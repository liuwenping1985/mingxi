<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/ctp/form/formreport/form/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/form/common/common.js.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script>
$(function(){
//获取父窗口参数
var parentParams = window.parentDialogObj["frOpenDialog"].getTransParams();
var formInput = "";
if(parentParams.reportid != null){
	formInput = formInput + "<input type='hidden' name='reportid' value='"+parentParams.reportid+"'/>";
}
if(parentParams.reportSaveId != null){
	formInput = formInput + "<input type='hidden' name='reportSaveId' value='"+parentParams.reportSaveId+"'/>";
}
if(parentParams.title != null){
	formInput = formInput + "<input type='hidden' name='title' value='"+parentParams.title+"'/>";
}
if(parentParams.mapinfo != null){
	formInput = formInput + "<input type='hidden' name='mapinfo' value='"+parentParams.mapinfo+"'/>";
}
if(parentParams.formType != null){
	formInput = formInput + "<input type='hidden' name='formType' value='"+parentParams.formType+"'/>";
}
if(parentParams.userCondition != null){
	formInput = formInput + "<input type='hidden' name='userCondition' value='"+parentParams.userCondition+"'/>";
}
if(parentParams.userFastCondition != null){
	formInput = formInput + "<input type='hidden' name='userFastCondition' value='"+parentParams.userFastCondition+"'/>";
}
if(parentParams.stateCon != null){
	formInput = formInput + "<input type='hidden' name='stateCon' value='"+parentParams.stateCon+"'/>";
}
$("#formId").append(formInput);
$("#formId").attr("action",_ctxPath+"/report/queryReport.do?method=openShowReportQuery&formMasterId=${ctp:escapeJavascript(formMasterId)}");
$("#formId").submit();
})
</script>
</head>
<body>
<form id="formId" action="" method="post">
</form>
</body>
</html>
