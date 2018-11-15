<%--
/**
 * $Author: wangchw $
 * $Rev: 34307 $
 * $Date:: 2014-03-27 17:46:39#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
 --%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b">
<head>
<title><%-- 选择环形回退的节点 --%></title>
</head>
<body onkeydown="listenerKeyESC();" marginheight="0" marginwidth="0" class="h100b">
<jsp:include page="/WEB-INF/jsp/common/content/workflow.jsp" />
<div class="form_area">
	<div class="form_area_content" style="width:100%;" id="contentHtmlId">
	</div>
</div>
</body>
</html>
<script type="text/javascript">  

var circleNodes = "";
var context = "";
var isInSpecialStepBackStatus = "";
$(function(){
	var paramObjs= window.parentDialogObj['workflow_dialog_showCircleBackSelectDialog_Id'].getTransParams();
	circleNodes = paramObjs.circleNodes;
	context = paramObjs.contextParam;
	isInSpecialStepBackStatus = paramObjs.isInSpecialStepBackStatus;
	var checkNodeId = circleNodes.length > 1 ? circleNodes[0].nodeId : "";
	var checkSubmitStyle =  circleNodes.length > 1 ? circleNodes[0].submitStyle : "";
	var _html = "<br><div id=\"_flowDIV\">";
	_html +="<fieldset style=\"padding-bottom: 4px;\">";
	_html +=     "<legend id=\"workflow_circle_branch_people\">";
	_html +=         "<span style=\"color:black\">${ctp:i18n('workflow.commonpage.branchpeople.select')}</span>";
	_html +=     "</legend>";
	_html +=     "<table border=\"0\" id=\"workflow_select_subprocess\" border=\"0\" cellpadding=\"1\" cellspacing=\"3\" style=\"width:100%;\">";
	
	for(var i=0;i<circleNodes.length;i++){
		 _html +=         "<tr id=\"workflow_select_subprocess_template\">";
		 _html +=             "<td id=\"workflow_subprocess_checkbox\" nowrap=\"nowrap\" class=\"padding_5\">"
		 _html += 					"<input type='radio' name='circleRadio' onclick='changeRadio(\""+circleNodes[i].submitStyle+"\",\""+circleNodes[i].nodeId+"\")' submitStyle='"+circleNodes[i].submitStyle+"'"+( i==0 ? " checked='checked'":"")+" value='"+circleNodes[i].nodeId+"'/>";
		 _html += 			  " </td>";
		 _html +=             "<td id=\"workflow_subprocess_checkbox\" nowrap=\"nowrap\" class=\"padding_5\">"
		 _html += 					 circleNodes[i].nodeName+(circleNodes[i].nodeId == 'start' ? '': '['+circleNodes[i].nodePolicy+']');
		 _html += 			  " </td>";
		 _html +=             "<td id=\"workflow_subprocess_checkbox\" nowrap=\"nowrap\" class=\"padding_5\">"
		 _html += 					circleNodes[i].conditionTitle
		 _html += 			  " </td>";
		 _html +=         "</tr>";
	}
	


	_html += "</table>";
	_html += "<br/><br/>";
	if (circleNodes.length > 0) {
		_html += "<span class=\"font_size12\" >${ctp:i18n('workflow.special.stepback.label14')}&nbsp;&nbsp;:&nbsp;&nbsp;</span>";
		
		_html += "<span  id=\"submitStyle0\" ><input id=\"submitStyle0_input\" onclick=\"_submitStyleRadioClick('0')\" class=\"radio_com\" name=\"submitStyle\" value='0' checked='checked' type='radio'><span class='font_size12' >${ctp:i18n('workflow.special.stepback.label6')}</span></span>";
		
		
		_html += "&nbsp;&nbsp;&nbsp;&nbsp;<span  id=\"submitStyle1\" ><input id=\"submitStyle1_input\" onclick=\"_submitStyleRadioClick('1')\" class=\"radio_com\" name=\"submitStyle\" value='1'  type='radio'><span class='font_size12' >${ctp:i18n('workflow.special.stepback.label7')}</span></span>";
		
	}
	_html += "<br/><span id=\"spanTip\" class='font_size12' style='display:none'><span class='ico16 risk_16'/> <font color='red' id='wordTip'></font></span>"
	_html += "</fieldset>";
	_html += "</div>";

	$("#contentHtmlId").html(_html);
	if(checkSubmitStyle != "" && checkNodeId != ""){
		changeRadio(checkSubmitStyle,checkNodeId);
	}
	
	 //判断是否显示流程追述的按钮：区域可见 && 有流程重走的选项 && 流程重走被选中
    if($("#submitStyle0_input")[0] && $("#submitStyle0_input").attr("checked")){
    	var traceSpanArea = parent.document.getElementById("traceSpanArea");
        if(traceSpanArea){
        	traceSpanArea.setAttribute("style","display:block");
        }
    }
	
})


function _submitStyleRadioClick(v){
	var traceSpanArea = parent.document.getElementById("traceSpanArea");
	if(v == '1'){
		if(traceSpanArea){
			traceSpanArea.setAttribute("style","display:none");
        	var traceCheckBox = parent.document.getElementById("trackWorkflow");
    		
        	if(traceCheckBox && !traceCheckBox.disabled){

        		traceCheckBox.checked = false;
        	}
		}
	}
	else{
		if(traceSpanArea){
			traceSpanArea.setAttribute("style","display:block");
		}
	}
}

function changeRadio(submitStyle,targetNodeId){
	if (submitStyle.indexOf('0') == -1 ) {
		$("#submitStyle0").hide();
	}
	if (submitStyle.indexOf('1') == -1) {
		$("#submitStyle1").hide();
	}
	if (submitStyle.indexOf('0') >= 0 ) {
		$("#submitStyle0").show();
		$("#submitStyle0_input").attr("disabled",false);
	}
	if (submitStyle.indexOf('1') >= 0) {
		$("#submitStyle1").show();
		$("#submitStyle1_input").attr("disabled",false);
	}
	
	setDefaultCheck(submitStyle,targetNodeId);
}

function setDefaultCheck(submitStyle,targetNodeId){
	
	if (submitStyle.indexOf('0,1') >= 0) {
		$("#submitStyle0_input").attr("checked","checked");
	}else if(submitStyle.indexOf('0') >= 0){
		$("#submitStyle0_input").attr("checked","checked");
	}else if(submitStyle.indexOf('1') >= 0){
		$("#submitStyle1_input").attr("checked","checked");
	}
	
	var rs = wfAjax.validateCurrentSelectedNode(context["caseId"],
			targetNodeId, "", context["currentActivityId"],
			context["processXml"], context["currentAccountId"],
			"collaboration", context["processId"]);
	
	var isShowRed = false;
	if (rs[0] == 'true') {
		if (isInSpecialStepBackStatus == 'true') {
			if (rs[2] == 'true' || rs[8] == 'true') {
				
			}else{
				if (submitStyle.indexOf('0') >= 0 ) {
					$("#submitStyle0_input").attr("disabled",true);
					
				}
				if (submitStyle.indexOf('1') >= 0 ) {
					$("#submitStyle1_input").attr("checked","checked");
				}
				//多次指定回退狀態下，提交方式只允許選擇“直接提交给我”
				$("#wordTip").html($.i18n("workflow.special.circleback.alert8.tip.js"));
				isShowRed = true;
				$("#spanTip").show();
			}
			
		} else {
			if (rs[2] == 'true' || rs[8] == 'true') {
				//当前节点与回退节点间有分支条件或触发子流程节点，只能选择流程重走
				if (submitStyle.indexOf('0') >= 0 ) {
					$("#submitStyle0_input").attr("checked","checked");
				}
				if (submitStyle.indexOf('1') >= 0 ) {
					$("#submitStyle1_input").attr("disabled",true);
				}

				$("#wordTip").html($.i18n("workflow.special.circleback.alert12.tip.js"));
				isShowRed = true;
				$("#spanTip").show();
			}
		}
	}	
	if(!isShowRed){
		$("#spanTip").hide();
	}
	
	//设置流程追述的按钮是否可见	
	setWFTraceView();
	
}
//设置流程追述的按钮是否可见
function setWFTraceView(){
	var traceSpanArea = parent.document.getElementById("traceSpanArea");
    if(traceSpanArea){
    	if($("#submitStyle0_input")[0] && $("#submitStyle0_input").attr("checked")){
    		traceSpanArea.setAttribute("style","display:block");
    	}
    	else{
    		traceSpanArea.setAttribute("style","display:none");
        	var traceCheckBox = parent.document.getElementById("trackWorkflow");
    		
        	if(traceCheckBox && !traceCheckBox.disabled){

        		traceCheckBox.checked = false;
        	}
    	}
    }
}
function OK() {
	
	var __submitStyle = "";
    $('input:radio[name=submitStyle]:checked').each(function(i){
     if(0==i){
  	   	__submitStyle = $(this).val();
     }else{
  	   __submitStyle += (","+$(this).val());
     }
    });
   
	var v = $(":radio:checked").val();
	var returnValue = [];
	returnValue[0] = v;
	returnValue[1] = __submitStyle;
	
    //追述
    var _traceInput = parent.document.getElementById("trackWorkflow");
    var isTrace = 0;
    if(_traceInput){
    	isTrace = _traceInput.checked ? 1 : 0;
    }
    returnValue[2] = isTrace ;
	
	return returnValue;
}
</script>