<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
<!--
 	/*
 	设置frame中组织结构的菜单样式
 	如：organization/listTeam.jsp中,将通过下面方式调用：
		var _mode = parent.parent.WebFXMenuBar_mode || 'blue';
		var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />",_mode); 	
 	*/
	var WebFXMenuBar_mode = 'gray';
//-->
</script>
</head>
<body class="tab-body" scroll="no" onload="setDefaultTab(0);">

<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
  <td valign="bottom" height="33" class="tab-tag">
	<div class="tab-separator"></div>
	<div id="menuTabDiv" class="div-float">
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel" onclick="javascript:changeMenuTab(this);"  url="organization/account.do?method=viewAccount"><fmt:message key='hr.organization.account.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel" onclick="javascript:changeMenuTab(this);"  url="organization/department.do?method=showDepartmentFrame&style=tree"><fmt:message key='hr.organization.department.lebel' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>	
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel" onclick="javascript:changeMenuTab(this);"  url="organization/postController.do?method=showPostframe"><fmt:message key='hr.organization.post.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel" onclick="javascript:changeMenuTab(this);"  url="organization/levelController.do?method=showLevelframe">
			<!-- lijl Add choose GOV-1907 -->
			<c:choose>
				<c:when test ="${(v3x:getSysFlagByName('sys_isGovVer')=='true')}">
					<fmt:message key='hr.organization.duty.label.gov' bundle='${v3xHRI18N}'/>
				</c:when>
				<c:otherwise>
					<fmt:message key='hr.organization.duty.label' bundle='${v3xHRI18N}'/>					
				</c:otherwise>
			</c:choose>
		</div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>	
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel" onclick="javascript:changeMenuTab(this);"  url="organization/member.do?method=listByAccount"><fmt:message key='hr.organization.member.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>	
		<div class="tab-separator"></div>
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel" onclick="javascript:changeMenuTab(this);"  url="organization/teamController.do?method=showTeamframe"><fmt:message key='hr.organization.team.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>
		<c:if test="${v3x:getSysFlagByName('sys_isGroupVer')}">
		<div class="tab-separator"></div>
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel" onclick="javascript:changeMenuTab(this);"  url="organization/conPost.do"><fmt:message key='hr.organization.Plurality.label' bundle='${v3xHRI18N}'/></div>
		<div class="tab-tag-right"></div>
		</c:if>
		<div class="tab-separator"></div>
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel" onclick="javascript:changeMenuTab(this);"  url="organization/externalController.do?method=showExternalframe"><fmt:message key='org.member_form.type.out' /></div>	
        <div class="tab-tag-right"></div>
		<div class="tab-separator"></div>
			</div>
		</td>
  </tr>

<tr>
		<td class="tab-body-bg" style="margin: 0px;padding:0px;">
		<iframe noresize="noresize" frameborder="0" scrolling="no" id="detailIframe" name="detailIframe" style="height: 100%;overflow: hidden;"></iframe>			
		</td>
	</tr>
</table>
<script type="text/javascript">
showCtpLocation("F03_hrOrgMgr");
$(function(){
	$("#detailIframe").width($("body").width());
})
</script>
</body>
</html>

