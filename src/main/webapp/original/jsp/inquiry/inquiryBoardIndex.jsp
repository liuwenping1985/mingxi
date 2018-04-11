<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="inquiryHeader.jsp"%>
<html>
<head>
    <meta charset="UTF-8">
    <title>${ctp:i18n('inquiry.boardindex')}</title><%--i18 版块首页 --%>
    <link rel="stylesheet" type="text/css" href="${path}/skin/default/inquiry.css${v3x:resSuffix()}" />
    <link rel="stylesheet" href="${path}/apps_res/pubinfo/css/index_search.css${ctp:resSuffix()}">
    <script src="${path}/apps_res/inquiry/js/common.js${v3x:resSuffix()}"></script>
    <script src="${path}/apps_res/inquiry/js/index.js${v3x:resSuffix()}"></script>
    <script src="${path}/apps_res/inquiry/js/inquiryBoardManage.js${v3x:resSuffix()}"></script>
    <script type="text/javascript" src="${path}/apps_res/pubinfo/js/index_search.js${ctp:resSuffix()}"></script>
    <script type="text/javascript">
        var _path = '${path}';
        var ajax_inquiryManager = new inquiryManager();
        var targetBoardPageNo = '${boardPageNo}';
        var targetBoardType = '${boardType}';
        showRecent_per = false;
        $(function(){
            if($("#manageMode").val()=="1"){
                enterManageModel();
            }
        });
        var _spaceId = '${param.spaceId}';
        var _spaceType = '${param.spaceType}';
        var _hasPublishAuth = '${board.hasPublicAuth}';
        var _hasManageAuth = '${board.hasManageAuth}';
        //栏目指定版块
        var fragmentId = '${param.fragmentId}';
        var ordinal = '${param.ordinal}';
        var panelValue = '${param.panelValue}';
    </script>
</head>
<body>
<input type="hidden" name="leftPageNo" id = "leftPageNo" value="1">
<input type="hidden" name="basicSize" id = "basicSize" value="${basicSize}">
<input type="hidden" name="canEditSize" id = "canEditSize" value="${canEditSize}">
<input type="hidden" name="boardId" id = "boardId" value="${board.inquirySurveytype.id}">
<input type="hidden" name="manageMode" id = "manageMode" value="${manageMode}">
<input type="hidden" name="areaBoardId" id = "areaBoardId" value="">
<div class="container">
    <div class="container_top">
        <div class="container_top_area">
            <span class="index_logo hand" title="${ctp:i18n('inquiry.backtoindex')}" onclick="toInquiryIndex();"><%--i18 返回首页 --%>
                <img src="${path}/skin/default/images/cultural/inquiry/inquiry_logo.png">
                <span class="index_logo_name hand">${ctp:i18n('inquiry.inquiry')}</span><%--i18 调查 --%>
            </span>
            <div id="searchCondition"></div>
        </div>
        <%--<span class="index_search">--%>
            <%--<em class="icon16 index_search_16"></em>--%>
            <%--<input class="index_search_input" type="text" placeholder="${ctp:i18n('inquiry.searchyourfav')}">&lt;%&ndash;i18 搜索你喜欢的 &ndash;%&gt;--%>
        <%--</span>--%>
    </div>
    <div class="content_container">
        <div class="container_auto">
            <div class="admin_container_discuss">
                <div class="discuss_left">
                    <div class="group_admin_manage" id="boardManage_${boardId}">
                        <div class="manage_list_infos">
                            <div class="manage_infos_content">
                                <div class="cover_left">
                                    <div class="manage_top">
                                                <span class="manage_title" title="${board.inquirySurveytype.typeName}">
                                                    ${board.inquirySurveytype.typeName}
                                                </span>
                                                <%--<span class="manage_num">
                                                    <span>[<font color="#ff6804">${boardGoing}</font> ${ctp:i18n('inquiry.state1')}/${boardTotal} ${ctp:i18n('inquiry.inquiry')}]</span>
                                                </span>--%>
                                    </div>
                                    <div class="manage_bottom">
                                        <span class="manage_user" title="${v3x:showOrgEntitiesOfIds(boardManager, 'Member', pageContext)}">
                                            ${ctp:i18n('inquiry.manager')}：<%--i18 管理员 --%>
                                            <c:if test="${boardManager == ''}">
                                                ${ctp:i18n('inquiry.nobody')}<%--i18 无 --%>
                                            </c:if>
                                            <c:if test="${boardManager != ''}">
                                                ${v3x:getLimitLengthString(v3x:showOrgEntitiesOfIds(boardManager, 'Member', pageContext),72,"...")}
                                            </c:if>
                                        </span>
                                        <c:if test="${board.checker != '' && board.checker != null}">
                                        <span class="manage_auditing" title="${v3x:showMemberName(board.checker.id)}">
                                            ${ctp:i18n('inquiry.auditor')}：${v3x:getLimitLengthString(v3x:showMemberName(board.checker.id),10,"...")}<%--i18 审核员 --%>

                                        </span>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="manage_right">
                                    <c:if test="${board.hasManageAuth}">
                                        <a class="buttonNew enter_manage_button" onclick="enterManageModel();"><em class="icon24 manage_set_24"></em><span class="talk_button_manager_msg">${ctp:i18n('inquiry.manage.enterManageMode')}</span></a><%--i18n 进入管理--%>
                                        <a class="buttonNew exit_manage_button" onclick="exitManageModel();"style="display: none"><em class="icon24 manage_set_24"></em><span class="talk_button_manager_msg">${ctp:i18n('inquiry.manage.exitManageMode')}</span></a><%--i18n 退出管理--%>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="admin_manage_left">
                        <div class="discuss_left_header">
                            <div class="left_header_info">
                                <input class="check_all" type="checkbox" onclick="checkAll();" style="display: none">
                                <span class="discuss_header_title left">${ctp:i18n('inquiry.myinquiry')}</span><%--i18 我的调查 --%>
                                <span class="right">
                                    <span class="discuss_num">${ctp:i18n_1('inquiry.total',0)}</span><%--i18 (共${basicSize}份) ,basicSize--%>
                                    <label for="onlyShowEdit" class="hidden">
                                        <input type="checkbox" id="onlyShowEdit" class="checkbox hand">
                                        <span class="show_unWrite hand">${ctp:i18n('inquiry.onlycanedit')}</span><%--i18 只看未填写的 --%>
                                    </label>
                                </span>
                            </div>
                        </div>
                        <input id="tableSearchType" type="hidden" value="">
                        <input id="tableSearchCondition" type="hidden" value="">
                        <input id="tableSearchValue1" type="hidden" value="">
                        <input id="tableSearchValue2" type="hidden" value="">
                        <div class="left_list">
                            <!-- <div class="discuss_left_list"> -->
                            <!-- </div> -->
                            <div class="admin_list_more"></div>
                            <div id="noInquiryTips" style="background: #FFF;text-align: center;height: 300px;display: none">
                                <img src="/seeyon/apps_res/pubinfo/image/null.png" width="103" height="129" style="display: inline-block;margin-top: 80px;">
                                <div style="font-size: 14px;color: #999;margin-top: 5px;">${ctp:i18n('inquiry.noinquiry')}</div>
                            </div>
                        </div>
                    </div>

                </div>
                <div class="discuss_right">
                    <div class="company_discuss">
                        <div class="user_msg_info">
                            <div class="msg_info_header">
                                <span class="user_photo">
                                    <img class="radius" src="${v3x:avatarImageUrl(v3x:currentUser().id)}">
                                </span>
                                <span class="user_name" title="${ctp:toHTML(v3x:currentUser().name)}">${ctp:toHTML(v3x:getLimitLengthString(v3x:currentUser().name,8,"..."))}</span>
                                <c:if test="${hasIssue}">
                                    <a class="buttonNew examine_button" onclick="inquiryCreate('${param.spaceType}','${param.spaceId}','index');"><span class="talk_button_add">+</span><span class="talk_button_msg">${ctp:i18n('inquiry.createinquiry')}</span></a><%--i18 发起调查 --%>
                                </c:if>
                                <%--<c:if test="${!hasIssue}">--%>
                                    <%--<a class="buttonNew gray_button examine_button"><span class="talk_button_add">+</span><span class="talk_button_msg">${ctp:i18n('inquiry.createinquiry')}</span></a>&lt;%&ndash;i18 发起调查 &ndash;%&gt;--%>
                                    <%--<div class="pop_msgNew">--%>
                                        <%--<img src="${path}/skin/default/images/cultural/inquiry/pop_corner.png" class="msg_pop_corner" >--%>
                                        <%--<div class="msg_box">--%>
                                        <%--<span class="msg_box_icon" style="line-height: 0px">--%>
                                            <%--<em class="icon16 tips_16"></em>--%>
                                        <%--</span>--%>
                                            <%--<span class="msg_box_info">${ctp:i18n('inquiry.cannotcreatetip')}</span>&lt;%&ndash;i18 您没有发起调查的权限， 请联系对应的板块管理 员为您开通权限。&ndash;%&gt;--%>
                                        <%--</div>--%>
                                    <%--</div>--%>
                                <%--</c:if>--%>
                            </div>
                            <ul class="msg_info_body">
                                <%--<li class="msg_info_li hand">不显示--%>
                                <%--<strong class="msg_num h">${iJoined}</strong>--%>
                                <%--<span class="msg_name">${ctp:i18n('inquiry.ijoined')}</span>&lt;%&ndash;i18 我参与的 &ndash;%&gt;--%>
                                <%--</li>--%>
                                <li class="msg_info_li <c:if test="${hasIssue}">hand</c:if>" <c:if test="${hasIssue}">onclick="toIStarted();"</c:if>>
                                    <strong class="msg_num" <c:if test="${!hasIssue}">style="color: #999999;font-weight: normal" </c:if>>${iPublished}</strong>
                                    <span class="msg_start">${ctp:i18n('inquiry.icreated')}</span><%--i18 我发起的 --%>
                                </li>
                                <li class="msg_info_li_last <c:if test="${hasAuthIssue}">hand</c:if>" <c:if test="${hasAuthIssue}">onclick="toIAuth();"</c:if>>
                                    <strong class="msg_num" <c:if test="${!hasAuthIssue}">style="color: #999999;font-weight: normal" </c:if>>${iAuth}</strong>
                                    <span class="msg_auth">${ctp:i18n('inquiry.iauth')}</span><%--i18 调查审核 --%>
                                </li>
                            </ul>
                        </div>
                        <c:if test="${v3x:getSysFlagByName('sys_isGroupVer') && groupInquiryTypeList!=null}">
                        <ul class="discuss_ul" id="groupTypeList">
                            <li class="ling_4_group"></li>
                            <li class="discuss_title hand">
                                <c:if test="${param.spaceType eq '18' }">
                                <span class="discuss_title_name" onclick="changeType(18);">${ctp:i18n('inquiry.type.public.custom.group')}</span><%--i18 自定义集团调查 --%>
                                </c:if>
                                <c:if test="${param.spaceType ne '18'}">
                                <span class="discuss_title_name" onclick="changeType(3);">${ctp:i18n('inquiry.type.group')}</span><%--i18 集团调查 --%>
                                </c:if>
                            </li>
                            <li class="discuss_body">
                                <ul class="discuss_body_page">
                                    <c:if test="${fn:length(groupInquiryTypeList)==0 }">
                                        <div class="discuss_no_list_msg">${ctp:i18n('bbs.board.list.null')}</div>
                                    </c:if>
                                    <c:forEach items="${groupInquiryTypeList}" var="groupType" varStatus="status">
                                        <%--集团第一页 --%>
                                    <c:if test="${status.index<5}">
                                    <li class="discuss_cover_name hand" id='side_${groupType.inquirySurveytype.id}'>
                                        <c:choose>
                                            <c:when test="${groupType.hasManageAuth&&groupType.hasPublicAuth}">
                                                <div class="hand left" style="width: 190px" onclick="toBoardIndex('${groupType.inquirySurveytype.id}','group');" title="${ctp:toHTML(groupType.inquirySurveytype.typeName)}">${ctp:toHTML(v3x:getLimitLengthString(groupType.inquirySurveytype.typeName,29,"..."))}</div>
                                                <div class="discuss_cover right">
                                                    <em class="icon24 admin_cover_left_24" title="${ctp:i18n('blog.set.label')}" onclick="showDropList(this);"></em>
                                                    <em class="icon24 admin_cover_right_24" title="${ctp:i18n('new.inquiry.button')}" onclick="inquiryCreate('${groupType.spaceType}','${groupType.spaceId}','${groupType.inquirySurveytype.id}');"></em>
                                                    <div class="drop_component">
                                                        <div class="corner">
                                                            <img src="${path}/skin/default/images/cultural/inquiry/drop_corner.png" class="drop_conner">
                                                        </div>
                                                        <ul class="drop_list">
                                                            <li class="drop_list_li" onclick="setAuth('${groupType.inquirySurveytype.id}','group')">${ctp:i18n('inquiry.type.Set')}</li>
                                                            <li class="drop_list_line"></li>
                                                            <li class="drop_list_li" onclick="statistics('${groupType.inquirySurveytype.id}')">${ctp:i18n('inquiry.getcount')}</li>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </c:when>
                                            <c:when test="${(!groupType.hasManageAuth)&&groupType.hasPublicAuth}">
                                                <div class="hand left" style="width: 205px" onclick="toBoardIndex('${groupType.inquirySurveytype.id}','group');" title="${ctp:toHTML(groupType.inquirySurveytype.typeName)}">${ctp:toHTML(v3x:getLimitLengthString(groupType.inquirySurveytype.typeName,29,"..."))}</div>
                                                <div class="discuss_talk right" style="right:16px">
                                                    <em class="icon24 add_talk_24" onclick="inquiryCreate('${groupType.spaceType}','${groupType.spaceId}','${groupType.inquirySurveytype.id}')"></em>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="hand left" onclick="toBoardIndex('${groupType.inquirySurveytype.id}','group');" title="${ctp:toHTML(groupType.inquirySurveytype.typeName)}">${ctp:toHTML(v3x:getLimitLengthString(groupType.inquirySurveytype.typeName,29,"..."))}</div>
                                            </c:otherwise>
                                        </c:choose>
                                        <c:if test="${board.inquirySurveytype.id == groupType.inquirySurveytype.id}">
                                            <img class="current_corner" src="${path}/skin/default/images/cultural/inquiry/cover_current.png">
                                        </c:if>
                                    </li>
                                    </c:if>
                                        <%--集团后续 --%>
                                    <c:if test="${status.index>=5}">
                                    <li class="discuss_cover_name hand" style="display:none" id='side_${groupType.inquirySurveytype.id}'">
                                    <c:choose>
                                    <c:when test="${groupType.hasManageAuth&&groupType.hasPublicAuth}">
                                    <div class="hand left" style="width: 190px" onclick="toBoardIndex('${groupType.inquirySurveytype.id}','group');" title="${ctp:toHTML(groupType.inquirySurveytype.typeName)}">${ctp:toHTML(v3x:getLimitLengthString(groupType.inquirySurveytype.typeName,29,"..."))}</div>
                                    <div class="discuss_cover right">
                                        <em class="icon24 admin_cover_left_24" title="${ctp:i18n('blog.set.label')}" onclick="showDropList(this);"></em>
                                        <em class="icon24 admin_cover_right_24" title="${ctp:i18n('new.inquiry.button')}" onclick="inquiryCreate('${groupType.spaceType}','${groupType.spaceId}','${groupType.inquirySurveytype.id}');"></em>
                                        <div class="drop_component">
                                            <div class="corner">
                                                <img src="${path}/skin/default/images/cultural/inquiry/drop_corner.png" class="drop_conner">
                                            </div>
                                            <ul class="drop_list">
                                                <li class="drop_list_li" onclick="setAuth('${groupType.inquirySurveytype.id}','group')">${ctp:i18n('inquiry.type.Set')}</li>
                                                <li class="drop_list_line"></li>
                                                <li class="drop_list_li" onclick="statistics('${groupType.inquirySurveytype.id}')">${ctp:i18n('inquiry.getcount')}</li>
                                            </ul>
                                        </div>
                                    </div>
                                    </c:when>
                                    <c:when test="${(!groupType.hasManageAuth)&&groupType.hasPublicAuth}">
                                    <div class="hand left" style="width: 205px" onclick="toBoardIndex('${groupType.inquirySurveytype.id}','group');" title="${ctp:toHTML(groupType.inquirySurveytype.typeName)}">${ctp:toHTML(v3x:getLimitLengthString(groupType.inquirySurveytype.typeName,29,"..."))}</div>
                                    <div class="discuss_talk right" style="right:16px">
                                        <em class="icon24 add_talk_24" onclick="inquiryCreate('${groupType.spaceType}','${groupType.spaceId}','${groupType.inquirySurveytype.id}')"></em>
                                    </div>
                                    </c:when>
                                    <c:otherwise>
                                    <div class="hand left" onclick="toBoardIndex('${groupType.inquirySurveytype.id}','group');" title="${ctp:toHTML(groupType.inquirySurveytype.typeName)}">${ctp:toHTML(v3x:getLimitLengthString(groupType.inquirySurveytype.typeName,29,"..."))}</div>
                                    </c:otherwise>
                                    </c:choose>
                                    <c:if test="${board.inquirySurveytype.id == groupType.inquirySurveytype.id}">
                                        <img class="current_corner" src="${path}/skin/default/images/cultural/inquiry/cover_current.png">
                                    </c:if>
                            </li>
                            </c:if>
                            </c:forEach>
                        </ul>
                        </li>
                        <c:if test="${fn:length(groupInquiryTypeList)>5 }">
                            <li class="discuss_cover_page" id="groupPage">
                                <input type="hidden" name="groupNowPage" id="groupNowPage" value="1">
                                <input type="hidden" name="groupPageNum" id="groupPageNum" value="${fn:length(groupInquiryTypeList)}">
                                    <span class="discuss_page">
                                        <em class="icon16 discuss_left_16 hand" onclick="jumpBack('group');"></em>
                                        <span class="page_circles">
                                            <c:forEach begin="1" end="${groupInquiryTypeListPageNum}" var="count" varStatus="countStatus">
                                                <c:if test="${countStatus.first}">
                                                    <a href="javascript:;" class="page_num current">1</a>
                                                </c:if>
                                                <c:if test="${count<=10 && !countStatus.first}">
                                                    <a href="javascript:;" class="page_num" onclick="jumpPageNew('group',${count})">${count}</a>
                                                </c:if>
                                                <c:if test="${count>10 && !countStatus.first}">
                                                    <a href="javascript:;" class="page_num" style="display: none" onclick="jumpPageNew('group',${count})">${count}</a>
                                                </c:if>
                                            </c:forEach>
                                        </span>
                                        <em class="icon16 discuss_right_16 hand" onclick="jumpNext('group');"></em>
                                    </span>
                            </li>
                        </c:if>
                        </ul>
                        </c:if>
                        <c:if test="${accountInquiryTypeList!=null}">
                        <ul class="discuss_ul" id="accountTypeList">
                            <li class="ling_4_account"></li>
                            <li class="discuss_title hand">
                                <c:if test="${param.spaceType eq '17' }">
                                <span class="discuss_title_name" onclick="changeType(17);">${ctp:i18n('inquiry.type.public.custom')}</span><%--i18 自定义单位调查 --%>
                                </c:if>
                                <c:if test="${param.spaceType ne '17' }">
                                <span class="discuss_title_name" onclick="changeType(2);">${ctp:i18n('inquiry.type.corporation')}</span><%--i18n 单位调查--%>
                                </c:if>
                            </li>
                            <li class="discuss_body">
                                <ul class="discuss_body_page">
                                    <c:if test="${fn:length(accountInquiryTypeList)==0 }">
                                        <div class="discuss_no_list_msg">${ctp:i18n('bbs.board.list.null')}</div>
                                    </c:if>
                                    <c:forEach items="${accountInquiryTypeList}" var="groupType" varStatus="accountStatus">
                                        <%--单位第一页--%>
                                        <c:if test="${accountStatus.index<5}">
                                            <li class="discuss_cover_name hand" id='side_${groupType.inquirySurveytype.id}'>
                                                <c:choose>
                                                    <c:when test="${groupType.hasManageAuth&&groupType.hasPublicAuth}">
                                                        <div class="hand left" style="width: 190px" onclick="toBoardIndex('${groupType.inquirySurveytype.id}','account');" title="${ctp:toHTML(groupType.inquirySurveytype.typeName)}">${ctp:toHTML(v3x:getLimitLengthString(groupType.inquirySurveytype.typeName,29,"..."))}</div>
                                                        <div class="discuss_cover right">
                                                            <em class="icon24 admin_cover_left_24" title="${ctp:i18n('blog.set.label')}" onclick="showDropList(this);"></em>
                                                            <em class="icon24 admin_cover_right_24" title="${ctp:i18n('new.inquiry.button')}" onclick="inquiryCreate('${groupType.spaceType}','${groupType.spaceId}','${groupType.inquirySurveytype.id}');"></em>
                                                            <div class="drop_component">
                                                                <div class="corner">
                                                                    <img src="${path}/skin/default/images/cultural/inquiry/drop_corner.png" class="drop_conner">
                                                                </div>
                                                                <ul class="drop_list">
                                                                    <li class="drop_list_li" onclick="setAuth('${groupType.inquirySurveytype.id}','account')">${ctp:i18n('inquiry.type.Set')}</li>
                                                                    <li class="drop_list_line"></li>
                                                                    <li class="drop_list_li" onclick="statistics('${groupType.inquirySurveytype.id}')">${ctp:i18n('inquiry.getcount')}</li>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                    <c:when test="${(!groupType.hasManageAuth)&&groupType.hasPublicAuth}">
                                                        <div class="hand left" style="width: 205px" onclick="toBoardIndex('${groupType.inquirySurveytype.id}','account');" title="${ctp:toHTML(groupType.inquirySurveytype.typeName)}">${ctp:toHTML(v3x:getLimitLengthString(groupType.inquirySurveytype.typeName,29,"..."))}</div>
                                                        <div class="discuss_talk right" style="right:16px">
                                                            <em class="icon24 add_talk_24" onclick="inquiryCreate('${groupType.spaceType}','${groupType.spaceId}','${groupType.inquirySurveytype.id}')"></em>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="hand left" onclick="toBoardIndex('${groupType.inquirySurveytype.id}','account');" title="${ctp:toHTML(groupType.inquirySurveytype.typeName)}">${ctp:toHTML(v3x:getLimitLengthString(groupType.inquirySurveytype.typeName,29,"..."))}</div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:if test="${board.inquirySurveytype.id == groupType.inquirySurveytype.id}">
                                                    <img class="current_corner" src="${path}/skin/default/images/cultural/inquiry/cover_current.png">
                                                </c:if>
                                            </li>
                                        </c:if>
                                        <%--单位后续--%>
                                        <c:if test="${accountStatus.index>=5}">
                                            <li class="discuss_cover_name hand" style="display:none" id='side_${groupType.inquirySurveytype.id}'>
                                                <c:choose>
                                                    <c:when test="${groupType.hasManageAuth&&groupType.hasPublicAuth}">
                                                        <div class="hand left" style="width: 190px" onclick="toBoardIndex('${groupType.inquirySurveytype.id}','account');" title="${ctp:toHTML(groupType.inquirySurveytype.typeName)}">${ctp:toHTML(v3x:getLimitLengthString(groupType.inquirySurveytype.typeName,29,"..."))}</div>
                                                        <div class="discuss_cover right">
                                                            <em class="icon24 admin_cover_left_24" title="${ctp:i18n('blog.set.label')}" onclick="showDropList(this);"></em>
                                                            <em class="icon24 admin_cover_right_24" title="${ctp:i18n('new.inquiry.button')}" onclick="inquiryCreate('${groupType.spaceType}','${groupType.spaceId}','${groupType.inquirySurveytype.id}');"></em>
                                                            <div class="drop_component">
                                                                <div class="corner">
                                                                    <img src="${path}/skin/default/images/cultural/inquiry/drop_corner.png" class="drop_conner">
                                                                </div>
                                                                <ul class="drop_list">
                                                                    <li class="drop_list_li" onclick="setAuth('${groupType.inquirySurveytype.id}','account')">${ctp:i18n('inquiry.type.Set')}</li>
                                                                    <li class="drop_list_line"></li>
                                                                    <li class="drop_list_li" onclick="statistics('${groupType.inquirySurveytype.id}')">${ctp:i18n('inquiry.getcount')}</li>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                    <c:when test="${(!groupType.hasManageAuth)&&groupType.hasPublicAuth}">
                                                        <div class="hand left" style="width: 205px" onclick="toBoardIndex('${groupType.inquirySurveytype.id}','account');" title="${ctp:toHTML(groupType.inquirySurveytype.typeName)}">${ctp:toHTML(v3x:getLimitLengthString(groupType.inquirySurveytype.typeName,29,"..."))}</div>
                                                        <div class="discuss_talk right" style="right:16px">
                                                            <em class="icon24 add_talk_24" onclick="inquiryCreate('${groupType.spaceType}','${groupType.spaceId}','${groupType.inquirySurveytype.id}')"></em>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="hand left" onclick="toBoardIndex('${groupType.inquirySurveytype.id}','account');" title="${ctp:toHTML(groupType.inquirySurveytype.typeName)}">${ctp:toHTML(v3x:getLimitLengthString(groupType.inquirySurveytype.typeName,29,"..."))}</div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:if test="${board.inquirySurveytype.id == groupType.inquirySurveytype.id}">
                                                    <img class="current_corner" src="${path}/skin/default/images/cultural/inquiry/cover_current.png">
                                                </c:if>
                                            </li>
                                        </c:if>
                                    </c:forEach>
                                </ul>
                            </li>
                            <c:if test="${fn:length(accountInquiryTypeList)>5 }">
                                <li class="discuss_cover_page" id="accountPage">
                                    <input type="hidden" name="accountNowPage" id="accountNowPage" value="1">
                                    <input type="hidden" name="accountPageNum" id="accountPageNum" value="${fn:length(accountInquiryTypeList)}">
                                    <span class="discuss_page">
                                        <em class="icon16 discuss_left_16 hand" onclick="jumpBack('account');"></em>
                                        <span class="page_circles">
                                            <c:forEach begin="1" end="${accountInquiryTypeListPageNum}" var="count" varStatus="countStatus">
                                                <c:if test="${countStatus.first}">
                                                    <a href="javascript:;" class="page_num current">1</a>
                                                </c:if>
                                                <c:if test="${count<=10 && !countStatus.first}">
                                                    <a href="javascript:;" class="page_num" onclick="jumpPageNew('account',${count})">${count}</a>
                                                </c:if>
                                                <c:if test="${count>10 && !countStatus.first}">
                                                    <a href="javascript:;" class="page_num" style="display: none" onclick="jumpPageNew('account',${count})">${count}</a>
                                                </c:if>
                                            </c:forEach>
                                        </span>
                                        <em class="icon16 discuss_right_16 hand" onclick="jumpNext('account');"></em>
                                    </span>
                                </li>
                            </c:if>
                        </ul>
                        </c:if>
                        <c:if test="${customInquiryTypeList!=null}">
                        <ul class="discuss_ul" id="customTypeList">
                            <li class="ling_4_group"></li>
                            <li class="discuss_title">
                                <span class="discuss_title_name">${ctp:i18n('inquiry.type.custom')}</span><%--i18n 自定义团队--%>
                            </li>
                            <li class="discuss_body">
                                <ul class="discuss_body_page">
                                    <c:if test="${fn:length(customInquiryTypeList)==0 }">
                                        <div class="discuss_no_list_msg">${ctp:i18n('bbs.board.list.null')}</div>
                                    </c:if>
                                    <c:forEach items="${customInquiryTypeList}" var="customType" varStatus="accountStatus">
                                        <%--单位第一页--%>
                                        <c:if test="${accountStatus.index<5}">
                                            <li class="discuss_cover_name hand" id='side_${customType.inquirySurveytype.id}'>
                                                <c:choose>
                                                    <c:when test="${customType.hasManageAuth&&customType.hasPublicAuth}">
                                                        <div class="hand left" style="width: 190px" title="${customType.inquirySurveytype.typeName}" onclick="toBoardIndex('${customType.inquirySurveytype.id}','custom');">${ctp:toHTML(v3x:getLimitLengthString(customType.inquirySurveytype.typeName,29,"..."))}</div>
                                                        <div class="discuss_cover right">
                                                            <em class="icon24 admin_cover_left_24" title="${ctp:i18n('blog.set.label')}" onclick="showDropList(this);"></em>
                                                            <em class="icon24 admin_cover_right_24" title="${ctp:i18n('new.inquiry.button')}" onclick="inquiryCreate('${customType.spaceType}','${customType.spaceId}','${customType.inquirySurveytype.id}')"></em>
                                                            <div class="drop_component">
                                                                <div class="corner">
                                                                    <img src="${path}/skin/default/images/cultural/inquiry/drop_corner.png" class="drop_conner">
                                                                </div>
                                                                <ul class="drop_list">
                                                                    <li class="drop_list_li" onclick="statistics('${customType.inquirySurveytype.id}')">${ctp:i18n('inquiry.getcount')}</li>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                    <c:when test="${(!customType.hasManageAuth)&&customType.hasPublicAuth}">
                                                        <div class="hand left" style="width: 205px" title="${customType.inquirySurveytype.typeName}" onclick="toBoardIndex('${customType.inquirySurveytype.id}','custom');">${ctp:toHTML(v3x:getLimitLengthString(customType.inquirySurveytype.typeName,29,"..."))}</div>
                                                        <div class="discuss_talk right" style="right:16px">
                                                            <em class="icon24 add_talk_24" onclick="inquiryCreate('${customType.spaceType}','${customType.spaceId}','${customType.inquirySurveytype.id}')"></em>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="hand left" title="${customType.inquirySurveytype.typeName}" onclick="toBoardIndex('${customType.inquirySurveytype.id}','custom');">${ctp:toHTML(v3x:getLimitLengthString(customType.inquirySurveytype.typeName,29,"..."))}</div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:if test="${board.inquirySurveytype.id == customType.inquirySurveytype.id}">
                                                    <img class="current_corner" src="${path}/skin/default/images/cultural/inquiry/cover_current.png">
                                                </c:if>
                                            </li>
                                        </c:if>
                                        <%--单位后续--%>
                                        <c:if test="${accountStatus.index>=5}">
                                            <li class="discuss_cover_name hand" style="display:none" id='side_${customType.inquirySurveytype.id}'>
                                                <c:choose>
                                                    <c:when test="${customType.hasManageAuth&&groupType.hasPublicAuth}">
                                                        <div class="hand left" title="${customType.inquirySurveytype.typeName}" style="width: 190px" onclick="toBoardIndex('${customType.inquirySurveytype.id}','custom');">${ctp:toHTML(v3x:getLimitLengthString(customType.inquirySurveytype.typeName,29,"..."))}</div>
                                                        <div class="discuss_cover right">
                                                            <em class="icon24 admin_cover_left_24" title="${ctp:i18n('blog.set.label')}" onclick="showDropList(this);"></em>
                                                            <em class="icon24 admin_cover_right_24" title="${ctp:i18n('new.inquiry.button')}" onclick="inquiryCreate('${customType.spaceType}','${customType.spaceId}','${customType.inquirySurveytype.id}')"></em>
                                                            <div class="drop_component">
                                                                <div class="corner">
                                                                    <img src="${path}/skin/default/images/cultural/inquiry/drop_corner.png" class="drop_conner">
                                                                </div>
                                                                <ul class="drop_list">
                                                                    <li class="drop_list_li" onclick="setAuth('${customType.inquirySurveytype.id}','custom')">${ctp:i18n('inquiry.type.Set')}</li>
                                                                    <li class="drop_list_line"></li>
                                                                    <li class="drop_list_li" onclick="statistics('${customType.inquirySurveytype.id}')">${ctp:i18n('inquiry.getcount')}</li>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                    <c:when test="${(!customType.hasManageAuth)&&groupType.hasPublicAuth}">
                                                        <div class="hand left" style="width: 205px" title="${customType.inquirySurveytype.typeName}" onclick="toBoardIndex('${customType.inquirySurveytype.id}','custom');">${ctp:toHTML(v3x:getLimitLengthString(customType.inquirySurveytype.typeName,29,"..."))}</div>
                                                        <div class="discuss_talk right" style="right:16px">
                                                            <em class="icon24 add_talk_24" onclick="inquiryCreate('${customType.spaceType}','${customType.spaceId}','${customType.inquirySurveytype.id}')"></em>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="hand left" title="${customType.inquirySurveytype.typeName}" onclick="toBoardIndex('${customType.inquirySurveytype.id}','custom');">${ctp:toHTML(v3x:getLimitLengthString(customType.inquirySurveytype.typeName,29,"..."))}</div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:if test="${board.inquirySurveytype.id == customType.inquirySurveytype.id}">
                                                    <img class="current_corner" src="${path}/skin/default/images/cultural/inquiry/cover_current.png">
                                                </c:if>
                                            </li>
                                        </c:if>
                                    </c:forEach>
                                </ul>
                            </li>
                            <c:if test="${fn:length(customInquiryTypeList)>5 }">
                                <li class="discuss_cover_page" id="customPage">
                                    <input type="hidden" name="customNowPage" id="customNowPage" value="1">
                                    <input type="hidden" name="customPageNum" id="customPageNum" value="${fn:length(customInquiryTypeList)}">
                                    <span class="discuss_page">
                                        <em class="icon16 discuss_left_16 hand" onclick="jumpBack('custom');"></em>
                                        <span class="page_circles">
                                            <c:forEach begin="1" end="${customInquiryTypeListPageNum}" var="count" varStatus="countStatus">
                                                <c:if test="${countStatus.first}">
                                                    <a href="javascript:;" class="page_num current">1</a>
                                                </c:if>
                                                <c:if test="${count<=10 && !countStatus.first}">
                                                    <a href="javascript:;" class="page_num" onclick="jumpPageNew('custom',${count})">${count}</a>
                                                </c:if>
                                                <c:if test="${count>10 && !countStatus.first}">
                                                    <a href="javascript:;" class="page_num" style="display: none" onclick="jumpPageNew('custom',${count})">${count}</a>
                                                </c:if>
                                            </c:forEach>
                                        </span>
                                        <em class="icon16 discuss_right_16 hand" onclick="jumpNext('custom');"></em>
                                    </span>
                                </li>
                            </c:if>
                        </ul>
                        </c:if>
                        <ul class="discuss_ul overflow padding_b_25" id="newInquiryRightList">
                            <input type="hidden" name="newFivePageNo" id="newFivePageNo" value="0">
                            <input type="hidden" name="allSize" id="allSize" value="0">
                            <li class="ling_4_new"></li>
                            <li class="discuss_title">
                                <span class="discuss_title_name">${ctp:i18n('inquiry.newrighttitle')}</span><%--i18n 最新调查 --%>
                                <span class="discuss_title_more hand" onclick="getFive();">${ctp:i18n('inquiry.newrightchange')}</span><%--i18n 换一换 --%>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div class="admin_edit" style="display: none">
            <ul class="admin_edit_ul">
                <li class="admin_edit_li hand" onclick="killInquiry();">
                    <img src="${path}/skin/default/images/cultural/inquiry/end.png" class="edit_li_img" >
                    <span class="edit_li_name">${ctp:i18n('inquiry.manage.killinquiry')}</span>
                </li>
                <li class="li_line"></li>
                <li class="admin_edit_li hand" onclick="cancelInquirys();">
                    <img src="${path}/skin/default/images/cultural/inquiry/cancle.png" class="edit_li_img" >
                    <span class="edit_li_name">${ctp:i18n('inquiry.manage.cancelinquiry')}</span>
                </li>
                <li class="li_line"></li>
                <li class="admin_edit_li  hand" onclick="delInquiry();">
                    <img src="${path}/skin/default/images/cultural/inquiry/delete.png" class="edit_li_img" >
                    <span class="edit_li_name">${ctp:i18n('inquiry.manage.delinquiry')}</span>
                </li>
                <c:if test="${ctp:hasPlugin('doc')}">
                <li class="li_line"></li>
                <li class="admin_edit_li  hand" onclick="myPigeonhole();">
                    <img src="${path}/skin/default/images/cultural/inquiry/file.png" class="edit_li_img" >
                    <span class="edit_li_name">${ctp:i18n('inquiry.manage.mypigeonhole')}</span>
                </li>
                </c:if>
                <c:if test="${manageMove}">
                    <li class="li_line"></li>
                    <li class="admin_edit_li  hand" onclick="moveInquiry();">
                        <img src="${path}/skin/default/images/cultural/inquiry/move.png" class="edit_li_img" >
                        <span class="edit_li_name">${ctp:i18n('inquiry.manage.moveinquiry')}</span>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
</div>
<div class="to_top" id="back_to_top">
    <span class="scroll_bg">
        <em class="icon24 to_top_24 margin_t_5"></em>
        <span class="back_top_msg hidden">${ctp:i18n('inquiry.gototop')}</span>
    </span>
</div>
</body>
<footer>

</footer>
</html>