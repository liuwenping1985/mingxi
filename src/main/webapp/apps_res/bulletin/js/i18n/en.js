/**
 *
 *  File Authors: quboxun
 */

var bulletin = {
	please_select_record:"Please select the entry to be processed from the list!",
	confirm_pigeonhole:"Are you sure to archive these records?",
	pigeonhole_failure:"Archiving failed!",
	select_delete_record:"Please select the entry to be deleted from the list!",
	confirm_delete:"Are you sure to delete these bulletins?",
	confirm_delete_news:"Are you sure to delete these news?",
	select_top_record:"Please select the bulletin to be moved to the top of the list!",
	confirm_cancel:"Are you sure to cancel these records?",
	bul_time_alert:"End time should be later than the start time!",
	
    common_process_label : "Processing…",
    common_separator_label : ",",
    bulletin_already_audit : "The bulletin has been audited!",
    bulletin_not_audit : "The bulletin has not been audited!",
    bulletin_no_pers : "you don't have the manager permissions of publish the bulltion!",

	bulletin_type_delAlreadyUsed : "It is not permitted to delete the issued bulletin!",
	bulletin_type_delConfirmed: "Sure to delete ? You can't get it back!",
    bulletin_type_AlreadyUsed : "Sure to delete the bulletin board with bulletins under it? You can't get them back!",
    bulletin_type_NoExists : "The record does not exist!",
    bulletin_alreay_exists : "The record already exists!",
    bulletin_notAlreay_exists : "Duplicate name of type is not permitted!",
    bulletin_Template_notAlreay : "Duplicate name of board is not permitted!",
    bulletin_no_purview:"No right to use the function, contact with the system administrator!",
    bul_not_audit:"Sorry, you chose not audit the information!",
    bulletin_type_system:"It is not permitted to delete the built-in bulletin of system!",
    
    news_type_AlreadyUsed :"Sure to delete the news board with newses under it? You can't get them back!",
    news_type_NoExists:"The record does not exist!",
    news_alreay_exists:"The record already exists!",
    news_no_purview:"No right to use the function, contact with the system administrator!",
    news_not_exists:"The record does not exist!",
    news_not_audit:"The unaudited news can not be issued!",
    news_type_system:"It is not permitted to delete the built-in news of system!",
    news_already_audit : "The news has been audited!",
    news_not_audit : "The news has not been audited!",
    
    meeting_already_start:"{0} which has already started can not be deleted!",
    meeting_no_delete:"No right to delete {0}!",
    meeting_no_summary:"No right to sum up the meeting {0}!",
    meeting_no_finish_no_summary:"The meeting {0} which has not yet come to an end can not be summed up!",
    
    cal_end_less_begin:"Terminal time of an event should be larger than its start time, reset!",
    
	a:"a",
	news_type_delAlreadyUsed :"It is not permitted to delete the issued news!",
	bul_has_no_top : "It is not allowed to carry out this operation as the number of top is zero! ",
	bul_news_update: "Only one record can be selected for modification!",
	
	select_top_record_cancel:"Please select the entry to cancel top from the list!",
	toped_full:"Only {0} items can be set top.",
	
	please_select_only_one_edit: "Only one record can be selected for modification!",
	audited_no_edit: "The audited record can not be selected for modification. ",
	data_deleted: "The record has been deleted.",
	
	detail_info_604_1:"<li></li>",
	detail_info_604_2:"<li></li>",
	detail_info_8003:"<li></li>",
	detail_info_605:"<li> To create a new bulletin template, click the 'New' button to open a dialog form and fill in the relevant info; also configure whether the bulletin should be audited or not.</li>\n<li>To modify a bulletin template, select an item on the list, and then click the 'Modify' button.</li>\n<li>To delete a bulletin template, select an item on the list, and then click the 'Delete' button.</li>\n<li>It is not allowed to delete a bulletin template which has existing bulletin items.</li>",
	detail_info_2006 :"<li> To create a new bulletin template, click the 'New' button to open a dialog form and fill in the relevant info; also configure whether the bulletin should be audited or not.</li>\n<li>To modify a bulletin template, select an item on the list, and then click the 'Modify' button.</li>\n<li>To delete a bulletin template, select an item on the list, and then click the 'Delete' button.</li>\n<li>It is not allowed to delete a bulletin template which has existing bulletin items.</li>",
	detail_info_608 :"<li> To create a new bulletin , click the 'New' button to open a dialog form and fill in the relevant info.</li>\n<li>To modify a bulletin, select a record that is not published yet on the list, and then click the 'Modify' button.</li>\n<li>Select the records in the list and then click the 'Delete' button.</li>\n<li>Select the records in the list that has been audited or need no audit and click the 'Publish' button to publish them.</li>",
	audit_user_has_pending: "The auditor has some pendings, you can not edit.",
	
	bul_not_pass:"Sorry, you chose the audit did not pass the information!",
	news_not_pass:"The auditor has not passed the news, you can not issue it.",
	bul_top_no_valid:"You can not config repeatedly, please select again.",
	
	published_no_edit: "The published record can not be selected for modification. only view",
	
	type_deleted: "The type has been deleted.",
	
	type_manager_stop_alert: "You are not the type's manager now.",
	
	bul_top_no_valid_alert:"The bulletin 《{0}》 have been set to top.",
	bul_edit_window_not_close:"You are the body of modify operations were temporarily not directly submit!",
	bul_top_cancel_no_valid_alert:"The selected records have been canceld top flag.",
	
	bul_top_selected_too_much: "The type's maximum topped count is {0}, now {1} is topped, you can only select {2} records this time.",
	detail_info_606:"<li>Notice an administrator to manage the view of the notice, or cancel the notice Top Top, delete and other operations.</li>\n<li>Click on the archives, archives will notice the need to preserve the text block folder.</li>\n<li>Click authorized this type of announcement of the powers delegated to other ordinary users.</li>\n<li>Click on statistics, based on type of readers, sponsors, such as state statistical bulletin.</li>",	
	detail_info_606_2:"<li>Notice an administrator to manage the view of the notice, or cancel the notice Top Top, delete and other operations.</li>\n<li>Click on the archives, archives will notice the need to preserve the text block folder.</li>\n</li>\n<li>Click on statistics, based on count of readers, sponsors, such as state statistical bulletin.</li>",	
	detail_info_607:"<li>Click auditors pending notice, to review and audit opinions can enter.</li>\n<li>The auditor may notice to the audit conducted by the abolition of examination.</li>",
	bul_news_already_poss:"This information has been released!",
	bul_news_poss_del :"The information has been released, can not be deleted!",
	record_delete:"The news you want to audit has been deleted by the administrator of the board or the creator!",
	group_bulletin_manage:"Group Bulletin Manage",
	account_bulletin_manage:"Account Bulletin Manage",
	dept_bulletin_manage:"Department Bulletin Manage",
	group_bulletin_audit:"Group Bulletin Audit",
	account_bulletin_audit:"Account Bulletin Audit",
	bulletin_delete:"Are you sure you cancel the bulletin?",
	news_delete:"Are you sure you cancel the news?",
	bulletin_checker_enabled_please_reset:"Checker enabled please reset it!",
	bulletin_invalid:"This bulletin has been deleted or canceled or pigeonholed and you can't view its content any more.",
     
    not_purview : "Does not have the jurisdiction!"	,
    label_pos : "Current Location",
    bulletin_boardAuth_success : "Authorized to success!",
    broad_move : "Transfer",
	broad_move_ok : "ok",
	broad_move_cancel : "cancel",
	please_select_record_to_move:"Please select at least one record to move!",
	please_set_issus_scope : "Please select Publish range",
	please_select_issus_space : "Please select Bulletin Board"

}