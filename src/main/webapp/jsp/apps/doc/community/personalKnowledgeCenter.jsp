<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/doc/js/docFavorite.js?V=V5_0_product.build.date"></script>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
    <title>${ctp:i18n('doc.jsp.knowledge.center')}</title>
    <script type="text/javascript" src="${path}/apps_res/doc/js/doc.js"></script>
    <script type="text/javascript" src="${path}/common/js/i18n/zh-cn.js"></script>
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/webmail/js/webmail.js${v3x:resSuffix()}" />"></script>
    <style type="text/css">
        .lvl1 .lvlIcon { position:relative;top:-3px;left:-5px;}
        .common_button, .form_btn {
                max-width: 120px;
        }
        .file_box_menu_list ul.lvl1 {
            width:120px;
        }
        .file_box_menu_list ul.lvl1 li a {
            width:90px;
        }
        .area_learn2 a{
            max-width: 128px;
            overflow: hidden;
            float: left;
            display: block;
            white-space: nowrap;
            word-break: keep-all;
            text-overflow: ellipsis;
        }
    </style>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/knowledgeBrowseUtils.js" />"></script>
<script type="text/javascript">
var jsMeetingURL = "${mtMeetingURL}";
<%@ include file="/WEB-INF/jsp/apps/doc/js/docUtil.js"%>
<%@ include file="/WEB-INF/jsp/apps/doc/js/personalKnowledgeCenter.js"%>
<%@ include file="/WEB-INF/jsp/apps/doc/js/knowledgeCenter.js"%>
hiddenPostOfDepartment_perLearnPop = true;
isNeedCheckLevelScope_perLearnPop = false;
onlyLoginAccount_perLearnPop = true;
_ = v3x.getMessage;
v3x.loadLanguage("/apps_res/doc/i18n");
var LockStatus_AppLock = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.AppLock.key()%>";
var LockStatus_ActionLock = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.ActionLock.key()%>";
var LockStatus_DocInvalid = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.DocInvalid.key()%>";
var LockStatus_None = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.None.key()%>";
var LOCK_MSG_NONE = "<%=com.seeyon.apps.doc.util.Constants.LOCK_MSG_NONE%>";

//菜单权限
var canNewColl = "${v3x:hasNewCollaboration()}";
var canNewMail = "${v3x:hasNewMail()}";
//隐藏左边
if(getA8Top()){
    if(getA8Top().hideLeftNavigation){
        getA8Top().hideLeftNavigation();
    }
}
$(function(){
	
    var curUserId = $.ctx.CurrentUser.id;
    var knowledgeMgr = new knowledgePageManager();
    var hasAttr = "<span class='ico16 affix_16 left'></span>";
    // 我的学习区栏目列表
    knowledgeMgr.getDocLearn(curUserId, 8, {
        success:function(list) {
            if(list.length > 0){
                $('#docLearnMore').removeClass("display_none");
                var $learnUL = $("#ulwithlis_docLearn");
               
                for(var i=0,len=list.length; i< len; i++) {
                    var attr = list[i].hasAttachments ? hasAttr:"";
                    $learnUL.append("<li class='margin_t_5 clearfix'><a href='javascript:fnOpenKnowledge(\"" + list[i].docResourceId +"\");' class='color_black'><span class='ico16 fileType2_" + list[i].docMimeTypeId + " margin_r_5'></span>"
                        + list[i].frName + "</a>"+attr+"<span class='color_gray margin_r_5 right'>" + list[i].recommendTime + 
                        "</span></li>");
                }
            }else{
                $('#docLearnMore').addClass("display_none");
                var strHtml = "<div class=\"color_gray align_center padding_10\">${ctp:i18n('doc.knowledge.blank.warning')}</div>";
                $(strHtml).insertAfter("#docLearn");
            }
                
        }
    });
});
/**
 * 去XX地方,修改title
 */
function fnToLocation(url,title){
    window.location = url;
}
function levelinfoDialog() {
	$.dialog({
		title : $.i18n("doc.title.level.instruction.js"),
		url: "${path}/doc/knowledgeController.do?method=showKnowledgeIntegrationSetting&readOnly=readonly",
		height:538,
	    width:658,
	    targetWindow :getA8Top()
	});
}
</script>
<style type="text/css">
.area_page {
  width: 967px;
}
.file_box_area {
  width: 233px;
}

.margin_r_42 {
  margin-right: 10px;
}

.area_page .area_main {
  width: 725px;
}

.area_page .area_sub {
  width: 230px;
  margin-right:1px; 
}
.per_center_bg{
    background: #a2d2e6;
    padding: 5px 0 0 10px;
}
#divPageTab #a_style
{
    background: #daeaf1;
}
#a_style .current{
    background: #fff;
}
#a_style a:hover{
     background: #fff;
}
.bg_color_blueF{
    background: #daeaf1;
}
.page_color{
    background: url(images/per_center.png?V=5_0_8_30) no-repeat;
}
.color_gray{
    color:#474646;
}
</style>

<v3x:selectPeople id="perLearnPop" panels="Department,Team,Post,Level,Outworker" selectType="Member,Team,Post,Level"
    departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" 
    jsFunction="sendToPersonalLearn(elements, 'pop')" minSize="1" />

</head>
<body class="per_center">
<form action="" name="mainForm" id="mainForm"  method="post" >
<div class="comp" comp="type:'fileupload',applicationCategory:'3',isEncrypt:true,quantity:3,callMethod:'callbackInsertAttachmentReplace',takeOver:false"
 attsdata=''></div>
<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F04_showKnowledgeNavigation'"></div>
    <div class="area_page" id="divAreaPageId">
        <div class="area_main" id="divAreaMainId" style="padding:0;">
            <div class="clearFlow per_center_bg" id="divPersonInfo">
                <img class="left margin_r_10 hand radius" id="imgPersonCardId" width="64" height="64" src="${v3x:avatarImageUrl(CurrentUser.id)}" />
                <p class="clearFlow font_size14 margin_t_5"><strong class="left margin_r_5 margin_t_5">
                <!-- onclick="javascript:fnPersonCard(this);" -->
                <span userId="${personStaut.userId}">${personStaut.userName}</span>
                </strong>
                <c:set var="medal" value="medals_${personStaut.degree}"></c:set>
                <c:choose>
                    <c:when test="${personStaut.showXunzhang}">
                		<span id="levelinfo" onclick="levelinfoDialog()" class="ico24 ${medal}" title=" ${personStaut.personScore}${personStaut.shortScore}${ctp:i18n('doc.knowledge.level.info')}"></span></p>
                		<p class="margin_t_10 font_bold" >${personStaut.medal}</p>
                	</c:when>
                </c:choose>
                <div class="clearFlow line_height200 margin_r_10">
                    <p class="left color_gray">${personStaut.department.name} ${personStaut.orgPost.name}</p>
                        <a href="javascript:fnToLocation('${path}/doc.do?method=docIndex&openLibType=1','${ctp:i18n('doc.tree.struct.lable')}');" class="common_button right margin_l_5 resCode" resCode="F04_docIndex" title="${ctp:i18n('doc.jsp.knowledge.go.knowledge.doclib')}">${ctp:i18n('doc.jsp.knowledge.go.knowledge.doclib')}</a>
                        <a href="javascript:fnToLocation('${path}/doc/knowledgeController.do?method=toKnowledgeSquare','${ctp:i18n('doc.jsp.knowledge.knowledge.square')}');"  class="common_button right margin_l_5 resCode" resCode="F04_knowledgeSquareFrame" title="${ctp:i18n('doc.jsp.knowledge.go.knowledge.square')}">${ctp:i18n('doc.jsp.knowledge.go.knowledge.square')}</a>
                        <a href="javascript:fnToLocation('${path}/doc/knowledgeController.do?method=personalShare','${ctp:i18n('doc.jsp.knowledge.share')}');"  class="common_button common_button_emphasize right margin_l_5" title="${ctp:i18n('doc.jsp.knowledge.share')}">${ctp:i18n('doc.jsp.knowledge.share')}</a>
                    <span class="right color_gray">${ctp:i18n('doc.jsp.knowledge.have.share.my')}&nbsp;<strong class="color_black">${personStaut.shareNum}</strong>&nbsp;${ctp:i18n('doc.jsp.knowledge.have.share.pieces')}</span>
                </div>
            </div>
            <div class="area_menu per_center_bg" id="divPageTab">
                <div id="a_style" class="clearfix">
                    <span class="line_ico left"></span>
                    <a id="docRead" >${ctp:i18n('doc.jsp.knowledge.my.read')}</a>
                    <span class="line_ico left"></span>
                    <a id="docTrends" >${ctp:i18n('doc.jsp.knowledge.dynamic')}</a>
                    <span class="line_ico left"></span>
                    <a id="docComment" >${ctp:i18n('doc.jsp.knowledge.evaluation')}</a>
                    <span class="line_ico left"></span>
                    <a id="myKnowledgeLib" >${ctp:i18n('doc.contenttype.knowledge')}</a>
                    <span class="line_ico left"></span>
                </div>
            </div>
            <div id="contentArea">
                <div id="recentlyRead" class="zszx_title_area">
                    <span class="left font_bold font_size14">${ctp:i18n('doc.jsp.knowledge.recent.read')}<em class="title_ico margin_t_5"></em></span>
                </div>
                <div id="latestCollect" class="zszx_title_area">
                    <span class="left font_bold font_size14">${ctp:i18n('doc.jsp.knowledge.recent.collect')}<em class="title_ico margin_t_5"></em></span>
                    <div class="right margin_t_5"><a id="docMoreCollect" href="javascript:void(0);">${ctp:i18n('doc.jsp.knowledge.more')}</a></div>
                </div>
           </div>
           <div id="isPaging" class="display_none">
                <%@ include file="/WEB-INF/jsp/apps/doc/flipInfoBar.jsp"%>
           </div>
        </div>
        <div class="area_sub margin_l_10">
            <div class="clearFlow border_all">
                <div id="docLearn" class="bg_color_blueF padding_lr_10 padding_tb_5 border_b_gray2"><strong>${ctp:i18n('doc.jsp.home.label.learn')}</strong></div>
                <ul id="ulwithlis_docLearn" class="clearFlow area_learn2 line_height160 padding_lr_5 padding_b_5" ></ul>
                <div id="docLearnMore" class="border_t_gray2 align_right padding_tb_5">
                    <a href="${path}/doc.do?method=docLearningMore&from=knowledgeCenter" class="margin_r_10">${ctp:i18n('doc.jsp.knowledge.more')}</a>
                </div>
            </div>
            <div class="clearFlow margin_t_5 border_all">
                <div class="bg_color_blueF padding_lr_10 padding_tb_5 border_b_gray2"><strong>${ctp:i18n('doc.jsp.knowledge.other.borrow')}</strong></div>
                <c:set var="attachment" value="<span class='ico16 affix_16 margin_l_0'></span>"/>
                <c:choose>
                    <c:when test="${borrowListEmpty}">
                        <div class="color_gray align_center padding_10">${ctp:i18n('doc.knowledge.blank.warning')}</div>
                    </c:when>
                    <c:otherwise>
                        <ul class="clearFlow line_height180 padding_5">
                            <c:forEach items="${borrowList}" var="borrowDoc" varStatus="index">
                            <li class="clearFlow margin_t_5">                    
                                <img id="personCard${index.index}" userId="${borrowDoc.borrowUserId}" ${borrowDoc.borrowUserValid?"onclick='javascript:fnPersonCard(this);'":""}  class="radius hand left margin_r_5 ${borrowDoc.borrowUserValid?'':'common_disable'}" userId="${borrowDoc.borrowUserId}" width="20" height="20" src="${borrowDoc.borrowUserImg}" />
                                <div class="clearFlow">
                                    <p><a ${borrowDoc.borrowUserValid?"onclick='javascript:fnPersonCard(this);'":"class='disabled_color'"} userId="${borrowDoc.borrowUserId}">${ctp:toHTML(borrowDoc.borrowUserName)}</a>:${ctp:i18n('doc.jsp.knowledge.apply.borrow')}:<span id="styleId" class="ico16 fileType2_${borrowDoc.styleId}"></span><a id="title" href="#" title="${ctp:toHTMLAlt(borrowDoc.frName)}" onClick="fnOpenKnowledge('${borrowDoc.docId}');">
                                       ${ctp:toHTML(borrowDoc.frName)}</a>${borrowDoc.hasAttachments ? attachment :''}</p>
                                    <p class="align_right color_gray padding_r_5">
                                        ${ctp:formatDateByPattern(borrowDoc.borrowTime,'MM-dd HH:mm')}
                                    </p>
                                </div>
                            </li>
                            </c:forEach>
                        </ul>
                        <div class="border_t_gray2 align_right padding_tb_5">
                            <a href="${path}/doc/knowledgeController.do?method=link&prefix=personal&path=borrowHandle" class="margin_r_10">${ctp:i18n('doc.jsp.knowledge.go.handle')}</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="clearFlow margin_t_5 border_all">
                <div id="knowledgeLink" class="bg_color_blueF padding_lr_10 padding_tb_5 border_b_gray2"><strong>${ctp:i18n('doc.jsp.knowledge.list.my.knowledge.link')}</strong></div>
                <div id="div_knowledgeLink" class="line_height200 clearfix padding_tb_5" ></div>
                <div id="knowledgeLinkSet" class="border_t_gray2 align_right padding_tb_5">
                    <a onclick="openPensonalLink()" class="margin_r_10">${ctp:i18n('doc.jsp.knowledge.knowledge.link.config')}</a>
                    <a id="hrefKnowledgeLinkMoreId" href="${path}/portal/linkSystemController.do?method=linkSystemMore&doType=${knowledgeLink_doType}" class="margin_r_10">${ctp:i18n('doc.jsp.knowledge.more')}</a>
                </div>
            </div>
        </div>
    </div>
    <div id="docUploadDiv" style="visibility:hidden"><div><v3x:fileUpload applicationCategory="3" /></div></div>
    <iframe id="emptyIframe" style="display:none;" name="emptyIframe" frameborder="0"
            height="0" width="0" scrolling="no" marginheight="0" marginwidth="0" />
</form>
</body>
</html>
