<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>督办列表</title>
<script type="text/javascript"
    src="${path}/ajax.do?managerName=colManager,superviseManager,traceWorkflowManager"></script>
<script type="text/javascript" charset="UTF-8"
    src="${path}/apps_res/collaboration/js/collaboration.js${ctp:resSuffix()}"></script>
<script text="text/javascript">
var secretLevelList = '${secretLevelList}';
var arr = new Array();
arr = eval("(" + secretLevelList + ")");
var secretLevelOptions = new Array();
for(var i = 0; i<arr.length; i++){
	secretLevelOptions[i] = {text:arr[i].label,value:arr[i].value};
}
	//显示流程图
	var isShowRecord = false;
	function showFlowChart(_contextCaseId, _contextProcessId, _templateId,
			_contextActivityId, appType) {
		var showHastenButton = 'true';
		var supervisorsId = "";
		var isTemplate = false;
		var operationId = "";
		var senderName = "";
		var openType = getA8Top();
		if (_templateId && "undefined" != _templateId) {
			isTemplate = true;
		}
		showWFCDiagram(openType, _contextCaseId, _contextProcessId, isTemplate,
				showHastenButton, supervisorsId, window, appType, false,
				_contextActivityId, operationId, null, senderName);
	}
	var recordType = '${recordType}';
	var grid;
	$(function() {
		var app = "${ctp:escapeJavascript(param.app)}";
		//初始化布局
		new MxtLayout({
			'id' : 'layout',
			'northArea' : {
				'id' : 'north',
				'height' : 30,
				'sprit' : false,
				'border' : false
			},
			'centerArea' : {
				'id' : 'center',
				'border' : false,
				'minHeight' : 20
			}
		});

		//工具栏
		var toolbars = $("#toolbars")
				.toolbar(
						{
							borderTop : false,
							borderLeft : false,
							borderRight : false,
							toolbar : [
									{
										id : "listPending",
										name : "${ctp:i18n('common.toolbar.transacted.without.label')}",//未办结
										className : "ico16 no_through_ico_16",
										selected : true,
										click : listPending
									},
									{
										id : "listDone",
										name : "${ctp:i18n('common.toolbar.transacted.done.label')}",//已办结
										className : "ico16 gone_through_16",
										click : listDone
									},
									{
										id : "repealRecord",
										name : "${ctp:i18n('collaboration.workflow.label.repeal')}",//撤销记录
										className : "ico16 revoked_process_16 ",
										click : listRepealRecord
									},
									{
										id : "stepbackRecord",
										name : "${ctp:i18n('collaboration.workflow.label.stepback')}",//回退记录
										className : "ico16 toback_16 ",
										click : listSBRecord
									},
									{
										id : "handling",
										name : "${ctp:i18n('common.toolbar.showAffair.label')}",//办理情况
										className : "ico16 handling_16",
										click : handling
									},
									<%--{--%>
										<%--id : "archivedModifyHistory",--%>
										<%--name : "${ctp:i18n('common.toolbar.edocArchiveModifyHistory.label')}",//归档公文修改日志--%>
										<%--className : "ico16 revision_history_16",--%>
										<%--click : showArchiveModifyLog_iframe--%>
									<%--},--%>
									{
										id : "deleteSupervise",
										name : "${ctp:i18n('common.button.delete.label')}",//删除
										className : "ico16 del_16",
										click : deleteSupervise
									} ]
						});
		//搜索框
		var searchobj;
		if (app != '4') {
			searchobj = $
					.searchCondition({
						top : 2,
						right : 10,
						searchHandler : function() {
							searchFunc();
						},
						conditions : [
								{
									id : 'title',
									name : 'title',
									type : 'input',
									text : '${ctp:i18n("cannel.display.column.subject.label")}',//标题
									value : 'title'
								},
								{
									id : 'importantLevel',
									name : 'importantLevel',
									type : 'select',
									text : '${ctp:i18n("common.importance.label")}',//重要程度
									value : 'importantLevel',
									items : [
											{
												text : '${ctp:i18n("common.importance.putong")}',//普通
												value : '1'
											},
											{
												text : '${ctp:i18n("common.importance.zhongyao")}',//重要
												value : '2'
											},
											{
												text : '${ctp:i18n("common.importance.feichangzhongyao")}',//非常重要
												value : '3'
											} ]
								},
								{
									id : 'sender',
									name : 'sender',
									type : 'input',
									text : '${ctp:i18n("common.sender.label")}',//发起人
									value : 'sender'
								},
								{
									id : 'sendDate',
									name : 'sendDate',
									type : 'datemulti',
									text : '${ctp:i18n("common.date.sendtime.label")}',//发起时间
									value : 'sendDate',
									ifFormat : '%Y-%m-%d',
									dateTime : false
								},{
						        	id:'deadlineDatetime',
						        	name:'deadlineDatetime',
						        	type:'datemulti',
						        	text:$.i18n("collaboration.process.cycle.label"), //流程期限
						        	value:'deadlineDatetime',
						        	ifFormat:'%Y-%m-%d',
						        	dateTime:false
						        }]
					});
		} else {
			searchobj = $
					.searchCondition({
						top : 2,
						right : 10,
						searchHandler : function() {
							searchFunc();
						},
						conditions : [
								{
									id : 'title',
									name : 'title',
									type : 'input',
									text : '${ctp:i18n("edoc.supervise.title")}',//公文标题
									value : 'title'
								},
								{
									id : 'docMark',
									name : 'docMark',
									type : 'input',
									text : '${ctp:i18n("edoc.element.wordno.label")}',//公文文号
									value : 'docMark'
								},
								{
									id : 'docInMark',
									name : 'docInMark',
									type : 'input',
									text : '${ctp:i18n("edoc.element.wordinno.label")}',//内部文号
									value : 'docInMark'
								},
								{
									id : 'sender',
									name : 'sender',
									type : 'input',
									text : '${ctp:i18n("common.sender.label")}',//发起人
									value : 'sender'
								},
								{
									id : 'sendDate',
									name : 'sendDate',
									type : 'datemulti',
									text : '${ctp:i18n("common.date.sendtime.label")}',//发起时间
									value : 'sendDate',
									ifFormat : '%Y-%m-%d',
									dateTime : false
								},
								{
									id : 'supervisors',
									name : 'supervisors',
									type : 'input',
									text : '${ctp:i18n("edoc.supervise.supervisor")}',//督办人
									value : 'supervisors'
								},
								{
									id : 'awakeDate',
									name : 'awakeDate',
									type : 'datemulti',
									text : '${ctp:i18n("edoc.supervise.deadline")}',//督办期限
									value : 'awakeDate'
								}/* ,
								{//根据国家行政公文规范,去掉主题词
									id : 'keywords',
									name : 'keywords',
									type : 'input',
									text : '${ctp:i18n("edoc.element.keyword")}',//主题词
									value : 'keywords'
								} */,
								{
									id : 'secretLevel',
									name : 'secretLevel',
									type : 'select',
									text : '${ctp:i18n("edoc.element.secretlevel.simple")}',//密级
									value : 'secretLevel',
									items : secretLevelOptions
								},
								{
									id : 'urgentLevel',
									name : 'urgentLevel',
									type : 'select',
									text : '${ctp:i18n("edoc.element.urgentlevel")}',//紧急程度
									value : 'urgentLevel',
									items : [
											{
												text : '${ctp:i18n("edoc.urgentlevel.commonexigency")}',//普通
												value : '1'
											},
											{
												text : '${ctp:i18n("collaboration.pending.exigencyNames4")}',//平急
												value : '2'
											},
											{
												text : '${ctp:i18n("collaboration.pending.exigencyNames2")}',//加急
												value : '3'
											},
											{
												text : '${ctp:i18n("collaboration.pending.exigencyNames1")}',//特急
												value : '4'
											},
											{
												text : '${ctp:i18n("collaboration.pending.exigencyNames3")}',//特提
												value : '5'
											} ]
								},{
						        	id:'deadlineDatetime',
						        	name:'deadlineDatetime',
						        	type:'datemulti',
						        	text:$.i18n("collaboration.process.cycle.label"), //流程期限
						        	value:'deadlineDatetime',
						        	ifFormat:'%Y-%m-%d',
						        	dateTime:false
						        },{
						        	id:'edocType',
						        	name:'edocType',
						            type:'select',
						            text : "${ctp:i18n('edoc.sorttype.label')}",//类别
						            value : 'edocType',
						            items : [
	                                            {
	                                                text : "${ctp:i18n('edoc.docmark.inner.send')}",//发文
	                                                value : '0'
	                                            },
	                                            {
	                                                text : "${ctp:i18n('edoc.docmark.inner.receive')}",//收文
	                                                value : '1'
	                                            } ,
	                                            {
	                                                text : "${ctp:i18n('edoc.docmark.inner.signandreport')}",//签报
	                                                value : '2'
	                                            }]
							    } ]
					});
		}

		//搜索框执行的动作
		function searchFunc(flag) {
			if(grid.p.total == 1 && flag){
				window.location.reload();
				return;
			}
			var o = new Object();
			var choose = $('#' + searchobj.p.id).find("option:selected").val();
			if (app != '4') { //协同
				if (choose === 'title') {
					o.title = $('#title').val();
				} else if (choose === 'importantLevel') {
					o.importantLevel = $('#importantLevel').val();
				} else if (choose === 'sender') {
					o.sender = $('#sender').val();
				} else if (choose === 'sendDate') {
					var fromDate = $('#from_' + choose).val();
					var toDate = $('#to_' + choose).val();
					o.sendDate = '';
					o.begin_sendDate = fromDate;
					o.end_sendDate = toDate;
				}else if(choose === 'deadlineDatetime'){//流程期限
			        var fromDate =  $('#from_' + choose).val();
			        var toDate = $('#to_' + choose).val();
			        o.deadlineDatetime = '';
			        o.begin_deadlineDatetime = fromDate;
					o.end_deadlineDatetime = toDate;
					 if(fromDate != "" && toDate != "" && fromDate > toDate){
			            $.alert($.i18n('collaboration.rule.date'));//开始时间不能早于结束时间
			            return;
			        }
					}
				var val = searchobj.g.getReturnValue();
				if(window.location.href.indexOf("condition=templeteAll&templeteAll=templeteAll")!= -1){
		               o.templeteAll = "templeteAll";
		        }
				if (val !== null) {
					o.status = $('#status').val();
					o.app = "${ctp:escapeJavascript(param.app)}";
					o.templeteIds = "${ctp:escapeJavascript(param.templeteIds)}";
					$("#superviseList").ajaxgridLoad(o);
				}
			} else {
				//公文
				if (choose === 'title') {
					o.title = $('#title').val();
				} else if (choose === 'docMark') {
					o.docMark = $('#docMark').val();
				} else if (choose === 'docInMark') {
					o.docInMark = $('#docInMark').val();
				} else if (choose === 'sender') {
					o.sender = $('#sender').val();
				} else if (choose === 'sendDate') {
					var fromDate = $('#from_' + choose).val();
					var toDate = $('#to_' + choose).val();
					o.sendDate = '';
					o.begin_sendDate = fromDate;
					o.end_sendDate = toDate;
				} else if (choose === 'supervisors') {
					o.supervisors = $('#supervisors').val();
				} else if (choose === 'awakeDate') {
					var fromDate = $('#from_' + choose).val();
					var toDate = $('#to_' + choose).val();
					o.awakeDate = '';
					o.begin_awakeDate = fromDate;
					o.end_awakeDate = toDate;
				} else if (choose === 'keywords') {
					o.keywords = $('#keywords').val();
				} else if (choose === 'secretLevel') {
					o.secretLevel = $('#secretLevel').val();
				} else if (choose === 'urgentLevel') {
					o.urgentLevel = $('#urgentLevel').val();
				}else if(choose === 'deadlineDatetime'){//流程期限
					var fromDate =  $('#from_' + choose).val();
			        var toDate = $('#to_' + choose).val();
			        var date = fromDate+'#'+toDate;
			        o.deadlineDatetime = '';
			        o.begin_deadlineDatetime = fromDate;
					o.end_deadlineDatetime = toDate;
			        if(fromDate != "" && toDate != "" && fromDate > toDate){
			            $.alert($.i18n('collaboration.rule.date'));//开始时间不能早于结束时间
			            return;
			        }
				}else if(choose === 'edocType'){
					o.edocType = $('#edocType').val();
				}
				var val = searchobj.g.getReturnValue();
				if (val !== null) {
					o.status = $('#status').val();
					o.app = "${ctp:escapeJavascript(param.app)}";
					o.templeteIds = "${ctp:escapeJavascript(param.templeteIds)}";
					$("#superviseList").ajaxgridLoad(o);
				}
			}
		}
		//定义列表栏
		var colModel = new Array();
		colModel.push({
			display : 'id',
			name : 'id',
			width : '4%',
			sortable : false,
			type : 'checkbox'
		});
		if (app != '4') {
			var width = '36%';
			if ("${ctp:escapeJavascript(param.status)}" == '1') {
				width = '40%';
			}
			//标题
			colModel.push({
				display : "${ctp:i18n('supervise.subject.label')}",
				name : 'title',
				width : width,
				sortable : true
			});
			//发起人
			colModel.push({
				display : "${ctp:i18n('supervise.sender.label')}",
				name : 'senderName',
				width : '7%',
				sortable : true
			});
			//发起时间
			colModel.push({
				display : "${ctp:i18n('supervise.date.sendtime.label')}",
				name : 'sendDate',
				width : '10%',
				cutsize : 10,
				sortable : true
			});
			if ("${ctp:escapeJavascript(param.status)}" == '0' || "${ctp:escapeJavascript(param.status)}" == '') {//未办结
				//当前处理人信息
				colModel
						.push({
							display : "${ctp:i18n('collaboration.list.currentNodesInfo.label')}",
							name : 'currentNodesInfo',
							width : '10%',
							sortable : true
						});
			}
			//流程期限
			colModel.push({
				display : "${ctp:i18n('supervise.process.cycle.label')}",
				name : 'deadlineName',
				width : '11%',
				sortable : true
			});
			//督办期限
			colModel.push({
				display : "${ctp:i18n('supervise.col.deadline')}",
				name : 'awakeDate',
				width : '10%',
				sortable : true
			});
			//催办
			colModel.push({
				display : "${ctp:i18n('supervise.hasten.label')}",
				name : 'count',
				width : '11%',
				sortable : true
			});
			//已办结 没有'流程'
			if ("${ctp:escapeJavascript(param.status)}" !== '1') {
				//流程
				colModel.push({
					display : "${ctp:i18n('supervise.form.bind.flow.label')}",
					name : 'processDescBy',
					width : '4%'
				});
			}
			//督办摘要
			colModel.push({
				display : "${ctp:i18n('supervise.col.description')}",
				name : 'description',
				width : '6%'
			});
		} else {
			var width = '22%';
			if ("${ctp:escapeJavascript(param.status)}" == '1') {
				width = '26%';
			}
			//公文类别
			colModel.push({
				display : "${ctp:i18n('edoc.sorttype.label')}",
				name : 'appName',
				width : '7%',
				sortable : true
			});
			//文件标题
			var titleLength = "28%";
			if ("${ctp:getSystemProperty('edoc.isG6')}" == "true") {
				titleLength = "20%";
			}
			colModel.push({
				display : "${ctp:i18n('edoc.supervise.title')}",
				name : 'title',
				width : titleLength,
				sortable : true
			});
			//发起人
			colModel.push({
				display : "${ctp:i18n('supervise.sender.label')}",
				name : 'senderName',
				width : '9%',
				sortable : true
			});
			//发起时间
			colModel.push({
				display : "${ctp:i18n('supervise.date.sendtime.label')}",
				name : 'sendDate',
				width : '10%',
				cutsize : 10,
				sortable : true
			});

			if ("${ctp:escapeJavascript(param.status)}" == '0' || "${ctp:escapeJavascript(param.status)}" == '') {//未办结
				//当前处理人信息
				colModel
						.push({
							display : "${ctp:i18n('collaboration.list.currentNodesInfo.label')}",
							name : 'currentNodesInfo',
							width : '10%',
							sortable : true
						});
			}
			//督办人
			colModel.push({
				display : "${ctp:i18n('edoc.supervise.supervisor')}",
				name : 'supervisors',
				width : '10%',
				cutsize : 10,
				sortable : true
			});
			//流程期限
			colModel.push({
				display : "${ctp:i18n('supervise.process.cycle.label')}",
				name : 'deadlineName',
				width : '10%',
				sortable : true
			});
			//督办期限
			colModel.push({
				display : "${ctp:i18n('supervise.col.deadline')}",
				name : 'awakeDate',
				width : '12%',
				sortable : true
			});
			//催办
			colModel.push({
				display : "${ctp:i18n('supervise.hasten.label')}",
				name : 'count',
				width : '9%',
				sortable : true
			});
			//已办结 没有'流程'
			if ("${ctp:escapeJavascript(param.status)}" !== '1') {
				//流程
				colModel.push({
					display : "${ctp:i18n('supervise.form.bind.flow.label')}",
					name : 'processDescBy',
					width : '4%'
				});
			}
			//督办摘要
			colModel.push({
				display : "${ctp:i18n('supervise.col.description')}",
				name : 'description',
				width : '9%'
			});
		}
		var xyms = true;
		//定义列表
		var _managerName = "superviseManager";
		var _managerMethod = "getPageInfo";
		var _callBackFun = rend;
		grid = $("#superviseList")
				.ajaxgrid(
						{
							colModel : colModel,
							click : toDetailPage,
							dblclick : dbclickRow,
							render : _callBackFun,
							height : 200,
							parentId : $('.layout_center').eq(0).attr('id'),
							showTableToggleBtn : true,
							vChange : true,
							vChangeParam : {
								overflow : "hidden"
							},
							isHaveIframe : true,
							slideToggleBtn : true,
							onSuccess : function() {
								xyms = false;
								$('#summary')
										.attr(
												"src",
												_ctxPath
														+ "/collaboration/collaboration.do?method=listDesc&type=listSupervise&size="
														+ grid.p.total);
							},
							managerName : _managerName,
							managerMethod : _managerMethod
						});
		if (xyms) {
			$('#summary')
					.attr(
							"src",
							_ctxPath
									+ "/collaboration/collaboration.do?method=listDesc&type=listSupervise&size=0");
		}
		//定义回调函数
		function rend(txt, data, r, c, col) {
			if (app != '4') {
				if (col.name == "title") {//标题
					//标题列加深
					txt = "<span class='grid_black'>" + txt + "</span>";
					//加图标
					//重要程度
					if (data.importantLevel !== "" && data.importantLevel !== 1) {
						txt = "<span class='ico16 important"+data.importantLevel+"_16 '></span>"
								+ txt;
					}
					//附件
					if (data.hasAttachment === true) {
						txt = txt + "<span class='ico16 affix_16'></span>";
					}
					//协同类型
					if (data.bodyType !== "" && data.bodyType !== null
							&& data.bodyType !== "10" && data.bodyType !== "30") {
						txt = txt
								+ "<span class='ico16 office"+data.bodyType+"_16'></span>";
					}
					//流程状态
					if ($.trim(data.state) !== "") {
						txt = "<span class='ico16  flow"+data.state+"_16 '></span>"
								+ txt;
					}
					return txt;
				}
				if ("${ctp:escapeJavascript(param.status)}" == '0' || "${ctp:escapeJavascript(param.status)}" == '') {//增加一列当前待办人
					if (col.name === "currentNodesInfo") {//当前代办人
						return "<a href='javascript:void(0)' onclick='showFlowChart(\""
								+ data.caseId
								+ "\",\""
								+ data.processId
								+ "\",\""
								+ data.templeteId
								+ "\",\""
								+ data.activityId
								+ "\",\"collaboration\")'>"
								+ txt + "</a>";
					} else if (col.name == "deadlineName") {//流程期限
						if (data.workflowTimeout == true) {
							var tip = "${ctp:i18n('collaboration.process.mouseover.overtop.true.title')}";
							txt = "<span class='color_red'  title='"+tip+"'>"
									+ txt + "</span>";
						} else {
							var tip = "${ctp:i18n('collaboration.process.mouseover.overtop.false.title')}";
							txt = "<span title='"+tip+"'>" + txt + "</span>";
						}
						return txt;
					} else if (col.name == "awakeDate") {
						//督办期限
						if (data.status == 1) {
							if (data.isRed) {
								return "<span class='color_red'>" + txt
										+ "</span>";
							} else {
								return txt;
							}
						} else {
							if (data.isRed) {
								return "<a id='ssss"
										+ data.id
										+ "' class='noClick' href='javascript:void(0)' onclick='changeAwake(event,\""
										+ data.id
										+ "\")'><span class='noClick color_red'>" + txt
										+ "</span></a>";
							} else {
								return "<a id='ssss"
										+ data.id
										+ "' class='noClick' href='javascript:void(0)' onclick='changeAwake(event,\""
										+ data.id + "\")'>" + txt + "</a>";
							}
						}
					} else if (col.name == "count") {
						//催办次数
						var id = data.id;
						if (data.status == 1) {
							return "<a class='noClick' href='javascript:void(0)' onclick='showSuperviseLog(\""
									+ data.id
									+ "\")'>"
									+ txt
									+ "${ctp:i18n('supervise.superviseDetailList.secondary')}</a>";
						} else {
							return "<div style='text-align:right;width:50%;font-family:Arial,Helvetica,sans-serif'><a class='noClick' href='javascript:void(0)' onclick='showSuperviseLog(\""
									+ data.id
									+ "\")'>"
									+ txt
									+ "${ctp:i18n('supervise.superviseDetailList.secondary')}</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' class='ico16 notify_16 noClick' onclick='showWFCDiagram(getCtpTop(),\""
									+ data.caseId
									+ "\",\""
									+ data.processId
									+ "\",\""
									+ data.isTemplate
									+ "\",true,\""
									+ data.id
									+ "\",null,\"collaboration\",refreshWindow,\"\",\"\",\"${ctp:i18n('supervise.hasten.label')}\")'></a></div>";
						}
					}
					//已办结
					if ("${ctp:escapeJavascript(param.status)}" == '1') {
						if (col.name === "description") {
							//督办摘要
							var summaryId = data.summaryId;
							var id = data.id;
							return "<a href='javascript:void(0)' class='noClick' onclick='superviseContent(\""
									+ summaryId
									+ "\","
									+ data.status
									+ ",\""
									+ id
									+ "\")'>${ctp:i18n('supervise.superviseDetailList.content')}</a>";
						}
					} else {
						//未办结
						if (col.name == "processDescBy") {
							//流程
							return "<a href='javascript:void(0)' class='ico16 process_16 noClick' onclick='superviousWFCDiagram(getCtpTop(),\""
									+ data.caseId
									+ "\",\""
									+ data.processId
									+ "\",\""
									+ data.isTemplate
									+ "\",window,\""
									+ data.appName
									+ "\",\""
									+ data.flowPermAccountId
									+ "\",\"\",\"\",\"${ctp:i18n('supervise.col.label')}\");'></a>&nbsp;";
						} else if (col.name == "description") {
							//督办摘要
							var summaryId = data.summaryId;
							var id = data.id;
							return "<a href='javascript:void(0)' class='noClick' onclick='superviseContent(\""
									+ summaryId
									+ "\","
									+ data.status
									+ ",\""
									+ id
									+ "\")'>${ctp:i18n('supervise.superviseDetailList.content')}</a>";
						}
					}
				} else {
					if (col.name == "deadlineName") {
						if (data.workflowTimeout == true) {
							var tip = "${ctp:i18n('collaboration.process.mouseover.overtop.true.title')}";
							txt = "<span class='color_red'  title='"+tip+"'>"
									+ txt + "</span>";
						} else {
							var tip = "${ctp:i18n('collaboration.process.mouseover.overtop.false.title')}";
							txt = "<span title='"+tip+"'>" + txt + "</span>";
						}
						return txt;
					} else if (col.name == "awakeDate") {
						//督办期限
						if (data.status == 1) {
							if (data.isRed) {
								return "<span class='color_red'>" + txt
										+ "</span>";
							} else {
								return txt;
							}
						} else {
							if (data.isRed) {
								return "<a id='ssss"
										+ data.id
										+ "' class='noClick' href='javascript:void(0)' onclick='changeAwake(event,\""
										+ data.id
										+ "\")'><span class='noClick color_red'>" + txt
										+ "</span></a>";
							} else {
								return "<a id='ssss"
										+ data.id
										+ "' class='noClick' href='javascript:void(0)' onclick='changeAwake(event,\""
										+ data.id + "\")'>" + txt + "</a>";
							}
						}
					} else if (col.name == "count") {
						//催办次数
						var id = data.id;
						if (data.status == 1) {
							return "<a class='noClick' href='javascript:void(0)' onclick='showSuperviseLog(\""
									+ data.id
									+ "\")'>"
									+ txt
									+ "${ctp:i18n('supervise.superviseDetailList.secondary')}</a>";
						} else {
							return "<div style='text-align:right;width:50%;font-family:Arial,Helvetica,sans-serif'><a class='noClick' href='javascript:void(0)' onclick='showSuperviseLog(\""
									+ data.id
									+ "\")'>"
									+ txt
									+ "${ctp:i18n('supervise.superviseDetailList.secondary')}</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' class='ico16 notify_16 noClick' onclick='showWFCDiagram(getCtpTop(),\""
									+ data.caseId
									+ "\",\""
									+ data.processId
									+ "\",\""
									+ data.isTemplate
									+ "\",true,\""
									+ data.id
									+ "\",null,\"collaboration\",refreshWindow,\"\",\"\",\"${ctp:i18n('supervise.hasten.label')}\")'></a></div>";
						}
					}
					//已办结
					if ("${ctp:escapeJavascript(param.status)}" == '1') {
						if (col.name === "description") {
							//督办摘要
							var summaryId = data.summaryId;
							var id = data.id;
							return "<a href='javascript:void(0)' class='noClick' onclick='superviseContent(\""
									+ summaryId
									+ "\","
									+ data.status
									+ ",\""
									+ id
									+ "\")'>${ctp:i18n('supervise.superviseDetailList.content')}</a>";
						}
					} else {
						//未办结
						if (col.name == "processDescBy") {
							//流程
							return "<a href='javascript:void(0)' class='ico16 process_16 noClick' onclick='superviousWFCDiagram(getCtpTop(),\""
									+ data.caseId
									+ "\",\""
									+ data.processId
									+ "\",\""
									+ data.isTemplate
									+ "\",window,\""
									+ data.appName
									+ "\",\""
									+ data.flowPermAccountId
									+ "\",\"\",\"\",\"${ctp:i18n('supervise.col.label')}\");'></a>&nbsp;";
						} else if (col.name == "description") {
							//督办摘要
							var summaryId = data.summaryId;
							var id = data.id;
							return "<a href='javascript:void(0)' class='noClick' onclick='superviseContent(\""
									+ summaryId
									+ "\","
									+ data.status
									+ ",\""
									+ id
									+ "\")'>${ctp:i18n('supervise.superviseDetailList.content')}</a>";
						}
					}
				}

			} else {
				if(col.name == "appName"){//类别
				    if(data.appName =='edocSend'){
					    txt = "${ctp:i18n('edoc.docmark.inner.send')}";
					}else if(data.appName =='recEdoc'){
						txt = "${ctp:i18n('edoc.docmark.inner.receive')}";
					}else if(data.appName =='signReport'){
						txt = "${ctp:i18n('edoc.docmark.inner.signandreport')}";
					}
				}
				if (col.name == "title") {//标题
					//加图标
					//重要程度,公文有自定义重要程度
					if (data.importantLevel !== "" && data.importantLevel > 1
							&& data.importantLevel < 6) {
						txt = "<span class='ico16 important"+data.importantLevel+"_16 '></span>"
								+ txt;
					}
					//附件
					if (data.hasAttsFlag === true) {
						txt = txt + "<span class='ico16 affix_16'></span>";
					}
					var bodyType = '10';
					if (data.bodyType == "OfficeWord") {
						bodyType = 41;
					} else if (data.bodyType == "OfficeExcel") {
						bodyType = 42;
					} else if (data.bodyType == "WpsWord") {
						bodyType = 43;
					} else if (data.bodyType == "WpsExcel") {
						bodyType = 44;
					}
					//附件
					if (data.hasAttachment === true) {
						txt = txt + "<span class='ico16 affix_16'></span>";
					}
					//协同类型
					if (bodyType !== "10") {
						txt = txt
								+ "<span class='ico16 office"+bodyType+"_16'></span>";
					}
					//流程状态
					if ($.trim(data.state) !== "") {
						txt = "<span class='ico16  flow"+data.state+"_16 '></span>"
								+ txt;
					}
					return txt;
				}
				//已办结
				if ("${ctp:escapeJavascript(param.status)}" == '1') {
					if (col.name === "currentNodesInfo") {
						return "<a href='javascript:void(0)' onclick='showFlowChart(\""
								+ data.caseId
								+ "\",\""
								+ data.processId
								+ "\",\""
								+ data.templeteId
								+ "\",\""
								+ data.activityId
								+ "\",\"edoc\")'>"
								+ txt
								+ "</a>";
					}
				} else {//未办结
					if (col.name === "currentNodesInfo") {
						return "<a href='javascript:void(0)' onclick='showFlowChart(\""
								+ data.caseId
								+ "\",\""
								+ data.processId
								+ "\",\""
								+ data.templeteId
								+ "\",\""
								+ data.activityId
								+ "\",\"edoc\")'>"
								+ txt
								+ "</a>";
					}
				}
				//督办期限
				if (col.name === "awakeDate") {
					if(data.status == 1){
                        if(data.isRed){
                            return "<span class='color_red'>"+txt+"</span>";
                        }else{
                            return txt;
                        }
                    }else{
                        if(data.isRed){
                            return "<a id='ssss"+data.id+"' class='noClick' href='javascript:void(0)' onclick='changeAwake(event,\""+data.id+"\")'><span class='noClick color_red'>"+txt+"</span></a>";
                        }else{
                            return "<a id='ssss"+data.id+"' class='noClick' href='javascript:void(0)' onclick='changeAwake(event,\""+data.id+"\")'>"+txt+"</a>";
                        }
                    }
				}

				//G6版本区分，多了公文种类
				if ("${ctp:getSystemProperty('edoc.isG6')}" == "true") {
					//G6版本，已办结列，流程期限是在第六列
					if (col.name == "deadlineName") {//流程期限
						if (data.workflowTimeout == true) {
							var tip = "${ctp:i18n('collaboration.process.mouseover.overtop.true.title')}";
							txt = "<span class='color_red'  title='"+tip+"'>"
									+ txt + "</span>";
						} else {
							var tip = "${ctp:i18n('collaboration.process.mouseover.overtop.false.title')}";
							txt = "<span title='"+tip+"'>" + txt + "</span>";
						}
						return txt;
					}
					if (col.name == "count") {
						if (data.status == 1) {
							return "<a class='noClick' href='javascript:void(0)' onclick='showSuperviseLog(\""
									+ data.id
									+ "\")'>"
									+ txt
									+ "${ctp:i18n('supervise.superviseDetailList.secondary')}</a>";
						} else {

							return "<div style='text-align:right;width:50%;font-family:Arial,Helvetica,sans-serif'><a class='noClick' href='javascript:void(0)' onclick='showSuperviseLog(\""
									+ data.id
									+ "\")'>"
									+ txt
									+ "${ctp:i18n('supervise.superviseDetailList.secondary')}</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' class='ico16 notify_16 noClick' onclick='showWFCDiagram(getCtpTop(),\""
									+ data.caseId
									+ "\",\""
									+ data.processId
									+ "\",\""
									+ data.isTemplate
									+ "\",true,\""
									+ data.id
									+ "\",null,\"collaboration\",refreshWindow,\"\",\"\",\"${ctp:i18n('supervise.hasten.label')}\")'></a></div>";
						}
					}
					if (col.name == "processDescBy") {
						var appName = data.appName;
						var formTypeEnum = "";
						if(data.entityType == 3){
							if(data.appName == "edocSend"){
								formTypeEnum = "govdocSend";
							}else if(data.appName == "edocRec"){
								formTypeEnum = "govdocRec";
							}else if(data.appName == "edocSign"){
								formTypeEnum = "govdocExchange";
							}else if(data.appName == "signReport"){
								formTypeEnum = "govdocSign";
							}else if(data.appName == "recEdoc"){
								//2017-2-29（眉山市政府）公文督办人员增加节点后，节点的处理的意见显示的位置不正确
								formTypeEnum = "7";
							}else {
								formTypeEnum = "collaboration";
							}
							appName = "collaboration";
						}
						return "&nbsp;<a href='javascript:void(0)' class='ico16 process_16 noClick' onclick='editEdocWorkflow(\""
								+ data.finished
								+ "\",\""
								+ data.caseId
								+ "\",\""
								+ formTypeEnum
								+ "\",\""
								+ data.processId
								+ "\",\""
								+ data.isTemplate
								+ "\",\""
								+ appName
								+ "\",\""
								+ data.secretLevel
								+ "\",\""
								+ data.flowPermAccountId
								+ "\",\"${ctp:i18n('supervise.edoc.label')}\");'></a>&nbsp;";
					}
					if (col.name == "description") {
						var summaryId = data.summaryId;
						var id = data.id;
						return "<a class='noClick' href='javascript:void(0)' onclick='superviseContent(\""
								+ summaryId
								+ "\","
								+ data.status
								+ ",\""
								+ id
								+ "\")'>[内容]</a>";
					}
					if ("${ctp:escapeJavascript(param.status)}" == '1') {
						if (col.name == "processDescBy") {
							var summaryId = data.summaryId;
							var id = data.id;
							return "<a class='noClick' href='javascript:void(0)' onclick='superviseContent(\""
									+ summaryId
									+ "\","
									+ data.status
									+ ",\""
									+ id + "\")'>[内容]</a>";
						}
					} else {
						if (col.name == "processDescBy") {
							var id = data.id;
							if (data.status == 1) {
								return "<a class='noClick' href='javascript:void(0)' onclick='showSuperviseLog(\""
										+ data.id
										+ "\")'>"
										+ txt
										+ "${ctp:i18n('supervise.superviseDetailList.secondary')}</a>";
							} else {
								return "<div style='text-align:right;width:50%;font-family:Arial,Helvetica,sans-serif'><a class='noClick' href='javascript:void(0)' onclick='showSuperviseLog(\""
										+ data.id
										+ "\")'>"
										+ txt
										+ "${ctp:i18n('supervise.superviseDetailList.secondary')}</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' class='ico16 notify_16 noClick' onclick='showWFCDiagram(getCtpTop(),\""
										+ data.caseId
										+ "\",\""
										+ data.processId
										+ "\",\""
										+ data.isTemplate
										+ "\",true,\""
										+ data.id
										+ "\",null,\"collaboration\",refreshWindow,\"\",\"\",\"${ctp:i18n('supervise.hasten.label')}\")'></a></div>";
							}
						}

					}
				} else {
					//已办结
					if ("${ctp:escapeJavascript(param.status)}" == '1') {
						if (col.name == "deadlineName") {//流程期限
							if (data.workflowTimeout == true) {
								var tip = "${ctp:i18n('collaboration.process.mouseover.overtop.true.title')}";
								txt = "<span class='color_red'  title='"+tip+"'>"
										+ txt + "</span>";
							} else {
								var tip = "${ctp:i18n('collaboration.process.mouseover.overtop.false.title')}";
								txt = "<span title='"+tip+"'>" + txt
										+ "</span>";
							}
							return txt;
						}
					} else {
						if (col.name == "deadlineName") {//流程期限
							if (data.workflowTimeout == true) {
								var tip = "${ctp:i18n('collaboration.process.mouseover.overtop.true.title')}";
								txt = "<span class='color_red'  title='"+tip+"'>"
										+ txt + "</span>";
							} else {
								var tip = "${ctp:i18n('collaboration.process.mouseover.overtop.false.title')}";
								txt = "<span title='"+tip+"'>" + txt
										+ "</span>";
							}
							return txt;
						}
					}
					//已办结
					if ("${ctp:escapeJavascript(param.status)}" == '1') {
						if (col.name == "count") {
							//催办次数
							var id = data.id;
							if (data.status == 1) {
								return "<a class='noClick' href='javascript:void(0)' onclick='showSuperviseLog(\""
										+ data.id
										+ "\")'>"
										+ txt
										+ "${ctp:i18n('supervise.superviseDetailList.secondary')}</a>";
							} else {
								return "<div style='text-align:right;width:50%;font-family:Arial,Helvetica,sans-serif'><a class='noClick' href='javascript:void(0)' onclick='showSuperviseLog(\""
										+ data.id
										+ "\")'>"
										+ txt
										+ "${ctp:i18n('supervise.superviseDetailList.secondary')}</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' class='ico16 notify_16 noClick' onclick='showWFCDiagram(getCtpTop(),\""
										+ data.caseId
										+ "\",\""
										+ data.processId
										+ "\",\""
										+ data.isTemplate
										+ "\",true,\""
										+ data.id
										+ "\",null,\"collaboration\",refreshWindow,\"\",\"\",\"${ctp:i18n('supervise.hasten.label')}\")'></a></div>";
							}
						}
						if (col.name == "description") {
							//督办摘要
							var summaryId = data.summaryId;
							var id = data.id;
							return "<a href='javascript:void(0)' class='noClick' onclick='superviseContent(\""
									+ summaryId
									+ "\","
									+ data.status
									+ ",\""
									+ id
									+ "\")'>${ctp:i18n('supervise.superviseDetailList.content')}</a>";
						}
					} else {
						if (col.name == "count") {
							//催办次数
							var id = data.id;
							if (data.status == 1) {
								return "<a class='noClick' href='javascript:void(0)' onclick='showSuperviseLog(\""
										+ data.id
										+ "\")'>"
										+ txt
										+ "${ctp:i18n('supervise.superviseDetailList.secondary')}</a>";
							} else {
								return "<div style='text-align:right;width:50%;font-family:Arial,Helvetica,sans-serif'><a class='noClick' href='javascript:void(0)' onclick='showSuperviseLog(\""
										+ data.id
										+ "\")'>"
										+ txt
										+ "${ctp:i18n('supervise.superviseDetailList.secondary')}</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' class='ico16 notify_16 noClick' onclick='showWFCDiagram(getCtpTop(),\""
										+ data.caseId
										+ "\",\""
										+ data.processId
										+ "\",\""
										+ data.isTemplate
										+ "\",true,\""
										+ data.id
										+ "\",null,\"collaboration\",refreshWindow,\"\",\"\",\"${ctp:i18n('supervise.hasten.label')}\")'></a></div>";
							}
						}
						//未办结
						if (col.name == "processDescBy") {
							//流程
							var nodeId = "shenpi";
							var nodeName = "${ctp:i18n('node.policy.shenpi')}";
							;

							//收文督办默认节点权限是 阅读
							if ("recEdoc" == data.appName) {
								nodeId = "yuedu";
								nodeName = "${ctp:i18n('node.policy.yuedu')}";
							}
							return "<a href='javascript:void(0)' class='ico16 process_16 noClick' onclick='superviousWFCDiagram(getCtpTop(),\""
									+ data.caseId
									+ "\",\""
									+ data.processId
									+ "\",\""
									+ data.isTemplate
									+ "\",window,\""
									+ data.appName
									+ "\",\""
									+ data.flowPermAccountId
									+ "\",\""
									+ nodeId
									+ "\",\""
									+ nodeName
									+ "\",\"${ctp:i18n('supervise.edoc.label')}\");'></a>&nbsp;";
						} else if (col.name == "description") {
							//督办摘要
							var summaryId = data.summaryId;
							var id = data.id;
							return "<a href='javascript:void(0)' class='noClick' onclick='superviseContent(\""
									+ summaryId
									+ "\","
									+ data.status
									+ ",\""
									+ id
									+ "\")'>${ctp:i18n('supervise.superviseDetailList.content')}</a>";
						}
					}
				}
			}
			return txt;
		}


		//初始化列表数据
		var obj = new Object();
		obj.app = "${ctp:escapeJavascript(param.app)}";
		var status = "${ctp:escapeJavascript(param.status)}";
		if (status == '' || status == '0') {
			//默认为 '未办结'
			obj.status = '0';
			$('#status').val('0');
			//隐藏工具栏最右侧'|'标识
			$($("#toolbars div div em")[5]).hide();
			toolbars.unselected('listDone');
			toolbars.selected('listPending');
			//初始化化时默认查询为'未办结'的数据，所以隐藏'删除'按钮
			toolbars.hideBtn('deleteSupervise');
			//归档公文修改日志按钮隐藏
			toolbars.hideBtn('archivedModifyHistory');
			obj.templeteIds = "${ctp:escapeJavascript(param.templeteIds)}";
			if(window.location.href.indexOf("condition=templeteAll&templeteAll=templeteAll")!= -1){
			   obj.templeteAll = "templeteAll";
			}
		} else {
			obj.status = status;
			$('#status').val(status);
			$($("#toolbars div div em")[5]).show();
			toolbars.showBtn('deleteSupervise');
			//公文已办结显示归档公文修改日志的按钮
			//归档公文修改日志在公文督办中去掉2016-3-16具体可以咨询杨园
//			if (app == '4') {
//				toolbars.showBtn('archivedModifyHistory');
//			} else {
//				toolbars.hideBtn('archivedModifyHistory');
//			}
			toolbars.unselected('listPending');
			toolbars.selected('listDone');
			obj.templeteIds = "${ctp:escapeJavascript(param.templeteIds)}";
		}
		<%
		String edocType=request.getParameter("edocType");
		if(edocType!=null){
			%>
			obj.edocType=<%=edocType%>;
			<%
		}

		%>
		$("#superviseList").ajaxgridLoad(obj);

		//定义setTimeout执行方法
		var TimeFn = null;
		//定义列表单击事件
		function toDetailPage(data, rowIndex, colIndex) {
			grid.grid.resizeGrid(105);
			var url = "";
			var callerResponder = new CallerResponder();
            var collManager = new colManager();
            var obj = new Object();
            obj.objId = data.summaryId;
            obj.openFrom ="supervise";
            obj.appName = data.appName;
            var reBack = collManager.checkSuperviseIsCancel(obj);
			if(reBack){
				$.alert(reBack);
				return ;
			}

		    var _affairId = getSenderAffairId(data.summaryId);
			//老公文和旧公文用不同的链接
			if(data.entityType == 2){
			url = "${path}/" + data.detailPageUrl + "&affairId="
					+ _affairId + "&summaryId=" + data.summaryId
					+ "&openFrom=supervise&type=" + data.status;
			}else if(data.entityType == 3){
				url = "${path}" + data.detailPageUrl + "&affairId="
				+ _affairId + "&openFrom=supervise&summaryId=" + data.summaryId+"&type=" + data.status;
			}else{
				url = "${path}/" + data.detailPageUrl + "&affairId="
				+ _affairId + "&summaryId=" + data.summaryId
				+ "&openFrom=supervise&type=" + data.status;
			}
			// 取消上次延时未执行的方法
			clearTimeout(TimeFn);

			//执行延时
			TimeFn = setTimeout(function() {
				$('#summary')[0].src = url;
			}, 300);

		}
		//双击事件
		function dbclickRow(data, rowIndex, colIndex) {
			// 取消上次延时未执行的方法
			clearTimeout(TimeFn);
			var url = "";

			var callerResponder = new CallerResponder();
            var collManager = new colManager();
            var obj = new Object();
            obj.objId = data.summaryId;
            obj.openFrom ="supervise";
            var reBack = collManager.checkSuperviseIsCancel(obj);
			if(reBack){
				$.alert(reBack);
				return ;
			}


		    var _affairId = getSenderAffairId(data.summaryId);
			//老公文和旧公文用不同的链接
			if(data.entityType == 2){
				url = "${path}/" + data.detailPageUrl + "&affairId="
				+ _affairId + "&summaryId=" + data.summaryId
				+ "&openFrom=supervise&type=" + data.status;
			}else if(data.entityType == 3){
				url = "${path}" + data.detailPageUrl + "&affairId="
				+ _affairId + "&openFrom=supervise&summaryId=" + data.summaryId+"&type=" + data.status;
			}else{
				url = "${path}/" + data.detailPageUrl + "&affairId="
				+ _affairId + "&summaryId=" + data.summaryId
				+ "&openFrom=supervise&type=" + data.status;
			}



			var title = data.subject;
			doubleClick(url, escapeStringToHTML(title));
			grid.grid.resizeGridUpDown('down');
			//页面底部说明加载
			$('#summary')
					.attr(
							"src",
							_ctxPath
									+ "/collaboration/collaboration.do?method=listDesc&type=listSupervise&size="
									+ grid.p.total);
		}
		//未办结
		function listPending() {
			var url = _ctxPath
					+ "/supervise/supervise.do?method=listSupervise&app=${ctp:escapeJavascript(param.app)}&templeteIds=${ctp:escapeJavascript(param.templeteIds)}&status=0&srcFrom=${ctp:escapeJavascript(param.srcFrom)}";
			window.location.href = url +"&isShowRecord="+isShowRecord;
		}
		//撤销记录
		function listRepealRecord() {
			var url = _ctxPath
					+ "/supervise/supervise.do?method=listRecord&app=${ctp:escapeJavascript(param.app)}&record=repealRecord";
					url = addUrlPath(url);
			window.location.href = url;
		}
		//回退记录
		function listSBRecord() {
			var url = _ctxPath
					+ "/supervise/supervise.do?method=listRecord&app=${ctp:escapeJavascript(param.app)}&record=stepBackRecord";
					url = addUrlPath(url);
			window.location.href = url;
		}
		//已办结
		function listDone() {
			var url = _ctxPath
					+ "/supervise/supervise.do?method=listSupervise&app=${ctp:escapeJavascript(param.app)}&templeteIds=${ctp:escapeJavascript(param.templeteIds)}&status=1&srcFrom=${ctp:escapeJavascript(param.srcFrom)}";
			window.location.href = url+"&isShowRecord="+isShowRecord;
		}
		//办理情况
		function handling() {
			showAffair();
		}
		//删除已办结记录
		function deleteSupervise() {
			var rows = grid.grid.getSelectRows();
			var len = rows.length;
			var str = "";
			if (recordType == "stepBackRecord" || recordType == "repealRecord") {
				for (var i = 0; i < len; i++) {
					str += rows[i].id;
					str += ",";
				}
				if (len === 0) {
					//请选择一条督办记录!
					$.alert("${ctp:i18n('collaboration.workflow.label.pleaseChoose')}");
					return false;
				}

				str = str.substring(0, str.length - 1);
				$.confirm({
							'msg' : "${ctp:i18n('collaboration.workflow.label.sureDelete')}",
							ok_fn : function() {
								var tm = new traceWorkflowManager();
								var tranObj = new Object();
								tranObj.ids = str;
								tranObj.app = app;
								tm.deleteTraceWorkflows(tranObj, {
									success : function() {
										for (var i = 0; i < rows.length; i++) {
											try {
											    var _affairId = getSenderAffairId(rows[i].summaryId);
												closeOpenMultyWindow(_affairId);
											} catch (e) {}
											;
										}
										//刷新列表
										searchFunc('delete');
									},
									error : function(request, settings, e) {
										$.alert(e);
									}
								});
							}
						});

			} else {
				for (var i = 0; i < len; i++) {
					str += rows[i].id;
					str += ",";
				}
				if (len === 0) {
					//请选择一条督办记录!
					$
							.alert("${ctp:i18n('collaboration.common.supervise.selectOneSupervise')}");
					return false;
				}
				str = str.substring(0, str.length - 1);
				$
						.confirm({
							'msg' : "${ctp:i18n('collaboration.common.supervise.sureDeleteSupervise')}", //确定要删除督办记录?'
							ok_fn : function() {
								var sup = new superviseManager();
								var tranObj = new Object();
								tranObj.ids = str;
								sup.deleteSupervisedAjax(tranObj, {
									success : function() {
										for (var i = 0; i < rows.length; i++) {

											try {
											    var _affairId = getSenderAffairId(rows[i].summaryId);
												closeOpenMultyWindow(_affairId);
											} catch (e) {
											};

										}
										//刷新列表
										searchFunc('delete');
									},
									error : function(request, settings, e) {
										$.alert(e);
									}
								});
							}
						});
			}
		}
		//显示办理情况
		function showAffair() {
			var rows = grid.grid.getSelectRows();
			var len = rows.length;
			if (len === 0) {
				//请选择一条督办记录!
				$
						.alert("${ctp:i18n('collaboration.common.supervise.selectOneSupervise')}");
				return false;
			}
			if (len > 1) {
				//请选择一条督办记录!
				$
						.alert("${ctp:i18n('collaboration.common.supervise.selectOnlyOneSupervise')}");
				return false;
			}
		    var _affairId = getSenderAffairId(rows[0].summaryId);


			var url = _ctxPath
					+ "/supervise/supervise.do?method=showAffair&id="
					+ rows[0].summaryId + "&affairId=" + _affairId;

			var dialog = $.dialog({
				url : url,
				width : 820,
				height : 400,
				title : "${ctp:i18n('common.toolbar.showAffair.label')}",//办理情况
				targetWindow : getCtpTop(),
				buttons : [ {
					text : "${ctp:i18n('common.button.close.label')}",
					handler : function() {
						dialog.close();
					}
				} ]
			});
		}
	    var _urlp = window.location.href;
		if((_urlp.indexOf("srcFrom=bizconfig") != -1
				||_urlp.indexOf("templeteAll=templeteAll") != -1
				||_urlp.indexOf("templeteCategory=") != -1
				||'${isShowRecord}' =='true') && _urlp.indexOf("app=4") ==-1){
			toolbars.hideBtn('repealRecord');
			toolbars.hideBtn('stepbackRecord');
			isShowRecord = true;
		}
	});//ready 结束
	//刷新页面
	function refreshWindow() {
		window.location.reload();
	}

	function getSenderAffairId(summaryId){
         var _affairId = 0;

         var _colManager = new colManager();
         var objSum = _colManager.getSenderAffair(summaryId);

         if(null != objSum && objSum.affairId != null){
         	_affairId = objSum.affairId ;
         }
         return _affairId;
	}

	function getCurrentTime() {
		var date = new Date();
		var year = date.getFullYear();
		var month = date.getMonth() + 1;
		var day = date.getDate();
		var hour = date.getHours();
		var time = year + "-" + month + "-" + day + " " + hour + ":" + "00";
		return time;
	}

	function getCurrentDate() {
		var date = new Date();
		var year = date.getFullYear();
		var month = date.getMonth() + 1;
		var day = date.getDate();
		var date = year + "-" + month + "-" + day;
		return date;
	}
	var changeAwakeID;
	function changeAwake(e, id) {
		changeAwakeID = id;
		var time = getCurrentTime();
		$.calendar({
			displayArea : "ssss" + id,
			position : [ e.clientX, e.clientY + 10 ],
			returnValue : true,
			ifFormat : "%Y-%m-%d %H:%M",
			daFormat : "%Y-%m-%d %H:%M",
			dateString : time,
			singleClick : true,
			showsTime : true,
			onUpdate : getDateTime,
			autoShow : true,
			isClear : true
		});
	}

    function addUrlPath(urlStr){
        var _url = urlStr;
        var _loca = window.location.href;
        if(_loca.indexOf("srcFrom=bizconfig") != -1){
        //控制面包削
        	_url +="&srcFrom=bizconfig&condition=templeteIds&templeteIds="+$("#templeteIds").val();
        }
    	//srcFrom=bizconfig&condition=templeteIds&templeteIds=4487748473006737914;
        return _url;
    }

	function getDateTime(awake) {
		var date1 = getCurrentDate();
		;
		var date1s = date1.split("-");
		var bdate = new Date(date1s[0], date1s[1] - 1, date1s[2]);
		var date2 = awake.substring(0, 10);
		var date2s = date2.split("-");
		var edate = new Date(date2s[0], date2s[1] - 1, date2s[2]);
		var url = _ctxPath
				+ "/supervise/supervise.do?method=modifySupervise&superviseId="
				+ changeAwakeID + "&awakeDate=" + awake + "&app=${ctp:escapeJavascript(param.app)}";
		url = addUrlPath(url);
		if (bdate.getTime() > edate.getTime()) {
			var confirm = $
					.confirm({
						'msg' : '${ctp:i18n("collaboration.common.supervise.thisTimeXYouset")}', //您设置的督办日期小于当前日期,是否继续?
						ok_fn : function() {
							document.location.href = url;
						},
						cancel_fn : function() {
							confirm.close();
						}
					});
		} else {
			document.location.href = url;
		}
	}

	function findListByStatus(status, flag, type, tempIds, bizConfigId) {
		location.href = _ctxPath
				+ "/supervise/supervise.do?method=listSupervise&status="
				+ status;
	}

	//催办日志
	function showSuperviseLog(superviseId) {
		var url = _ctxPath
				+ "/supervise/supervise.do?method=showLog&superviseId="
				+ superviseId;
		var dialog = $.dialog({
			url : url,
			width : 815,
			height : 500,
			targetWindow : getCtpTop(),
			title : "${ctp:i18n('supervise.col.title.label')}"
		});

	}

	//督办摘要
	function superviseContent(summaryId, status, superviseId) {
		var url = _ctxPath
				+ "/supervise/supervise.do?method=showDescription&summaryId="
				+ summaryId + "&superviseId=" + superviseId;
		var but = new Array();
		var dialogs = "";
		//当是未办结状态时，才显示确定按钮
		if (status == 0) {
			but
					.push({
						text : "${ctp:i18n('common.button.ok.label')}",
						handler : function() {
							var returnValue = dialogs.getReturnValue();
							if (returnValue != null) {
								var map = $.parseJSON(returnValue);
								var content = map.content;
								var url = _ctxPath
										+ "/supervise/supervise.do?method=updateContent&content="
										+ content + "&superviseId="
										+ map.superviseId;
								$("#grid_detail").jsonSubmit({
									action : url,
									callback : function() {
										window.location.reload();
									}
								});
								dialogs.close();
							}
						}
					});
			but.push({
				text : "${ctp:i18n('common.button.cancel.label')}",
				handler : function() {
					dialogs.close();
				}
			});
		} else {
			but.push({
				text : "${ctp:i18n('common.button.close.label')}",
				handler : function() {
					dialogs.close();
				}
			});
		}
		//显示title需要判断app
		var appName = "${ctp:escapeJavascript(param.app)}";
		var openTitle = "${ctp:i18n('supervise.col.label')}";
		if (appName == 4) {
			openTitle = "${ctp:i18n('supervise.edoc.label')}";
		}
		//督办摘要 弹出dialog
		dialogs = $.dialog({
			url : url,
			width : 500,
			height : 350,
			targetWindow : getCtpTop(),
			title : openTitle,
			buttons : but
		});
	}

	//归档公文修改日志
	function showArchiveModifyLog_iframe() {
		try {
			var rows = grid.grid.getSelectRows();
			var len = rows.length;
			if (len === 0) {
				//请选择一条督办记录!
				$
						.alert("${ctp:i18n('collaboration.common.supervise.selectOneSupervise')}");
				return false;
			}
			if (len > 1) {
				//请选择一条督办记录!
				$
						.alert("${ctp:i18n('collaboration.common.supervise.selectOneSupervise')}");
				return false;
			}

			var summaryId = rows[0].summaryId;
			var url = _ctxPath
					+ "/edocController.do?method=showArchiveModifyLog_Iframe&summaryId="
					+ summaryId;
			var dialog = $
					.dialog({
						url : url,
						width : 750,
						height : 550,
						title : "${ctp:i18n('common.toolbar.edocArchiveModifyHistory.label')}",
						targetWindow : getCtpTop(),
						buttons : [ {
							text : "${ctp:i18n('common.button.close.label')}",
							handler : function() {
								dialog.close();
							}
						} ]
					});

		} catch (e) {
		}
	}

	function editEdocWorkflow(finished, caseId,formTypeEnum, processId, isTemplate, appName,secretLevel,
			flowPermAccountId) {
		if (finished == 'true') {
			$.alert("${ctp:i18n('collaboration.process.finished')}");
			return;
		}
		document.getElementById("secretLevel").value = secretLevel;
		superviousWFCDiagram(getCtpTop(), caseId, processId, isTemplate,
				window, appName, flowPermAccountId, 'shenpi',
				"${ctp:i18n('node.policy.shenpi')}",
				"${ctp:i18n('supervise.edoc.label')}","",formTypeEnum);
	}
</script>
</head>

<body class="body-pading" leftmargin="0" topmargin="" marginwidth="0"
	marginheight="0">
	<input id="awakeChangeDate" type="hidden" />
	<jsp:include page="/WEB-INF/jsp/common/supervise/superviseDetail/bizOrPicConditon.jsp"></jsp:include>
	<div id='layout'>
		<div class="layout_north bg_color" id="north">
			<div class="border_lr padding_b_5">
				<!-- 如果是业务生成器创建的一个列表菜单，则不显示面包屑 -->
				<c:if test="${param.srcFrom ne 'bizconfig' }">
					<div class="comp"
						comp="type:'breadcrumb',comptype:'location',code:'${param.app=='4'?'F20_supervise':'F01_supervise' }'"></div>
				</c:if>
				<div id="toolbars"></div>
			</div>
		</div>
		<div class="layout_center over_hidden" id="center">
			<table id="superviseList" style="display: none"></table>
			<input type="hidden" id="status" />
			<div id="grid_detail" class="h100b">
				<iframe id="summary" name="summary" width="100%" height="100%"
					frameborder="0" style="overflow-y: hidden"
					class='calendar_show_iframe'></iframe>
			</div>
		</div>
	</div>
</body>
</html>