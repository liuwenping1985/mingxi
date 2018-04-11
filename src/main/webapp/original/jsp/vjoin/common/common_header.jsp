<%-- 供后台页面调用的header --%>
<%@ page isELIgnored="false" import="java.util.Locale"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%
    response.setHeader("Pragma", "No-cache");
    response.setHeader("Cache-Control", "no-store");
    response.setDateHeader("Expires", 0);
%>

<%-- 解决360兼容问题 --%>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
<meta name="renderer" content="webkit|ie-stand|ie-comp" />

<c:set var="path" value="${pageContext.request.contextPath}" />
<c:set var="v5Path" value="/seeyon" />

<link rel="stylesheet" href="${path}/apps_res/vjoin/portal/mobileDesigner/common/depend/bootstrap/css/bootstrap.min.css${ctp:resSuffix()}">
<link rel="stylesheet" href="${path}/apps_res/vjoin/portal/mobileDesigner/common/depend/layui/build/css/layui.css${ctp:resSuffix()}">
<link rel="stylesheet" href="${path}/apps_res/vjoin/portal/mobileDesigner/common/depend/zTree/css/vjoinStyle/vjoinStyle.css${ctp:resSuffix()}">
<link rel="stylesheet" href="${path}/apps_res/vjoin/portal/mobileDesigner/common/css/common/common.css${ctp:resSuffix()}">
<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
<!--[if lt IE 9]>
<script src="${path}/apps_res/vjoin/portal/mobileDesigner/common/depend/bootstrap/asst/html5shiv.min.js"></script>
<script src="${path}/apps_res/vjoin/portal/mobileDesigner/common/depend/bootstrap/asst/respond.min.js"></script>
<![endif]-->