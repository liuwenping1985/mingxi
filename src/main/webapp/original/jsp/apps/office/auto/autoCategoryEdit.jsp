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
<title>${ctp:i18n('office.auto.car.categorySet.js')}</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/auto/autoCategoryEdit.js"></script>
</head>
<body class="h100b over_hidden">
 <div class="stadic_layout h100b font_size12">
        <div class="stadic_layout_head stadic_head_height bg_color_gray" >
            <!--上边区域-->
            <div class="clearfix ">
                <span class="left margin_5 font_bold color_blue">${ctp:i18n('office.auto.category.set.js') }</span><span class="right margin_5 green">*${ctp:i18n('office.auto.must.enter.js') }</span>
            </div>
        </div>
        <div id="centerDIV" class="stadic_layout_body stadic_body_top_bottom margin_b_5" style="overflow-x: hidden">
            <!--中间区域-->
            <div id="categoryDiv" class="form_area set_search align_center">
                 <table border="0" cellSpacing="0" cellPadding="0" align="center" style="table-layout:fixed;" width='400'>
                    <tr>
                        <th class="padding_r_5" width="100" noWrap="nowrap" align="right"><span class="color_red">*</span><label  for="text">${ctp:i18n('office.auto.category.name.js') }:</label></th>
                        <td>
                            <div class="common_txtbox_wrap">
                                <input id="subject" class="validate font_size12" type="text" maxlength="80" validate="notNullWithoutTrim:'true',type:'string',name:'${ctp:i18n('office.auto.category.name.js')}',notNull:true">
                                <input id="id" type="hidden">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th class="padding_r_5" noWrap="nowrap" align="right" valign="top">
                            <span class="color_red">*</span><label for="text">${ctp:i18n('office.auto.category.usescope.js') }:</label>
                        </th>
                        <td align="left">
                            <div class="common_txtbox clearfix">
                                <textarea id="range" name="range" class="comp w100b validate font_size12" style="height: 70px;"
                                 validate="notNullWithoutTrim:'true',type:'string',name:'${ctp:i18n('office.auto.category.usescope.js')}',notNull:true"
                                 comp="type:'selectPeople', panels:'Account,Department,Team,Post,Level',selectType:'Account,Department,Team,Post,Level,Member',isNeedCheckLevelScope:false">
                                </textarea>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
       <div id="btnDiv" class="stadic_layout_footer stadic_footer_height border_t padding_tb_5 align_center bg_color_black display_none">
            <a id="btnok" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('common.button.ok.label')}</a> 
            <a id="btncancel" class="common_button common_button_grayDark margin_l_10" href="javascript:void(0)">${ctp:i18n('common.button.cancel.label')}</a>
       </div>
</div>
</body>
</html>