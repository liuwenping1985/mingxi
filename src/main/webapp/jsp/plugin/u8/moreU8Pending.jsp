<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@include file="header.jsp"%>
    <link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
</head>
<script type="text/javascript">
	getA8Top().showMoreSectionLocation("<fmt:message key='u8.schedule.pending.label'/>");
</script>
<body srcoll="no" style="overflow: hidden">
    <div class="center_div_row2" id="scrollListDiv">
		<form name="listForm" id="listForm" method="post">  
			<v3x:table htmlId="ncPendingTable" showPager="true" data="U8Pendings" var="p" className="sort ellipsis">
				<v3x:column width="50%" type="String" label="common.subject.label" value="${p.title}" alt="${p.title}"
					 className="cursor-hand sort"/>
				<v3x:column width="9%" type="Date" label="common.date.sendtime.label">
					<fmt:formatDate value="${p.sendeDate}" pattern="${datePattern}"/>
				</v3x:column>
				<v3x:column width="14%" type="Date" label="u8.schedule.time.label">
					<fmt:formatDate value="${p.receiveDate}" pattern="${datePattern}"/>
				</v3x:column>
				<v3x:column width="9%" type="String" label="u8.schedule.days.label" value="${p.dateLine}天" />
				<v3x:column width="9%" type="String" label="common.sender.label" value="${p.senderName}" />

				<v3x:column width="9%" type="String" label="common.type.label" value="${p.type}" />
			</v3x:table>
		</form>
    </div>
</body>
</html>
<script>
	//设置数据显示div的px高度
	initIe10AutoScroll("scrollListDiv",40);
</script>