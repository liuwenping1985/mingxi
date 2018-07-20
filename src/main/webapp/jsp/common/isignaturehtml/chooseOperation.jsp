<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ctp:i18n('common.choose.signature.style')}</title>
<script type="text/javascript">
<!--
function choose(v){
	window.parent.top.doSignatureCallBack(v);
	window.parent.top.isignaturedialog.close();
}
//-->
</script>
</head>
<body class="h100b over_hidden">

        <table class="popupTitleRight" width="100%" height="100%" border="0px" cellspacing="0" cellpadding="0"  >
        	<tr>
        		<td width="45%"  align="right">
                    <a href="javascript:choose('0');" class="common_button common_button_gray">${ctp:i18n('common.isignaturehtml.isignature')}</a>
        		</td>
        		<td width="10%" align="center">
        		</td>
        		<td width="45%"  align="left">
                    <a href="javascript:choose('1');" class="common_button common_button_gray">${ctp:i18n('common.isignaturehtml.handwrite')}</a>
        		</td>
        		
        	</tr>
        </table>
</body>
</html>