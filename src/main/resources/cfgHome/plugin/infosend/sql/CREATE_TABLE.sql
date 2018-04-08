
drop table ctp_category;
drop table ctp_keyword;
drop table ctp_element;
drop table ctp_form;
drop table ctp_form_element;
drop table ctp_form_acl;
drop table ctp_form_extend_info;
drop table ctp_element_flowperm_acl;
drop table ctp_form_flowperm_bound;
drop table ctp_opinion;


delete from ctp_element;
delete from ctp_element_flowperm_acl;
delete from ctp_form;
delete from ctp_form_extend_info;
delete from ctp_form_acl;
delete from ctp_form_flowperm_bound;
delete from ctp_form_element;
delete from ctp_category;


select * from ctp_element;
select * from ctp_element_flowperm_acl;
select * from ctp_form;
select * from ctp_form_extend_info;
select * from ctp_form_acl;
select * from ctp_form_flowperm_bound;
select * from ctp_form_element;
select * from ctp_category;


-- 信息类型表
CREATE TABLE `ctp_category` (
  `id` 				BIGINT(20),
  `name` 			VARCHAR(255),
  `root_category` 			BIGINT(20),
  `category_level` 			TINYINT(4),
  `sort` 			INT(4),
  `create_user_id` 	BIGINT(20),
  `create_time` 	DATETIME,
  `parent_id` 		BIGINT(20),
  `is_system` 		TINYINT(4) 		DEFAULT '0',
  `category_desc` 	VARCHAR(1024),
  `domain_id` 		BIGINT(20),
	`state` 	INT(4),
	`app_type` INT(4),
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;

-- 信息关键字表
CREATE TABLE `ctp_keyword` (
  `id` 				BIGINT(20),
  `name` 			VARCHAR(255),
  `keyword_type` 	VARCHAR(30),
  `is_system` 		TINYINT(4),
	`app_type` INT(4),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8;


-- 信息单元素表
CREATE TABLE `ctp_element` (
  `id` 				BIGINT(20),
  `element_id` 		CHAR(4),
  `name` 			VARCHAR(255),
  `field_name` 		VARCHAR(30),
  `type` 			TINYINT(4),
  `enum_id` 	BIGINT(20),
  `is_system` 		TINYINT(1),
  `status` 			TINYINT(4),
  `domain_id`      	BIGINT          DEFAULT 0,
  `input_mode`     	VARCHAR(32),
	`app_type` INT(4),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8;

-- 信息单表
CREATE TABLE `ctp_form` (
  `id` 				BIGINT(20),
  `name` 			VARCHAR(255),
  `description` 	VARCHAR(255),
  `type` 			TINYINT(4),
  `category_id` 	BIGINT(20),
  `content` 		TEXT,
  `create_user_id` 	BIGINT(20),
  `create_time` 	DATETIME,
  `last_user_id` 	BIGINT(20),
  `last_update` 	DATETIME,
  `domain_id` 		BIGINT(20),
  `file_id` 		BIGINT(20),
  `show_log` 		TINYINT(4),
  `is_system` 		TINYINT(4),
  `isunit` 			TINYINT(4)  	DEFAULT '0',
	`app_type` INT(4),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8;

-- 信息单元素关系表
CREATE TABLE `ctp_form_element` (
  `id` 	BIGINT(20),
  `form_id` 	BIGINT(20),
  `element_id` 	BIGINT(20),
  `required`		TINYINT(1) 	DEFAULT 0,
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8;

-- 信息单授权表
CREATE TABLE `ctp_form_acl` (
  `id` 			BIGINT(20),
  `form_id` 	BIGINT(20),
  `domain_id` 	BIGINT(20),
  `entity_type` VARCHAR(255),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8;

-- 信息报送单信息
CREATE TABLE `ctp_form_extend_info` (
  `id` 				BIGINT(20),
  `form_id` 		BIGINT(20),
  `account_id`		BIGINT(20),
  `status` 			TINYINT(4),
  `is_default` 		TINYINT(4),
  `optionFormatSet` VARCHAR(32) DEFAULT '0,0,0',
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8;

-- 信息元素节点权限表
CREATE TABLE ctp_element_flowperm_acl(
    id             		BIGINT(20),
    flow_perm_id        BIGINT(20),
    element_id          BIGINT(20),
    perm               	TINYINT(4),
    PRIMARY KEY (id)
) DEFAULT CHARSET utf8;

-- 信息节点权限表
create table `ctp_form_flowperm_bound`(
  `id`                   BIGINT(20),
  `form_id`         BIGINT(20),
  `process_name`         VARCHAR(255),
  `flowperm_name`        VARCHAR(255),
  `flowperm_name_label`  VARCHAR(255),
  `sort_type` 			   VARCHAR(8) 	DEFAULT '0',
  `domain_id` 			   BIGINT(20),
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;


-- 信息意见表
CREATE TABLE `ctp_opinion` (
  `id` 				BIGINT(20),
  `summary_id` 		BIGINT(20),
  `affair_id` 		BIGINT(20),
  `attribute` 		INT(11),
  `content` 		TEXT,
  `opinion_type` 	INT(11),
  `is_hidden` 		TINYINT(4),
  `create_user_id` 	BIGINT(20),
  `create_time` 	DATETIME,
  `policy` 			VARCHAR(255),
  `proxy_name`      VARCHAR(255),
  `node_id`   		BIGINT(20) 		DEFAULT '-1',
  `state` 			INT(4) 			DEFAULT 0,
	`app_type` INT(4),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8;

