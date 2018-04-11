<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<LINK href="<c:url value='/apps_res/plan/css/DocMgr.css${v3x:resSuffix()}'/>" type=text/css rel=STYLESHEET>
<script type="text/javascript">
	function increaseYear(){
		var myYear = document.getElementById("c_year");
		myYear.innerHTML = parseInt(myYear.innerHTML) + 1;
	}
	
	function decreaseYear(){
		var myYear = document.getElementById("c_year");
		myYear.innerHTML = parseInt(myYear.innerHTML) - 1;
	}
	
	function fnsubmit(m){
		var returnValue = document.getElementById("c_year").innerHTML + "-" + m;
		transParams.parentWin.selectDateCollBack(returnValue);
	}
	function setYear(){
		var y = new Date().getFullYear();
		document.getElementById("c_year").innerHTML = y;
	}
	
	function clear(){
		transParams.parentWin.selectDateCollBack("");
	}
</script>
</head>
<body style="overflow:visible;" onload="setYear()">
<table border="0" cellspacing="0" cellpadding="0" width="100%" height="100%">
	<tr class="calenderTitle">
		<td align="center" valign="middle" class="cursor-hand" onclick="javascript:decreaseYear();" width="10%" height="15">
			<img src="<c:url value='/common/images/leftMounth.gif'/>" border="0">
		</td>
		<td align="center" valign="middle" width="80%" height="15">
			<span id="c_year"></span><fmt:message key="fundia.plan.data.year"  />
		</td>
		<td align="center" valign="middle" class="cursor-hand" onclick="javascript:increaseYear();" width="10%" height="15">
			<img src="<c:url value='/common/images/rightMounth.gif'/>" border="0">
		</td>
	</tr>
	<tr>
		<td colspan="3">
			<table cellpadding="0" cellspacing="0" border="0" width="100%">
				<tr>
		            <td class="cursor-hand" onclick="javascript:fnsubmit(1)" align="center" valign="middle" width="25%" height="40"><fmt:message key="fundia.plan.data.month.1" /></td>
		            <td class="cursor-hand" onclick="javascript:fnsubmit(2)" align="center" valign="middle" width="25%" height="40"><fmt:message key="fundia.plan.data.month.2" /></td>
		            <td class="cursor-hand" onclick="javascript:fnsubmit(3)" align="center" valign="middle" width="25%" height="40"><fmt:message key="fundia.plan.data.month.3" /></td>
		            <td class="cursor-hand" onclick="javascript:fnsubmit(4)" align="center" valign="middle" width="25%" height="40"><fmt:message key="fundia.plan.data.month.4" /></td>
	          	</tr>
	          	<tr>
		            <td class="cursor-hand" onclick="javascript:fnsubmit(5)" align="center" valign="middle" width="25%" height="40"><fmt:message key="fundia.plan.data.month.5" /></td>
		            <td class="cursor-hand" onclick="javascript:fnsubmit(6)" align="center" valign="middle" width="25%" height="40"><fmt:message key="fundia.plan.data.month.6" /></td>
		            <td class="cursor-hand" onclick="javascript:fnsubmit(7)" align="center" valign="middle" width="25%" height="40"><fmt:message key="fundia.plan.data.month.7" /></td>
		            <td class="cursor-hand" onclick="javascript:fnsubmit(8)" align="center" valign="middle" width="25%" height="40"><fmt:message key="fundia.plan.data.month.8" /></td>
	          	</tr>
	          	<tr>
		            <td class="cursor-hand" onclick="javascript:fnsubmit(9)" align="center" valign="middle" width="25%" height="40"><fmt:message key="fundia.plan.data.month.9" /></td>
		            <td class="cursor-hand" onclick="javascript:fnsubmit(10)" align="center" valign="middle" width="25%" height="40"><fmt:message key="fundia.plan.data.month.10" /></td>
		            <td class="cursor-hand" onclick="javascript:fnsubmit(11)" align="center" valign="middle" width="25%" height="40"><fmt:message key="fundia.plan.data.month.11" /></td>
		            <td class="cursor-hand" onclick="javascript:fnsubmit(12)" align="center" valign="middle" width="25%" height="40"><fmt:message key="fundia.plan.data.month.12" /></td>
	          	</tr>
	          	<c:if test="${param.showClearButton eq 'true'}">
	          	<tr>
	          		<td colspan="4" height="20" align="right">
	          		<input type="button" onclick="clear()" value='<fmt:message key="common.button.clear.label" bundle="${v3xCommonI18N}" />'/>
	          		&nbsp;&nbsp;&nbsp;&nbsp;</td>
	          	</tr>
	          	</c:if>
			</table>
		</td>
	</tr>
</table>
</body>
</html>
