require "mysql2"
require "faker"
require "active_support/all"
require "date"
require "digest/md5"

ENV["numb"] ||= 1.to_s

def rundom_number n = 6
	number = Array.new
	n.times {
		number.push(rand(9))
	}
	number.join.to_i
end

# Make a users names
ENV["password"] ||= "my_temp_password"
# Add tariff
tariffs = [{name: "Basic 30 Mb/s", month_fee: 75.00, day_fee: 75.00 / 31 }, {name: "Advanced 40 Mb/s", month_fee: 85.00, day_fee: 85.00 / 31 }, {name: "Advanced 80 Mb/s", month_fee: 115.00, day_fee: 115.00 / 31 }]
puts "Creating tarif_plans"
max_id = DB.query("SELECT (MAX(`id`)+ 1) as `id` FROM `tarif_plans`").first["id"]
tariffs.each { |tariff|
	max_id ||= 0
	DB.query("INSERT INTO `tarif_plans`(`id`,`month_fee`, `name`,`day_fee`) 
													VALUES(#{max_id},'#{tariff[:month_fee]}','#{tariff[:name]}','#{tariff[:day_fee]}')")
	max_id += 1
}
# Users list
USERS = ["leo", "lesya", "ruslan", "gena"]
ENV["numb"].to_i.times { |i|
	# Creating a user
	USERS.each { |username|
		username += "-#{i}"
		puts "Creating a user: #{username}"
		user_created_at = (Date.today - rand(3).month).to_s
		DB.query("INSERT INTO `users`(`id`,`credit`,`registration`,`password`,`disable`) 
														VALUES('#{username}','#{Faker::Commerce.price}','#{user_created_at}',
															'#{ENV["password"]}','#{[1,0].sample}')")
		user_id = DB.last_id
		# Create billing for user
		puts "Creating bills"
		DB.query("INSERT INTO `bills`(`deposit`, `uid`, `registration`) 
														VALUES('#{Faker::Commerce.price}', #{user_id}, '#{user_created_at}')")
		billing_id = DB.last_id
		# Add to user
		DB.query("UPDATE `users` SET `bill_id`=#{billing_id} WHERE `uid`=#{user_id}")
		# Add user data
		puts "Creating users_pi"
		DB.query("INSERT INTO `users_pi`(`uid`,`fio`,`phone`,`email`,`address_street`,`address_build`,
																			`address_flat`,`comments`,`contract_id`) 
													VALUES(#{user_id}, \"#{Faker::Name.name}\",
																	'#{Faker::PhoneNumber.cell_phone.gsub(/[^\d]+/,"")}',
																	'#{Faker::Internet.free_email(username)}',\"#{Faker::Address.street_name}\",
																	'#{Faker::Address.building_number}', '#{Faker::Address.building_number}',
																	'','#{Faker::Number.number(8)}'
													)")
		# Add user sms phone
		puts "Creating users_sms"
		DB.query("INSERT INTO `users_sms` SET `uid`=#{user_id}, `sms_phone`='#{Faker::PhoneNumber.cell_phone}'")

		# User tariff
		tariff = DB.query("SELECT * FROM `tarif_plans` WHERE `id` >= (SELECT FLOOR(MAX(`id`) * RAND()) FROM `tarif_plans`) ORDER BY `id` LIMIT 1").first
		# Add user network info
		puts "Creating user dv_main"
		DB.query("INSERT INTO `dv_main`(`uid`,`tp_id`,`registration`,`ip`,`speed`,`netmask`,`password`) 
														VALUES(#{user_id},#{tariff["id"]}, '#{user_created_at}', '#{Faker::Internet.ip_v4_address}', #{tariff["name"].match(/(\d+.*)/[1].to_i},INET_ATON('255.255.255.#{rand(255)}'),'#{ENV["password"]}')")
		# Add user fees
		puts "Creating user fees"
		rand(1..5).times { DB.query("INSERT INTO `fees` SET `date`='#{Faker::Date.between(Date.parse(user_created_at), Time.now).to_time.to_s.gsub(/( \+\.*)$/i, "")}', `sum`=#{Faker::Commerce.price}, `dsc`=\"#{Faker::Lorem.sentence}\", `ip`=INET_ATON('#{Faker::Internet.ip_v4_address}'), `last_deposit`='#{Faker::Commerce.price}', `uid`=#{user_id}, `aid`=1, `bill_id`=#{billing_id}") }
		# Add user payments
		puts "Creating user payments"
		rand(1..10).times { DB.query("INSERT INTO `payments` SET `date`='#{Faker::Date.between(Date.parse(user_created_at), Time.now).to_time.to_s.gsub(/( \+\.*)$/i, "")}', `sum`=#{Faker::Commerce.price}, `dsc`=\"#{Faker::Lorem.sentence}\", `ip`=INET_ATON('#{Faker::Internet.ip_v4_address}'), `last_deposit`='#{Faker::Commerce.price}', `uid`=#{user_id}, `aid`=6, `bill_id`=#{billing_id}") }
		# Add user days statistics
		# Build stats from rand day
		puts "Creating user net statistic"
		start = Date.parse(user_created_at)
		while start < Time.now
			DB.query("INSERT INTO `day_stats` SET `uid`=#{user_id}, `started`='#{start.strftime("%Y-%m-%d %H:%M:%S")}', `day`='#{start.strftime("%d")}', `month`='#{start.strftime("%m")}', `year`='#{start.strftime("%Y")}', `c_acct_input_octets`=#{rundom_number(rand(3))}, `c_acct_output_octets`=#{rundom_number(rand(3))}, `c_acct_input_gigawords`=#{rundom_number(rand(3))}, `c_acct_output_gigawords`=#{rundom_number(rand(3))}, `s_acct_input_octets`=#{rundom_number(rand(3))}, `s_acct_output_octets`=#{rundom_number(rand(3))}, `s_acct_input_gigawords`=#{rundom_number(rand(3))}, `s_acct_output_gigawords`=#{rundom_number(rand(3))}, `lupd`=#{rundom_number(rand(6))}")
			start += 1.day
		end	
	}
}
# # Add abon tariffs
# abon_tariffs = Array.new
# puts "Creating abon tariffs"
# DB.query("SELECT GROUP_CONCAT(`name` SEPARATOR '||') as `names`, GROUP_CONCAT(`id` SEPARATOR ',') as `ids` FROM `abon_tariffs`").each { |q|
# 	uniq_name = q["names"].split("||") rescue Array.new
# 	ids = q["ids"].split(",") rescue Array.new
# 	ENV["abon_tariffs"] ||= "10"
# 	abon_tariffs += ids
# 	ENV["abon_tariffs"].to_i.times { |i|
# 		name = "#{Faker::Lorem.word}_#{Digest::MD5.hexdigest(rand.to_s)}_#{i}"
# 		name = "#{Faker::Lorem.word}_#{Digest::MD5.hexdigest(rand.to_s)}_#{i}" while uniq_name.include?(name)
# 		DB.query("INSERT INTO `abon_tariffs` SET `name`='#{name}', `period`='#{(rand(98) + 1).to_s}', `price`='#{Faker::Commerce.price}', `payment_type`=0")
# 		abon_tariffs.push(DB.last_id)
# 	}
# }
# abon_tariffs.compact!
# # Add user tariffs
# puts "Creating user abon tarif"
# DB.query("INSERT INTO `abon_user_list` SET `uid`=#{USER_ID}, `tp_id`=#{abon_tariffs.sample}, `date`='#{(Date.today - rand(10).days).to_s}'")