<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="${path}/common/designer/css/jquery-ui.css${ctp:resSuffix()}"/>
<link rel="stylesheet" type="text/css" href="${path}/common/designer/css/default_model.css${ctp:resSuffix()}"/>
<link rel="stylesheet" type="text/css" href="${path}/common/designer/css/icon-pic.css${ctp:resSuffix()}"/>
<link rel="stylesheet" type="text/css" href="${path}/common/designer/css/widgetDefault.css${ctp:resSuffix()}"/>
<link rel="stylesheet" type="text/css" href="${path}/common/designer/css/portalDefaultGlobal.css${ctp:resSuffix()}"/>
<link id="v5PageLayoutCss" rel="stylesheet" type="text/css" href="${pageRenderResult.defaultLayoutCssPath}${ctp:resSuffix()}"/>
<link id="v5PageSkinCss" rel="stylesheet" href="${pageRenderResult.defaultSkinCssPath}${ctp:resSuffix()}">
<style type="text/css">
${pageRenderResult.customCss}
</style>
<title>${pageRenderResult.pageName}</title>
</head>
${pageRenderResult.bodyHtml}
</html>
<script type="text/javascript" src="${pageRenderResult.customJS}${ctp:resSuffix()}"></script>