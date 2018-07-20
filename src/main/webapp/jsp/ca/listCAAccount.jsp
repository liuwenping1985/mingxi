<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@page import="java.util.Properties"%>
<html>
<head>
<title>成员列表</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<%@include file="caaccountHeader.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<script type="text/javascript">
function editOrViewMember(operationType ,memberId){
	parent.detailFrame.location.href = "${caacountURL}?method=showAddOrEditCAAccount&operationType="+ operationType +"&memberId=" + memberId;
}

</script>
</head>
<body >
<div class="main_div_center">
<div class="right_div_center">
<div class="center_div_center" id="scrollListDiv">
<input type="hidden" value="${condition}" id="condition" name="condition">
<input type="hidden" value="${textfield}" id="textfield" name="textfield">
	<form id="accountform" name="accountform" method="post" >
	<fmt:message key="org.entity.disabled" var="orgDisabled"/>
	<fmt:message key="org.entity.deleted" var="orgDeleted"/>
	<fmt:message key="org.entity.transfered" var="orgTransfered"/>
		<v3x:table htmlId="webCAAccountVolist" data="webCAAccountVolist" var="webCAAccountVo" className="sort ellipsis">
			<c:set var="click" value="editOrViewMember('view' ,'${webCAAccountVo.webV3xOrgMember.v3xOrgMember.id}')"/>
			<c:set var="dbclick" value="editOrViewMember('edit' ,'${webCAAccountVo.webV3xOrgMember.v3xOrgMember.id}')"/>
			<v3x:column width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
				<input type="checkbox" name="id" id="${webCAAccountVo.webV3xOrgMember.v3xOrgMember.id}" value="${webCAAccountVo.webV3xOrgMember.v3xOrgMember.id}" isInternal="${webCAAccountVo.webV3xOrgMember.v3xOrgMember.isInternal}" 
				st="${webCAAccountVo.caAccount.caState}" na="${webCAAccountVo.webV3xOrgMember.v3xOrgMember.name}"/>
			</v3x:column>
			<v3x:column width="10%" align="left" label="org.member_form.name.label" type="String"
				value="${webCAAccountVo.webV3xOrgMember.v3xOrgMember.name}" className="cursor-hand sort" 
				alt="${webCAAccountVo.webV3xOrgMember.v3xOrgMember.name}" onClick="${click}" onDblClick="${dbclick }"/>
			<v3x:column width="15%" align="left" label="org.member_form.loginName.label" type="String"
				className="cursor-hand sort" alt="${webCAAccountVo.webV3xOrgMember.v3xOrgMember.loginName}" onClick="${click}" onDblClick="${dbclick }">
				<c:out value='${webCAAccountVo.webV3xOrgMember.v3xOrgMember.loginName}' escapeXml='true'/><c:if test="${webCAAccountVo.webV3xOrgMember.stateName!=''&& webCAAccountVo.webV3xOrgMember.stateName!=null}">&nbsp;<img style="vertical-align:middle;" src="<c:url value='/common/images/ldapbinding.gif' />" alt="<fmt:message key='ldap.user.prompt' bundle='${ldaplocale}'><fmt:param value='${webCAAccountVo.webV3xOrgMember.stateName}'></fmt:param></fmt:message>"/></c:if>
			</v3x:column>
			<v3x:column width="15%" align="left" label="ca.keyNum.label" type="String"
				value="${webCAAccountVo.caAccount.keyNum}" className="cursor-hand sort" 
				alt="${webCAAccountVo.caAccount.keyNum}" onClick="${click}" onDblClick="${dbclick }"/>
			<v3x:column width="10%" align="left" label="level.select.state" className="cursor-hand sort" 
				onClick="${click}" onDblClick="${dbclick}">
				<c:choose>
 				<c:when test="${webCAAccountVo.caAccount.caState}">
 					<fmt:message key="edoc.element.enabled" bundle='${v3xEdocI18N}'/>
 				</c:when>
 				<c:otherwise>
 					<fmt:message key="edoc.element.disabled" bundle='${v3xEdocI18N}'/>
 				</c:otherwise>
 				</c:choose>
 			</v3x:column>
 			<v3x:column width="10%" align="left" label="ca.mustUseCA.label" type="String" className="cursor-hand sort"  
				onClick="${click}" onDblClick="${dbclick }">
				<c:choose>
 				<c:when test="${webCAAccountVo.caAccount.caEnable}">
 					<fmt:message key="org.account_form.isRoot.yes"/>
 				</c:when>
 				<c:otherwise>
 					<fmt:message key="org.account_form.isRoot.no"/>
 				</c:otherwise>
 				</c:choose>
			</v3x:column>
			<v3x:column width="15%" align="left" label="ca.mobile.label" type="String" className="cursor-hand sort"  
				onClick="${click}" onDblClick="${dbclick }">
				<c:choose>
 				<c:when test="${webCAAccountVo.caAccount.mobileEnable}">
 					<fmt:message key="org.account_form.isRoot.yes"/>
 				</c:when>
 				<c:otherwise>
 					<fmt:message key="org.account_form.isRoot.no"/>
 				</c:otherwise>
 				</c:choose>
			</v3x:column>
			<v3x:column width="10%" align="left" label="org.member_form.deptName.label" type="String"
				value="${webCAAccountVo.webV3xOrgMember.departmentName}" className="cursor-hand sort" 
				alt="${webCAAccountVo.webV3xOrgMember.departmentName}" onClick="${click}" onDblClick="${dbclick }"/>
			<v3x:column width="10%" align="left" label="org.member_form.account" type="String"
				value="${webCAAccountVo.webV3xOrgMember.accountName}" className="cursor-hand sort" 
				alt="${webCAAccountVo.webV3xOrgMember.accountName}" onClick="${click}" onDblClick="${dbclick }"/>
		</v3x:table>
	</form>
</div>
</div>
</div>
<div id="elementIds" style="display:none"></div>
<script type="text/javascript">
<!--
showDetailPageBaseInfo("detailFrame", "<fmt:message key='ca.account.binding'/>", [3,1], pageQueryMap.get('count'), _("CAAccountLong.ca_options_description"));	
//-->
</script>
</body>
</html>