<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/shortcut.js${v3x:resSuffix()}" />"></script>
<title>Insert title here</title>
<link type="text/css" rel="stylesheet" href="<c:url value='/apps_res/v3xmain/css/storage.css${v3x:resSuffix()}' />">
<fmt:setBundle basename="com.seeyon.apps.doc.resources.i18n.DocResource" var="docI18N"/>
	<style>
	TD.sort{
		border-bottom-color:#d2d2d2;
		text-align:center;
	}
	.headSorttd{
		color:white;
	}
	.headBody{
		border-left:1px #d2d2d2 solid;
		border-top:1px #d2d2d2 solid;
		border-bottom:none;
		border-right:none;
	}
	</style>
</head> 
<body scroll="no" class="padding5" style="backgroud-color:#fafafa;">
<form method="get" action="${mainURL}">
	<input type="hidden" name="method" value="updatePersonalInfo">
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td class="tab-body-bg" style="border-width: 0px;padding: 0;" width="100%" align="center">
        <div class="scrollList">
        <table width="450" height="90%" align="center" border="0" cellpadding="0" cellspacing="0">
              <tr>
		        <td width="100%">
				<table class="border_all headBody" width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr height="33" align="center">
					<td height="22" width="22%" colspan="5"  class="sorttd" align="left"><fmt:message key="doc.space.set.label" bundle="${docI18N}"/>(${vo.allTotal})</td>
			  	</tr>
				<tr height="33" align="center" style="background-color: #7facd2">
					<td height="22" width="22%"  class="sorttd headSorttd"><fmt:message key="doc.space.name" bundle="${docI18N}"/></td>
					<td width="20%"  class="sorttd headSorttd"><fmt:message key='doc.space.totalsize.label' bundle="${docI18N}" /></td>
					<td  class="sorttd headSorttd"><fmt:message key='doc.space.usedsize.label' bundle="${docI18N}"/></td>
					<td width="20%"  class="sorttd headSorttd"><fmt:message key='doc.space.freesize.label' bundle="${docI18N}"/></td>
					<td  class="sorttd headSorttd"><fmt:message key='doc.space.percent' bundle="${docI18N}"/></td>
			  	</tr>
			  	<tbody>
                <c:if test="${v3x:hasPlugin('doc')}">
				<tr height="33" align="center">
					<td class="sort sorttd"><fmt:message key='doc.space.doc.space' bundle="${docI18N}"/></td>					
					<td class="sort sorttd" align="right">${vo.total}</td>
					<td class="sort sorttd" align="right">${vo.used}</td>
					<td class="sort sorttd" align="right">${vo.docFree}</td>
					<td class="sort sorttd" align="right">${vo.docPercentStr}%</td>
			  	</tr>
                </c:if>
			  	<c:if test="${v3x:hasPlugin('webmail')}">
			  	<tr height="33" align="center">
					<td class="sort sorttd"><fmt:message key='doc.space.mail.space' bundle="${docI18N}"/></td>					
					<td class="sort sorttd" align="right">${vo.mailTotal}</td>
					<td class="sort sorttd" align="right">${vo.mailUsed}</td>
					<td class="sort sorttd" align="right">${vo.mailFree}</td>
					<td class="sort sorttd" align="right">${vo.mailPercentStr}%</td>
			  	</tr>
			  	</c:if>
			  	<c:if test="${v3x:hasPlugin('blog') && v3x:isEnableSwitch('blog_enable')}">
			  	<tr height="33" align="center">
					<td class="sort sorttd"><fmt:message key='doc.space.blog.space' bundle="${docI18N}"/></td>					
					<td class="sort sorttd" align="right">${vo.blogTotal}</td>
					<td class="sort sorttd" align="right">${vo.blogUsed}</td>
					<td class="sort sorttd" align="right">${vo.blogFree}</td>
					<td class="sort sorttd" align="right">${vo.blogPercentStr}%</td>
			  	</tr>
			  	</c:if>
			  	</tbody>		  				  				  				  	
			</table>
		   </td>
		   </tr>
		   <%--<tr><td height="100"></td></tr>--%>
		   </table>
		   </div>
	    </td>
	  </tr>
	</table>
</form>
</body>
</html>