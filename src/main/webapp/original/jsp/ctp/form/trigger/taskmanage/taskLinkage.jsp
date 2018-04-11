<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>createTask</title>
<script type="text/javascript">

var taskLinkageBackValue="";
var formId = "${formId}";
// $().ready(function(){
//  	taskLinkageBackValue = $("#ConfigValue",parent.document).val();
// 	if(parent.currentTr != undefined){
// 		taskLinkageBackValue = parent.currentTr.find("#ConfigValue").val();
// 	}
// });
function init(configValue){
	taskLinkageBackValue = configValue;
}

function OK(){
	return taskLinkageBackValue;
}

function taskLinkageFun(){
	var goLinkageValue = "";
	var backLinkageValue = "";
	var bidirectional = "";
	if($.isNull(taskLinkageBackValue)){
		taskLinkageBackValue = $("#ConfigValue",parent.currentTr).val();
	}
	if(taskLinkageBackValue != ""){
		var taskBackVal = $.parseJSON(taskLinkageBackValue);
		goLinkageValue = encodeURIComponent($.toJSON(taskBackVal.goTask));
		backLinkageValue = (null == taskBackVal.backTask ||　taskBackVal.backTask.length == 0) ? "" : encodeURIComponent($.toJSON(taskBackVal.backTask));
		bidirectional = $.isNull(taskBackVal.bidirectional) ? "" : taskBackVal.bidirectional;
	}
	dialog = $.dialog({
		width:620,
		height:450,
		targetWindow:getCtpTop(),
		transParams:window,
		url:_ctxPath + "/form/formTriggerCreateTask.do?method=triggerTaskLinkageBack&formId="+formId+"&goLinkageValue="+goLinkageValue+"&backLinkageValue="+backLinkageValue+"&bidirectional="+bidirectional,
	    title : $.i18n('taskmanage.trigger.linkage.settings'),//$.i18n('任务联动设置'),//任务联动设置
	    buttons : [{
	      text : $.i18n('common.button.ok.label'),
	      id:"taskLinkage",
		  isEmphasize: true,
	      handler : function() {
		      var retValue = dialog.getReturnValue();
		      if(retValue == false || retValue == "false"){
			      return;
		      }
		      taskLinkageBackValue = retValue;
	    	  dialog.close();
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
	dialog = $.dialog({
		width:620,
		height:450,
		targetWindow:getCtpTop(),
		transParams:window,
		html:$("#help_common").html(),
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
		<td width="22%" align="right" nowrap="nowrap">
			<label  style="font-size:12px;font-family:Microsoft YaHei,SimSun,Arial,Helvetica,sans-serif"> <font color="red">*</font>${ctp:i18n('taskmanage.trigger.linkage.settings')}：</label>
		</td>
		<td width="60" nowrap="nowrap">
			<a class="common_button common_button_gray margin_l_5" href="javascript:taskLinkageFun();">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
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
	.help_com .title0{font-weight: bold;}
	.help_com .title1{margin-top:15px;font-weight: bold;}
	.help_com .title2{margin-top:25px;margin-bottom:15px;font-weight: bold;}
	.help_com table{margin-top:15px;margin-bottom:15px;width:565px;}
	.help_com tr{height:30px;}
	.help_com tr th{text-align: center;}
	.help_com tr td{text-align: center;}
</style>
	<div class="align_center help_title">${ctp:i18n("taskmanage.trigger.help.text67") }</div>
	<div class="help_com">
		<div class="title1"><span>1.	${ctp:i18n("taskmanage.trigger.help.text2") }</span></div>
	    <table border="0" cellspacing="0" cellpadding="0" class="only_table edit_table">
		    <thead>
		        <tr>
		            <th width="40%">${ctp:i18n("taskmanage.trigger.help.text3") }</th><th>${ctp:i18n("taskmanage.trigger.help.text4") }</th>
		        </tr>
		    </thead>
		    <tbody>
		        <tr><td>${ctp:i18n("taskmanage.detail.creator.label") }</td><td>${ctp:i18n("taskmanage.trigger.help.text5") }</td></tr>
		        <tr><td>${ctp:i18n("taskmanage.subject.label") }</td><td>${ctp:i18n("taskmanage.trigger.help.text6") }</td></tr>
		        <tr><td>${ctp:i18n("taskmanage.starttime") }</td><td>${ctp:i18n("taskmanage.trigger.help.text7") }</td></tr>
		        <tr><td>${ctp:i18n("taskmanage.endtime") }</td><td>${ctp:i18n("taskmanage.trigger.help.text7") }</td></tr>
		        <tr><td>${ctp:i18n("taskmanage.manager") }</td><td>${ctp:i18n("taskmanage.trigger.help.text8") }</td></tr>
		        <tr><td>${ctp:i18n("taskmanage.participator") }</td><td>${ctp:i18n("taskmanage.trigger.help.text8") }</td></tr>
		        <tr><td>${ctp:i18n("taskmanage.detail.tell.label") }</td><td>${ctp:i18n("taskmanage.trigger.help.text8") }</td></tr>
		        <tr><td>${ctp:i18n("taskmanage.description.js") }</td><td>${ctp:i18n("taskmanage.trigger.help.text9") }</td></tr>
		        <tr><td>${ctp:i18n("taskmanage.detail.importantLevel.label") }</td><td>${ctp:i18n("taskmanage.trigger.help.text10") }</td></tr>
		        <tr><td>${ctp:i18n("taskmanage.mark.milestone.label") }</td><td>${ctp:i18n("taskmanage.trigger.help.text11") }</td></tr>
		        <tr><td>${ctp:i18n("taskmanage.detail.project.label") }</td><td>${ctp:i18n("taskmanage.trigger.help.text12") }</td></tr>
		        <tr><td>${ctp:i18n("taskmanage.trigger.attachment") }</td><td>${ctp:i18n("taskmanage.trigger.help.text13") }</td></tr>
		        <tr><td>${ctp:i18n("taskmanage.trigger.document") }</td><td>${ctp:i18n("taskmanage.trigger.document") }</td></tr>
		    </tbody>
		</table>
		<div class="title2"><span>2.	${ctp:i18n("taskmanage.trigger.help.text14") }</span></div>
		<div class="font_size12">
			<p>2.1	${ctp:i18n("taskmanage.trigger.help.text15") }</p>
			<p>2.2	${ctp:i18n("taskmanage.trigger.help.text16") }</p>
			<p>2.3	${ctp:i18n("taskmanage.trigger.help.text17") }</p>
			<p>2.4	${ctp:i18n("taskmanage.trigger.help.text18") }</p>
		</div>
		<div class="title2"><span>3.	${ctp:i18n("taskmanage.trigger.help.text19") }</span></div>
		<div class="font_size12">
			<p>3.1${ctp:i18n("taskmanage.trigger.help.text20") }</p>
			<table border="0" cellspacing="0" cellpadding="0" class="only_table edit_table">
			    <thead>
			        <tr>
			            <th width="40%">${ctp:i18n("taskmanage.trigger.help.text21") }</th><th>${ctp:i18n("taskmanage.trigger.help.text22") }</th>
			        </tr>
			    </thead>
			    <tbody>
			        <tr><td>${ctp:i18n("taskmanage.trigger.help.text23") }</td><td>${ctp:i18n("taskmanage.trigger.help.text24") }</td></tr>
			        <tr><td>${ctp:i18n("taskmanage.trigger.help.text25") }</td><td style="text-align: left;">
			        							${ctp:i18n("taskmanage.trigger.help.text26") }
			        <tr><td>${ctp:i18n("taskmanage.trigger.help.text27") }</td><td>${ctp:i18n("taskmanage.trigger.help.text28") }</td></tr>
			        <tr><td>${ctp:i18n("taskmanage.trigger.help.text29") }</td><td>${ctp:i18n("taskmanage.trigger.help.text30") }</td></tr>
			        <tr><td>${ctp:i18n("taskmanage.trigger.help.text31") }</td><td rowspan="3">${ctp:i18n("taskmanage.trigger.help.text32") }</td></tr>
			        <tr><td>${ctp:i18n("taskmanage.trigger.help.text33") }	</td></tr>
			        <tr><td>${ctp:i18n("taskmanage.trigger.help.text34") }</td></tr>
			    </tbody>
			</table>
			<p>3.2${ctp:i18n("taskmanage.trigger.help.text35") }</p>
			<table border="0" cellspacing="0" cellpadding="0" class="only_table edit_table">
			    <thead>
			        <tr>
			            <th width="20%">${ctp:i18n("taskmanage.trigger.help.text36") }</th><th>${ctp:i18n("taskmanage.trigger.help.text37") }</th>
			        </tr>
			    </thead>
			    <tbody>
			    	<tr><td>1</td><td>${ctp:i18n("taskmanage.trigger.help.text38") }</td></tr>
			    	<tr><td>2</td><td>${ctp:i18n("taskmanage.trigger.help.text39") }</td></tr>
			    	<tr><td>3</td><td>${ctp:i18n("taskmanage.trigger.help.text40") }</td></tr>
			    	<tr><td>4</td><td>${ctp:i18n("taskmanage.trigger.help.text41") }</td></tr>
			    	<tr><td>5</td><td>${ctp:i18n("taskmanage.trigger.help.text42") }</td></tr>
			    	<tr><td>6</td><td>${ctp:i18n("taskmanage.trigger.help.text43") }</td></tr>
			    	<tr><td>7</td><td>${ctp:i18n("taskmanage.trigger.help.text44") }</td></tr>
			    </tbody>
			</table>
		</div>
	</div>
	<div class="help_com">
		<div class="title0"><span class="margin_l_10">${ctp:i18n("taskmanage.trigger.help.text45") }</span></div>
		<div class="title1"><span>1.	${ctp:i18n("taskmanage.trigger.help.text46") }</span></div>
	    <table border="0" cellspacing="0" cellpadding="0" class="only_table edit_table">
		    <thead>
		        <tr>
		            <th width="40%">${ctp:i18n("taskmanage.trigger.help.text3") }</th><th>${ctp:i18n("taskmanage.trigger.help.text4") }</th>
		        </tr>
		    </thead>
		    <tbody>
		        <tr><td>${ctp:i18n("taskmanage.status.label") }</td><td>${ctp:i18n("taskmanage.trigger.help.text47") }</td></tr>
		        <tr><td>${ctp:i18n("taskmanage.finishrate") }</td><td>${ctp:i18n("taskmanage.trigger.help.text48") }</td></tr>
		        <tr><td>${ctp:i18n("taskmanage.risk") }</td><td>${ctp:i18n("taskmanage.trigger.help.text49") }</td></tr>
		        <tr><td>${ctp:i18n("taskmanage.elapsedTime") }</td><td>${ctp:i18n("taskmanage.trigger.help.text50") }</td></tr>
		        <tr><td>${ctp:i18n("taskmanage.trigger.help.text51") }</td><td>${ctp:i18n("taskmanage.trigger.help.text52") }</td></tr>
		        <tr><td>${ctp:i18n("taskmanage.trigger.help.text53") }</td><td>${ctp:i18n("taskmanage.trigger.help.text54") }</td></tr>
		        <tr><td>${ctp:i18n("taskmanage.trigger.help.text55") }</td><td>${ctp:i18n("taskmanage.trigger.document") }</td></tr>
		    </tbody>
		</table>
		<div class="title2"><span>2.	${ctp:i18n("taskmanage.trigger.help.text14") }</span></div>
		<div class="font_size12">
			<p>2.1	${ctp:i18n("taskmanage.trigger.help.text56") }
			</p>
			<p>2.2	${ctp:i18n("taskmanage.trigger.help.text57") }</p>
			<p>2.3	${ctp:i18n("taskmanage.trigger.help.text58") }</p>
		</div>
		<div class="title2"><span>3.	${ctp:i18n("taskmanage.trigger.help.text19") }</span></div>
		<div class="font_size12">
			<p>3.1${ctp:i18n("taskmanage.trigger.help.text59") }</p>
			<table width="90%" border="0" cellspacing="0" cellpadding="0" class="only_table edit_table">
			    <thead>
			        <tr>
			            <th width="40%">${ctp:i18n("taskmanage.trigger.help.text21") }</th><th>${ctp:i18n("taskmanage.trigger.help.text22") }</th>
			        </tr>
			    </thead>
			    <tbody>
			        <tr><td>${ctp:i18n("taskmanage.trigger.help.text60") }</td><td>${ctp:i18n("taskmanage.trigger.help.text61") }</td></tr>
			        <tr><td>${ctp:i18n("taskmanage.trigger.help.text62") }</td><td>${ctp:i18n("taskmanage.trigger.help.text63") }</td></tr>
			    </tbody>
			</table>
			<p>3.2${ctp:i18n("taskmanage.trigger.help.text64") }</p>
			<table width="90%" border="0" cellspacing="0" cellpadding="0" class="only_table edit_table">
			    <thead>
			        <tr>
			            <th width="20%">${ctp:i18n("taskmanage.trigger.help.text36") }</th><th>${ctp:i18n("taskmanage.trigger.help.text37") }</th>
			        </tr>
			    </thead>
			    <tbody>
			    	<tr><td>1</td><td>${ctp:i18n("taskmanage.trigger.help.text65") }</td></tr>
			    	<tr><td>2</td><td>${ctp:i18n("taskmanage.trigger.help.text66") }</td></tr>
			    </tbody>
			</table>
		</div>
	</div>
</div>
</body>
</html>


