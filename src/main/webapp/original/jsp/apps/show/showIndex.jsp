<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page isELIgnored="false" import="com.seeyon.ctp.common.flag.BrowserEnum"%>
<%@page import="com.seeyon.apps.show.ShowConstants.ShowbarListEnum" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
	<meta name="renderer" content="webkit">
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<title>${ctp:i18n('show.showIndex.title') }</title>
	<link rel="stylesheet" href="${path}/apps_res/show/css/base.css${ctp:resSuffix()}">
	<link rel="stylesheet" href="${path}/apps_res/show/css/show.css${ctp:resSuffix()}">
	<link rel="stylesheet" href="${path}/apps_res/show/css/auto-fix.css${ctp:resSuffix()}">
	<style type="text/css">
			#photosWaterfall .feed_text{height: 48px;word-wrap:break-word;word-break:break-all;white-space:-moz-pre-wrap;white-space: normal;line-height: 24px;}
			#photosWaterfall .feed_text img{cursor: default;}
			#photosWaterfall .feed_text p{font-size: 14px;}
	</style>
	<%
		//OA-87090我的相册和秀秀列表，秀圈描述较长时，描述内容被截断了，具体见截图
		String browserString=BrowserEnum.valueOf1(request);
		if(browserString != "Chrome" || browserString != "IE7"){
	%>
		<style type="text/css">
			.msgCnt p img{margin-top: -2px;}
		</style>
	<%
		}
	%>
</head>
<body>
	<%-- 大秀的顶部   --%>
	<%@include file="/WEB-INF/jsp/apps/show/common/showHeader.jsp" %>
	
	<%-- 最新最热文字列表   --%>
	<div class="tag_groups_box"></div>
	
	<div class="warp">
	
		<%-- 首页秀吧轮播dom --%>
		<div class="slider-container w1208" id="carousel" ></div>
		<div style="text-align: center; clear: both"></div>
		
		<!-- 秀吧首页列表[Start] -->
		<div class="indexTab w1208" id="indexTab">
			<ul>
				<li class="newest"><a href="javascript:void(0);">${ctp:i18n('show.showIndex.showbar.newest') }</a></li><li class="showcases"><a href="javascript:void(0);">${ctp:i18n('show.showIndex.showbar.hottest') }</a></li><li class="show_photolist"><a href="javascript:void(0)">${ctp:i18n('show.showIndex.showbar.shows') }</a></li>
			</ul>
		</div>
		<div id="container">
			<!-- 主题 -->
			<div class="Tabcontent w1208"  data-option="type:'<%=ShowbarListEnum.NewHot.ordinal()%>'">
				<%-- <div class="singelPart"></div>  --%>
				<div class="doublePartOut clearfix"></div>
			</div>
			<!-- 大秀 -->
			<div class="Tabcontent w1208 detailsC display_none clearfix">
				<div style="margin-top: 30px;"></div>
				<div class="fl AdaptiveLeft" id="AdaptiveLeft">            
			         <ul id="talkList" style="margin-top:-20px;"></ul>
				</div>
				<div class="fr showlistR">
		        	<!-- 最热秀+最新秀 -->
		            <%@include file="/WEB-INF/jsp/apps/show/common/hotShow.jsp" %>
		        </div>
		    </div>
			<!-- 首页照片墙 -->
		    <div class="Tabcontent w1208">
		    	<div style="margin-top: 30px;"></div>
				<div id="photosWaterfall"></div>
			</div>
		</div>
		<!-- 秀吧首页列表[End] -->
		
	</div>
	
	<%-- 秀首页的模板 --%>
	<%@include file="/WEB-INF/jsp/apps/show/showindex/showIndexTpl.jsp" %>
	
	<%-- 平台的js --%>
	<%@include file="/WEB-INF/jsp/common/common_footer.jsp"%>
	<%-- 秀公用的js --%>
	<%@include file="/WEB-INF/jsp/apps/show/common/showFooter.jsp" %>
	<%-- 秀首页js --%>
	<script type="text/javascript" src="${path }/apps_res/show/js/showIndex/showbar-selector-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/apps_res/show/js/showIndex/showbar-carousel-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/apps_res/show/js/showIndex/show-index-debug.js${ctp:resSuffix()}"></script>

</body>
</html>