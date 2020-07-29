CREATE TABLE `duban_score_record` (
`id` bigint(20) NOT NULL,
`task_id` varchar(255) DEFAULT NULL,
`score` varchar(255) DEFAULT NULL,
`kg_score` varchar(255) DEFAULT NULL,
`zg_score` varchar(255) DEFAULT NULL,
`member_id` bigint(20) DEFAULT NULL,
`summary_id` bigint(20) DEFAULT NULL,
`ext_val` varchar(255) DEFAULT NULL,
`department_id` bigint(20) DEFAULT NULL,
`weight` varchar(255) DEFAULT NULL,
`create_date` datetime DEFAULT NULL,
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;