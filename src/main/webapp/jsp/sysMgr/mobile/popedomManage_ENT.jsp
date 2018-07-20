<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
<%@include file="../header.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>集团管理员-移动应用-权限管理</title>
<script type="text/javascript">
onlyLoginAccount_sendSMSPopedomSel = true;
onlyLoginAccount_recMessagePopedomSel = true;
showCtpLocation("F13_unitMobile2");
var defaultSMSSuffix = "<fmt:message key='mobile.default.SMS.suffix'/>";
</script>
</head>
<body scroll="no" class="padding5">
<v3x:selectPeople id="sendSMSPopedomSel" minSize="0" panels="Department,Level,Team,Outworker" selectType="Account,Department,Team,Member,Level" originalElements="${v3x:parseElementsOfTypeAndId(canSendAuth)}" jsFunction="mobileMgrPopedom('sendSMSPopedom', 'sendAuth', elements)"/>
<v3x:selectPeople id="recMessagePopedomSel" minSize="0" panels="Department,Level,Team,Outworker" selectType="Account,Department,Team,Member,Level" originalElements="${v3x:parseElementsOfTypeAndId(canRecieveAuth)}" jsFunction="mobileMgrPopedom('recMessagePopedom', 'recieveAuth', elements)"/>
	<form method="post" action="${mobileManagerURL}">
	<input type="hidden" name="method" value="updatePopedomManageENT">
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	   <tr>
	      <td valign="bottom" height="26" class="tab-tag">
				<div class="div-float">
					<div class="tab-tag-left-sel"></div>
					<div class="tab-tag-middel-sel" onclick="location.reload();">
					 <fmt:message key="mobile.popedomManage.label"/>
					</div>
					<div class="tab-tag-right-sel"></div>
					
					<c:if test="${isValidateMobileMessage}">
					<div class="tab-separator"></div>	
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel cursor-hand" 
						onclick="javascript:location.href='${mobileManagerURL}?method=msgGateManage&from=accountAdmin'">
					 <fmt:message key="mobile.msgGateManage.label"/>
					</div>
					<div class="tab-tag-right"></div>

					<div class="tab-separator"></div>	
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel cursor-hand" 
						onclick="javascript:location.href='${mobileManagerURL}?method=messageCount&toType=ENT'">
					 <fmt:message key="mobile.messageCount.label"/>
					</div>
					<div class="tab-tag-right"></div>
					
					</c:if>	
				</div>
		  </td>
	  </tr>
	  <tr>
	    <td valign="top" class="tab-body-bg" align="center">
	    <div class="scrollList" id ="scrollListDiv">
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
		    				<input id="isCanUseWap_Y" type="radio" name="isCanUseWap" value="true" ${isCanUseWap? 'checked':''}>
							<fmt:message key='common.yes' bundle='${v3xCommonI18N}'/>
		    			</label>&nbsp;
		    			<label for="isCanUseWap_N">
		    				<input id="isCanUseWap_N" type="radio" name="isCanUseWap" value="false" ${!isCanUseWap? 'checked':''}>
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
		    				<input id="isCanUseSMS_Y" type="radio" name="isCanUseSMS" value="true" onclick="displayPopedomFieldset();setSMSSuffix(true);" ${isCanUseSMS? 'checked':''}>
							<fmt:message key='common.yes' bundle='${v3xCommonI18N}'/>
		    			</label>&nbsp;
		    			<label for="isCanUseSMS_N">
		    				<input id="isCanUseSMS_N" type="radio" name="isCanUseSMS" value="false" onclick="displayPopedomFieldset();setSMSSuffix(false);" ${!isCanUseSMS? 'checked':''}>
							<fmt:message key='common.no' bundle='${v3xCommonI18N}'/>
		    			</label>
		    		</td>
		    	</tr>
		    	<tr  id="suffixDisplayTR" class="${isCanUseSMS?'show':'hidden'}">
		    		<td width="40%" align="right">
		    			<fmt:message key='mobile.SMS.suffix.label'/>:&nbsp;
		    		</td>
		    		<td>
		    			<input id="smsSuffix" type="input" name="smsSuffix" value="${SMSSuffix}" class="input-60per">
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
		    				<input id="isCanUseWappush_Y" type="radio" name="isCanUseWappush" value="true" onclick="displayPopedomFieldset()" ${isCanUseWappush? 'checked':''}>
							<fmt:message key='common.yes' bundle='${v3xCommonI18N}'/>
		    			</label>&nbsp;
		    			<label for="isCanUseWappush_N">
		    				<input id="isCanUseWappush_N" type="radio" name="isCanUseWappush" value="false" onclick="displayPopedomFieldset()" ${!isCanUseWappush? 'checked':''}>
							<fmt:message key='common.no' bundle='${v3xCommonI18N}'/>
		    			</label>
		    		</td>
		    	</tr>
		    	</c:if>
		    	<tr>
		    		<td colspan="2" align="right">
		    			<input type="button" name="toDefault" value="<fmt:message key='channel.button.toDefault' bundle='${v3xMainI18N}'/>" class="button-default-4" onclick="radioState2Default(false,false,false);displayPopedomFieldset();setDefaultSuffix();">
		    		</td>
		    	</tr>
		    	</c:if>
		    </table>
        </fieldset>
        <br>
        <c:if test="${isValidateMobileMessage}">
        <fieldset id="popedomFieldset" style="padding: 20px; width: 80%; display:${(!isCanUseSMS&&!isCanUseWappush)? 'none':''}">
			<legend><b><fmt:message key='mobile.memberPopedom.label'/></b></legend>
		    <br>
		    <c:if test="${isValidateSMS}">
	    	<div id="sendSMSPopedomDIV" align="left" style="display:${!isCanUseSMS? 'none':''}"><fmt:message key='mobile.popedomMember.sendSMS.label'/>:<br>
	    	<c:choose>
    			<c:when test="${!empty canSendAuth}"><c:set var="b" value="${v3x:showOrgEntitiesOfTypeAndId(canSendAuth, pageContext)}" /></c:when>
    			<c:otherwise><fmt:message key='common.default.selectPeople.generic.value' bundle="${v3xCommonI18N}" var="b" /></c:otherwise>
    		</c:choose>
	    	<textarea id="sendSMSPopedom" cols="" rows="4" style="width:100%" class="cursor-hand" onclick="selectPeopleFun_sendSMSPopedomSel()" readonly>${b}</textarea>
	    	<div class="description-lable" style="font-weight: normal;"><fmt:message key="mobile.popedomMember.sendSMS.description"/></div>
	    	</div>
		    <input type="hidden" id="sendAuth" name="sendAuth" value="${canSendAuth}">
	    	</c:if>
	    	<br>
	    	<c:if test="${(isValidateSMS || isValidateWappush)}">
	    	<br>
	    	<div align="left"><fmt:message key='mobile.popedomMember.recMsg.label'/>:<br>
    		<c:choose>
    			<c:when test="${!empty canRecieveAuth}"><c:set var="a" value="${v3x:showOrgEntitiesOfTypeAndId(canRecieveAuth, pageContext)}" /></c:when>
    			<c:otherwise><fmt:message key='common.default.selectPeople.generic.value' bundle="${v3xCommonI18N}" var="a" /></c:otherwise>
    		</c:choose>
    		<textarea id="recMessagePopedom" cols="" rows="4" style="width:100%" class="cursor-hand" onclick="selectPeopleFun_recMessagePopedomSel()" readonly>${a}</textarea>
	    	<div class="description-lable" style="font-weight: normal;"><fmt:message key='mobile.popedomMember.recMsg.description'/></div>
	    	</div>
	    	<input type="hidden" id="recieveAuth" name="recieveAuth" value="${canRecieveAuth}">
	    	</c:if>
	    </fieldset>
	    </c:if>
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
<script type="text/javascript">
if (document.body.clientHeight > 100){
	document.getElementById('scrollListDiv').style.height = document.body.clientHeight -100;
} else {
	bindOnresize('scrollListDiv',0,100);
}
</script>
</html>