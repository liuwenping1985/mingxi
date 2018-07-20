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
<script type="text/javascript">
function OK(){
	var retVal=$("input[name='option']:checked").val();
	return retVal;
}
</script>
<style type="text/css">
.disagree_title{ 
	text-align:left !important;
	margin-left:30px;
}
</style>
</head>
<body>
   <div class="align_center" id="disagreeDialogHtml" style="font-size: 12px; margin-top: 45px;">
        <!-- 您的态度是"不同意"，请选择流程操作 -->
	    <div class="disagree_title">${ctp:i18n('collaboration.disagreeDeal.alert.1')}</div><br><br>
	    <label for="radio1" class="margin_r_10 hand" id="label1" style="padding-right: 10px;">
            <!-- 继续 -->
	    	<input type="radio" value="continue" id="radio1" name="option" class="radio_com" checked/>${ctp:i18n('collaboration.state.15.continue')}
	    </label>
	    <label for="radio2" class="margin_r_10 hand ${param.stepBack}" id="label2" style="padding-right: 10px;">
            <!-- 回退 -->
	    	<input type="radio" value="stepBack" id="radio2" name="option" class="radio_com" <c:if test="${param.disableTB eq '1'}">disabled</c:if>/>${ctp:i18n('collaboration.state.6.stepback')}
	    </label>
	    <label for="radio3" class="margin_r_10 hand ${param.stepStop}" id="label3" style="padding-right: 10px;">
            <!-- 终止  -->
	    	<input type="radio" value="stepStop" id="radio3" name="option" class="radio_com"/>${ctp:i18n('collaboration.state.10.stepstop')} 
	    </label>
	    <label for="radio4" class="margin_r_10 hand ${param.repeal}" id="label4">
            <!-- 撤销 -->
	    	<input type="radio" value="repeal" id="radio4" name="option" class="radio_com"/>${ctp:i18n('collaboration.state.5.cancel')}
	    </label>
	</div>
</body>
</html>
