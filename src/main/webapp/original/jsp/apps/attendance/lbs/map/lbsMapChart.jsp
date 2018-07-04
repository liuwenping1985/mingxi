<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html class="w100b" id="mapHtml" style="height:${columnsHeight}">
<head>
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Insert title here</title>
	<style type="text/css">
	  #info{display:none;width:250px;color:white;background:transparent url('${path}/skin/default/images/portal_column_my-bg.png')  repeat scroll 0px 0px;position:absolute;top:0px;z-index:200;}
	</style>
</head>
<body onunload="destoryMap()">
	<div id="mapDiv" class="w100b h100b">
		<div id="errMsg" class="hidden" style="font-size: 12px">${ctp:i18n("attendance.message.mapDisplay")}</div>
		<div id="info">
			${currentDate} ${ctp:i18n("attendance.sign.num.label")}:<label id="memberNum">0</label>
		</div>
		<div id="iCenter" style="height: 410px" class="w100b h100b"></div>
		<div id="card" class="nowPosition_card hidden" style="width: 460px; position: relative; top: -90px; left: 315px; z-index: 200">
			<div class="positionContent" style="width: 370px" id="cardContent"></div>
			<div class="prevPosition" id="prev">
				<a>${ctp:i18n("attendance.label.previous")}</a>
			</div>
			<div class="nextPosition" id="next">
				<a>${ctp:i18n("attendance.label.next")}</a>
			</div>
		</div>
	</div>
</body>
	<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
	<%@include file = "mapLbsBase.jsp" %>
	<%@include file = "mapLbs_js.jsp" %>
</html>