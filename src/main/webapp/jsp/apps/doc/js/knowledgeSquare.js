<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
var userValidMsg="${ctp:i18n('doc.alert.user.inexistence')}";
var pageObject=new Object();
v3x.loadLanguage("/apps_res/doc/i18n");
var jsURL = "/seeyon/doc.do";
var jsURI = "/seeyon/doc/knowledgeController.do";
var LockStatus_AppLock = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.AppLock.key()%>";
var LockStatus_ActionLock = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.ActionLock.key()%>";
var LockStatus_DocInvalid = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.DocInvalid.key()%>";
var LockStatus_None = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.None.key()%>";
var LOCK_MSG_NONE = "<%=com.seeyon.apps.doc.util.Constants.LOCK_MSG_NONE%>";
//单位宣传区，
var kpManager = new knowledgePageManager();
var ajaxPropagandaBean = new Object();

$(function(){
    pageObject.insert=false;
	GoTo_Top({ showHeight: 100, marginLeft: 990 });
	var knowledgeManagerAjax = new knowledgeManager();
	 //隐藏左边
    if(getA8Top()){
        if(getA8Top().hideLeftNavigation){
            getA8Top().hideLeftNavigation();
        }
    }
	
	//知识贡献榜
	knowlegeRanking("total");
	$('#total').addClass('page_color').siblings().removeClass('page_color');
	$('#week').click(function(){
		$('#week').addClass('page_color').siblings().removeClass('page_color');
		$('#knowledgeRanking').html('');
		openProce();
		knowlegeRanking("week");
	});
	
	$('#month').click(function(){
		$('#month').addClass('page_color').siblings().removeClass('page_color');
		$('#knowledgeRanking').html('');
		openProce();
		knowlegeRanking("month");
	});

	$('#total').click(function(){
		$('#total').addClass('page_color').siblings().removeClass('page_color');
		$('#knowledgeRanking').html('');
		openProce();
		knowlegeRanking("total");
	});
	
	//单位学习区
	kpManager.getAccountPropaganda(ajaxPropagandaBean, {
        success: function(list){
            var strHtml = "";
            for(var i=0; i < list.length; i++) {
                var o = list[i];
                var icoClass = "ico32 fileType_"+o.docLearning.docResource.mimeTypeId+" margin_r_10 left";
                var docTitle = o.docName;
                
                strHtml += "<li><span class='" + icoClass
                    +"'></span><div class='clearFlow'>   <a href=\"javascript:fnOpenKnowledge('"
                    +o.docLearning.docResource.id+"');\" class='t color_black' title='"+docTitle+"'>" + docTitle.getLimitLength(22,"..")
                    +"</a><p class='color_gray2 margin_t_5'>${ctp:i18n('doc.jsp.home.learn.push.people')}：<a onclick=\"javascript:personCard('"+o.createrUserId+"');\" title='"+o.recommender+"'>"+o.recommender.getLimitLength(8,"..")
                    +"</a>("+o.recommendTimeStr
                    +")</p></div></li>";
            }
            if(list.length == 0){
                strHtml = "<div class=\"align_center padding_tb_10 color_gray\"><img class=\"valign_m margin_r_10\" src=\"${path}/skin/default/images/zszx_empty.png\" />${ctp:i18n('doc.jsp.no.content.label')}</div>";
            }else{
                $("#divPropagandaId").addClass("align_right border_t padding_t_5").html("<a href='javascript:toAccountPropaganda();'>${ctp:i18n('doc.jsp.knowledge.more')}</a>");
            }
            $('#propagandaUL').html(strHtml);
        }
    });
});

/**
 * 人员卡片
 */
function personCard(userId) {
    $.PeopleCard({
        memberId : userId
    });
}

//知识统计
function knowlegeStatistics(){
    var params = new Object();
    knowledgeManagerAjax.findKnowledgeStatistics(params,{
        success: function(flipInfo){
            var result = flipInfo.data;
            if (result.length > 0) {
                $('#divDocTotal').removeClass("display_none");
                $('#knowlegeStatistics').removeClass("display_none");
                var dataStr="";
                for(var i=0; i<result.length; i++){
                    var userName = result[i].createUserName;
                    var userNameShort = result[i].createUserNameShort;
                    var docCount = result[i].docCount;
                    var imgUrl = result[i].userImageSrc;
                    
                    var userId = result[i].createUserId;
                    var liStr = "";
                    if(result[i].createUserValid!=null&&result[i].createUserValid){
                        liStr = "<li class=\"clearFlow padding_tb_5 padding_lr_10\"><img id=\"img"+i+"\" userId=\"" + userId + "\" onclick='$.PeopleCard({memberId:\"" + userId + "\"});' class=\"radius hand left margin_r_10\" width=\"20\" height=\"20\" src=\""+imgUrl+"\" />" +
                        "<a onclick='javascript:$.PeopleCard({memberId:\"" + userId + "\"});' title='"+userName+"' class=\"left line_height180\">"+userNameShort+"</a><span class=\"right line_height180 color_gray\">"+docCount+"</span></li>";
                    }else{
                        liStr = "<li class=\"clearFlow padding_tb_5 padding_lr_10\"><img id=\"img"+i+"\" userId=\"" + userId + "\" title='"+userValidMsg+"' class=\"radius left margin_r_10 common_disable\" width=\"20\" height=\"20\" src=\""+imgUrl+"\" />" +
                        "<a href=\"javascript:void(0);\" class=\"left line_height180 disabled_color\" title='"+userValidMsg+"' >"+userNameShort+"</a><span class=\"right line_height180 color_gray\">"+docCount+"</span></li>";
                    }
                    dataStr += liStr;
                }
                
                $('#knowlegeStatistics').html(dataStr);
                //绑定人员卡片  huangfj  20130524 性能问题  屏蔽迷你卡片
//                var $el;
//                for(var i=0; i<result.length; i++){
//                    if(result[i].createUserValid!=null&&result[i].createUserValid){
//                        $el = $("#img"+i);
//                        $el.PeopleCardMini({memberId: $el.attr("userId")});
//                    }
//                }
            } else {
                $('#divDocTotal').addClass("display_none");
                $('#knowlegeStatistics').addClass("display_none");
                var strHtml = "<div class=\"color_gray align_center padding_10\">${ctp:i18n('doc.knowledge.blank.warning')}</div>";
                if(!pageObject.insert){
                    pageObject.insert=true;
                    $(strHtml).insertAfter("#docTotalLable");
                }
               
            }
            
        }
    });
}


//知识贡献榜
function knowlegeRanking(dateType){
    var params = new Object();
    params.dateType = dateType;
    params.rankSize = 10;
    params.unitId = $.ctx.CurrentUser.loginAccount;
    knowledgeManagerAjax.queryKnowledgeRankingByDateType(params,{
        success: function(flipInfo){
            var result = flipInfo.data;
            if (result.length > 0) {
                $('#empty').remove();
                $('#knowledgeRanking').removeClass("display_none");
                $('#knowledgeRankingMore').removeClass("display_none");
                for(var i=0; i<result.length; i++){
                    var userName = result[i].userName;
                    var userNameShort = result[i].userNameShort;
                    var totalScore = result[i].totalScore;
                    var imgUrl = result[i].userImageSrc;
                    var levelStyle = "<em class=\"relation_ico left margin_r_5 padding_tb_5\">"+eval(i+1)+"</em>";
                    if(i>2){
                        levelStyle = "<em class=\"relation_ico left margin_r_5 padding_tb_5 relation_gray\">"+eval(i+1)+"</em>";
                    }
                    var userId = result[i].userId;
                    var liStr = "<li class=\"clearFlow padding_tb_5 padding_lr_10\">" + levelStyle +"<img id=\"img1"+i+"\" userId=\"" + userId + "\" onclick='$.PeopleCard({memberId:\"" + userId + "\"});' class=\"hand left margin_r_5 radius\" width=\"20\" height=\"20\" src=\""+imgUrl+"\" />" +
                            "<a onclick='$.PeopleCard({memberId:\"" + userId + "\"});' title='"+userName+"' class=\"left line_height180\">"+userNameShort+"</a><span class=\"right line_height180 color_gray\">"+totalScore+"</span></li>";
                    
                    if(result[i].userValid!=null&&!result[i].userValid){//离职人员处理
                        liStr = "<li class=\"clearFlow padding_tb_5 padding_lr_5\">" + levelStyle +"<img id=\"img1"+i+"\" title='"+userValidMsg+"' userId=\"" + userId + "\" class=\"hand left margin_r_5 radius common_disable\" width=\"20\" height=\"20\" src=\""+imgUrl+"\" />" +
                        "<a href=\"javascript:void(0);\" title='"+userValidMsg+"' class=\"left line_height180 disabled_color\">"+userNameShort+"</a><span class=\"right line_height180 color_gray\">"+totalScore+"</span></li>";
                    }
                    $(liStr).appendTo('#knowledgeRanking');
                }
                //绑定人员卡片  huangfj  20130524 性能问题  屏蔽迷你卡片
//                var $el;
//                for(var i=0; i<result.length; i++){
//                    if(result[i].userValid!=null&&result[i].userValid){
//                        $el = $("#img1"+i);
//                        $el.PeopleCardMini({memberId: $el.attr("userId")});
//                    }
//                }
            } else {
                $('#empty').remove();
                $('#knowledgeRanking').addClass("display_none");
                $('#knowledgeRankingMore').addClass("display_none");
                var strHtml = "<div id=\"empty\" class=\"color_gray align_center padding_10\">${ctp:i18n('doc.knowledge.blank.warning')}</div>";
                $(strHtml).insertAfter("#rankScope");
            }
            closeProce();
        }
    });
}

function toAccountPropaganda(){
    window.location = jsURL + "?method=docLearningMore&accountId="+$.ctx.CurrentUser.loginAccount+"&from=knowledgeSquare";
}
function toDocLib(){
//    if(window.parent){
//        if(window.parent.document.title){
//            window.parent.document.title="${ctp:i18n('doc.tree.struct.lable')}";
//        }
//    }
    window.location = jsURL + "?method=docIndex&openLibType=1";
}
function toPersonalKnowledgeCenter(){
//    if(window.parent){
//        if(window.parent.document.title){
//            window.parent.document.title="${ctp:i18n('doc.jsp.knowledge.center')}";
//        }
//    }
    window.location = jsURI + "?method=personalKnowledgeCenterIndex&openFlag=docRead";
}

/**
 * 关闭滚动阻塞
 */
function closeProce(){
    if(pageObject.proce){
        pageObject.proce.close();
        pageObject.proce = null;
    }
}

/**
 * 开启滚动阻塞
 */
function openProce(){
    if(pageObject.proce==null){
        pageObject.proce = $.progressBar(); 
    }
}