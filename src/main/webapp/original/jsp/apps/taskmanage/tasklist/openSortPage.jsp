<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>${ctp:i18n('taskmanage.sortSetting.label') }</title>
</head>
<body onload="getparamer();" scroll="no" style="font-size: 12px;margin: 0;margin-left: 5px;">
<table cellspacing="0" cellpadding="0" width="100%" border="0" height="100%"> 
  <tbody>
    <tr>
        <td class="bg-advance-middel">
            <table border="0" cellpadding="0" cellspacing="0">          
                <tbody>
                    <tr>
                        <td align="right">${ctp:i18n('taskmanage.addOrder.label') }：</td>
                        <td><label id="sortdataname"></label></td>
                        <td>&nbsp;</td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                    <tr>
                        <td align="right">${ctp:i18n('taskmanage.addOrder.label') }：</td>
                        <td>
                            <label for="asc"><input type="radio" name="sorttype" id="asc" checked="checked" value="asc">${ctp:i18n('taskmanage.ascOrder.label') }</label>
                        </td>
                        <td>
                            <label for="desc"><input type="radio" name="sorttype" id="desc" value="desc">${ctp:i18n('taskmanage.descOrder.label') }</label>
                        </td>
                    </tr>
                </tbody>
            </table>
        </td>
    </tr>
  </tbody>
</table>
<script type="text/javascript">
	function getparamer() {
		var params = window.parentDialogObj["openSortPage"].getTransParams();
		$("#sortdataname").text(params.text);
		$(":input[name='sorttype'][value='" + params.order + "']").prop("checked", true);
	}
	function OK() {
		return $("input:checked").val();
	}
</script>
</body>
</html>