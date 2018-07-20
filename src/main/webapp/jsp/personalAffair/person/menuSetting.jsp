<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/shortcut.js${v3x:resSuffix()}" />"></script>
<title>Insert title here</title>
<script type="text/javascript">
getA8Top().showLocation(801, "<fmt:message key='personalSetting.menu.label'/>");

function updateTopMenu(refreshTopFlag){
	if(refreshTopFlag == "true"){
		getA8Top().contentFrame.topFrame.reloadMenu();
	}else{
		setOldMenuSpareIdsValue();
	}
}

function setOldMenuSpareIdsValue(){
	var str = "";
	<c:forEach items="${menuProfileIds}" var="id" varStatus="status">
		str += "${id}";
		<c:if test="${!status.last}">
		str += ",";
		</c:if>
	</c:forEach>
	document.getElementById("oldMenuSpareIds").value = str;
}
</script>
</head>
<body scroll="no" class="padding5" onload="updateTopMenu('${param.refreshTop}');">
<form method="get" action="${mainURL}" onsubmit="return settingMenuOk();">
	<input type="hidden" name="method" value="updateMenuSetting">
	<input type="hidden" name="isRefreshTop" value="true">
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
	      <td valign="bottom" height="26" class="tab-tag">
	      		<%@include file="../../sysMgr/settingCommon.jsp" %>
		  </td>
	  </tr>
	  <tr>
	    <td width="100%" class="tab-body-bg" align="center">
        <div class="scrollList" id="scrollListDiv">
        <table width="440" height="100%" align="center" border="0" cellpadding="0" cellspacing="0">
              <tr>
		        <td width="100%" valign="top" style="padding-top: 20px;">
		        <br/>
		         <br/>
		        <fieldset style="height:320px;">
		     	<legend><fmt:message key="personalSetting.menu.label"/>:</legend>
		     	 <table width="100%" height="100%" align="center" border="0" cellpadding="0" cellspacing="0">
		              <tr>
				        <td width="150" height="30" align="center" >
				        	<b><fmt:message key="shortcut.all.label"/></b>
				        </td>
				        <td width="15">&nbsp;</td>
				        <td width="150" align="center">
				        	<b><fmt:message key="selectPeople.selected.label"/></b>
				         </td>
				         <td width="20">&nbsp;</td>
				     </tr>
		              <tr>
				        <td align="center">
						    <SELECT name="menuSourceSelect" size="16" id="menuSourceSelect" multiple style="width:170px; height: 250px;" ondblclick="addThisItem('menu')">
								<c:forEach items="${menuSpareProfileList}" var="menuSpare">
								<c:if test="${!v3x:containInCollection(menuProfileIds, menuSpare.id)}">
								        <OPTION value="${menuSpare.id}">
								        <c:choose>
								        	<c:when test="${menuSpare.resourceI18N != null}">${v3x:messageFromResource(menuSpare.resourceI18N, menuSpare.name)}</c:when>
								        	<c:otherwise>
								        		${v3x:_(pageContext, menuSpare.name)}
								        	</c:otherwise>
								        </c:choose>
								        </OPTION>
								</c:if>
								</c:forEach>
						    </SELECT>
				        </td>
				        <td align="center">
			         		<img alt="<fmt:message key='selectPeople.alt.select'/>" src="<c:url value="/common/images/arrow_a.gif"/>" width="15"
									height="12" class="cursor-hand" onClick="addThisItem('menu')"><br/><br/>
							<img alt="<fmt:message key='selectPeople.alt.unselect'/>" src="<c:url value="/common/images/arrow_del.gif"/>" width="15"
									height="12" class="cursor-hand" onClick="removeThisItem('menu')">
						</td>
				        <td align="center">
						    <SELECT name="menuTargetSelect" size="16" id="menuTargetSelect" multiple style="width:170px; height: 250px;" ondblclick="removeThisItem('menu')">
								<c:forEach items="${menuProfileIds}" var="menuId">
								        <OPTION value="${menuId}">
								        <c:choose>
								        	<c:when test="${menuProfileMaps[menuId].resourceI18N != null}">${v3x:messageFromResource(menuProfileMaps[menuId].resourceI18N, menuProfileMaps[menuId].name)}</c:when>
								        	<c:otherwise>								        		
								        		${v3x:_(pageContext, menuProfileMaps[menuId].name)}
								        	</c:otherwise>
								        </c:choose>
								        </OPTION>
								</c:forEach>
						    </SELECT>
						    <input type="hidden" name="menuSpareIds" id="menuSpareIds" value="">
						    <input type="hidden" name="oldMenuSpareIds" id="oldMenuSpareIds" value="">
				        </td>
				        <td>
			         		<p><img alt="<fmt:message key='selectPeople.alt.up'/>" src="<c:url value="/common/images/arrow_u.gif"/>" width="12"
									height="15" class="cursor-hand" onClick="moveUp('menu')"></p><br/>
							<p><img alt="<fmt:message key='selectPeople.alt.down'/>" src="<c:url value="/common/images/arrow_d.gif"/>" width="12"
									height="15" class="cursor-hand" onClick="moveDown('menu')"></p>
						</td>
				     </tr>
					</table>
		     </fieldset>
		   </td>
		   </tr>
		   </table>
		   </div>
	    </td>
	  </tr>
	  <tr>
			<td height="42" align="center" class="tab-body-bg bg-advance-bottom">
				<input type="submit" id="submitButton" name="submitButton" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;&nbsp;
				<input type="button" onclick="getA8Top().contentFrame.topFrame.backToPersonalSpace();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
			</td>
		</tr>
	</table>
</form>
</body>
</html>
<script>
initIe10AutoScroll('scrollListDiv',100);
</script>