<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="${path}/apps_res/supervision/css/supervisionSummary.css">
    <script type="text/javascript" src="${path}/common/js/v3x-debug.js"></script>
    <script type="text/javascript" src="${path}/common/js/jquery.js"></script>
<script type="text/javascript" src="${path}/apps_res/supervision/js/supervisionPage.js"></script>
    <title>变更</title>
</head>
<body>
    <div class="change_container">
        <table>
            <colgroup>
                <col width="5%">
                <col width="20%">
                <col width="10%">
                <col width="10%">
                <col width="25%">
                <col width="10%">
                <col width="20%">
            </colgroup>
            <thead>
                <tr>
                    <td>序号</td>
                    <td>申请单位</td>
                    <td>变更类型</td>
                    <td>延期完成时间</td>
                    <td>申请原因</td>
                    <td>申请时间</td>
                    <td>申请记录</td>
                </tr>
            </thead>
            <tbody>
            <c:forEach items="${changeList}" var="con" varStatus="status">
                <tr>
                    <td><div>${status.index+1}</div></td>
                    <td title="${con.field0043}"><div>${con.field0043}</div></td>
                    <td><div>${con.field0044}</div></td>
                    <td><div>${con.field0046}</div></td>
                    <td title="${con.field0049}"><div>${con.field0049}</div></td>
                    <td><div>${con.field0048}</div></td>
                    <td title="${con.field0047}"><div style="cursor:pointer;color:#3b78de;" onclick="showSummaryCol('${masterDataId}','${con.id}','field0047','${path}')">${con.field0047}</div></td>
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
	var count=parseInt(${fn:length(changeList)});
	refreshCount("changeNum",count);
})
</script>