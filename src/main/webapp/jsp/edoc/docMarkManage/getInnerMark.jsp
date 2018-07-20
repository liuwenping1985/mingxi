<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../edocHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="serial.no.input" /></title>
<script type="text/javascript">
	function OK(){
		return doIt();
	}

	function doIt() {
		var arr = new Array();
		if('${personInput }' == 'false'){
			parentDialogObj.markDialog.close();
			return;
		}
		var handWrite=document.getElementById("hand_write");
		var handWriteValue= handWrite.value;
		if (handWriteValue == "") {
			alert(v3x.getMessage('edocLang.edoc_serial_no_alter_not_write'));
			handWrite.focus();
			return false;
		}
		if(/[\\|'"@#￥%]/.test(handWriteValue)) {
	        alert(_("edocLang.edoc_mark_isnotwellformated"));
	        return false;
	    }
		arr[0] = "0|" + handWriteValue + "||3";
		arr[1] = handWriteValue;
		arr[2]="my:serial_no";
		return arr;
	}
</script>
</head>
<body scroll=no>

	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="popupTitleRight">
		<tr>
			<td height="20" class="PopupTitle">
				<fmt:message key="serial.no.input" />
			</td>
		</tr>
		<tr>
			<td class="padding010">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td class="new-column" nowrap="nowrap">
							<c:if test="${personInput eq 'true' }">
								<div><fmt:message key='serial.no.input.plea' />:</div>
								<input type="text" name="hand_write" id="hand_write" onkeypress="" class="input-300px">
							</c:if>
							<c:if test="${personInput ne 'true' }">
								<div><fmt:message key='serial.noInputRight' /></div>								
							</c:if>
						</td>	
					</tr>
				</table>
			</td>
		</tr>
	</table>


</body>
</html>