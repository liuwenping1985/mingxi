<%-- 供后台页面调用的footer --%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext,java.util.Locale"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.util.json.JSONUtil,java.util.Locale"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.constants.ProductEditionEnum,java.util.Locale"%>
<%@ page isELIgnored="false" import="java.util.Locale"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%
    boolean isDevelop = AppContext.isRunningModeDevelop();
    String ctxPath =request.getContextPath(),  ctxServer = request.getScheme()+"://" + com.seeyon.ctp.util.Strings.getServerName(request) + ":"
            + request.getServerPort() + ctxPath;
    Locale locale = AppContext.getLocale();
%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<c:set var="v5Path" value="/seeyon" />
<script type="text/javascript">
    var _ctxPath = '${path}';
    var _v5Path = '${v5Path}';
    var _locale = '<%=locale%>';
    var _editionI18nSuffix = '<%=ProductEditionEnum.getCurrentProductEditionEnum().getI18nSuffix()%>';
</script>
<script type="text/javascript" src="/seeyon/i18n_<%=locale%>.js${ctp:resSuffix()}"></script>

<script type="text/javascript" src="${path}/apps_res/vjoin/portal/mobileDesigner/common/js/common/jquery-1.9.1.min.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/vjoin/portal/mobileDesigner/common/js/common/jquery.json-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/vjoin/portal/mobileDesigner/common/js/common/jquery.validate-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/vjoin/portal/mobileDesigner/common/js/common/jquery.form.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/vjoin/portal/mobileDesigner/common/depend/bootstrap/js/bootstrap.min.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/vjoin/portal/mobileDesigner/common/depend/layui/build/lay/dest/layui.all.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/vjoin/portal/mobileDesigner/common/depend/zTree/js/jquery.ztree.all.min.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/vjoin/portal/mobileDesigner/common/js/common/seeyon.ui.selectPeople-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/vjoin/portal/mobileDesigner/common/js/common/seeyon.ui.selectEnum-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/vjoin/portal/mobileDesigner/common/js/common/seeyon.ui.selectPanel-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/vjoin/portal/mobileDesigner/common/js/common/seeyon.ui.grid-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/vjoin/portal/mobileDesigner/common/js/common/jquery.extend-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/vjoin/portal/mobileDesigner/common/js/common/common-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/vjoin/portal/mobileDesigner/common/js/common/common-ajax.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/vjoin/portal/mobileDesigner/common/js/common/crypto.js${ctp:resSuffix()}"></script>
