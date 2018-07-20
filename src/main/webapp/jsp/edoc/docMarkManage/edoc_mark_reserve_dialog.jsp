<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>${dialogTitle }</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/edoc_mark_reserve_dialog.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/jquery.jetspeed.json.js${v3x:resSuffix()}" />"></script>

<style>
.dialog_main_body {
	buttom: 30px;
}
.dialog_main_footer {
	height: 30px;
	bottom: 0px;
}
</style>
<script>
var reserveToLabel  = "${reserveToLabel}";
var maxDiffNumber = 1000;
var reserveLineObjArray = [];
var reserveDownObjArray = [];
<c:forEach items="${reserveLineList }" var="reserved">
	var startNo = parseInt("${reserved.startNo}", 10);
	var endNo = parseInt("${reserved.endNo}", 10);
	var reserveObj = new Object();
	reserveObj.startNo = startNo;
	reserveObj.endNo = endNo;
	reserveLineObjArray.push(reserveObj);
</c:forEach>
<c:forEach items="${reserveDownList }" var="reserved">
var startNo = parseInt("${reserved.startNo}", 10);
var endNo = parseInt("${reserved.endNo}", 10);
	var reserveObj = new Object();
	reserveObj.startNo = startNo;
	reserveObj.endNo = endNo;
	reserveDownObjArray.push(reserveObj);
</c:forEach>
//设置开始和结束输入框宽度
function init(){
	var titleDivWidth = document.getElementById("titleDiv").scrollWidth;
	var titleSpan = document.getElementById("titleSpan");
	var titleSpanWidth= Math.max( titleSpan.style.width,titleSpan.clientWidth,titleSpan.offsetWidth,titleSpan.scrollWidth);
	var addMarkReserveWidth = document.getElementById("addMarkReserve").scrollWidth;
	var forMatCLabelWidth = document.getElementById("forMatCLabel").scrollWidth;
	var inputWidth = ((titleDivWidth-titleSpanWidth-addMarkReserveWidth-forMatCLabelWidth-90)/2) + "px";
	document.getElementById("startNo").style.width =  inputWidth;
	document.getElementById("endNo").style.width =  inputWidth;
	document.getElementById("endNo").focus();
}

function pressEnter(evt){
	evt = (evt)?evt:((window.event)?window.event:"");
	var k = evt.keyCode?evt.keyCode:evt.which;
	return k>=48&&k<=57 || k==8;
}
</script>
</head>
<body onload="init();" class="over_hidden">

<form id="markReserveForm" name="markReserveForm" action="edocMark.do?method=saveMarkReserve" mthod="post" target="reserveIframe">
	<div id="reserveData">
	<input type="hidden" id="method" name="method" value="saveMarkReserve" />
	<input type="hidden" id="type" name="type" value="${param.type }" />
	<input type="hidden" id="markDefineId" name="markDefineId" value="${reserveVO.markDefineId }" />
	<input type="hidden" id="currentNo" name="currentNo" value="${reserveVO.edocMarkCategory.currentNo }" />
	<input type="hidden" id="wordNoLimit" name="wordNoLimit" value="${v3x:getLimitLengthString(reserveVO.wordNo,15,'...') }" />
	<input type="hidden" id="reserveLimitNo" name="reserveLimitNo" value="${reserveVO.reserveLimitNo }" />
	<input type="hidden" id="wordNo" name="wordNo" value="${reserveVO.wordNo }" />
	<input type="hidden" id="yearNo" name="yearNo" value="${reserveVO.yearNo }" />
	<input type="hidden" id="formatA" name="formatA" value="${reserveVO.formatA }" />
	<input type="hidden" id="formatB" name="formatB" value="${reserveVO.formatB }" />
	<input type="hidden" id="formatC" name="formatC" value="${reserveVO.formatC }" />
	<input type="hidden" id="length" name="length" value="${reserveVO.edocMarkDefinition.length }" />
	<input type="hidden" id="minNo" name="minNo" value="${reserveVO.edocMarkCategory.minNo }" />
	<input type="hidden" id="maxNo" name="maxNo" value="${reserveVO.edocMarkCategory.maxNo }" />

	<div id="dialog_main" class="bg_color_white">
	
		<div id="titleDiv" class="margin_10 w100b">
			<span id="titleSpan" style="font-size:12px;font-family:SimSun;" title="${reserveVO.wordNo }${reserveVO.formatA }${reserveVO.yearNo }${reserveVO.formatB }">${v3x:getLimitLengthString(reserveVO.wordNo,15,'...') }${reserveVO.formatA }${reserveVO.yearNo }${v3x:getLimitLengthString(reserveVO.formatB,13,'...')}</span>
			<input id="startNo" name="startNo" value="${reserveVO.edocMarkCategory.currentNo }" onkeypress="return pressEnter(event)" onpaste="return !clipboardData.getData('text').match(/\D/)" ondragenter="return false" style="font-size:12px;ime-mode:Disabled;" /> —
			<input id="endNo" name="endNo" onclick="this.focus()" size="2" onkeypress="return pressEnter(event)" onpaste="return !clipboardData.getData('text').match(/\D/)" ondragenter="return false" style="font-size:12px;ime-mode:Disabled;" /> <label id="forMatCLabel" style="font-size:12px;font-family:SimSun;">${v3x:getLimitLengthString(reserveVO.formatC,11,'...')}</label>
			<span class="ico16 g6_add_16" id="addMarkReserve" onclick="addMarkReserve()"></span>
		</div>
		
		<div id="dialog_main_body" class="dialog_main_body center bg_color_white w100b border_t margin_l_10 margin_r_10">		
			<div class="margin_t_10 margin_b_10">
				<div class="margin_r_20 margin_b_10" style="height:20px;">
					<label style="font-size:12px;font-family:SimSun;">${ctp:i18n('edoc.moreSign.hasSelected')}</label>
					<span style="padding-left:240px;float:right;">
						<input id="queryNumber" name="queryNumber" style="width:80px" /><span id="queryButton" class="ico16 search_16"></span>
					</span>
				</div>
				<div class="margin_r_20" style="height:215px;">
					<ul id="ul_reserve" class="border_all over_auto h100b" style="padding-left:12px;">
						<c:if test="${param.type=='1' }">
							<c:forEach items="${reserveLineList }" var="reserved">
								<li style="font-size:12px;font-family:SimSun;display:${param.type=='1'?'':'none' }" title="${reserved.docMarkDisplay }" class="padding_t_5" reservedId="${reserved.id }" type="1" yearNo="${reserved.yearNo }" startNo="${reserved.startNo }" endNo="${reserved.endNo }">${reserved.docMarkDisplay }<span onClick="deleteMarkReserve(this)" class="ico16 g6_del_16 margin_l_5"></span></li>
							</c:forEach>
						</c:if>
						<c:if test="${param.type=='2' }">
							<c:forEach items="${reserveDownList }" var="reserved">
								<li style="font-size:12px;font-family:SimSun;display:${param.type=='2'?'':'none' }" title="${reserved.docMarkDisplay }" class="padding_t_5" reservedId="${reserved.id }" type="2" yearNo="${reserved.yearNo }" startNo="${reserved.startNo }" endNo="${reserved.endNo }">${reserved.docMarkDisplay }<span onClick="deleteMarkReserve(this)" class="ico16 g6_del_16 margin_l_5"></span></li>
							</c:forEach>
						</c:if>
					</ul>	
				</div>
			</div>
		</div>
	</div>
	</div><%-- 表单提交数据 --%>
	
	<div class="dialog_main_footer left padding_t_5 w100b" style="height: 44px; color: #fff; background-image: none; background-attachment: scroll; background-repeat: repeat; background-position-x: 0%; background-position-y: 0%; background-size: auto; background-origin: padding-box; background-clip: border-box; background-color: rgb(77, 77, 77);">
		<div class="align_right right" style="width:100%;">
			<a href="javascript:void(0)" id="submitBtn" onclick="doIt('${type}')" class="common_button common_button_gray margin_r_10" style="cursor: pointer;">${ctp:i18n('common.button.ok.label')}</a>
			<a href="javascript:void(0)" onclick="commonDialogClose('win123')" class="common_button common_button_gray margin_r_10" style="cursor: pointer;">${ctp:i18n('common.button.cancel.label')}</a>
		</div>
	</div>
	
	<%-- 本次回填的数据 --%>
	<div id="thisReservedIds" style="display:none;">
		<c:forEach items="${reservedIdList }" var="reservedId">
			<input type="hidden" name="thisReservedId" value="${reservedId }" />
		</c:forEach>
	</div>

	<%-- 本次删除的数据 --%>
	<div id="delReserveIds" style="display:none;">
	</div>
	
	<%-- 本次删除的数据 --%>
	<div id="addReserveIds" style="display:none;">
	</div>
	
</form>

<iframe id="reserveIframe" name="reserveIframe" style="height:0px;width:0px;display:none;"></iframe>
</body>
</html>
