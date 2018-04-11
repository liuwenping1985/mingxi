<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="header.jsp" %>
<title><fmt:message key="system.open"/></title>
</head>
<script type="text/javascript">
<!--
    showCtpLocation("F13_sysOpen");
	function confirmthisform(){
		var submitForm = document.getElementById("submitform");
		var result = checkForm(submitForm);
		if(result){
			submitForm.action = "${systemopenURL}?method=confirm";
			submitForm.submit();
		}
	}
	
	function defaultform(){
	    var submitForm = document.getElementById("submitform");
		submitForm.action = "${systemopenURL}?method=defaultSetting";
		submitForm.submit();
	}
//-->
</script>
<body scroll="auto">
<form id="submitform" name="submitform" method="post" target="hiddenIframe">
<TABLE width="100%" height="100%" align="center" border="0" cellpadding="0" cellspacing="0" class="">
	<tr id="table_head" class="page2-header-line">
		<td width="100%" height="41" valign="top" class="border_b">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     	<tr class="page2-header-line">
		        <td width="45" class="page2-header-img"><div class="systemOpenSpace"></div></td>
			        <td class="page2-header-bg"><fmt:message key="system.open"/></td>
			        <td class="page2-header-line">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
	<td align="center" valign="top" height="100%">
	<div class="scrollList">
	<br/><br/>
			<table border="0" width="70%" cellpadding="0" cellspacing="0" >
			<tr><td>
			<fieldset width="50%"><legend><fmt:message key="system.switch"/></legend>
			<table border="0" width="100%" cellpadding="4" cellspacing="6" >
			<%--启用消息声音提示 --%>
			  <tr>
			    <td width="40%"><div align="right"><fmt:message key="systemswitch.MsgHint.lable"/>:</div></td>
			    <td width="60%">
			    	<label for="msgSoundEnable1">
			    		<input id="msgSoundEnable1" name="SMS_hint" type="radio" value="enable"${SMS_hint=='enable' ? 'checked' : ''}>
			       		<fmt:message key="systemswitch.yes.lable"/>
			       </label>
			       <label for="msgSoundEnable2">
			        <input id="msgSoundEnable2" name="SMS_hint" type="radio" value="disable" ${SMS_hint=='disable' ? 'checked' : ''}>
			         <fmt:message key="systemswitch.no.lable"/>			       
			       </label>
			    </td>
			  </tr>
			  <%--公开显示流程的已读状态 --%>
			  <tr>
			    <td width="40%"><div align="right"><fmt:message key="systemswitch.isShowFlowReadState.lable"/>:</div></td>
			    <td width="60%">
			    <label for="isShowFlowReadState1">
			    	<input id="isShowFlowReadState1" name="read_state_enable" type="radio" value="enable" ${read_state_enable=='enable' ? 'checked' : ''}>
			     	<fmt:message key="systemswitch.yes.lable"/>
			     </label>
			    <label for="isShowFlowReadState2">
			        <input id="isShowFlowReadState2" name="read_state_enable" type="radio" value="disable" ${read_state_enable=='disable' ? 'checked' : ''}>
		         	<fmt:message key="systemswitch.no.lable"/>
		        </label> 
			     </td>
			  </tr>
			  <%--启用Office永中转换 --%>
			  <c:if test="${officetransFlag}">
			  <tr>
			  	<td width="40%"><div align="right"><fmt:message key="systemswitch.office.transform.lable"/>:</div></td>
			  	<td width="60%">
			  	 <label for=officeTransformConversion1>
			    	<input id="officeTransformConversion1" name="office_transform_enable" type="radio" value="enable" ${office_transform_enable=='enable' ? 'checked' : ''}>
			     	<fmt:message key="systemswitch.yes.lable"/>
			     </label>
			    <label for="officeTransformConversion2">
			        <input id="officeTransformConversion2" name="office_transform_enable" type="radio" value="disable" ${office_transform_enable=='disable' ? 'checked' : ''}>
		         	<fmt:message key="systemswitch.no.lable"/>
		        </label> 
			     </td>
			  </tr>
			  </c:if>
			 </table>
			 </fieldset>
			 <fieldset width="50%"><legend><fmt:message key="function.switch"/></legend>
			 <table border="0" width="100%" cellpadding="4" cellspacing="6" >
			 <%--启用公文管理 
			  <tr class="${v3x:getSysFlagByName('sys_isGovVer')=='true' or !v3x:hasPlugin('edoc')? 'hidden':''}">
			    <td width="40%" align="right"><fmt:message key="systemswitch.edoc.lable.rep"/>:</td>
			    <td width="60%">
			    <label for="edocRadio1">
			    <input id="edocRadio1" name="edoc_enable" type="radio" value="enable" ${edoc_enable=='enable' ? 'checked' : ''}>
			      <fmt:message key="systemswitch.yes.lable"/>
			    </label> 
			     <label for="edocRadio2">
			    <input id="edocRadio2" name="edoc_enable" type="radio" value="disable" ${edoc_enable=='disable' ? 'checked' : ''}>
			         <fmt:message key="systemswitch.no.lable"/>
			    </label> 
			    </td>
			   </tr>--%>
			   <%--启用RSS订阅 --%>
				<c:if test="${docRssFlag}">
			   <tr class="">
			    <td width="40%"><div align="right"><fmt:message key="systemswitch.rssenable.label.rep"/>:</div></td>
			    <td width="60%">
			    <label for="rssenable1">
			    <input id="rssenable1" name="rss_enable" type="radio" value="enable" ${rss_enable=='enable' ? 'checked' : ''}>
			      <fmt:message key="systemswitch.yes.lable"/>
			     </label>
			     <label for="rssenable2">
			        <input id="rssenable2" name="rss_enable" type="radio" value="disable" ${rss_enable=='disable' ? 'checked' : ''}>
			         <fmt:message key="systemswitch.no.lable"/>
			      </label>
			    </td>
			   </tr>
			   </c:if>
			   <%-- 启用考勤管理--%>
			   <tr class="${v3x:hasPlugin('attendance')? '':'hidden'}">
			    <td width="40%"><div align="right"><fmt:message key="systemswitch.cardEnable.label"/>:</div></td>
			    <td width="60%">
			    <label for="cardEnable1">
			    <input id="cardEnable1" name="card_enable" type="radio" value="enable" ${card_enable=='enable' ? 'checked' : ''}>
			      <fmt:message key="systemswitch.yes.lable"/>
			     </label>
			     <label for="cardEnable2">
			        <input id="cardEnable2" name="card_enable" type="radio" value="disable" ${card_enable=='disable' ? 'checked' : ''}>
			         <fmt:message key="systemswitch.no.lable"/>
			      </label>
			    </td>
			   </tr>
			    <%-- 启用薪资查看--%>
			   <tr class="${v3x:hasPlugin('hr')? '':'hidden'}">
			    <td width="40%"><div align="right"><fmt:message key="systemswitch.salaryEnable.label"/>:</div></td>
			    <td width="60%">
			    <label for="salaryEnable1">
			    <input id="salaryEnable1" name="salary_enable" type="radio" value="enable" ${salary_enable=='enable' ? 'checked' : ''}>
			      <fmt:message key="systemswitch.yes.lable"/>
			     </label>
			     <label for="salaryEnable2">
			        <input id="salaryEnable2" name="salary_enable" type="radio" value="disable" ${salary_enable=='disable' ? 'checked' : ''}>
			         <fmt:message key="systemswitch.no.lable"/>
			      </label>
			    </td>
			   </tr>		
			   <%--启用员工博客 --%>
				<c:if test="${docBlogFlag}">
			   <tr>
			    <td width="40%"><div align="right"><fmt:message key="systemswitch.blogEnable.label"/>:</div></td>
			    <td width="60%">
			    <label for="blogEnable1">
			    <input id="blogEnable1" name="blog_enable" type="radio" value="enable" ${blog_enable=='enable' ? 'checked' : ''}>
			      <fmt:message key="systemswitch.yes.lable"/>
			     </label>
			     <label for="blogEnable2">
			        <input id="blogEnable2" name="blog_enable" type="radio" value="disable" ${blog_enable=='disable' ? 'checked' : ''}>
			         <fmt:message key="systemswitch.no.lable"/>
			      </label>
			    </td>
			  </tr>
			  </c:if>
			  <%--是否允许单位更改权限--%>
			  <c:if test="${v3x:getSystemProperty('system.allowUnitChangePriv')}">
			  <tr>
			    <td width="40%"><div align="right"><fmt:message key="systemswitch.privEnable.label"/>:</div></td>
			    <td width="60%">
			    <label for="privEnable1">
			    <input id="privEnable1" name="group_priv_type" type="radio" value="true" ${group_priv_type=='true' ? 'checked' : ''}>
			      <fmt:message key="systemswitch.yes.lable"/>
			    </label>
			    <label for="privEnable2">
			        <input id="privEnable2" name="group_priv_type" type="radio" value="false" ${group_priv_type=='false' ? 'checked' : ''}>
			         <fmt:message key="systemswitch.no.lable"/>
			     </label>
			    </td>
			  </tr>
			  </c:if>
			  <!-- 是否默认使用管理员上传的头像 -->
			  <tr>
			    <td width="40%"><div align="right"><fmt:message key="systemswitch.defaultAvatar.lable"/>:</div></td>
			    <td width="60%">
			    <label for="defaultAvatar1">
			    <input id="defaultAvatar1" name="default_avatar" type="radio" value="enable" ${default_avatar=='enable' ? 'checked' : ''}>
			      <fmt:message key="systemswitch.yes.lable"/>
			    </label>
			    <label for="defaultAvatar2">
			        <input id="defaultAvatar2" name="default_avatar" type="radio" value="disable" ${default_avatar=='disable' ? 'checked' : ''}>
			         <fmt:message key="systemswitch.no.lable"/>
			     </label>
			    </td>
			  </tr>
			  <!-- 是否允许员工修改头像 -->
			  <tr>
			    <td width="40%"><div align="right"><fmt:message key="systemswitch.allowUpdateAvatar.lable"/>:</div></td>
			    <td width="60%">
			    <label for="allowUpdateAvatar1">
			    <input id="allowUpdateAvatar1" name="allow_update_avatar" type="radio" value="enable" ${allow_update_avatar=='enable' ? 'checked' : ''}>
			      <fmt:message key="systemswitch.yes.lable"/>
			    </label>
			    <label for="allowUpdateAvatar2">
			        <input id="allowUpdateAvatar2" name="allow_update_avatar" type="radio" value="disable" ${allow_update_avatar=='disable' ? 'checked' : ''}>
			         <fmt:message key="systemswitch.no.lable"/>
			     </label>
			    </td>
			  </tr>
			  <%--是否允许单位更改权限--%>
              <c:if test="${v3x:getSystemProperty('system.allowUnitChangePriv')}">
              <tr>
                <td width="40%"><div align="right"><fmt:message key="systemswitch.allowGroupEditAccount.label"/>:</div></td>
                <td width="60%">
                <label for="allowGroupEditAccount1">
                <input id="allowGroupEditAccount1" name="allow_group_edit_account" type="radio" value="enable" ${allow_group_edit_account=='enable' ? 'checked' : ''}>
                  <fmt:message key="systemswitch.yes.lable"/>
                </label>
                <label for="allowGroupEditAccount2">
                    <input id="allowGroupEditAccount2" name="allow_group_edit_account" type="radio" value="disable" ${allow_group_edit_account=='disable' ? 'checked' : ''}>
                     <fmt:message key="systemswitch.no.lable"/>
                 </label>
                </td>
              </tr>
              </c:if>
			  </table>
			  </fieldset>
			  <fieldset width="50%"><legend><fmt:message key="security.switch"/></legend>
			  <table border="0" width="100%" cellpadding="4" cellspacing="6" >
			  <%--启用验证码 --%>
			  <tr>
			  <td width="40%"><div align="right"><fmt:message key="systemswitch.verifycode.lable.rep"/>:</div></td>
			  <td width="60%">
			  <label for="verifycodeEnable">
			  	<input id="verifycodeEnable" name="verify_code" type="radio" value="enable" ${verify_code=='enable' ? 'checked' : ''}>
			    <fmt:message key="systemswitch.yes.lable"/>
			  </label>
			  <label for="verifycodeDisable">
			      <input id="verifycodeDisable" name="verify_code" type="radio" value="disable" ${verify_code=='disable' ? 'checked' : ''}>
			      <fmt:message key="systemswitch.no.lable"/>
			   </label>
			   </td>
			  </tr>
			  <%--附件加密--%>
			  <tr>
			    <td width="40%"><div align="right"><fmt:message key="systemswitch.attatchencrypt.lable"/>:</div></td>
			    <td width="60%">
			    <label for="attatchencrypt1">
			    <input id="attatchencrypt1" name="attach_encrypt" type="radio" value="no" ${attach_encrypt=='no'? 'checked' : ''}>
			      <fmt:message key="systemswitch.attatchencrypt.no"/>
			    </label>
			    <label for="attatchencrypt2">
			        <input id="attatchencrypt2" name="attach_encrypt" type="radio" value="middle" ${attach_encrypt=='middle' ? 'checked' : ''}>
			         <fmt:message key="systemswitch.attatchencrypt.middle"/>
			    </label>
			     <label for="attatchencrypt3">
			        <input id="attatchencrypt3" name="attach_encrypt" type="radio" value="high" ${attach_encrypt=='high' ? 'checked' : ''}>
			         <fmt:message key="systemswitch.attatchencrypt.high"/>
			     </label>
			    </td>
			  </tr>
			  
			  <%-- 日志保存期限 --%>
			  <tr>
			    <td width="40%"><div align="right"><fmt:message key="systemswitch.log.deadline.login"/>:</div></td>
			    <td width="60%">
			    	<select	name="log_deadline_login">
						<v3x:metadataItem metadata="${logDeadlineMetadata}" showType="option" name="log_deadline_login" selected="${log_deadline_login}" switchType="input" />
					</select>
			    </td>
			  </tr>
			  <%--应用日志保存期限 --%>
			  <tr>
			    <td width="40%"><div align="right"><fmt:message key="systemswitch.log.deadline.app"/>:</div></td>
			    <td width="60%">
			    	<select	name="log_deadline_app">
						<v3x:metadataItem metadata="${logDeadlineMetadata}" showType="option" name="log_deadline_app" selected="${log_deadline_app}" switchType="input" />
					</select>
			    </td>
			  </tr>
<%-- 			  <!-- 新增密码过期期限 -->
			  <tr>
			    <td width="40%"><div align="right"><font color="red">*</font><fmt:message key="systemswitch.pwdExpirationTime.lable"/>:</div></td>
			    <td width="60%">
			    	<input class="input-date" maxlength="6" type="text" id="pwdExpirationTime" name="pwd_expiration_time"
			    	 type="input" value="${pwd_expiration_time}" inputName="<fmt:message key='systemswitch.pwdExpirationTime.lable'/>" validate="notNull,isInteger">
			    	<fmt:message key="systemswitch.pwdExpirationTime.lable.desc"/>
			   </td>
			  </tr>
			  <!-- 新增错误登录次数 -->
			  <tr>
			    <td width="40%"><div align="right"><font color="red">*</font><fmt:message key="systemswitch.userLoginCount.lable"/>:</div></td>
			    <td width="60%">
			    	<input class="input-date" maxlength="6" type="text" id="userLoginCount" name="user_login_count"
			    	 type="input" value="${user_login_count}" inputName="<fmt:message key='systemswitch.userLoginCount.lable'/>" validate="notNull,isInteger">
			    	<fmt:message key="systemswitch.userLoginCount.lable.desc"/>
			   </td>
			  </tr>
			  <!-- 新增禁止登录期限 -->
			   <tr>
			    <td width="40%"><div align="right"><font color="red">*</font><fmt:message key="systemswitch.forbiddenLoginTime.lable"/>:</div></td>
			    <td width="60%">
			    	<input class="input-date" maxlength="6" type="text" id="forbiddenLoginTime" name="forbidden_login_time"
			    	 type="input" value="${forbidden_login_time}" inputName="<fmt:message key='systemswitch.forbiddenLoginTime.lable'/>" validate="notNull,isInteger">
			    	<fmt:message key="systemswitch.forbiddenLoginTime.lable.desc"/></td>
			  </tr>
			  <!-- 新增是否启用密码强度检查 -->
			  <tr>
			  <td width="40%"><div align="right"><fmt:message key="systemswitch.pwdStrengthValidate.lable"/>:</div></td>
			  <td width="60%">
			  <label for="pwdStrengthValidationEnable">
			  	<input id="pwdStrengthValidationEnable" name="pwd_strength_validation_enable" type="radio" value="enable" ${pwd_strength_validation_enable=='enable' ? 'checked' : ''}>
			    <fmt:message key="systemswitch.yes.lable"/>
			  </label>
			  <label for="pwdStrengthValidationDisable">
			      <input id="pwdStrengthValidationDisable" name="pwd_strength_validation_enable" type="radio" value="disable" ${pwd_strength_validation_enable=='disable' ? 'checked' : ''}>
			      <fmt:message key="systemswitch.no.lable"/>
			   </label>
			   </td>
			  </tr> --%>
			  <!--  
			  <tr>
			  <td width="40%"><div align="right"><fmt:message key="systemswitch.formnumneedformat.lable"/>:</div></td>
			  <td width="60%">
			  <label for="formNumberNeedFormat">
			  	<input id="formNumberNeedFormat" name="FORMNUMBER_ISNEED_FORMAT" type="radio" value="true" ${formNumberNeedFormat.configValue=='true' ? 'checked' : ''}>
			    <fmt:message key="systemswitch.yes.lable"/>
			  </label>
			  <label for="formNumberNoNeedFormat">
			      <input id="formNumberNoNeedFormat" name="FORMNUMBER_ISNEED_FORMAT" type="radio" value="false" ${formNumberNeedFormat.configValue=='false' ? 'checked' : ''}>
			      <fmt:message key="systemswitch.no.lable"/>
			   </label>
			   </td>
			  </tr>
			  -->
			  <!-- 新增访问IP控制开关 -->
			  <tr>
			  <td width="40%"><div align="right"><fmt:message key="systemswitch.control.label"/>:</div></td>
			  <td width="60%">
			  <label for="ipcontrol1">
			  	<input id="ipcontrol1" name="ip_control_enable" type="radio" value="enable" ${ip_control_enable=='enable' ? 'checked' : ''}>
			    <fmt:message key="systemswitch.yes.lable"/>
			  </label>
			  <label for="ipcontrol2">
			      <input id="ipcontrol2" name="ip_control_enable" type="radio" value="disable" ${ip_control_enable=='disable' ? 'checked' : ''}>
			      <fmt:message key="systemswitch.no.lable"/>
			   </label>
			   </td>
			  </tr>
			  <%-- 公开显示通讯录的职务级别
			  <tr>
			    <td width="40%"><div align="right"><fmt:message key="systemswitch.isShowLevelState.lable${v3x:suffix()}"/>:</div></td>
			    <td width="60%">
			    <label for="isShowLevelState1">
			    	<input id="isShowLevelState1" name="level_state_enable" type="radio" value="enable" ${level_state_enable=='enable' ? 'checked' : ''}>
			     	<fmt:message key="systemswitch.yes.lable"/>
			     </label>
			    <label for="isShowLevelState2">
			        <input id="isShowLevelState2" name="level_state_enable" type="radio" value="disable" ${level_state_enable=='disable' ? 'checked' : ''}>
		         	<fmt:message key="systemswitch.no.lable"/>
		        </label> 
			     </td>
			  </tr>--%>
			</table>
			</fieldset>	
			</td></tr>
			</table>
	 </div>
	</td>
  </tr>
  <tr id="table_foot">
	  <td height="42" class="bg-advance-bottom" align="center"> 
	  	<input type="button" name="Input3" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2" onclick="confirmthisform()">&nbsp;&nbsp;
		<input name="Input" type="button" title="<fmt:message key="systemswitch.resume.defaultDeploy"/>" class="button-default-2" value="<fmt:message key="systemswitch.resume.defaultDeploy"/>" onclick="defaultform()">&nbsp;&nbsp;
		<input type="button" name="Input2" onclick="getA8Top().backToHome()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
	  </td>
  </tr>
</table>
</form>
<iframe name="hiddenIframe" frameborder="0" height="0" width="0"></iframe>
</body>
<script>
	initIe10AutoScroll("scrollList", document.getElementById("table_head").clientHeight + document.getElementById("table_foot").clientHeight);
</script>
</html>