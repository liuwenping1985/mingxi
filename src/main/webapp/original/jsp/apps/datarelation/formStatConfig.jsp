<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<script id="formStat_HTMLTemp" type="text/html">
<div class="list_item">
  <div class="model_name">
    <label class="label_th left">${ctp:i18n('ctp.dr.data.source.title.js')}:</label> 
    <div class="form_area customValidate">
      <div class="common_txtbox_wrap customSubmit">
        <input id="subject" type="text" placeholder="${ctp:i18n('ctp.dr.input.title.js')}" class="validate subject left" onkeyup="subjectChange(this)" validate="type:'string',func:checkNull,name:'',errorMsg:'${ctp:i18n('ctp.dr.name.not.empty.js')}'" maxlength="85">
        <input id="dataType" type="hidden" value="2">
      </div>
    </div>
  </div>
  <div class="selected_data">
    <label class="label_th left">${ctp:i18n('ctp.dr.selected.data.title.js')}:</label> <a href="javascript:void(0)" onclick="openFormSelectWin();" class="common_button common_button_emphasize left">${ctp:i18n('ctp.dr.select.data.js')}</a>
  </div>
  <div id="formStatDiv" class="datalist">
    <div class="margin_r_5 hidden" style="display: none;">
      <span id="templeteName" class="color margin_l_5" href="javascript:void(0);"></span>
      <span class="itemclose" onclick="delSelectForm(this);"></span>
    </div>
  </div>
</div>

<div class="list_item">
  <div class="list_title">
    <span class="title_l">${ctp:i18n('ctp.dr.stat.setting.js')}</span>
  </div> 
  <div class="count">
     <table width="100%" id="formStatCndTab" style="table-layout: fixed; font-size: 14px;" isgrid="true" widthattr="177">
        <tbody>
          <tr>
            <td style="width: 40px;"></td>
            <td style="width: 20%;">${ctp:i18n('ctp.dr.alter.cond.js')}</td>
            <td style="width: 65px;"></td>
            <td class="fieldInputValue" style="width: 127px;">${ctp:i18n('ctp.dr.current.form.data.js')}</td>
            <td style="width: 40px;"></td>
            <td style="width: 50px;"></td>
            <td style="width: 50px;"></td>
          </tr>
        </tbody>
     </table>
  </div>
</div>

<div class="list_item form_area customSubmit">
  <div class="list_title">
    <span class="title_l">${ctp:i18n('ctp.dr.show.set.js')}</span>
  </div>
<div class="" style="border-bottom: 1px solid rgb(238,238,240);">
  <div class="selected_data">
    <label style="width:80px;" class="label_th left">${ctp:i18n('datarelation.select.data.js')}</label> 
    <a id="showColSetBtn" href="javascript:void(0)" onclick="openFormShowColSetWin();" class="common_button common_button_emphasize left common_button_disable">${ctp:i18n('ctp.dr.select.data.js')}</a>
  </div>
  
  <div id="formStatShowCol" class="datalist">
  </div>
</div>

  <div class="common_radio_box clearfix">
    <label for="showTable" class="margin_t_5 hand display_block showlists customSubmit" onclick="showTableBtnChange();">
      <input type="checkbox" value="1" id="showTable" class="radio_com">${ctp:i18n('datarelation.label.showTable')}
    </label>
  </div>
  
  <div class="show_count customValidate customSubmit">
    <table border="0" cellspacing="0" cellpadding="0">
           <tr>
            <td><label class="label_th margin_l_10 float_margin">${ctp:i18n('ctp.dr.show.size.js')}:</label> </td>
            <td>
            <div class="common_txtbox_wrap">
      			<input type="text" id="pageSize" maxlength="2" class="validate font_size12" validate="type:'number',minValue:1,maxValue:20,name:'',notNull:true,regExp:'^[0-9]{0,9}$',errorMsg:'${ctp:i18n('ctp.dr.page.size.title.js')}'">
    		</div>
            </td>
            <td><label class="label_ti float_margin">${ctp:i18n('ctp.dr.size.js')}</label></td>
            </tr>
          </table>
  </div>
  
  <div class="common_radio_box clearfix list_title">
    <label for="vertical2" class="margin_t_5 margin_l_10 hand display_block showlists"> 
      <input type="checkbox" value="1" id="vertical2" name="option" class="radio_com ">${ctp:i18n('ctp.dr.data.other.show.js')}
    </label>
  </div>
</div>
<!-- 模板 -->
<div id="chartDiv" class="right-item display_none" >
  <div class="common_radio_box clearfix">
    <label for="showChart" class="margin_t_5 hand showlists customSubmit" onclick="showChartBtnChange();"> 
    <input type="checkbox" value="1" id="showChart" class="radio_com">${ctp:i18n('datarelation.label.showChart')}</label>
  </div>
  <table cellspacing="10" cellpadding="0">
    <tr>
      <th nowrap="nowrap" align="right" valign="top">
        <label for="text" class="label_th left">${ctp:i18n('ctp.dr.select.chart.js')}:</label>
      </th>
      <td width="100%" valign="top">
        <div id="chartCnd">
          <table  id="chartTab" border="0" cellspacing="5" cellpadding="0" width="90%">
          </table>
        </div>
      </td>
    </tr>
  </table>
</div> 

<div id="chartAreaTemp" class="display_none">
<table  border="0" cellspacing="5" cellpadding="0" width="90%">
   <tr>
      <td width="40%" nowrap="nowrap" align="right">
       <div class="common_selectbox_wrap">
         <select onchange="hidePieCharts(this)" id="imgId">
          <option value="-1" selected></option>
        </select>
       </div>
      </td>
      <td width="40%" valign="middle">
        <div class="common_selectbox_wrap">
          <select id="type">
          </select>
        </div>
      </td>
      <td valign="middle">
          <span class="delButton repeater_reduce_16 ico16 revoked_process_16 margin_l_5" id="delButton" onclick="removeChartTr(this,'formStat');"></span>
          <span class="addButton repeater_plus_16 ico16" id="addButton" onclick="insertChartTr(this,'formStat');"></span>
      </td>
    </tr>
</table>
</div>
</script>
<%-- 图表下拉选项HTML --%>
<script type="text/html" id="chart_type_tpl0">
<option value="1" selected>${ctp:i18n('ctp.dr.chart2.js')}</option>
<option value="3">${ctp:i18n('ctp.dr.chart4.js')}</option>
<option value="11">${ctp:i18n('ctp.dr.chart3.js')}</option><%-- 雷达图 --%>
</script>
<script type="text/html" id="chart_type_tpl1">
<option value="1">${ctp:i18n('ctp.dr.chart2.js')}</option>
<option value="7" selected>${ctp:i18n('ctp.dr.chart1.js')}</option>
<option value="3">${ctp:i18n('ctp.dr.chart4.js')}</option>
<option value="11">${ctp:i18n('ctp.dr.chart3.js')}</option><%-- 雷达图 --%>
</script>
<div id="formStat" class="hidden">
</div>