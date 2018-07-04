<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--  首页轮播图模板 --%>
<script type="text/html" id="template-carousel-tpl">  
	<div class="main-slider">
        {{# if(d.length > 1){ }}
		<div class="slide-num">
			{{# for(var i = 0; i < d.length; i++){ }}
			<span class="{{# if(i == 0){ }}current{{# } }}">{{i}}</span>
			{{# } }}
		</div>
		{{# } }}
		{{# for (var i = 0; i < d.length; i ++){ }}
		{{# var showbar = d[i]; }}
		<div class="slide-item {{#if(i == 0){ }}current{{#} }}">
		    {{# if(showbar.isTop){ }}<span class="flag"></span>{{# } }}
			{{# if(showbar.isHot){ }}<span class="hot"></span>{{# } }}
			<a href="${path }/show/show.do?method=showbar&showbarId={{showbar.showbarId}}">
			<img src="${path }/image.do?method=showImage&id={{showbar.coverPicture}}&size=source&handler=show" /></a>
			<div class="slide-cont"> 
				<h1>{{=showbar.showbarName}}</h1> 
				<p class="photo_info">
						{{#if(showbar.startDate){ }} 
							{{showbar.startDate}} - 
						{{#if(showbar.endDate){ }}
							{{showbar.endDate}}
						{{#}else{ }}
							${ctp:i18n('show.showbar.shoebarinfo.now') }
						{{# } } }}
						{{# if(showbar.address){ }}
							<span class="location"><span class="ico16 show_locationWhite"></span>{{showbar.address}}</span>
						{{#} }}
				</p> 
				<p class="photo_set">
					<span class="amount" title="${ctp:i18n('show.showbar.shoebarinfo.images') }">
						<span class="ico16 show_imageNumber"></span>{{showbar.imgNum}}
					</span>
					<span class="hits_gray" title="${ctp:i18n('show.showbar.shoebarinfo.view') }">
						<span class="ico16 show_clickNumberWhite"></span>{{showbar.viewNum}}
					</span>
					<span class="estimate_gray" title="${ctp:i18n('show.showbar.shoebarinfo.comment') }">
						<span class="ico16 show_replyNumberWhite"></span>
						{{showbar.commentNum}}
					</span>	
					<span class="liked_gray" title="${ctp:i18n('show.showbar.shoebarinfo.like') }">
						<span class="ico16 show_likeWhite"></span>{{showbar.likeNum}}
					</span>
				</p> 
			</div> 
		</div>
		{{#} }}
	</div>
	<a href="javascript:void(0);" id="slide_top" class="slide_handle" ></a>
	<a href="javascript:void(0);" id="slide_bottom" class="slide_handle"></a>
</script>

<%--  首页主题/我参与/我创建的/搜索结果 模板 --%>
<%@include file="/WEB-INF/jsp/apps/show/common/showTpl.jsp" %>
<%--  首页大秀模板 --%>
<script type="text/html" id="showindex-showpost-list-tpl">
{{# for(var i = 0, len = d.length; i < len; i++){ }}
{{# 	var li = d[i];			 				  }}
<li class="feed_detail" id="showpost{{ li.id }}">
	{{# if(li.canDelete && li.canTransfer) { }}
	<div class="manger_action">
		<span class="toggle_btn expand">
		</span>
		<dl>
			<em>&#9670;</em>
			<span>&#9670;</span>
			{{# if(li.canDelete){ }}
			<dd>
				<a class="delete" href="javascript:void(0)">
					${ctp:i18n('show.showIndex.showbar.template.delete')}
				</a>
			</dd>
			{{# } }}
			{{# if(li.canTransfer){ }}
			<dd>
				<a class="move2other" showbarName="{{li.showbarName}}" showpostId="{{li.id}}" showbarId="{{li.showbarId}}" href="javascript:void(0)" >${ctp:i18n("show.showpostTransfer.transfer")}</a>
			</dd>
			{{# } }}
		</dl>
	</div>
	{{# }else if(li.canDelete){ }} 
	<div class="manger_action">
		<span class="delThis_btn hand delete"></span>
	</div>
	{{# } }}
	<div class="userPic hand" onclick="showMemberCard('{{ li.createUserId }}')">
		<img src="{{ li.createUserPicUrl }}" title="{{ li.createUserName }}">
		<span onclick="showMemberCard('{{ li.createUserId }}')" title="{{ li.createUserName }}">{{ li.createUserName }}</span>
	</div>
    <span id="top{{ li.id }}" {{# if(li.setTop){ }}class="flag" {{# } }}></span>
	<div class="msgBox">
		<div class="userName"><strong>${ctp:i18n('show.myShow.myPhotos.comefrom')}：<a class="view" href="javascript:void(0)">{{=li.showbarName }}</a></strong></div>
		<div id="cntDiv{{ li.id }}" class="msgCnt msgCntHidden">
			<p>{{#if(li.content){ }}{{li.content}} {{# } }}</p>
		</div>
		<p class="readMore expand hidden" id="cntp{{li.id}}"><a class="contentAll" href="javascript:void(0)">&ensp;</a></p>
		<div class="mediaWrap">
			<div class="tl_imgGroup clearfix">
				{{# for(var j= 0; j < li.imageList.length ;j++){ }}
        			<div class="tl_imgGroup_item">
						<a _userName="{{li.createUserName}}"  _userPic="{{li.createUserPicUrl}}"  _text="{{=li.oriContent}}"
							_src="{{li.imageList[j].showpostPicAuto}}"  
							_originalSrc="{{li.imageList[j].showpostPicOriginal}}" >
							<img src="{{li.imageList[j].showpostPicUrl}}" width="186" height="145"/>
						</a>
					</div>
    			{{# } }}
			</div>
		</div>
		<div class="areaInfo">
			<div class="pubTime"><a href="javascript:void(0);">{{li.showpostPubTime}}</a></div>
			{{# if(li.showpostPubAddress){ }}
			<div class="pubAddress"><a href="javascript:void(0);"><span class="ico16 show_locationGray"></span>{{li.showpostPubAddress}}</a></div>
			{{# } }}
			<div class="pubInfo">
				<div class="pubInfop">
					<a href="javascript:;" id="int_cmt{{li.id}}" class="int_comment" title="${ctp:i18n('show.showbar.showpost.comment')}">
						<span class="ico16 show_replyNumberGray"></span>
						<span class="commentNum">{{li.commentNum}}</span>
					</a>
					<a id="praise{{li.id}}" class="int_like">
						<span class="sepline2"></span>
						<span id="like{{li.id}}" class="ico16 no_like_16" title="${ctp:i18n('show.showPraise.praise.tip')}">
						</span>
						<span class="praiseNum">{{li.likeNum}}</span>
					</a>
				</div>
			</div>
		</div>
	</div>
	<div id="common{{li.id}}"></div>
</li>
{{# } }}
</script>


<%--  首页照片墙模板 --%>
<script type="text/html" id="show-index-photos-tpl">
{{# for(var index = 0; index < d.length ; index++ ){ }}
{{# 	var img = d[index] 							 }}
	<div class="item" id="image{{img.showimageId}}" postId="{{img.showpostId}}">
		<a _dataId="{{img.showpostId}}" _userId="{{img.userId}}" _textUrl="${path }{{img.showpostUrl}}" _userPic="{{img.userPic}}" _userName="{{=img.userName}}" 
		   _src="${path }/image.do?method=showImage&id={{img.showimageId}}&size=auto&handler=show"
		   _originalSrc="${path }/image.do?method=showImage&id={{img.showimageId}}&size=source&handler=show" class="touchTouchImg" _text="{{=img.description}}" data-original="${path }/image.do?method=showImage&id={{img.showimageId}}&size=original&handler=show">
			{{# if(img.height < 140){ }}
				<img src="${path }/image.do?method=showImage&id={{img.showimageId}}&size=custom&h=140&w=266&handler=show" width="266" height="140"/>
			{{# }else if(img.height > 500){ }}
				<img src="${path }/image.do?method=showImage&id={{img.showimageId}}&size=custom&h=500&w=266&handler=show" width="266" height="500"/>
			{{# }else if(img.height <= 500 && img.height >= 140 ){ }}
				<img src="${path }/image.do?method=showImage&id={{img.showimageId}}&size=custom&h={{img.height}}&w={{img.width}}&handler=show" width="{{img.width}}" height="{{img.height}}"/>
			{{# } }}
		</a>
		<div class="Waterfall_info photo_wall">
			<div class="userPic">
				<a href="javascript:void(0)" onclick="showMemberCard('{{img.userId}}',this)" title="{{img.userName}}"><img src="{{img.userPic}}"></a>
				<strong onclick="showMemberCard('{{img.userId}}',this)" style="word-break: break-all;word-wrap: break-word;cursor: pointer;" title="{{img.userName}}">{{img.suserName}}</strong>
			</div>
			<div class="feed_text">
				<p title="{{=img.description}}">{{img.faceDescription}}</p>
			</div>
		</div>
	</div>
{{# } }}
</script>
