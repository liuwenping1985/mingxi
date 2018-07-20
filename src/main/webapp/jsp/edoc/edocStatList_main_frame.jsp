<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="edocHeader.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html:link renderURL="/edocWorkManage.do" var="edocWorkManageUrl" />
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<frameset  rows="*" cols="100%" frameBorder="1"  frameSpacing="5" bordercolor="#ececec">
	
	<!-- 列表 -->
	<frameset rows="100%" id='sx' cols="*" framespacing="3" frameborder="no" border="0">
		<frame frameborder="no" src="${edocWorkManageUrl}?method=${listMethod}&user_id=${param.user_id}&reportName=${param.reportName}&state=${param.state}&start_time=${param.start_time}&end_time=${param.end_time }&coverTime=${param.coverTime }&memberId=${param.memberId }&type=${param.type }&beginDate=${param.beginDate }&endDate=${param.endDate }&Checkbox1=${param.Checkbox1}&Checkbox2=${param.Checkbox2}&reportId=${param.reportId}" name="listFrame" scrolling="no" id="listFrame" />
        <%-- <c:if test="${v3x:getBrowserFlagByRequest('PageBreak', pageContext.request)}">
			<frame frameborder="no" src="<c:url value="/common/detail.jsp?direction=Down" />" name="detailFrame" id="detailFrame" scrolling="no" />
        </c:if> --%>
	</frameset>
</frameset>

</html>

