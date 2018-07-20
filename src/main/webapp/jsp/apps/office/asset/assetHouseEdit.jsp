<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b">
<head>
<style type="text/css">
.stadic_layout_head {
  height: 22px;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.asset.assetHouseEdit.psbsz.js') }</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/asset/assetHouseEdit.js"></script>
</head>
<body class="h100b over_hidden">
  <div class="stadic_layout h100b font_size12">
    <div class="stadic_layout_head stadic_head_height bg_color_gray">
      <!--上边区域-->
      <div class="clearfix ">
        <span class="left margin_5 font_bold color_blue">${ctp:i18n('office.assethouse.set.js') }</span><span class="right margin_5 green">*${ctp:i18n('office.auto.must.enter.js') }</span>
      </div>
    </div>
    <div id="centerDIV" class="stadic_layout_body stadic_body_top_bottom margin_b_5">
      <!--中间区域-->
      <div id="assetHouseDiv" class="form_area set_search align_center">
        <table border="0" cellSpacing="0" cellPadding="0" align="center" style="table-layout: fixed;" width='500'>
          <tr>
            <th class="padding_r_5" width="100" noWrap="nowrap" align="right"><span class="color_red">*</span><label for="text">${ctp:i18n('office.assethouse.name.js') }:</label>
            </th>
            <td>
              <div class="common_txtbox_wrap">
                <input id="name" class="validate font_size12" type="text" maxlength="85" validate="notNullWithoutTrim:'true',type:'string',name:'${ctp:i18n('office.assethouse.name.js') }',notNull:true"> <input id="id" type="hidden">
              </div>
            </td>
          </tr>
          <tr>
            <th class="padding_r_5" width="100" noWrap="nowrap" align="right"><span class="color_red">*</span><label for="text">${ctp:i18n('office.stock.house.manager.js') }:</label>
            </th>
            <td>
              <div class="common_txtbox_wrap">
              	<input id="manager" type="hidden" value=""/>
                <input id="managertxt" class="validate font_size12" type="text" readonly="readonly" validate="type:'string',name:'${ctp:i18n('office.stock.house.manager.js') }',notNull:true" value=""/>
              </div>
            </td>
          </tr>
          <tr>
            <th class="padding_r_5" noWrap="nowrap" align="right" valign="top"><span class="color_red">*</span><label for="text">${ctp:i18n('office.stock.house.usescope.js') }:</label></th>
            <td align="left">
              <div class="common_txtbox clearfix">
                <textarea id=scope name="scope" class="comp w100b validate font_size12" style="height: 70px;" 
                validate="notNullWithoutTrim:'true',type:'string',name:'${ctp:i18n('office.stock.house.usescope.js')}',notNull:true"
                comp="type:'selectPeople', panels:'Account,Department,Team,Post,Level',selectType:'Account,Department,Team,Post,Level,Member',isNeedCheckLevelScope:false"></textarea>
              </div>
            </td>
          </tr>
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