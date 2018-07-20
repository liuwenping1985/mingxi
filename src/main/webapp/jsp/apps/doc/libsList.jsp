<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="docHeader.jsp" %>
<%@ include file="docLibRightMenu.jsp"%>
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
  <div class="right_div_row2">
    <%@ include file="libTable.jsp"%>
  </div>
</div>
<iframe name="theFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>