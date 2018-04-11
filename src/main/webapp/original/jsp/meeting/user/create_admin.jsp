<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
	<title></title>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<fmt:setBundle basename="com.seeyon.v3x.office.admin.resources.i18n.AdminResources" var="v3xAdmin"/>
<fmt:message key='admin.alert.selectmodel' var="adminalert"/>
<script type="text/javascript">
<!--

function selectPeople()
{
	selectPeopleFun_wf();
}

function setBulPeopleFields(elements){
	if(elements.length > 1){
		alert("<fmt:message key='admin.alert.selectone'/>");
		return false;
	}else{
		var element = elements[0];
		document.getElementById("admin").value=element.id;
		document.getElementById("admin_name").value=element.name;
		/*
		for(prop in element){
			alert(prop+"="+element[prop]);
		}
		*/
	}
}

function selectDepartment()
{
	selectPeopleFun_depart();
}

/*function setBulDepartmentFields(elements){
	if(elements.length > 1){
		alert("<fmt:message key='admin.alert.selectonedep'/>");
		return false;
	}else{
		var element = elements[0];
		document.getElementById("accountId").value=element.accountId;
		document.getElementById("departmentId").value=element.id;
		document.getElementById("mngDepId").value=element.accountShortname + "-" + element.name;
	}
}*/

function setBulDepartmentFields(elements){
	if(elements.length > 0){
		document.getElementById("accountId").value="";
		document.getElementById("departmentId").value="";
		document.getElementById("mngDepId").value="";
		var accValue = document.getElementById("accountId").value;
		var depValue = document.getElementById("departmentId").value;
		var mngValue = document.getElementById("mngDepId").value;
		for(var i = 0; i < elements.length; i++){
			var element = elements[i];
			if(accValue.length > 0){
				accValue += ",";
				depValue += ",";
				mngValue += ",";
			}
			accValue += element.accountId;
			depValue += element.id;
			//mngValue += element.accountShortname + "-" + element.name;
			mngValue += element.name;
		}
		document.getElementById("accountId").value = accValue;
		document.getElementById("departmentId").value = depValue;
		document.getElementById("mngDepId").value = mngValue;
		
	}
}

function doSubmit(){
	var form = document.newForm;
	var checkboxs = document.getElementsByName("adminModel");
	var selectCount = 0;
	for(var i = 0; i < checkboxs.length; i++){
		if(checkboxs[i].checked){
			selectCount++;
		}
	}
	if(selectCount == 0){
		alert("${adminalert}");
		return false;
	}
	if(checkForm(form)){
		newForm.submit();
	}else{
		return false;
	}
}

${script}
//-->
</script>
	
<base>
</head>
<body style="text-align:center">
<!-- 
<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
	<tr align="center">
		<td height="12" class="detail-top"><img src="<c:url value="/apps_res/bulletin/images/button.preview.gif" />" height="8" onclick="previewFrame()" class="cursor-hand"></td>
	</tr>
</table>
-->
<div id="topDiv" class="">
<div id="mainDiv">
<script type="text/javascript">
	var onlyLoginAccount_wf = true;
	var onlyLoginAccount_depart = true;
</script>
<form name="newForm" action="officeadmin.do?method=doCreate" method="post" onsubmit="" style="margin-top:0px;">
<input type="hidden" name="method" value="doCreate"/>
<v3x:selectPeople id="wf" panels="Department" selectType="Member" jsFunction="setBulPeopleFields(elements);" />
<v3x:selectPeople id="depart" panels="Department" selectType="Account,Department" jsFunction="setBulDepartmentFields(elements);" />
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
	<tr align="center">
		<td height="8" class="detail-top">
			<script type="text/javascript">
			getDetailPageBreak("<c:url value='/common/images/button.preview.up.gif'/>", "<c:url value='/common/images/button.preview.down.gif'/>");
		</script>
		</td>
	</tr>	
	<tr>
		<td class="categorySet-4" height="8"></td>
	</tr>
	<tr>
		<td class="categorySet-head" height="23">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="categorySet-1" width="4"></td>
				<td class="categorySet-title" width="80px" nowrap><fmt:message key='mt.admin.button.modify.settings'/></td>
				<td class="categorySet-2" width="7"></td>
				<td class="categorySet-head-space">&nbsp;</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td class="categorySet-head"><div class="categorySet-body">
		<table width="100%" height="100%" cellspacing="0" cellpadding="0" align="center">
		<tr><td height="10%">&nbsp;</td></tr>
			<tr><td valign="top" align="center">
	<table width="400" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td class="bg-gray" width="12%" nowrap="nowrap"><font color="red">*</font><fmt:message key='mt.admin.button.administrator'/>:&nbsp;</td>
			<td class="new-column" width="35%" nowrap="nowrap"><fmt:message key='admin.alert.checkselectperson' var='checkselectperson'/>
				<input type="hidden" name="admin" />
				&nbsp;&nbsp;<input type="text" name="admin_name" onclick="selectPeople()" 
				inputName="<fmt:message key='admin.label.manager' bundle="${v3xAdmin }"/>" deaultValue="${checkselectperson }" validate="notNull,isDeaultValue" 
				value="<c:out value="${checkselectperson }" escapeXml="true" />" readonly />
			</td>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td class="bg-gray" width="12%" nowrap="nowrap"><font color="red">*</font><fmt:message key='mt.admin.button.management.range'/>:&nbsp;</td>
			<td class="new-column" width="35%" nowrap="nowrap" colspan="3">
				<fmt:message key='admin.alert.checkselectdep' var='checkselectdep'/>
				<input type="hidden" name="accountId" /><input type="hidden" name="departmentId"/>
				&nbsp;&nbsp;<input type="text" name="mngDepId" onclick="selectDepartment()" 
				inputName="<fmt:message key='admin.label.mgedep' bundle="${v3xAdmin }"/>" deaultValue="${checkselectdep }" validate="notNull,isDeaultValue" 
				value="<c:out value="${checkselectdep }" escapeXml="true" />" readonly />
			</td>
		</tr>
		<tr>
			<td class="bg-gray" width="12%" nowrap="nowrap" valign="top" style="padding-top: 3px;">&nbsp;</td>
			<td class="new-column" width="35%" nowrap="nowrap" colspan="3">
			    <div style="height: 20px;" style="display:none;">
			    	<label for="admin_meeting">&nbsp;
			    		<input type="checkbox" checked="checked" name="adminModel" id="admin_meeting" value="${meetingRoomType}"/>
			    		<fmt:message key='admin.label.meetingroom'/>
			    	</label>
			    </div>
			</td>
		</tr>
	</table>
	</td></tr></table>
	</div></td></tr>
		<tr>
			<td height="42" align="center" class="bg-advance-bottom">
				<input type="button" class="button-default_emphasize" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" onclick="doSubmit()" />&nbsp;
				<input type="button" onclick="cancelOper()" class="button-default-2" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" />
			</td>
		</tr>
	</table>
</form>
</div>
</div>
<c:choose>
	<c:when test="${showFlag == 1 }"></c:when>
	<c:otherwise>
		<script type="text/javascript">
			document.getElementById("mainDiv").style.display="none";
		</script>
	</c:otherwise>
</c:choose>

</body>
</html> 