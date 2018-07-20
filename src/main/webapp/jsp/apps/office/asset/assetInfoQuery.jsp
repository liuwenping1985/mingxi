<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.asset.assetApply.pbgsbsq.js') }</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/asset/assetUse.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/asset/assetInfoQuery.js"></script>
</head>
<body class="h100b over_hidden">
  <div id='layout' class="comp" comp="type:'layout'">
  	<!-- 上边区域 Start-->
  	<form id="exportForm" action="" method="post"></form>
    <div id="layoutNorthDIV" class="layout_north" layout="maxHeight:220,border:false,spiretBar:{show:true,handlerT:function(){pTemp.layout.setNorth(95);pTemp.tab.reSize();},handlerB:function(){pTemp.layout.setNorth(295);pTemp.tab.reSize();}}">
      <div id="assetInfoDiv" class="form_area common_center">
        <table id="assetInfoQuery" class="margin_t_5" border="0" cellSpacing="0" cellPadding="0" align="center" style="width:700px;">
          <tr >
            <th  noWrap="nowrap" align="right"><label for="text">${ctp:i18n('office.assetinfo.assethouse.js') }:</label></th>
            <td  width="280" align="left">
            	<div class="common_selectbox_wrap" >
           			<select id="assetHouseId" class="font_size12"></select>
            	</div>
            </td>
            <th  noWrap="nowrap" align="right" ><label for="text">${ctp:i18n('office.assetinfo.num.js') }:</label></th>
            <td  width="280" align="left" >
            	<div class="common_txtbox_wrap font_size12" >
            		<input type="text" id="assetNum"/>
            	</div>
            </td>
          </tr>

          <tr>
            <th noWrap="nowrap" align="right" ><label for="text">${ctp:i18n('office.assetinfo.type.js') }:</label></th>
            <td  align="left">
            	<div class="common_selectbox_wrap">
            		<select id="assetType" class="font_size12"></select>
            	</div>
            </td>
            <th  noWrap="nowrap" align="right" ><label for="text">${ctp:i18n('office.assetinfo.name.js') }:</label></th>
            <td  align="left" >
            	<div class="common_txtbox_wrap font_size12">
            		<input type="text" id="assetName"/>
            	</div>
            </td>
          </tr>
          
          <tr>
            <th noWrap="nowrap" align="right" ><label for="text">${ctp:i18n('office.asset.query.state.js') }:</label></th>
            <td id="stateTD"  align="left">
            	<div class="common_radio_box clearfix">
                    <label for="allAssetInfo" class="margin_r_10 hand">
                        <input type="radio" value="allAssetInfo" id="allAssetInfo" checked="checked" name="state" class="radio_com" >${ctp:i18n('office.asset.query.state.all.js') }</label>
                    <label for="lendAssetInfo" class="margin_r_10 hand">
                        <input type="radio" value="10" id="lendAssetInfo" name="state" class="radio_com">${ctp:i18n('office.asset.query.state.lended.js') }</label>
                    <label for="lending" class="margin_r_10 hand">
                        <input type="radio" value="15" id="lending" name="state" class="radio_com" >${ctp:i18n('office.asset.query.state.lending.js') }</label>
                    <label for="freeAssetInfo" class="margin_r_10 hand">
                        <input type="radio" value="20" id="freeAssetInfo" name="state" class="radio_com">${ctp:i18n('office.asset.query.state.free.js') }</label>
            </div>
            </td>
            <td id="highQueryTD"  align="right" >
            	<a id="highQuery" href="javascript:;" class="color_blue font_size12">${ctp:i18n('office.asset.query.high.js') }</a>
            </td>
          </tr>
          
          <tr id="useInfoTR">
            <th noWrap="nowrap" align="right" ><label for="text">${ctp:i18n('office.asset.query.user.js') }:</label></th>
            <td  align="left">
            	<div id="applyUserDIV" class="common_txtbox_wrap font_size12">
            		<input type="text" id="applyUser" class="comp" comp="type:'selectPeople', panels:'Account,Department,Team,Post,Level',selectType:'Member'"/>
            	</div>
            </td>
            <th  noWrap="nowrap" align="right" ><label for="text">${ctp:i18n('office.asset.query.usedep.js') }:</label></th>
            <td  align="left" >
            	<div id="applyDeptDIV" class="common_txtbox_wrap font_size12">
            		<input type="text" id="applyDept" class="comp" comp="type:'selectPeople', panels:'Department',selectType:'Department'"/>
            	</div>
            </td>
          </tr>
          
          <tr id="processTimeTR" >
            <th noWrap="nowrap" align="right" ><label for="text">${ctp:i18n('office.asset.query.handtime.js') }:</label></th>
            <td  align="left">
            	<div class="common_txtbox_wrap font_size12">
					<input id="startDate" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d'" readonly />
            	</div>
            </td>
            <td align="center" ><label for="text">-</label></td>
            <td align="left">
            	<div class="common_txtbox_wrap font_size12">
            		<input id="endDate" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d'" readonly />
            	</div>
            </td>
          </tr>
          
          <tr>
            <td colspan="5" align="center">
              <div class="padding_tb_10">
                <a id="btnok" onclick="fnQuery();" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('office.button.query.js') }</a>
                <a id="btncancel" onclick="fnCancel();" class="common_button common_button_gray margin_r_10" href="javascript:void(0)">${ctp:i18n('office.button.reset.js') }</a>
              </div>
            </td>
          </tr>
          
        </table>
      </div>
    </div>
    <!-- 上边区域 End-->
    <!-- 中间区域 Start-->
    <div class="layout_center over_hidden bg_color_gray" layout="border:false">
    	<div class="stadic_layout">
            <div class="stadic_layout_head stadic_head_height">
            	<table class="w100b" border="0" cellSpacing="0" cellPadding="0">
	     		<tr>
	     			<td ><span class="font_size12 margin_l_10">${ctp:i18n('office.asset.query.result.js') }:</span><span class="ico16 xls_16 margin_l_10"></span><a id="exportUseInfo" href="#" class="color_blue font_size12">${ctp:i18n('office.tbar.export.js') }</a><span class="ico16 print_16 margin_l_10"></span><a id="assetPrint" href="#" class="color_blue font_size12">${ctp:i18n('office.tbar.print.js') }</a></td>
	     			<td rowspan="2" align="left"><span style="font-size: 18px">${ctp:i18n('office.asset.query.js') }</span></td>
	     			<td></td>
	     		</tr>
	     		<tr>
	     			<td></td>
	     			<td align="right"><span class="font_size12 margin_r_10">${ctp:i18n('office.asset.query.date.js') }:${now }</span></td>
	     		</tr>
	     	</table>
            </div>
            <div id="assetUseInfoDiv" class="stadic_layout_body stadic_body_top_bottom margin_t_5" style="overflow: hidden;">
           		<table id="assetUseInfo" class="flexme3" style="display: none;"> </table>
            </div>
        </div>
    </div>
    <!-- 中间区域 End-->
  </div>
</body>
</html>