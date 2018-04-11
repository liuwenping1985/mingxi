<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>createMember</title>
<script type="text/javascript">

var createMemberFillBackValue="";
var formId = "${formId}";
$().ready(function(){
});

function init(configValue){
	createMemberFillBackValue = configValue;
}

function OK(){
	return createMemberFillBackValue;
}

function createMemberFun(){
	if(createMemberFillBackValue==""){
		createMemberFillBackValue = $("#ConfigValue",parent.currentTr).val();
	}
	dialog = $.dialog({
		width:620,
		height:450,
		targetWindow:getCtpTop(),
		transParams:window,
		url:_ctxPath + "/form/formTriggerCreateMember.do?method=triggerFillMemberBack&formId="+formId+"&createMemberFillBackValue="+encodeURIComponent(createMemberFillBackValue),
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
		      createMemberFillBackValue = retValue[0];
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

</script>
</head>
<body class="page_color">
<table width="100%" border="0" cellpadding="2" cellspacing="0" height="100px;" style="background-color: 	#FFFFFF">
	<!-- 创建人员 数据拷贝设置 -->
	<tr>
		<td width="18%" align="right" nowrap="nowrap">
			<label  style="font-size:12px;font-family:Microsoft YaHei,SimSun,Arial,Helvetica,sans-serif"> <font color="red">*</font>${ctp:i18n('form.trigger.triggerSet.copyData.label')}：</label>
		</td>
		<td nowrap="nowrap">
			<a class="common_button common_button_gray margin_l_5" href="javascript:createMemberFun();">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
		</td>
	</tr>
</table>
</body>
</html>
