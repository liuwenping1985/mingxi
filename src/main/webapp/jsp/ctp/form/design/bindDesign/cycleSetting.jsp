<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
    <style>
        #setTime span{
            line-height: 26px;
        }
    </style>
</head>
<body scroll="no">
    <table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%" class="font_size12 margin_t_10">
        <tr>
            <td>
                <table cellspacing="2" cellpadding="2" width="95%" border="0">
                    <tr height="20">
                        <td colspan="5">&nbsp;</td>
                    </tr>
                    <tr height="40">
                        <td width="20" class="padding_t_10">&nbsp;</td>
                        <td align="right" width="90" class="padding_t_10"><font color="red">*</font>${ctp:i18n('form.system.start.member.field.label')}：</td>
                        <td width="410" class="padding_t_10">
                            <div class="common_txtbox_wrap">
                                <input type="text" id="sender_txt" name="sender_txt" value="" readonly="readonly" />
                                <input type="hidden" id="sender" name="sender" value="" />
                            </div>
                        </td>
                        <td width="50" class="padding_t_10">
                            <a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="senderBtn">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
                        </td>
                        <td width="20" class="padding_t_10">&nbsp;</td>
                    </tr>
                    <tr height="40">
                        <td class="padding_t_10">&nbsp;</td>
                        <td align="right" class="padding_t_10">${ctp:i18n('form.bind.set.autosend.time.label')}：</td>
                        <td class="padding_t_10" colspan="2">
                            <span class="margin_r_10 left">${ctp:i18n('form.bind.set.autosend.time.start.label')}</span>
                            <div class="common_txtbox_wrap left">
                                <input id="startDate" name="startDate" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d'" readonly="readonly" style="width: 180px;" />
                            </div>
                            <span class="margin_l_10 margin_r_10 left">${ctp:i18n('form.bind.set.autosend.time.end.label')}</span>
                            <div class="common_txtbox_wrap right">
                                <input id="endDate" name="endDate" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d'" readonly="readonly" style="width: 180px;" />
                            </div>
                            <input type="hidden" id="currentDate" name="currentDate" value="${currentDate}" />
                        </td>
                        <td class="padding_t_10">&nbsp;</td>
                    </tr>
                    <tr height="40">
                        <td class="padding_t_10">&nbsp;</td>
                        <td align="right" class="padding_t_10">${ctp:i18n('form.bind.set.autosend.mode.label')}：</td>
                        <td class="padding_t_10" colspan="2" id="setTime">
                            <div class="common_selectbox_wrap left">
                                <select id="type" name="type" class="codecfg" codecfg="codeType:'java',codeId:'com.seeyon.ctp.cycle.enums.CycleEnum'" style="width: 60px;"></select>
                            </div>
                            
                            <span class="hidden year margin_l_10 margin_r_5 left">${ctp:i18n('form.bind.set.autosend.mode.year.per.label')}</span>
                            <div class="hidden year common_selectbox_wrap left">
                                <select id="month" name="month" class="codecfg" codecfg="codeType:'java',codeId:'com.seeyon.ctp.cycle.enums.MonthEnum'" style="width: 50px;"></select>
                            </div>
                            <span class="hidden year margin_l_5 margin_r_5 left">${ctp:i18n('form.bind.set.autosend.mode.which.month.label')}</span>
                            
                            <span class="hidden month margin_l_10 margin_r_5 left">${ctp:i18n('form.bind.set.autosend.mode.month.per.label')}</span>
                            <div class="hidden year month common_selectbox_wrap left">
                                <select id="order" name="order" style="width: 60px;">
                                    <option value="0">${ctp:i18n('form.bind.set.autosend.mode.asc.label')}</option>
                                    <option value="1">${ctp:i18n('form.bind.set.autosend.mode.desc.label')}</option>
                                </select>
                            </div>
                            
                            <span class="hidden year month margin_l_5 margin_r_5 left">${ctp:i18n('form.bind.set.autosend.mode.which.label')}</span>
                            <div class="hidden year month common_selectbox_wrap left">
                                <select id="day" name="day" class="codecfg" codecfg="codeType:'java',codeId:'com.seeyon.ctp.cycle.enums.DayEnum'" style="width: 50px;"></select>
                            </div>
                            <span class="hidden year month margin_l_5 margin_r_5 left">${ctp:i18n('form.bind.set.autosend.mode.which.day.label')}</span>
                            
                            <span class="hidden week margin_l_10 margin_r_5 left">${ctp:i18n('form.bind.set.autosend.mode.week.per.label')}</span>
                            <div class="hidden week common_selectbox_wrap margin_r_5 left">
                                <select id="week" name="week" class="codecfg" codecfg="codeType:'java',codeId:'com.seeyon.ctp.cycle.enums.WeekEnum'" style="width: 70px;"></select>
                            </div>
                            <span class="hidden week margin_l_5 left">&nbsp;</span>
                            
                            <span class="hidden day margin_l_10 margin_r_5 left">${ctp:i18n('form.bind.set.autosend.mode.day.per.label')}</span>
                            <div class="hidden year month week day common_selectbox_wrap left">
                                <select id="hour" name="hour" class="codecfg" codecfg="codeType:'java',codeId:'com.seeyon.ctp.cycle.enums.HourEnum'" style="width: 70px;"></select>
                            </div>
                            <span class="hidden year month week day margin_l_5 left">${ctp:i18n('form.bind.set.autosend.mode.which.hour.label')}</span>
                        </td>
                        <td class="padding_t_10">&nbsp;</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
<script type="text/javascript">
  var transParams = window.dialogArguments;
  $().ready(function() {
    $("#senderBtn").click(function(){
      var senderObj = new Object();
      senderObj.value = $("#sender").val();
      senderObj.text = $("#sender_txt").val();
      $.selectPeople({
        panels : 'Account,Department,Team,Post,Level,Outworker',
        selectType : 'Account,Department,Team,Post,Level,Member',
        hiddenPostOfDepartment : true,
        isNeedCheckLevelScope : false,
        params : senderObj,
        minSize : 1,
        callback : function(ret){
          $("#sender").val(ret.value);
          $("#sender_txt").val(ret.text);
        }
      });
    });
    
    $("#type").change(function(event, changeType){
      if (changeType != "auto") {
        $("#month option").eq(0).attr("selected", "true");
        $("#order option").eq(0).attr("selected", "true");
        $("#day option").eq(0).attr("selected", "true");
        $("#week option").eq(0).attr("selected", "true");
        $("#hour option").eq(0).attr("selected", "true");
      }
      
      $(this).parent().nextAll().hide();
      $("." + $(this).val()).show();
    });
    
    var type = "day";
    if (transParams.cycleSender != "") {
      $("#sender").val(transParams.cycleSender);
      $("#sender_txt").val(transParams.cycleSender_txt);
      $("#startDate").val(transParams.cycleStartDate);
      $("#endDate").val(transParams.cycleEndDate);
      
      type = transParams.cycleType;
      
      $("#month").val(transParams.cycleMonth);
      $("#order").val(transParams.cycleOrder);
      $("#day").val(transParams.cycleDay);
      $("#week").val(transParams.cycleWeek);
      $("#hour").val(transParams.cycleHour);
    }
    
    $("#type").val(type);
    $("#type").trigger("change", ["auto"]);
  });
  
  function OK(){
    var sender = $("#sender").val();
    if (sender == "") {
      $.alert("${ctp:i18n('form.bind.set.autosend.sender.label')}");
      return false;
    }
    
    var startDate = $("#startDate").val();
    var endDate = $("#endDate").val();
    var nowDate = new Date().format("yyyy-MM-dd");
    if (endDate != "") {
        if (compareDate(endDate, nowDate) < 0) {
            $.alert("${ctp:i18n('form.bind.set.autosend.time.error.2.label')}");
            return false;
        }
    }
    if (startDate != "" && endDate != "") {
      if (compareDate(endDate, startDate) < 0) {
        $.alert("${ctp:i18n('form.bind.set.autosend.time.error.1.label')}");
        return false;
      }
    }
    
    var obj={};
    obj.cycleSender = sender;
    obj.cycleSender_txt = $("#sender_txt").val();
    obj.cycleStartDate = startDate;
    obj.cycleEndDate = endDate;
    obj.cycleType = $("#type").val();
    obj.cycleMonth = $("#month").val();
    obj.cycleOrder = $("#order").val();
    obj.cycleDay = $("#day").val();
    obj.cycleWeek = $("#week").val();
    obj.cycleHour = $("#hour").val();
    return obj;
  }
</script>
</html>