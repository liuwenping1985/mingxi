<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>


<script type="text/javascript">
	<c:if test="${_my_exception!=null}">
		<c:set var="key" value="${_my_exception.message}" />
		<c:if test="${key==null}">
			<c:set var="key" value="${_my_exception.errorCode}" />
		</c:if>
		<c:set var="args" value="${_my_exception.errorArgs}" />
		<c:if test="${args==null || args==''}">
			alert(v3x.getMessage("meetingLang.${key}"));
		</c:if>
		
		<c:if test="${args!=null && args!=''}">
			alert(v3x.getMessage("meetingLang.${key}","${args[0]}"));
		</c:if>
		
		<c:remove var="_my_exception" scope="session" />
	</c:if>
</script>