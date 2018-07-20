<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>图书库设置</title>
<script type="text/javascript" charset="UTF-8"  src="${path}/apps_res/office/js/pub/bookPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8"  src="${path}/apps_res/office/js/book/bookHouseEdit.js"></script>
</head>
<body class="h100b over_hidden">
  <div class="stadic_layout h100b font_size12">
    <div class="stadic_layout_head stadic_head_height">
      <!--上边区域-->
      <div class="clearfix bg_color_gray">
        <span class="left margin_5 font_bold color_blue">${ctp:i18n('office.book.bookHouseEdit.ptsksz.js') }</span><span
          class="right margin_5 green">*${ctp:i18n('office.auto.mustfill.js')}</span>
      </div>
    </div>
    <div class="stadic_layout_body stadic_body_top_bottom margin_b_10">
      <!--中间区域-->
      <div id="bookHouseDiv" class="form_area set_search align_center w100b" >
        <table border="0" cellSpacing="0" cellPadding="0" align="center"
          width="750" style="table-layout:fixed;">
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <input id="id" type="hidden" />
          <input id="houseManager" type="hidden" value="" />
          <tr>
            <th noWrap="nowrap" align="center"><span class="color_red">*</span>
              <label for="text">${ctp:i18n('office.book.bookHouseEdit.ptszlk.js') }:</label></th>
            <td colspan="3">
              <div class="common_txtbox_wrap">
                <input id="houseName" class="validate font_size12" type="text"
                  validate="type:'string',name:'${ctp:i18n('office.book.bookHouseEdit.ptszlk.js') }',maxLength:85,showConcurrentMember:true,notNullWithoutTrim:true" />
              </div>
            </td>
          </tr>

          <tr>
            <th noWrap="nowrap" align="center"><span class="color_red">*</span>
              <label for="text">${ctp:i18n('office.book.bookHouseEdit.pgly.js') }:</label></th>
            <td colspan="3">
              <div class="common_txtbox_wrap">
                <input id="houseManager_txt"  class="font_size12 validate"  type="text" readonly="readonly" 
                  validate="name:'${ctp:i18n('office.book.bookHouseEdit.pgly.js') }',notNull:true"  onclick="fnSelectBookMember('BookMember')"> 
              </div>
            </td>
          </tr>

          <tr>
            <th noWrap="nowrap" align="center" valign="top"><span class="color_red">*</span><label for="text">${ctp:i18n('office.book.bookHouseEdit.psyfw.js') }:</label></th>
            <td colspan="3" align="left">
              <div class="common_txtbox clearfix">
                <textarea id="rangeScope" name="range" class="comp w100b validate font_size12"  style="height: 70px;"
                  validate="notNullWithoutTrim:'true',type:'string',name:'${ctp:i18n('office.stock.house.usescope.js')}',notNull:true"
                  comp="type:'selectPeople',showOriginalElement:false, panels:'Department,Account,Level,Team',selectType:'Member,Account,Department,Team,Level'">
                </textarea>
              </div>
            </td>
          </tr>

          <tr>
            <th noWrap="nowrap" align="center"><span class="color_red">*</span>
              <label for="text">${ctp:i18n('office.book.bookHouseEdit.pjyts.js') }:</label></th>
            <td colspan="3">
              <div class="common_txtbox_wrap">
                <input id="borrowDays" class="validate font_size12" maxlength="5" type="text" 
                  validate="name:'${ctp:i18n('office.book.bookHouseEdit.pjyts.js') }',notNull:true,isInteger:true,min:0,max:99999" />
              </div>
            </td>
            <td align="left"><div class="margin_lr_5">（${ctp:i18n('office.book.bookHouseEdit.pyjcsjq.js') }）&nbsp;</div></td>
          </tr>

          <tr>
            <th noWrap="nowrap" align="center"><label for="text">${ctp:i18n('office.book.bookHouseEdit.pyjts.js') }:</label></th>
            <td colspan="3">
              <div class="common_txtbox_wrap">
                <input id="alertDays" class="validate font_size12"  maxlength="5" type="text" 
                  validate="name:'${ctp:i18n('office.book.bookHouseEdit.pyjts.js') }',isInteger:true,min:0,max:99999" />
              </div>
            </td>
            <td align="left"><div class="margin_lr_5">（${ctp:i18n('office.book.bookHouseEdit.phssjqjttx.js') }）</div></td>
          </tr>

          <tr>
            <th noWrap="nowrap" align="center"><label for="text">${ctp:i18n('office.book.bookHouseEdit.pxjcs.js') }:</label></th>
            <td colspan="3">
              <div class="common_txtbox_wrap">
                <input id="renewTimes" class="validate font_size12" maxlength="5" type="text"
                  validate="name:'续借次数',isInteger:true,min:0,max:99999" />
              </div>
            </td>
          </tr>
          <tr>
            <td colspan="2">&nbsp;</td>
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