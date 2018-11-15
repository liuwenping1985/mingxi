<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>createTask</title>
<script type="text/javascript">
if(navigator.language == "zh-CN"){

}
var createTaskFillBackValue="";
var formId = "${formId}";
// $().ready(function(){
// 	createTaskFillBackValue = $("#ConfigValue",parent.document).val();
// 	if(parent.currentTr != undefined){
// 		createTaskFillBackValue = parent.currentTr.find("#ConfigValue").val();
// 	}
// });
function init(configValue){
	createTaskFillBackValue = configValue;
}

function OK(){
	return createTaskFillBackValue;
}

function createTaskFun(){
	if($.isNull(createTaskFillBackValue)){
		createTaskFillBackValue = $("#ConfigValue",parent.currentTr).val();
	}
	dialog = $.dialog({
		width:620,
		height:450,
		targetWindow:getCtpTop(),
		transParams:window,
		url:_ctxPath + "/form/formTriggerCreateTask.do?method=triggerFillTaskBack&formId="+formId+"&createTaskFillBackValue="+ encodeURIComponent(createTaskFillBackValue),
	    title : $.i18n('form.trigger.triggerSet.copyData.label'),//数据拷贝设置
	    buttons : [{
	      text : $.i18n('common.button.ok.label'),
	      id:"creataTask",
		  isEmphasize: true,
	      handler : function() {
		      var retValue = dialog.getReturnValue();
		      if(retValue != false && !$.isNull(retValue)){
		    	  createTaskFillBackValue = retValue;
		    	  dialog.close();
		      }
	      }
	    }, {
	      text : $.i18n('common.button.cancel.label'),
	      id:"exit",
	      handler : function() {
	        dialog.close();
	      }
	    } ]
	});
}
function openHelpFun(){

	var helpHtml = $("#help_common").html();
	debugger;
	if(_locale == "en"){
		helpHtml = $("#help_common_english").html();
	}
	dialog = $.dialog({
		width:620,
		height:450,
		targetWindow:getCtpTop(),
		transParams:window,
		html:helpHtml,
	    title : $.i18n('taskmanage.trigger.linkage.help.document'),
	    buttons : [ {
	      text : $.i18n('common.button.cancel.label'),
	      id:"exit",
	      handler : function() {
	        dialog.close();
	      }
	    } ]
	});
}
</script>
</head>
<body class="page_color">
<table width="100%" border="0" cellpadding="2" cellspacing="0" height="100px;" style="font-size:12px;background-color:#FFFFFF">
	<!-- 创建人员 数据拷贝设置 -->
	<tr>
		<td width="23%" align="right" nowrap="nowrap">
			<label  style="font-size:12px;font-family:Microsoft YaHei,SimSun,Arial,Helvetica,sans-serif"> <font color="red">*</font>${ctp:i18n('form.trigger.triggerSet.copyData.label')}：</label>
		</td>
		<td width="60" nowrap="nowrap">
			<a class="common_button common_button_gray margin_l_5" href="javascript:createTaskFun();">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
		</td>
		<td nowrap="nowrap">
			<a class="common_button common_button_gray margin_l_5" href="javascript:openHelpFun();">${ctp:i18n('taskmanage.trigger.linkage.help.document')}</a>
		</td>
	</tr>
</table>

<div id="help_common" class="help_common hidden" style="color:#333;">
<style type="text/css">
	.help_title{font-size:18px;margin-top: 30px;}
	.help_com{margin-left: 20px;font-size:14px;line-height: 20px;}
	.help_com .title1{margin-top:15px;font-weight: bold;}
	.help_com .title2{margin-top:25px;margin-bottom:15px;font-weight: bold;}
	.help_com table{margin-top:15px;margin-bottom:15px;width:565px;}
	.help_com tr{height:30px;}
	.help_com tr th{text-align: center;}
	.help_com tr td{text-align: center;}
</style>
	<div class="align_center help_title">表单触发任务说明</div>
	<div class="help_com">
		<div class="title1"><span>1.	表单字段配置明细：</span></div>
	    <table border="0" cellspacing="0" cellpadding="0" class="only_table edit_table">
		    <thead>
		        <tr>
		            <th width="40%">任务字段名称</th><th>对应当前表单字段录入类型</th>
		        </tr>
		    </thead>
		    <tbody>
		        <tr><td>创建人</td><td>选择人员</td></tr>
		        <tr><td>标题</td><td>文本框</td></tr>
		        <tr><td>开始时间</td><td>日期控件、日期时间控件</td></tr>
		        <tr><td>结束时间</td><td>日期控件、日期时间控件</td></tr>
		        <tr><td>负责人</td><td>选择人员、选择多人</td></tr>
		        <tr><td>参与人</td><td>选择人员、选择多人</td></tr>
		        <tr><td>告知</td><td>选择人员、选择多人</td></tr>
		        <tr><td>描述</td><td>文本框、文本域</td></tr>
		        <tr><td>重要程度</td><td>下拉框（选择公共枚举-重要程度）</td></tr>
		        <tr><td>标为里程碑</td><td>下拉框（选择公共枚举-里程碑）</td></tr>
		        <tr><td>所属项目</td><td>选择关联项目</td></tr>
		        <tr><td>附件</td><td>插入附件、插入图片</td></tr>
		        <tr><td>关联文档</td><td>关联文档</td></tr>
		    </tbody>
		</table>
		<div class="title2"><span>2.	特殊说明：</span></div>
		<div class="font_size12">
			<p>2.1	配置以下字段:重要程度、里程碑时，请使用公共枚举下的枚举值，不要修改。如果修改后使用，可能导致任务创建触发失败。</p>
			<p>2.2	创建人必填，并且只能选择主表字段。</p>
			<p>2.3	任务属性不能重复选择.</p>
			<p>2.4	表单字段可以重复。</p>
		</div>
		<div class="title2"><span>3.	触发说明：</span></div>
		<div class="font_size12">
			<p>3.1为了提升用户体验，以下情况系统会自动调整数据并数据触发成功：</p>
			<table border="0" cellspacing="0" cellpadding="0" class="only_table edit_table">
			    <thead>
			        <tr>
			            <th width="40%">表单录入异常情况</th><th>系统解决方案</th>
			        </tr>
			    </thead>
			    <tbody>
			        <tr><td>任务标题字数过多</td><td>对任务标题字数进行截取，只保留前85字</td></tr>
			        <tr><td>任务的开始时间大于结束时间</td><td style="text-align: left;">
			        							任务中开始时间取【表单中开始时间】<br>
			        							任务中结束时间取：<br>
			        							a.若【表单中开始时间】为日期型，则结束时间为当日23:59:59<br>
												b.若【表单中开始时间】为时间型，则结束时间等于开始时间+1小时<br>
												开始时间等于结束时间	【表单中开始时间】为时间型，将结束时间+1小时</td></tr>
			        <tr><td>人员已被停用或删除</td><td>不进行校验</td></tr>
			        <tr><td>枚举字段未使用系统默认</td><td>自动匹配默认值：重要程度-普通；里程碑-非里程碑任务</td></tr>
			        <tr><td>选取所属项目已结束</td><td rowspan="3">设置当前任务为非项目任务</td></tr>
			        <tr><td>任务的创建人不在项目中	</td></tr>
			        <tr><td>创建人没有任务的分解权限</td></tr>
			    </tbody>
			</table>
			<p>3.2如果出现以下情况，会导致表单触发任务失败：</p>
			<table border="0" cellspacing="0" cellpadding="0" class="only_table edit_table">
			    <thead>
			        <tr>
			            <th width="20%">序号</th><th>触发失败原因</th>
			        </tr>
			    </thead>
			    <tbody>
			    	<tr><td>1</td><td>表单重复行，如果有一行不满足校验，所有的分发都触发失败</td></tr>
			    	<tr><td>2</td><td>表单填写标题为空时</td></tr>
			    	<tr><td>3</td><td>表单填写任务开始时间为空时</td></tr>
			    	<tr><td>4</td><td>表单填写任务结束时间为空时</td></tr>
			    	<tr><td>5</td><td>表单填写创建人为空时</td></tr>
			    	<tr><td>6</td><td>表单填写负责人为空时</td></tr>
			    	<tr><td>7</td><td>表单填写负责人、参与人或告知超过255人时</td></tr>
			    </tbody>
			</table>
		</div>
	</div>
</div>
<div id="help_common_english" class="help_common hidden" style="color:#333;">
	<style type="text/css">
		.help_title{font-size:18px;margin-top: 30px;}
		.help_com{margin-left: 20px;font-size:14px;line-height: 20px;}
		.help_com .title1{margin-top:15px;font-weight: bold;}
		.help_com .title2{margin-top:25px;margin-bottom:15px;font-weight: bold;}
		.help_com table{margin-top:15px;margin-bottom:15px;width:565px;}
		.help_com tr{height:30px;}
		.help_com tr th{text-align: center;}
		.help_com tr td{text-align: center;}
	</style>
	<div class="align_center help_title">Form trigger task description</div>
	<div class="help_com">
		<div class="title1"><span>1.	Form field configuration details：</span></div>
		<table border="0" cellspacing="0" cellpadding="0" class="only_table edit_table">
			<thead>
			<tr>
				<th width="40%">Task field name</th><th>Corresponds to the current form field entry type</th>
			</tr>
			</thead>
			<tbody>
			<tr><td>Founder</td><td>Select personnel</td></tr>
			<tr><td>Title</td><td>Text box</td></tr>
			<tr><td>start time</td><td>Date control, date, time control</td></tr>
			<tr><td>End time</td><td>Date control, date, time control</td></tr>
			<tr><td>Person in charge</td><td>Select people, select many people</td></tr>
			<tr><td>Participant</td><td>Select people, select many people</td></tr>
			<tr><td>inform</td><td>Select people, select many people</td></tr>
			<tr><td>describe</td><td>Text box、Text field</td></tr>
			<tr><td>Importance</td><td>Dropdown box (select public enumeration - importance)</td></tr>
			<tr><td>Mark as milestone</td><td>Drop down box (select public enumeration - milestone)</td></tr>
			<tr><td>Subordinate items</td><td>Select associated items</td></tr>
			<tr><td>Attachment</td><td>Insert attachments and insert pictures</td></tr>
			<tr><td>Associated document</td><td>Associated document</td></tr>
			</tbody>
		</table>
		<div class="title2"><span>2.	Special Instructions：</span></div>
		<div class="font_size12">
			<p>2.1	Configure the following fields: When you are important, use the enumeration value under the public enumeration, do not modify it. If modified, it may cause the task creation trigger to fail。</p>
			<p>2.2	The creator is required, and only the main table field can be selected。</p>
			<p>2.3	The task attribute can not be repeated.</p>
			<p>2.4	Form fields can be repeated。</p>
		</div>
		<div class="title2"><span>3.	Trigger instructions：</span></div>
		<div class="font_size12">
			<p>3.1In order to enhance the user experience, the following conditions will automatically adjust the data and data trigger success：</p>
			<table border="0" cellspacing="0" cellpadding="0" class="only_table edit_table">
				<thead>
				<tr>
					<th width="40%">Form entry exception condition</th><th>System solution</th>
				</tr>
				</thead>
				<tbody>
				<tr><td>Too many task titles</td><td>Interception of the task title word, leaving only the first 85 words</td></tr>
				<tr><td>The start time of the task is greater than the end time</td><td style="text-align: left;">
					Start time in the task Take the form start time in the form<br>
					The end of the task is taken：<br>
					a.If the start time in the form is the date type, the end time is 23:59:59 the same day<br>
					b.If the start time in the form is time, the end time is equal to the start time of 1 hour<br>
					The start time is equal to the end time [Form start time] is the time type, the end time is +1 hours</td></tr>
				<tr><td>Person has been disabled or deleted</td><td>No verification</td></tr>
				<tr><td>Enumerated fields are not used by default</td><td>Automatic Matching Default: Importance - Normal; Milestone - Non Milestone Mission</td></tr>
				<tr><td>Select the item is over</td><td rowspan="3">Set the current task to a non-project task</td></tr>
				<tr><td>The creator of the task is not in the project</td></tr>
				<tr><td>The creator has no task to break down the permissions</td></tr>
				</tbody>
			</table>
			<p>3.2If the following conditions occur, the form triggers the task to fail：</p>
			<table border="0" cellspacing="0" cellpadding="0" class="only_table edit_table">
				<thead>
				<tr>
					<th width="20%">Serial number</th><th>Trigger the cause of the failure</th>
				</tr>
				</thead>
				<tbody>
				<tr><td>1</td><td>The form repeats the line, and if there is a line that does not satisfy the check, all distributions fail to fail</td></tr>
				<tr><td>2</td><td>When the form is filled in, the title is empty</td></tr>
				<tr><td>3</td><td>When the form fill in the task start time is empty</td></tr>
				<tr><td>4</td><td>When the form completion time is empty</td></tr>
				<tr><td>5</td><td>Fill in the form when the person is empty</td></tr>
				<tr><td>6</td><td>When the form is filled in, the person in charge is empty</td></tr>
				<tr><td>7</td><td>Form fill in person, participant or inform more than 255 people</td></tr>
				</tbody>
			</table>
		</div>
	</div>
</div>
</body>
</html>
