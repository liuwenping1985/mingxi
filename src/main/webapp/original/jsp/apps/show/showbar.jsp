<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.flag.BrowserEnum"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
	<meta name="renderer" content="webkit">
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<link rel="stylesheet" href="${path}/apps_res/show/css/base.css${ctp:resSuffix()}">
	<link rel="stylesheet" href="${path}/apps_res/show/css/show.css${ctp:resSuffix()}">
	<link rel="stylesheet" href="${path}/apps_res/show/css/auto-fix.css${ctp:resSuffix()}">
	<title>${ctp:toHTML(showbarInfo.showbarName) }</title>
	<style type="text/css">
		.photo_wall .feed_text{height: 48px;word-wrap:break-word;word-break:break-all;white-space:-moz-pre-wrap;white-space: normal;line-height: 24px;}
		.photo_wall .feed_text img{cursor: default;}
		.photo_wall .feed_text p{font-size: 14px;}
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
	<%@include file="/WEB-INF/jsp/apps/show/common/showHeader.jsp"%>
	
	<div class="warp">
		<%-- 主题的详细信息 --%>
		<div class="slide-item topic clearfix" style="display:block;">
		    <img  src="${path }/image.do?method=showImage&id=${ showbarInfo.coverPicture}&size=source&handler=show"  ${showbarCover.imagePostfix == 2?'':'width="100%" height="100%"' }/> 
		    <div class="slide-cont"> 
		        <h1 title="${ctp:toHTML(showbarInfo.showbarName) }" class="showbarName">${ctp:toHTML(showbarInfo.showbarName) }</h1> 
		        <p class="photo_info">
			        <c:if test="${!empty showbarInfo.startDate }">
			        	${ctp:formatDate(showbarInfo.startDate) }-
			        </c:if>
			        <c:if test="${!empty showbarInfo.endDate }">
			        	${ctp:formatDate(showbarInfo.endDate) }
			        </c:if>
			        <c:if test="${empty showbarInfo.endDate && !empty showbarInfo.startDate}">
			        	${ctp:i18n('show.showbar.shoebarinfo.now') }
			        </c:if>
			       	<c:if test="${!empty showbarInfo.address }">
				        <span class="location" title="${ctp:toHTMLWithoutSpaceEscapeQuote(showbarInfo.address) }" >
				        	<span class="ico16 show_locationWhite"></span><span class="location-text"></span>
				        </span>
			       	</c:if>
		        </p> 
		        <p class="photo_set">
		        	<span class="amount" title="${ctp:i18n('show.showbar.shoebarinfo.images') }"><span class="ico16 show_imageNumber"></span>${showbarInfo.imgNum }</span>
		        	<span class="hits_gray" title="${ctp:i18n('show.showbar.shoebarinfo.view') }"><span class="ico16 show_clickNumberWhite"></span>${showbarInfo.viewNum }</span>
		        	<span class="estimate_gray" title="${ctp:i18n('show.showbar.shoebarinfo.comment') }"><span class="ico16 show_replyNumberWhite"></span>${showbarInfo.commentNum }</span>
		        	<span class="liked_gray" title="${ctp:i18n('show.showbar.shoebarinfo.like') }"><span class="ico16 show_likeWhite"></span>${showbarInfo.likeNum }</span></p> 
		    </div> 
		    <%-- 是否具有秀吧的编辑权限 --%>
		    <c:if test="${hasEditAuth }">
		    	<a class="edit_show" id="edit_show" href="${path }/show/show.do?method=showbarEdit&showbarId=${showbarInfo.id }">${ctp:i18n('show.showbar.shoebarinfo.edit') }</a>
			</c:if>
		</div>

		<%-- 主题详情下边的页签 --%>
		<div class="nyTab w1208" id="nyTab" style="${!empty showbarInfo.summary?'':'margin-top:0px;'}">
			<ul>
		    	<li class="current showlist"><a href="javascript:;">${ctp:i18n("show.showbar.tab.bigshow") }</a></li><li class="show_photolist"><a href="javascript:;">${ctp:i18n("show.showbar.tab.photowall") }</a></li>
		    </ul>
		</div>
		<div id="container" class="nycontent show_container">
			<div class="Tabcontent clearfix w1208" style="display:block;">
				<!-- 大秀瀑布流 -->
		    	<div class="fl AdaptiveLeft" id="AdaptiveLeft">
		            <div id="showpostCreate"></div>
		            <ul id="showpostList"></ul>
		            <div id="showpostMsg" class="align_center hidden">
		            	<img>
		            	<p class="color_red"></p>
		            </div>
		            <div id="showpostAll" class="showAll_feed_detail hidden">${ctp:i18n("show.showbar.showpost.show.all")}</div>
		        </div>
		        <div class="fr showlistR">
		        
		        	<%-- 主题的授权、简介信息  --%>
		        	<div class="showbar-summary">
				    	<h3 class="showbar-summary-title">${ctp:i18n('show.showedit.placeholder.summary') }</h3>
				    	<div class="showbar-summary-detail">
					    	<div class="showbar-summary-content">
					    		<span class="showbar-summary-name">${ctp:i18n("show.showbar.creator")}：</span>
					    		<a href="javascript:showMemberCard('${showbarInfo.createUserId}')">${ctp:toHTML(ctp:showMemberName(showbarInfo.createUserId)) }</a>
					    	</div>
					    	<div class="showbar-summary-content">
					    		<span class="showbar-summary-name">${ctp:i18n('show.showedit.placeholder.scope') }：</span>
					    		<c:if test="${showbarAuthVO.showbarAuthScope == 'All'}">
									${ctp:i18n('show.showedit.placeholder.allpeople') }(${ctp:i18n('show.showedit.placeholder.allpeople1') })
								</c:if>
								<c:if test="${showbarAuthVO.showbarAuthScope == 'All_extend_externalStaff'}">
									${ctp:i18n('show.showedit.placeholder.allpeople') }(${ctp:i18n('show.showedit.placeholder.allpeople2') })
								</c:if>
								<c:if test="${showbarAuthVO.showbarAuthScope == 'All_group'}">
									${ctp:i18n('show.showedit.placeholder.allgroup') }
								</c:if>
								<c:if test="${showbarAuthVO.showbarAuthScope == 'Part'}">
									${ctp:toHTML(showbarAuthVO.showbarAuthString) }
								</c:if>
					    	</div>
					    	<c:if test="${!empty showbarInfo.summary }">
					    	<div class="showbar-summary-content">
					    		<span class="showbar-summary-name">${ctp:i18n('show.showedit.placeholder.summary') }：</span>
					    		<span class="showbar-summary-name-content">${ctp:toHTML(showbarInfo.summary) }</span>
					    	</div>
					    	</c:if>
				    	</div>
					</div>
		        
		        	<!-- 秀吧详情右边的最热和最新 -->
		            <%@include file="/WEB-INF/jsp/apps/show/common/hotShow.jsp" %>
		        </div>
		    </div>
		    <div class="Tabcontent w1208">
		        <div id="containerWaterfall"></div>
		    </div>
		</div>
	</div>
	
	<%-- 记录页面的基本信息，方便页面js调用 --%>
	<div>
		<input id="showbarId" type="hidden" name="showbarId" value="${showbarInfo.id }" />
		<input id="showpostId" type="hidden" name="showpostId" value="${showpostId }" />
		<input id="commentId" type="hidden" name="commentId" value="${commentId }" />
		<input id="from" type="hidden" name="from" value="${from }" />
	</div>
	
	<%-- 秀吧详情中的模版（大秀瀑布流流和照片墙） --%>
	<%@include file="/WEB-INF/jsp/apps/show/showbar/showbarTpl.jsp" %>
	<%-- 平台的js --%>
	<%@include file="/WEB-INF/jsp/common/common_footer.jsp"%>
	<%-- 秀公用的js --%>
	<%@include file="/WEB-INF/jsp/apps/show/common/showFooter.jsp" %>
	<%-- 主题详情的js --%>
	<script type="text/javascript" src="${path }/apps_res/show/js/showbar/showbar-debug.js${ctp:resSuffix()}"></script>
	
</body>
</html>