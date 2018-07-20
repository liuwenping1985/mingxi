<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="header.jsp"%>
<html:link renderURL="/main.do" var="mainURL" psml="default-page.psml" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
function loadDefaultTab(){
	if("${isSpace}" == "true"){
		changeMenuTab(document.getElementById("spaceTab"));
	} else {
		setDefaultTab("${isRelateOrDept == 'relate' ? '0' : '1'}");
	}
}
</script>
</head>
<body scroll="no" onLoad="loadDefaultTab();">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
	<tr class="page2-header-line">
		<td width="100%" height="41" valign="top" class="page-list-border-LRD gov_noborder gov_border_bottom">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     <tr class="page2-header-line">
		        <td width="45" class="page2-header-img"><div class="relateMore"></div></td>
		        <td class="page2-header-bg">
			        <c:choose>
			        	<c:when test="${isRelateOrDept == 'relate'}">
			        		<fmt:message key="relate.type.relatemember"/>
			        	</c:when>
			        	<c:when test="${isSpace}">
			        		${v3x:toHTML(space.spaceName)}
			        	</c:when>
			        	<c:otherwise>
			        		${v3x:toHTML(dept.name)}
			        	</c:otherwise>
			        </c:choose>
		        </td>
		        <td class="page2-header-line page2-header-link" align="right">
		        <c:if test="${isRelateOrDept == 'relate'}">
		        <a href="<html:link renderURL='/relateMember.do?method=relate'/>"><fmt:message key="relate.setmember"/></a>&nbsp;&nbsp;
		        </c:if>
		        </td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td valign="bottom" height="26" class="tab-tag gov_noborder" style="padding-left: 10px;border-top: 1px solid #b6b6b6;border-bottom: 1px solid #b6b6b6;">
			<div class="tab-separator"></div>
			<div class="div-float" id="menuTabDiv">
			<c:if test="${!isSpace}">
				<div class="tab-tag-left"></div>
				 
				<div class="tab-tag-middel" style="border-bottom:0;" onClick="javascript:changeMenuTab(this);"
					url="${relateURL}?method=relate&oper=more&fragmentId=${param.fragmentId}&ordinal=${param.ordinal}&panelValue=${param.panelValue}"><fmt:message key="relate.type.relatemember"/></div>
				
				<div class="tab-tag-right"></div>
				
				<div class="tab-separator"></div>
			</c:if>
				<div class="tab-tag-left"></div>
				
				<c:choose>
		        	<c:when test="${isSpace}">
		        		<div class="tab-tag-middel" style="border-bottom:0;" onClick="javascript:changeMenuTab(this);" id="spaceTab"
						url="${relateURL}?method=departmentSpaceMore&spaceId=${space.id}">${v3x:toHTML(space.spaceName)}</div>
		        	</c:when>
		        	<c:otherwise>
		        		<div class="tab-tag-middel" style="border-bottom:0;" onClick="javascript:changeMenuTab(this);"
						url="${relateURL}?method=departmentSpaceMore&departmentId=${dept.id}">${v3x:toHTML(dept.name)}</div>
		        	</c:otherwise>
			    </c:choose>
				<div class="tab-tag-right"></div>
				<div class="tab-separator"></div>
			</div>
		</td>
	</tr>
	<tr>
		<td>
			<iframe frameborder="0" src="" id="detailIframe" name="detailIframe" width="100%" height="100%" scrolling="auto"></iframe>
		</td>
	</tr>
</table>
</body>
</html>
