<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
var contain = 2;
function OK(c){
    contain = c;
    window.returnValue = c;
    window.close();
}
</script>
</head>
<title>${ctp:i18n("selectPeople.ConfirmChildDept")}</title>
<body class="page_color h100b" scroll="no" style="overflow: hidden;height:100%;" onkeypress="listenerKeyESC()">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class="border_b padding_10 font_bold" align="center">"${name}" ${ctp:i18n("selectPeople.ConfirmChildDept")}</td>
    </tr>
    <tr>
        <td height="42" align="center" class="bg-advance-bottom">
            <input class="common_button common_button_gray" type="button" value="${ctp:i18n('selectPeople.ConfirmChildDept.yes')}" onclick="OK(0);">&nbsp;&nbsp;
            <input class="common_button common_button_gray" type="button" value="${ctp:i18n('selectPeople.ConfirmChildDept.no')}" onclick="OK(1);">&nbsp;&nbsp;
            <input class="common_button common_button_gray" type="button" value="${ctp:i18n('selectPeople.ConfirmChildDept.canel')}" onclick="OK(2);">
       	<div style="height: 5px;"></div>
        </td>
    </tr>
</table>
</body>
</html>