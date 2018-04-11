<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<% 
	String bread = "m3_banner";
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=bannerManager"></script>
<script type="text/javascript">
	var BANNERSRC = {
		language : {
			toolbar_add 				: "${ctp:i18n('common.toolbar.new.label')}",
			toolbar_modify 				: "${ctp:i18n('common.button.modify.label')}",
			toolbar_delete 				: "${ctp:i18n('common.button.delete.label')}",
			
			table_banner_name 			: "${ctp:i18n('m3.banner.table.banner.name')}",
			table_banner_url 			: "${ctp:i18n('m3.banner.table.banner.url')}",
			table_banner_view 			: "${ctp:i18n('m3.banner.table.banner.view')}",
			table_banner_upload_date 	: "${ctp:i18n('m3.banner.table.banner.upload.date')}",
			
			confirm_msg_delete 			: "${ctp:i18n('m3.banner.confirm.msg.delete')}",
			confirm_msg_delete_img 		: "${ctp:i18n('m3.banner.confirm.msg.delete.img')}",
			alert_msg_1 				: "${ctp:i18n('m3.banner.alert.msg1')}",
			alert_msg_2 				: "${ctp:i18n('m3.banner.alert.msg2')}",
			alert_msg_3 				: "${ctp:i18n('m3.banner.alert.msg3')}",
			alert_msg_4 				: "${ctp:i18n('m3.banner.alert.msg4')}",
			alert_msg_5 				: "${ctp:i18n('m3.banner.alert.msg5')}",
			alert_msg_6 				: "${ctp:i18n('m3.banner.alert.msg6')}",
			alert_msg_7 				: "${ctp:i18n('m3.banner.alert.msg7')}",
			alert_msg_8 				: "${ctp:i18n('m3.banner.alert.msg8')}",
			
			infor_msg_save_success 		: "${ctp:i18n('m3.banner.infor.msg.save.success')}",
			input_name_msg 				: "${ctp:i18n('m3.banner.input.name.msg')}",
			input_url_msg 				: "${ctp:i18n('m3.banner.input.url.msg')}"
			
		}
	};
</script>
<script type="text/javascript" src="${path}/apps_res/m3/js/banner.js"></script>
</head>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
		<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'m3_bannerManager'"></div>
		<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'<%=bread %>'"></div>
		<div class="layout_north" layout="height:40,sprit:false,border:false">
			<div id="toolbar"></div>
		</div>
		<div class="layout_center over_hidden" id="center">
			<table id="bannerTable" class="flexme3"></table>
			<div id="grid_detail" style="overflow-y: hidden; position: relative;">
				<div class="stadic_layout">
					<div class="stadic_layout_body stadic_body_top_bottom" style="margin: auto;">
						<div id="bannerFormDiv" class="form_area" style="overflow-y: hidden;">
							<%@include file="bannerForm.jsp"%>
						</div>
					</div>
					<div class="stadic_layout_footer stadic_footer_height">
						<div id="button" align="center" class="page_color button_container">
							<div class="common_checkbox_box clearfix  stadic_footer_height padding_t_5 border_t">
								<a id="btn-submit" href="javascript:void(0)" class="common_button common_button_emphasize margin_r_10">${ctp:i18n('m3.banner.form.confirm')}</a>
								<a id="btn-cancel" href="javascript:void(0)" class="common_button common_button_gray">${ctp:i18n('m3.banner.form.cancel')}</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<iframe class="hidden" id="delIframe" src=""></iframe>
	</div>
</body>
</html>