<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/WEB-INF/jsp/ctp/view/operationcenter/i18n/i18nMain_js.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
</head>
<body  class="body-pading" leftmargin="0" topmargin="" marginwidth="0"
marginheight="0">
	<div id='layout' class="comp" comp="type:'layout'">
	    <div class="comp" comp="type:'breadcrumb',code:'T02_i18n'"></div>
		<div class="layout_north" layout="height:30,sprit:false,border:false">
	        <div id="tabs" class="common_tabs clearfix margin_t_5">
	            <ul class="left margin_l_10">
	                <li id="zh_CN" class="current"><a  hideFocus="true" href="javascript:tabrelaod('zh_CN')" >${ctp:i18n('i18nresource.chinese.info')}</a></li>
	                <li id="en"><a  href="javascript:tabrelaod('en')">${ctp:i18n('i18nresource.english.info')}</a></li>
	                <li id="zh_TW"><a  href="javascript:tabrelaod('zh_TW')">${ctp:i18n('i18nresource.taiwan.info')}</a></li>
	                <li id="custom"><a  href="javascript:tabrelaod('custom')">${ctp:i18n('i18nresource.custom.info')}</a></li>
	            </ul>
	        </div>
		</div>
		<div id='layoutCenter' class="layout_center over_hidden" layout="border:true">
            <div id="toolbar"></div>
            <div id="searchDiv"></div>
		<div class="stadic_layout">
			<div id='roleList_stadic_body_top_bottom' class="stadic_layout_body stadic_body_top_bottom" style="top:1px">
				<table id="mytable" class="mytable" style="display: none"></table>
				<div>
					<div id="welcome">
						<div class="color_gray margin_l_20">
							<div class="clearfix">
								<h2 class="left" style="font-size: 26px;font-family: Verdana;font-weight: bolder;color: #888888;"></h2>
								<div class="font_size12 left margin_t_20 margin_l_10">
									<div class="margin_t_10 font_size14">
										<span id="count"></span>
									</div>
								</div>
							</div>
							<div class="line_height160 font_size14" style="overflow:auto"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>