class CreateUsersTable < ActiveRecord::Migration
	def up
		execute("CREATE TABLE `users` (
				`id` varchar(20) collate latin1_general_ci NOT NULL default '',
				`activate` date NOT NULL default '0000-00-00',
				`expire` date NOT NULL default '0000-00-00',
				`credit` double(10,2) NOT NULL default '0.00',
				`reduction` double(6,2) NOT NULL default '0.00',
				`registration` date default '0000-00-00',
				`password` blob NOT NULL,
				`uid` int(11) unsigned NOT NULL auto_increment,
				`gid` smallint(6) unsigned NOT NULL default '0',
				`disable` tinyint(1) unsigned NOT NULL default '0',
				`company_id` int(11) unsigned NOT NULL default '0',
				`bill_id` int(11) unsigned NOT NULL default '0',
				PRIMARY KEY  (`uid`),
				UNIQUE KEY `id` (`id`)
			) ENGINE=MyISAM AUTO_INCREMENT=24066 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;")
	end
	def down
		execute("DROP TABLE `users`;")
	end
end