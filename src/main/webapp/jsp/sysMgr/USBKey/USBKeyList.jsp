<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>	
<%@ include file="header.jsp" %>
<html>

<head>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"> 
${v3x:skin()}
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="USBKey.make.LoginVerifyUSBKey" /> </title>
<script type="text/javascript">
showCtpLocation("F13_makeIndex");
if(parent.showDetailInfo == true){
	showDetailPageBaseInfo("detailFrame", "<fmt:message key='menu.USBKey.make' />", [3,1], ${listCount}, _("USBKeyLang.detail_info_6001"));		
}
</script>
</head>
<body>
<div class="main_div_row2" scroll="no" class="listPadding">
<div class="right_div_row2">
<div class="top_div_row2">
<table border="0" width="100%" align="center"  cellpadding="0" cellspacing="0">	
    <tr>
	   <td height="22" class="webfx-menu-bar" style="color:black; padding-left: 10px;">
	   	<script type="text/javascript">
			var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
			myBar.add(new WebFXMenuButton("makeUSBKey", "<fmt:message key='menu.USBKey.make' />", "makeUSBKey()", [1,1]));
			myBar.add(new WebFXMenuButton("updateUSBKey", "<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />", "updateUSBKey()", [1,2]));
			myBar.add(new WebFXMenuButton("enableUSBKey", "<fmt:message key='common.toolbar.enable.label' bundle='${v3xCommonI18N}' />", "enableUSBKey(true)", [2,3]));
			myBar.add(new WebFXMenuButton("disableUSBKey", "<fmt:message key='common.toolbar.disable.label' bundle='${v3xCommonI18N}' />", "enableUSBKey(false)", [2,4]));
			myBar.add(new WebFXMenuButton("deleteUSBKey", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "deleteUSBKey()", [1,3]));
			document.write(myBar);
			document.close();
		</script>
	   </td>
	   <td class="webfx-menu-bar" width="50%" height="100%">
		   	<form action="" name="searchForm" id="searchForm" method="get" onkeypress="doSearchEnter()" onsubmit="return false" style="margin: 0px">
		   		<input type="hidden" value="<c:out value='${param.method}' />" name="method">
		        <div class="div-float-right">
	                <div class="div-float margin_r_5">
	                    <select name="condition" id="condition" onChange="showNextCondition(this)" class="textfield">
	                        <option value=""><fmt:message key='menu.USBKey.find' /></option>
	                        <option value="name"><fmt:message key='menu.USBKey.name' /></option>
	                        <option value="type"><fmt:message key='menu.USBKey.type' /></option>
	                        <option value="owner"><fmt:message key='menu.USBKey.owner' /></option>
	                        <option value="state"><fmt:message key='menu.USBKey.state' /></option>       
	                    </select>
	                </div>
	                <div id="nameDiv"  class="div-float hidden">
	                    <input type="text" name="textfield" maxlength="30" id="textfield" class="textfield" onkeydown="javascript:if(event.keyCode==13)return false;">
	                </div>
	                <div id="typeDiv" class="div-float hidden">
	                    <select name="textfield" id="textfield" class="textfield">
	                        <option value="0"><fmt:message key='USBKey.attribute.generic' /></option>
	                        <option value="1"><fmt:message key="USBKey.attribute.owner" /></option>
	                    </select>
	                </div>
	                <div id="ownerDiv" class="div-float hidden">
	                   <input name="textfield" type="text"  id="textfield" maxlength="40"  class="textfield" onkeydown="javascript:if(event.keyCode==13)return false;">
	                </div>
	                <div id="stateDiv" class="div-float hidden">
	                	<select name="textfield" id="textfield"  class="textfield">
		                    <option value="1"><fmt:message key='common.state.normal' /></option>
	                        <option value="0"><fmt:message key="common.state.invalidation" /></option>
	                    </select>
	                </div>
	                <div onclick="javascript:doSearch()" class="div-float condition-search-button"></div>
	            </div>
            </form>
        </td>
	</tr>
	</table>
	</div>
	 <div class="center_div_row2" id="scrollListDiv" style="top:26px">
	 <form name="USBKeyMgrForm" action="${identificationURL}" method="post" target="helpIFrame">
			<input type="hidden" name="method" value="enableUSBKey">
			<input type="hidden" name="enabled" value="true">
			<v3x:table width="100%" data="USBKeyList" var="USBKey" showPager="false" subHeight="0" className="sort ellipsis">
				<v3x:column width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"dogIds\")'/>">
				<input type='checkbox' name='dogIds' value="${USBKey.dogId}" />
				</v3x:column>
				<v3x:column width="20%" type="String" label="USBKey.attribute.name" className="cursor-hand sort" onClick="updateUSBKey('${USBKey.dogId}')" onDblClick="updateUSBKey()">
				    &nbsp;${v3x:toHTML(USBKey.name)}
				</v3x:column>
				<c:choose>
				<c:when test="${USBKey.memberId == 1}">
					<c:set var="owner"><fmt:message key="org.account_form.systemAdminName.value" bundle="${v3xOrganizationI18N }" /></c:set>
				</c:when>
				<c:when test="${USBKey.memberId == 0}">
					<c:set var="owner"><fmt:message key="org.auditAdminName.value" bundle="${v3xOrganizationI18N }" /></c:set>
				</c:when>
				<c:otherwise>
					<c:set var="owner">${v3x:toHTML(v3x:showOrgEntitiesOfIds(USBKey.memberId, 'Member', pageContext))}</c:set>
				</c:otherwise>
				</c:choose>
				<v3x:column width="15%" type="String" label="USBKey.attribute.type" className="cursor-hand sort" onClick="updateUSBKey('${USBKey.dogId}')" onDblClick="updateUSBKey()">
					<c:choose>
						<c:when test="${USBKey.genericDog == false}">
							<fmt:message key="USBKey.attribute.owner" />: ${owner}
						</c:when>
						<c:otherwise>
							<fmt:message key='USBKey.attribute.generic' />
						</c:otherwise>
					</c:choose>
				</v3x:column>
				<v3x:column width="20%" type="String" label="USBKey.attribute.isMustUseDog" className="cursor-hand sort" onClick="updateUSBKey('${USBKey.dogId}')" onDblClick="updateUSBKey()">
					<c:choose>
						<c:when test="${USBKey.genericDog == false}">
							<fmt:message key="common.${USBKey.mustUseDog? 'yes':'no'}" bundle="${v3xCommonI18N}" />
						</c:when>
						<c:otherwise>
							--
						</c:otherwise>
					</c:choose>
				</v3x:column>
				<v3x:column width="20%" type="String" label="USBKey.attribute.isNeedCheckUsername" className="cursor-hand sort" onClick="updateUSBKey('${USBKey.dogId}')" onDblClick="updateUSBKey()">
					<c:choose>
						<c:when test="${USBKey.genericDog == false}">
							<fmt:message key="common.${USBKey.needCheckUsername? 'yes':'no'}" bundle="${v3xCommonI18N}" />
						</c:when>
						<c:otherwise>
							--
						</c:otherwise>
					</c:choose>
				</v3x:column>
				<v3x:column type="String" width="20%" align="center" label="common.state.label" className="cursor-hand sort">
					<fmt:message key="common.state.${USBKey.enabled==true? 'normal':'invalidation'}.label" bundle="${v3xCommonI18N}" />
				</v3x:column>
			</v3x:table>
			</form>
		</div>
	 </div>
</div>
<iframe name="helpIFrame" width="0" height="0" frameborder="0"></iframe>
<script type="text/javascript">
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
</script>
</body>
</html>