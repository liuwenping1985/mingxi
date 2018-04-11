<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
	<link rel="stylesheet" type="text/css" href="${path}/apps_res/attendance/css/common.css${ctp:resSuffix()}"/>
	<link rel="stylesheet" type="text/css" href="${path}/apps_res/attendance/css/index.css${ctp:resSuffix()}"/>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <style>
		.common_txtbox_wrap input{width:auto;height:21px;line-height:21px}
		.radio_default{background:url(../apps_res/attendance/img/radio_check.png) no-repeat;background-size:15px 15px}
		.radio_checked{background:url(../apps_res/attendance/img/radio_checked.png) no-repeat;background-size:15px 15px}
		.radio_span{width:20px;height:15px;display:inline-block;margin-bottom:-3px}
		#endTime,#startTime,select{padding-top:1px;padding-left:10px;font-size:14px;color:#333;width:132px;height:28px}
		select{height:31px;padding-left:6px}
		input[disabled]{background-color:#f4f4f4}
		.common_txtbox_wrap{width:100px;height:28px;display:inline-block;margin-bottom:-10px;padding:0;border:1px solid #ddd}
		.common_txtbox_wrap input{width:auto;height:28px;line-height:28px;padding:0 10px}
		.calendar_icon_area{position:absolute}
		.calendar_icon{top:8px!important;right:0!important}
		#attendanceTable .hand{cursor:default}
		
		/* 页面整体布局 */
		body{background:#F0F0F0;}
		.stadic_layout{background-color: #F5F4F3;margin-top: 10px;}
		.stadic_layout_head{background-color: #fff;height: 96px;}
		.stadic_layout_body{clear:both;top:106px;bottom:5px;overflow: hidden; background-color: #fff;}
		
		.con-area{margin: 0px 20px; min-height: 45px; border-bottom: 1px dashed #e5e5e5;padding-top: 8px;}
		.con-btns{width: 100%; text-align: center;padding: 10px 0px;}
		
		.body-btns{width: 100%; padding-top:10px;padding-left:10px;height: 38px;}
    </style>
</head>
<body class="h100b over_hidden">

	<div class="stadic_layout">
		<div class="stadic_layout_head">
			<form id="attendanceForm" method="post">
				<div class="con-area">
					<span style="font-size: 14px; color: rgb(179, 179, 179);">${ctp:i18n('attendance.common.time')}</span>
					<span>
						<input id="startTime" name="startTime" type="text" class="comp mycal validate" validate="notNull:true" readonly="true" comp="cache:false,type:&quot;calendar&quot;,ifFormat:&quot;%Y-%m-%d&quot;" comptype="calendar" _inited="1" value="${startTime}">
					</span>
					<span style="font-size: 14px; color: #ccc;margin-left: 2px;width: 15px;height: 20px;">—</span>
					<span>
						<input id="endTime" name="endTime" type="text" class="comp mycal validate" validate="notNull:true" readonly="true" comp="cache:false,type:&quot;calendar&quot;,ifFormat:&quot;%Y-%m-%d&quot;" comptype="calendar" _inited="1" value="${endTime }">
					</span>
					<span style="font-size: 14px; color: rgb(179, 179, 179);margin-left: 20px;">${ctp:i18n('attendance.common.type')}</span>
					<select id="type" name="type" style="width: 100px;">
						<option value="1,2,3" selected>${ctp:i18n('attendance.common.all')}</option>
						<option value="1">${ctp:i18n('attendance.common.clockin')}</option>
						<option value="2">${ctp:i18n('attendance.common.clockout')}</option>
						<option value="3">${ctp:i18n('attendance.common.outside')}</option>
					</select>
					<span style="margin-left: 20px;font-size: 14px; color: rgb(179, 179, 179);">${ctp:i18n('attendance.common.acount')}</span>
					<label style="margin-left: 10px;" for="all"> 
						<input class="inputRadio" type="radio" id="all" name="all" style="display: none;" value="selectAll"/> 
						<span class="radio_span radio_checked" type="0" style="cursor: pointer; background-position: center;"></span> 
						<span style="font-size: 14px; color: rgb(179, 179, 179);">${ctp:i18n('attendance.common.all')}</span>
					</label> 
					<label style="margin-left: 10px;"> 
						<input type="radio" id="department" name="department" style="display: none;" value="selectDept"/> 
						<span class="radio_span radio_default" type="1" style="cursor: pointer; background-position: center;"></span> 
						<span style="font-size: 14px; color: rgb(179, 179, 179);">${ctp:i18n('attendance.common.belong')}</span>
						<input id="departmentName" type="text" name="departmentName" style="cursor: pointer" disabled onclick="Attendance.selectDepartment()"/> 
						<input id="departmentId" name="departmentId" type="hidden"/>
					</label> 
					<label style="margin-left: 10px;"> 
						<input type="radio" id="member" name="member" style="display: none;" value="selectMember"/> 
						<span class="radio_span radio_default" type="2" style="cursor: pointer; background-position: center;"></span> 
						<span style="font-size: 14px; color: rgb(179, 179, 179);">${ctp:i18n('attendance.common.name')}</span>
						<input id="memberName" type="text" name="memberName" disabled style="cursor: pointer" onclick="Attendance.selectMember()"> 
						<input id="memberId" name="memberId" type="hidden">
					</label> 
				</div>
				<div class="con-btns">
					<a href="javascript:void(0)" class="common_button common_button_emphasize margin_r_10" id="querySave" onclick="Attendance.query()">${ctp:i18n('attendance.common.check')}</a> 
					<a href="javascript:void(0)" class="common_button common_button_emphasize margin_r_10" style="background-color: #ECEAE8; border-color: rgb(179, 179, 179); color: #000;" id="" onclick="Attendance.rest()">${ctp:i18n('attendance.common.reset')}</a>
				</div>
				<input type="hidden" id="departmentEle" name="departmentEle" value="${deptList}" />
				<!-- 当月第一天 -->
				<input type="hidden" id="firstDayMonth" value="${startTime }">
				<!-- 当月最后一天 -->
				<input type="hidden" id="lastDayMonth" value="${endTime }"> 
				<input type="hidden" id="isDept" name="isDept" value="${isDept}"> 
				<input type="hidden" id="selectRange" name="selectRange" value="selectAll" />
			</form>
			<input type="hidden" id="departmentEle" value="${deptList}" />
		</div>
		
		<div id="staffTable" class="stadic_layout_body classification">
			<div class="body-btns">
				<a class="img-button margin_r_5" href="javascript:void(0)" id="exportToExcel" onclick="Attendance.exportToExcel()">
					<em class="ico16 export_excel_16"></em> ${ctp:i18n('attendance.common.export')}
				</a>
				<c:if test="${isDept == false}">
				<a class="img-button margin_r_5" href="javascript:void(0)" id="deleteAttendance" onclick="Attendance.deleteAttendance()">
					<em class="ico16 del_16"></em> ${ctp:i18n('attendance.common.delete')}
				</a>
				</c:if>
			</div>
			<div class="list" id="attendanceTable-parent">
				<table id="attendanceTable" style="display: none"></table>
			</div>
		</div>
		
	</div>
</body>
	<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
    <script type="text/javascript" src="${path}/common/js/laytpl.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path}/apps_res/attendance/js/staffAttendance.js${ctp:resSuffix()}"></script>
</html>

