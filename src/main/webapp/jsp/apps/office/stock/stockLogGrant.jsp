<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>办公用品-发放记录</title>
<style type="text/css">
.stadic_layout_body{
  bottom: 0px;
}
</style>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/stock/stockUse.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/stock/stockLogGrant.js"></script>
</head>
<body class="h100b over_hidden">
<div id='layout' class="comp" comp="type:'layout'">
  <div class="layout_north" layout="height:110,maxHeight:110,border:false,spiretBar:{show:true,handlerT:function(){pTemp.layout.setNorth(0);pTemp.tab.reSize();},handlerB:function(){pTemp.layout.setNorth(110);pTemp.tab.reSize();}}">
    <div id="stockDiv" class="form_area common_center">
     <table id="stockUseTab" class="margin_t_5" style="min-width: 820px;max-width: 1124px;" border="0" cellSpacing="0" cellPadding="0" align="center">
       <tr>
          <th width="80" noWrap="nowrap" align="right"><label  for="text">${ctp:i18n('office.stock.house.js') }:</label></th>
          <td width="300" >
             <div class="common_selectbox_wrap">
             	<select id="stockHouseId" class="w100b font_size12 h100b" onchange="fnHouseChange();"></select>
            </div>
          </td>
          <th width="80" noWrap="nowrap" align="right"><label  for="text">${ctp:i18n('office.stock.type.js') }:</label></th>
          <td width="300" >
            <div class="common_selectbox_wrap">
             	<select id="stockType" class="w100b font_size12 h100b"></select>
            </div>
          </td>
          <th width="80" noWrap="nowrap" align="right"><label  for="text">${ctp:i18n('office.stock.name.js') }:</label></th>
          <td width="300" colspan="2">
            <div class="common_txtbox_wrap">
              <input id="stockName" class="font_size12" maxlength="80" type="text">
            </div>
          </td>
      </tr>
    
      <tr>
        <th noWrap="nowrap" align="right" width="80"><label  for="text">${ctp:i18n('office.stock.use.dep.js') }:</label></th>
        <td align="left" width="300">
         <div id="depDiv" class="common_txtbox_wrap">
            <input id="applyDept" class="comp font_size12" comp="type:'selectPeople', panels:'Department',selectType:'Department',minSize:'0',maxSize:'1'">
          </div>
        </td>
        
        <th noWrap="nowrap" align="right" width="80"><label  for="text">${ctp:i18n('office.stock.use.user.js') }:</label></th>
        <td align="left" width="300">
         <div id="applyUserDiv" class="common_txtbox_wrap">
            <input id="applyUser" class="comp font_size12">
          </div>
        </td>
          
        <th noWrap="nowrap" align="right" width="80"><label for="text">${ctp:i18n('office.stock.use.applydate.js') }:</label></th>
        <td align="left" nowrap="nowrap" width="145">
        	<div class="clearfix">
        	<div class="common_txtbox_wrap">
          		<input id="applyDate0" class="comp font_size12" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d'" readonly>
         	</div>
        	</div>
        </td>
      	<td align="left" width="155">
        	<span class="margin_lr_5 margin_t_5 left">${ctp:i18n('office.asset.apply.to.js') }</span>
       		<div class="common_txtbox_wrap">
            	<input id="applyDate1" class="comp font_size12" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d'" readonly>
          	</div>
      	</td>
    </tr>
    
    <tr>
      <td colspan="7" align="center">
       <div class="padding_tb_10">
          <a id="btnok" onclick="fnQuery();" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('office.button.query.js') }</a> 
          <a id="btncancel" onclick="fnCancel();" class="common_button common_button_grayDark margin_r_10" href="javascript:void(0)">${ctp:i18n('office.button.reset.js') }</a>
        </div>
      </td>
    </tr>
  </table>
 </div>
</div>
<div class="layout_center over_hidden" layout="border:false">
   <div class="stadic_layout border_t">
      <div class="stadic_layout_head stadic_head_height">
          <div id="toolbar"></div>
      </div>
      <div id="stockGrantLogTabDiv" class="stadic_layout_body stadic_body_top_bottom over_hidden">
          <table id="stockGrantLogTab" class="flexme3" style="display: none;"></table>
      </div>
   </div>
</div>
</div>
</body>
</html>