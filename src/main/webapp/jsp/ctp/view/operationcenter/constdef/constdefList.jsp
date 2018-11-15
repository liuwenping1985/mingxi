<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/WEB-INF/jsp/ctp/view/operationcenter/constdef/constdefList_js.jsp"%>
<html>
<head>
<style>
.stadic_head_height {
	height: 26px;
}

.stadic_body_top_bottom {
	bottom: 0px;
	top: 0px;
	overflow: hidden;
}
</style>
</head>
<body class="body-pading" leftmargin="0" topmargin="" marginwidth="0"
	marginheight="0">
	<div class="comp" comp="type:'breadcrumb',code:'T02_constdef'"></div>
	<div id='layout' class="comp" comp="type:'layout'">
		<div class="layout_north" layout="height:30,sprit:false,border:false">
			<div id="toolbar"></div>
			<div id="searchDiv"></div>
		</div>
		<div id='layoutCenter' class="layout_center over_hidden"
			layout="border:true">
			<div class="stadic_layout">
				<div id='roleList_stadic_body_top_bottom'
					class="stadic_layout_body stadic_body_top_bottom">
					<table id="mytable" class="mytable" style="display: none"></table>
					<div id="grid_detail">
						<div id="welcome">
							<div class="color_gray margin_l_20">
								<div class="clearfix">
									<h2 class="left"
										style="font-size: 26px; font-family: Verdana; font-weight: bolder; color: #888888;">常量管理</h2>
									<div class="font_size12 left margin_t_20 margin_l_10">
										<div class="margin_t_10 font_size14">
											<span id="count"></span>
										</div>
									</div>
								</div>
								<div class="line_height160 font_size14" style="overflow: auto">
									.单击“新建”菜单，新建常量</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
