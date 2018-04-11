<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/shortcut.js${v3x:resSuffix()}" />"></script>
<title>Insert title here</title>
<script type="text/javascript">
getA8Top().showLocation(801, "<fmt:message key='personalInfo.storeSpace.look'/>");
</script>
<link type="text/css" rel="stylesheet" href="<c:url value='/apps_res/v3xmain/css/storage.css${v3x:resSuffix()}' />">
<fmt:setBundle basename="com.seeyon.v3x.doc.resources.i18n.DocResource" var="docI18N"/>
</head>
<body scroll="no" class="padding5">
<form method="get" action="${mainURL}">
	<input type="hidden" name="method" value="updatePersonalInfo">
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	   <tr>
	      <td valign="bottom" height="26" class="tab-tag">
				<%@include file="../../sysMgr/settingCommon.jsp" %>
		  </td>
	  </tr>
	  <tr>
	    <td class="tab-body-bg" width="100%" align="center">
        <div class="scrollList">
        <table width="450" height="100%" align="center" border="0" cellpadding="0" cellspacing="0">
              <tr>
		        <td width="100%">
				<table class="manage-stat-2" width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr align="center">
					<td height="22" width="22%" colspan="5"  class="sorttd" align="left"><fmt:message key="doc.space.set.label" bundle="${docI18N}"/>(${vo.allTotal})</td>
			  	</tr>
				<tr align="center">
					<td height="22" width="22%"  class="sorttd"><fmt:message key="doc.space.name" bundle="${docI18N}"/></td>
					<td width="20%"  class="sorttd"><fmt:message key='doc.space.totalsize.label' bundle="${docI18N}" /></td>
					<td  class="sorttd"><fmt:message key='doc.space.usedsize.label' bundle="${docI18N}"/></td>
					<td width="20%"  class="sorttd"><fmt:message key='doc.space.freesize.label' bundle="${docI18N}"/></td>
					<td  class="sorttd"><fmt:message key='doc.space.percent' bundle="${docI18N}"/></td>
			  	</tr>
			  	<tbody>
				<tr align="center">
					<td class="sort"><fmt:message key='doc.space.doc.space' bundle="${docI18N}"/></td>					
					<td class="sort" align="right">${vo.total}</td>
					<td class="sort" align="right">${vo.used}</td>
					<td class="sort" align="right">${vo.docFree}</td>
					<td class="sort" align="right">${vo.docPercentStr}%</td>
			  	</tr>
			  	<tr align="center">
					<td class="sort"><fmt:message key='doc.space.mail.space' bundle="${docI18N}"/></td>					
					<td class="sort" align="right">${vo.mailTotal}</td>
					<td class="sort" align="right">${vo.mailUsed}</td>
					<td class="sort" align="right">${vo.mailFree}</td>
					<td class="sort" align="right">${vo.mailPercentStr}%</td>
			  	</tr>
			  	<c:if test="${v3x:isEnableSwitch('blog_enable') && vo.blogStatus ne 'doc.space.nonassigned'}">
			  	<tr align="center">
					<td class="sort"><fmt:message key='doc.space.blog.space' bundle="${docI18N}"/></td>					
					<td class="sort" align="right">${vo.blogTotal}</td>
					<td class="sort" align="right">${vo.blogUsed}</td>
					<td class="sort" align="right">${vo.blogFree}</td>
					<td class="sort" align="right">${vo.blogPercentStr}%</td>
			  	</tr>
			  	</c:if>
			  	</tbody>		  				  				  				  	
			</table>
		   </td>
		   </tr>
		   <tr><td height="100"></td></tr>
		   </table>
		   </div>
	    </td>
	  </tr>
	  <tr>
		<td height="42" align="center" class="tab-body-bg bg-advance-bottom">
			<input type="button" onclick="getA8Top().contentFrame.topFrame.backToPersonalSpace();" value="<fmt:message key='common.toolbar.back.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
		</tr>
	</table>
</form>
</body>
</html>