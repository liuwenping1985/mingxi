<%--
 $Author: dengxj $
 $Rev: 603 $
 $Date:: 2014-06-10

 Copyright (C) 2014 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html style="width: 100%;height: 100%;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>数据关联HR重定向</title>
</head>
<body style="width: 100%;height: 100%">
<div>
	<span>请选择人员属性：</span>
	<select id="hrselect" style="width:100px;">
		<c:forEach items="${viewAttrValueList}" var="viewAttrVal">
		<option fieldType="${viewAttrVal.fieldType}" value="${viewAttrVal.key}" title="${viewAttrVal.text}" >${viewAttrVal.text}</option>
		</c:forEach>
	</select>
</div>

<script>
var fieldType = "${fieldType}";
function OK(){
	var selFieldType = $("#hrselect").find("option:selected").attr("fieldType");
	if(fieldType != selFieldType){
		$.alert("字段类型不一致，请重新选择！");
		return false;
	}
	var object = new Object();
	object.value = $("#hrselect").find("option:selected").val();
	object.text = $("#hrselect").find("option:selected").text();
	return object;
}
</script>
</body>
</html>