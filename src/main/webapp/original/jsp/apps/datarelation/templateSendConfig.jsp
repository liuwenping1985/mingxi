<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<script id="templateSend_HTMLTemp" type="text/html">
<div class="list_item">
    <div class="model_name form_area customSubmit customValidate">
      <label class="label_th left">${ctp:i18n('ctp.dr.data.source.title.js')}:</label> 
      <div class="common_txtbox_wrap">
          <input type="text" id="subject" onkeyup="subjectChange(this)" maxlength="85" class="validate subject left" validate="type:'string',func:checkNull,name:'',errorMsg:'${ctp:i18n('ctp.dr.name.not.empty.js')}'" placeholder="${ctp:i18n('ctp.dr.input.title.js')}" >
      </div>
      <input id="dataType" type="hidden" value="0">
      <input id="selectTemplate" type="hidden">
    </div>
  <div class="selected_data customSubmit">
      <label class="label_th left">${ctp:i18n('ctp.dr.selected.data.title.js')}:</label> 
      <a href="javascript:chooseTemplate('templateSend');" class="common_button common_button_emphasize left">${ctp:i18n('ctp.dr.select.data.js')}</a>
    <label for="currentTemplate" class="margin_l_10 hand"> 
      <input type="checkbox" value="1" id="currentTemplate" class="radio_com">${ctp:i18n('datarelation.select.template.js')}
    </label>
    </div>
    <div id="templateDealDiv" class="datalist">
    </div> 
  </div>      
  <div class="list_item form_area customSubmit customValidate">
    <div class="list_title">
          <span class="title_r">${ctp:i18n('ctp.dr.node.desc.js')}</span>
      </div>
      
      <div class="common_checkbox_box clearfix left ">
      <label for="mySend" class="margin_r_10 hand"> 
        <input type="checkbox" value="1" disabled="disabled" id="mySend" name="mySend" class="radio_com">${ctp:i18n('ctp.dr.my.sended.js')}
      </label>
        <label for="sendChecked" class="margin_r_10 hand"> 
          <input type="checkbox" value="1" id="sendChecked" name="sendChecked" class="radio_com">${ctp:i18n('ctp.dr.done.js')}
        </label> 
        <label for="waitSendChecked" class="margin_r_10 hand"> 
          <input type="checkbox" value="1" id="waitSendChecked" name="waitSendChecked" class="radio_com">${ctp:i18n('ctp.dr.sended.js')}
        </label>
      </div>
    <br>      
      <div class="show_count">

         <table border="0" cellspacing="0" cellpadding="0">
           <tr>
            <td><label class="label_th float_margin">${ctp:i18n('ctp.dr.show.size.js')}:</label> </td>
            <td>
            <div class="common_txtbox_wrap">
            <input id="pageSize" type="text" maxlength="2" class="validate" validate="type:'number',name:'',minValue:1,maxValue:20,notNull:true,regExp:'^[0-9]{0,9}$',errorMsg:'${ctp:i18n('ctp.dr.page.size.title.js')}'">
      </div>
            </td>
            <td><label class="label_ti float_margin">${ctp:i18n('ctp.dr.size.js')}</label></td>
            </tr>
          </table>
     </div>
  </div>
</script>
<div id="templateSend" class="hidden">
</div>