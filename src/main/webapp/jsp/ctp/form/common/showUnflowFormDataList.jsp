<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="common.js.jsp"%>
<%@ include file="../component/formFieldConditionComp.js.jsp"%>
<title>信息管理数据页面</title>
<link rel="stylesheet" href="${path}/common/form/common/css/showUnflowFormDataList.css">
<script type="text/javascript" src="${path}/common/form/common/showUnflowFormDataList.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/form/common/unFlowCommon.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=formDataManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=formManager"></script>
<script type="text/javascript">
var modelType = "${modelType}";
var _newFormAuth = "${newFormAuth}";
var _formId = "${formId}";
var _formTemplateId = "${formTemplateId}";
var _formType = "${formType}";
var showFields = ${showFields};;
var _fromFormId = "${fromFormId}";
var _fromDataId = "${fromDataId}";
var _fromRecordId = "${fromRecordId}";
var _fromRelationAttr = "${fromRelationAttr}";
var toFormBean = ${toFormBean};
var _sortStr = "${sortStr}";
var _moduleType = "${moduleType}";
var queryConditionMap = {};
var _firstRightId = "${firstRightId}";
_firstRightId = _firstRightId.replaceAll("[|]","_");
var _type = "${ctp:escapeJavascript(type)}";
var locking = false;
var _editAuth = "${editAuth}";
var _editAuthJson = '${editAuthJson}';
var unlockAuth=0;
var grid;
//判断是否来源于首页无流程栏目
var isFormSection = "${isFormSection}";
var showView = "${showView}"==""?"true":"${showView}";
var urlFieldList = ${urlFieldList};
var relationInitParam = "${relationInitParam}";
var selectBtmType = (relationInitParam===""||relationInitParam==="ss"||relationInitParam==="sm")?'checkbox':"radio";
var successFlag = false;
var _templateName = "${templateName}";
var freshObj = new Object();
var operat = new Array();
var delnum=0;//用来控制显示
var gridPramsObj = new Object();
var exportType = "base";//用来判断信息管理数据是通过基础查询出来的还是通过高级查询出来的.
gridPramsObj.formId = toFormBean.id;
gridPramsObj.formTemplateId = _formTemplateId;
gridPramsObj.sortStr = _sortStr;
gridPramsObj.fromFormId = _fromFormId;
gridPramsObj.fromDataId = _fromDataId;
gridPramsObj.fromRecordId = _fromRecordId;
gridPramsObj.fromRelationAttr = _fromRelationAttr;

<c:forEach var="f" items="${searchFields}">
field = new Object();
field.fieldName = '${f.name}';
field.display = '${f.display}';
field.inputType = '${f.inputType}';
field.formatType = '${f.formatType}';
operat[operat.length] = field;
</c:forEach>
function showHelp(){
	var current_dialog = $.dialog({
		url: "${path}/form/staticFile.do?method=getUnflowSearchHelp",
		title : "${ctp:i18n('form.formulahelp.label')}",
		width:600,
		height:410,
		targetWindow:getCtpTop(),
		buttons : [{
			text : "${ctp:i18n('form.trigger.triggerSet.confirm.label')}",id:"sure",isEmphasize: true,
			handler : function() {
				current_dialog.close();
			}
		}]
	});
}
var layout;
$(document).ready(function() {
	var windowWidth = $(window).width();
	var condAreaH = 200;
	layout = new MxtLayout({
        'id': 'layout',
        <c:if test="${fn:length(searchFields) >= 1}">
        'northArea': {
	        'id': 'north',
	        'height': 200,
	        'sprit': true,
	        'maxHeight':300,
	        'minHeight':100,
	        'border': false,
	        'spritBar': true,
	        'spiretBar': {
                show: true,
                handlerB: function () {
                	if(layout.getNorthHeight() == 0){
//                    		layout.setNorth(200);
						layout.setNorth(condAreaH);
                   		setTableHeight();
                        $("#mytable").ajaxgrid().grid.resizeGrid($("#tableArea").height() - 85);
                	}
                },
                handlerT: function () {
                    layout.setNorth(0);
                    
                    setTableHeight();
                    $("#mytable").ajaxgrid().grid.resizeGrid($("#tableArea").height() - 85);
                }
            }
        },
        </c:if>
        'centerArea': {
            'id': 'center',
            'border': false,
            'minHeight':20,
        }
    });
	//表单自定义查询字段
	var formSearchFields = ${formSearchFields};
	loadSearchCondition(formSearchFields);
	condAreaH = $("#conditionArea").height();
	layout.setNorth(condAreaH);
	$("#conditionList").height($("#conditionList").height());//设置条件区的高度，方便出滚动条
	//重置
	$("#excReset").click(function(){
		loadSearchCondition(formSearchFields);
		//重置树
		window.parent.resetTree();
    });
	//执行查询
	$("#excSearch").click(function(){
		exportType = "base";
		excSearch();
    });
	
	$("#advanceSearch").click(function(){
		var qwidth = $("#highquery").width();
		var objX = $(this).offset().left;
		var objY = $(this).offset().top;
		$("#highquery").css({position: "absolute",'top':objY + 22,'left':objX - qwidth/2});
		$("#highquery").toggle();
		if($(this).attr("advanceInit")==null){
			$("#qCondition").compCondition({formId:toFormBean.id,fieldNames:operat});
			$(this).attr("advanceInit","1");
		}
	});
	/**
	 * 执行高级查询
	 */
	$("#dohighsearch").click(function (){
		exportType = "hight";
		doHighSearch();
	});
	/**
	 * 扫一扫
	 */
	$("#scanButton").unbind("click").bind("click",function(){
		openScanPort()
	});

	/**
	 * 重置查询条件
	 */
	$("#resethsearch").click(function (){
		$("#qCondition").empty();
		$("#qCondition").compCondition({formId:toFormBean.id,fieldNames:operat});
	});

	setToolbar();
	/**
	 * 初始化列表组件
	 */
	initGridAjax();
	excSearch();
	//拖动后高度重新计算
	$("#north").resize(function(){
// 		showMoreCondition();
		var conH = $("#north").height() - 46;
		$("#conditionList").css({"max-height":conH,"height":conH});
		setTableHeight();
		$("#mytable").ajaxgrid().grid.resizeGrid($("#tableArea").height() - 85);
    });
 });

function customFunction(name) {
	if (name) {
		try {
			eval(name + "()");
		}catch (e){

		}
	}
}

/**
 * 根据不同的权限,生成toolbar
 */
function setToolbar(){
	var disp='{toolbar :[';

	<c:if test="${formType == '3'}">//基础信息不需要根据权限显示toolbar
	disp+='{name : "${ctp:i18n('common.toolbar.new.label')}",click : add,className : "ico16"},';
	disp+='{name : "${ctp:i18n('common.toolbar.update.label')}",click : function(){edit({"editAuth":"${editAuth}","hideRefresh":false,"newAuthName":"","editAuthName":""})},className : "ico16 editor_16"},';
	disp+='{name : "${ctp:i18n('form.bind.bath.update.label')}",click : bathUpdate,className : "ico16 editor_16"},';
	disp+='{name : "${ctp:i18n('form.bind.bath.refresh.label')}",click : bathRefreshFun,className : "ico16 refresh_16"},';
	disp+='{name : "${ctp:i18n('addressbook.toolbar.remove.select.label')}",click : del,className : "ico16 del_16"},';
	disp+='{name : "${ctp:i18n('form.formmasterdatalist.inportexport')}",className : "ico16 import_16",subMenu : [ {name : "${ctp:i18n('form.query.transmitexcel.label')}",click :exporttoExcel},';
	disp+='{name : "${ctp:i18n('form.formlist.downinfopath')}",click : downTemplate} , {name : "${ctp:i18n('form.condition.guidein.label')}Excel",click : importExcel }]},';
	disp+='{name : "${ctp:i18n('form.print.printbutton')}",click : print,className : "ico16 print_16"},';
	disp+='{name : "${ctp:i18n('log.record.view.label')}",className : "ico16 view_log_16",subMenu : [ {name : "${ctp:i18n('log.record.single.label')}",click :singleLog},';
	disp+='{name : "${ctp:i18n('log.record.all.label')}",className : "ico16 view_log_16",click : allLog}]},';
	</c:if>



	<c:if test="${formType == '2' or formType== '5'}">
	//有新增权限
	if(_newFormAuth.split(".").length>1){
		disp+='{name : "${fn:escapeXml(newFormAuthTitle)}",click : add,className : "ico16"},';
	}

	//有修改权限
	<c:if test="${fn:length(editAuth) >= 1}">
	<c:forEach items="${editAuth}" var="eauth" varStatus="status">
	disp+='{id : "edit_${status.index}",name : "${fn:escapeXml(eauth.display)}",click : function(){edit({"editAuth":"${eauth.value}","hideRefresh":${eauth.modifyShowDeal},"newAuthName":"","editAuthName":"${fn:escapeXml(eauth.display)}"})},className : "ico16 editor_16"},';
	</c:forEach>
	</c:if>

	<c:forEach items="${authList}" var="auth">
	//批量修改
	if ("${auth.name}" === 'bathupdate' && "${auth.value}") {
		disp += '{name : "${ctp:i18n('form.bind.bath.update.label')}",click : bathUpdate,className : "ico16 editor_16"},';
		//批量刷新
	}else if("${auth.name}" === 'bathFresh' && "${auth.value}" === 'true'){
		disp += '{name : "${ctp:i18n('form.bind.bath.refresh.label')}",click : bathRefreshFun,className : "ico16 refresh_16"},';
	}else if("${auth.name}"==='allowdelete'&&"${auth.value}"==='true'&&delnum===0){
		disp+='{name : "${ctp:i18n('application.94.label')}",click : del,className : "ico16 del_16"},';
	}else if("${auth.name}"==='allowlock'&&"${auth.value}"==='true'){//加锁,解锁
		unlockAuth=1;
		disp+='{name : "${ctp:i18n('form.query.lockedstatus.label')}",click : lock,className : "ico16 locking_16"},';
		disp+='{name : "${ctp:i18n('form.query.unlock.label')}",click : unlock,className : "ico16 unlock_16"},';
	}else if("${auth.name}"==='allowexport'){//导出
		var allImp = "${allImp}";
		if("true"==allImp&&"${auth.value}"==='true'){
			disp+='{name : "${ctp:i18n('form.formmasterdatalist.inportexport')}",className : "ico16 import_16",subMenu : [ ';
			disp+='{name : "${ctp:i18n('form.query.transmitexcel.label')}",className:"export_excel_16",click :exporttoExcel},';
			disp+='{name : "${ctp:i18n('form.formlist.downinfopath')}",className:"download_16",click : downTemplate} ,';
			disp+='{name : "${ctp:i18n('application.95.label')}",className : "ico16 import_16",click : importExcel }]},';
		}else if("true"==allImp&&"${auth.value}"!=='true'){
			disp+='{name : "${ctp:i18n('form.formmasterdatalist.inportexport')}",className : "ico16 import_16",subMenu : [ ';
			disp+='{name : "${ctp:i18n('form.formlist.downinfopath')}",className:"download_16",click : downTemplate} ,';
			disp+='{name : "${ctp:i18n('application.95.label')}",className : "ico16 import_16",click : importExcel }]},';
		}else if("true"!=allImp&&"${auth.value}"==='true'){
			disp+='{name : "${ctp:i18n('form.formmasterdatalist.inportexport')}",className : "ico16 import_16",subMenu : [ ';
			disp+='{name : "${ctp:i18n('form.query.transmitexcel.label')}",className:"export_excel_16",click :exporttoExcel }]},';
		}

	}else if("${auth.name}"==='allowprint'&&"${auth.value}"==='true'){//打印
		disp+='{name : "${ctp:i18n('form.print.printbutton')}",click : print,className : "ico16 print_16"},';
	}else if("${auth.name}"==='allowlog'&&"${auth.value}"==='true'){//日志
		disp+='{name : "${ctp:i18n('log.record.view.label')}",className : "ico16 view_log_16",subMenu : [ {name : "${ctp:i18n('log.record.single.label')}",click :singleLog},';
		disp+='{name : "${ctp:i18n('log.record.all.label')}",className : "ico16 view_log_16",click : allLog}]},';
	}else if("${auth.name}"==='allowquery'&&"${auth.value}"=='true'){//查询
		<c:if test="${fn:length(queryList)>0}">
		disp+='{name : "${ctp:i18n('form.forminputchoose.search')}",className : "ico16 view_log_16",subMenu : [';
		<c:forEach items="${queryList}" var="query">
		disp+='{name : "${query.name}",click :function(){doQuery("${query.id}")}},';
		</c:forEach>
		disp=disp.substring(0, disp.length-1);
		disp+="]},";
		</c:if>
	}else if("${auth.name}"==='allowreport'&&"${auth.value}"=='true'){//统计
		<c:if test="${fn:length(reportList)>0}">
		disp+='{name : "${ctp:i18n('form.report.statbutton')}",className : "ico16 view_log_16",subMenu : [';
		<c:forEach items="${reportList}" var="report">
		disp+='{name : "${report.reportDefinition.name}",click :function(){doReport("${report.reportDefinition.id}")}},';
		</c:forEach>
		disp=disp.substring(0, disp.length-1);
		disp+="]},";
		</c:if>
	}
	</c:forEach>

	<c:if test="${fn:length(customSet) >= 1}">
	<c:forEach items="${customSet}" var="eauth" varStatus="status">
	disp+='{id : "custom_${status.index}",name : "${fn:escapeXml(eauth.display)}",click : function(){customFunction("${eauth.value}");},className : "ico16 editor_16"},';
	</c:forEach>
	</c:if>




	</c:if>


	if(disp.indexOf(",")!=-1){
		disp=disp.substring(0, disp.length-1);
	}
	disp+=']}';
	$("#toolbarArea").toolbar($.parseJSON(disp));

}
</script>
</head>
<body class="h100b overflow_hidden border_t" id="layout">
	<c:if test="${fn:length(searchFields) >= 1}">
	    <div class="layout_north" id="north">
	    	<%-- 条件区域 --%>
	       	<div id="conditionArea">
	       		<div class="condition-div relative" id="conditionList" >
				</div>
	       		<div id="conditionButton">
	       			<a href="javascript:void(0)" class="common_button common_button_emphasize margin_r_10" id="excSearch">${ctp:i18n('form.forminputchoose.search')}</a>
	       			<a href="javascript:void(0)" class="common_button margin_r_10" id="excReset">${ctp:i18n('form.compute.reset.label')}</a>
	       			<span><a id="advanceSearch" class="margin_r_10" href="javascript:void(0)">[${ctp:i18n('form.unflow.data.list.advance.query')}]</a></span>
					<c:if test="${hasBarcode == 'true'}">
						<a id="scanButton" class="scanButton" href="javascript:void(0)" title="${ctp:i18n('common.barcode.search.saoyisao')}"></a>
					</c:if>
					<span class="ico16 chm_16" onclick="showHelp()"></span>
	       			<div class="show-more" onclick="showMoreCondition();">
	       				<span>${ctp:i18n('form.unflow.data.list.condition.showmore')}</span>
	       				<span class="ico16 more_up_16"></span>
	       			</div>
	       		</div>
	       	</div>
	  	</div>
	</c:if>
	
	<%--高级查询 --%>
	<div id="highquery" class="set_search">
		<div class="conernav"></div>
		<div class="form_title"><span class="dialog_close_msg" onclick="javascript:$('#advanceSearch').trigger('click')"></span></div>
		<div class="form_name">${ctp:i18n('form.unflow.advance.query.setting.label')}</div>
		<form id="queryForm" method="post" name="queryForm">
			<div class="form_body"><div id="qCondition"></div></div>
			<div class="form_botom">
				<a id="dohighsearch" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n("common.button.condition.search.label")}</a>
				<a id="resethsearch" class="common_button" href="javascript:void(0)">${ctp:i18n("common.button.reset.label")}</a>
			</div>
		</form>
	</div>
    <div id="titleDiv">
	    <iframe id="viewFrame" class="calendar_show_iframe" src="" width="100%" height="100%" frameborder="no"></iframe>
    </div>
	<iframe id="unflowexporttoExcel" class="calendar_show_iframe" src="" width="100%" height="100%" frameborder="no"></iframe>
	<form id="unflowDownForm" method="post" action="formData.do?method=downTemplate" style="display: none">
		<input type="hidden" id="formId" value="${formId}">
		<input type="hidden" id="field">
	</form>
	<input id="myfile" type="hidden" class="comp"
		   comp="type:'fileupload',applicationCategory:'1',extensions:'xls,xlsx',quantity:1,isEncrypt:false,firstSave:true,showReplaceOrAppend:true">
	<iframe id="unflowdownTemplate" class="calendar_show_iframe" src="" width="100%" height="100%" frameborder="no"></iframe>
    <div class="layout_center over_hidden" id="center">
    	<%-- 列表区域 --%>
       	<div id="toolbarArea">
       	
       	</div>
	     <div id="tableArea">
	     	<table id="mytable">
	       	
	       	</table>
	     </div>
    </div>
    <%-- 无流程表单展示条件模版 --%>
    <%@include file="/WEB-INF/jsp/ctp/form/common/showUnflowConditionTpl.jsp" %>
	<script type="text/javascript" src="${path }/common/js/laytpl.js${ctp:resSuffix()}"></script>
	<ctp:webBarCode readerId="PDF417Reader" readerCallBack="callback" decodeParamFunction="preCallback" decodeType="unflowurl"/>
</body>
</html>