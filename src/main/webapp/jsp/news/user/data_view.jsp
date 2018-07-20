<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext,java.util.Locale"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>
<title>${bean.title}</title>
<%@ include file="../include/header_jquery.jsp"%>
<style type="text/css">
<%--表单专属样式start--%>
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
  var _ctxServer = '<%=ctxServer%>';
  var seeyonProductId="${ctp:getSystemProperty("system.ProductId")}";
  var _locale = '<%=locale%>';
</script>
<link rel="stylesheet" type="text/css" href="/seeyon/apps_res/rikaze/css/style.css" />
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

<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/docFavorite.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/ui/seeyon.ui.tooltip-debug.js${v3x:resSuffix()}" />"></script>
<link href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/news/css/news.css${v3x:resSuffix()}" />">
<script type="text/javascript">
	function myOnload(){
	    var parentObj = getA8Top().window.dialogArguments;
	     	if (parentObj){
		 	location.href='#aaa';
		 }	
	}	
	function lookImage(){
		 v3x.openWindow({
				url :"${genericController}?ViewPage=news/audit/lookImage",
				workSpace : true,
				scrollbars: false,
				resizable	: "yes",
				dialogType : "open"	,
				width	: 140,
				height	: 100
			});
	}
	var fromGenius = false;
	try{
	  fromGenius = getA8Top().location.href.indexof('a8genius.do')>-1;
	}catch(e){}
	// 精灵打开不显示,归档不显示
	if(!parent.window.opener && !fromGenius && "${param.openFrom}"!="ucpc" && '${param.fromPigeonhole}'!='true'){
		getDetailPageBreak();
	}	
	refreshAndCloseWhenInvalid("${dataExist}" == "false", "${param.from}", _("NEWSLang.news_invalid"));
	
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
	    if(_wmp){
	        _wmp.remove(id);
	    }
	}
	
	window.onbeforeunload = function(){
	    try {
	        removeCtpWindow("${bean.id}",2);
	    } catch (e) {
	    }
	}
</script>
<style type="text/css">
.padding355{ 
    padding: 35px 39px 35px 39px;
}
#htmlContentDiv .contentText {
	text-align: justify;
}
</style>
</head>

<input type="hidden" id="createDate" name="createDate" value="${bean.createDate}" />
<input type="hidden" id="imageDate" name="imageDate" value="${imageDate}" />
<input type="hidden" id="imageId" name="imageId" value="${bean.imageId}" />
<body scroll="no" style="overflow: hidden;" onload="myOnload();" onkeydown="listenerKeyESC()" >
<input type="hidden" id="subject" name="subject" value="${ctp:toHTML(bean.title)}">


<a name="aaa"></a>

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">		
	<tr height="100%">
		<td width="100%" height="100%" class="body-bgcolor" style="background-color:#fff" valign="top" style="padding-bottom: 8px;" align="center">
				<div class="scrollList" id="mainbodyDiv" style="">
						<div class="rkz_top" style="margin-bottom:0px">
								<div class="rkz_header">
									<div class="rkz_banner_left">
										<div class="rkz_logo">
											<img class="rkz_logo" src="/rikaze/page/images/logo4.png">
										</div>
										<div class="rkz_banner">日喀则市纪委监委内部工作网</div>
							
							
									</div>
								</div>
							</div>
			<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="${bean.dataFormat=='HTML'?'body-detail':'body-detail-office'} margin-auto">
		<tr>
		<td height="60">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr class="page2-header-line-old">
				<td width="100%" height="60">
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center" class="CollTable">
						<tr class="page2-header-line-old" height="60">
							 <td width="80" height="60"><span class="new_img"></span></td>
		        			 <td id="page_title" class="page2-header-bg-old"></td>
		       				 <td class="page2-header-line-old page2-header-link" align="right">&nbsp;</td> 
							<td align="right" class="padding5">
							 <c:if test="${bean.imageNews}">
                             <input type="button" id="submitBtn" class="button-default-2" onclick="lookImage();" value="<fmt:message key='new.lookImage' />" />
                             </c:if>
                            <!-- 关联文档不显示收藏，打印 -->
							<c:if test="${param.fromPigeonhole!=true && docCollectFlag eq 'true'}">
                                    <span id="cancelFavorite${bean.id}" class="font-size-12 cursor-hand ${!isCollect?'hidden':''}" onclick="javaScript:cancelFavorite_old('8','${bean.id}','${bean.attachmentsFlag }','3','',false,20)">
                                        <img class="cursor-hand" style="vertical-align: middle;margin-top: -1px;" src="<c:url value="/apps_res/doc/images/uncollect.gif" />">
                                        <fmt:message key='news.cancel.favorite' />
                                    </span>
                                    <span id="favoriteSpan${bean.id}" class="font-size-12 cursor-hand ${isCollect?'hidden':''}" onclick="javaScript:favorite_old('8','${bean.id}','${bean.attachmentsFlag }','3')">
                                        <img class="cursor-hand" style="vertical-align: middle;margin-top: -1px;" src="<c:url value="/apps_res/doc/images/collect.gif"/>">
                                        <fmt:message key='news.favorite' />
                                    </span>
                            </c:if>
                            <c:if test="${param.openFrom ne 'glwd'}">
								<span class="font-size-12 margin_r_10 cursor-hand" href="javascript:void(0);" name="mergeButton" onclick="printResult('${(not empty bean.ext5 && bean.dataFormat == 'OfficeWord') ? 'Pdf' : bean.dataFormat}')" >
	                                <img class="cursor-hand" style="vertical-align: middle;margin-top: -1px;" src="<c:url value="/common/images/toolbar/print.gif"/>">
	                                <fmt:message key="oper.print" />
	                            </span>
                            </c:if>
                           </td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		</td>
		</tr>
		<tr>
		<td valign="top"><div id="printThis"><!-- 打印开始 -->
		<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
			 <td height="30">
			 	<table border="0" cellpadding="0" cellspacing="0" width="100%">
				 <tr>
				 	<td width="35">&nbsp;</td>
				   <td align="center" width="90%" class="titleCss" style="line-height:35px;padding: 20px 0px 10px 0px;">${v3x:toHTML(bean.title)}</td>
				   <td width="35">&nbsp;</td>
				  </tr>
				</table>
			 </td>
			</tr>
			<tr>
				<td class="padding35">
				<table width="100%" height="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td class="font-12px" align="center" height="28" style="padding: 0 0 10px 0;">
							<fmt:formatDate value="${bean.publishDate}" pattern="${datePattern}" /> 
							&nbsp;&nbsp;&nbsp;&nbsp;
							${v3x:toHTML(bean.publishDepartmentName)}
							<c:if test="${bean.showPublishUserFlag }">
							&nbsp;&nbsp;&nbsp;&nbsp;
							${bean.createUserName}
							</c:if>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<fmt:message key="label.readCount" />: ${bean.readCount}
						</td>
					</tr>
					<c:if test="${false&&bean.showKeywordsArea == true || false&&bean.showBriefArea == true}">
					<tr>
						<td height="${bean.showBriefArea == true? '60':'28'}">
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<c:if test="${false&&bean.showKeywordsArea == true}"> 
							<tr>
								<td class="font-12px" align="right" width="60" height="24"><b><fmt:message key="news.data.keywords" />:</b></td>
								<td class="font-12px" style="padding: 0 12px;">
									${v3x:toHTML(bean.keywords)}
								</td>
							</tr>
							</c:if>
							<c:if test="${false&&bean.showBriefArea == true}">
							<tr>
								<td class="font-12px" valign="top" height="40" width="60" nowrap="nowrap" align="right"><b><fmt:message key="news.data.brief"/>:</b></td>
								<td class="font-12px" valign="top" style="padding: 0 12px;">${v3x:toHTML(bean.brief)}</td>
							</tr>
							</c:if>
							</table>
						</td>	
					</tr>
					</c:if>
				</table>
				</td>
			</tr>
			<tr>
				<td width="100%" id="contentTD" height="${(bean.dataFormat!='HTML' && bean.dataFormat!='FORM') ? '768px' : '100%'}" style="padding-bottom: 6px;" valign="top">
				    <div style="height:100%">
				    	<v3x:showContent content="${empty bean.ext5 ? bean.content : bean.ext5}" type="${empty bean.ext5 ? bean.dataFormat : 'Pdf'}" createDate="${bean.createDate}" htmlId="content"  viewMode="edit"/>
                    </div>
                    <style>
                        .contentText p{
                            font-size:16px;
                        }
                    </style>
					<!-- 
					<c:if test="${bean.dataFormat == 'OfficeWord' || bean.dataFormat == 'OfficeExcel'}">
						<%-- 此处div的id只能是"edocContentDiv", 用来控制office控件懒加载, 如果以后showContent组件支持这个属性后可以修改此名称 --%>
						<div id="edocContentDiv" style="display: none; width: 0px; height: 0px;">
							<v3x:showContent content="${bean.content}" type="${bean.dataFormat}" createDate="${bean.createDate}" htmlId="content" viewMode ="edit" />
						</div>
					</c:if>
					 -->
				</td>
			</tr>
			<!-- 关联文档显示内容-->
        <tr id="attachment2Tr" style="display: none">
          <td class="paddingLR" height="30" colspan="6">
           <table  border="0" cellspacing="0" cellpadding="0" width="100%" height="100%">
                <tr>
                    <td height="10" valign="top" colspan="6" class="border-top">
                        &nbsp;
                    </td>
                </tr>
                
                <tr style="padding-bottom: 20px;">
                    <td nowrap="nowrap" width="70" class="font-12px" valign="top"><b><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:&nbsp;</b></td>
                    <td width="100%" class="font-12px" style="padding-bottom: 20px;">
                      <v3x:attachmentDefine attachments="${attachments}" /> 
                        <script type="text/javascript">     
                            showAttachment('${bean.id}', 2, 'attachment2Tr', '');       
                        </script>
                    </td>
                 </tr>
            </table>
          </td>
        </tr>
        <!-- end -->
       		<!-- 附件显示内容-->
			<tr id="attachmentTr" style="display: none;">
				<td class="paddingLR" height="50" valign="top">
					<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td height="6" valign="top" colspan="2" class="border-top">
								&nbsp;
							</td>
						</tr>
					    <tr style="padding-bottom: 100px;">
							<td valign="top" nowrap="nowrap" width="50" class="font-12px"><b><fmt:message key="label.attachments" />:&nbsp;</b></td>
							<td valign="top" width="100%" class="font-12px">
							  <v3x:attachmentDefine	attachments="${attachments}" />		   
								<script type="text/javascript">					
									showAttachment('${bean.id}', 0, 'attachmentTr', '');					
								</script>
							</td>
						 </tr>
					 </table>
				</td>
			</tr> 
		</table></div><!-- 打印结束 -->
		</td>
		</tr>	
		</table>
		</td>
	</tr>
</table>
</div>
</body>

<script type="text/javascript">
    //表单签章相关,hw.js中需要用到
    var hwVer = '<%=DBstep.iMsgServer2000.Version("iWebSignature")%>';
    var webRoot = _ctxServer;
    var htmOcxUserName = $.ctx.CurrentUser.name;
    var _ctxPath = '<%=ctxPath%>', _ctxServer = '<%=ctxServer%>';
   
</script>
<SCRIPT language=javascript for=SignatureControl 
    event=EventOnSign(DocumentId,SignSn,KeySn,Extparam,EventId,Ext1)>
      //作用：重新获取签章位置
      if(EventId = 4 ){
        CalculatePosition();
        SignatureControl.EventResult = true;
      }
</SCRIPT>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/office/js/hw.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
loadSignatures('${bean.id}',false,false,false,null,false);
var docFavoriteDialog = document.getElementById('docFavoriteDialog');
if(docFavoriteDialog){
	docFavoriteDialog.style.height = "450px";
}

if (window.screenTop > 200) {
	document.getElementById('mainbodyDiv').style.height = "97%";
}
if($("#mainbodyDiv").attr("isload")=="false"){
$(".comp").each(function(i) {
    $(this).compThis();
});
$("#mainbodyDiv").attr("isload","true");
}
setTimeout("initFormContent(false,false);",280);
/*try{
    if (document.getElementById('contentTD').height > 0 && document.getElementById('officeFrameDiv')) {
        //document.getElementById('officeFrameDiv').style.height = document.getElementById('contentTD').height + "px";
    }
}catch(e){}*/
function GetRequest() {  
   var url = location.search; //获取url中"?"符后的字串  
   var theRequest = new Object();  
   if (url.indexOf("?") != -1) {  
      var str = url.substr(1);  
      strs = str.split("&");  
      for(var i = 0; i < strs.length; i ++) {  
         theRequest[strs[i].split("=")[0]]=unescape(strs[i].split("=")[1]);  
      }  
   }  
   return theRequest;  
}
var title__ = document.getElementById("page_title");
	var params = GetRequest();
	if(params['type']){
		if(params['type']=="1"){
			title__.innerHTML="工作动态";
		}
		if(params['type']=="2"){
			title__.innerHTML="信息简报";
		}
	}
</script>
</html>