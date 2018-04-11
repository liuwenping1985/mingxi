<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 照片墙 -->
<script type="text/html" id="waterfall-tpl">
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
<!-- 秀圈瀑布流模板 -->
<script type="text/html" id="showbar-showpost-list-tpl">
{{# for(var i = 0, len = d.length; i < len; i++){ }}
{{# 	var li = d[i];			 				  }}
<li class="feed_detail" id="showpost{{li.id}}">
	{{# if(li.canSetTop || li.canDelete || li.canTransfer) { }}
	<div class="manger_action">
		<span class="toggle_btn expand">
		</span>
		<dl>
			<em>&#9670;</em>
			<span>&#9670;</span>
			{{# if(li.canSetTop){ }}
			<dd>
				<a class="setTop" href="javascript:void(0)">
					{{# if(li.setTop){ }}
						${ctp:i18n('show.showIndex.showbar.template.unsetTop')}
					{{# }else{ }}
						${ctp:i18n('show.showIndex.showbar.template.setTop')}
					{{# } }}
				</a>
			</dd>
			{{# } }} 
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
	{{# } }} 
	<span id="top{{li.id}}" {{# if(li.setTop){ }}class="flag" {{# } }}></span>
	<div class="userPic hand" onclick="showMemberCard('{{li.createUserId}}')">
		<img src="{{li.createUserPicUrl}}">
		<span title="{{li.createUserName}}">{{li.createUserName}}</span>
	</div>
	<span class="trigon1 feed_detail_trigon">&#9670;</span>
	<span class="trigon2 feed_detail_trigon">&#9670;</span>
	<div class="msgBox">
		<div class="userName">
			<strong>
				<a href="javascript:showMemberCard('{{li.createUserId}}')">{{li.createUserName}}</a>
			</strong>
		</div>
		<div id="cntDiv{{li.id}}" class="msgCnt msgCntHidden">
			<p>{{#if(li.content){ }}{{li.content}} {{# } }}</p>
		</div>
		<p class="readMore expand hidden" id="cntp{{li.id}}">
			<a class="contentAll" href="javascript:void(0)">&nbsp;</a>
		</p>
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
			<div class="pubTime">
				<a href="javascript:void(0);">{{li.showpostPubTime}}</a>
			</div>
			{{# if(li.showpostPubAddress){ }}
			<div class="pubAddress">
				<a href="javascript:void(0);">
					<span class="ico16 show_locationGray"></span>{{li.showpostPubAddress}}
				</a>
			</div>
			{{# } }}
			<div class="pubInfo">
			    <a href="javascript:;" id="int_cmt{{li.id}}" class="int_comment" title="${ctp:i18n('show.showbar.showpost.comment')}">
			    	<span class="ico16 show_replyNumberGray"></span>
			    	<span class="commentNum">{{li.commentNum}}</span>
			    </a>
			    <a id="praise{{li.id}}" class="int_like">
			    	<span class="sepline2"></span>
			    	<span id="like{{li.id}}" class="ico16 no_like_16" title="${ctp:i18n('show.showPraise.praise.tip')}"></span>
			    	<span class="praiseNum">{{li.likeNum}}</span>
			    </a>
			</div>
		</div>
	</div>
	<div id="common{{li.id}}">
	</div>
</li>
{{# } }}
</script>