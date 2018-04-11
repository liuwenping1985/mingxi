<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
</script>
</head>
<body scroll="no" class="padding5">

<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td valign="bottom" height="26" class="tab-tag">
			<div id="menuTabDiv" class="div-float">
			
			<div class="${param.from=='publish'||param.from==null?'tab-tag-left-sel':'tab-tag-left'}"></div>
			<div class="${param.from=='publish'||param.from==null?'tab-tag-middel-sel':'tab-tag-middel'}" onclick="javascript:meeting_changeMenuTab(this);" url="mtMeeting.do?method=mymtListMain&from=publish"><fmt:message key="mt.mtMeeting.publish.label" /></div>
			<div class="${param.from=='publish'||param.from==null?'tab-tag-right-sel':'tab-tag-right'}"></div>
			<div class="tab-separator"></div>
			
			<div class="${param.from=='join'?'tab-tag-left-sel':'tab-tag-left'}"></div>
			<div class="${param.from=='join'?'tab-tag-middel-sel':'tab-tag-middel'}" onclick="javascript:meeting_changeMenuTab(this);" url="mtMeeting.do?method=mymtListMain&from=join"><fmt:message key="mt.mtMeeting.attend.label" /></div>
			<div class="${param.from=='join'?'tab-tag-right-sel':'tab-tag-right'}"></div>
			</div>
		</td>
	</tr>

	<tr>
		<td class="page-list-border">

			<iframe src="mtMeeting.do?method=mymtListMain&from=${param.from}&stateStr=${param.stateStr}" noresize="noresize" frameborder="no" id="detailIframe" name="detailIframe" style="width:100%;height: 100%;" border="0px"></iframe>			
		</td>
	</tr>
</table>

</body>
</html>
