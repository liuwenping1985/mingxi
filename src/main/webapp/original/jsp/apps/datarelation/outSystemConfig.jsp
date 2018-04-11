<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<script id="outSystem_HTMLTemp" type="text/html">
<div class="form_area customValidate customSubmit">
	<div class="list_item">
		<div class="model_name">
			<label class="label_th left">${ctp:i18n('ctp.dr.data.source.title.js')}:</label>
			<div class="common_txtbox_wrap">
        		<input id="subject" type="text" onkeyup="subjectChange(this)" class="left validate subject" validate="type:'string',func:checkNull,name:'',errorMsg:'${ctp:i18n('ctp.dr.name.not.empty.js')}'" maxlength="85" placeholder="${ctp:i18n('ctp.dr.input.title.js')}" >
			</div>
			<input id="dataType" type="hidden" value="4">
		</div>
	</div>
	<div class="list_item">
	<div class="list_title">
		<span class="title_l">${ctp:i18n('ctp.dr.content.source.js')}</span>
	</div>
	<div class="model_name margin_t_10">
		<label class="label_th left">URL：</label>
		<div class="common_txtbox_wrap">
			<input id="url" style="width: 400px;" type="text" onkeydown="urlKeyDown(this);" class="validate left" validate="type:'string',func:checkNull,name:'URL',errorMsg:'${ctp:i18n('datarelation.check.msg.title.js')}'" maxlength="1000" placeholder="${ctp:i18n('datarelation.check.msg.title2.js')}">
		</div>
    </div>
	<div>
		<div class="left" style="height: 1px; width: 85px;"></div>
		<div class="consumer_name left">
			<p>${ctp:i18n('ctp.dr.out.system.url')}</p>
			<p style="color: green;">${ctp:i18n('ctp.dr.out.system.exp1')}</p>
			<select id="formFieldSelect" class="select-text" onchange="formFieldChange(this,'outSystem');">
				<option selected="" value="-1"></option>
			</select>
		</div>
	</div>
</div>
</script>
<div id="outSystem" class="hidden rightmeau outersystem">
</div>