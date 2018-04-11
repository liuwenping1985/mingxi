<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html style="height: 100%">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>首页</title>
	
</head>
<body style="overflow: hidden;height: 100%">
<iframe marginheight="0" marginwidth="0" height="100%" style="height: 100%;" src="${OAurl}" name="dataIFrame0" scroll="no" id="dataIFrame0" width="100%" frameborder="0"></iframe>
</body>
<script type="text/javascript">
		window.onload=function(){
			init();
		}
		function init(){
			//初始环境
			window.frames["dataIFrame0"].document.body.style.display="none";
			
			dataIFrame0.window.$._eipsearch("测试","测试");
		}
	</script>
</html>