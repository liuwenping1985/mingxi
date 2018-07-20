<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
<%@include file="../header.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>单位管理员-移动应用管理-消息授权</title>
<script type="text/javascript">
var onlyLoginAccount_sendSMSPopedomSel = true;
var showConcurrentMember_sendSMSPopedomSel = false;

var onlyLoginAccount_recMessagePopedomSel = true;
var showConcurrentMember_recMessagePopedomSel = false;

showCtpLocation("F13_unitMobile1");
</script>
</head>
<body scroll="no" class="padding5">
<%-- 
<c:set value="${v3x:showOrgEntities(canSendAuth, 'id', 'entityType', pageContext)}" var="canSendAuthStr"/>
<c:set value="${v3x:showOrgEntities(canRecieveAuth, 'id', 'entityType', pageContext)}" var="canRecieveAuthStr"/>
 --%>
<v3x:selectPeople id="sendSMSPopedomSel" panels="Department,Level,Team,Outworker" minSize="0" selectType="Account,Department,Team,Member,Level" originalElements="${v3x:parseElementsOfTypeAndId(canSendAuth)}" jsFunction="mobileMgrPopedom('sendSMSPopedom', 'sendAuth', elements)"/>
<v3x:selectPeople id="recMessagePopedomSel" panels="Department,Level,Team,Outworker" minSize="0" selectType="Account,Department,Team,Member,Level" originalElements="${v3x:parseElementsOfTypeAndId(canRecieveAuth)}" jsFunction="mobileMgrPopedom('recMessagePopedom', 'recieveAuth', elements)"/>
	<form method="post" action="${mobileManagerURL}">
	<input type="hidden" name="method" value="updateMessagePopedom">
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	   <tr>
	      <td valign="bottom" height="26" class="tab-tag">
				<div class="div-float">
					<div class="tab-separator"></div>
					<div class="tab-tag-left-sel"></div>
					<div class="tab-tag-middel-sel" onclick="location.reload();">
					 <fmt:message key="mobile.messagePopedom.label"/>
					</div>
					<div class="tab-tag-right-sel"></div>
					
					<c:if test="${canUseSMSStr=='allow'}">
					<div class="tab-separator"></div>
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel cursor-hand" 
						onclick="javascript:location.href='${mobileManagerURL}?method=messageCount&toType='">
					 <fmt:message key="mobile.messageCount.label"/>
					</div>
					<div class="tab-tag-right"></div>
					</c:if>
					<div class="tab-separator"></div>
				</div>
		  </td>
	  </tr>

	  <tr>
	    <td valign="top" class="" align="center">
	    <div class="scrollList" id="scrollList">
	    <br>
		<fieldset style="padding: 20px; width: 80%">
		<legend><b><fmt:message key='mobile.accountPopedom.label'/></legend>
	    <br>
		    <table border="0" cellpadding="0" cellspacing="0">
		    	<tr>
		    		<td width="40%" align="right"><fmt:message key='mobile.isCanUseSMS.label'/>:</td>
		    		<td class="padding-L"><fmt:message key='common.${canUseSMSStr}.label' bundle='${v3xCommonI18N}'/></td>
		    	</tr>
		    	
		    	<c:if test="${canUseWapPushStr=='allow'}">
		    	<tr>
		    		<td width="40%" align="right"><fmt:message key='mobile.isCanUseWappush.label'/>:</td>
		    		<td class="padding-L"><fmt:message key='common.${canUseWapPushStr}.label' bundle='${v3xCommonI18N}'/></td>
		    	</tr>
		    	</c:if>
		    </table>
        </fieldset>
        <br>
        <fieldset style="padding: 20px; width: 80%; display:${canUseSMSStr == 'unallow' ? 'none' : ''}">
			<legend><b><fmt:message key='mobile.memberPopedom.label'/></b></legend>
		    <br>
	    	<div align="left" style="display:${canUseSMSStr=='unallow'? 'none':''}"><fmt:message key='mobile.popedomMember.sendSMS.label'/>:
	    	<br>
    		<c:choose>
    			<c:when test="${!empty canSendAuth}"><c:set var="b" value="${v3x:showOrgEntitiesOfTypeAndId(canSendAuth, pageContext)}" /></c:when>
    			<c:otherwise><fmt:message key='common.default.selectPeople.generic.value' bundle="${v3xCommonI18N}" var="b" /></c:otherwise>
    		</c:choose>
	    	<textarea id="sendSMSPopedom" cols="" rows="4" style="width:100%" class="cursor-hand" onclick="selectPeopleFun_sendSMSPopedomSel()" readonly>${b}</textarea>
	    	<div class="description-lable" style="font-weight: normal;"><fmt:message key="mobile.popedomMember.sendSMS.description"/></div>
		    <input type="hidden" id="sendAuth" name="sendAuth" value="${canSendAuth}">
	    	</div>
	    	<br><br>
	    	<div align="left"><fmt:message key='mobile.popedomMember.recMsg.label'/>:
	    	<br>
    		<c:choose>
    			<c:when test="${!empty canRecieveAuth}"><c:set var="a" value="${v3x:showOrgEntitiesOfTypeAndId(canRecieveAuth, pageContext)}" /></c:when>
    			<c:otherwise><fmt:message key='common.default.selectPeople.generic.value' bundle="${v3xCommonI18N}" var="a" /></c:otherwise>
    		</c:choose>
	    	<textarea id="recMessagePopedom" cols="" rows="4" style="width:100%" class="cursor-hand" onclick="selectPeopleFun_recMessagePopedomSel()" readonly>${a}</textarea>
	    	<div class="description-lable" style="font-weight: normal;"><fmt:message key='mobile.popedomMember.recMsg.description'/></div>
	    	<input type="hidden" id="recieveAuth" name="recieveAuth" value="${canRecieveAuth}">
	    	</div>
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
	
	<script>
		bindOnresize('scrollList',0,70);
	</script>
</body>
</html>