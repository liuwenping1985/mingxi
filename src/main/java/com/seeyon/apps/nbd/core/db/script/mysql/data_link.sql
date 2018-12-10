CREATE TABLE `data_link` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `data_base_name` varchar(255) DEFAULT NULL,
  `host` varchar(255) DEFAULT NULL,
  `status` smallint(6) DEFAULT '0',
  `user` varchar(255) DEFAULT NULL,
  `password` varchar(512) DEFAULT NULL,
  `port` varchar(255) DEFAULT NULL,
  `ext_string1` varchar(255) DEFAULT NULL,
  `ext_string2` varchar(255) DEFAULT NULL,
  `ext_string3` varchar(255) DEFAULT NULL,
  `ext_string4` varchar(255) DEFAULT NULL,
  `ext_string5` varchar(255) DEFAULT NULL,
  `link_type` varchar(255) DEFAULT NULL,
  `db_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

