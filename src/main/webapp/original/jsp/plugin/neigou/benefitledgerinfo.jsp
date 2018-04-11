<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript">
	
</script>
<style type="text/css">
.title {
	padding: 6pt;
}
</style>
</head>
<body>
	<form name="addForm" id="addForm" method="post" target="addDeptFrame">
		<div class="form_area" id="benbottom">
			<input type="button" class="common_button" id="btnok" name="btnok"
				style="position: relative; left: 1%; margin-top: 4px; margin-bottom: 2px;"
				value="${ctp:i18n('common.toolbar.back.label')}" />
			<table id="beneftable" class="flexme3" border="0" cellspacing="0"
				cellpadding="0"></table>
		</div>
	</form>
</body>
</html>