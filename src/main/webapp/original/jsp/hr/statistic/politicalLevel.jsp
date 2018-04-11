<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources" />
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
</head>
<body>
	<form id="statisticform" method="post">
		<v3x:table data="${ppLevels}" var="ppLevel" leastSize="${leastSize }" htmlId="ppLevel">
		
		<v3x:column  width="40%" label="hr.statistic.business.label" type="String"
			 value="${ppLevel.level}" className="sort"
			 symbol="..."
			></v3x:column>
		<v3x:column  width="30%" label="hr.staffInfo.position.label" type="String"
			  className="sort"
			 symbol="..."
			><fmt:message key="hr.staffInfo.position.${ppLevel.politicalPosition}" bundle="${v3xHRI18N}" /></v3x:column>
		<v3x:column  width="30%" label="hr.statistic.count.label" type="Number"
			value="${ppLevel.count}"  className="sort"
			 symbol="..."
			></v3x:column>
	</v3x:table>
	</form>
<script type="text/javascript">
showDetailPageBaseInfo("detailFrame", "<fmt:message key='hr.statistic.pp.business.label' bundle='${v3xHRI18N}'/>", [2,4], pageQueryMap.get('count'),  v3x.getMessage("HRLang.detail_hr_120605"));
showCtpLocation("F04_hrStatistic");
</script>
</body>
</html>
