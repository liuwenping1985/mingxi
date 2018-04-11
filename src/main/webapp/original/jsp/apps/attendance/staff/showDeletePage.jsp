<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
   <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
   <style>
	    .stadic_head_height{height:30px}
		.stadic_body_top_bottom{top:100px;bottom:100px}
		.stadic_footer_height{height:50px;color:red}
		.common_selectbox_wrap{width:100px;margin-left:0}
   </style>
</head>
<body class="h100b over_hidden">
    <div class="stadic_layout">
        <div style="margin:34px 24px 50px 24px;width:100%">
        	<label class="left" style="font-size:14px;color:#333;padding-top:5px;">${ctp:i18n('attendance.common.select')}</label>
            <div class="common_selectbox_wrap" style="width:185px;">
				<select id="clearRange" style="color:#333;">
					<option value="1" selected>${ctp:i18n('attendance.common.month1')}</option>
					<option value="2">${ctp:i18n('attendance.common.month3')}</option>
					<option value="3">${ctp:i18n('attendance.common.month6')}</option>
					<option value="4">${ctp:i18n('attendance.common.month9')}</option>
					<option value="5">${ctp:i18n('attendance.common.year1')}</option>
					<option value="6">${ctp:i18n('attendance.common.year2')}</option>
					<option value="7">${ctp:i18n('attendance.common.year3')}</option>
					<option value="8">${ctp:i18n('attendance.common.year5')}</option>
				</select>
			</div>
        </div>
        <div style="margin:0 24px;font-size:14px;color:#ff0303;">
            <label>${ctp:i18n('attendance.common.showlabel')}</label>
        </div>
    </div>
</body>
   <%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
   <script type="text/javascript">
   	function OK(){
   		var obj = new Object();
   		obj["earlySign"] = "${earlySign}";
   		obj["clearRange"] = $("#clearRange").val();
   		obj["clearTitle"] = $("#clearRange>option:selected").html();
   		return obj;
   	}
   </script>
</html>