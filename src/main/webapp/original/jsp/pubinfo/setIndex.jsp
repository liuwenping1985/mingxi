<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/INC/noCache.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<c:url value='/common/css/default.css${v3x:resSuffix()}' />">
${v3x:skin()}
<link rel="stylesheet" href="/seeyon/skin/default/skin.css${v3x:resSuffix()}">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}"/>"></script>
<title>Insert title here</title>
<c:set value="${param.flag=='group'? v3x:suffix():''}" var="suffix"/>
<script type="text/javascript">
	var v3x = new V3X();
	v3x.init("<c:out value='${pageContext.request.contextPath}' />","${v3x:getLanguage(pageContext.request)}");
</script>
</head>
<body scroll="no" class="padding5" onload="setDefaultTab(0);">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	   <tr>
	      <td valign="bottom" height="26" class="tab-tag">
	      		<div class="tab-separator"></div>
				<div id="menuTabDiv" class="div-float">
				<c:if test="${v3x:hasPlugin('bulletin')}">
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel" onclick="javascript:changeMenuTab(this);" url="${pageContext.request.contextPath}/bulType.do?method=listMain&flag=${param.flag}&spaceType=${param.spaceType}&spaceId=${param.spaceId}&where=${param.where}">
						<fmt:message key='menu.${param.flag}.bulletin.set${suffix}'/>
					</div>
					<div class="tab-tag-right"></div>
					<div class="tab-separator"></div>
				</c:if>
				<c:if test="${v3x:hasPlugin('inquiry')}">
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel" onclick="javascript:changeMenuTab(this);" url="${pageContext.request.contextPath}/inquiry.do?method=inquiryFrame&flag=${param.flag}&spaceType=${param.spaceType}&spaceId=${param.spaceId}&where=${param.where}">
						<fmt:message key='menu.${param.flag}.inquiry.set${suffix}'/>
					</div>
					<div class="tab-tag-right"></div>
					<div class="tab-separator"></div>
				</c:if>
				<c:if test="${v3x:hasPlugin('bbs')}">
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel" onclick="javascript:changeMenuTab(this);" url="${pageContext.request.contextPath}/bbs.do?method=listBoard&flag=${param.flag}&spaceType=${param.spaceType}&spaceId=${param.spaceId}&where=${param.where}">
						<fmt:message key='menu.${param.flag}.bbs.set${suffix}'/>
					</div>
					<div class="tab-tag-right"></div>
					<div class="tab-separator"></div>
				</c:if>
				<c:if test="${v3x:hasPlugin('news')}">
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel" onclick="javascript:changeMenuTab(this);" url="${pageContext.request.contextPath}/newsType.do?method=listMain&flag=${param.flag}&spaceType=${param.spaceType}&spaceId=${param.spaceId}&where=${param.where}">
					 	<fmt:message key='menu.${param.flag}.news.set${suffix}'/>
					</div>
					 <div class="tab-tag-right"></div>
                    <div class="tab-separator"></div>
				</c:if>
				</div>
		  </td>
	  </tr>
	  <tr>
	    <td valign="top" width="100%" height="100%" align="center">
		    <iframe width="100%" height="100%" id="detailIframe" frameborder="0" src="" />
		</td>
	</tr>
</table>
</body>		
</html>