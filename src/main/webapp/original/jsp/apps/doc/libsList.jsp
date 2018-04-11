<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="docHeader.jsp" %>
<%@ include file="docLibRightMenu.jsp"%>
<%@page import="java.util.List" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript">
	//getA8Top().contentFrame.document.all.navigationFrameset.rows = "0,*";
</script>
<script language="javascript">
function libShowOrhidden() {
	if(parent.layout.cols == "0,*") {
		parent.layout.cols = "150,*";
		getA8Top().contentFrame.LeftRightFrameSet.cols = "0,*";
	}
	else {
		parent.layout.cols = "0,*";
		getA8Top().contentFrame.leftFrame.closeLeft();
	}
}
var isAdvancedQuery = ${param.method eq 'advancedQuery'};
</script>
<style>
/***layout*row1+row2***/
.main_div_row2 {
 width: 100%;
 height: 100%;
 _padding-left:0px;
}
.right_div_row2 {
 width: 100%;
 height: 100%;
 _padding:54px 0px 0px 0px;
}
.main_div_row2>.right_div_row2 {
 width:auto;
 position:absolute;
 left:0px;
 right:0px;
}
.center_div_row2 {
 width: 100%;
 height: 100%;
 /*background-color:#00CCFF;*/
 overflow:auto;
}
.right_div_row2>.center_div_row2 {
 height:auto;
 position:absolute;
 top:54px;
 bottom:0px;
}
.top_div_row2 {
 height:54px;
 width:100%;
 /*background-color:#9933FF;*/
 position:absolute;
 top:0px;
}

.mxtgrid div.bDiv {
    border-bottom-width: 1px;
    border-right-width: 1px;
    border-left-width: 0px;
}

.mxtgrid div.hDiv {
    border-left-width: 0px;
    border-top-width: 0px;
}

/***layout*row1+row2****end**/
</style>
</head>
<body>
<div class="main_div_row2">
	<div style="padding: 5px 0 5px 5px; background: #f0f0f0;">
		<script>
		var newSubItems = new WebFXMenu;
		var sendToSubItems = new WebFXMenu;
		var forwardSubItems = new WebFXMenu;
		var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
		myBar.add(new WebFXMenuButton("new", "<fmt:message key='doc.menu.new.label'/>", "", [1,1],"<fmt:message key='doc.menu.new.label'/>", newSubItems));
		myBar.add(new WebFXMenuButton("upload", "<fmt:message key='doc.menu.upload.label'/>", "fileUpload('upload');", [1,6],"<fmt:message key='doc.menu.upload.label'/>", null));
		myBar.add(new WebFXMenuButton("sendto", "<fmt:message key='doc.menu.sendto.label'/>", "",[9,1],"<fmt:message key='doc.menu.sendto.label'/>", sendToSubItems));
		myBar.add(new WebFXMenuButton("move", "<fmt:message key='doc.menu.move.label'/>", "selectDestFolder('undefined','${param.resId}','${param.docLibId}','${param.docLibType}','move');",[2,1],"<fmt:message key='doc.menu.move.label'/>", null));
		myBar.add(new WebFXMenuButton("del", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "delF('topOperate','topOperate')",[1,3],"<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", null));
		myBar.add(new WebFXMenuButton("forward", "<fmt:message key='common.advance.label' bundle='${v3xCommonI18N}'/>", "",[17,1],"<fmt:message key='common.advance.label' bundle='${v3xCommonI18N}'/>", forwardSubItems));
		var shareAndBorrow = '${param.isShareAndBorrowRoot}';
	 	<v3x:showThirdMenus rootBarName="myBar" parentBarName="forwardSubItems" addinMenus="${AddinMenus}"/>
	 	myBar.disabled();
		document.write(myBar);
		docDisable('new');
		docDisable('upload');
		docDisable('sendto');
		docDisable('move');
		docDisable("del");
		docDisable("forward");
	</script>
	<%
		List addinMenus = (List)request.getAttribute("AddinMenus");
	%>
	</div>
  <div class="right_div_row2 iframeRight">
    <%@ include file="libTable.jsp"%>
  </div>
</div>
<iframe name="theFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>