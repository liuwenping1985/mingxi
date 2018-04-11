<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../common/INC/noCache.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<html class="over_hidden h100b">
<head>
<META http-equiv="X-UA-Compatible" content="IE=EmulateIE9"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${v3x:escapeJavascript(summarySubject)}</title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/edoc.js${v3x:resSuffix()}" />"></script>
<style type="text/css">
body,html{
   border: 0px;
   margin: 0px;
   padding: 0px;
}
</style>
<script type="text/javascript">
//ie以外的浏览器关闭窗口时不能从内关闭外面的窗口
function closeWindow(){
	if(window.dialogArguments){
		window.returnValue = "true";
		window.close();
	}else if(window.opener){
		window.opener.location.reload();
		window.close();
	}else{
		try{
			parent.parent.location.reload(true);
		}catch(e){
			parent.getA8Top().reFlesh();
		}
	}
}
/**
 * lijl注销,OA-42824  风暴测试：在已发/待办/已办查看关联文档，该文档的标题太靠上了 
 * try{
 *    parent.document.title = "${v3x:escapeJavascript(summarySubject)}";
 * }
 * catch(e){
 * }
 */

if(parent!=null && "lenPotent"!="${openFrom}") {
	parent.document.title = "${v3x:escapeJavascript(summarySubject)}";
}
 
</script>

</head>
<body class="over_hidden h100b"> 
  <c:set value="${(from=='supervise' || !empty from) ? from : param.from}" var="f"/>
  <c:set value="${(empty param.affairId || isEdocRecDistribute || changeTOSelf) ? affairId : param.affairId}" var="affId"/>
	<iframe style="border: 0px;" FRAMEBORDER="0" marginheight="0" marginwidth="0" width="100%" height="100%" src="edocController.do?method=summary&summaryId=${summaryId}&affairId=${affId}&from=${v3x:toHTML(f)}&docResId=${param.docResId}&openFrom=${v3x:toHTML(openFrom)}&lenPotent=${lenPotent}&docId=${docId}&isLibOwner=${isLibOwner}&docResId=${param.docResId }&bodyType=${bodyType}&recType=${recType}&relSends=${relSends}&relRecs=${relRecs}&sendSummaryId=${v3x:toHTML(sendSummaryId)}&recEdocId=${recEdocId}&forwardType=${forwardType}&archiveModifyId=${archiveModifyId}&isOpenFrom=${isOpenFrom}&openEdocByForward=${v3x:toHTML(param.openEdocByForward)}&isTransFrom=${v3x:toHTML(isTransFrom)}" name="detailMainFrame" id="detailMainFrame" scrolling="no">
	</iframe>
</body>
</html>