<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<!-- <%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%> -->
<!-- <%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%> -->


<%@ page isELIgnored="false"
	import="com.seeyon.ctp.common.AppContext,java.util.Locale"%>
<%@ page isELIgnored="false"
	import="com.seeyon.ctp.util.json.JSONUtil,java.util.Locale"%>
<%@ page isELIgnored="false"
	import="com.seeyon.ctp.common.constants.ProductEditionEnum,java.util.Locale"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%
	boolean isDevelop = AppContext.isRunningModeDevelop();
String ctxPath = request.getContextPath(), ctxServer = request.getScheme() + "://"
		+ com.seeyon.ctp.util.Strings.getServerName(request) + ":" + request.getServerPort() + ctxPath;
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
	var seeyonProductId = "${ctp:getSystemProperty('system.ProductId')}";
	var systemfileUploadmaxsize = "${ctp:getSystemProperty("fileUpload.image.maxSize")}";
</script>
<script type="text/javascript">
var curUserId="${ctp:escapeJavascript(CurrentUser.id)}";
var curUserName = "${ctp:escapeJavascript(CurrentUser.name)}";

var curUserPhoto;
try {
    curUserPhoto = _ctxPath + '/rest/orgMember/avatar/'+ curUserId+'?maxWidth=36';
} catch (e) {
    curUserPhoto = "${ctp:avatarImageUrl(CurrentUser.id)}";
}
</script>

<%-- <%
System.out.println(isDevelop);
	if (isDevelop) {
		
%> --%>
<!-- 合并压缩js代码后引出一系列问题，这个暂时不引用；
OA-123478公司协同：web端致信会话窗口：群组名显示null
OA-123096（致信）web端接收消息会提示undefined -->
	<script type="text/javascript"
		src="/seeyon/i18n_<%=locale%>.js${ctp:resSuffix()}"></script>
	<%@ include file="/WEB-INF/jsp/common/editor_js.jsp"%>
	<script type="text/javascript"
		src="/seeyon/apps_res/uc/chat/js/uc_connection.js"></script>
	<!-- <script type="text/javascript"
		src="/seeyon/apps_res/uc/chat/js/shared.js"></script>
	<script type="text/javascript"
		src="/seeyon/apps_res/uc/chat/js/jsjac.js"></script>

	<script type="text/javascript"
		src="/seeyon/apps_res/uc/chat/js/uc_onlinemsg.js"></script>
	<script type="text/javascript"
		src="/seeyon/apps_res/uc/chat/js/uc_connection.js"></script> -->

<%-- <%
	} else {
		
%>

<script type="text/javascript" charset="UTF-8"
	src="<c:url value="/apps_res/uc/chat/js/uc-min.js${ctp:resSuffix()}" />"></script>

<%
	}
%> --%>