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
    <title>关注</title>
</head>
<body>
    <div class="concern_container">
    <table>
        <colgroup>
            <col width="30%">
            <col width="40%">
            <col width="30%">
        </colgroup>
        <thead>
        <tr>
            <td>序号</td>
            <td>关注领导</td>
            <td>关注时间</td>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${attentionList}" var="con" varStatus="status">
            <tr>
                <td><div>${status.index+1}</div></td>
                <td><div>${con.field0081 }</div></td>
                <td><div>${con.field0083 }</div></td>
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
	var count=parseInt(${fn:length(attentionList)});
	refreshCount("attentionNum",count);
})
</script>