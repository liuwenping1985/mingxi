<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="docHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport"
    content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, width=device-width">
<title><c:if test="${param.versionFlag eq 'HistoryVersion'}">
        <fmt:message key="doc.menu.history.label" />:</c:if>${v3x:toHTML(docRes.frName)}</title>
</head>
<body scroll=no onunload='javascript:closeOpen()'>
    <c:choose>
        <c:when test="${param.versionFlag eq 'HistoryVersion'}">
            <IFRAME name="myframe" id="myframe" frameborder="0" width="100%" height="100%"
                src="${detailURL}?method=docOpenView&versionFlag=${param.versionFlag}&docVersionId=${param.docVersionId}&docLibId=${param.docLibId}&docLibType=${param.docLibType}&all=${param.all}&edit=${param.edit}&add=${param.add}&readonly=${param.readonly}&browse=${param.browse}&isBorrowOrShare=${param.isBorrowOrShare}&list=${param.list}&isLink=${param.isLink}"></IFRAME>
        </c:when>
        <c:otherwise>
            <IFRAME name="myframe" id="myframe" frameborder="0" width="100%" height="100%"
                src="${detailURL}?method=docOpenView&docResId=${param.docResId}&docLibId=${param.docLibId}&docLibType=${param.docLibType}&all=${param.all}&edit=${param.edit}&add=${param.add}&readonly=${param.readonly}&browse=${param.browse}&isBorrowOrShare=${param.isBorrowOrShare}&list=${param.list}&isLink=${param.isLink}&commentEnabled=${docRes.commentEnabled}&commentCount=${docRes.commentCount}"></IFRAME>
        </c:otherwise>
    </c:choose>
</body>
<script language='javascript'>
    var result = 'false';
    var isBorrow = '${param.isBorrow}';//个人借阅调用时，不能关闭父窗口
    function closeOpen() {
        parent.window.returnValue = result;
        if ('true' != isBorrow) {
            parent.window.close();
        }
    }
</script>
</html>