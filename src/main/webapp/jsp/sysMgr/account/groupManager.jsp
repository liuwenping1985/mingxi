<%@ page language="java" contentType="text/html;charset=UTF-8"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>

<%@include file="../header.jsp"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/passwdcheck.css${v3x:resSuffix()}" />">
<script type="text/javascript" src="<c:url value='/common/js/passwdcheck.js${v3x:resSuffix()}'/>"></script>
<script type="text/javascript">
<!--
showCtpLocation('F13_group');
	// 进行编辑
		var pwdNeedUpdate=${pwdNeedUpdate};
		var pwdpower=${pwdpower};
		var _ctxPath = '${path}';
	function showEdit(){
		document.getElementById("submitOk").style.display= "";		
		document.getElementById("formerpassword").disabled="";
		document.getElementById("oldpassword").disabled="";
		document.getElementById("validatepass").disabled="";
		document.getElementById("name").readOnly=false;
		document.getElementById("name").disabled="";		
	}
	// 取消编辑
	function notEdit(){
	if(parent.alterPwdWin!=null){
	parent.alterPwdWin.close();
	}
    document.getElementById("submitOk").style.display="none";
		document.getElementById("name").disabled="disabled";
		document.getElementById("formerpassword").value="";
		document.getElementById("oldpassword").value="";
		document.getElementById("validatepass").value="";
		document.getElementById("formerpassword").disabled="disabled";
		document.getElementById("oldpassword").disabled="disabled";
		document.getElementById("validatepass").disabled="disabled";
	}
	function validate(){
		var oldpasword = document.getElementById("oldpassword").value;
		var validatepassword = document.getElementById("validatepass").value;
		if (oldpasword == validatepassword){
			return true;
		} else {		
			alert("<fmt:message key='manager.vialdateword'/>");
			document.getElementById("validatepass").value = "";
			return false;
		}
	}
	function exitsystem(){
		 try
        {
          top.window.location.href =_ctxPath+"/main.do?method=logout";
        }
     catch(err)
      {
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
	function validateNameAccount(){
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
	//检测密码是否符合要求
	var pwdStrengthValidation=${pwdStrengthValidation};
	function check(){
		var pwdStrength="";
		if(pwdpower<pwdStrengthValidation){
		if(pwdStrengthValidation==1){
		pwdStrength="<fmt:message key='manager.vaildate.strength1'/>";
		}else if(pwdStrengthValidation==2){
		pwdStrength="<fmt:message key='manager.vaildate.strength2'/>";
		}else if(pwdStrengthValidation==3){
		pwdStrength="<fmt:message key='manager.vaildate.strength3'/>";
		}
			alert(pwdStrength);
		return false;
	}
	 return true;
}
$(function(){
 if(pwdpower>0){
	if(pwdpower<pwdStrengthValidation||pwdNeedUpdate==1){
		 $("#outUpdate0").hide();//隐藏
         $("#outUpdate1").show();//显示
	} else{
        $("#outUpdate1").hide();//隐藏
        $("#outUpdate0").show();//显示
	}
	}else{
		 $("#outUpdate1").hide();//隐藏
        $("#outUpdate0").show();//显示
	}
      });
//-->
</script>
</head>
<body scroll="no" class="padding5">
	<form id="postForm"  method="post" action="<html:link renderURL='/accountManager.do' />?method=modifyGroupManager" onsubmit="return (validateNameAccount() && validateOldPassword() && checkForm(this) && validate()&&check())">
		<input type="hidden" name="id" id="logerName" value="${logerName}" />
		<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="">
			<c:if test="${param.result != true }">
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
			</c:if>
			<tr >
				<td valign="top">
				<div style="padding:50px">
				<fieldset height="50%" ><legend ><fmt:message key="system.groupmanager.set${v3x:suffix()}"/></legend>
			    <div id="editmanageradmins">
			    <table width="60%" border="0" cellspacing="0" cellpadding="0"
					align="center">
					<c:set var="disabled"
						value="${param.disabled }" />
					<tr>
						<td class="bg-gray" width="20%" nowrap="nowrap"><label
							for="name"> <font color="red">*</font><fmt:message key="manager.name.notnull" />:</label>							
							</td>
						<td class="new-column" width="80%">
							<input disabled name="name"  maxLength="40" maxSize="40" class="input-100per" type="text" id="name" value="<c:out value="${logerName }" escapeXml="true"/>" inputName="<fmt:message key="manager.name.notnull" />" validate="notNull,isWord" />
						</td>
					</tr>
					<tr>
						<td class="bg-gray" width="20%" nowrap="nowrap"><label
							for="post.code">  <font color="red">*</font> <fmt:message key="manager.formerpassword.notnull" />:</label></td>
						<td class="new-column" width="80%">
							<input disabled class="input-100per" type="password" name="formerpassword" id="formerpassword" value="${systemPassword }" maxSize="50" maxlength="50" inputName="<fmt:message key="manager.formerpassword.notnull" />" />
						</td>
					</tr>
					<tr>
						<td class="bg-gray" width="20%" nowrap="nowrap"><label
							for="post.code"> <font color="red">*</font> <fmt:message key="manager.password.notnull" />:</label></td>
						<td class="new-column" width="80%">
							<input disabled class="input-100per" type="password" name="password" id="oldpassword" value="" inputName="<fmt:message key="manager.password.notnull" />" minLength="6" maxSize="50" maxLength="50"  validate="notNull,minLength,maxLength"  
							<c:if test="${pwdStrengthValidation>0 }">
							onKeyUp="EvalPwdStrength(document.forms[0],this.value);"
							</c:if> />
						</td>
					</tr>
					<c:if test="${pwdStrengthValidation>0 }">
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
						<td class="new-column" width="80%">
							<input disabled id="validatepass" class="input-100per" type="password" name="validatepass" value="" inputName="<fmt:message key="manager.validate.notnull" />" minLength="6" maxSize="50" maxLength="50"  validate="notNull" />
						</td>
					</tr>
					<tr>
								<td>&nbsp;</td><c:if test="${pwdStrengthValidation==1}">
								<td class="description-lable"><font color='red'><fmt:message key="manager.vaildate.strength1" /></font></br>
								</c:if>
								<c:if test="${pwdStrengthValidation==2}">
								<td class="description-lable"><font color='red'><fmt:message key="manager.vaildate.strength2" /></font></br>
								</c:if>
								<c:if test="${pwdStrengthValidation==3}">
								<td class="description-lable"><font color='red'><fmt:message key="manager.vaildate.strength3" /></font></br>
								</c:if>
								<fmt:message key="manager.vaildate.length1"/></br>
								<fmt:message key="manager.vaildate.length2"/></br>
								<fmt:message key="manager.vaildate.length3"/></br></td>
							</tr>
				</table>
				</div>
				</fieldset>	
				</div>
				</td>
			</tr>
				<tr id="submitOk" style="display:none">
					<td height="42" align="center" class="bg-advance-bottom" >
						<input type="submit" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
					<input type="button" id="outUpdate0" onclick="notEdit();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
					<input type="button" id="outUpdate1" onclick="exitsystem();" value="<fmt:message key='seeyon.top.close.alt' bundle="${v3xCommonI18N}" />" class="button-default-2">
					</td>
				</tr>
		</table>
</form>
<div class="hidden">
<iframe id="temp_iframe" name="temp_iframe">&nbsp;</iframe>
</div>
</body>
<script>
	<c:if test="${param.result == true }">
		showEdit();
	</c:if>
</script>
</html>