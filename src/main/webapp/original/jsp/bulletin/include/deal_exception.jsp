<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>


<script type="text/javascript">
	<c:if test="${_my_exception!=null}">
		<c:set var="key" value="${_my_exception.message}" />
		<c:if test="${key==null}">
			<c:set var="key" value="${_my_exception.errorCode}" />
		</c:if>
		alert(v3x.getMessage("bulletin.${key}"));
		<c:remove var="_my_exception" scope="session" />
	</c:if>
</script>