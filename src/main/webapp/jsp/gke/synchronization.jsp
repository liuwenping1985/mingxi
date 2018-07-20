<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
<title>accountList</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="head.jsp"%>
<script type="text/javascript">
getA8Top().hiddenNavigationFrameset(); //隐藏当前位置   

	function asynchronism()
		{
		
	    try {
	     getA8Top().startProc('');
	    document.getElementById("startSynchron").disabled = true;
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
	     
	     
	//定义回调函数
	this.invoke = function(ds) {
		try {
			if(ds != null && (typeof ds == 'string'))
			{
			getA8Top().endProc();
	        document.getElementById("showtime").style.display="";
	        document.getElementById("fieldsettext").innerText=ds;
			}
		}
		catch (ex1) {
		  alert("Exception : " + ex1);
		}
	}
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxGKESynchronController", "asynchronism",true);
		requestCaller.addParameter(1, "String", isdel);
		requestCaller.addParameter(2, "String", isovr);
		requestCaller.serviceRequest();
		}
		catch (ex1) {
			alert("Exception : " + ex1);
		}
		}
</script>
</head>

<body>
<table border="0" cellpadding="0" cellspacing="0" width="99%" height="100%" align="center" class="line">
	<tr>
		<td width="100%" height="60" valign="top">
			 <table width="100%" border="0" cellpadding="0" cellspacing="0" class="page2-header-line">
			        <tr>
						<td width="80"><img src="<c:url value="/apps_res/systemmanager/images/pic-yinzhang.gif" />" width="80" height="60" /></td>
						<td class="page2-header-bg">&nbsp;<fmt:message key="org.synchron.gke" /></td>
						<td>&nbsp;</td>
			      </tr>
			 </table>
		</td>
	</tr>
	<tr>
		<td height="80">
		<form name="gkeForm" method="post">
		<table class="sort manage-stat-1" width="97%" border="0" cellspacing="0" cellpadding="0" align="center">
		  <tr>
		    <td width="20%" align="center"><input type="button" id="startSynchron" name="startSynchron" value="<fmt:message key="org.synchron.start" />" class="button-default-2" onclick="asynchronism()"></td>
		    <td width="20%" align="left"><input type="checkbox" id="isDelAllDate" name="isDelAllDate"><fmt:message key="org.synchron.del.data" /></td>
		    <td width="15%" align="left"><input type="checkbox" id="isOverOrgDate" name="isOverOrgDate"><fmt:message key="org.synchron.over.org" /></td>
		    <td width="45%"></td>
		  </tr>
		</table>
		</form>
		</td>
	</tr>
	<!--
	<tr>	
	<td colspan="2">
	<div style="padding:20px">
			<fieldset style="width:70%;height:20%" ><legend><fmt:message key="org.synchron.result" /></legend>
				<table width="50%" border="0">
					  <tr height="20%">
					    <td width="5%" align="center">&nbsp;
					      <div <c:if test="${!showResult }">style="display:none"</c:if>>
					      <fmt:message key="org.synchron.log.total" />：${ success+fail}&nbsp;&nbsp;&nbsp;&nbsp;
					      <fmt:message key="org.synchron.log.success" />：${ success}&nbsp;&nbsp;&nbsp;&nbsp;
					      <fmt:message key="org.synchron.log.fail" />：${ fail}&nbsp;&nbsp;&nbsp;&nbsp;
					      <div>
					    </td>
        			  </tr>
			    </table>
			</fieldset>
	</div>
	</td>
	<td></td>
	</tr>
	-->
	<tr>	
	<td colspan="2">
	<div style="padding:20px;display: none" id="showtime">
	
		   <fieldset style="width:70%;height:20%" id="fieldsettext"><legend><fmt:message key="org.synchron.log" /></legend>
			
			</fieldset>
		
	</div>
	<td>
	<td></td>
	</tr>
	
</table>
</body>
</html>