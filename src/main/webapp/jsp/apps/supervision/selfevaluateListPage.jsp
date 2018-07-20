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
    <title>评价</title>
</head>
<body>
    <div class="evaluate_container">
        <p class="self-evaluation">自评记录</p>
        <table>
            <colgroup>
                <col width="5%">
                <col width="70%">
                <col width="15%">
                <col width="10%">
            </colgroup>
            <thead>
                <tr>
                    <td>序号</td>
                    <td>自评</td>
                    <td>评价人</td>
                    <td>自评时间</td>
                </tr>
            </thead>
            <tbody>
            <c:forEach items="${selfevaluateList}" var="con" varStatus="status">
                <tr>
                    <td><div>${status.index+1}</div></td>
                    <td title="${con.field0103}"><div>${con.field0103}</div></td>
                    <td><div>${con.field0127}</div></td>
                    <td><div>${con.field0114}</div></td>
                </tr>
                </c:forEach>
            </tbody>
        </table>
        <p class="exam_evaluate">考核记录</p>
        <table>
            <colgroup>
                <col width="5%">
                <col width="40%">
                <col width="15%">
                <col width="15%">
                <col width="15%">
                <col width="10%">
            </colgroup>
            <thead>
                <tr>
                    <td>序号</td>
                    <td>考核评价</td>
                    <td>等级</td>
                    <td>得分</td>
                    <td>评价人</td>
                    <td>评价时间</td>
                </tr>
            </thead>
            <tbody>
             <c:forEach items="${othervaluateList}" var="con" varStatus="status">
                <tr>
                    <td><div>${status.index+1}</div></td>
                    <td title="${con.field0107}"><div>${con.field0107}</div></td>
                    <td><div>${con.field0105}</div></td>
                    <td><div>${con.field0106}</div></td>
                    <td><div>${con.field0108}</div></td>
                    <td><div>${con.field0116}</div></td>
                </tr>
              </c:forEach>
            </tbody>
        </table>
    </div>
</body>
<script type="text/javascript">
$(function(){
	//获取父页面中存放条数的对象
	var count=parseInt(${fn:length(selfevaluateList)}+${fn:length(othervaluateList)});
	refreshCount("evaluateNum",count);
})
</script>
</html>