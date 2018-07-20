<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>车辆消息提醒設置</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/autoPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/auto/autoNoticeSet.js${ctp:resSuffix()}"></script>
</head>
<body class="h100b over_hidden">
 <div class="stadic_layout h100b font_size12 bg_color">
        <div class="stadic_layout_head stadic_head_height" >
            <!--上边区域-->
        </div>
        <div class="stadic_layout_body stadic_body_top_bottom margin_b_5">
            <!--中间区域-->
            <div id="reminDiv" class="form_area set_search align_center">
                <table border="0" cellSpacing="5" cellPadding="0" align="center" width='500'>
                    <tr>
                        <td noWrap="nowrap" align="left">
                            <label class="margin_t_5 hand display_block" for="Checkbox5">
                                <input id="checkRepair" class="radio_com" onclick="reminClick();" name="option" value="0" type="checkbox">${ctp:i18n('office.auto.notice.maintain.js') }${ctp:i18n('office.auto.notice.js') }：${ctp:i18n('office.auto.notice.forward.js') }
                            </label>
                        </td>
                        <td nowrap="nowrap"  style="width: 25%" >
                            <div class="common_txtbox_wrap">
                                <input id="remindMilRepair" class="validate font_size12" type="text" maxlength="6" validate="isInteger:true,name:'',max:99999,min:0">
                                <input id="id" type="hidden">
                            </div>
                        </td>
                        <td nowrap="nowrap">
                              ${ctp:i18n('office.auto.maintenance.js') }，${ctp:i18n('office.auto.notice.orr.js') }${ctp:i18n('office.auto.notice.forward.js') }
                        </td>
                        <td nowrap="nowrap" style="width: 25%">
                            <div class="common_txtbox_wrap">
                                <input id="remindDateRepair" class="validate font_size12" type="text" maxlength="80" validate="isInteger:true,name:'',max:999,min:0">
                            </div>
                        </td>
                        <td nowrap="nowrap" align="left">${ctp:i18n('office.auto.notice.day.js') }</td>
                    </tr>
                    
                    <tr>
                        <td noWrap="nowrap" align="left">
                            <label class="margin_t_5 hand display_block" for="Checkbox5">
                                <input id="checkInspection"  onclick="reminClick();" class="radio_com" name="option" value="0" type="checkbox">${ctp:i18n('office.auto.notice.inspection.js') }${ctp:i18n('office.auto.notice.js') }：${ctp:i18n('office.auto.notice.forward.js') }
                            </label>
                        </td>
                        <td nowrap="nowrap" style="width: 25%">
                            <div class="common_txtbox_wrap">
                                <input id="remindDateInspection" class="validate font_size12" type="text" maxlength="80" validate="isInteger:true,name:'',notNull:true,max:999,min:0">
                            </div>
                        </td>
                        <td nowrap="nowrap" align="left" colspan="3">${ctp:i18n('office.auto.notice.day.js') } </td>
                    </tr>
                    
                    
                    <tr>
                        <td noWrap="nowrap" align="left">
                            <label class="margin_t_5 hand display_block" for="Checkbox5">
                                <input id="checkSafety"  onclick="reminClick();" class="radio_com" name="option" value="0" type="checkbox">${ctp:i18n('office.auto.notice.safety.js') }${ctp:i18n('office.auto.notice.js') }：${ctp:i18n('office.auto.notice.forward.js') }
                            </label>
                        </td>
                        <td nowrap="nowrap" style="width: 25%">
                            <div class="common_txtbox_wrap">
                                <input id="remindDateSafety" class="validate font_size12" type="text" maxlength="80" validate="isInteger:true,name:'',notNull:true,max:999,min:0">
                            </div>
                        </td>
                        <td nowrap="nowrap" align="left" colspan="3">${ctp:i18n('office.auto.notice.day.js') } </td>
                    </tr>
                    
                    <tr>
                        <td noWrap="nowrap" align="left">
                            <label class="margin_t_5 hand display_block" for="Checkbox5">
                                <input id="checkLicense"   onclick="reminClick();" class="radio_com" name="option" value="0" type="checkbox">${ctp:i18n('office.auto.notice.driverlicense.js') }${ctp:i18n('office.auto.notice.js') }：${ctp:i18n('office.auto.notice.forward.js') }
                            </label>
                        </td>
                        <td nowrap="nowrap" style="width: 25%">
                            <div class="common_txtbox_wrap" >
                                <input id="remindDateLicense" class="validate font_size12" type="text" maxlength="80" validate="isInteger:true,name:'',notNull:true,max:999,min:0">
                            </div>
                        </td>
                        <td nowrap="nowrap" align="left" colspan="3">${ctp:i18n('office.auto.notice.day.js') } </td>
                    </tr>
                    
                </table>
            </div>
        </div>
       <div id="btnDiv" class="stadic_layout_footer stadic_footer_height border_t padding_tb_5 align_center bg_color_black">
            <!--下边区域-->
            <a id="btnok" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('common.button.ok.label')}</a> <a id="btncancel" class="common_button common_button_gray margin_l_10"
                href="javascript:void(0)">${ctp:i18n('common.button.cancel.label')}</a>
       </div>
</div>
</body>
</html>