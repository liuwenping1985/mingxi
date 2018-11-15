<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext,java.util.Locale"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.util.json.JSONUtil,java.util.Locale"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.constants.ProductEditionEnum,java.util.Locale"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<!DOCTYPE html>
<html>
<head>
    <title>无流程表单列表</title>
    <meta charset="utf-8">
    <meta name="apple-touch-fullscreen" content="yes"/>
    <meta name="apple-mobile-web-app-capable" content="yes"/>
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no"/>
    <script src="${ctp_contextPath}/common/form/lightFormList/controls_common/script/jquery-debug.js"></script>
    <!--jquery.mobile-->
    <link href="${ctp_contextPath}/common/form/lightFormList/controls_common/jquery.moblie/jquery.mobile-debug.css" rel="stylesheet"/>
    <script src="${ctp_contextPath}/common/form/lightFormList/controls_common/jquery.moblie/jquery.mobile-debug.js"></script>
    <script type="text/javascript" src="${ctp_contextPath}/common/form/lightFormList/controls_iphone/iscroll.js"></script>
    <script type="text/javascript" src="${ctp_contextPath}/common/form/lightFormList/controls_iphone/seework.ui.iphone-debug.js"></script>
    <script type="text/javascript" src="${ctp_contextPath}/common/js/misc/Moo-debug.js"></script>
    <script type="text/javascript" src="${ctp_contextPath}/common/js/misc/jsonGateway-debug.js"></script>
    <script type="text/javascript" src="${ctp_contextPath}/common/js/jquery.hotkeys-debug.js"></script>
    <script type="text/javascript" src="${ctp_contextPath}/common/js/ui/seeyon.ui.checkform-debug.js"></script>
    <script type="text/javascript" src="${ctp_contextPath}/common/js/jquery.json-debug.js"></script>
    <script type="text/javascript" src="${ctp_contextPath}/ajax.do?managerName=formManager"></script>
    <script type="text/javascript" src="${ctp_contextPath}/common/form/lightFormList/controls_iphone/mobiscroll.date-min.js"></script> 
    
    <script src="${ctp_contextPath}/cmp/commons/jquery/jquery.json.js"></script>
    <script src="${ctp_contextPath}/cmp/plugins/new_choose/js/CMPUtils.js"></script>
    <script src="${ctp_contextPath}/cmp/plugins/new_choose/js/CMPChoosePerson.js"></script>
    <!--自定义样式-->
    <link href="${ctp_contextPath}/common/form/lightFormList/controls_common/css/seework-common-debug.css" rel="stylesheet"/>
    <link href="${ctp_contextPath}/common/form/lightFormList/controls_iphone/skin/seework/css/css-debug.css" rel="stylesheet"/>
    <link href="${ctp_contextPath}/common/form/lightFormList/controls_iphone/skin/seework/css/mobile-date-skin-min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="${ctp_contextPath}/cmp/plugins/new_choose/css/cmp_common.css" />
    <link rel="stylesheet" href="${ctp_contextPath}/cmp/plugins/new_choose/css/cmp_choose_person.css" />
    <link rel="stylesheet" href="${ctp_contextPath}/cmp/plugins/new_choose/css/cmp_choose_dept.css" />
</head>
<body>
<section data-role="page" id="form_list">
    <header data-role="header" class="flexible_box seework_app_header">
        <div>
            <a href="#" data-transition="slidefade" data-rel="back" class="iphone40 return_40"></a>
        </div>
         <h1 class="adaptive_box_flex"><span class="form_logo"></span>${formName}</h1>
    </header>
    <div data-role="content" id="form_list_content" class="comp" 
     comp="type:'tabs',tabType:'navbar',scrollState:true,hideLayerOpen:true,changeParentId:'form_list_content',tabBorderClass:'form_tab_none',callBack:formListTab">
        <!--  表单查询块开始-->
        <%@ include file="include_formdata_condition.jsp"%>
         <!-- 表单查询块结束-->
        <div class="wrapper over_y_auto pos_relative form_list_content no_content_1351 no_content_hide" id="search_result">
            <div class="scroller comp" comp="type:'list',listType:'dataRefresh',callBack:userList">
              
            </div>
        </div>
    </div>
    <c:if test="${moduleType!=37 || (moduleType==37&&newFormAuth)}">
    <a href="#" id="newBtn"  data-transition="slidefade" data-ajax="false" data-role="button" data-inline="ture" class="new_built_btn"></a>
    </c:if>
    <script type="text/javascript">
       var  _ctxServer = '${ctp_contextPath}';
       var _currentAccountId = '${CurrentUser.loginAccount}';
        // 保存条件的数组
        var userConditionArray = new Array();
        // 控件序号
	    var reportIndex;
	    // 控件名称
	    var queryName;
	    
	    // 统计关系
		var operation;
		 // 当前查询控件的排序号
	    var activeNum;
	    // 开关val属性
	    var checkBoxV;
	    // 选择的年份
	    var selectedYear;
	    // 选择的月份
	    var selectedMonth;
	    // 当月最大天数
	    var currtMonthMaxDay;
	    // 选择的日
	    var selectedDay;
        var pageNum = 1;
        var _formId = "${formId}";
        var _formTemplateId = "${formTemplateId}";
        var _moduleType = "${moduleType}";
        $().ready(function(){
            initBtn();
        });

        function initBtn(){
            $("#newBtn").attr("href","${ctp_contextPath}/content/content.do?newTag=true&isFullPage=true&moduleId="+_formTemplateId+"&moduleType="+_moduleType+"&rightId=${rightId}&contentType=20&viewState=1&style=4");
        }
       
        /**
         * list点击数据扩展方法
         * @param obj 当前点击对象
         * @param objId 当前点击对象的自定义属性，对应下面的listId，每条数据的唯一标示符
         */
        function userList(obj,objId){
            var url = getDetailFormDataUrl(objId);
            window.location.href=url;
//             var data_obj = "";
//             toNextPage(url,data_obj);
        }
        /**
         * 搜索扩展方法
         * @param thisObj 当前点击对象
         * @param index 当前点击对象的index值
         * @param domObj 父级对象
         */
         var formListTab=function (thisObj,domObj,tgtId){
        	// 判断触发的控件是否是选人控件
        	isMember();
            // 触发操作
            triggerOper();
            var tab_height = parseInt($("body").height()*0.8);
            var tab_w = parseInt($("body").width());
            var tab_de_height = 87;
            activeNum = $('.ui-btn-active input').attr("index");
            switch (tgtId){
                case "inquiry_com_list"+activeNum: // 普通下拉框
                    var p_list = $("#inquiry_com_list"+activeNum).find("p").length;
                    var obj_h = p_list * 45 + 48;
                    if(obj_h > tab_height){
                        $(".inquiry_content").height(tab_height);
                    }
                    else{
                        $(".inquiry_content").height(obj_h);
                    }
                    $.loadedScroll("inquiry_text_content",1,"v");
                    break;
                case "alone_year"+activeNum: // 年下拉框
                  var p_list = $("#alone_year"+activeNum).find("p").length;
                  var obj_h = p_list * 45 + 48;
                  if(obj_h > tab_height){
                      $(".inquiry_content").height(tab_height);
                  }
                  else{
                      $(".inquiry_content").height(obj_h);
                  }
                  $.loadedScroll("year_refresh",1,"v");
                  break;
                case "alone_month"+activeNum: // 月下拉框
                  var p_list = $("#alone_month"+activeNum).find("p").length;
                  var obj_h = p_list * 45 + 48;
                  if(obj_h > tab_height){
                    $(".inquiry_content").height(tab_height);
                  }
                  else{
                    $(".inquiry_content").height(obj_h);
                  }
                  $.loadedScroll("month_refresh",1,"v");
                  break;
                case "alone_day"+activeNum: // 日下拉框
                  var p_list = $("#alone_day"+activeNum).find("p").length;
                  var obj_h = p_list * 45 + 48;
                  if(obj_h > tab_height){
                    $(".inquiry_content").height(tab_height);
                  }
                  else{
                    $(".inquiry_content").height(obj_h);
                  }
                  $.loadedScroll("form_query_day_refresh",1,"v");
                  break;
                case "inquiry_com_list"+activeNum: // 关联下拉框
                  var p_list = $("#inquiry_com_list"+activeNum).find("p").length;
                  var obj_h = p_list * 45 + 48;
                  if(obj_h > tab_height){
                    $(".inquiry_content").height(tab_height);
                  }
                  else{
                    $(".inquiry_content").height(obj_h);
                  }
                  $.loadedScroll("select_relation"+activeNum,1,"v");
                  break;
               default :
                  $(".inquiry_content").height(tab_de_height);
            }
        }
        /**
         * 触发条件需得到以下数据
         */
        function triggerOper() {
          // 在触发时获取控件的序号index
          reportIndex = $('.ui-btn-active input').attr("index");
          // 统计名称
          queryName = $('.ui-btn-active input').attr("fieldName");
          // 关系
          operation = $('.ui-btn-active input').attr("operation");
          // 当前查询控件的排序号
          activeNum = $('.ui-btn-active input').attr("index");
          checkBoxV = $(".ui-btn-active input").attr("val");
        }
       
        /**
         * tabs切换扩展方法
         * @param thisObj 当前点击对象
         */
        function userInquiry(thisObj){
            $.hideLayerClose();
        }

        function getDetailFormDataUrl(listId){
            var editAuth = "${editAuth}";
            var strs = editAuth.split(".");
            var viewId = strs[0];
            var rightId = strs[1];
            var url = "${ctp_contextPath}/content/content.do?newTag=false&isFullPage=true&moduleId="+listId+"&moduleType="+_moduleType+"&rightId="+rightId+"&contentType=20&viewState=1&style=4";
            return url;
        }
        /**
         *  下拉刷新获取数据方法
         */
        function userInfoList(obj,id) {
            ajaxMobileLoad(id,false,"down");
        }
        /**
         *  点击加载更多获取数据方法
         */
        function userMoreInfoList(obj,id){
            ajaxMobileLoad(id,false,"");
        }
        $("#form_list").bind("pagebeforeshow",function(){
        	pageInit("form_list");
        	 var currYear = (new Date()).getFullYear();
             var opt={};
             opt.default = { 
                 theme: 'android-ics light', //皮肤样式
                 lang:'zh',
                 startYear:currYear - 100, //开始年份
                 endYear:currYear //结束年份
             };
             opt.date = {preset : 'date'};
             opt.datetime = {preset : 'datetime'};
             $(".form_query_data_class").val("").scroller('destroy').scroller($.extend(opt['date'], opt['default']));
             $(".form_query_datatime_class").val("").scroller('destroy').scroller($.extend(opt['datetime'], opt['default']));
        	//加载数据
            loadData();
        	
        })
        $("#form_list").bind("pageshow",function(){
            pageShowInit("form_list");
            
        });

        /**
        *ajax 加载初始数据,默认第一页，每页20条
         */
        function loadData(){
            //初始化方法，必须将页面设置成第一页
            pageNum = 1;
            ajaxMobileLoad($("#search_result"),true,"");
        }

        /**
         * 核心加载方法
         * id页面对象id,isInit是否是初始化加载，refreshType刷新类型
         */
        function ajaxMobileLoad(id,isInit,refreshType){
            var timeOutVal = 0;
            if(!isInit){
                timeOutVal = 1000;
            }
            if(!isInit) {
                pageNext();
            }
            var fm = new formManager();
            fm.getFormMasterData4Mobile(getLoadParam(),{success: function(result) {
                if(result == ""){
                    timeOutVal = 0;
                }
                setTimeout(function () {
                    if(result && result != "") {
                        listData(id, {
                            list_type: 'inquirylist',
                            list_refresh_type: refreshType,
                            update_time: showTime(),
                            data: $.parseJSON(result),
                            callback: function () {
                                if (isInit) {
                                    loaded('search_result', userInfoList, userMoreInfoList);
                                }
                            }
                        });
                    }
                    //非初始化加载才需要刷新
                    if (!isInit) {
                        $.refreshScroll(id);
                    }
                },timeOutVal);
            }});
        }

        /**
         * 获得加载数据参数
         */
        function getLoadParam(){
            //获得加载参数
            var param = new Object();
            param.page = pageNum;
            param.formId = "${formId}";//表单id
            param.formTemplateId = "${formTemplateId}";//表单模板id
            if(userConditionArray.length != 0){
               param.highquery = userConditionArray;//表单模板id
            }
            return param;
        }
        
        /**
        *获得客户端刷新时间
        * @returns {number}
         */
        function showTime(){
            var today = new Date();
            var reStr=today.getFullYear()+"-"+(today.getMonth()+1)+"-"+today.getDate()+" "+today.getHours()+":"+today.getMinutes();
            return reStr;
        }

        /**
        *设置翻页页数，从1开始递增
         */
        function pageNext(){
            pageNum = pageNum + 1;
        }

        /**
                 * 年下拉触发
                 */
                formReportYearControl = function(domObj, objId) {
                	// 下拉框对应数据库值
                	  var selectVal = $(domObj).attr("value");
                	  // 选的那个值
                	  var selectValue = $(domObj).html();
                	  if (selectVal != 0) {// 选择某年，月份下拉显示月份
                	    // 月控件值
                	    $("#month_control_value")[0].innerHTML= "月";
                	    // 日控件值
                	    $("#day_control_value")[0].innerHTML= "日";
                	    // 月下拉值
                	    $("#month_select_val").empty();
                	    var html = "<p value=\"0\">全部</p>";
                	    for (var i=1; i<=12; i++) {
                	      html += "<p value='"+i+"'>"+i+"月</p>";
                	    }
                	    $("#month_select_val")[0].innerHTML= html;
                	    // 日下拉值
                	    $("#day_select_val").empty();
                	    $("#day_select_val")[0].innerHTML="<p value=\"-1\">请先选择年月</p>";
                	    // 年份
                	    selectedYear = selectVal;
                	    
                	    // 查询某年
                	    formSearchOneYear(selectVal);
                	  } else { // 选择“全部”
                	    // 月控件值
                	    $("#month_control_value")[0].innerHTML= "全部";
                	    // 月下拉值
                	    $("#month_select_val").empty();
                	    $("#month_select_val")[0].innerHTML= "<p value=\"-1\">请先选择年</p>";
                	    
                	    // 日控件值
                	    $("#day_control_value")[0].innerHTML= "全部";
                	    // 日下拉值
                	    $("#day_select_val").empty();
                	    $("#day_select_val")[0].innerHTML="<p value=\"-1\">请先选择年月</p>";
                	    
                	    
                	    // 日期条件
                	    var userCondition = {};
                	    userCondition.leftChar = "(";
                	    userCondition.fieldName = queryName;
                	    userCondition.operation = "=";
                	    userCondition.fieldValue = "";
                	    userCondition[queryName] = "";
                	    userCondition.rightChar = ")";
                	    userCondition.rowOperation = "and";
                	    // 放入数组
                	    userConditionArray[parseInt(5)] = userCondition;
                	    userConditionArray[parseInt(6)] = "";
                        ajaxMobileLoad($("#search_result"),true,"");
                        
                	   /* $("div.list_data_content").empty();
                	    conditionQueryRsult();*/
                	  }
                	  $.loadedScroll("month_refresh",1,"v");
                	 
                	  selectedYear = selectVal;
                }
                /**
                 * 月下拉触发
                 */
                formReportMonthControl = function(domObj, objId) {
                	 // 月下拉框对应数据库值
                	  var selectVal = $(domObj).attr("value");
                	  // 月下拉选的那个值
                	  var selectValue = $(domObj).html();
                	  if (selectVal == "-1") { // 选择“请先选择年”
                	    // 月控件值
                	    $("#month_control_value")[0].innerHTML= "全部";
                	    return;
                	  } else if (selectVal == "0") { // 选择“全部”
                	    // 月控件值
                	    $("#month_control_value")[0].innerHTML= "全部";
                	    // 日控件值
                	    $("#day_control_value")[0].innerHTML= "全部";
                	    // 日下拉值
                	    $("#day_select_val").empty();
                	    $("#day_select_val")[0].innerHTML="<p value=\"-1\">请先选择年月</p>";
                	    
                	    // 查询某年
                	    formSearchOneYear(selectedYear);
                	  } else { // 选择某月
                	    var maxDay = parseInt(getMaxDays(selectedYear,selectVal));
                	    // 日下拉值
                	    $("#day_select_val").empty();
                	    var html = "<p value=\"0\">全部</p>";
                	    for (var i=1; i<=maxDay; i++ ) {
                	      html += "<p value='"+i+"'>"+i+"日</p>";
                	    }
                	    $("#day_select_val")[0].innerHTML= html;
                	    
                	    selectedMonth = selectVal;
                	    currtMonthMaxDay = maxDay;
                	    // 查询某年某月
                	    formSearchOneYear(selectedYear, selectedMonth, currtMonthMaxDay);
                	  }
                	  $.loadedScroll("form_query_day_refresh",1,"v");
                }
                /**
                 * 日下拉触发
                 */
                formReportDayControl = function(domObj, objId) {
                	 // 日下拉框对应数据库值
                	  var selectVal = $(domObj).attr("value");
                	  // 日下拉选的那个值
                	  var selectValue = $(domObj).html();
                	  if (selectVal == "-1") { // 请选择年月
                	    $("#day_control_value")[0].innerHTML="全部";
                	    return;
                	  } else if (selectVal == "0") { // 全部
                	    // 查询某年某月
                	    formSearchOneYear(selectedYear, selectedMonth, currtMonthMaxDay);
                	    return;
                	  } else { // 选择某日
                	    // 查询某年某月某日
                	    formSearchOneYear(selectedYear, selectedMonth, currtMonthMaxDay, selectVal);
                	  }
                }
                /**
                 * 获取月的最大天数
                 */
                function getMaxDays(yearStr, monthStr) {
                  var maxDay;
                  if (monthStr%2 == 0 && monthStr!=2) {
                    // 偶数月份且不是2月
                    maxDay = 30;
                  } else if (monthStr%2 != 0) {
                    // 奇数月份
                    maxDay = 31;
                  } else {
                    // 2月
                    if ((yearStr%4==0 && yearStr%100!=0)||(yearStr%100==0 && yearStr%400==0)) {
                      // 闰年
                      maxDay = 29;
                    } else {
                      // 非闰年
                      maxDay = 28;
                    }
                  }
                  return maxDay;
                }
              //查询某年
                /**
                 * yearStr 年
                 * monthStr 月
                 * monthMaxDay 月的最大天数
                 * dayStr 日
                 */
                function formSearchOneYear(yearStr, monthStr, monthMaxDay, dayStr) {
                  // 日期条件1
                  var userCondition1 = {};
                  userCondition1.leftChar = "(";
                  userCondition1.fieldName = queryName;
                  userCondition1.operation = ">=";
                  if (monthStr != null && dayStr != null) { // 年月日查询
                    userCondition1.fieldValue = yearStr+"-"+monthStr+"-"+dayStr+" 00:00";
                    userCondition1[queryName] = yearStr+"-"+monthStr+"-"+dayStr+" 00:00";
                  }else if (monthStr != null) {// 年月查询
                    userCondition1.fieldValue = yearStr+"-"+monthStr+"-01";
                    userCondition1[queryName] = yearStr+"-"+monthStr+"-01";
                  } else {// 年查询
                    userCondition1.fieldValue = yearStr+"-01-01";
                    userCondition1[queryName] = yearStr+"-01-01";
                  }
                  userCondition1.rightChar = ")";
                  userCondition1.rowOperation = "and";
                  // 放入数组
                  userConditionArray[parseInt(5)] = userCondition1;
                  
                  // 日期条件2
                  var userCondition2 = {};
                  userCondition2.leftChar = "(";
                  userCondition2.fieldName = queryName;
                  userCondition2.operation = "<=";
                  if (monthStr != null && dayStr != null) { // 年月日查询
                    userCondition2.fieldValue = yearStr+"-"+monthStr+"-"+dayStr+" 23:59";
                    userCondition2[queryName] = yearStr+"-"+monthStr+"-"+dayStr+" 23:59";
                  }else if (monthStr != null) {// 年月查询
                    userCondition2.fieldValue = yearStr+"-"+monthStr+"-"+monthMaxDay;
                    userCondition2[queryName] = yearStr+"-"+monthStr+"-"+monthMaxDay;
                  } else {// 年查询
                    userCondition2.fieldValue = yearStr+"-12-31";
                    userCondition2[queryName] = yearStr+"-12-31";
                  }
                  userCondition2.rightChar = ")";
                  userCondition2.rowOperation = "and";
                  // 放入数组
                  userConditionArray[parseInt(6)] = userCondition2;
                  // 发送统计
                  $("div.list_data_content").empty();
                  ajaxMobileLoad($("#search_result"),true,"");
                }
                /**
                 * 关联下拉框触发事件
                 */
                relationSelectReport = function(domObj, objId) {
                  //下拉框对应数据库值
                  var selectVal = $(domObj).attr("value");
                  // 选的那个值
                  var selectValue = $(domObj).html();
                  
                  var userCondition = {};
                  userCondition.leftChar = "(";
                  userCondition.fieldName = queryName;
                  userCondition.operation = operation;
                  userCondition.fieldValue = selectVal;
                  userCondition[queryName] = selectVal;
                  userCondition[queryName + '_txt'] = selectValue;
                  userCondition.rightChar = ")";
                  userCondition.rowOperation = "and";
                  // 放入数组
                  userConditionArray[parseInt(activeNum)] = userCondition;
                  // 发送统计
                  sendQuerySearch(1);
                  $("div.list_data_content").empty();
                  conditionQueryRsult();
                  
                  // 是关联表单的下拉
                  // 是否触发的是关联下拉框的判断：
                  relationFn(queryName, selectValue);
                }
                /**
                 * 是否是关联下拉框判断与后续操作
                 * @param thisSelectFeildname 当前选中下拉框的fieldname
                 * @param selectValue 选中下拉框的值
                 */
                function relationFn(thisSelectFeildname, selectValue) {
                  // 判断点击的下拉框是否是关联下拉框：
                  // 1. 所有的下拉框对象中，至少一个input元素，含有class="relationInput"，表示该页面有关联下拉框；
                  if ($("input[class=relationInput]").length > 0) {
                    // 2. 获取所有关联下拉框的input元素的enumparent属性的值字符串
                    var a = new Array();
                    a = $("input[class=relationInput]");
                    var length = a.length;
                    var enumparentStrs = "";
                    for (var i=0; i<length; i++) {
                      enumparentStrs += $(a[i]).attr("enumparent")+",";
                    }
                    // 3. 且该点击的下拉框的fieldname值，等于含有class="relationInput"的input元素的enumparent属性的值。
                    if (enumparentStrs.includes(thisSelectFeildname)) {
                      // 该下拉框是关联下拉框
                      // 获取被点击关联下拉框的下一级下拉框的fieldname
                      nextFieldname = $("input[class=relationInput][enumparent="+thisSelectFeildname+"]").attr("fieldname");
                      
                      // 获取根下拉框的fieldname
                      var rootFieldname = "";
                      var b = new Array();
                      b = $("input[inputtype=select]");
                      var len = b.length;
                      for (var j=0; j<len; j++) {
                        if (enumparentStrs.includes($(b[j]).attr("fieldname"))) {
                          rootFieldname = $(b[j]).attr("fieldname");
                        }
                      }
                      
                      // 获取页面html字符串
                      getQueryReportRelationData(queryId, nextFieldname, rootFieldname, selectValue, "formQueryRequest");
                    }
                  }
                  
                }
                /**
                 * 获取关联的数据
                 * formId 表单id
                 * fieldId  关联表单的字段
                 * rootFieldname 根下拉框的fieldname值
                 * selectValue 下拉框选中值
                 * requestType 请求分类：表单查询，表单统计-formReportRequest
                 */
                function getQueryReportRelationData(formId, fieldId, rootFieldname, selectValue, requestType) {
                  var param = {};
                  param.formId = formId;
                  param.fieldId = fieldId;
                  param.rootFieldname = rootFieldname;
                  seeworkAjax({
                    url : _ctxPath + "/rest/seeworkFormReport/getRelationParam",
                    type : 'post',
                    dataType : 'json',
                    data : {
                      'formId' : formId,
                      'fieldId' : fieldId,
                      'rootFieldname' : rootFieldname,
                      'selectValue' : selectValue,
                      'requestType' : requestType,
                    },
                    async : false,
                    success : function(datas) {
                      if (requestType == "formReportRequest") {
                        // 表单统计
                        formReportRelation(datas, fieldId);
                      } else if (requestType == "formQueryRequest") {
                        // 表单查询
                        formQueryRelation(datas, fieldId);
                      }
                    },
                    error : function(XMLHttpRequest, textStatus, errorThrown) {
                    }
                  });
                }
                /**
                 * 下拉框触发事件
                 */
                formReportSelectControl = function(domObj, objId) {
                  // 下拉框对应数据库值
                  var selectVal = $(domObj).attr("value");
                  // 选的那个值
                  var selectValue = $(domObj).html();
                  var userCondition = {};
                  userCondition.leftChar = "(";
                  userCondition.fieldName = queryName;
                  userCondition.operation = operation;
                  userCondition.fieldValue = selectVal;
                  userCondition[queryName] = selectVal;
                  userCondition[queryName + '_txt'] = selectValue;
                  userCondition.rightChar = ")";
                  userCondition.rowOperation = "and";
                  // 放入数组
                  userConditionArray[parseInt(activeNum)] = userCondition;
                  // 发送统计
                  $("div.list_data_content").empty();
                  ajaxMobileLoad($("#search_result"),true,"");
                }
                /**
                 * 文本框统计触发
                 */
                formReportTextControl = function(domObj, objId) {
                  // 文本框值
                  var textValue = $("#user_search"+activeNum).val();
                  
                  // 新建js对象
                  var userCondition = {};
                  userCondition.leftChar = "(";
                  userCondition.fieldName = queryName;
                  userCondition.operation = operation;
                  userCondition.fieldValue = textValue;
                  userCondition[queryName] = textValue;
                  userCondition.rightChar = ")";
                  userCondition.rowOperation = "and";
                  // 放入数组
                  userConditionArray[parseInt(activeNum)] = userCondition;
                  $("div.list_data_content").empty();
                  ajaxMobileLoad($("#search_result"),true,"");
                }
                /**
                 * 开关控件触发
                 */
                formReportCheckBoxControl = function() {
                  // 开关才有此属性 $("#inquiry_three2 p[check]").attr("textvalue")
//                  var isCheck = $("#seeworkCheckbox p[check]").attr("textvalue");
                  var isCheck = $("#inquiry_three"+activeNum+" p[check]").attr("textvalue");
                  // 开关条件
                  var userCondition = {};
                  if (isCheck == null) {
                    userCondition = null;
                  } else {
                    // 拆分开关的val属性
                    var strs = checkBoxV.split(";");
                    var checkBoxOpen;
                    var checkBoxClose;
                    for (var k = 0; k < 2; k++) {
                      var str = strs[k].split(",");
                      if (str[1] == "勾选") {
                        checkBoxOpen = str[0];
                      } else {
                        checkBoxClose = str[0];
                      }
                    }

                    // 开关的值，勾选1，未勾选0.
                    var checkBoxValue;
                    // 开启与关闭分别对应的值
                    var checkedVal;
                    var unCheckedVal;
                    if (isCheck == "勾选") {
                      checkBoxValue = 1;
                      checkedVal = "1";
                      unCheckedVal = null;
                    } else if (isCheck == "未勾选") {
                      checkBoxValue = 0;
                      checkedVal = null;
                      unCheckedVal = "0";
                    }
                    userCondition.leftChar = "(";
                    userCondition.fieldName = queryName;
                    userCondition.operation = "=";
                    userCondition.fieldValue = checkBoxValue;
                    userCondition[checkBoxOpen] = checkedVal;
                    userCondition[checkBoxClose] = unCheckedVal;
                    userCondition.rightChar = ")";
                    userCondition.rowOperation = "and";
                  }
                  // 放入数组
                  userConditionArray[parseInt(activeNum)] = userCondition;
                  $("div.list_data_content").empty();
                  ajaxMobileLoad($("#search_result"),true,"");
                }
                /**
                 * 日期控件触发事件
                 */
                formReportDateControl = function() {
                  // 日期值
                  var dateValue = $("#dateInput"+activeNum).val();
                  // 日期条件
                  var userCondition = {};
                  userCondition.leftChar = "(";
                  userCondition.fieldName = queryName;
                  userCondition.operation = "=";
                  userCondition.fieldValue = dateValue;
                  userCondition[queryName] = dateValue;
                  userCondition.rightChar = ")";
                  userCondition.rowOperation = "and";
                  // 放入数组
                  userConditionArray[parseInt(activeNum)] = userCondition;
                  $("div.list_data_content").empty();
                  ajaxMobileLoad($("#search_result"),true,"");
                }
                /**
                 * 选人组件触发,获得选取的人员数组
                 */
                isMember = function() {
                	 // 触发的控件类型
                	 var type = $('.ui-btn-active input').attr("inputtype");
                	 // 触发选人控件,弹出
                	 if (type == "member") {
                	   var choosePeople=new ChoosePeople("form_list",function(data){
                	     memberReport(data);
                	   });
                	   choosePeople.show();
                	 }
                }
                /**
                * 选人组件触发查询，次处选人为单选
                */
                function memberReport(data) {
                  //var memberValue = ((poplesJson[0].listId).split("_"))[1];
                  //var typeName = (poplesJson[0].typeName);
                  var memberValue = data[0].memberID;
                  var typeName = data[0].name;
                  $("ul.model_header_tabs li input[index='"+activeNum+"']").prev().text(typeName);
                  // 修改选人控件为所选择的人
                 // $("ul.model_header_tabs li:eq("+activeNum+") span:eq(0)").text(typeName);
                  //[{"leftChar":"(","fieldName":"field0002","operation":"=","fieldValue":"-966375890284886859","field0002_txt":"校长","field0002":"Member|-966375890284886859","rightChar":")","rowOperation":"and"}]
                  //开关条件
                  var userCondition = {};
                  userCondition.leftChar = "(";
                  userCondition.fieldName = queryName;
                  userCondition.operation = "=";
                  userCondition.fieldValue = memberValue;
                  userCondition[queryName+"_txt"] = typeName;
                  userCondition[queryName] = "Member|"+memberValue;
                  userCondition.rightChar = ")";
                  userCondition.rowOperation = "and";        
                  // 放入数组
                  userConditionArray[parseInt(activeNum)] = userCondition;
                  // 发送统计
                  $("div.list_data_content").empty();
                  ajaxMobileLoad($("#search_result"),true,"");
                }
    </script>
</section>

</body>
</html>