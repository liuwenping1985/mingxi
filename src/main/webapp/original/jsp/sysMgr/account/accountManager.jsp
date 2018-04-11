<%@ page language="java" contentType="text/html;charset=UTF-8"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>管理员维护</title>

<%@include file="../header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/passwdcheck.css${v3x:resSuffix()}" />">
<script type="text/javascript" src="<c:url value='/common/js/passwdcheck.js${v3x:resSuffix()}'/>"></script>
<script type="text/javascript">
//showCtpLocation('F13_account');

var weakrule="<fmt:message key='manager.pwdStrength.weakrule'/>";
var mediumrule="<fmt:message key='manager.pwdStrength.mediumrule'/>";
var strongrule="<fmt:message key='manager.pwdStrength.strongrule'/>";
var bestrule="<fmt:message key='manager.pwdStrength.bestrule'/>";

var mediumMsg="<fmt:message key='manager.pwdStrength.medium'/>"+"\r\n"+mediumrule;
var strongMsg="<fmt:message key='manager.pwdStrength.strong'/>"+"\r\n"+strongrule;
var bestMsg="<fmt:message key='manager.pwdStrength.best'/>"+"\r\n"+bestrule;
var notequalMsg="<fmt:message key='manager.pwdModify.notequal'/>";
	// 进行编辑
	function showEdit(){
		document.getElementById("submitOk").style.display= "";
		document.getElementById("name").disabled="";
		document.getElementById("formerpassword").disabled="";
		document.getElementById("nowpassword").disabled="";
		document.getElementById("validatepass").disabled="";
		
		var forcemodify = '${param.forcemodify}';
		if (forcemodify == "true" || forcemodify == true) {
			document.getElementById("submitOk").style.display="none";
			var submitbutton=document.getElementById("submitbutton");
			submitbutton.disabled=true;
			
			var canclebutton=document.getElementById("canclebutton");
			canclebutton.disabled=true;
			
			$(document).bind("keydown", function (event)  {
				if (event.keyCode == 116 || event.keyCode == 9) {
					return false;
				}
			});
		}
		
	}
	// 取消编辑
	function notEdit(){
		getA8Top().pwdModify.close();
	}
	function validate(){
		var oldpasword = document.getElementById("nowpassword").value;
		var validatepassword = document.getElementById("validatepass").value;
		if (oldpasword == validatepassword){
			return true;
		} else {		
			alert("<fmt:message key='manager.vialdateword'/>");
			document.getElementById("validatepass").value = "";
			return false;
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
	
	function canSamePWD(){
		var cansame = document.getElementById("pwdmodify_same_enable").value;
		if(cansame){
			if(cansame ==="enable"){
				return true;
			}
		}
		return false;
	}
		
	function OK() {
		var _form = document.getElementById("postForm");
		if(validateNameAccount() && validateOldPassword()  && checkForm(_form) && validate() 
				&& (canSamePWD() || validatePwdEqual(document.getElementById("formerpassword").value,document.getElementById("nowpassword").value)) 
				&& validatePwdStrong('${pwd_strong_require}',document.getElementById('nowpassword').value)) {
			if(_form.submit()){
				return "true";
			}
		}
	}
	
</script>
<style>
.webfx-menu-bar{ background: none;}
</style>
</head>
<body scroll="no" style="overflow: auto">
	<form id="postForm" target="temp_iframe" method="post" action="<html:link renderURL='/accountManager.do' />?method=modifyManager" 
	onsubmit="return (validateNameAccount() && validateOldPassword() && checkForm(this) && validate() && (canSamePWD() || validatePwdEqual(document.getElementById('formerpassword').value,document.getElementById('nowpassword').value))  && validatePwdStrong('${pwd_strong_require}',document.getElementById('nowpassword').value))">
		<input type="hidden" name="id" id="logerName" value="${logerName}" />
		<input id=pwdmodify_same_enable type="hidden" name="pwdmodify_same_enable" value="${pwdmodify_same_enable}" />
		<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" class="" align="center">
			<%--<c:if test="${param.forcemodify != true }">
			<tr>
				<td height="40" bgcolor="#f0f0f0" colspan="2" class="border_b">
					<script type="text/javascript">
						var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","");
						// Add By Lif Start
						myBar.add(new WebFXMenuButton("mod","<fmt:message key="common.toolbar.update.label" bundle='${v3xCommonI18N}'/>","showEdit()",[1,2],"", null));
						// Add End
						document.write(myBar);
				    	document.close();
			    	</script>
			    </td>
			</tr>
			</c:if>--%>
			<tr >
				<td>
				<div style="padding:20px 20px 0px 20px">
				<fieldset height="100%"><legend ><fmt:message key="system.manager.set"/></legend>
				<table width="300" border="0" cellspacing="0" cellpadding="0"
					align="center">
					<c:set var="disabled"
						value="${param.disabled }" />
						<tr height="40">
								<td class="bg-gray" width="20%" nowrap="nowrap"><label
									for="name"> <font color="red">*</font><fmt:message key="manager.name.notnull" />:</label></td>
								<td class="new-column" width="80%">
									<input disabled name="name" maxLength="40" maxSize="40" class="input-100per" style="width:325px;height:28px;border: 1px solid #e4e4e4;" onfocus="this.style.borderColor = '#68BAFF'" onblur="this.style.borderColor = '#e4e4e4'" type="text" id="name" value="<c:out value="${logerName }" escapeXml="true" />" inputName="<fmt:message key="manager.name.notnull" />" validate="notNull,isCriterionWord" />
								</td>
						</tr>
					<tr height="40">
								<td class="bg-gray" width="20%" nowrap="nowrap"><label
									for="post.code">  <font color="red">*</font><fmt:message key="manager.formerpassword.notnull" /></label></td>
								<td class="new-column" width="80%">
									<input disabled class="input-100per" style="width:325px;height:28px;border: 1px solid #e4e4e4;" onfocus="this.style.borderColor = '#68BAFF'" onblur="this.style.borderColor = '#e4e4e4'" type="password" name="formerpassword" id="formerpassword" value="${systemPassword }" maxlength="50" inputName="<fmt:message key="manager.formerpassword.notnull" />" validate="notNull" />
								</td>
							</tr>
							<tr height="40">
								<td class="bg-gray" width="20%" nowrap="nowrap"><label
									for="post.code"> <font color="red">*</font> <fmt:message key="manager.password.notnull" /></label></td>
								<td class="new-column" width="80%">
									<input disabled class="input-100per" style="width:325px;height:28px;border: 1px solid #e4e4e4;" onfocus="this.style.borderColor = '#68BAFF'" onblur="this.style.borderColor = '#e4e4e4'" type="password" name="password" id="nowpassword" value="" inputName="<fmt:message key="manager.password.notnull" />" minLength="6" maxLength="50" validate="notNull,minLength,maxLength"
									onKeyUp="EvalPwdStrength(document.forms[0],this.value);"/>
								</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td>
									<div style="padding-left:5px;">
										<span style="color:green;font-family:'Microsoft YaHei',SimSun, Arial,Helvetica,sans-serif;font-size:12px;">
										<fmt:message key='common.pwd.pwdStrength.require'/>:
										</span>
										<!-- 弱密碼強度提示 -->
										<c:if test="${pwd_strong_require=='weak'}">
											<span style="color:#f90001;font-family:'Microsoft YaHei',SimSun, Arial,Helvetica,sans-serif;font-size:12px;">
											<fmt:message key='common.pwd.pwdStrength.value1'/>
											</span>
											</br>
											<span style="color:green;font-family:'Microsoft YaHei',SimSun, Arial,Helvetica,sans-serif;font-size:12px;">
											<fmt:message key='common.pwd.pwdStrength.weakrule'/>
											</span>
										</c:if>
										<!-- 中密碼強度提示 -->
										<c:if test="${pwd_strong_require=='medium'}">
											<span style="color:#f90001;font-family:'Microsoft YaHei',SimSun, Arial,Helvetica,sans-serif;font-size:12px;">
											<fmt:message key='common.pwd.pwdStrength.value2'/>
											</span>
											</br>
											<span style="color:green;font-family:'Microsoft YaHei',SimSun, Arial,Helvetica,sans-serif;font-size:12px;">
											<fmt:message key='common.pwd.pwdStrength.mediumrule'/>
											</span>
										</c:if>
										<!-- 強密碼強度提示 -->
										<c:if test="${pwd_strong_require=='strong'}">
											<span style="color:#f90001;font-family:'Microsoft YaHei',SimSun, Arial,Helvetica,sans-serif;font-size:12px;">
											<fmt:message key='common.pwd.pwdStrength.value3'/>
											</span>
											</br>
											<span style="color:green;font-family:'Microsoft YaHei',SimSun, Arial,Helvetica,sans-serif;font-size:12px;">
											<fmt:message key='common.pwd.pwdStrength.strongrule'/>
											</span>
										</c:if>
										<!-- 最好密碼強度提示 -->
										<c:if test="${pwd_strong_require=='best'}">
											<span style="color:#f90001;font-family:'Microsoft YaHei',SimSun, Arial,Helvetica,sans-serif;font-size:12px;">
											<fmt:message key='common.pwd.pwdStrength.value4'/>
											</span>
											</br>
											<span style="color:green;font-family:'Microsoft YaHei',SimSun, Arial,Helvetica,sans-serif;font-size:12px;">
											<fmt:message key='common.pwd.pwdStrength.bestrule'/>
											</span>
										</c:if>
									</div>
								</td>
							</tr>
							<tr height="40">
							<td class="bg-gray" width="20%" nowrap="nowrap"><label
									for="post.code"><fmt:message key="common.pwd.pwdStrength.label" bundle="${v3xCommonI18N }"/></label></td>
							<td class="new-column" width="80%">
							<%--<table cellpadding="0" cellspacing="0" class="pwdChkTbl2">--%>
								<%--<td>--%>
									<div style="width:100%;margin-top:4px;">
										 <div id="idSM1" style="position:relative;width:77px;height:7px;float:left;" class="pwdChkCon0" align="center">
											 <div id="idSMD1" style="position:absolute;width:28px;height:28px;background-color:#fc5d5c;border-radius:100%;top:-10px;left:24px;line-height:28px;color:white;display:none;">
							 					<span id="idSMT1" style="display:none;"><fmt:message key="common.pwd.pwdStrength.value1" bundle="${v3xCommonI18N }"/></span>
							 				</div>
							 			</div>
										 <div id="idSM2" class="pwdChkCon0" align="center" style="position:relative;width:77px;height:7px;float:left;margin-left:5px;">
							 				<div id="idSMD2" style="position:absolute;width:28px;height:28px;background-color:#fcb04b;border-radius:100%;top:-10px;left:24px;line-height:28px;color:white;display:none;">
											 	<span id="idSMT2" style="display:none;"><fmt:message key="common.pwd.pwdStrength.value2" bundle="${v3xCommonI18N }"/></span>
							 				</div>
							 			</div>
										 <div id="idSM3" class="pwdChkCon0" align="center" style="position:relative;width:77px;height:7px;float:left;margin-left:5px;">
											 <div id="idSMD3" style="position:absolute;width:28px;height:28px;background-color:#70b442;border-radius:100%;top:-10px;left:24px;line-height:28px;color:white;display:none;">
												 <span id="idSMT3" style="display:none;"><fmt:message key="common.pwd.pwdStrength.value3" bundle="${v3xCommonI18N }"/></span>
							 				</div>
							 			</div>
										 <div id="idSM4" class="pwdChkCon0" align="center" style="position:relative;width:77px;height:7px;float:left;margin-left:5px;">
											 <div id="idSMD4" style="position:absolute;width:28px;height:28px;background-color:#378404;border-radius:100%;top:-10px;left:24px;line-height:28px;color:white;display:none;">
											 	<span id="idSMT4" style="display:none;"><fmt:message key="common.pwd.pwdStrength.value4" bundle="${v3xCommonI18N }"/></span>
											 </div>
										 </div>
										 <%--<td id="idSM4" width="25%" class="pwdChkCon0" align="center"--%>
										 <%--style="border-left:solid 1px #fff"><span style="font-size:1px">&nbsp;</span><span--%>
										 <%--id="idSMT4" style="display:none;"><fmt:message key="common.pwd.pwdStrength.value4" bundle="${v3xCommonI18N }"/></span></td>--%>
										 <div style="clear:both;"></div>
							 		</div>
							 <%--</td>--%>
							<%--</table>--%>
							</td>
						</tr>
							<tr>
								<td class="bg-gray" width="20%" nowrap="nowrap"><label
									for="post.code"> <font color="red">*</font><fmt:message key="manager.validate.notnull" /></label></td>
								<td class="new-column" width="80%">
									<input disabled id="validatepass" class="input-100per" style="width:325px;height:28px;border: 1px solid #e4e4e4;" onfocus="this.style.borderColor = '#68BAFF'" onblur="this.style.borderColor = '#e4e4e4'" type="password" name="validatepass" value="" inputName="<fmt:message key="manager.validate.notnull" />"  minLength="6" maxLength="50" validate="notNull" />
								</td>
							</tr>
							<tr height="35">
								<td>&nbsp;</td>
								<td class="description-lable">
									<div style="padding-left:5px;">
										<fmt:message key="manager.vaildate.length1"/>
									</div>
								</td>
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
						<input type="submit" id="submitbutton" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
						<input type="button" id="canclebutton"  onclick="notEdit();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
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
	<c:if test="${param.forcemodify != true }">
		showEdit();
	</c:if>
</script>
</html>