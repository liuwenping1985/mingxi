<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<html>
<head>
<title>123</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="header.jsp" %>
<script type="text/javascript">
function modify() {
  var id = getSelectIds(parent.listFrame);
  var ids = id.split(",");
  if (ids.size() == 2) {
    parent.detailFrame.location.href = "${ldapSynchron}?method=editUserMapper&id=" + ids[0];
  } else if (ids.size() > 2) {
    alert("ldap.alert.selectone");
    return false;
  } else {
    alert("ldap.alert.selectnone");
    return false;
  }
}
function showDetail(id, type, tframe) {
  tframe.location.href = "${ldapSynchron}?method=editUserMapper&id=" + id + "&oper=edit";
}
function impPost() {
  var sendResult = v3x.openWindow({
    url: "${ldapSynchron}?method=importLDIF",
    width: "390",
    height: "210",
    resizable: "false",
    scrollbars: "yes"
  });
  if (!sendResult) {
    return;
  } else {
    parent.detailFrame.location.href = "${ldapSynchron}?method=uploadReport&parseTime=" + sendResult;
  }
  //parent.detailFrame.location.href="${ldapSynchron}?method=importLDIF";
}
getA8Top().showLocation(null, "<fmt:message key='org.synchron.ldap' bundle='${ldaplocale}' />", "<fmt:message key='org.synchron.ldap.sub' bundle='${ldaplocale}'/>");</script>
</head>
<body>
<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="22"  style="border-top:1px #A4A4A4 solid">
			<script type="text/javascript">
				var _mode = parent.parent.WebFXMenuBar_mode || 'blue'; 
				var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />",_mode);
				myBar.add(new WebFXMenuButton("mod","<fmt:message key="common.toolbar.update.label" bundle='${v3xCommonI18N}'/>","modify()","<c:url value='/common/images/toolbar/update.gif'/>","", null));
				myBar.add(new WebFXMenuButton("mod","<fmt:message key="org.synchron.ldap.batoperation" bundle='${ldaplocale}'/>","impPost()","<c:url value='/common/images/toolbar/update.gif'/>","", null));
				document.write(myBar);
		    	document.close();
	    	</script>
	    </td>
	    	<td id="grayTd" class="webfx-menu-bar"  style="border-top:1px #A4A4A4 solid">
	    	<form action="${ldapSynchron}?method=query" name="searchForm" id="searchForm" method="post" style="margin: 0px">
			<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources"/>
			<div class="div-float-right">
				<div class="div-float">
					<select name="condition" id="condition" onChange="showNextCondition(this)" class="condition">
					    <option value=""><fmt:message key="member.list.find"/></option>
					    <option value="loginName"><fmt:message key="member.list.find.login"/></option>
				  	</select>
			  	</div>
	
			  	<div id="loginNameDiv" class="div-float hidden">
					<input type="text" name="textfield" class="textfield"  onkeydown="javascript:if(event.keyCode==13)doSearch();">
				</div>				  	
		
			  	<div id="grayButton" onclick="javascript:doSearch()" class="condition-search-button"></div>
		  	</div>
		  	</form>
		</td>    		
	</tr>
	
	
	<tr>
		<td colspan="2">
		<div class="scrollList">
		<form id="userMapperForm" method="post">
			<v3x:table htmlId="userMapperlist" data="userMapperList" var="member"  showHeader="true" >
			<c:set var="click" value="showDetail('${member.v3xOrgMember.id}','Member',parent.detailFrame)"/>
			<c:set var="dbclick" value="modify();"/>
			<c:set var="status" value=""/>
				<c:if test="${member.v3xOrgMember.state == 2}">
					<c:set var="status" value="(<fmt:message key='org.synchron.disable' bundle='${ldaplocale}'/>)"/>
				</c:if>
				<c:if test="${member.v3xOrgMember.state == 3}">
					<c:set var="status" value="(<fmt:message key='org.synchron.disable' bundle='${ldaplocale}'/>)"/>
				</c:if>	
				<v3x:column width="4%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
					<input type="checkbox" name="id" value="${member.v3xOrgMember.id}" isInternal="${member.v3xOrgMember.isInternal}">
				</v3x:column>
				<v3x:column width="10%" align="left" label="org.member_form.name.label" type="String"
					value="${member.v3xOrgMember.name}${status}" className="cursor-hand sort" 
					maxLength="10"  symbol="..." alt="${member.v3xOrgMember.name}${status}" onClick="${click}" onDblClick="${dbclick }">
					</v3x:column>
				<v3x:column width="10%" align="left" label="org.member_form.loginName.label" type="String"
					value="${member.v3xOrgMember.loginName}" className="cursor-hand sort" 
					maxLength="10"  symbol="..." alt="${member.v3xOrgMember.loginName}" onClick="${click}" onDblClick="${dbclick }"/>
				<v3x:column width="10%" align="center" label="common.sort.label" type="Number"
					alt="${member.v3xOrgMember.sortId}" value="${member.v3xOrgMember.sortId}" className="cursor-hand sort" onClick="${click}" onDblClick="${dbclick }"/>
				<v3x:column width="15%" align="left" label="org.member_form.deptName.label" type="String"
					value="${member.departmentName}" className="cursor-hand sort" 
					maxLength="15"  symbol="..." alt="${member.departmentName}" onClick="${click}" onDblClick="${dbclick }"/>
				<v3x:column width="20%" align="left" label="org.account_form.name.label" type="String"
					value="${member.accountName}" className="cursor-hand sort" 
					maxLength="20"  symbol="..." alt="${member.accountName}" onClick="${click}" onDblClick="${dbclick }"/>
			<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources"/>
				<v3x:column  width="10%" align="left" label="org.member_form.primaryPost.label" type="String"
					className="cursor-hand sort" maxLength="10" symbol="..." alt="${member.postName}" onClick="${click}" onDblClick="${dbclick }" value="${member.postName}" >
				</v3x:column>	
				<v3x:column width="10%" align="left" label="org.member_form.levelName.label" type="String"
					className="cursor-hand sort" maxLength="10"  symbol="..." alt="${member.levelName}" value="${member.levelName }" onClick="${click}" onDblClick="${dbclick }">
				</v3x:column>
				<fmt:setBundle basename="com.seeyon.v3x.plugin.ldap.resource.i18n.LDAPSynchronResources"/>
				<v3x:column width="15%" align="left" label="org.synchron.ldap.exloginname" type="String"
					value="${member.stateName}" className="cursor-hand sort" 
					maxLength="15"  symbol="..." alt="${member.stateName}" onClick="${click}" onDblClick="${dbclick }"/>
			</v3x:table>
		</form>
		</div>
		</td>
	</tr>
</table>
<script type="text/javascript">
<c:if test="${reload==null}">
showDetailPageBaseInfo("detailFrame", "<fmt:message key='org.synchron.ldap' bundle='${ldaplocale}'/>", "/common/images/detailBannner/41.gif", pageQueryMap.get('count'),v3x.getMessage("LDAPLang.detail_ldapmessage_110201"));	
</c:if>
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
</script>
</body>
</html>