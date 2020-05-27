

-- ----------------------------
-- Table structure for duban_task_config
-- ----------------------------
DROP TABLE IF EXISTS `duban_task_config`;
CREATE TABLE `duban_task_config` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `enum_id` bigint(20) DEFAULT NULL,
  `item_value` varchar(255) DEFAULT NULL,
  `account_id` bigint(20) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `ext_value_1` varchar(255) DEFAULT NULL,
  `ext_value_2` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of duban_task_config
-- ----------------------------
BEGIN;

INSERT INTO `duban_task_config` VALUES (1, 'cb_xishu', NULL, '1', NULL, '1', NULL, NULL);
INSERT INTO `duban_task_config` VALUES (2, 'xb_xishu', NULL, '0.9', NULL, '1', NULL, NULL);

COMMIT;


