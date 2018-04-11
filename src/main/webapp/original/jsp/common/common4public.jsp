<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext,java.util.Locale"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.util.json.JSONUtil,java.util.Locale"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.constants.ProductEditionEnum,java.util.Locale"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<!DOCTYPE html>
<%-- è§£å³360å¼å®¹é®é¢ --%>
<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
<%
    response.setHeader("Pragma", "No-cache");
    response.setHeader("Cache-Control", "no-store");
    response.setDateHeader("Expires", 0);
    
    boolean isDevelop = AppContext.isRunningModeDevelop();
	String ctxPath =request.getContextPath(),  ctxServer = request.getScheme()+"://" + com.seeyon.ctp.util.Strings.getServerName(request) + ":"
        + request.getServerPort() + ctxPath;
    Locale locale = AppContext.getLocale();
  
%>
<c:set var="path" value="${pageContext.request.contextPath}" />

<script type="text/javascript">
  var _ctxPath = '<%=ctxPath%>', _ctxServer = '<%=ctxServer%>';
  var _locale = '<%=locale%>',_isDevelop = <%=isDevelop%>,_sessionid = '<%=session.getId()%>',_isModalDialog = false;
  var _editionI18nSuffix = '<%=ProductEditionEnum.getCurrentProductEditionEnum().getI18nSuffix()%>';
  <c:if test="${param._isModalDialog == 'true' || param.isFromModel == 'true'}">
  _isModalDialog = true;
  </c:if>
  var _resourceCode = "${ctp:escapeJavascript(param._resourceCode)}";
  var seeyonProductId="${ctp:getSystemProperty("system.ProductId")}";
  var systemfileUploadmaxsize="${ctp:getSystemProperty("fileUpload.image.maxSize")}";
</script>