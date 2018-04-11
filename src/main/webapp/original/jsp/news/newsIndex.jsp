<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="newsHeader.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>
    <c:if test="${newsTypeMessage==null}">${ctp:i18n('news.newsIndex')}</c:if>
    <c:if test="${newsTypeMessage!=null}">${ctp:i18n('news.newsTypeIndex')}</c:if>
    </title>
    <link rel="stylesheet" href="${path}/skin/default/news.css${ctp:resSuffix()}">
    <link rel="stylesheet" href="${path}/apps_res/pubinfo/css/index_search.css${ctp:resSuffix()}">
    <style type="text/css">
    .left_list .icon16{cursor:default;}
    </style>
    <script type="text/javascript" src="${path}/apps_res/news/js/common.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" src="${path}/apps_res/news/js/newsIndex.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" src="${path}/apps_res/pubinfo/js/index_search.js${ctp:resSuffix()}"></script>
    <script type="text/javascript">
    var VJoinMember = ${CurrentUser.externalType == 1}; //是否是VJoin人员
    var newsTypeId = '${newsTypeMessage.id}';
    var _spaceId = '${param.spaceId}';
    var _spaceType = '${param.spaceType}';
    var labelPage = '${labelPage}';
    //栏目指定版块
    var fragmentId = '${param.fragmentId}';
    var ordinal = '${param.ordinal}';
    var panelValue = '${param.panelValue}';
    //我的新闻栏目穿透参数
    var myNews='${param.myNews}';
    if (VJoinMember) {
        myNews = "all";
    }

    function toIndex(){
      var url = '';
      if(_spaceType=='4'){
        url = '${path}/newsData.do?method=newsIndex&boardId=${param.spaceId}&spaceType=${param.spaceType}&spaceId=${param.spaceId}';
      }else if(_spaceType==''||_spaceType=='2'|| _spaceType=='3'){
        url = '${path}/newsData.do?method=newsIndex';
      }else{
        url = '${path}/newsData.do?method=newsIndex&spaceType=${param.spaceType}&spaceId=${param.spaceId}';
      }
      window.location.href = url;
    }
    </script>
</head>
<body>
  <input type="hidden" value="${designateTypeIds}" name="designateTypeIds" id="designateTypeIds"/>
  <div class="container">
    <div class="container_top">
       <div class="container_top_area">
        <span class="index_logo hand" title="${ctp:i18n('news.backToIndex')}" onclick="toIndex();">
          <img src="${path}/skin/default/images/cultural/news/news_logo.png" width="39" height="39">
          <span class="index_logo_name">${ctp:i18n('news.news')}</span>
        </span>
        <div id="searchCondition"></div>
      </div>
    </div>
    <div class="content_container">
      <div class="container_auto">
        <c:if test="${fn:length(topImageNews)>=7 && newsTypeMessage==null}">
        <div class="container_cover">
          <div class="cover_list">
            <ul class="cover_list_info" pager="1" id="newsCover">
              <li class="cover_list_li">
                <div class="cover_list_img hand" title="${topImageNews.get(0).title }" onclick="newsView('${topImageNews.get(0).id}')">
                    <img src="${topImageNews.get(0).imageUrl }" class="cover_img cover_img_first">
                    <div class="cover_name font14" style="width:474px;">${ctp:toHTML(v3x:getLimitLengthString(topImageNews.get(0).title,32,"...")) }</div>
                </div>
              </li>
              <li class="cover_list_li second_li">
                  <div class="cover_list_img margin_r_5 hand" title="${topImageNews.get(1).title }" onclick="newsView('${topImageNews.get(1).id}')">
                      <img src="${topImageNews.get(1).imageUrl }" class="cover_img cover_img_third">
                      <div class="cover_name font14" style="width:205px;">${ctp:toHTML(v3x:getLimitLengthString(topImageNews.get(1).title,22,"...")) }</div>
                  </div>
                  <div class="cover_list_img hand" title="${topImageNews.get(2).title }" onclick="newsView('${topImageNews.get(2).id}')">
                      <img src="${topImageNews.get(2).imageUrl }" class="cover_img cover_img_third">
                      <div class="cover_name font14" style="width:205px;">${ctp:toHTML(v3x:getLimitLengthString(topImageNews.get(2).title,22,"...")) }</div>
                  </div>
                  <div class="cover_list_img margin_tr_5 hand" title="${topImageNews.get(4).title }" onclick="newsView('${topImageNews.get(4).id}')">
                      <img src="${topImageNews.get(4).imageUrl }" class="cover_img cover_img_third">
                      <div class="cover_name font14" style="width:205px;">${ctp:toHTML(v3x:getLimitLengthString(topImageNews.get(4).title,22,"...")) }</div>
                  </div>
                  <div class="cover_list_img margin_t_5 hand" title="${topImageNews.get(5).title }" onclick="newsView('${topImageNews.get(5).id}')">
                      <img src="${topImageNews.get(5).imageUrl }" class="cover_img cover_img_third">
                      <div class="cover_name font14" style="width:205px;">${ctp:toHTML(v3x:getLimitLengthString(topImageNews.get(5).title,22,"...")) }</div>
                  </div>
              </li>
              <li class="cover_list_li_last">
                  <div class="cover_list_img hand" title="${topImageNews.get(3).title }" onclick="newsView('${topImageNews.get(3).id}')">
                      <img src="${topImageNews.get(3).imageUrl }" class="cover_img cover_img_third">
                      <div class="cover_name font14" style="width:205px;">${ctp:toHTML(v3x:getLimitLengthString(topImageNews.get(3).title,22,"...")) }</div>
                  </div>
                  <div class="cover_list_img margin_t_5 hand" title="${topImageNews.get(6).title }" onclick="newsView('${topImageNews.get(6).id}')">
                      <img src="${topImageNews.get(6).imageUrl }" class="cover_img cover_img_third">
                      <div class="cover_name font14" style="width:205px;">${ctp:toHTML(v3x:getLimitLengthString(topImageNews.get(6).title,22,"...")) }</div>
                  </div>
              </li>
            </ul>
          </div>
        </div>
        </c:if>
        <div class="container_discuss">
          <div class="discuss_left" id="contentLeft">
            <c:if test="${newsTypeMessage!=null }">
            <div class="group_admin_manage">
                <div class="manage_admin_list_infos">
                    <div class="manage_infos_content">
                        <div class="cover_left">
                            <div class="manage_top">
                                <span class="manage_title" title="${ctp:toHTML(newsTypeMessage.typeName)}">
                                ${v3x:getLimitLengthString(ctp:toHTML(newsTypeMessage.typeName),50,"...")}
                                </span>
                                <%--<span class="manage_num">
                                    <span>[<font color="#ff6804"> ${newsTypeCount} </font>${ctp:i18n('news.news')} / ${newsTypeReplyCount } ${ctp:i18n('news.comments')} ]</span>
                                </span>--%>
                            </div>
                            <div class="manage_bottom">
                                <span class="manage_user" title="${ctp:toHTML(newsTypeMessage.adminsName)}">${ctp:i18n('news.adminType')}：<span id="adminsName">${ctp:toHTML(newsTypeMessage.adminsName)}</span></span>
                                <c:if test="${hasAuditUser }">
                                <span class="manage_auditing" title="${ctp:toHTML(newsTypeMessage.auditName)}">${ctp:i18n('news.auditType')}：<span id="auditName">${ctp:toHTML(newsTypeMessage.auditName)}</span></span>
                                </c:if>
                            </div>
                        </div>
                        <c:if test="${newsTypeMessage.canAdminOfCurrent }">
                        <div class="manage_right">
                            <a id="adminBtn" onclick="adminBoard('${newsTypeMessage.id}')" class="manager_button exit_manage_button"><em class="icon24 manage_set_24"></em><span class="talk_button_msg">${ctp:i18n('news.manageNews')}</span></a>
                        </div>
                        </c:if>
                    </div>
                </div>
            </div>
            </c:if>
            <div class="border_e6">
            <div class="discuss_left_header" id="listTab">
              <input type="checkbox" class="check_all" style="display:none;">
              <ul class="left_header">
                <li class="current left_header_li" id="findLatest" onclick="findListDatas('findLatest',1,'${newsTypeMessage.id}')">${ctp:i18n('news.latestNews')}</li>
                <li class="left_header_li" id="findHot" onclick="findListDatas('findHot',1,'${newsTypeMessage.id}')">${ctp:i18n('news.latestHot')}</li>
                <li class="left_header_li" id="findFocus" onclick="findListDatas('findFocus',1,'${newsTypeMessage.id}')">${ctp:i18n('news.foucsNews')}</li>
                <span style="font-size: 14px;color: #999999;float:right">${ctp:i18n('news.totalcount')}<span id="totalCount">0</span>${ctp:i18n('news.totalrow')}</span>
              </ul>
            </div>
            <div class="left_list" id="listData">
              <!-- contentList -->
            </div>
            </div>
          </div>
          <div class="discuss_right" id="news_discuss_right">
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
                  <a class="button talk_button new_border-radius"  
                  	<c:if test="${newsTypeMessage!=null && (newsTypeMessage.canAdminOfCurrent || newsTypeMessage.canNewOfCurrent)}"> onclick="createNews('${newsTypeMessage.spaceType}','${newsTypeMessage.spaceId}','${newsTypeMessage.id}');" </c:if>
                  	<c:if test="${newsTypeMessage==null || (newsTypeMessage!=null &&!newsTypeMessage.canNewOfCurrent)}"> onclick="createNews('${param.spaceType}','${param.spaceId}','');" </c:if> >
                    <span class="talk_button_add">+</span>
                    <span class="talk_button_msg">${ctp:i18n('news.publishNews')}</span>
                  </a>
                  </c:if>
                </div>
                <ul class="msg_info_body">
                  <li class="msg_info_li hand" onclick="toMyInfo('2');">
                    <strong class="msg_num">${myReplyCount}</strong>
                    <span class="msg_name">${ctp:i18n('news.myCommentsCount')}</span>
                  </li>
                  <c:if test="${ctp:hasPlugin('doc') && ctp:getSystemProperty('doc.collectFlag') == 'true'}">
                  <li class="msg_info_li hand" onclick="toMyInfo('3');">
                    <strong class="msg_num">${myCollectCount}</strong>
                    <span class="msg_name">${ctp:i18n('news.myCollectCount')}</span>
                  </li>
                  </c:if>
                  <c:if test="${hasIssue}">
                  <li class="msg_info_li hand" onclick="toMyInfo('1');">
                    <strong class="msg_num">${myIssueCount}</strong>
                    <span class="msg_name">${ctp:i18n('news.myIssueCount')}</span>
                  </li>
                  </c:if>
                  <c:if test="${!hasIssue}">
                  <li class="msg_info_li noper" onclick="toMyInfo('0');">
                    <span class="msg_num">${myIssueCount}</span>
                    <span class="msg_name">${ctp:i18n('news.myIssueCount')}</span>
                  </li>
                  </c:if>
                  <c:if test="${hasAudit}">
                  <li class="msg_info_li_last hand" onclick="toMyInfo('4');">
                    <strong class="msg_num">${myAuditCount}</strong>
                    <span class="msg_name">${ctp:i18n('news.newsAudit')}</span>
                  </li>
                  </c:if>
                  <c:if test="${!hasAudit}">
                  <li class="msg_info_li_last noper" onclick="toMyInfo('0');">
                    <span class="msg_num">${myAuditCount}</span>
                    <span class="msg_name">${ctp:i18n('news.newsAudit')}</span>
                  </li>
                  </c:if>
                </ul>
              </div>
              <c:forEach items="${newsTypeModelMap}" var="typeModelMap" varStatus="status">
              <ul class="discuss_ul">
                <li class="ling_${status.index}"></li>
                <li class="discuss_title hand" onclick="toUnitIndex('${typeModelMap.key}');">
                    <c:set value="news.type.${typeModelMap.key}" var="_typeName" />
                    <span class="discuss_title_name">${ctp:i18n(_typeName)}</span>
                    <c:if test="${param.spaceType == typeModelMap.key && empty param.boardId && (param.spaceType=='2'||param.spaceType=='3')}">
                    <img class="current_corner" src="${path}/skin/default/images/cultural/news/cover_current.png">
                    </c:if>
                </li>
                <li class="discuss_body">
                    <ul class="discuss_body_page" id="newsType_${status.index}">
                        <c:if test="${fn:length(typeModelMap.value)<=0}" >
                        <div class="discuss_no_list_msg ">${ctp:i18n('news.null.newsType')}</div>
                        </c:if>
                        <c:if test="${fn:length(typeModelMap.value)>0}" >
                        <c:forEach items="${typeModelMap.value}" var="typeModel">
                            <li class="discuss_cover_name hand" id="board_${typeModel.id}">
                                <span title="${ctp:toHTML(typeModel.typeName)}">${ctp:toHTML(v3x:getLimitLengthString(typeModel.typeName,29,"..."))}</span>
                                <span class="discuss_cover">
                                    <c:if test="${typeModel.canAdminOfCurrent}">
                                        <em class="icon24 admin_cover_left_24" title="${ctp:i18n('news.setting')}" onclick="showDropList(this);"></em>
                                        <em class="icon24 admin_cover_right_24" title="${ctp:i18n('news.publishNews')}" onclick="createNews('${typeModel.spaceType}','${typeModel.spaceId}','${typeModel.id}');"></em>
                                        <div class="drop_component">
                                            <div class="corner">
                                                <img src="${path}/skin/default/images/cultural/news/drop_corner.png" class="drop_conner" />
                                            </div>
                                            <ul class="drop_list">
                                                <c:if test="${typeModel.spaceType != '4'}">
                                                <li class="drop_list_li" onclick="typeSetting('${typeModel.id}')">${ctp:i18n('news.setting')}</li>
                                                <li class="drop_list_line"></li>
                                                </c:if>
                                                <li class="drop_list_li" onclick="statistics('${typeModel.id}')">${ctp:i18n('news.statistics')}</li>
                                            </ul>
                                        </div>
                                    </c:if>
                                    <c:if test="${!typeModel.canAdminOfCurrent && typeModel.canNewOfCurrent}">
                                        <em class="icon24 add_talk_24" onclick="createNews('${typeModel.spaceType}','${typeModel.spaceId}', '${typeModel.id}');"></em>
                                    </c:if>
                                </span>
                                <c:if test="${newsTypeMessage!=null && newsTypeMessage.id == typeModel.id }">
                                <img class="current_corner" src="${path}/skin/default/images/cultural/news/cover_current.png">
                                </c:if>
                            </li>
                        </c:forEach>
                        </c:if>
                    </ul>
                </li>
              </ul>
              </c:forEach>
              <input type="hidden" value="${newsTypeMessage.topNumber == 'null' ? 0: newsTypeMessage.topNumber}" id="newsTopNumber"/>
              <c:if test="${newsTypeMessage!=null }">
              <ul class="discuss_ul overflow padding_b_25" id="hotNews">
                  <li class="ling_hot"></li>
                  <li class="discuss_title ">
                      <span class="discuss_title_name">${ctp:i18n('news.hotNews')}</span>
                      <span id="changeHotNews" class="discuss_title_more hand" onclick="changeHotNews()">${ctp:i18n('news.change.hotNews')}></span>
                  </li>

              </ul>
              </c:if>
              <c:if test="${newsTypeMessage==null }">
                    <c:if test="${!empty showbarHotList }">
                    <ul class="discuss_ul padding_b_20">
                        <li class="ling_show"></li>
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
            </div>
          </div>
        </div>
      </div>
      <div class="admin_edit hidden" id="adminEdit">
          <ul class="admin_edit_ul">
          		<%-- 置顶 --%>
              <li class="admin_edit_li hand" onclick="setTop('1',true)">
                 <img src="${path}/skin/default/images/cultural/news/top.png" class="edit_li_img">
                 <span class="edit_li_name">${ctp:i18n('news.top')}</span>
              </li>
              	<%-- 取消置顶 --%>
              <li class="li_line"></li>
              <li class="admin_edit_li hand" onclick="setTop('2',false)">
                  <img src="${path}/skin/default/images/cultural/news/cancle.png" class="edit_li_img">
                  <span class="edit_li_name">${ctp:i18n('news.cancleTop')}</span>
              </li>
              <li class="li_line"></li>
              <li class="admin_edit_li hand" onclick="focusNews(true);">
                  <img src="${path}/skin/default/images/cultural/news/foucs.png" class="edit_li_img">
                  <span class="edit_li_name">${ctp:i18n('news.foucsNews')}</span>
              </li>
              <li class="li_line"></li>
              <li class="admin_edit_li hand" onclick="focusNews(false);">
                  <img src="${path}/skin/default/images/cultural/news/cancle_foucs.png" class="edit_li_img">
                  <span class="edit_li_name">${ctp:i18n('news.cancelFoucsNews')}</span>
              </li>
              <li class="li_line"></li>
              <li class="admin_edit_li hand" onclick="publishNews();">
                  <img src="${path}/skin/default/images/cultural/news/cancle_publish.png" class="edit_li_img">
                  <span class="edit_li_name">${ctp:i18n('news.cancelPublish')}</span>
              </li>
              <li class="li_line"></li>
              <li class="admin_edit_li hand" onclick="deleteNews();">
                  <img src="${path}/skin/default/images/cultural/news/delete.png" class="edit_li_img">
                  <span class="edit_li_name">${ctp:i18n('news.delete.label')}</span>
              </li>
              <c:if test="${ctp:hasPlugin('doc')}">
              <li class="li_line"></li>
              <li class="admin_edit_li hand" onclick="newsPigeonhole('<%=com.seeyon.ctp.common.constants.ApplicationCategoryEnum.news.key()%>');">
                  <img src="${path}/skin/default/images/cultural/news/file.png" class="edit_li_img">
                  <span class="edit_li_name">${ctp:i18n('news.pigeonhole')}</span>
              </li>
              </c:if>
              <c:if test="${canMove}">
              <li class="li_line"></li>
              <li class="admin_edit_li hand" onclick="moveTo();">
                  <img src="${path}/skin/default/images/cultural/news/move.png" class="edit_li_img">
                  <span class="edit_li_name">${ctp:i18n('news.move')}</span>
              </li>
              </c:if>
          </ul>
      </div>
    </div>
  </div>
  <div class="to_top" id="back_to_top">
    <span class="scroll_bg">
      <em class="icon24 to_top_24 margin_t_5"></em>
      <span class="back_top_msg hidden">${ctp:i18n('news.backToTop')}</span>
    </span>
  </div>
</body>
</html>