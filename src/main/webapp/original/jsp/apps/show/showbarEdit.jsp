<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>${title }</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="renderer" content="webkit">
	<link rel="stylesheet" type="text/css" href="${path}/apps_res/show/css/base.css${ctp:resSuffix()}">
	<link rel="stylesheet" type="text/css" href="${path}/apps_res/show/css/show.css${ctp:resSuffix()}">
	<link rel="stylesheet" type="text/css" href="${path}/apps_res/show/css/auto-fix.css${ctp:resSuffix()}">
	<style type="text/css">
		.upload_banner .webuploader-container{position:absolute;}
		input[placeholder]{ font-color:#FFF; } 
		input::-webkit-input-placeholder { color: #FFF; } 
		input:-moz-placeholder {color: #FFF; } 
		input::-moz-placeholder {color: #FFF; } 
		input:-ms-input-placeholder {color: #FFF; } 
		input:-ms-input-placeholder{ color: #FFF;} 
		.captureImage{display:none; z-index:10000;background:#000;background-color:rgba(0,0,0,0.5); background: url(${path}/apps_res/show/images/common/blackOpacity50.png) \9; width: 100%;height: 100%;position:fixed;top: 0px;left: 0px;}
		.cpdiv{margin:30px auto 10px;text-align:center;position: relative;}
		.capAtion{width:700px;text-align:center;}
		.header{position:relative; }
		.warp{margin-top:-60px;margin-bottom: 60px;}
		.showAction{position: fixed;width: 100%;bottom: 0px;}
		.changeDate{cursor: pointer;}
		.focus-banner-text .error-input{border-color:red;}
		.focus-banner-text .ok-input{border-color:#fff;border-color:rgba(255,255,255,0.4);}
	</style>
	<!--[if lt IE 9]>
	<script type="text/javascript" src="${path}/common/respond/respond.min.js${ctp:resSuffix()}"></script>
	<![endif]-->
</head>
<body>
	<!-- 首页header -->
	<%@include file="/WEB-INF/jsp/apps/show/common/showHeader.jsp"%>
	<div class="warp">
		<form action="${path}/show/show.do?method=saveShowbarInfo" id="showBarForm" method="post">
			<div id="focus-banner" class="w1208">
			
			   <%--轮播效果 --%>
				<ul id="focus-banner-list">
					<%-- 使用了非预制封面--%>
					<c:if test="${isnotDefaultPic }">
						<li id="${ showbarCover.id}" class="upload_li display_none">
							<a href="javascript:;" class="focus-banner-img">
								<img src="${path }/image.do?method=showImage&id=${ showbarCover.id}&size=source&handler=show"  alt="${ showbarCover.imageName}"  title="${ showbarCover.imageName}" ${showbarCover.imagePostfix == 2?'':'style="width: 100%; height: 100%;"' }	 />
							</a>
						</li>
					</c:if>
					<c:forEach items="${defaultCovers }" var="showImage" varStatus="st">
						<li id="${ showImage.id}">
							<a href="javascript:;" class="focus-banner-img">
								<img style="width: 100%; height: 100%;" src="${path }/image.do?method=showImage&id=${ showImage.id}&size=source&handler=show" alt="${ctp:i18n(showImage.imageName)}" title="${ctp:i18n(showImage.imageName)}"/>
							</a>
						</li>
					</c:forEach>
				</ul>
				
			    <a href="javascript:void(0);" id="next-img" style="display:none" class="focus-handle"></a>
			    <a href="javascript:void(0);" id="prev-img" style="display:none" class="focus-handle"></a>
			    <ul id="focus-bubble"></ul>
			    
			    <div class="focus-banner-text" id="focus-banner-text">
			   	 	<%--秀吧名称 --%>
			        <span class="bgopacity_50 fl">
				        <input class="showName placeholder" value="${ctp:toHTMLWithoutSpaceEscapeQuote(showbarInfo.showbarName) }"  dplaceholder="${ctp:i18n('show.showedit.placeholder.name') }" placeholder="${ctp:i18n('show.showedit.placeholder.name') }" name="showbarName"  type="text" />
			        </span>
			        
			        <%--开始时间 --%>
			        <span class="bgopacity_50" style="position: relative;">
			        	<input readonly="readonly"  class="showTimeBegin placeholder changeDate" 
				        	 <c:if test="${!empty showbarInfo.startDate }">
					        	value="${ctp:formatDate(showbarInfo.startDate) }"
					         </c:if>
			        		dplaceholder="${ctp:i18n('show.showedit.placeholder.startdate') }" placeholder="${ctp:i18n('show.showedit.placeholder.startdate') }"   name="startDate" type="text" id="startDate"/>
			        </span>
			        
			        <%--结束时间 --%>
			        <span class="bgopacity_50" style="position: relative;">
			        	<input readonly="readonly"  class="showTimeEnd placeholder changeDate"  
				        	 <c:if test="${!empty showbarInfo.endDate }">
					        	value="${ctp:formatDate(showbarInfo.endDate) }"
					         </c:if>
			        		dplaceholder="${ctp:i18n('show.showedit.placeholder.enddate') }" placeholder="${ctp:i18n('show.showedit.placeholder.enddate') }" name="endDate" type="text" id="endDate"/>
			        </span>
			        
			        <%--地址 --%>
			        <span class="bgopacity_50 margin_r_20">
			        	<input class="showLocation placeholder"  value="${ctp:toHTMLWithoutSpaceEscapeQuote(showbarInfo.address) }" dplaceholder="${ctp:i18n('show.showedit.placeholder.adress') }" placeholder="${ctp:i18n('show.showedit.placeholder.adress') }" name="address" type="text" />
			        </span>
			        
			    </div>
			    
			    <%-- 没使用预制封面 或者 新建页面--%>
			    <c:if test="${!isnotDefaultPic }">
				    <div class="upload_banner" id="upload_banner">
				        <b id="upload_txt">${ctp:i18n('show.showedit.placeholder.upload') }</b>
				        <p>1110×314</p>
				    </div>
			    	<a class="reupload" style="display: none" id="cancel">${ctp:i18n('show.showedit.placeholder.cancelback') }</a>
			    </c:if>
			    
			     <%--使用预制 --%>
			    <c:if test="${isnotDefaultPic}">
				    <div class="upload_banner" id="upload_banner">
				        <b id="upload_txt">${ctp:i18n('show.showedit.placeholder.reupload') }</b>
				        <p>1110×314</p>
				    </div>
			    	<a class="reupload" id="cancel">${ctp:i18n('show.showedit.placeholder.cancelback') }</a>
			    </c:if>
			</div>
			
			<div class="creat_synopsis">
			    <h2>${ctp:i18n('show.showedit.placeholder.summary') }</h2>
			    <div class="creatShowtextElDiv" id="summarydiv">
			    	<textarea class="placeholder" placeholder="${ctp:i18n('show.showedit.placeholder.summaryinput') }"  dplaceholder="${ctp:i18n('show.showedit.placeholder.summaryinput') }" name="summary">${showbarInfo.summary}</textarea>
			    </div>
			    <div class="creatShowForm">
			    	<p class="showTitle">
			    		<strong>
			    			<em class="color_red">*</em> ${ctp:i18n('show.showedit.placeholder.scope') }：
			    		</strong>
			    	</p>
					<ul class="radio_group">
			            <li id="All">
			            	<strong>
			            		<span class="radio_span ${empty showbarAuth?'radio_checked':(showbarAuth.showbarAuthScope=='All'?'radio_checked':'radio_default') }"></span>
			            		${ctp:i18n('show.showedit.placeholder.allpeople') }
			            	</strong>
			            	(${ctp:i18n('show.showedit.placeholder.allpeople1') })
			            </li>
			            <li id="All_extend_externalStaff">
			            	<strong>
			            		<span class="radio_span ${showbarAuth.showbarAuthScope=='All_extend_externalStaff'?'radio_checked':'radio_default' }"></span>
			            		${ctp:i18n('show.showedit.placeholder.allpeople') }
			            	</strong>
			            	(${ctp:i18n('show.showedit.placeholder.allpeople2') })
						</li>
						<c:if test="${showA8Group }" >
							<%--A8集团版 --%>
				            <li id="All_group">
				            	<strong>
				            		<span class="radio_span ${showbarAuth.showbarAuthScope=='All_group'?'radio_checked':'radio_default' }"></span>
				            		${ctp:i18n('show.showedit.placeholder.allgroup') }
				            	</strong>
				            </li>
						</c:if>
			            <li id="Part">
			            	<strong>
			            		<span class="radio_span choosePeople ${showbarAuth.showbarAuthScope=='Part'?'radio_checked':'radio_default' }"></span>
			            		${ctp:i18n('show.showedit.placeholder.choosepeople') }
			            	</strong>
			            </li>
			            <div style="${showbarAuth.showbarAuthScope!='Part'?'display:none;':'display:block;' }" id="selectedPeople">
			            	<textarea name="" cols="" rows="" placeholder="${ctp:i18n('show.showedit.placeholder.clickpeople')}">${ctp:toHTMLWithoutSpaceEscapeQuote(showbarAuth.showbarAuthString) }</textarea>
			            </div>
			        </ul>
			    </div>
			</div>
		
			<input type="hidden" name="showbarId" value="${showbarInfo.id }"/>
			<input type="hidden" name="coverPicture" value="${showbarInfo.coverPicture }"/>
			<input type="hidden" name="showbarAuth" value="${showbarAuth.showbarAuth }"/>
			<input type="hidden" name="showbarAuthScope" value="${empty showbarAuth?'All':showbarAuth.showbarAuthScope }"/>
		</form>
		
		<%-- 切图插件  --%>
		<div id="captureImage"  class="captureImage">
			<div id="cpdiv" class="cpdiv">
				<img id="cutPic"/>
			</div>
			<div class="showAction capAtion">
				<a id="OKCap" class="action_submit" href="javascript:void(0);">${ctp:i18n('show.showedit.placeholder.sure') }</a>
				<a id="cancelCap" class="action_cancel" href="javascript:void(0);">${ctp:i18n('show.showedit.placeholder.cancel') }</a>
			</div>
		</div>
		
	</div>
        <p class="showAction">
			<a href="javascript:void(0);" id="sumb" onclick="submitForm()" class="action_submit">${ctp:i18n('show.showedit.placeholder.sure') }</a>
			<a href="${path }/show/show.do?method=showIndex" class="action_cancel">${ctp:i18n('show.showedit.placeholder.cancel') }</a>
		</p>
</body>
	<script type="text/javascript" src="${path }/apps_res/show/js/show-face-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/apps_res/show/js/show-seach-box-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/apps_res/show/webuploader/webuploader.min.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/apps_res/show/js/show-uploader-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/apps_res/show/js/showpost-edit-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/apps_res/show/js/layer-dialog-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/main/personalHeadImg/jquery.Jcrop.min.js${ctp:resSuffix()}"></script>
	<%-- 页面头部，秀吧管理员操作 --%>
	<script type="text/javascript" src="${path }/apps_res/show/js/show-auth-edit-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/apps_res/show/js/showbaredit/showbar-edit-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path }/apps_res/show/js/jquery.caret-debug.js${ctp:resSuffix()}"></script><!-- @控件 -->
	<script type="text/javascript" src="${path }/apps_res/show/js/jquery.atwho-debug.js${ctp:resSuffix()}"></script><!-- @控件 -->
	<script type="text/javascript" src="${path }/apps_res/show/js/show-at-util-debug.js${ctp:resSuffix()}"></script><!-- @控件 -->
	<%--at人的信息 --%>
	<script type="text/javascript" src="${path }/organization/orgIndexController.do?method=index&login=${loginTime}"></script>
</html>
