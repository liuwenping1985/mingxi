<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="inquiryHeader.jsp"%>
<html>
<head>
    <meta charset="UTF-8">
    <title>${ctp:i18n('inquiry.see.big.img')}</title>
</head>
<script type="application/javascript">
    <%--var url = '${path}' + '/fileUpload.do?method=showRTE&fileId='+ '${imgId}';--%>
    <%--$("#target").attr("src",url);--%>
</script>
<body>
<input type="hidden" name="imgId" id = "imgId" value="${imgId}">
<img id="target" src="${path}/fileUpload.do?method=showRTE&fileId=${imgId}&type=image">
</body>

</html>