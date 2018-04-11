<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="bbsHeader.jsp"%>
<%@ page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum"%>
<%@ page import="com.seeyon.ctp.common.constants.Constants"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/bbs" prefix="bbs"%>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta charset="utf-8">
		<title>${ctp:toHTML(article.articleName)}</title>
		<link rel="stylesheet" type="text/css" href="${path}/skin/default/bbs.css${v3x:resSuffix()}" />
		<link rel="stylesheet" type="text/css" href="${path}/apps_res/bbs/css/discuss_info.css${v3x:resSuffix()}" />
		<script src="${path}/apps_res/bbs/js/discuss_info.js${v3x:resSuffix()}"></script>
		<script src="${path}/apps_res/bbs/js/common.js${v3x:resSuffix()}"></script>
		<script src="${path}/apps_res/bbs/js/bbsReplyFace.js${v3x:resSuffix()}"></script>
		<script src="${path}/apps_res/bbs/js/bbs-info.js${v3x:resSuffix()}"></script>
		<script src="${path}/apps_res/doc/js/docFavorite.js${v3x:resSuffix()}"></script>
		<script type="text/javascript">
			var _path = '${path}';
			var _canSecretReply = "${article.anonymousReplyFlag}";
			var ajax_bbsArticleManager = new bbsArticleManager();
			var replyFace = new BbsReplyFace();
			var articleID = '${article.id}';
			var favText = ['${ctp:i18n('bbs.cancel.favorite')}','${ctp:i18n('bbs.favorite')}'];
			var createTalk = null;
			var _i18nText = ['${ctp:i18n('bbs.reply.label')}','${ctp:i18n('bbs.boardmanager.menu.delarticle.label') }','${ctp:i18n('common.button.cancel.label') }'];
			var _spaceType = '${param.spaceType}';
			var _spaceId = '${param.spaceId}';
			function containerWid() {
				var _width = $(window).width();
				$(".content_container").width(_width);
			}
			$(window).resize(function(){
				containerWid()
			});
			$(function(){
			  var h1 = $(".content_container").height();
			  var h2 = $(".discuss_info").height();
			  if(h1>=h2){
			    $("#discuss_info").hide();
			  }
			  containerWid();
			})

			//返回首页（集团和单位空间下的处于发布状态下的讨论）
			function bbsToIndex(){
				if( ('${article.spaceType}' =='2' || '${article.spaceType}' =='3') && ('${article.state}'=='0'||'${article.state}'=='2') && '${param.from}' != 'pigeonhole'){
					var url = '${path}/bbs.do?method=bbsIndex';
					window.location.href = url;
				}
			}
		</script>
		<v3x:attachmentDefine attachments="${attachments}" />
	</head>
	<style type="text/css">
		#carbonads-container {
			clear: both;
			margin-top: 1em;
		}
		#carbonads-container .carbonad {
			margin: 0 auto;
		}
		#content:hover {
            border: none;
        }
        #content {
            border: none;
        }
		.article_content p    { font-size: 16px; line-height: 1.8;word-break: normal; }
        .article_content td   { font-size: 16px; line-height: 1.8; }
        .article_content UL   { font-size: 16px; line-height: 1.8; }
        .article_content LI   { font-size: 16px; line-height: 1.8; }
        .article_content div  { font-size: 16px; line-height: 1.8; }
        .article_content ol   { font-size: 16px; line-height: 1.8; }
        .article_content pre  { font-size: 16px; line-height: 1.8; }
        .article_content span { font-size: 16px; line-height: 1.8; } 
		.article_content ul, .article_content ol {
			padding-left: 40px;
		}
        .article_content ul li {font-size: 16px;list-style: disc;}
		.article_content ol li {font-size: 16px;list-style: decimal;}
	</style>
	<body>
  		<input id="pre" name="pre" type="hidden" value="${pre}">
  		<input id="preTitle" name="preTitle" type="hidden" value="${ctp:toHTML(preTitle)}">
		<input id="preContent" name="preContent" type="hidden" value="${ctp:toHTML(preContent)}">
		<input id="preScope" name="preScope" type="hidden" value="${preScope}">
		<input id="preBoardId" name="preBoardId" type="hidden" value="${preBoardId}">
		<div class="container">
			<div class="container_top">
              <div class="container_top_area">
  				<span class="index_logo" <c:if test="${(article.spaceType == 2 ||article.spaceType == 3 )&&(article.state==0||article.state==2)&& param.from != 'pigeonhole'}">title="${ctp:i18n('bbs.return.to.index')}"</c:if> onclick="bbsToIndex();" style="cursor: pointer;">
  					<img src="${path}/skin/default/images/cultural/bbs/index_logo.png" width="48" height="33">
  					<span class="index_logo_name">${ctp:i18n('dept.space.discuss')}</span>
  				</span>
              </div>
			</div>
			<div class="content_container">
				<div class="container_auto">
					<div class="discuss_info">
						<div class="discuss_info_top">
							<span class="user_photo">
								<c:choose>
				                	<c:when test="${article.anonymousFlag && memberId!=article.issueUserId}">
				                		<img class="radius hand" src="${pageContext.request.contextPath}/apps_res/v3xmain/images/personal/pic.gif" />
				                	</c:when>
				                	<c:otherwise>
										<img class="radius hand" src="${issuerImage}" onclick="showMemberCard('${article.issueUserId}')"/>
				                	</c:otherwise>
								</c:choose>
								<%-- <img src="${path}/skin/default/images/cultural/bbs/user_msg.jpg"> --%>
							</span>
							<div style="float:left; width:110px;">
								<c:choose>
									<c:when test="${article.anonymousFlag && memberId!=article.issueUserId}">
									  <span class="user_name margin_t_15">
										<fmt:message key="anonymous.label"/>
									  </span>
									  <span style="display:block;padding-top: 40px;font-size:12px;color:#999;">
									  *****
									  </span>
									</c:when>
									<c:otherwise>
										<span class="user_name margin_t_15" title="${v3x:showMemberName(aricle.issueUserId)}">
										  ${v3x:getLimitLengthString(v3x:showMemberName(article.issueUserId),10,"...")}
										 </span>
										 <span style="display:block;padding-top: 40px;font-size:12px;color:#999;"title="${v3x:getOrgEntity('Post',article.post).name}">				 
										${v3x:getLimitLengthString(v3x:getOrgEntity('Post',article.post).name,15,"...")}
										 </span>
									</c:otherwise>
								</c:choose>
							</div>
							<div style="float:left;">
								<div style="margin-top: 15px;">
										<span class="depart_title">${ctp:i18n('bbs.board.label')}：</span><%--讨论板块 --%>
										<span class="depart_name" title="${v3x:toHTML(board.name)}">${v3x:toHTML(v3x:getLimitLengthString(board.name,40,"..."))}
										</span>
								</div>
								<div style="margin-top: 10px;">
									<span class="depart_title">${ctp:i18n('common.issueScope.label')}：</span><%--发布范围 --%>
										<span class="depart_name" title = "${v3x:showOrgEntitiesOfTypeAndId(issueArea, pageContext) }">${v3x:getLimitLengthString(v3x:showOrgEntitiesOfTypeAndId(issueArea, pageContext),40,"...")}</span><%--长度待定？ --%>
								</div>
							</div>
							<div class="depart_right margin_r_20">
								<div class="depart_right_top">
									<c:if test="${param.from != 'pigeonhole' && docCollectFlag eq 'true' && article.state != 3}">
										<c:choose>
											<c:when test="${isCollect}">
                                                <span id = "article_fav" onclick="javaScript:cancelFavorite_bbs('${article.id}','${ctp:i18n('bbs.favorite')}')">
												<em class="ico16 stored_16"></em>
												<span class="collect_name hand" >${ctp:i18n('bbs.cancel.favorite')}</span><%--取消收藏 --%>
                                                </span>
											</c:when>
											<c:otherwise>
                                                <span id = "article_fav" onclick="javaScript:favorite_bbs('${article.id}','${ctp:i18n('bbs.cancel.favorite')}')">
												<em class="ico16 unstore_16"></em>
						        				<span class="collect_name hand">${ctp:i18n('bbs.favorite')}</span><%--收藏 --%>
                                                </span>
											</c:otherwise>
			       						</c:choose>
			       					</c:if>
								</div>
								<div class="depart_right_bottom">
                                    <span class="depart_handle">
                                        <c:if test="${canModify&&article.state==0}">
                                        <span class="cover_end_32 hand" title="${ctp:i18n('bbs.close.article')}" onclick="closeArticle();"><%--结贴 --%>
                                            <img class="margin_t_7" src="${path}/skin/default/images/cultural/bbs/cover_end.jpg" width="22" height="18"/>
                                        </span>
                                        </c:if>
                                        <c:if test="${canModify}">
                                        <span class="cover_edit_32 hand" title="${ctp:i18n('bbs.reply.modify.label')}" onclick="modifyArticle('${article.id}');"><%--编缉 --%>
                                            <img class="margin_t_5" src="${path}/skin/default/images/cultural/bbs/cover_edit.jpg" width="22" height="22"/>
                                        </span>
                                        </c:if>
                                        <c:if test="${canDeleteArticleFlag}">
                                        <span class="cover_delete_32 hand" title="${ctp:i18n('label.new.delete')}" onclick="deleteArticle();"><%--删贴 --%>
                                            <img class="margin_t_5" src="${path}/skin/default/images/cultural/bbs/cover_delete.jpg" width="16" height="22"/>
                                        </span>
                                        </c:if>
                                    </span>
                                    <c:if test="${canModify&&article.state==0 || canDeleteArticleFlag || canDeleteArticleFlag}">
                                    <span class="cover_line left"></span>
                                    </c:if>
									<span class="discuss_state">
										<span class="margin_r_5">
											<em class="icon16 discuss_click_16"></em>
											<span class="discuss_num" style="width:30px;">${article.clickNumber }</span>
										</span>
										<span class="margin_r_5" <c:if test="${pre!='true' }">onclick="goToHotReply();"</c:if>>
											<em class="icon16 discuss_reply_16"></em>
											<span class="discuss_num" style="width:23px;" name='replyTotal'>${total }</span>
										</span>
										<span id="bbsArticlePraise1" class="margin_r_5" title="${v3x:showOrgEntitiesOfIds(article.praise, 'Member', pageContext)}">
											<c:choose>
												<c:when test="${bbsPraise == true}">
													<em class="icon16 discuss_like_current_16"></em>
												</c:when>
												<c:when test="${article.state == 3 || article.state == 100}">
													<em class="icon16 discuss_like_16"></em>
												</c:when>
												<c:otherwise>
													<em class="icon16 discuss_like_16 articlePraise" onclick="addPraise('${article.id}');"></em>
												</c:otherwise>
											</c:choose>
											<c:choose>
												<c:when test="${article.praiseSum >=0}">
													<span class="discuss_num articlePraiseNum" style="width:23px;">${article.praiseSum }</span><%--点赞数 预留 --%>
												</c:when>
												<c:otherwise>
													<span class="discuss_num articlePraiseNum" style="width:23px;">0</span><%--点赞数 预留 --%>
												</c:otherwise>
											</c:choose>
										</span>
									</span>
								</div>
							</div>
						</div>
						<div class="discuss_info_body">
							<div class="info_body_content">
								<div class="discuss_article_title">
									<span class="title_name">
                                        <c:if test="${article.topSequence==1 }">
                                        <font color="#ff0000">[${ctp:i18n('label.top.js')}]</font>
                                        </c:if>
										${v3x:toHTML(article.articleName)}
                                        <c:if test="${article.eliteFlag }">
                                        <em class="icon24 cover_essence_24"></em>
                                        </c:if>
                                        <c:if test="${article.state==2 }">
                                        <em class="icon24 card_end_24"></em>
                                        </c:if>
										<c:if test="${article.resourceFlag==1}">
											[${ctp:i18n('bbs.showArticle.Author') }]
										</c:if>
										<c:if test="${article.resourceFlag==2}">
											[${ctp:i18n('bbs.showArticle.Transmit') }]
										</c:if>
									</span>
									<span class="content_time"><fmt:formatDate value="${article.issueTime}" pattern="yyyy-MM-dd HH:mm"/></span>
								</div>

								<div class="article">
									<div class="article_content" style="width:100%;">
                                    <v3x:showContent content="${article.content}"  type="HTML" createDate="${article.issueTime}" htmlId="content"  viewMode="edit"/>
                                    </div>
									<%--附件 --%>
									<div class="file_auto" style="display: none;" id="attachmentTRbbsFile">
										<div class="atts-label" >${ctp:i18n('common.attachment.label') } :&nbsp;&nbsp;(<span id="attachmentNumberDivbbsFile"></span>)</div>
                                        <div id="attFile" isGrid="true" class="comp" comp="type:'fileupload',attachmentTrId:'bbsFile',canFavourite:false,applicationCategory:'9',canDeleteOriginalAtts:false" attsdata='${bbsAttListJSON}'></div>
                                        <div id="attachmentAreabbsFile" class="reply_attachment"></div>
									</div>
									<div class="user_change">
										<span>
											<c:if test="${article.modifyTime!=null}">
												<span class="change_user_name">
													<c:choose>
														<c:when test="${article.anonymousFlag && memberId!=article.issueUserId }">
															${ctp:i18n('anonymous.label')}
														</c:when>
														<c:otherwise>${v3x:showMemberName(article.issueUserId)}</c:otherwise>
													</c:choose>
												</span>
												${ctp:i18n('bbs.at.label')}<span class="change_time"><fmt:formatDate value="${article.modifyTime}" pattern="yyyy-MM-dd HH:mm"/></span>${ctp:i18n('bbs.finallyeditarticle.label')}
											</c:if>
										</span>
										<span class="discuss_state">
											<span class="margin_r_5">
												<em class="icon16 discuss_click_16"></em>
												<span class="discuss_num" style="width:30px;">${article.clickNumber }</span>
											</span>
											<span class="margin_r_5" <c:if test="${pre!='true'}"> onclick="goToHotReply();"</c:if>>
												<em class="icon16 discuss_reply_16"></em>
												<span class="discuss_num" name='replyTotal' style="width:23px;">${total }</span>
											</span>
											<span id="bbsArticlePraise2" class="margin_r_5" title="${v3x:showOrgEntitiesOfIds(article.praise, 'Member', pageContext)}">
												<c:choose>
													<c:when test="${bbsPraise == true}">
														<em class="icon16 discuss_like_current_16"></em>
													</c:when>
													<c:when test="${article.state == 3 || article.state == 100}">
														<em class="icon16 discuss_like_16"></em>
													</c:when>
													<c:otherwise>
														<em class="icon16 discuss_like_16 articlePraise" onclick="addPraise('${article.id}');"></em>
													</c:otherwise>
												</c:choose>
												<c:choose>
													<c:when test="${article.praiseSum >=0}">
														<span class="discuss_num articlePraiseNum" style="width:23px;">${article.praiseSum }</span><%--点赞数 预留 --%>
													</c:when>
													<c:otherwise>
														<span class="discuss_num articlePraiseNum" style="width:23px;">0</span><%--点赞数 预留 --%>
													</c:otherwise>
												</c:choose>
											</span>
										</span>
									</div>
								</div>
							</div>
						</div>
						<c:if test="${pre!='true' && article.state!=3}">
						<div class="info_body_reply">
							<div class="info_body_content">
								<div class="discuss_info_title">
									<span class="title_name_16">${ctp:i18n('bbs.info.mostPraiseReply')}</span>
									<c:if test="${canReply }">
									<a class="button reply_button_fast margin_r_10" onclick="goToReply();">
                                        <span class="icon24 discuss_info_24"></span>
                                        <span class="font14">${ctp:i18n('quick.reply.label')}</span>
									</a>
									</c:if>
								</div>
								<div class="reply_best_list">
									<ul class="reply_list">
										<c:forEach items="${hotReplyModelList}" var="hotReply">
											<li class="reply_list_info" id = "hot_${hotReply.id}">
												<span class="reply_user">
													<c:choose>
									                	<c:when test="${hotReply.anonymousFlag&&hotReply.replyUserId!=v3x:currentUser().id}">
									                		<img class="radius hand" src="${pageContext.request.contextPath}/apps_res/v3xmain/images/personal/pic.gif" />
									                	</c:when>
									                	<c:otherwise>
															<img class="radius hand" src="${ctp:avatarImageUrl(hotReply.replyUserId)}" onclick="showMemberCard('${hotReply.replyUserId}')"/>
									                	</c:otherwise>
													</c:choose>
												</span>
												<div class="reply_content_info">
													<div class="user_reply">
                                                        <div class="reply_self">
                                                          <div class="reply_content_left">
                                                            <div class="reply_username left">
  														    <c:choose>
    										                	<c:when test="${hotReply.anonymousFlag&&hotReply.replyUserId!=v3x:currentUser().id}">
    										                		<span class="reply_userfirst">${ctp:i18n('anonymous.label')}</span>
    										                	</c:when>
    										                	<c:when test="${!hotReply.anonymousFlag&&hotReply.replyUserId==v3x:currentUser().id}">
    																<span class="color_999 left">${v3x:showMemberName(hotReply.replyUserId)}</span>
    										                	</c:when>
    										                	<c:otherwise>
    																<span class="reply_userfirst" onclick="showMemberCard('${hotReply.replyUserId}')">${v3x:showMemberName(hotReply.replyUserId)}</span>
    										                	</c:otherwise>
  														    </c:choose>
                                                            <c:if test="${hotReply.replyFrom != null && hotReply.replyFrom eq 'weixin' }">
                                                                        &nbsp;<span>(${ctp:i18n('bbs.from.weChat')})</span>
                                                            </c:if>
                                                            <c:if test="${hotReply.replyFrom != null && hotReply.replyFrom ne 'pc' && hotReply.replyFrom ne 'other'&& hotReply.replyFrom ne 'email' && hotReply.replyFrom ne 'weixin'}">
                                                                        &nbsp;<span>(${ctp:i18n('bbs.from.mobile.client.js') })</span>
                                                            </c:if>
                                                            </div>
                                                            <div class="reply_content_right">
      														    <div class="reply_time right">${ctp:formatDateTime(hotReply.replyTime)}</div>
                                                            </div>
                                                          </div>
                                                          <div class="view_reply_content">
          													<div class="reply_content left">
                                                                <c:if test="${hotReply.replyFrom eq 'pc' || hotReply.replyFrom == null}">
                                                                ${hotReply.content}
                                                                </c:if>
                                                                <c:if test="${hotReply.replyFrom != null && hotReply.replyFrom ne 'pc' }">
                                                                ${bbs:showReplyContent(hotReply.content,true)}
                                                                </c:if>
                                                                <div class="div-float" style="display: none" id="attachmentTRhot${hotReply.id}">
                                                                    <div class="atts-label">${ctp:i18n('common.attachment.label') } :&nbsp;&nbsp;(<span id="attachmentNumberDivhot${hotReply.id}"></span>)</div>
                                                                    <div isGrid="true" class="comp" comp="type:'fileupload',attachmentTrId:'hot${hotReply.id}',checkSubReference:false,canFavourite:false,applicationCategory:'9',canDeleteOriginalAtts:false" attsdata='${hotReply.fileListJson}'></div>
                                                                    <div id="attachmentAreahot${hotReply.id}" class="reply_attachment"></div>
                                                                </div>
                                                            </div>
        														<div class="reply_like right" title="${v3x:toHTML(hotReply.praise)}">
                                                                    <c:choose>
                                                                    <c:when test="${hotReply.praiseFlag}">
                                                                        <em class="icon16 discuss_like_current_16"></em>
                                                                    </c:when>
                                                                    <c:when test="${article.state==100}">
                                                                        <em class="icon16 discuss_like_16"></em>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <em class="icon16 discuss_like_16" onclick="addReplyPraise('${hotReply.id}')"></em>
                                                                    </c:otherwise>
                                                                    </c:choose>
        															<span class="discuss_num">${hotReply.praiseSum}</span>
          													</div>
                                                          </div>
                                                        </div>
													</div>
												</div>
											</li>
										</c:forEach>
									</ul>
								</div>
							</div>
							<div class="reply_all">
								<div class="discuss_info_title">
									<span class="title_name_16">${ctp:i18n('bbs.info.allReply')}     (  <span class="reply_count_num">${total}</span>${ctp:i18n('bbs.info.number')}  )</span>
                                    <c:if test="${pages>1}">
									<span class="discuss_page right margin_t_15">
										<em class="icon16 discuss_left_16" onclick="nextPage();"></em>
												<span class="page_circles">
													<c:set value='${pageArea}' var='pageArea' />
													<c:forEach var="x" begin="${pageArea*10+1 }" end="${ (pageArea+1)*10 }" step="1">
												  		<c:if test="${x<=pages}">
													    	<c:if test="${nowPage==x}">
													     		<a href="javascript:;" class="page_num current">${x}</a>
													    	</c:if>
													    	<c:if test="${nowPage!=x}">
													      		<a href="javascript:;" class="page_num" onclick="goPage(parseInt(${x}));">${x}</a>
													    	</c:if>
												  		</c:if>
													</c:forEach>
												</span>
										<em class="icon16 discuss_right_16" onclick="prevPage();"></em>
									</span>
                                    </c:if>
								</div>
								<div class="reply_all_info">
									<ul class="reply_all_list">
									<c:set value='${nowPage == 1 ? 1 : ((nowPage-1)*pageSize+1) }' var='i' />
										<c:forEach items="${replyModelList}" var="replyPost" varStatus="state">
										<li class="reply_list_info" id = "reply_${replyPost.id}">
											<span class="reply_user">
												<c:choose>
										      		<c:when test="${replyPost.anonymousFlag&&replyPost.replyUserId!=v3x:currentUser().id}">
										    			<img class="radius hand" src="${pageContext.request.contextPath}/apps_res/v3xmain/images/personal/pic.gif" />
										         	</c:when>
										           	<c:otherwise>
														<img class="radius hand" src="${ctp:avatarImageUrl(replyPost.replyUserId)}" onclick="showMemberCard('${replyPost.replyUserId}')"/>
										        	</c:otherwise>
												</c:choose>
											</span>
											<div class="reply_content_info">
												<div class="user_reply">
													<div class="reply_self">
														<div class="reply_content_left">
                                                            <div class="reply_username left">
															<c:choose>
										      					<c:when test="${replyPost.anonymousFlag&&replyPost.replyUserId!=v3x:currentUser().id}">
										    						<span class="reply_userfirst">${ctp:i18n('anonymous.label')}</span>
										         				</c:when>
										      					<c:when test="${replyPost.replyUserId==v3x:currentUser().id}">
																	<span class="color_999">${v3x:showMemberName(replyPost.replyUserId)}</span>
										         				</c:when>
										           				<c:otherwise>
																	<span class="reply_userfirst" onclick="showMemberCard('${replyPost.replyUserId}')">${v3x:showMemberName(replyPost.replyUserId)}</span>
										        				</c:otherwise>
															</c:choose>
                                                            <c:if test="${replyPost.replyFrom != null && replyPost.replyFrom eq 'weixin' }">
                                                                    <span>(${ctp:i18n('bbs.from.weChat')})</span>
                                                            </c:if>
                                                            <c:if test="${replyPost.replyFrom != null && replyPost.replyFrom ne 'pc' && replyPost.replyFrom ne 'other'&& replyPost.replyFrom ne 'email' && replyPost.replyFrom ne 'weixin'}">
                                                            		<span>(${ctp:i18n('bbs.from.mobile.client.js') })</span>
                                                            </c:if>
                                                            </div>
                                                            <div class="right">
        														<c:choose>
        															<c:when test="${state.count == 1 && nowPage == 1 && board.orderFlag == '0'}">
        																<div class="reply_order first_reply">${ctp:i18n('bbs.info.reply1floor')}</div>
        															</c:when>
        															<c:when test="${state.count == 2 && nowPage == 1 && board.orderFlag == '0'}">
        																<div class="reply_order second_reply">${ctp:i18n('bbs.info.reply2floor')}</div>
        															</c:when>
        															<c:when test="${state.count == 3 && nowPage == 1 && board.orderFlag == '0'}">
        																<div class="reply_order third_reply">${ctp:i18n('bbs.info.reply3floor')}</div>
        															</c:when>
        														</c:choose>
        														<div class="reply_content_right">
        															<div class="reply_time">${ctp:formatDateTime(replyPost.replyTime)}</div>
        															<div class="reply_list_handle">
        																<c:if test="${replyPost.canBeDeleteFlag}">
        																	<a href="javascript:;" class="list_delete" onclick="deleteReply('${replyPost.id}',true)">${ctp:i18n('bbs.boardmanager.menu.delarticle.label') }</a>
        																</c:if>
        																<c:if test="${canReply}">
        																	<a href="javascript:;" class="list_reply" onclick="createChildReply('${replyPost.id}');">${ctp:i18n('bbs.reply.label')}</a>
        																</c:if>
        															</div>
        														</div>
                                                            </div>
														</div>
                                                        <div class="view_reply_content">
    														<div class="reply_content left">
                                                                <c:if test="${replyPost.replyFrom eq 'pc' || replyPost.replyFrom == null}">
    															${replyPost.content}
                                                                </c:if>
                                                                <c:if test="${replyPost.replyFrom != null && replyPost.replyFrom ne 'pc' }">
    															${bbs:showReplyContent(replyPost.content,true)}
                                                                </c:if>
    															<div class="div-float" style="display: none" id="attachmentTRreply${replyPost.id}">
    																<div class="atts-label">${ctp:i18n('common.attachment.label') } :&nbsp;&nbsp;(<span id="attachmentNumberDivreply${replyPost.id}"></span>)</div>
                                                                    <div isGrid="true" class="comp" comp="type:'fileupload',attachmentTrId:'reply${replyPost.id}',checkSubReference:false,canFavourite:false,applicationCategory:'9',canDeleteOriginalAtts:false" attsdata='${replyPost.fileListJson}'></div>
                                                                    <div id="attachmentAreareply${replyPost.id}" class="reply_attachment"></div>
    															</div>
    														</div>
    														<div class="reply_like right" title="${v3x:toHTML(replyPost.praise)}">
    															<c:choose>
    																<c:when test="${replyPost.praiseFlag}">
    																	<em class="icon16 discuss_like_current_16"></em>
    																</c:when>
    																<c:when test="${article.state==100}">
    																	<em class="icon16 discuss_like_16"></em>
    																</c:when>
    																<c:otherwise>
    																	<em class="icon16 discuss_like_16" onclick="addReplyPraise('${replyPost.id}')"></em>
    																</c:otherwise>
    															</c:choose>
    															<span class="discuss_num">${replyPost.praiseSum}</span>
    														</div>
                                                        </div>
													</div>
												</div>
												<c:if test="${fn:length(replyPost.childList)>0 }">
												<div class="reply_others">
													<ul class="user_reply_list">
													<c:forEach items="${replyPost.childList}" var="childReply" varStatus="status">
														<li class="reply_list_info ${status.last ? 'lastLi' : ''}" id = "childReply_${childReply.id}">
															<div class="reply_content_info">
																<div class="child_reply_top">
																	<div class="reply_username left">
                                                                    <c:choose>
                                                                        <c:when test="${childReply.replyUserId==v3x:currentUser().id}">
                                                                            <span class="color_999">${v3x:showMemberName(childReply.replyUserId)}</span>
                                                                        </c:when>
                                                                        <c:when test="${childReply.anonymousFlag&&childReply.replyUserId!=v3x:currentUser().id}">
    																		<span class="reply_userfirst">${ctp:i18n('anonymous.label')}</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="reply_userfirst" onclick="showMemberCard('${childReply.replyUserId}')">${v3x:showMemberName(childReply.replyUserId)}</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
																	<c:if test="${childReply.replyFlag==6}">
                                                                        <span style="color:#333;">${ctp:i18n('bbs.reply.label')}</span>
                                                                        <c:choose>
                                                                            <c:when test="${childReply.toReplyUserId==v3x:currentUser().id}">
        																		<span class="color_999">${childReply.toReplyUserName}</span>
                                                                            </c:when>
                                                                            <c:when test="${childReply.toReplyAnonymousFlag && childReply.toReplyUserId!=v3x:currentUser().id}">
        																		<span class="reply_usersecond">${ctp:i18n('anonymous.label')}</span>
                                                                            </c:when>
                                                                            <c:otherwise>
        																		<span class="reply_usersecond" onclick="showMemberCard('${childReply.toReplyUserId}')">${childReply.toReplyUserName}</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
																	</c:if>
			                                                        <c:if test="${childReply.replyFrom != null && childReply.replyFrom eq 'weixin' }">
			                                                                     <span>(${ctp:i18n('bbs.from.weChat')})</span>
			                                                        </c:if>
			                                                        <c:if test="${childReply.replyFrom != null && childReply.replyFrom ne 'pc' && childReply.replyFrom ne 'other'&& childReply.replyFrom ne 'email' && childReply.replyFrom ne 'weixin'}">
			                                                                     <span>(${ctp:i18n('bbs.from.mobile.client.js') })</span>
			                                                        </c:if>
																	</div>
    																<div class="reply_others_right">
    																	<div class="reply_time">${ctp:formatDateTime(childReply.replyTime)}</div>
    																	<div class="reply_list_handle">
    																		<c:if test="${childReply.canBeDeleteFlag}">
    																			<a href="javascript:;" class="list_delete" onclick="deleteReply('${childReply.id}',false,'${replyPost.id}')">${ctp:i18n('bbs.boardmanager.menu.delarticle.label')}</a>
    																		</c:if>
    																		<c:if test="${canReply }">
    																			<a href="javascript:;" class="list_reply" onclick = "createC2CReply('${replyPost.id}','${childReply.id}')">${ctp:i18n('bbs.reply.label')}</a>
    																		</c:if>
    																	</div>
    																</div>
																</div>
																<div class="reply_content">${bbs:showReplyContent(childReply.content,false)}</div>
															</div>
														</li>
													</c:forEach>
													</ul>
													<img src="${path}/skin/default/images/cultural/bbs/reply_other_corner.jpg" class="reply_other_corner"/>
												</div>
												</c:if>
											</div>
										</li>
										</c:forEach>
										<li class="reply_list_page">
                                            <c:if test="${pages>1}">
											<span class="discuss_page">
												<em class="icon16 discuss_left_16" onclick="nextPage();"></em>
												<span class="page_circles">
													<c:set value='${pageArea}' var='pageArea' />
													<c:forEach var="x" begin="${pageArea*10+1 }" end="${ (pageArea+1)*10 }" step="1">
												  		<c:if test="${x<=pages}">
													    	<c:if test="${nowPage==x}">
													     		<a href="javascript:;" class="page_num current">${x}</a>
													    	</c:if>
													    	<c:if test="${nowPage!=x}">
													      		<a href="javascript:;" class="page_num" onclick="goPage(parseInt(${x}));">${x}</a>
													    	</c:if>
												  		</c:if>
													</c:forEach>
												</span>
												<em class="icon16 discuss_right_16" onclick="prevPage();"></em>
											</span>
                                            </c:if>
										</li>
									</ul>
								</div>
							</div>
							<img src="${path}/skin/default/images/cultural/bbs/corner.png" width="21" height="11" class="reply_corner">
						</div>
						<c:if test="${canReply}">
							<div class="say_words">
								<div class="say_words_info">
									<span class="say_words_title">${ctp:i18n('bbs.info.say2words')}</span>
									<div class="textarea_edit" style="height:375px; overflow:hidden;">
										<div style="height:380px;">
										<c:if test="${article.state !=100}">
												<iframe id="replyArticle" name="replyArticle" frameborder="0" width="100%" style="height:100%;" src="${detailURL}?method=replyArticleNew&useReplyFlag=1&articleId=${article.id}&fromIsearch=${param.fromIsearch}&isCollCube=${isCollCube}"></iframe>
										</c:if>
										</div>
									</div>
									<div class="textarea_edit_reply">
										<div class="edit_reply_attchment" style="width: 100%">
											<span class="edit_reply_left">
												<span class="pointer">
													<c:if test="${article.messageNotifyFlag}">
                                                    <label for="isSendMessage">
													<input type="checkbox" class="reply_checkbox" id="isSendMessage" checked="checked"/>
													<span>${ctp:i18n('send.message.to.issue.user.label')}</span>
                                                    </label>
													</c:if>
													<c:if test="${article.anonymousReplyFlag}">
                                                        <label for="isSecret">
														<input type="checkbox" class="reply_checkbox" id="isSecret"/>
														<span>${ctp:i18n('anonymous.reply')}</span>
                                                        </label>
													</c:if>
												</span>
												<span class="pointer">
													<em class="icon16 file_attachment_16 margin_b_5 margin_l_10"></em>
													<span class="insert_file" onclick="javascript:insertAttachmentPoi('atts1')">${ctp:i18n('oper.insert')}</span>
												</span>
	                                            <a  id="reply_button" class="button reply_button" style="margin-top:0;" onclick="createReply('${article.id}',true)">${ctp:i18n('bbs.reply.label')}</a>
											</span>
											<div id="attachmentTRatts1" style="display:none;">${ctp:i18n('common.attachment.label')}:(<span id="attachmentNumberDivatts1"></span>)</div>
											<div id="atts2" class="comp" comp="type:'fileupload',applicationCategory:'9',attachmentTrId:'atts1',canDeleteOriginalAtts:false,originalAttsNeedClone:false"></div>
                                            <div id="attachmentAreaatts1" class="reply_attachment"></div>
    								     </div>
      								</div>
    							</div>
    						</div>
    					</c:if>
					</c:if>
				</div>
			</div>
		</div>
		<div class="to_top" id="back_to_top">
			<span class="scroll_bg">
				<em class="icon24 to_top_24 margin_t_5"></em>
				<span class="back_top_msg hidden">${ctp:i18n('bbs.info.goTop')}</span>
			</span>
		</div>
		<c:if test="${pre != 'true' && article.state != 3 && canReply}">
		<div class="discuss_reply_info" id="discuss_info">
			<span class="scroll_bg ">
				<em class="icon24 discuss_info_24 margin_t_5"></em>
				<span class="back_top_msg hidden">${ctp:i18n('quick.reply.label')}</span>
			</span>
		</div>
		</c:if>
	</body>
	<footer>
		<script>
		//下一页响应事件
		function nextPage(){
			var nowPage = ${nowPage}-1;
			var articleId = articleID;
			var newPageSize = 20;
			var newTotalPages = ${pages}+0;
			if(nowPage<1) {
				return null;
			}
			if("${param.isCollCube}" == "1"){
				parent.window.location.replace("${detailURL}?method=bbsView&articleId="+articleId+"&group=true&nowPagePara="+nowPage+"&isCollCube="+"${param.isCollCube}");
			}else{
				getA8Top().location.replace("${detailURL}?method=bbsView&articleId="+articleId+"&group=true&nowPagePara="+nowPage);
			}
		}

		//上一页响应事件
		function prevPage(){
			var nowPage = ${nowPage}+1;
			var articleId = articleID;
			var newPageSize = 20;
			var newTotalPages = ${pages}+0;
			if(nowPage>newTotalPages) {
				return null;
			}
			if("${param.isCollCube}" == "1"){
				parent.window.location.replace("${detailURL}?method=bbsView&articleId="+articleId+"&group=true&nowPagePara="+nowPage+"&isCollCube="+"${param.isCollCube}");
			}else{
				getA8Top().location.replace("${detailURL}?method=bbsView&articleId="+articleId+"&group=true&nowPagePara="+nowPage);
			}
		}

		//首页响应事件
		function firstPage(){
			var pageSize = 20;
			var articleId = articleID;
			if("${param.isCollCube}" == "1"){
				parent.window.location.replace("${detailURL}?method=bbsView&articleId="+articleId+"&group=true&pageSizePara="+pageSize+"&nowPagePara=1"+"&isCollCube="+"${param.isCollCube}");
			}else{
				getA8Top().location.replace("${detailURL}?method=bbsView&articleId="+articleId+"&group=true&pageSizePara="+pageSize+"&nowPagePara=1");
			}
		}

		//末页响应事件
		function endPage(){
			var articleId = articleID;
			var pageSize = 20;
			var lasePageNum = getTotalPages("${size}", pageSize);
			if("${param.isCollCube}" == "1"){
				parent.window.location.replace("${detailURL}?method=bbsView&articleId="+articleId+"&group=true&pageSizePara="+pageSize+"&nowPagePara="+lasePageNum+"&isCollCube="+"${param.isCollCube}");
			}else{
				getA8Top().location.replace("${detailURL}?method=bbsView&articleId="+articleId+"&group=true&pageSizePara="+pageSize+"&nowPagePara="+lasePageNum);
			}
		}

		//go响应事件
		function goPage(nowPageStr){
			var nowPage = 1;
			var pageSize = 20;
			var totalPages = ${pages};

			nowPage = parseInt(nowPageStr);
			if(nowPage>totalPages){
				nowPage = totalPages;
			}
			if(nowPage<=0) {
				nowPage = 1;
			}
			if("${param.from}" == "colCube"){
				parent.window.location.replace("${detailURL}?method=bbsView&articleId=${article.id}&from=${param.from}&pageSizePara="+pageSize+"&nowPagePara="+nowPage);
			}else{
				window.location.replace("${detailURL}?method=bbsView&articleId=${article.id}&from=${param.from}&pageSizePara="+pageSize+"&nowPagePara="+nowPage);
			}
		}
		</script>
	</footer>
</html>
