<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<html style="height:100%;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>个人维护</title>
<%@include file="header.jsp"%>
<html:link renderURL='/main.do' var="mainURL"/>
<c:set var="path" value="${pageContext.request.contextPath}" />
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/passwdcheck.css${v3x:resSuffix()}" />">
<script type="text/javascript" src="<c:url value='/common/js/passwdcheck.js${v3x:resSuffix()}'/>"></script>
<script type="text/javascript">
<%--getA8Top().showLocation(801, "<fmt:message key='menu.individual.manager' bundle='${v3xMainI18N}'/>");--%>
<%--验证弹出的信息-输入新密码是否相同-原密码错误--%>
var sameOrNot = "<fmt:message key='manager.vialdateword'/>";
var oldPasswordMsg = "<fmt:message key='manager.oldword'/>";
var pwdStrengthValidation=${pwdStrengthValidation};//获取系统设置密码强度
var pwdNeedUpdate=${pwdNeedUpdate};//过期强制修改开关
var pwdpower=${pwdpower};//当前密码强度
var _ctxPath = '${path}';
function save(){
	var fm = document.getElementById('subBut');
	fm.click();
}
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
}
function cancle(){
	window.location.reload();
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
function initPage(){
	var from = parent.document.getElementById('submitbtn');
	if(from != null){
		document.getElementById('submitOk').style.display='none';
	}else{
		document.getElementById('submitOk').style.display='';
	}
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
</script>
<script type="text/javascript"
	src="<c:url value='/apps_res/systemmanager/js/individualManager.js${v3x:resSuffix()}'/>">
</script>
</head>
<body style="height:100%;" class="padding5 " scroll="no" onload="initPage();">
<form  style="height:100%;" id="postForm" method="post" action="<html:link renderURL='/individualManager.do' />?method=modifyIndividual" onsubmit="return (validateOldPassword1() && checkForm(this) && validate1()&&check())">
<input id="individualName" type="hidden" name="individualName" value="${logerName}" />
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	  <%--<tr>
	  	<td class="init-password-border">
	  		<c:if test="${initPage != 'true' }">
	    	<script type="text/javascript">
	    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}","gray");
			myBar.add(new WebFXMenuButton("editBtn","<fmt:message key='common.toolbar.update.label' bundle="${v3xCommonI18N}" />", "editData();", [1,2], "",null));
	    	document.write(myBar);
	    	document.close();
	    	</script>
	    	</c:if>
	  	</td>
	  </tr> --%>   
	  <tr>
	    <td valign="top" class="tab-body-bg" height="100%" align="center">
			<br><br><br><br>
			<div style="width: 500px;">	
			<fieldset>
			<legend>
			<fmt:message key="personal.password"/>
			</legend>	<br/>			
						<table width="70%" border="0" cellspacing="0" cellpadding="0"
							align="center">
							<c:set var="disabled" value="${param.disabled }" />
							<tr>
								<td class="bg-gray" width="20%" nowrap="nowrap"><label
									for="post.code">  <font color="red">*</font><fmt:message key="manager.formerpassword.notnull" />:</label></td>
								<td class="new-column" width="80%">
									<input class="input-100per" type="password" name="formerpassword" id="formerpassword" value="${systemPassword }" maxlength="50" inputName="<fmt:message key="manager.formerpassword.notnull" />" validate="notNull" />
								</td>
							</tr>
							<tr>
								<td class="bg-gray" width="20%" nowrap="nowrap"><label
									for="post.code"> <font color="red">*</font> <fmt:message key="manager.password.notnull" />:</label></td>
								<td class="new-column" width="80%">
									<input class="input-100per" type="password" name="nowpassword" id="nowpassword" value="" inputName="<fmt:message key="manager.password.notnull" />" minLength="6" maxLength="50" validate="notNull,minLength,maxLength"
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
									<input id="validatepass" class="input-100per" type="password" name="validatepass" value="" inputName="<fmt:message key="manager.validate.notnull" />"  minLength="6" maxLength="50" validate="notNull" />
								</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<c:if test="${pwdStrengthValidation==1}">
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
						<br/>			
						</fieldset>				
			</div>
			
		</td>
	</tr>
	<tr id="submitOk" style="display: ">
		<td height="42" align="center" class="tab-body-bg bg-advance-bottom" >
			<input type="submit" id="subBut" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
			<input type="button" id="outUpdate0" onclick="getA8Top().back();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2 button-left-margin-10">
			<input type="button" id="outUpdate1" onclick="exitsystem();" value="<fmt:message key='seeyon.top.close.alt' bundle="${v3xCommonI18N}" />" class="button-default-2 button-left-margin-10">
		</td>
	</tr>
</table>
</form>
</body>
</html>