<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<script id="templateDeal_HTMLTemp" type="text/html">
<div class="list_item">
    <div class="model_name customSubmit customValidate form_area">
        <label class="label_th left">${ctp:i18n('ctp.dr.data.source.title.js')}:</label> 
    <div class="common_txtbox_wrap">
          <input type="text" id="subject" onkeyup="subjectChange(this)" maxlength="85" class="validate subject left" validate="type:'string',func:checkNull,name:'',errorMsg:'${ctp:i18n('ctp.dr.name.not.empty.js')}'" placeholder="${ctp:i18n('ctp.dr.input.title.js')}">
    </div>
        <input id="dataType" type="hidden" value="7">
    <input id="selectTemplate" type="hidden">
    </div>
    <div class="selected_data customSubmit">
        <label class="label_th left">${ctp:i18n('ctp.dr.selected.data.title.js')}:</label> 
        <a href="javascript:chooseTemplate();" class="common_button common_button_emphasize left">${ctp:i18n('ctp.dr.select.data.js')}</a>
    <label for="currentTemplate" class="margin_l_10 hand"> 
      <input type="checkbox" value="1" id="currentTemplate" class="radio_com">${ctp:i18n('datarelation.select.template.js')}
    </label>
    </div>
    <div id="templateDealDiv" class="datalist">
    </div>
</div>
<div class="list_item customSubmit">
    <div class="list_title">
        <span class="title_l">${ctp:i18n('ctp.dr.content.source.js')}</span> <span class="title_r">${ctp:i18n('ctp.dr.node.desc.js')}</span>
    </div>
    <div class="common_checkbox_box clearfix ">
        <label for="sendChecked2" class="margin_t_5 hand display_block">
            <input type="checkbox" value="1" id="sendChecked2" name="option" class="radio_com">${ctp:i18n('ctp.dr.node.desc2.js')}
        </label> 
    <label for="deptMemberChecked" class="margin_t_5 hand display_block">
            <input type="checkbox" value="1" id="deptMemberChecked" name="option" class="radio_com">${ctp:i18n('ctp.dr.node.desc3.js')}
        </label> 
    <label for="senderDeptMemberChecked" class="margin_t_5 hand display_block">
            <input type="checkbox" value="1" id="senderDeptMemberChecked" name="option" class="radio_com">${ctp:i18n('ctp.dr.node.desc4.js')}
        </label> 
    <label for="allSend" class="margin_t_5 hand display_block">
            <input type="checkbox" value="1" id="allSend" name="option" class="radio_com">${ctp:i18n('ctp.dr.node.desc5.js')}
        </label>
    </div>
</div>
<div class="list_item customSubmit">
    <div class="list_title">
        <span class="title_l">${ctp:i18n('ctp.dr.march.rang.js')}</span>
    </div>
    <div class="common_radio_box clearfix">
        <div class="select_model">
            <label for="myRadio" class="margin_t_5 hand display_block left" onclick="changeTemplate('my')">
                <input type="radio" value="1" name="myNode" id="myRadio" class="radio_com">${ctp:i18n('ctp.dr.selected.template.js')}
            </label>
            <div id="myDiv" class="common_checkbox_box clearfix left">
                <span class="select_red">${ctp:i18n('ctp.dr.me.done.js')}</span> 
        <label for="myPending" class="margin_r_10 hand"> 
          <input type="checkbox" value="1" id="myPending" name="myPending" class="radio_com">${ctp:i18n('collaboration.coltype.Pending.label')}
                </label> 
       <label for="myDone" class="margin_r_10 hand"> 
        <input type="checkbox" value="1" id="myDone" name="myDone" class="radio_com">${ctp:i18n('collaboration.coltype.Done.label')}
             </label>
            </div>
        </div>
        <div class="select_model">
            <label for="nodeRadio" class="margin_t_5 hand display_block left" onclick="changeTemplate('other')">
                <input type="radio" value="1" id="nodeRadio" name="myNode" class="radio_com">${ctp:i18n('ctp.dr.selected.template.js')}
            </label>
            <div id="otherDiv" class="common_checkbox_box clearfix left">
                <span class="select_red">${ctp:i18n('ctp.dr.node.desc6.js')}</span> 
        <label for="nodePending" class="margin_r_10 hand"> 
          <input type="checkbox" value="1" id="nodePending" name="nodePending" class="radio_com">${ctp:i18n('collaboration.coltype.Pending.label')}
                </label> 
        <label for="nodeDone" class="margin_r_10 hand"> 
          <input type="checkbox" value="1" id="nodeDone" name="nodeDone" class="radio_com">${ctp:i18n('collaboration.coltype.Done.label')} 
                </label>
            </div>
        </div>
    </div>
</div>
<div class="list_item customValidate customSubmit form_area">
    <div class="list_title">
        <span class="title_l">${ctp:i18n('ctp.dr.show.set.js')}</span>
    </div>
    <div class="show_count">
       <table border="0" cellspacing="0" cellpadding="0">
           <tr>
            <td><label class="label_th float_margin">${ctp:i18n('ctp.dr.show.size.js')}:</label></td>
            <td>
  <div class="common_txtbox_wrap">
        <input id="pageSize" type="text" class="validate" validate="type:'number',name:'',minValue:1,maxValue:20,notNull:true,regExp:'^[0-9]{0,9}$',errorMsg:'${ctp:i18n('ctp.dr.page.size.title.js')}'">
     </div>
          </td>
            <td>
<label class="label_ti float_margin">${ctp:i18n('ctp.dr.size.js')}</label>
        </td>
            </tr>
          </table>
    </div>
</div>

</script>
<div id="templateDeal" class="hidden rightmeau tpldata">
</div>
<!-- 模板 -->
<div id="dealTemplate" class="display_none">
<div>
   <p></p>
   <span class="itemclose" onclick="delTemplate(this);"></span>
</div>
</div>