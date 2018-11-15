<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext,java.util.Locale"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.util.json.JSONUtil,java.util.Locale"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.constants.ProductEditionEnum,java.util.Locale"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%
    boolean isDevelop = AppContext.isRunningModeDevelop();
    String ctxPath =request.getContextPath(),  ctxServer = request.getScheme()+"://" + request.getServerName() + ":"
                    + request.getServerPort() + ctxPath;
    Locale locale = AppContext.getLocale();
%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<%
    if (true) {
%>
<meta charset="utf-8">
<link rel="stylesheet" type="text/css" href="${path}/common/designer/css/layout-default-latest.css${ctp:resSuffix()}"/>
<link rel="stylesheet" type="text/css" href="${path}/common/designer/css/jquery-ui.css${ctp:resSuffix()}">
<link rel="stylesheet" type="text/css" href="${path}/common/designer/css/default_model.css${ctp:resSuffix()}"/>
<link rel="stylesheet" type="text/css" href="${path}/common/designer/css/icon-pic.css${ctp:resSuffix()}"/>
<script type="text/javascript" charset="UTF-8" src="${path}/common/designer/js/component.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/common/designer/js/jquery-1.11.3.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/common/designer/js/jquery-ui.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/common/designer/js/jquery.json.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/common/designer/js/jquery.layout-latest.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/common/designer/js/initialization.layout.js${ctp:resSuffix()}"></script>
<%
    } else {
%>
<link rel="stylesheet" type="text/css" href="${path}/common/designer/css/designer-all-min.css${ctp:resSuffix()}"/>
<script type="text/javascript" src="${path}/common/designer/js/designer-all-min.js${ctp:resSuffix()}"></script>
<%
    }
%>