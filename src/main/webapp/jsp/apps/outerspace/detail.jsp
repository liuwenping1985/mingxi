<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title></title>
		<link rel="stylesheet" type="text/css" href="${path}/main/login/default-G6/common/css/common.css${ctp:resSuffix()}"/>
		<link rel="stylesheet" type="text/css" href="${path}/main/login/default-G6/detail/css/style.css${ctp:resSuffix()}"/>
		<link rel="stylesheet" type="text/css" href="${path}/main/login/default-G6/common/skin/skin_red.css${ctp:resSuffix()}" id="skin"/>
		<script src="${path}/main/login/default-G6/index/js/index.js${ctp:resSuffix()}"></script>
		<script src="${path}/main/login/default-G6/common/js/jqthumb.min.js${ctp:resSuffix()}"></script>
	</head>
	<body>
	<div class="container">
			<div class="header">
				<div class="wrap">
					<div class="header_logo">
						<ul>
							<li>电子政务网</li>
							<li class="no_r_border"><a href="../index.html">首页</a></li>
						</ul>
					</div>
				</div>
			</div>
			<div class="main">
				<div class="main_title">
					<a href="../index.html"><h1></h1></a>
				</div>
				<div class="content">
					<div class="acticle">
						<h2 class="detail_title">${title }</h2>
						<p class="info">
							<span>发布时间：${publishDate }</span>
							<span>文章来源：${publishUnit }</span>
						</p>
						<div class="detail">
							<p>${content }</div>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>