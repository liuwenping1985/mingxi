<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
<title>${ctp:i18n('attendance.common.personalAt')}</title>
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
                 comp="cache:false,type:&quot;calendar&quot;,ifFormat:&quot;%Y-%m-%d&quot;" comptype="calendar" _inited="1" value="${startTime}">
             </label>
             <label style="margin-left:10px;">
                 <span style="font-size:14px;color:#999;">-</span>
             </label>
             <label style="margin-left:10px;">
                 <input id="endTime" name="endTime" readonly="readonly" type="text" class="comp mycal validate" validate="notNull:true" readonly="true" 
                 comp="cache:false,type:&quot;calendar&quot;,ifFormat:&quot;%Y-%m-%d&quot;" comptype="calendar" _inited="1" value="${endTime}">
             </label>
             
             <label style="margin-left: 14px;"> 
			 	<span style="font-size: 14px; color: rgb(179, 179, 179);">${ctp:i18n('attendance.label.peopleAt')}</span>
			 	<input id="memberName" type="text" name="memberName">
			 </label>
        </div>
        <div class="btns" >
            <a href="javascript:void(0)" onclick="personalAt.loadGrid();" class="common_button common_button_emphasize">${ctp:i18n('attendance.common.check')}</a>
            <a href="javascript:void(0)" onclick="personalAt.reset();" class="common_button common_button_emphasize margin_r_10 common_button_reset">${ctp:i18n('attendance.common.reset')}</a>
        	<input type="hidden" id="hideStartTime" value="${startTime}">
        	<input type="hidden" id="hideEndTime" value="${endTime}">
        </div>
    </div>  
    <div class="classification statist-list" id="statist-list">
        <table id="atTable" style="display: none"></table>
    </div>
    
<%@include file="/WEB-INF/jsp/common/common_footer.jsp"%>
<script type="text/javascript">

$(function(){
	personalAt.initGrid();
	personalAt.loadGrid();
});

var personalAt = {
	initGrid : function(){
		$("#atTable").ajaxgrid({
		    colModel : [{
		    	display : "${ctp:i18n('attendance.label.peopleAt')}",
			    name : 'ownerName',
			    width : '10%',
			    sortable : true,
			    align : 'left'
		    },{
		      display : "${ctp:i18n('attendance.common.time2')}",
		      name : 'signTime',
		      width : '15%',
		      sortable : true,
		      align : 'left'
		    },{
		      display : "${ctp:i18n('attendance.common.practicaltime')}",
		      name : 'fixTime',
		      width : '10%',
		      sortable : true,
		      align : 'left'
		    },{
		      display : "${ctp:i18n('attendance.common.type')}",
		      name : 'typeDisplay',
		      width : '10%',
		      sortable : true,
		      align : 'left'
		    },{
		      display : "${ctp:i18n('attendance.common.add')}",
		      name : 'sign',
		      width : '25%',
		      sortable : true,
		      align : 'left'
		    },{
		      display : "${ctp:i18n('attendance.common.ps')}",
		      name : 'remark',
		      width : '28%',
		      sortable : true,
		      align : 'left'
		    }],
		    height: $("body").height() - $("#statist-list").offset().top - 50,
		    resizable:false,
		    managerName : "attendanceManager",
		    managerMethod : "findMentionedMeAttendance"
		});
	},
	loadGrid : function(){
		//加载表格数据
		var conditions = personalAt.getCondition();
		var startTime = conditions.startTime;
		var endTime = conditions.endTime; 
		if(startTime == '' || endTime == ''){
			$.alert($.i18n("attendance.common.jserror2"));
			return false;
		}
		if(Date.parse(startTime) > Date.parse(endTime)){
			$.alert($.i18n("attendance.common.jserror1"));
			return false;
		}
		var startYear = startTime.substr(0, 4);
		var endYear = endTime.substr(0, 4);
		var startMonth = startTime.substr(5, 2);
		var endMonth = endTime.substr(5, 2);
		var len = (endYear - startYear) * 12 + (endMonth - startMonth);
		var startDay = startTime.substr(8,2);
		var endDay = endTime.substr(8,2);
		if(len == 12 && startDay < endDay){
			$.alert($.i18n("attendance.message.ex11"));
			return false;
		}
		if(len > 12){
			$.alert($.i18n("attendance.message.ex11"));
			return false;
		}
		$("#atTable").ajaxgridLoad(conditions);
	},
	getCondition : function(){
		var condition = {
			startTime : $("#startTime").val(),
			endTime : $("#endTime").val(),
			memberName : $("#memberName").val()
		}
		return condition;
	},
	reset : function(){
		$("#startTime").val($("#hideStartTime").val());
		$("#endTime").val($("#hideEndTime").val());
		$("#memberName").val("");
	}
}

</script>
</body>
</html>