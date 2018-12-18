CREATE TABLE `zrzx_user_schedule` (
`id` bigint(20) NOT NULL,
`name` varchar(255) DEFAULT NULL,
`user_name` varchar(255) DEFAULT NULL,
`user_id` bigint(20) DEFAULT NULL,
`location` varchar(512) DEFAULT NULL,
`reason` varchar(512) DEFAULT NULL,
`ext_string1` varchar(512) DEFAULT NULL,
`ext_string2` varchar(512) DEFAULT NULL,
`ext_string3` varchar(512) DEFAULT NULL,
`start_date` datetime DEFAULT NULL,
`end_date` datetime DEFAULT NULL,
`create_time` datetime DEFAULT NULL,
`update_time` datetime DEFAULT NULL,
`status` smallint(6) DEFAULT '0',
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

