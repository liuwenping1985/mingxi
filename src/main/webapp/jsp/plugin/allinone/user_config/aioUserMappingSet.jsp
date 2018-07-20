<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/WEB-INF/jsp/common/common.jsp"%>
<link rel="stylesheet" type="text/css" href="${path}/common/css/default.css">
<link rel="stylesheet" type="text/css" href="${path}/apps_res/systemmanager/css/css.css">
<link rel="stylesheet" type="text/css" href="${path}/apps_res/collaboration/css/collaboration.css">
<link rel="stylesheet" type="text/css" href="${path}/common/css/default.css">
<html><head>
<script type="text/javascript">
<!--
var retFlag="${retFlag}";
var retMsg="${retMsg}";
$(document).ready(function() {
	if(parseInt(retFlag) == 0){
		showMsg(0,"保存成功！");
	}
	else if(parseInt(retFlag) == 1){
		showMsg(1,retMsg);
	}
    $("#btnAioSave").click(function() {
		if($.trim($("#aioSrv").val()) == ""){
			showMsg(1,"ALL-IN-ONE服务器未设置，请到参数设置中先设置地址！");
			return;
		}
		if($.trim($("#aioLoginName").val()) == ""){
			showMsg(1,"请输入绑定用户!");
			$("#aioLoginName:focus");
			return;
		}
    	$("#frmAioMapping").jsonSubmit({debug:false});
    });
});
function showMsg(imgType,msg){
	$.messageBox({
	    'title':'提示对话框',
        'type' : 0,
		'imgType':imgType,
        'msg' : msg
      });
}
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ALL-IN-ONE操作员设置</title>
</head>
<body>
<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'aio_person01'"></div>
<form id="frmAioMapping" name="frmAioMapping" method="post" action="/seeyon/u8AioUserMapping.do?method=aioSave">
	<table border="0" cellpadding="0" cellspacing="0" width="100%" height="90%" align="center">
			<tr >
				<td width="100%">
				<div style="padding:30px">
				<fieldset align="center"><legend><strong>绑定ALL-IN-ONE账号</strong></legend>
				<table width="30%" border="0" cellspacing="0" cellpadding="0"
					align="center">
					<tr>
						<td class="bg-gray" height="28" width="25%" nowrap="nowrap">
						<label for="name"> <font color="red">*</font>ALL-IN-ONE服务器:</label></td>
						<td class="new-column" width="75%">
							<input name="aioSrv" maxLength="20" maxSize="20" class="input-80per" type="text" id="aioSrv" value="${aioSrv}" readonly="readonly"/>						</td>
					</tr>
					<tr>
						<td class="bg-gray" height="28" width="25%" nowrap="nowrap"><label for="name"> <font color="red">*</font>绑定用户:</label></td>
						<td class="new-column" width="75%">
							<input name="aioLoginName" maxLength="20" maxSize="20" class="input-80per" type="text" id="aioLoginName" value="${aioLoginName}"/>						</td>
					</tr>
				<tr>
					<td height="42" align="center" class="tab-body-bg bg-advance-bottom" colspan=2>
						<a id="btnAioSave" class="common_button common_button_gray" href="javascript:void(0)">确定</a> </td>
				</tr>
		</table>
		</fieldset>
		</div>
		</td>
		</tr>
</table>
</form>
</body>
</html>