<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>${ctp:i18n('collaboration.workflow.label.stepback')}</title>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=colManager"></script>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=superviseManager,traceWorkflowManager"></script>
<script type="text/javascript" charset="UTF-8"
	src="${path}/apps_res/collaboration/js/collaboration.js${ctp:resSuffix()}"></script>
<script text="text/javascript">
	var recordType = "${ctp:escapeJavascript(recordType)}";
	var grid;
	$(function() {
		var app = "${ctp:escapeJavascript(param.app)}";
		//初始化布局
		new MxtLayout({
			'id' : 'layout',
			'northArea' : {
				'id' : 'north',
				'height' : 40,
				'sprit' : false,
				'border' : false
			},
			'centerArea' : {
				'id' : 'center',
				'border' : false,
				'minHeight' : 20
			}
		});
		
		var toolbarArray = new Array();

		var openFrom = "${openFrom}";
		var showPigonHoleBtn = "${showPigonHoleBtn}"
		var hasDumpData = "${hasDumpData}";
		if(openFrom != "listDone"){
			//未办结
			toolbarArray.push({id : "listPending",name : "${ctp:i18n('common.toolbar.transacted.without.label')}",className : "ico16 no_through_ico_16",selected : true,click : listPending});
			//已办结
			toolbarArray.push({id : "listDone",name : "${ctp:i18n('common.toolbar.transacted.done.label')}",className : "ico16 gone_through_16",click : listDone});
			//撤销记录
			toolbarArray.push({id : "repealRecord",name : "${ctp:i18n('collaboration.workflow.label.repeal')}",className : "ico16 revoked_process_16 ",click : listRepealRecord});
			//回退记录
			toolbarArray.push({id : "stepbackRecord",name : "${ctp:i18n('collaboration.workflow.label.stepback')}",className : "ico16 toback_16 ",click : listSBRecord});
			//删除
			toolbarArray.push({id : "deleteSupervise",name : "${ctp:i18n('common.button.delete.label')}",className : "ico16 del_16",click : deleteSupervise});
		}else {
			//处理从协同已办列表跳过来的情况，由于要保持和协同已办列表显示一致将协同已办列表中的菜单带过来并置灰
			//转发
			toolbarArray.push({id: "menuTransmit",name: $.i18n('collaboration.transmit.label'),className: "ico16 forwarding_16",subMenu: new Array()});
		    //归档
		    if(showPigonHoleBtn == "true"){
		        toolbarArray.push({id: "menuPigeonhole",name: $.i18n('collaboration.toolbar.pigeonhole.label'),className: "ico16 filing_16",click: function(){}});
		    }
		    //删除
		    toolbarArray.push({id: "delete",name:$.i18n('collaboration.button.delete.label'),className: "ico16 del_16",click:deleteSupervise});
		    //取回
		    toolbarArray.push({id: "menuTakeBack",name: $.i18n('common.toolbar.takeBack.label'),className: "ico16 retrieve_16",click:function(){}});
		    //回退记录
		    toolbarArray.push({id: "stepbackRecord",name:$.i18n('collaboration.workflow.label.stepback'),className: "ico16 toback_16",click:listSBRecord});
		    //同一流程只显示最后一条
		    toolbarArray.push({id: "menuDeduplication",type: "checkbox",checked:false,text: $.i18n('collaboration.portal.listDone.isDeduplication'),value:"1",click:function(){}});
		}
		
		//工具栏
		var toolbars = $("#toolbars")
				.toolbar(
						{
							borderTop : false,
							borderLeft : false,
							borderRight : false,
							toolbar : toolbarArray
						});
		//处理从协同已办列表跳过来的情况，由于要保持和协同已办列表显示一致，将下列按钮置为不可用
		if(openFrom == "listDone"){
			//转发
			disableMenu("menuTransmit");
			//归档
			disableMenu("menuPigeonhole");
			//取回
			disableMenu("menuTakeBack");
			//同一流程只显示最后一条
			$("#menuDeduplication").attr("disabled","true").css("color","gray");
			$('label[for="menuDeduplication"]').css("color","gray");
			//当前数据
			disableMenu("menuCurrentData");
			//转储数据
			disableMenu("menuDumpData");
		}
		//搜索框
		var searchobj;
		if (recordType == "stepBackRecord" || recordType == "repealRecord") {//回退
			var text1 = "${ctp:i18n('collaboration.workflow.label.stepbackPeople')}";
			var text2 = "${ctp:i18n('collaboration.workflow.label.stepbackTime')}";
			if (recordType == "repealRecord") {
				text1 = "${ctp:i18n('collaboration.workflow.label.repealPeople')}";
				text2 = "${ctp:i18n('collaboration.workflow.label.repealTime')}";
			}
			var trackType;
			if(app == '1'){
				 if(recordType == "repealRecord"){//撤销列表的状态应该是撤销
					trackType = [{
						text : $.i18n("collaboration.nodePerm.repeal.label"),//撤销
						value : '0'
					}]
				 }else{
					trackType = [{
						text : $.i18n("collaboration.workflow.state.stepBack.js"),//回退
						value : '1'
					},{
						text : $.i18n("collaboration.workflow.state.specialStepBack.js"),//指定回退
						value : '2'
					},{
						text : $.i18n("collaboration.workflow.state.circleStepBack.js"),//环形回退
						value : '3'
					}]
				} 
			}else{
				if(recordType == "repealRecord"){//撤销列表的状态应该是撤销
					trackType = [{
						text : $.i18n("collaboration.nodePerm.repeal.label"),//撤销
						value : '0'
					}]
				 }else{
					trackType = [{
						text : $.i18n("collaboration.workflow.state.stepBack.js"),//回退
						value : '1'
					}]
				 }
			}
			searchobj = $
					.searchCondition({
						top : 7,
						right : 10,
						searchHandler : function() {
							searchFunc();
						},
						conditions : [
								{
									id : 'subject',
									name : 'subject',
									type : 'input',
									text : '${ctp:i18n("cannel.display.column.subject.label")}',//标题
									value : 'subject'
								},
								{
									id : 'senderName',
									name : 'senderName',
									type : 'input',
									text : '${ctp:i18n("common.sender.label")}',//发起人
									value : 'senderName'
								},
								{
									id : 'senderTime',
									name : 'senderTime',
									type : 'datemulti',
									text : '${ctp:i18n("common.date.sendtime.label")}',//发起时间
									value : 'senderTime',
									ifFormat : '%Y-%m-%d',
									dateTime : false
								}, {
									id : 'operationName',
									name : 'operationName',
									type : 'input',
									text : text1,//回退人
									value : 'operationName'
								}, {
									id : 'operationTime',
									name : 'operationTime',
									type : 'datemulti',
									text : text2,//回退时间
									value : 'operationTime',
									ifFormat : '%Y-%m-%d',
									dateTime : false
								}, {
									id : 'trackType',
									name : 'trackType',
									type : 'select',
									text : $.i18n("collaboration.workflow.state.js"),//状态
									value : 'trackType',
									items : trackType
								}]
					});
		}
		
		//将菜单栏中的指定菜单置为不可用
		function disableMenu(menuId){
			$("#" + menuId + "_a").attr("disabled","true").addClass("back_disable_color").addClass("common_button_disable").addClass("common_menu_dis");
		}

		//搜索框执行的动作
		function searchFunc(flag) {
			if(grid.p.total == 1 && flag){
				window.location.reload();
				return;
			}
			var o = new Object();
			var choose = $('#' + searchobj.p.id).find("option:selected").val();
			if (recordType == "stepBackRecord" || recordType == "repealRecord") {//回退
				if (choose === 'subject') {//标题
					o.subject = $('#subject').val();
				} else if (choose === 'senderName') {//发起人姓名
					o.senderName = $('#senderName').val();
				} else if (choose === 'senderTime') {//发起时间
					var fromDate = $('#from_' + choose).val();
					var toDate = $('#to_' + choose).val();
					o.senderTime = '';
					o.begin_senderTime = fromDate;
					o.end_senderTime = toDate;
				} else if (choose === 'operationName') {//操作人
					o.operationName = $('#operationName').val();
				} else if (choose === 'operationTime') {//操作时间
					var fromDate = $('#from_' + choose).val();
					var toDate = $('#to_' + choose).val();
					o.operationTime = '';
					o.begin_operationTime = fromDate;
					o.end_operationTime = toDate;
				} else if (choose === 'status') {//状态
					o.status = $('status').val();
				} else if (choose === 'trackType'){
					o.trackType = $("#trackType").val();
				}
				var val = searchobj.g.getReturnValue();
				if (val !== null) {
					//o.status = $('#status').val();
					o.app = "${ctp:escapeJavascript(param.app)}";
					o.recordType = recordType;
					//o.templeteIds = "${param.templeteIds}";
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
		if (recordType == "repealRecord") {
			var width = '36%';
			if ('${param.status}' == '1') {
				width = '40%';
			}
			//标题
			colModel.push({
				display : "${ctp:i18n('supervise.subject.label')}",
				name : 'subject',
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
				name : 'senderTime',
				width : '10%',
				cutsize : 10,
				sortable : true
			});
			//撤销人   
			colModel
					.push({
						display : "${ctp:i18n('collaboration.workflow.label.repealPeople')}",
						name : 'operationName',
						width : '11%',
						sortable : true
					});
			//撤销时间       
			colModel
					.push({
						display : "${ctp:i18n('collaboration.workflow.label.repealTime')}",
						name : 'operationTime',
						width : '10%',
						sortable : true
					});
			//状态
			colModel.push({
				display : "${ctp:i18n('collaboration.workflow.label.status')}",
				name : 'trackTypeI18n',
				width : '10%',
				sortable : true
			});
		} else if (recordType == "stepBackRecord") {
			var width = '36%';
			if ('${param.status}' == '1') {
				width = '40%';
			}
			//标题
			colModel.push({
				display : "${ctp:i18n('supervise.subject.label')}",
				name : 'subject',
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
				name : 'senderTime',
				width : '10%',
				cutsize : 10,
				sortable : true
			});
			//回退人    
			colModel
					.push({
						display : "${ctp:i18n('collaboration.workflow.label.stepbackPeople')}",
						name : 'operationName',
						width : '11%',
						sortable : true
					});
			//回退时间       
			colModel
					.push({
						display : "${ctp:i18n('collaboration.workflow.label.stepbackTime')}",
						name : 'operationTime',
						width : '10%',
						sortable : true
					});
			//状态
			colModel.push({
				display : "${ctp:i18n('collaboration.workflow.label.status')}",
				name : 'trackTypeI18n',
				width : '10%',
				sortable : true
			});
		}
		var xyms = true;
		//定义列表
		var _managerName = "traceWorkflowManager";
		var _managerMethod = "getPageInfo";
		var _callBackFun = rendRecord;
		var listDescType = "listSupervise";
		if(openFrom == "listDone"){
			listDescType = "listDone";
		}
		grid = $("#superviseList")
				.ajaxgrid(
						{
							colModel : colModel,
							click : dbclickRow,
							render : _callBackFun,
							height : 200,
							parentId : $('.layout_center').eq(0).attr('id'),
							showTableToggleBtn : true,
							vChange : true,
							vChangeParam : {
								overflow : "hidden",
								autoResize:false //表格下方是否自动显示
							},
							isHaveIframe : true,
							slideToggleBtn : true,
							onSuccess : function() {
								xyms = false;
								$('#summary')
										.attr(
												"src",
												_ctxPath
														+ "/collaboration/listDesc.do?method=listDesc&type=" + listDescType + "&size="
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
									+ "/collaboration/listDesc.do?method=listDesc&type=" + listDescType + "&size=0");
		}

		//定义回调函数
		function rendRecord(txt, data, r, c) {
			return txt;
		}

		//初始化列表数据
		var obj = new Object();
		obj.app = "${ctp:escapeJavascript(param.app)}";
		var status = '${param.status}';
		if (recordType == "repealRecord" || recordType == "stepBackRecord") {
			toolbars.unselected('listPending');
			toolbars.unselected('listDone');
			if (recordType == "stepBackRecord") {
				toolbars.selected('stepbackRecord');
			} else {
				toolbars.selected('repealRecord');
			}
			toolbars.hideBtn('deleteSupervise');
			toolbars.showBtn('deleteSupervise');
			obj.recordType = recordType;
		}
		//obj.templeteIds = "${param.templeteIds}";
		$("#superviseList").ajaxgridLoad(obj);

		//点击事件
		function dbclickRow(data, rowIndex, colIndex) {
			var url = "";
			if (recordType == "stepBackRecord") {
				url = "${path}/" + data.detailPageUrl + "&affairId="
						+ data.affairId + "&openFrom=stepBackRecord&summaryId="
						+ data.objectId + "&trackTypeRecord=" + data.trackType;
			} else if (recordType == "repealRecord") {
				url = "${path}/" + data.detailPageUrl + "&affairId="
						+ data.affairId + "&openFrom=repealRecord&summaryId="
						+ data.objectId + "&trackTypeRecord=" + data.trackType;
			}
			var title = data.subject;
			doubleClick(url, escapeStringToHTML(title));
			grid.grid.resizeGridUpDown('down');
			//页面底部说明加载
			$('#summary')
					.attr(
							"src",
							_ctxPath
									+ "/collaboration/listDesc.do?method=listDesc&type=listSupervise&size="
									+ grid.p.total);
		}
		//未办结
		function listPending() {
			var url = _ctxPath
					+ "/supervise/supervise.do?method=listSupervise&app=${ctp:escapeJavascript(param.app)}&templeteIds=${param.templeteIds}&status=0&srcFrom=${param.srcFrom}";
			window.location.href = url;
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
			if(openFrom == "listDone"){
				url = _ctxPath + "/collaboration/collaboration.do?method=listRecord&app=1&record=stepBackRecord&showPigonHoleBtn=" + showPigonHoleBtn + "&hasDumpData=" + hasDumpData;
			}
			url = addUrlPath(url);
			window.location.href = url;
		}
		//已办结
		function listDone() {
			var url = _ctxPath
					+ "/supervise/supervise.do?method=listSupervise&app=${ctp:escapeJavascript(param.app)}&templeteIds=${param.templeteIds}&status=1&srcFrom=${param.srcFrom}";
			window.location.href = url;
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
											var affairId = rows[i].affairId;
											try {
												closeOpenMultyWindow(affairId);
											} catch (e) {
											}
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
					$.alert("${ctp:i18n('collaboration.common.supervise.selectOneSupervise')}");
					return false;
				}
				str = str.substring(0, str.length - 1);
				$.confirm({
							'msg' : "${ctp:i18n('collaboration.common.supervise.sureDeleteSupervise')}", //确定要删除督办记录?'
							ok_fn : function() {
								var sup = new superviseManager();
								sup.deleteSupervisedAjax(str, {
									success : function() {
										for (var i = 0; i < rows.length; i++) {
											var affairId = rows[i].affairId;
											try {
												closeOpenMultyWindow(affairId);
											} catch (e) {
											}
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
			}
		}
	});

	function findListByStatus(status, flag, type, tempIds, bizConfigId) {
		location.href = _ctxPath
				+ "/supervise/supervise.do?method=listSupervise&status="
				+ status;
	}

	function addUrlPath(urlStr){
        var _url = urlStr;
        var _loca = window.location.href;
        
        if(_loca.indexOf("srcFrom=bizconfig") != -1){
        //控制面包削
            _url +="&srcFrom=bizconfig";
        }
        //srcFrom=bizconfig&condition=templeteIds&templeteIds=4487748473006737914;
        return _url;
    }


</script>
</head>

<body class="body-pading" leftmargin="0" topmargin="" marginwidth="0"
	marginheight="0">
	<div id='layout'>
		<div class="layout_north bg_color" id="north">
			<div class="border_lr padding_b_5">
				<!-- 如果是业务生成器创建的一个列表菜单，则不显示面包屑 -->
				<c:if test="${param.srcFrom ne 'bizconfig' }">
					<c:if test="${openFrom eq 'listDone'}">
						<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F01_listDone'"></div>
					</c:if>
					<c:if test="${openFrom ne 'listDone'}">
						<div class="comp"
							comp="type:'breadcrumb',comptype:'location',code:'${param.app=='4'?'F07_edocSupervise':'F01_supervise' }'"></div>
					</c:if>
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