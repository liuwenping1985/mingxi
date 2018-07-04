<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="bbsHeader.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta charset="utf-8">
		<title>
        <c:if test="${boardMessage!=null}">${ctp:i18n('bbs.discussion.index')}</c:if>
        <c:if test="${boardMessage==null || param.spaceType=='2' || param.spaceType=='4'}">${ctp:i18n('bbs.index.label')}</c:if>
        </title>
		<link rel="stylesheet" type="text/css" href="${path}/skin/default/bbs.css${v3x:resSuffix()}" />
        <link rel="stylesheet" href="${path}/apps_res/pubinfo/css/index_search.css${ctp:resSuffix()}">
        <style type="text/css">
        .list_infos .icon16{cursor:default;}
        </style>
		<script src="${path}/apps_res/bbs/js/common.js${v3x:resSuffix()}"></script>
		<script src="${path}/apps_res/bbs/js/bbsCommon.js${v3x:resSuffix()}"></script>
		<script src="${path}/apps_res/bbs/js/bbsIndex.js${v3x:resSuffix()}"></script>
        <script type="text/javascript" src="${path}/apps_res/pubinfo/js/index_search.js${ctp:resSuffix()}"></script>
		<script type="text/javascript">
		var url_boardId = "${param.boardId}";
		var _spaceType = '${param.spaceType}';
        var _spaceId = '${param.spaceId}';
        //栏目指定版块
        var fragmentId = '${param.fragmentId}';
        var ordinal = '${param.ordinal}';
        var panelValue = '${param.panelValue}';
		</script>
	</head>
	<body>
	<input id="currentUserId" type="hidden" value="${v3x:currentUser().id}"/>
	<input id="_path" type="hidden" value="${path}"/>
		<div class="container">
			<div class="container_top">
                <div class="container_top_area">
    				<span class="index_logo hand" title="${ctp:i18n('bbs.return.to.index')}" onclick="toIndex();">
    					<img src="${path}/skin/default/images/cultural/bbs/index_logo.png" width="48" height="33">
    					<span class="index_logo_name">${ctp:i18n('bbs.label')}</span>
    				</span>
                    <div id="searchCondition"></div>
                </div>
			</div>
			<div class="content_container">
				<div class="container_auto">
                    <c:if test="${fn:length(coverBoardModelList)>0}">
					<div class="container_cover" <c:if test="${boardMessage!=null }">style="display:none;"</c:if> >
						<div class="cover_list">
							<div class="cover_list_info" pager="1">
								<c:forEach items="${coverBoardModelList}" var="cover" varStatus="status">
									<div class="list_img ${status.index==4?'list_img_last':''} hand" boardId="${cover.id }">
										<c:if test="${cover.imageId!=null}">
											<img src="${path}/commonimage.do?method=showImage&id=${cover.imageId}&size=custom&h=165&w=216" class="cover_img">
										</c:if>
										<c:if test="${cover.imageId==null}">
											<img src="${path}/apps_res/bbs/css/images/${bbs:getBoardImage(cover.id)}" class="cover_img">
										</c:if>
										<span class="add_talk">
										<c:if test="${cover.isAdminFlag}">
											<span class="" style="position:relative;">
												<em class="icon24 admin_cover_left_24" title="${ctp:i18n('blog.set.label')}" onclick="showDropList(this);"></em>
                                                <em class="icon24 admin_cover_right_24" title="${ctp:i18n('new.bbs.button')}" onclick="createArticle('${cover.id}',null);"></em>
												<div class="drop_component" style="left:-85px">
													<div class="corner">
														<img src="${path}/skin/default/images/cultural/bbs/drop_corner.png" class="drop_conner">
													</div>
													<ul class="drop_list">
														<li class="drop_list_li" onclick="adminSet('${cover.id}')">${ctp:i18n('bbs.set.label')}</li>
														<li class="drop_list_line"></li>
														<li class="drop_list_li" onclick="statistics('${cover.id}')">${ctp:i18n('bbs.count.label')}</li>
													</ul>
												</div>
											</span>
										</c:if>
										<c:if test="${!cover.isAdminFlag&&cover.hasAuthIssue}">
											<em class="icon24 add_talk_24" onclick="createArticle('${cover.id}',null);"></em>
										</c:if>
										</span>
										<div class="cover_name" title="${cover.boardName}">${ctp:toHTML(v3x:getLimitLengthString(cover.boardName,23,"..."))}</div>
									</div>
								</c:forEach>
								
							</div>
						</div>
					</div>
                    </c:if>
					<div class="container_discuss" <c:if test="${boardMessage!=null || fn:length(coverBoardModelList)<=0}">style="padding-top:20px;"</c:if>>
						<div class="discuss_left">
							<c:if test="${boardMessage!=null}">
                            <input type="hidden" value="${boardMessage.topNumber }" id="boardTopNumber"/>
							<div id="adminTitle" class="group_admin_manage">
								<div class="manage_list_infos">
									<div class="manage_infos_content">
										<div class="cover_left">
											<div class="manage_top">
												<span class="manage_title" title="${ctp:toHTML(boardMessage.boardName)}">	
													${v3x:getLimitLengthString(ctp:toHTML(boardMessage.boardName),50,"...")}
												</span>
												<%--<span class="manage_num">
													<span>[<font color="#ff6804"> ${boardMessage.articleNumber}</font> ${ctp:i18n('bbs.latest.post.label')} / ${boardMessage.replyPostNumber} ${ctp:i18n('bbs.reply.label')} ]</span>
												</span>--%>
											</div>
											<div class="manage_bottom">
												<span class="manage_user" title="${ctp:toHTML(boardAdmins)}">${ctp:i18n('bbs.admins')}：<span id="adminUser">${ctp:toHTML(boardAdmins)}</span></span>
											</div>
										</div>
										
										<div class="manage_right">
                                            <c:if test="${boardMessage.isAdminFlag }">
											<a id="adminBtn" class="button exit_manage_button" style="background:#3d81d5;" onclick="adminBoard()">
                                              <em class="icon24 manage_set_24"></em>
                                              <span class="talk_button_msg">${ctp:i18n('bbs.discussion.to.admin.js')}</span>
                                            </a>
                                            </c:if>
										</div>
									</div>
								</div>
							</div>
							</c:if>
                            <div class="admin_manage_left" id="contentLeft">
    							<div id="pageTab" class="discuss_left_header">
                                    <input type="checkbox" class="check_all" style="display:none;">
    								<ul class="left_header">
    									<li id="latestArticle" class="current left_header_li" onclick="showContent('latestArticle','${param.spaceType}','${param.spaceId}','${boardMessage.id}',1);">${ctp:i18n('bbs.latest.post')}</li>
    									<li id="latestReply" class="left_header_li" onclick="showContent('latestReply','${param.spaceType}','${param.spaceId}','${boardMessage.id}',1);">${ctp:i18n('bbs.latest.reply')}</li>
    									<li id="hot" class="left_header_li" onclick="showContent('hot','${param.spaceType}','${param.spaceId}','${boardMessage.id}',1);">${ctp:i18n('bbs.hot.post')}</li>
    									<li id="elite" class="left_header_li" onclick="showContent('elite','${param.spaceType}','${param.spaceId}','${boardMessage.id}',1);">${ctp:i18n('bbs.elite.label')}</li>
										<span style="font-size: 14px;color: #999999;float:right">${ctp:i18n('bbs.totalcount')}<span id="totalCount">0</span>${ctp:i18n('bbs.totalrow')}</span>
									</ul>
    							</div>
    							<div id="contentList" class="left_list">
    								<!-- <div class="discuss_left_list"> -->
    							</div>
                            </div>
                            
						</div>
						<div class="discuss_right" id="contentRight">
							<div class="company_discuss">
								<div class="user_msg_info">
									<div class="msg_info_header">
										<span class="user_photo" style="overflow: hidden;">
											<img src="${v3x:avatarImageUrl(v3x:currentUser().id)}">
										</span>
										<span class="user_name" title="${ctp:toHTML(v3x:currentUser().name)}" style="width: 75px;">
                                            <span style="word-break: break-word;line-height: 1;display: inline-block;vertical-align: middle;">
                                                ${ctp:toHTML(v3x:getLimitLengthString(v3x:currentUser().name,14,"..."))}
                                            </span>
                                        </span>
										<c:if test="${hasIssue}">
											<a class="button talk_button" <c:if test="${boardMessage!=null && (boardMessage.isAdminFlag || boardMessage.hasAuthIssue)}"> onclick="createArticle('${boardMessage.id}','');"</c:if><c:if test="${boardMessage==null || (boardMessage!=null && !boardMessage.hasAuthIssue)}"> onclick="createArticle('','');"</c:if>><span class="talk_button_add">+</span><span class="talk_button_msg">${ctp:i18n('bbs.issue.discuss.label')}</span></a>
										</c:if>
									</div>
									<ul class="msg_info_body">
										<li class="msg_info_li hand" onclick="toMyArticle('2');">
											<strong class="msg_num">${replyNum}</strong>
											<span class="msg_name">${ctp:i18n('bbs.reply.self')}</span>
										</li>
                                        <c:if test="${ctp:hasPlugin('doc') && ctp:getSystemProperty('doc.collectFlag') == 'true'}">
										<li class="msg_info_li hand" onclick="toMyArticle('3');">
											<strong class="msg_num">${collectNum}</strong>
											<span class="msg_name">${ctp:i18n('bbs.collect.self')}</span>
										</li>
                                        </c:if>
                                        <c:if test="${hasIssue}">
										<li class="msg_info_li_last hand" onclick="toMyArticle('1');">
											<strong class="msg_num">${articleNum}</strong>
											<span class="msg_name">${ctp:i18n('bbs.issue.self')}</span>
										</li>
                                        </c:if>
                                        <c:if test="${!hasIssue}">
										<li class="msg_info_li_last hand noper">
											<span class="msg_num">${articleNum}</span>
											<span class="msg_name">${ctp:i18n('bbs.issue.self')}</span>
										</li>
                                        </c:if>
									</ul>
								</div>
								<c:forEach items="${boardModelMap}" var="boardModelMap" varStatus="status">
								<ul class="discuss_ul">
									<li class="ling_4 ling_4_${status.index} "></li>
									<li class="discuss_title hand" onclick="toUnitIndex('${boardModelMap.key}');">
                                        <c:set value="bbs.board.${boardModelMap.key}" var="_boardName" />
										<span class="discuss_title_name">${ctp:i18n(_boardName)}</span>
                                        <c:if test="${param.spaceType == boardModelMap.key && empty param.boardId && (param.spaceType=='2'||param.spaceType=='3')}">
                                        <img class="current_corner" src="${path}/skin/default/images/cultural/bbs/cover_current.png">
                                        </c:if>
									</li>
									<li class="discuss_body">
										<ul class="discuss_body_page" id="boardType_${status.index}">
                                            <c:if test="${fn:length(boardModelMap.value)<=0}" >
                                              <c:if test="${boardModelMap.key == 'bbs.board.department'}">
                                              <div class="discuss_no_list_msg">${ctp:i18n('bbs.board.list.null.dept')}</div>
                                              </c:if>
                                              <c:if test="${boardModelMap.key != 'bbs.board.department'}" >
                                              <div class="discuss_no_list_msg">${ctp:i18n('bbs.board.list.null')}</div>
                                              </c:if>
                                            </c:if>
                                            <c:if test="${fn:length(boardModelMap.value)>0}" >
											<c:forEach items="${boardModelMap.value}" var="boardModel">
												<li class="discuss_cover_name hand" id="board_${boardModel.id}" title="${ctp:toHTML(boardModel.boardName)}">
													<span>${ctp:toHTML(v3x:getLimitLengthString(boardModel.boardName,29,"..."))}</span>
													<span class="discuss_cover">
														<c:if test="${boardModel.isAdminFlag}">
															<em class="icon24 admin_cover_left_24" title="${ctp:i18n('blog.set.label')}" onclick="showDropList(this);"></em>
                                                            <em class="icon24 admin_cover_right_24" title="${ctp:i18n('new.bbs.button')}" onclick="createArticle('${boardModel.id}',null);"></em>
                                                            <div class="drop_component">
                                                                <div class="corner">
                                                                    <img src="${path}/skin/default/images/cultural/bbs/drop_corner.png" class="drop_conner" />
                                                                </div>
                                                                <ul class="drop_list">
                                                                  <c:if test="${!(boardModel.affiliateroomFlag == '1' || boardModel.affiliateroomFlag == '4')}">
                                                                      <li class="drop_list_li" onclick="adminSet('${boardModel.id}')">${ctp:i18n('bbs.set.label')}</li>
                                                                      <li class="drop_list_line"></li>
                                                                  </c:if>
                                                                    <li class="drop_list_li" onclick="statistics('${boardModel.id}')">${ctp:i18n('bbs.count.label')}</li>
                                                                </ul>
                                                            </div>
														</c:if>
														<c:if test="${!boardModel.isAdminFlag && boardModel.hasAuthIssue}">
															<em class="icon24 add_talk_24" onclick="createArticle('${boardModel.id}',null);"></em>
														</c:if>
													</span>
                                                    <c:if test="${boardMessage!=null&&boardMessage.id==boardModel.id }">
                                                    <img class="current_corner" src="${path}/skin/default/images/cultural/bbs/cover_current.png">
                                                    </c:if>
												</li>
											</c:forEach>
                                            </c:if>
										</ul>
									</li>
								</ul>
								</c:forEach>
                                <c:if test="${boardMessage==null }">
								<c:if test="${!empty showbarHotList }">
								<ul class="discuss_ul padding_b_20">
									<li class="ling_4 ling_4_show"></li>
									<li class="discuss_title hand" onclick="goToShow();">
										<span class="discuss_title_name " >${ctp:i18n('show.ad.hotshow')}</span>
										<span class="discuss_title_more " >${ctp:i18n('show.ad.seemore')}></span>
									</li>
									<c:forEach items="${showbarHotList}" var="showbar" varStatus="status">
									<li class="discuss_hot_show">
										<div class="hot_show_info pointer" onclick="goToShow('${showbar.id}')">
											<div class="hot_show_photo">
												<img src="${path}/${showbar.coverPictureUrl}">
											</div>
											<div class="show_photo_title" title="${ctp:toHTMLWithoutSpaceEscapeQuote(showbar.showbarName)}">${ctp:toHTMLWithoutSpaceEscapeQuote(showbar.showbarName)}</div>
										</div>
									</li>
									</c:forEach>
								</ul>
								</c:if>
								
                                </c:if>
                                <c:if test="${boardMessage!=null }">
                                <ul class="discuss_ul overflow padding_b_25" id="hotBoard">
                                    <li class="ling_4 ling_4_hot"></li>
                                    <li class="discuss_title">
                                        <span class="discuss_title_name">${ctp:i18n('bbs.hot.discussion')}</span>
                                        <span id="changeHotBoard" class="discuss_title_more hand" onclick="hotBoard()">${ctp:i18n('bbs.change.change')}</span>
                                    </li>
                                    
                                </ul>
                                </c:if>
							</div>
						</div>
                    </div>
					  
				</div>
			</div>
		</div>
        <c:if test="${boardMessage.isAdminFlag }">
        <div id="adminEdit" class="admin_edit" style="display:none;">
            <ul class="admin_edit_ul">
                <li class="admin_edit_li hand" onclick="setArticle('1','${boardMessage.id}')">
                    <img src="${path}/skin/default/images/cultural/bbs/top.png" class="edit_li_img">
                    <span class="edit_li_name">${ctp:i18n('label.top.js')}</span>
                </li>
                <li class="li_line"></li>
                <li class="admin_edit_li hand" onclick="setArticle('2','${boardMessage.id}')">
                    <img src="${path}/skin/default/images/cultural/bbs/cancle_top.png" class="edit_li_img opacity30">
                    <span class="edit_li_name">${ctp:i18n('bbs.boardmanager.menu.canceltoparticle.label')}</span>
                </li>
                <li class="li_line"></li>
                <li class="admin_edit_li hand" onclick="setArticle('3','${boardMessage.id}')">
                    <img src="${path}/skin/default/images/cultural/bbs/essence.png" class="edit_li_img ">
                    <span class="edit_li_name">${ctp:i18n('bbs.elite.label')}</span>
                </li>
                <li class="li_line"></li>
                <li class="admin_edit_li hand" onclick="setArticle('4','${boardMessage.id}')">
                    <img src="${path}/skin/default/images/cultural/bbs/cancle_essence.png" class="edit_li_img opacity30">
                    <span class="edit_li_name">${ctp:i18n('bbs.boardmanager.menu.cancelelitearticle.label')}</span>
                </li>
                <li class="li_line"></li>
                <li class="admin_edit_li hand" onclick="deleteArticle('','${boardMessage.id}')">
                    <img src="${path}/skin/default/images/cultural/bbs/delete.png" class="edit_li_img">
                    <span class="edit_li_name">${ctp:i18n('bbs.boardmanager.menu.delarticle.label')}</span>
                </li>
                <c:if test="${ctp:hasPlugin('doc')}">
                <li class="li_line"></li>
                <li class="admin_edit_li hand" onclick="bbsPigeonhole('<%=com.seeyon.ctp.common.constants.ApplicationCategoryEnum.bbs.key()%>','${boardMessage.id}')">
                    <img src="${path}/skin/default/images/cultural/bbs/file.png" class="edit_li_img">
                    <span class="edit_li_name">${ctp:i18n('inquiry.document.label')}</span>
                </li>
                </c:if>
                <c:if test="${canMove}">
                <li class="li_line"></li>
                <li class="admin_edit_li hand" onclick="moveTo('${boardMessage.id}')">
                <img src="${path}/skin/default/images/cultural/bbs/move.png" class="edit_li_img">
                <span class="edit_li_name">${ctp:i18n('bbs.menu.move.label')}</span>
                </li>
                </c:if>
            </ul>
        </div>
        </c:if>
		<div class="to_top" id="back_to_top">
			<span class="scroll_bg">
				<em class="icon24 to_top_24 margin_t_5"></em>
				<span class="back_top_msg hidden">${ctp:i18n('bbs.return.to.top')}</span>
			</span>
		</div>
	</body>
</html>
