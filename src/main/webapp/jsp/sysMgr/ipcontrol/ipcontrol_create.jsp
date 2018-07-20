<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<style type="text/css">
.fld{
    float:left;
    width:25px;
}
.fld input{
    border:none;
    width:25px;
}
.fldDot{
    float:left;
    width:5px;
}
.common_button_emphasize{
	color:#fff;
	border:1px solid #42b3e5;
	background:#42b3e5;
}
.common_button_emphasize:hover{
	color:#fff;
	border:1px solid #42b3e5;
	background:#62c4ef;
}
</style>
<script>
<!--
var accountId_auth="${param.accountId}";
showAllOuterDepartment_auth = true;

function doSecurity(elements){
	document.getElementById("authName").value =  getNamesString(elements);
	document.getElementById("selectPeopleStr").value =  getIdsString(elements);
}

function switchDisplay(selectObj){
	var obj0 = document.getElementById('tr0');
	var obj1 = document.getElementById('tr1');
	var obj2 = document.getElementById('tr2');
	var selectPeopleDom = document.getElementById('selectPeopleStr');
	var readonly = '${readonly}';
	if(0 == selectObj.selectedIndex){
		obj0.style.display = "";
		obj1.style.display = "";
		obj2.style.display = "";
		selectPeopleDom.setAttribute("validate","notNull");
	}else if(1 == selectObj.selectedIndex){
		obj0.style.display = "";
		obj1.style.display = "none";
		obj2.style.display = "none";
		selectPeopleDom.setAttribute("validate","notNull");
	}else{
		obj0.style.display = "none";
		obj1.style.display = "";
		obj2.style.display = "";
		selectPeopleDom.setAttribute("validate","");
	}
	if(readonly != ""){
		obj2.style.display = "none";
		document.getElementById('delete').style.display = "none";
	}
}
function myCheckForm(form){
	if(!checkForm(form)){
		return false;
	}
	var ipsStr = "";
	var selectObj = document.getElementById('select');
	var type = document.getElementById('type');
	if(0 == type.selectedIndex || 2 ==type.selectedIndex){
		if(selectObj.options.length == 0){
			alert(v3x.getMessage("sysMgrLang.checkForm_ip_must"));
			return false;
		}
	}
	for(var i=0; i<selectObj.options.length; i++){
		 ipsStr += selectObj.options[i].value;
	     if(i!=selectObj.options.length-1){
	    	 ipsStr += ";";
	    }
	 }
	document.getElementById('ips').value = ipsStr;
	return true;
}
//-->
</script>
</head>
<body onload="switchDisplay(document.getElementById('type'))">
<c:set value="${v3x:parseElementsOfTypeAndId(ipcontrol.users)}" var="selectPeopleStr" />
<c:set value="${v3x:showOrgEntitiesOfTypeAndId(ipcontrol.users,pageContext) }" var="authStr" />
<c:if test="${v3x:currentUser().groupAdmin}">
<c:if test="${root == 'true'}">
<script type="text/javascript">
	var onlyLoginAccount_auth = false;
</script>
<v3x:selectPeople id="auth" showAllAccount="true" panels="Account,Department,Team" selectType="Account,Department,Team,Member" jsFunction="doSecurity(elements)" originalElements="${selectPeopleStr}" />
</c:if>
<c:if test="${root == 'false'}">
<script type="text/javascript">
	var onlyLoginAccount_auth = true;
	hiddenRootAccount_auth = true;
</script>
<v3x:selectPeople id="auth" showAllAccount="true" panels="Department,Team" selectType="Account,Department,Team,Member" jsFunction="doSecurity(elements)" originalElements="${selectPeopleStr}" />
</c:if>
</c:if>

<c:if test="${v3x:currentUser().administrator}">
<script type="text/javascript">
	var onlyLoginAccount_auth = true;
	hiddenRootAccount_auth = true;
</script>
<v3x:selectPeople id="auth" panels="Department,Team,Outworker" selectType="Account,Department,Team,Member" jsFunction="doSecurity(elements)" originalElements="${selectPeopleStr}" />
</c:if>
<form method="post" action="<c:url value="/ipcontrol.do?method=save" />" onsubmit="return myCheckForm(this);">
<input type="hidden" id="accountId" name="accountId" value="${param.accountId }">
<input type="hidden" id="ips" name="ips" value="${ips }">
<input type="hidden" id="id" name="id" value="${ipcontrol.id }">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="98%" align="center" class="categorySet-bg" id="createTable">
	<tr>
		<td class="categorySet-4">
			<script type="text/javascript">
				getDetailPageBreak();
			</script>
		</td>
	</tr>
	<tr>
		<td class="categorySet-head" height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<td class="categorySet-title" width="120" nowrap="nowrap">
					<c:choose>
						<c:when test="${ipcontrol == null}">
							<fmt:message key="system.ipcontrol.new"/>
						</c:when>
						<c:when test="${ipcontrol != null && readonly != null}">
							<fmt:message key="system.ipcontrol.view"/>
						</c:when>
						<c:when test="${ipcontrol != null && readonly == null}">
							<fmt:message key="system.ipcontrol.edit"/>
						</c:when>
					</c:choose>
					</td>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="categorySet-head" align="center" height="100%" valign="top">
			<div id="scrollListDiv" style="height:180px;width:99%;">
			<%-- 访问控制设置 --%>
			<fieldset style="width: 500px;">
				<legend><fmt:message key="system.ipcontrol.setting" /></legend>
				<table width="400" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td class="bg-gray" nowrap><fmt:message key="common.type.label" bundle="${v3xCommonI18N}"/>:</td>
						<td class="new-column" nowrap colspan="2">
							<select name="type" id="type" class="input-300px" onchange="switchDisplay(this)" ${v3x:outConditionExpression(readonly == null, '', 'disabled')}>
								<option value="0" ${ipcontrol.type==0? 'selected':''}><fmt:message key="system.ipcontrol.limit" /></option>
								<option value="1" ${ipcontrol.type==1? 'selected':''}><fmt:message key="system.ipcontrol.nolimit" /></option>
								<option value="2" ${ipcontrol.type==2? 'selected':''}><fmt:message key="system.ipcontrol.black" /></option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="bg-gray" width="30%" nowrap><font color="red">*</font><fmt:message key="common.name.label" bundle="${v3xCommonI18N}"/>:</td>					
						<td class="new-column" width="70%" colspan="2">
							<fmt:message key="common.default.name.value" var="defName" bundle="${v3xCommonI18N}" />
					        <input name="name" type="text" id="name" class="input-300px" deaultValue="${defName}"
					               inputName="<fmt:message key="common.name.label" bundle="${v3xCommonI18N}"/>" validate="maxLength,isDeaultValue,notNull"
					               value="<c:out value="${ipcontrol.name}" escapeXml="true" default='${defName}' />"
					               ${v3x:outConditionExpression(readonly == null, '', 'disabled')}
					               onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)" maxLength="60" maxSize="60">
					    </td>
					</tr>
					
					<fmt:message key="common.default.selectPeople.value" var="defaultSP" bundle="${v3xCommonI18N}"/>
					<fmt:message key="sysMgr.lockedUser.ip.target" var="auth" bundle='${v3xCommonI18N}'/>					
					<tr id="tr0">
						<td class="bg-gray" nowrap><fmt:message key="sysMgr.lockedUser.ip.target" bundle='${v3xCommonI18N}'/>:</td>
						<td class="new-column" nowrap colspan="2">
							<input name='authName' id="authName"
							value="<c:out value='${authStr}' default='${defaultSP}' escapeXml='true' />" 
							readonly class="cursor-hand input-300px" onclick="selectPeopleFun_auth()" title="${authStr}"
							deaultValue="${defaultSP}" ${v3x:outConditionExpression(readonly == null, '', 'disabled')}
							onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)">
							<input type="hidden" value="${ipcontrol.users}" name="selectPeopleStr" id="selectPeopleStr" inputName="${auth}"  validate="notNull">
						</td>
					</tr>
					<tr id="tr1">
					<td class="bg-gray" nowrap><fmt:message key="sysMgr.lockedUser.ip.range" bundle='${v3xCommonI18N}'/>:</td>
					<td class="new-column" nowrap style="padding-top:12px;">
						<SELECT name="IPSelect" size="8" id="select" style="width:124px;" ondblclick="removeIPOption()" ${v3x:outConditionExpression(readonly == null, '', 'disabled')}>
							<c:forTokens items="${ipcontrol.address}" delims=";" var="ip">
								<OPTION value="${ip}">${ip}</OPTION>
							</c:forTokens>
						</SELECT>
					</td>
					<td align="left"><input id="delete" type="button" name="delete" value="<fmt:message key='common.button.delete.label' bundle='${v3xCommonI18N}'/>" class="button-default-2" onclick="removeIPOption()"></td>
					</tr>
					<tr id="tr2">
					<td class="bg-gray" nowrap style="padding-top:12px;">
					<fmt:message key='sysMgr.lockedUser.ip.label' bundle='${v3xCommonI18N}'/>:</td>
					<td style="padding-left:5px;">
						<div style="border-top-style: solid; border-top-width: 1px; width:124px; float:left; border-left-style: solid; border-left-width: 1px; border-right-style: solid; border-right-width: 1px; border-bottom-style: solid; border-bottom-width: 1px;" id="ipAddress"></div>
							<script type="text/javascript">
								var ipAddress = new CIP("ipAddress", "ipAddress");
								ipAddress.create();
							</script>
					</td>
					<td align="left" style="padding-top:12px;"><input type="button" name="add" value="<fmt:message key='common.button.add.label' bundle='${v3xCommonI18N}'/>" class="button-default-2" onclick="addIPOption(ipAddress.getIPValue())"></td>
					</tr>
					<%--
					<tr id="tr3"> 
					<td class="bg-gray" style="padding-top:12px;">
					<input type="checkbox" name="ismobile" id="ismobile" ${ipcontrol.isMobile==0?'checked':''} ${v3x:outConditionExpression(readonly == null, '', 'disabled')}>
					</td>
					<td style="padding-top:12px;"><label for="ismobile"><fmt:message key="system.ipcontrol.mobile" /></label></td>
					<td></td>
					</tr>
					 --%>
					<tr>
						<td colspan="3" class="new-column description-lable" style="padding-top: 12px;">
							<fmt:message key="system.ipcontrol.description" />
						</td>
					</tr>
				</table>
			</fieldset>
			</div>		
		</td>
	</tr>
	<c:if test="${empty readonly}">
	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
			<input type="submit" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2 common_button_emphasize" ${isDisableStr}>&nbsp;
			<input type="button" onclick="parent.location.reload()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
	
	<tr>
		<td height="20" align="center" ></td>
	</tr>
	</c:if>
</table>
</form>
<script type="text/javascript">
bindOnresize('scrollListDiv',30,100);
</script>
</body>
</html>