<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/shortcut.js${v3x:resSuffix()}" />"></script>
<title>Insert title here</title>
<script type="text/javascript">
getA8Top().showLocation(801,"<fmt:message key='shortcut.set.title'/>");
function updateShortcut(isUpdateShortcut, isUpdateTools){
	if(isUpdateShortcut == "true"){
		var str = "";
		str += "<table width='100%' border='0' cellspacing='0' cellpadding='0'>";
		<c:forEach items="${shortcutMenus}" var="menu">
			var shortcutLabel = "${v3x:_(pageContext, menu.name)}";
			str += "<tr>";
			str += "<td height='35'>";
			str += "<div class='leftMenu' title='" + shortcutLabel + "' onmouseover=\"this.className='leftMenuCursor'\" onmouseout=\"this.className='leftMenu'\" onclick=\"openURL('<html:link renderURL='${menu.action}'/>')\">";
			str += "<span class='myshortcut${menu.id}'></span>";
			str += "<span class='myshortcuttext'>&nbsp;" + shortcutLabel.getLimitLength(getA8Top().contentFrame.leftFrame.maxMenuNameLength) + "</span>";
			str += "</div>";
			str += "</td>";
			str += "</tr>";
		</c:forEach>
		str += "</div>";
		getA8Top().contentFrame.leftFrame.document.getElementById("toolsPaneDiv").innerHTML = str;
	}
	/*
	if(isUpdateTools == "true"){
		var str = "<table cellpadding='0' cellspacing='0' width='100%' height='100%'>";
    	<c:forEach items="${toolsMenus}" var="tools">
    		var toolLabel = '<fmt:message key="${tools.name}"/>';
			str += "<tr>";
			str += "<td height='35' style='padding: 0 7px;'>";

			str += "<div class='leftMenu' title='" + toolLabel + "' onmouseover=\"this.className='leftMenuCursor'\" onmouseout=\"this.className='leftMenu'\" onclick=\"mergeSpaceLink('<html:link renderURL="${tools.action}"/>')\">";
			str += "<span class='toolIcon${tools.id}'></span>";
			str += "<span class='myshortcuttext'>&nbsp;" + toolLabel + "</span>";
			str += "</div>";
			
			str += "</td>";
			str += "</tr>";
		</c:forEach>
		str += "</table>";
		getA8Top().contentFrame.leftFrame.document.getElementById("toolsPaneDiv").innerHTML = str;
	}
	*/
}
</script>
</head>
<body scroll="no" class="padding5" onload="updateShortcut('${param.updateShortcut}','${param.updateTools}');">
<c:set var="hasAddress" value="${v3x:hasMenu(1006)}"/>
<form method="get" action="${mainURL}" onsubmit="shortcutAndToolsSetOk()">
	<input type="hidden" name="method" value="updateShortcutSet">
	<input type="hidden" name="shortcutId" id="shortcutId" value="${shortcut.id}">
	<input type="hidden" name="shortcutSetStr" id="shortcutSetStr" value="${shortcut.shortcutSet}">
	<input type="hidden" name="toolsSetStr" id="toolsSetStr" value="${shortcut.toolsSet}">
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	      <td valign="bottom" height="26" class="tab-tag">
				<%@include file="../../sysMgr/settingCommon.jsp" %>
		  </td>
	  </tr>
	  <tr>
	    <td width="100%" class="tab-body-bg" align="center">
        <div class="scrollList">
	    	<table width="430" height="100%" align="center" border="0" cellpadding="0" cellspacing="0">
              <tr>
		        <td width="100%" align="center">
				 <fieldset style="padding:6px;">
			     	<legend><fmt:message key="personalSetting.shortcut.label"/>:</legend>
			            <table width="100%" height="100%" align="center" border="0" cellpadding="0" cellspacing="0">
			              <tr>
					        <td width="150" height="28" align="center">
					        	<b><fmt:message key="shortcut.all.label"/></b>
					        </td>
					        <td width="30">&nbsp;</td>
					        <td width="150" align="center" >
					        	<b><fmt:message key="selectPeople.selected.label"/></b>
					         </td>
					         <td width="30">&nbsp;</td>
					     </tr>
					     <tr>
					         <td align="center">
					            <select name="shortcutSourceSelect" size="20" id="shortcutSourceSelect" multiple style="width:170px;" ondblclick="addThisItem('shortcut')">
							      <c:forEach items="${allShortcutMenus}" var="menu">
							      	<c:if test="${!v3x:containInCollection(shortcutMenus, menu) && (menu.id != '4' || hasAddress)}">
							        <option value="${menu.id}">${v3x:_(pageContext, menu.name)}</option>
							        </c:if>
							      </c:forEach>
							    </select>
					         </td>
					         <td align="center">
				         		<p><img alt="<fmt:message key='selectPeople.alt.select'/>" src="<c:url value="/common/images/arrow_a.gif"/>" width="15"
										height="12" class="cursor-hand" onClick="addThisItem('shortcut')"></p>
										<br>
								<p><img alt="<fmt:message key='selectPeople.alt.unselect'/>" src="<c:url value="/common/images/arrow_del.gif"/>" width="15"
										height="12" class="cursor-hand" onClick="removeThisItem('shortcut')"></p>
					         </td>
					         <td align="center">
							    <select name="shortcutTargetSelect" size="20" id="shortcutTargetSelect" multiple style="width:170px;" ondblclick="removeThisItem('shortcut')">
							      <c:forEach items="${shortcutMenus}" var="shortcut">
							      <c:if test="${shortcut.id != '4' || hasAddress}">
							        <option value="${shortcut.id}">${v3x:_(pageContext, shortcut.name)}</option>
							      </c:if>
							      </c:forEach>
							    </select>
					         </td>
					         <td align="center">
				         		<p><img alt="<fmt:message key='selectPeople.alt.up'/>" src="<c:url value="/common/images/arrow_u.gif"/>" width="12"
										height="15" class="cursor-hand" onClick="moveUp('shortcut')"></p>
										<br>
								<p><img alt="<fmt:message key='selectPeople.alt.down'/>" src="<c:url value="/common/images/arrow_d.gif"/>" width="12"
										height="15" class="cursor-hand" onClick="moveDown('shortcut')"></p>
					         </td>
					     </tr>
					     <tr>
					     <td>&nbsp;</td>
					     </tr>
			        </table>
			   </fieldset>
			   <br>
			   <%----
		   	   <fieldset style="height:200px; padding:6px;">
		     	<legend><fmt:message key="personalSetting.tools.label"/>:</legend>
		     	 <table width="100%" height="100%" align="center" border="0" cellpadding="0" cellspacing="0">
		              <tr>
				        <td width="150" height="28" align="center">
				        	<b><fmt:message key="shortcut.all.label"/></b>
				        </td>
				        <td width="30">&nbsp;</td>
				        <td width="150" align="center" >
				        	<b><fmt:message key="selectPeople.selected.label"/></b>
				         </td>
				         <td width="30">&nbsp;</td>
				     </tr>
		              <tr>
				        <td align="center">
						    <select name="toolsSourceSelect" size="8" id="toolsSourceSelect" multiple style="width:170px;" ondblclick="addThisItem('tools')">
								<c:forEach items="${allToolsMenus}" var="toolMenu">
									<c:if test="${!v3x:containInCollection(toolsMenus, toolMenu)}">
								    <option value="${toolMenu.id}"><fmt:message key="${toolMenu.name}"/></option>
								    </c:if>
								</c:forEach>
						    </select>
				        </td>
				        <td align="center">
			         		<p><img alt="<fmt:message key='selectPeople.alt.select'/>" src="<c:url value="/common/images/arrow_a.gif"/>" width="15"
									height="12" class="cursor-hand" onClick="addThisItem('tools')"></p>
							<p><img alt="<fmt:message key='selectPeople.alt.unselect'/>" src="<c:url value="/common/images/arrow_del.gif"/>" width="15"
									height="12" class="cursor-hand" onClick="removeThisItem('tools')"></p>
						</td>
				        <td align="center">
						    <select name="toolsTargetSelect" size="8" id="toolsTargetSelect" multiple style="width:170px;" ondblclick="removeThisItem('tools')">
								<c:forEach items="${toolsMenus}" var="toolsMenu">
								        <option value="${toolsMenu.id}"><fmt:message key="${toolsMenu.name}"/></option>
								</c:forEach>
						    </select>
				        </td>
				        <td align="center">
			         		<p><img alt="<fmt:message key='selectPeople.alt.up'/>" src="<c:url value="/common/images/arrow_u.gif"/>" width="12"
									height="15" class="cursor-hand" onClick="moveUp('tools')"></p>
							<p><img alt="<fmt:message key='selectPeople.alt.down'/>" src="<c:url value="/common/images/arrow_d.gif"/>" width="12"
									height="15" class="cursor-hand" onClick="moveDown('tools')"></p>
						</td>
				     </tr>
					</table>
		     </fieldset>
		     ---%>
		   </td>
		   </tr>
		   </table>
		   </div>
	    </td>
	  </tr>
	  <tr>
			<td height="42" align="center" class="tab-body-bg bg-advance-bottom">
				<input type="submit" id="submitButton" name="submitButton" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
				<input type="button" onclick="getA8Top().contentFrame.topFrame.backToPersonalSpace();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
			</td>
		</tr>
	</table>
</form>
</body>
</html>