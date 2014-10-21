class CreateFeesTable < ActiveRecord::Migration
	def up
		execute("CREATE TABLE `fees` (
			`date` datetime NOT NULL default '0000-00-00 00:00:00',
			`sum` double(12,2) NOT NULL default '0.00',
			`dsc` varchar(80) collate latin1_general_ci NOT NULL default '',
			`ip` int(11) unsigned NOT NULL default '0',
			`last_deposit` double(15,6) NOT NULL default '0.000000',
			`uid` int(11) unsigned NOT NULL default '0',
			`aid` smallint(6) unsigned NOT NULL default '0',
			`id` int(11) unsigned NOT NULL auto_increment,
			`bill_id` int(11) unsigned NOT NULL default '0',
			`vat` double(5,2) unsigned NOT NULL default '0.00',
			PRIMARY KEY  (`id`),
			UNIQUE KEY `id` (`id`),
			KEY `date` (`date`),
			KEY `uid` (`uid`)
		) ENGINE=MyISAM AUTO_INCREMENT=643456 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;")
	end
	def down
		execute("DROP TABLE `fees`;")
	end
end