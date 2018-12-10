<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html style="width: 100%;height: 100%">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
</head>
<body class="over_hidden font_size12">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="">
	<tr>
		<td valign="top">
		<fieldset height="100%" ><legend >${ctp:i18n('taskmanage.trigger.copy')}</legend>
		
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
		
		<form action="#" id="inputForm">
		<div style="height: 340px;overflow-y:scroll">
		<table width="90%" id="fieldAreaContent"  cellspacing="0" cellpadding="0" align="center">
			<%-- 这里存放表格内容 --%>
	    </table>
		</div>
		</form>
		
		</fieldset>	
		</td>
	</tr>
	<tr id="reset">
		<td height="42" align="left" class="bg-advance-bottom" >
		<a class="common_button common_button_gray margin_l_5" href="javascript:reset();" >${ctp:i18n('taskmanage.trigger.linkage.reset')}</a>
		</td>
	</tr>
</table>

<%-- 必选字段，放在最前面的 --%>
<script type="text/html" id="requiredTrTpl">
<tr height="10">
	<td class="new-column" width="50%" nowrap="nowrap" align ="left" >
		<div style="height:28px;border: 1px solid #e4e4e4;line-height:28px;vertical-align: middle;">
			<label style="margin-top: 10px"><font color="red">*</font>{{d.taskName}}</label>	
		</div>
	</td>
	<td class="new-column" width="270px" align ="left" colspan="3" >
		<input onclick="bindFormField('{{d.inputId}}','{{d.fieldType}}',this);" value="{{d.display}}" readonly="readonly" style="width:270px;height:28px;border: 1px solid #e4e4e4;"  class="input-100per hand"/>
		<input id="{{d.inputId}}" name="{{d.inputId}}" type="hidden" value="{{d.value}}" class="requiredInput" taskName="{{d.taskName}}"/>
	</td>
</tr>
</script>

<%-- 右边文本框效果 --%>
<script type="text/html" id="rightTdTpl">
{{# if(d.inputId != undefined){ }}
<input readonly="readonly" onclick="bindFormField('{{d.inputId}}','{{d.fieldType}}',this);" value="{{d.display}}" style="width:270px;height:28px;border: 1px solid #e4e4e4;"  class="input-100per hand displayInput"/>
<input type="hidden" id="{{d.inputId}}" name="{{d.inputId}}" value="{{d.value}}" class="hiddenInput requiredInput" taskName="{{d.taskName}}"/>
{{# }else{ }}
<input readonly="readonly" style="width:270px;height:28px;border: 1px solid #e4e4e4;"  class="input-100per displayInput"/>
<input type="hidden" id="" value="" class="hiddenInput"/>
{{# } }}
</script>

<%-- 可选字段 --%>
<script type="text/html" id="canSelectTrTpl">
<tr height="10" class="canSelectedTr">
  <td class="new-column" width="50%" nowrap="nowrap" align ="left" >
	<div class="w100b">
	<select class="w100b" onchange="changeBindInput(this);">
	  <option value="" displayName="">${ctp:i18n('taskmanage.risk.no')}</option>
	  {{# for(var key in d.options){     }}
      {{# var option = d.options[key];   }}
	  <option value="{{option.inputId}}|{{option.fieldType}}|{{option.taskName}}"  {{# if(d.inputId==option.inputId){ }}selected="selected"{{# } }} >{{option.taskName}}</option>
	  {{# }                              }}
	</select>
	</div>
  </td>
  <td class="new-column rightTd" align ="left">
	{{d.rightTd}}
  </td>
  <td>
	<span class='ico16 repeater_reduce_16' onclick="delField(this);"></span>
  </td>
  <td>
    <span class='ico16 repeater_plus_16' onclick="addField(this);"></span>
  </td>
</tr>	
</script>
<%@include file="/WEB-INF/jsp/common/common_footer.jsp"%>
<script type="text/javascript" src="${path}/common/js/laytpl.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
$(function(){
	init();
});

//此前填写过的数据
var fillValues = '${oldFillBackValue}';
//表单ID
var formId = "${formId}";
//应用类型： 表单
var appName = "form";
//必填项，每一行的模板
var requiredTrTpl;
//可选项，每一行的模板
var canSelectTrTpl;
//可选项，右边的文本框模板：分为可点击和不可点击两类
var rightTdTpl;
//必选字段基础信息
var requiredConfigs = {
"createUser" : {"taskName":"${ctp:i18n('taskmanage.detail.creator.label')}","inputId":"createUser","fieldType":"member","value":"","display":""},
"subject"  : {"taskName":"${ctp:i18n('taskmanage.subject.label')}","inputId":"subject","fieldType":"text","value":"","display":""},
"starttime": {"taskName":"${ctp:i18n('taskmanage.starttime')}","inputId":"starttime","fieldType":"date,datetime","value":"","display":""},
"endtime"  : {"taskName":"${ctp:i18n('taskmanage.endtime')}","inputId":"endtime","fieldType":"date,datetime","value":"","display":""},
"managers" : {"taskName":"${ctp:i18n('taskmanage.manager')}","inputId":"managers","fieldType":"member,multimember","value":"","display":""}
}
//可选字段基础信息
var canSelectedConfigs = {
"participators"	: {"taskName":"${ctp:i18n('taskmanage.participator')}","inputId":"participators","fieldType":"member,multimember","value":"","display":""},
"inspectors"  	: {"taskName":"${ctp:i18n('taskmanage.detail.tell.label')}","inputId":"inspectors","fieldType":"member,multimember","value":"","display":""},
"content"  		: {"taskName":"${ctp:i18n('taskmanage.description.js')}","inputId":"content","fieldType":"text,textarea","value":"","display":""},
"importantLevel": {"taskName":"${ctp:i18n('taskmanage.detail.importantLevel.label')}","inputId":"importantLevel","fieldType":"select,radio","value":"","display":""},	
"milestone" 	: {"taskName":"${ctp:i18n('taskmanage.mark.milestone.label')}","inputId":"milestone","fieldType":"select,radio","value":"","display":""},
"projectId" 	: {"taskName":"${ctp:i18n('taskmanage.project.belong.js')}","inputId":"projectId","fieldType":"project","value":"","display":""},
"attachment" 	: {"taskName":"${ctp:i18n('taskmanage.trigger.attachment')}","inputId":"attachment","fieldType":"attachment,image","value":"","display":""},
"document" 	    : {"taskName":"${ctp:i18n('taskmanage.trigger.document')}","inputId":"document","fieldType":"document","value":"","display":""}
}


function init(){
	requiredTrTpl = laytpl($("#requiredTrTpl").html());
	canSelectTrTpl = laytpl($("#canSelectTrTpl").html());
	rightTdTpl = laytpl($("#rightTdTpl").html());
	
	if($.isNull(fillValues)){
		reset();
	}else{
		
		var values = $.parseJSON(fillValues);
		
		var requiredHtml = "";
		var canSelectHtml = "";
		
		for(var key in requiredConfigs){
			var value = getValue(values,key);
			var param;
			if(value == null){
				param = requiredConfigs[key];
			}else{
				var inputId = value.inputId;
				var field = value.field;
				var fieldType = value.fieldType;
				var display = value.display;
				var required = requiredConfigs[inputId];
				param = {
					"taskName":required.taskName,
					"inputId":inputId,
					"fieldType":required.fieldType,
					"value":field,
					"display":display
				}
			}
			requiredHtml += requiredTrTpl.render(param);
		}  
		for(var i=0;i<values.length;i++){
			var value = values[i];
			var inputId = value.inputId;
			var field = value.field;
			var fieldType = value.fieldType;
			var display = value.display;
			if(canSelectedConfigs[inputId] != undefined){
				//选填字段
				var canSelected = canSelectedConfigs[inputId];
				var param = {
					"taskName" : canSelected.taskName,
					"inputId"  : inputId,
					"fieldType": canSelected.fieldType,
					"value"    : field,
					"display"  : display,
					"options"  : canSelectedConfigs
				}
				param.rightTd = rightTdTpl.render(param);
				canSelectHtml += canSelectTrTpl.render(param);
			}
		}//end of for
		
		if(canSelectHtml == ""){
			canSelectHtml = canSelectTrTpl.render({options:canSelectedConfigs,rightTd:rightTdTpl.render({})});
		}
		
		//将可选项插入到表格中
		$("#fieldAreaContent").html(requiredHtml + canSelectHtml);
	}
}
function getValue(values,inputId){
	var value = null;
	for(var i=0;i<values.length;i++){
		if(inputId == values[i].inputId){
			value = values[i];
			break;
		}
	}
	return value;
}
/**重置，即恢复到数据初始状态*/
function reset(){
	
	var requiredHtml = "";
	for(var key in requiredConfigs){
		requiredHtml += requiredTrTpl.render(requiredConfigs[key]);
	}
	
	var canSelectHtml = canSelectTrTpl.render({options:canSelectedConfigs,rightTd:rightTdTpl.render({})});
	//将可选项插入到表格中
	$("#fieldAreaContent").html(requiredHtml + canSelectHtml);
}

/**新增一行*/
function addField(dom){
	var canSelectHtml = canSelectTrTpl.render({options:canSelectedConfigs,rightTd:rightTdTpl.render({})});
	$(dom).parents("tr:eq(0)").after(canSelectHtml);
}

/**减去一行*/
function delField(dom){
	var trs = $(".canSelectedTr");
	if(trs.length > 1){
		$(dom).parents("tr:eq(0)").remove();
	}else{
		$.alert("${ctp:i18n('taskmanage.trigger.linkage.can.not.delete')}");
	}
}

/*绑定元素*/
function bindFormField(hideId,fieldType,bindDom){
	if(hideId === '') return;
  	$.selectStructuredDocFileds({
  		'appName':appName,
  		'formAppId':formId,
  		'fieldType':fieldType,
  		'onOk':function(v){
  			if(v && v.fieldDbName && v.fieldDisplayName){
  				//选择的值回填 ： 显示值回填到文本框中，隐藏的field信息回填到隐藏域中
  				bindDom.value = v.fieldDisplayName;
  	  			$("#"+hideId).val(v.fieldDbName);
  			}
  		}
  	});
}

/**下拉列表*/
function changeBindInput(selectDom){
	var optionValue = selectDom.value;
	if(optionValue == ""){
		var tr = $(selectDom).parents("tr:eq(0)");
		tr.find(".rightTd").html(rightTdTpl.render({}));
	}else{
		var arrs = optionValue.split("|");
		var inputId = arrs[0];
		var fieldType = arrs[1];
		var display = arrs[2];
		
		/**校验这家伙是否已经被选择过，如果有则提示不能再选择*/
		var hiddenInputs = $(".hiddenInput");
		for(i=0;i<hiddenInputs.length;i++){
	 		var hideId = hiddenInputs[i].id;
			if(hideId == ""){
				continue;
			}
			if(hideId == inputId){
				$.alert("${ctp:i18n('taskmanage.trigger.linkage.has.Task.properties')}");
				//将下拉选择项置为空
				selectDom.value = "";
				var tr = $(selectDom).parents("tr:eq(0)");
				tr.find(".rightTd").html(rightTdTpl.render({}));
				return;
			}
	 	}
		
		//如果一切都OK，则添加上对应事件
		var tr = $(selectDom).parents("tr:eq(0)");
		tr.find(".rightTd").html(rightTdTpl.render({
			"inputId" : inputId,
			"fieldType" : fieldType,
			"taskName" : display,
			"display" : "",
			"value": ""
		}));
	}//end of else
}

/**外层dialog确定时触发*/
function OK(){
	var valid = true;
	var data = new Array();
	$("#inputForm .requiredInput").each(function(){
		var $this = $(this);
		if($.isNull($this.val())){
			$.alert($this.attr("taskName")+"${ctp:i18n('taskmanage.trigger.linkage.cannot.empty')}");
			valid = false;
			return false;
		}else{
			var code = $this.attr("id");
			data.push(code + "|" + $this.val());
		}
	});
// 	var data = $("#inputForm").formobj();
	
	if(valid == true){
		var ajax = new formTriggerTaskManager();
		var result = ajax.validateDesign(data);
		if(result.success == "false"){
			valid = false;
			$.alert(result.error);
		}
	}
	
	if(valid == false){
		return false;
	}else{
		return $.toJSON(data);
	}
}

</script>
</body>
</html>