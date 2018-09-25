/**
 *
 *  File Authors: xuegw
 */

var InquiryLang = {

	inquiry_question_is_not_null : "問題選項不能為空",
		
    inquiry_delete : "刪除",

    inquiry_delete_alert : "你確定刪除所選調查嗎？",

	inquiry_more_one_alert : "請最多選擇一個待修改板塊",
	
	inquiry_one_alert : "請選擇一個待修改板塊",
    
    inquiry_alertDeleteItem : '請選擇要刪除的項',
    
    inquiry_choose_checker_alert:"請選擇審核人員",
    
    inquiry_no_question_alert: "請添加調查題目" ,
    
    inquiry_add_question_isNull_alert: "新增調查問題為空",
    
    inquiry_choose_the_send_alert : "請選擇你要發布的調查" ,
    
    inquiry_choose_query_condition_alert : "請選擇查詢的條件" ,
    
    inquiry_tautonymy_alert:"調查問題不能重名" ,
    
    inquiry_question_null_alert:"調查問題不能為空" ,
   
    inquiry_time_equal_alert:"發布時間不能大于或等于結束時間" ,
    
    inquiry_title_alert: "請填寫查詢標題" ,
    
    inquiry_issuer_alert: "請選擇發布人" ,
    
    inquiry_issueDate_alert: "請選擇發布日期",
    
    inquiry_out_most_alert: "超出最多選擇個數" ,
    
    inquiry_select_the_same_alert: "請選擇同一個調查問題下的選項" ,
    
    inquiry_select_two_item_alert: "請至少選擇2個問題選項" ,
    
    inquiry_add_merge_item_alert: "請輸入合并項名稱!",
    
    inquiry_enter_number_alert: "最大選擇數填寫錯誤，請重新填寫" ,
    
    inquiry_enter_something_alert:"請填寫第",
    
    inquiry_enter_question_something_alert:"個問題",
    
    inquiry_enter_options_alert:"選項不能重複",
    
    inquiry_enter_question_other_alert:"個問題的其他選項內容" ,
    
    inquiry_isTheSame_alert:"該板塊已存在!" ,
    
    inquiry_type_mostword_alert:"板塊名稱最多50個字!" ,
    
    inquiry_type_desc_mostword_alert:"板塊描述最多200個字!"  ,
    
    inquiry_question_is_null_alert:"增加題目為空!" ,
    
    inquiry_is_error:"當前時間不在調查期限內或者調查已刪除！" ,
    
    inquiry_select_pigeonhole:"請選擇歸檔的調查" ,
    
    inquiry_pigeonhole_fail:"歸檔失敗" ,
    
    inquiry_pigeonhole_success:"歸檔成功",
    
    inquiry_before_up_down_alert:"請先增加問題項" ,
    
    inquiry_stop_alert:"確定結束該調查嗎?",
    
    inquiry_send_A_alert:"發送的調查中第 ",
   
    inquiry_send_B_alert:" 項為審核未通過的調查,請取消該項操作!",
    
    inquiry_send_C_alert:" 項為未審核的調查,請取消該項操作!" ,
    
    inquiry_type_delete_alert:"刪除調查板塊時,將連同板塊下的調查一起刪除，刪除不可恢復，確認嗎？" ,
    
    inquiry_grouptype_not_delete:"你無權刪除該調查!" ,
    
    enddate_should_late_than_now:"結束時間應該晚于當前時間!" ,
    
    inquiry_exist:"該調查已經存在,是否繼續操作?",
    
    inquiry_done_alert: "你已經投過票,只能查看結果!",
    
    inuiry_send:"該調查項未審核,請取消該項操作!",
    
    inuiry_no_through:"該調查審核不通過,不能發佈!",
    
    inuiry_is_draft:"該調查處于草稿狀態,不能發佈!",
    
    inuiry_no_auditing:"該信息尚未審核，不允許直接發布!",
    
    inuiry_is_stop:"該調查已經終止,不能發佈!",
    
    inuiry_is_not_fount:"沒有找到當前信息!",
    
    inquiry_senddate_can_not_late_than_now:"發布時間不能小于當前時間!",
    
    inquiry_checkmind_too_long:"審核意見過長,請輸入{0}字以內!",
    
    inquiry_survey_nopass:"該調查結束時間早於當前時間,操作強制為審核不通過!",
    
    inquiry_hasInquiry_can_not_delete:"板塊下有調查不允許刪除!",
    
    inquiry_has_send:"調查已發布!",
    
    inquiry_has_noCheck:"審核員有未審核的調查不能修改,請處理后再進行設置!",
    
    inquiry_has_send_can_not_delete:"調查已發布,不允許刪除!",
    
    inquiry_has_cancel:"調查已取消，無法查看!",
    
    inquiry_is_not_send:"調查還沒有發布！",
    
    inquiry_cancel_alert:"您確認取消發布該調查嗎？",
    
    inquiry_has_delete_by_admin:"此調查板塊已被管理員刪除!",
    
    inquiry_please_choose_one_data:"請選擇一條數據進行操作!",
    
    inquiry_choose_item_from_list:"請從列表中選擇要操作的條目!",
    
    inquiry_can_not_be_edit:"此調查不允許修改!",
    
    inquiry_checker_enabled_please_reset:"審核員不可用,請重新設置審核員后再進行操作!",
    
    inquiry_choose_template:"請選擇調查模板!",
    
    inquiry_ok_continue:"確認并繼續", 
    
    inquiry_ok_exist:"確認并退出",
    
    inquiry_submit:"確認",
    
    inquiry_cancel:"取消",
    
    detail_info_8005 : "<li>單擊“新建”菜單，新建調查。</li>\n<li>勾選一條調查記錄後單擊“修改”菜單或雙擊列表中的調查記錄，修改調查內容。</li>\n<li>勾選列表中的調查記錄，單擊“刪除”菜單，刪除選定的調查記錄。</li>\n<li>勾選列表中的調查記錄，單擊“發布”菜單，發布選定的調查記錄。</li>\n<li>已發布的調查不允許修改，待審核的調查不能發布。</li>",
    detail_info_2006 :"<li>單擊“新建”菜單，新建調查板塊,並對板塊的管理和審核授權。</li>\n<li>勾選一條調查板塊記錄後單擊“修改”菜單或雙擊列表中的調查板塊，修改調查板塊信息並設置管理和審核授權。</li>\n<li>勾選列表中的調查板塊記錄，單擊“刪除”菜單，刪除選定的調查板塊。</li>\n<li>不允許刪除包含調查記錄的板塊。</li>",
    detail_info_607:"<li>審核員點擊待審核的調查，進行審核，并可以輸入審核意見。</li>\n<li>審核員可以對審核通過的調查進行取消審核。</li>",
	inquiry_check_no:"未審核",
    inquiry_check_success:"審核通過",
    
    inquiry_has_finsihed:"調查已經結束!",
    vote_already:"您無法參與、只能查看當前調查，原因可能是：\n1.您已經對當前調查提交了投票結果；\n2.當前調查已結束或已歸檔；\n3.您不在當前調查範圍之內。",
    audit_already:"您已經處理過該條記錄！",
    delete_by_admin_or_creator:"該調查已被管理員或發起者刪除！",
    group_inquiry_manage:"集團調查管理",
    account_inquiry_manage:"單位調查管理",
    group_inquiry_audit:"集團調查審核",
    account_inquiry_audit:"單位調查審核",
    already_pigeonholed:"該調查已被歸檔，您無法在此查看！",
    inquiry_invalid:"發起人修改或刪除了此調查，您無法通過點擊此消息查看其內容。",
    inquiry_pigeonhole_all_running:"您所選中的調查均未結束，不允許進行歸檔操作！",
    inquiry_pigeonhole_some_running:"您所選中的部分未結束調查將不會被歸檔，只有您選中的已結束調查才會被歸檔！",
    inquiry_not_found:"此調查已經被刪除、取消發佈或歸檔，您無法繼續查看其內容！",
    inquiry_has_not_null:"審核員不能為空，請選擇審核員！",
    inquiry_boardAuth_success: "授權成功!"
}