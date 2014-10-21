require "mysql2"
require "faker"
require "active_support/all"
require "date"
require "digest/md5"
# Insert user
puts "Creating a user"
user_created_at = Faker::Date.between(rand(366).days.ago, Date.today)
DB.query("INSERT INTO `users` SET `id`='#{Faker::Internet.user_name}', `credit`='#{Faker::Commerce.price}', `registration`=CURDATE() - INTERVAL 1 MONTH, `password`='#{Faker::Internet.password}', `disable`=#{[0,1].sample}")
# Retrieve last inserted user id
USER_ID = DB.last_id
# Create billing for user
puts "Creatings a billing"
DB.query("INSERT INTO `bills` SET `deposit`='#{Faker::Commerce.price}', `uid`=#{USER_ID}, `registration`=CURDATE() - INTERVAL 1 MONTH")
BILLING_ID = DB.last_id
# Add to user
DB.query("UPDATE `users` SET `bill_id`=#{BILLING_ID}")
# Add user data
puts "Creating user pi"
DB.query("INSERT INTO `users_pi`(`uid`,`fio`,`phone`,`email`,`address_street`,`address_build`,`address_flat`,`comments`,`contract_id`) VALUES(#{USER_ID}, '#{Faker::Name.name}', '#{Faker::PhoneNumber.cell_phone.gsub(/[^\d]+/,"")}', '#{Faker::Internet.email}', '#{Faker::Address.street_name}', '#{Faker::Address.building_number}', '#{Faker::Address.building_number}', '', '#{Faker::Number.number(8)}')")
# Add user sms phone
puts "Creating users sms"
DB.query("INSERT INTO `users_sms` SET `uid`=#{USER_ID}, `sms_phone`='#{Faker::PhoneNumber.cell_phone}'")
# Add tariff
puts "Creating tarif plans"
DB.query("SELECT (MAX(`id`)+ 1) as `id`, GROUP_CONCAT(DISTINCT `name` SEPARATOR '||') as `names` FROM `tarif_plans`").each do |q|
	uniq_name = q["names"].split("||") rescue Array.new
	q["id"] ||= 0
	name = Faker::Internet.user_name
	name = Faker::Internet.user_name while uniq_name.include?(name)
	DB.query("INSERT INTO `tarif_plans`(`id`,`hourp`,`month_fee`,`uplimit`,`name`,`day_fee`) VALUES(#{q["id"]}, '#{Faker::Commerce.price}', '#{Faker::Commerce.price}', '#{Faker::Commerce.price}', '#{name}', '#{Faker::Commerce.price}')")
end
USER_TARIFF_ID = DB.last_id
# Add user network info
puts "Creating user dv main"
DB.query("INSERT INTO `dv_main` SET `uid`=#{USER_ID}, `tp_id`=#{USER_TARIFF_ID}, `registration`=CURDATE(), `ip`=INET_ATON('#{Faker::Internet.ip_v4_address}'), `speed`=#{rand(120)}, `netmask`=INET_ATON('255.255.255.#{rand(255)}'), `password`='#{Faker::Internet.password}'")
# Add user fees
puts "Creating user fees"
rand(1..10).times { DB.query("INSERT INTO `fees` SET `date`='#{(Time.now - rand(99).days).strftime("%Y-%m-%d %H:%M:%S")}', `sum`=#{Faker::Commerce.price}, `dsc`='#{Faker::Lorem.sentence}', `ip`=INET_ATON('#{Faker::Internet.ip_v4_address}'), `last_deposit`='#{Faker::Commerce.price}', `uid`=#{USER_ID}, `aid`=1, `bill_id`=#{BILLING_ID}") }
# Add user payments
puts "Creating user payments"
rand(1..5).times { DB.query("INSERT INTO `payments` SET `date`='#{(Time.now - rand(99).days).strftime("%Y-%m-%d %H:%M:%S")}', `sum`=#{Faker::Commerce.price}, `dsc`='#{Faker::Lorem.sentence}', `ip`=INET_ATON('#{Faker::Internet.ip_v4_address}'), `last_deposit`='#{Faker::Commerce.price}', `uid`=#{USER_ID}, `aid`=6, `bill_id`=#{BILLING_ID}") }
# Add user days statistics
puts "Creating user net statistic"
# Build stats from rand day
start = Time.now - rand(90).days
while start < Time.now
	DB.query("INSERT INTO `day_stats` SET `uid`=#{USER_ID}, `started`='#{start.strftime("%Y-%m-%d %H:%M:%S")}', `day`='#{start.strftime("%d")}', `month`='#{start.strftime("%m")}', `year`='#{start.strftime("%Y")}', `c_acct_input_octets`=#{(1..8).to_a.map { |e| rand(9)}.join.to_i}, `c_acct_output_octets`=#{(1..8).to_a.map { |e| rand(9)}.join.to_i}, `c_acct_input_gigawords`=0, `c_acct_output_gigawords`=0, `s_acct_input_octets`=#{(1..8).to_a.map { |e| rand(9)}.join.to_i}, `s_acct_output_octets`=#{(1..8).to_a.map { |e| rand(9)}.join.to_i}, `s_acct_input_gigawords`=0, `s_acct_output_gigawords`=0, `lupd`=#{(1..10).to_a.map { |e| rand(9)}.join.to_i}")
	start += 1.day
end
# Add abon tariffs
abon_tariffs = Array.new
puts "Creating abon tariffs"
DB.query("SELECT GROUP_CONCAT(`name` SEPARATOR '||') as `names`, GROUP_CONCAT(`id` SEPARATOR ',') as `ids` FROM `abon_tariffs`").each { |q|
	uniq_name = q["names"].split("||") rescue Array.new
	ids = q["ids"].split(",") rescue Array.new
	ENV["abon_tariffs"] ||= "10"
	abon_tariffs += ids
	ENV["abon_tariffs"].to_i.times { |i|
		name = "#{Faker::Lorem.word}_#{Digest::MD5.hexdigest(rand.to_s)}_#{i}"
		name = "#{Faker::Lorem.word}_#{Digest::MD5.hexdigest(rand.to_s)}_#{i}" while uniq_name.include?(name)
		DB.query("INSERT INTO `abon_tariffs` SET `name`='#{name}', `period`='#{(rand(98) + 1).to_s}', `price`='#{Faker::Commerce.price}', `payment_type`=0")
		abon_tariffs.push(DB.last_id)
	}
}
abon_tariffs.compact!
# Add user tariffs
puts "Creating user abon tarif"
DB.query("INSERT INTO `abon_user_list` SET `uid`=#{USER_ID}, `tp_id`=#{abon_tariffs.sample}, `date`='#{(Date.today - rand(10).days).to_s}'")