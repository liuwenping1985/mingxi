<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
<%@include file="../header.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>集团管理员-移动应用-权限管理</title>
<script type="text/javascript">
var bodyHeight = "";
showCtpLocation("F13_groupMobile");
var accountSize = ${accountCount};
var defaultSMSSuffix = "<fmt:message key='mobile.default.SMS.suffix'/>";
</script>
</head>
<body scroll="no" onload="appSettingInit(${isCanUseWap}, ${isCanUseSMS}, ${isCanUseWappush})">
	<form method="post" action="${mobileManagerURL}">
	<input type="hidden" name="method" value="updatePopedomManage">
  <script type="text/javascript">
  bodyHeight = document.body.scrollHeight;
  </script>
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	   <tr>
	      <td valign="bottom" height="26" class="tab-tag">
				<div class="div-float">
					<div class="tab-separator"></div>	
					<div class="tab-tag-left-sel"></div>
					<div class="tab-tag-middel-sel" onclick="location.reload();">
					 <fmt:message key="mobile.popedomManage.label"/>
					</div>
					<div class="tab-tag-right-sel"></div>

					<c:if test="${isValidateMobileMessage}">
					<div class="tab-separator"></div>	
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel cursor-hand" 
						onclick="javascript:location.href='${mobileManagerURL}?method=msgGateManage'">
					 <fmt:message key="mobile.msgGateManage.label"/>
					</div>
					<div class="tab-tag-right"></div>

					 
					<div class="tab-separator"></div>	
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel cursor-hand" 
						onclick="javascript:location.href='${mobileManagerURL}?method=stateQuery'">
					 <fmt:message key="mobile.messageCount.label"/>
					</div>
					<div class="tab-tag-right"></div>
					</c:if>	
					<div class="tab-separator"></div>	
				</div>
		  </td>
	  </tr>
	  <tr>
	    <td valign="top" height="100%" class="" align="center">
	    <div class="scrollList" id="scrollListDiv">
	    <br>
		<fieldset style="padding: 20px; width: 80%">
			<legend><b><fmt:message key='mobile.appSetting.label'/></b></legend>
		    <br>
		    <table border="0" cellpadding="0" cellspacing="0">
		    	<%-- 是否有移动Wap访问插件 --%>
		    	<c:if test="${v3x:hasPlugin('mobileWap')}">
		    	<tr>
		    		<td width="40%" align="right">
		    			<fmt:message key='mobile.isCanUseWap.label'/>:&nbsp;
		    		</td>
		    		<td>
		    			<label for="isCanUseWap_Y">
		    				<input id="isCanUseWap_Y" type="radio" name="isCanUseWap" value="true" onclick="setSelectValue('isCanUseWap')">
							<fmt:message key='common.yes' bundle='${v3xCommonI18N}'/>
		    			</label>&nbsp;
		    			<label for="isCanUseWap_N">
		    				<input id="isCanUseWap_N" type="radio" name="isCanUseWap" value="false" onclick="setSelectValue('isCanUseWap')">
							<fmt:message key='common.no' bundle='${v3xCommonI18N}'/>
		    			</label>
		    		</td>
		    	</tr>
		    	</c:if>
		    	<c:if test="${isValidateMobileMessage}">
		    	<c:if test="${isValidateSMS}">
		    	<tr>
		    		<td width="40%" align="right">
		    			<fmt:message key='mobile.isCanUseSMS.label'/>:&nbsp;
		    		</td>
		    		<td>
		    			<label for="isCanUseSMS_Y">
		    				<input id="isCanUseSMS_Y" type="radio" name="isCanUseSMS" value="true" onclick="setSelectValue('isCanUseSMS');setSMSSuffix(true);">
							<fmt:message key='common.yes' bundle='${v3xCommonI18N}'/>
		    			</label>&nbsp;
		    			<label for="isCanUseSMS_N">
		    				<input id="isCanUseSMS_N" type="radio" name="isCanUseSMS" value="false" onclick="setSelectValue('isCanUseSMS');setSMSSuffix(false);">
							<fmt:message key='common.no' bundle='${v3xCommonI18N}'/>
		    			</label>
		    		</td>
		    	</tr>
		    	<tr id="suffixDisplayTR" class="hidden">
		    		<td width="40%" align="right">
		    			<fmt:message key='mobile.SMS.suffix.label'/>:&nbsp;
		    		</td>
		    		<td>
		    			<input id="smsSuffix" type="input" name="smsSuffix" value="${SMSSuffix}" class="input-60per" validate="maxLength" maxSize="50" maxlength="50">
		    		</td>
		    	</tr>
		    	</c:if>
		    	<c:if test="${isValidateWappush}">
		    	<tr>
		    		<td width="40%" align="right">
		    			<fmt:message key='mobile.isCanUseWappush.label'/>:&nbsp;
		    		</td>
		    		<td>
		    			<label for="isCanUseWappush_Y">
		    				<input id="isCanUseWappush_Y" type="radio" name="isCanUseWappush" value="true" onclick="setSelectValue('isCanUseWappush')">
							<fmt:message key='common.yes' bundle='${v3xCommonI18N}'/>
		    			</label>&nbsp;
		    			<label for="isCanUseWappush_N">
		    				<input id="isCanUseWappush_N" type="radio" name="isCanUseWappush" value="false" onclick="setSelectValue('isCanUseWappush')">
							<fmt:message key='common.no' bundle='${v3xCommonI18N}'/>
		    			</label>
		    		</td>
		    	</tr>
		    	</c:if>
		    	<tr>
		    		<td colspan="2" align="right">
		    			<input type="button" name="toDefault" value="<fmt:message key='channel.button.toDefault' bundle='${v3xMainI18N}'/>" class="button-default-4" onclick="appSettingInit(false,false,false);setDefaultSuffix();">
		    		</td>
		    	</tr>
		    	</c:if>
		    </table>
        </fieldset>
        <br>
        <br>
        <fieldset style="padding: 0px; width: 80% ;border: 0px">
        	<legend><b><fmt:message key='mobile.accountPopedom.label'/></b></legend>
   			<br>
   			<table class="page2-list-border sort" width="100%" cellpadding="0" cellspacing="0">
   				<thead>
   				<tr>
   					<td width="25%" height="28">
   					<fmt:message key='org.account.label' bundle='${v3xMainI18N}'/>
   					</td>
   					<c:if test="${v3x:hasPlugin('mobileWap')}">
   					<td width="25%">
   						<label for="isCanUseWap_all">
   							<input type="checkbox" id="isCanUseWap_all" onclick="selectAll(this, 'canUseWapAccounts')"/><fmt:message key='mobile.mobileView.label'/>
   						</label>
   					</td>
   					</c:if>
   					<c:if test="${isValidateSMS}">
   					<td width="25%">
   						<label for="isCanUseSMS_all">
   							<input type="checkbox" id="isCanUseSMS_all" onclick="selectAll(this, 'canUseSMSAccounts')"/><fmt:message key="mobile.SMS.label"/>
   						</label>
   					</td>
   					</c:if>
   					<c:if test="${isValidateWappush}">
   					<td>
   						<label for="isCanUseWappush_all">
   							<input type="checkbox" id="isCanUseWappush_all" onclick="selectAll(this, 'canUseWappushAccounts')"/><fmt:message key="mobile.WapPush.label"/>
   						</label>
   					</td>
   					</c:if>
   				</tr>
   				</thead>
   				<c:forEach items="${accountList}" var="account" varStatus="status">
   					<c:if test="${account.group!=true}">
   					<tr class="padding-L">
   					<td width="25%" height="24" class="sort" title="${account.name}">
   						${v3x:getLimitLengthString(account.name, 40, '...')}
   					</td>
   					<c:if test="${v3x:hasPlugin('mobileWap')}">
   					<td width="25%" class="sort">
	   					<label for="isCanUseWap${status.index}">
	   						<input type="checkbox" id="isCanUseWap${status.index}" name="canUseWapAccounts" value="${account.id}" ${v3x:containInCollection(canUseWapAccountList,account.id)? 'checked':''}><fmt:message key='common.allow.label' bundle='${v3xCommonI18N}'/>
	   					</label>
   					</td>
   					</c:if>
   					<c:if test="${isValidateSMS}">
   					<td width="25%" class="sort">
	   					<label for="isCanUseSMS${status.index}">
	   						<input type="checkbox" id="isCanUseSMS${status.index}" name="canUseSMSAccounts" value="${account.id}" ${v3x:containInCollection(canUseSMSAccountList,account.id)? 'checked':''}><fmt:message key='common.allow.label' bundle='${v3xCommonI18N}'/>
	   					</label>	
   					</td>
   					</c:if>
   					<c:if test="${isValidateWappush}">
   					<td class="sort">
	   					<label for="isCanUseWappush${status.index}">
	   						<input type="checkbox" id="isCanUseWappush${status.index}" name="canUseWappushAccounts" value="${account.id}" ${v3x:containInCollection(canUseWappushAccountList,account.id)? 'checked':''}><fmt:message key='common.allow.label' bundle='${v3xCommonI18N}'/>
	   					</label>
   					</td>
   					</c:if>
   				</tr>
   				</c:if>
  				</c:forEach>
   			</table>
        </fieldset>
        <br>
        </div>
	    </td>
	  </tr>
	  <tr>
			<td height="42" align="center" class="tab-body-bg bg-advance-bottom">
				<input type="submit" name="submitButton" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="button" onclick="getA8Top().backToHome();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
			</td>
		</tr>
	</table>
	</form>
</body>
</html>
<script>
$('#scrollListDiv').height(bodyHeight-100);
</script>