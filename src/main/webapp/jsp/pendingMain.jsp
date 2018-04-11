<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
<%@ include file="pending_header.jsp"%>
<link rel="stylesheet" href="/seeyon/common/all-min.css${ctp:resSuffix()}">
<c:if test="${CurrentUser.skin != null}">
    <link rel="stylesheet" href="/seeyon/skin/${CurrentUser.skin}/skin${CurrentUser.fontSize}.css${ctp:resSuffix()}">
</c:if>
<c:if test="${CurrentUser.skin == null}">
    <link rel="stylesheet" href="/seeyon/skin/default/skin${CurrentUser.fontSize}.css${ctp:resSuffix()}">
</c:if>
<link rel="stylesheet" type="text/css"  href="/seeyon/main/skin/frame/default/default_common.css${ctp:resSuffix()}">
<link rel="stylesheet" id="mainSkinCss" type="text/css"  href="${ctp:getUserDefaultCssPath()}">
<%-- 当不显示统计图的时候不引用图表相关的文件 --%>
<%-- <c:if test="${ctp:hasPlugin('report') and 'listAndStatisticalGraph' eq columnsStyle }"> --%>
<c:if test="${'listAndStatisticalGraph' eq columnsStyle }">
	<jsp:include page="/WEB-INF/jsp/ctp/report/chart/chart_pie.jsp" flush="true"/>
</c:if>
<c:if test="${ctp:hasPlugin('meeting')}">
	<jsp:include page="/WEB-INF/jsp/meeting/dialog/meeting_reply_card_dialog.jsp" flush="true"/>
</c:if>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%--增加下面的样式是为了解决Chrome下统计图显示的高度不对的问题 OA-80186 --%>
<style type="text/css">
.rolling_area_zong li.rolling_item{
	float:left;
	width:270px;
	height:201px;
	word-break:break-all;
}
</style>
</head>
<body class="h100b bg_color_white bg_color_none">
<div id="contentDiv" class="h100b w100b" style="position: absolute; z-index: 1;visibility:hidden;">
<table id="pendingTable" width="100%"  cellpadding="0" cellspacing="0" border="0">
	<tr>
		<!--单列表 -->
		<c:if test="${columnsStyle ne 'listAndStatisticalGraph'}">
			<td valign="top" valign="top" noWrap="nowrap">
				<div id="leftListDiv" class="channel_content font_size12">
					<%@ include file="/WEB-INF/jsp/apps/collaboration/displayPendingList.jsp" %>
				</div>
			</td>
		</c:if>
		<!-- 列表加统计图  -->
		<c:if test="${columnsStyle eq 'listAndStatisticalGraph'}">
			<td id="leftListTd" valign="top" valign="top" noWrap="nowrap" width="66%">
				<div id="leftListIframe" >
					<iframe id="leftList" frameborder="0"
					 style="width:100%;height:100%"></iframe>
				</div>
				<div id="leftListDiv" class="channel_content font_size12">
					<%@ include file="/WEB-INF/jsp/apps/collaboration/displayPendingList.jsp" %>
				</div>
			</td>
			<!--这一个td 用来隔开列表和统计图 -->
			<td width="1" bgcolor="#FFFFFF"></td>
			<!-- 统计图 -->
			<td valign="top" align="center" noWrap="nowrap" class="padding_l_5 page_color">
				<div id="statisticalChart" class="type_chart anychartbg" style="width:310px;margin:0 auto;height:200px;overflow:hidden;">
						<div class="type_chart align_left">
							<div class="front_rolling_flash clearfix">
								<div class="rolling_area_zong">
									<ul class="rolling_box">
										<c:forEach items="${graphicalList }" var="graphicalChart">
											<c:if test="${graphicalChart eq 'handleType' }">
												<li id="handleTypeGraph" class="rolling_item"></li>
											</c:if>
											<c:if test="${graphicalChart eq 'importantLevel' }">
												<li id="importantLevelGraph" class="rolling_item"></li>
											</c:if>
											<c:if test="${graphicalChart eq 'exigency' }">
												<li id="exigencyGraph" class="rolling_item"></li>
											</c:if>
											<c:if test="${graphicalChart eq 'overdue' }">
												<li id="overdueGraph" class="rolling_item"></li>
											</c:if>
											<c:if test="${graphicalChart eq 'handlingState' }">
												<li id="handlingStateGraph" class="rolling_item"></li>
											</c:if>
										</c:forEach>
									</ul>
								</div>
								<div class="rolling_btn_area">
									<span class="ico16 rolling_btn_t"></span>
									<ul id="rollingBtnArea">
										<c:forEach items="${graphicalList }" var="graphicalChart">
											<c:if test="${graphicalChart eq 'handleType' }">
												<li id="handleType"><em class="ico16 rolling_uncurrent"
													title="${ctp:i18n('collaboration.pending.handleType')}"></em>
												</li>
												<!-- 办理类型 -->
											</c:if>
											<c:if test="${graphicalChart eq 'importantLevel' }">
												<li id="importantLevel"><em
													class="ico16 rolling_uncurrent"
													title="${ctp:i18n('collaboration.pending.importantLevel')}"></em>
												</li>
												<!-- 重要程度 -->
											</c:if>
											<c:if test="${graphicalChart eq 'exigency' }">
												<li id="exigency"><em class="ico16 rolling_uncurrent"
													title="${ctp:i18n('collaboration.pending.exigencyGraph')}"></em>
												</li>
												<!-- 紧急程度 -->
											</c:if>
											<c:if test="${graphicalChart eq 'overdue' }">
												<li id="overdue"><em class="ico16 rolling_uncurrent"
													title="${ctp:i18n('collaboration.pending.overdueGraph')}"></em>
												</li>
												<!-- 是否超期 -->
											</c:if>
											<c:if test="${graphicalChart eq 'handlingState' }">
												<li id="handlingState"><em
													class="ico16 rolling_uncurrent"
													title="${ctp:i18n('collaboration.pending.handlingState.name')}"></em>
												</li>
												<!-- 办理状态 -->
											</c:if>
										</c:forEach>
									</ul>
									<span class="ico16 rolling_btn_b"></span>
							</div>
						</div>
					</div>
				</div>
			</td>
		</c:if>
	</tr>
</table>
</div>
<script type="text/javascript">
var iframe_w=0;
var iframe_h=0;
var columnHeaderStr="${columnHeaderList}";
var columnsStyleStr="${columnsStyle}";
var currentPanel="${currentPanel}";
var pageSize="${pageSize}";
var dueToRemind="${dueToRemind}";
var fragmentId="${fragmentId}";
var ordinal="${ctp:escapeJavascript(ordinal)}";
var width="${width}";
var sectionId="${ctp:escapeJavascript(sectionId)}";
var resultMap;
var hasHandleType=false;
var hasImportantLevel=false;
var hasExigency=false;
var hasOverdue=false;
var hasHandlingState=false;
var defaultSelectedId="";
var selectChartId="";
var dataNameTemp="";
var dialogDealColl;
var widthSize="${width}";
var iframeWidth=$("#contentDiv").width();
var iframeHeight=$("#contentDiv").height();
var graphicalListStr="${graphicalList}";
var hasMeetingPlug = "${ctp:hasPlugin('meeting')}";
</script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/channel-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/pendingMain.js${ctp:resSuffix()}"></script>
<c:if test="${ctp:hasPlugin('meeting')}">
	<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/info/js/common/magazine_publish_common.js${ctp:resSuffix()}"></script>
</c:if>
</body>
</html>