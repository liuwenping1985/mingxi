<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.tbar.dolend.js') }</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/book/bookDoLend.js"></script>
</head>
<body class="h100b over_hidden">
	<div id='layout' class="comp" comp="type:'layout'">
		<div class="layout_north margin_t_10 margin_l_10" layout="height:70,border:false,sprit:false">
			<div id="toPersonDiv" class="form_area " >
				<table class=" font_size12" border="0" cellSpacing="0" cellPadding="0" style="table-layout:fixed;">
					<tr>
						<td align="right" width="60">${ctp:i18n('office.bookapply.dolend.lendto.js') }:</td>
						<td align="left">
							<div id="userDiv" class="common_txtbox_wrap">
	              				<input id="applyUser_txt" class=" font_size12 validate" validate="name:'${ctp:i18n('office.stock.use.user.js')}',notNull:true">
	              				<input id="applyUser" type="hidden"/>
	            			</div>
						</td>
					</tr>
				</table>
			</div>
			<a id="selectBook" class="common_button common_button_emphasize margin_t_5 margin_b_5" href="javascript:void(0);" >${ctp:i18n('office.bookapply.dolend.selectbook1.js') }</a>
		</div>
		<div id="bookDoLendTabDiv" class="layout_center margin_t_5" layout="border:false,sprit:false" >
				<table id="bookDoLendTab" class="flexme3" style="display: none;"></table>
		</div>
	</div>  
</body>
</html>