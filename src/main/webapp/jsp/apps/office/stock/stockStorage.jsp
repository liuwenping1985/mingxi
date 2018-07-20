<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b">
<head>
<style type="text/css">
.stadic_layout_head {
	height: 22px;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>入库</title>
<script type="text/javascript" charset="UTF-8"
	src="${path}/apps_res/office/js/pub/stockPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8"
	src="${path}/apps_res/office/js/stock/stockStorage.js"></script>
</head>
<body class="h100b over_hidden">
	<div class="stadic_layout h100b font_size12">
		<div class="stadic_layout_body stadic_body_top_bottom margin_b_5">
			<!--中间区域-->
			<div id="stockStorageDiv" class="form_area set_search align_center">
				<table border="0" cellSpacing="0" cellPadding="0" align="center"
					style="table-layout: fixed;" width='300'>
					<tr>
						<th style="width: 10%;" noWrap="nowrap" align="right">
							<label for="text">${ctp:i18n('office.stock.stockprice.js')}:</label>
						</th>
						<td style="width: 30%;">
							<div id="stockPriceDiv" class="common_txtbox_wrap">
								<input id="stockPrice" name="stockPrice"
									class="font_size12 validate" validate="name:'${ctp:i18n('office.stock.stockprice.js')}',regExp:'^([0-9][0-9]{0,7})([.][0-9]{1,2})?$',errorMsg:'${ctp:i18n('office.auto.money.check.js')}'" value="${stockInfoPO.stockPrice}" />
								<input type="hidden" id="stockInfoId" name="stockInfoId" value="${stockInfoId}" />
							</div>
						</td>
					</tr>
					<tr>
						<th style="width: 10%;" noWrap="nowrap" align="right"><span
							class="color_red">*</span><label for="text">${ctp:i18n('office.stock.storagecount.js')}:</label></th>
						<td style="width: 30%;">
							<div id="stockCountDiv" class="common_txtbox_wrap">
								<input id="stockCount" name="stockCount"
									class="font_size12 validate" maxlength="5" validate="name:'${ctp:i18n('office.stock.storagecount.js')}',notNull:true,regExp:'^-?[0-9]{1,5}$',errorMsg:'${ctp:i18n('office.stock.zlsr5wzs.stc.title.js')}'"  value="" />
							</div>
						</td>
					</tr>
					<tr>
						<th noWrap="nowrap" align="right"><span
							class="color_red">*</span><label for="text">${ctp:i18n('office.assetinfo.buydata.js')}:</label>
						</th>
						<td>
							<div id="buyDateDiv" class="common_txtbox_wrap">
								<input id="buyDate" name="buyDate" type="text" class="comp validate"
									comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:true"
									validate="name:'${ctp:i18n('office.assetinfo.buydata.js')}',notNull:true"
									comptype="calendar" readonly="readonly"  value="${updateDate}" />
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div id="btnDiv"
			class="stadic_layout_footer stadic_footer_height border_t padding_tb_5 align_center bg_color_black">
			<a id="btnok" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('common.button.ok.label')}</a>
			<a id="btncancel" class="common_button common_button_grayDark margin_l_10" href="javascript:void(0)">${ctp:i18n('common.button.cancel.label')}</a>
		</div>
	</div>
</body>
</html>