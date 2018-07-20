<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="menu.address.list" bundle="${v3xMainI18N}" /></title>
<script type="text/javascript">
<!--
	//getA8Top().showLocation(1006);
	var historyUrl = new Array();
	var historyLength =0;
	function myback(){
		if(event.keyCode==8){
			if(historyLength < 1){
				window.history.back(-1);			
			}else{
				historyLength--;
				changeMenuTab(historyUrl[historyLength-1]);
			}
		}
	}
	function remberHistory(tabUrl){
		var table = tabUrl;
		if(historyLength==0 || historyUrl[historyLength-1]!= table){
			historyUrl[historyLength]=table;
			historyLength ++;
		}
	}
	function returnBack(){
	  getA8Top().back();
	}
	
	window.onbeforeunload = function(){
	    try {
	        removeCtpWindow(null,2);
	    } catch (e) {
	    }
	}
//-->
</script>
<style type="text/css">
	.border_b_s{
		border-bottom: 1px solid #b6b6b6;
	}
</style>
</head>
<body scroll="no" style="overflow: hidden;" onload="setDefaultTab(0);remberHistory(document.getElementById('first'))" onkeydown="myback()">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
  <td valign="bottom" height="33" class="tab-tag border_b_s">
		<div class="tab-separator"></div>
	<div id="menuTabDiv" class="div-float">
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel" style="border-bottom-width:0px;" id="first" onclick="javascript:changeMenuTab(this);remberHistory(this);" url="${urlAddressBook}?method=home&addressbookType=1"><fmt:message key='addressbook.menu.private.label' bundle='${v3xAddressBookI18N}'/></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel" style="border-bottom-width:0px;" onclick="javascript:changeMenuTab(this);remberHistory(this);" url="${urlAddressBook}?method=home&addressbookType=2"><fmt:message key='addressbook.menu.public.label'  bundle='${v3xAddressBookI18N}'/></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel" style="border-bottom-width:0px;" onclick="javascript:changeMenuTab(this);remberHistory(this);" url="${urlAddressBook}?method=home&addressbookType=4"><fmt:message key='addressbook.team.personal.label'  bundle='${v3xAddressBookI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel" style="border-bottom-width:0px;" onclick="javascript:changeMenuTab(this);remberHistory(this);" url="${urlAddressBook}?method=home&addressbookType=3&from=sys"><fmt:message key='addressbook.team.system.label'  bundle='${v3xAddressBookI18N}'/></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>
	</div>
  </td>
</tr>
<tr>
  <td>
  <div id="scrollDiv" style="height: 100%;width: 100%">
	<iframe noresize="noresize" frameborder="no" id="detailIframe" name="detailIframe" width="100%" height="100%" border="0px"></iframe>			
 </div>
  </td>
</tr>
</table>
<script>
initIpadScroll("scrollDiv",520);
</script>
</body>
</html>
