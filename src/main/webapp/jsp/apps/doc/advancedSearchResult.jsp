<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="docHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<%@page import="java.util.List" %>
<%@page import="com.seeyon.v3x.common.i18n.ResourceBundleUtil" %>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/thirdMenu.js${v3x:resSuffix()}" />"></script>
<title></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<%@ include file="rightHead.jsp"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/knowledgeBrowseUtils.js" />"></script>
<script type="text/javascript">
function fnCloseAllDialog() {
	getA8Top().$('.mask').remove();
	getA8Top().$('.mxt-window').remove();
	getA8Top().$('.shield').remove();
	getA8Top().$('.dialog_box').remove();
}
</script>
</head>
<body scroll="no" onbeforeunload="fnCloseAllDialog()">
<form action="" name="theForm" id="theForm" method="post" style='display: none'>
</form>
<iframe name="delIframe" frameborder="0" height="0" width="0" style='display: none' scrolling="no" marginheight="0" marginwidth="0"></iframe>
<fmt:setBundle basename="com.seeyon.v3x.isearch.resources.i18n.ISearchResources" var="isearchI18N"/>
<%-- 
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr height="15">
	<td valign="top" style="padding: 5px;background: #EFEFEF">
		<div class="portal-layout-cell ">		  	
			<div class="portal-layout-cell_head">
				<div class="portal-layout-cell_head_l"></div>
				<div class="portal-layout-cell_head_r"></div>
			</div>
			<table border="0" cellSpacing="0" cellPadding="0" width="100%" class="portal-layout-cell-right">
				<tr>
					<td class="sectionBody sectionBodyBorder">
						&nbsp;&nbsp;&nbsp;<fmt:message key="isearch.jsp.list.result" bundle="${isearchI18N}"/>:
					</td>
				</tr>
			</table>
			<div class="portal-layout-cell_footer">
				<div class="portal-layout-cell_footer_l"></div>
				<div class="portal-layout-cell_footer_r"></div>
			</div>
		</div>  
	</td>
</tr>
</table>
--%>
<div id="ScrollDIV" class="border_l">
<script type="text/javascript">
	parent.document.getElementById('advancedSearchButton').disabled = false;
	try{
		parent.document.getElementById("dataIFrame").style.height =parent.document.body.clientHeight -238;
	}catch(e){
		
	}
</script>
<%
	List addinMenus = (List)request.getAttribute("AddinMenus");
%>
<%@ include file="rightTable.jsp"%>
</div>
<form action="" method="post" name="thirdMenuForm" id="thirdMenuForm">
	<input type="hidden" name="thirdMenuIds" id="thirdMenuIds">
</form>
<iframe name="orderIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
<div id="pubDate"></div>
<IFRAME height="0%" name="empty" id="empty" width="0%" frameborder="0"></IFRAME>
<iframe id="emptyIframe" name="emptyIframe" frameborder="0"
	height="0" width="0" scrolling="no" marginheight="0" marginwidth="0" />
</body>
</html>