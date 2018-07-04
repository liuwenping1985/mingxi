<%--
 $Author:  zhangxiangwei$
 $Rev:  $
 $Date:: 2012-12-07#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>不同意处理页面</title>
<style type="text/css">
.disagree_title{ 
	text-align:left !important;
	margin-left:30px;
}
</style>
<script type="text/javascript">
$(function(){
	var isOptional = "${param.isOptional}";
	var optionalActions = "${param.optionalAction}";
	var defaultAction = "${param.defaultAction}";
	//用户可选择
	//Continue,Terminate,Return,Cancel
	if (isOptional == "1") {
       	if (optionalActions != "") {
       		var optionals = optionalActions.split(",");
       		for(var i=0;i<optionals.length;i++) {
       			showAction(optionals[i]);
       		}
		} else {
			showAction(defaultAction);
		}
	} else {
		showAction(defaultAction);
	}
	$("input[name='option'][id='"+defaultAction+"']").attr("checked","checked");
});
function showAction(optionalAction) {
	var stepBack =  "${param.stepBack}";
	var stepStop = "${param.stepStop}";
	var repeal = "${param.repeal}";
	if (optionalAction == "Continue") {
			$("#label1").show();
		}
		//终止
		if (optionalAction == "Terminate" && stepStop != "hidden"){
			$("#label3").show();
		}
		//回退
		if (optionalAction == "Return" && stepBack != "hidden"){
			$("#label2").show();
		}
		//撤销
		if (optionalAction == "Cancel" && repeal != "hidden"){
			$("#label4").show();
		}
}

function OK(){
	var retVal=$("input[name='option']:checked").val();
	return retVal;
}
</script>
</head>
<body>
   <div class="align_center" id="disagreeDialogHtml" style="font-size: 12px; margin-top: margin-top: 45px;">
        <!-- 您的态度是"不同意"，请选择流程操作 -->
	    <div class="disagree_title">${ctp:i18n('collaboration.disagreeDeal.alert.1')}</div><br><br>
	    <label for="Continue" class="margin_r_10 hand hidden" id="label1" style="padding-right: 10px;">
            <!-- 继续 -->
	    	<input type="radio" value="continue" id="Continue" name="option" class="radio_com"/>${ctp:i18n('collaboration.state.15.continue')}
	    </label>
	    <label for="Return" class="margin_r_10 hand hidden" id="label2" style="padding-right: 10px;">
            <!-- 回退 -->
	    	<input type="radio" value="stepBack" id="Return" name="option" class="radio_com" <c:if test="${param.disableTB eq '1'}">disabled</c:if>/>${ctp:i18n('permission.operation.Return')}
	    </label>
	    <label for="Terminate" class="margin_r_10 hand hidden" id="label3" style="padding-right: 10px;">
            <!-- 终止  -->
	    	<input type="radio" value="stepStop" id="Terminate" name="option" class="radio_com"/>${ctp:i18n('permission.operation.Terminate')}
	    </label>
	    <label for="Cancel" class="margin_r_10 hand hidden" id="label4">
            <!-- 撤销 -->
	    	<input type="radio" value="repeal" id="Cancel" name="option" class="radio_com"/>${ctp:i18n('permission.operation.Cancel')}
	    </label>
	</div>
</body>
</html>
