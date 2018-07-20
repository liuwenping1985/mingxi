<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<HTML>
<HEAD>
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<meta HTTP-EQUIV="Cache-Control" CONTENT="no-store"> 
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/SelectPeople/js/orgDataCenter.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/seeyon.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
var v3x = new V3X();
window.onload = function (){
	document.cookie="JSESSIONID=${jsessionid}; Path=/";
  window.blur();
	var h=window.screen.Height;
	var w=window.screen.Width;	
	var rv;
	var openArgs = {};
	url = "<html:link renderURL='/a8genius.do' />?method=window&url=" + escape("${url}") + "&jsessionid=${jsessionid}";
	openArgs["url"] = url;

	// 文档中心的操作需要打开新的对话框，而模态对话框打开的窗口不支持对parent进行reload
	// 而协同公文撤销是通过window.dialogArguments来判断该关闭窗口还是refresh，如果不用模态对话框打开会陷入死循环
	if(url.indexOf('/doc.do')>-1){
		//rv = window.open(url, '', 'height='+window.screen.height+', width='+window.screen.width+', top=0, left=0, toolbar=no, menubar=no, scrollbars=no,resizable=no,location=no, status=no,fullscreen=no');
		//rv.moveTo(0, 0);
		//rv.resizeTo(screen.width, screen.height - 25);
	  var width = screen.width;
	  var height = screen.height - 100;
      openArgs["dialogType"] = "open";
	  openArgs["width"] = width;
	  openArgs["height"] = height;
	  openArgs["left"] = 1;
	  openArgs["top"] = 1;
	  rv = v3x.openWindow(openArgs);
	}
	else{
		window.resizeTo(0,0);
		if(url.indexOf('calEvent.do')>-1){
			  var width = 520;
			  var height = 560;
			  openArgs['width'] = width;
			  openArgs['height'] = height;
			  var x = parseInt(screen.width / 2.0)
			  var y =parseInt(screen.height / 2.0);
			  window.moveTo(x,y);
			  rv = v3x.openWindow(openArgs);
			  
		}else{
		    openArgs["FullScrean"] = "yes";	
		    window.moveTo(h,w);
		    rv = v3x.openWindow(openArgs);
	  }
		
	}
	
	if(typeof(window.opener) != "undefined"&&typeof(window.opener.link_open_state) != "undefined"){
		try{
	    window.opener.link_open_state  = false;
	  }
	  catch(e){
	   //忽略opener已关闭的错误
	  }
	}
	window.opener=null;
  	window.open('','_self');	
	getA8Top().window.close();
}

function winopen(targeturl){
	var isMSIE = (navigator.appName == "Microsoft Internet Explorer");
	if(isMSIE){
		var newwin = window.open('', '', 'resizable=true,status=no');
		try{
			newwin.focus();
		}
		catch(e){
			alert("您打开了窗口拦截的功能，请先关闭该功能。 \n请点击首页的《辅助程序安装》。");
			self.history.back();
			return;
		}
		if(newwin != null && document.all){
			newwin.moveTo(0, 0);
			newwin.resizeTo(screen.width, screen.height - 25);
		}
		newwin.location = targeturl;
	}
	else{
		window.open (targeturl, '', 'height='+window.screen.height+', width='+window.screen.width+', top=0, left=0, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no')
	}
}
//-->
</SCRIPT>
</head>
<body>
</body>
</html>