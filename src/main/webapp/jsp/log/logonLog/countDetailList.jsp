<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="logHeader.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<title>Insert title here</title>
</head>
<body scroll="yes">
<form>
<fmt:message key="message.online.loginType" var="loginTypeTitle" bundle="${v3xMainI18N}" />
<div id="print" style="height: 100%">
<v3x:table data="${results}" var="result" htmlId="dd" isChangeTRColor="true" showHeader="true" showPager="true">
  <v3x:column width="25%" type="String" label="logon.stat.person" maxLength="40" >
				<c:set var="logMember" value="${v3x:getOrgEntity('Member', result[0]) }"/>
				<c:choose>
					<c:when test="${logMember == null }">
					${v3x:showMemberNameOnly(result[0]) }
					</c:when>
					<c:when test="${logMember.isDeleted}">
						<font color="gray"><s>${v3x:showMemberNameOnly(result[0]) }</s></font>
					</c:when>
					<c:otherwise>
						${v3x:showMemberNameOnly(result[0]) }
					</c:otherwise>
				</c:choose>
			  </v3x:column>
			 
			 
			  <v3x:column width="20%" label="所在部门" maxLength="40" type="String" value="${ v3x:getDepartment(v3x:getMember(result[0]).orgDepartmentId).name}"/>
							
 			<v3x:column width="20%" label="logon.org.post" type="String" maxLength="40" value="${v3x:showOrgPostNameByMemberid(result[0]) }" /> 
			  
			  <c:choose>
			    <c:when test="${ result[1]==null}">
			  	  <v3x:column width="25%" type="String" label="logon.search.lasLogonTime" maxLength="40" value="${v3x:_(pageContext,'logon.noLogRecord')}" />
			    </c:when>
			    <c:otherwise>
			      <v3x:column width="25%" type="String" label="logon.search.lasLogonTime" maxLength="40">
			      	<fmt:formatDate value="${result[1]}" type="both" pattern="yyyy-MM-dd HH:mm:ss"/>
			      </v3x:column>
			    </c:otherwise>
			  </c:choose>
			  <c:set value="${v3x:getMember(result[0])}" var="user"></c:set>
			  <c:choose>
			  	<c:when test="${user.state == 1}">
			  		<v3x:column width="10%" label="logon.search.user.state" type="String" maxLength="40" value="${v3x:_(pageContext,'logon.user.state.1')}" />
			  	</c:when>
			  	<c:otherwise>
			  		<v3x:column width="10%" label="logon.search.user.state" type="String" maxLength="40" value="${v3x:_(pageContext,'logon.user.state.2')}" />
			  	</c:otherwise>
			  </c:choose>
</v3x:table>
</div>
</form>
</body>
</html>