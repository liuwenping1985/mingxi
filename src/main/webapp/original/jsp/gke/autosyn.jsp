<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@include file="head.jsp"%>
<html>
<head>
<title>accountList</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script type="text/javascript">
		getA8Top().showLocation(null,"<fmt:message key='org.synchron.gke'/>","<fmt:message key='org.synchron.autotimeset'/>");
	</script>
<script type="text/javascript">
	function cancel(){
		document.location.href = "${gkeURL}?method=showAccountState";
	}
	function startAutoSyn()
		{
		var isEnabled;
		var intervalDay = document.all.intervalDay.value;
	    var intervalHour = document.all.intervalHour.value;
	    var intervalMin = document.all.intervalMin.value;
			if(intervalDay=='0' && intervalHour=='0' && intervalMin=='0'){
				alert("<fmt:message key='org.synchron.alert.autotime'/>");
				return;
			}
		
		  	 var enable = document.getElementsByName("enable");
		for(var i = 0 ; i < enable.length; i++){
			if(enable[i].checked)
				isEnabled =enable[i].value;
		}
		  var requestCaller = new XMLHttpRequestCaller(this, "ajaxGKESynchronController", "startAutoSynchron",false);
		  requestCaller.addParameter(1, "String", intervalDay);
		  requestCaller.addParameter(2, "String", intervalHour);
		  requestCaller.addParameter(3, "String", intervalMin);
		  requestCaller.addParameter(4, "String", isEnabled);
		  var ds = requestCaller.serviceRequest();
		  if(ds==null||ds=='')
		  {
	          alert("fail");
	          top.endProc();
		      return false;
		  }
		  else
		  {
		  alert(ds);
		  }
		  return true;	  
		}
		
		</script>
</head>
	
<body style="text-align:center">

<div class="divFrame">

<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
	<tr>
		<td class="categorySet-4" height="8"></td>
	</tr>
	<tr>
		<td class="categorySet-head" height="23">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="categorySet-1" width="4"></td>
				<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key="org.synchron.autoset" /></td>
				<td class="categorySet-2" width="7"></td>
				<td class="categorySet-head-space">&nbsp;</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td class="categorySet-head">
		<div class="categorySet-body" align="center">
		<br>
	    <br>
        <br>
<fieldset style="width: 550;height:160;" ><legend><b><fmt:message key="org.synchron.selecttime" /></b></legend>
	<table width="500" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td  nowrap="nowrap" class="bg-gray"><fmt:message key="synchron.interval"/>：</td>
			<td  nowrap="nowrap" class="new-column">
				<select name="intervalDay">
								<option value="0" ${intervalDay == '0'?'selected':''}>0</option>
								<option value="1" ${intervalDay == '1'?'selected':''}>1</option>
								<option value="2" ${intervalDay == '2'?'selected':''}>2</option>
								<option value="3" ${intervalDay == '3'?'selected':''}>3</option>
								<option value="4" ${intervalDay == '4'?'selected':''}>4</option>
								<option value="5" ${intervalDay == '5'?'selected':''}>5</option>
								<option value="6" ${intervalDay == '6'?'selected':''}>6</option>
				</select>
				<fmt:message key="synchron.day"/>
				<select name="intervalHour">
								<option value="0" ${intervalHour == '0'?'selected':''}>0</option>
								<option value="1" ${intervalHour == '1'?'selected':''}>1</option>
								<option value="2" ${intervalHour == '2'?'selected':''}>2</option>
								<option value="3" ${intervalHour == '3'?'selected':''}>3</option>
								<option value="4" ${intervalHour == '4'?'selected':''}>4</option>
								<option value="5" ${intervalHour == '5'?'selected':''}>5</option>
								<option value="6" ${intervalHour == '6'?'selected':''}>6</option>
								<option value="8" ${intervalHour == '8'?'selected':''}>8</option>
								<option value="10" ${intervalHour == '10'?'selected':''}>10</option>
								<option value="12" ${intervalHour == '12'?'selected':''}>12</option>
								<option value="24" ${intervalHour == '24'?'selected':''}>24</option>
				</select>
				<fmt:message key="synchron.hour"/>
				<select  name="intervalMin">
				<option value="0" ${intervalMin == '0'?'selected':''}>0</option>
				<option value="5" ${intervalMin == '5'?'selected':''}>5</option>
				<option value="10" ${intervalMin == '10'?'selected':''}>10</option>
				<option value="15" ${intervalMin == '15'?'selected':''}>15</option>
				<option value="20" ${intervalMin == '20'?'selected':''}>20</option>
				<option value="30" ${intervalMin == '30'?'selected':''}>30</option>
				<option value="40" ${intervalMin == '40'?'selected':''}>40</option>
				<option value="50" ${intervalMin == '50'?'selected':''}>50</option>
				<option value="60" ${intervalMin == '60'?'selected':''}>60</option>
				</select>
			<fmt:message key="org.synchron.timeunit"/>
		</tr>
		<tr>
			<td  nowrap="nowrap" class="bg-gray"><fmt:message key="org.synchron.isstartauto" />：</td>
			<td  nowrap="nowrap" class="new-column"><input type="radio" id="a" name="enable" value="0" <c:if test="${isAutoSynFlag==true}">checked</c:if> <c:if test="${editFlag!=1}">disabled</c:if>><fmt:message key="org.synchron.enable"/><input type="radio" id="b" name="enable" value="1" <c:if test="${isAutoSynFlag==false}">checked</c:if> <c:if test="${editFlag!=1}">disabled</c:if>><fmt:message key="org.synchron.disabled"/></td>
		</tr>

	</table>
</fieldset>
	</div>
	</td>
	</tr>
	<c:if test="${editFlag==1}">
	
	<tr>
		<td height="42" align="center" colspan="2" class="bg-advance-bottom"><input type="button" value="<fmt:message key="org.synchron.determined"/>" onclick="startAutoSyn()"  class="button-default-2">
			&nbsp;&nbsp;<input type="button" onClick="cancel()"  value="<fmt:message key="common.button.cancel.label" bundle='${v3xCommonI18N}'/>" class="button-default-2">
			</td>
	</tr>
	</c:if>
	</table>
	</div>
</body>
</html> 