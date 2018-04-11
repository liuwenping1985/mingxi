<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
var isDepartment = "1";
</script>
</head>
<frameset id="treeandlist" rows="*" cols="18%,*" framespacing="5" frameborder="yes"  bordercolor="#ececec">
	<c:choose>
	<c:when test="${addressbookType == 1}">
		<frame frameborder="0" src="${urlAddressBook}?method=treeDept&addressbookType=${addressbookType}&accountId=${param.accountId}" name="treeFrame" scrolling="no" id="treeFrame"/>
	</c:when>
	<c:when test="${addressbookType == 3}">
		<frame frameborder="0" src="${addressbookURL}?method=treeSysTeam&addressbookType=1&accountId=${param.accountId}" name="treeFrame" scrolling="no" id="treeFrame"/>
	</c:when>
	<c:when test="${addressbookType == 4}">
		<frame frameborder="0" src="${addressbookURL}?method=treeOwnTeam&addressbookType=1" name="treeFrame" scrolling="no" id="treeFrame"/>
	</c:when>
	<c:when test="${addressbookType == 2}">
		<frame frameborder="0" src="${urlAddressBook}?method=treeOwnTeam&addressbookType=${addressbookType}" name="treeFrame" scrolling="no" id="treeFrame"/>
	</c:when>
	</c:choose>
    <frame src="${urlAddressBook}?method=initList&addressbookType=${addressbookType}&accountId=${param.accountId}" id="listFrame" name="listFrame" frameborder="no" scrolling="no" style="width: 100%; height: 100%;" />
</frameset>
<noframes>
<body>
</body>
</noframes>

</html>