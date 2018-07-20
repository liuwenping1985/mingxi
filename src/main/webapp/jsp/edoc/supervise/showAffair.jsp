<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../edocHeader.jsp" %>
<title>Insert title here</title>
</head>
<body>
<form>
<v3x:table data="${models}" var="model" htmlId="" isChangeTRColor="true" showHeader="true" showPager="true"  pageSize="10">
  <v3x:column width="15%" label="col.supervise.dealUser" maxLength="40" value="${v3x:showMemberName(model.dealUser)  }" className="sort deadline-${model.overTime }"/>
  <v3x:column width="15%" label="node.policy" maxLength="40" value="${model.policyName  }"  className="sort deadline-${model.overTime }"/>
  <v3x:column width="15%" label="col.supervise.receiveTime" alt="${model.reveiveDate }" maxLength="40" className="sort deadline-${model.overTime }">
  	<fmt:formatDate value="${model.reveiveDate}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>
  </v3x:column>
  <v3x:column width="15%" label="col.time.sign.label" alt="${model.dealDate }" maxLength="40" className="sort deadline-${model.overTime }">
  	<fmt:formatDate value="${model.dealDate}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>
  </v3x:column>
  <v3x:column width="15%" label="col.supervise.dealDays" maxLength="10" value="${model.dealDays }"  className="sort deadline-${model.overTime }"/>
  <v3x:column width="15%" label="col.metadata_item.process.date" maxLength="40"  className="sort deadline-${model.overTime }">
  	<fmt:message key="${model.dealLine }"/>
  </v3x:column>
  <v3x:column width="5%" label="node.isovertoptime" maxLength="40" value="${model.efficiency}"  className="sort deadline-${model.overTime }"/>
  <v3x:column width="5%" label="hasten.number.label" maxLength="40" value="${model.hastened}"  className="sort deadline-${model.overTime }"/>
</v3x:table>
</form>
</body>
</html>