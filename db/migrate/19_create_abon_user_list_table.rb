class CreateAbonUserListTable < ActiveRecord::Migration
	def up
		execute("CREATE TABLE `abon_user_list` (
				`uid` int(11) unsigned NOT NULL default '0',
				`tp_id` smallint(6) unsigned NOT NULL default '0',
				`date` date NOT NULL default '0000-00-00'
			) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci COMMENT='Abon user list';")
	end
	def down
		execute("DROP TABLE `abon_user_list`;")
	end
end