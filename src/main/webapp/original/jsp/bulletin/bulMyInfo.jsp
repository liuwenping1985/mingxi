<%@ page language="java" contentType="text/html; charset=UTF-8"%>
    <%@ include file="bulHeader.jsp"%>
        <html xmlns="http://www.w3.org/1999/xhtml">

        <head>
            <meta charset="utf-8">
            <title>
                <c:if test="${type==1}">${ctp:i18n('news.myIssueCount')}</c:if>
                <c:if test="${type==2}">${ctp:i18n('news.myCollectCount')}</c:if>
                <c:if test="${type==3}">${ctp:i18n('bulletin.myAuditCount')}</c:if>
            </title>
            <link rel="stylesheet" type="text/css" href="${path}/skin/default/bulletin.css${ctp:resSuffix()}" />
            <link rel="stylesheet" type="text/css" href="${path}/apps_res/bulletin/css/myPublish.css${ctp:resSuffix()}" />
            <style type="text/css">
                /* id_xxx 修改condition组件样式 */
                
                #searchCondition,
                #state_dropdown {
                    position: relative;
                }
                
                #search_dropdown_content_iframe,
                #state_dropdown_content_iframe {
                    width: 0;
                    height: 0;
                    left: 0;
                    top: 30px;
                }
                
                .common_drop_list .common_drop_list_content a {
                    text-align: left;
                }
            </style>
            <script type="text/javascript" src="${path}/apps_res/bulletin/js/common.js${ctp:resSuffix()}"></script>
            <script type="text/javascript" src="${path}/apps_res/bulletin/js/bulCommon.js${ctp:resSuffix()}"></script>
            <script type="text/javascript" src="${path}/apps_res/bulletin/js/bulMyInfo.js${ctp:resSuffix()}"></script>
            <script type="text/javascript">
                var myType = ${type};
                var hasIssue = ${hasIssue};
                var url_bulId = "${param.spaceId}";
                var _spaceType = '${param.spaceType}';
                var _spaceId = '${param.spaceId}';
            </script>
        </head>

        <body>
            <div class="container">
                <div class="container_top">
                    <div class="container_top_area">
                        <span class="index_logo hand" title="${ctp:i18n('news.backToIndex')}" <c:if test="${param.spaceType!=4 && param.spaceType!=1}">
        onclick="window.location.href='${path}/bulData.do?method=bulIndex&spaceId=${param.spaceId}&spaceType=${param.spaceType}'"
      </c:if>
      <c:if test="${param.spaceType==4 || param.spaceType==1}">
        onclick="window.location.href='${path}/bulData.do?method=bulIndex&spaceId=${param.spaceId}&typeId=${param.spaceId}&spaceType=${param.spaceType}'"
      </c:if>>
        <img src="${path}/skin/default/images/cultural/bulletin/notice_log1.png">
                    <span class="bulentinLOG_Text">${ctp:i18n('bulletin.bulletin')}</span>
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
                                            <li class="handle_list_li hand" onclick="editData()">
                                                <em class="icon24 cover_edit_24"></em>
                                                <span>${ctp:i18n('bulletin.modify')}</span>
                                            </li>
                                            <li class="handle_list_line">|</li>
                                            <li class="handle_list_li hand" onclick="deleteRecord()">
                                                <em class="icon24 cover_delete_24"></em>
                                                <span>${ctp:i18n('bulletin.delete')}</span>
                                            </li>
                                            <li class="handle_list_line ">|</li>
                                            <li class="handle_list_li hand" onclick="myPublish()">
                                                <em class="icon24 cover_publish_current_24"></em>
                                                <span>${ctp:i18n('bulletin.publish')}</span>
                                            </li>
                                            <div id="searchCondition"></div>
                                        </ul>
                                    </div>
                                </c:if>
                                <c:if test="${type==2 }">
                                    <div class="handle">
                                        <ul class="handle_list">
                                            <div id="searchCondition"></div>
                                        </ul>
                                    </div>
                                </c:if>
                                <c:if test="${type==3 }">
                                    <div class="handle">
                                        <ul class="handle_list">
                                            <li class="handle_list_li hand cancelAudit" onclick="cancelAudit();" style="width:77px;">
                                                <em class="icon24 cover_edit_24"></em>
                                                <span>${ctp:i18n('bulletin.cancelPublish')}</span>
                                            </li>
                                            <div id="searchCondition"></div>
                                        </ul>
                                    </div>
                                </c:if>
                                <div class="tableDate" id="tableDate">
                                    <div class="radius_15">
                                        <table id="myInfoTable" cellpadding="0" cellspacing="0" width="100%" height="100%" class="table"></table>
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
                                                <a class="button talk_button new_border-radius" onclick="createBul('${param.spaceType}','${param.spaceId}','');">
                                                    <span class="talk_button_add">+</span>
                                                    <span class="talk_button_msg">${ctp:i18n('bulletin.publistBulleitn')}</span>
                                                </a>
                                            </c:if>
                                        </div>
                                        <ul class="msg_info_body">
                                            <c:if test="${ctp:hasPlugin('doc') && ctp:getSystemProperty('doc.collectFlag') == 'true'}">
                                            <li class="msg_info_li hand ${type==2 ? 'current':''}" onclick="toMyInfo('2');">
                                                <strong class="msg_num">${myCollectCount}</strong>
                                                <span class="msg_name">${ctp:i18n('news.myCollectCount')}</span>
                                            </li>
                                            </c:if>
                                            <c:if test="${hasIssue}">
                                                <li class="msg_info_li hand ${type==1 ? 'current':''}" onclick="toMyInfo('1');">
                                                    <strong class="msg_num">${myIssueCount}</strong>
                                                    <span class="msg_name">${ctp:i18n('news.myIssueCount')}</span>
                                                </li>
                                            </c:if>
                                            <c:if test="${!hasIssue}">
                                                <li class="msg_info_li ${type==1 ? 'current':''}" style="cursor: default;">
                                                    <strong class="msg_num" style="color:#999;">${myIssueCount}</strong>
                                                    <span class="msg_name" style="color:#999;">${ctp:i18n('news.myIssueCount')}</span>
                                                </li>
                                            </c:if>
                                            <c:if test="${auditManager}">
                                                <li class="msg_info_li_last hand ${type==3 ? 'current':''}" onclick="toMyInfo('3');">
                                                    <strong class="msg_num">${myAuditCount}</strong>
                                                    <span class="msg_name">${ctp:i18n('bulletin.myAuditCount')}</span>
                                                </li>
                                            </c:if>
                                            <c:if test="${!auditManager}">
                                                <li class="msg_info_li_last ${type==3 ? 'current':''}" style="cursor: default;">
                                                    <strong class="msg_num" style="color:#999;">${myAuditCount}</strong>
                                                    <span class="msg_name" style="color:#999;">${ctp:i18n('bulletin.myAuditCount')}</span>
                                                </li>
                                            </c:if>
                                        </ul>
                                    </div>

                                    <ul class="discuss_ul overflow padding_b_25" id="new_Bul">
                                        <!-- 换一换 -->
                                        <li class="ling_hot"></li>
                                        <li class="discuss_title">
                                            <span class="discuss_title_name">${ctp:i18n('bulletin.newBulletin')}</span>
                                            <span id="change_NewBul" class="discuss_title_more hand" onclick="newBul()">${ctp:i18n('bulletin.change')}></span>
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