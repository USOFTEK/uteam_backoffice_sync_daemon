class CreatePResselerPaysTable < ActiveRecord::Migration
	def up
		execute("CREATE TABLE `p_ress_pays` (
		  `rid` bigint(20) default NULL,
		  `uid` int(11) default NULL,
		  `year` int(11) default NULL,
		  `month` int(11) default NULL,
		  `day` int(11) default NULL,
		  `sum` float default NULL,
		  `status` int(11) default NULL
		) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;")
	end
	def down
		execute("DROP TABLE `p_ress_pays`;")
	end
end