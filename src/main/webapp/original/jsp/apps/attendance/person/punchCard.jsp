<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<title></title>
	<style>
		.card-date{width:100%;height:42px;line-height:42px;background-color:#f6f6f6;text-align:left}
		.card-date span{font-size:14px;color:#666}
		.card-punch{position: relative; margin: 0 30px; min-height: 130px; border-bottom: 1px solid #eee;}
		.card-punch-end{width:74px;height:74px;border:1px solid #e7e7e7;background-color:#f5f5f5;border-radius:100%;cursor:default}
		.card-punch-end-inner{width:66px;height:66px;background-color:#cfd6dc;border-radius:100%;margin-top:4px;margin-left:4px;text-align:center}
		.card-punch-start{width:74px;height:74px;border:1px solid #b4dbff;background-color:#d3eaff;border-radius:100%;cursor:pointer}
		.card-punch-start-inner{width:66px;height:66px;background-color:#51abff;border-radius:100%;margin-top:4px;margin-left:4px;text-align:center}
		textarea{font-size:14px}
		
		.punch-ip{color: #333; display: inline-block; overflow: hidden; text-overflow: ellipsis; line-height: 14px; height:14px;white-space: nowrap;}
	    .singn-content{width: 85%; float: left;display: inline-block;font-size: 14px; color: #333; resize: none; word-wrap: break-word;padding-top:3px;}
	    .singn-edit-area{width: 100%; max-width: 880px; border: 1px solid #0088ff; max-height: 68px; display: none; padding-left: 5px; overflow-y: auto; overflow-x: hidden;}
	</style>
</head>
<body scroll="no" style="overflow: hidden; text-align: center; background: #fafafa;width: 100%;">
	<div style="background: #fff; margin-top: 20px; border: 1px solid #e2e2e2; border-radius: 5px;width: 99%;">
		<div class="card-date">
			<div style="padding-left: 20px; background-color: #f6f6f6;">
				<span>${today}</span>
			</div>
		</div>
		
		<div style="width: 100%;">
			<div class="card-punch">
				<div style="position: absolute; width: 92px; left: 0; top: 28px;">
					<c:choose>
						<c:when test="${canAttend == true}">
							<%-- 可签到样式 --%>
							<div onclick="punchCard.signIn(this,'${userAccountId}');" class="card-punch-start">
								<div class="card-punch-start-inner">
									<div style="width: 100%; padding-top: 22px;">
										<span style="font-size: 14px; color: #fff;">${ctp:i18n('attendance.common.punchcard')}</span>
									</div>
								</div>
							</div>
						</c:when>
						<c:otherwise>
							<%-- 不可签到样式 --%>
							<div class="card-punch-end">
								<div class="card-punch-end-inner">
									<div style="width: 100%; padding-top: 22px;">
										<span style="font-size: 14px; color: #fff;">${ctp:i18n('attendance.common.punchcard')}</span>
									</div>
								</div>
							</div>
						</c:otherwise>
					</c:choose>
				</div>

				<div style="padding-top: 40px; padding-left: 96px; padding-bottom: 20px;">
					<div style="text-align: left;">
						<span style="display: inline-block;">
							<span style="font-size: 14px; color: #999;">${ctp:i18n('attendance.common.worktime')}</span>
						</span> 
						<span style="display: inline-block;">
							<span style="font-size: 14px; color: #999;">${requiredSignin}</span>
						</span>
						<c:choose>
							<c:when test="${signin.id == null}">
								<%-- 未签到样式 --%>
								<span class="punch-dialog" style="display: inline-block; margin-left: 66px">
									<span style="font-size: 14px; color: #ff0000;">${ctp:i18n('attendance.common.notpunch')}</span>
								</span>
							</c:when>
							<c:otherwise>
								<%-- 已签到样式 --%>
								<span class="punch-dialog" style="display: inline-block; margin-left: 66px">
									<span style="font-size: 14px; color: #999;">${ctp:i18n('attendance.common.clockintime')}</span>
								</span>
								<span style="display: inline-block;">
									<span style="font-size: 14px; color: #333;">${ctp:formatDateByPatternNoTimeZone(signin.signTime,'HH:mm')}</span>
								</span>
								<span class="punch-dialog" style="display: inline-block; margin-left: 66px">
									<span style="font-size: 14px; color: #999;">${ctp:i18n('attendance.common.clockinadd')}</span>
								</span>
								<span style="display: inline-block;">
									<span class="punch-dialog-signadd" style="font-size: 14px;">
										${signin.sign}
									</span>
								</span>
							</c:otherwise>
						</c:choose>
					</div>

					<div style="text-align: left; margin-top: 6px; width: 100%;">
						<c:choose>
							<c:when test="${canAttend == true}">
								<%-- 可签到样式 --%>
								<div style="float: left;">
									<span style="font-size: 14px; color: #0088ff; cursor: pointer" onclick="showTextarea('signin_remark',this);">${ctp:i18n('attendance.common.ps')}</span>
								</div>
								<div style="width: 95%; float: left; margin-left: 5px;">
									<textarea id="signin_remark" class="singn-edit-area" rows="5" cols="10" maxlength="140" ></textarea>
								</div>
								<div style="clear: both;"></div>
							</c:when>
							<c:otherwise>
								<%-- 不可签到样式 --%>
								<div style="float: left; width: 45px;display: inline-block;">
									<span style="font-size: 14px; color: #999; cursor: default">${ctp:i18n('attendance.common.ps')}</span>
								</div>
								<c:choose>
									<c:when test="${not empty signin.remark}">
										<div id="singnInRemark" class="singn-content" >
											<span>${ctp:toHTMLWithoutSpace(signin.remark)}</span>
										</div>
									</c:when>
									<c:otherwise>
										<span style="font-size: 16px; color: #333; resize: none">${ctp:i18n('attendance.common.no')}</span>
									</c:otherwise>
								</c:choose>

								<div style="clear: both;"></div>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</div>
		</div>




		<div style="width: 100%;">
			<div class="card-punch" >
				<div style="position: absolute; width: 92px; left: 0; top: 28px;">
					<c:choose>
						<c:when test="${canLeave == true}">
							<%-- 可签到样式 --%>
							<div onclick="punchCard.signOut(this,'${userAccountId}');" class="card-punch-start">
								<div class="card-punch-start-inner">
									<div style="width: 100%; padding-top: 22px;">
										<span style="font-size: 14px; color: #fff;">${ctp:i18n('attendance.common.punchcardoff')}</span>
									</div>
								</div>
							</div>
						</c:when>
						<c:otherwise>
							<%-- 不可签到样式 --%>
							<div class="card-punch-end">
								<div class="card-punch-end-inner">
									<div style="width: 100%; padding-top: 22px;">
										<span style="font-size: 14px; color: #fff;">${ctp:i18n('attendance.common.punchcardoff')}</span>
									</div>
								</div>
							</div>
						</c:otherwise>
					</c:choose>
				</div>

				<div style="padding-top: 40px; padding-left: 96px; padding-bottom: 20px;">
					<div style="text-align: left;">
						<span style="display: inline-block;">
							<span style="font-size: 14px; color: #999;">${ctp:i18n('attendance.common.offtime')}</span>
						</span> 
						<span style="display: inline-block;">
							<span style="font-size: 14px; color: #999;">${requiredsignout}</span>
						</span>
						<c:choose>
							<c:when test="${signout.id == null}">
								<%-- 未签到样式 --%>
								<span class="punch-dialog" style="display: inline-block; margin-left: 66px">
									<span style="font-size: 14px; color: #ff0000;">${ctp:i18n('attendance.common.notoff')}</span>
								</span>
							</c:when>
							<c:otherwise>
								<%-- 已签到样式 --%>
								<span class="punch-dialog" style="display: inline-block; margin-left: 66px">
									<span style="font-size: 14px; color: #999;">${ctp:i18n('attendance.common.clockouttime')}</span>
								</span>
								<span style="display: inline-block;">
									<span style="font-size: 14px; color: #333;">${ctp:formatDateByPatternNoTimeZone(signout.signTime,'HH:mm')}</span>
								</span>
								<span class="punch-dialog" style="display: inline-block; margin-left: 66px">
									<span style="font-size: 14px; color: #999;">${ctp:i18n('attendance.common.clockoutadd')}</span>
								</span>
								<span style="display: inline-block;"> 
									<span class="punch-dialog-signadd" style="font-size: 14px;">${signout.sign}</span>
								</span>
							</c:otherwise>
						</c:choose>
					</div>

					<div style="text-align: left; margin-top: 6px; width: 100%;">
						<c:choose>
							<c:when test="${canLeave == true}">
								<%-- 可签到样式 --%>
								<div style="float: left;">
									<span style="font-size: 14px; color: #0088ff; cursor: pointer" onclick="showTextarea('signout_remark',this);">${ctp:i18n('attendance.common.ps')}</span>
								</div>
								<div style="width: 95%; float: left; margin-left: 5px;">
									<textarea id="signout_remark" class="singn-edit-area" rows="5" cols="10" maxlength="140" ></textarea>
								</div>
								<div style="clear: both;"></div>
							</c:when>
							<c:otherwise>
								<%-- 不可签到样式 --%>
								<div style="float: left; width: 45px;display: inline-block;">
									<span style="font-size: 14px; color: #999; cursor: default">${ctp:i18n('attendance.common.ps')}</span>
								</div>
								<c:choose>
									<c:when test="${not empty signout.remark}">
										<div id="singnOutRemark" class="singn-content">
											${ctp:toHTMLWithoutSpace(signout.remark)}
										</div>
									</c:when>
									<c:otherwise>
										<span style="font-size: 16px; color: #333; resize: none">${ctp:i18n('attendance.common.no')}</span>
									</c:otherwise>
								</c:choose>
								<div style="clear: both;"></div>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
<%-- 平台的js --%>
<%@include file="/WEB-INF/jsp/common/common_footer.jsp"%>
<script type="text/javascript" src="${path}/apps_res/attendance/js/punchCard.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
	$(function() {
		$("#signout_remark,#signin_remark").bind("keyup", function(e) {
			var _this = $(this);
			var _value = _this.val();
			if (_value.length >= 140 && e.keyCode != 8) {
				if ((e.keyCode >= 65 && e.keyCode <= 90) 
						|| (e.keyCode >= 48 && e.keyCode <= 57) 
						|| (e.keyCode >= 96 && e.keyCode <= 111) 
						|| (e.keyCode >= 186 && e.keyCode <= 222) 
						|| e.keyCode == 32 
						|| e.keyCode == 13){
					_this.val(_value.substring(0, 140));
					$(this).blur();
					$.alert($.i18n("attendance.common.notewarn"));
				}
			}
		}).bind("blur", function() {
			if ($(this).val() == '') {
				$(this).css({
					"display" : "none"
				});
				$(this).parent().parent().parent().parent().css({
					"height" : +$(this).parent().parent().parent().height() + "px"
				});
			}
		});
	
	});
	if ($(window).width() <= 800) {
		$(".punch-dialog").css({"margin-left" : "30px"});
		$(".punch-dialog-signadd").css({"width" : "144px"}).addClass("punch-ip");
		$(".singn-content").css({"width" : "535px"});
	}
	function showTextarea(_target, _this) {
		$('#' + _target).css({
			'display' : 'block'
		});
		$('#' + _target).focus();
		$(_this).parent().parent().parent().parent().css({
			"height" : +$(_this).parent().parent().parent().height() + 55 + "px"
		});
	}
</script>
</html>