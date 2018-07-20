<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<link rel="stylesheet" type="text/css" href="${path}/apps_res/govdoc/css/govdocPendingMain.css">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<body>
<div class="dialog_style">
	<fieldset style="border:1px solid #ccc">
		<legend>
			<label for="App_Col">
				<span class="padding_l_5">${ctp:i18n('edoc.listConfig.defaultCategory.label')}</span>
			</label>
		</legend>
		<table width="100%" style="border-spacing: 5px;" class="table_column category_default">
			<tr>
				<c:forEach var="list" items="${govdocPendingAll}" varStatus="status">
				<c:if test="${list eq 1 && status.index==0}">
				<td>
					<label for=""><input type="checkbox" checked="checked" disabled="disabled"><span class="padding_l_5">全部</span></label>
				</td>
				</c:if>
				<c:if test="${list eq 1 && status.index==1}">
				<td>
					<label for=""><input type="checkbox" onclick="changeCheck()"  checked="checked" id="check_do"  name="${ctp:i18n('edoc.stat.result.list.pending')}"><span class="padding_l_5">${ctp:i18n('edoc.stat.result.list.pending')}</span></label>
				</td>
				</c:if>
				<c:if test="${list eq 0 && status.index==1}">
				<td>
					<label for=""><input type="checkbox" onclick="changeCheck()"   id="check_do"  name="${ctp:i18n('edoc.stat.result.list.pending')}"><span class="padding_l_5">${ctp:i18n('edoc.stat.result.list.pending')}</span></label>
				</td>
				</c:if>
				<c:if test="${list eq 1 && status.index==2}">
				<td>
					<label for=""><input type="checkbox" onclick="changeCheck()"  checked="checked" id="check_read" name="${ctp:i18n('edoc.element.receive.reading')}"><span class="padding_l_5">${ctp:i18n('edoc.element.receive.reading')}</span></label>
				</td>
				</c:if>
				<c:if test="${list eq 0 && status.index==2}">
				<td>
					<label for=""><input type="checkbox" onclick="changeCheck()"  id="check_read" name="${ctp:i18n('edoc.element.receive.reading')}"><span class="padding_l_5">${ctp:i18n('edoc.element.receive.reading')}</span></label>
				</td>
				</c:if>
				</c:forEach>
			</tr>
		</table>
	</fieldset>
	<form id="permissionForm"  method="post" action="${path}/govDoc/govDocController.do?method=savePermission&ListType=1">
	<div class="assortment">
		<label>${ctp:i18n('edoc.listConfig.newCategory.label')}  : </label>
		<input type="text" id="name" name="name">
		<input type="hidden" id="permissions" name="permissions">
		<input type="hidden" id="govdocpending_permissions" name="govdocpending_permissions">
		<input type="hidden" id="govdocpending_name" name="govdocpending_name">
	</div>
	</form> 
	<div class="assortment_method">
		<p><span class="span1">${ctp:i18n('edoc.custom.sort')} :</span><span class="span2">${ctp:i18n('edoc.form.flowperm.name.label')}</span></p>
	</div>
	<table width="100%" style="border-spacing: 5px;" class="table_style1">

		<tr>
			<c:forEach var="permission" items="${permission}" varStatus="status">
			<td>
				<label for=""><input type="checkbox" name="${permission.flowPermId}" class="checkbox1 margin_r_5"><span class="font_size12">${permission.label}</span></label>
			</td>
			<c:if test="${(status.index+1)%4 eq 0 &&status.index ne 0}">
			</tr>
			<tr>
			</c:if>
</c:forEach>
		</tr>
	</table>
</div>
</body>
<script>
var isChange = false;
function changeCheck(){
	isChange = true;
}
function OK(){
	var newName=$("#name").val().trim();
	var str="";
	$(".checkbox1").each(function(){
		if($(this).is(':checked')){
		   str+=$(this).attr("name")+",";
		}
	})
	var str2="1";
		if($("#check_do").is(':checked')){
		   str2+=",1";
		}else{
			str2+=",0";
		}
		if($("#check_read").is(':checked')){
			   str2+=",1";
			}else{
				str2+=",0";
			}

	//检查是否与默认分类重名
	var flag = false;
	$.each($("table.category_default td span.padding_l_5"),function(i,d){
		if(newName == d.innerText){
			alert("新增分类不能与系统默认分类重名");
			flag = true;
			return false;
		}
	});
	if((newName==null||newName==""||newName=="undefined") && !isChange){
		alert("请输入新分类名称!");
		return;
	}
	//检查分类名长度是否超过最大限度
	if(newName.length > 20){
		alert("新分类最大长度已经超过20个字符");
		flag = true;
	}
	if(flag){
		return 0;
	}
	if(newName!=""&&str!=""){
		$("#permissions").val(str);
		$("#govdocpending_permissions").val(str2);
		$("#govdocpending_name").val("govdoc.pending.all");
		 return $("#permissionForm");
	}else if(newName!=""&&str==""){
		alert("请选择节点权限");
		return 0;
	}else{
		$("#govdocpending_permissions").val(str2);
		$("#govdocpending_name").val("govdoc.pending.all");
		return $("#permissionForm");
	}
}
</script>
</html>