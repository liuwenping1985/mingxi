<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<style type="text/css">
.stadic_layout_body {
  top: 0px;
  bottom: 30px;
}
.stadic_footer_height{
  _height:60px;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.car.recede.edit.js')}</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/auto/autoRecedeEdit.js${ctp:resSuffix()}"></script>
</head>
<body class="h100b over_hidden">
 <div class="stadic_layout h100b font_size12">
    <div class="stadic_layout_body stadic_body_top_bottom margin_b_10">
      <!--中间区域-->
      <div id="autoSendDiv" class="form_area set_search align_center w100b">
        <div class="margin_t_10"></div>
         <table id="autoUseTab" border="0" cellSpacing="0" cellPadding="0" align="center" class="w80b" style="table-layout:fixed;font-size:12px;">
           <tr nodePostion="autoOut">
              <th  width="80" noWrap="nowrap" align="right"><label  class="margin_r_5"  for="text">${ctp:i18n('office.app.auto.js') }:</label></th>
              <td colspan="1" align="left">
                <div class="common_txtbox_wrap">
                  <input id="applyAutoId" type="hidden">
                  <input id="applyAutoIdName" class="validate font_size12" type="text">
                </div>
              </td>
              <td width="40"></td>
              <th width="80" noWrap="nowrap" align="right"><label  class="margin_r_5"  for="text">${ctp:i18n('office.auto.driver.js') }:</label></th>
              <td colspan="1" align="left">
                <div id="applyDriverDiv" class="common_txtbox_wrap">
                  <input id="applyDriverName" type="text" onclick="fnSelectPeoplePub({type:'driver'});" class="font_size12 validate" validate="name:'${ctp:i18n('office.auto.autoStcInfo.jsy.js')}'" >
                  <input id="applyDriver" type="hidden">
                </div>
              </td>
              <td width="40"></td>
            </tr>
            
            <!-- 出车  --> 
            <tr>
              <th noWrap="nowrap" align="right"><span class="color_red">*</span><label  class="margin_r_5"  for="text">${ctp:i18n('office.autoapply.senddate.js') }:</label></th>
              <td colspan="1" align="left">
                <div class="common_txtbox_wrap">
                  <input id="realOuttime" class="comp font_size12 validate" type="text" validate="name:'${ctp:i18n('office.auto.autoStcInfoShow.ccsj.js')}',notNull:true" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true" readonly>
                </div>
              </td>
              <td></td>
              <th noWrap="nowrap" align="right"><span class="color_red">*</span><label  class="margin_r_5"  for="text">${ctp:i18n('office.autoapply.recededate.js') }:</label></th>
              <td colspan="1" align="left">
                <div class="common_txtbox_wrap">
                  <input id="realBacktime" class="comp font_size12 validate" type="text" validate="name:'${ctp:i18n('office.autoapply.recededate.js')}',notNull:true" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true" readonly>
                </div>
              </td>
              <td></td>
            </tr>
            
            <tr>
             <th noWrap="nowrap" align="right"><label  class="margin_r_5"  for="text">${ctp:i18n('office.autoapply.outkm.js') }:</label></th>
              <td align="left">
                <div class="common_txtbox_wrap">
                  <input id="outmileage" class="validate font_size12" maxlength="9"  type="text" validate="type:'number',name:'',regExp:'^[0-9]{0,9}$',errorMsg:'${ctp:i18n('office.auto.out.car.check.js')}'">
                 </div>
              </td>
              <td align="left"><span class="margin_l_5"></span>${ctp:i18n('office.auto.maintenance.js') }</td>
              <th noWrap="nowrap" align="left"><label  class="margin_r_5"  for="text">${ctp:i18n('office.autoapply.recedekm.js') }:</label></th>
              <td>
                <div class="common_txtbox_wrap">
                  <input id="backMileage" class="validate font_size12" maxlength="9"  type="text" validate="type:'number',name:'',regExp:'^[1-9][0-9]{0,8}$',errorMsg:'${ctp:i18n('office.auto.recede.car.check.msg.js')}'">
                 </div>
              </td>
              <td align="left"><span class="margin_l_5"></span>${ctp:i18n('office.auto.maintenance.js') }</td>
            </tr>
            
            <!-- 还车 -->
            <tr>
              <th noWrap="nowrap" align="right"><label  class="margin_r_5"  for="text">${ctp:i18n('office.autoapply.runnedkm.js') }:</label></th>
              <td align="left"><div class="common_txtbox_wrap">
                    <input id="travelMileage" class="validate font_size12"  type="text" maxlength="9" validate="type:'number',name:'',regExp:'^[1-9][0-9]{0,9}$',errorMsg:'${ctp:i18n('office.auto.drive.km.check.msg.js')}'">
                  </div>
              </td>
              <td align="left"><span class="margin_l_5"></span>${ctp:i18n('office.auto.maintenance.js') }</td>
              <th noWrap="nowrap" align="right"><label  class="margin_r_5"  for="text">${ctp:i18n('office.autoapply.outfaul.js') }:</label></th>
              <td align="left"><div class="common_txtbox_wrap">
                    <input id="fuelPrice" class="validate font_size12"  type="text" maxlength="11" validate="type:'number',name:'',regExp:'^([0-9]{0,8})([.][0-9]{1,2})?$',errorMsg:'${ctp:i18n('office.auto.check.money2.js')}'">
                  </div>
              </td>
              <td align="left"><span class="margin_l_5"></span>${ctp:i18n('office.auto.element.js') }</td>
            </tr>
            
            <tr>
              <th noWrap="nowrap" align="right"><label  class="margin_r_5"  for="text">${ctp:i18n('office.autoapply.roadprice.js') }:</label></th>
              <td align="left"><div class="common_txtbox_wrap">
                    <input id="roadPrice" class="validate font_size12"  type="text"  maxlength="11" validate="type:'number',name:'',regExp:'^([0-9]{0,8})([.][0-9]{1,2})?$',errorMsg:'${ctp:i18n('office.auto.check.money2.js')}'">
                  </div>
              </td>
              <td align="left"><span class="margin_l_5"></span>${ctp:i18n('office.auto.element.js') }</td>
              <th noWrap="nowrap" align="right"><label  class="margin_r_5"  for="text">${ctp:i18n('office.autoapply.parkingfee.js') }:</label></th>
              <td align="left"><div class="common_txtbox_wrap">
                    <input id="parkingFee" class="validate font_size12"  type="text" maxlength="11" validate="type:'number',name:'',regExp:'^([0-9]{0,8})([.][0-9]{1,2})?$',errorMsg:'${ctp:i18n('office.auto.check.money2.js')}'">
                  </div>
              </td>
              <td align="left"><span class="margin_l_5"></span>${ctp:i18n('office.auto.element.js') }</td>
            </tr>
            
            <tr>
              <th noWrap="nowrap" align="right"><label  class="margin_r_5"  for="text">${ctp:i18n('office.autoapply.cardfee.js') }:</label></th>
              <td align="left"><div class="common_txtbox_wrap">
                    <input id="cardFee" class="validate font_size12"  type="text" maxlength="11" validate="type:'number',name:'',regExp:'^([0-9]{0,8})([.][0-9]{1,2})?$',errorMsg:'${ctp:i18n('office.auto.check.money2.js')}'">
                  </div>
              </td>
              <td align="left"><span class="margin_l_5"></span>${ctp:i18n('office.auto.element.js') }</td>
              <th noWrap="nowrap" align="right"><label  class="margin_r_5"  for="text">${ctp:i18n('office.autoapply.cashfee.js') }:</label></th>
              <td align="left"><div class="common_txtbox_wrap">
                    <input id="cashFee" class="validate font_size12"  type="text" maxlength="11" validate="type:'number',name:'',regExp:'^([0-9]{0,8})([.][0-9]{1,2})?$',errorMsg:'${ctp:i18n('office.auto.check.money2.js')}'">
                  </div>
              </td>
              <td align="left"><span class="margin_l_5"></span>${ctp:i18n('office.auto.element.js') }</td>
            </tr>
            
            <tr>
              <th noWrap="nowrap" align="right"><label  class="margin_r_5"  for="text">${ctp:i18n('office.autoapply.washesfee.js') }:</label></th>
              <td align="left"><div class="common_txtbox_wrap">
                    <input id="washesFee" class="validate font_size12"  type="text" maxlength="11" validate="type:'number',name:'',regExp:'^([0-9]{0,8})([.][0-9]{1,2})?$',errorMsg:'${ctp:i18n('office.auto.check.money2.js')}'">
                  </div>
              </td>
              <td align="left"><span class="margin_l_5"></span>${ctp:i18n('office.auto.element.js') }</td>
              <th noWrap="nowrap" align="right"><label  class="margin_r_5"  for="text">${ctp:i18n('office.autoapply.otherfee.js') }:</label></th>
              <td align="left"><div class="common_txtbox_wrap">
                    <input id="otherFee" class="validate font_size12" type="text" maxlength="11" validate="type:'number',name:'',regExp:'^([0-9]{0,8})([.][0-9]{1,2})?$',errorMsg:'${ctp:i18n('office.auto.check.money2.js')}'">
                  </div>
              </td>
              <td align="left"><span class="margin_l_5"></span>${ctp:i18n('office.auto.element.js')}</td>
            </tr>
            <tr>
              <th noWrap="nowrap" align="right" valign="top">
                  <label class="margin_r_5"  for="text">${ctp:i18n('office.assetinfo.memo.js')}:</label>
              </th>
              <td colspan="5" align="left">
                  <div class="common_txtbox  clearfix">
                      <textarea id="backMemo" style="width: 95%; height: 45px;" id="cyy_textbox" class="validate padding_5 margin_r_5 font_size12" validate="name:'${ctp:i18n('office.assetinfo.memo.js')}',type:'string',maxLength:600"></textarea>
                  </div>
              </td>
          </tr>
        </table>
      </div>
    </div>
    <c:if test="${param.isRecedeEdit eq 'true' and (isAdmin or isDriver) and (state eq 15)}">
      <div id="btnDiv" class="stadic_layout_footer stadic_footer_height border_t padding_tb_10 align_right bg_color_black">
        <a id="btnok" onclick="fnOK();" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('office.tbar.recede.js') }</a> 
        <a id="btncancel" onclick="fnCancel();" class="common_button common_button_grayDark margin_r_10" href="javascript:void(0)">${ctp:i18n('common.button.cancel.label')}</a>
      </div>
    </c:if>
 </div>
</body>
</html>