<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../header.jsp" %>
<html>
<head>
</head>

<body  class="tab-body" scroll="no">
  <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>	    
		<td class="page-list-border" style="margin: 0px;padding:0px">
		<iframe src="${hrStaffURL}?method=initStaffInfoList" id="detailIframe" name="detailIframe" style="width:100%;height: 100%;" border="0px" frameborder="0" scrolling="no"></iframe>		
		</td>
	</tr>
  </table>
</body>

</html>