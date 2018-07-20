<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.auto.driver.js')}</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/auto/autoDriverEdit.js"></script>
</head>
<body class="h100b over_hidden">
  <div class="stadic_layout h100b font_size12">
    <div class="stadic_layout_head stadic_head_height">
      <!--上边区域-->
      <div class="clearfix bg_color_gray">
        <span class="left margin_5 font_bold color_blue">${ctp:i18n('office.auto.driver.js')}</span><span
          class="right margin_5 green">*${ctp:i18n('office.auto.mustfill.js')}</span>
      </div>
    </div>
    <div class="stadic_layout_body stadic_body_top_bottom margin_b_10">
      <!--中间区域-->
      <div id="driverDiv" class="form_area set_search align_center w100b">
        <table border="0" cellSpacing="0" cellPadding="0" align="center" width="488">
          <tr>
            <th noWrap="nowrap" align="right"><strong>${ctp:i18n('office.auto.peopleinfo.js')}</strong></th>
            <td colspan="3"></td>
          </tr>
          <tr>
            <th noWrap="nowrap" align="center"><label for="text">${ctp:i18n('office.auto.peopletype.js')}:</label></th>
            <td colspan="3" width="300">
              <div class="driver_radio_peopleType  clearfix align_left">
                <label class="margin_r_10 hand" for="memberType_self"> 
                <input id="memberType" class="radio_com" value="0" type="radio"
                checked="checked" name="memberType"
                  onclick="fnShowOrHideSelectPeople('show')">${ctp:i18n('office.auto.peoplesystem.js')}
                </label><label class="margin_r_10 hand" for=memberType_self> 
                <input id="memberType" class="radio_com" value="1" type="radio"
                  name="memberType" onclick="fnShowOrHideSelectPeople('hide')">${ctp:i18n('office.auto.peopleselfhelp.js')}
                </label>
                <input id="id" type="hidden">
                <input id="createDate" type="hidden">
              </div>
            </td>
          </tr>

          <tr id="inputNameTr" class="display_none">
            <th noWrap="nowrap" align="center"><span class="color_red">*</span>
              <label for="text">${ctp:i18n('office.auto.drivername.js')}:</label></th>
            <td colspan="3" width="300">
            <div class="common_txtbox_wrap">
                <input id="memberName" class="validate font_size12" type="text" validate="type:'string',name:'${ctp:i18n('office.auto.drivername.js')}',maxLength:40,notNullWithoutTrim:true,avoidChar:'|,&quot'"/>
            </div>
            </td>
          </tr>
          <tr id="selectPeopleTr">
            <th noWrap="nowrap" align="center"><span class="color_red">*</span>
              <label for="text">${ctp:i18n('office.auto.drivername.js')}:</label></th>
            <td colspan="3" width="300">
              <div class="common_txtbox_wrap">
                <input type="text" id="systemMemberName" name="systemMemberName" class="comp validate"
                  comp="type:'selectPeople',maxSize:'1',minSize:'1',onlyLoginAccount:true,showOriginalElement:false, panels:'Department',selectType:'Member',callback:systemMemberNameCallBack" validate="type:'string',name:'${ctp:i18n('office.auto.drivername.js')}',notNull:true,avoidChar:'|,&quot'"/>
              </div>
            </td>
          </tr>
          
          <tr>
            <th noWrap="nowrap" align="center"><label for="text">${ctp:i18n('office.auto.phone.js')}:</label></th>
            <td width="300" colspan="3"><div class="common_txtbox_wrap">
                <input id="phoneNumber" class="font_size12" type="text" maxlength="20">
              </div></td>
          </tr>
          <tr>
            <th noWrap="nowrap" align="center"><strong>${ctp:i18n('office.auto.drivinglicenceinfo.js')}</strong></th>
            <td colspan="3"></td>
          </tr>
          <tr>
            <th noWrap="nowrap" align="center"><label for="text">${ctp:i18n('office.auto.receiveDate.js')}:</label></th>
            <td width="300" colspan="3">
              <div class="common_txtbox_wrap">
                <input id="receiveDate" type="text" class="comp font_size12" readonly="readonly" comp="type:'calendar',ifFormat:'%Y-%m-%d '" validate="name:'${ctp:i18n('office.auto.cclzrq.js')}'"/>
              </div>
            </td>
          </tr>

          <tr>
            <th noWrap="nowrap" align="center"><label for="text">${ctp:i18n('office.auto.licenseType.js')}:</label></th>
            <td width="300" colspan="3">
              <div class="w100b">
                <select id="licenseType"  class="w100b codecfg font_size14"
                  codecfg="codeType:'java',codeId:'com.seeyon.apps.office.constants.AutoDriverEnum',defaultValue:0">
                </select> 
              </div>
            </td>
          </tr>

          <tr>
            <th noWrap="nowrap" align="center"><label for="text">${ctp:i18n('office.auto.validDate.js')}:</label></th>
            <td width="140">
              <div class="common_txtbox_wrap" >
                <input id="validStartDate" type="text"  class="comp font_size12"  comp="type:'calendar',ifFormat:'%Y-%m-%d '" readonly="readonly" validate="name:'${ctp:i18n('office.auto.sdate.is.used.js')}'"/>
              </div>
            </td>
            <td width="20" nowrap="nowrap"><div class="margin_lr_5">${ctp:i18n('office.auto.to.js')}:</div></td>
            <td width="140">
              <div class="common_txtbox_wrap" >
                <input id="validEndDate" type="text"  class="comp font_size12" comp="type:'calendar',ifFormat:'%Y-%m-%d '" readonly="readonly" validate="name:'${ctp:i18n('office.auto.edate.is.used.js')}'"/>
              </div>
            </td>
          </tr>
          <tr>
            <td colspan="4">&nbsp;</td>
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