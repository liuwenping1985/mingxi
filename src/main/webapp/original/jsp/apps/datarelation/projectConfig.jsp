<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<script id="project_HTMLTemp" type="text/html">
<div class="form_area rightmeau">
    <div class="list_item  customSubmit customValidate">
        <div class="model_name">
            <label class="label_th left">${ctp:i18n('ctp.dr.data.source.title.js')}:</label> 
            <div class="searchitem-project common_txtbox_wrap">
        <input type="text" id="subject" class="validate subject left" onkeyup="subjectChange(this)" validate="type:'string',func:checkNull,name:'',errorMsg:'${ctp:i18n('ctp.dr.name.not.empty.js')}'" placeholder="${ctp:i18n('ctp.dr.input.title.js')}">
        <input id="dataType" type="hidden" value="6">
        </div>
        </div>
        <div class="selected_data">
            <label class="label_th left">${ctp:i18n('ctp.dr.selected.data.title.js')}:</label> 
            <a href="javascript:chooseProject();" class="common_button common_button_emphasize left">${ctp:i18n('ctp.dr.select.data.js')}</a>
      <label for="hasProject" class="margin_l_10 display_none hand"> 
        <input type="checkbox" value="1" id="hasProject" class="radio_com">关联项目
      </label>
        </div>
    
      <div id="projectDiv" class="datalist">
    </div>
    </div>
    <div class="list_item  customSubmit customValidate">
        <div class="list_title">
            <span class="title_l">${ctp:i18n('ctp.dr.show.set.js')}</span>
        </div>
        <div class="show_count">
         
          <table border="0" cellspacing="0" cellpadding="0">
           <tr>
            <td><label class="label_th float_margin">${ctp:i18n('ctp.dr.show.size.js')}:</label> </td>
            <td>
            <div class="common_txtbox_wrap">
               <input id="pageSize" type="text" maxlength="2" class="validate font_size12" validate="type:'number',name:'',minValue:1,maxValue:20,notNull:true,regExp:'^[0-9]{0,9}$',errorMsg:'${ctp:i18n('ctp.dr.page.size.title.js')}'">
      </div>
            </td>
            <td><label class="label_ti float_margin">${ctp:i18n('ctp.dr.size.js')}</label></td>
            </tr>
          </table>
        </div>
    </div>
    <!-- 模板 -->
  <div id="projectTemplate" class="display_none">
    <div>
       <p href="javascript:void(0);"></p>
       <span class="itemclose margin_r_5" onclick="delProject(this);"></span>
    </div>
  </div>
</div>
</script>
<div id="project" class="hidden">

</div>