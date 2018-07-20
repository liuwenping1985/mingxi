<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<html>
<head>
<title>
	<c:if test="${bean.id!=null}"><fmt:message key='node.policy.shenhe' bundle="${v3xCommonI18N}" /></c:if><c:if test="${bean.id==null}"><fmt:message key='common.toolbar.new.label' bundle="${v3xCommonI18N}" /></c:if><fmt:message key="bul.data" />
</title>
<html:link renderURL="/bulData.do" var="bulDataURL" />
<%@ include file="../include/header.jsp" %>
</head>
	<c:choose>
	<c:when test="${needBreak!=null&&needBreak=='true'}">
	<frameset rows="10,*" cols="*" framespacing="0" frameborder="no" border="0" scrolling="no">
	  <%--分隔条--%>	
	  <frame noresize="noresize" src='<c:url value="/common/detail.jsp" />' scrolling="no">
	  <frameset  rows="*" cols="*,25%" framespacing="1" id="zy" name="zy">
	    <frame frameborder="no" src="${detailURL}?method=audit&id=${id}&description=left&needBreak=${needBreak}&spaceId=${param.spaceId}" name="detailMainFrame" id="detailMainFrame" scrolling="auto" />
	    <frame frameborder="no" src="${detailURL}?method=audit&id=${id}&description=right&needBreak=${needBreak}&spaceId=${param.spaceId}" name="detailRightFrame" scrolling="no" id="detailRightFrame" />
	  </frameset>
	</frameset>
	</c:when>
	<c:otherwise>
  <frameset  rows="*" cols="*,25%" framespacing="1" id="zy" name="zy">
    <frame frameborder="no" src="${detailURL}?method=audit&id=${id}&description=left&spaceId=${param.spaceId}" name="detailMainFrame" id="detailMainFrame" scrolling="no" />
    <frame frameborder="no" src="${detailURL}?method=audit&id=${id}&description=right&spaceId=${param.spaceId}" name="detailRightFrame" scrolling="no" id="detailRightFrame" />
  </frameset>
  </c:otherwise>
</c:choose>



<noframes><body scroll="no">
</body>
</noframes>
</html>