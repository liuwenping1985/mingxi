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
<title></title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/auto/autoSafetyEdit.js${ctp:resSuffix()}"></script>
</head>
<body class="h100b over_hidden">
  <div class="stadic_layout h100b font_size12">
    <div class="stadic_layout_body stadic_body_top_bottom margin_b_10">
        <div id="autoSafetyEdit" class="form_area set_search align_center w100b">
            <table id="autoUseTab" border="0" cellSpacing="5" cellPadding="0" align="center" class="w80b">
              <tr>
                  <td colspan="5" class="w100b">&nbsp;</td>
              </tr>
              <tr>
                <th noWrap="nowrap" style="width:10%;" align="right"><span class="color_red">*</span><label  for="text">${ctp:i18n('office.auto.num.js')}:</label></th>
                <td style="width:30%;">
                  <div id="userDiv" class="common_txtbox_wrap">
                    <input id="autoInfoNumber" class="font_size12 validate w100b" readonly="readonly" validate="name:'${ctp:i18n('office.auto.num.js')}',notNull:true" onclick="fnSelectCarOrDriverMember('auto')">
                    <input id="autoInfoId" type="hidden" value=""/>
                    <input id="id" type="hidden" value=""/>
                  </div>
                </td>
                <th noWrap="nowrap" style="width:10%;" align="right"><label  for="text">${ctp:i18n('office.auto.safety.policyNum.js') }:</label></th>
                <td colspan="2" style="width:30%;">
                  <div class="common_txtbox_wrap">
                      <input id="policyNum" class="validate font_size12" type="text" maxlength="60" validate="type:'string',name:'${ctp:i18n('office.auto.safety.policyNum.js') }',avoidChar:'-!@#$%^&*()_+\'&quot;'">
                  </div>
                </td>
              </tr>
              <tr>
                <th noWrap="nowrap" align="right"><span class="color_red">*</span><label  for="text">${ctp:i18n('office.auto.safety.insuredDate.js') }:</label></th>
                <td>
                    <div class="common_txtbox_wrap">
                      <input id="insuredDate" type="text" class="validate comp"  readonly="readonly" validate="name:'${ctp:i18n('office.auto.safety.insuredDate.js') }',notNull:true" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false" comptype="calendar"/>
                    </div>
                </td>
                <th noWrap="nowrap" align="right"><span class="color_red">*</span><label  for="text">${ctp:i18n('office.auto.expDate.js') }:</label></th>
                <td colspan="2">
                    <div class="common_txtbox_wrap">
                    <input id="expDate" type="text" class="validate comp"  readonly="readonly" validate="name:'${ctp:i18n('office.auto.expDate.js') }',notNull:true" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false" comptype="calendar"/>
                    </div>
                </td>
              </tr>
                <tr>
                <th noWrap="nowrap" align="right"><label  for="text">${ctp:i18n('office.auto.safety.insuerType.js') }:</label></th> 
                <td>
                     <div class="common_txtbox_wrap">
                      <input id="insuerType" class="font_size12"  maxlength="60" type="text">
                      </div>
                 </td>
                  <th noWrap="nowrap" class="w15b" align="right"><label  for="text">${ctp:i18n('office.auto.safety.insureAmount.js') }:</label></th>
                  <td class="w25b">
                      <div class="common_txtbox_wrap">
                      <input id="insureAmount" class="validate font_size12"  maxlength="11" type="text" validate="name:'${ctp:i18n('office.auto.safety.insureAmount.js') }',errorMsg:'${ctp:i18n('office.auto.money.check.js')}',type:'number',min:0,dotNumber:2,integerDigits:8">
                      </div>
                  </td>
                  <td style="width:10px;" align="right"><label  for="text">${ctp:i18n('office.auto.yuan.js') }</label></td>
              </tr>
              <tr>
                  <th noWrap="nowrap" class="w15b" align="right"><label  for="text">${ctp:i18n('office.auto.safety.insureCompany.js') }:</label></th>
                  <td class="w25b">
                    <div class="common_txtbox_wrap">
                        <input id="insureCompany" class="validate font_size12" type="text" maxlength="80" validate="type:'string',name:'${ctp:i18n('office.auto.safety.insureCompany.js') }',avoidChar:'-!@#$%^&*()_+\'&quot;'">
                    </div>
                  </td> 
                  <th noWrap="nowrap" align="right"><span class="color_red">*</span><label  for="text">${ctp:i18n('office.auto.handled.js')}:</label></th>
                  <td colspan="2">
                      <div class="common_txtbox_wrap">
                        <input id="memberName" value="${memberName }" class="font_size12 validate"  type="text" readonly="readonly" validate="name:'${ctp:i18n('office.auto.handled.js')}',notNull:true" onclick="fnSelectCarOrDriverMember('managerOrDriver')">
                        <input id="memberId" value="${memberId }" type="hidden" value=""/>
                      </div>
                  </td>
              </tr>
              <tr>
                  <th noWrap="nowrap" align="right" valign="top">
                      <label  for="text">${ctp:i18n('office.auto.safety.insureRemark.js') }:</label>
                  </th>
                  <td colspan="5" align="left">
                      <div class="common_txtbox  clearfix">
                          <textarea id="insureRemark" style="width: 98%; height: 45px;" class="padding_5 margin_r_5 validate" validate="name:'${ctp:i18n('office.auto.safety.insureRemark.js') }',type:'string',maxLength:600"></textarea>
                      </div>
                  </td>
              </tr>
            </table>
        </div>
    </div>
  </div>
</body>
</html>