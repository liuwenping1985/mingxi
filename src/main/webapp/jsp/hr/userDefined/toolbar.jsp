<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<%@include file="../header.jsp" %>
<script type="text/javascript">
	function changeType(settingType){
		parent.detailFrame.location.href='<c:url value="/common/detail.jsp" />';
		parent.toolbarFrame.location.href = "${hrUserDefined}?method=initToolBar&settingType="+settingType;
		parent.listFrame.location.href = "${hrUserDefined}?method=initSpace&settingType="+settingType;
	}
</script>
</head>
<body>
<table width="50%" border="0" cellpadding="0" cellspacing="0">
<tr>
    <td valign="bottom" height="26" >
		<div class="div-float">
			<c:choose>
				<c:when test="${settingType==1}">
					<div class="tab-tag-left-sel"></div>
					<div class="tab-tag-middel-sel"><a href="#" class="non-a" onclick="changeType(1)" ><fmt:message key='hr.userDefined.category.label' bundle='${v3xHRI18N}'/></div>
					<div class="tab-tag-right-sel"></div>
					<div class="tab-separator"></div>	
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel"><a href="#" class="non-a" onclick="changeType(2)" ><fmt:message key='hr.userDefined.option.label' bundle='${v3xHRI18N}'/></div>
					<div class="tab-tag-right"></div>
					<div class="tab-separator"></div>	
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel"><a href="#" class="non-a" onclick="changeType(3)" ><fmt:message key='hr.userDefined.page.set.label' bundle='${v3xHRI18N}'/></div>
					<div class="tab-tag-right"></div>
				</c:when>
				<c:when test="${settingType==2}">
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel"><a href="#" class="non-a" onclick="changeType(1)" ><fmt:message key='hr.userDefined.category.label' bundle='${v3xHRI18N}'/></div>
					<div class="tab-tag-right"></div>
					<div class="tab-separator"></div>	
					<div class="tab-tag-left-sel"></div>
					<div class="tab-tag-middel-sel"><a href="#" class="non-a" onclick="changeType(2)" ><fmt:message key='hr.userDefined.option.label' bundle='${v3xHRI18N}'/></div>
					<div class="tab-tag-right-sel"></div>
					<div class="tab-separator"></div>	
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel"><a href="#" class="non-a" onclick="changeType(3)" ><fmt:message key='hr.userDefined.page.set.label' bundle='${v3xHRI18N}'/></div>
					<div class="tab-tag-right"></div>
				</c:when>
				<c:otherwise>
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel"><a href="#" class="non-a" onclick="changeType(1)" ><fmt:message key='hr.userDefined.category.label' bundle='${v3xHRI18N}'/></div>
					<div class="tab-tag-right"></div>
					<div class="tab-separator"></div>	
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel"><a href="#" class="non-a" onclick="changeType(2)" ><fmt:message key='hr.userDefined.option.label' bundle='${v3xHRI18N}'/></div>
					<div class="tab-tag-right"></div>
					<div class="tab-separator"></div>	
					<div class="tab-tag-left-sel"></div>
					<div class="tab-tag-middel-sel"><a href="#" class="non-a" onclick="changeType(3)" ><fmt:message key='hr.userDefined.page.set.label' bundle='${v3xHRI18N}'/></div>
					<div class="tab-tag-right-sel"></div>
				</c:otherwise>
			</c:choose>
		</div>
	</td>
</tr>
</table>
</body>
</html>