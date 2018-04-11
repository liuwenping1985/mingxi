<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="bulHeader.jsp"%>
    <html>

    <head>
        <meta charset="utf-8">
        <title>
            <c:if test="${bulTypeMessage==null}">${ctp:i18n('bulletin.index.label')}</c:if>
            <c:if test="${bulTypeMessage!=null}">${ctp:i18n('news.newsTypeIndex')}</c:if>
        </title>
        <link rel="stylesheet" type="text/css" href="${path}/skin/default/bulletin.css${v3x:resSuffix()}" />
        <link rel="stylesheet" href="${path}/apps_res/pubinfo/css/index_search.css${ctp:resSuffix()}">
        <script type="text/javascript" src="${path}/apps_res/bulletin/js/bulCommon.js${v3x:resSuffix()}"></script>
        <script type="text/javascript" src="${path}/apps_res/bulletin/js/bulIndex.js${v3x:resSuffix()}"></script>
        <script type="text/javascript" src="${path}/apps_res/bulletin/js/common.js${v3x:resSuffix()}"></script>
        <script type="text/javascript" src="${path}/apps_res/bulletin/js/index.js${v3x:resSuffix()}"></script>
        <script type="text/javascript" src="${path}/apps_res/pubinfo/js/index_search.js${ctp:resSuffix()}"></script>
        <script type="text/javascript">
            var VJoinMember = ${CurrentUser.externalType == 1}; //是否是VJoin人员
            var url_bulId = "${param.typeId}";
            var _spaceType = '${param.spaceType}';
            var _spaceId = '${param.spaceId}';
            var myBul = "${param.myBul}";
            if (VJoinMember) {
                myBul = "all";
            }
            //栏目指定版块
            var fragmentId = '${param.fragmentId}';
            var ordinal = '${param.ordinal}';
            var panelValue = '${param.panelValue}';

            function toIndex(){
                var url = '';
                if(_spaceType=='4'||_spaceType=='1'){
                url = '${path}/bulData.do?method=bulIndex&spaceId=${param.spaceId}&typeId=${param.spaceId}&spaceType=${param.spaceType}';
                }else if(_spaceType==''||_spaceType=='2'|| _spaceType=='3'){
                url = '${path}/bulData.do?method=bulIndex';
                }else{
                url = '${path}/bulData.do?method=bulIndex&spaceType=${param.spaceType}&spaceId=${param.spaceId}';
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
                    <img src="${path}/skin/default/images/cultural/bulletin/notice_log1.png" >
                    <span class="bulentinLOG_Text">${ctp:i18n('bulletin.bulletin')}</span>
                    </span>
                    <div id="searchCondition"></div>
                </div>
            </div>
            <div class="content_container index_discuss">
                <div class="container_auto container_footer">
                    <div class="container_discuss">
                        <div class="discuss_left index_minHeight" id="discuss_left" style="background-color:#f1f0ed">
                            <c:if test="${bulTypeMessage!=null }">
                                <input type="hidden" value="${bulTypeMessage.topNumber }" id="bulTopNumber"/>
                                <div class="group_admin_manage">
                                    <div class="manage_admin_list_infos">
                                        <div class="manage_infos_content">
                                            <div class="cover_left" style="width:664px;">
                                                <div class="manage_top">
                                                    <span class="manage_title" title="${ctp:toHTML(bulTypeMessage.bulName)}">
                                                ${v3x:getLimitLengthString(ctp:toHTML(bulTypeMessage.bulName),50,"...")}
                                                </span>
                                                    <%--<span class="manage_num">
                                                    <span>[&nbsp;<span id="bul_size" style="color:orange"></span>&nbsp;${ctp:i18n('bulletin.bulletin')}&nbsp;]</span>
                                                    </span>--%>
                                                </div>
                                                <div class="manage_bottom">
                                                    <span id="adminsName" class="manage_user" title="${ctp:toHTML(bulTypeMessage.adminsName)}">${ctp:i18n('bulletin.adminsName')}：<span id="adminsNames">${ctp:toHTML(bulTypeMessage.adminsName)}</span></span>
                                                    <c:if test="${bulTypeMessage.auditName!=''}">
                                                        <span id="auditName" class="manage_auditing">${ctp:i18n('bulletin.auditName')}：<span id="auditNames" title="${ctp:toHTML(bulTypeMessage.auditName)}">${ctp:toHTML(bulTypeMessage.auditName)}</span></span>
                                                    </c:if>
                                                </div>
                                            </div>
                                            <c:if test="${bulTypeMessage.canAdminOfCurrent }">
                                                <div class="manage_right">
                                                    <a id="adminBtn" onclick="adminBul('${bulTypeMessage.id}')" class="button exit_manage_button"><em class="icon24 manage_set_24" style="position:relative;top: -1px;"></em><span class="talk_button_msg" style="position:relative;top: -1px;">${ctp:i18n('bulletin.manage')}</span></a>
                                                    <!-- 公告管理 -->
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                            <div class="index_discuss_body">
                                <div class="top_index_boder">
                                    <div class="discuss_left_header" style="position: relative;">
                                        <!-- 最新公告 -->
                                        <span id="listView" onclick="findListDatas('${bulTypeMessage.id}',1)"></span>
                                        <input type="checkbox" class="check_all" style="display: none; position: absolute; left: 0px;">
                                        <span class="left_header_li">${ctp:i18n('bulletin.newBulletin')}</span>
                                        <span style="font-size: 14px;color: #999999;float:right;padding: 5px 20px 0 0;">${ctp:i18n('bulletin.totalcount')}<span id="totalCount">0</span>${ctp:i18n('bulletin.totalrow')}</span>
                                    </div>
                                    <div class="index_border">
                                    </div>
                                </div>
                                <div class="left_list" id="listData" style="position: relative;">
                                    <!-- <div class="discuss_left_list"> -->
                                    <!-- </div> -->
                                </div>
                            </div>
                        </div>
                        <div class="discuss_right" id="bul_discuss_right">
                            <div class="company_discuss">
                                <div class="user_msg_info">
                                    <div class="msg_info_header">
                                        <!-- 人员头像名字 -->
                                        <span class="user_photo" style="overflow: hidden;">
                                        <img src="${v3x:avatarImageUrl(v3x:currentUser().id)}">
                                    </span>
                                        <span class="user_name" title="${ctp:toHTML(v3x:currentUser().name)}"   style="width: 75px;">
                                            <span style="word-break: break-word;line-height: 1;display: inline-block;vertical-align: middle;">
                                                ${ctp:toHTML(v3x:getLimitLengthString(v3x:currentUser().name,12,"..."))}
                                            </span>
                                        </span>                                        
                                        <c:if test="${hasIssue}">
                                            <a class="button talk_button new_border-radius" <c:if test="${bulTypeMessage!=null &&(bulTypeMessage.canAdminOfCurrent ||bulTypeMessage.canNewOfCurrent) }">onclick="createBul('${bulTypeMessage.spaceType}','${bulTypeMessage.spaceId}','${bulTypeMessage.id}')"></c:if><c:if test="${bulTypeMessage==null ||(bulTypeMessage!=null&& !bulTypeMessage.canNewOfCurrent) }">onclick="createBul('${param.spaceType}','${param.spaceId}','')"></c:if><span class="talk_button_add">+</span><span class="talk_button_msg" style="position: relative;top: -1px;">${ctp:i18n('bulletin.publistBulleitn')}</span></a>
                                        </c:if>
                                    </div>
                                    <ul class="msg_info_body">
                                        <c:if test="${ctp:hasPlugin('doc') && ctp:getSystemProperty('doc.collectFlag') == 'true'}">
                                        <li class="msg_info_li hand" onclick="toBulMyInfo(2)">
                                            <strong class="msg_num">${myCollectCount}</strong>
                                            <span class="msg_name">${ctp:i18n('news.myCollectCount')}</span>
                                        </li>
                                        </c:if>
                                        <c:if test="${hasIssue}">
                                            <li class="msg_info_li hand" onclick="toBulMyInfo(1)">
                                                <strong class="msg_num">${myIssueCount}</strong>
                                                <span class="msg_name">${ctp:i18n('news.myIssueCount')}</span>
                                            </li>
                                        </c:if>
                                        <c:if test="${!hasIssue}">
                                            <li class="msg_info_li" style="cursor: default;">
                                                <span class="msg_num" style="color:#999;">${myIssueCount}</span>
                                                <span class="msg_name" style="color:#999;">${ctp:i18n('news.myIssueCount')}</span>
                                            </li>
                                        </c:if>
                                        <c:if test="${auditManager}">
                                            <li class="msg_info_li_last hand" onclick="toBulMyInfo(3)">
                                                <strong class="msg_num">${myAuditCount}</strong>
                                                <span class="msg_name">${ctp:i18n('bulletin.myAuditCount')}</span>
                                            </li>
                                        </c:if>
                                        <c:if test="${!auditManager}">
                                            <li class="msg_info_li_last hand" style="cursor: default;">
                                                <span class="msg_num" style="color:#999;">${myAuditCount}</span>
                                                <span class="msg_name" style="color:#999;">${ctp:i18n('bulletin.myAuditCount')}</span>
                                            </li>
                                        </c:if>
                                    </ul>
                                </div>
                                <c:forEach items="${bulTypeModelMap}" var="bulTypeModelMap" varStatus="status">
                                    <ul class="discuss_ul">
                                        <!-- 版块 -->
                                        <li class="ling_${status.index}"></li>
                                        <li class="discuss_title" onclick="toSpaceType('${bulTypeModelMap.key}')">
                                            <span class="discuss_title_name" test="${(-status.index + 3) == param.spaceType}">${ctp:i18n(bulTypeModelMap.key)}</span>
                                            <c:if test="${empty param.typeId && (param.spaceType=='2'||param.spaceType=='3') && (-status.index + 3) == param.spaceType}">
                                                <img class="current_corner left" src="${path}/skin/default/images/cultural/bulletin/cover_current.png" style="height: 36px;">
                                            </c:if>
                                        </li>
                                        <li class="discuss_body">
                                            <ul class="discuss_body_page" id="bulType_${status.index}">
                                                <c:if test="${fn:length(bulTypeModelMap.value)<=0}">
                                                    <c:if test="${bulTypeModelMap.key == 'bulletin.type.department'}">
                                                        <div class="discuss_no_list_msg">${ctp:i18n('bbs.board.list.null.dept')}</div>
                                                    </c:if>
                                                    <c:if test="${bulTypeModelMap.key != 'bulletin.type.department'}">
                                                        <div class="discuss_no_list_msg">${ctp:i18n('bbs.board.list.null')}</div>
                                                    </c:if>
                                                </c:if>
                                                <c:if test="${fn:length(bulTypeModelMap.value)>0}">
                                                    <c:forEach items="${bulTypeModelMap.value}" var="bulType">
                                                        <li class="discuss_cover_name hand" id="bul_${bulType.id}">
                                                            <span title="${bulType.bulName}">${ctp:toHTML(v3x:getLimitLengthString(bulType.bulName,27,"..."))}</span>
                                                            <span class="discuss_cover">
                                                          <c:if test="${bulType.canAdminOfCurrent}">
                                                            <em class="icon24 admin_cover_left_24" title="${ctp:i18n('bulletin.set')}" onclick="showDropList(this);"></em>
                                                            <em class="icon24 admin_cover_right_24" title="${ctp:i18n('bulletin.publistBulleitn')}" onclick="createBul('${bulType.spaceType}','${bulType.spaceId}','${bulType.id}');"></em>
                                                            <div class="drop_component">
                                                              <div class="corner">
                                                                  <img src="${path}/skin/default/images/cultural/bulletin/drop_corner.png" class="drop_conner" />
                                                              </div>
                                                              <ul class="drop_list">
                                                                <c:if test="${bulType.flag && bulType.spaceType != '4'}">
                                                                    <li class="drop_list_li" onclick="typeSetting('${bulType.id}')">${ctp:i18n('bulletin.set')}</li><!-- 设置 -->
                                                                    <li class="drop_list_line"></li>
                                                                </c:if>
                                                                  <li class="drop_list_li" onclick="statistics('${bulType.id}')">${ctp:i18n('bulletin.statistics')}</li><!-- 统计 -->
                                                              </ul>
                                                            </div>
                                                          </c:if>
                                                          <c:if test="${!bulType.canAdminOfCurrent && bulType.canNewOfCurrent}">
                                                            <em class="icon24 add_talk_24" title="${ctp:i18n('bulletin.publistBulleitn')}" onclick="createBul('${bulType.spaceType}','${bulType.spaceId}','${bulType.id}');"></em>
                                                          </c:if>
                                                        </span>
                                                            <c:if test="${bulTypeMessage!=null&&bulTypeMessage.id==bulType.id }">
                                                                <img class="current_corner left" src="${path}/skin/default/images/cultural/bulletin/cover_current.png">
                                                            </c:if>
                                                        </li>
                                                    </c:forEach>
                                                </c:if>
                                            </ul>
                                        </li>
                                    </ul>
                                </c:forEach>
                                <%--<c:if test="${bulTypeMessage!=null }">
                                    <!-- 换一换 -->
                                    <ul class="discuss_ul overflow padding_b_25" id="new_Bul">
                                        <li class="ling_hot"></li>
                                        <li class="discuss_title">
                                            <span class="discuss_title_name">${ctp:i18n('bulletin.newBulletin')}</span>
                                            <span id="change_NewBul" class="discuss_title_more hand" onclick="newBul()">${ctp:i18n('bulletin.change')}</span>
                                        </li>
                                    </ul>
                                </c:if> --%>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="admin_edit hidden" id="adminEdit" bulType_Id="${bulTypeMessage.id}">
                    <ul class="admin_edit_ul">
                        <li class="admin_edit_li hand" onclick="setTop('1','${bulTypeMessage.id}')">
                            <img src="${path}/skin/default/images/cultural/bulletin/top.png" class="edit_li_img">
                            <span class="edit_li_name">${ctp:i18n('bulletin.top')}</span>
                        </li>
                        <li class="li_line"></li>
                        <li class="admin_edit_li hand" onclick="setTop('2','${bulTypeMessage.id}')">
                            <img src="${path}/skin/default/images/cultural/bulletin/cancle.png" class="edit_li_img">
                            <span class="edit_li_name">${ctp:i18n('bulletin.cancleTop')}</span>
                        </li>
                        <li class="li_line"></li>
                        <li class="admin_edit_li hand" onclick="cancelPublish('${bulTypeMessage.id}')">
                            <img src="${path}/skin/default/images/cultural/bulletin/canclePublish.png" class="edit_li_img">
                            <span class="edit_li_name">${ctp:i18n('bulletin.canclePublish')}</span>
                        </li>
                        <li class="li_line"></li>
                        <li class="admin_edit_li hand" onclick="deleteBul('${bulTypeMessage.id}')">
                            <img src="${path}/skin/default/images/cultural/bulletin/delete.png" class="edit_li_img">
                            <span class="edit_li_name">${ctp:i18n('bulletin.delete')}</span>
                        </li>
                        <c:if test="${ctp:hasPlugin('doc')}">
                        <li class="li_line"></li>
                        <li class="admin_edit_li hand" onclick="setPigeonhole('<%=com.seeyon.ctp.common.constants.ApplicationCategoryEnum.bulletin.key() %>')">
                            <img src="${path}/skin/default/images/cultural/bulletin/file.png" class="edit_li_img">
                            <span class="edit_li_name">${ctp:i18n('bulletin.pigeonhole')}</span>
                        </li>
                        </c:if>
                        <c:if test="${canMove}">
                            <li class="li_line"></li>
                            <li class="admin_edit_li hand" onclick="setMove()">
                                <img src="${path}/skin/default/images/cultural/bulletin/move.png" class="edit_li_img">
                                <span class="edit_li_name">${ctp:i18n('bulletin.move')}</span>
                            </li>
                        </c:if>
                    </ul>
                </div>
            </div>
        </div>
        <div class="to_top" id="back_to_top">
            <span class="scroll_bg">
            <em class="icon24 to_top_24 margin_t_5"></em>
            <span class="back_top_msg hidden">${ctp:i18n('bulletin.backToTop')}</span>
            </span>
        </div>
    </body>

    </html>