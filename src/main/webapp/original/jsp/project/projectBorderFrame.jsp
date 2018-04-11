<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="projectHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
<%--显示当前位置--%>
	//getA8Top().showLocation(810, "<fmt:message key='menu.projece.set.label' bundle='${v3xMainI18N}'/>");
</script>
</head>
<body class="padding5" scroll="no" style="overflow:hidden;">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	   <tr>
	      <td valign="bottom" height="26" class="tab-tag">
				<div class="div-float">
					<div class="tab-separator"></div>	
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel cursor-hand" onclick="javascript:location.href='<html:link renderURL='/relateMember.do?method=relate' />'"><fmt:message key="menu.peoplerelate.options" bundle="${v3xMainI18N}"/></div>
					<div class="tab-tag-right"></div>
					
					<div class="tab-separator"></div>	
					<div class="tab-tag-left-sel"></div>
					<div class="tab-tag-middel-sel cursor-hand" onclick="location.reload();">
					 	<fmt:message key="menu.projece.set.label" bundle="${v3xMainI18N}"/>
					</div>
					<div class="tab-tag-right-sel"></div>

					<div class="tab-separator"></div>	
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel cursor-hand" onclick="javascript:location.href='<html:link renderURL='/portal/linkSystemController.do?method=userLinkMain' />'">
					 	<fmt:message key="menu.relateSystem.set" bundle="${v3xMainI18N}"/>
					</div>
					<div class="tab-tag-right"></div>
					<div class="tab-separator"></div>	
				</div>
		  </td>
	  </tr>
	  <tr>
	    <td valign="top" height="100%" class="tab-body-bg" style="padding: 0px">
		<iframe id="formqueryframe" name="formqueryframe" src="${basicURL}?method=myTemplateBorderMain" style="width:100%;height: 100%;" border="0px" frameborder="0"></iframe>
		<c:if test="${v3x:getBrowserFlagByRequest('PageBreak', pageContext.request)}">
		<iframe id="detailIframe" name="detailIframe" style="width:100%;height: 100%;" border="0px" frameborder="0"></iframe>
		</c:if>
		</td>
	</tr>
</table>
</body>
</noframes>
</html>