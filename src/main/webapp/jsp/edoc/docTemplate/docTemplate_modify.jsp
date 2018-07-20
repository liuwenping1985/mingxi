<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head> 
<%@include file="../edocHeader.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
	function enableModify(){
		var readAttribute = document.selectedForm.name;
		readAttribute.readOnly = false;
	}

</script>
</head>
<body class="over_hidden">

<div class="newDiv">

<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
	<tr align="center">
		<td height="8" class="detail-top" colspan="2">
			<script type="text/javascript">
				getDetailPageBreak(); 
			</script>
		</td>
	</tr> 
	<tr>
		<td class="categorySet-4" height="8"></td>
	</tr>
	<tr>
		<td class="categorySet-head" height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key="edoc.doctemplate.info" /></td>
					<td class="categorySet-2" width="7"> </td>
					<td class="categorySet-head-space">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
  	
  	<tr>
		<td id="categorySetTd" class="categorySet-head">
			<div id="categorySetBody" class="categorySet-body overflow_auto" style="padding:0;border-bottom:1px solid #a0a0a0;">
				<%@include file="docTemplate_list_detail_iframe.jsp"%>
			</div>		
		</td>
	</tr>
	
	<c:if test="${param.flag != 'readonly'}">
		<tr>
			<td height="42" align="center" class="bg-advance-bottom">
				<input type="button" class="button-default_emphasize" value="<fmt:message key="common.button.ok.label" bundle="${v3xCommonI18N}" />" onclick="formSubmit();" />&nbsp;&nbsp;
				<input type="button" class="button-default-2" value="<fmt:message key="common.button.cancel.label" bundle="${v3xCommonI18N}"/>" onclick="window.location.href='<c:url value="/common/detail.jsp" />'"/>
			</td> 
		</tr>
	</c:if>
	<input type="hidden" name="operType" id="operType" value="${operType}">	
</table>
</div>
<script>
	if('${operType}' == 'add'){
			attach();
	}
	$(function() {
		$("#categorySetBody").hide().height($("#categorySetTd").height()).show();
		$(window).resize(function() {
			$("#categorySetBody").hide().height($("#categorySetTd").height()).show();
		})
	})
</script>
</body>
</html> 