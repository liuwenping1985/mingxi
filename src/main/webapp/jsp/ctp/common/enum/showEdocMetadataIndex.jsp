<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
	getA8Top().showLocation("208","<fmt:message key='metadata.manager.metadatamgr' bundle="${v3xSysI18N}"/>");
</script>
<script type="text/javascript">
function getObjectById(divObj){
   var returnObj = document.getElementById(divObj) ;
   return returnObj;
}
function displayObj(){
 var displayObj = document.getElementById("toolbarFram") ;
}
</script>

</head>
<body scroll="no" class="padding5">
<form action="" name="delectForm" method="post" target="mainIframe" id="deleteForm">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td valign="top" width="100%" height="100%" align="center" class="page-list-border-LRD" style="padding-top:1px;">
		    <iframe width="100%" height="100%" frameborder="0" src="${metadataMgrURL}?method=showEdocMetadataMain" name="mainIframe" id="mainIframe" />
		</td>
	</tr>
</table>
</form>
 <iframe name="deleteFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>		
</html>