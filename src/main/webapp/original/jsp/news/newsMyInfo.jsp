<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="newsHeader.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8">
<title>
<c:if test="${type==1}">${ctp:i18n('news.myIssueCount')}</c:if>
<c:if test="${type==2}">${ctp:i18n('news.myCommentsCount')}</c:if>
<c:if test="${type==3}">${ctp:i18n('news.myCollectCount')}</c:if>
<c:if test="${type==4}">${ctp:i18n('news.newsAudit')}</c:if>
</title>
<link rel="stylesheet" href="${path}/skin/default/news.css${ctp:resSuffix()}">
<link rel="stylesheet" type="text/css" href="${path}/apps_res/news/css/myPublish.css${ctp:resSuffix()}" />
<style type="text/css">
/* id_xxx 修改condition组件样式 */
#searchCondition,#state_dropdown{position:relative;}
#search_dropdown_content_iframe,#state_dropdown_content_iframe{width:0;height:0;left:0;top:30px;}
.common_drop_list .common_drop_list_content a{text-align:left;}
</style>
<script type="text/javascript" src="${path}/apps_res/news/js/common.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/news/js/newsMyInfo.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
      var myType = ${type};//1 我发起的 2 我评论的 3 我收藏的 4 新闻审核
      var _spaceType = '${param.spaceType}';
      var _spaceId = '${param.spaceId}'; 
      
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
  <div class="container">
    <div class="container_top">
      <div class="container_top_area">
        <span class="index_logo hand" title="${ctp:i18n('news.backToIndex')}" onclick="toIndex();">
          <img src="${path}/skin/default/images/cultural/news/news_logo.png" width="39" height="39">
          <span class="index_logo_name">${ctp:i18n('news.news')}</span>
        </span>
      </div>
    </div>
    <div class="content_container myPublish">
      <div class="container_auto">
        <div class="container_discuss ">
          <div class="discuss_left">
            <!--左侧内容 begin-->
            <!--我发布的 begin-->
            <c:if test="${type==1 }">
              <div class="handle">
                <ul class="handle_list">
                  <li class="handle_list_li" onclick="newsEdit();">
                    <em class="icon24 cover_edit_24"></em>
                    <span>${ctp:i18n('news.edit.label')}</span>
                  </li>
                  <li class="handle_list_line">|</li>
                  <li class="handle_list_li" onclick="deleteNews();">
                    <em class="icon24 cover_delete_24"></em>
                    <span>${ctp:i18n('news.delete.label')}</span>
                  </li>
                  <li class="handle_list_line">|</li>
                  <li class="handle_list_li current" onclick="publishNews();">
                    <em class="icon24 cover_publish_current_24"></em>
                    <span>${ctp:i18n('news.publish')}</span>
                  </li>
                  <div id="searchCondition"></div>
                </ul>
              </div>
            </c:if>
            <c:if test="${type==3 }">
              <div class="handle">
                <ul class="handle_list">
                  <div id="searchCondition"></div>
                </ul>
              </div>
            </c:if>
            <c:if test="${type==4 }">
              <div class="handle">
                <ul class="handle_list">
                  <li class="handle_list_li" onclick="cancelAudit();">
                    <em class="icon24 cover_edit_24"></em>
                    <span>${ctp:i18n('news.revocation.audit')}</span>
                  </li>
                  <div id="searchCondition"></div>
                </ul>
              </div>
            </c:if>
            <div class="tableDate ${type!=2 ? 'margin_t_10':''}">
              <div class="radius_15">
                  <c:if test="${type!=2 }">
                  <table id="myInfoTable" cellpadding="0" cellspacing="0" width="100%" height="100%" class="table"></table>
                  </c:if>
                  <c:if test="${type==2 }">
                    <div class="my_reply_list">
                      <c:if test="${fn:length(replyList)<=0}">
                        <div class="empty_reply">
                          <img alt="" class="empty_reply_img" width="103" height="129" src="${path}/apps_res/pubinfo/image/null.png">
                          <div class="empty_reply_msg">${ctp:i18n('news.list.reply.null')}</div>
                        </div>
                      </c:if>
                      <c:forEach items="${replyList}" var="list" varStatus="status">
                        <ul class="reply_list">
                          <li class="reply_list_info">
                            <div class="reply_content_info">
                              <div class="reply_top">
                                <div class="reply_username">
                                  <span class="reply_userfirst">${ctp:i18n('news.my')}</span>
                                  &nbsp; ${ctp:i18n('news.reply.label')}&nbsp;
                                  <span class="reply_usersecond">${ctp:toHTML(list.toMemberName)}${ctp:toHTML(v3x:getLimitLengthString(toMemberName,30,"..."))}</span>
                                  <span class="reply_delete right hand" onclick="deleteMyReply('${list.id }','${list.replyType}')" >${ctp:i18n('news.delete.label')}</span>
    
                                </div>
                                <div class="reply_title word_break_all">${ctp:toHTML(list.replayContent) }</div>
                              </div>
                              <div class="reply_content">
                                <div class="content_info">
                                  <span class="reply_username  margin_r_5">
                                    ${ctp:i18n('news.reply.label')} <span title="${ctp:toHTML(v3x:getLimitLengthString(list.fromMemberName,30,"..."))}">${ctp:toHTML(list.fromMemberName)}</span> ${ctp:i18n('news.for.news')}
                                    <span class="hand color_333" onclick="clk({'id':'${list.newsId}'})" >${ctp:toHTML(list.replayTitle)}</span>
                                  </span>
                                </div>
                              </div>
                              <div class="reply_bottom">
                                <div class="reply_time" style="display: block;">${ctp:formatDateTime(list.createDate) }</div>
                              </div>
                            </div>
                          </li>
                        </ul>
                      </c:forEach>
                  </div>
                  <c:if test="${pages>1}" >
                  <div class="reply_page">
                  <input type="hidden" id="pages" value="${pages}"/>
                  <input type="hidden" id="pageNo" value="${pageNo}"/>
                    <span class="discuss_page margin_r_20" id="pageCount">
                        <c:if test="${pageNo>1}">
                            <em onclick="myInfo(parseInt(${pageNo})-1);" class="icon16 discuss_left_16"></em>
                        </c:if>
                        <c:if test="${pageNo<=1}">
                            <em class="icon16 discuss_left_16"></em>
                        </c:if>
                        <c:forEach var="x" begin="${pageArea*10+1 }" end="${(pageArea+1)*10 }" step="1">
                          <c:if test="${x<=pages}">
                              <c:if test="${pageNo==x}">
                                  <a href="javascript:;" class="page_num  current">${x}</a>
                              </c:if>
                              <c:if test="${pageNo!=x}">
                                  <a href="javascript:myInfo(parseInt(${x}));" class="page_num">${x}</a>
                              </c:if>
                          </c:if>
                        </c:forEach>
                        <c:if test="${pageNo<pages}">
                            <em onclick="myInfo(parseInt(${pageNo})+1);" class="icon16 discuss_right_16"></em>
                        </c:if>
                        <c:if test="${pageNo>=pages}">
                            <em class="icon16 discuss_right_16"></em>
                        </c:if>
                    </span>
                  </div>
                  </c:if>
                  </c:if>
              </div>
            </div>
            <!--我发布的 end-->
            <!--左侧内容 end-->
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
                    <a class="button talk_button new_border-radius" onclick="createNews();">
                      <span class="talk_button_add">+</span>
                      <span class="talk_button_msg">${ctp:i18n('news.publishNews')}</span>
                    </a>
                  </c:if>
                </div>
                <ul class="msg_info_body">
                  <li class="msg_info_li ${type==2 ? 'current':''} hand" onclick="toMyInfo('2');">
                    <strong class="msg_num">${myReplyCount}</strong>
                    <span class="msg_name">${ctp:i18n('news.myCommentsCount')}</span>
                  </li>
                  <c:if test="${ctp:hasPlugin('doc') && ctp:getSystemProperty('doc.collectFlag') == 'true'}">
                  <li class="msg_info_li hand ${type==3 ? 'current':''}" onclick="toMyInfo('3');">
                    <strong class="msg_num">${myCollectCount}</strong>
                    <span class="msg_name">${ctp:i18n('news.myCollectCount')}</span>
                  </li>
                  </c:if>
                  <c:if test="${!hasIssue}">
                  <li class="msg_info_li hand noper ${type==1 ? 'current':''}" onclick="toMyInfo('0');">
                    <span class="msg_num">${myIssueCount}</span>
                    <span class="msg_name">${ctp:i18n('news.myIssueCount')}</span>
                  </li>
                  </c:if>
                  <c:if test="${hasIssue}">
                  <li class="msg_info_li hand ${type==1 ? 'current':''}" onclick="toMyInfo('1');">
                    <strong class="msg_num">${myIssueCount}</strong>
                    <span class="msg_name">${ctp:i18n('news.myIssueCount')}</span>
                  </li>
                  </c:if>
                  <c:if test="${hasAudit}">
                  <li class="msg_info_li_last hand ${type==4 ? 'current':''}" onclick="toMyInfo('4');">
                    <strong class="msg_num">${myAuditCount}</strong>
                    <span class="msg_name">${ctp:i18n('news.newsAudit')}</span>
                  </li>
                  </c:if>
                  <c:if test="${!hasAudit}">
                  <li class="msg_info_li_last hand noper ${type==4 ? 'current':''}" onclick="toMyInfo('0');">
                    <span class="msg_num">${myAuditCount}</span>
                    <span class="msg_name">${ctp:i18n('news.newsAudit')}</span>
                  </li>
                  </c:if>
                </ul>
              </div>

              <ul class="discuss_ul overflow padding_b_25" id="hotNews">
                <li class="ling_0"></li>
                <li class="discuss_title">
                  <span class="discuss_title_name">${ctp:i18n('news.hotNews')}</span>
                  <span id="changeHotNews" class="discuss_title_more hand" onclick="changeHotNews()">${ctp:i18n('news.change.hotNews')}></span>
                </li>
              </ul>

            </div>
          </div>
        </div>
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