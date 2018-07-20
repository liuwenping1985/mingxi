<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>form</title>
<script type="text/javascript">
	function OK() {
		var result = "";
		var defaultOperateViewId = $("#defaultOperate").val();
		$("input:not(.showContentFlag)[type='checkbox']:checked").each(function() {
			if (result != "") {
				result += "|";
			}
			result += $(this).val() + "." + document.getElementById($(this).val() + "select").value;
			if($(this).val() == defaultOperateViewId){
				result += ".isDefault";
			}
		});
		var showContent = $("#showContentFlag");
		var showContentFlag;
		if(showContent.attr("checked") == "checked"){
			result += "@true";
		}else{
			result += "@false";
		}
		return result;
	}
	function bindOperate(obj){
		var obj = $("#defaultOperate").find("option:selected");
		$(".viewCheckbox").removeAttr("disabled","");
		$(".operateSelect").removeAttr("disabled","");
		$("#" + $(obj).attr("operateId")).prop("selected","selected");
		$("#" + $(obj).val() + "select").prop("disabled","disabled");
		$(".viewCheckbox").each(function(){
			if($(this).val() == $(obj).val() || $(this).val() == "on"){
				$("#" + $(obj).val() + "checkbox").prop("checked","checked");
				$("#" + $(obj).val() + "checkbox").prop("disabled","disabled");
			}else{
				$(this).removeAttr("checked");
			}
		});
		
		$(".operateOption").each(function(){
			if($(this).parent().attr("id") == ($(obj).val() + "select")){
				return;
			}else if($(this).attr("type") == "readonly"){
				$(this).prop("selected","selected");
			}else{
				$(this).prop("disabled","disabled");
			}
		});
	}
</script>
</head>
<body class="page_color">
<!-- disabled='disabled' -->
	<div style="margin: 20px auto; padding-left: 20px; font-size: 12px">
		<span>绑定操作</span>
		<select id="defaultOperate" style="width: 200px; margin-left: 10px" onchange="bindOperate(this)">
			<c:forEach var="view" items="${viewList }">
				<c:forEach var="operate" items="${view.operations }">
					<option value="${view.id }" operateId=${operate.id } <c:if test="${view.id == defaultViewId && operate.id == defalutRightId }">selected="selected"</c:if>>${view.formViewName }.${operate.name }</option>
				</c:forEach>
			</c:forEach>
		</select>
	</div>
	

	<table>
		<c:forEach var="view" items="${viewList }" varStatus="status">
			<tr>
				<td style="padding-left: 20px; font-size: 12px"><input id="${view.id }checkbox" class="viewCheckbox" type="checkbox" value="${view.id }" <c:if test="${fn:contains(views, view.id)}">checked='checked'</c:if><c:if test="${view.id == defaultViewId}">disabled="disabled"</c:if>/>${view.formViewName }</td>
				<td style="padding-left: 10px"><select style="width: 200px" class="operateSelect" id="${view.id }select" <c:if test="${view.id == defaultViewId}">disabled="disabled"</c:if>>
						<c:forEach var="operate" items="${view.operations }">
							<option id="${operate.id }" class="operateOption" value="${operate.id }" type="${operate.type }" <c:if test="${fn:contains(rights, operate.id) || operate.id == defalutRightId}">selected='selected'</c:if><c:if test="${view.id != defaultViewId && operate.type != 'readonly'}">disabled</c:if>>${operate.name }</option>
						</c:forEach>
				</select></td>
			</tr>
		</c:forEach>
		<tr>
				<td style="padding-left: 20px; font-size: 12px"><input class="viewCheckbox showContentFlag" id="showContentFlag" type="checkbox"  <c:if test="${showContentInfo eq 'true'}">checked='checked'</c:if>/>${ctp:i18n('govdoc.content.label')}</td>
				<td style="padding-left: 10px"><select style="width: 200px" class="operateSelect"  disabled="disabled">
					<option class="operateOption">${ctp:i18n('govdoc.show.label')}</option>
				</select></td>
		</tr>
	</table>
</body>
</html>
