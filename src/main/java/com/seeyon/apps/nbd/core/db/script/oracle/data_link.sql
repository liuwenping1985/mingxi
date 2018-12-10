CREATE TABLE "data_link" (
  "id" NUMBER(20,0) NOT NULL,
  `name` VARCHAR2(255) DEFAULT NULL,
  `create_time` DATE DEFAULT NULL,
  `update_time` DATE DEFAULT NULL,
  `data_base_name` varchar2(255) DEFAULT NULL,
  "host" varchar2(255) DEFAULT NULL,
  "status" NUMBER(4,0) DEFAULT '0',
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

