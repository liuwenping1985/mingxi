<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/apps_res/attendance/css/common.css${ctp:resSuffix()}"/>
	<link rel="stylesheet" type="text/css" href="${path}/apps_res/attendance/css/index.css${ctp:resSuffix()}"/>
	<title></title>
	<style>
		#start_time_list, #end_time_list, #select_type {margin-bottom: 5px; padding-top: 1px; padding-left: 10px; font-size: 14px; color: #333; width: 132px; height: 28px;}
		#select_type { height: 31px;}
		.common_button_reset { color: #333; border: 1px solid #d1d4db; background: #fff; margin-left: 10px;}
		.common_button_reset:hover { color: #333; border: 1px solid #d1d4db; background: #fff;}
		.calendar_icon_area { position: absolute;}
		.calendar_icon { top: 8px !important; right: 0 !important;}
		
		.northLayoutDiv{width: 100%; margin-right: 5px; left: 0px; top: 0px; border-width: 0px; z-index: 1; display: block; background: #fff; margin-top: 10px;}
		.tbox{height: 40px; white-space: nowrap; width: auto;padding-top: 9px;margin: 0 20px; overflow: hidden; border-bottom: 1px dashed #e5e5e5;}
	    .topea{height: 40px; width: 100%; text-align: center;padding-top: 10px;}
	    
	    /* tips */
	    .tip-area{z-index: 98;position: absolute;display: none;}
	    .tip-ab{position: absolute;top: opx;left: 0px;}
	    .tip-bg{z-index:99;display: block;background:#000;background: rgba(0,0,0,.7);padding: 7px;border-radius: 5px;}
	    .tip-content{z-index:100;display: block;color: #fff;word-wrap:break-word;white-space: normal;max-width: 352px;line-height:19px;padding: 7px;}
	</style>
</head>
<body class="h100b over_hidden page_color">
	<div class="tip-area">
		<span class="tip-ab tip-bg"></span>
		<span class="tip-ab tip-content"></span>
	</div>
	<div class="northLayoutDiv">
		<div class="tbox">
			<label> 
				<span style="font-size: 14px; color: #999;">${ctp:i18n('attendance.common.type')}:</span> 
			</label>
			<label style="margin-left:14px;"> 
				<select id="select_type" name="" style="vertical-align: top">
					<option value="1,2,3" selected="selected">${ctp:i18n('attendance.common.all')}</option>
					<option value="1">${ctp:i18n('attendance.common.clockin')}</option>
					<option value="2">${ctp:i18n('attendance.common.clockout')}</option>
					<option value="3">${ctp:i18n('attendance.common.outside')}</option>
				</select> 
			</label>
			<label style="margin-left:14px;"> 
				<span style="font-size: 14px; color: #999;">${ctp:i18n('attendance.common.time')}</span> 
			</label>
			<label style="margin-left:-2px;"> 
				<input id="start_time_list" type="text" readonly="readonly" value="${startTime}" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d',cache:false" /> 
			</label>
			<label style="margin-left:4px;"> 
				<span style="font-size: 14px; color: #999;">-</span> 
			</label>
			<label style="margin-left:4px;">
				<input id="end_time_list" type="text" readonly="readonly" value="${endTime}" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d',cache:false" />
			</label>
			<label id="authScopeLable" style="margin-left:4px;display: none;">
				<span style="font-size: 14px; color: #999;margin-right: 10px">${ctp:i18n("attendance.common.authscope")}</span>
				<label for="range_mine" class="margin_r_10 hand"><input type="radio" value="mine" id="range_mine" name="range_auth" class="radio_com" checked onclick="detailsObj.changeRange('mine')">${ctp:i18n('attendance.common.mine')}</label>
				<label for="range_authorize" class="margin_r_10 hand"><input type="radio" value="auth" id="range_authorize" name="range_auth" class="radio_com" onclick="detailsObj.changeRange('auth')">${ctp:i18n('attendance.common.authrize')}</label>
				<label><input type="text" id="selectRange" readonly="readonly" disabled="disabled" onclick="detailsObj.getRange();"/></label>
			</label>
		</div>
		<div class="topea">
			<a href="javascript:void(0)" onclick="detailsObj.query()" class="common_button common_button_emphasize">${ctp:i18n('attendance.common.check')}</a> 
			<a href="javascript:void(0)" class="common_button common_button_emphasize margin_r_10 common_button_reset" id="rest" onclick="detailsObj.reset()">${ctp:i18n('attendance.common.reset')}</a>
		</div>
	</div>
	<div class="classification" style="margin-top: 10px; background: #fff; padding: 10px; position: relative;">
		<div>
			<a class="img-button margin_r_5" href="javascript:void(0)" onclick="detailsObj.print();" style="width: 50px; padding: 0 5px; line-height: 21px;">
				<em class="ico16 print_16" style="margin-right: 0;"></em> 
				<span style="font-size: 12px;">${ctp:i18n("attendance.message.print")}</span> 
			</a>
		</div>
		<div id="list_div_c" class="list" style="margin-top: 10px;">
			<table id="myList_person_details" style="display: none"></table>
		</div>
		<div id="printDiv" class="hide"></div>
	</div>
	<!-- 当月第一天 -->
    <input type="hidden" id="firstDayMonth" value="${startTime }">
    <!-- 当月最后一天 -->
    <input type="hidden" id="lastDayMonth" value="${endTime }">
</body>
    <%@include file="/WEB-INF/jsp/common/common_footer.jsp"%>
    <script type="text/javascript" src="${path}/common/js/laytpl.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" src="${path}/apps_res/attendance/js/personalDetails.js${ctp:resSuffix()}"></script>
    <script type="text/javascript">
	    /**
	     * 定义attendanceObj对象
	     */
	    $(function(){
	    	$("#myList_person_details").ajaxgrid({
	    	      colModel : [{
                      display : "${ctp:i18n('attendance.common.name')}",
                      name : 'membername',
                      width : '10%',
                      sortable : true,
                      align : 'left'
                  },{
	    	        display : "${ctp:i18n('attendance.common.time2')}",
	    	        name : 'signtime',
	    	        width : '15%',
	    	        sortable : true,
	    	        align : 'left'
	    	      },{
	    	        display : "${ctp:i18n('attendance.common.practicaltime')}",
	    	        name : 'fixtime',
	    	        width : '10%',
	    	        sortable : true,
	    	        align : 'left'
	    	      },{
	    	        display : "${ctp:i18n('attendance.common.type')}",
	    	        name : 'signtype',
	    	        width : '10%',
	    	        sortable : true,
	    	        align : 'left'
	    	      },{
	    	        display : "${ctp:i18n('attendance.common.add')}",
	    	        name : 'sign',
	    	        width : '30%',
	    	        sortable : true,
	    	        align : 'left',
	    	      },{
		    	        display : "${ctp:i18n('attendance.common.modifyNum')}",
		    	        name : 'modifynum',
		    	        width : '10%',
		    	        sortable : true,
		    	        align : 'left'
			       },{
	    	        display : "${ctp:i18n('attendance.common.ps')}",
	    	        name : 'remark',
	    	        width : '33%',
	    	        sortable : true,
	    	        align : 'left'
	    	      }],
	    	      height:initHeight(),
	    	      resizable:false,
	    	      render :rendTable,
	    	      managerName : "attendanceManager",
	    	      managerMethod : "findPersonAttendanceInfoData"
	    	})
	    	//加载表格数据
	    	detailsObj.conditions = detailsObj.getCondition();
	    	$("#myList_person_details").ajaxgridLoad(detailsObj.conditions);
	    	//detailsObj.initTips();
			//初始化
            detailsObj.init();
	    });
    </script>
</html>