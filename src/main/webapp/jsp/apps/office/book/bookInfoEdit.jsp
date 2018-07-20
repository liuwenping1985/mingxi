<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<script type="text/javascript" charset="UTF-8"
  src="${path}/apps_res/office/js/pub/bookPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8"  src="${path}/apps_res/office/js/book/bookInfoEdit.js"></script>
</head>
<body class="h100b over_hidden">
  <div class="stadic_layout h100b font_size12">
    <div class="stadic_layout_head stadic_head_height">
      <!--上边区域-->
      <div class="clearfix bg_color_gray">
        <span class="left margin_5 font_bold color_blue">${ctp:i18n('office.bookinfo.reg.js') }</span><span
          class="right margin_5 green">*${ctp:i18n("office.auto.must.enter.js")}</span>
      </div>
    </div>
    <div id="tableDiv"
      class="stadic_layout_body stadic_body_top_bottom margin_b_10">
      <!--中间区域-->
      <div id="bookInfoDiv" class="form_area set_search align_center">
        <div id="mainbookInfo">
          <input id="id" name="id" type="hidden" />
          <table border="0" cellSpacing="0" cellPadding="0" align="center"
            class="w70b" style="table-layout:fixed;">
            <tr>
              <th noWrap="nowrap" align="right"><span class="color_red">*</span><label
                for="text">${ctp:i18n('office.bookinfo.num.js') }:</th>
              <td colspan="2">
                <div class="common_txtbox_wrap">
                  <input id="bookNum" name="bookNum"
                    class="validate font_size12" maxlength="80" value=""
                    validate="notNullWithoutTrim:true,type:'string',name:'${ctp:i18n('office.bookinfo.num.js') }',notNull:true,maxLength:80"
                    type="text" />
                </div>
              </td>
              <td colspan="3" rowspan="6" align="right">
              	<input type="hidden" id="bookImage" name="bookImage" value=""/>
                <div id="imageDiv" style="text-align: center;"></div>
                <div id="dyncid" ></div></td>
            </tr>
            <tr>
              <th noWrap="nowrap" align="right"><span class="color_red">*</span>${ctp:i18n('office.asset.apply.assetName.js') }:</th>
              <td colspan="2">
                <div class="common_txtbox_wrap">
                  <input id="bookName" class="validate font_size12"
                    maxlength="80" value=""
                    validate="notNullWithoutTrim:true,type:'string',name:'${ctp:i18n('office.asset.apply.assetName.js') }',notNull:true,maxLength:80"
                    type="text" />
                </div>
              </td>
            </tr>

            <tr>
              <th noWrap="nowrap" align="right"><label
                for="text">${ctp:i18n('office.bookinfo.type.js') }:</th>
              <td colspan="2">
                <div class="common_selectbox_wrap">
                    <select id="bookType" name="bookType" class="w100b codecfg font_size12"
                  codecfg="codeType:'java',codeId:'com.seeyon.apps.office.constants.BookInfoEnum',defaultValue:0"></select>
                </div>
              </td>
            </tr>

            <tr>
              <th noWrap="nowrap" align="right">${ctp:i18n('office.bookinfo.author.js') }:</th>
              <td colspan="2">
                <div class="common_txtbox_wrap">
                  <input id="bookAuthor" name="bookAuthor" 
                    class="validate font_size12" type="text" validate="type:'string',name:'${ctp:i18n('office.bookinfo.author.js') }',maxLength:80" />
                </div>
              </td>
            </tr>

            <tr>
              <th noWrap="nowrap" align="right">${ctp:i18n('office.bookinfo.publisher.js') }:</th>
              <td colspan="2">
                <div class="common_txtbox_wrap">
                  <input id="bookPublisher" name="bookPublisher" maxlength="80"
                    class="validate font_size12" type="text" validate="type:'string',name:'${ctp:i18n('office.bookinfo.publisher.js') }',maxLength:80" />
                </div>
              </td>
            </tr>

            <tr>
              <th noWrap="nowrap" align="right">${ctp:i18n('office.bookinfo.publishdate.js') }:</th>
              <td colspan="2">
                <div class="common_txtbox_wrap">
                    <input id="bookPublishTime" name="bookPublishTime" type="text" class="comp " comp="type:'calendar',ifFormat:'%Y-%m-%d '" readonly="readonly" validate="name:'${ctp:i18n('office.bookinfo.publishdate.js') }'"/>
                </div>
              </td>
            </tr>

            <tr>
              <th noWrap="nowrap" align="right">${ctp:i18n('office.bookinfo.price.js') }:</th>
              <td colspan="2">
                <div class="common_txtbox_wrap">
                  <input id="bookPrice" name="bookPrice" 
                    class="validate font_size12"  maxlength="8" type="text" validate="name:'${ctp:i18n('office.bookinfo.price.js') }',errorMsg:'${ctp:i18n('office.book.bookInfoEdit.pznsrxywxsdhlwdyxje.js') }',type:'number',min:0,dotNumber:2,integerDigits:5"/>
                </div>
              </td>
              <td colspan="3" align="right">
              	<a id="imgUpload"   class="common_button common_button_emphasize"  href="javascript:void(0)">${ctp:i18n('office.bookinfo.cover.upload.js') }</a>
              	<a id="imgCancel" class="common_button common_button_grayDark" href="javascript:void(0)">${ctp:i18n('office.bookinfo.cover.default.js') }</a>
              </td>
            </tr>
            <!--                         图片 -->

            <tr>
              <th noWrap="nowrap" align="right" valign="top">
              <label for="text">${ctp:i18n('office.bookinfo.summary.js') }:</label> </th>
              <td colspan="5" align="left">
                <div class="common_txtbox  clearfix margin_tb_5"  >
                  <textarea id="bookSummary"  name="bookMemo" class="validate font_size12"  
                    style="width: 100%; height: 50px;" validate="type:'string',name:'${ctp:i18n('office.bookinfo.summary.js') }',maxLength:80"></textarea>
                </div>
              </td>
            </tr>

            <tr>
              <th noWrap="nowrap" align="right"><span class="color_red">*</span>${ctp:i18n('office.stock.countsum.js') }:</th>
              <td colspan="2">
                <div class="common_txtbox_wrap">
                    <input id="bookCount" name="bookCount" class="validate font_size12"  maxlength="5" type="text" 
                    validate="name:'${ctp:i18n('office.stock.countsum.js') }',errorMsg:'${ctp:i18n('office.book.bookInfoEdit.pkcslznsrzs.js') }',isInteger:true,notNull:true,min:0,max:99999">
                </div>
              </td>
              <th noWrap="bookUnit" align="right">${ctp:i18n('office.stock.unit.js') }:</th>
              <td colspan="2">
                <div class="common_txtbox_wrap">
                  <input id="bookUnit" name="bookUnit"
                    maxlength="80" class="validate font_size12" validate="type:'string',errorMsg:'${ctp:i18n('office.book.bookInfoEdit.pjldwbnbhtszfjldw.js') }',name:'${ctp:i18n('office.stock.unit.js') }',maxLength:80,avoidChar:'|,&quot'"
                    type="text" />
                </div>
              </td>
            </tr>

            <tr>
              <th noWrap="nowrap" align="right"><span class="color_red">*</span><label for="text">${ctp:i18n('office.bookhouse.js') }:</th>
              <td colspan="2">
                <div class="common_selectbox_wrap" style="margin-bottom: 5px;margin-top: 5px;">
                <select  id="houseId" name="houseId" class="font_size12 validate" validate="name:'${ctp:i18n('office.bookhouse.js') }',notNull:true" ></select>
              </td>
              <th noWrap="nowrap" align="right"><span class="color_red">*</span>${ctp:i18n('office.bookinfo.category.js') }:</th>
              <td colspan="2">
                <div class="common_selectbox_wrap margin_tb_5" >
                    <select  id="bookCategory" name="bookCategory" class="w100b codecfg font_size12 validate" codecfg="codeId:'office_book_type'" validate="name:'${ctp:i18n('office.bookinfo.category.js') }',notNull:true"></select>
                </div>
              </td>
            </tr>

            <tr>
              <th noWrap="nowrap" align="right">${ctp:i18n('office.assetinfo.state.js') }:</th>
              <td colspan="2">
                <div class="common_selectbox_wrap margin_tb_5" >
                    <select  id="bookState" name="bookState" class="codecfg font_size12 "  codecfg="codeType:'java',codeId:'com.seeyon.apps.office.constants.BookInfoStateEnum'" ></select>
                </div>
              </td>
            </tr>
          </table>
        </div>
      </div>
    </div>
    <div id="btnDiv" class="stadic_layout_footer stadic_footer_height padding_tb_5 align_center bg_color_black">
      <!--下边区域-->
      <a id="btnok" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('common.button.ok.label')}</a> 
      <a id="btncancel" class="common_button common_button_grayDark margin_l_10" href="javascript:void(0)">${ctp:i18n('common.button.cancel.label')}</a>
    </div>
  </div>
</body>
</html>