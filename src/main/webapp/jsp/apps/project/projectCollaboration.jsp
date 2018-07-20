<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=pendingManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=colManager"></script>
<script type="text/javascript" src="<c:url value='/apps_res/project/js/projectCollaborationEvent.js${v3x:resSuffix()}'/>"></script>
<script type="text/javascript" src="<c:url value='/apps_res/project/js/pendingMain.js${v3x:resSuffix()}'/>"></script>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
<script type="text/javascript">
	//栏目面板id
	var sectionId=1;
	try{
		sectionId=parent.document.getElementById("PanelId_"+"${sectionEntityId}").value;
	}catch(e){}
	var widthSize="${width}";
	var iframeWidth=$(window).width();
	var iframeHeight=$(window).height();
	var columnsCount="${columnsCount}";
	var columnProperty="${columnProperty}";
	var columnsStyle="${columnsStyle}";
	var sfyData="${sfyData}";
	//协同处理所需参数
	var selectChartId="";
	var dataNameTemp="";
	$(function(){
		initCssStyle();
	})
</script>
</head>
<body class="h100b bg_color_white">
	<div id="contentDiv" class="h100b w100b" style="position: absolute; z-index: 1;overflow-x:auto;overflow-y:hidden;">
		<table cellpadding="0" class="h100b w100b" cellspacing="0" border="0">
		<tr>
		<!--单列表 -->
		<c:if test="${columnsStyle eq '1'}">
			<td valign="top" valign="top" noWrap="nowrap">
				<div id="leftListDiv" class="channel_content font_size12">
					<%@ include file="/WEB-INF/jsp/apps/project/leftProjectCollaboration.jsp" %>
				</div>
			</td>
		</c:if>
		<!-- 双列表  -->
		<c:if test="${columnsStyle eq '2'}">
			<td valign="top" valign="top" noWrap="nowrap" class="border_r">
				<div id="leftListDiv" class="channel_content font_size12" >
					<%@ include file="/WEB-INF/jsp/apps/project/leftProjectCollaboration.jsp" %>
				</div>
			</td>
			<td valign="top" valign="top" noWrap="nowrap">
				<div id="rightListDiv" class="channel_content font_size12">
					<c:set var="rowList1" value="${rowList2}"></c:set>
					<%@ include file="/WEB-INF/jsp/apps/project/rightProjectCollaboration.jsp" %>
				</div>
			</td>
		</c:if>
		</tr>
		</table>
	</div>
</body>
<script type="text/javascript" src="<c:url value='/apps_res/project/js/projectCollaborationStyle.js${v3x:resSuffix()}'/>"></script>
</html>