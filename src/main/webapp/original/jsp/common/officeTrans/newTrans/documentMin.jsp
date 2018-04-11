<%@ page language="java" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/JLibrary/";
	String basePath2 = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>致远文库</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta name="viewport" content="initial-scale=1,user-scalable=no,maximum-scale=1,width=device-width" />
        <style type="text/css">
			html, body, *{
				overflow: hidden;
				background-color: #ffffff;
				margin: 0px;
				padding: 0px;
				width: 100%;
			}
		</style>
		<script type="text/javascript" src="<%=basePath %>js/jquery/jquery-1.9.1.min.js"></script>
		<script type="text/javascript" src="<%=basePath %>flexpaper/js/flexpaper.js?v=20170405"></script>
		<script type="text/javascript" src="<%=basePath %>flexpaper/js/flexpaper_handlers.js"></script>
		<script type="text/javascript">
			//var startDocument = "${filePath }";//将要预览文档的完整物理路径
			var swfSizeServiceUrl = "<%=basePath %>SwfSizeServlet?doc=";
			//var searchServiceUrl = escape("ContainsTextServlet?doc="+startDocument+"&page=[page]&searchterm=[searchterm]");
			
			/**
			*浏览器窗口改变事件
			*/
			$(window).resize(function(){
			  	initLayout();
			});
			
			
			function getDocumentUrl(){
				var numPages = "${totalPage }";
				var fileId="${fileId}";
				var dateStr="${dateStr}";
				var rn=Math.random();
				var url = "{<%=basePath2%>/officeTrans.do?rn={rnNum}&method=docView&fileId={fileId}&dateStr={dateStr}&format={format}&totalPage={totalPage}&page=[*,0],{numPages}}";
				url = url.replace("{fileId}",fileId);
				url = url.replace("{dateStr}",dateStr);
				url = url.replace("{numPages}",numPages);
				url = url.replace("{totalPage}",numPages);
				url= url.replace("{rnNum}",rn);
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
				var docViewerWidth = document.documentElement.clientWidth;
				var docViewerHeight = document.documentElement.clientHeight;
				$('#documentViewer').width(docViewerWidth).height(docViewerHeight);
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
				initLayout();//设置文档阅读器布局
				$('#documentViewer').FlexPaperViewer({
					 config : {
						 DOC :getDocumentUrl(),
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
						 RenderingOrder : '<%=("flash" + "," +	"html") %>',
	
						 ViewModeToolsVisible : true,
						 ZoomToolsVisible : true,
						 NavToolsVisible : true,
						 CursorToolsVisible : true,
						 SearchToolsVisible : true,
	
						 IsMin:true,
						// DocSizeQueryService : swfSizeServiceUrl,
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
		</script>
    </head>
    <body>    
		<div id="documentViewer"></div>
   </body>
</html>