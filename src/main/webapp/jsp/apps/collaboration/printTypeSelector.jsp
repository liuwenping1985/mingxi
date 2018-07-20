<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
function OK(){
	if(document.getElementById("mainpp") && document.getElementById("mainpp").checked){
		return "mainpp";
	}else if(document.getElementById("colPrint") && document.getElementById("colPrint").checked){
		return "colPrint";
	}
}
</script>
</head>
<body>
<div class="margin_t_10">
	<div class="margin_t_10 margin_t_10 margin_l_10">
	    <c:choose>
			<c:when test="${isForm}">
				<label for="mainpp">
					<input id="mainpp" type="radio" name="printType" value="mainpp">
					<span class="font_size12">${ctp:i18n('collaboration.print.type.form')}</span>
			    </label>
			</c:when>
			<c:otherwise>
				<label for="mainpp">
					<input id="mainpp" type="radio" name="printType" value="mainpp">
					<span class="font_size12">${ctp:i18n('collaboration.print.type.office')}</span>
			    </label>
			</c:otherwise>
		</c:choose>
	</div>
	<div class="margin_t_10 margin_t_10 margin_l_10">
		<label for="colPrint">
			<input id="colPrint" type="radio" name="printType" value="colPrint" checked="checked">
			<span class="font_size12">${ctp:i18n('collaboration.print.type.coll')}</span>
		</label>
	</div>
</div>
</body>
</html>