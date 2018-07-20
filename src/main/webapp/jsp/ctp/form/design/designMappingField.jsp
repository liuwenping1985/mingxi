<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/form/design/formDevelopmentOfadv.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
<script type="text/javascript" src="/seeyon/ajax.do?managerName=govdocExchangeManager,colManager"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">
</head>
<body>
<!-- add by chencm 2016-04-16 -->
<div class="top_div_row2 webfx-menu-bar" style="border-top:0;">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
    <td class="webfx-menu-bar">
        <form action="" name="searchForm" id="searchForm" method="post">
            <input type="hidden" value="<c:out value='${param.method}' />" name="method">
            <input type="hidden" value="11" name="conditionType" id="conditionType" />
            <input type="hidden" value="223" name="conditionValue" id="conditionValue" />
            <div class="div-float-right">
                <div class="div-float">
                    <select name="condition"
                        onChange="showConditionInput(this)" id="condition" class="condition" style="font-family: sans-serif">
                        <option value="">${ctp:i18n("common.option.selectCondition.text")}</option>
                        <option value="elementName" <c:if test="${conditionType == 'elementName'}">selected</c:if>>${ctp:i18n("edoc.element.elementName")}</option>
                        <option value="elementfieldName" <c:if test="${conditionType == 'elementfieldName'}">selected</c:if>>${ctp:i18n("edoc.element.elementfieldName")}</option>
                    </select>
                </div>
                <div id="elementNameDiv" class="div-float hidden">
                    <input type="text" id="elementName" class="textfield">
                </div>
                <div id="elementFieldNameDiv" class="div-float hidden">
                    <input type="text" id="elementFieldName" class="textfield">
                </div>
                <div onclick="javascript:doSearch()" class="condition-search-button"></div>
            </div>
        </form>
    </td>
</tr>
</table>
</div>
<!--end  add by chencm 2016-04-16 -->
  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table">
    <thead>
        <tr>
            <th width="20"></th>
            <th width="40%">元素代码</th>
            <th>元素名称</th>
        </tr>
    </thead>
    <tbody>
    <c:forEach var="vo" items="${lists }" varStatus="status">
        <tr <c:if test="${status.index % 2==0 }"> class="erow" </c:if> onclick="$('#codeRadio${status.index }').attr('checked',true);">
            <td><input id="codeRadio${status.index }" type="radio" value="${vo.code }" name="codeRadio" <c:if test="${param.fieldName == vo.code }">checked='checked'</c:if>/></td>
            <td>${vo.code }</td>
            <td>${vo.name}</td>
        </tr>
        </c:forEach>
    </tbody>
</table>
</body>
<script type="text/javascript">
<c:if test="${conditionType == 'elementName'}">
$("#elementNameDiv").attr("class","div-float");
$("#elementName").val('${conditionValue}');
</c:if>
<c:if test="${conditionType == 'elementfieldName'}">
$("#elementFieldNameDiv").attr("class","div-float");
$("#elementFieldName").val('${conditionValue}');
</c:if>
function OK(){
	return $("input:checked").val();
}
//add by chencm 2016-04-16
function doSearch(){
	var condition = $("#condition").val();
	$("#conditionType").val(condition);
	var selectedValue = "";
    if(condition == "elementName"){
    	selectedValue = $("#elementName").val();
    }else{
    	selectedValue = $("#elementFieldName").val();
    }
    $("#conditionValue").val(selectedValue);
	window.document.searchForm.action = _ctxPath + "/form/fieldDesign.do?method=designMappingField";
	window.document.searchForm.submit();
}
function showConditionInput(){
	var selectedValue = $("#condition").val();
	if(selectedValue == ""){//查询条件
		//隐藏
		$("#elementNameDiv").attr("class","div-float hidden");
		$("#elementFieldNameDiv").attr("class","div-float hidden");
	}else if(selectedValue == "elementName"){
		//显示
		$("#elementNameDiv").attr("class","div-float");
		$("#elementFieldNameDiv").attr("class","div-float hidden");
	}else{
		$("#elementFieldNameDiv").attr("class","div-float");
		$("#elementNameDiv").attr("class","div-float hidden");
	}
}
//end add by chencm

</script>
</html>