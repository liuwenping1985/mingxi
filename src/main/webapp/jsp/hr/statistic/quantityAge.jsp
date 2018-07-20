<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="../header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources" />
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
</head>
<body scroll="no">
	<form id="statisticform" method="post">
		<v3x:table data="${quantityAges}" var="quantityAge" leastSize="${leastSize }" className="sort ellipsis" htmlId="quantityDep">
		
		<v3x:column  width="50%" label="hr.statistic.age.distributing.label" type="String"
			  className="sort"
			 symbol="..."
			><fmt:message key="${quantityAge.ageLevel}" bundle="${v3xHRI18N}" /></v3x:column>
		<v3x:column  width="50%" label="hr.statistic.count.label" type="Number"
			value="${quantityAge.count}"  className="sort"
			 symbol="..."
			></v3x:column>
	</v3x:table>
	</form>
<script type="text/javascript">
showCtpLocation("F04_hrStatistic");
</script>
</body>
</html>
