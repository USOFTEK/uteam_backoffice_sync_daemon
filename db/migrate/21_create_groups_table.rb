class CreateGroupsTable < ActiveRecord::Migration
	def up
		execute("CREATE TABLE `groups` (
				`gid` smallint(4) unsigned NOT NULL default '0',
        `name` varchar(30) NOT NULL,
        `descr` varchar(200) NOT NULL,
				PRIMARY KEY(`gid`),
        UNIQUE KEY `gid` (`gid`),
				UNIQUE KEY `name` (`name`)
			) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;")
	end
	def down
		execute("DROP TABLE `groups`;")
	end
end