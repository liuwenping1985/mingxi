<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<script id="doc_HTMLTemp" type="text/html">
<div class="customValidate customSubmit">
	<div class="list_item">
		<div class="model_name form_area">
			<label class="label_th left">${ctp:i18n('ctp.dr.data.source.title.js')}:</label>
      <div class="common_txtbox_wrap">
        <input id="subject" type="text" placeholder="${ctp:i18n('ctp.dr.input.title.js')}" onkeyup="subjectChange(this)" class="validate subject left" validate="type:'string',func:checkNull,name:'',errorMsg:'${ctp:i18n('ctp.dr.name.not.empty.js')}'" maxlength="85">
      </div>
      <input id="dataType" type="hidden" value="5">
		</div>
		<div class="selected_data">
			<label class="label_th left">${ctp:i18n('ctp.dr.selected.data.title.js')}:</label> 
			<a href="javascript:openDocWin();" class="common_button common_button_emphasize left">${ctp:i18n('ctp.dr.select.data.js')}</a>
		</div>
		<div id="docsDiv" class="datalist">
    </div>
	</div>
</div>
</script>
<div id="doc" class="hidden rightmeau outersystem">
</div>
<!-- 模板 -->
<div id="docTemplate" class="display_none">
  <div>
     <p href="javascript:void(0);">
        <img width="16" id="file" class="display_none" height="16" src="/seeyon/apps_res/doc/images/docIcon/file.gif"/>
        <img width="16" id="folder" class="display_none" height="16" src="/seeyon/apps_res/doc/images/docIcon/folder_close.gif"/>
     </p>
     <span class="itemclose margin_r_5" onclick="delDoc(this);"></span>
    </div>
</div>