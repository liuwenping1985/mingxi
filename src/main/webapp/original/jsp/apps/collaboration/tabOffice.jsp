<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/commonSummary.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
</head>

<%-- @功能插件引入 --%>
<script type="text/javascript" charset="UTF-8" src="${path}/common/office/js/baseOffice.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/common/office/license.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/common/office/js/i18n/${localeStr}.js${ctp:resSuffix()}"></script>

<body>
   <div id="officeFrameDiv" style="height:786px;width:100%; overflow:hidden;">
       <iframe name="officeEditorFrame" width="100%" height="100%" id="officeEditorFrame" src="" frameBorder="0"></iframe>
   </div>
</body>
</html>