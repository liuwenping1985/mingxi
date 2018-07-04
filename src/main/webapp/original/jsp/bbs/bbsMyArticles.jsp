<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="bbsHeader.jsp"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/bbs" prefix="bbs"%>
<html>
<head>
<meta charset="utf-8">
  <title><c:choose>
      <c:when test="${myType==1}">
        ${ctp:i18n('bbs.discussion.my.issue')}
      </c:when>
      <c:when test="${myType==2}">
        ${ctp:i18n('bbs.discussion.my.reply')}
      </c:when>
      <c:when test="${myType==3}">
        ${ctp:i18n('bbs.discussion.my.collect')}
      </c:when>
    </c:choose></title>
    <link rel="stylesheet" type="text/css" href="${path}/skin/default/bbs.css${v3x:resSuffix()}" />
  <link rel="stylesheet" type="text/css" href="${path}/apps_res/bbs/css/discuss_mine.css${v3x:resSuffix()}" />
  <style type="text/css">
  /* id_xxx 修改condition组件样式 */
  #searchCondition,#state_dropdown{position:relative;}
  #search_dropdown_content_iframe,#state_dropdown_content_iframe{width:0;height:0;left:0;top:32px;}
  .common_drop_list .common_drop_list_content a{text-align:left;}
  .header_operate{height:35px;}
  </style>
  <script src="${path}/apps_res/bbs/js/common.js${v3x:resSuffix()}"></script>
  <script src="${path}/apps_res/bbs/js/bbsCommon.js${v3x:resSuffix()}"></script>
  <script src="${path}/apps_res/bbs/js/bbsMyArticles.js${v3x:resSuffix()}"></script>
  <script type="text/javascript">
  <c:if test="${myType==2}">
      var pages = ${pages};
      var pageNo = ${pageNo};
  </c:if>
      var myType = ${myType};
      var url_boardId = "${param.spaceId}";
      var _spaceType = '${param.spaceType}';
      var _spaceId = '${param.spaceId}';
    </script>
</head>
<body>
  <div class="container">
    <div class="container_top">
        <div class="container_top_area">
          <span class="index_logo hand" title="${ctp:i18n('bbs.return.to.index')}" onclick="toIndex();">
            <img src="${path}/skin/default/images/cultural/bbs/index_logo.png" width="48" height="33"> <span class="index_logo_name">${ctp:i18n('bbs.label')}</span>
          </span>
          <%-- <span class="index_user">
            <!-- <img src="${path}/skin/default/images/cultural/bbs/index_user.png" class="index_user_img"> -->
            <img src="${path}/skin/default/images/cultural/bbs/index_header_line.png" width="1" height="60" class="index_line"> 
              <span class="index_cover hand">
                <em class="icon24 index_cover_24"></em>
              </span>
          </span> --%>
        </div>
    </div>
    <div class="content_container">
      <div class="container_auto">
        <!-- 热门板块  -->
        <c:if test="false">
        <div class="container_cover">
          <div class="cover_list">
            <div class="cover_list_info" pager="1">
              <c:forEach items="${coverBoardModelList}" var="cover" varStatus="status">
                <div class="list_img hand" boardId="${cover.id }">
                  <c:if test="${cover.imageId!=null}">
                    <img src="${path}/fileUpload.do?method=showRTE&fileId=${cover.imageId}&type=image" class="cover_img">
                  </c:if>
                  <c:if test="${cover.imageId==null}">
                    <img src="${path}/skin/default/images/cultural/bbs/${bbs:getBoardImage(cover.id)}" class="cover_img">
                  </c:if>
                  <span class="add_talk">
                    <c:if test="${cover.isAdminFlag}">
                      <span class="" style="position: relative;">
                        <em class="icon24 admin_cover_left_24" onclick="showDropList(this);"></em>
                        <em class="icon24 admin_cover_right_24" onclick="createArticle('${cover.id}',null);"></em>
                        <div class="drop_component" style="left:-70px;">
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
        <div class="container_discuss">
          <div class="discuss_left">
            <c:if test="${myType==1}">
              <div class="discuss_left_header">
                <div class="header_operate left">
                  <span class="cover_end hand" onclick="closeMyArticle()">
                    <em class="icon24 cover_end_24"></em>
                    <span class="left">${ctp:i18n('bbs.close.article')}</span>
                  </span>
                  <span class="line_1"></span>
                  <span class="cover_edit hand" onclick="editMyArticle()">
                    <em class="icon24 cover_edit_24"></em>
                    <span class="left">${ctp:i18n('bul.manageraction.false')}</span>
                  </span>
                  <span class="line_1"></span>
                  <span class="cover_delete hand" onclick="deleteMyArticle()">
                    <em class="icon24 cover_delete_24"></em>
                    <span class="left">${ctp:i18n('delete.label')}</span>
                  </span>
                  <span class="line_1"></span>
                  <span class="cover_delete hand" onclick="publishMyArticle()">
                    <em class="icon24 cover_publish_current_24"></em>
                    <span class="left">${ctp:i18n('blog.article.create')}</span>
                  </span>
                </div>
                <div id="searchCondition"></div>
              </div>
            </c:if>
            <c:if test="${myType==3}">
              <div class="discuss_left_header">
                <div id="searchCondition"></div>
              </div>
            </c:if>
            <c:choose>
              <c:when test="${myType==2}">
                <div class="my_reply_list">
                  <c:if test="${fn:length(myReplyList)<=0}">
                  <div class="empty_reply">
                    <img alt="" class="empty_reply_img" width="103" height="129" src="${path}/apps_res/pubinfo/image/null.png">
                    <div class="empty_reply_msg">${ctp:i18n('bbs.list.no.reply.js')}</div>
                  </div>
                  </c:if>
                  <c:forEach items="${myReplyList}" var="list" varStatus="status">
                  <ul class="reply_list">
                      <li class="reply_list_info">
                        <div class="reply_content_info">
                          <div class="reply_top">
                            <div class="reply_username">
                              <span class="reply_userfirst">${ctp:i18n('bbs.my')}</span>
                              &nbsp; ${ctp:i18n('bbs.reply.label')}&nbsp;
                              <span class="reply_usersecond">${ctp:toHTML(v3x:getLimitLengthString(list.toReplyUserName,10,"..."))}</span>
                              <span class="reply_delete right hand" onclick="deleteMyReply('${list.id }','${list.articleId}','${list.replyFlag}')" >${ctp:i18n('delete.label')}</span>
  
                            </div>
                            <div class="reply_title word_break_all">
                            <c:choose>
                              <c:when test="${list.replyFlag != 4}">
                                ${list.content==null? ctp:i18n('bbs.content.not.display') : bbs:showReplyContent(list.content,false) }
                              </c:when>
                              <c:otherwise>
                                ${list.content==null? ctp:i18n('bbs.content.not.display') : ctp:toHTML(list.content) }
                              </c:otherwise>
                            </c:choose>
                            </div>
                          </div>
                          <div class="reply_content">
                            <div class="content_info">
                              <span class="reply_username  margin_r_5">
                                ${ctp:i18n('bbs.reply.label')} <span title="${ctp:toHTML(v3x:getLimitLengthString(list.articleIssueUser,10,"..."))}">${ctp:toHTML(list.articleIssueUser)}</span> ${ctp:i18n('bbs.article.talk')}
                                <span class="hand color_333" onclick="viewArticle('${list.articleId}')" >${ctp:toHTML(list.articleName)}</span>
                              </span>
                            </div>
                          </div>
                          <div class="reply_bottom">
                            <div class="reply_time" style="display: block;">${ctp:formatDateByPattern(list.replyTime,"yyyy-MM-dd HH:mm:ss") }</div>
                          </div>
                        </div>
                      </li>
                  </ul>
                  </c:forEach>
                </div>
                <c:if test="${pages>1}">
                <div class="reply_page">
                  <span class="discuss_page margin_r_20" id="pageCount"></span>
                </div>
                </c:if>
             </c:when>
             <c:otherwise>
                <table id="myArticleTable" cellpadding="0" cellspacing="0" width="100%" height="100%" class="table"></table>
             </c:otherwise>
          </c:choose>

        </div>
        <div class="discuss_right">
          <div class="company_discuss">
            <div class="user_msg_info">
              <div class="msg_info_header">
                <span class="user_photo" style="overflow: hidden;">
                  <img src="${v3x:avatarImageUrl(v3x:currentUser().id)}">
                </span>
                <span class="user_name" title="${ctp:toHTML(v3x:currentUser().name)}">${ctp:toHTML(v3x:getLimitLengthString(v3x:currentUser().name,8,"..."))}</span>
                <c:if test="${hasIssue}">
                <a class="button talk_button" onclick="createArticle('','');">
                  <span class="talk_button_add">+</span>
                  <span class="talk_button_msg">${ctp:i18n('bbs.issue.discuss.label')}</span>
                </a>
                </c:if>
              </div>
              <ul class="msg_info_body">
                <li class="msg_info_li hand" onclick="toMyArticle('2')">
                  <strong class="msg_num" id="replyNum">${replyNum}</strong>
                  <span class="msg_name">${ctp:i18n('bbs.reply.self')}</span>
                </li>
                <c:if test="${ctp:hasPlugin('doc') && ctp:getSystemProperty('doc.collectFlag') == 'true'}">
                <li class="msg_info_li hand" onclick="toMyArticle('3')">
                  <strong class="msg_num" id="collectNum">${collectNum}</strong>
                  <span class="msg_name">${ctp:i18n('bbs.collect.self')}</span>
                </li>
                </c:if>
                <c:if test="${hasIssue}">
                <li class="msg_info_li_last hand" onclick="toMyArticle('1')">
                  <strong class="msg_num" id="issueNum">${articleNum}</strong>
                  <span class="msg_name">${ctp:i18n('bbs.issue.self')}</span>
                </li>
                </c:if>
                <c:if test="${!hasIssue}">
                <li class="msg_info_li_last hand noper">
                  <span class="msg_num" id="issueNum">${articleNum}</span>
                  <span class="msg_name">${ctp:i18n('bbs.issue.self')}</span>
                </li>
                </c:if>
              </ul>
            </div>
            <ul class="discuss_ul overflow padding_b_25" id="hotBoard">
              <li class="ling_4 ling_4_show"></li>
              <li class="discuss_title">
                <span class="discuss_title_name">${ctp:i18n('bbs.hot.discussion')}</span>
                <span id="changeHotBoard" class="discuss_title_more hand" onclick="hotBoard()">${ctp:i18n('bbs.change.change')}</span>
              </li>
            </ul>

          </div>
        </div>
         </div>
      </div>
    </div>
  </div>
  </div>
  <div class="to_top" id="back_to_top">
    <span class="scroll_bg">
      <em class="icon24 to_top_24 margin_t_5"></em>
      <span class="back_top_msg hidden">${ctp:i18n('bbs.return.to.top')}</span>
    </span>
  </div>
</body>
</html>