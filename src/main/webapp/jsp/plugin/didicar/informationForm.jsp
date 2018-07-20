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
                    <input type="hidden" name="id" id="id" value="" />
                     <input type="hidden" name="carRole" id="carRole" value="" />
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('didicar.plugin.information.authmember')}:</label></th>
                        <td width="100%" colspan="5">
                            <div class="common_txtbox  clearfix">
                                <textarea rows="5" id="memberName"   class="w100b validate" readonly="readonly" validate="notNull:true" name="${ctp:i18n('didicar.plugin.information.authmember')}"></textarea>
                                <input type="hidden" id="authorize" name="authorize" value="-1">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('didicar.plugin.information.limit')}:</label></th>
                        <td width="45%" nowrap="nowrap">
                            <div class="common_radio_box clearfix">
                                <label for="nolimit" class="margin_r_30 hand"><input type="radio" value="0" id="no_quota" name="quota" class="radio_com" checked="checked">${ctp:i18n('didicar.plugin.information.period.nolimit')}</label>
                                <label for="monlimit" class="hand"><input type="radio" value="1" id="mon_quota" name="quota" class="radio_com">${ctp:i18n('didicar.plugin.information.limit.monlimit') }</label>     
                            </div> 
                        </td>
                        <td width="15%">
                            <div class="common_txtbox_wrap" style="width:80px;">
                            <input type="text" id="limitmoney" style="width:100%;height:18px" disabled="disabled" class="validate word_break_all" name="${ctp:i18n('didicar.plugin.information.limit.monlimit') }"
                                    validate="notNull:true,min:1,max:1000000,isInteger:true">
                            </div>
                        </td>
                        <td align="left" width="10%" >&nbsp;${ctp:i18n('didicar.plugin.account.yuan')}</td>
                        
                        <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('didicar.plugin.information.monthTotal')}:</label></th>
                        <td width="30%" align="left">
                            <div class="common_txtbox_wrap" style="width: 80px; float: left; border: 0;">
                                <input type="text" id="monthTotal" style="width:100%;" readonly="readonly" class="word_break_all" name="${ctp:i18n('didicar.plugin.information.monthTotal')}">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('didicar.plugin.information.period')}:</label></th>
                        <td width="100%" colspan="5">
                            <div class="common_radio_box clearfix">
                                <label for="period1" class="margin_r_30 hand"><input type="radio" value="0" id="period1" name="car_period" class="radio_com" checked="checked">${ctp:i18n('didicar.plugin.information.period.nolimit')}</label>
                                <label for="period2" class="margin_r_30 hand"><input type="radio" value="1" id="period2" name="car_period" class="radio_com">${ctp:i18n('didicar.plugin.information.period.limit')}</label>     
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
                                                <input type="checkbox" value="0" id="weekday" name="time_limit"
                                                class="radio_com" checked="checked">${ctp:i18n('didicar.plugin.information.weekday')}</label>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="common_selectbox_wrap margin_l_20" style="float: left;">
                                                    <select style="width:70px;" id="start_h" class="hourOption" >
                                                    </select>
                                            </div>
                                            <div class="common_selectbox_wrap" style="float: left;">
                                                    <select style="width:70px;" id="start_m" class="mOption">
                                                        <option value="00">00${ctp:i18n('didicar.plugin.information.period.limi.minute')}</option>
                                                        <option value="30">30${ctp:i18n('didicar.plugin.information.period.limi.minute')}</option>
                                                    </select>
                                            </div>
                                            <div style="float: left;" class="margin_l_10 margin_r_10">${ctp:i18n('didicar.plugin.information.period.limi.to')}</div>
                                            <div class="common_selectbox_wrap" style="float: left;">
                                                    <select style="width:70px;" id="to_h" class="hourOption">
                                                    </select>
                                            </div>
                                            <div class="common_selectbox_wrap" style="float: left;">
                                                    <select style="width:70px;" id="to_m" class="mOption">
                                                        <option value="00">00${ctp:i18n('didicar.plugin.information.period.limi.minute')}</option>
                                                        <option value="30">30${ctp:i18n('didicar.plugin.information.period.limi.minute')}</option>
                                                    </select>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="common_checkbox_box clearfix ">
                                            <label for="weekend" class="margin_b_10 margin_t_15 hand display_block">
                                                <input type="checkbox" value="0" id="weekend" name="time_limit"
                                                class="radio_com">${ctp:i18n('didicar.plugin.information.weekend')}</label> 
                                            </div>
                                        </td>
                                        <td>
                                            <div class="common_radio_box clearfix">
                                                <label for="anytime" class="margin_r_30 hand"><input type="radio" value="0" id="anytime" name="weekend_limit" class="radio_com" checked="checked">${ctp:i18n('didicar.plugin.information.weekend.anytime')}</label>
                                                <label for="bucketed" class="margin_r_30 hand"><input type="radio" value="1" id="bucketed" name="weekend_limit" class="radio_com">${ctp:i18n('didicar.plugin.information.weekend.bucketed')}</label>     
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
                                                        <option value="00">00${ctp:i18n('didicar.plugin.information.period.limi.minute')}</option>
                                                        <option value="30">30${ctp:i18n('didicar.plugin.information.period.limi.minute')}</option>
                                                    </select>
                                            </div>
                                            <div style="float: left;" class="margin_l_10 margin_r_10">${ctp:i18n('didicar.plugin.information.period.limi.to') }</div>
                                            <div class="common_selectbox_wrap" style="float: left;">
                                                    <select style="width:70px;" id="to_h_2" class="hourOption">
                                                    </select>
                                            </div>
                                            <div class="common_selectbox_wrap" style="float: left;">
                                                    <select style="width:70px;" id="to_m_2" class="mOption">
                                                        <option value="00">00${ctp:i18n('didicar.plugin.information.period.limi.minute')}</option>
                                                        <option value="30">30${ctp:i18n('didicar.plugin.information.period.limi.minute')}</option>
                                                    </select>
                                            </div>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('didicar.plugin.information.mode') }:</label></th>
                        <td width="100%" colspan="5">
                        <!--最后一个不用margin_r_10-->
                                <div class="common_checkbox_box clearfix ">
                                    <label for="mode1" class="margin_r_30 hand"> <input
                                        type="checkbox" value="201" id="mode1" name="car_mode"
                                        class="radio_com" checked="checked">${ctp:i18n('didicar.plugin.information.mode.201')}
                                    </label> <label for="mode2" class="margin_r_30 hand"> <input
                                        type="checkbox" value="301" id="mode2" name="car_mode"
                                        class="radio_com" checked="checked">${ctp:i18n('didicar.plugin.information.mode.301')}
                                    </label> 
                                </div>
                            </td>
                    </tr>
                    <tr class="car_models">
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('didicar.plugin.information.models') }:</th>
                        <td width="100%" colspan="5">
                                <div class="common_checkbox_box clearfix ">
                                    <label for="mode1" class="margin_r_20 hand"> <input
                                        type="checkbox" value="500" id="models1" name="models"
                                        class="radio_com" checked="checked">${ctp:i18n('didicar.plugin.information.models.500') }
                                    </label> <label for="models2" class="margin_r_20 hand"> <input
                                        type="checkbox" value="100" id="models2" name="models"
                                        class="radio_com" checked="checked">${ctp:i18n('didicar.plugin.information.models.100') }
                                    </label>  <label for="models3" class="margin_r_20 hand"> <input
                                        type="checkbox" value="400" id="models3" name="models"
                                        class="radio_com" checked="checked">${ctp:i18n('didicar.plugin.information.models.400') }
                                    </label>  <label for="models4" class="margin_r_30 hand"> <input
                                        type="checkbox" value="200" id="models4" name="models"
                                        class="radio_com" checked="checked">${ctp:i18n('didicar.plugin.information.models.200') }
                                    </label>
                                </div>
                            </td>
                    </tr>

                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>用车备注:</label></th>
                        <td width="100%" colspan="5">
                            <div class="common_radio_box clearfix">
                                <label for="needMemo1" class="margin_r_30 hand"><input type="radio" value="1" id="needMemo1" name="needMemo" class="radio_com">必填</label>
                                <label for="needMemo2" class="margin_r_30 hand"><input type="radio" value="0" id="needMemo2" name="needMemo" class="radio_com">选填</label>     
                            </div> 
                        </td>
                    </tr>
                    <tr class="car_models">
                        <th nowrap="nowrap"><label class="margin_r_10"></th>
                        <td width="100%" colspan="3">
                            <font color="#008000">${ctp:i18n('didicar.plugin.information.message.label')}</font>
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