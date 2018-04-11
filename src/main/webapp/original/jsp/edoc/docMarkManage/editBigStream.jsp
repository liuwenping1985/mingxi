<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../edocHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
/**
 *内部方法，向上层页面返回参数   -- 这个方法在JAVA后台有调用
 */
function _returnValue(value){
    if(transParams.popCallbackFn){//该页面被两个地方调用
        transParams.popCallbackFn(value);
    }else{
        transParams.parentWin.editBigStreamPageCallback(value);
    }
}

/**
 *内部方法，关闭当前窗口 -- 这个方法在JAVA后台有调用
 */
function _closeWin(){
    if(transParams.popWinName){//该页面被两个地方调用
        transParams.parentWin[transParams.popWinName].close();
    }else{
        transParams.parentWin.editBigStreamPageWin.close();
    }
}
</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()">
<form name="myform" id="myform" method="post">
<input type="hidden" name="id" value="${category.id}">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td height="20" class="PopupTitle" nowrap="nowrap">&nbsp;</td>
	</tr>
	
	<tr>
		<td valign="top" align="center">		
			<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr height="25"><td colspan="2">&nbsp;</td></tr>
				<tr>
					<td width="25%" class="bg-gray" align="right" nowrap><font color="red">*</font><fmt:message key="common.name.label" bundle="${v3xCommonI18N}"/>:</td>
					<td width="75%" class="new-column"><input type="text" id="name" name="name" value="${category.categoryName}" class="input-100per"></td>
				</tr>
				<tr>
					<td class="bg-gray" align="right" nowrap><font color="red">*</font><fmt:message key="edoc.docmark.minNo"/>:</td>
					<td class="new-column"><input type="text" id="minNo" name="minNo" size="6" maxlength="10" value="${category.minNo}" onkeypress="var k=event.keyCode; return k>=48&&k<=57" onpaste="return !clipboardData.getData('text').match(/\D/)"
 ondragenter="return false" style="ime-mode:Disabled" class="input-100per"></td>
				</tr>
				<tr>
					<td class="bg-gray" align="right"><font color="red">*</font><fmt:message key="edoc.docmark.maxNo"/>:</td>
					<td class="new-column"><input type="text" id="maxNo" name="maxNo" size="6" maxlength="10" value="${category.maxNo}" onkeypress="var k=event.keyCode; return k>=48&&k<=57" onpaste="return !clipboardData.getData('text').match(/\D/)"
 ondragenter="return false" style="ime-mode:Disabled" class="input-100per"></td>
				</tr>
				<tr>
					<td class="bg-gray" align="right"><font color="red">*</font><fmt:message key="edoc.docmark.currentNo"/>:</td>
					<td class="new-column"><input type="text" id="currentNo" name="currentNo" size="6" maxlength="10" value="${category.currentNo}" onkeypress="var k=event.keyCode; return k>=48&&k<=57" onpaste="return !clipboardData.getData('text').match(/\D/)"
 ondragenter="return false" style="ime-mode:Disabled" class="input-100per"></td>
				</tr>
				<tr>
					<td class="bg-gray" align="right"><fmt:message key="edoc.docmark.sortbyyear"/>:</td>
					<td class="new-column">
					<label for="yearEnabled1">
					<input type="radio" id="yearEnabled1" name="yearEnabled" value="1" checked><fmt:message key="common.yes" bundle="${v3xCommonI18N}"/>&nbsp;&nbsp;
					</label>
					<label for="yearEnabled2">
					<input type="radio" id="yearEnabled2" name="yearEnabled" value="0"><fmt:message key="common.no" bundle="${v3xCommonI18N}"/>
					</label>
					</td>
				</tr>
			</table>		
		</td>
	</tr>
	
			
	<tr height="42">
		<td align="right" class="bg-advance-bottom">
			<input type="button" name="b1" onclick="updateBigStream();" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
			<input type="button" name="b2" onclick="_closeWin();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
</table>

</form>

<iframe name="empty" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0">
</iframe>

</body>
</html>

<script type="text/javascript">
<!--
	var readonly = ${category.readonly};
	var yearEnabled = ${category.yearEnabled};

	var _yearEnabled = document.getElementsByName("yearEnabled");
	if (yearEnabled == "true" || yearEnabled == true) {
		_yearEnabled[0].checked = true;
	}
	else {
		_yearEnabled[1].checked = true;
	}

	if (readonly) {
		_yearEnabled[0].disabled = true;
		_yearEnabled[1].disabled = true;
	}

//-->
</script>