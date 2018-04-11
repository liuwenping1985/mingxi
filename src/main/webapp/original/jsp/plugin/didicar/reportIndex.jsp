<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../common/common.jsp"%>

<style>
    .stadic_head_height{
        height:0px;
    }
    .stadic_body_top_bottom{
        bottom: 37px;
        top: 0px;
    }
    .stadic_footer_height{
        height:37px;
    }
</style>
<script type="text/javascript">
$().ready(function() {
    $("#reportShow").hide();
    //$("#button").hide();
    $("input[name='car_period']").click(function(){
    
       var dialog = $.dialog({
                            url: "${path}/didicarReport.do?method=reportList&entityId="+ $("#entityId").val(),
                            title: "报表分析",
                            width: 800,
                            height: 800,
                            targetWindow:getCtpTop(),
                            buttons: [
                                {
                                    text: "确定",
                                    id: "sure1",
                                    handler: function () {
                                        dialog.close();
                                    }
                                },
                                {
                                    text: "${ctp:i18n('form.query.cancel.label')}",
                                    id: "exit1",
                                    handler: function () {
                                        dialog.close();
                                    }
                                }
                            ]
                        });
    
    });
    // mytable.grid.resizeGridUpDown('middle');
     $("#memberName").click(function() {
       $.selectPeople({
         type: 'selectPeople',
         panels: 'Department,Post,Level,Outworker',
         selectType: 'Member,Department,Post,Level',
         minSize:0,
         maxSize:100,
         showConcurrentMember:false,
         onlyLoginAccount: false,
         returnValueNeedType: true,
         unallowedSelectEmptyGroup: true,
         text : $("#memberName").val(),
         params: {value:$("#entityId").val()},
         callback: function(ret) {
            $("#memberName").val(ret.text);
            $("#entityId").val(ret.value);
         }
   });
   });
    $("#btncancel").click(function() {
        location.reload();
    });
    
    $("#btnok").click(function() {
        if(!($("#accountCfgForm").validate())){ 
          return;
        }
        var id=$("#id").val();
        var nameDup=accountCfg.checkName($("#name").val());
        if(nameDup!=null&&id!=nameDup.id){
            $.alert("${ctp:i18n('voucher.plugin.cfg.accountCfg.nameDuplicate')}");
            return;
        }
        var accountDup=accountCfg.checkAccount($("#type").val(),$("#address").val(),$("#code").val());
        if(accountDup!=null&&id!=accountDup.id){
            $.alert("${ctp:i18n('voucher.plugin.cfg.accountCfg.typeCodeDuplicate')}");
            return;
        }
        var driver=$("#dbType").val();      
        var url=$("#dbUrl").val();
        if(checkDBType(driver,url)){
          return;
        }
        var DbOK = checkDBInfo();
        if("1"!=DbOK){
            $.error("${ctp:i18n('voucher.plugin.cfg.accountCfg.dbcheck')}");
            return;
          }
        if($("#isDefault")[0].checked==true){           
          confirmSave(id);
        }else{
          saveAccountForm();
        }
                                                                                       
    });
        
});
</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'F21_didi_report'"></div>
    <div  class="layout_north" layout="height:50,sprit:false,border:false" style="margin: 10px;padding: 10px;">        
                              输入统计条件
    </div>
    <div class="layout_center over_hidden  font-size-12" layout="border:false" id="center">
        <form name="addForm" id="addForm" method="post" target="">
        <div class="one_row" style="margin: 30px; width:60%;">
            <table border="0" cellspacing="0" cellpadding="0" >
                    <tr>
                        <td nowrap="nowrap"><span class="color_red">*</span>用车人:</td>
                        <td width="100%" colspan="5">
                            <div class="common_txtbox  clearfix">
                                <textarea rows="5" id="memberName"   class="w100b validate" readonly="readonly" validate="notNull:true" name="${ctp:i18n('didicar.plugin.information.authmember')}"></textarea>
                                <input type="hidden" id="entityId" name="entityId" value="-1">
                            </div>
                        </td>
                    </tr>
                      <tr>
                        <td nowrap="nowrap"><span class="color_red">*</span>用车时间:</td>
                             <td   colspan="2">
                        <input type="text" id="beginDate" style="width:40%;" readonly="readonly" class="word_break_all" name="beginDate" onclick="whenstart('${path}',null,event.clientX,event.clientY+100);"> 
                                —
                       <input type="text" id="endDate" style="width:40%;"  readonly="readonly" class="word_break_all" name="endDate" onclick="whenstart('${path}',null,event.clientX,event.clientY+100);">
                           
                        </td>
                        <td width="45%" nowrap="nowrap">
                            <div class="common_radio_box clearfix">
                                <label for="nolimit" class="margin_r_30 hand"><input type="checkbox" value="0" id="no_quota" name="quota" class="radio_com" >年</label>
                                <label for="monlimit" class="margin_r_30 hand"><input type="checkbox" value="1" id="mon_quota" name="quota" class="radio_com">季度</label>    
                                <label for="monlimit" class="margin_r_30 hand"><input type="checkbox" value="1" id="mon_quota" name="quota" class="radio_com">月</label>  
                            </div> 
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><span class="color_red">*</span>${ctp:i18n('didicar.plugin.information.mode') }:</th>
                        <td width="100%" colspan="5">
                        <!--最后一个不用margin_r_10-->
                                <div class="common_checkbox_box clearfix ">
                                    <label for="mode1" class="margin_r_30 hand"> <input
                                        type="checkbox" value="201" id="mode1" name="car_mode"
                                        class="radio_com" >${ctp:i18n('didicar.plugin.information.mode.201')}
                                    </label> <label for="mode2" class="margin_r_30 hand"> <input
                                        type="checkbox" value="301" id="mode2" name="car_mode"
                                        class="radio_com" >${ctp:i18n('didicar.plugin.information.mode.301')}
                                    </label> 
                                </div>
                            </td>
                    </tr>
                    <tr class="car_models">
                        <th nowrap="nowrap"><span class="color_red">*</span>${ctp:i18n('didicar.plugin.information.models') }:</th>
                        <td width="100%" colspan="5">
                                <div class="common_checkbox_box clearfix ">
                                    <label for="mode1" class="margin_r_20 hand"> <input
                                        type="checkbox" value="500" id="models1" name="models"
                                        class="radio_com" >${ctp:i18n('didicar.plugin.information.models.500') }
                                    </label> <label for="models2" class="margin_r_20 hand"> <input
                                        type="checkbox" value="100" id="models2" name="models"
                                        class="radio_com" >${ctp:i18n('didicar.plugin.information.models.100') }
                                    </label>  <label for="models3" class="margin_r_20 hand"> <input
                                        type="checkbox" value="400" id="models3" name="models"
                                        class="radio_com" >${ctp:i18n('didicar.plugin.information.models.400') }
                                    </label>  <label for="models4" class="margin_r_30 hand"> <input
                                        type="checkbox" value="200" id="models4" name="models"
                                        class="radio_com" >${ctp:i18n('didicar.plugin.information.models.200') }
                                    </label>
                                </div>
                            </td>
                    </tr>
                  </table>
                  <br>
                  <br>
                  <br>
                  <br>
                   <table border="0" cellspacing="0" cellpadding="0" >
                    <tr>
                        <th nowrap="nowrap"><span class="color_red">*</span>统计项:</th>
                        <td width="100%" colspan="5">
                            <div class="common_radio_box clearfix">
                                <label for="period1" class="margin_r_30 hand"><input type="radio" value="0" id="period1" name="car_period" class="radio_com">用车金额</label>
                                <label for="period2" class="margin_r_30 hand"><input type="radio" value="1" id="period2" name="car_period" class="radio_com">用车时段</label>     
                             <label for="period2" class="margin_r_30 hand"><input type="radio" value="1" id="period2" name="car_period" class="radio_com">金额区间</label>  
                            </div> 
                        </td>
                    </tr>
                 </table>
           
        </div>
    
        </form>
        <table id="mytable" class="flexme3" border="0" cellspacing="0" cellpadding="0" ></table>
        <div id="grid_detail" class="relative" style="overflow-y:hidden">
         
          
                <div class="stadic_layout_body stadic_body_top_bottom">                   
                    <div id="reportShow" class="form_area" style="overflow-y:hidden">
                        <%@include file="reportShow.jsp"%></div>
                    </div>
                <div class="stadic_layout_footer stadic_footer_height">
                    <div id="button" align="center" class="page_color button_container">
                        <div class="common_checkbox_box clearfix  stadic_footer_height padding_t_5 border_t">                           
                            <a id="btnok" href="javascript:void(0)" class="common_button common_button_emphasize margin_r_10">${ctp:i18n('common.button.ok.label')}</a>
                            <a id="btncancel" href="javascript:void(0)" class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>