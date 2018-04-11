<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--  首页主题/我参与/我创建的/搜索结果 模板 --%>
<script type="text/html" id="showbar-list-tpl">
{{# for(var i =0; i< d.length ; i++){ }}
{{# var showbar = d[i];				  }}
<div class="doublePart" id="id{{showbar.randomId}}">
	<ul class="photolist clearfix" id="photolist{{showbar.randomId}}">
		{{# if(showbar.canSetTop || showbar.canEdit || showbar.canDelete){ }}
			<div class="manger_action">
				<span class="toggle_btn expand"></span>
					<dl>
						<em>&#9670;</em>
						<span>&#9670;</span>
						{{# if(showbar.canSetTop){ }}
						<dd>
							{{# if(showbar.setTop){ }}
								<a class="setTop" href="javascript:void(0)" data-option="{{showbar.setTop}}">${ctp:i18n('show.showIndex.showbar.template.unsetTop')}</a>
							{{# }else{ }}
								<a class="setTop" href="javascript:void(0)" data-option="{{showbar.setTop}}">${ctp:i18n('show.showIndex.showbar.template.setTop')}</a>
							{{# } }}
						</dd>
						{{# } }}
						{{# if(showbar.canEdit){ }}
						<dd>
							<a class="edit" href="javascript:void(0)">${ctp:i18n('show.showIndex.showbar.template.edit')}</a>
						</dd>
						{{# } }}
						{{# if(showbar.canDelete){ }}
						<dd>
							<a class="delete" href="javascript:void(0)">${ctp:i18n('show.showIndex.showbar.template.delete')}</a>
						</dd>
						{{# } }}
						{{# if(showbar.canHandover){ }}
						<dd>
							<a class="handover" href="javascript:void(0)">${ctp:i18n('show.showIndex.showbar.template.handover')}</a>
						</dd>
						{{# } }}
					</dl>
			</div>
		{{# } }}
		<span class="IwantShow" title="${ctp:i18n("show.showbar.showpost.newpost") }"></span>
		<li class="fullImg">
			<a href="${path }/show/show.do?method=showbar&showbarId={{showbar.id}}&from=homePage">
				<img class="lazy" data-original="${path }/image.do?method=showImage&id={{showbar.imageList[0]}}&size=custom&w=400&h=288&handler=show"/>
			</a>
			<span class="{{# if(showbar.setTop){ }}flag{{# } }}"></span>
	    </li>
	</ul>
	<div class="activity_title">
		<h2 title="{{showbar.showbarName}}">{{=showbar.showbarName}}</h2>
		<p class="activity_photo_set">
			<span class="activity_myShow">
				<span class="userpic hand" onclick="showMemberCard('{{showbar.createUserId}}')"><img class="lazy" data-original="{{showbar.createUserPicUrl}}" /></span>
				<a href="javascript:showMemberCard('{{showbar.createUserId}}')" title="{{showbar.createUserName}}">{{showbar.createUserName}}</a>
			</span>
			<span class="hits_gray" title="${ctp:i18n('show.showbar.shoebarinfo.view')}" ><span class="ico16 show_clickNumberGray"></span>{{showbar.viewNum}}</span>
			<span class="estimate_gray" title="${ctp:i18n('show.showbar.shoebarinfo.comment')}" ><span class="ico16 show_replyNumberGray"></span>{{showbar.commentNum}}</span>
			<span class="liked_gray" title="${ctp:i18n('show.showbar.shoebarinfo.like')}" ><span class="ico16 show_likeGray"></span>{{showbar.likeNum}}</span><span class="IwantShow" title="${ctp:i18n("show.showbar.showpost.newpost") }"></span>
		</p> 
	</div>
</div>
{{# } }}
</script>