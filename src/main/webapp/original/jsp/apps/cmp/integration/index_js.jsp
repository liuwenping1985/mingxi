<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<script type="text/javascript" src="${path}/ajax.do?managerName=cmpAppManager"></script>
<script type="text/javascript">
	/*==========================================初始化============================================*/
	var toolbar = null;
 	var welcomeCountFormater = null;
 	var cmpApp = null;

 	/**
	 * 初始化
	 * 1、初始化欢迎页数据调试
	 * 2、初始化导航路径位置
	 * 3、初始化toolbar，为新建、修改、删除、列表切换绑定相应事件
	 * 4、初始化列表视图
	 * 5、加载列表数据
	 * 7、初始化欢迎页面，欢迎页面需要放在列表数据加载之后，因为需要数据总条数
	 * 8、初始化表单
	 * 9、页面第一次加载默认隐藏表单视图
	 * 10、初始化Ajax管理器，用于Ajax请求
 	*/
	$(function() {
		welcomeCountFormater = '${ctp:i18n("info.totally")}';
		showCtpLocation('CMP_mobileAppMgr');
		initToolbar();
		initGridView();
		loadGridData();
		initWelcome();
		initForm();
		formViewController(false);
		cmpApp = new cmpAppManager();
	});

	/*==========================================toolbar相关处理============================================*/
	/**
	 * 初始化toolbar，为新建、修改、删除、列表切换绑定相应事件
	 */
	function initToolbar() {
		toolbar = $("#toolbar").toolbar({
			toolbar: [{
				id: "add",
		      	name: "${ctp:i18n('common.toolbar.new.label')}",
		      	className: "ico16",
		      	click: function() {
		      		preCreateAppInfo();
		        	$("[name = imgIcon]").remove();
		      	}
		    },{
		     	id: "modify",
		      	name: "${ctp:i18n('common.button.modify.label')}",
		      	className: "ico16 editor_16",
		      	click: gridItemDoubleClickEvent
		    },{
				id: "delete",
		      	name: "${ctp:i18n('common.toolbar.delete.label')}",
		      	className: "ico16 del_16",
		      	click: function() {
					formViewController(false);
					bottomBtnViewController(false);
					welcomeViewController(true);
			        var v = $("#gridTable").formobj({
			        	gridFilter: function(data, row) {
			            	return $("input:checkbox", row)[0].checked;
			          	}
			        });
			        if(v.length < 1) {
			        	$.alert("${ctp:i18n('org.member_form.choose.personnel')}");
			            return;
			       	}else{
			        	var array = new Array();
			            for (var  i = 0; i < v.length; i++) {
			            	array.push(v[i].id);
			        	}
			            var status = v[0].status;
			            var filter = getGridFilterByStatus(status);
						$.confirm({
							title: "${ctp:i18n('common.prompt')}",
						 	'msg': "${ctp:i18n('org.member_form.choose.member.delete')}",
						    ok_fn: function() {
						    	cmpApp.deleteAppInfo(array, {
						        	success: function(result) {
										$.alert("${ctp:i18n('organization.ok')}");
						               	$("#gridTable").ajaxgridLoad(filter);
						               	gridTable.grid.resizeGridUpDown('down');
									}
								});
							}
						});
					}
				}
			},{
				id: "selectView",
				name: "${ctp:i18n('cmp.appMgr.toolbar.listToSwitch')}",
				className:"ico16 view_switch_16",
				subMenu:[{
					id:"appStar",
					name:"${ctp:i18n('cmp.appMgr.startedApps')}",
					value:1,
					click:switchStartOrStopGrid
				},{
					id:"appStop",
					name:"${ctp:i18n('cmp.appMgr.stopedApps')}",
					value:2,
					click:switchStartOrStopGrid
				}]
			}]
		});
	}

	/*==========================================列表组件相关处理============================================*/
	/**
	 * 初始化列表框架
	 */
	function initGridView() {
		grid = $("#gridTable").ajaxgrid({
			click : gridItemClickEvent,
			dblclick : gridItemDoubleClickEvent,
			colModel : [ {
				display : 'id',
				name : 'id',
				width : '5%',
				sortable : false,
				align : 'center',
				type : 'checkbox'
			}, {
				display : "${ctp:i18n('cmp.appMgr.form.label.appName')}",
				name : 'fullname',
				sortable : true,
				width : '8%'
			}, {
				display : "${ctp:i18n('cmp.appMgr.form.label.shortAppName')}",
				name : 'shortname',
				sortable : true,
				width : '8%'
			}, {
				display : "${ctp:i18n('cmp.appMgr.form.label.version')}",
				name : 'version',
				sortable : true,
				width : '8%'
			}, {
				display : "${ctp:i18n('cmp.appMgr.form.label.thirdpartyApp')}",
				name : 'thirdpartyAppName',
				sortable : true,
				width : '8%'
			}, {
				display : "${ctp:i18n('cmp.appMgr.form.label.appType')}",
				name : 'appTypeName',
				sortable : true,
				width : '8%'
			}, {
				display : "${ctp:i18n('cmp.appMgr.form.label.createdate')}",
				name : 'createdate',
				sortable : true,
				width : '12%'
			}, {
				display : "${ctp:i18n('cmp.appMgr.form.label.lastModify')}",
				name : 'lastModify',
				sortable : true,
				width : '15%'
			} ],
			managerName : "cmpAppManager",
			managerMethod : "getPageAppInfo",
			parentId : 'center',
			vChangeParam : {
				overflow : 'hidden',
				position : 'relative'
			},
			slideToggleBtn : true,
			showTableToggleBtn : true,
			vChange : true,
			callBackTotle : getCount
		});
	}

	/**
	 * 列表条目单击事件
	 */
	function gridItemClickEvent(data) {
		gridTable.grid.resizeGridUpDown('middle');
	    var detail = cmpApp.getAppInfoByID(data.id);
	    readonlyFormView(detail);
	}

	/**
	 * 列表条目双击事件
	 */
	function gridItemDoubleClickEvent() {
	    var item = $("#gridTable").formobj({
	    	gridFilter: function(data, row) {
	        	return $("input:checkbox", row)[0].checked;
	    	}
	    });
	    if(item.length < 1) {
	    	$.alert("${ctp:i18n('m1.bind.binded.noselect')}");
	    } else if (item.length > 1) {
	      	$.alert("${ctp:i18n('once.selected.one.record')}");
	    } else {
	      	preUpdateAppInfo(item);
	    }
	}

	/**
	 * 加载列表数据
	 */
	function loadGridData() {
		var filter = getGridFilterByStatus(1);
		$("#gridTable").ajaxgridLoad(filter);
	}

	/**
	 * 切换启用、停用列表
	 */
	function switchStartOrStopGrid() {
		var status = parseInt($(this).val());
		var filter = getGridFilterByStatus(status);
        $("#gridTable").ajaxgridLoad(filter);
	}

	/**
	 * 根据当前选中的状态生成对应的过滤器
	 */
	function getGridFilterByStatus(status) {
		var filter = new Object();
    	filter.status= status;
    	return filter;
	}

	/*==========================================欢迎页相关处理============================================*/
	/**
	 * 初始化欢迎页
	 */
	function initWelcome() {
		var welcomeTitle = $("#welcomeTitle");
		var title = '${ctp:i18n("cmp.appMgr.menu.MobileAccessSetting")}';
		welcomeTitle.html(title);
	}

	/**
	 * isDisplay=true,显示欢迎页，isDisplay=false隐藏欢迎页
	 */
	function welcomeViewController(isDisplay) {
		var welcomeView = $("#welcome");
		viewController(welcomeView, isDisplay);
	}

	/**
	 * 显示集成应用的总条数
	 */
	function getCount() {
		var count = gridTable.p.total;
		$("#count").get(0).innerHTML = welcomeCountFormater.format(count);
	}
	/*==========================================表单相关处理============================================*/
	/**
	 * 1、绑定应用类型改变事件
	 * 2、绑定表单取消按钮事件
	 * 3、绑定表单提交按钮事件
	 * 4、绑定授权选人事件
	 */
	function initForm(){
		bindAppTypChangeEvent();
		bindFormBtnCancel();
		bindFormBtnSubmit();
		bindChoosePersonEvent();
	}

	function bindAppTypChangeEvent() {
		$("#appType").bind("change",function(){
			var select = $(this);
			var value = select.val();
			switchFormByAppType(value);
		});
	}

	/**
	 *根据appType决定表单是实现WEB集成录入表单还是Native,appType=1表示WEB集成应用，appType=2表示本地集成应用
	*/
	function  switchFormByAppType(appType){
		if(appType == 1) {
			webViewController(true);
			nativeViewController(false);
			loadWebFormCheckRule();
		} else {
			webViewController(false);
			nativeViewController(true);
			loadNativeFormCheckRule();
		}
	}

	function bindFormBtnCancel() {
		var btncanel = $("#btncancel");
		btncanel.click(function(){location.reload();});
	}

	function bindFormBtnSubmit() {
		var btnok = $("#btnok");
		var formAera = $("#addForm");
		btnok.click(function(){
			var shortnameInput = $("input[id=shortname]");
			if(checkShortnameIsExsit(shortnameInput)){
				alert("${ctp:i18n('cmp.appMgr.prompt.shortNameExist')}");
				//$(this).select();
				return;
			}
			
			cleanAllTipsBeforeSubmit();
			if(!(formAera.validate({
				errorAlert:true
			}))) {
				return;
			}

			if (getCtpTop() && getCtpTop().startProc) {
				getCtpTop().startProc();
			}
			cmpApp.saveAppInfo($("#addForm").formobj({
		    	includeDisabled: true
		    }), {
				success: function(result) {
			    	try {
			    		if (getCtpTop() && getCtpTop().endProc) {
				        	getCtpTop().endProc();
				        	$.infor("${ctp:i18n('organization.ok')}");
							$("#id").val(result);
								formAera.jsonSubmit({
						   		domains : [ "magr_table" ],
						        debug : false,
						        callback : function(res) {
								}
							});
						}
			        }catch(e) {};
					$("#gridTable").ajaxgridLoad(getGridFilterByStatus($("#status").val()));
			        formViewController(false);
			        bottomBtnViewController(false);
			        welcomeViewController(true);
				}
			});
		});
	}

	/**
	 * 创建表单前对表单进行预处理，包括：
	 * 1、清空表单内容
	 * 2、设置表单为编辑状态
	 * 3、初始化默认值，主要针对select和radio控件
	 * 4、默认加载WEB集成应用的表单校验规则
	*/
	function preCreateAppInfo() {
		$("#addForm").clearform({
			clearHidden: true
		});
		editFormView();
		initDefaultValue();
		loadWebFormCheckRule();
		var shortnameInput = $("input[id=shortname]");
		shortnameInput.bind("blur",function(){
			if(checkShortnameIsExsit(shortnameInput)){
				alert("${ctp:i18n('cmp.appMgr.prompt.shortNameExist')}");
				//$(this).select();
				return;
			}

		});
	}

	/**
	 * 用户点击列表时显示只读表单内容
	*/
	function readonlyFormView(detail) {
		setFormViewEditStatus(false);
	    formViewController(true);
	    welcomeViewController(false);
	    bottomBtnViewController(false);
	    $("#iconUploadBtn").hide();
	    $("#addForm").fillform(detail);
	    switchFormByAppType(detail.appType);
	    initIcon(detail);
	}

	/**
	 * 将表单变为可编辑状态
	*/
	function editFormView() {
		gridTable.grid.resizeGridUpDown('middle');
		setFormViewEditStatus(true);
		formViewController(true);
		webViewController(true);
		bottomBtnViewController(true);
		nativeViewController(false);
		welcomeViewController(false);
		$("#iconUploadBtn").show();
	}

	function initDefaultValue() {
		$("input[id=status]:eq(0)").attr("checked", 'checked');
	    $("input[id=thirdpartyApp]:eq(0)").attr("checked","checked");
	    $("select").find("option[value='1']").attr("selected","selected");
	    initFieldTips();
	}

	function loadFormCheckRule(jqCtrlObj, name, isCheckNull) {
		var checkNullValidate = getCheckRuleObj('string', name, true, 1, 1024, '-!@#$%^&*()_+\"');
		var noCheckNullValidate = getCheckRuleObj('string', name, true, 1, 1024, '-!@#$%^&*()_+\"');

		var checkNullValidateJSONStr = $.toJSON(checkNullValidate);
		var noCheckNullValidateJSONStr = $.toJSON(noCheckNullValidate);

		checkNullValidateJSONStr = checkNullValidateJSONStr.substring(1, checkNullValidateJSONStr.length - 1);
		noCheckNullValidateJSONStr = noCheckNullValidateJSONStr.substring(1, noCheckNullValidateJSONStr.length - 1);

		if(isCheckNull) {
			jqCtrlObj.attr("validate", checkNullValidateJSONStr);
		} else {
			jqCtrlObj.attr("validate", noCheckNullValidateJSONStr);
		}

	}

	function getCheckRuleObj(type, name, notNull, minLength, maxLength, avoidChar) {
		var checkObj = new Object();
		checkObj.type = type;
		checkObj.name = name;
		checkObj.notNull = notNull;
		checkObj.minLength = minLength;
		checkObj.maxLength = maxLength;
		checkObj.avoidChar = avoidChar;
		return checkObj;
	}

	function loadNativeFormCheckRule() {
		var invokeAddrForWebCtrl = $("#invokeAddrForWeb");
		var invokeAddrForWebCtrlName = '${ctp:i18n('cmp.appMgr.form.label.invokeAddrForWeb')}';

		var invokeAddrForAndroidPhoneCtrl = $("#invokeAddrForAndroidPhone");
		var invokeAddrForAndroidPhoneCtrlName = '${ctp:i18n('cmp.appMgr.form.label.invokeAddrForAndroidPhone')}';
		var invokeAddrForAndroidPadCtrl = $("#invokeAddrForAndroidPad");
		var invokeAddrForAndroidPadCtrlName = '${ctp:i18n('cmp.appMgr.form.label.invokeAddrForAndroidPad')}';

		var invokeAddrForIOSPhoneCtrl = $("#invokeAddrForIOSPhone");
		var invokeAddrForIOSPhoneCtrlName = '${ctp:i18n('cmp.appMgr.form.label.invokeAddrForIOSPhone')}';
		var invokeAddrForIOSPadCtrl = $("#invokeAddrForIOSPad");
		var invokeAddrForIOSPadCtrlName = '${ctp:i18n('cmp.appMgr.form.label.invokeAddrForIOSPad')}';

		loadFormCheckRule(invokeAddrForWebCtrl, invokeAddrForWebCtrlName, false);

		loadFormCheckRule(invokeAddrForAndroidPhoneCtrl, invokeAddrForAndroidPhoneCtrlName, true);
		loadFormCheckRule(invokeAddrForAndroidPadCtrl, invokeAddrForAndroidPadCtrlName, true);

		loadFormCheckRule(invokeAddrForIOSPhoneCtrl, invokeAddrForIOSPhoneCtrlName, true);
		loadFormCheckRule(invokeAddrForIOSPadCtrl, invokeAddrForIOSPadCtrlName, true);
	}

	function loadWebFormCheckRule() {
		var invokeAddrForWebCtrl = $("#invokeAddrForWeb");
		var invokeAddrForWebCtrlName = '${ctp:i18n('cmp.appMgr.form.label.invokeAddrForPhone')}';

		var invokeExt4Ctrl = $("#ext4");
		var invokeExt4CtrlName = '${ctp:i18n('cmp.appMgr.form.label.invokeAddrForPad')}';

		var invokeAddrForAndroidPhoneCtrl = $("#invokeAddrForAndroidPhone");
		var invokeAddrForAndroidPhoneCtrlName = '${ctp:i18n('cmp.appMgr.form.label.invokeAddrForAndroidPhone')}';
		var invokeAddrForAndroidPadCtrl = $("#invokeAddrForAndroidPad");
		var invokeAddrForAndroidPadCtrlName = '${ctp:i18n('cmp.appMgr.form.label.invokeAddrForAndroidPad')}';

		var invokeAddrForIOSPhoneCtrl = $("#invokeAddrForIOSPhone");
		var invokeAddrForIOSPhoneCtrlName = '${ctp:i18n('cmp.appMgr.form.label.invokeAddrForIOSPhone')}';
		var invokeAddrForIOSPadCtrl = $("#invokeAddrForIOSPad");
		var invokeAddrForIOSPadCtrlName = '${ctp:i18n('cmp.appMgr.form.label.invokeAddrForIOSPad')}';

		loadFormCheckRule(invokeAddrForWebCtrl, invokeAddrForWebCtrlName, true);
		loadFormCheckRule(invokeExt4Ctrl,invokeExt4CtrlName,true);

		loadFormCheckRule(invokeAddrForAndroidPhoneCtrl, invokeAddrForAndroidPhoneCtrlName, false);
		loadFormCheckRule(invokeAddrForAndroidPadCtrl, invokeAddrForAndroidPadCtrlName, false);

		loadFormCheckRule(invokeAddrForIOSPhoneCtrl, invokeAddrForIOSPhoneCtrlName, false);
		loadFormCheckRule(invokeAddrForIOSPadCtrl, invokeAddrForIOSPadCtrlName, false);
	}

	/**
	 * 修改某条集成记录时，需要对表单进行预处理，包括：
	 * 1、清空表单内容
	 * 2、从后台获取指定数据的详细信息
	 * 3、将数据填充到表单中
	 * 4、将表单设置为可编辑状态
	 * 5、根据应用类型，进行表单的切换，WEB集成或Native集成
	*/
	function preUpdateAppInfo(item) {
		gridTable.grid.resizeGridUpDown('middle');
		$("#addForm").clearform({
			clearHidden: true
		});
		var detail = cmpApp.getAppInfoByID(item[0]["id"]);
		initIcon(detail);
		$("#addForm").fillform(detail);
		var shortnameInput = $("input[id=shortname]");
		shortnameInput.blur(function(){
			var shortnameValue = shortnameInput.val();
			if(shortnameValue != detail.shortname){
				if(checkShortnameIsExsit(shortnameInput)){
					alert("${ctp:i18n('cmp.appMgr.prompt.shortNameExist')}");
					//$(this).select();
					return
				}
			}
		});

		editFormView();
		switchFormByAppType(detail.appType);
	}

	function setFormViewEditStatus(isEdit) {
		var formView = $("#appMgrForm");
		editStatus(formView, isEdit);
	}

	function webViewController(isDisplay) {
		var webPhoneView = $("#webPhoneDisplayArea");
		var webPadView = $("#webPadDisplayArea");
		viewController(webPhoneView, isDisplay);
		viewController(webPadView, isDisplay);
	}

	function nativeViewController(isDisplay) {
		var nativeView = $("[id='nativeDisplayArea']");
		viewController(nativeView, isDisplay);
	}

	function formViewController(isDisplay) {
		var formView = $("#appMgrForm");
		viewController(formView, isDisplay);
	}

	function bottomBtnViewController(isDisplay) {
		var btn = $("#button");
		viewController(btn, isDisplay);
	}

	/**
	 * 初始化表单文本框中的提示文字
	*/
	function initFieldTips() {
	    var nameField = $("input[id=fullname]");
	    var shortNameField = $("input[id=shortname]");
	    var invokeAddrFroPhoneField = $("input[id=invokeAddrForWeb]");
	    var invokeAddrFroPadField = $("input[id=ext4]");
	    var versionField = $("input[id=version]");

	    var downloadAddrForAndroidPhoneField = $("input[id=downloadAddrForAndroidPhone]");
	    var invokeAddrForAndroidPhoneField = $("input[id=invokeAddrForAndroidPhone]");
	    var downloadAddrForAndroidPadField = $("input[id=downloadAddrForAndroidPad]");
	    var invokeAddrForAndroidPadField = $("input[id=invokeAddrForAndroidPad]");

	    var downloadAddrForIOSPhoneField = $("input[id=downloadAddrForIOSPhone]");
	    var invokeAddrForIOSPhoneField = $("input[id=invokeAddrForIOSPhone]");
	    var downloadAddrForIOSPadField = $("input[id=downloadAddrForIOSPad]");
	    var invokeAddrForIOSPadField = $("input[id=invokeAddrForIOSPad]");

	    displayFieldTips(nameField, "<${ctp:i18n('cmp.appMgr.form.input.tips.fullname')}>");
	    displayFieldTips(shortNameField, "<${ctp:i18n('cmp.appMgr.form.input.tips.shortname')}>");
	    displayFieldTips(invokeAddrFroPhoneField, "<${ctp:i18n('cmp.appMgr.form.input.tips.InvokeAddrForWebPhone')}>");
	    displayFieldTips(invokeAddrFroPadField, "<${ctp:i18n('cmp.appMgr.form.input.tips.InvokeAddrForWebPad')}>");
	    displayFieldTips(versionField, "<${ctp:i18n('cmp.appMgr.form.input.tips.Version')}>");


	    displayFieldTips(downloadAddrForAndroidPhoneField, "<${ctp:i18n('cmp.appMgr.form.input.tips.DownloadAddrForAndroidPhone')}>");
	    displayFieldTips(invokeAddrForAndroidPhoneField, "<${ctp:i18n('cmp.appMgr.form.input.tips.InvokeAddrForAndroidPhone')}>");
	    displayFieldTips(downloadAddrForAndroidPadField, "<${ctp:i18n('cmp.appMgr.form.input.tips.DownloadAddrForAndroidPad')}>");
	    displayFieldTips(invokeAddrForAndroidPadField, "<${ctp:i18n('cmp.appMgr.form.input.tips.InvokeAddrForAndroidPad')}>");

	    displayFieldTips(downloadAddrForIOSPhoneField, "<${ctp:i18n('cmp.appMgr.form.input.tips.DownloadAddrForIOSPhone')}>");
	    displayFieldTips(invokeAddrForIOSPhoneField, "<${ctp:i18n('cmp.appMgr.form.input.tips.InvokeAddrForIOSPhone')}>");
	    displayFieldTips(downloadAddrForIOSPadField, "<${ctp:i18n('cmp.appMgr.form.input.tips.DownloadAddrForIOSPad')}>");
	    displayFieldTips(invokeAddrForIOSPadField, "<${ctp:i18n('cmp.appMgr.form.input.tips.InvokeAddrForIOSPad')}>");

	    bindFieldTipsEvent(nameField, "<${ctp:i18n('cmp.appMgr.form.input.tips.fullname')}>");
	    bindFieldTipsEvent(shortNameField, "<${ctp:i18n('cmp.appMgr.form.input.tips.shortname')}>");
	    bindFieldTipsEvent(invokeAddrFroPhoneField, "<${ctp:i18n('cmp.appMgr.form.input.tips.InvokeAddrForWebPhone')}>");
		bindFieldTipsEvent(invokeAddrFroPadField, "<${ctp:i18n('cmp.appMgr.form.input.tips.InvokeAddrForWebPad')}>");
	    bindFieldTipsEvent(versionField, "<${ctp:i18n('cmp.appMgr.form.input.tips.Version')}>");

	    bindFieldTipsEvent(downloadAddrForAndroidPhoneField, "<${ctp:i18n('cmp.appMgr.form.input.tips.DownloadAddrForAndroidPhone')}>");
	    bindFieldTipsEvent(invokeAddrForAndroidPhoneField, "<${ctp:i18n('cmp.appMgr.form.input.tips.InvokeAddrForAndroidPhone')}>");
	    bindFieldTipsEvent(downloadAddrForAndroidPadField, "<${ctp:i18n('cmp.appMgr.form.input.tips.DownloadAddrForAndroidPad')}>");
	    bindFieldTipsEvent(invokeAddrForAndroidPadField, "<${ctp:i18n('cmp.appMgr.form.input.tips.InvokeAddrForAndroidPad')}>");

	    bindFieldTipsEvent(downloadAddrForIOSPhoneField, "<${ctp:i18n('cmp.appMgr.form.input.tips.DownloadAddrForIOSPhone')}>");
	    bindFieldTipsEvent(invokeAddrForIOSPhoneField, "<${ctp:i18n('cmp.appMgr.form.input.tips.InvokeAddrForIOSPhone')}>");
	    bindFieldTipsEvent(downloadAddrForIOSPadField, "<${ctp:i18n('cmp.appMgr.form.input.tips.DownloadAddrForIOSPad')}>");
	    bindFieldTipsEvent(invokeAddrForIOSPadField, "<${ctp:i18n('cmp.appMgr.form.input.tips.InvokeAddrForIOSPad')}>");
	}

	function cleanAllTipsBeforeSubmit() {
		var nameField = $("input[id=fullname]");
	    var shortNameField = $("input[id=shortname]");
	    var invokeAddrField = $("input[id=invokeAddrForWeb]");
	    var invokeAddrFieldExt4 = $("input[id=ext4]");
	    var versionField = $("input[id=version]");

	    var downloadAddrForAndroidPhoneField = $("input[id=downloadAddrForAndroidPhone]");
	    var invokeAddrForAndroidPhoneField = $("input[id=invokeAddrForAndroidPhone]");
	    var downloadAddrForAndroidPadField = $("input[id=downloadAddrForAndroidPad]");
	    var invokeAddrForAndroidPadField = $("input[id=invokeAddrForAndroidPad]");

	    var downloadAddrForIOSPhoneField = $("input[id=downloadAddrForIOSPhone]");
	    var invokeAddrForIOSPhoneField = $("input[id=invokeAddrForIOSPhone]");
	    var downloadAddrForIOSPadField = $("input[id=downloadAddrForIOSPad]");
	    var invokeAddrForIOSPadField = $("input[id=invokeAddrForIOSPad]");

	    clearFieldTips(nameField, "<${ctp:i18n('cmp.appMgr.form.input.tips.fullname')}>");
	    clearFieldTips(shortNameField, "<${ctp:i18n('cmp.appMgr.form.input.tips.shortname')}>");
	    clearFieldTips(invokeAddrField, "<${ctp:i18n('cmp.appMgr.form.input.tips.InvokeAddrForWebPhone')}>");
	    clearFieldTips(invokeAddrFieldExt4,"<${ctp:i18n('cmp.appMgr.form.input.tips.InvokeAddrForWebPad')}>");
	    clearFieldTips(versionField, "<${ctp:i18n('cmp.appMgr.form.input.tips.Version')}>");

	    clearFieldTips(downloadAddrForAndroidPhoneField, "<${ctp:i18n('cmp.appMgr.form.input.tips.DownloadAddrForAndroidPhone')}>");
	    clearFieldTips(invokeAddrForAndroidPhoneField, "<${ctp:i18n('cmp.appMgr.form.input.tips.InvokeAddrForAndroidPhone')}>");
	    clearFieldTips(downloadAddrForAndroidPadField, "<${ctp:i18n('cmp.appMgr.form.input.tips.DownloadAddrForAndroidPad')}>");
	    clearFieldTips(invokeAddrForAndroidPadField, "<${ctp:i18n('cmp.appMgr.form.input.tips.InvokeAddrForAndroidPad')}>");

	    clearFieldTips(downloadAddrForIOSPhoneField, "<${ctp:i18n('cmp.appMgr.form.input.tips.DownloadAddrForIOSPhone')}>");
	    clearFieldTips(invokeAddrForIOSPhoneField, "<${ctp:i18n('cmp.appMgr.form.input.tips.InvokeAddrForIOSPhone')}>");
	    clearFieldTips(downloadAddrForIOSPadField, "<${ctp:i18n('cmp.appMgr.form.input.tips.DownloadAddrForIOSPad')}>");
	    clearFieldTips(invokeAddrForIOSPadField, "<${ctp:i18n('cmp.appMgr.form.input.tips.InvokeAddrForIOSPad')}>");
	}

	function bindFieldTipsEvent(field, text) {
		field.focus(function(){
			clearFieldTips(field, text);
		});
		field.blur(function(){
			displayFieldTips(field, text);
		});
	}

	function displayFieldTips(field, text) {
		var currentValue = field.val();
		if(currentValue == "") {
			field.val(text);
		}
	}

	function clearFieldTips(field, text) {
		var currentField = field.val();
		if(currentField == text) {
			field.val("");
		}
	}
	function iconUploadCallback(obj) {
		var attList = obj.instance;
		var len = attList.length;
		for(var i = 0; i < len; i++) {
			var att = attList[i];
			var fileID = att.fileUrl;
			//var createdate = att.createDate;
			var createdate = (att.createDate && att.createDate != undefined) ? att.createDate : new Date().newFormat("yyyy-MM-dd");

			var iconDownloadUrl = "${path}/fileUpload.do?method=showRTE&fileId="+fileID+"&createDate="+createdate+"&type=image";
			var imageAreaStr = 	"<img name='imgIcon' id = 'imgIcon' src='" + iconDownloadUrl + "' width='75' height='75'>";

			var iconValue = "/fileUpload.do?method=showRTE&fileId="+fileID+"&createDate="+createdate+"&type=image";
			$("#icon").val(iconValue);
			$("#iconDiv").html(imageAreaStr);
		}
	}

	function initIcon(detail) {
		var iconAddr = detail.icon;
		if(iconAddr != "" && iconAddr != null) {
			var iconDownloadUrl = "${path}" + iconAddr;
			var imageAreaStr = 	"<img name='imgIcon' id = 'imgIcon' src='" + iconDownloadUrl + "' width='75' height='75'>";
			$("#iconDiv").html(imageAreaStr);
		}else {
            $("#iconDiv").html("");
        }
	}
	/**
	  *校验简称是否唯一
	  */
	function checkShortnameIsExsit(shortnameInput){
			var shortname = shortnameInput.val();
			var id = $("#id").val();
			var hasApp = cmpApp.getAppInfoByShortName(shortname,id);
			if(hasApp == true){
				return true;
			}
			return false;
	}

	/**
	* 绑定授权选人事件
	*/
	function bindChoosePersonEvent() {
		var choosePersonCtr = $("#authedScopeNames");
		choosePersonCtr.unbind("click").bind("click",function() {
			$.selectPeople({
			      type: 'selectPeople',
			      panels: 'Department,Post,Level,Outworker',
			      selectType: 'Account,Department,Member',
			      minSize:0,
			      maxSize:100,
			      showConcurrentMember:false,
			      onlyLoginAccount: false,
			      returnValueNeedType: true,
			      text : $("#authedScopeNames").val(),
			      params: {value:$("#authedScopeIds").val()},
			      callback: function(ret) {
			    	 choosePersonCtr.val(ret.text);
			    	 $("#authedScopeIds").val(ret.value);
			    	 $.alert("${ctp:i18n('cmp.appMgr.prompt.authedUser.success')}");
			      }
		    });
		});
	}


/*==========================================公共方法============================================*/
	/**
	 * 控制指定控件显示与否，isDisplay=true，表示显示，反之，则不显示
	*/
	function viewController(jqCtrlObj, isDisplay) {
		if(isDisplay) {
			jqCtrlObj.show();
		} else {
			jqCtrlObj.hide();
		}
	}

	/**
	 * 控制指定控件编辑状态，isEdit=true表示可编辑，反之则只读
	*/
	function editStatus(jqCtrlObj, isEdit) {
		if(isEdit) {
			jqCtrlObj.enable();
		} else {
			jqCtrlObj.disable();
		}
	}


	/**
	    * 日期格式化
	    * @param format
	    * @returns {*}
	    */
	Date.prototype.newFormat = function(format) {
	    var o = {
	    	"M+": this.getMonth() + 1, //month
	    	"d+": this.getDate(), //day
	    	"h+": this.getHours(), //hour
	    	"m+": this.getMinutes(), //minute
	    	"s+": this.getSeconds(), //second
	    	"q+": Math.floor((this.getMonth() + 3) / 3), //quarter
	    	"S": this.getMilliseconds() //millisecond
	    };
	    if (/(y+)/.test(format)) format = format.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
	    for (var k in o)
	    if (new RegExp("(" + k + ")").test(format))
	    format = format.replace(RegExp.$1,
	    RegExp.$1.length == 1 ? o[k] :
	    ("00" + o[k]).substr(("" + o[k]).length));
	    return format;
	};

</script>