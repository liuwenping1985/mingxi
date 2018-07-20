<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@include file="head.jsp"%>
<head>
<title><fmt:message key="org.synchron.hand" /></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script type="text/javascript">
function showSendResult(){
    var isdel=0;
	var isovr=0;
	if(document.getElementById("isDelAllDate").checked)
	{
      isdel=1;
	}

	if(document.getElementById("isOverOrgDate").checked)
	{
       isovr=1;
	}
	var returnMsg = isdel+","+isovr+"";
	window.returnValue = returnMsg;
	window.close();
}
		
</script>
</head>
<body>
	<table class="sort manage-stat-1" width="97%" border="0" cellspacing="0" cellpadding="0" align="center">
		  <tr>
		    <td width="20%" align="left" nowrap="nowrap"><input type="checkbox" id="isDelAllDate" name="isDelAllDate"><fmt:message key="org.synchron.del.data" /></td>
		    <td width="15%" align="left" nowrap="nowrap"><input type="checkbox" id="isOverOrgDate" name="isOverOrgDate"><fmt:message key="org.synchron.over.org" /></td>
            <td width="20%" align="center">
            <input type="button" id="startSynchron" name="startSynchron" value="<fmt:message key="org.synchron.start" />" class="button-default-2" onclick="showSendResult()">
		    </td>
		    <td width="45%"></td>
		  </tr>
		</table>

</body>