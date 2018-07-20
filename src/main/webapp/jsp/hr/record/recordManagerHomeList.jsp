<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../header.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
<!--
 
	var WebFXMenuBar_mode = 'gray';
//-->
</script>
</head>
<body class="tab-body" scroll="no">

<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
		<td  class="tab-body-bg" style="margin: 0px;padding:0px;">
		<iframe noresize="noresize" scroll="no" frameborder="no" src="${hrRecordURL}?method=recordManagerHomeListEntry&recordType=staffRecordList&recordDept=${recordDept}"  id="detailIframe" name="detailIframe" style="width:100%;height: 100%;" border="0px"></iframe>			
		</td>
	</tr>
</table>

</body>
</html>

