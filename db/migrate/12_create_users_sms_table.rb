class CreateUsersSmsTable < ActiveRecord::Migration
	def up
		execute("CREATE TABLE `users_sms` (
			`uid` bigint(20) default NULL,
			`sms_phone` varchar(50) collate latin1_general_ci default NULL,
			UNIQUE KEY `uid` (`uid`)
		) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;")
	end
	def down
		execute("DROP TABLE `users_sms`;")
	end
end