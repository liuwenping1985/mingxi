<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.apps.show.ShowConstants.ShowbarListEnum" %>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.flag.BrowserEnum"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
	<meta name="renderer" content="webkit">
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<title>${ctp:i18n('show.myshow.title') }</title>
	<link rel="stylesheet" href="${path}/apps_res/show/css/base.css${ctp:resSuffix()}">
	<link rel="stylesheet" href="${path}/apps_res/show/css/show.css${ctp:resSuffix()}">
	<link rel="stylesheet" href="${path}/apps_res/show/css/auto-fix.css${ctp:resSuffix()}">
	<style type="text/css">
	   .anyshow-area{top:155px}
	</style>
</head>
<body>
	<!-- 首页header -->
	<%@include file="/WEB-INF/jsp/apps/show/common/showHeader.jsp" %>
	<div class="warp">
		<div class="myshowTab w1208" id="nyTab">
			<ul>
				<li class="myPhotos"><a href="javascript:void(0);">${ctp:i18n('show.myShow.showbar.myPhotos') }</a></li><li class="iCreated"><a href="javascript:void(0);">${ctp:i18n('show.myShow.showbar.myCreated') }</a></li><li class="iReleased"><a href="javascript:void(0);">${ctp:i18n('show.myShow.showbar.myJoined') }</a></li>
			</ul>
		</div>
		<div id="container" class="myshowContent">
			<!-- 我的相册 -->
			<div class="Tabcontent w1208 detailsC display_none clearfix">
			<div class="fl AdaptiveLeft" id="AdaptiveLeft">            
	            <ul id="talkList"></ul>
	        </div>
	        <div class="fr showlistR">
	        	<!-- 最热秀+最新秀 -->
	            <%@include file="/WEB-INF/jsp/apps/show/common/hotShow.jsp" %>
	        </div>
			</div>
			<!-- 我创建的 -->
			<div class="Tabcontent w1208 display_none" data-option="type:'<%=ShowbarListEnum.MyCreated.ordinal()%>'">
				<div class="doublePartOut clearfix"></div> 
			</div>
			<!-- 我参与的 -->
			<div class="Tabcontent w1208 clearfix"  data-option="type:'<%=ShowbarListEnum.MyJoined.ordinal()%>'">
				<div class="doublePartOut clearfix"></div>
			</div>
		</div>
	</div>
	
	<%-- 我的主题模板 --%>
	<%@include file="/WEB-INF/jsp/apps/show/myshow/myshowTpl.jsp" %>
	<%-- 平台的js --%>
	<%@include file="/WEB-INF/jsp/common/common_footer.jsp"%>
	<%-- 秀公用的js --%>
	<%@include file="/WEB-INF/jsp/apps/show/common/showFooter.jsp" %>
	<%-- 我的主题 --%>
	<script type="text/javascript" src="${path }/apps_res/show/js/myShow/my-show-debug.js${ctp:resSuffix()}"></script>
</body>
</html>