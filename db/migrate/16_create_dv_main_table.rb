class CreateDvMainTable < ActiveRecord::Migration
	def up
		execute("CREATE TABLE `dv_main` (
				`uid` int(11) unsigned NOT NULL auto_increment,
				`tp_id` smallint(5) unsigned NOT NULL default '0',
				`logins` tinyint(3) unsigned NOT NULL default '0',
				`registration` date default '0000-00-00',
				`ip` int(10) unsigned NOT NULL default '0',
				`filter_id` varchar(15) collate latin1_general_ci NOT NULL default '',
				`speed` int(10) unsigned NOT NULL default '0',
				`netmask` int(10) unsigned NOT NULL default '4294967294',
				`cid` varchar(35) collate latin1_general_ci NOT NULL default '',
				`password` blob NOT NULL,
				`disable` tinyint(1) unsigned NOT NULL default '0',
				`callback` tinyint(1) unsigned NOT NULL default '0',
				`port` int(11) unsigned NOT NULL default '0',
				PRIMARY KEY  (`uid`),
				KEY `tp_id` (`tp_id`)
			) ENGINE=MyISAM AUTO_INCREMENT=24066 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;")
	end
	def down
		execute("DROP TABLE `dv_main`;")
	end
end