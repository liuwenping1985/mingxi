<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ include file = "../../../hr/header.jsp" %>
<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources" />
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script type="text/javascript">
	parent.detailFrame.location.href="<c:url value='/common/detail.jsp?direction=Down'/>";
</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
</head>
<body>
      <input type="hidden" id="resultCount" value="${resultCount}" />
		<form id="recordform" name="recordform" method="post">
			<v3x:table data="${webRecords}" var="webRecord"  htmlId="recordlist" leastSize="${leastSize }">	
			
			<v3x:column width="15%" label="m1.lbs.attendance.record.name" onClick="${click}"
					value="${webRecord.belongUserName}" className="cursor-hand sort" symbol="..." alt="${webRecord.belongUserName}"
			></v3x:column>
			<v3x:column width="15%" label="m1.lbs.attendance.record.department" onClick="${click}"
					value="${webRecord.belongUserDeptmentName}" className="cursor-hand sort" symbol="..." alt="${webRecord.belongUserDeptmentName}"
			></v3x:column>
			<v3x:column width="15%" type="String"  label="m1.lbs.attendance.record.time" className="cursor-hand sort" onClick="${click}">
              <fmt:formatDate value="${webRecord.createDate}" type="both" dateStyle="full" pattern="yyyy-MM-dd HH:mm"  />
               	</v3x:column>
			<v3x:column width="30%" label="m1.lbs.attendance.record.address" onClick="${click}"
					value="${webRecord.lbsAddr}" className="cursor-hand sort" symbol="..." alt="${webRecord.lbsAddr}"></v3x:column>
			<v3x:column width="25%" label="m1.lbs.attendance.record.comment" onClick="${click}"
					value="${webRecord.lbsComment}" className="cursor-hand sort" symbol="..." alt="${webRecord.lbsComment}"></v3x:column>
			</v3x:table>
		</form>

</body>
</html>