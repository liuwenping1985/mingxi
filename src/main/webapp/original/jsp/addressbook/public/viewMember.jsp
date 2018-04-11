<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@include file="../header.jsp"%>
</head>
<body scroll="no" style="overflow: no">
	<form id="editForm" method="post" action="${addressbookURL}?method=updateMember&addressbookType=1" onSubmit="return (checkForm(this))">
		<input type="hidden" name="id" value="${tel.id}" />
		<input type="hidden" name="orgAccountId" value="${tel.orgAccountId}" />
		<%request.setAttribute("pop",request.getParameter("listorpop")); %>
		<c:choose>
			<c:when test="${pop==0}">
				<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
					<tr align="center">
						<td height="8" class="detail-top">
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
									<td class="categorySet-title" width="80" nowrap="nowrap"><c:out value="${v3x:showOrgMemberName(tel) }"></c:out></td>
									<td class="categorySet-2" width="7"></td>
									<td class="categorySet-head-space">&nbsp;</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td class="categorySet-head">
							<div class="categorySet-body">
								<%@include file="memberInfo.jsp"%>
							</div>		
						</td>
					</tr>
				</table>
			</c:when>
			<c:otherwise>
				<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="popupTitleRight">
					<tr>
						<td class="PopupTitle" nowrap="nowrap">
							<c:out value="${tel.name}"></c:out>
						</td>
					</tr>
					<tr>
						<td class="categorySet-head">
							<div class="categorySet-body2">
								<%@include file="memberInfo.jsp"%>
							</div>		
						</td>
					</tr>
				</table>
			</c:otherwise>
		</c:choose>
	</form>
</body>
</html>