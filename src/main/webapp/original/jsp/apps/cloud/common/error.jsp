<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="s" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="path" value="${pageContext.request.contextPath}" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
	<head>
		<%@ include file="/main/common/frame_header.jsp" %>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <link href="${path}/skin/default/skin.css" rel="stylesheet" type="text/css" />
		<link href="${path}/${resources_cloud_css}/common.css" rel="stylesheet" type="text/css" />
		<link href="${path}/${resources_cloud_css}/mall.css" rel="stylesheet" type="text/css" />
		<title>${mall_title}-错误</title>
		<style>
			html {
				font-size: 12px;
			}
			
			html, body, div, dl, dt, dd, ul, ol, li, h1, h2, h3, h4, h5, h6, form,
				fieldset, input, textarea, p, th, td, img, label, button, span, a, i,
				em, b, strong {
				margin: 0;
				padding: 0;
				word-break: break-all;
				font-family: Microsoft YaHei, "微软雅黑";
			}
			
			body {
				background: #f7f7f7;
			}
			
			html, body {
				height: 100%;
			}
			
			a {
				color: #0077fb;
				text-decoration: none;
			}
			
			a:hover {
				color: #ff7000;
			}
			
			.e_content {
				text-align: center;
				width: 100%;
				position: absolute;
				top: 50%;
				margin-top: -109px;
			}
			
			.e_content .img {
				vertical-align: middle;
				width: 300px;
			}
			
			.e_content .content {
				display: inline-block;
				color: #666;
				font-size: 18px;
				line-height: 1.6;
				text-align: left;
				position: relative;
				left: -50px;
			}
			
			.e_content .content .p2 {
				font-size: 14px;
				color: #999;
			}
		</style>
	</head>
	
	<body>
		<!--中间-->
	    <div class="e_content">
	    	<img src="${path}/${resources_cloud_img}/icon/error.png" class="img" />
			<div class="content">
				<p>${error_msg}</p>
				<p class="p2">请联系系统管理员或者手动<a href="http://mall.seeyon.com">访问应用中心</a></p>
			</div>
	    </div>
	</body>
</html>