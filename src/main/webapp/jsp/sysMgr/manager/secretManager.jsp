<%@ page language="java" contentType="text/html;charset=UTF-8"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>管理员维护</title>

<%@include file="../header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/passwdcheck.css${v3x:resSuffix()}" />">
<script type="text/javascript" src="<c:url value='/common/js/passwdcheck.js${v3x:resSuffix()}'/>"></script>
<script type="text/javascript"><!--
	//  renw@2012-11-9 getA8Top().showLocation(${param.from=='audit'?'6201':'2301'});
showCtpLocation('F15_secret');
	// 进行编辑
	function showEdit(){
		document.getElementById("submitOk").style.display= "";
		document.getElementById("formerpassword").disabled="";
		document.getElementById("oldpassword").disabled="";
		document.getElementById("validatepass").disabled="";
	}
	// 取消编辑
	function notEdit(){
		document.getElementById("submitOk").style.display="none";
		document.getElementById("name").disabled="disabled";
		document.getElementById("formerpassword").disabled="disabled";
		document.getElementById("formerpassword").value="";
		document.getElementById("oldpassword").disabled="disabled";
		document.getElementById("oldpassword").value="";
		document.getElementById("validatepass").disabled="disabled";
		document.getElementById("validatepass").value="";
	}
	function validate(){
		var oldpasword = document.getElementById("oldpassword").value;
		var validatepassword = document.getElementById("validatepass").value;
		if (oldpasword == validatepassword){
			return true;
		} else {
			alert("<fmt:message key='manager.vialdateword'/>");
			document.getElementById("oldpassword").value = "";
			document.getElementById("validatepass").value = "";
			//return false;
		}
	}
	// 验证原密码
	function validateOldPassword(){
		var oldPassword = document.getElementById("formerpassword").value;
		var systemName    = document.getElementById("logerName").value;
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxOrgManager", "isOldPasswordCorrect", false);
		requestCaller.addParameter(1, "String", systemName);
		requestCaller.addParameter(2, "String", oldPassword);
		var ds = requestCaller.serviceRequest();
		if(ds=="true"){
			return true;
		}else{
			alert("<fmt:message key='manager.oldword'/>");
			return false;
		}
	}
	// 验证重名字方法
	function validateName(){
		var systemName = document.getElementById("name").value;
		var oldName = document.getElementById("logerName").value;
		if (systemName != oldName){
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxOrgManager", "isExistLoginName", false);
			requestCaller.addParameter(1, "String", systemName);
			var team = requestCaller.serviceRequest();
			if (team=="true") {
				alert(v3x.getMessage("sysMgrLang.system_manager_name_exit"));
				return false ;
			} else {
				return true;
			}
		}else{
			return true;
		}
	}
	// 合并方法
	function unit(flag){
		if (validateName() && validateOldPassword() && checkForm(flag) && validate()){
			return true;
		}   return false;
	}

</script>


</head>
<body scroll="no" style="overflow: no">
	<form id="postForm" method="post" action="<html:link renderURL='/secret/secretSetController.do' />?method=modifyManager" onsubmit="return(unit(this))">
		<input type="hidden" id="logerName" name="logerName" value="${logerName}" />
		<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="">
			<tr>
				<td height="12" colspan="2" class="border_b">
					<script type="text/javascript">
						var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
						myBar.add(new WebFXMenuButton("mod","<fmt:message key="common.toolbar.update.label" bundle='${v3xCommonI18N}'/>","showEdit()",[1,2],"", null));
						document.write(myBar);
				    	document.close();
			    	</script>
			    </td>
			</tr>
			<tr >
				<td>
				<div style="width:80%;padding:40px;">
					<fieldset height="100%" style="padding:12px"><legend><fmt:message key="manager.countersign.setup"/></legend>
						<table width="60%" border="0" cellspacing="0" cellpadding="0"
							align="center">
							<c:set var="disabled"
								value="${param.disabled }" />
							<tr>
								<td class="bg-gray" width="20%" nowrap="nowrap">
									<label for="name"> <font color="red">*</font><fmt:message key="manager.name.notnull" />:</label></td>
								<td class="new-column" width="80%">
									<input disabled id="name" name="name" maxLength="40" maxSize="40" class="input-100per" type="text" value="<c:out value="${logerName }" escapeXml="true"/>" inputName="<fmt:message key="manager.name.notnull" />" validate="notNull,isCriterionWord" />
								</td>
							</tr>
							<tr>
								<td class="bg-gray" width="20%" nowrap="nowrap"><label
									for="post.code"> <font color="red">*</font>  <fmt:message key="manager.formerpassword.notnull" />:</label></td>
								<td class="new-column" width="80%"><input disabled class="input-100per"
									type="password" name="formerpassword" id="formerpassword"
									value="${systemPassword }" maxSize="50" maxlength="50" inputName="<fmt:message key="manager.formerpassword.notnull" />" validate="notNull" /></td>
							</tr>
							<tr>
								<td class="bg-gray" width="20%" nowrap="nowrap"><label
									for="post.code"> <font color="red">*</font> <fmt:message key="manager.password.notnull" />:</label></td>
								<td class="new-column" width="80%"><input disabled class="input-100per"
									type="password" name="password" id="oldpassword"
									value="" inputName="<fmt:message key="manager.password.notnull" />" minLength="6" maxSize="50" maxLength="50" validate="notNull,minLength,maxLength"
									<c:if test="${pwdStrengthValidation==1 }">
									 onKeyUp="EvalPwdStrength(document.forms[0],this.value);"
									 </c:if> />
								</td>
							</tr>
							<c:if test="${pwdStrengthValidation==1 }">
							<tr>
							<td class="bg-gray" width="20%" nowrap="nowrap"><label
									for="post.code"><fmt:message key="common.pwd.pwdStrength.label" bundle="${v3xCommonI18N }"/>:</label></td>
							<td class="new-column" width="80%">
							<table cellpadding="0" cellspacing="0" class="pwdChkTbl2">
								<tr>
									<td id="idSM1" width="25%" class="pwdChkCon0" align="center"><span
										style="font-size:1px">&nbsp;</span><span id="idSMT1"
										style="display:none;"><fmt:message key="common.pwd.pwdStrength.value1" bundle="${v3xCommonI18N }"/></span></td>
									<td id="idSM2" width="25%" class="pwdChkCon0" align="center"
										style="border-left:solid 1px #fff"><span style="font-size:1px">&nbsp;</span>
										<span id="idSMT0" style="display:inline;font-weight:normal;color:#666"><fmt:message key="common.pwd.pwdStrength.value0" bundle="${v3xCommonI18N }"/></span>
										<span id="idSMT2" style="display:none;"><fmt:message key="common.pwd.pwdStrength.value2" bundle="${v3xCommonI18N }"/></span></td>
									<td id="idSM3" width="25%" class="pwdChkCon0" align="center"
										style="border-left:solid 1px #fff"><span style="font-size:1px">&nbsp;</span><span
										id="idSMT3" style="display:none;"><fmt:message key="common.pwd.pwdStrength.value3" bundle="${v3xCommonI18N }"/></span></td>
									<td id="idSM4" width="25%" class="pwdChkCon0" align="center"
										style="border-left:solid 1px #fff"><span style="font-size:1px">&nbsp;</span><span
										id="idSMT4" style="display:none;"><fmt:message key="common.pwd.pwdStrength.value4" bundle="${v3xCommonI18N }"/></span></td>
								</tr>
							</table>
							</td>
						</tr>
						</c:if>
							<tr>
								<td class="bg-gray" width="20%" nowrap="nowrap"><label
									for="post.code"> <font color="red">*</font><fmt:message key="manager.validate.notnull" />:</label></td>
								<td class="new-column" width="80%"><input disabled id="validatepass"
									class="input-100per" type="password" name="validatepass" value="" minLength="6" maxSize="50" maxLength="50" inputName="<fmt:message key="manager.validate.notnull" />"
									validate="notNull" /></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td class="description-lable"><fmt:message key="manager.vaildate.length"/></td>
							</tr>

						</table>
					</fieldset>
				</div>
				</td>
			</tr>
			<tr>
				<td height="100%"></td>
			</tr>
				<tr id="submitOk" style="display:none">
					<td height="42" align="center" class="bg-advance-bottom" >
					    <input type="hidden" value="<c:out value="${adminName == 'null'? '' : adminName}" escapeXml="true"/>" id="oldsystem.name">
					    <input type="hidden" value="<c:out value="${adminPhone == 'null'? '': adminPhone}" escapeXml="true"/>" id="oldsystem.phone">
					    <input type="hidden" value="<c:out value="${adminEmail == 'null'? '': adminEmail}" escapeXml="true"/>" id="oldsystem.email">
						<input type="submit" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
						<input type="button" onclick="notEdit();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
					</td>
				</tr>
		</table>
</form>
</body>
<script>
	<c:if test="${param.result == true }">
		showEdit();
	</c:if>
</script>
</html>
