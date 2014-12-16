class CreatePResselerTable < ActiveRecord::Migration
	def up
		execute("CREATE TABLE `p_resseler` (
		  `rid` bigint(20) NOT NULL auto_increment,
		  `uid` int(11) unsigned NOT NULL,
		  `name` varchar(255) collate latin1_general_ci default NULL,
		  `contact` varchar(255) collate latin1_general_ci default NULL,
		  `address` varchar(255) collate latin1_general_ci default NULL,
		  `percent` float default NULL,
		  `notes` varchar(255) collate latin1_general_ci default NULL,
		  UNIQUE KEY `rid` (`rid`)
		) ENGINE=MyISAM AUTO_INCREMENT=1294 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;")
	end
	def down
		execute("DROP TABLE `p_resseler`;")
	end
end