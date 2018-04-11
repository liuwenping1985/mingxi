<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/plan/planInterface.js.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/taskmanage/taskInterface.js.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/calendar/event/calEvent_Dialog_js.jsp"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>layout</title>
	<style>
	.stadic_head_height { height: 240px;}
	.stadic_body_top_bottom {bottom: 0px; top: 400px;}
	.vGrip { display: none;}
	</style>
	<script type="text/javascript">
		var planDetailTable;
		var myReferPlanTable;
		var createTimeForTrTitle;
		var updateTimeForTrTitle;
		var curTransParams = {
			searchFunc : search,
			diaClose : viewDialogClose,
			showButton : showBtn,
			isHasConVal : "Yes"
		};
	
		var initTable = function(type, toPage) {
			var detail = $("#planDetail").ajaxgridLoad('${dataId}');
			var mine = $("#referPlanList").ajaxgridLoad('${dataId}');
		}
		var initTableForReferPlan = function() {
			var mine = $("#referPlanList").ajaxgridLoad('${dataId}');
		}
		var initTableForTask = function() {
			var taskinfo = $("#taskFormPlan").ajaxgridLoad('${dataId}');
		}
		var initTableForCalEvent = function() {
			var calevent = $("#caleventFormPlan").ajaxgridLoad('${dataId}');
		}
		var initPlanTableForCalEvent = function() {
			planDetailTable2 = $("#caleventFormPlan").ajaxgrid({
				usepager : false,
				colModel : [ {
					display : "${ctp:i18n('plan.grid.label.title')}",
					name : 'realSubject',
					width : '33%',
					sortable : true,
					align : 'left'
				}, {
					display : "${ctp:i18n('calendar.event.create.beginDate')}",
					name : 'beginDate',
					width : '20%',
					sortable : true,
					align : 'left'
				}, {
					display : "${ctp:i18n('calendar.event.create.createUserName')}",
					name : 'createUserName',
					width : '20%',
					sortable : true,
					align : 'left'
				}, {
					display : "${ctp:i18n('calendar.event.create.states')}",
					name : 'states',
					width : '15%',
					sortable : true,
					codecfg : "codeType:'java',codeId:'com.seeyon.apps.calendar.enums.StatesEnum'"
				}, {
					display : "${ctp:i18n('calendar.event.create.completeRate')}",
					name : 'completeRate',
					width : '10%',
					sortable : true
				} ],
				vChange : true,
				vChangeParam : {
					overflow : "hidden",
					autoResize : false
				},
				showTableToggleBtn : false,
				slideToggleBtn : false,
				autoResize : false,
				height : "240px",
				managerName : "calEventManager",
				managerMethod : "getCalEventByRecordId",
				click : showPlan,
				render : rend,
				parentId : 'tab1_div'
			});
		}
		var initPlanTableForTask = function() {
			planDetailTable1 = $("#taskFormPlan").ajaxgrid({
				usepager : false,
				colModel : [ {
					display : "${ctp:i18n('plan.grid.label.title')}",
					name : 'subject',
					width : '38%',
					sortable : true,
					align : 'left'
				}, {
					display : "${ctp:i18n('taskmanage.manager')}",
					name : 'managerNames',
					width : '16%',
					sortable : true,
					align : 'left'
				}, {
					display : "${ctp:i18n('taskmanage.starttime')}",
					name : 'plannedStartTime',
					width : '12%',
					sortable : true,
					align : 'left'
				}, {
					display : "${ctp:i18n('common.date.endtime.label')}",
					name : 'plannedEndTime',
					width : '12%',
					sortable : true,
					align : 'left'
				}, {
					display : "${ctp:i18n('common.state.label')}",
					name : 'status',
					width : '10%',
					sortable : true,
					align : 'left',
					codecfg : "codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.TaskStatus'"
				}, {
					display : "${ctp:i18n('taskmanage.finishrate')}",
					name : 'finishRate',
					width : '10%',
					sortable : true,
					align : 'left'
				} ],
				vChange : true,
				vChangeParam : {
					overflow : "hidden",
					autoResize : false
				},
				showTableToggleBtn : false,
				slideToggleBtn : false,
				autoResize : false,
				height : "240px",
				managerName : "taskAjaxManager",
				managerMethod : "findTaskBySourceId",
				click : showPlan,
				render : rendforTask,
				parentId : 'tab1_div'
			});
		}
		var initPlanTableForReferPlan = function() {
			referPlanTable = $("#referPlanList").ajaxgrid({
				usepager : false,
				colModel : [ {
					display : "${ctp:i18n('plan.grid.label.title')}",
					name : 'title',
					width : '32%',
					sortable : true,
					align : 'left'
				}, {
					display : "${ctp:i18n('plan.grid.label.creator')}",
					name : 'createUserName',
					width : '18%',
					sortable : true,
					align : 'left'
				}, {
					display : "${ctp:i18n('plan.desc.viewreferinfo.plansendtime')}",
					name : 'createTime',
					width : '18%',
					sortable : true,
					align : 'left'
				}, {
					display : "${ctp:i18n('plan.desc.viewreferinfo.newmodifytime')}",
					name : 'updateTime',
					width : '18%',
					sortable : true,
					align : 'left'
				}, {
					display : "${ctp:i18n('plan.grid.label.replystatus')}",
					name : "process",
					width : '14%',
					sortable : true,
					align : 'left',
					hidden : false,
					codecfg : "codeType:'java',codeId:'com.seeyon.apps.plan.enums.PlanReplyStatusEnum'"
				} ],
				vChange : true,
				vChangeParam : {
					overflow : "hidden",
					autoResize : false
				},
				showTableToggleBtn : false,
				slideToggleBtn : false,
				autoResize : false,
				managerName : "planRefRelationManager",
				managerMethod : "getRefBySourceId",
				click : showPlan,
				render : rend,
				height : 240,
				parentId : "tab1_div"
			});
		}
	
		var initPlanTable = function() {
			if ("${planBO.referType}" == "1") {
				planDetailTable = $("#planDetail").ajaxgrid({
					usepager : false,
					colModel : [ {
						display : "${ctp:i18n('plan.grid.label.title')}",
						name : 'subject',
						width : '38%',
						sortable : true,
						align : 'left'
					}, {
						display : "${ctp:i18n('taskmanage.manager')}",
						name : 'managerNames',
						width : '16%',
						sortable : true,
						align : 'left'
					}, {
						display : "${ctp:i18n('taskmanage.starttime')}",
						name : 'plannedStartTime',
						width : '12%',
						sortable : true,
						align : 'left'
					}, {
						display : "${ctp:i18n('common.date.endtime.label')}",
						name : 'plannedEndTime',
						width : '12%',
						sortable : true,
						align : 'left'
					}, {
						display : "${ctp:i18n('common.state.label')}",
						name : 'status',
						width : '10%',
						sortable : true,
						align : 'left',
						codecfg : "codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.TaskStatus'"
					}, {
						display : "${ctp:i18n('taskmanage.finishrate')}",
						name : 'finishRate',
						width : '10%',
						sortable : true,
						align : 'left'
					} ],
					vChange : true,
					vChangeParam : {
						overflow : "hidden",
						autoResize : false
					},
					showTableToggleBtn : false,
					slideToggleBtn : false,
					autoResize : false,
					height : "240px",
					managerName : "planRefRelationManager",
					managerMethod : "getSourceBytoId",
					click : showPlan,
					render : rendforTask,
					parentId : "tab1_div"
				});
			} else if ("${planBO.referType}" == "2") {
				planDetailTable = $("#planDetail").ajaxgrid({
					usepager : false,
					colModel : [ {
						display : "${ctp:i18n('plan.column.mt_name')}",
						name : 'title',
						sortable : true,
						width : '35%'
					}, {
						display : "${ctp:i18n('plan.grid.label.creator')}",
						name : 'createUserName',
						sortable : true,
						width : '15%'
					}, {
						display : "${ctp:i18n('plan.grid.label.begintime')}",
						name : 'beginDateStr',
						sortable : true,
						width : '18%'
					}, {
						display : "${ctp:i18n('plan.grid.label.endtime')}",
						name : 'endDateStr',
						sortable : true,
						width : '18%'
					}, {
						display : "${ctp:i18n('plan.label.reply_state')}",
						name : 'replyStateStr',
						sortable : true,
						width : '12%'
					} ],
					click : showPlan,
					parentId : "tab1_div",
					managerName : "planRefRelationManager",
					managerMethod : "getSourceBytoId",
					render : rendForMeeting,
					onSuccess : successFunc
				});
			} else {
				planDetailTable = $("#planDetail").ajaxgrid({
					usepager : false,
					colModel : [ {
						display : "${ctp:i18n('plan.grid.label.title')}",
						name : 'title',
						width : '32%',
						sortable : true,
						align : 'left'
					}, {
						display : "${ctp:i18n('plan.grid.label.creator')}",
						name : 'createUserName',
						width : '18%',
						sortable : true,
						align : 'left'
					}, {
						display : createTimeForTrTitle,
						name : 'createTimeStr',
						width : '18%',
						sortable : true,
						align : 'left'
					}, {
						display : updateTimeForTrTitle,
						name : 'updateTimeStr',
						width : '18%',
						sortable : true,
						align : 'left'
					}, {
						display : "${ctp:i18n('plan.grid.label.replystatus')}",
						name : "process",
						width : '14%',
						sortable : true,
						align : 'left',
						hidden : false,
						codecfg : "codeType:'java',codeId:'com.seeyon.apps.plan.enums.PlanReplyStatusEnum'"
					} ],
					vChange : true,
					vChangeParam : {
						overflow : "hidden",
						autoResize : false
					},
					showTableToggleBtn : false,
					slideToggleBtn : false,
					autoResize : false,
					height : "240px",
					managerName : "planRefRelationManager",
					managerMethod : "getSourceBytoId",
					click : showPlan,
					render : rend,
					parentId : "tab1_div"
				});
			}
		}
	
		function successFunc() {
			if ('${planBO.referType}' == 2) {
				var total = 0;
				$("#planDetail").formobj({
					gridFilter : function(data, row) {
						total = total + 1;
					}
				});
				if (total != 0) {
					$("#source_txt").html("&nbsp;&nbsp;${ctp:i18n('plan.desc.viewreferinfo.planresource')}:${ctp:i18n('plan.desc.viewreferinfo.meeting')}");
				}
			}
		}
	
		var rendforTask = function(txt, data, r, c, col) {
			if (col.name == "subject") {
				return taskNameIconDisplay(txt, data);
			}
			if (col.name == "finishRate") {
				return processFinishRateData(txt, data);
			} else {
				return txt;
			}
		}
		var rendForMeeting = function(text, data, r, c, col) {
			var titleIcon = "";
			if (col.name == "title") {
				titleIcon += text;
				//视频会议图标
				if (data.video == true || data.video == "true") {
					titleIcon += "<span class='ico16 bodyType_videoConf_16'></span>";
				}
				//附件图标
				if (data.hasAttachments == true || data.hasAttachments == "true") {
					titleIcon += "<span class='ico16 affix_16'></span>";
				}
				//正文内容图片
				if (data.contentType == "OfficeWord") {
					titleIcon += "<span class='ico16 doc_16'></span>";
				} else if (data.contentType == "OfficeExcel") {
					titleIcon += "<span class='ico16 xls_16'></span>";
				} else if (data.contentType == "WpsWord") {
					titleIcon += "<span class='ico16 wps_16'></span>";
				} else if (data.contentType == "WpsExcel") {
					titleIcon += "<span class='ico16 xls2_16'></span>";
				}
				return titleIcon;
			}
			return text;
		}
		var rend = function(txt, data, r, c, col) {
			if (col.name == 'createUserId') {
				txt = "${ctp:showMemberName(data.createUserId)}";
				return txt;
			}
			if (col.name == 'title') {
				txt = txt + "&nbsp;" + data.viewTitle;
				if (data.hasAttatchment == true) {
					txt = txt + "<span class='ico16 affix_16'></span>";
				}
				return txt;
			}
			if (col.name == 'subject') {
				if (data.calEvent.attachmentsFlag == true) {
					txt = txt.replace("&lt;span&nbsp;class=&#039;ico16&nbsp;affix_16&nbsp;margin_l_5&#039;&gt;&lt;/span&gt;", "");
					txt = txt + "<span class='ico16 affix_16'></span>";
				}
				txt = txt.replace(new RegExp("&amp;nbsp;", "gm"), " ");
				return txt;
			}
			if (col.name == 'completeRate') {
				txt = "<span class='right margin_l_5' style='width:40px;'>" + txt + "%</span>";
				return txt;
			}
	
			return txt;
		}
		/**
		 * 任务标题中所显示图标处理
		 * @param text 列表显示信息
		 * @param row 列对象
		 */
		function taskNameIconDisplay(text, row) {
			var iconStr = "";
			//重要程度图标
			if (row.importantLevel == "2") {
				iconStr += "<span class='ico16 important_16'></span>";
			} else if (row.importantLevel == "3") {
				iconStr += "<span class='ico16 much_important_16'></span>";
			}
			//里程碑
			if (row.milestone == "1") {
				iconStr += "<span class='ico16 milestone'></span>";
			}
			//风险图标
			if (row.riskLevel == "1") {
				iconStr += "<span class='ico16 l_risk_16'></span>";
			} else if (row.riskLevel == "2") {
				iconStr += "<span class='ico16 risk_16'></span>";
			} else if (row.riskLevel == "3") {
				iconStr += "<span class='ico16 h_risk_16'></span>";
			}
			iconStr += text;
			//附件图标
			if (row.has_attachments == true || row.has_attachments == "true") {
				iconStr += "<span class='ico16 affix_16'></span>";
			}
			return iconStr;
		}
		/**
		 * 对完成率显示内容进行处理
		 * @param text 列表显示信息
		 * @param row 列对象
		 */
		function processFinishRateData(text, row) {
			var percent = parseInt(text);//百分数
			if (text.indexOf("%") == -1) {
				return "<span class='right margin_l_5' style='width:40px;'>" + text + "%</span>";
			} else {
				return "<span class='right margin_l_5' style='width:40px;'>" + text + "</span>";
			}
		}
	
		function openMeeting(meetingId) {
			var dialog = $.dialog({
				url : _ctxPath + "/mtMeeting.do?method=myDetailFrame&id=" + meetingId + "&isQuote=true&proxy=0&proxyId=-1",
				width : $(getCtpTop()).width() - 100,
				height : $(getCtpTop()).height() - 100,
				title : "${ctp:i18n('plan.desc.viewreferinfo.meeting')}",
				targetWindow : getCtpTop(),
				buttons : [ {
					text : "${ctp:i18n('common.button.close.label')}",
					handler : function() {
						dialog.close();
					}
				} ]
			});
		}
	
		var showPlan = function(data, r, c) {
			if (data.planStatus) {
				//打开计划
				openPlan(data.id, function() {
				}, true, false, function() {
				}, true);
			} else if (typeof (data.calEvent) != "undefined") {
				if (data.calEvent.id != "") {
					//打开事件	
					dblclk(data, r, c);
				}
			} else if (data.meetingIdStr != undefined && data.meetingIdStr != "") {
				openMeeting(data.meetingIdStr);
			} else {
				//打开任务
				viewTaskInfo(data.id, 0, 1);
			}
		}
		var referTitle;
		var isLoadCalEvent = false;
		var isLoadTask = false;
		var isLoadReferPlan = false;
	
		function initForCalEvent() {
			//if(!isLoadCalEvent){
			initPlanTableForCalEvent();
			initTableForCalEvent();
			//isLoadCalEvent = true;
			//}
		}
	
		function initForTask() {
			//if(!isLoadTask){
			initPlanTableForTask();
			initTableForTask();
			//isLoadTask = true;
			//}
		}
	
		function initForReferPlan() {
			//if(!isLoadReferPlan){
			initPlanTableForReferPlan();
			initTableForReferPlan();
			//isLoadReferPlan = true;
			//}
		}
		$(function() {
			if ('${planBO.referType}' == 1) {
				//任务
				createTimeForTrTitle = "${ctp:i18n('plan.grid.label.begintime')}";
				updateTimeForTrTitle = "${ctp:i18n('plan.grid.label.endtime')}";
			} else {
				createTimeForTrTitle = "${ctp:i18n('plan.desc.viewreferinfo.plansendtime')}";
				updateTimeForTrTitle = "${ctp:i18n('plan.desc.viewreferinfo.newmodifytime')}";
			}
			initPlanTable();
			initTable();
			if ('${planBO.referType}' == 2) {
				$("#source_txt").html("&nbsp;&nbsp;${ctp:i18n('plan.desc.viewreferinfo.planresource')}:${ctp:i18n('plan.desc.viewreferinfo.nothing')}");
			}
		});
	</script>
</head>
<body class="h100b over_hidden font_size12">

	<div id="tabs2" class="comp" comp="type:'tab',width:585,height:350">
		<div id="tabs2_head" class="common_tabs clearfix">
			<ul class="left">
				<li class="current"><a href="javascript:initTable()" class="no_b_border" tgt="tab1_div"><span>${ctp:i18n('plan.label.reference.referencesource')}</span></a></li>
				<li><a href="javascript:initForReferPlan()" class="no_b_border" tgt="tab2_div"><span>${ctp:i18n('plan.label.reference.referenced')}</span></a></li>
				<li><a href="javascript:initForTask()" class="no_b_border" tgt="tab3_div"><span>${ctp:i18n('plan.alert.plandetail.transfertask')}</span></a></li>
				<li><a href="javascript:initForCalEvent()" tgt="tab4_div" class="no_b_border last_tab"><span>${ctp:i18n('plan.alert.plandetail.transferevent')}</span></a></li>
			</ul>
		</div>
		<div id="tabs2_body" class="common_tabs_body   border_all">
			<div id="tab1_div" class="margin_t_5">
				<div class="margin_b_5">
					<label for="text" id="source_txt">&nbsp;&nbsp;${ctp:i18n('plan.desc.viewreferinfo.planresource')}:<c:if test="${planBO.referType==1}">${ctp:i18n('plan.desc.viewreferinfo.task')}</c:if>
						<c:if test="${planBO.referType==0}">${ctp:i18n('plan.module.name')}</c:if>
						<c:if test="${planBO.referType==2}">${ctp:i18n('plan.desc.viewreferinfo.meeting')}</c:if>
						<c:if test="${planBO.referType==-1}">${ctp:i18n('plan.desc.viewreferinfo.nothing')}</c:if></label>
				</div>
				<table id="planDetail" class="font_size12 "></table>
			</div>
			<div id="tab2_div" class="hidden margin_t_5">
				<div class="margin_b_5">
					<label for="text">&nbsp;&nbsp;${ctp:i18n('plan.desc.viewreferinfo.planresourced')}</label>
				</div>
				<table id="referPlanList" class="font_size12"></table>

			</div>
			<div id="tab3_div" class="hidden margin_t_5">
				<div class="margin_b_5">
					<label for="text">&nbsp;&nbsp;${ctp:i18n('plan.trans.taskinfotranslist')}</label>
				</div>
				<table id="taskFormPlan" class="font_size12 "></table>
			</div>
			<div id="tab4_div" class="hidden margin_t_5">
				<div class="margin_b_5">
					<label for="text">&nbsp;&nbsp;${ctp:i18n('plan.trans.eventtranslist')}</label>
				</div>
				<table id="caleventFormPlan" class="font_size12 "></table>
			</div>
		</div>
	</div>
	<!--
    <div class="stadic_layout font_size12" layout="sprit:false">
        <div class="font_size12 margin_t_5" style="height:100px">
            <div class="margin_b_5"><label for="text">&nbsp;&nbsp;${ctp:i18n('plan.desc.viewreferinfo.planresource')}:<c:if test="${planBO.referType==1}">${ctp:i18n('plan.desc.viewreferinfo.task')}</c:if><c:if test="${planBO.referType==0}">${ctp:i18n('plan.module.name')}</c:if><c:if test="${planBO.referType==-1}">${ctp:i18n('plan.desc.viewreferinfo.nothing')}</c:if></label></div>
            <table id="planDetail" class="font_size12 "></table>
        </div>
		<div class="stadic_layout font_size12" layout="sprit:false">
			<div class="font_size12 stadic_body_top_bottoms" style="height:100px">
				<div class="margin_b_5">
			        <label for="text">&nbsp;&nbsp;${ctp:i18n('plan.trans.taskinfotranslist')}</label>
			    </div>
				<table id="taskFormPlan" class="font_size12 "></table>
			</div>
		</div>
		
		<div class="stadic_layout font_size12" layout="sprit:false">
			<div class="font_size12 stadic_body_top_bottoms" style="height:100px">
				<div class="margin_b_5">
					<label for="text">&nbsp;&nbsp;${ctp:i18n('plan.trans.eventtranslist')}</label>
				</div>
			    <table id="caleventFormPlan" class="font_size12 "></table>
			</div>
		</div>
        <div class="stadic_body_top_bottom font_size12" >
            <div class="margin_b_5"><label for="text">&nbsp;&nbsp;${ctp:i18n('plan.desc.viewreferinfo.planresourced')}</label></div>
            <table id="referPlanList" class="font_size12"></table>
        </div>
		
    </div>  
      -->
</body>
</html>
