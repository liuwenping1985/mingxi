<%--
/**
 * $Author: zhoulj $
 * $Rev: 33356 $
 * $Date:: 2014-02-26 14:16:20#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
 --%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/common/workflow/workflowDesigner_ajax.js${ctp:resSuffix()}"></script>
<html>
<head>
<title>${ctp:i18n('selectPolicy.please.select')}</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body scroll="no">
	<div class="form_area">
		<div class="form_area_content" style="width:300px;height:100%;">
			<div class="one_row" style="width:250px;height:100%;">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
          		<!-- 手工分支可选条件  -->
				<tr id="hs_type_area2">
					<td align="left">&nbsp;</td>
				</tr>
				<tr id="hs_type_area2">
					<td align="left">&nbsp;</td>
				</tr>
				<tr id="hs_type_area2">
					<td align="left">&nbsp;</td>
				</tr>
				<tr id="hs_type_area2">
					<td id="hs_type_td" align="left" colspan="3"></td>
				</tr>
				<tr id="hs_type_area2">
					<td align="left">&nbsp;</td>
				</tr>
				<tr id="hs_type_area2">
					<td align="left">&nbsp;</td>
				</tr>
			</table>
			</div>
		</div>
	</div>
<script type="text/javascript">
var paramObjs= window.parentDialogObj['workflow_dialog_setWorkflowNodeProperty_Id'].getTransParams();
$(function(){
	if(paramObjs.hsbObj!=null){
		if(paramObjs.hsbObj.isHasHandCodition){
			$("#hs_type_td").html(paramObjs.hsbObj.optionStr);
		}
	}
});
function OK(){
	var hst = $("#hs_type_td select").val();
	var result = ["", "", "", "", "", "", "",
                  "", "", "","", "","","","",
                  "","","","",hst,"-1"];
	return result;
}
var wfAjax= new WFAjax();
</script>
</body>
</html>