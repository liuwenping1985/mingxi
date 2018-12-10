CREATE TABLE `log_entry` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `status` smallint(6) DEFAULT '0',
  `msg` varchar(1024) DEFAULT NULL,
  `level` varchar(255) DEFAULT NULL,
  `success` smallint(6) DEFAULT '0',
  `data` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;