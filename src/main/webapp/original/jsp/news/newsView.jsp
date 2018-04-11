<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="newsHeader.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8">
<title>${bean.title }</title>
<link rel="stylesheet" href="${path}/skin/default/news.css${ctp:resSuffix()}">
<link rel="stylesheet" type="text/css" href="${path}/apps_res/news/css/myPublish.css${ctp:resSuffix()}" />
<script src="${path}/apps_res/news/js/common.js${ctp:resSuffix()}"></script>
<script src="${path}/apps_res/news/js/newsView.js${ctp:resSuffix()}"></script>
<script src="${path}/apps_res/doc/js/docFavorite.js${v3x:resSuffix()}"></script>
<script type="text/javascript">
var currentUserName = "${v3x:showMemberName(v3x:currentUser().id)}";
var view_newsId = '${bean.id}';
//正文类型
var bodyType = "${bean.ext4 eq 'form' ? bean.ext4 : bean.dataFormat}";

//返回首页（集团和单位空间下的处于发布状态下的新闻）
function toIndex(){
  if( ('${bean.spaceType}' =='2' || '${bean.spaceType}' =='3') && '${bean.state}' =='30' && '${param.from}' != 'pigeonhole'){
    var url = '${path}/newsData.do?method=newsIndex';
    window.location.href = url;
  }
}

<c:if test="${viewFlag!=null && viewFlag eq 'pendingAudit'}">
initLock();
window.onbeforeunload = "";
window.onunload = unlock;
//进行加锁
function initLock(){
  try {
      var action="news.lockaction.audit";
      var requestCaller = new XMLHttpRequestCaller(this, "ajaxNewsDataManager", "lock", false);
      requestCaller.addParameter(1, "Long", '${bean.id}');
      requestCaller.addParameter(2, "String",action);
      var ds= requestCaller.serviceRequest();
  }
  catch (ex1) {
      alert("Exception : " + ex1);
  }
}
//进行解锁
function unlock(){
    try {
      var newsDatAjax = new newsDataManager();
      newsDatAjax.unlock('${bean.id}');
    }
    catch (ex1) {
        alert("Exception : " + ex1);
    }
    <%-- try {
        var requestCaller = new XMLHttpRequestCaller(this, "ajaxNewsDataManager", "unlock", false);
        requestCaller.addParameter(1, "Long", '${bean.id}');
        如果用户直接点击退出或关闭IE，此时解锁无法进行，可能形成死锁
        requestCaller.needCheckLogin = false;
        var ds = requestCaller.serviceRequest();
    }catch (ex1) {
        alert("Exception : " + ex1);
    } --%>
}
</c:if>
</script>
<style>
#contentTD p{font-size: 16px;line-height: 1.6;word-break: normal;}
<%--表单专属样式start--%>
.browse_class span {
  color: blue;
}
.xdTableHeader TD {
  min-height: 10px;
}
.radio_com {
  margin-right: 0px;
}
.xdTextBox {
  BORDER-BOTTOM: #dcdcdc 1pt solid;
  min-height: 20px;
  TEXT-ALIGN: left;
  BORDER-LEFT: #dcdcdc 1pt solid;
  BACKGROUND-COLOR: window;
  DISPLAY: inline-block;
  WHITE-SPACE: nowrap;
  COLOR: windowtext;
  OVERFLOW: hidden;
  BORDER-TOP: #dcdcdc 1pt solid;
  BORDER-RIGHT: #dcdcdc 1pt solid;
}
.xdRichTextBox {
  font-size: 12px;
  BORDER-BOTTOM: #dcdcdc 1pt solid;
  TEXT-ALIGN: left;
  BORDER-LEFT: #dcdcdc 1pt solid;
  BACKGROUND-COLOR: window;
  FONT-STYLE: normal;
  min-height: 20px;
  display: inline-block;
  VERTICAL-ALIGN: bottom !important;
  WORD-WRAP: break-word;
  COLOR: windowtext;
  BORDER-TOP: #dcdcdc 1pt solid;
  BORDER-RIGHT: #dcdcdc 1pt solid;
  TEXT-DECORATION: none;
  margin: 0px !important;
  padding: 0px !important;
  border: 0px !important;
}
#mainbodyDiv div,#mainbodyDiv input,#mainbodyDiv textarea,#mainbodyDiv p,#mainbodyDiv th,#mainbodyDiv td,#mainbodyDiv ul,#mainbodyDiv li{
  font-family: inherit;
}
<%--表单专属样式end--%>

#content{border:none;}
#content:hover{border:none;}
</style>
</head>
<body>
  <input type="hidden" id="subject" name="subject" value="${ctp:toHTML(bean.title)}">
  <div class="container">
    <div class="container_top">
      <div style="width:768px;" class="container_top_area">
      <span class="news_index_logo hand" <c:if test="${(bean.spaceType == 2 || bean.spaceType ==3) && bean.state ==30 && param.from != 'pigeonhole' }">title="${ctp:i18n('news.backToIndex')}"</c:if> onclick="toIndex();">
        <img src="${path}/skin/default/images/cultural/news/news_logo.png" width="39" height="39">
        <span class="news_index_logo_name">${ctp:i18n('news.news')}</span>
      </span>
      </div>
    </div>
    <div class="content_container Details">
      <c:if test="${viewFlag!=null && viewFlag eq 'pendingAudit'}">
      <div class="container_check">
        <div class="check_share">
            <c:if test="${auditorModify eq 'true'}">
            <a class="check_button left" style="background: #3d81d5;"><span onclick="editNews('${bean.id}','${param.spaceId}');" class="talk_button_msg" >${ctp:i18n('news.editNews')}</span></a>
            </c:if>
            <span class="Wopacity left">${ctp:i18n('news.allow.share.to')}：</span>
            <span class="check_share_to left">
                <input id="weixin" type="checkbox" disabled ${v3x:outConditionExpression(bean.shareWeixin, 'checked', '')}/>
                <label for="weixin">${ctp:i18n('news.weixin')}</label>
            </span>
        </div>
        <div class="check_suggest">
            <div class="left">
                <textarea class="Wopacity" id="auditAdvice"
                    style="color:#999;"
                    onfocus="if(this.value == '${ctp:i18n('news.tip.audit.opinion')}') {this.style.color = '#333';this.value = '';}"
                    onblur="if(this.value =='') {this.style.color = '#999';this.value = '${ctp:i18n('news.tip.audit.opinion')}';}"
                    >${ctp:i18n('news.tip.audit.opinion')}</textarea>
            </div>
            <div class="right">
                <a class="check_button blue"><span class="buttom_msg" onclick="auditSubmit('publish');">${ctp:i18n('news.audit.pass.publish')}</span></a>
                <a class="check_button blue"><span class="buttom_msg" onclick="auditSubmit('audit');">${ctp:i18n('news.audit.pass')}</span></a>
                <a class="check_button red"><span class="buttom_msg" onclick="auditSubmit('noaudit');">${ctp:i18n('news.noPass')}</span></a>
            </div>
        </div>
      </div>
      </c:if>
      <c:if test="${bean.state==20 || bean.state==40}">
      <div class="container_check">
        <div class="check_suggest pass">
        <div class="check_msg">
            <div style="margin: 10px;">
              <span class="check_msg_title">${v3x:getLimitLengthString(v3x:showMemberName(bean.auditUserId),10,"...")}${ctp:i18n('news.audit.opinion')}： </span>
              <c:if test="${bean.state==20}">
                <span style="color:green;">${ctp:i18n('news.audit.pass')}</span>
              </c:if>
              <c:if test="${bean.state==40}">
                <span style="color:red;">${ctp:i18n('news.state.auditNotPassed')}</span>
              </c:if>
              &nbsp;&nbsp;&nbsp;&nbsp;
              <span>${ctp:formatDateTime(bean.updateDate) }</span>
            </div>
            <div class="check_content">
                <span class="left check_content_left">${ctp:i18n('news.postscript')}：</span>
                <span class="check_commons">${v3x:toHTMLWithoutSpace(bean.auditAdvice)}</span>
            </div>
            <c:if test="${bean.state==20 && v3x:currentUser().id==bean.createUser && param.from ne 'myAudit'}">
            <div class="right pulish_button">
                <a class="reply_button bule"><span class="buttom_msg" onclick="publishNewsView();">${ctp:i18n('news.publish')}</span></a>
            </div>
            </c:if>
        </div>
        </div>
      </div>
      </c:if>
      <div class="container_auto">
      <div class="all_content">
        <div class="container_discuss"  id="mainContent">
          <!--11.25 begin-->
          <div class="">
            <div class="mainText_head">
              <div class="mainText_head_title">
                <div class="title_name" style="word-break: break-all;white-space: pre-wrap;">${ctp:toHTML(bean.title)}</div>
              </div>
              <div class="mainText_head_msg">
                <span class="Wopacity mainText_head_msgSpan ">
                  <span class="msgSpan">
                    <c:choose>
                      <c:when test="${bean.state==30 || bean.state==100 && param.from eq 'pigeonhole'}">
                        <span>${ctp:formatDateTime(bean.publishDate) }</span>
                      </c:when>
                      <c:otherwise>
                        <span>${ctp:formatDateTime(bean.createDate) }</span>
                      </c:otherwise>
                    </c:choose>
                  </span>
                  <c:if test="${bean.showPublishUserFlag }">
                  <span class="msgSpan">
                    <span title="${v3x:toHTML(bean.createUserName)}">${v3x:toHTML(v3x:getLimitLengthString(bean.createUserName,20,"..."))}</span>
                  </span>
                  </c:if>
                  <span class="msgSpan">
                    <span title="${v3x:toHTML(bean.publishDepartmentName)}">${v3x:toHTML(v3x:getLimitLengthString(bean.publishDepartmentName,20,"..."))}</span>
                  </span>
                  <span class="msgSpan">
                    <span>${v3x:toHTML(typeName)}</span>
                  </span>
                </span>
              </div>
              <c:if test="${viewStyle == '1'}">
                <div class="mainText_attachment" name="mergeButton" id="mergeButton3">
                  <!-- 附件 -->
                  <div id="attachmentTRAttFile" style="display: none;">
                <span class="attachmentFlag">
                  <em class="icon16 file_attachment_16"></em>
                  <span>(<span id="attachmentNumberDivAttFile"></span>)</span>
                </span>
                    <div id="attFileDomain" isGrid="true" class="comp" comp="type:'fileupload',attachmentTrId:'AttFile',canFavourite:false,applicationCategory:'8',canDeleteOriginalAtts:false" attsdata='${attListJSON }'></div>
                    <div style="clear:both"></div>
                  </div>
                  <!-- 关联文档 -->
                  <div id="attachment2TRDoc1" style="display: none">
                <span class="attachmentFlag">
                  <em class="icon16 relation_file_16"></em>
                  <span>(<span id="attachment2NumberDivDoc1"></span>)</span>
                </span>
                    <div id="assDocDomain" isCrid="true" class="comp" comp="type:'assdoc',attachmentTrId:'Doc1',applicationCategory:'8',modids:8,canDeleteOriginalAtts:false" attsdata='${attListJSON }'></div>
                    <div style="clear:both"></div>
                  </div>
                </div>
              </c:if>
              <div class="setBtn" id="mergeButton1">
                  <!-- 关联文档不显示收藏，打印 -->
                  <span class="left">
                    <c:if test="${bean.imageNews}">
                    <span class="head_title_print hand" onclick="lookImage('${bean.imageId}');">
                      <em class="icon16 news_seeImage_16"></em>
                      <span class="Wopacity">${ctp:i18n('news.lookImage')}</span>
                    </span>
                    </c:if>
                    <c:if test="${bean.state==30 && param.openFrom ne 'glwd'}">
                    <span class="head_title_print hand" onclick="printResult('${(not empty bean.ext5 && bean.dataFormat == 'OfficeWord') ? 'Pdf' : bean.dataFormat}',${not empty bean.ext4 && bean.ext4 == 'form' })">
                      <em class="icon16 print_16"></em>
                      <span class="Wopacity">${ctp:i18n('news.print')}</span>
                    </span>
                    </c:if>
                    <c:if test="${bean.state==30 && param.from ne 'pigeonhole' && docCollectFlag eq 'true'}">
                    <c:choose>
                      <c:when test="${isCollect}">
                        <span id="favoriteSpan" class="head_title_collect hand" onclick="cancelFavorite_News('${bean.id}',${bean.attachmentsFlag})">
                          <em class="ico16 stored_16"></em>
                          <span class="Wopacity">${ctp:i18n('news.cancelFavourite')}</span>
                        </span>
                      </c:when>
                      <c:otherwise>
                        <span id="favoriteSpan" class="head_title_collect hand" onclick="favorite_News('${bean.id}',${bean.attachmentsFlag})">
                          <em class="ico16 unstore_16"></em>
                          <span class="Wopacity">${ctp:i18n('news.favourite')}</span>
                        </span>
                      </c:otherwise>
                    </c:choose>
                    </c:if>
                  </span>
                  <span class="right  mainText_head_msgIcon">
                    <span>
                      <em class="icon16 discuss_click_16"></em>
                      <span class="Wopacity">${bean.readCount}</span>
                    </span>
                    <c:if test="${bean.type.commentPermit && bean.commentPermit}">
                    <span onclick="goToHotReply();">
                      <em class="icon16 discuss_reply_16"></em>
                      <span class="Wopacity">${replyNum }</span>
                    </span>
                    </c:if>
                    <span title="${v3x:showOrgEntitiesOfIds(bean.praise, 'Member', pageContext)}">
                      <c:if test="${newsPraise}">
                          <em id="newsPraise1" class="icon16 discuss_like_current_16"></em>
                      </c:if>
                      <c:if test="${!newsPraise && bean.state==30}">
                          <em id="newsPraise1" class="icon16 discuss_like_16" onclick="addNewsPraise('${bean.id}');"></em>
                      </c:if>
                      <c:if test="${!newsPraise && bean.state!=30}">
                          <em id="newsPraise1" class="icon16 discuss_like_16"></em>
                      </c:if>
                      <span id="newsPraiseSum1" class="Wopacity">${bean.praiseSum}</span>
                    </span>
                  </span>

                </div>
                <div class="title_line"></div>
            </div>
            <c:if test="${bean.showKeywordsArea == true || bean.showBriefArea == true}">
            <div class="mainText_keyWord Wopacity ">
              <c:if test="${bean.showKeywordsArea == true}">
              <div>
                <span>${ctp:i18n('news.keyWord')}：</span>
                <span>${v3x:toHTML(bean.keywords)}</span>
              </div>
              </c:if>
              <c:if test="${bean.showBriefArea == true}">
              <div>
                <span>${ctp:i18n('news.summary')}：</span>
                <span>${v3x:toHTML(bean.brief)}</span>
              </div>
              </c:if>
            </div>
            </c:if>
            <div class="mainText_body mainText" id="contentTD"  style="word-break: break-all;min-height: 250px;">
            <div style="width:100%; height:${(bean.dataFormat!='HTML' && bean.dataFormat!='FORM') ? '768px' : ''};">
            <c:choose>
                <c:when test="${bean.ext4=='form'}">
                    <v3x:showContent content="${empty bean.ext5 ? bean.content : bean.ext5}" type="${empty bean.ext5 ? bean.dataFormat : 'Pdf'}" createDate="${bean.createDate}" htmlId="content"  viewMode="edit" transForm="true"/>
                    <script type="text/javascript">
                        $("span[id^='field']").eq(0).parent().prepend("<div id='newInputPosition' style='width: 0px;height: 0px;position: relative;display:inline-block;'></div>");
                    </script>
                </c:when>
                <c:otherwise>
                    <v3x:showContent content="${empty bean.ext5 ? bean.content : bean.ext5}" type="${empty bean.ext5 ? bean.dataFormat : 'Pdf'}" createDate="${bean.createDate}" htmlId="content"  viewMode="edit"/>
                </c:otherwise>
            </c:choose>
            </div>
            <style>
                .mainText_body table{
                    width:100%;
                }
            </style>
            </div>
            <c:if test="${viewStyle != '1'}">
              <div class="mainText_attachment" name="mergeButton" id="mergeButton3">
                <!-- 附件 -->
                <div id="attachmentTRAttFile" style="display: none;">
                <span class="attachmentFlag">
                  <em class="icon16 file_attachment_16"></em>
                  <span>(<span id="attachmentNumberDivAttFile"></span>)</span>
                </span>
                  <div id="attFileDomain" isGrid="true" class="comp" comp="type:'fileupload',attachmentTrId:'AttFile',canFavourite:false,applicationCategory:'8',canDeleteOriginalAtts:false" attsdata='${attListJSON }'></div>
                  <div style="clear:both"></div>
                </div>
                <!-- 关联文档 -->
                <div id="attachment2TRDoc1" style="display: none">
                <span class="attachmentFlag">
                  <em class="icon16 relation_file_16"></em>
                  <span>(<span id="attachment2NumberDivDoc1"></span>)</span>
                </span>
                  <div id="assDocDomain" isCrid="true" class="comp" comp="type:'assdoc',attachmentTrId:'Doc1',applicationCategory:'8',modids:8,canDeleteOriginalAtts:false" attsdata='${attListJSON }'></div>
                  <div style="clear:both"></div>
                </div>
              </div>
            </c:if>
            <div class="mainText_foot" name="mergeButton" id="mergeButton4">
              <span class="right">
                <span>
                  <em class="icon16 discuss_click_16"></em>
                  <span class="Wopacity">${bean.readCount}</span>
                </span>
                <c:if test="${bean.type.commentPermit && bean.commentPermit}">
                <span onclick="goToHotReply();">
                  <em class="icon16 discuss_reply_16"></em>
                  <span class="Wopacity">${replyNum }</span>
                </span>
                </c:if>
                <span>
                  <c:if test="${newsPraise}">
                      <em id="newsPraise2" class="icon16 discuss_like_current_16" title="${v3x:showOrgEntitiesOfIds(bean.praise, 'Member', pageContext)}"></em>
                  </c:if>
                  <c:if test="${!newsPraise && bean.state==30}">
                      <em id="newsPraise2" class="icon16 discuss_like_16" title="${v3x:showOrgEntitiesOfIds(bean.praise, 'Member', pageContext)}" onclick="addNewsPraise('${bean.id}');"></em>
                  </c:if>
                  <c:if test="${!newsPraise && bean.state!=30}">
                      <em id="newsPraise2" class="icon16 discuss_like_16" title="${v3x:showOrgEntitiesOfIds(bean.praise, 'Member', pageContext)}"></em>
                  </c:if>
                  <span id="newsPraiseSum2" class="Wopacity">${bean.praiseSum}</span>
                </span>
              </span>
            </div>

          </div>

        </div>
        <c:if test="${bean.type.commentPermit && bean.commentPermit && (bean.state==30 || bean.state==100)}">
        <div class="Commentlist">
          <em class="right"></em>
          <div class="Commentlist_new">
            <div class="Commentlist_new_head">
              <span>${ctp:i18n('news.hotReply')}</span>
              <c:if test="${bean.type.commentPermit && bean.commentPermit && bean.state==30}">
              <a class="reply_button_fast right" onclick="goToReply();">
                <span class="icon24 discuss_info_24"></span>
                <span class="">${ctp:i18n('news.fastReply')}</span>
              </a>
              </c:if>
            </div>
            <ul class="Commentlist_new_list">
            <c:if test="${hotReplyList!=null && fn:length(hotReplyList)>0 }">
            <c:forEach items="${hotReplyList}" var="hotReply">
              <li class="new_list_li" id="hotReply_${hotReply.id}">
                <img class="newList_li_img left hand" onclick="$.PeopleCard({memberId:'${hotReply.fromMemberId}'});" src="${ctp:avatarImageUrl(hotReply.fromMemberId)}">
                <div class=" newList_li_msg">
                  <div>
                    <span class="Wopacity view_reply_name" onclick="$.PeopleCard({memberId:'${hotReply.fromMemberId}'});">${v3x:showMemberName(hotReply.fromMemberId)}</span>
                    <span class="replyDate right">${ctp:formatDateTime(hotReply.createDate)}</span>
                  </div>
                  <div class="li_msgText">
                    <span class="left">${v3x:toHTMLWithoutSpace(hotReply.replayContent)}</span>
                    <span class="right">
                      <c:if test="${fn:contains(hotReply.praise,v3x:currentUser().id)}">
                          <em class="icon16 discuss_like_current_16" title="${v3x:showOrgEntitiesOfIds(hotReply.praise, 'Member', pageContext)}"></em>
                      </c:if>
                      <c:if test="${!fn:contains(hotReply.praise,v3x:currentUser().id) && (bean.type.commentPermit && bean.commentPermit && bean.state==30)}">
                          <em class="icon16 discuss_like_16" title="${v3x:showOrgEntitiesOfIds(hotReply.praise, 'Member', pageContext)}" onclick="addReplyPraise('${hotReply.id}')"></em>
                      </c:if>
                      <c:if test="${!fn:contains(hotReply.praise,v3x:currentUser().id) && !(bean.type.commentPermit && bean.commentPermit && bean.state==30)}">
                          <em class="icon16 discuss_like_16" title="${v3x:showOrgEntitiesOfIds(hotReply.praise, 'Member', pageContext)}"></em>
                      </c:if>
                      <span class="Wopacity">${hotReply.praiseSum}</span>
                    </span>
                  </div>
                </div>
              </li>
            </c:forEach>
            </c:if>
            </ul>
          </div>
          <div class="Commentlist_all">
            <div class="commentlist_all_head">
              <span>${ctp:i18n('news.all.reply')}(<em id="replyAllNumber">${replyNum}</em>${ctp:i18n('news.bar')})</span>
              <c:if test="${pages>1}">
              <div class="tfoot right">
                <ol class="right pageUp Wopacity">
                  <li class="left" onclick="pageUp();">
                    <em class="icon16 discuss_left_16"></em>
                  </li>
                  <c:set value='${pageArea}' var='pageArea' />
                  <c:forEach var="x" begin="${pageArea*10+1 }" end="${ (pageArea+1)*10 }" step="1">
                      <c:if test="${x<=pages}">
                          <c:if test="${nowPage==x}">
                              <li class="left view_pages current"><span>${x}</span></li>
                          </c:if>
                          <c:if test="${nowPage!=x}">
                              <li class="left view_pages" onclick="goPage(parseInt(${x}));"><span>${x}</span></li>
                          </c:if>
                      </c:if>
                  </c:forEach>
                  <li class="left" onclick="pageDn();">
                    <em class="icon16 discuss_right_16"></em>
                  </li>
                </ol>

              </div>
              </c:if>
            </div>
            <ul class="Commentlist_new_list">
              <c:forEach items="${replyList}" var="replyList" varStatus="state">
              <li class="new_list_li" id = "reply_${replyList.id}">
                <img class="newList_li_img left hand" onclick="$.PeopleCard({memberId:'${replyList.fromMemberId}'});" src="${ctp:avatarImageUrl(replyList.fromMemberId)}">
                <div class=" newList_li_msg">
                  <div class="replyTop">
                    <div>
                      <c:if test="${replyList.fromMemberId == v3x:currentUser().id}">
                        <span class="Wopacity color_999">${v3x:showMemberName(replyList.fromMemberId)}</span>
                      </c:if>
                      <c:if test="${replyList.fromMemberId != v3x:currentUser().id}">
                        <span class="Wopacity view_reply_name" onclick="$.PeopleCard({memberId:'${replyList.fromMemberId}'});">${v3x:showMemberName(replyList.fromMemberId)}</span>
                      </c:if>
                      <c:if test="${replyList.replyFrom != null && replyList.replyFrom eq 'weixin'}">
                        <span class="Wopacity color_999">(${ctp:i18n('bbs.from.weChat')})</span>
                      </c:if>
                      <c:if test="${replyList.replyFrom != null && replyList.replyFrom ne 'pc'&& replyList.replyFrom ne 'email' && replyList.replyFrom ne 'weixin'}">
                        <span class="Wopacity color_999">(${ctp:i18n("news.reply.from.phone")})</span>
                      </c:if>
                      <span class="right Wopacity">
                        <span class="replyDate right">${ctp:formatDateTime(replyList.createDate)}</span>
                        <span class="replyOper">
                          <c:if test="${replyList.canDelete =='true'&& bean.type.commentPermit && bean.commentPermit && bean.state==30}">
                          <span class="comDelet hand" onclick="delReply('${replyList.id}',0);">${ctp:i18n('news.delete.label')}</span>
                          </c:if>
                          <c:if test="${bean.type.commentPermit && bean.commentPermit && bean.state==30}">
                          <span class="hand" style="color: #0177c6" onclick="createChildReply('${replyList.id}','${replyList.id}','${replyList.fromMemberId}','${v3x:showMemberName(replyList.fromMemberId)}',1);">${ctp:i18n('news.comments')}</span>
                          </c:if>
                        </span>
                      </span>
                    </div>
                    <div class="li_msgText">
                      <span class="left">${v3x:toHTMLWithoutSpace(replyList.replayContent)}</span>
                      <span class="right">
                        <c:if test="${replyList.praiseFlag=='true'}">
                            <em id="likeIco_${replyList.id}" class="icon16 discuss_like_current_16" title="${v3x:showOrgEntitiesOfIds(replyList.praise, 'Member', pageContext)}"></em>
                        </c:if>
                        <c:if test="${replyList.praiseFlag=='false' && (bean.type.commentPermit && bean.commentPermit && bean.state==30)}">
                            <em id="likeIco_${replyList.id}" class="icon16 discuss_like_16" title="${v3x:showOrgEntitiesOfIds(replyList.praise, 'Member', pageContext)}" onclick="addReplyPraise('${replyList.id}')"></em>
                        </c:if>
                        <c:if test="${replyList.praiseFlag=='false' && !(bean.type.commentPermit && bean.commentPermit && bean.state==30)}">
                            <em id="likeIco_${replyList.id}" class="icon16 discuss_like_16" title="${v3x:showOrgEntitiesOfIds(replyList.praise, 'Member', pageContext)}"></em>
                        </c:if>
                        <span id ="rNum_${replyList.id}" class="Wopacity">${replyList.praiseSum}</span>
                      </span>
                    </div>
                  </div>
                  <c:if test="${fn:length(replyList.childReplyList)>0 }">
                  <ul class="otherCom">
                    <em></em>
                    <c:forEach items="${replyList.childReplyList}" var="childReply" varStatus="status">
                    <li id="childReply_${childReply.id}" class="${status.last ? 'lastLi' : '' }">
                      <div class="otherCom_title">
                        <span class="Wopacity">
                          <c:if test="${childReply.fromMemberId == v3x:currentUser().id}">
                          <span class="color_999">${v3x:showMemberName(childReply.fromMemberId)}</span>
                          </c:if>
                          <c:if test="${childReply.fromMemberId != v3x:currentUser().id}">
                          <span class="view_reply_name" onclick="$.PeopleCard({memberId:'${childReply.fromMemberId}'});">${v3x:showMemberName(childReply.fromMemberId)}</span>
                          </c:if>
                          <c:if test="${childReply.replyType==2}">
                          <span>${ctp:i18n('news.reply.label')}</span>
                          <c:if test="${childReply.toMemberId == v3x:currentUser().id}">
                          <span class="color_999">${v3x:showMemberName(childReply.toMemberId)}</span>
                          </c:if>
                          <c:if test="${childReply.toMemberId != v3x:currentUser().id}">
                          <span class="view_reply_name" onclick="$.PeopleCard({memberId:'${childReply.toMemberId}'});">${v3x:showMemberName(childReply.toMemberId)}</span>
                          </c:if>
                          </c:if>
                          <c:if test="${childReply.replyFrom != null && childReply.replyFrom eq 'weixin'}">
                            <span class="color_999">(${ctp:i18n('bbs.from.weChat')})</span>
                          </c:if>
                          <c:if test="${childReply.replyFrom != null && childReply.replyFrom ne 'pc'&& childReply.replyFrom ne 'email' && childReply.replyFrom ne 'weixin'}">
                            <span class="color_999">(${ctp:i18n("news.reply.from.phone")})</span>
                          </c:if>
                        </span>
                        <span class="replyDate right">${ctp:formatDateTime(childReply.createDate)}</span>
                        <span class="replyOper">
                        <c:if test="${bean.type.commentPermit && bean.commentPermit && bean.state==30}">
                        <span class="right Wopacity hand" style="color: #0177c6" onclick="createChildReply('${childReply.id}','${replyList.id}','${childReply.fromMemberId}','${v3x:showMemberName(childReply.fromMemberId)}',2);">${ctp:i18n('news.comments')}</span>
                        </c:if>
                        <c:if test="${childReply.canDelete =='true' && bean.type.commentPermit && bean.commentPermit && bean.state==30}">
                        <span class="comDelet right hand" onclick="delReply('${childReply.id}','${childReply.replyType}');">${ctp:i18n('news.delete.label')}</span>
                        </c:if>
                        </span>
                      </div>
                      <div class="li_msgText">
                        <span class="left">${v3x:toHTMLWithoutSpace(childReply.replayContent)}</span>
                      </div>
                    </li>
                    </c:forEach>
                  </ul>
                  </c:if>
                </div>
              </li>
              </c:forEach>

            </ul>
            <c:if test="${pages>1}">
            <div class="tfoot ">
              <ol class="right pageUp right Wopacity">
                <li class="left" onclick="pageUp();">
                    <em class="icon16 discuss_left_16"></em>
                  </li>
                  <c:forEach var="x" begin="${pageArea*10+1 }" end="${ (pageArea+1)*10 }" step="1">
                      <c:if test="${x<=pages}">
                          <c:if test="${nowPage==x}">
                              <li class="left view_pages current"><span>${x}</span></li>
                          </c:if>
                          <c:if test="${nowPage!=x}">
                              <li class="left view_pages" onclick="goPage(parseInt(${x}));"><span>${x}</span></li>
                          </c:if>
                      </c:if>
                  </c:forEach>
                  <li class="left" onclick="pageDn();">
                    <em class="icon16 discuss_right_16"></em>
                  </li>
              </ol>
            </div>
            </c:if>
          </div>
        </div>
        <c:if test="${bean.type.commentPermit && bean.commentPermit && bean.state==30}">
        <div class="myComment">
          <div class="Wopacity">
            <span class="say_words_title">${ctp:i18n('news.mySay')}</span>
          </div>
          <div class="textWord">
            <textarea id="replyContent"></textarea>
          </div>
          <div style="height: 16px;">
          <c:if test="${bean.messagePermit}">
            <span>
              <input type="checkbox" checked name="msgToCreater" id="msgToCreater"/>
              <label for="msgToCreater">
              <span class="Wopacity hand">${ctp:i18n('news.reply.to.createUser')}</span>
              </label>
            </span>
          </c:if>
            <a id="replyButton" class="reply_button right" onclick="saveReply(0,'','${bean.createUser}');">
              <span class="">${ctp:i18n('news.comments')}</span>
            </a>
          </div>
        </div>
        </c:if>
        <script type="text/javascript">
          function pageUp(){
            var nowPage = ${nowPage}-1;
            var newTotalPages = ${pages};
            if(nowPage<1) {
                return null;
            }
            if("${param.from}" == "colCube"){
                parent.window.location.replace("${path}/newsData.do?method=newsView&newsId=${bean.id}&group=true&replyPageNo="+nowPage+"&from=colCube");
            }else{
                getA8Top().location.replace("${path}/newsData.do?method=newsView&newsId=${bean.id}&group=true&replyPageNo="+nowPage);
            }
          }

          function pageDn(){
            var nowPage = ${nowPage}+1;
            var newTotalPages = ${pages};
            if(nowPage>newTotalPages) {
                return null;
            }
            if("${param.from}" == "colCube"){
                parent.window.location.replace("${path}/newsData.do?method=newsView&newsId=${bean.id}&group=true&replyPageNo="+nowPage+"&from=colCube");
            }else{
                getA8Top().location.replace("${path}/newsData.do?method=newsView&newsId=${bean.id}&group=true&replyPageNo="+nowPage);
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
                parent.window.location.replace("${detailURL}?method=newsView&newsId=${bean.id}&from=${param.from}&replyPageNo="+nowPage);
            }else{
                window.location.replace("${detailURL}?method=newsView&newsId=${bean.id}&from=${param.from}&replyPageNo="+nowPage);
            }
          }
          </script>
        </c:if>
        </div>
      </div>
      <!--11.25 end-->
    </div>
  </div>
  <div class="to_top" id="back_to_top">
    <span class="scroll_bg">
      <em class="icon24 to_top_24 margin_t_5"></em>
      <span class="back_top_msg hidden">${ctp:i18n('news.backToTop')}</span>
    </span>
  </div>
  <c:if test="${bean.type.commentPermit && bean.commentPermit && bean.state==30}">
  <div class="discuss_reply_info" id="discuss_info">
      <span class="scroll_bg ">
          <em class="icon24 discuss_info_24 margin_t_5"></em>
          <span class="back_top_msg hidden">${ctp:i18n('news.fastReply')}</span>
      </span>
  </div>
  </c:if>
</body>
<script type="text/javascript">
    //表单签章相关,hw.js中需要用到
    var hwVer = '<%=DBstep.iMsgServer2000.Version("iWebSignature")%>';
    var webRoot = _ctxServer;
    var htmOcxUserName = $.ctx.CurrentUser.name;
    var _ctxPath = '<%=ctxPath%>', _ctxServer = '<%=ctxServer%>';

</script>
<SCRIPT language=javascript for=SignatureControl
    event=EventOnSign(DocumentId,SignSn,KeySn,Extparam,EventId,Ext1)>
      //作用：重新获取签章位置
      if(EventId = 4 ){
        CalculatePosition();
        SignatureControl.EventResult = true;
      }
</SCRIPT>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/office/js/hw.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="common/isignaturehtml/js/isignaturehtml.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
    //页面大小改变的时候移动ISignatureHTML签章对象，让其到达正确的位置
    window.onresize = function (){
        moveISignatureOnResize();
    }
    loadSignatures('${bean.id}',false,false,false,null,false);
</script>
</html>