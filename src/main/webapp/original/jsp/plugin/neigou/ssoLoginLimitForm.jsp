<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
    <form name="addForm" id="addForm" method="post" target="">
    <div class="form_area" >
        <div class="one_row" style="width:50%;">
            <br>
            <table border="0" cellspacing="0" cellpadding="0">
                <tbody>                 
                    <input type="hidden" name="id" id="id"/>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('neigou.sso.manage.authmember')}:</label></th>
                        <td width="100%" colspan="5">
                            <div class="common_txtbox  clearfix">
                                <textarea rows="5" id="name"   class="w100b validate" readonly="readonly" validate="notNull:true" name="${ctp:i18n('neigou.sso.manage.authmember')}"></textarea>
                                <input type="hidden" id="entityId" name="entityId">
                                <input type="hidden" id="entityIds" name="entityIds">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('neigou.sso.manage.timedisplay')}:</label></th>
                        <td width="100%" colspan="5">
                            <div class="common_radio_box clearfix">
                                <label for="loginNotLimit" class="margin_r_30 hand"><input type="radio" value="false" id="loginNotLimit" name="limit" class="radio_com" checked="checked">${ctp:i18n('neigou.sso.manage.loginnotlimit')}</label>
                                <label for="loginLimit" class="margin_r_30 hand"><input type="radio" value="true" id="loginLimit" name="limit" class="radio_com">${ctp:i18n('neigou.sso.manage.loginlimit')}</label>     
                            </div> 
                        </td>
                    </tr>
                    <tr id="tr_time" class="hidden">
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red"></font></label></th>
                        <td width="100%" colspan="5">
                            <table border="0" cellspacing="0" style="width: 100%;" cellpadding="0" class="margin_b_15">
                                <tbody>
                                    <tr>
                                        <td width="30%">
                                            <div class="common_checkbox_box clearfix ">
                                            <label for="weekday" class="margin_b_10 margin_t_15 hand display_block">
                                                <input type="checkbox"  id="workDay" name="time_limit"
                                                class="radio_com" checked="checked">${ctp:i18n('neigou.sso.manage.workday')}</label>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="common_selectbox_wrap margin_l_20" style="float: left;">
                                                    <select style="width:70px;" id="start_h" class="hourOption" >
                                                    </select>
                                            </div>
                                            <div class="common_selectbox_wrap" style="float: left;">
                                                    <select style="width:70px;" id="start_m" class="mOption">
                                                        <option value="00">00${ctp:i18n('neigou.sso.manage.minute')}</option>
                                                        <option value="30">30${ctp:i18n('neigou.sso.manage.minute')}</option>
                                                    </select>
                                            </div>
                                            <div style="float: left;" class="margin_l_10 margin_r_10">${ctp:i18n('neigou.sso.manage.to')}</div>
                                            <div class="common_selectbox_wrap" style="float: left;">
                                                    <select style="width:70px;" id="to_h" class="hourOption">
                                                    </select>
                                            </div>
                                            <div class="common_selectbox_wrap" style="float: left;">
                                                    <select style="width:70px;" id="to_m" class="mOption">
                                                        <option value="00">00${ctp:i18n('neigou.sso.manage.minute')}</option>
                                                        <option value="30">30${ctp:i18n('neigou.sso.manage.minute')}</option>
                                                    </select>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="common_checkbox_box clearfix ">
                                            <label for="weekend" class="margin_b_10 margin_t_15 hand display_block">
                                                <input type="checkbox" id="restDay" name="time_limit"
                                                class="radio_com">${ctp:i18n('neigou.sso.manage.restday')}</label> 
                                            </div>
                                        </td>
                                        <td>
                                            <div class="common_radio_box clearfix">
                                                <label for="anytime" class="margin_r_30 hand"><input type="radio" value="0" id="anytime" name="weekend_limit" class="radio_com" checked="checked">${ctp:i18n('neigou.sso.manage.anytime')}</label>
                                                <label for="bucketed" class="margin_r_30 hand"><input type="radio" value="1" id="bucketed" name="weekend_limit" class="radio_com">${ctp:i18n('neigou.sso.manage.bucketed')}</label>     
                                            </div> 
                                        </td>
                                    </tr>
                                    <tr id="tr_bucketed" class="hidden">
                                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red"></font></label></th>
                                        <td>
                                            <div class="common_selectbox_wrap margin_l_20" style="float: left;">
                                                    <select style="width:70px;" id="start_h_2" class="hourOption">
                                                    </select>
                                            </div>
                                            <div class="common_selectbox_wrap" style="float: left;">
                                                    <select style="width:70px;" id="start_m_2" class="mOption">
                                                        <option value="00">00${ctp:i18n('neigou.sso.manage.minute')}</option>
                                                        <option value="30">30${ctp:i18n('neigou.sso.manage.minute')}</option>
                                                    </select>
                                            </div>
                                            <div style="float: left;" class="margin_l_10 margin_r_10">${ctp:i18n('neigou.sso.manage.to') }</div>
                                            <div class="common_selectbox_wrap" style="float: left;">
                                                    <select style="width:70px;" id="to_h_2" class="hourOption">
                                                    </select>
                                            </div>
                                            <div class="common_selectbox_wrap" style="float: left;">
                                                    <select style="width:70px;" id="to_m_2" class="mOption">
                                                        <option value="00">00${ctp:i18n('neigou.sso.manage.minute')}</option>
                                                        <option value="30">30${ctp:i18n('neigou.sso.manage.minute')}</option>
                                                    </select>
                                            </div>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </td>
                    </tr>
                 
                  
                    <tr>
                        <td align="left" colspan="6"></td>
                    </tr>
                </tbody>
            </table>
        </div>
        </div>
    </form>
</body>
</html>