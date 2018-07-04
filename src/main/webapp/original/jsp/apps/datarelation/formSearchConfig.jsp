<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<script id="formSearch_HTMLTemp" type="text/html">
  <div class="list_item form_area">
    <div class="model_name customValidate customSubmit">
       <label class="label_th left">${ctp:i18n('ctp.dr.data.source.title.js')}:</label>
       <div class="common_txtbox_wrap">
          <input id="subject" type="text" class="validate subject left" placeholder="${ctp:i18n('ctp.dr.input.title.js')}" onkeyup="subjectChange(this)" validate="type:'string',func:checkNull,name:'',errorMsg:'${ctp:i18n('ctp.dr.name.not.empty.js')}'" maxlength="85">
       </div>
       <input id="dataType" type="hidden" value="1">
    </div>
    <div class="selected_data">
      <label class="label_th left">${ctp:i18n('ctp.dr.selected.data.title.js')}:</label>
      <a href="javascript:void(0)" onclick="openFormSelectWin();" class="common_button common_button_emphasize left">${ctp:i18n('ctp.dr.select.data.js')}</a>
    </div>
    <div class="datalist">
       <div class="margin_r_5 hidden" style="display: none;">
          <span id="templeteName" class="color margin_l_5" href="javascript:void(0);"></span>
          <span class="itemclose" onclick="delSelectForm(this);"></span>
       </div>
    </div>
  </div>
  <div class="list_item">
      <div class="list_title">
        <span class="title_l">${ctp:i18n('ctp.dr.custom.search.cond.js')}</span>
      </div>
      <table width="100%" id="formSearchCndTab" style="table-layout: fixed; font-size:14px;" isgrid="true" widthattr="177">
        <tbody>
          <tr>
            <td style="width: 40px;"></td>
            <td style="width: 60px;">${ctp:i18n('ctp.dr.alter.cond.js')}</td>
            <td style="width: 65px;"></td>
            <td class="fieldInputValue" style="width: 127px;">${ctp:i18n('ctp.dr.current.form.data.js')}</td>
            <td style="width: 40px;"></td>
            <td style="width: 50px;"></td>
            <td style="width: 50px;"></td>
          </tr>
        </tbody>
      </table>
  </div>
  
  <div class="list_item customSubmit form_area">
    <div class="list_title">
      <span class="title_l">${ctp:i18n('ctp.dr.show.set.js')}</span>
    </div>
    <div class="show_count customValidate">
<table border="0" cellspacing="0" cellpadding="0">
           <tr>
            <td><label class="label_th float_margin">${ctp:i18n('ctp.dr.show.size.js')}:</label></td>
            <td>
<div class="common_txtbox_wrap">
        <input id="pageSize" type="text"  maxlength="2" class="validate font_size12" validate="type:'number',name:'',minValue:1,maxValue:20,notNull:true,regExp:'^[0-9]{0,9}$',errorMsg:'${ctp:i18n('ctp.dr.page.size.title.js')}'">
      </div>
            </td>
            <td><label class="label_ti float_margin">${ctp:i18n('ctp.dr.size.js')}</label></td>
            </tr>
          </table>
    </div>
    
    
    <div class="selected_data">
      <label class="label_th left" style="margin-top:8px;">${ctp:i18n('ctp.dr.show.col.js')}:</label>
      <a id="showColSetBtn" style="margin-top:14px;margin-left:1px;" href="javascript:void(0);" onclick="openFormShowColSetWin();" class="common_button common_button_emphasize left common_button_disable">${ctp:i18n('ctp.dr.select.data.js')}</a>
    </div>
    <div id="formSearchShowCol" class="datalist">
      <!-- 选择列 -->
    </div>
    <div class="common_radio_box clearfix">
       <label for="vertical" class="margin_t_5 hand display_block showlists hand">
       <input id="vertical" type="checkbox" value="1" name="vertical" class="radio_com">${ctp:i18n('ctp.dr.data.other.show.js')}</label>
    </div>
  </div>
</script>
<div id="formSearch" class="rightmeau formsearch hidden">
</div>

<!-- 自定义条件条件查询区域模板，统计和查询公用 -->
<div id="condTemplete" class="display_none">
<table border="0" cellspacing="0" cellpadding="0">
  <tr>
      <td style="width: 40px;">
      <div class="common_selectbox_wrap">
        <select class="leftChar" id="leftChar">
          <option value="" selected=""></option>
          <option value="(">(</option>
        </select>
      </div>
    </td>
    <td style="width: 20%;">
      <div class="common_selectbox_wrap">
        <select id="fieldName" title="" onchange="fnFieldChange(this)" class="fieldName validate">
       </select>
      </div>
    </td>
    <td style="width: 65px;">
      <div class="common_selectbox_wrap operationDiv">
        <select id="operation" class="operation w100b operateSelect">
        </select>
      </div>
    </td>
    <td align="left" class="fieldInputValue" style="width: 127px;">
      <div class="common_selectbox_wrap operationDiv">
        <input type="hidden" id="" style="width:98%;">
        <select id="fieldValue" class="operation w100b valueSelect">
        </select>
      </div>
    </td>
    <td style="width: 40px;">
      <div class="common_selectbox_wrap">
        <select id="rightChar" class="rightChar">
          <option value="" selected></option>
          <option value=")">)</option>
        </select>
      </div>
     </td>
    <td style="width: 50px;">
      <div class="common_selectbox_wrap">
        <select id="rowOperation" class="rowOperation">
          <option value="and" selected>and</option>
          <option value="or">or</option>
        </select>
      </div>
   </td>
   <td style="width: 50px;">
    <span class="delButton repeater_reduce_16 ico16 revoked_process_16" id="delButton" onclick="removeTr(this,'formSearch');"></span>
    <span class="addButton repeater_plus_16 ico16" id="addButton" onclick="insertTr(this,'formSearch');"></span>
  </td>
  </tr>
</table>
</div>
<!-- 自定义条件实例化后的区域，js生成，参考js代码fnInitCndArea -->
<div id="cndTrArea" class="display_none">
  <table border="0" cellspacing="0" cellpadding="0">
  </table>
</div>
<!-- 显示列 -->
<div id="showColTemple" class="display_none">
  <div>
    <p class="color" href="javascript:void(0);"></p>
    <span onclick="fnDelShowCol(this);" class="itemclose"></span>
  </div>
</div>  