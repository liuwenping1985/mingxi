<script type="text/javascript" src="/seeyon/i18n_<%=locale%>.js${ctp:resSuffix()}"></script>
<%@ include file="/WEB-INF/jsp/common/editor_js.jsp"%>

<%
    if (isDevelop) {
%>
<script type="text/javascript" src="/seeyon/common/js/jquery-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/misc/Moo-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/misc/jsonGateway-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/jquery.json-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/jquery.jsonsubmit-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/common-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/v3x-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.checkform-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.dialog-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.layout-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.common-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.progress-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.arraylist-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.peopleCrad-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/laytpl.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.arraylist-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/ui/seeyon.ui.peopleCrad-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/jquery.comp-debug.js"></script>
<script type="text/javascript" src="/seeyon/common/js/laytpl.js"></script>
<%
    } else {
%>
<script type="text/javascript" src="/seeyon/common/coll-min.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="/seeyon/common/js/jquery.comp-min.js${ctp:resSuffix()}"></script>
<%
    }
%>

<script type="text/javascript" src="/seeyon/common/js/ui/calendar/calendar-<%=locale%>.js${ctp:resSuffix()}"></script>
<c:set var="loginTime" value="${ CurrentUser !=null ? CurrentUser.etagRandom : 0}" />
<script type="text/javascript" src="/seeyon/main.do?method=headerjs&login=${loginTime}"></script>
<script type="text/javascript">

var addinMenus = new Array();
<c:forEach var="addinMenu" items="${AddinMenus}" varStatus="status">
    var index = ${status.index};
    addinMenus[index] = {pluginId : '${addinMenu.pluginId}',name : '${addinMenu.label}',className : '${addinMenu.icon}',click : '${addinMenu.url}'};
</c:forEach>

$.ctx._currentPathId = '${_currentPathId}';
$.ctx._pageSize = ${ctp:getSystemProperty("paginate.page.size")};

$.ctx._emailShow = ${v3x:hasPlugin("webmail")}; 
$.ctx.fillmaps = <c:out value="${_FILL_MAP}" default="null" escapeXml="false"/>;
$.releaseOnunload();
</script>
<script type="text/javascript" src="/seeyon/common/image/jquery.touchTouch-debug.js${ctp:resSuffix()}"></script>
<c:if test="${fn:length(EXTEND_JS)>0}">
    <c:forEach var="js" items="${EXTEND_JS}">
        <script type="text/javascript" src="/seeyon/${js}${ctp:resSuffix()}"></script>            
    </c:forEach>
</c:if>