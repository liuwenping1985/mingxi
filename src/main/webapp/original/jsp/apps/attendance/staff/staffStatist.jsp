<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/apps_res/attendance/css/common.css${ctp:resSuffix()}" />
	<link rel="stylesheet" type="text/css" href="${path}/apps_res/attendance/css/index.css${ctp:resSuffix()}" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<style>
	    body{font-size:12px;background-color:#F0F0F0}
		.stadic_head_height{height:30px}
		.stadic_body_top_bottom{bottom:0;top:30px}
		.radio_default{background:url(../apps_res/attendance/img/radio_check.png) no-repeat;background-size:15px 15px}
		.radio_checked{background:url(../apps_res/attendance/img/radio_checked.png) no-repeat;background-size:15px 15px}
		.radio_span{width:20px;height:15px;display:inline-block;margin-bottom:-3px}
		.common_txtbox_wrap input{width:auto;height:28px;line-height:28px;padding:0 10px}
		.common_txtbox_wrap{width:100px;height:28px;display:inline-block;margin-bottom:-10px;padding:0;border:1px solid #ddd}
		#endTime,#startTime{padding-top:1px;padding-left:10px;font-size:14px;color:#333;width:132px;height:28px}
		.common_button_reset{color:#333;border:1px solid #d1d4db;background:#fff}
		.common_button_reset:hover{color:#333;border:1px solid #d1d4db;background:#fff}
		input[disabled]{background-color:#f4f4f4}
		#endTime[disabled],#startTime[disabled]{background-color:#fff}
		.dateList{margin:0}
		.calendar_icon_area{position:absolute}
		.calendar_icon{top:8px!important;right:0!important}
		#statistTable .hand{cursor:default}
		.em_title{top: -65px;right: 35px;}
	</style>
</head>
<body class="h100b over_hidden">
	<div class="stadic_layout">
		<div class="stadic_layout_head stadic_head_height" style="height: 100px; margin-top: 12px;">
			<form id="attendanceForm" method="post" style="background-color: #fff;">
				<div style="height: 48px; border-bottom: 1px dashed #e5e5e5; margin: 0 20px;width: 100%;">
					<div style="padding-top: 9px;">
						<span style="font-size: 14px; color: #999;">${ctp:i18n('attendance.common.acount')}</span> 
						<label style="margin-left:10px;"> 
							<input class="inputRadio" style="display: none;" type="radio" value="selectAll" /> 
							<span class="radio_span radio_checked" type="0" style="cursor: pointer; background-position: center;"></span> 
							<span style="font-size: 14px; color: #999;">${ctp:i18n('attendance.common.all')}</span> 
						</label>
						<label style="margin-left:20px;"> 
							<input class="inputRadio" style="display: none;" type="radio" value="selectDept" /> 
							<span class="radio_span radio_default" type="1" style="cursor: pointer; background-position: center;"></span> 
							<span style="font-size: 14px; color: #999;">${ctp:i18n('attendance.common.belong')}</span> 
						</label>
						<input type="text" id="departmentName" onclick="Attendancestatist.selectDepartment()" style="cursor: pointer" disabled /> 
						<input type="hidden" id="departmentId" type="hidden" />
						<label style="margin-left:20px;"> 
							<input class="inputRadio" style="display: none;" type="radio" value="selectMember" /> 
							<span class="radio_span radio_default" type="2" style="cursor: pointer; background-position: center;"></span> 
							<span style="font-size: 14px; color: #999;">${ctp:i18n('attendance.common.name')}</span> 
						</label>
						<input type="text" id="memberName" onclick="Attendancestatist.selectMember()" style="cursor: pointer" disabled /> 
						<input type="hidden" id="memberId" />
						<label style="margin-left:50px;"> 
							<span style="font-size: 14px; color: #999;">${ctp:i18n('attendance.common.time')}</span> 
						</label>
						<label style="margin-left:10px;"> 
							<input id="startTime" name="startTime" type="text" class="comp mycal validate" validate="notNull:true" readonly="true" comp="cache:false,type:&quot;calendar&quot;,ifFormat:&quot;%Y-%m-%d&quot;" comptype="calendar" _inited="1" value="${startTime}"> 
						</label>
						<label style="margin-left:10px;"> 
							<span style="font-size: 14px; color: #999;">—</span> 
						</label>
						<input id="endTime" name="endTime" type="text" class="comp mycal validate" validate="notNull:true" readonly="true" comp="cache:false,type:&quot;calendar&quot;,ifFormat:&quot;%Y-%m-%d&quot;" comptype="calendar" _inited="1" value="${endTime }"> 
					</div>
				</div>
				<div style="width: 100%; text-align: center;padding: 12px 0px;">
					<a href="javascript:void(0)" class="common_button common_button_emphasize margin_r_10" id="statist" onclick="Attendancestatist.statist()">${ctp:i18n('attendance.common.check')}</a> 
					<a href="javascript:void(0)" class="common_button common_button_emphasize margin_r_10 common_button_reset" id="rest" onclick="Attendancestatist.rest()">${ctp:i18n('attendance.common.reset')}</a> 
					<span class="titleSpan_title"> 
						<em id="icon_exp" onmouseover="Attendancestatist.showInfo(this)" onmouseleave="Attendancestatist.hideInfo(this)" class="ico16 help_16 help_16_red" style="float: right; margin-right: 20px;margin-top: -20px;"></em> 
						<em class="em_title em_title_bg" style="height: 55px; display: none;"></em> 
						<em class="em_title em_title_content" style="display: none;">${ctp:i18n("attendance.undk.info")}</em>
					</span>
				</div>
				
				<input type="hidden" id="departmentEle" name="departmentEle" value="${deptList}" />
				<!-- 当月第一天 -->
				<input type="hidden" id="firstDayMonth" value="${startTime }"/>
				<!-- 当月最后一天 -->
				<input type="hidden" id="lastDayMonth" value="${endTime }"/> 
				<input type="hidden" id="isDept" name="isDept" value="${isDept}"/> 
				<input type="hidden" id="selectRange" name="selectRange" value="selectAll" />
			</form>
		</div>
		<div id="staffStatist" class="stadic_layout_body stadic_body_top_bottom classification" style="top: 115px; background-color: #fff;">
			<div class="list" style="margin: 10px 10px 0px;">
				<div class="button_box clearfix">
					<table id="statistTable" style="display: none"></table>
				</div>
			</div>
		</div>
	</div>
</body>
	<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
    <script type="text/javascript" src="${path}/common/js/laytpl.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path}/apps_res/attendance/js/staffStatist.js${ctp:resSuffix()}"></script>
</html>

