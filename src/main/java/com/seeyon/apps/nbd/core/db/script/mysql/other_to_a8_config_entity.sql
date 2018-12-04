CREATE TABLE `other_to_a8_config_entity` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `status` smallint(6) DEFAULT '0',
  `affair_type` varchar(255) DEFAULT NULL,
  `trigger_type` varchar(512) DEFAULT NULL,
  `export_type` varchar(255) DEFAULT NULL,
  `export_url` varchar(255) DEFAULT NULL,
  `link_id` varchar(255) DEFAULT NULL,
  `ftd_id` bigint(20) DEFAULT NULL,
  `table_name` varchar(255) DEFAULT NULL,
  `period` varchar(255) DEFAULT NULL,
  `trigger_process` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

