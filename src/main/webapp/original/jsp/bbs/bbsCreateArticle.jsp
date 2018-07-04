<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="bbsHeader.jsp"%>
<html class="h100b over_hidden">
  <head>
        <title>${ctp:i18n('new.bbs.button')}</title>
        <link rel="stylesheet" type="text/css" href="${path}/skin/default/bbs.css${v3x:resSuffix()}" />
        <script src="${path}/apps_res/bbs/js/bbs-createArticle.js${v3x:resSuffix()}"></script>
        <script type="text/javascript">
        var modifyAnonymousFlag = false;
        var modifyAnonymousReplyFlag = false;
        var ajax_bbsArticleManager = new bbsArticleManager();
        <%-- 集团版块选人组件 --%>
        var isNeedCheckLevelScope_spGroup = false;
        var hiddenPostOfDepartment_spGroup = true;
        <%-- 单位版块选人组件 --%>
        var isNeedCheckLevelScope_spAccount = false;
        var hiddenPostOfDepartment_spAccount = true;
        var onlyLoginAccount_spAccount = true;
        var hiddenOtherMemberOfTeam_spAccount = true;
        <%-- 部门版块选人组件 --%>
        var isNeedCheckLevelScope_spDept = false;
        var hiddenPostOfDepartment_spDept = true;
        var onlyLoginAccount_spDept = true;
        var includeElements_spDept = "${v3x:parseElementsOfTypeAndId(entity)}";
        <%-- 自定义--%>
        var isNeedCheckLevelScope_spCustomSpace = false;
        var hiddenPostOfDepartment_spCustomSpace = true;
        var onlyLoginAccount_spCustomSpace = false;
        
        function selectIssueArea(type){
            if(type=="group"){
                selectPeopleFun_spGroup();
            }
            if(type=="account"){
                selectPeopleFun_spAccount();
            }
            if(type=="dept"){
                selectPeopleFun_spDept();
            }
            if(type=="custom"){
              selectPeopleFun_spCustomSpace();
            }
        }
        function setPeopleFields(elements){
            if(!elements){
                return;
            }
            $("#issueArea").val(getIdsString(elements));
            $("#issueAreaName").val(getNamesString(elements));  
            hasIssueArea = true;
        }
        
        var _isCustom = ${spaceType == '18'||spaceType == '17'||spaceType == '4'};
        </script>
  </head>
  <body scroll='no' class="h100b over_hidden">
            <form id="articlePostForm" action="" style="height:100%;">
            <input type="hidden" name="original_top"  id = "original_top"value="">
            <input type="hidden" name="original_left" id = "original_left" value="">
            <input type="hidden" name="boardId"  id = "boardId" value="${boardId }">
            <input type="hidden" name="boardType" id = "boardType" value="${boardType }">
            <input type="hidden" name="boardInfo" id = "boardInfo" value="${ctp:toHTML(boardMapJson)} ">
            <input type="hidden" id="issueArea" 
                value="${spaceType == '18'||spaceType == '17'||spaceType == '4'||spaceType == '1'||spaceType == '12'  ? entity : ''}" 
                name="issueArea"><%-- 选人信息 --%>
            <%--选人 --%>
            <c:set value="${v3x:parseElementsOfTypeAndId(entity)}" var="org"/>
            <c:set var="issueAreaName" value="${v3x:showOrgEntitiesOfTypeAndId(entity, pageContext)}" />
            <v3x:selectPeople id="spGroup" showAllAccount="true" originalElements="${org}"
                    panels="Account,Department,Team,Post,Level" selectType="Member,Department,Account,Post,Level,Team"
                    departmentId="" jsFunction="setPeopleFields(elements)" />
            <v3x:selectPeople id="spAccount" originalElements="${org}"
                    panels="Department,Team,Post,Level,Outworker"
                    selectType="Member,Department,Account,Post,Level,Team"
                    departmentId="${v3x:currentUser().departmentId}"
                    jsFunction="setPeopleFields(elements)" />
            <v3x:selectPeople id="spDept" originalElements="${org}"
                    panels="Department,Team,Post,Level,Outworker"
                    selectType="Member,Department,Account,Post,Level,Team"
                    departmentId="${v3x:currentUser().departmentId}"
                    jsFunction="setPeopleFields(elements)" />
            <c:if test="${spaceType == '18'||spaceType == '17'||spaceType == '4'}">
              <script type="text/javascript">
                    <!--
                     includeElements_spCustomSpace = "${v3x:parseElementsOfTypeAndId(entity)}";
                    //-->
              </script>
              <v3x:selectPeople id="spCustomSpace" showAllAccount="true"
                    originalElements="${org}"
                    panels="Account,Department,Team,Post,Level,Outworker"
                    selectType="Member,Department,Account,Post,Level,Team"
                    departmentId="${v3x:currentUser().departmentId}"
                    jsFunction="setPeopleFields(elements)" />
            </c:if>
            <script type="text/javascript">
            if('18'=='${v3x:escapeJavascript(param.spaceType)}'||'17'=='${v3x:escapeJavascript(param.spaceType)}'||'4'=='${v3x:escapeJavascript(param.spaceType)}')
                showAllOuterDepartment_spCustomSpace = false;
            else
                showAllOuterDepartment_spCustomSpace = true;
            </script>
            <div class="dialog_body">
                <div class="dialog_header">
                    <span class="index_logo" style="padding-left:96px;">
                        <img src="${path}/skin/default/images/cultural/bbs/logo_create.png" width="31" style="margin-top:15px;">
                        <span class="index_logo_name">${ctp:i18n('new.bbs.button')} +</span>
                    </span>
                </div>
                <div class="dialog_content" style="background:#f7f7f7;">
                    <div class="dialog_content_top over_hidden">
                        <input type="text" class="input_left font16" id = "articleTitle"><%-- 标题 --%>
                        <select class="news_select margin_r_10 font12" onchange="createBoardSelect(true);" id = "boardTypeSelect">
                            <c:choose>
                              <c:when test="${spaceType==18}"><option id="boardType_18" value="group" selected>${ctp:i18n('bbs.board.public.custom.group')}</option></c:when>
                              <c:when test="${spaceType==17}"><option id="boardType_17" value="account" selected>${ctp:i18n('bbs.board.public.custom')}</option></c:when>
                              <c:when test="${spaceType==4}"><option id="boardType_4" value="custom" selected>${ctp:i18n('bbs.board.custom')}</option></c:when>
                              <c:when test="${spaceType==12}"><option id="boardType_12" value="project" selected>${ctp:i18n('bbs.title.label')}</option></c:when>
                              <c:otherwise>
                                <c:if test="${fn:length(boardMap['group'])>0 && (boardType=='2'||boardType=='3')}">
                                <option value="group" id="boardType_3">${ctp:i18n('Groupdiscussion.label')}</option>
                                </c:if>
                                <c:if test="${fn:length(boardMap['account'])>0 && (boardType=='2'||boardType=='3')}">
                                <option value="account" id="boardType_2">${ctp:i18n('Unitdiscussion.label')}</option>
                                </c:if>
                                <c:if test="${fn:length(boardMap['dept'])>0 && boardType=='1'}">
                                <option value="dept" id="boardType_1">${ctp:i18n('bbs.departmentBbsSection.label')}</option>
                                </c:if>
                              </c:otherwise>
                             </c:choose>
                        </select>
                        <select class="active_select font12" id = "boardSelect" name="boardSelect" onchange="changeCheckBox();">
                            <c:if test="${spaceType==4}"><option value="${param.spaceId}" selected>${v3x:toHTML(customName)}</option></c:if>
                        </select>
                    </div>
                    <div class="dialog_content_bottom margin_t_10 margin_b_10">
                        <c:choose>
                            <c:when test="${spaceType == '18'||spaceType == '17'||spaceType == '4'}">
                              <input id="issueAreaName" type="text" readonly="readonly" value="${issueAreaName}" class="issue_area margin_r_10" onclick="javascript:selectIssueArea('custom');">
                            </c:when>
                            <c:when test="${spaceType == '1'}">
                              <input id="issueAreaName" type="text" readonly="readonly" value="${issueAreaName}" class="issue_area margin_r_10" onclick="javascript:selectIssueArea('dept');">
                            </c:when>
                            <c:when test="${spaceType == '12'}">
                              <input id="issueAreaName" type="text" readonly="readonly" value="${issueAreaName}" disabled class="issue_area margin_r_10">
                            </c:when>
                            <c:otherwise>
                              <input id="issueAreaName" type="text" readonly="readonly" class="issue_area margin_r_10" onclick="javascript:selectIssueArea();alert();">
                            </c:otherwise>
                        </c:choose>
                        <span style="margin-right:20px;" class="font12">
                            <label for="radio1">
                                <input type="radio" name="typeRadio" class="radio" checked="checked" value="0" id="radio1" > ${ctp:i18n('bbs.showArticle.Noth') }<span style="margin-right: 5px"></span>
                            </label>
                            <label for="radio2">
                                <input type="radio" name="typeRadio" class="radio" value="1" id="radio2"> ${ctp:i18n('bbs.yuan.label') }<span style="margin-right: 5px"></span>
                            </label>
                            <label for="radio3">
                                <input type="radio" name="typeRadio" class="radio" value="2" id="radio3"> ${ctp:i18n('bbs.zhuan.label') }<span style="margin-right: 5px"></span>
                            </label>
                        </span>
                        <span class="font16">
                            <label for="isGetNewReply">
                                <input type="checkbox" class="checkbox" id = "isGetNewReply" value="${ctp:i18n('bbs.receive.message.label') }" checked="checked"><span class="margin_l_5 font12" style="margin-right: 5px;">${ctp:i18n('bbs.receive.message.label') }</span>
                            </label>
                            <c:if test="${boardType!='1'}">
                            <label for="isSendSecret">
                                <input type="checkbox" class="checkbox" id = "isSendSecret" value="${ctp:i18n('anonymous.post') }"><span class="margin_l_5 font12" style="margin-right: 5px;">${ctp:i18n('anonymous.post') }</span>
                            </label>
                            <label for="isReplySecret">
                                <input type="checkbox" class="checkbox" id = "isReplySecret" value="${ctp:i18n('anonymous.reply') }"><span class="margin_l_5 font12" style="margin-right: 5px;">${ctp:i18n('anonymous.reply') }</span>
                            </label>
                            </c:if>
                        </span>
                    </div>
                    <!-- 附件 -->
                    <div id="attachmentDiv" class="textarea_edit_reply">
                        <div class="attch_flag left">
                            <span class="pointer">
                                <em class="icon16 file_attachment_16 margin_b_5"></em>
                                <span class="insert_file" onclick="javascript:insertAttachmentPoi('atts1')">${ctp:i18n('common.attachment.label')}</span>
                            </span>
                            <span id="attachmentTRatts1" style="display:none;">&nbsp;&nbsp;(<span id="attachmentNumberDivatts1"></span>)&nbsp;&nbsp;</span>
                        </div>
                        <div id="atts2" class="comp" comp="type:'fileupload',applicationCategory:'9',attachmentTrId:'atts1',canDeleteOriginalAtts:false,originalAttsNeedClone:false,callMethod:'attchmentCallBack',takeOver:false"></div>
                        <div id="attachmentAreaatts1" class="attachment_area left"></div>
                    </div>
                </div>
                <%--正文编辑器 --%>
                <div class="text_editor">
                    <iframe id="replyArticle" name="replyArticle" frameborder="0" width="100%" height="100%" src="${detailURL}?method=createArticleEditor"></iframe>
                </div>
                <div class="bottom_button" style="margin-top:-5px; position: relative; z-index:2;">
                    <a class="right create_button margin_tr_10" onclick="publishArticle('false');">${ctp:i18n('bbs.create.issue.js')}</a>
                    <a class="left create_button margin_tr_10" onclick="previewBbs();">${ctp:i18n('bbs.create.preView.js') }</a>
                    <c:if test="${spaceType!='12'}">
                    <a class="left create_button margin_tr_10 save" onclick="publishArticle('true');">${ctp:i18n('button.save') }</a>
                    </c:if>
                </div>  
            </div>
        </form>
        <form name="preForm" action='${path}/bbs.do?method=bbsPreview' method="post"  target="_blank" >
            <input id="preTitle" name="preTitle" type="hidden">
            <input id="preContent" name="preContent" type="hidden">
            <input id="preScope" name="preScope" type="hidden">
            <input id="preBoardId" name="preBoardId" type="hidden">
            <input id="preAttachment" name="preAttachment" type="hidden">
        </form>
    </body>
</html>
