<%--
 $Author:  xiangq$
 $Rev:  280$
 $Date:: 2014-11-12 14:38:52#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>导入Excel</title>

<script type="text/javascript">
var proce = null;
function OK(obj) {
	var isValidate = validateForm();
	if (isValidate == true || isValidate == "true") {
		startProgressBar("数据导入中，请稍后...");
		submitForm();
		if (obj.dialogObj) {
			obj.dialogObj.hideBtn("ok");
			obj.dialogObj.hideBtn("cancel");
			obj.dialogObj.reSize({width:600,height:350});
		}
	}
}

/**
 * 启动进度条
 * 
 * @param meg 进度显示信息
 */
function startProgressBar(meg) {
    proce = $.progressBar({
        text : meg
    });
}

/**
 * 提交form表单
 */
function submitForm() {
	var actionUrl = _ctxPath + "/taskmanage/taskinfo.do?method=doImportExcel";
	$("#file_form").attr("action", actionUrl);
	$("#file_form").submit();
}

/**
 * 验证form表单
 */
function validateForm() {
	var isValidate = true;
	var filePath = $("#file_path").val();
	$("#file_path_text").val(filePath);
	if (filePath.length == 0) {
		$.alert("${ctp:i18n('choose_import_file')}");
		isValidate = false;
	} else {
		var fileSuffix = filePath.substring(filePath.lastIndexOf(".") + 1);
		if(fileSuffix.toLowerCase() != "xls" && fileSuffix.toLowerCase() != "xlsx") {
			$.alert("${ctp:i18n('taskmanage.import.choose.excel.warning')}");
			isValidate = false;
		}
	}
	return isValidate;
}
//     $(document).ready(function() {
//     });
</script>
</head>
<body class="page_color h100b">
    <div class="form_area h100b" id="file_info">
        <form id="file_form" name="file_form" method="post" enctype="multipart/form-data" class="h100b">
            <table border="0" cellspacing="0" cellpadding="0" width="100%" class="h100b" align="center">
            	<tr><td width="100%" valign="middle">
	            	<table id="domain_file_info" border="0" cellspacing="0" cellpadding="0" width="98%" height="90px" align="center">
	            		<tr>
	            			<td><label class="margin_r_5" for="text">${ctp:i18n('import.choose.file')}</label></td>
	            		</tr>
		                <tr>
		                    <td width="100%">
		                        <input type="hidden" id="file_path_text" name="file_path_text"/>
		                        <input id="file_path" name="file_path" type="file" style="width: 95%"/>
		                    </td>
		                </tr>
		                <tr><td>&nbsp;</td></tr>
	                </table>
                </td></tr>
            </table>
        </form>
    </div>
</body>
</html>