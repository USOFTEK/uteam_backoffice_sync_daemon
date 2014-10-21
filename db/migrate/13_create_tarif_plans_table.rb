class CreateTarifPlansTable < ActiveRecord::Migration
	def up
		execute("CREATE TABLE `tarif_plans` (
			`id` smallint(5) unsigned NOT NULL default '0',
			`hourp` double(15,5) unsigned NOT NULL default '0.00000',
			`month_fee` double(14,2) unsigned NOT NULL default '0.00',
			`uplimit` double(14,2) NOT NULL default '0.00',
			`name` varchar(40) collate latin1_general_ci NOT NULL default '',
			`day_fee` double(14,2) unsigned NOT NULL default '0.00',
			`reduction_fee` tinyint(1) unsigned NOT NULL default '0',
			`postpaid_fee` tinyint(1) unsigned NOT NULL default '0',
			`logins` tinyint(4) NOT NULL default '0',
			`day_time_limit` int(10) unsigned NOT NULL default '0',
			`week_time_limit` int(10) unsigned NOT NULL default '0',
			`month_time_limit` int(10) unsigned NOT NULL default '0',
			`day_traf_limit` int(10) unsigned NOT NULL default '0',
			`week_traf_limit` int(10) unsigned NOT NULL default '0',
			`month_traf_limit` int(10) unsigned NOT NULL default '0',
			`prepaid_trafic` int(10) unsigned NOT NULL default '0',
			`change_price` double(14,2) unsigned NOT NULL default '0.00',
			`activate_price` double(14,2) unsigned NOT NULL default '0.00',
			`credit_tresshold` double(8,2) unsigned NOT NULL default '0.00',
			`age` smallint(6) unsigned NOT NULL default '0',
			`octets_direction` tinyint(2) unsigned NOT NULL default '0',
			`max_session_duration` smallint(6) unsigned NOT NULL default '0',
			`filter_id` varchar(15) collate latin1_general_ci NOT NULL default '',
			`payment_type` tinyint(1) NOT NULL default '0',
			`min_session_cost` double(14,5) unsigned NOT NULL default '0.00000',
			`rad_pairs` text collate latin1_general_ci NOT NULL,
			PRIMARY KEY  (`id`),
			UNIQUE KEY `name` (`name`),
			UNIQUE KEY `id` (`id`)
		) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;")
	end
	def down
		execute("DROP TABLE `tarif_plans`;")
	end
end