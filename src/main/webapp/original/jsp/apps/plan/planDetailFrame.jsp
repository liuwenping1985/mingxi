<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.seeyon.ctp.common.flag.BrowserEnum"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<c:if test="${v3x:hasPlugin('taskmanage')}">
	<%@ include file="/WEB-INF/jsp/apps/taskmanage/taskInterface.js.jsp"%>
</c:if>
<c:if test="${v3x:hasPlugin('calendar')}">
	<script type="text/javascript" src="${path}/apps_res/calendar/js/calEvent_Create_addData_js.js${ctp:resSuffix()}"></script>
</c:if>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
<html>
<head>
<%
if(BrowserEnum.valueOf(request) == BrowserEnum.IE11){
%>
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9">
<%
} else {
%>
    <meta http-equiv="X-UA-Compatible" content="IE=EDGE"/>
<%
}
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript">
var detailLayout;
var proce = null;
/**
 * 启动进度条
 * 
 * @param meg 进度显示信息
 */
function startProgressBar() {
    proce = $.progressBar();
}

/**
 * 关闭进度条
 */
function closeProgressBar() {
    if (proce && proce != null) {
        proce.close();
        proce = null;
    }
}

$().ready(function(){
    startProgressBar();
	detailLayout = $("#detailLayout").layout();
	$("#detailRightFrame").attr("src","plan.do?method=getPlanSummary&planId=${param.planId }&path=${commentMaxPathStr}&sfrom=${sfrom}&readOnly=${param.readOnly}");
	$('#detailLeftDiv').css("border-left-width","0px");
	$('#detailLeftDiv').css("border-bottom-width","0px");
});

var myActions = "${param.doneAction}"==""?"view":"${param.doneAction}";
var openStyle = "${param.open}";
function OK(){
	return myActions;
}
</script>
</head>

<body class="page_color bg_color"  onbeforeunload="removeCtpWindow('${param.planId}',2)">
	<input id="dataSource" name="dataSource" type="hidden" value="${param.dataSource }" />
	<div id="detailLayout" class="comp " comp="type:'layout'">
 		<div id="detailLeftDiv" class="layout_center over_hidden" layout="border:true,sprit:false,width:1000"> 
        	<div style="height:100%">
        		<%@ include file="/WEB-INF/jsp/apps/plan/planDetail.jsp"%>
        	</div>
         </div> 
        <c:if test="${isRef eq false}">
	        <div class="layout_east" layout="border:false,width:78,minWidth:78,maxWidth:310,sprit:false">
	        	<iframe id="detailRightFrame" name="detailRightFrame" src="" frameBorder="no" border="0" height="97%" width="100%"></iframe>
	        </div>
        </c:if>
	</div>
</body>

</html>