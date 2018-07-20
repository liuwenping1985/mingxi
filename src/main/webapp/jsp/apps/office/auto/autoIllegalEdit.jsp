<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp"%>
<html class="h100b over_hidden">
<head>
<style type="text/css">
.stadic_layout_body {
  top: 0px;
  bottom: 30px;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>车辆违章事故新建，编辑</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/auto/autoIllegalEdit.js${ctp:resSuffix()}"></script>
</head>
<body class="h100b over_hidden">
  <div class="stadic_layout h100b font_size12">
    <div class="stadic_layout_body stadic_body_top_bottom margin_b_10">
        <div id="autoIllegal" class="form_area set_search align_center w100b">
            <table id="autoUseTab" border="0" cellSpacing="5" cellPadding="0" align="center" style="table-layout:fixed;">
              <tr>
                  <td colspan="6">&nbsp;</td>
              </tr>
              <tr>
                <th noWrap="nowrap" width="100" align="right"><span class="color_red">*</span><label  for="text">${ctp:i18n('office.auto.num.js') }:</label></th>
                <td colspan="2" width="200" >
                  <div id="userDiv" class="common_txtbox_wrap">
                    <input id="autoInfoNumber" class="font_size12 validate" readonly="readonly" validate="name:'${ctp:i18n('office.auto.num.js') }',notNull:true" onclick="fnSelectCarOrDriverMember('auto')">
                    <input id="autoInfoId" type="hidden" value=""/>
                    <input id="id" type="hidden" value=""/>
                  </div>
                </td>
                <th noWrap="nowrap" width="100" align="right"><label  for="text">${ctp:i18n('office.auto.illegal.illegalDate.js') }:</label></th>
                <td colspan="2" width="200">
                  <div class="common_txtbox_wrap">
                      <input id="illegalDate" readonly="readonly" type="text" class="comp" comp="type:'calendar',onUpdate:fnShowDriver,ifFormat:'%Y-%m-%d %H:%M',showsTime:true" comptype="calendar"/>
                  </div>
                </td>
              </tr>
              <tr>
                <th noWrap="nowrap" align="right"><label  for="text">${ctp:i18n('office.auto.illegal.illegalAddr.js') }:</label></th>
                <td colspan="2">
                    <div class="common_txtbox_wrap">
                      <input id="illegalAddr" class="validate font_size12" maxlength="80" type="text" validate="type:'string',name:'${ctp:i18n('office.auto.illegal.illegalAddr.js') }',avoidChar:'-!@#$%^&*()_+\'&quot;'">
                    </div>
                </td>
                <th noWrap="nowrap" align="right"><label  for="text">${ctp:i18n('office.auto.illegal.illegalAction.js') }:</label></th>
                <td colspan="2">
                    <div class="common_txtbox_wrap">
                    <input id="illegalAction" class="validate font_size12" maxlength="80" type="text" validate="type:'string',name:'${ctp:i18n('office.auto.illegal.illegalAction.js') }',avoidChar:'-!@#$%^&*()_+\'&quot;'" >
                    </div>
                </td>
              </tr>
              <tr>
                  <th noWrap="nowrap" width="100" align="right"><label  for="text">${ctp:i18n('office.auto.illegal.money.js') }:</label></th>
                  <td width="180">
                      <div class="common_txtbox_wrap">
                      <input id="money" class="validate font_size12" maxlength="11"  type="text" validate="name:'${ctp:i18n('office.auto.illegal.money.js') }',errorMsg:'${ctp:i18n('office.auto.check.money.js')}',type:'number',min:0 , dotNumber:2, isInteger:true,integerDigits:8">
                      </div>
                  </td>
                  <td width="20" align="right"><label  for="text">${ctp:i18n('office.auto.yuan.js') }</label></td>
                  <th noWrap="nowrap" width="100" align="right"><label  for="text">${ctp:i18n('office.auto.illegal.mark.js') }:</label></th>
                  <td width="180">
                     <select id="mark" class="w100b font_size12">
                          <option value="0" selected="selected">0</option>
                          <option value="1">1</option>
                          <option value="3">3</option>
                          <option value="6">6</option>
                          <option value="12">12</option>
                      </select>
                  </td> 
                  <td width="20" align="right"><label  for="text">${ctp:i18n('office.auto.fen.js') }</label></td>
              </tr>
              <tr>
                  <th noWrap="nowrap" align="right"><span class="color_red">*</span><label  for="text">${ctp:i18n('office.auto.driver.js') }:</label></th>
                  <td colspan="2">
                      <div class="common_txtbox_wrap">
                        <input id="driverMemberName" class="font_size12 validate"  type="text" readonly="readonly" validate="name:'${ctp:i18n('office.auto.driver.js') }',notNull:true" onclick="fnSelectCarOrDriverMember('driver')">
                        <input id="autoDriverId" type="hidden" value=""/>
                      </div>
                  </td>
                  <th noWrap="nowrap" align="right"><label  for="text">${ctp:i18n('office.auto.illegal.dealState.js') }:</label></th>
                  <td colspan="2">
                      <select id="dealState" class="w100b font_size12">
                          <option value="0" selected="selected">${ctp:i18n('office.auto.illegal.dealState1.js')}</option>
                          <option value="2" >${ctp:i18n('office.auto.illegal.dealState3.js') }</option>
                          <option value="1" >${ctp:i18n('office.auto.illegal.dealState2.js') }</option>
                      </select>
                  </td>  
              </tr>
              <tr>
                  <th noWrap="nowrap" align="right"><label  for="text">${ctp:i18n('office.auto.illegal.illegalFlag.js') }:</label></th>
                  <td colspan="5">
                    <div class="driver_radio_peopleType  clearfix align_left">
                      <label class="margin_r_10 hand" for="illegalContent"> <input
                        id="illegalFlag" class="radio_com" value="0" type="radio"  name="illegalFlag"
                        onclick="fnDisableIncidentDesc('enable')">${ctp:i18n('office.auto.illegal.illegalFlag1.js') }
                      </label><label class="margin_r_10 hand" for="illegalContent"> 
                      <input id="illegalFlag" class="radio_com" value="1" type="radio" checked="checked"
                        name="illegalFlag" onclick="fnDisableIncidentDesc('disable')">${ctp:i18n('office.auto.illegal.illegalFlag2.js') }
                      </label>
                    </div>
                  </td>
              </tr>
              <tr>
                  <th noWrap="nowrap" align="right" valign="top">
                      <label  for="illegalContent">${ctp:i18n('office.auto.illegal.illegalContent.js') }:</label>
                  </th>
                  <td colspan="5" align="left">
                      <div class="common_txtbox  clearfix">
                          <textarea id="illegalContent" style="width: 98%; height: 45px;" disabled="disabled" class="padding_5 margin_r_5 validate" validate="name:'${ctp:i18n('office.auto.illegal.illegalContent.js') }',type:'string',maxLength:600"></textarea>
                      </div>
                  </td>
              </tr>
            </table>
        </div>
    </div>
  </div>
</body>
</html>