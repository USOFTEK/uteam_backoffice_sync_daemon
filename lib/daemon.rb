require_relative "daemon_options"
require "date"

module Daemon
  extend DaemonOptions

  def self.archive_db db_name = nil
    current_db = db_name == "test_dump" ? "current_db_test" : DUMP_CURRENT_DB_NAME
    sql_pass = ""
    sql_pass = " -p#{SQL_PASS}" unless SQL_PASS.strip.empty?
    system "mysqldump -u#{SQL_USER}#{sql_pass} #{current_db} > dumps/#{db_name || Time.now.to_i}.sql"
  end

  def self.current_conn
    @current_conn
  end

  # Sync data from tracker
  def self.sync_from_tracker
    connect_to_dbs unless @current_conn
    # Sync user model
    sync_update_users

  end

  # Sync data to tracker
  def self.sync_to_tracker
    puts "Connecting to dbs\n"
    connect_to_dbs unless @current_conn
    puts "Connected to dbs\n"

    clean_up "abon_tariffs", "id", Abonement
    sync_abon_tariffs
    clean_up "tarif_plans", "id", Tariff
    sync_tariffs
    clean_up "groups", "gid", Group
    sync_groups
    clean_up "users", "uid", User
    sync_users
    # Sync bonuses
    sync_bonuses
  end

  # Dynamically sync user fees and payments

  ["Payment", "Fee"].each do |klass|
    name = klass.downcase.pluralize
    define_singleton_method "sync_#{name}".to_sym do |user, result|
      q = "SELECT *, INET_NTOA(`ip`) as `ip`
                        FROM `#{name}`
                        WHERE `uid`='#{user.id}' AND `bill_id`='#{result["bill_id"]}'"
      @current_conn.query(q).each do |result|
        model = self.const_get(klass)
        item = model.where(billing_id: result["bill_id"], remote_id: result["id"]).first_or_create
        item.with_lock do
          item.created_at = result["date"] #DateTime.strptime(result["date"], "%Y-%m-%d %H:%M:%S").to_time
          item.amount = result["sum"]
          item.deposit = result["last_deposit"]
          item.description = result["dsc"]
          item.ip = result["ip"]
          save_with_log item, item.remote_id
        end
      end
    end
  end

  private

  def self.clean_up table, field, klass
    puts "Cleaning up #{table}"
    query = @current_conn.query("SELECT GROUP_CONCAT(`#{field}` SEPARATOR ',') AS `records` FROM `#{table}`")
    return true unless query.first["records"]
    ids = query.first["records"].split(",")
    klass.where.not(id: ids).each(&:delete)
  end


  # Sync actions

  # Sync tariffs
  def self.sync_tariffs
    query = @current_conn.query("
      SELECT `id`, `name`, `month_fee`, `day_fee`
      FROM `tarif_plans`")
    query.each do |res|
      tariff = Tariff.where(remote_id: res.delete("id")).first_or_create
      tariff.with_lock do
        res.each { |k, v| tariff.method("#{k}=".to_sym).call(v) }
        save_with_log tariff, tariff.id
      end
    end
  end

  # Sync tariffs
  def self.sync_groups
    query = @current_conn.query("
      SELECT `gid`, `name`, `descr`
      FROM `groups`")
    query.each do |res|
      group = Group.where(id: res.delete("gid")).first_or_create
      group.with_lock do
        res.each do |k, v|
          k = "description" if k == "descr"
          group.method("#{k}=".to_sym).call(v)
        end
        save_with_log group, group.id
      end
    end
  end

  # Sync abon tariffs
  def self.sync_abon_tariffs
    query = @current_conn.query("
      SELECT `id`, `name`, `period`, `price`, `payment_type`
      FROM `abon_tariffs`")
    query.each do |res|
      abon = Abonement.where(id: res.delete("id")).first_or_create
      abon.with_lock do
        res.each do |k, v|
          k = "cost" if k == "price"
          #v = !!v if k == "payment_type"
          abon.method("#{k}=".to_sym).call(v)
        end
        save_with_log abon, abon.id
      end
    end
  end

  # Sync user billing data
  def self.sync_billing user, res
    # Build user billing
    billing = Billing.where(id: res["bill_id"], user: user).first_or_create
    billing.with_lock {
      billing.deposit = res["deposit"]
      billing.remote_id = res["bill_id"]
      billing.created_at = DateTime.strptime(res["registration"], "%Y-%m-%d").to_time rescue Time.now
      save_with_log billing, res["bill_id"]
    }
  end

  # Sync user bonuses (with friends)
  def self.sync_bonuses
    @current_conn.query("SELECT * FROM `p_resseler`").each { |rec|
      # Skip if user doesn't exists
      next unless User.exists?(rec["uid"])
      user = User.find(rec["uid"])
      user.update_attributes(bonus_percent: rec["percent"])
      friends = @current_conn.query("SELECT * FROM `p_ress_users` WHERE `rid`=#{rec["rid"]}")
      friends.each { |friend|
        next unless User.exists?(friend["uid"])
        # Add friend to user if not exists
        user.teams.find_or_create_by(friend_id: friend["uid"]) unless user.friends.exists?(friend["uid"])
        user_friend = User.find(friend["uid"])
        bonus_pays = @current_conn.query("SELECT * FROM `p_ress_pays` WHERE `uid`=#{user_friend.id} AND `rid`=#{rec["rid"]}")
        bonus_pays.each { |pay|
          bonus_pay = BonusPay.find_or_create_by(user_id: user_friend.id, day: Date.new(pay["year"].to_i, pay["month"].to_i, pay["day"].to_i))
          bonus_pay.update_attributes(amount: pay["sum"], paid: !pay["status"].zero?)
        }
      }
    }
  end


  # Sync user network statistic data
  def self.sync_day_stats user, res
    query = @current_conn.query("SELECT *, SUM(`c_acct_input_gigawords` * 4294967296 + `c_acct_input_octets`) as sent, 
                                      SUM( `c_acct_output_gigawords` * 4294967296 + `c_acct_output_octets`  ) as received 
                                      FROM `day_stats` WHERE `uid`=#{user.id} GROUP BY year,month,day")
    query.each { |stat|
      record = NetworkActivity.where(user_id: user.id, per: Date.parse("#{stat["year"]}-#{stat["month"]}-#{stat["day"]}").to_time).first_or_create
      record.sent = stat["sent"]
      record.received = stat["received"]
      record.save! if record.valid?
    }
  end
  
  # Sync abon_users_list
  def self.sync_abon_users_list user, res
    query = @current_conn.query("SELECT * FROM `abon_user_list` WHERE `uid`=#{user.id}")
    query.each do |au|
      date = au["date"] ? { created_at: au["date"] } : {}
      new_au = AbonementUser.new({user_id: user.id, abonement_id: au["tp_id"]}.merge(date))
      new_au.save
    end

  end


  # Sync users
  def self.sync_users offset = 0, limit = nil
    limit ||= USERS_LIMIT_PER_TRANSACTION
    query = @current_conn.query("
      SELECT u.*, u.id as user_name, upi.*, dvm.*, dvm.registration as dv_reg,
              `bills`.*, `bills`.`registration` as `bill_reg`, `bills`.id as bill_id,
      INET_NTOA(dvm.ip) as `ip`, INET_NTOA(dvm.netmask) as `netmask`
      FROM `users` u
      LEFT JOIN `users_pi` upi ON (u.uid=upi.uid)
      LEFT JOIN `dv_main` dvm ON (u.uid=dvm.uid)
      LEFT JOIN `bills` ON (u.uid=bills.uid)
      LEFT JOIN `users_sms` usms ON (u.uid=usms.uid)
      LIMIT #{offset},#{limit}")
    query.each do |res|
      user = User.where(id: res["uid"]).first_or_create
      puts "Syncing user #{res["uid"]}"
      user.with_lock do
        user.created_at = DateTime.strptime(res["registration"], "%Y-%m-%d").to_time rescue Time.now
        user.tariff = Tariff.where(remote_id: res["tp_id"].to_i).first_or_create
        user.group = Group.where(id: res["gid"].to_i).first_or_create

        user.username = res["user_name"]
        user.registration = res["dv_reg"]
        user.initials = res["fio"]
        user.password = res["password"] if user.new_record?
        user.primary_phone = Phone.find_or_create_by(user_id: user.id, number: res["phone"].to_s)
        user.primary_phone.update_attributes(is_main: true)
        user.primary_phone.update_attributes(is_mobile: false) if res["phone"].to_s.scan(/^+?3?8(050|066|068|095|099|096|093|063|067)/i).empty?
        user.mobile_phone = Phone.find_or_create_by(user_id: user.id, number: res["sms_phone"])
        user.mobile_phone.update_attributes(is_mobile: true)
        user.disable = !res["disable"].to_i.zero?
        %w(email disable ip speed netmask address_street address_build address_flat).each do |f|
          user.method("#{f}=".to_sym).call(res[f])
        end
        %w(billing payments fees day_stats abon_users_list).each { |table| self.method("sync_#{table}".to_sym).call(user, res) }

        save_with_log user, res["uid"]
      end
    end
    offset += 1
    sync_users offset, limit unless query.count == 0
  end

  def self.count what="users", &blk
    @current_conn.query("SELECT COUNT(*) AS c FROM #{what}") do |res|
      blk.call(res.first["c"])
    end
  end

  def self.save_with_log inst, id
    begin
      inst.save! #! if user.valid?
    rescue ActiveRecord::RecordInvalid
      puts "ERROR saving #{inst.to_s} #{id}: #{inst.errors.full_messages.join("; ")}"
    end
  end

  # Sync users from tracker
  def self.sync_update_users
    User.all.each { |user|
      user.with_lock {
        # Skip if user has no updates
        next if user.previous_version.nil?
        sync_user_profile(user) unless Activity.where(object: user.class.name.to_s.downcase, prev: user.previous_version.version.index).exists?
      }
    }
  end

  def self.sync_user_profile object
    # TODO: confirm method to save phone in users_pi
    phone = ""
    # phone = ",upi.`phone`='#{object.primary_phone.gsub(/[^\d]+/, "").to_i}'" unless object.primary_phone.nil?
    mobile = ""
    mobile = ",usms.`sms_phone`='#{object.mobile_phone.number}'" if object.mobile_phone
    current_conn.query("UPDATE `users` u 
                          LEFT JOIN `users_pi` upi ON (u.`uid`=upi.`uid`) 
                          LEFT JOIN `users_sms` usms ON (u.`uid`=usms.`uid`) 
                              SET upi.`fio`=\"#{object.initials}\",upi.`address_street`=\"#{object.address_street}\",
                              upi.`address_build`=\"#{object.address_build}\",upi.`address_flat`=\"#{object.address_flat}\",
                              upi.`email`=\"#{object.email}\",u.`disable`='#{object.disabled? ? 1 : 0}'#{phone}#{mobile}"
                      )
    Activity.find_or_create_by(object: object.class.name.to_s.downcase, prev: object.previous_version.version.index)
  end

end