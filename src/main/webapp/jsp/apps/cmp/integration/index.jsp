<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../../common/common.jsp"%>
<script type="text/javascript" charset="UTF-8"
	src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
    var v3x = new V3X();
    v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
    v3x.loadLanguage("/common/js/i18n");
</script>	


<%@ include file="./index_js.jsp"%>
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
		<div class="layout_north" layout="height:30,sprit:false,border:false">
			<div id="toolbar"></div>
			<div id="searchDiv"></div>
		</div>
		<div class="layout_center over_hidden" layout="border:false"
			id="center">
			<table id="gridTable" class="flexme3" border="0" cellspacing="0"
				cellpadding="0"></table>
			<div id="grid_detail" class="relative">
				<div class="stadic_layout">
					<div class="stadic_layout_head stadic_head_height"></div>
					<div class="stadic_layout_body stadic_body_top_bottom">
						<div id="welcome">
							<div class="color_gray margin_l_20">
								<div class="clearfix">
									<h2 id="welcomeTitle" class="left"
										style="font-size: 26px; font-family: Verdana; font-weight: bolder; color: #888888;"></h2>
									<div class="font_size12 left margin_t_20 margin_l_10">
										<div class="margin_t_10 font_size14">
											<span id="count"></span>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div id="appMgrForm">
							<%@include file="appMagrForm.jsp"%>
						</div>
					</div>
					<div class="stadic_layout_footer stadic_footer_height">
						<div id="button" align="center"
							class="page_color button_container">
							<div
								class="common_checkbox_box clearfix stadic_footer_height padding_t_5 border_t">
								<a id="btnok" href="javascript:void(0)"
									class="common_button common_button_gray margin_r_10">确定</a> <a
									id="btncancel" href="javascript:void(0)"
									class="common_button common_button_gray">取消</a>
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