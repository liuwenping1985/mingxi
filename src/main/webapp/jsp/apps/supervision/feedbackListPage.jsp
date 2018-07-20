<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>   
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="pragma" contect="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<link rel="stylesheet" href="${path}/apps_res/supervision/css/supervisionSummary.css">
<link rel="stylesheet" href="${path}/apps_res/supervision/css/dialog.css">
<script type="text/javascript" src="${path}/apps_res/supervision/js/supervisionPage.js"></script>
<title>反馈</title>
<style type="text/css">
	.attachment_operate {
	display: none;
	position: relative;
}

.attachment_operate .attachment_operate_btn {
	position: absolute;
	z-index: 3;
	top: 0;
	left: 0;
	width: 100%;
	height: 25px;
	line-height: 25px;
	cursor: pointer;
}

.attachment_operate .attachment_operate_btn_bg {
	position: absolute;
	z-index: 2;
	top: 0;
	left: 0;
	width: 100%;
	height: 25px;
	line-height: 25px;
}

.attachment_operate table td div {
	display: none;
	height: 25px;
	line-height: 25px;
	/* background: #111; */
	opacity: .3;
	filter: alpha(opacity = 30);
	*zoom: 1;
}

.attachment_operate .attachment_operate_bg {
	position: absolute;
	z-index: 1;
	top: 0;
	left: 0;
	width: 100%;
	height: 25px;
	line-height: 25px;
	/* background: #111; */
	opacity: .5;
	filter: alpha(opacity = 50);
	*zoom: 1;
}
</style>
</head>
<body>
	<div class="feedback_container">
		<p>计划记录</p>
		<table style="width: 100%">
            <colgroup>
                <col width="5%">
                <col width="15%">
                <col width="45%">
                <col width="25%">
                <col width="10%">
            </colgroup>
            <thead>
                <tr>
                	<td>序号</td>
                    <td>计划时间段</td>
                    <td>目标路线</td>
                    <td>反馈单位</td>
                    <td>填报时间</td>
                </tr>
            </thead>
            <tbody>
            <c:forEach items="${planList}" var="con" varStatus="status">
                <tr id="${con.id}" style="cursor: pointer;" tableName="plan">
                	<td><div>${status.index+1}</div></td>
                		<c:set var="field0138" value=""/>
						<c:set var="field0142" value=""/>
						<c:set var="showvalue" value=""/>
						<c:if test="${con.field0138==''}">
							<c:set var="field0138" value="--"/>
						</c:if>
   						<c:if test="${con.field0138!=''}">
   							<c:set var="field0138" value="${con.field0138 }"/>
   						</c:if>
   						<c:if test="${con.field0142==''}">
							<c:set var="field0142" value="--"/>
						</c:if>
   						<c:if test="${con.field0142!=''}">
   							<c:set var="field0142" value="${con.field0142 }"/>
   						</c:if>
   						<c:if test="${con.field0142!=''||con.field0138!=''}">
   							<c:set var="showvalue" value="${field0138 }至${field0142}"/>
   						</c:if>
                    <td title="${showvalue}"><div>${showvalue}</div></td>
                    <td title="${con.field0139}"><div>${con.field0139}</div></td>
                    <td title="${con.field0140}"><div style="text-align: left">${con.field0140}</div></td>
                    <td title="${con.field0141}"><div>${con.field0141}</div></td>
                </tr>
                </c:forEach>
            </tbody>
        </table>
        <p class="exam_evaluate">反馈记录</p>
		<table style="width: 100%">
			<colgroup>
				<col width="5%">
				<col width="15%">
				<col width="15%">
				<col width="25%">
				<col width="15%">
				<col width="15%">
				<col width="10%">
			</colgroup>
			<thead>
				<tr>
					<td style="text-align: left">序号</td>
					<td style="text-align: left">计划时间段</td>
					<td style="text-align: left">目标路线</td>
					<td style="text-align: left">完成情况</td>
					<td style="text-align: left">完成率</td>
					<td style="text-align: left">反馈单位</td>
					<td style="text-align: left">反馈时间</td>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${feedbackList}" var="feedback" varStatus="status">
					<tr id="${feedback.id}" style="cursor: pointer;" tableName="feedback">
						<td><div>${status.index+1}</div></td>
						<c:set var="field0092" value=""/>
						<c:set var="field0130" value=""/>
						<c:set var="showvalue" value=""/>
						<c:if test="${feedback.field0092==''}">
							<c:set var="field0092" value="--"/>
						</c:if>
   						<c:if test="${feedback.field0092!=''}">
   							<c:set var="field0092" value="${feedback.field0092 }"/>
   						</c:if>
   						<c:if test="${feedback.field0130==''}">
							<c:set var="field0130" value="--"/>
						</c:if>
   						<c:if test="${feedback.field0130!=''}">
   							<c:set var="field0130" value="${feedback.field0130 }"/>
   						</c:if>
   						<c:if test="${feedback.field0092!=''||feedback.field0130!=''}">
   							<c:set var="showvalue" value="${field0092 }至${field0130}"/>
   						</c:if>
						<td title="${showvalue }"><div style="text-align: left">${showvalue }</div></td>
							<td title="${feedback.field0097 }"><div style="text-align: left">${feedback.field0097 }</div></td>
							<td title="${feedback.field0073 }"><div style="text-align: left">${feedback.field0073 }</div></td>
							<td>
							<c:if test="${feedback.field0074!=''}">
								<span class="progressbar_1">
									 <span class="bar" style="width:<fmt:formatNumber type='number' maxFractionDigits="0" value='${feedback.field0074*100}'/>%">
									</span>
								</span>
	                        	&nbsp;<fmt:formatNumber type='number' maxFractionDigits="0" value='${feedback.field0074*100}'/>%
	                    	</c:if></td>
	                    <td title="${feedback.field0072}"><div style="text-align: left">${feedback.field0072}</div></td>
						<td title="${feedback.field0075}"><div >${feedback.field0075 }</div></td>
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
	var count=parseInt(${fn:length(feedbackList)});
	refreshCount("feedbackNum",count);
	
	$(".feedback_container tbody").find("tr").click(function(){
		 var id=$(this).attr("id");
		 var tableName=$(this).attr("tableName");
		 var dialogH='540px';
		 if(tableName=='plan'){
			 dialogH='430px';
		 }
		 var url = _ctxPath + "${path}/supervision/supervisionController.do?method=feedBackView&id="+id+"";
	     window.feedBackView = getA8Top().$.dialog({
        	id:'feedBackView',
    	    title:'查看计划/反馈',
    	    transParams:{'parentWin':window, "popWinName":"feedBackView"},
    	    url:  _ctxPath+"/supervision/supervisionController.do?method=feedBackView&masterDataId=${masterDataId}&from="+tableName+"&tableName="+tableName+"&id="+id,
    	    targetWindow:getA8Top(),
    	    width:"550",
    	    height:dialogH
    	});
	});
})
</script>