class CreateBillsTable < ActiveRecord::Migration
	def up
		execute("CREATE TABLE `bills` (
				`id` int(11) unsigned NOT NULL auto_increment,
				`deposit` double(15,6) NOT NULL default '0.000000',
				`uid` int(11) unsigned NOT NULL default '0',
				`company_id` int(11) unsigned NOT NULL default '0',
				`registration` date NOT NULL default '0000-00-00',
				PRIMARY KEY(`id`),
				UNIQUE KEY `id` (`id`),
				UNIQUE KEY `uid` (`uid`, `company_id`)
			) ENGINE=MyISAM AUTO_INCREMENT=24335  DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;")
	end
	def down
		execute("DROP TABLE `bills`;")
	end
end