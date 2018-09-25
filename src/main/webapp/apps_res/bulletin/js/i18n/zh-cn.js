/**
 *
 *  File Authors: quboxun
 */

var bulletin = {
	please_select_record:"请从列表中选择要操作的条目！",
	confirm_pigeonhole:"你确定要归档这些记录吗？",
	pigeonhole_failure:"归档失败！",
	select_delete_record:"请从列表中选择要删除的条目 !",
	confirm_delete:"你确定删除所选公告吗？",
	confirm_delete_news:"你确定删除所选新闻吗？",
	select_top_record:"请从列表中选择要置顶的条目 !",
	confirm_cancel:"你确定要撤销这些记录吗？",
	bul_time_alert:"结束时间应当晚于起始时间！",
	
    common_process_label : "处理中...",
    common_separator_label : "、",
    bulletin_already_audit : "该公告已审核！",
    bulletin_not_audit : "该公告未审核！",
    bulletin_no_pers : "你没有公告管理的权限!",

	bulletin_type_delAlreadyUsed : "已发布状态的公告不能删除！",
	bulletin_type_delConfirmed: "确认要删除吗? 该操作不能恢复！",
    bulletin_type_AlreadyUsed : "删除公告板块时,将连同板块下的公告一起删除，删除不可恢复，确认吗？",
    bulletin_type_NoExists : "该记录不存在！",
    bulletin_alreay_exists : "该记录已经存在！",
    bulletin_notAlreay_exists : "板块名称不允许重名！",
    bulletin_Template_notAlreay : "版面名称不允许重复！",
    bulletin_no_purview:"你无权使用该功能，请联系系统管理员！",
    bul_not_audit:"对不起，您选择了尚未审核的信息！",
    bulletin_type_system:"系统内置公告板块，不允许删除！",
    
    news_type_AlreadyUsed :"删除新闻板块时,将连同板块下的新闻一起删除，删除不可恢复，确认吗？",
    news_type_NoExists:"该记录不存在！",
    news_alreay_exists:"该记录已经存在！",
    news_no_purview:"你无权使用该功能，请联系系统管理员！",
    news_not_exists:"该记录不存在！",
    news_not_audit:"该新闻尚未审核，不能发布！",
    news_type_system:"系统内置新闻板块，不允许删除！",
    news_already_audit : "该新闻已审核！",
    news_not_audit : "该新闻未审核！",
    
    meeting_already_start:"{0} 已经召开，无法删除！",
    meeting_no_delete:"你无权删除 {0}！",
    meeting_no_summary:"你无权对会议 {0} 进行总结！",
    meeting_no_finish_no_summary:"会议 {0} 尚未结束，不能进行总结！",
    
    cal_end_less_begin:"事件结束时间应该大于开始时间，请重新设置！",
    
	a:"a",
	news_type_delAlreadyUsed : "已发布状态的新闻不能删除！",
	bul_has_no_top : "该板块置顶个数设置为零,不能进行此操作!",
	bul_news_update: "只能选择一条记录进行修改！",
	
	select_top_record_cancel:"请从列表中选择要取消置顶的条目 !",
	toped_full:"该板块置顶个数不得超过{0}",
	
	please_select_only_one_edit: "只能选择一条记录进行修改!",
	audited_no_edit: "已经审核通过的不允许修改。",
	data_deleted: "记录已经被删除。",
	
	detail_info_604_1:"<li></li>",
	detail_info_604_2:"<li></li>",
	detail_info_8003:"<li></li>",
	detail_info_605:"<li>单击“新建”菜单，新建公告板块，并对公告板块的管理和审核授权。</li>\n<li>勾选一条公告板块记录后单击“修改”菜单或双击列表中的公告板块，修改公告板块信息。</li>\n<li>勾选列表中的公告板块记录，单击“删除”菜单，删除选定的公告板块。</li>\n<li>不允许删除包含公告记录的板块。</li>",
	detail_info_2006_1 :"<li>单击“新建”菜单，新建公告板块,并对公告板块的管理和审核授权。</li>\n<li>勾选一条公告板块记录后单击“修改”菜单或双击列表中的公告板块，修改公告板块信息。</li>\n<li>勾选列表中的公告板块记录，单击“删除”菜单，删除选定的公告板块。</li>\n<li>不允许删除包含公告记录的板块。</li>",
	detail_info_608 :"<li>单击“新建”菜单，进入新建公告页面。</li>\n<li>勾选一条未发布的公告记录后单击“修改”菜单或双击列表中的公告记录，修改公告信息。</li>\n<li>勾选列表中的公告记录，单击“删除”菜单，删除选定的公告记录。</li>\n<li>勾选列表中审核通过或不需审核的公告记录，单击“发布”菜单，可以将选中的公告发布。</li>",
	
	audit_user_has_pending: "该审核员有未审核事项，不允许修改。",
	
	bul_not_pass:"对不起，您选择了审核未通过的信息！",
	news_not_pass:"该新闻审核未通过，不能发布！",
	bul_top_no_valid:"不可以重复设置，请重新选择。",
	
	published_no_edit: "已经发布的不允许修改。只能查看",
	
	type_deleted: "板块已经被删除。",
	
	type_manager_stop_alert: "您已经不是该板块的管理员。",
	
	bul_top_no_valid_alert:"公告《{0}》已经置顶。",
	bul_edit_window_not_close:"您正在进行正文修改操作，暂不能直接提交!",
	bul_top_cancel_no_valid_alert:"选中的记录已经取消置顶。",
	
	bul_top_selected_too_much: "该板块最多允许置顶 {0} 条，现已经置顶 {1} 条，您本次置顶最多可以选择 {2} 条记录。",
	detail_info_606:"<li>公告管理员管理板块内的公告，可以对公告置顶或取消置顶、删除等操作。</li>\n<li>点击归档，将公告归档到需要保存的文挡夹。</li>\n<li>点击授权，将此类型的发布公告的权力授权给其他普通用户。</li>\n<li>点击统计，可以根据阅读次数、发起者、公告状态等进行统计。</li>",	
	detail_info_606_2:"<li>公告管理员管理板块内的公告，可以对公告置顶或取消置顶、删除等操作。</li>\n<li>点击归档，将公告归档到需要保存的文挡夹。</li>\n<li>点击统计，可以根据阅读次数、发起者、公告状态等进行统计。</li>",
	detail_info_607:"<li>审核员点击待审核的公告，进行审核，并可以输入审核意见。</li>\n<li>审核员可以对审核通过的公告进行取消审核。</li>",
	bul_news_already_poss:"该信息已经发布！",
	bul_news_poss_del :"该信息已经发布，不能删除！",
	record_delete:"您要审核的本条公告已被管理员或发起者删除！",
	group_bulletin_manage:"集团公告管理",
	account_bulletin_manage:"单位公告管理"	,
	dept_bulletin_manage:"部门公告管理"	,
	group_bulletin_audit:"集团公告审核",
	account_bulletin_audit:"单位公告审核",
	bulletin_delete:"您确认取消发布该公告吗？",
	news_delete:"您确认取消发布该新闻吗？",
	bulletin_checker_enabled_please_reset:"审核员不可用,请重新设置审核员后再进行操作!",
	bulletin_invalid:"此公告已被删除、取消发布或归档，您无法继续查看其内容。",
	not_purview : "您没有发布权限！",
	label_pos : "当前位置",
	bulletin_boardAuth_success : "授权成功!",
	broad_move : "移动",
	broad_move_ok : "确定",
	broad_move_cancel : "取消",
	please_select_record_to_move: "请最少选择一条需要移动的记录！",
	please_set_issus_scope : "请选择公告发布范围",
	please_select_issus_space : "请选择公告板块"
}