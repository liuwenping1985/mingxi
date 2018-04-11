<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@include file="head.jsp"%>
<head>
<title><fmt:message key="org.synchron.hand" bundle='${v3xVideoconf}'/></title>
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
	      <tr height="50%" border="0">
	      	<td>&nbsp</td>
	      </tr>
		  <tr height="50%">
		    <td align="left" nowrap="nowrap"><input type="checkbox" id="isDelAllDate" name="isDelAllDate" style="display:none"></td>
		    <td align="left" nowrap="nowrap"><input type="checkbox" id="isOverOrgDate" name="isOverOrgDate" style="display:none"></td>
            <td width="50%" align="center">
            <input type="button" id="startSynchron" name="startSynchron" value="<fmt:message key="org.synchron.confirm"  bundle='${v3xVideoconf}'/>"  class="button-default-2" onclick="showSendResult()">
		    </td>
            <td width="50%" align="center">
            <input type="button" id="cancel" name="cancel" value="<fmt:message key="mt.synchor.cancel" bundle='${v3xVideoconf}'/>"  class="button-default-2" onclick="window.close()">
		    </td>
		  </tr>
		</table>

</body>