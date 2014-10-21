class CreateUsersPiTable < ActiveRecord::Migration
	def up
		execute("CREATE TABLE `users_pi` (
				`uid` int(11) unsigned NOT NULL auto_increment,
				`fio` varchar(40) collate latin1_general_ci NOT NULL default '',
				`phone` bigint(16) unsigned NOT NULL default '0',
				`email` varchar(35) collate latin1_general_ci NOT NULL default '',
				`address_street` varchar(100) collate latin1_general_ci NOT NULL default '',
				`address_build` varchar(10) collate latin1_general_ci NOT NULL default '',
				`address_flat` varchar(10) collate latin1_general_ci NOT NULL default '',
				`comments` text collate latin1_general_ci NOT NULL,
				`contract_id` varchar(10) collate latin1_general_ci NOT NULL default '',
				PRIMARY KEY  (`uid`)
			) ENGINE=MyISAM AUTO_INCREMENT=24042 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;")
	end
	def down
		execute("DROP TABLE `users_pi`;")
	end
end