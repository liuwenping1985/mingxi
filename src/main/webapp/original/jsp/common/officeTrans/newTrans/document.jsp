<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.netpower.library.util.config.Config"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/JLibrary/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>致远文库</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta name="viewport" content="initial-scale=1,user-scalable=no,maximum-scale=1,width=device-width" />

		<link href="<%=basePath %>css/filelist.css" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" type="text/css" href="<%=basePath %>flexpaper/css/flexpaper.css" />
		<script type="text/javascript" src="<%=basePath %>js/jquery/jquery-1.9.1.min.js"></script>
		<script type="text/javascript" src="<%=basePath %>js/jquery/jquery.extensions.min.js"></script>
		<script type="text/javascript" src="<%=basePath %>flexpaper/js/flexpaper.js"></script>
		<script type="text/javascript" src="<%=basePath %>flexpaper/js/flexpaper_handlers.js"></script>
    	<script type='text/javascript' src='<%=basePath %>js/common.js'></script>
		<script type="text/javascript">
			var startDocument = "${filePath }";//将要预览文档的完整物理路径
			var swfSizeServiceUrl = "<%=basePath %>SwfSizeServlet?doc=" + startDocument;
			//var searchServiceUrl = escape("ContainsTextServlet?doc="+startDocument+"&page=[page]&searchterm=[searchterm]");
			
			/**
			*浏览器窗口改变事件
			*/
			$(window).resize(function(){
			  	initLayout();
			});
			
			
			function getDocumentUrl(document){
				var numPages = "${totalPage }";
				var url = "{<%=basePath %>DocViewServlet?doc={doc}&format={format}&totalPage={totalPage}&page=[*,0],{numPages}}";
				url = url.replace("{doc}",document);
				url = url.replace("{numPages}",numPages);
				url = url.replace("{totalPage}",numPages);
				return url;
			}
			
			String.format = function() {
				var s = arguments[0];
				for (var i = 0; i < arguments.length - 1; i++) {
					var reg = new RegExp("\\{" + i + "\\}", "gm");
					s = s.replace(reg, arguments[i + 1]);
				}
				return s;
			};
			
			function initLayout()
			{
				var docViewerHeight = document.documentElement.clientHeight - $('#filePath').height() - $('#doc-header').height() - 25;
				$('#documentViewer').height(docViewerHeight);
				$('#documentViewer').css("width","100%");
			}	
			
			/**
			*获取浏览器对象
			*/
			var OsObject = function ()  
			{  
			  var ua = navigator.userAgent.toLowerCase();  
			  var isOpera = ua.indexOf("opera") > -1,  
			      isIE = !isOpera && ua.indexOf("msie") > -1,  
			      isIE7 = !isOpera && ua.indexOf("msie 7") > -1;  
			  return {  
			   isIE : isIE,  
			   isIE6 : isIE && !isIE7,  
			   isIE7 : isIE7,  
			   isFirefox : ua.indexOf("firefox")>0,  
			   isSafari : ua.indexOf("safari")>0,  
			   isCamino : ua.indexOf("camino")>0,  
			   isGecko : ua.indexOf("gecko/")>0  
			  };  
			}();  
			
			/**
			*停用鼠标滚轴事件
			*/
			function disWheel(evt)  
			{  
			  if(!evt) evt=window.event;  
			  var delta=0;  
			  if(OsObject.isFirefox)  
			  {  
			    delta = -evt.detail/2;  
			    //alert(delta); // 可以调用Flash接口,让flash响应滚轮  
			    if(evt.preventDefault)  
			      evt.preventDefault();  
			    evt.returnValue = false;  
			  }else if(OsObject.isIE)  
			  {  
			    delta = evt.wheelDelta/60;  
			    //alert(delta); // 可以调用Flash接口,让flash响应滚轮  
			    return false;  
			  }  
			}  
			
			/**
			*监听鼠标滚轴事件
			*/
			EnableWheelScroll = function (enable)  
			{  
			  if(enable)  
			  {  
			    if(OsObject.isFirefox)  
			    {  
			      window.removeEventListener('DOMMouseScroll', disWheel, false);  
			    }  
			    else if(OsObject.isIE)  
			    {  
			      window.onmousewheel = document.onmousewheel = function(){return true};  
			    }  
			  }  
			  else // disable  
			  {  
			    if(OsObject.isFirefox)  
			    {  
			      window.addEventListener('DOMMouseScroll', disWheel, false);  
			    }  
			    else if(OsObject.isIE)  
			    {  
			      window.onmousewheel = document.onmousewheel = disWheel;  
			    }  
			  }  
			}  		
			
			$(document).ready(function() {
				$('#documentViewer').mouseover(function(){
				  	EnableWheelScroll(false);//鼠标移动到阅读器部分，禁用鼠标滚轴事件防止，防止冒泡，否则网页和flash阅读器同时滚动就会花屏
				}).mouseout(function(){
				  	EnableWheelScroll(true);//鼠标离开阅读器部分，开启鼠标滚轴事件防止，用于滚动网页
				});
				getParentNav();
				initLayout();//设置文档阅读器布局
				$('#documentViewer').FlexPaperViewer({
					 config : {
						 DOC : encodeURIComponent(getDocumentUrl(startDocument)),
						 Scale : 0.6, 
						 ZoomTransition : 'easeOut',
						 ZoomTime : 0.5, 
						 ZoomInterval : 0.1,
						 FitPageOnLoad : true,
						 FitWidthOnLoad : true, 
						 FullScreenAsMaxWindow : false,
						 ProgressiveLoading : false,
						 MinZoomSize : 0.2,
						 MaxZoomSize : 5,
						 SearchMatchAll : false,
						 //SearchServiceUrl : searchServiceUrl,
						 RenderingOrder : '<%=(Config.RenderType.flash + "," +	Config.RenderType.html) %>',
	
						 ViewModeToolsVisible : true,
						 ZoomToolsVisible : true,
						 NavToolsVisible : true,
						 CursorToolsVisible : true,
						 SearchToolsVisible : true,
	
						 IsMin:false,
						 DocSizeQueryService : swfSizeServiceUrl,
						 basePath : '<%=basePath %>',
						 jsDirectory : '<%=basePath %>flexpaper/js/',
						 cssDirectory : '<%=basePath %>flexpaper/css/',
						 localeDirectory : '<%=basePath %>flexpaper/locale/',
	
						 JSONDataType : 'jsonp',
						 key : '<%=basePath %>flexpaper/license/LICENSE-UNLIMITED.txt',
	
						 WMode : 'transparent',
						 localeChain: 'zh_CN'
					}
				});
			});
			
			function changeImg(o) {
				if(o.src.indexOf('03.png')<0) {
					o.src = o.src.replace('02.png','03.png');
				} else {
					o.src = o.src.replace('03.png','02.png');
				}								
			}
			
			function openFile(id) {
				window.close();
				window.opener.openParentFile(id);
			}
			
			// 获取当行信息
			function getParentNav() {
				try { // 处理邮件页面直接打开
					$("#filePath").html(window.opener.getFilePath());
					$("#filePath a").each(function(){ 
						$(this).attr("title", "返回到："+$(this).attr("fileName")).removeAttr("disabled").removeClass("filePathLast").addClass("filePath").css("color", "#2d64b3");
						$(this).children("div").each(function(){$(this).removeClass("filePathLast_Back").addClass("filePath_Back"); });
					});
					$("#filePath a:last-child").each(function(){ 
						$(this).removeAttr("title").attr("disabled", "disabled").removeClass("filePath").addClass("filePathLast");
						$(this).children("div").each(function(){$(this).removeClass("filePath_Back").addClass("filePathLast_Back"); });
					});
				} catch (e) {
				}
			}
			
			//下载文件
			function downLoadFile(filePath, fileName) { 
				w_open('<%=basePath %>DownloadServlet?filePath='+encodeURIComponent(encodeURIComponent(filePath))+'&fileName='+encodeURIComponent(encodeURIComponent(fileName)), 802, 599, arguments[5]);
			}
		</script>
    </head>
    <body>    
    	<div class="bd-wrap">
			<div id="filePath" class="crubms-wrap">
			</div>
			<div id="doc-header" class="hd doc-header w-width">
				<span class="act" style="float: right;"><span
					class="download2mobile view-download2mobile"><a 
						title="文档下载"
						onclick="downLoadFile('${fn:escapeXml(filePath)}','${fn:escapeXml(fileName)}')"
						href="javascript:void(0);"> <img alt="文档下载" onmouseover="changeImg(this)" onmouseout="changeImg(this)"
								src="flexpaper/images/download_02.png">
					</a>
				</span>
				</span>
				<h1 class="reader_ab_test">
					<b class="ic ic-doc"></b><span id="doc-tittle-5">${fileName}
					</span><span class="viewCount ml5">文件长度：${fileSize}</span>
				</h1>
			</div>
			<div id="documentViewer" class="w-width"></div>
    	</div>		
   </body>
</html>