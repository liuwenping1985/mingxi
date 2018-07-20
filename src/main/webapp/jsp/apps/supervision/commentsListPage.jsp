<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="${path}/apps_res/supervision/css/supervisionSummary.css">
    <script type="text/javascript" src="${path}/common/js/jquery.js"></script>
<script type="text/javascript" src="${path}/apps_res/supervision/js/supervisionPage.js"></script>
    <title>批示</title>
</head>
<body>
    <div class="instruction_container">
    <table>
        <colgroup>
            <col width="5%">
            <col width="25%">
            <col width="55%">
            <col width="15%">
        </colgroup>
        <thead>
        <tr>
            <td>序号</td>
            <td>批示领导</td>
            <td>批示内容</td>
            <td>批示时间</td>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="comment" items="${commentsList}" varStatus="status">
        <tr>
            <td><div>${status.index+1}</div></td>
            <td title="${comment.field0111}"><div>${comment.field0111}</div></td>
            <td title="${comment.field0110}"><div>${comment.field0110}</div></td>
            <td><div>${comment.field0112}</div></td>
		    </tr>
		    </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
<script type="text/javascript">
$(function(){
	//获取父页面中存放条数的对象
	var count=parseInt(${fn:length(commentsList)});
	refreshCount("commentsNum",count);
})
</script>