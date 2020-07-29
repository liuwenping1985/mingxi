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

INSERT INTO `duban_task_config`(`id`, `name`, `enum_id`, `item_value`, `account_id`, `state`, `ext_value_1`, `ext_value_2`) VALUES (1, 'cb_xishu', 99999999, '1', NULL, '1', NULL, NULL);
INSERT INTO `duban_task_config`(`id`, `name`, `enum_id`, `item_value`, `account_id`, `state`, `ext_value_1`, `ext_value_2`) VALUES (2, 'xb_xishu', 99999998, '0.9', NULL, '1', NULL, NULL);