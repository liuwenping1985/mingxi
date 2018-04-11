<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.Properties"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<html>
<head>
<title>List</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../header.jsp"%>
<script>
<!--
function view(id){
	parent.detailFrame.location.href = "${ipcontrolURL}?method=create&id=" + id + "&readonly=readonly";
} 
function modify(id,accountId){
	parent.detailFrame.location.href = "${ipcontrolURL}?method=create&id=" + id + "&accountId=" + accountId;
}
//-->
</script>
</head>
<body scroll="no">
<table height="100%" width="100%" border="0" cellspacing="0"
	cellpadding="0" style="">
	<tr>
		<td colspan="2">
		<div class="scrollList">
			<form id="ipform" name="ipform" method="post">
			<fmt:message key="org.account_form.name.label" bundle="${organizations}" var="account"></fmt:message>
				<v3x:table htmlId="ipcontrols" data="ipcontrols" var="ipcontrol" showHeader="true" className="sort ellipsis" >
					<c:set var="dbclick" value="modify('${ipcontrol.id}','${ipcontrol.accountId}');"/>	
					<c:set var="click" value="view('${ipcontrol.id}');"/>
					<c:choose>
						<c:when test="${v3x:currentUser().id!=ipcontrol.createUser && v3x:currentUser().administrator}">
							<c:set value="disabled" var="disabled" />
						</c:when>
						<c:otherwise>
							<c:set value="" var="disabled" />
						</c:otherwise>
					</c:choose>	
	                <v3x:column width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
						<input type='checkbox' name='id' id="${ipcontrol.id}" value="${ipcontrol.id}" ${disabled}/>
					</v3x:column>
					<v3x:column width="25%" align="left" label="common.name.label" type="String"
						alt="${ipcontrol.name}"
						className="cursor-hand sort" 
						onClick="${click}" value="${ipcontrol.name}" />
					<v3x:column width="25%" align="left" label="common.toolbar.auth.label" type="String"
						alt="${v3x:showOrgEntitiesOfTypeAndId(ipcontrol.users,pageContext) }"
						className="cursor-hand sort" 
						onClick="${click}">
						${v3x:showOrgEntitiesOfTypeAndId(ipcontrol.users,pageContext) }
					</v3x:column>
					<v3x:column width="20%" align="center" label="${account}" type="String"
					    alt="${v3x:showOrgEntitiesOfIds(ipcontrol.accountId,'Account', pageContext) }" className="cursor-hand sort" onClick="${click}">
					    ${v3x:showOrgEntitiesOfIds(ipcontrol.accountId,'Account', pageContext) }
					</v3x:column>
					<c:if test="${ipcontrol.type==0}">
						<v3x:column width="25%" align="center" label="common.type.label" type="String"
							alt='${ctp:i18n("system.ipcontrol.limit")}'
							className="cursor-hand sort" onClick="${click}">
								<fmt:message key="system.ipcontrol.limit" />
						</v3x:column>
					</c:if>
					<c:if test="${ipcontrol.type==1}">
						<v3x:column width="25%" align="center" label="common.type.label" type="String"
									alt='${ctp:i18n("system.ipcontrol.nolimit")}'
									className="cursor-hand sort" onClick="${click}">
							<fmt:message key="system.ipcontrol.nolimit" />
						</v3x:column>
					</c:if>
					<c:if test="${ipcontrol.type==2}">
						<v3x:column width="25%" align="center" label="common.type.label" type="String"
									alt='${ctp:i18n("system.ipcontrol.black")}'
									className="cursor-hand sort" onClick="${click}">
							<fmt:message key="system.ipcontrol.black" />
						</v3x:column>
					</c:if>
				</v3x:table>
			</form>
		</div>
		</td>
	</tr>
</table>
<script type="text/javascript">
	var item;
	var content;
	<c:if test="${v3x:currentUser().groupAdmin}">
	item = 2003;
	content = _("sysMgrLang.detail_info_1489");
	</c:if>
	<c:if test="${v3x:currentUser().administrator}">
	item = 3311;
	content = _("sysMgrLang.detail_info_1488");
	</c:if>
	showDetailPageBaseInfo("detailFrame", "${v3x:messageFromResource('com.seeyon.v3x.main.resources.i18n.MainResources', 'menu.common.accesscontrol.setting')}", [2,1], pageQueryMap.get('count'), content);	
	<c:if test="${ctp:hasRoleName('GroupAdmin') == true}">
		 showCtpLocation("F13_groupIpcontrol");
		 
	</c:if>
	<c:if test="${ctp:hasRoleName('AccountAdministrator') == true}">
		 showCtpLocation("F13_unitIpcontrol"); 
	</c:if>
	
</script>
</body>
</html>