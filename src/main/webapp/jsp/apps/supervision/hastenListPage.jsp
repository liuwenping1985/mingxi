<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<c:set var="path" value="${pageContext.request.contextPath}" />
<html lang="en">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="${path}/apps_res/supervision/css/supervisionSummary.css"/>
    <script type="text/javascript" src="${path}/common/js/v3x-debug.js"></script>
    <script type="text/javascript" src="${path}/common/js/jquery.js"></script>
    <script type="text/javascript" src="${path}/apps_res/supervision/js/supervisionPage.js"></script>
    <title>催办</title>
</head>
<body>
    <div class="urge_container">
     <p>催办记录</p>
        <table class="xl-urge-record">
            <colgroup>
                <col width="5%">
                <col width="20%">
                <col width="40%">
                <col width="15%">
                <col width="20%">
            </colgroup>
            <thead>
                <tr>
                    <td>序号</td>
                    <td>催办单位</td>
                    <td>催办内容</td>
                    <td>催办时间</td>
                    <td>催办记录</td>
                </tr>
            </thead>
            <tbody>
            	<c:forEach var="hasten" items="${hastenList}" varStatus="status">
                <tr>
                    <td><div>${status.index+1}</div></td>
                    <td title="${hasten.field0038}"><div>${hasten.field0038}</div></td>
                    <td title="${hasten.field0041}"><div>${hasten.field0041}</div></td>
                    <td><div>${hasten.field0039}</div></td>
                    <td>
                    	<div title="${hasten.field0040}" style="cursor:pointer;color:#3b78de;" onclick="showSummaryCol('${masterDataId}','${hasten.id}','field0040','${path}')">${hasten.field0040}</div>
                    </td>
                </tr>
                </c:forEach>
            </tbody>
        </table>
        <p class="exam_evaluate">提醒记录</p>
        <table class="xl-remind-record">
        <colgroup>
            <col width="5%">
            <col width="20%">
            <col width="45%">
            <col width="20%">
            <col width="10%">
        </colgroup>
        <thead>
        <tr>
            <td>序号</td>
            <td>发起人</td>
            <td>提醒内容</td>
            <td>接收单位</td>
            <td>提醒时间</td>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="remind" items="${remindList}" varStatus="status">
        	<tr>
	            <td><div>${status.index+1}</div></td>
	            <td><div>${remind.field0152}</div></td>
	            <td title="${remind.field0033}"><div>${remind.field0033}</div></td>
	            <td title="${remind.field0036}"><div>${remind.field0036}</div></td>
	            <td><div>${remind.field0034}</div></td>
		    </tr>
		    </c:forEach>
        </tbody>
    </table>
    </div>
</body>
<script type="text/javascript">
$(function(){
	//获取父页面中存放条数的对象
	var count=${fn:length(remindList)}+${fn:length(hastenList)};
	refreshCount("hastenNum",count);
})
</script>
</html>