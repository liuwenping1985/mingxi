<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html id='compontentHtml' style="height:100%;">
<head>
</head>
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
        <iframe id='zwIframe' name='zwIframe' style="width:100%;height:786px;" scrolling="no" frameborder="0"></iframe>
    </li>
    <!--附言区域-->
    <!-- 如果不是公文新页面，则显示原来意见 -->
     <c:if test="${newGovdocView!='1'}">
    
    	<jsp:include page="/WEB-INF/jsp/common/content/comment.jsp" />
    	 
    	<textarea id='formTextId' class='hidden'>${repealRecordText}</textarea>
   </c:if> 
</ul>
</div>
</body>
<script type="text/javascript">
var canMoveISignature = "${canMoveISignature}";
<!--
var affairBodyType = "${affair.bodyType}";
var isFromTransform = '${isFromTransform ne null and isFromTransform}';
var openFrom = "${ctp:escapeJavascript(openFrom)}";
/* xiex 增加了一个参数 affairId*/
var zwIframeSrc = "/seeyon/content/content.do?method=index&isFullPage=true&moduleId=${_moduleId}&moduleType=${_moduleType}&rightId=${ctp:toHTML(_rightId)}&contentType=${_contentType}&viewState=${_viewState}&openFrom=${ctp:toHTML(openFrom)}&canDeleteISigntureHtml=${canDeleteISigntureHtml}&isShowMoveMenu=${isShowMoveMenu}&isShowDocLockMenu=${isShowDocLockMenu}&affairId=${affair.id}&templateId=${templateId}&formAppid=${formAppid}&isTakeback=${isTakeback}";
//-->
</script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/componentPage.js${ctp:resSuffix()}"></script>
</html>
