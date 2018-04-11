<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum" %>
<%@ include file="../edocHeader.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/edocCategory.js${v3x:resSuffix()}" />"></script>
<title>Insert title here</title>
</head>
<body>
<form action="" id="categoryForm" name="categoryForm" method="post" onsubmit="return false">
<input type="hidden" name="id" value="${category.id }">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">	
<tr align="center">
	<td height="8" class="detail-top">
		<script type="text/javascript">
		var currentUserDomain = "${v3x:currentUser().loginAccount}";
			getDetailPageBreak(); 
			function pressCategoryName(){
				if(event.keyCode == 13){
					saveCategory();
	    		}
			}
		</script>
	</td>
</tr>
<tr>
	<td class="categorySet-4" height="8"></td>
</tr>
<tr>
	<td align="center">
		<table>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td class="categorySet-head">
					<fmt:message key='edoc.category.send' />:
				</td>
				<td>
					<input type="text" id="categoryName" style="height:20px;width:150px" onKeyPress="pressCategoryName()" name="categoryName"  validate="notNull,maxLength" maxSize="85" inputName = '<fmt:message key="edoc.category.send" />' value="${category.name }" ${onlyShow?"disabled":"" }>
				</td>
			</tr>
			<!-- <tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td class="categorySet-head">
					修改人:
				</td>
				<td>
					<label>${v3x:showMemberName(category.modifyUserId) }</label>
				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td class="categorySet-head">
					修改时间:
				</td>
				<td>
					<label>${category.modifyTime }</label>
				</td>
			</tr> -->
		</table>
	</td>
</tr>
<c:if test="${onlyShow != true}">
<tr>
	<td align="center" class="bg-advance-bottom">
		<input type="button" id="submitButton" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize" onclick="saveCategory();">
			&nbsp;&nbsp; 
			<input type="button" onclick="window.location.href='<c:url value="/common/detail.jsp" />'" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
	</td>
</tr>
</c:if>
</table>
</form>
</body>
</html>