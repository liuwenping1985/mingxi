<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/commonComPage.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html id='compontentHtml' style="height:100%;">
<head>
</head>

<%-- @功能插件引入 --%>
<link rel="stylesheet" href="${path}/apps_res/collaboration/atwho/css/jquery.atwho.min.css${ctp:resSuffix()}">
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/atwho/js/jquery.caret.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/atwho/js/jquery.atwho.js${ctp:resSuffix()}"></script>


<style>
	.content_view .view_li_hasoverflow {
  		*zoom: 1;
  		width: 786px;
  		margin-left: auto;
  		margin-right: auto;
  		background: white;
}
</style>
<body style="height:100%;background:#D2D2D2;" onload="_init_()">
<div class='content_view' style="height:100%;">
<ul class="view_ul align_left content_view"  id='display_content_view'>
    <li id="cc" class="view_li_hasoverflow" style="min-width:786px;text-align:center;">
        <!--jsp:include page="/WEB-INF/jsp/common/content/content.jsp" /-->
        <iframe id='zwIframe' name='zwIframe' style="width:100%;height:786px;" frameborder="0"></iframe>
        <c:if test="${_contentType == '20'}">
        <iframe id='zwOfficeIframe' hasLoad="false" name='zwOfficeIframe' src="/seeyon/collaboration/collaboration.do?method=tabOffice" style="width:100%;height:786px;display:none;" frameborder="0"></iframe>
    	</c:if>
    </li>
    <!--附言区域-->
    <jsp:include page="/WEB-INF/jsp/common/content/commentTpl/defaultForSummary.jsp" />
    <textarea id='formTextId' class='hidden'>${repealRecordText}</textarea>
</ul>
</div>
</body>
<script type="text/javascript">
<!--
var affairBodyType = "${affair.bodyType}";
var isFromTransform = '${isFromTransform ne null and isFromTransform}';
var openFrom = "${ctp:escapeJavascript(openFrom)}";
var zwIframeSrc = "/seeyon/content/content.do?method=index&isFullPage=true&hasDealArea=${param.hasDealArea}&moduleId=${_moduleId}&moduleType=${_moduleType}&rightId=${ctp:toHTML(_rightId)}&contentType=${_contentType}&viewState=${_viewState}&openFrom=${ctp:toHTML(openFrom)}&canDeleteISigntureHtml=${canDeleteISigntureHtml}&isShowMoveMenu=${isShowMoveMenu}&isShowDocLockMenu=${isShowDocLockMenu}";
//-->
var _summaryId = "${_moduleId}";
var isHistoryFlag ="${param.isHistoryFlag}";
</script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/comment.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/componentPage.js${ctp:resSuffix()}"></script>
</html>