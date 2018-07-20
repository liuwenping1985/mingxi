<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/isignaturehtml/js/isignaturehtml.js" />"></script>
<link href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">
<SCRIPT language=javascript for=SignatureControl  event=EventOnSign(DocumentId,SignSn,KeySn,Extparam,EventId,Ext1)>
<%-- 作用：重新获取签章位置--%>
  if(SignatureControl && EventId == 4 ){
    CalculatePosition();
    SignatureControl.EventResult = true;
  }
</SCRIPT>
<SCRIPT language=javascript >
//专业签章数
var htmlISignCount = "${htmlISignCount}";
var onlySeeContent = "${ctp:escapeJavascript(param.onlySeeContent)}";
function hasHtmlSign(){
  return htmlISignCount>0;
}
 <%-- 页面大小改变的时候移动ISignatureHTML签章对象，让其到达正确的位置--%>
  window.onresize = function (){
      moveISignatureOnResize();
  }
  <%-- 页面离开的时候卸载签章--%>
  //window.onbeforeunload=cbfun;
  function cbfun(){
      try{releaseISignatureHtmlObj();}catch(e){}
      if(typeof(beforeCloseCheck) =='function'){
         return beforeCloseCheck();
      }
  }
  <%--装载签章--%>
	window.onload = function() {
		if (onlySeeContent == 'true') {
			loadSignatures("${param.summaryId}",false,false,false,3);
		}
		$("#edoc-contentText").attr("class", "content_text");
	}
	var _baseApp = 4;
	var _baseObjectId = "${param.summaryId}";
</SCRIPT>
<style>
.content_text a{
	line-height:1.5;
	font-size:16px;
}
</style>
<html class="h100b content_view">
<v3x:showContent  htmlId="edoc-contentText" content="${govdocContentObj.content}" type="${govdocBodyType}" createDate="${govdocContentCreateTime}"  viewMode ="edit"/>
</html>