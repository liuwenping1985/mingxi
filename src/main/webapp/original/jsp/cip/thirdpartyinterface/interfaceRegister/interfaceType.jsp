<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<style type="text/css"></style>
</head>
<script type="text/javascript">
function OK() {
	var id = ${id}.key;
	var name = $("#name").val();
	return {"id":id,"name":name};
}	
</script>
<body>
	<form name="addForm" id="addForm" method="post" target=""
		class="validate">
		<div class="form_area">
			<div class="one_row" style="width: 70%; margin-top: 50px;">
				<table>
					<tr>
						<td nowrap="nowrap"><label class="margin_r_10" for="text"><font
								color="red">*</font>${ctp:i18n('cip.base.interface.type.way')}</label></td>
						<td width="100%"><input id="way" type="text"
							class="w100b validate" validate="type:'string'" value="${name}"
							disabled="disabled"></td>
					</tr>
					<tr>
						<td nowrap="nowrap"><label class="margin_r_10" for="text"><font
								color="red">*</font>${ctp:i18n('cip.base.interface.type.name')}</label></td>
						<td width="100%"><input id="name" type="text"
							class="w100b validate" validate="type:'string'"
							value="${nameValue}"></td>
					</tr>
				</table>
			</div>
		</div>
	</form>
</body>
</html>