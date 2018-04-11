<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ include file="inquiryHeader.jsp" %>
<html>
<head>
    <meta charset="UTF-8">
    <c:if test="${type==1}">
        <title>${ctp:i18n('inquiry.mystart')}</title><%--i18 我发起的 --%>
    </c:if>
    <c:if test="${type==2}">
        <title>${ctp:i18n('inquiry.iauth')}</title><%--i18 调查审核 --%>
    </c:if>
    
    <link rel="stylesheet" type="text/css" href="${path}/skin/default/inquiry.css${v3x:resSuffix()}" />
    <link rel="stylesheet" type="text/css" href="${path}/apps_res/inquiry/css/mine.css${v3x:resSuffix()}"/>
    <script src="${path}/apps_res/inquiry/js/common.js${v3x:resSuffix()}"></script>
    <script src="${path}/apps_res/inquiry/js/inquiry-iStartedOrAuth.js${v3x:resSuffix()}"></script>
    <script type="text/javascript">
        var _path = '${path}';
        var ajax_inquiryManager = new inquiryManager();
        var type = '${type}';
        var _spaceType = '${param.spaceType}';
        var _spaceId = '${param.spaceId}';
    </script>
</head>
<body>
<input type="hidden" name="basicSize" id="basicSize" value="${basicSize}">
<input type="hidden" name="canEditSize" id="canEditSize" value="${canEditSize}">
<input name="boardId" id="boardId" value="" type="hidden">
<div class="container">
    <div class="container_top">
        <div class="container_top_area">
            <span class="index_logo hand" title="${ctp:i18n('inquiry.backtoindex')}" onclick="toInquiryIndex();"><%--i18 返回首页 --%>
                <img src="${path}/skin/default/images/cultural/inquiry/inquiry_logo.png" width="40" height="40">
                <span class="index_logo_name hand">${ctp:i18n('inquiry.inquiry')}</span><%--i18 调查 --%>
            </span>
        </div>
		<%--<span class="index_search">--%>
			<%--<em class="icon16 index_search_16"></em>--%>
			<%--<input class="index_search_input" type="text" placeholder="${ctp:i18n('inquiry.searchyourfav')}">--%>
		<%--</span>--%>
    </div>
    <div class="content_container">
        <div class="container_auto">
            <div class="container_discuss margin_t_25">
                <div class="discuss_left">
                    <div class="discuss_left_header">
                        <c:if test="${type==1}">
							<span class="cover_end" onclick="killInquiry();">
                                <em class="cover_end_24"></em>
                                <span class="left">${ctp:i18n('inquiry.manage.killinquiry')}</span><%--i18n 结束调查--%>
                            </span>
                            <span class="line_1"></span>
                            <span class="cover_edit" onclick="editInquiry();">
                                <em class="icon24 cover_edit_24"></em>
                                <span class="left">${ctp:i18n('inquiry.manage.editInquiry')}</span><%--i18n 编辑调查--%>
                            </span>
                            <span class="line_1"></span>
                            <span class="cover_delete" onclick="delInquiry();">
                                <em class="icon24 cover_delete_24"></em>
                                <span class="left">${ctp:i18n('inquiry.manage.delinquiry')}</span><%--i18n 删除--%>
                            </span>
                            <span class="line_1"></span>
                            <span class="cover_delete" onclick="publishInquiry();">
                                <em class="icon24 cover_publish_24"></em>
                                <span class="left">${ctp:i18n('inquiry.manage.publishinquiry')}</span><%--i18n 发布调查--%>
                            </span>
                            <div id="searchCondition" style="line-height: normal; float: right;margin-top: 4px;"></div>
                            <%--<span class="cover_select" >--%>
                                <%--<select style="width: 150px;float: right" onchange="changeTableBySelect(this.value);">--%>
                                    <%--<option value="all">全部</option>--%>
                                    <%--<option value="8">${ctp:i18n('inquiry.grid.censor1')}</option>--%>
                                    <%--<option value="4">${ctp:i18n('inquiry.grid.censor2')}</option>--%>
                                    <%--<option value="1">${ctp:i18n('inquiry.grid.censor3')}</option>--%>
                                    <%--<option value="2">${ctp:i18n('inquiry.grid.censor4')}</option>--%>
                                    <%--<option value="3">${ctp:i18n('inquiry.grid.censor5')}</option>--%>
                                    <%--<option value="5">${ctp:i18n('inquiry.grid.censor6')}</option>--%>
                                <%--</select>--%>
                            <%--</span>--%>
                        </c:if>
                        <c:if test="${type==2}">
                            <span class="cover_delete" onclick="authInquiry('cancel');">
							    <em class="icon24 cover_delete_24"></em>
							    <span class="left">${ctp:i18n('inquiry.manage.cancelAuthInquiry')}</span><%--i18n 取消审核--%>
                            </span>
                            <div id="searchCondition" style="line-height: normal;float: right;margin-top: 4px;"></div>
                        </c:if>

                    </div>
                    <div class="radius_15">
                        <table id="iStartTable" style="display: none;" width="100%" height="100%" class="table"></table>
                        <table id="iAuthTable" style="display: none;" width="100%" height="100%" class="table"></table>
                    </div>
                </div>
                <div class="discuss_right">
                    <div class="company_discuss">
                        <div class="user_msg_info">
                            <div class="msg_info_header">
                                <span class="user_photo">
                                    <img class="radius" src="${v3x:avatarImageUrl(v3x:currentUser().id)}">
                                </span>
                                <span class="user_name"
                                      title="${ctp:toHTML(v3x:currentUser().name)}">${ctp:toHTML(v3x:getLimitLengthString(v3x:currentUser().name,8,"..."))}</span>
                                <c:if test="${hasIssue}">
                                    <a class="buttonNew examine_button" onclick="inquiryCreate('${param.spaceType}','${param.spaceId}','index');"><span class="talk_button_add">+</span><span class="talk_button_msg">${ctp:i18n('inquiry.createinquiry')}</span></a><%--i18 发起调查 --%>
                                </c:if>
                                <%--<c:if test="${!hasIssue}">--%>
                                    <%--<a class="buttonNew gray_button examine_button"><span--%>
                                            <%--class="talk_button_add">+</span><span--%>
                                            <%--class="talk_button_msg">${ctp:i18n('inquiry.createinquiry')}</span></a>&lt;%&ndash;i18 发起调查 &ndash;%&gt;--%>
                                    <%--<div class="pop_msgNew">--%>
                                        <%--<img src="${path}/skin/default/images/cultural/inquiry/pop_corner.png"--%>
                                             <%--class="msg_pop_corner">--%>

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
    </div>
</div>
<div class="to_top" id="back_to_top">
    <span class="scroll_bg">
        <em class="icon24 to_top_24 margin_t_5"></em>
        <span class="back_top_msg hidden">${ctp:i18n('inquiry.gototop')}</span>
    </span>
</div>
</body>
</html>