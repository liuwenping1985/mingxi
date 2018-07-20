<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>

<html>
<head>
	<title>
		<c:if test="${bean.id!=null}"><fmt:message key='common.toolbar.edit.label' bundle="${v3xCommonI18N}" /></c:if><c:if test="${bean.id==null}"><fmt:message key='common.toolbar.new.label' bundle="${v3xCommonI18N}" /></c:if><fmt:message key="bul.data" />
	</title>
	<%@ include file="../include/header.jsp" %>
	
<script type="text/javascript">
<!--
	function setPeopleFields(elements){
		alert(elements);
	}
	
	function saveForm(operType){
			$('form_oper').value=operType;
			$('dataForm').submit();
		}
		
		
	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
    	    	
    	var insert = new WebFXMenu;
    	insert.add(new WebFXMenuItem("", "<fmt:message key='common.insert.localfile.label' bundle='${v3xCommonI18N}' />", "insertAttachment()"));
    	    	
    	<c:if test="${bean.state==20}">
			myBar.add(new WebFXMenuButton("publish", "<fmt:message key='common.toolbar.oper.publish.label' bundle='${v3xCommonI18N}'/><fmt:message key="bul.data_shortname" />", "saveForm('publish');", "<c:url value='/common/images/toolbar/send.gif'/>", "", null));
		</c:if>
		<c:if test="${bean.state==30}">
			myBar.add(new WebFXMenuButton("cancelPublish", "<fmt:message key="oper.cancel" /><fmt:message key="oper.publish" />", "saveForm('cancelPublish');", "<c:url value='/common/images/toolbar/save.gif'/>", "", null));
		</c:if>	
    	
    	myBar.add(new WebFXMenuButton("return", "<fmt:message key='common.toolbar.back.label' bundle='${v3xCommonI18N}' />", "history.go(-1);", "<c:url value='/common/images/toolbar/back.gif'/>", "", null));    	
    	
//-->
</script>

</head>
<body>

<div class="newDiv">
<form action="${bulDataURL}" id="dataForm" name="dataForm" method="post">
<input type="hidden" name="method" value="publishOper" />
<input type="hidden" name="id" value="${bean.id}" />
<input type="hidden" name="form_oper" value="" />
		

	<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="CollTable">
		<tr>
			<td height="10px">
				<script type="text/javascript">document.write(myBar);</script>
			</td>
		</tr>
		<tr>
			<td class="detail-summary" valign="top">
				<%@ include file="../include/dataView.jsp" %>
			</td>
		</tr>
	</table>

</form>
</div>
</body>
</html> 