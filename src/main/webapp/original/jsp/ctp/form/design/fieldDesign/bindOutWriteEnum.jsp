<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body class="h100b over_hidden  font_size12">
<form id="bindOutWrite">
<div class="margin_t_10">
        <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%"
            align="center">
            <tr id="trRadioclass" class="radioShow ">
                <td>&nbsp;</td>
                <td align="right">${ctp:i18n('form.formenum.enumname')}:</td>
                <td colspan="2" >
                <div class="left common_txtbox_wrap">
                <input name="formatEnum"  id="formatEnum"  onclick="bindFomatEnum()" style="width: 200px" value="${fn:escapeXml(formatEnumName)}">
                </div>
                </td>
            </tr>
            <tr id="trSelectclass" class="selectShow hidden">
                <td>&nbsp;</td>
                <td align="right">${ctp:i18n('form.formenum.enumtype')}:</td>
                <td colspan="2">
                <div class="common_txtbox_wrap" >
                    <input type='hidden' id="formatEnumId"  value='' >
                    <input type='hidden' id="formatEnumIsFinalChild"  value='' >
                </div>
                </td>
            </tr>
            <tr>
                <td colspan="4">&nbsp;</td>
            </tr>
            <tr id="trSelectReturnclass" class="selectReturnShow hidden">
                <td>&nbsp;</td>
                <td align="right" id="trSelectReturnclassId">${ctp:i18n('form.formenum.enumlevel')}:</td>
                <td colspan="2">
                <div class="left common_selectbox_wrap" style="width: 210px">
                    <select name="formatEnumLevel"  id="formatEnumLevel" style="display:none;width: 210px">
                    </select>
                    <select name="imageEnumFormat"  id="imageEnumFormat" style="display:none;width: 210px">
                    </select>
                </div>
                </td>
            </tr>
        </table>
</div>
</form>
</body>
<script type="text/javascript" src="${path}/common/form/design/bindOutWriteEnum.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
var imageEnumType='${imageEnumType}';
var imageEnumFormatOpHtml='${imageEnumFormatOpHtml}';
var maxLevel = "${maxLevel}";
var hasMoreLevel = "${hasMoreLevel}";
var enumType = "${enumType}";
</script>
</html>