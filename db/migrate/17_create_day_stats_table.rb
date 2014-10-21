class CreateDayStatsTable < ActiveRecord::Migration
	def up
		execute("CREATE TABLE `day_stats` (
			`uid` int(10) unsigned default NULL,
			`started` datetime default NULL,
			`day` tinyint(3) unsigned default NULL,
			`month` tinyint(3) unsigned default NULL,
			`year` smallint(5) unsigned default NULL,
			`c_acct_input_octets` int(10) unsigned default NULL,
			`c_acct_output_octets` int(10) unsigned default NULL,
			`c_acct_input_gigawords` smallint(5) unsigned default NULL,
			`c_acct_output_gigawords` smallint(5) unsigned default NULL,
			`s_acct_input_octets` int(10) unsigned default NULL,
			`s_acct_output_octets` int(10) unsigned default NULL,
			`s_acct_input_gigawords` smallint(5) unsigned default NULL,
			`s_acct_output_gigawords` smallint(5) unsigned default NULL,
			`acct_session_id` varchar(25) collate latin1_general_ci default NULL,
			`lupd` int(10) unsigned default NULL
		) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;")
	end
	def down
		execute("DROP TABLE `day_stats`;")
	end
end