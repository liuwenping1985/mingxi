<%--
 $Author:  zhaifeng$
 $Rev:  $
 $Date:: 2012-09-07#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%--为了兼容ie11下的Office控件 把common.jsp的内容粘贴到这个jsp  --%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext,java.util.Locale"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.util.json.JSONUtil,java.util.Locale"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.constants.ProductEditionEnum,java.util.Locale"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%
    response.setHeader("Pragma", "No-cache");
  response.setHeader("Cache-Control", "no-store");
  response.setDateHeader("Expires", 0);
  boolean isDevelop = AppContext.isRunningModeDevelop();
    String ctxPath =request.getContextPath(),  ctxServer = request.getScheme()+"://" + request.getServerName() + ":"
                    + request.getServerPort() + ctxPath;
    Locale locale = AppContext.getLocale();
%>
<!DOCTYPE html>
<%@page import="com.seeyon.ctp.common.flag.*"%>
<%
if(BrowserEnum.valueOf(request) == BrowserEnum.IE11){
%>
    <META http-equiv="X-UA-Compatible" content="IE=EmulateIE9">
<%
} else {
%>
      <meta http-equiv="X-UA-Compatible" content="IE=EDGE"/>
<%
}
%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<script type="text/javascript">
  var _ctxPath = '<%=ctxPath%>', _ctxServer = '<%=ctxServer%>';
  var _locale = '<%=locale%>',_isDevelop = <%=isDevelop%>,_sessionid = '<%=session.getId()%>',_isModalDialog = false;
  var _editionI18nSuffix = '<%=ProductEditionEnum.getCurrentProductEditionEnum().getI18nSuffix()%>';
  <c:if test="${param._isModalDialog == 'true' || param.isFromModel == 'true'}">
  _isModalDialog = true;
  </c:if>
  var _resourceCode = "${ctp:escapeJavascript(param._resourceCode)}";
  var seeyonProductId="${ctp:getSystemProperty("system.ProductId")}";
</script>
<link rel="stylesheet" href="${path}/common/all-min.css${ctp:resSuffix()}">
<c:if test="${CurrentUser.skin != null}">
<link rel="stylesheet" href="${path}/skin/${CurrentUser.skin}/skin.css${ctp:resSuffix()}">
</c:if>
<c:if test="${CurrentUser.skin == null}">
<link rel="stylesheet" href="${path}/skin/default/skin.css${ctp:resSuffix()}">
</c:if>
<script type="text/javascript" src="${path}/i18n_<%=locale%>.js${ctp:resSuffix()}"></script>
<%
    if (isDevelop) {
%>
<script type="text/javascript" src="${path}/common/js/ui/calendar/calendar-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/jquery-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/misc/Moo-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/misc/jsonGateway-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/jquery.json-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/jquery.fillform-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/jquery.jsonsubmit-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/jquery.hotkeys-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/jquery.ajaxgridbar-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/jquery.code-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/common-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/v3x-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/seeyon.ui.core-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/jquery.comp.lbs-debug.js"></script>
<!--seeyonUI start-->
<script type="text/javascript" src="${path}/common/js/ui/searchBox-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.checkform-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.dialog-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.grid-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.layout-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.menu-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.progress-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.tab-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.toolbar-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.tree-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.calendar-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.arraylist-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.tooltip-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.common-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.comLanguage-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.print-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.shortCutSet-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.colorpicker-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.peopleCrad-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.projectTaskDetailDialog-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.zsTree-debug.js"></script>
<!--seeyonUI end-->
<script type="text/javascript" src="${path}/common/js/jquery.comp-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/jquery.tree-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/jquery.autocomplete-debug.js"></script>
<script type="text/javascript" src="${path}/common/js/jquery.dd-debug.js"></script>
<%
    } else {
%>
<script type="text/javascript" src="${path}/common/all-min.js${ctp:resSuffix()}"></script>
<%
    }
%>
<script type="text/javascript" src="${path}/common/js/ui/calendar/calendar-<%=locale%>.js${ctp:resSuffix()}"></script>
<c:set var="loginTime" value="${ CurrentUser !=null ? CurrentUser.etagRandom : 0}" />
<script type="text/javascript" src="${path}/main.do?method=headerjs&login=${loginTime}"></script>
<script type="text/javascript">

var addinMenus = new Array();
<c:forEach var="addinMenu" items="${AddinMenus}" varStatus="status">
    var index = ${status.index};
    addinMenus[index] = {pluginId : '${addinMenu.pluginId}',name : '${addinMenu.label}',className : '${addinMenu.icon}',click : '${addinMenu.url}'};
</c:forEach>

function onBridgeReady() {
	WeixinJSBridge.call('hideOptionMenu');
}

if (typeof WeixinJSBridge == "undefined") {
	if (document.addEventListener) {
		document.addEventListener('WeixinJSBridgeReady', onBridgeReady,
				false);
	} else if (document.attachEvent) {
		document.attachEvent('WeixinJSBridgeReady', onBridgeReady);
		document.attachEvent('onWeixinJSBridgeReady', onBridgeReady);
	}
} else {
	onBridgeReady();
}

$.ctx._currentPathId = '${_currentPathId}';
$.ctx._pageSize = ${ctp:getSystemProperty("paginate.page.size")};
$.ctx.fillmaps = <c:out value="${_FILL_MAP}" default="null" escapeXml="false"/>;
<c:if test="${fn:length(EXTEND_JS)>=0}">
// 保证扩展的js最后执行
$(document).ready(function() {
    $(window).load(function() {
        <c:forEach var="js" items="${EXTEND_JS}">
            $.getScript("${path}/${js}");
        </c:forEach>
    });
});
</c:if>
</script>

<script type="text/javascript" src="${path}/common/js/orgIndex/jquery.tokeninput.js${ctp:resSuffix()}"></script>
<link rel="stylesheet" href="${path}/common/js/orgIndex/token-input.css${ctp:resSuffix()}" type="text/css" />
<link href="${path}/common/images/${ctp:getSystemProperty('portal.porletSelectorFlag')}/favicon${ctp:getSystemProperty('portal.favicon')}.ico${ctp:resSuffix()}" type="image/x-icon" rel="icon"/>
<script type="text/javascript" src="${path}/ajax.do?managerName=knowledgeFavoriteManager,colManager"></script>
<%--为了兼容ie11下的Office控件 把common.jsp的内容粘贴到这个jsp  --%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 

<%@ include file="/WEB-INF/jsp/apps/collaboration/new_print.js.jsp" %>
<c:if test="${ctp:hasPlugin('calendar')}">
<script type="text/javascript" src="${path}/apps_res/calendar/js/calEvent_Create_addData_js.js"></script>
</c:if>
<%@ include file="/WEB-INF/jsp/ctp/form/common/common.js.jsp" %>
<c:if test="${ctp:hasPlugin('bulletin')}">
<jsp:include page="/WEB-INF/jsp/bulletin/bulletin_issue_js.jsp" flush="true"></jsp:include>
</c:if>
<c:if test="${ctp:hasPlugin('news')}">
<jsp:include page="/WEB-INF/jsp/news/news_issue_js.jsp" flush="true"></jsp:include>
</c:if>
<%@ include file="/WEB-INF/jsp/ctp/form/design/formDevelopmentOfadv.jsp" %>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
<meta name="viewport" content="width=device-width, initial-scale=1" />
<script type="text/javascript" src="${path}/apps_res/doc/js/docFavorite.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/doc/js/knowledgeBrowseUtils.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/doc/js/docFavorite.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/summaryForWechat.js${ctp:resSuffix()}"></script>
<!-- 查看处理页面 -->
<title></title>
<style type="text/css">
    .stadic_head_height{}
    .stadic_body_top_bottom{bottom: 0;overflow:hidden;}
    
    .scroll-wrapper {  
	    display: inline-block;
		-webkit-overflow-scrolling: touch;
  		overflow-y: scroll;

	}  
	.scroll-wrapper, .scroll-wrapper {  
	    width: 100%;
		height: 100%;

	}  
</style>
<c:set value='${summaryVO.openFrom == "repealRecord" || summaryVO.openFrom == "stepBackRecord" || summaryVO.openFrom == "stepbackRecord"}' var="isFromTraceFlag"></c:set>
<script type="text/javascript">
var summaryId = '${summaryVO.summary.id}';
var affairId  = '${summaryVO.affairId}';

<%-- 解锁Param--%>
var formAppId = '${summaryVO.summary.formAppid}';
var fromRecordId = '${summaryVO.summary.formRecordid}';

<%--后台已经使用ctp:toHTML()进行了一次转义了，所以这个地方不能重复转义了--%>
var subject = "${ctp:escapeJavascript(summaryVO.summary.subject)}";

var _trackTitle = "${ctp:i18n('collaboration.newColl.alert.zdgzrNotNull')}";
var _summaryProcessId = '${summaryVO.summary.processId}';
var _summaryActivityId = '${summaryVO.activityId}';
var _summaryCaseId = '${summaryVO.summary.caseId}';
var _summaryItemId=  '${summaryVO.workitemId}';

var _processTemplateId= '';
var _contextProcessId = '${contentContext.wfProcessId}';
var _contextActivityId = '${contentContext.wfActivityId}';
var _contextCaseId = '${contentContext.wfCaseId}';
var _contextItemId = '${contentContext.wfItemId}';
var _scene = "${scene}";
var show1 = '${show1}';
var show2 = '${show2}';

var _currentUserId = '${CurrentUser.id}';
var _currentUserName = '${ctp:escapeJavascript(CurrentUser.name)}';
var _loginAccountId = '${CurrentUser.loginAccount}';
var isFromTemplate = '${summaryVO.summary.templeteId ne null}';
var templateType = '${templateType}';
var affairState = "${summaryVO.affair.state}";
var affairSubState = '${summaryVO.affair.subState}';
var isCurrentUserSupervisor = "${summaryVO.isCurrentUserSupervisor}";
var isFinshed = "${summaryVO.flowFinished}";
var isFinish = ${(summaryVO.summary.finishDate!= null) ? true : false};
var commentId = "${commentId}";
var _isOfficeTrans = ${v3x:isOfficeTran()};
var openFrom = "${ctp:escapeJavascript(summaryVO.openFrom)}";
var summaryReadOnly = '${summaryVO.readOnly}';
var templateId = '${summaryVO.summary.templeteId}';
var isSupervise = '${summaryVO.openFrom}'=='supervise';
var isCurSuperivse = '${summaryVO.openFrom}'=='listDone' && '${summaryVO.isCurrentUserSupervisor}' == 'true';
var _moduleTypeName = '${contentContext.moduleTypeName}';
var _affairMemberId = '${summaryVO.affair.memberId}';
var _startMemberId = "${summaryVO.summary.startMemberId}";
var _canFavorite = "${canFavorite}";
var trackType = '${trackType}';
var bodyType = '${summaryVO.summary.bodyType}';
var formRecordid = '${summaryVO.summary.formRecordid}';
var operationId = '${summaryVO.operationId}';

//控制OFFICE正文能否打印，OFFICE组件中会读取这个变量
var isFromTrace = openFrom == "repealRecord" || openFrom == 'stepBackRecord' || openFrom == 'stepbackRecord';
var officecanPrint = isFromTrace ? 'false' : '${summaryVO.officecanPrint}';
var canEdit  =  isFromTrace ? 'false' : '${canEdit and summaryVO.affair.state eq 3}';
var officecanSaveLocal = isFromTrace ? 'false' : '${summaryVO.officecanSaveLocal}';
var forTrackShowString='${forTrackShowString}';
var openType = "";
var proce = "";
var contentAnchor = "${ctp:escapeJavascript(contentAnchor)}";
var nodePerm_baseActionList = <c:out value="${nodePerm_baseActionList}" default="null" escapeXml="false"/>;
var nodePerm_commonActionList = <c:out value="${nodePerm_commonActionList}" default="null" escapeXml="false"/>;
var nodePerm_advanceActionList = <c:out value="${nodePerm_advanceActionList}" default="null" escapeXml="false"/>;
var isDealPageShow = "${isDealPageShow}";
var flowPermAccountId= '${summaryVO.flowPermAccountId}';
var nodePolicy = "${ctp:escapeJavascript(nodePolicy)}";
var hasAttsFlag = '${summaryVO.hasAttsFlag}';
var templateWorkflowId =  '${templateWorkflowId}';
var supervisorsId = '${summaryVO.summary.supervisorsId }';
var hasPluginUC = ${ctp:hasPlugin('uc')};
var hasMeeting = "${ctp:hasPlugin('meeting')}";
var layout = null;
var rightId = '${rightId}' ;
//当前节点是否加盖html签章 false：未盖章，true：加盖印章
var nowNodeIsSignatureHtml = "false";
//dialog方式打开协同，dialog的ID可以默认，也可以通过参数传过来，目前表单统计查询都是传递过来的。
var dialogId = "${param.dialogId eq null ? 'dialogDealColl' : param.dialogId}";
var isHasDealPage = "${ summaryVO.affair.state eq 3 and param.openFrom eq 'listPending'}";
var isTimeLine ='${param.isTimeLine}';
var noConfigItem = "${noFindPermission}";
// var defaultWidth;
var customSetTrackFlag = '${customSetTrack}' == 'true';
var isHistoryFlag = "${isHistoryFlag}";
//var _affairSubState=affairSubState;
var affairMemberName="${ctp:escapeJavascript(summaryVO.affairMemberName)}";//当前待办事项的所属人Name
<c:set value="${summaryVO.affair.state eq 3 and param.openFrom eq 'listPending'}" var ="hasDealArea" />
$(function(){
    //判断当前节点是否存在
    if (noConfigItem == "true") { //如果没有找当对应节点权限，则提示:当前处理节点已被删掉，改为知会节点，请联系管理员解决!
        $.alert($.i18n("collaboration.summary.noFindNode"));
    }
    //var initWidth=350;
    isDealPageShow = "false";
    if(isDealPageShow !== "false"){
        $(".deal_area").show();
        $("#deal_area_show").hide();
    }else{
        //initWidth=38;
        $(".deal_area").hide();
        $("#deal_area_show").show();
    }
    //页面加载 样式初始化
    layout = new MxtLayout({
        'id': 'layout',
        <c:if test="${hasDealArea}">
        'eastArea': {
            'id': 'east',
            'width': 25,
            'sprit': false,
            'minWidth': 350,
            'maxWidth': 500,
            'border': false
        },
        </c:if>
        'centerArea': {
            'id': 'center',
            'border': false,
            'minHeight': 20
        }
    });
    summaryHeadHeight();
    // defaultWidth =layout.getEastWidth();
    //defaultWidth = parseInt($("#east").css("width"));
})
/*开始*/
var xmlDoc = null;
if("${CurrentUser.systemAdmin}"!="true"){
    getDom();
}
function getDom(){
    if(xmlDoc == null){
        try{
            xmlDoc = new ActiveXObject( "SeeyonFileDownloadLib.SeeyonFileDownload");
            xmlDoc.AddUserParam("${CurrentUser.locale}", "${ctp:escapeJavascript(CurrentUser.loginName)}", "<%=session.getId()%>", "${CurrentUser.id}");
        }catch(ex1){
          /**
           * TODO:暂时屏蔽控件加载异常
           */
            //alert("批量下载控件加载错误 : " + ex1.message);
        }
    }
    return xmlDoc;
}
/*结束*/
$(document).ready(function() {
    $(window).load(function() {
		if(isFromTrace){//撤销的时候屏蔽按钮
			//$("#attachmentListFlag,#attachmentListFlag1").hide();//附件
			//$("span[id^='favoriteSpan'],span[id^='cancelFavorite']").hide();//收藏
			//$("#attributeSetting,#attributeSettingFlag").hide();//属性状态
			//$("#showDetailLog,#showDetailLogFlag").hide();//明细日志
			//$("#caozuo_more").hide();
			$("#print").hide();
			if(!('${trackTypeRecord}' == '6') || '${trackTypeRecord}' == '5'){//不是普通回退都要隐藏回复
				$("span[class='add_new']",document.componentDiv.document).hide();
			}
		}
		if('${isCollCube}'=="1" || '${isColl360}'=="1"){
			_hideButton();
		}
    });
});


</script>
</head>
<body class="h100b over_hidden page_color"  onunload="colDelLock('${summaryVO.affairId}');">
    <v3x:attachmentDefine attachments="${attachments}" />
    <div id='layout'>
        <%@ include file="/WEB-INF/jsp/common/supervise/supervise.js.jsp" %>    
        <input type="hidden" id="affairId" value="${summaryVO.affairId}">
        <input type="hidden" id="dealFlag" value="">
        <div class="layout_east bg_color_blueLight2" id="east" style="width: 100px;">
            <!--处理区域-->
            <div id="deal_area_show" class="font_size12 align_center h100b hidden hand">
              <table width="100%" height="100%"><tr><td align="center" id='_opinionArea' valign="middle" style="font-size: 15px;"><span class="ico16 arrow_2_l" ></span><br />处理</td></tr></table>
            </div>
            <jsp:include page="/WEB-INF/jsp/common/content/contentDealTpl/defaultForWechat.jsp" />
        </div>
        <div class="layout_center over_hidden h100b" id="center">
                <c:set var="affair" value="${summaryVO.affair}" />
                <c:set var="summary" value="${summaryVO.summary}" />
                <!--查看区域-->
                <div class="h100b stadic_layout">
                    <div class="stadic_head_height" id="summaryHead">
                        <!--标题+附件区域-->
                        <div id="colSummaryData" class="newinfo_area title_view">
                            <input type="hidden" value="" id="contentstr" name ="contentstr"/>
                            <input type="hidden" id="summaryId" value="${summary.id}">
                            <input type="hidden" name="isDeleteSupervisior" id="isDeleteSupervisior" value="false">
                            <input id="processId" name="processId" type="hidden" value="${summary.processId}">
                            <input id="subject" name="subject" type="hidden" value="${summary.subject}">
                            <input id="createDate" name="createDate" type="hidden" value="${ctp:formatDateByPattern(summaryVO.createDate, 'yyyy-MM-dd HH:mm:ss')}">
                            <input id="canDeleteORarchive" name="canDeleteORarchive" type="hidden" value="${summaryVO.canDeleteORarchive}">
                            <input id="cancelOpinionPolicy" name="cancelOpinionPolicy" type="hidden" value="${summaryVO.cancelOpinionPolicy}">
                            <input id="disAgreeOpinionPolicy" name="disAgreeOpinionPolicy" type="hidden" value="${summaryVO.disAgreeOpinionPolicy}">
                            <input id="bodyType" name="bodyType" type="hidden" value="${summary.bodyType}">
                            <input id="modifyFlag" name="modifyFlag" type="hidden" value="0"/>
                            <input id="isLoadNewFile" name="isLoadNewFile" type="hidden" value="0"/>
                            <input id="attModifyFlag" name="attModifyFlag" type="hidden" value="0"/><!-- 修改附件标志位 -->
                            <input id="flowPermAccountId" name="flowPermAccountId" type="hidden" value="${summaryVO.flowPermAccountId}" />
                            <table border="0" cellspacing="0" cellpadding="0" width="100%" style="table-layout:fixed;">
                                <tr>
                                    <td class="text_overflow title" nowrap="nowrap"><span class="padding_l_25 font_size18 font_family_yahei color_black2">
                                        <c:if test="${summaryVO.summary.importantLevel ne null && summaryVO.summary.importantLevel ne '1'}">
                                            <span class='ico16 important${summaryVO.summary.importantLevel}_16 '></span>
                                        </c:if>
                                        <strong title='${(summaryVO.subject)}'>${(summaryVO.subject)}</strong>
                                      <span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                      <span class="padding_l_25">
                                      <a href="#" class="color_gray2" id="panleStart">${ctp:toHTML(summaryVO.startMemberName)}</a> <span class="color_gray2">${ctp:formatDateByPattern(summaryVO.createDate, 'yyyy-MM-dd HH:mm')}</span>
                                      </span>
                                    </td>
                                </tr>
                              </table>

                        </div>
                        <!--视图切换区域-->
                        <div class="common_tabs common_tabs_big clearfix margin_t_5">
                            <ul class="left margin_l_25">
                                <!-- 正文 -->
                                <%-- <li id="content_view_li" class="current"><a onclick="showContentView()">${ctp:i18n('collaboration.summary.text')}</a></li> --%>
                                <!-- 流程 -->
                                <%-- <li id="workflow_view_li"><a onclick="refreshWorkflow()" >${ctp:i18n('collaboration.workflow.label')}</a></li> --%>
                              
                                <!-- 相关查询 :当有处理区或者已办列表中才显示。
                             
                                <c:if test = "${ not empty affair.formRelativeQueryIds && (hasDealArea or param.openFrom eq 'listDone')}">
                                    <li id="query_view_li"><a onclick="showFormRelativeView('query','${affair.formRelativeQueryIds}','${summaryVO.summary.formAppid}')" >${ctp:i18n('collaboration.summary.formquery.label')}</a></li>
                                </c:if>
                                <c:if test = "${not empty affair.formRelativeStaticIds  && (hasDealArea or param.openFrom eq 'listDone')}">
                                    <li id="statics_view_li"><a onclick="showFormRelativeView('report','${affair.formRelativeStaticIds}','${summaryVO.summary.formAppid}')" >${ctp:i18n('collaboration.summary.formstatic.label')}</a></li>
                                 </c:if>
                                 -->
                            </ul>
                            <!--命令按钮区域-->
                        <div class="orderBt left margin_l_10 margin_t_10 align_center">
                             <div style="position:absolute; right:50px; top:125px; width:220px; z-index:200; background-color: #ececec;display:none;overflow:auto;text-align:left;border: 1px #dadada solid; padding: 5px;" id="processAdvanceDIV">
                                <input type="text" id="searchText" onkeypress="enterKeySearch(event)" name="searchText" onfocus="checkDefSubject(this, true)" onblur="checkDefSubject(this, false)" deaultvalue="&lt;${ctp:i18n('collaboration.summary.label.search')}&gt;" value="&lt;${ctp:i18n('collaboration.summary.label.search')}&gt;">
                                <span class="ico16 arrow_1_b" onclick="javascript:doSearch('forward')" class="cursor-hand"></span>
                                <span class="ico16 arrow_1_t" onclick="javascript:doSearch('back')" class="cursor-hand"></span>
                                <span class="ico16 close_16" onclick="javascript:advanceViews(false)" class="cursor-hand"></span>
                             </div> 
                             
                             <!-- 流程最大化，意见查找，附件列表，收藏，新建会议，即时交流，明细日志，属性状态，打印，督办
                              -->
                             <c:set value="1" var="countBtn" />
                             <%-- 查看原文档--%>
                             <c:set value="${summaryVO.summary.bodyType}" var = "bodyType"/>
                             <c:if test="${(bodyType eq '41' || bodyType eq '42') && v3x:isOfficeTran()}">
                                <a href="javascript:popupContentWin()" class="left" style="margin-right:5px;line-height:19px;overflow:visible">${ctp:i18n("collaboration.content.viewOriginalContent")}</a>
                             </c:if>
                             
                             <!-- 打印 -->  
                             <%-- <c:if test="${summaryVO.officecanPrint && !isFromTraceFlag}">                      
                                <c:set value="${countBtn+1}" var="countBtn" />
                                <c:if test="${countBtn<=5}">
                                    <span class="hand left" id="print"><span class="ico16 print_16 margin_lr_5" title="${ctp:i18n('collaboration.newcoll.print')}"></span>${ctp:i18n('collaboration.newcoll.print')}</span>
                                </c:if>
                             </c:if> --%>
                             <!-- 意见查找 -->
                             <c:set value="${countBtn+1}" var="countBtn" />
                             <c:if test="${countBtn<=5}">
                                <span class="hand left" id='msgSearch' onclick="javascript:advanceViews(null,this)" title="${ctp:i18n('collaboration.summary.advanceViews')}"><span class="ico16 search_16 margin_lr_5"></span>${ctp:i18n('collaboration.summary.opinionFind')}</span>
                             </c:if>
                             
                             <!-- 附件列表 -->
                             <c:if test='${!isFromTraceFlag}'>
                             <c:set value="${countBtn+1}" var="countBtn" />
                                <c:if test="${countBtn<=5}">
                                    <span class="hand left" id="attachmentListFlag1" onclick="javascript:showOrCloseAttachmentList(true)"><span class="ico16 affix_16 margin_lr_5" title="${ctp:i18n('collaboration.summary.findAttachmentList')}"></span>${ctp:i18n('collaboration.common.flag.attachmentList')}</span>
                                </c:if>
                                <c:if test="${countBtn>5}">
                                      <input id="attachmentListFlag" type="hidden"/>    
                             </c:if>
                             </c:if>
                             <%--收藏 --%>
                             <%--判断是否有处理后归档权限或者发送协同时勾选了‘归档’，如果没有，则不能收藏 ,a6没有收藏功能--%>
                             <c:if test="${canFavorite && !isFromTraceFlag}">
                                <c:if test="${param.openFrom ne 'favorite' and param.openFrom ne 'listWaitSend'  and param.openFrom ne 'glwd' and productId ne '0' and summaryVO.affair.state ne '1'}">
                                    <c:set value="${countBtn+1}" var="countBtn" />
                                     <c:if test="${countBtn<=5}">
                                        <span class="hand left ${isCollect ? 'display_none':''}" id="favoriteSpan${summaryVO.affairId}"><span class="ico16 unstore_16 margin_lr_5 " title="${ctp:i18n('collaboration.summary.favorite')}"></span>${ctp:i18n('collaboration.summary.favorite')}</span>
                                        <span class="hand left ${!isCollect ? 'display_none':''}" id="cancelFavorite${summaryVO.affairId}"><span class="ico16 stored_16 margin_lr_5" title="${ctp:i18n('collaboration.summary.favorite.cancel')}"></span>${ctp:i18n('collaboration.summary.favorite.cancel')}</span>
                                     
                                     </c:if>
                                </c:if>
                             </c:if>
                             <!-- 跟踪 -->
                             <c:if test="${(param.openFrom eq 'listSent' or param.openFrom eq 'listDone') and isHistoryFlag ne 'true'}">
                                <c:set value="${countBtn+1}" var="countBtn" />
                                 <c:if test="${countBtn<=5}">
                                    <span class="hand left" id="gzbutton"><span class="ico16 track_16 margin_lr_5" title="${ctp:i18n('collaboration.forward.page.label4')}"></span>${ctp:i18n('collaboration.forward.page.label4')}</span>
                                 </c:if>
                                <c:if test="${countBtn>5}">
                                      <input id="gzbuttonFlag" type="hidden"/>    
                                </c:if>
                             </c:if>
                               
                             <!-- 明细日志 -->         
                             <c:if test='${!isFromTraceFlag}'>                        
                             <c:set value="${countBtn+1}" var="countBtn" />
                             <c:if test="${countBtn<=5}">
                                 <span class="hand left" id="showDetailLog"><span class="ico16 view_log_16 margin_lr_5" title="${ctp:i18n('collaboration.sendGrid.findAllLog')}"></span>${ctp:i18n('collaboration.common.flag.showDetailLog')}</span>
                             </c:if>
                             <c:if test="${countBtn>5}">
                                 <input id="showDetailLogFlag" type="hidden"/>    
                             </c:if>
                             </c:if> 
                             
                             
                              <!-- 属性状态 -->  
                              <c:if test='${!isFromTraceFlag}'>                                    
                             <c:set value="${countBtn+1}" var="countBtn" />
                             <c:if test="${countBtn<=5}">
                                <span class="hand left" id="attributeSetting"><span class="ico16 attribute_16 margin_lr_5 display_none" title="${ctp:i18n('collaboration.common.flag.findAttributeSetting')}"></span>${ctp:i18n('collaboration.common.flag.attributeSetting')}</span>
                             </c:if>
                             <c:if test="${countBtn>5}">
                                  <input id="attributeSettingFlag" type="hidden"/>    
                             </c:if>
                             </c:if>
                            
                             <!-- 新建会议  & 及时交流  在已发已办中始终都有，不管流程结束与否，在文档中心等其他都地方没有 -->                               
                             <%-- <c:if test="${((param.openFrom eq 'listSent')
                                        or (param.openFrom eq 'listDone')
                                        or (param.openFrom eq 'listPending')
                                        or (param.openFrom eq 'supervise'))&& !isFromTraceFlag && (isHistoryFlag ne 'true')}">
                                 <!-- 新建会议 -->
                                 <c:set value="${countBtn+1}" var="countBtn" />
                                 <c:if test="${countBtn<=5}">
                                     <span class="hand left" id="createMeeting"><span class="ico16 margin_lr_5" title="${ctp:i18n('collaboration.summary.createMeeting')}"></span>${ctp:i18n('collaboration.summary.createMeeting')}</span>
                                 </c:if>
                                 <c:if test="${countBtn>5}">
                                     <input id="createMeetingFlag" type="hidden"/>    
                                 </c:if>
                                 <!-- 即时交流 -->
                                 <c:set value="${countBtn+1}" var="countBtn" />
                                 <c:if test="${countBtn<=5}">
                                    <span class="hand left" id="timelyExchange"><span class="ico16 communication_16 margin_lr_5" title="${ctp:i18n('collaboration.summary.timelyExchange')}"></span>${ctp:i18n('collaboration.summary.timelyExchange')}</span>
                                 </c:if>
                                 <c:if test="${countBtn>5}">
                                     <input id="timelyExchangeFlag" type="hidden"/>    
                                 </c:if>
                             </c:if> --%>
                             
                             <!-- 表单授权,已发表单或者已发归档的表单可以设置表单首选 -->
                             <c:if test="${((summaryVO.summary.startMemberId eq CurrentUser.id and summaryVO.openFrom eq 'docLib') or summaryVO.openFrom eq 'listSent') and summaryVO.bodyType eq '20' and (productId ne '0' or productId ne '7')}">
                                 <c:set value="${countBtn+1}" var="countBtn" />
                                 <c:if test="${countBtn<=5}">
                                    <span class="hand left" id="formAuthority"><span class="ico16 authorize_16 margin_lr_5" title="${ctp:i18n('common.toolbar.relationAuthority.label')}"></span>${ctp:i18n('common.toolbar.relationAuthority.label')}</span>3
                                 </c:if>
                                 <c:if test="${countBtn>5}">
                                     <input id="formAuthorityFlag" type="hidden"/>    
                                 </c:if>
                             </c:if>
                            
                             <!-- 追溯流程 -->
                             <c:if test="${hasWorkflowDataaButton && summaryVO.openFrom == 'listPending'}">
                                 <c:set value="${countBtn+1}" var="countBtn" />
                                 <c:if test="${countBtn<=5}">
                                     <span class="hand left" id="showWorkflowtrace"><span class="ico16 review_flow_16 margin_lr_5" title="${ctp:i18n('collaboration.workflow.label.lczs')}"></span>${ctp:i18n('collaboration.workflow.label.lczs')}</span>
                                 </c:if>
                                 <c:if test="${countBtn>5}">
                                     <input id="showWorkflowtraceFlag" type="hidden"/>    
                                 </c:if>
                             </c:if>
                             
                             
                             <c:choose>
                                  <c:when test="${param.openFrom eq 'listSent' and (isHistoryFlag ne 'true')}">
                                      <%--如果是已发，则显示督办设置 --%>
                                      <c:set value="${countBtn+1}" var="countBtn" />
                                      <c:if test="${countBtn<=5}">
                                          <span class="hand left" id="showSuperviseSettingWindow"><span class="ico16 setting_16 margin_lr_5" title="${ctp:i18n('collaboration.common.flag.showSuperviseSetting')}"></span>${ctp:i18n('collaboration.common.flag.showSuperviseSetting')}</span>
                                      </c:if>
                                      <c:if test="${countBtn>5}">
                                          <input id="showSuperviseSettingWindowFlag" type="hidden"/>    
                                      </c:if>
                                  </c:when>
                                  <c:when test="${((param.openFrom eq 'listDone' and summaryVO.isCurrentUserSupervisor) or param.openFrom eq 'supervise') and (isHistoryFlag ne 'true')}">
                                      <c:set value="${countBtn+1}" var="countBtn" />
                                          <c:if test="${countBtn<=5}">
                                              <!-- 督办 -->
                                              <span class="hand left"  id="showSuperviseWindow"><span class="ico16 meeting_look_1 margin_lr_5" title="${ctp:i18n('collaboration.common.flag.showSupervise')}"></span>${ctp:i18n('collaboration.common.flag.showSupervise')}</span>
                                          </c:if>
                                          <c:if test="${countBtn>5}">
                                             <input id="showSuperviseWindowFlag" type="hidden"/>    
                                          </c:if>
                                  </c:when>
                              </c:choose>
                              
                              
                              <!--流程最大化 -->
                             <%-- <c:set value="${countBtn+1}" var="countBtn" />
                             <c:if test="${countBtn<=5}">
                                 <span class="hand left" id="processMaxFlag" title="${ctp:i18n('collaboration.summary.flowMax')}"><span class="ico16 process_max_16 margin_lr_5 "></span>${ctp:i18n('collaboration.summary.flowMax')}</span>
                             </c:if> 
                             <c:if test="${countBtn>5}">
                                 <input id="_processMaxFlag" type="hidden"/>    
                             </c:if> --%>
 
 
                             <%-- <c:if test="${countBtn>5}">
                                <span id="caozuo_more" class="ico16 arrow_2_b left margin_l_5"></span>
                             </c:if> --%>
                        </div>
                        <div style="clear: both;"></div>
                        </div>
                        <table class="" border="0" cellspacing="0" cellpadding="0" width="100%">
                            <tr>
                                <td colspan="2">
                                <div id="attachmentTRshowAttFile" class="margin_t_5" style="display: none;">
                                      <div style="float:left;padding-top:5px;" class="margin_l_25 margin_r_5"><span class="ico16 affix_16"></span> (<span id="attachmentNumberDivshowAttFile"></span>) </div>
                                      <div id="attFileDomain" isGrid="true" class="comp" comp="type:'fileupload',attachmentTrId:'showAttFile',canFavourite:${canFavorite},applicationCategory:'1',canDeleteOriginalAtts:false" attsdata='${attListJSON }'> </div>
                                </div>
                               </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <%--关联文档 --%>
                                    <div id="attachment2TRDoc1" style="display: none;">
                                        <div style="float:left;padding-top:5px;" class="margin_l_25 margin_r_5"><span class="ico16 associated_document_16"></span> (<span id="attachment2NumberDivDoc1"></span>)</div>
                                        <div style="float: right;" id="assDocDomain" isCrid="true" class="comp" comp="type:'assdoc',attachmentTrId:'Doc1',applicationCategory:'1',referenceId:'${vobj.summary.id}',modids:1,canDeleteOriginalAtts:false" attsdata='${attListJSON }'></div>
                                    </div>
                                    <div id="attActionLogDomain" style="display: none;"></div>
                                </td>
                            </tr>
                        </table>
                        <div class="padding_l_25 padding_t_5 hidden" id="show_edit_workFlow">
                            <%-- 修改流程 --%>
                            <a id="edit_workFlow" class="common_button common_button_gray" >${ctp:i18n('collaboration.summary.updateFlow')}</a>
                        </div>
                   </div>
                   <div id="content_workFlow" class="stadic_layout_body stadic_body_top_bottom processing_view align_center" style="width: 100%;top:30;visibility: visible;">
                        <div style="position:absolute; overflow:hidden; width:100%; height:10px; -moz-box-shadow:inset 0px 3px 5px #A8A8A8; box-shadow:inset 0px 3px 5px #A8A8A8;">&nbsp;</div>
                        <iframe  frameborder="0" style="display:none;position:absolute;top:0px;right:20px;width:650px;z-index:200;height: 180px" id="attachmentList" class="over_auto align_right" src="" >
                        </iframe> 
                        <iframe id="iframeright" class="hidden bg_color_white" src="about:blank"  width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
                        <c:set var="securityCheckParam" value="&docResId=${param.docResId}&docId=${param.docId}&baseObjectId=${param.baseObjectId}&baseApp=${param.baseApp}&fromEditor=${param.fromEditor}&eventId=${param.eventId}&relativeProcessId=${param.relativeProcessId}&processId=${param.processId}"/>
                        <div class="scroll-wrapper">
                        <iframe id="componentDiv" name="componentDiv" width="100%" height="100%" frameborder="0"
                            src='${path }/collaboration/wechatCollaboration.do?method=componentPageForWechat&affairId=${summaryVO.affairId}&rightId=${rightId}&canFavorite=${canFavorite}&isHasPraise=${isHasPraise}&readonly=${summaryVO.readOnly}&openFrom=${summaryVO.openFrom}&isHistoryFlag=${isHistoryFlag}&trackType=${param.trackTypeRecord}${securityCheckParam}&r=<%=Math.random()%>'></iframe>
                        </div>
                        <iframe id="formRelativeDiv" name="formRelativeDiv" width="100%" height="100%" frameborder="0" class="hidden bg_color_white" src=""></iframe>
                        <jsp:include page="/WEB-INF/jsp/common/content/workflow.jsp" />
                    </div>
                    <%-- 跟踪区域开始 --%>
                         <input type="hidden" id="zdgzry" name="zdgzry" />
                         <div id="htmlID" class="hidden"> 
                        <div class="padding_tb_10 padding_l_10">
                        <input type="text" style="display: none" id="zdgzryName" name="zdgzryName" size="30" onclick="$('radio4').click()"/>
                            <%-- 跟踪 --%>
                            <span class="valign_m">${ctp:i18n('collaboration.forward.page.label4')}:</span>
                            <select id="gz" class="valign_m">
                                <option value="1">${ctp:i18n('message.yes.js')}</option><%-- 是 --%>
                                <option value="0">${ctp:i18n('message.no.js')}</option><%-- 否 --%>
                            </select>
                            <div id="gz_ren" class="common_radio_box clearfix margin_t_10">
                                <label for="radio1" class="margin_r_10 hand">
                                    <input type="radio" value="0" id="radio1" name="option" class="radio_com">${ctp:i18n('collaboration.listDone.all')}</label><!-- 全部 -->
                                <label for="radio4" class="margin_r_10 hand">
                                    <input type="radio" value="0" id="radio4" name="option" class="radio_com">${ctp:i18n('collaboration.listDone.designee')}</label><!-- 指定人 -->
                            </div>
                        </div>
                    </div>
                    <%-- 跟踪区域结束 --%>
                    <input type="hidden" name="can_Track" id="can_Track" value="${summary.canTrack ? 1 : 0}" />
                    <input type="hidden" name="trackType" id="trackType" value="${trackType}" />
            </div>  
        </div>
    </div>
<script type="text/javascript">   
OfficeObjExt.showExt = OfficeObjExtshowExt;
</script>
</body>
</html>
<script>
$(function(){
    if ($.browser.msie){
        if($.browser.version < 7 || document.documentMode<8){
			var _c = document.getElementById('content_workFlow');
			if(document.documentMode<8)_c.style.height = _c.clientHeight
            $("#componentDiv").height($("#content_workFlow").height());
            $(window).resize(function(){
                $("#componentDiv").height($("#content_workFlow").height());
            })
        }
    }
})
</script>