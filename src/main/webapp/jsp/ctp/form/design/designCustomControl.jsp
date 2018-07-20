<%--
 $Author: dengxj $
 $Rev: 603 $
 $Date:: 2014-01-12
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>表单自定义控件</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=formFieldCustomExtendManager"></script>
</head>
<body>
	<div class="form_area align_center" style="position:absolute; bottom:35px; top:0; width:100%;left:0;">
	<form id="tableForm" class="align_center" method="post">
		<c:choose>
		<c:when test="${empty allCustomExtend}">
		<span class="required" >${ctp:i18n('form.input.extend.customcontrol.error.span')}</span>
   		</c:when>
   		<c:otherwise>
   			<span>${ctp:i18n('form.input.extend.customcontrol.name.span')}：<select id="select" name="select" style="width:200px">
			<c:forEach items="${allCustomExtend}" var="extend">
			<option value ="${extend.key}" <c:if test="${fieldExtend.key eq extend.key}">selected="selected"</c:if> >${extend.value.name}</option>
			</c:forEach>
			</select>
			</span>
			<br/><br/>
			<span>
			自定义条件：
			<input id="extendParam" name="extendParam" value="${fieldExtend.extendParam}"/>
			</span>
   		</c:otherwise>
  		</c:choose>
		<input id="fieldName" name="fieldName" value="${fieldExtend.fieldName}" type="hidden"/>
		<%--
	    <input id="id" name="id" value="${fieldExtend.id}"  type="hidden" >
	    <input id="name" name="name" value="${fieldExtend.name}"  type="hidden" >
	    <input id="imageUrl" name="imageUrl" value="${fieldExtend.imageUrl}" type="hidden" >
	    <input id="clickUrl" name="clickUrl" value="${fieldExtend.clickUrl}" type="hidden" >
	    <input id="valueType" name="valueType" value="text" type="hidden" >
		<input id="windowWidth" name="windowWidth" value="${fieldExtend.windowWidth}" type="hidden" >
	    <input id="windowHeight" name="windowHeight" value="${fieldExtend.windowHeight}" type="hidden" >
		--%>
	</form>
    </div>
	<%@ include file="../common/common.js.jsp" %>
</body>
<script type="text/javascript">
	function OK(){
		if($("#select").length>0){//存在数据时
			var fieldCustom = new formFieldCustomExtendManager();
			fieldCustom.saveOrUpdateCustomControl($("body").formobj());
			return $("#select option:selected").text();
		}else{//不存在数据也返回
			return null;
		}
	}
</script>
</HTML>