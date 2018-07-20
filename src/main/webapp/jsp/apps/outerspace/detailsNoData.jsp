<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
	<head>
		<meta charset="UTF-8">
		<title></title>
		<link rel="stylesheet" type="text/css" href="/seeyon/outerspace/details/css/style.css" />
		<link rel="stylesheet" type="text/css" href="/seeyon/outerspace/common/skin/skin_red.css" id="skin"/>
		<script src="/seeyon/outerspace/common/js/jquery.cookies.2.2.0.min.js"></script>
		<script type="text/javascript">
			$(document).ready(function(){
				skinStyle();
				function skinStyle(){
					if(!$.cookies.get('path')){
						return;
					} else {
						if(location.href.indexOf("index")== -1){
							$("#skin").attr("href", $.cookies.get('path'));
						} else {
							$("#skin").attr("href", $.cookies.get('path'));
						}
					}
				 }
				alert("内容已取消发布！");
				window.close();
			})
		</script>
		<script type="text/javascript">
		function logoResize(boxWidth,boxHeight){
			var imgWidth=$("#outerspaceLogo").width();
		    var imgHeight=$("#outerspaceLogo").height();
		    if((boxWidth/boxHeight)>=(imgWidth/imgHeight)){        
		    	$("#outerspaceLogo").width((boxHeight*imgWidth)/imgHeight);
		        $("#outerspaceLogo").height(boxHeight);
		        var margin=(boxWidth-$("#outerspaceLogo").width())/2;
		        $("#outerspaceLogo").css("margin-left",margin);
		    } else {
		        $("#outerspaceLogo").width(boxWidth);
		        $("#outerspaceLogo").height((boxWidth*imgHeight)/imgWidth);
		        var margin=(boxHeight-$("#outerspaceLogo").height())/2;
		        $("#outerspaceLogo").css("margin-top",margin);
		    }
		}
		</script>
	</head>
	<body>
		<div class="container">
			<div class="header">
				<div class="wrap">
					<div class="header_logo">
						<ul>
							<li>电子政务网</li>
						</ul>
					</div>
				</div>
			</div>
			<div class="main">
				<div class="main_title">
					<c:if test='${pic_logo != null && pic_logo != ""}' >
						<a href="#"><img id="outerspaceLogo" alt="logo" src='/seeyon/fileUpload.do?method=showRTE&fileId=${pic_logo}&createDate=&type=image' onload="logoResize(320,170)"/></a>
					</c:if>
					<c:if test='${pic_logo == null || pic_logo == ""}' >
						<a href="#"><img id="outerspaceLogo" alt="logo" src='${logoImgUrl}' onload="logoResize(320,170)"/></a>
					</c:if>
				</div>
				<div class="content">
					<div class="acticle">
						<h2 class="detail_title">${title }</h2>
						<p class="info">
							<span>发布时间：${publishDate }</span>
							<span>文章来源：${publishUnit }</span>
						</p>
						<div class="detail">
							${content }
						</div>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>