<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<html class="h100b">
<head>
<style type="text/css">
.stadic_layout_head {
	height: 22px;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>用品库设置</title>
<script type="text/javascript" charset="UTF-8"
	src="${path}/apps_res/office/js/pub/stockPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8"
	src="${path}/apps_res/office/js/stock/stockInfoEdit.js"></script>
</head>
<body class="h100b over_hidden">
	<div class="stadic_layout h100b font_size12">
		<div class="stadic_layout_head stadic_head_height bg_color_gray">
			<!--上边区域-->
			<div class="clearfix ">
				<span
					class="right margin_5 green">*${ctp:i18n('office.auto.must.enter.js') }</span>
			</div>
		</div>
		<div id="centerDIV" class="stadic_layout_body stadic_body_top_bottom margin_b_5">
			<!--中间区域-->
			<div id="stockInfoDiv" class="form_area set_search align_center">
				<table border="0" cellSpacing="0" cellPadding="0" align="center"
					style="table-layout: fixed;" width='800'>
					<tr>
						<th style="width: 10%;" noWrap="nowrap" align="right"><span
							class="color_red">*</span><label for="text">${ctp:i18n('office.stock.num.js') }:</label></th>
						<td style="width: 30%;">
							<div id="stockNumDiv" class="common_txtbox_wrap">
								<input id="stockNum" name="stockNum"
									class="font_size12 validate" maxlength="85"  validate="name:'${ctp:i18n('office.auto.bookStcInfo.bh.js')}',notNull:true,notNullWithoutTrim:true" />
							</div>
						</td>
						<th style="width: 10%;" noWrap="nowrap" align="right"><span
							class="color_red">*</span><label for="text">${ctp:i18n('office.stock.name.js') }:</label></th>
						<td style="width: 30%;" colspan="2">
							<div id="stockNameDiv" class="common_txtbox_wrap">
								<input id="stockName" name="stockName"
									class="font_size12 validate" maxlength="85" validate="name:'${ctp:i18n('office.asset.apply.assetName.js')}',notNull:true,notNullWithoutTrim:true" />
									<input id="id" type="hidden">
							</div>
						</td>
					</tr>
					<tr>
						<th style="width: 10%;" noWrap="nowrap" align="right"><label
							for="text">${ctp:i18n('office.manager.StockInfoManagerImpl.ypgg.js') }:</label></th>
						<td style="width: 30%;">
							<div id="stockModelDiv" class="common_txtbox_wrap">
								<input id="stockModel" name="stockModel"
									class="font_size12 validate" maxlength="85" validate="" />
							</div>
						</td>
						<th style="width: 10%;" noWrap="nowrap" align="right"><label for="text">${ctp:i18n('office.stock.unit.js') }:</label></th>
						<td style="width: 30%;" colspan="2">
							<div id="stockUnitDiv" class="common_txtbox_wrap">
								<input id="stockUnit" name="stockUnit" maxlength="85"
									class="font_size12 validate" validate="name:'',errorMsg:'${ctp:i18n('office.auto.unit.check.code.js')}',avoidChar:'!@#$%^&\'*+()'" />
							</div>
						</td>
					</tr>
					<tr>
						<th style="width: 10%;" noWrap="nowrap" align="right"><span
							class="color_red">*</span><label
							for="text">${ctp:i18n('office.stock.type.js') }:</label></th>
						<td style="width: 30%;">
							<div id="stockTypeDiv" class="common_selectbox_wrap">
								<div class="common_selectbox_wrap">
	                            	<select  id="stockType" name="stockType" class="codecfg font_size12" codecfg="codeId:'office_stock_type'"></select>
	                            </div>
							</div>
						</td>
						<th style="width: 10%;" noWrap="nowrap" align="right"><span
							class="color_red">*</span><label for="text">${ctp:i18n('office.stock.house.js') }:</label></th>
						<td style="width: 30%;" colspan="2">
							<div id="stockHouseDiv" class="common_selectbox_wrap">
								<select  id="stockHouseId" name="stockHouseId" class="font_size12 validate" validate="name:'${ctp:i18n('office.stock.house.js')}',notNull:true" ></select>
							</div>
						</td>
					</tr>
					<tr>
						<th style="width: 10%;" noWrap="nowrap" align="right"><label
							for="text">${ctp:i18n('office.manager.StockStcManagerImpl.pjdj.js') }:</label></th>
						<td style="width: 30%;">
							<div id="stockPriceDiv" class="common_txtbox_wrap">
								<input id="stockPrice" name="stockPrice"
									class="font_size12 validate" validate="name:'${ctp:i18n('office.stock.stockprice.js')}',regExp:'^([0-9][0-9]{0,7})([.][0-9]{1,2})?$',errorMsg:'${ctp:i18n('office.auto.money.check.js')}'" value="${stockInfoPO.stockPrice}"/>
							</div>
						</td>
						<th style="width: 10%;" noWrap="nowrap" align="right"><label
							for="text">${ctp:i18n('office.stock.countsum.js') }:</label></th>
						<td style="width: 30%;" colspan="2">
							<div id="stockCountDiv" class="common_txtbox_wrap">
								<input id="stockCount" name="stockCount" 
									class="font_size12 validate" maxlength="6" validate="regExp:'^-?[0-9]{1,5}$',errorMsg:'${ctp:i18n('office.stock.zlsr5wzs.stc.title.js')}'" />
							</div>
						</td>
					</tr>
					<tr>
						<th noWrap="nowrap" align="right"><label for="text">${ctp:i18n('office.assetinfo.buydata.js') }:</label>
						</th>
						<td>
							<div id="createDateDiv" class="common_txtbox_wrap" style="">
								<input id="createDateTxt" name="createDateTxt" type="text" class=""
									comptype="calendar" readonly disabled="disabled" />
							</div>
						</td>
						<th noWrap="nowrap" align="right"><label for="text">${ctp:i18n('office.stockinfo.mincount.js') }:</label>
						</th>
						<td colspan="2">
							<div id="minCountDiv" class="common_txtbox_wrap">
								<input id="minCount" name="minCount"
									class="font_size12 validate" maxlength="5" validate="regExp:'^[0-9]{1,5}$',errorMsg:'${ctp:i18n('office.stock.input.check.number.js')}'" />
							</div>
						</td>
					</tr>
					<tr>
						<th noWrap="nowrap" align="right"><span class="color_red">*</span><label
							for="text">${ctp:i18n('office.assetinfo.state.js') }:</label></th>
						<td>
							<div id="stateDiv" class="common_selectbox_wrap">
								<select  id="state" name="state" class="codecfg font_size12 validate" validate="notNull:true" codecfg="codeType:'java',codeId:'com.seeyon.apps.office.constants.StockInfoStateEnum'" ></select>
							</div>
						</td>
						<th noWrap="nowrap" align="right"></th>
						<td noWrap="nowrap" colspan="2"><input value="1" type="checkbox" name="warnFlag"
							id="warnFlag">${ctp:i18n('office.stockinfo.warnflag.js') }</td>
				</table>
			</div>
		</div>
		<div id="btnDiv" class="stadic_layout_footer stadic_footer_height border_t padding_tb_5 align_center bg_color_black">
			<a id="btnok" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('common.button.ok.label')}</a>
			<a id="btncancel" class="common_button common_button_grayDark margin_l_10" href="javascript:void(0)">${ctp:i18n('common.button.cancel.label')}</a>
		</div>
	</div>
</body>
</html>