<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<%@include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<title></title>
	<link rel="stylesheet" type="text/css" href="${path}/apps_res/attendance/css/common.css${ctp:resSuffix()}"/>
	<link rel="stylesheet" type="text/css" href="${path}/apps_res/attendance/css/index.css${ctp:resSuffix()}"/>
	<link rel="stylesheet" type="text/css" href="${path}/common/css/layout.css${ctp:resSuffix()}">
    <style type="text/css" >
		#endTime,#startTime{margin-bottom:5px;padding-top:1px;padding-left:10px;font-size:14px;color:#333;width:132px;height:28px;}
		.common_button_reset{color:#333;border:1px solid #d1d4db;background:#fff;margin-left:10px;}
		.common_button_reset:hover{color:#333;border:1px solid #d1d4db;background:#fff;}
		.dateList{margin-top:0;}
		.calendar_icon_area{position:absolute;}
		.calendar_icon{top:8px!important;right:0!important;}
		#statistTable .hand{cursor:default;}
		
		.myTbox{margin:10px 0px;background-color:#fff;padding:0px 20px;height:96px;width: 100%;}
		.myTbox .tbox-wrep{width:100%;overflow:hidden;border-bottom:1px dashed #e5e5e5;padding-top:9px;}
		.myTbox .btns{padding-top:10px;height:48px;width:100%;text-align:center;}
		.statist-list{padding: 20px 20px 0px;text-align: center;background:#fff;margin-top:10px;}
    </style>
</head>
<body class="page_color">
    <div class="myTbox">
        <div class="tbox-wrep">
             <label>
                 <span style="font-size:14px;color:#999;">${ctp:i18n('attendance.common.time')}</span>
             </label>
             <label style="margin-left:14px;">
                  <input id="startTime" name="startTime" readonly="readonly" type="text" class="comp mycal validate" validate="notNull:true" readonly="true" 
                 comp="cache:false,type:&quot;calendar&quot;,ifFormat:&quot;%Y/%m/%d&quot;" comptype="calendar" _inited="1" value="${startTime}">
             </label>
             <label style="margin-left:10px;">
                 <span style="font-size:14px;color:#999;">-</span>
             </label>
             <label style="margin-left:10px;">
                 <input id="endTime" name="endTime" readonly="readonly" type="text" class="comp mycal validate" validate="notNull:true" readonly="true" 
                 comp="cache:false,type:&quot;calendar&quot;,ifFormat:&quot;%Y/%m/%d&quot;" comptype="calendar" _inited="1" value="${endTime}">
             </label>
        </div>
        <div class="btns" >
            <a href="javascript:void(0)" onclick="Attendancestatist.statist();" class="common_button common_button_emphasize">${ctp:i18n('attendance.common.check')}</a>
            <a href="javascript:void(0)" onclick="Attendancestatist.reset();" class="common_button common_button_emphasize margin_r_10 common_button_reset">${ctp:i18n('attendance.common.reset')}</a>
        </div>
    </div>  
    <div class="classification statist-list" id="statist-list">
        <table id="statistTable" style="display: none"></table>
    </div>  
     <!-- 当月第一天 -->
     <input type="hidden" id="firstDayMonth" value="${startTime }">
     <!-- 当月最后一天 -->
     <input type="hidden" id="lastDayMonth" value="${endTime }">
</body>
    <%@include file="/WEB-INF/jsp/common/common_footer.jsp"%>
    <script type="text/javascript" src="${path}/common/js/laytpl.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" src="${path}/apps_res/attendance/js/personalStatistic.js${ctp:resSuffix()}"></script>
</html>