<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

</head>

<body class="tab-body" scroll="no">
 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="line">
 	<tr>
		<td>
		<iframe noresize="noresize" frameborder="no" src="${hrRecordURL}?method=homeEntry" id="detailIframe" name="detailIframe" style="width:100%;height: 100%;" border="0px"></iframe>			
		</td>
	</tr>
</table>
<script type="text/javascript">
    showCtpLocation('F12_perRecord');
</script>
</body>


</html>