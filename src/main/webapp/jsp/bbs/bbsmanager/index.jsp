<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<c:set value="${param.flag=='group'? v3x:suffix():''}" var="suffix"/>
<script type="text/javascript">
<%-- 
<c:if test="${param.where != 'space'}">
getA8Top().showLocation(2006,  "<fmt:message key='menu.${param.flag}.bbs.set${suffix}' bundle='${v3xMainI18N}'/>");
</c:if>
--%>
</script>
</head>
<body scroll="no" class="padding5">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	   <tr>
	      <td valign="bottom" height="26" class="tab-tag  ">
				<div class="div-float">
					<div class="tab-separator"></div>	
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel cursor-hand" onclick="javascript:location.href='<html:link renderURL='/bulType.do?method=bulletinManageIndex&flag=${param.flag}&spaceType=${param.spaceType}&spaceId=${param.spaceId}&where=${param.where}' />'">
						<fmt:message key='menu.${param.flag}.bulletin.set${suffix}' bundle="${v3xMainI18N}"/>
					</div>
					<div class="tab-tag-right"></div>

					<div class="tab-separator"></div>	
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel cursor-hand" onclick="javascript:location.href='<html:link renderURL='/inquiry.do?method=inquiryManageIndex&flag=${param.flag}&spaceType=${param.spaceType}&spaceId=${param.spaceId}&where=${param.where}' />'">
						<fmt:message key='menu.${param.flag}.inquiry.set${suffix}' bundle="${v3xMainI18N}"/>
					</div>
					<div class="tab-tag-right"></div>

					<div class="tab-separator"></div>	
					<div class="tab-tag-left-sel"></div>
					<div class="tab-tag-middel-sel cursor-hand" onclick="location.reload();">
						<fmt:message key='menu.${param.flag}.bbs.set${suffix}' bundle="${v3xMainI18N}"/>
					</div>
					<div class="tab-tag-right-sel"></div>
					
					<div class="tab-separator"></div>
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel cursor-hand" onclick="javascript:location.href='<html:link renderURL='/newsType.do?method=newsManageIndex&flag=${param.flag}&notIndex=true&spaceType=${param.spaceType}&spaceId=${param.spaceId}&where=${param.where}' />'">
					 	<fmt:message key='menu.${param.flag}.news.set${suffix}' bundle="${v3xMainI18N}"/>
					</div>
					<div class="tab-tag-right"></div>
					<div class="tab-separator"></div>
				</div>
		  </td>
	  </tr>
	  <tr>
	    <td valign="top" width="100%" height="100%" id="bbsIndexFrame"  align="center">
		    <iframe width="100%" height="100%" frameborder="0" src="${detailURL}?method=listBoard&spaceType=${param.spaceType}&spaceId=${param.spaceId}"></iframe>
		</td>
	</tr>
</table>
</body>		
</html>