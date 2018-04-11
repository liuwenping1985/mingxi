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
<script type="text/javascript">
pTemp.isRemind = "${isRemind}";
</script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.car.illegal.edit.js')}</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/auto/autoRepairEdit.js${ctp:resSuffix()}"></script>
</head>
<body class="h100b over_hidden">
  <div class="stadic_layout h100b font_size12">
    <div class="stadic_layout_body stadic_body_top_bottom h100b">
        <div id="autoRepair" class="form_area set_search align_center w100b">
            <table id="autoRepairTab" border="0" cellSpacing="5" cellPadding="0" style="" align="center" class="w80b">
                <tr><td colspan="5">&nbsp;</td></tr>
               <tr>
                 <th style="width:10%;" noWrap="nowrap" align="right"><span class="color_red">*</span><label  for="text">${ctp:i18n('office.auto.num.js')}:</label></th>
                  <td style="width:30%;">
                    <div id="userDiv" class="common_txtbox_wrap">
                      <input id="autoInfoNumber" class="font_size12 validate" readonly="readonly" validate="name:'${ctp:i18n('office.auto.num.js')}',notNull:true" onclick="fnSelectCarOrDriverMember('auto')">
                      <input id="autoInfoId" type="hidden" value=""/>
                      <input id="id" type="hidden" value=""/>
                    </div>
                  </td>
                  <th style="width:10%;" noWrap="nowrap" align="right"><span class="color_red">*</span><label  for="text">${ctp:i18n('office.auto.handled.js')}:</label></th>
                  <td style="width:30%;" colspan="2">
                      <div id="userDiv" class="common_txtbox_wrap">
                           <input id="memberName" value="${memberName }" class="font_size12 validate" readonly="readonly" validate="name:'${ctp:i18n('office.auto.handled.js')}',notNull:true"  onclick="fnSelectCarOrDriverMember('managerOrDriver')">
                           <input id="memberId" value="${memberId }" type="hidden" value="123"/>
                      </div>
                  </td>
              </tr>
              <tr>
                 <th noWrap="nowrap" align="right"><label  for="text">${ctp:i18n('office.auto.repairtime.js') }:</label></th>
                 <td>
                     <div class="common_txtbox_wrap">
                          <input id="repairTime" type="text" readonly="readonly"  class="comp" comp="type:'calendar',onUpdate:repairTimeVer,ifFormat:'%Y-%m-%d %H:%M',showsTime:true" comptype="calendar"/>
                     </div>
                 </td>  
                 <th noWrap="nowrap" align="right"><label  for="text">${ctp:i18n('office.auto.backtime.js')}:</label></th>
                 <td colspan="2">
                     <div class="common_txtbox_wrap">
                          <input id="retrievalTime" type="text" readonly="readonly"  class="comp" comp="type:'calendar',onUpdate:repairTimeVer,ifFormat:'%Y-%m-%d %H:%M',showsTime:true" comptype="calendar"/>
                     </div>
                 </td>           
              </tr>
              <tr>
                 <th noWrap="nowrap" align="right"><label  for="text">${ctp:i18n('office.auto.repairshop.js')}:</label></th>
                 <td>
                     <div id="userDiv" class="common_txtbox_wrap">
                        <input id="repairPlant" class="font_size12 validate" validate="name:'${ctp:i18n('office.auto.repairshop.js') }',type:'string',maxLength:80">
                     </div>
                 </td>
                 <th noWrap="nowrap" align="right"><label  for="text">${ctp:i18n('office.auto.cost.js') }:</label></th>
                 <td>
                     <div id="userDiv" class="common_txtbox_wrap">
                          <input id="repairFee" class="font_size12 validate" maxlength="11"  validate="name:'${ctp:i18n('office.auto.cost.js') }',errorMsg:'${ctp:i18n('office.auto.money.check.js')}',type:'number',min:0, dotNumber:2, integerDigits:8" >
                     </div>
                 </td>
                 <td>
                     <label  for="text">${ctp:i18n('office.auto.yuan.js') }</label>
                 </td>              
              </tr>
              <tr>
                  <th noWrap="nowrap" align="right"><label  for="text">${ctp:i18n('office.auto.repairType.js') }:</label></th>
                  <td>
                    <div class="driver_radio_peopleType  clearfix align_left">
                      <label class="margin_r_10 hand" for="isIncidentFlag"> <input
                        id="repairType" class="radio_com" value="0" type="radio"
                        checked="checked" name="repairType" onclick="fnMaintenanceTabDisableOrEnable(0)"/><span class="margin_l_5">${ctp:i18n('office.auto.repairType1.js') }</span>
                      </label><label class="margin_r_10 hand" for=isIncidentFlag> 
                      <input id="repairType" class="radio_com" value="1" type="radio"
                        name="repairType" onclick="fnMaintenanceTabDisableOrEnable(1)" /><span class="margin_l_5">${ctp:i18n('office.auto.repairType2.js') }</span>
                      </label>
                    </div>
                  </td>
                  <th id="maintenanceMileageth" noWrap="nowrap" align="right"><label  for="text">${ctp:i18n('office.auto.maintenanceMileageth.js')}:</label></th>
                  <td id="maintenanceMileageTd">
                      <div class="common_txtbox_wrap">
                           <input id="maintenanceMileage" maxlength="9" ype="text" class="font_size12 validate" validate="isInteger:true,name:'${ctp:i18n('office.auto.maintenanceMileageth.js')}'"/>
                      </div>
                  </td>
                  <td id="maintenanceMileagetext" tyle="width:35px;">
                       <label  for="text">${ctp:i18n('office.auto.maintenance.js') }</label>
                  </td>
              </tr>
              <tr id="nextMaintenanceMileagetr">
                  <th>&nbsp;</th>
                  <td>&nbsp;</td>
                  <th noWrap="nowrap" align="right"><label  for="text">${ctp:i18n('office.auto.nextMaintenanceMileageth.js')}:</label></th>
                  <td>
                      <div class="common_txtbox_wrap">
                           <input id="nextMaintenanceMileage" maxlength="9" type="text" class="font_size12 validate" validate="isInteger:true,name:'${ctp:i18n('office.auto.nextMaintenanceMileageth.js')}'"/>
                      </div>
                  </td>
                  <td style="width:35px;">
                      <label  for="text">${ctp:i18n('office.auto.maintenance.js') }</label>
                  </td>
              </tr>
              <tr id="nextMaintenanceDatetr">
                 <th>&nbsp;</th>
                 <td>&nbsp;</td>
                 <th noWrap="nowrap" align="right"><label  for="text">${ctp:i18n('office.auto.nextMaintenanceDate.js') }:</label></th>
                 <td colspan="2">
                     <div class="common_txtbox_wrap">
                          <input id="nextMaintenanceDate" readonly="readonly" type="text" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true" comptype="calendar"/>
                     </div>
                 </td>
              </tr>
              <tr>
                 <th noWrap="nowrap" align="right" valign="top">
                     <label  for="text">${ctp:i18n('office.auto.maintanceProject.js') }:</label>
                 </th>
                 <td  align="left" colspan="4">
                      <div class="common_txtbox  clearfix">
                           <textarea id="repairProject" style="width: 98%; height: 45px;" class="padding_5 margin_r_5 validate" validate="name:'${ctp:i18n('office.auto.maintanceProject.js') }',type:'string',maxLength:600"></textarea>
                      </div>
                 </td>
              </tr>
              <tr>
              <th noWrap="nowrap" align="right" valign="top">
                     <label  for="text">${ctp:i18n('office.auto.repairRemarks.js') }:</label>
                 </th>
                 <td  align="left" colspan="4">
                      <div class="common_txtbox  clearfix">
                           <textarea id="repairRemarks" style="width: 98%; height: 36px;" class="padding_5 margin_r_5 validate" validate="name:'${ctp:i18n('office.auto.repairRemarks.js') }',type:'string',maxLength:600"></textarea>
                      </div>
                 </td>
              </tr>
            </table>
        </div>
    </div>
  </div>
</body>
</html>