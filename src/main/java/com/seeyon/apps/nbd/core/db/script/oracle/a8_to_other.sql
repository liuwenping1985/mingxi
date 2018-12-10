CREATE TABLE `a8_to_other` (
  `id` NUMBER NOT NULL,
  `name` VARCHAR2(255) DEFAULT NULL,
  `create_time` DATE DEFAULT NULL,
  `update_time` DATE DEFAULT NULL,
  `status` NUMBER(19,4) DEFAULT '0',
  `data` longtext DEFAULT NULL,
  `source_id` NUMBER DEFAULT NULL,
  PRIMARY KEY (`id`)
)

