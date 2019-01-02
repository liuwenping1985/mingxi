CREATE TABLE `a8_to_other_config_entity` (
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
  `ext_string1` varchar(255) DEFAULT NULL,
  `ext_string2` varchar(255) DEFAULT NULL,
  `ext_string3` varchar(255) DEFAULT NULL,
  `ext_string4` varchar(255) DEFAULT NULL,
  `ext_string5` varchar(255) DEFAULT NULL,
  `ext_string6` varchar(255) DEFAULT NULL,
  `ext_string7` varchar(255) DEFAULT NULL,
  `ext_string8` varchar(255) DEFAULT NULL,
  `ftd_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

