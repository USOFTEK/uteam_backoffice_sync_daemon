class CreatePResselerUsersTable < ActiveRecord::Migration
	def up
		execute("CREATE TABLE `p_ress_users` (
		  `rid` bigint(20) default NULL,
		  `uid` int(11) default NULL,
		  `status` int(11) default NULL,
		  `notes` varchar(255) collate latin1_general_ci default NULL
		) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;")
	end
	def down
		execute("DROP TABLE `p_ress_users`;")
	end
end