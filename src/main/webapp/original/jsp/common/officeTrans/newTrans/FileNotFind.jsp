<%@ page language="java" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<html>
  <head>
    <base href="<%=basePath%>">    
    <title>错误提示</title>
    <style type="text/css">P {
		COLOR: #6293bb; FONT-SIZE: 16px
		}
		.clearfix:after {
			DISPLAY: block; HEIGHT: 0px; VISIBILITY: hidden; CLEAR: both; CONTENT: "."
		}
		.clearfix {
			DISPLAY: block;
			WIDTH : 100%;
		}
		.left {
			FLOAT: left;
		}
	</style>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is error page">
  </head>
  
  <body style="text-align: center;background-color: white;">
	<div class="clearfix">
		<div style="padding-top: 0px; float: right;"><img src="/JLibrary/images/A8.png"> </div>
		<div style="clear: both;"></div>
		<div id="no_page" style="width: 100%;display: none;">
			<div style="padding-top: 90px;">
				<img src="/JLibrary/images/no_page.gif">
			</div>
		</div >
		<div id = "error_bg" style="display: none;">
			<img src="/JLibrary/images/error_bg.jpg">
		</div>
		<!-- 2014-04-04黄奎修改，屏蔽掉返回首页链接，否则.Net等其他应用系统在嵌入调用时会报错 -->
		<div style="display:none;padding-top: 10px; padding-right: 0px; padding-bottom: 0px; padding-left: 400px;">
			<a href="javaScript:window.history.back()">
			 	<img border="0" onmouseout="change(this)" onmouseover="change(this)"  src="/JLibrary/images/error_backhomepage.jpg">
			</a>
		</div>
	</div>
  </body>
</html>
<script type="text/javascript">
	window.onload = function() {
		if('${error}' == '404') {
			document.getElementById("error_bg").style.display = 'block';
		} else {
			document.getElementById("no_page").style.display = 'block';
		}
	}

	function change(o) {
		if(o.src.indexOf('over')<0) {
			o.src = o.src.replace('.jpg','_over.jpg')
		} else {
			o.src = o.src.replace('_over.jpg','.jpg')
		}
	}
</script>