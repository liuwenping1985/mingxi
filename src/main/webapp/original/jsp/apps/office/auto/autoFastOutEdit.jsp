<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<style type="text/css">
  .stadic_layout_footer {
    height: 40px;
  }
</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.quick.car.edit.js')}</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/auto/autoOutEdit.js"></script>
</head>
<body class="h100b font_size12 over_hidden bg_color">
<div class="stadic_layout h100b font_size12">
  <div id="autoSendDiv" class="form_area set_search align_center w100b">
    <div class="margin_t_10"></div>
    <table id="autoUseTab"  class="w100b" border="0" cellSpacing="0" cellPadding="0" align="center" style="table-layout:fixed;">
      <tr>
        <th noWrap="nowrap" align="right"><span class="color_red">*</span><label  for="text">${ctp:i18n('office.autoapply.udate.js')}:</label></th>
        <td colspan="3">
          <table class="w80b" border="0" cellSpacing="0" cellPadding="0" style="table-layout:fixed;">
           <tr nodePostion="send" nodeAcl="sendOut">
              <td align="left">
                <div class="common_txtbox clearfix">
                 <input id="applyOuttime" class="comp font_size12 validate" style="width:98%" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true" validate="name:'${ctp:i18n('office.autoapply.udate.js')}',notNull:true" readonly>
                </div>
              </td>
              <td width="20"><span class="margin_lr_5 margin_t_5 left">${ctp:i18n('office.asset.apply.to.js')}</span></td>
              <td align="left">
                <div class="common_txtbox clearfix">
                  <input id="applyBacktime" class="comp validate font_size12" style="width:98%" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true" validate="name:'${ctp:i18n('office.autoapply.udate.js')}',notNull:true" readonly>
                </div>
              </td>
            </tr>
          </table>
        </td>
      </tr>
      <tr nodePostion="send" nodeAcl="sendOut">
        <th width="120" noWrap="nowrap" align="right"><span class="color_red">*</span><label for="text">${ctp:i18n('office.app.auto.js')}:</label></th>
        <td colspan="2">
          <div class="common_txtbox_wrap bg_color">
            <input id="applyAutoId" type="hidden">
            <input id="applyUser" type="hidden">
            <input id="passengerNum" type="hidden">
            <input id="applyAutoIdName" onclick="fnOpenAutoPub('autoAdmin');" class="validate font_size12" validate="type:'string',notNull:true,name:'${ctp:i18n('office.app.auto.js')}'" type="text" readonly="readonly">
          </div>
        </td>
        <td width="70"><div id="applySelf2Msg" class="display_none"><input id="selfDriving" value="1" type="checkbox"></div></td>
      </tr>
      
     <tr id="applyDriverDiv" nodePostion="send" nodeAcl="sendOut">
        <th noWrap="nowrap" align="right"><span id="applyDriverSpan" class="color_red">*</span><label for="text">${ctp:i18n('office.auto.autoStcInfo.jsy.js')}:</label></th>
        <td colspan="2">
          <div class="common_txtbox_wrap">
            <input id="applyDriverName" type="text" onclick="fnSelectPeoplePub({type:'driver'});" class="font_size12 validate" validate="type:'string',notNull:true,name:'${ctp:i18n('office.auto.autoStcInfo.jsy.js')}'" readonly="readonly">
            <input id="applyDriver" type="hidden">
            <input id="shadowapplyDriver" type="hidden">
            <input id="shadowapplyDriverName" type="hidden">
            <input id="shadowapplyDriverPhone" type="hidden">
          </div>
        </td>
        <td></td>
      </tr>
      
      <tr nodePostion="autoOut" nodeAcl="sendOut">
        <th noWrap="nowrap" align="right"><span class="color_red">*</span><label for="text">${ctp:i18n('office.auto.autoStcInfoShow.ccsj.js')}:</label></th>
        <td colspan="2">
          <div class="common_txtbox_wrap">
              <input id="realOuttime" class="comp font_size12 validate" type="text" validate="type:'string',notNull:true,name:'${ctp:i18n('office.auto.autoStcInfoShow.ccsj.js')}'" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true" readonly>
          </div>
        </td>
        <td></td>
      </tr>
      
      <tr nodePostion="autoOut" nodeAcl="sendOut">
        <th noWrap="nowrap" align="right"><label for="text">${ctp:i18n('office.autoapply.outkm.js')}:</label></th>
        <td colspan="2">
          <div class="common_txtbox_wrap clearfix">
            <input id="outmileage" class="validate font_size12"  type="text" maxlength="9" validate="type:'number',name:'',regExp:'^[0-9]{0,9}$',errorMsg:'${ctp:i18n('office.auto.out.car.check.js')}'">
           </div>
        </td>
        <td nowrap="nowrap" align="left" class="padding_l_5">${ctp:i18n('office.auto.maintenance.js')}</td>
      </tr>
    </table>
  </div>
  <c:if test="${param.isEdit eq 'true'}">
    <div id="btnDiv" class="stadic_layout_footer stadic_footer_height border_t padding_tb_5 align_right bg_color_black">
      <!--下边区域-->
      <c:if test="${isAdmin}">
        <a id="btnEdit" onclick="fnOK('save');" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('office.auto.save.js')}</a> 
      </c:if>
      <a id="btnOut" onclick="fnOK('out');" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('office.tbar.out.js')}</a> 
      <a id="btncancel" onclick="fnCancel();" class="common_button common_button_grayDark margin_r_10" href="javascript:void(0)">${ctp:i18n('common.button.cancel.label')}</a>
    </div>
  </c:if>
</div>
</body>
</html>