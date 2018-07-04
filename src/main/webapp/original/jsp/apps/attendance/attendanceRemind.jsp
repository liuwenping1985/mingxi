<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<style>
		body { font-size: 12px; background-color: #F0F0F0;}
		.stadic_head_height { height: 30px;}
		.stadic_body_top_bottom { bottom: 0px; top: 30px;}
		select {padding-top: 1px; padding-left: 10px; font-size: 14px; color: #333; width: 132px; height: 28px;}
		.common_button_reset { color: #333; border: 1px solid #d1d4db; background: #fff;}
		.common_button_reset:hover {color: #333; border: 1px solid #d1d4db; background: #fff;}
	</style>
 </head>
 <body class="h100b over_hidden">
	<div class="stadic_layout">
		<div class="stadic_layout_head stadic_head_height" style="height: 103px; margin-top: 12px;">
			<form id="remindForm" method="post" style="background-color: #fff;">
				<table width="100%">
					<tr height="48">
						<td>
							<div style="height: 48px; border-bottom: 1px dashed #e5e5e5; margin: 0 20px;">
								<div style="padding-top: 9px;">
									<label> 
										<span style="font-size: 14px; color: #999;">${ctp:i18n('attendance.common.morning')}</span> 
									</label>
									<label> ${attendRemindHtml} </label>
									<label style="margin-left:80px;"> 
										<span style="font-size: 14px; color: #999;">${ctp:i18n('attendance.common.afternoon')}</span> 
									</label>
									<label> ${leaveRemindHtml } </label>
								</div>
							</div>
						</td>
					</tr>
					<tr height="48">
						<td>
							<div style="width: 100%; text-align: center;">
								<a href="javascript:void(0)" class="common_button common_button_emphasize margin_r_10" onclick="AttendanceRemind.modify()">${ctp:i18n('common.button.ok.label')}</a> <a href="javascript:void(0)" class="common_button common_button_emphasize margin_r_10 common_button_reset" onclick="AttendanceRemind.rest()">${ctp:i18n('common.button.reset.label')}</a>
							</div>
						</td>
					</tr>
				</table>
			</form>
			<!-- 上班签到提醒 -->
			<input type="hidden" id="attend" value="${attendRemind }" />
			<!-- 下班签退提醒 -->
			<input type="hidden" id="leave" value="${leaveRemind }" />
		</div>
	</div>
</body>
    <%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
    <script type="text/javascript" src="${path}/apps_res/attendance/js/attendanceRemind.js${ctp:resSuffix()}"></script>
</html>

