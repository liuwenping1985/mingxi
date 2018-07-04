<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html style="background:#e9eaec;">
<head>
    <title>${ctp:i18n('doc.jsp.knowledge.center')}</title>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/doc/js/docFavorite.js${v3x:resSuffix()}"></script>
    <script type="text/javascript" src="${path}/apps_res/doc/js/doc.js${v3x:resSuffix()}"></script>
    <script type="text/javascript" src="${path}/common/js/i18n/zh-cn.js${v3x:resSuffix()}"></script>
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
        .clearfix {
            clear:both;
        }
    </style>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/knowledgeBrowseUtils.js" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/CollaborationApi.js${v3x:resSuffix()}"/>"></script>
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
                    $learnUL.append("<li class='margin_t_5 clearfix'><a href='javascript:fnOpenKnowledge(\"" + list[i].docResourceId +"\");' class='set_color_3 color_black'><span class='ico16 fileType2_" + list[i].docMimeTypeId + " margin_r_5'></span>"
                        + list[i].frName + "</a>"+attr+"<span class='color_gray margin_r_5 right'>" + list[i].recommendTime + 
                        "</span></li>");
                }
            }else{
                $('#docLearnMore').addClass("display_none");
                var strHtml = "<div class=\"bg_color_white color_gray align_center padding_10\">${ctp:i18n('doc.knowledge.blank.warning')}</div>";
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
  overflow: visible;
}
.file_box_area {
  width: 233px;
  height:98px;
}

.margin_r_42 {
  margin-right: 10px;
}
.margin_r_17{
  margin-right: 17px;
}

.area_page .area_main {
  width: 717px;
}

.area_page .area_sub {
  width: 238px;
  margin-right:1px; 
}
.per_center_bg{
    background: url(${path}/apps_res/doc/images/per_center_bg.jpg${v3x:resSuffix()}) no-repeat;
}
#divPageTab #a_style
{
    background: url(${path}/apps_res/doc/images/per_center_bg1.jpg${v3x:resSuffix()}) no-repeat;
}
#a_style .current{
    background: #5093e1;
    font-weight:normal;
}
#a_style .current em{
    display:block;
}
#a_style a:hover{
     background: #5093e1;
     font-weight:normal;
}
#a_style a:hover em{
    display:block;
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
.clearfix>a{
    height:44px;
    line-height:44px;
    color:#fff;
    font-weight:normal;
    position:relative;
}
.clearfix>a>em{
    position:absolute;
    top:44px;
    left:50%;
    margin-left:-8px;
    display:inline-block;
    width:16px;
    height:6px;
    background:url(${path}/apps_res/doc/images/Knowledge_center.png${v3x:resSuffix()}) no-repeat;
    display:none;
}
#divPersonInfo{
    height:122px;
}
.zhanwei{
    height:6px;
    width:100%;
    background:#fff;
}
#imgPersonCardId{
    margin-left:30px;
    margin-top:27px;
}
.userName{
    font-size:16px;
    color:#fff;
}
.set_mt_18{
    margin-top:18px;
    line-height:26px;
}
.set_color_3{
    color:#333;
}
.clearfix>a.set_color_3{
    color:#333;
    font-size:12px;
    line-height:12px;
    height:16px;
}
.set_color_6{
    color:#666;
    margin-top:2px;
}
.zszx_title_area{
    margin-top:-2px;
    border-bottom:1px solid #e0e0e0;
}
.zszx_title_area span{
    color:#333;
}
#contentArea{
    padding:20px;
    padding-top:20px;
    padding-bottom:35px;
    position:relative;
}
.set_underLine{
    display:inline-block;
    padding:0 12px;
    border-bottom:2px solid #0088ff;
}
.zszx_file_list{
    margin-left:0;
}
.fileType_1{
    background-position:-5px 0;
}
.set_text_overflow{
    white-space: nowrap;
    text-overflow: ellipsis;
}
.zszx_file_list li .fixedHeigh{
    height:42px;
}
.zszx_file_list li{
    margin-top:0;
    margin-right:0;
    height:60px;
    border:1px solid #e0e0e0;
    background:#f9f9f9;
    padding:14px 10px;
    margin-top:20px;
}
.line{
    padding:0;
}
.fileType_107{
    background-position:-293px -32px;
}
#docReadUL{
    padding-bottom:28px;
}
#docLearn{
    background:#f7f8f9;
    font-size:14px;
    color:#333;
    padding:10px;
}
#docLearn>strong{
    font-weight:normal;
}
.set_border{
    border:1px solid #d5d8db;
    -webkit-border-radius:3px;
    -moz-border-radius:3px;
    border-radius: 3px;
}
.bg_color_blueF{
    background:#f7f8f9;
}
.border_b_gray2{
    border:none;
}
.bg_color_blueF{
    background:#f7f8f9;
    font-size:14px;
    color:#333;
    padding:10px;
}
.bg_color_blueF>strong{
    font-weight:normal;
}
#divAreaMainId{
    background:#fff;
}
#docLearnMore{
    display:inline-block;
    float: right;
}
#ulwithlis_docLearn{
    padding-left:9px;
    padding-top:5px;
    background:#fff;
}
#knowledgeLinkSet{
    display: inline-block;
    float: right;
}
#div_knowledgeLink{
    padding:0 10px 10px 5px;
    background: #fff;
}
#uuser{
    display: inline-block;
    overflow: hidden;
    max-width:36px;
    white-space: nowrap;
    text-overflow: ellipsis;
}
#title{
    display: inline-block;
    max-width:100px;
}
.margin_b_3{
    margin-bottom: 3px;
    display: inline-block;
}
.clearfix>a.otherPt{
    color:#296fbe;
    height:16px;
    line-height:16px;
}
.clearfix>a.set_normal{
    color:#296fbe;
    height:16px;
    line-height:16px;
}
.border_b_set{
    border-bottom:1px solid #f4f4f5;
}
span.margin_t_2{
    margin-top:2px;
}
.border_b{
    border-bottom:2px solid #0088ff;
}
#div_other_forum{
    color:#333;
    font-size:14px;
}
#div_my_forum{
    color:#333;
    font-size:14px;
}
.area_operation_btn_xia em{
    width:48px;
    height:7px;
    position: absolute;
    top: 0;
    left: 340px;
    display: inline-block;
    overflow: hidden;
    background:url(${path}/apps_res/doc/images/Knowledge_center.png${v3x:resSuffix()}) no-repeat -64px 0;
    _background:url(${path}/apps_res/doc/images/Knowledge_center.png${v3x:resSuffix()}) no-repeat -64px 0;
}
.area_operation_btn_shang em{
    width:48px;
    height:7px;
    position: absolute;
    top: -8px;
    left: 340px;
    display: none;
    overflow: hidden;
    background:url(${path}/apps_res/doc/images/Knowledge_center.png${v3x:resSuffix()}) no-repeat -16px 0;
    _background:url(${path}/apps_res/doc/images/Knowledge_center.png${v3x:resSuffix()}) no-repeat -16px 0;
}
.area_operation_btn{
    height:0;
    background:none;
}
.area_operation{
    border:none;
    position: absolute;
    top:0;
    left:0;
    height:22px;
}
#docNavigation{
    border-bottom:1px solid #e9eaec;
    width:697px;
    height:14px;
    padding:0 10px;
    background:#f9f9f9;
}
#docNavigation>a{
    display:none;
}
.file_box_area{
    width:212px;
    background:#f9f9f9;
    border:1px solid #e9eaec;
}
.border_t_set{
    border-top:1px solid #f1f1f2;
}
.file_box_area_title>a{
    display: inline-block;
    height: 14px;
    max-width:150px;
    overflow: hidden;
    word-wrap: break-word;
    word-break: break-all;
    white-space: nowrap;
    text-overflow: ellipsis;
}
.set_color_b{
    color:#296fbe;
    font-weight:800;
}
.area_operation_item a.current{
    color:#296fbe;
    font-weight:800;
}
.set_maxWidth{
    width:100%;
    max-width:74px;
}
.common_button:active{
    border: 1px solid #0088ff;
    background-position: left -80px;
    background: #fff;
    color: #656565;
}
.jieyue{
    position:relative;
    height:21px;
}
.jieyue>#uuser{
    position:absolute;
    top:50%;
    margin-top:-11px;
    left:0;
}
.jieyue span.span1{
    position:absolute;
    top:50%;
    margin-top:-10px;
    left:36px;
}
.jieyue>#title{
    position:absolute;
    top:50%;
    margin-top:-10px;
    left:85px;
}
#title>span{
    margin-left:25px;
    max-width:75px;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
}
.jieyue span#styleId{
    position:absolute;
    top:50%;
    margin-top:-8px;
    left:90px;
}
.jieyue span.span2{
    position:absolute;
    top:50%;
    margin-top:-8px;
    left:182px;
}
.clearfix>a.set_height_color{
    height:16px;
    line-height: 16px;
    color:#296fbe;
}
.clearfix>a.set_height_color:hover{
    color:#318ed9;
}
.bj_color_w{
    background: #fff;
}
.clearfix > a.set_visible{
    height:16px;
    line-height:16px;
    color:#296fbe;
}
.clearfix > a.set_visible:hover{
    color:#318ed9;
}
.border_b_e9eaec{
    border-bottom:1px solid #e9eaec;
}
#myajaxgridbar{
    position:absolute;
    left:0;
    bottom:0;
    height:30px;
    width:100%;
    background: #f7f8f9;
}
#myajaxgridbar>a{
    position: absolute;
    left:50%;
    margin-left:-24px;
    top:50%;
    margin-top:-8px;
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
                <img class="left margin_r_20 hand radius" id="imgPersonCardId" width="64" height="64" src="${v3x:avatarImageUrl(CurrentUser.id)}" />
                <p class="set_mt_18 clearFlow font_size14">
                <strong class="left margin_r_5">
                <span class="userName" userId="${personStaut.userId}">${personStaut.userName}</span>
                </strong>
                <c:set var="medal" value="medals_${personStaut.degree}"></c:set>
                <c:choose>
                    <c:when test="${personStaut.showXunzhang}">
                		<span id="levelinfo" onclick="levelinfoDialog()" class="ico24 ${medal}" title=" ${personStaut.personScore}${personStaut.shortScore}${ctp:i18n('doc.knowledge.level.info')}"></span>
                	</c:when>
                </c:choose>
                <c:if test="${ctp:hasResourceCode('F04_docIndex') == true}">
                    <a href="javascript:fnToLocation('${path}/doc.do?method=docIndex&openLibType=1','${ctp:i18n('doc.tree.struct.lable')}');" class="common_button right margin_l_5 resCode" style="margin-right:20px;" title="${ctp:i18n('doc.jsp.knowledge.go.knowledge.doclib')}">${ctp:i18n('doc.jsp.knowledge.go.knowledge.doclib')}</a>
                </c:if>
                <c:if test="${ctp:hasResourceCode('F04_knowledgeSquareFrame') == true}">
                    <a href="javascript:fnToLocation('${path}/doc/knowledgeController.do?method=toKnowledgeSquare','${ctp:i18n('doc.jsp.knowledge.knowledge.square')}');"  class="common_button right margin_l_5 resCode" title="${ctp:i18n('doc.jsp.knowledge.go.knowledge.square')}">${ctp:i18n('doc.jsp.knowledge.go.knowledge.square')}</a>
                </c:if>
                <a href="javascript:fnToLocation('${path}/doc/knowledgeController.do?method=personalShare','${ctp:i18n('doc.jsp.knowledge.share')}');"  class="common_button common_button_emphasize right margin_l_5" title="${ctp:i18n('doc.jsp.knowledge.share')}">${ctp:i18n('doc.jsp.knowledge.share')}</a>
                <span class="right color_gray">${ctp:i18n('doc.jsp.knowledge.have.share.my')}&nbsp;<strong class="color_black">${personStaut.shareNum}</strong>&nbsp;${ctp:i18n('doc.jsp.knowledge.have.share.pieces')}</span>
                </p>
            	<p class="set_color_3 margin_t_10 font_bold" >${personStaut.medal}</p>
                <div class="clearFlow line_height200 margin_r_10">
                    <p class="set_color_6 left color_gray">${personStaut.department.name} ${personStaut.orgPost.name}</p>
                </div>
            </div>
            <div class="area_menu" id="divPageTab">
                <div id="a_style" class="clearfix">
                    <a id="docRead" >${ctp:i18n('doc.jsp.knowledge.my.read')}<em></em></a>
                    <a id="docTrends" >${ctp:i18n('doc.jsp.knowledge.dynamic')}<em></em></a>
                    <a id="docComment" >${ctp:i18n('doc.jsp.knowledge.evaluation')}<em></em></a>
                    <a id="myKnowledgeLib" >${ctp:i18n('doc.contenttype.knowledge')}<em></em></a>
                </div>
                <p class="zhanwei"></p>
            </div>
            <div id="contentArea">
                <div id="recentlyRead" class="zszx_title_area">
                    <span class="set_underLine left font_size14">${ctp:i18n('doc.jsp.knowledge.recent.read')}</span>
                </div>
                <div id="latestCollect" class="zszx_title_area">
                    <span class="left font_size14">${ctp:i18n('doc.jsp.knowledge.recent.collect')}</span>
                    <div class="right margin_t_5"><a id="docMoreCollect" href="javascript:void(0);">${ctp:i18n('doc.jsp.knowledge.more')}</a></div>
                </div>
           </div>
           <div id="isPaging" class="display_none">
                <%@ include file="/WEB-INF/jsp/apps/doc/flipInfoBar.jsp"%>
           </div>
        </div>
        <div class="area_sub margin_l_10">
            <div class="set_border clearFlow border_all">
                <div id="docLearn" class="bg_color_blueF padding_lr_10 border_b_gray2">
                    <strong>${ctp:i18n('doc.jsp.home.label.learn')}</strong>
                    <div id="docLearnMore" class="align_right">
                        <a style="font-size:12px;" href="${path}/doc.do?method=docLearningMore&from=knowledgeCenter">${ctp:i18n('doc.jsp.knowledge.more')}</a>
                    </div>
                </div>
                <ul id="ulwithlis_docLearn" class="clearFlow area_learn2 line_height160 padding_lr_5 padding_b_5" ></ul>
            </div>
            <div class="set_border clearFlow margin_t_10 border_all">
                <div class="bg_color_blueF padding_lr_10 padding_tb_5 border_b_gray2">
                    <strong>${ctp:i18n('doc.jsp.knowledge.other.borrow')}</strong>
                    <div style="display:inline-block;float:right;" class="align_right">
                        <a style="font-size:12px;" href="${path}/doc/knowledgeController.do?method=link&prefix=personal&path=borrowHandle">${ctp:i18n('doc.jsp.knowledge.go.handle')}</a>
                    </div>
                </div>
                <c:set var="attachment" value="<span class='span2 ico16 affix_16 margin_l_0'></span>"/>
                <c:choose>
                    <c:when test="${borrowListEmpty}">
                        <div class="bj_color_w color_gray align_center padding_10">${ctp:i18n('doc.knowledge.blank.warning')}</div>
                    </c:when>
                    <c:otherwise>
                        <ul class="clearFlow line_height180 padding_5" style="background: #fff;">
                            <c:forEach items="${borrowList}" var="borrowDoc" varStatus="index">
                            <li class="clearFlow margin_t_5">                    
                                <img id="personCard${index.index}" userId="${borrowDoc.borrowUserId}" ${borrowDoc.borrowUserValid?"onclick='javascript:fnPersonCard(this);'":""}  class="radius hand left margin_r_5 ${borrowDoc.borrowUserValid?'':'common_disable'}" userId="${borrowDoc.borrowUserId}" width="20" height="20" src="${borrowDoc.borrowUserImg}" />
                                <div class="clearFlow">
                                    <p class="jieyue">
                                        <a id='uuser' ${borrowDoc.borrowUserValid?"onclick='javascript:fnPersonCard(this);'":"class='disabled_color'"} userId="${borrowDoc.borrowUserId}">${ctp:toHTML(borrowDoc.borrowUserName)}</a>
                                        <span class="span1 margin_b_3">:${ctp:i18n('doc.jsp.knowledge.apply.borrow')}:</span>
                                        <span id="styleId" class="margin_b_3 ico16 fileType2_${borrowDoc.styleId}"></span>
                                        <a id="title" href="#" title="${ctp:toHTMLAlt(borrowDoc.frName)}" onClick="fnOpenKnowledge('${borrowDoc.docId}');">
                                       <span class="margin_b_3">${ctp:toHTML(borrowDoc.frName)}</a>${borrowDoc.hasAttachments ? attachment :''}</span>
                                    </p>
                                    <p class="align_right color_gray padding_r_5">
                                        ${ctp:formatDateByPattern(borrowDoc.borrowTime,'MM-dd HH:mm')}
                                    </p>
                                </div>
                            </li>
                            </c:forEach>
                        </ul>
                        
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="set_border clearFlow margin_t_10 border_all">
                <div id="knowledgeLink" class="bg_color_blueF padding_lr_10 padding_tb_5 border_b_gray2">
                    <strong>${ctp:i18n('doc.jsp.knowledge.list.my.knowledge.link')}</strong>
                    <div id="knowledgeLinkSet" class="align_right">
                        <a onclick="openPensonalLink()"style="font-size:12px;">${ctp:i18n('doc.jsp.knowledge.knowledge.link.config')}</a>
                        <a id="hrefKnowledgeLinkMoreId" href="${path}/portal/linkSystemController.do?method=linkSystemMore&doType=${knowledgeLink_doType}"style="font-size:12px;">${ctp:i18n('doc.jsp.knowledge.more')}</a>
                    </div>
                </div>
                <div id="div_knowledgeLink" class="line_height200 clearfix padding_tb_5" ></div>
                
            </div>
        </div>
    </div>
    <div id="docUploadDiv" style="visibility:hidden"><div><v3x:fileUpload applicationCategory="3" /></div></div>
    <iframe id="emptyIframe" style="display:none;" name="emptyIframe" frameborder="0"
            height="0" width="0" scrolling="no" marginheight="0" marginwidth="0" />
</form>
</body>
</html>
