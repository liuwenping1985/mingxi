<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
<%@include file="../header.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>移动应用-消息通道管理</title>
<script type="text/javascript">
//getA8Top().showLocation(2008, "<fmt:message key='mobile.msgGateManage.label'/>");
var otherMsgSystemKey = [];
<c:forEach items="${otherMsgSystemList}" var="sys">
	otherMsgSystemKey[otherMsgSystemKey.length] = "${sys.applicationCategory}";
</c:forEach>

function checkAll(){
	var all_p = document.getElementsByName("preferredHidden");
	var all_s = document.getElementsByName("isSendOfOnlineHidden");
	for (var i = 0; i < all_p.length; i++) {
		if (all_p[i].value == "true") {
			document.getElementById("smscheckbox_all").checked = true;
			break;
		}
	}
	for (var i = 0; i < all_s.length; i++) {
		if (all_s[i].value == "true") {
			document.getElementById("onlineRecCheckbox_all").checked = true;
			break;
		}
	}
}
</script>
</head>
<body scroll="no" class="padding5" onload="checkAll()">
<form method="get" action="${mobileManagerURL}">
	<input type="hidden" name="method" value="updateMsgGateManage">
	<input type="hidden" name="from" value="${from}">
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	   <tr>
	      <td valign="bottom" height="26" class="tab-tag">
				<div class="div-float">
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel cursor-hand" 
						onclick="javascript:location.href='${mobileManagerURL}?method=popedomManage${from=='accountAdmin'? 'ENT':''}'">
					 <fmt:message key="mobile.popedomManage.label"/>
					</div>
					<div class="tab-tag-right"></div>
					
					<div class="tab-separator"></div>

					<div class="tab-tag-left-sel"></div>
					<div class="tab-tag-middel-sel" onclick="location.reload();">
					 <fmt:message key="mobile.msgGateManage.label"/>
					</div>
					<div class="tab-tag-right-sel"></div>

					<div class="tab-separator"></div>	
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel cursor-hand" 
						onclick="javascript:location.href='${mobileManagerURL}?method=${from=='accountAdmin'? 'messageCount&toType=ENT':'stateQuery'}'">
					 <fmt:message key="mobile.messageCount.label"/>
					</div>
					<div class="tab-tag-right"></div>
					
				</div>
		  </td>
	  </tr>
	  <tr>
	    <td valign="top" align="center" height="100%" class="">
			<div class="scrollList" id="scrollList">
			<br>
		      <table align="center" width="600" class="page2-list-border sort" border="0" cellpadding="0" cellspacing="0">
		      	<thead>
			      	<tr class="padding-L">
			      		<td height="28" width="25%">
			      			<fmt:message key="mobile.appName.label"/>
			      		</td>
			      		<c:if test="${isValidateSMS}">
			      		<td width="25%">
			      			<label for="smscheckbox_all">
   							<input type="checkbox" id="smscheckbox_all" onclick="selectAllApp(this,1)"/><fmt:message key='mobile.SMS.label'/>
   							</label>
			      		</td>
			      		</c:if>
			      		<c:if test="${isValidateWappush}">
			      		<td width="30%">
			      			<label for="wappushCheckbox_all">
   							<input type="checkbox" id="wappushCheckbox_all" onclick="selectAllApp(this,2)"/><fmt:message key='mobile.WapPush.label'/>
   							</label>
			      		</td>
						</c:if>
						<td>
			      			<label for="onlineRecCheckbox_all">
   							<input type="checkbox" id="onlineRecCheckbox_all" onclick="selectAllApp(this,3)"/><fmt:message key="mobile.onlineRec.label"/><font color="red">*</font>
   							</label>
			      		</td>
			      	</tr>
		      	</thead>
		      	<c:forEach items="${appEnumList}" var="appEnumKey">
					<c:if test="${!(appEnumKey==4&&!v3x:hasPlugin('edoc')) && !v3x:containInCollection(keyList, appEnumKey)}">
						<tr class="padding-L">
				      		<td height="30" class="sort">
				      			<c:if test="${appEnumKey == 3 && v3x:getSysFlag('knowledge_change') == 'true'  }">
				      				<fmt:message key='doc.tree.struct.lable' bundle="${v3xSysI18N}" />
				      			</c:if>
				      			<c:if test="${!(appEnumKey == 3 && v3x:getSysFlag('knowledge_change') == 'true')  }">
				      				<fmt:message key='application.${appEnumKey}.label' bundle="${v3xSysI18N}" />
				      			</c:if>
				      		</td>
				      		<c:if test="${isValidateSMS}">
				      		<td class="sort">
				      		<label for="checkBox${appEnumKey}1">
				      			<input id="checkBox${appEnumKey}1" type="checkbox" name="preferred${appEnumKey}" value="SMS" ${appMessageRules[appEnumKey].preferred=='SMS'? 'checked':''} onclick="checkBox2radioBtn('checkBox${appEnumKey}', 1, 'isSendOfOnline${appEnumKey}')">
				      			<input type="hidden" name="preferredHidden" value="${appMessageRules[appEnumKey].preferred=='SMS' ? 'true' : ''}" />
				      			<fmt:message key='mobile.preferred.label' />
				      		</label>
				      		</td>
				      		</c:if>
				      		<c:if test="${isValidateWappush}">
				      		<td class="sort">
					      		<c:choose>
					      		<c:when test="${v3x:containInCollection(appEnumListOfWapPush, appEnumKey)}">
						      		<label for="checkBox${appEnumKey}2">
						      			<input id="checkBox${appEnumKey}2" type="checkbox" name="preferred${appEnumKey}" value="WAPPUSH" ${appMessageRules[appEnumKey].preferred=='WAPPUSH'? 'checked':''} onclick="checkBox2radioBtn('checkBox${appEnumKey}', 2, 'isSendOfOnline${appEnumKey}')">
						      			<fmt:message key='mobile.preferred.label' />
						      		</label>
					      		</c:when>
					      		<c:otherwise>
					      			<fmt:message key='common.none' bundle="${v3xCommonI18N}"/>
					      		</c:otherwise>
					      		</c:choose>
				      		</td>
				      		</c:if>
				      		<td class="sort">
				      			<input type="checkbox" name="isSendOfOnline${appEnumKey}" id="isSendOfOnline${appEnumKey}" value="true" ${appMessageRules[appEnumKey].sendOfOnline? 'checked':''} ${appMessageRules[appEnumKey].preferred==null? 'disabled':''}>
				      			<input type="hidden" name="isSendOfOnlineHidden" value="${appMessageRules[appEnumKey].sendOfOnline ? 'true' : ''}" />
				      		</td>
				      	</tr>
					</c:if>
		      	</c:forEach>
		      	<c:forEach items="${otherMsgSystemList}" var="sys">
		      		<c:set value="${sys.applicationCategory}" var="key" />
		      		<tr class="padding-L">
				      		<td height="30" class="sort">
				      			${v3x:messageFromResource(sys.i18NResource, sys.displayName)}
				      		</td>
				      		<c:if test="${isValidateSMS}">
				      		<td class="sort">
				      		<label for="checkBox${key}1">
				      			<input id="checkBox${key}1" type="checkbox" name="preferred${key}" value="SMS" ${appMessageRules[key].preferred=='SMS'? 'checked':''} onclick="checkBox2radioBtn('checkBox${key}', 1, 'isSendOfOnline${key}')">
				      			<fmt:message key='mobile.preferred.label' />
				      		</label>
				      		</td>
				      		</c:if>
				      		<c:if test="${isValidateWappush}">
				      		<td class="sort">
					      		<fmt:message key='common.none' bundle="${v3xCommonI18N}"/>
				      		</td>
				      		</c:if>
				      		<td class="sort">
				      			<input type="checkbox" name="isSendOfOnline${key}" id="isSendOfOnline${key}" value="true" ${appMessageRules[key].sendOfOnline? 'checked':''} ${appMessageRules[key].preferred==null? 'disabled':''}>
				      		</td>
				      	</tr>
		      	</c:forEach>
		      </table>
		    <br>
		   <li style="color: red"><span class="description-lable"> <fmt:message key='mobile.msgGateManage.explain.label' /></span></li>
		   </div>
	    </td>
	  </tr>
	  <tr>
			<td height="42" align="center" class="tab-body-bg bg-advance-bottom">
				<input type="submit" name="submitButton" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2 button-default_emphasize">&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="button" onclick="getA8Top().backToHome();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
			</td>
		</tr>
	</table>
	<script>
		bindOnresize('scrollList',0,70);
	</script>
</body>
</html>