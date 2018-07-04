<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../../common/common.jsp"%>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=m3XiaoZhiAuthManager"></script>
<script type="text/javascript"
	src="${path}/apps_res/m3/js/xiaozhi_auth.js"></script>
<link rel="stylesheet" href="${path}/apps_res/m3/css/xiaozhi_auth.css">
<script type="text/javascript">
 	var maxandroid = ${maxandroid};
 	var maxiphone = ${maxiphone};
</script>
<style>
.stadic_head_height {
	height: 0px;
}

.stadic_body_top_bottom {
	bottom: 30px;
	top: 0px;
}

.stadic_footer_height {
	height: 37px;
}
</style>

</head>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
		<!--  <div class="comp" comp="type:'breadcrumb',code:'T02_showPostframe'"></div>  -->
		<div class="layout_north" layout="height:40,sprit:false,border:false">
			<div id="toolbar"></div>
			<div id="searchDiv"></div>
		</div>
		<div class="layout_center over_hidden" layout="border:false"
			id="center">
			<table id="mytable" class="flexme3" border="0" cellspacing="0"
				cellpadding="0"></table>
			<div id="grid_detail" class="relative">
				<div class="stadic_layout">
					<div class="stadic_layout_head stadic_head_height"></div>
					<div class="stadic_layout_body stadic_body_top_bottom">
						<div id="welcome">
							<div class="color_gray margin_l_20">
								<div class="clearfix">
									<br />
									<div class="font_size12 left margin_t_20 margin_l_10">
										<div class="margin_t_10 font_size14">
											<table>
												<thead>
													<tr>
														<td>${ctp:i18n('m3.xiaozhi.client.type.android') }</td>
														<td>${ctp:i18n('m3.xiaozhi.client.type.iphone') }</td>
													</tr>
												</thead>
												<tbody>
													<tr>
														<td>${ctp:i18n('m3.xiaozhi.member.auth.android') }:${orgAuthInfo.androidCount }</td>
														<td>${ctp:i18n('m3.xiaozhi.member.auth.iphone') }:${orgAuthInfo.iphoneCount }</td>
													</tr>
													<tr>
														<td>${ctp:i18n('m3.xiaozhi.member.used.count')}:<font id = "welcome_androidUsed">${orgAuthInfo.androidUsed }</font></td>
														<td>${ctp:i18n('m3.xiaozhi.member.used.count')}:<font id = "welcome_iphoneUsed">${orgAuthInfo.iphoneUsed }</font></td>
													</tr>
													<tr>
														<td>${ctp:i18n('m3.xiaozhi.member.surplus.count')}:<font id = "welcome_androidResidue">${orgAuthInfo.androidResidue }</font></td>
														<td>${ctp:i18n('m3.xiaozhi.member.surplus.count')}:<font id = "welcome_iphoneResidue">${orgAuthInfo.iphoneResidue }</font></td>
													</tr>
													<tr>
														<td>${ctp:i18n('m3.xiaozhi.member.recovery.count')}:<font
															color="blue" id = "welcome_androidRelease">${orgAuthInfo.androidRelease }</font></td>
														<td>${ctp:i18n('m3.xiaozhi.member.recovery.count')}:<font
															color="blue" id = "welcome_iphoneRelease">${orgAuthInfo.iphoneRelease }</font></td>
													</tr>
												</tbody>
												<tfoot>
													<tr>
														<td>${ctp:i18n('m3.xiaozhi.member.auth.explain')}</td>
													</tr>
												</tfoot>
											</table>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div id="form_area" class="form_area">
							<%@include file="xiaozhiAuthForm.jsp"%></div>
					</div>
					<div class="stadic_layout_footer stadic_footer_height">
						<div id="button" align="center"
							class="page_color button_container">
							<div
								class="common_checkbox_box clearfix stadic_footer_height padding_t_5 border_t">
								<label for="conti" class="margin_r_10" id="lconti"> <input
									type="checkbox" id="conti" class="radio_com">${ctp:i18n('continuous.add')}</label>
								<a id="btnok" href="javascript:void(0)"
									class="common_button common_button_emphasize margin_r_10">${ctp:i18n('common.button.ok.label')}</a>
								<a id="btncancel" href="javascript:void(0)"
									class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<iframe width="0" height="0" name="exportIFrame" id="exportIFrame"></iframe>
</body>
</html>