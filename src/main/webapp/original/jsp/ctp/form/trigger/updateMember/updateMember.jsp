<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>updateMember</title>
<script type="text/javascript">

var updateMemberFillBackValue="";
var formId = "${formId}";
//应用类型： 表单
var appName = "form";
var tableType = "main";
var updateMemberFieldStr = "";
$().ready(function(){
	if(updateMemberFieldStr == ""){
		getUpdateMemberFieldStr($("#ConfigValue",parent.currentTr).val());
	}
});

function getUpdateMemberFieldStr(v){
	if(v != ""){
		var oldFillBackValueArr = v.split(',');
		var o = oldFillBackValueArr[oldFillBackValueArr.length-1].split('|');
		//将设置的更新人员的表单字段放到第三个位置，作为标识  updateMember|field001|member|isUpdateField|姓名
		if(o.length == 5){
			var fbName = o[0];   //人员属性  name
			var updateMemberField = o[1];   //表单字段名称  field001
			var type = o[2];   //表单字段类型  member
			var isUpdateField = o[3];    //是否是对应更新的表单控件 isUpdateField
			var updateMemberFieldDisplay = o[4];    //表单控件中展示的名称。
			
			if(fbName == "updateMember" && type == "member" && isUpdateField == "isUpdateField"){
				updateMemberFieldStr = oldFillBackValueArr[oldFillBackValueArr.length-1];
				$("#updateMemberField").val(updateMemberField);
				$("#updateMemberFieldDisplay").val(updateMemberFieldDisplay);
			}
		}
	}
}

function init(configValue){
	updateMemberFillBackValue = configValue;
	
	if(updateMemberFillBackValue != ""){
		getUpdateMemberFieldStr(updateMemberFillBackValue);
	}
}

function OK(){
	return updateMemberFillBackValue;
}

function updateMemberFun(){
	if(updateMemberFillBackValue==""){
		updateMemberFillBackValue = $("#ConfigValue",parent.currentTr).val();
	}
	
	var updateMemberField = $("#updateMemberField").val();
	var updateMemberFieldDisplay = $("#updateMemberFieldDisplay").val();
	
 	if(updateMemberFieldStr == ""){
		$.alert("${ctp:i18n('form.trigger.triggerSet.updateMember.select')}");
		return;
	} 
	
	dialog = $.dialog({
		width:620,
		height:450,
		targetWindow:getCtpTop(),
		transParams:window,
		url:_ctxPath + "/form/formTriggerUpdateMember.do?method=triggerFillMemberBack&formId="+formId+"&updateMemberFillBackValue="+encodeURIComponent(updateMemberFillBackValue)+"&updateMemberField="+encodeURIComponent(updateMemberFieldStr),
	    title : $.i18n('form.trigger.triggerSet.copyData.label'),//数据拷贝设置
	    buttons : [{
	      text : $.i18n('common.button.ok.label'),
	      id:"creataMember",
		  isEmphasize: true,
	      handler : function() {
		      var retValue = dialog.getReturnValue();
		      if(retValue == false || retValue == "false"){
			      return;
		      }
		      updateMemberFillBackValue = retValue[0];
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

/* 
*绑定更新人员
*/
function bindFormField(inputId,fieldType,obj){
	if(inputId==='') return;
  	$.selectStructuredDocFileds({'appName':appName,'formAppId':formId,'fieldType':fieldType,'tableType':tableType,'onOk':onOk});
}

/**
 * 绑定元素后的返回方法
 */
function onOk(v){
	if(v && v.fieldDbName && v.fieldDisplayName){
		var fieldDbName = v.fieldDbName;
		var fieldDisplayName = v.fieldDisplayName;
		$("#updateMemberFieldDisplay").val(fieldDisplayName);
		$("#updateMemberField").val(fieldDbName);
		updateMemberFieldStr = "updateMember|"+fieldDbName+"|member|isUpdateField|"+fieldDisplayName;
	}
}

</script>
</head>
<body class="page_color">
<table width="100%" border="0" cellpadding="2" cellspacing="0" height="100px;" style="background-color: 	#FFFFFF">
	<!-- 创建人员 数据拷贝设置 -->
	<tr>
		<td width="18%" align="right" nowrap="nowrap">
			<label  style="font-size:12px;font-family:Microsoft YaHei,SimSun,Arial,Helvetica,sans-serif"> <font color="red">*</font>${ctp:i18n('form.trigger.triggerSet.updateMember')}：</label>
		</td>
		<td nowrap="nowrap">
			<input onclick="bindFormField('updateMember','member',this);" readonly="readonly" id="updateMemberFieldDisplay" style="width:270px;height:28px;border: 1px solid #e4e4e4;"  class="input-100per"/>
			<input id ="updateMemberField" type="hidden" value=""/>
		</td>
	</tr>
	
	<tr>
		<td width="18%" align="right" nowrap="nowrap">
			<label  style="font-size:12px;font-family:Microsoft YaHei,SimSun,Arial,Helvetica,sans-serif"> <font color="red">*</font>${ctp:i18n('form.trigger.triggerSet.copyData.label')}：</label>
		</td>
		<td nowrap="nowrap">
			<a class="common_button common_button_gray margin_l_5" href="javascript:updateMemberFun();">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
		</td>
	</tr>
</table>
</body>
</html>
