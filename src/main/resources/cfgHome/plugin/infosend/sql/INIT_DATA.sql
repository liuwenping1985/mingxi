
select * from ctp_enum where PROGRAM_CODE like '%edoc%';


select * from ctp_enum_item where ref_enumid=3001 or id=3001;



update ctp_element set type=5 where field_name = 'category';


insert into ctp_enum(id, enumtype, sortnumber, ifuse, enumstate, description, org_account_id, parent_id, 
program_code, category, can_edit, rule_ctp, enumname, i18n)
values(1111111111111, 1, 32, 0, 1, '信息报送权限策略', 0, 0, 
'info_send_permission_policy', 4, 0, null, 'flowperm.info.sendpolicy', 1);

insert into ctp_enum(id, enumtype, sortnumber, ifuse, enumstate, description, org_account_id, parent_id, 
program_code, category, can_edit, rule_ctp, enumname, i18n)
values(1111111111112, 1, 32, 0, 1, '基本操作', 0, 0, 
'info_basic_action', 4, 0, null, 'flowperm.operation.basic', 1);

insert into ctp_enum(id, enumtype, sortnumber, ifuse, enumstate, description, org_account_id, parent_id, 
program_code, category, can_edit, rule_ctp, enumname, i18n)
values(1111111111113, 1, 32, 0, 1, '高级操作', 0, 0, 
'info_node_control_action', 4, 0, null, 'flowperm.operation.advanced', 1);



insert into ctp_enum_item(id, ref_enumid, showvalue, enumvalue, sortnumber, state, output_switch, 
org_account_id, parent_id, root_id, level_num, description, ifuse, i18n)
values(111111111111111, 1111111111111, 'node.policy.shangbao', 'shangbao', 1, 1, 1, 
0, 0, 0, 0, '', 1, 1);
insert into ctp_enum_item(id, ref_enumid, showvalue, enumvalue, sortnumber, state, output_switch, 
org_account_id, parent_id, root_id, level_num, description, ifuse, i18n)
values(111111111111112, 1111111111111, 'node.policy.jieshou', 'jieshou', 1, 1, 1, 
0, 0, 0, 0, '', 1, 1);
insert into ctp_enum_item(id, ref_enumid, showvalue, enumvalue, sortnumber, state, output_switch, 
org_account_id, parent_id, root_id, level_num, description, ifuse, i18n)
values(111111111111113, 1111111111111, 'node.policy.shenhe', 'shenhe', 1, 1, 1, 
0, 0, 0, 0, '', 1, 1);
insert into ctp_enum_item(id, ref_enumid, showvalue, enumvalue, sortnumber, state, output_switch, 
org_account_id, parent_id, root_id, level_num, description, ifuse, i18n)
values(111111111111114, 1111111111111, 'node.policy.qianfa', 'qianfa', 1, 1, 1, 
0, 0, 0, 0, '', 1, 1);
insert into ctp_enum_item(id, ref_enumid, showvalue, enumvalue, sortnumber, state, output_switch, 
org_account_id, parent_id, root_id, level_num, description, ifuse, i18n)
values(111111111111115, 1111111111111, 'node.policy.caibian', 'caibian', 1, 1, 1, 
0, 0, 0, 0, '', 1, 1);


insert into ctp_enum_item(id, ref_enumid, showvalue, enumvalue, sortnumber, state, output_switch, 
org_account_id, parent_id, root_id, level_num, description, ifuse, i18n)
values(111111111111116, 1111111111112, 'info.state.6.stepback', 'InfoReturn', 1, 1, 1, 
0, 0, 0, 0, '退回', 1, 1);
insert into ctp_enum_item(id, ref_enumid, showvalue, enumvalue, sortnumber, state, output_switch, 
org_account_id, parent_id, root_id, level_num, description, ifuse, i18n)
values(111111111111117, 1111111111112, 'col.state.10.stepstop', 'InfoTerminate', 1, 1, 1, 
0, 0, 0, 0, '终止', 1, 1);
insert into ctp_enum_item(id, ref_enumid, showvalue, enumvalue, sortnumber, state, output_switch, 
org_account_id, parent_id, root_id, level_num, description, ifuse, i18n)
values(111111111111118, 1111111111112, 'info.state.6.stepback', 'ContentPrint', 1, 1, 1, 
0, 0, 0, 0, '正文打印', 1, 1);
insert into ctp_enum_item(id, ref_enumid, showvalue, enumvalue, sortnumber, state, output_switch, 
org_account_id, parent_id, root_id, level_num, description, ifuse, i18n)
values(111111111111119, 1111111111112, 'info.state.6.stepback', 'ContentSave', 1, 1, 1, 
0, 0, 0, 0, '正文保存', 1, 1);


insert into ctp_enum_item(id, ref_enumid, showvalue, enumvalue, sortnumber, state, output_switch, 
org_account_id, parent_id, root_id, level_num, description, ifuse, i18n)
values(1111111111111110, 1111111111113, 'info.action.form.update', 'UpdateInfoForm', 1, 1, 1, 
0, 0, 0, 0, '修改报送单', 1, 1);
insert into ctp_enum_item(id, ref_enumid, showvalue, enumvalue, sortnumber, state, output_switch, 
org_account_id, parent_id, root_id, level_num, description, ifuse, i18n)
values(1111111111111111, 1111111111113, 'info.action.department.pigeonhole', 'InfoDepartPigeonhole', 1, 1, 1, 
0, 0, 0, 0, '部门归档', 1, 1);
insert into ctp_enum_item(id, ref_enumid, showvalue, enumvalue, sortnumber, state, output_switch, 
org_account_id, parent_id, root_id, level_num, description, ifuse, i18n)
values(1111111111111112, 1111111111113, 'info.metadata_item.returnToStartUser', 'returnToStartUser', 1, 1, 1, 
0, 0, 0, 0, '退回到拟稿人', 1, 1);
insert into ctp_enum_item(id, ref_enumid, showvalue, enumvalue, sortnumber, state, output_switch, 
org_account_id, parent_id, root_id, level_num, description, ifuse, i18n)
values(1111111111111113, 1111111111113, 'info.metadata_item.TanstoPdf', 'InfoTanstoPDF', 1, 1, 1, 
0, 0, 0, 0, 'Word转PDF', 1, 1);



insert into ctp_config(id, config_category, config_category_name, config_item, config_value, config_description, 
create_date, modify_date, config_type, ext_config_value, org_account_id) values(-3100761985252114123, 'info_send_permission_policy', null, 'shangbao', null, '上报',
'2013-07-05 17:38:08', '2013-07-05 17:38:08', 0, '<com.seeyon.v3x.common.permission.util.NodePolicy><baseAction></baseAction><advancedAction></advancedAction><location>0</location><isEnabled>1</isEnabled></com.seeyon.v3x.common.permission.util.NodePolicy>',
329715819358209142);


insert into ctp_config(id, config_category, config_category_name, config_item, config_value, config_description, 
create_date, modify_date, config_type, ext_config_value, org_account_id) values(-3559961089689301910, 'info_send_permission_policy', null, 'shenhe', null, '审核',
'2013-07-05 17:38:08', '2013-07-05 17:38:08', 0, '<com.seeyon.v3x.common.permission.util.NodePolicy>
  <baseAction>ContinueSubmit,Comment,InfoReturn,InfoTerminate,Archive,Opinion</baseAction>
  <commonAction></commonAction>
  <advancedAction>AddNode,RemoveNode,Edit,InfoDepartPigeonhole</advancedAction>
  <location>1</location>
  <isEnabled>1</isEnabled>
</com.seeyon.v3x.common.permission.util.NodePolicy>',
329715819358209142);

insert into ctp_config(id, config_category, config_category_name, config_item, config_value, config_description, 
create_date, modify_date, config_type, ext_config_value, org_account_id) values(-4446131778644393293, 'info_send_permission_policy', null, 'qianfa', null, '签发',
'2013-07-05 17:38:08', '2013-07-05 17:38:08', 0, '<com.seeyon.v3x.common.permission.util.NodePolicy>
  <baseAction>ContinueSubmit,Comment,InfoReturn,InfoTerminate,Archive,Opinion</baseAction>
  <commonAction></commonAction>
  <advancedAction>AddNode,RemoveNode,Edit,InfoDepartPigeonhole</advancedAction>
  <location>1</location>
  <isEnabled>1</isEnabled>
</com.seeyon.v3x.common.permission.util.NodePolicy>',
329715819358209142);


insert into ctp_config(id, config_category, config_category_name, config_item, config_value, config_description, 
create_date, modify_date, config_type, ext_config_value, org_account_id) values(-2238041949311644485, 'info_send_permission_policy', null, 'jieshou', null, '接收',
'2013-07-05 17:38:08', '2013-07-05 17:38:08', 0, '<com.seeyon.v3x.common.permission.util.NodePolicy>
  <baseAction>ContinueSubmit,Comment,InfoReturn,InfoTerminate,Archive,Opinion</baseAction>
  <commonAction></commonAction>
  <advancedAction>AddNode,RemoveNode,Edit,InfoDepartPigeonhole</advancedAction>
  <location>1</location>
  <isEnabled>1</isEnabled>
</com.seeyon.v3x.common.permission.util.NodePolicy>',
329715819358209142);

insert into ctp_config(id, config_category, config_category_name, config_item, config_value, config_description, 
create_date, modify_date, config_type, ext_config_value, org_account_id) values(-2154012700049782980, 'info_send_permission_policy', null, 'caibian', null, '采编',
'2013-07-05 17:38:08', '2013-07-05 17:38:08', 0, '<com.seeyon.v3x.common.permission.util.NodePolicy>
  <baseAction>ContinueSubmit,Comment,InfoReturn,InfoTerminate,Archive,Opinion</baseAction>
  <commonAction></commonAction>
  <advancedAction>AddNode,RemoveNode,Edit,InfoDepartPigeonhole</advancedAction>
  <location>1</location>
  <isEnabled>1</isEnabled>
</com.seeyon.v3x.common.permission.util.NodePolicy>',
329715819358209142);


insert into info_category(id, name, category_level, sort, create_user_id, create_time, parent_id, is_system, category_desc, domain_id) values
(-3957661019398516869, '日常政务类', 1, 1, 0, '2012-02-06 15:14:47', 0, 0, null, 329715819358209142);


select * from info_body;


insert into ctp_content_all(id, create_id, create_date, module_type, module_id, module_template_id, content_type, content,
title, sort) select b.id,s.cr from edoc_summary s, edoc_body b where s.id=b.summary_id 


select * from ctp_content_all;


select * from info_summary;



select * from info_category where domain_id=329715819358209142


select * from ctp_config where CONFIG_CATEGORY LIKE '%info%';

select * from info_element where field_name like '%shangbao%';



select * from info_summary where `subject` like '%2222%';


select * from info_element;


select * from info_summary where id=3093100532791590940;



select * from ctp_affair 
where object_id=3093100532791590940;


select * from ctp_content_all



select * from info_form;
