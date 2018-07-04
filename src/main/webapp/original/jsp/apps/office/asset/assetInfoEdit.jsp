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
<title>${ctp:i18n('office.asset.assetHouseEdit.psbsz.js') }</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/asset/assetInfoEdit.js"></script>
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
			<div id="assetInfoDiv" class="form_area set_search align_center">
				<table border="0" cellSpacing="0" cellPadding="0" align="center"
					style="table-layout: fixed;" width='800'>
					
					<tr>
						<th style="width: 10%;" noWrap="nowrap" align="right">
							<input id="id" type="hidden" value="-1">
							<span class="color_red">*</span><label for="text">${ctp:i18n('office.assetinfo.num.js') }:</label>
						</th>
						<td style="width: 30%;">
							<div  class="common_txtbox_wrap">
								<input id="assetNum" name="assetNum" class="font_size12 validate" maxlength="85"  validate="notNullWithoutTrim:'true',name:'${ctp:i18n('office.assetinfo.num.js') }',notNull:true,avoidChar:'!@#$%^&\'*+()'" />
							</div>
						</td>
						<th style="width: 10%;" noWrap="nowrap" align="right"><label for="text">${ctp:i18n('office.assetinfo.buydata.js') }:</label></th>
						<td style="width: 30%;" colspan="2">
							<div  class="common_txtbox_wrap">
								<input id="buyDate" name="buyDate" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d'" readonly />
							</div>
						</td>
					</tr>
					
					<tr>
						<th style="width: 10%;" noWrap="nowrap" align="right"><span class="color_red">*</span><label for="text">${ctp:i18n('office.assetinfo.type.js') }:</label></th>
						<td style="width: 30%;">
							<div class="common_selectbox_wrap">
                            	<select  id="assetType" name="assetType" class="font_size12" ></select>
                            </div>
						</td>
						<th style="width: 10%;" noWrap="nowrap" align="right"><label for="text">${ctp:i18n('office.assetinfo.buyprice.js') }:</label></th>
						<td style="width: 30%;" >
							<div  class="common_txtbox_wrap">
								<input id="buyPrice" name="buyPrice" maxlength="13" class="validate font_size12" validate="name:'${ctp:i18n('office.assetinfo.buyprice.js') }',regExp:'^([1-9][0-9]{0,7})([.][0-9]{1,2})?$',errorMsg:'只能输入小于等于8个正数，2个小数点'" value="" type="text"/>
							</div>
						</td>
						<td align="left"><span class="margin_l_5">${ctp:i18n('office.auto.element.js')}</span></td>
					</tr>
					
					<tr>
						<th style="width: 10%;" noWrap="nowrap" align="right"><span class="color_red">*</span><label for="text">${ctp:i18n('office.assetinfo.name.js') }:</label></th>
						<td style="width: 30%;">
							<div  class="common_txtbox_wrap">
	                          <input  id="assetName" name="assetName" maxlength="85" class="font_size12 validate" validate="notNullWithoutTrim:'true',name:'${ctp:i18n('office.assetinfo.name.js') }',notNull:true,avoidChar:'!@#$%^&\'*+()'" value="" type="text"/>
							</div>
						</td>
						<th style="width: 10%;" noWrap="nowrap" align="right"><label for="text">${ctp:i18n('office.assetinfo.state.js') }:</label></th>
						<td style="width: 30%;" colspan="2">
							<div  class="common_selectbox_wrap">
								<select  id="state" name="state" class="codecfg font_size12 validate" validate="name:'${ctp:i18n('office.assetinfo.state.js') }',notNull:true" codecfg="codeType:'java',codeId:'com.seeyon.apps.office.constants.AssetInfoStateEnum'"></select>
							</div>
						</td>
					</tr>
					
					<tr>
						<th style="width: 10%;" noWrap="nowrap" align="right"><label for="text">${ctp:i18n('office.assetinfo.brand.js') }:</label></th>
						<td style="width: 30%;">
							<div  class="common_txtbox_wrap">
								<input id="assetBrand" name="assetBrand" maxlength="85" class="font_size12 validate" validate="" type="text"/>
							</div>
						</td>
						<th style="width: 10%;" noWrap="nowrap" align="right"><span class="color_red">*</span><label for="text">${ctp:i18n('office.assetinfo.currentCount.js') }:</label></th>
						<td style="width: 30%;" colspan="2">
							<div class="common_txtbox_wrap">
								<input id="currentCount" name="currentCount" maxlength="9" class="font_size12 validate" validate="name:'${ctp:i18n('office.assetinfo.currentCount.js') }',notNull:true,isInteger:true,min:0" />
							</div>
						</td>
					</tr>
					
					<tr>
						<th noWrap="nowrap" align="right"><label for="text">${ctp:i18n('office.assetinfo.model.js') }:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input id="assetModel" name="assetModel" maxlength="85" type="text" class="font_size12"  />
							</div>
						</td>
						<th noWrap="nowrap" align="right"><span class="color_red">*</span><label for="text">${ctp:i18n('office.assetinfo.assethouse.js') }:</label></th>
						<td colspan="2">
							<div class="common_selectbox_wrap">
								<select  id="assetHouseId" name="assetHouseId" class="font_size12 validate" validate="name:'${ctp:i18n('office.assetinfo.assethouse.js') }',notNull:true,errorMsg:'设备库不能为空'" ></select>
							</div>
						</td>
					</tr>
					
					<tr>
						<th noWrap="nowrap" align="right"><label for="text">${ctp:i18n('office.assetinfo.desc.js') }:</label></th>
						<td colspan="4" align="left">
							<div class="margin_b_5">
                                <textarea  id="assetDesc" name="assetDesc" class="font_size12 validate" validate="name:'${ctp:i18n('office.assetinfo.desc.js') }',type:'string',maxLength:600" style="width: 100%; height: 40px;" ></textarea>
							</div>
						</td>
						
					</tr>
					
					<tr > 
						<th noWrap="nowrap" align="right"><label for="text">${ctp:i18n('office.assetinfo.memo.js') }:</label></th>
						<td colspan="4" align="left">
							<div>
                                <textarea  id="assetMemo" name="assetMemo" class="font_size12 validate" validate="name:'${ctp:i18n('office.assetinfo.memo.js') }',type:'string',maxLength:600" style="width: 100%; height: 40px;" ></textarea>
							</div>
						</td>
						
					</tr>
	                    
				</table>
			</div>
		</div>
		<div 
			class="stadic_layout_footer stadic_footer_height border_t padding_t_5 padding_b_5 align_center bg_color_black">
			<!--下边区域-->
			<a id="btnok" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('common.button.ok.label')}</a>
			<a id="btncancel" class="common_button common_button_grayDark margin_l_10" href="javascript:void(0)">${ctp:i18n('common.button.cancel.label')}</a>
		</div>
	</div>
</body>
</html>