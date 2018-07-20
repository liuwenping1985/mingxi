<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext,java.util.Locale"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<html style="height:100%;overflow:hidden;">
<head>
<title>${bean.title}</title>
<%@ include file="../include/header_jquery.jsp"%>

<style type="text/css">
<%--表单专属样式start--%>
body{
	overflow-y:hidden!important
}
.browse_class span {
	color: blue;
}
.xdTableHeader TD {
	min-height: 10px;
}
.radio_com {
	margin-right: 0px;
}
.xdTextBox {
	BORDER-BOTTOM: #dcdcdc 1pt solid;
	min-height: 20px;
	TEXT-ALIGN: left;
	BORDER-LEFT: #dcdcdc 1pt solid;
	BACKGROUND-COLOR: window;
	DISPLAY: inline-block;
	WHITE-SPACE: nowrap;
	COLOR: windowtext;
	OVERFLOW: hidden;
	BORDER-TOP: #dcdcdc 1pt solid;
	BORDER-RIGHT: #dcdcdc 1pt solid;
}
.xdRichTextBox {
	font-size: 12px;
	BORDER-BOTTOM: #dcdcdc 1pt solid;
	TEXT-ALIGN: left;
	BORDER-LEFT: #dcdcdc 1pt solid;
	BACKGROUND-COLOR: window;
	FONT-STYLE: normal;
	min-height: 20px;
	display: inline-block;
	VERTICAL-ALIGN: bottom !important;
	WORD-WRAP: break-word;
	COLOR: windowtext;
	BORDER-TOP: #dcdcdc 1pt solid;
	BORDER-RIGHT: #dcdcdc 1pt solid;
	TEXT-DECORATION: none;
}
#mainbodyDiv div,#mainbodyDiv input,#mainbodyDiv textarea,#mainbodyDiv p,#mainbodyDiv th,#mainbodyDiv td,#mainbodyDiv ul,#mainbodyDiv li{
	font-family: inherit;
}
<%--表单专属样式end--%>
</style>
<%
    String ctxPath =request.getContextPath(),  ctxServer = request.getScheme()+"://" + request.getServerName() + ":"
                    + request.getServerPort() + ctxPath;
	Locale locale = AppContext.getLocale();
%>
<script type="text/javascript">
  var _ctxPath = '<%=ctxPath%>';
  var seeyonProductId="${ctp:getSystemProperty("system.ProductId")}";
  var _locale = '<%=locale%>';
</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/skin/default/skin.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery-ui.custom.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/jquery-ui.custom.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.plugin.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery-debug.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.json-debug.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/content/form.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/isignaturehtml/js/isignaturehtml.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.comp-debug.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/misc/Moo-debug.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/misc/jsonGateway-debug.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/common-debug.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.code-debug.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.fillform-debug.js${v3x:resSuffix()}" />"></script>
<c:set var="loginTime" value="${ CurrentUser !=null ? CurrentUser.etagRandom : 0}" />
<script type="text/javascript" charset="UTF-8" src="<c:url value="/main.do?method=headerjs&login=${loginTime}${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
    //表单签章相关,hw.js中需要用到
    var hwVer = '<%=DBstep.iMsgServer2000.Version("iWebSignature")%>';
    var webRoot = _ctxPath;
    var _ctxPath = '<%=ctxPath%>', _ctxServer = '<%=ctxServer%>';
    var htmOcxUserName = $.ctx.CurrentUser.name;
</script>
<SCRIPT language=javascript for=SignatureControl event=EventOnSign(DocumentId,SignSn,KeySn,Extparam,EventId,Ext1)>
      //作用：重新获取签章位置
      if(EventId = 4 ){
        CalculatePosition();
        SignatureControl.EventResult = true;
      }
</SCRIPT>
<link rel="stylesheet" type="text/css" href="/seeyon/apps_res/rikaze/css/style.css" />
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/office/js/hw.js${v3x:resSuffix()}" />"></script>

<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/docFavorite.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/ui/seeyon.ui.tooltip-debug.js${v3x:resSuffix()}" />"></script>
<c:if test="${bean.ext4 ne 'collaboration'}">
<link href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css">
</c:if>
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/news/css/news.css${v3x:resSuffix()}" />">
<c:if test="${bean.dataFormat eq 'FORM'}">
<link href="<c:url value="/apps_res/form/css/SeeyonForm.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css"/>
</c:if>
<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, width=device-width">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/isignaturehtml/js/isignaturehtml.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
var isShowHualian=false;//是否显示花脸
var officecanSave = "${bean.ext2=='1'}";
var fromGenius = false;
try{
	fromGenius = getA8Top().location.href.indexOf('a8genius.do')>-1;
}catch(e){}
// 精灵打开不显示
if(!parent.window.opener && !fromGenius && "${param.openFrom}"!="ucpc" && "${param.fromPigeonhole}"!="true"){
	getDetailPageBreak();
}
refreshAndCloseWhenInvalid("${dataExist}" == "false", "${param.from}", _("bulletin.bulletin_invalid"));
//页面大小改变的时候移动ISignatureHTML签章对象，让其到达正确的位置
window.onresize = function (){
	moveISignatureOnResize();
}	
<c:if test="${bean.ext2 != '1'}">
//屏蔽鼠标右键
window.document.oncontextmenu=function(){
	return false;
}
//禁止用户选择并复制数据
window.document.onselectstart=function(){
	return false;
}
</c:if>

function removeCtpWindow(id,type){
    var _top = getA8Top();
    if(id== null || id==undefined){
        id = _top.location+"";
        var _ss = id.indexOf('/seeyon/');
        if(_ss!=-1){
            id = id.substring(_ss)
        }
    }
    if(type == 2){
        _top = getA8Top().opener.getA8Top();
    }
    var _wmp = _top._windowsMap;
    //alert(_wmp.size())
    if(_wmp){
        _wmp.remove(id);
    }
    //alert(_wmp.size())
}

window.onbeforeunload = function(){
    try {
        removeCtpWindow("${bean.id}",2);
    } catch (e) {
    }
}
//-->
</script>
<SCRIPT language=javascript for=SignatureControl 
	event=EventOnSign(DocumentId,SignSn,KeySn,Extparam,EventId,Ext1)>
	  //作用：重新获取签章位置
	  if(EventId = 4 ){
		CalculatePosition();
	  	SignatureControl.EventResult = true;
	  }
</SCRIPT>
<style type="text/css">
body{    
	-moz-user-focus:   ignore;    
	-moz-user-select:   none;    
} 
.padding355{ 
    padding: 35px 39px 35px 39px;
}
ol{margin: auto;}
#htmlContentDiv .contentText {
	text-align: justify;
	min-height: 500px;
}
</style>
</head>
<body scroll="no" onkeydown="listenerKeyESC()" style="height:100%;overflow:hidden;">
<input type="hidden" id="subject" name="subject" value="${v3x:toHTMLWithoutSpaceEscapeQuote(bul_title)}">

<div class="scrollList" id="mainbodyDiv">
  <c:if test="${bulStyle==0 }">
     <%@include file="../include/bulStyle_standard.jsp" %>
  </c:if>
  <c:if test="${bulStyle==1 }">
     <%@include file="../include/bulStyle_formal_1.jsp" %>
  </c:if>
  <c:if test="${bulStyle==2 }">
     <%@include file="../include/bulStyle_formal_2.jsp" %>
  </c:if>
</div>
</body>
<script type="text/javascript">
loadSignatures('${bean.id}',false,false,false,null,false);
var docFavoriteDialog = document.getElementById('docFavoriteDialog');
if(docFavoriteDialog){
	docFavoriteDialog.style.height = "450px";
}
if($("#mainbodyDiv").attr("isload")=="false"){
	$(".comp").each(function(i) {
        $(this).compThis();
    });
	$("#mainbodyDiv").attr("isload","true");
	}
	setTimeout("initFormContent(false,false);",280);
try{
	if (document.getElementById('contentTD').height > 0 ) {
		document.getElementById('contentTD').style.height = document.getElementById('contentTD').height + "px";
	}
}catch(e){}
</script>
</html>