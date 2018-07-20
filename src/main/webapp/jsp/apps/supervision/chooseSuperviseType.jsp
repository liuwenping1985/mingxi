<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" contect="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<title>请选择事项分类</title>
<c:set var="path" value="${pageContext.request.contextPath}" />
<link rel="stylesheet" href="${path}/apps_res/supervision/css/dialog.css">
</head>
<body style="height:30px;">
<input type="hidden" name="affairId" id="affairId" value="${param.affairId }"/>
<input type="hidden" name="summaryId" id="summaryId" value="${param.summaryId }"/>
<input type="hidden" name="isFrom" id="isFrom" value="${param.isFrom }"/>
</body>
</html>
<script type="text/javascript">
<!--
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
//-->
/*window.supTypeWin = getA8Top().$.dialog({
	id:'supTypeDialog',
    title:'选择事项分类',
    transParams:{'parentWin':window, "popWinName":"supTypeWin", "popCallbackFn":window.openNewCallback},
    url:  "${path}/supervision/supervisionController.do?method=categoryHome",
    targetWindow:getA8Top(),
    width:"350",
    height:"150"
});*/

function openNewCallback(type){
	if(type=='close'){
		window.close();
		return;
	}
	var url ="${path}/form/formData.do?method=newUnFlowFormData&_isModalDialog=true&contentAllId=0&isNew=true&viewId=0&formTemplateId=0&formId=0&moduleType=37&isSupervise=true&supType=" + type;
	var isFrom=$("#isFrom").val();
	if(isFrom!='' && isFrom=='govdoc'){
		//公文转督办
		var affairId=$("#affairId").val();
		var summaryId=$("#summaryId").val();
		url+="&affairId="+affairId+"&summaryId="+summaryId+"&isFrom=govdoc";
	}
	window.close();
	//window.location.href=url;
	openCtpWindow({
        "url" : url
    });
}

var url ="${path}/form/formData.do?method=newUnFlowFormData&_isModalDialog=true&contentAllId=0&isNew=true&viewId=0&formTemplateId=0&formId=0&moduleType=37&isSupervise=true&supType=0";
var isFrom=$("#isFrom").val();
if(isFrom!='' && isFrom=='govdoc'){
	//公文转督办
	var affairId=$("#affairId").val();
	var summaryId=$("#summaryId").val();
	url+="&affairId="+affairId+"&summaryId="+summaryId+"&isFrom=govdoc";
}
window.close();
openCtpWindow({
    "url" : url
});
</script>