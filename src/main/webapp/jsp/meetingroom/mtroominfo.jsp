<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.meetingroom.resources.i18n.MeetingRoomResources"/>
<fmt:message key="common.date.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><fmt:message key='mr.label.mtdetails.title'/></title>
<%@ include file="header.jsp" %>
<c:set value="${pageContext.request.contextPath}" var="path" />
<link rel="stylesheet" href="${path}/common/all-min.css" />
<link rel="stylesheet" href="${path}/skin/default/skin.css" />
<style>
	input, textarea {
		height: 22px;
	}
	.dialog_main_body {
		buttom: 42px;
	}
	.dialog_main_footer {
		bottom: 0px;
	}
</style>
<script>

window.transParams = window.transParams || window.parent.transParams || {};//弹出框参数传递
/**
 *内部方法，向上层页面返回参数
 */
function _returnValue(value){
    if(transParams.popCallbackFn){//该页面被两个地方调用
        transParams.popCallbackFn(value);
    }else{
        window.returnValue = value;
    }
}

/**
 *内部方法，关闭当前窗口
 */
function _closeWin(){
    if(transParams.popWinName){//该页面被两个地方调用
        transParams.parentWin[transParams.popWinName].close();
    }else{
        window.close();
    }
}

window.onload = function() {
	//initIe10AutoScroll('dialog_main', 120);
	//initIe10AutoScroll('dialog_main', 40);
	//initIe10AutoScroll('dialog_main_body', 80);
}
</script>
</head>
<body class="bg_color_gray w100b h100b">
<div class="padding_t_5 padding_b_5 padding_l_5 padding_r_5">
<div id="dialog_main" class="dialog_main bg_color_white">

<div class="margin_l_10 margin_t_10 padding_b_10">
	<fmt:message key='mr.label.mtdetails.title'/>
</div>

<div id="dialog_main_body" class="dialog_main_body center bg_color_white over_auto border_all padding_l_5 padding_r_5 padding_tb_10 over_y_auto" style="height: 382px">

<table class="w100b h100b">
	
<tr>
	<th width="1%" nowrap="nowrap" align="right">
		<div class="padding_l_10 padding_t_5 padding_r_5"><fmt:message key='mr.label.meetingroomname'/>:</div>
	</th>
	<td>
		<input class="w90b" value="${meetingRoom.name}" readonly />
	</td>
</tr>
<tr>
	<th width="1%" nowrap="nowrap" align="right">
		<div class="padding_l_10 padding_t_5 padding_r_5"><fmt:message key='mr.label.seatCount'/>:</div>
	</th>
	<td>
		<input class="w90b" value="${meetingRoom.seatCount}" readonly />
	</td>
</tr>
<tr>
	<th width="1%" nowrap="nowrap" align="right">
		<div class="padding_l_10 padding_t_5 padding_r_5"><fmt:message key='mr.label.place'/>:</div>
	</th>
	<td>
		<textarea class="w90b" readonly>${meetingRoom.place}</textarea>
	</td>
</tr>
<tr>
	<th width="1%" nowrap="nowrap" align="right">
		<div class="padding_l_10 padding_t_5 padding_r_5"><fmt:message key='mr.label.roomdescription'/>:</div>
	</th>
	<td>
		<textarea class="w90b" readonly>${meetingRoom.description}</textarea>
	</td>
</tr>
<tr>
	<th width="1%" nowrap="nowrap" align="right">
		<div class="padding_l_10 padding_t_5 padding_r_5"><fmt:message key='mr.label.room.equipment.description'/>:</div>
	</th>
	<td>
		<textarea class="w90b" readonly>${meetingRoom.eqdescription }</textarea>
	</td>
</tr>

<tr>
	<th width="1%" nowrap="nowrap" align="right">
		<div class="padding_l_10 padding_t_5 padding_r_5"><fmt:message key='mr.label.Croom.system'/>:</div>
	</th>
	<td>
		<div id="attachmentTR" style="display:none;height:24px;" class="padding_t_0">
	  		<v3x:fileUpload attachments="${attatchments}" canDeleteOriginalAtts="false"/><br>
	  	</div>
	</td>
</tr>
			
<tr>
	<th width="1%" nowrap="nowrap" align="right">
		<div class="padding_l_10 padding_t_5 padding_r_5"><fmt:message key="mr.label.room.photo"/>:</div>
	</th>
	<td>
		<c:choose>
			<c:when test="${fileId!=null}">
                <html:link renderURL="/fileUpload.do?method=showRTE&fileId=${fileId}&createDate=${createTime}&type=image&filename=${filename}" var="imgURL" />
                <img id="imageId" src="${imgURL}" class="w90b" style="height:200px;" />
			</c:when>
			<c:otherwise>
				<img id="imageId" src="<c:url value='/apps_res/meetingroom/images/no_picture.png'/>" class="w90b border_all" style="height:200px;" />
			</c:otherwise>
		</c:choose> 
	</td>
</tr>

</table>

</div><!-- dialog_main_body -->
</div><!-- dialog_main -->
</div>

<div class="dialog_main_footer bg_color_gray padding_t_5 padding_r_10 align_right" style="height:35px;float: right;">
	<input type="button" value="<fmt:message key='common.button.close.label'  bundle='${v3xCommonI18N}'/>" onclick="javascript:_closeWin();" class="button-default-2" />
</div>
<div style="clear: both;"></div>
</body>
</html>
