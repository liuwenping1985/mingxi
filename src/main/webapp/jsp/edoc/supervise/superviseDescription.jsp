<%@ page import="com.seeyon.v3x.workflow.event.WorkflowEventListener" %>
<%@page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum" %>
<%@page import="com.seeyon.v3x.common.constants.Constants" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>    
<%@include file="../edocHeader.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<html:link renderURL='/edocSupervise.do?method=updateContent' var='sendURL'/>
<title><fmt:message key="edoc.supervise.description" /></title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
	function returnContent(){
		var form = document.getElementById("messageForm");
		if(!checkForm(form))
		return;//验证form
		window.returnValue = document.getElementById("content").value;
		window.close();
	}
</script>
</head>
<body scroll="no">
<form name="messageForm" id="messageForm" method="post" target="targetFrame">
<input type="hidden" name="superviseId" id="superviseId" value="${superviseId}">
<table border="0" cellspacing="0" cellpadding="0" width="100%" height="100%" class="popupTitleRight">
<tr>
<td class="PopupTitle">&nbsp;<fmt:message key='edoc.title' />
				</td>
			</tr>
	<tr>
	    <td align="left" style="padding:8px 15px 8px 15px ">
	    	<fmt:message key="col.supervise.title" bundle="${colI18N}"/>:<br/>
	        <textarea name="title" id="title" rows="" cols=""  readonly
	        		  style="width:320px;height: 100px" class="font-12px"  validate="maxLength" 
	        		  inputName="<fmt:message key="col.supervise.title"  bundle="${colI18N}" />" ><c:out value='${title}' escapeXml='true' default='${title}' /></textarea>
	    </td>
	</tr>
	<tr>
	    <td align="left" style="padding:8px 15px 8px 15px ">
	    	<fmt:message key="edoc.supervise.description" />:<br/>
	        <textarea name="content" id="content" rows="" cols="" <c:if test="${status == 1}"> disabled </c:if>
	        		  style="width:320px;height: 100px;" class="font-12px"  validate="maxLength" 
	        		  maxSize="200" inputName="<fmt:message key="edoc.supervise.description" />" ><c:out value='${content}' escapeXml='true' default='${content}' />
	        		  </textarea>
	    </td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom">
		    	<c:if test="${status != 1}"><input type="button" onclick="returnContent();" class="button-default_emphasize" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}'/>"/></c:if>&nbsp;&nbsp;&nbsp;&nbsp;
		    <input type="button" name="close" class="button-default-2" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}'/>" onclick="window.close()"/>
		</td>
	</tr>
</table>
</form>
<iframe id="targetFrame" name="targetFrame" height="0" width="0"></iframe>
</body>
</html>