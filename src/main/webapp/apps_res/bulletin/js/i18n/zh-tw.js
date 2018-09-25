/**
 *
 *  File Authors: quboxun
 */

var bulletin = {
	please_select_record:"請從列表中選擇要操作的條目！",
	confirm_pigeonhole:"你確定要歸檔這些記錄嗎？",
	pigeonhole_failure:"歸檔失敗！",
	select_delete_record:"請從列表中選擇要刪除的條目 !",
	confirm_delete:"你確定刪除所選公告嗎？",
	confirm_delete_news:"你確定刪除所選新聞嗎？",
	select_top_record:"請從列表中選擇要置頂的條目 !",
	confirm_cancel:"你確定要撤銷這些記錄嗎？",
	bul_time_alert:"結束時間應當晚於起始時間",
	
    common_process_label : "處理中...",
    common_separator_label : "、",
    bulletin_already_audit : "該公告已審核！",
    bulletin_not_audit : "該公告未審核！",
    bulletin_no_pers : "你沒有公告管理的權限",

	bulletin_type_delAlreadyUsed : "已發布狀態的公告不能刪除！",
	bulletin_type_delConfirmed: "確認要刪除嗎？該操作不能恢復！",
    bulletin_type_AlreadyUsed : "刪除公告模塊時，將連同版塊下的公告一起刪除，刪除不可恢復，確認嗎？",
    bulletin_type_NoExists : "該記錄不存在！",
    bulletin_alreay_exists : "該記錄已經存在！",
    bulletin_notAlreay_exists : "板塊名稱不允許重名！",
    bulletin_Template_notAlreay : "版面名稱不允許重復！",
    bulletin_no_purview:"你無權使用該功能，請聯系系統管理員！",
    bul_not_audit:"對不起，您選擇了尚未審核的信息！",
    bulletin_type_system:"系統內置公告板塊，不允許刪除！",
    
    news_type_AlreadyUsed :"刪除新聞版塊時，將連同版塊下的新聞一起刪除，刪除不可恢復，確認嗎？",
    news_type_NoExists:"該記錄不存在！",
    news_alreay_exists:"該記錄已經存在！",
    news_no_purview:"你無權使用該功能，請聯系系統管理員！",
    news_not_exists:"該記錄不存在！",
    news_not_audit:"該新聞尚未審核，不能發布！",
    news_type_system:"系統內置新聞板塊，不允許刪除！",
    news_already_audit : "該新聞已審核！",
    news_not_audit : "該新聞未審核！",
    
    meeting_already_start:"{0} 已經召開，無法刪除！",
    meeting_no_delete:"你無權刪除 {0}！",
    meeting_no_summary:"你無權對會議 {0} 進行總結！",
    meeting_no_finish_no_summary:"會議 {0} 尚未結束，不能進行總結！",
    
    cal_end_less_begin:"事件結束時間應該大于開始時間，請重新設置！",
    
	a:"a",
	news_type_delAlreadyUsed : "已發布狀態的新聞不能刪除！",
	bul_has_no_top : "該板塊置頂個數設置為零,不能進行此操作!",
	bul_news_update: "只能選擇一條記錄進行修改！",
	
	select_top_record_cancel:"請從列表中選擇要取消置頂的條目 !",
	toped_full:"該板塊置頂個數不得超過{0}",
	
	please_select_only_one_edit: "只能選擇一條記錄進行修改!",
	audited_no_edit: "已經審核通過的不允許修改。",
	data_deleted: "記錄已經被刪除。",
	
	detail_info_604_1:"<li></li>",
	detail_info_604_2:"<li></li>",
	detail_info_8003:"<li></li>",
	detail_info_605:"<li>單擊“新建”菜單，新建公告板塊，並對公告板塊的管理和審核授權。</li>\n<li>勾選一條公告板塊記錄後單擊“修改”菜單或雙擊列表中的公告板塊，修改公告板塊信息。</li>\n<li>勾選列表中的公告板塊記錄，單擊“刪除”菜單，刪除選定的公告板塊。</li>\n<li>不允許刪除包含公告記錄的板塊。</li>",
	detail_info_2006_1 :"<li>單擊“新建”菜單，新建公告板塊,並對公告板塊的管理和審核授權。</li>\n<li>勾選一條公告板塊記錄後單擊“修改”菜單或雙擊列表中的公告板塊，修改公告板塊信息。</li>\n<li>勾選列表中的公告板塊記錄，單擊“刪除”菜單，刪除選定的公告板塊。</li>\n<li>不允許刪除包含公告記錄的板塊。</li>",
	detail_info_608 :"<li>單擊“新建”菜單，進入新建公告頁面。</li>\n<li>勾選一條未發布的公告記錄後單擊“修改”菜單或雙擊列表中的公告記錄，修改公告信息。</li>\n<li>勾選列表中的公告記錄，單擊“刪除”菜單，刪除選定的公告記錄。</li>\n<li>勾選列表中審核通過或不需審核的公告記錄，單擊“發布”菜單，可以將選中的公告發布。</li>",
	audit_user_has_pending: "該審核員有未審核事項，不允許修改。",
	
	bul_not_pass:"對不起，您選擇了審核未通過的信息！",
	news_not_pass:"該新聞審核未通過，不能發布！",
	bul_top_no_valid:"不可以重複設置，請重新選擇。",
	
	published_no_edit: "已經發布的不允許修改。只能查看",
	
	type_deleted: "板塊已經被刪除。",
	
	type_manager_stop_alert: "您已經不是該板塊的管理員。",
	
	bul_top_no_valid_alert:"公告《{0}》已經置頂。",
	bul_edit_window_not_close:"您正在進行正文修改操作，暫不能直接提交!",
	bul_top_cancel_no_valid_alert:"選中的記錄已經取消置頂。",
	
	bul_top_selected_too_much: "該板塊最多允許置頂 {0} 條，現已經置頂 {1} 條，您本次置頂最多可以選擇 {2} 條記錄。",
	detail_info_606:"<li>公告管理員管理板塊內的公告，可以對公告置頂或取消置頂、刪除等操作。</li>\n<li>單擊歸檔，將公告歸檔到需要保存的文檔夾。</li>\n<li>單擊授權，將此類型的發布公告的權利授權給其他普通用戶。</li>\n<li>點擊統計，可以根據閱讀次數、發起者、新聞狀態等進行統計。</li>",	
	detail_info_606_2:"<li>公告管理員管理板塊內的公告，可以對公告置頂或取消置頂、刪除等操作。</li>\n<li>單擊歸檔，將公告歸檔到需要保存的文檔夾。</li>\n<li>點擊統計，可以根據閱讀次數、發起者、新聞狀態等進行統計。</li>",	
	detail_info_607:"<li>審核員點擊待審核的公告，進行審核，并可以輸入審核意見。</li>\n<li>審核員可以對審核通過的公告進行取消審核。</li>",
	bul_news_already_poss:"該信息已經發布！",
	bul_news_poss_del :"該信息已經發布，不能刪除！",
	record_delete:"您要審核的本條公告已被管理員或發起者刪除！",
	group_bulletin_manage:"集團公告管理",
	account_bulletin_manage:"單位公告管理",
	dept_bulletin_manage:"部門公告管理"	,
	group_bulletin_audit:"集團公告審核",
	account_bulletin_audit:"單位公告審核",
	bulletin_delete:"您确认取消发布该公告吗？",
	news_delete:"您确认取消发布该新闻吗？",
	bulletin_checker_enabled_please_reset:"審核員不可用,請重新設置審核員后再進行操作!",
	bulletin_invalid:"此公告已被刪除、取消發布或歸檔，您無法繼續查看其內容。",
    FlashTip_blankNode : "空節點無法設置節點屬性!",
    not_purview : "您沒有發布權限！",
    label_pos : "當前位置",
    bulletin_boardAuth_success: "授權成功!",
    broad_move : "移動",
	broad_move_ok : "確定",
	broad_move_cancel : "取消",
	please_select_record_to_move: "請最少選擇一條需要移動的記錄！",
	please_set_issus_scope : "請選擇公告發布範圍",
	please_select_issus_space : "請選擇公告板塊"
}