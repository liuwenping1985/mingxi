<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--  首页主题/我参与/我创建的/搜索结果 模板 --%>
<%@include file="/WEB-INF/jsp/apps/show/common/showTpl.jsp" %>
<%-- 我的相册模板 --%>
<script type="text/html" id="myshow-showpost-list-tpl">
{{# for(var i = 0, len = d.length; i < len; i++){ }}
{{# 	var li = d[i];			 				  }}
<li class="feed_detail  myshow_pubInfo" id="showpost{{li.id}}">
	<div class="manger_action">
		<span class="toggle_btn expand">
		</span>
		<dl>
			<em>&#9670;</em>
			<span>&#9670;</span>
			<dd>
				<a class="delete" href="javascript:void(0)">
					${ctp:i18n('show.showIndex.showbar.template.delete')}
				</a>
			</dd>
			<dd>
				<a class="move2other"  showbarName="{{li.showbarName}}"  showpostId="{{li.id}}" showbarId="{{li.showbarId}}" href="javascript:void(0)" >${ctp:i18n("show.showpostTransfer.transfer")}</a>
			</dd>
		</dl>
	</div>
    <span id="top{{li.id}}" {{# if(li.setTop){ }}class="flag" {{# } }}></span>
	<div class="msgBox">
		<div class="userName"><strong>${ctp:i18n('show.myShow.myPhotos.comefrom')}：<a class="view" href="javascript:void(0)">{{=li.showbarName}}</a></strong></div>
		<div id="cntDiv{{li.id}}" class="msgCnt msgCntHidden"><p>{{#if(li.content){ }}{{li.content}} {{# } }}</p></div>
		<p class="readMore expand hidden" id="cntp{{li.id}}"><a class="contentAll" href="javascript:void(0)">&ensp;</a></p>
		<div class="mediaWrap">
			<div class="tl_imgGroup clearfix">
				{{# if(li.imageList.length >0 ){ }}
				{{# for(var j= 0; j < li.imageList.length ;j++){ }}
        			<div class="tl_imgGroup_item">
						<a _userName="{{li.createUserName}}"  _userPic="{{li.createUserPicUrl}}"  _text="{{=li.oriContent}}"
							_src="{{li.imageList[j].showpostPicAuto}}"  
							_originalSrc="{{li.imageList[j].showpostPicOriginal}}" >
							<img src="{{li.imageList[j].showpostPicUrl}}" width="186" height="145"/>
						</a>
					</div>
    			{{# } }}
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