<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Insert title here</title>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
    <%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
    <%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>

    <fmt:setBundle basename="com.seeyon.v3x.system.resources.i18n.SysMgrResources" var="v3xSysI18N"/>
    <fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
    <fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources"/>
    <fmt:setBundle basename="com.seeyon.v3x.edoc.resources.i18n.EdocResource"  var="v3xEdocI18N"/>
    <link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
    <link href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">

    <script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery-1.11.3.min.js" />"></script>

</head>
<body srcoll="no" style="overflow: hidden;border:0;" class="tab-body">

</body>
</html>