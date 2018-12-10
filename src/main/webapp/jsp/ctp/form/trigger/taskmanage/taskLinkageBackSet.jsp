<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html style="width: 100%;height: 100%">
<head>
<style type="text/css">
	.display{width:240px;height:28px;border: 1px solid #e4e4e4;}
</style>
<script type="text/javascript">
//单据id
var formAppId = "";
//应用类型： 表单
var appName = "form";
//当前选中的绑定框
var selectObj;
//隐藏的存放绑定表单id的框
var hiddenSelectObj;
//必填项
var mustCodeArr = ["createUser","subject","starttime","endtime","managers"];
var goCodeOpt = null,backCodeOpt = null;
var codeMap = {};
$().ready(function(){
	goCodeOpt = ["participators","inspectors","content","importantLevel","milestone","projectId","attachment","document"];
	backCodeOpt = ["status","finishRate","riskLevel","elapsedTime","feedbackContent","feedbackAttachment","feedbackdocument"];
	
	codeMap['createUser']			={"fieldType":"member","text":"${ctp:i18n('taskmanage.detail.creator.label')}"};
	codeMap['subject']				={"fieldType":"text","text":"${ctp:i18n('taskmanage.subject.label')}"};
	codeMap['starttime']			={"fieldType":"date,datetime","text":"${ctp:i18n('taskmanage.starttime')}"};
	codeMap['endtime']				={"fieldType":"date,datetime","text":"${ctp:i18n('taskmanage.endtime')}"};
	codeMap['managers']				={"fieldType":"date,datetime","text":"${ctp:i18n('taskmanage.manager')}"};
	
	codeMap['content']				={"fieldType":"text,textarea","text":"${ctp:i18n('taskmanage.description.js')}"};
	codeMap['participators']		={"fieldType":"member,multimember","text":"${ctp:i18n('taskmanage.participator')}"};
	codeMap['inspectors']			={"fieldType":"member,multimember","text":"${ctp:i18n('taskmanage.detail.tell.label')}"};
	codeMap['importantLevel']		={"fieldType":"select,radio","text":"${ctp:i18n('taskmanage.detail.importantLevel.label')}"};
	codeMap['milestone']			={"fieldType":"select,radio","text":"${ctp:i18n('taskmanage.mark.milestone.label')}"};
	codeMap['projectId']			={"fieldType":"project","text":"${ctp:i18n('taskmanage.project.belong.js')}"};
	codeMap['attachment']			={"fieldType":"attachment,image","text":"${ctp:i18n('taskmanage.trigger.attachment')}"};
	codeMap['document']				={"fieldType":"document","text":"${ctp:i18n('taskmanage.trigger.document')}"};
	
	codeMap['status']				={"fieldType":"select,radio","text":"${ctp:i18n('taskmanage.status.label')}"};
	codeMap['finishRate']			={"fieldType":"decimal","text":"${ctp:i18n('taskmanage.finishrate')}"};
	codeMap['riskLevel']			={"fieldType":"select,radio","text":"${ctp:i18n('taskmanage.risk')}"};
	codeMap['elapsedTime']			={"fieldType":"decimal","text":"${ctp:i18n('taskmanage.elapsedTime')}"};
	codeMap['feedbackContent']		={"fieldType":"textarea","text":"${ctp:i18n('taskmanage.detail.report.label')}${ctp:i18n('taskmanage.explain.label')}"};
	codeMap['feedbackAttachment']	={"fieldType":"attachment","text":"${ctp:i18n('taskmanage.detail.report.label')}${ctp:i18n('taskmanage.trigger.attachment')}"};
	codeMap['feedbackdocument']		={"fieldType":"document","text":"${ctp:i18n('taskmanage.detail.report.label')}${ctp:i18n('taskmanage.trigger.document')}"};
	
	var bidirectional = '${bidirectional}';
	if(bidirectional == "true"){
		$("#bidirectional").attr("checked",'true');
	}
	formAppId = "${formId}";
	var oldGoLinkageValue = '${oldGoLinkageValue}';
	goFillForm(oldGoLinkageValue);
	var oldBackLinkageValue = '${oldBackLinkageValue}';
	backFillForm(oldBackLinkageValue);
	
	initBindClick();
});
/**
 * 绑定事件
 */
function initBindClick(){
	$(".goSelectTr,.backSelectTr").find(".display").unbind('click').click(function() {
		var taskCode = $(this).parents(".fieldSet").attr("id");
		if(!$.isNull(taskCode)){
			bindFormField(taskCode, codeMap[taskCode].fieldType, this);
		}
	});
	$("#bidirectional").change(function() { 
		$(".setArrow").text(getArrow());
	});
}
/**
 * 取设置方向箭头
 */
function getArrow(){
	var setArrow = "----->";
	if($("#bidirectional").is(':checked')){
		setArrow = "<----->";
	}
	return setArrow;
}
/**
 * 回填数据
 */
function goFillForm(oldFillValue){
	var hasSelectTr = false;
	if(!$.isNull(oldFillValue)){
		var values = $.parseJSON(oldFillValue)
		for (i = 0; i < values.length; i++) {
			var value = values[i];
			var taskCode = value.inputId;//任务属性字段  name  
			var field = value.field;//表单字段名称  field001
			var fieldType = value.fieldType;
			var display = value.display;//表单字段对应的显示名称
			if(mustCodeArr.contains(taskCode)){
				var $tr = $("#goFormTable").find("#"+taskCode);
				$tr.find(".display").val(display);
				$tr.find(".value").val(field);
			}else{
				hasSelectTr = true;
				addGoTr(taskCode,display,field);
			}
		}
	}
	if(!hasSelectTr){//没有添加行
		addGoTr("","","");
	}
}
function backFillForm(oldFillValue){
	var hasSelectTr = false;
	if(!$.isNull(oldFillValue)){
		var values = $.parseJSON(oldFillValue)
		for (i = 0; i < values.length; i++) {
			var value = values[i];
			var taskCode = value.inputId;//任务属性字段  name  
			var field = value.field;//表单字段名称  field001
			var fieldType = value.fieldType;
			var display = value.display;//表单字段对应的显示名称
			addBackTr(taskCode,display,field);
		}
	}else{
		addBackTr("","","");
	}
}
function addGoTr(taskCode,display,value){
	var data = {taskCode:taskCode,display:display,value:value,options: goCodeOpt,codeMap:codeMap};
	var $formTalbe = $("#goFormTable tbody");
	var tpl = document.getElementById('goSelectTrTpl').innerHTML; //读取模版
	var trHtml = laytpl(tpl).render(data);
	$formTalbe.append(trHtml);
}
function addBackTr(taskCode,display,value){
	var setArrow = getArrow();
	var data = {taskCode:taskCode,display:display,value:value,options: backCodeOpt,codeMap:codeMap,setArrow:setArrow};
	var $formTalbe = $("#backFormTable tbody");
	var tpl = document.getElementById('backSelectTrTpl').innerHTML; //读取模版
	var trHtml = laytpl(tpl).render(data);
	$formTalbe.append(trHtml);
}

/**
 *图标设置删除图标事项，删除一个重复项
 */
function delField(obj) {
	var $tr = $(obj).parents("tr:eq(0)");
	if ($("."+$tr.attr("class")).length > 1) {
		$(obj).parents("tr:eq(0)").remove();
	} else {
		$.alert("${ctp:i18n('taskmanage.trigger.linkage.can.not.delete')}");
	}
}

/**
 *图标设置添加图标事项，添加一个重复项
 */
function addField(obj) {
	var $tr = $(obj).parents("tr:eq(0)");
	if($tr.hasClass("goSelectTr")){
		addGoTr("","","");
	}else{
		addBackTr("","","");
	}
}

/**
 * 重置按钮
 */
function reset() {
	//清空字段的值
	$('input').val("");
	//删除可选字段
	$(".goSelectTr").remove();
	$(".backSelectTr").remove();
	addGoTr("","","");
	addBackTr("","","");
}

/* 
 *绑定元素
 */
function bindFormField(inputId, fieldType, obj) {
	if (inputId === '')
		return;
	$.selectStructuredDocFileds({
		'appName' : appName,
		'formAppId' : formAppId,
		'fieldType' : fieldType,
		'onOk':function(v){
  			if(v && v.fieldDbName && v.fieldDisplayName){
  				//选择的值回填 ： 显示值回填到文本框中，隐藏的field信息回填到隐藏域中
  				obj.value = v.fieldDisplayName;
  				$("#" + inputId).find(".value").val(v.fieldDbName);
  			}
  		}
	});
}

/**
 * 重新选择人员属性后
 */
function changeBindInput(obj) {
	//删掉绑定事件和绑定内容
	//展示的名称
	var $tr = $(obj).parents("tr:eq(0)");
	var input = $tr.find(".display");
	//清理原来的时间，和值
	input.unbind('click');
	input.val("");
	$tr.find(".value").val("");
	$tr.find(".fieldSet").attr("id", "");
	//重新添加绑定事件
	var selectVal = $(obj).val();
	if ($.isNull(selectVal)){
		$tr.find(".fieldSet").attr("id", selectVal);
		return;
	}
	var fieldSet = $(".fieldSet");
	for (i = 0; i < fieldSet.length; i++) {
		var id = fieldSet[i].id;
		if (id === '')
			continue;
		if (id == selectVal) {
			$.alert("${ctp:i18n('taskmanage.trigger.linkage.has.Task.properties')}");
			$(obj).val("");
			return;
		}
	}
	$tr.find(".fieldSet").attr("id", selectVal);
	input.unbind('click').click(function() {
		var taskCode = $(this).parents(".fieldSet").attr("id");
		bindFormField(taskCode, codeMap[taskCode].fieldType, this);
	});
}

/**
 *返回事件
 */
function OK() {
	var ret = true;
	var goTask = new Array();
	$("#goFormTable .fieldSet").each(function(){
		var $this = $(this);
		var code = $this.attr("id");
		if(!$.isNull(code)){
			var value = $this.find(".value").val();
			if($.isNull(value)){
				$.alert(codeMap[code].text+"${ctp:i18n('taskmanage.trigger.linkage.cannot.empty')}");
				ret = false;
				return false;
			}else{
				goTask.push(code + "|" + value);
			}
		}
	});
	var backTask = new Array();
	if(ret){
		$("#backFormTable .fieldSet").each(function(){
			var $this = $(this);
			var code = $this.attr("id");
			if(!$.isNull(code)){
				var value = $this.find(".value").val();
				if($.isNull(value)){
					$.alert(codeMap[code].text+"${ctp:i18n('taskmanage.trigger.linkage.cannot.empty')}");
					ret = false;
					return false;
				}else if(checkDuplicateField(code,value,goTask)){
					ret = false;
					return false;
				}else if(checkDuplicateField(code,value,backTask)){
					ret = false;
					return false;
				}else{
					backTask.push(code + "|" + value);
				}
			}
		});
	}
	var bidirectional = false;
	var result = new Object();
	result.goTask = goTask;
	if(!$.isEmptyObject(backTask)){
		bidirectional = $("#bidirectional").is(':checked');
		result.backTask = backTask;
	}
	result.bidirectional = bidirectional;
	if(ret){
		var ajax = new formTriggerTaskManager();
		var r = ajax.validateLinkageDesign(result);
		if(r.success == "false"){
			ret = false;
			$.alert(r.error);
		}
	}
	if(ret){
		return $.toJSON(result);
	}
	return ret;
}
/**
 * 检查选择的表单字段是否重复
 */
function checkDuplicateField(code,field,fieldList){
	for(var i=0;i<fieldList.length;i++) {
		var tAndf = fieldList[i].split("|");
		if(tAndf[1] == field){
			$.alert(codeMap[code].text+";"+codeMap[tAndf[0]].text+"${ctp:i18n('taskmanage.trigger.linkage.set.same.field')}");
			return true;
		}
	}
	return false;
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body class="over_hidden font_size12">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="">
	<tr>
		<td valign="top">
		<fieldset height="100%" ><legend >${ctp:i18n('taskmanage.trigger.distribution')}</legend>
		
			<table width="90%" border=0 align="center" style="border-bottom:solid 2px #333333;height: 10px;">
				<tr height="20">
					<td class="bg-gray" width="40%" nowrap="nowrap" align ="center">
						<label for="name"> ${ctp:i18n('taskmanage.trigger.Task.attribute')}</label>
					</td>
					<td class="bg-gray" width="60%" nowrap="nowrap" align ="center">
						<label for="name"> ${ctp:i18n('taskmanage.trigger.current.form')}</label>							
					</td>
				</tr>
			</table>
			<div style="height: 10px"></div>
			<!-- 固定字段 -->
			<div style="height: 180px;overflow-y:scroll">
			<table id="goFormTable" width="90%"  cellspacing="0" cellpadding="0" align="center">
				<tbody>
				<tr height="10" >
					<td class="new-column" width="50%" nowrap="nowrap" align ="left" >
						<div style="height:28px;border: 1px solid #e4e4e4;line-height:28px;vertical-align: middle;">
							<label style="margin-top: 10px"><font color="red">*</font>${ctp:i18n('taskmanage.detail.creator.label')}</label>	
						</div>
					</td>
					<td width="15%" ><label>&lt;-----&nbsp;</label></td>
					<td class="new-column fieldSet" id="createUser" width="240px" align ="left" colspan="3" >
						<input class="input-100per display" onclick="bindFormField('createUser','member',this);" readonly="readonly" />
						<input class="value" type="hidden" value=""/>
					</td>
				</tr>
				<tr height="10" >
					<td class="new-column" width="50%" nowrap="nowrap" align ="left" >
						<div style="height:28px;border: 1px solid #e4e4e4;line-height:28px;vertical-align: middle;">
							<label style="margin-top: 10px"><font color="red">*</font>${ctp:i18n('taskmanage.subject.label')}</label>	
						</div>
					</td>
					<td width="15%" ><label>&lt;-----&nbsp;</label></td>
					<td class="new-column fieldSet" id="subject" width="240px" align ="left" colspan="3" >
						<input class="input-100per display" onclick="bindFormField('subject','text',this);" readonly="readonly" />
						<input class="value" type="hidden" value=""/>
					</td>
				</tr>
				<tr height="10" >
					<td class="new-column" width="50%" nowrap="nowrap" align ="left" >
						<div style="height:28px;border: 1px solid #e4e4e4;line-height:28px;vertical-align: middle;">
							<label style="margin-top: 10px"><font color="red">*</font>${ctp:i18n('taskmanage.starttime')}</label>	
						</div>
					</td>
					<td width="15%" ><label>&lt;-----&nbsp;</label></td>
					<td class="new-column fieldSet" id ="starttime" width="240px" align ="left" colspan="3" >
						<input class="input-100per display" onclick="bindFormField('starttime','date,datetime',this);" readonly="readonly" name="starttime"/>
						<input class="value" type="hidden" value=""/>
					</td>
				</tr>	
				<tr height="10" >
					<td class="new-column" width="50%" nowrap="nowrap" align ="left" >
						<div style="height:28px;border: 1px solid #e4e4e4;line-height:28px;vertical-align: middle;">
							<label style="margin-top: 10px"><font color="red">*</font>${ctp:i18n('taskmanage.endtime')}</label>	
						</div>
					</td>
					<td width="15%" ><label>&lt;-----&nbsp;</label></td>
					<td class="new-column fieldSet" id="endtime" width="240px" align ="left" colspan="3" >
						<input class="input-100per display" onclick="bindFormField('endtime','date,datetime',this);" readonly="readonly" name="endtime"/>
						<input class="value" type="hidden" value=""/>
					</td>
				</tr>	
				<tr height="10" id="lastTr">
					<td class="new-column" width="50%" nowrap="nowrap" align ="left" >
						<div style="height:28px;border: 1px solid #e4e4e4;line-height:28px;vertical-align: middle;">
							<label style="margin-top: 10px"><font color="red">*</font>${ctp:i18n('taskmanage.manager')}</label>	
						</div>
					</td>
					<td width="15%" ><label>&lt;-----&nbsp;</label></td>
					<td class="new-column fieldSet" width="240px" id="managers" align ="left" colspan="3" >
						<input class="input-100per display" onclick="bindFormField('managers','member,multimember',this);" readonly="readonly"  name="managers"/>
						<input class="value" type="hidden" value=""/>
					</td>
				</tr>
				</tbody>
		    </table>
			</div>
		</fieldset>	
		</td>
	</tr>
	<tr>
		<td valign="top">
		<fieldset height="100%" ><legend >${ctp:i18n('taskmanage.trigger.linkage.feedback')}</legend>
			<div class="common_checkbox_box clearfix margin_b_5" style="margin-left:29px;">
                <input type="checkbox" value="1" id="bidirectional" name="bidirectional" class="radio_com">${ctp:i18n('taskmanage.trigger.linkage.two-way')}
            </div>
			<div style="height: 100px;overflow-y:scroll">
			<table id="backFormTable" width="90%" cellspacing="0" cellpadding="0" align="center">
			<tbody>
			</tbody>
		    </table>
			</div>
		</fieldset>	
		</td>
	</tr>
	<tr id="reset">
		<td height="42" align="left" class="bg-advance-bottom" >
		<a class="common_button common_button_gray margin_l_5" href="javascript:reset();" id="createMember">${ctp:i18n('taskmanage.trigger.linkage.reset')}</a>
		</td>
	</tr>
</table>

<script id="goSelectTrTpl" type="text/html">
<tr class="goSelectTr" height="10">
           <td class="new-column" width="50%" nowrap="nowrap" align ="left" >
			<div class="w100b">
				<select class="w100b selectCode" onchange="changeBindInput(this);">
				  <option value="" displayName="">${ctp:i18n('taskmanage.risk.no')}</option>
					{{# for(var i = 0, len = d.options.length; i < len; i++){ var opt = d.options[i]; }}
						<option value="{{opt }}" {{# if (opt == d.taskCode) { }} selected="selected"{{# } }}>{{d.codeMap[opt].text }}</option>
					{{# } }}
				</select>
			</div>
		</td>
		<td width="15%" ><label>&lt;-----&nbsp;</label></td>
		<td class="new-column fieldSet" id="{{d.taskCode}}" align ="left">
			<input readonly="readonly" class="input-100per display" value="{{d.display}}"/>
			<input type="hidden" class="value"  value="{{d.value}}"/>
		</td>
		<td>
			<span class='ico16 repeater_reduce_16' onclick="delField(this);"></span>
        	</td>
        	<td>
            <span class='ico16 repeater_plus_16' onclick="addField(this);"></span>
        	</td>
       	</tr>
</script>
<script id="backSelectTrTpl" type="text/html">
<tr class="backSelectTr" height="10">
           <td class="new-column" width="50%" nowrap="nowrap" align ="left" >
			<div class="w100b">
				<select class="w100b selectCode" onchange="changeBindInput(this);">
				  <option value="" displayName="">${ctp:i18n('taskmanage.risk.no')}</option>
					{{# for(var i = 0, len = d.options.length; i < len; i++){ var opt = d.options[i]; }}
						<option value="{{opt }}" {{# if (opt == d.taskCode) { }} selected="selected"{{# } }}>{{d.codeMap[opt].text }}</option>
					{{# } }}
				</select>
			</div>
		</td>
		<td width="15%" ><label class="setArrow">{{=d.setArrow }}</label></td>
		<td class="new-column fieldSet" id="{{d.taskCode}}" align ="left">
			<input readonly="readonly" class="input-100per display" value="{{d.display}}"/>
			<input type="hidden" class="value"  value="{{d.value}}"/>
		</td>
		<td>
			<span class='ico16 repeater_reduce_16' onclick="delField(this);"></span>
        	</td>
        	<td>
            <span class='ico16 repeater_plus_16' onclick="addField(this);"></span>
        	</td>
       	</tr>
</script>
<script type="text/javascript" src="${path}/common/js/laytpl.js${ctp:resSuffix()}"></script>
</body>
</html>