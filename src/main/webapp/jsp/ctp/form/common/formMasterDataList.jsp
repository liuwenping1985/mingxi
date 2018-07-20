<%--
 $Author: weijh $
 $Rev: 9416 $
 $Date:: 2012-12-12 12:46:11#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="common.js.jsp"%>
<%@ include file="../component/formFieldConditionComp.js.jsp"%>
<html class="h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n("form.formmasterdatalist.title")}</title>
</head>
    <script type="text/javascript" src="${path}/common/form/common/formMasterDataList.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" src="${path}/ajax.do?managerName=formManager"></script>
    <script type="text/javascript" src="${path}/ajax.do?managerName=formDataManager"></script>
    <%-- 如果来源于首页栏目时，加载JS --%>
    <c:if test="${isFormSection eq 'true'}">
        <script type="text/javascript" src="${path}/common/form/common/unflowQueryResultSection.js${ctp:resSuffix()}"></script>
    </c:if>
    
    <script type="text/javascript">
    var grid;
    //是否有解锁权限,0表示没有,1表示有
    var delnum=0;//用来控制显示
    var unlockAuth=0;
    var chekcSerch=true;
    var numleft=0;
    var numright=0;
    var toFormBean = ${toFormBean};
    var relationInitParam = "${relationInitParam}";
    //判断是否来源于首页无流程栏目
    var isFormSection = "${isFormSection}";
    var _type = "${ctp:escapeJavascript(type)}";
    var _formType = "${formType}";
    var _newFormAuth = "${newFormAuth}";
    var _moduleType = "${moduleType}";
    var _formId = "${formId}";
    var _firstRightId = "${firstRightId}";
    var _formTemplateId = "${formTemplateId}";
    var _templateName = "${templateName}";
    var _sortStr = "${sortStr}";
    var _editAuth = "${editAuth}";
    var _editAuthJson = '${editAuthJson}';
    var _commonSearchFields = ${commonSearchFields};
    var urlFieldList = ${urlFieldList};
    var selectBtmType = (relationInitParam===""||relationInitParam==="ss"||relationInitParam==="sm")?'checkbox':"radio";
    var v3x = new V3X();
    var showFields = [];
    var queryConditionMap = {};
    //列表加载需要的参数对象；替换页面中每次需要重新加载前构造的对象全部使用该全局对象代替，防止丢失了用户自己设置的过滤条件。by zhangc
    var gridPramsObj = new Object();
    gridPramsObj.formId = toFormBean.id;
    gridPramsObj.formTemplateId = _formTemplateId;
    gridPramsObj.sortStr = _sortStr;
    
    var _fromFormId = "${fromFormId}";
    var _fromDataId = "${fromDataId}";
    var _fromRecordId = "${fromRecordId}";
    var _fromRelationAttr = "${fromRelationAttr}";
    
    gridPramsObj.fromFormId = _fromFormId;
    gridPramsObj.fromDataId = _fromDataId;
    gridPramsObj.fromRecordId = _fromRecordId;
    gridPramsObj.fromRelationAttr = _fromRelationAttr;
    
    $(document).ready(function() {
        try{
            dispConditon();
            showFormData(toFormBean);
            $("#titleDiv").show();
            if(_type=="baseInfo"){
                setToolbar();
                $("#titleDiv").find("h2").text(_templateName);
            }else{
                $("#titleDiv").css("display","none");
            }
        }catch(e){
        }
        //只有关联的时候才会如此
        if(_type == "formRelation"){
            checkBindNum();
        }
        $("#searchBtn").click(function(){
            doSearch();
        });
        $("#advanceSearch").click(function(){
            $("#highquery").toggle();
            if($(this).attr("advanceInit")==null){
                var operat = new Array();
                var field;
                <c:forEach var="f" items="${searchFields}">
                field = new Object();
                field.fieldName = '${f.name}';
                field.display = '${f.display}';
                field.inputType = '${f.inputType}';
                field.formatType = '${f.formatType}';
                operat[operat.length] = field;
                </c:forEach>
                $("#qCondition").compCondition({formId:toFormBean.id,fieldNames:operat});
                $(this).attr("advanceInit","1");
            }
        });

        $("#dohighsearch").click(function (){
            var checkData = true;
            if($(".fieldName").length>1){
                $(".fieldName").each(function(index){
                    var temValue = $(this).val();
                    if(temValue == ""){
                        $.alert($.i18n('form.query.defineConditionFieldNotNull'));
                        checkData = false;
                        return false;
                    }
                });
            }
            if(!checkData){
                return;
            }
            if(!$.validateBrackets()){
                return;
            }
            $.setFieldValueSubmit();
            numleft=0;
            numright=0;
            //新建对象擦除痕迹；
            gridPramsObj = new Object();
            gridPramsObj.formId = toFormBean.id;
            gridPramsObj.formTemplateId = _formTemplateId;
            gridPramsObj.sortStr = _sortStr;
            
            gridPramsObj.fromFormId = _fromFormId;
            gridPramsObj.fromDataId = _fromDataId;
            gridPramsObj.fromRecordId = _fromRecordId;
            gridPramsObj.fromRelationAttr = _fromRelationAttr;
            
            var obj=$("#qCondition").formobj({validate : false});
            gridPramsObj.highquery=obj;
            queryConditionMap = {};
            var objNewArray = [];
            if(obj instanceof Array){
                for(var i=0; i < obj.length;i++){
                    var objNewValue ={};
                    objNewValue.fieldName = obj[i].fieldName;
                    objNewValue.fieldValue = encodeURIComponent(obj[i].fieldValue);
                    objNewValue.operation = obj[i].operation;
                    objNewValue.leftChar = obj[i].leftChar;
                    objNewValue.rightChar = obj[i].rightChar;
                    objNewValue.rowOperation = obj[i].rowOperation;
                    objNewArray[i]= objNewValue;
                }
                queryConditionMap["highquery"]=objNewArray;
            }else{
                var objNewValue  ={};
                objNewValue.fieldName = obj.fieldName;
                objNewValue.fieldValue = encodeURIComponent(obj.fieldValue);
                objNewValue.leftChar = obj.leftChar;
                objNewValue.rightChar = obj.rightChar;
                objNewValue.operation = obj.operation;
                objNewValue.rowOperation = obj.rowOperation;
                queryConditionMap["highquery"]=objNewValue;
            }
            $("#highquery").toggle();
            $("#mytable").ajaxgridLoad(gridPramsObj).width("");
        });

        $("#resethsearch").click(function (){
            $("#userConditionTable").empty();
            $("#userConditionTable").append($("body").data("cloneUserCondition").clone(true));
        });
    });
    
    function showFormData(formObj){
        new MxtLayout({
            'id' : 'layout',
            'northArea' : {
            'id' : 'north',
            'height' : 35,
            'sprit' : false
            },
            'centerArea' : {
            'id' : 'center',
            'border' : false
            },
            <c:if test="${type!='formRelation'}">
            'southArea':{
            'id' : 'viewSouth'
            },
            </c:if>
            'successFn' : function() {
                //构造动态表表头
                var theadarr = [{
                    display : 'id',
                    name : 'id',
                    width : '30',
                    sortable : false,
                    align : 'left',
                    type : selectBtmType
                },{
                	display : '<span class="ico16 locking_16"></span>',
                    name : 'state',
                    width : '25',
                    sortable : false,
                    align : 'left'
                }];
                var _width = $("body").width()-25;//宽度-id的宽度
                var num=2;//用来控制表头的显示
                //基础信息无锁定
                if( _formType ==='3'){
                    theadarr.pop();
                    _width = _width - 25//锁的宽度
                    num=1;
                }
                showFields = ${showFields};
                var _colWidth = 100;
                if(showFields.length>=10){
                    _colWidth = _width/10;
                }else{
                    _colWidth = _width/showFields.length;
                }
                var width = getTHWidthTable(showFields.length);
                for(var i=0;i<showFields.length;i++){
                    showFields[i].width = width;
                    showFields[i].align ='left';
                    theadarr.push(showFields[i]);
                }
                //定义默认的列表参数
                var firstListSize = 36;
                var _resizable = true;
                var _slideToggleBtn = true;
                var _vChange = true;
                if(isFormSection == "true"){
                    _resizable = false;
                    _slideToggleBtn = false;
                    _vChange = false;
                }
                grid = $("#mytable").ajaxgrid({
                    parentId : "center",
                    colModel : theadarr,
                    managerName : "formManager",
                    managerMethod : "getFormMasterDataListByFormId",
                    click :clk,
                    dblclick : dblclk,
                    callBackTotle:callBackTotal,
                    minwidth:50,
                    usepager : true,
                    useRp : true,
                    render : rend,
                    showTableToggleBtn : true,
                    customId : "customId_${formTemplateId}",
                    customize:false,
                    resizable : _resizable,
                    vChange :_vChange,
                    isHaveIframe:true,
                    rpMaxSize:999,
                    vChangeParam: {
                        overflow: "hidden",
                        autoResize:true
                    },
                    slideToggleBtn: _slideToggleBtn,
                    onSuccess:successFn
                });
               	$("#mytable").ajaxgridLoad(gridPramsObj);
            }
        });
    }
    
    //根据不同的权限,显示不同的toolbar
    function setToolbar(){
        var disp='{toolbar :[';
        <c:if test="${formType == '3'}">//基础信息不需要根据权限显示toolbar
            disp+='{name : "${ctp:i18n('common.toolbar.new.label')}",click : add,className : "ico16"},';
            disp+='{name : "${ctp:i18n('common.toolbar.update.label')}",click : function(){edit({"editAuth":"${editAuth}","hideRefresh":false,"newAuthName":"","editAuthName":""})},className : "ico16 editor_16"},';
            //批量刷新
            disp += '{name : "${ctp:i18n('form.bind.bath.update.label')}",click : bathUpdate,className : "ico16 editor_16"},';
            disp+='{name : "${ctp:i18n('form.bind.bath.refresh.label')}",click : bathRefreshFun,className : "ico16 refresh_16"},';
            disp+='{name : "${ctp:i18n('addressbook.toolbar.remove.select.label')}",click : del,className : "ico16 del_16"},';
            disp+='{name : "${ctp:i18n('form.formmasterdatalist.inportexport')}",className : "ico16 import_16",subMenu : [ {name : "${ctp:i18n('form.query.transmitexcel.label')}",click :exporttoExcel},';
            disp+='{name : "${ctp:i18n('form.formlist.downinfopath')}",click : downTemplate} , {name : "${ctp:i18n('form.condition.guidein.label')}Excel",click : inportExcel }]},';
            disp+='{name : "${ctp:i18n('form.print.printbutton')}",click : print,className : "ico16 print_16"},';
            disp+='{name : "${ctp:i18n('log.record.view.label')}",className : "ico16 view_log_16",subMenu : [ {name : "${ctp:i18n('log.record.single.label')}",click :singleLog},';
            disp+='{name : "${ctp:i18n('log.record.all.label')}",className : "ico16 view_log_16",click : allLog}]},';
        </c:if>
        <c:if test="${formType == '2'}">//信息管理需要根据权限显示toolbar
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
                    //有新增权限时才有模板下载的权限
                    if(_newFormAuth.split(".").length>1&&"${auth.value}"==='true'){
                        disp+='{name : "${ctp:i18n('form.formmasterdatalist.inportexport')}",className : "ico16 import_16",subMenu : [ ';
                        disp+='{name : "${ctp:i18n('form.query.transmitexcel.label')}",className:"export_excel_16",click :exporttoExcel},';
                        disp+='{name : "${ctp:i18n('form.formlist.downinfopath')}",className:"download_16",click : downTemplate} ,';
                        disp+='{name : "${ctp:i18n('application.95.label')}",className : "ico16 import_16",click : inportExcel }]},';
                    }else if(_newFormAuth.split(".").length>1&&"${auth.value}"!=='true'){
                        disp+='{name : "${ctp:i18n('form.formmasterdatalist.inportexport')}",className : "ico16 import_16",subMenu : [ ';
                        disp+='{name : "${ctp:i18n('form.formlist.downinfopath')}",className:"download_16",click : downTemplate} ,';
                        disp+='{name : "${ctp:i18n('application.95.label')}",className : "ico16 import_16",click : inportExcel }]},';
                    }else if(_newFormAuth.split(".").length<=1&&"${auth.value}"==='true'){
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
        </c:if>
        //disp+='{name : "移动端列表",click : mobileList,className : "ico16"},';
        //去掉最后一个,
        if(disp.indexOf(",")!=-1){
            disp=disp.substring(0, disp.length-1);
        }
        disp+=']}';
        $("#toolbar").toolbar($.parseJSON(disp));
    }

    //使用el表达式(fn:length)取数量有点问题,改用此方法
    function dispConditon(){
        var check=0;
        <c:forEach items="${searchFields}" var="field">
            check++;
        </c:forEach>
        if(check>0){
            setSearchToolbar();
        }
    }
    function successFn(){
        $('.flexigrid :radio').removeClass('noClick');
    }
    function mobileList(){
        var newFormAuth = _newFormAuth;
        var strs = newFormAuth.split(".");
        var viewId = strs[0];
        var rightId = strs[1];
		var url = _ctxPath+"/form/lightForm.do?method=formDataList&formId="+_formId+"&formTemplateId="+_formTemplateId+"&rightId="+rightId;
		openCtpWindow({"url":url});
    }
    function checkBindNum(){
        var pramsObj = {};
        var fdManager  = new formDataManager();
        pramsObj.formId = toFormBean.id;
        fdManager.checkBindsNum(pramsObj,{
            success: function(msg){  //查核通过
               if(msg){
                   $.alert(msg);
               }
            }
        });
    }
    </script>
<body class="h100b over_hidden">
	<c:if test="${param.srcFrom eq 'bizconfig' }">
		<div class="comp" comp="type:'breadcrumb',comptype:'location'"></div>
	</c:if>
	<div id="unflowFormDataList" class="comp" comp="type:'layout'">
		<%-- 北边部分包括toolbar和查询条件 --%>
		<div id="north" class="layout_north page_color"
			layout="height:30,maxHeight:30,minHeight:30,spiretBar:{show:false}"
			style="border-top: none;">
			<div id="toolbar"></div>
		</div>
		<div id="advanceSearchDiv"
			style="top: 10px; right: 0px; position: absolute; z-index: 1000000; display: none;">
			<span id="advanceSearch" class="ico16 advanced_16"></span>
		</div>
		<%-- 中间是主表数据列表 --%>
		<div id="center" class="layout_center over_hidden"
			layout="border:false">
			<table class="flexme3 " style="display: none" id="mytable"></table>
			<%-- 如果不是关联表单弹出框，则显示视图iframe --%>
			<div id="grid_detail">
				<div id="titleDiv" class="clearfix margin_t_20 margin_b_10"
					style="display: none">
					<h2 class="left margin_0">信息管理</h2>
					<div class="font_size12 left margin_l_10">
						<div class="margin_t_10 font_size14">
							${ctp:i18n('formsection.infocenter.total')} <span class="font_bold color_black">4</span> ${ctp:i18n('formsection.infocenter.num')}
						</div>
					</div>
				</div>
				<iframe id="viewFrame" class="calendar_show_iframe" src=""
					width="100%" height="100%" frameborder="no"></iframe>
			</div>
		</div>
		<input id="myfile" type="hidden" class="comp"
			comp="type:'fileupload',applicationCategory:'1',extensions:'xls,xlsx',quantity:1,isEncrypt:false,firstSave:true,showReplaceOrAppend:true">
		<%--高级查询 --%>
		<div id="highquery" class="set_search"
			style="width: 550px; height: 125px; top: 33px; right: 17px; overflow: auto; display: none; position: absolute; z-index: 104; border: 1px #cccccc solid; background-color: #e3f2fb;">
			<form id="queryForm" method="post" name="queryForm">
				<div style="padding-top: 6px;">
					<div id="qCondition"></div>
					<div
						style="padding-left: 250px; padding-top: 10px; padding-bottom: 15px;">
						<a id="dohighsearch" class="common_button common_button_gray"
							href="javascript:void(0)">${ctp:i18n("common.button.condition.search.label")}</a>
						<a id="resethsearch" class="common_button common_button_gray"
							href="javascript:void(0)">${ctp:i18n("common.button.reset.label")}</a>
					</div>
				</div>
			</form>
		</div>
		<%--end --%>
	</div>
	<iframe id="exporttoExcel" style="display: none"></iframe>
	<iframe id="downTemplate" style="display: none"></iframe>
</body>
</html>