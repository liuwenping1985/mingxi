<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
	<title>edit</title>
	<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
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
function cancelOper(){
  //alert("good");
  var frmObj = document.forms[0];
  
      frmObj.reset();
        window.parent.listFrame.location.reload();
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
		alert("<fmt:message key='admin.alert.selectmodel'/>");
		return false;
	}
	if(checkForm(form)){
		newForm.submit();
	}else{
		return false;
	}
}

${script}

window.onload = function() {
	bindOnresize("categorySetBody", 30, 52);
}

//-->
</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
</head>
<body style="text-align:center">

<form name="newForm" class="h100b" action="${mtAdminController}?method=doModify" method="post" onsubmit="" style="margin-top:0px;">
<input type="hidden" name="actionType" value="doModify"/><%--xiangfan 添加，起到标示的作用 --%>
<input type="hidden" name="id" value="${bean.admin},${bean.admin_model }"/>

<script type="text/javascript">
	var onlyLoginAccount_wf = true;
</script>
<c:set value="${bean.depIdArr }" var='depIdArr'/>
<c:set value="${v3x:parseElementsOfTypeAndId(OrgIdStr)}" var="defaultdep"/>
<c:set value="${bean.admin}" var="adminIds"/>
<c:set value="${v3x:parseElementsOfIds(adminIds,'Member')}" var="defaultmember"/>
<v3x:selectPeople id="wf" panels="Department" maxSize="1" minSize="1" selectType="Member" jsFunction="setBulPeopleFields(elements);" originalElements="${defaultmember }"/>
<v3x:selectPeople id="depart" panels="Department" selectType="Account,Department" jsFunction="setBulDepartmentFields(elements);" originalElements="${defaultdep }" />
<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center" class="categorySet-bg">
	<tr align="center">
		<td height="8" class="detail-top">
			<script type="text/javascript">
				getDetailPageBreak("<c:url value='/common/images/button.preview.up.gif'/>", "<c:url value='/common/images/button.preview.down.gif'/>");
			</script>
		</td>
	</tr>
	<tr>
		<td class="categorySet-4" height="11"></td>
	</tr>
	<!-- <tr>
		<td class="categorySet-head" height="19">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="categorySet-1" width="4"></td>
				<td class="categorySet-title" width="85" nowrap="nowrap"><fmt:message key='mt.admin.manager.button.modify.settings'/></td>
				<td class="categorySet-2" width="4"></td>
				<td class="categorySet-head-space">&nbsp;</td>
			</tr>
		</table>
		</td>
	</tr> -->

	<tr>
		<td id="categorySetId" class="categorySet-head" style="padding: 0px 0px 0px 0px;border:0px 0px 0px 0px;overflow-y:hidden;">
			<div id="categorySetBody" class="categorySet-body border-top border-right">
				<table width="400" border="0" cellspacing="0" cellpadding="0" align="center" class="margin_t_5">
					<tr>
						<td width="12%" nowrap="nowrap" class="bg-gray"><font color="red">*</font><fmt:message key='mt.admin.button.administrator'/>:&nbsp;</td>
						<td width="35%" nowrap="nowrap" class="new-column">
							<input type="text" id="admin_name" name="admin_name" onclick="selectPeople()" 
							inputName="<fmt:message key='admin.label.manager'/>" validate="notNull" 
							value="<c:out value='${bean.adminName }' escapeXml="true" />" readonly />
							<input type="hidden" id="admin" name="admin" value="${bean.admin }" />
						</td>
						<td colspan="2"></td>
					</tr>
					<tr>
						<td width="12%" nowrap="nowrap" class="bg-gray"><font color="red">*</font><fmt:message key='mt.admin.button.management.range'/>:</td>
						<td width="35%" nowrap="nowrap" class="new-column" colspan="3">
							<%-- <input type="text" id="mngDepId" name="mngDepId" onclick="selectDepartment()" 
							inputName="<fmt:message key='admin.label.manager'/>" validate="notNull" 
							value="<c:out value='${bean.depStr }' escapeXml="true" />" readonly /> --%>
							<input type="hidden" id="accountId" name="accountId" value="${bean.accountIds }"/><input type="hidden" id="departmentId" name="departmentId" value="${bean.depIdArr }"/>
                            <textarea id="mngDepId" name="mngDepId" onclick="selectDepartment()" inputName="<fmt:message key='admin.label.manager'/>" validate="notNull"  rows="6" cols="40" readonly ><c:out value='${bean.depStr }' escapeXml="true" /></textarea>
						</td>
					</tr>
					<tr  style="display:none;">
						<td width="12%" nowrap="nowrap" class="bg-gray" valign="top" style="padding-top: 3px;">&nbsp;</td>
						<td width="35%" nowrap="nowrap" class="new-column" colspan="3" >
						    <input type="checkbox" checked="checked" name="adminModel"  id="admin_meeting" value="5"/>
						</td>
					</tr>
				</table>
			</div>
     	</td>
	</tr>
</table>
<div align="center" class="bg-advance-bottom border-top" style="height:42px;width:100%;position:absolute;left:0;bottom:22px;line-height:42px;background:#F3F3F3;">
		<input type="button" class="button-default_emphasize margin_t_10" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" onclick="doSubmit()" />&nbsp;
		<input type="button" onclick="cancelOper()" class="button-default-2 margin_t_10" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" />
</div>
</form>
</body>
</html>