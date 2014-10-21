class CreateAbonTariffsTable < ActiveRecord::Migration
	def up
		execute("CREATE TABLE `abon_tariffs` (
				`id` smallint(6) unsigned NOT NULL auto_increment,
				`name` varchar(20) collate latin1_general_ci NOT NULL default '',
				`period` tinyint(2) unsigned NOT NULL default '0',
				`price` double(14,2) unsigned NOT NULL default '0.00',
				`payment_type` tinyint(1) unsigned NOT NULL default '0',
				PRIMARY KEY  (`id`),
				UNIQUE KEY `id` (`id`),
				UNIQUE KEY `name` (`name`)
			) ENGINE=MyISAM AUTO_INCREMENT=24 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci COMMENT='Abon tariffs';")
	end
	def down
		execute("DROP TABLE `abon_tariffs`;")
	end
end