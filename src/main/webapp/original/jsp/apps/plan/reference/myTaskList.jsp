<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/plan/reference/planReferList.js.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/taskmanage/taskInterface.js.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<script type="text/javascript">
	var toolbar = null;
	var searchobj = null;
	function initToolBar() {
		toolbar = $("#toolbar").toolbar({
			toolbar : [ {
				id : "personal",
				name : "${ctp:i18n('taskmanage.personal.label')}",
				className : "ico16 personal_tasks_16",
				click : function() {
					chooseTaskList('Personal');
				}
			}, {
				id : "sent",
				name : "${ctp:i18n('taskmanage.sent.label')}",
				className : "ico16 has_been_distributed_16",
				click : function() {
					chooseTaskList('Sent');
				}
			} ]
		});
		selectedBtnByTaskType('Personal');
	}

	/**
	 * 初始化搜索框
	 */
	function initSearchDiv() {
		var taskAjax = new taskAjaxManager();
		var taskRoles = taskAjax.findAllTaskRole();
		//任务查询过滤条件
		var conditions = [ {
			id : 'subject',
			name : 'subject',
			type : 'input',
			text : $.i18n('common.subject.label'),
			value : 'subject'
		}, {
			id : 'timeParagraph',
			name : 'timeParagraph',
			type : 'datemulti',
			text : $.i18n('taskmanage.search.time.paragraph'),
			value : 'timeParagraph',
			ifFormat : "%Y-%m-%d",
			dateTime : false
		}, {
			id : 'plannedStartTime',
			name : 'plannedStartTime',
			type : 'datemulti',
			text : $.i18n('taskmanage.starttime'),
			value : 'plannedStartTime',
			ifFormat : "%Y-%m-%d",
			dateTime : false
		}, {
			id : 'plannedEndTime',
			name : 'plannedEndTime',
			type : 'datemulti',
			text : $.i18n('common.date.endtime.label'),
			value : 'plannedEndTime',
			ifFormat : "%Y-%m-%d",
			dateTime : false
		}, {
			id : 'importantLevel',
			name : 'importantLevel',
			type : 'select',
			text : $.i18n('common.importance.label'),
			value : 'importantLevel',
			codecfg : "codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.ImportantLevelEnums'"
		}, {
			id : 'statusselect',
			name : 'statusselect',
			type : 'select',
			text : "${ctp:i18n('taskmanage.status')}",
			value : 'status',
			items : [ {
				text : "${ctp:i18n('taskmanage.status.unfinished')}",
				value : '-2'
			}, {
				text : "${ctp:i18n('taskmanage.status.notstarted')}",
				value : '1'
			}, {
				text : "${ctp:i18n('taskmanage.status.marching')}",
				value : '2'
			}, {
				text : "${ctp:i18n('taskmanage.overdue.yes')}",
				value : '6'
			} ]
		}, {
			id : 'riskLevel',
			name : 'riskLevel',
			type : 'select',
			text : $.i18n('taskmanage.risk'),
			value : 'riskLevel',
			codecfg : "codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.RiskEnums'"
		} ];
		//任务的角色筛选条件拼接
		for (var i = 0; i < taskRoles.length; i++) {
			//canView":true,"canUpdate":false,"canHasten":false,"roleName":"参与人","canFeedback":true,"canDelete":false,"roleType":"2"
			conditions.push({
				id : "roleType_" + taskRoles[i].roleType,
				name : "roleType_" + taskRoles[i].roleType,
				type : 'input',
				text : taskRoles[i].roleName,
				value : "roleType_" + taskRoles[i].roleType
			});
		}
		conditions.push({
			id : 'milestoneselect',
			name : 'milestoneselect',
			type : 'select',
			text : $.i18n('taskmanage.milestone.label'),
			value : 'milestone',
			items : [ {
				text : $.i18n('taskmanage.detail.yes.label'),
				value : '1'
			}, {
				text : $.i18n('taskmanage.detail.no.label'),
				value : '0'
			} ]
		});
		//生成筛选条件区域
		searchobj = $.searchCondition({
			top : 2,
			right : 10,
			searchHandler : doSearch,
			conditions : conditions
		});
		searchobj.g.setCondition('statusselect', '-2');
	}
	function doSearch() {
		var val = searchobj.g.getReturnValue();
		var queryParams = {};
		if (val != null) {
			var condition = val.condition;
			var value = val.value;
			//处理查询参数
			if (condition == "plannedStartTime" || condition == "plannedEndTime" || condition == "timeParagraph") {
				//计划开始时间 | 计划结束时间
				queryParams.queryType = condition;
				if (value.length > 0) {
					queryParams.startDate = value[0];
					queryParams.endDate = value[1];
				}
			} else if (/roleType_\d/gi.test(condition)) {
				queryParams.queryType = "roleType";
				queryParams.roleType = condition.split("_")[1];
				queryParams.value = value;
			} else if (condition != "") {
				queryParams.queryType = condition;
				queryParams.value = value;
			}
			queryParams.listType = $("#list_type").val();
			$("#taskInfoList").ajaxgridLoad(queryParams);
		}
	}

	/**
	 * 初始化任务里列表数据
	 */
	/* function initData() {
		initListData();
	} */

	/**
	 * 初始化列表数据
	 */
	function initListData() {
		listDataObj = $("#taskInfoList").ajaxgrid({
			render : render,
			resizable : false,
			colModel : [ {
				display : 'id',
				name : 'id',
				width : '5%',
				align : 'center',
				type : 'checkbox'
			}, {
				display : "${ctp:i18n('common.subject.label')}",
				name : 'subject',
				sortable : true,
				width : '25%'
			}, {
				display : "${ctp:i18n('taskmanage.weight')}",
				name : 'weight',
				sortable : true,
				width : '5%'
			}, {
				display : "${ctp:i18n('common.state.label')}",
				name : 'status',
				width : '8%',
				sortable : true,
				codecfg : "codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.TaskStatus'"
			}, {
				display : "${ctp:i18n('taskmanage.finishrate')}",
				name : 'finishRate',
				sortable : true,
				sortType : 'number',
				width : '18%'
			}, {
				display : "${ctp:i18n('common.date.begindate.label')}",
				name : 'plannedStartTime',
				sortable : true,
				width : '12%'
			}, {
				display : "${ctp:i18n('common.date.enddate.label')}",
				name : 'plannedEndTime',
				sortable : true,
				width : '12%'
			}, {
				display : "${ctp:i18n('taskmanage.manager')}",
				name : 'managerNames',
				sortable : true,
				width : '14%'
			} ],
			dblclick : doubleClickEvent,
			onSuccess : bindCheckBoxEvent,
			parentId : $('.layout_center').eq(0).attr('id'),
			managerName : "taskAjaxManager",
			managerMethod : "findTasksByPlan",
			sortname : "createTime",
			sortorder : "desc"
		});
		doSearch();
	}
	function doubleClickEvent(data, r, c) {
		viewTaskInfo(data.id, 0, 1);
	}
	function render(text, row, rowIndex, colIndex, col) {
		if (col.name == "subject") {
			return taskNameIconDisplay(text, row);
		}
		if (col.name == "finishRate") {
			return processFinishRateData(text, row);
		} else {
			return text;
		}
	}
	function processFinishRateData(text, row) {
		var percent = parseInt(text);//百分数
		var color_class = "rate_process";
		if (row.status == "4")
			color_class = "rate_filish"; //已完成
		if (row.status == "3")
			color_class = "rate_delay"; //已延期
		if (row.status == "5")
			color_class = "rate_canel"; //已取消
		return "<span class='right margin_l_5' style='width:40px;'>" + text + "%</span><p class='task_rate adapt_w' style=''><a href='#' class='" + color_class + "' style='width:" + percent + "%;'></a></p>";
	}

	function taskNameIconDisplay(text, row) {
		var iconStr = "";
		//根节点图标
		if (row.haschild == true && row.ischild != true) {
			iconStr += "<span root='true' class='ico16 table_add_16' onclick='toggleTree(this)' parentId='" + row.id + "' index='" + row.index + "'> </span>";
		}
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
		//判断是否是子节点
		if (row.ischild == true) {
			var index;
			if (row.index > 0) {
				index = row.index - 1;
			} else {
				index = row.index;
			}
			var margin = index * 20 + "px";
			if (row.haschild == true) {//判断是否存在二级子节点
				iconStr = "<a href='javascript:void(0)' class='row" + row.parentId + " treeNode' style='margin-left:" + margin + ";'><span class='ico16 table_add_16' onclick='toggleTree(this)' parentId='" + row.id + "' index='" + row.index + "'> </span>" + iconStr + "</a>";
			} else {
				iconStr = "<a href='javascript:void(0)'  class='row" + row.parentId + " treeNode' style='margin-left:" + margin + ";'>" + iconStr + "</a>";
			}
		}
		return iconStr;
	}

	/**
	 * 根据任务类型选中对应类型按钮
	 * @param taskType 任务类型
	 */
	function selectedBtnByTaskType(taskType) {
		if (taskType == "Personal") {
			toolbar.selected("personal");
			toolbar.unselected("sent");
		} else {
			toolbar.unselected("personal");
			toolbar.selected("sent");
		}
		$("#list_type").val(taskType);
	}

	/**
	 * 根据任务类型选择任务的显示内容
	 * @param type 任务类型
	 */
	function chooseTaskList(type) {
		selectedBtnByTaskType(type);
		doSearch();
	}
</script>

<script type="text/javascript">
	$(document).ready(function() {
		initSearchDiv();
		initToolBar();
		initListData();
	});
</script>
<body>
	<div id='layout' class="comp page_color" comp="type:'layout'">
		<div id="north" class="layout_north" layout="height:30,sprit:false,border:false">
			<input type="hidden" id="list_type" name="list_type" />
			<div id="toolbar"></div>
		</div>
		<div id="center" class="layout_center page_color over_hidden" layout="border:false">
			<table id="taskInfoList" class="flexme3" style="display: none"></table>
		</div>
	</div>
</body>
</html>