<%--
 $Author: lilong $
 $Rev: 35956 $
 $Date:: 2014-05-04 14:04:50#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/WEB-INF/jsp/apps/organization/role/roleList_js.jsp"%>
<html>
<head>
<style>
	.stadic_head_height{
		height:26px;
	}
	.stadic_body_top_bottom{
		bottom: 0px;
 		top: 26px;
 		overflow:hidden;
	}
</style>
</head>
<body class="body-pading" leftmargin="0" topmargin="" marginwidth="0"
marginheight="0">
	<div id='layout' class="comp" comp="type:'layout'">
	<div class="comp" comp="type:'breadcrumb',code:'T02_showRoleList'"></div>
		<div class="layout_north" layout="height:30,sprit:false,border:false">
			<div id="toolbar"></div>
			<div id="searchDiv"></div>
		</div>
		<div id='layoutCenter' class="layout_center over_hidden" layout="border:false">
	
		<div class="stadic_layout">
			<div class="stadic_layout_head stadic_head_height">
				<div class="common_tabs page_color clearfix" id="tabs">
				    <ul class="left">
				    	<c:if test="${CurrentUser.groupAdmin==true}">
				    	<li class="current"><a id="tab0" hidefocus="true" href="javascript:void(0)" class="no_b_border">${ctp:i18n("role.group")}</a></li>
				    	<li ><a id="tab1" hidefocus="true" href="javascript:void(0)" class="no_b_border">${ctp:i18n("role.unit")}</a></li>
				    	</c:if>
				        <c:if test="${CurrentUser.groupAdmin==false}">
				    	
				    	<li class="current"><a id="tab1" hidefocus="true" href="javascript:void(0)" class="no_b_border">${ctp:i18n("role.unit")}</a></li>
				    	</c:if>
				        
				        <li><a id="tab2" hidefocus="true" href="javascript:void(0)" class="last_tab no_b_border">${ctp:i18n("role.dept")}</a></li>
				    </ul>
				</div>
			</div>
			<div id='roleList_stadic_body_top_bottom' class="stadic_layout_body stadic_body_top_bottom">
				<table id="mytable" class="mytable" style="display: none"></table>
				<div id="grid_detail">
					<div id="welcome">
						<div class="color_gray margin_l_20">
							<div class="clearfix">
								<h2 class="left" style="font-size: 26px;font-family: Verdana;font-weight: bolder;color: #888888;">${ctp:i18n("common.role.information")}</h2>
								<div class="font_size12 left margin_t_20 margin_l_10">
									<div class="margin_t_10 font_size14">
										<span id="count"></span>
									</div>
								</div>
							</div>
							<div class="line_height160 font_size14" style="overflow:auto">
								<c:if test="${CurrentUser.groupAdmin==true}">
									${ctp:i18n('organization.detail.role.group')}
								</c:if>
								<c:if test="${CurrentUser.groupAdmin==false}">
									${ctp:i18n('organization.detail.role.account')}
								</c:if>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
			</div>
		</div>	
	<div id="copy123" class="form_area hidden" >
		<form id="copyform" name="copyform" method="post">
                <div class="common_checkbox_box clearfix margin_t_30 align_center">
                    <label for="copyrole1" class="margin_r_10 hand">
                        <input type="checkbox" value="2" id="copyrole1" name="copyrole" class="radio_com">${ctp:i18n("role.copy.resource")}
                    </label>
                    <label for="copyrole2" class="margin_r_10 hand">
                        <input type="checkbox" value="1" id="copyrole2" name="copyrole" class="radio_com">${ctp:i18n("role.copy.member")}
                    </label>
                </div>
        </form>
	</div>
	
</body>
</html>
