<%--
/**
 * $Author: zhoulj $
 * $Rev: 28394 $
 * $Date:: 2013-08-13 18:14:23#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
 --%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<title>${ctp:i18n('workflow.moreSign.findPerson')}</title>
<script type="text/javascript">
<!--
var methodName = "${methodName}";
function OK(){
	var result = [];
	var success = true;
	result.push(methodName);
    result.push("(");
	$("table tbody tr").each(function(index){
		if(index>0){
			result.push(",");
		}
		var tempThis = $(this);
		var type = tempThis.attr("type");
        var paramValue = null;
        var radio1 = tempThis.find("td:eq(2)").find(":radio"), radio2 = tempThis.find("td:eq(3)").find(":radio");
		if(radio1.size()>0 && radio1.prop("checked")==true){
			if(tempThis.find("#hand").val()==""){
				if("text"==type || "string"==type){
					
				}else{
					success = false;
					$.alert("请设置有效的参数值！");
					return false;
				}
			}
            paramValue = tempThis.find("#hand").val();
		}else if(radio2.size()>0 && radio2.prop("checked")==true){
			paramValue = tempThis.find("#formFieldSelect").val();
		}else{
			success = false;
            $.alert("请选择有效的参数值！");
            return false;
		}
		result.push(paramValue);
		tempThis = null;
	});
    result.push(")");
	if(!success){
		return "";
	}
	return result.join("");
}
$(function(){
	$("[id=handDiv]").click(function(){
		$(this).closest("td").next("td").find(":radio").prop("checked",false).attr("checked","");
		$(this).closest("td").find(":radio").prop("checked",true).attr("checked","checked");
	});
    $("[id=formFieldSelect]").click(function(){
        $(this).parent("td").prev("td").find(":radio").prop("checked",false).attr("checked","");
    	$(this).parent("td").find(":radio").prop("checked",true).attr("checked","checked");
    });
});

var targetInputId= "";
function bindFormField(inputId,appName,formAppId,fieldType){
	targetInputId= inputId;
	$.selectStructuredDocFileds({'appName':appName,'formAppId':formAppId,'fieldType':fieldType,'onOk':onOk,'showSystemVariables':true});
}

function onOk(v){
	if(v && v.fieldDbName && v.fieldDisplayName){
		var fieldDbName= v.fieldDbName;
		var fieldDisplayName= v.fieldDisplayName;
		$("#"+targetInputId).attr("value",fieldDbName);
		$("#"+targetInputId+"Name").attr("value",fieldDisplayName);
	}
}
//-->
</script>
</head>
<body style="overflow: auto">
<form name="selForm" target="inserPeopleIframe" method="post">
<div class="form_area  relative">
<table class="only_table edit_table" border="0" cellSpacing="0" cellPadding="0" width="100%">
     <thead>
        <tr>
            <th width="120px" >${ctp:i18n("workflow.customFunction.list.1") }</th>
            <th width="120px" >${ctp:i18n("workflow.customFunction.list.2") }</th>
            <th>${ctp:i18n("workflow.customFunction.list.3") }</th>
            <th>${ctp:i18n("workflow.customFunction.list.4") }</th>
        </tr>
     </thead>
     <tbody>
       <c:forEach var="funcParam" items="${functionParams}" varStatus="status">
       <tr type="${funcParam.type }">
          <td height="20px">${status.count } </td>
          <td height="20px">${funcParam.typeText } </td>
          <td nowrap="nowrap" id="handDiv">
              <label for="hand${status.count }" class="margin_t_5 hand display_inline">
              <input type="radio" value="1" id="hand${status.count }" name="option${status.count }" class="radio_com">:
              </label>
              <c:choose>
                  <c:when test="${funcParam.type=='text' || funcParam.type=='string' }">
                      <div style="width:70%;" id="type1Content" class="common_txtbox_wrap display_inline_block">
                          <input id="hand" value="" class="validate" validate="type:'string',name:'${ctp:i18n('workflow.formBranch.manualInput.vLabel') }',notNull:false,isDeaultValue:true,character:'~!@#$%^&*()_+=&#34;\'{}[]\\/?|:\'&#34;',maxLength:255">
                      </div></c:when>
                  <c:when test="${funcParam.type=='date' }">
                      <input style="width:70%;" id="hand" readonly="readonly" type="text"  class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d'"/></c:when>
                  <c:when test="${funcParam.type=='datetime' }">
                      <input style="width:70%;" id="hand" readonly="readonly" type="text"  class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true"/></c:when>
                  <c:when test="${funcParam.type=='member' }">
                      <input style="width:70%;" id="hand" type="text"  class="comp" comp="type:'selectPeople',panels:'Department,Team,Outworker',returnValueNeedType:false,selectType:'Member',maxSize:1,minSize:0,showMe:true,isNeedCheckLevelScope:false"/></c:when>
                  <c:when test="${funcParam.type=='account' }">
                      <input style="width:70%;" id="hand" type="text"  class="comp" comp="type:'selectPeople',panels:'Account',selectType:'Account',maxSize:1,minSize:0,showMe:true,returnValueNeedType:false,isNeedCheckLevelScope:false"/></c:when>
                  <c:when test="${funcParam.type=='department' }">
                      <input style="width:70%;" id="hand" type="text"  class="comp" comp="type:'selectPeople',panels:'Department',selectType:'Department',maxSize:1,minSize:0,showMe:true,returnValueNeedType:false,isConfirmExcludeSubDepartment:false,isNeedCheckLevelScope:false"/></c:when>
                  <c:when test="${funcParam.type=='post' }">
                      <input style="width:70%;" id="hand" type="text"  class="comp" comp="type:'selectPeople',panels:'Post',selectType:'Post',maxSize:1,minSize:0,showMe:true,returnValueNeedType:false,callback:selectPeopleCallback,isNeedCheckLevelScope:false"/></c:when>
                  <c:when test="${funcParam.type=='level' }">
                      <input style="width:70%;" id="hand" type="text"  class="comp" comp="type:'selectPeople',panels:'Level',selectType:'Level',maxSize:1,minSize:0,showMe:true,returnValueNeedType:false,callback:selectPeopleCallback,isNeedCheckLevelScope:false"/></c:when>
                  <c:when test="${funcParam.type=='int' }">
                      <input style="width:70%;" id="hand" type="text"  class="comp" comp="type:'onlyNumber',numberType:'int'"/></c:when>
                  <c:when test="${funcParam.type=='number' }">
                      <input style="width:70%;" id="hand" type="text"  class="comp" comp="type:'onlyNumber',numberType:'float'"/></c:when>
              </c:choose>
          </td>
          <td nowrap="nowrap">
          	  <input name="hand001" id="hand${status.count }" type="hidden" value=""/>
          	  <input style="width:70%;" name="hand001Name" id="hand${status.count }Name" type="text" readonly="readonly" onclick="bindFormField('hand${status.count }','${appName }','${formAppId }','text,checkbox,radio');" />
          </td>
    </tr>
    </c:forEach>
    </tbody>
</table>
</div>
</form>
</body>
</html>