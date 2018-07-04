<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
var userValid = "${ctp:i18n('doc.alert.user.inexistence')}";
var pageObject=new Object();
var docActionUseManagerAjax = new docActionUseManager();
var knowledgeManagerAjax = new knowledgeManager();

var currentUserId = $.ctx.CurrentUser.id;
var myDocLib = '${myLibId}';
var focusFolderId = '${myLibId}';

var openFlag = "${v3x:escapeJavascript(param.openFlag)}";
var wholeFolderId = focusFolderId;

$(function(){
    pageObject.queryAlert = "${ctp:i18n('doc.knowledge.query.blank.alert')}!";
    GoTo_Top({ showHeight: 100, marginLeft: 990 });
    fnRizeHeight();
    /*收藏*/
    $("#docMoreCollect").click(fnleastCollectMore);
    /*我读*/
    $('#docRead').click(fnMyRead);
    /*动态*/
    $('#docTrends').click(fnDynamic);
    /*评论*/
    $('#docComment').click(fnDocComment);
    /*我的知识库*/
    $('#myKnowledgeLib').click(fnMyDocLib);
    //刷新页面
    fnReload();
    //载入我的知识链接
    fnLoadMyKnowledgeLink();
});

//页面刷新的快捷方法
function fnReload(){
    if ("docTrends" == openFlag) {//动态
        $('#docTrends').click();
    } else if ("docComment" == openFlag) {
    	$(".search_buttonHand").click();
    } else if ("mydocComment" == openFlag) {
    	$(".search_buttonHand").click();
    } else if ("myKnowledgeLib" == openFlag) {
        $('#myKnowledgeLib').click();
    } else if ("docMoreCollect" == openFlag) {
        var oSearchBar = $(".search_buttonHand");
        if(oSearchBar.size()>0){
            oSearchBar.click();
        }else{
            fnleastCollectMore();
        }
    } else if ("docRecommendMore" == openFlag) {//推荐更多
        fnDocRecommendMore();
    } else if ("docTrends0" == openFlag) {//我的订阅
    	$("a[name='A_get0']").click();
    }  else if ("docTrends1" == openFlag) {//组织推送
    	$(".search_buttonHand").click();
    } else if ("docTrends2" == openFlag) {//他人推荐
    	$(".search_buttonHand").click();
    } else if ("docTrends4" == openFlag) {//收藏更多
    	$(".search_buttonHand").click();
    }  else if (openFlag.substr(0,13)=="docNavigator_") {//
    	$(".search_buttonHand").click();
    } else {
        $('#docRead').click();
    }
}

//推荐更多
function fnDocRecommendMore(){
    $('#docTrends').addClass('current').siblings().removeClass('current');
    $('#contentArea').html("<a id=\"initDocRecommendMore\" name=\"A_get2\" index=\"2\" class=\"right\" href=\"javascript:void(0);\"></a>");
    initDynamic();
    // 初始加载所有他人推荐
    $("#initDocRecommendMore").click();
}

//动态
function fnDynamic(){
    //ling start
    $(".zhanwei").css("background","#fff");
    //ling end
    openFlag = "docTrends";
    openProce();
    getA8Top().frames['main'].refreshFlag = 'docTrends';
    $(this).addClass('current').siblings().removeClass('current');
    $('#contentArea').html("<a id=\"initDynamicContent\" name=\"A_get3\"  index='3' class=\"right\" href=\"javascript:void(0);\"></a>");
    initDynamic();
    // 初始加载所有动态
    $("#initDynamicContent").click();
}

//评论    他人评价和我的评价数据
function fnDocComment(){
    //ling start
    $(".zhanwei").css("background","#fff");
    //ling end
    openFlag = "docComment";
    openProce();
    getA8Top().frames['main'].refreshFlag = 'docComment';
    $(this).addClass('current').siblings().removeClass('current');
    $('#isPaging').removeClass('display_none');
    $('#contentArea').html("<div class=\"border_b_e9eaec clearfix\"><div id=\"div_other_forum\" class=\"display_inline-block padding_lr_10 border_b margin_t_5 padding_b_5 hand left\">${ctp:i18n('doc.jsp.knowledge.others.evaluation')}</div><div id=\"div_my_forum\" class=\"display_inline-block padding_lr_10 margin_t_5 padding_b_5 hand left\">${ctp:i18n('doc.jsp.knowledge.my.evaluation')}</div><div id=\"searchDiv_forum\" class=\"right\"></div></div><ul id=\"ulwithlis_docForum\" class=\"bg_color_white clearfix margin_t_10\"></ul>");
    var queryObj = new Object();
    queryObj.userId = currentUserId;
    queryObj.flag = 1; // 他人评论
    
    $('#ajaxgridbar').ajaxgridbar({
        managerName : 'knowledgePageManager',
        managerMethod : 'getDocForum',
        callback : function(fpi) {
        	var lisObj = $('#ulwithlis_docForum'), strHtml = new StringBuffer();
            var hasAttr = "<span class='ico16 affix_16'></span>"; 
            lisObj.html("");
            if(queryObj.flag==1) { // 他人评论
            	openFlag = "docComment";
                for (var i = 0, len = fpi.data.length; i < len; i++) {
                    var o = fpi.data[i];
                    var isDocCreateUser = (currentUserId === o.docCreateUserId);
                    strHtml.append("<li class='padding_tb_10 border_b_set'><img id='personCard-");
                    strHtml.append(i.toString());
                    strHtml.append("' userId='");
                    strHtml.append(o.createUserId);
                    if(o.createUserValid!=null&&o.createUserValid){//离职人员处理
                        strHtml.append("' class='radius left margin_b_10 margin_r_20 hand' src='" + fpi.data[i].userImageSrc + "' width='42' height='42' onclick='$.PeopleCard({memberId:\"");
                        strHtml.append(o.createUserId);
                        strHtml.append("\"});' /><div class='over_auto_hiddenY'><div class='clearfix'><span class='left'><a onclick='javascript:$.PeopleCard({memberId:\"");
                        strHtml.append(o.createUserId);
                        strHtml.append("\"});' class='left margin_r_5' title='"+dealMeTxt(o.createUserName)+"'>");
                    }else{
                        strHtml.append("' class='radius left margin_l_10 margin_b_10 margin_r_20 hand common_disable' src='" + fpi.data[i].userImageSrc + "' width='42' height='42'");
                        strHtml.append(o.createUserId);
                        strHtml.append(" title='"+userValid+"'/><div class='over_auto_hiddenY'><div class='clearfix'><span class='left'><a href='javascript:void(0);' ");
                        strHtml.append(o.createUserId);
                        strHtml.append(" title='"+userValid+"' class='left margin_r_5 disabled_color'>");
                    }
                   
                    strHtml.append(fnSubString(o.createUserName,6));
                    var target ="${ctp:i18n('doc.jsp.knowledge.forum.evalulate.label')}${ctp:i18n('doc.contenttype.mydoc')}";
                    if(o.parentForumId!=0){//对评论回复
                        target = "${ctp:i18n('doc.jsp.knowledge.forum')}";
                        //离职人员处理
                        if(o.parentCreateUserValid != null && o.parentCreateUserValid){
                            target += "<a onclick='javascript:$.PeopleCard({memberId:\"";
                            target += o.parentForumUserId;
                            target += "\"});' class='margin_lr_5' title='"+dealMeTxt(o.parentForumUserName)+"'>";
                        }else{
                            target += "<a href='javascript:void(0);' ";
                            target += " title='"+userValid+"' class='margin_lr_5 disabled_color'>";
                        }
                        target += fnSubString(o.parentForumUserName,4);
                        target += "</a>";
                        if($.ctx.CurrentUser.id === o.docCreateUserId){
                            target += "${ctp:i18n('doc.jsp.knowledge.forum.reply.3')}";
                        }else{
                            target += "${ctp:i18n('doc.jsp.knowledge.forum.reply.2')}" ;
                            //离职人员处理
                            if(o.docCreateUserValid != null && o.docCreateUserValid){
                                target += "<a onclick='javascript:$.PeopleCard({memberId:\"";
                                target += o.docCreateUserId;
                                target += "\"});' class='margin_lr_5' title='"+dealMeTxt(o.docCreateUserName)+"'>";
                            }else{
                                target += "<a href='javascript:void(0);' ";
                                target += " title='"+userValid+"' class='margin_lr_5 disabled_color'>";
                            }
                            target += fnSubString(o.docCreateUserName,4);
                            target += "</a>";
                            
                            target += "${ctp:i18n('doc.jsp.knowledge.forum.reply.4')}" ;
                        }
                    }
                    
                    strHtml.append("</a><span class='left margin_r_10'>"+target+"</span><span class='left ico16 fileType2_");
                    strHtml.append(o.docMimeTypeId);
                    strHtml.append(" margin_r_5'></span><a href='javascript:fnOpenKnowledge(\"");
                    strHtml.append(o.docResourceId);
                    strHtml.append("\", 1);' title=\"");
                    strHtml.append(o.frName);
                    strHtml.append("\" class='left margin_r_5'>${ctp:i18n('doc.jsp.knowledge.doc.leftBook')}");
                    strHtml.append(o.frNameLimtLen);
                    var hasAttachments = o.hasAttachments ?hasAttr:'';
                    strHtml.append(hasAttachments);
                    strHtml.append("${ctp:i18n('doc.jsp.knowledge.doc.rightBook')}</a><span class='left ");
                    strHtml.append(fnGetStarLevelClass(o.avgScore));
                    strHtml.append("' title=\"${ctp:i18n('doc.knowledge.doc.score')}:");
                    strHtml.append(o.avgScore.toString());
                    strHtml.append("\"></span></span><span class='color_gray right'>");
                    strHtml.append(fnEvalTimeInterval(o.recommendTime));
                    strHtml.append("</span></div><div class='margin_t_5 word_break_all'>");
                    strHtml.append(o.description);
                    if(o.recommendEnable) {
                         strHtml.append("</div><div class='clearfix margin_t_10'><span class='right margin_l_10'><a href='javascript:doc_recommend(\"");
                         strHtml.append(o.docResourceId);
                         strHtml.append("\",");
                         strHtml.append(o.recommendEnable.toString());
                         strHtml.append(");'>${ctp:i18n('doc.jsp.knowledge.recommend')}(");
                    } else {
                        strHtml.append("</div><div class='clearfix margin_t_10'><span class='right margin_l_10 color_gray'>${ctp:i18n('doc.jsp.knowledge.recommend')}(");
                    }
                    strHtml.append(o.recommendCount.toString());
                    strHtml.append(")</a></span><span class='right margin_l_10 color_gray'>${ctp:i18n('doc.jsp.knowledge.evaluation')}(");
                    strHtml.append(o.commentCount.toString());
                    strHtml.append(")</span><span class='right margin_l_10 color_gray'>${ctp:i18n('doc.menu.download.label')}(");
                    strHtml.append(o.downloadCount.toString());
                    //非个人库，个人库，但是创建者不是自己均可以收藏
                    if((!o.isPersonLib &&(o.potent.all || o.potent.read || o.potent.create || o.potent.edit || o.potent.readOnly))||(o.isPersonLib && !isDocCreateUser )){
                        strHtml.append(")</span>");
                        
                        var sHide = 'display_none',sShow ='';
                        if(o.collect){//显示取消收藏
                            sShow = sHide;
                            sHide = '';
                        }                        
                        //收藏
                        strHtml.append("<a id='favoriteSpan"+o.docResourceId+i+"' href='javascript:favorite(\"3\", \""); 
                        strHtml.append(o.docResourceId+"\", false, 3,"+i+");'");
                        strHtml.append(" class='set_visible right margin_l_10 "+sShow+"'>${ctp:i18n('doc.jsp.knowledge.collection')}(");
                        strHtml.append(o.collectCount.toString());
                        strHtml.append(")</a>");
                        
                        //取消收藏
                        strHtml.append("<a id='cancelFavorite"+o.docResourceId+i+"' href='javascript:void(0);' onclick='cancelFavorite(3,\""); 
                        strHtml.append(o.docResourceId+"\",false,3,"+i+");'");
                        strHtml.append(" class='set_visible right margin_l_10 "+sHide+"'>${ctp:i18n('doc.jsp.cancel.collection')}(");
                        strHtml.append(o.collectCount.toString());
                        strHtml.append(")</a>");
                        
                        strHtml.append("</div></div></li>");
                    }else{
                        strHtml.append(")</span><span class='right margin_l_10 color_gray'>${ctp:i18n('doc.jsp.knowledge.collection')}(");
                        strHtml.append(o.collectCount.toString());
                        strHtml.append(")</span></div></div></li>");
                    }
                } ;
            } else {// 我的评论
            	openFlag = "mydocComment";
                for ( var i = 0, len = fpi.data.length; i < len; i++) {
                    var o = fpi.data[i];
                    var isDocCreateUser = (currentUserId === o.docCreateUserId);
                    strHtml.append("<li class='padding_tb_10 border_b_set'><img id='personCard-");
                    strHtml.append(i.toString());
                    strHtml.append("' userId='");
                    strHtml.append(o.createUserId);
                    
                    if(o.createUserValid!=null&&o.createUserValid){//离职人员处理
                        strHtml.append("' class='radius left margin_b_10 margin_r_20 hand' src='" + fpi.data[i].userImageSrc + "' width='42' height='42' onclick='$.PeopleCard({memberId:\"");
                        strHtml.append(o.createUserId);
                        strHtml.append("\"});' /><div class='over_auto_hiddenY'><div class='clearfix'><span class='left'><a onclick='javascript:$.PeopleCard({memberId:\"");
                        strHtml.append(o.createUserId);
                        strHtml.append("\"});' class='left margin_r_5' title='"+dealMeTxt(o.createUserName)+"'>");
                    }else{
                        strHtml.append("' class='radius left margin_l_10 margin_b_10 margin_r_20 hand common_disable' src='" + fpi.data[i].userImageSrc + "' width='42' height='42' ");
                        strHtml.append(o.createUserId);
                        strHtml.append(" title='"+userValid+"' /><div class='over_auto_hiddenY'><div class='clearfix'><span class='left'><a href='javascript:void(0);'");
                        strHtml.append(o.createUserId);
                        strHtml.append(" title='"+userValid+"' class='left margin_r_5 disabled_color'>");
                        
                    }
                    strHtml.append(fnSubString(o.createUserName,6));
                    var target = "${ctp:i18n('doc.jsp.knowledge.forum.evalulate.label')}";
                    if(o.parentForumId!=0){//对评论回复
                        target = "${ctp:i18n('doc.jsp.knowledge.forum')}";
                        //离职人员处理
                        if(o.parentCreateUserValid != null && o.parentCreateUserValid){//离职人员处理
                            target += "<a onclick='javascript:$.PeopleCard({memberId:\"";
                            target += o.parentForumUserId;
                            target += "\"});' class='margin_lr_5' title='"+dealMeTxt(o.parentForumUserName)+"'>";
                        }else{
                            target += "<a href='javascript:void(0);' ";
                            target += " title='"+userValid+"' class='margin_lr_5 disabled_color'>";
                        }
                        target += fnSubString(o.parentForumUserName,4);
                        target += "</a>";
                        target += "${ctp:i18n('doc.jsp.knowledge.forum.reply.2')}";
                    }
                    
                    strHtml.append("</a><span class='left margin_r_5'>"+target+"</span>");
                    var df="";
                    var docCreateUserName = o.docCreateUserName;
                    
                    if(o.docCreateUserValid != null && o.docCreateUserValid){//离职人员处理
                        strHtml.append("<a onclick='javascript:$.PeopleCard({memberId:\"");
                        strHtml.append(o.docCreateUserId);
                        strHtml.append("\"});' class='left margin_r_5' title='"+dealMeTxt(o.docCreateUserName)+"'>");
                    }else{
                        strHtml.append("<a href='javascript:void(0);' ");
                        strHtml.append(" title='"+userValid+"' class='left margin_r_5 disabled_color'>");
                    }
                    strHtml.append(fnSubString(o.docCreateUserName,6)+"</a>");
                    
                    strHtml.append("<span class='left margin_r_10'>${ctp:i18n('doc.jsp.knowledge.others.doc.label')}");
                    strHtml.append(o.fileType);
                    strHtml.append("</span><span class='left ico16 fileType2_");
                    strHtml.append(o.docMimeTypeId);
                    strHtml.append(" margin_r_5'></span><a href='");
                    if (isDocCreateUser) {
                        strHtml.append("javascript:fnOpenKnowledge(\"");
                        strHtml.append(o.docResourceId);
                        strHtml.append("\");");
                    } else {
                        strHtml.append("javascript:fnOpenKnowledge(\"");
                        strHtml.append(o.docResourceId);
                        strHtml.append("\");");
                    }
                    strHtml.append("'  title=\"");
                    strHtml.append(o.frName);
                    strHtml.append("\" class='left margin_r_5'>${ctp:i18n('doc.jsp.knowledge.doc.leftBook')}");
                    strHtml.append(o.frNameLimtLen);
                    var hasAttachments = o.hasAttachments ?hasAttr:'';
                    strHtml.append(hasAttachments);
                    strHtml.append("${ctp:i18n('doc.jsp.knowledge.doc.rightBook')}</a><span class='left ");
                    strHtml.append(fnGetStarLevelClass(o.avgScore));
                    strHtml.append("' title=\"${ctp:i18n('doc.knowledge.doc.score')}:");
                    strHtml.append(o.avgScore.toString());
                    strHtml.append("\"></span></span><span class='color_gray right'>");
                    strHtml.append(fnEvalTimeInterval(o.recommendTime));
                    strHtml.append("</span></div><div class='margin_t_5 word_break_all' >");//title='"+unescapeHTML(o.description)+"'
                    strHtml.append(o.description);
                   if(o.recommendEnable) {
                        strHtml.append("</div><div class='clearfix margin_t_10'><span class='right margin_l_10'><a href='javascript:doc_recommend(\"");
                        strHtml.append(o.docResourceId);
                        strHtml.append("\",");
                        strHtml.append(o.recommendEnable.toString());
                        strHtml.append(");'>${ctp:i18n('doc.jsp.knowledge.recommend')}(");
                   } else {
                       strHtml.append("</div><div class='clearfix margin_t_10'><span class='right margin_l_10 color_gray'>${ctp:i18n('doc.jsp.knowledge.recommend')}(");
                   }
                    strHtml.append(o.recommendCount.toString());
                    strHtml.append(")</a></span><span class='right margin_l_10 color_gray'>${ctp:i18n('doc.jsp.knowledge.evaluation')}(");
                    strHtml.append(o.commentCount.toString());
                    strHtml.append(")</span><span class='right margin_l_10 color_gray'>${ctp:i18n('doc.menu.download.label')}(");
                    strHtml.append(o.downloadCount.toString());
                    strHtml.append(")</span>");
                    //非个人库或者个人库，但是创建者不是自己均可以收藏
                    if((!o.isPersonLib && (o.potent.all || o.potent.read || o.potent.create || o.potent.edit || o.potent.readOnly))||(o.isPersonLib && !isDocCreateUser )){
                        strHtml.append("<span class='right margin_l_10'>");
                        
                        var sHide = 'display_none',sShow ='';
                        if(o.collect){//显示取消收藏
                            sShow = sHide;
                            sHide = '';
                        }               
                        //收藏
                        strHtml.append("<a id='favoriteSpan"+o.docResourceId+i+"' href='javascript:favorite(3, \""); 
                        strHtml.append(o.docResourceId+"\", false, 3,"+i+");'");
                        strHtml.append(" class='set_visible right margin_l_10 "+sShow+"'>${ctp:i18n('doc.jsp.knowledge.collection')}(");
                        strHtml.append(o.collectCount.toString());
                        strHtml.append(")</a>");
                        
                        //取消收藏
                        strHtml.append("<a id='cancelFavorite"+o.docResourceId+i+"' href='javascript:void(0);' onclick='cancelFavorite(3,\""); 
                        strHtml.append(o.docResourceId+"\",false,3,"+i+");'");
                        strHtml.append(" class='set_visible right margin_l_10 "+sHide+"'>${ctp:i18n('doc.jsp.cancel.collection')}(");
                        strHtml.append(o.collectCount.toString());
                        strHtml.append(")</a>");
                        
                        
                        strHtml.append("</span>");
                    } else {
                        strHtml.append("<span class='right margin_l_10 color_gray'>${ctp:i18n('doc.jsp.knowledge.collection')}(");
                        strHtml.append(o.collectCount.toString());
                        strHtml.append(")</span>");
                    }
                    strHtml.append("</div></div></li>");
                } ;
            }
            
            if(fpi.data.length==0){
                var infoMessage="${ctp:i18n('doc.jsp.knowledge.read.nullform')}";
                if(queryObj.flag==0){//他人评价
                    infoMessage="${ctp:i18n('doc.jsp.knowledge.read.nullMyform')}";
                }
                if(pageObject.isQuery){
                    infoMessage = pageObject.queryAlert;
                }
                pageObject.isQuery = false;
                var empty = "<div class=\"align_center padding_tb_10 color_gray\"><img class=\"valign_m margin_r_10\" src=\"${path}/skin/default/images/zszx_empty.png\" />"+infoMessage+"</div>";
                lisObj.html(empty);
            }else{
                lisObj.html(strHtml.toString());
            }
            
            $('#_afpPage').val(fpi.page);
            $('#_afpPages').val(fpi.pages);
            $('#_afpSize').val(fpi.size);
            $('#_afpTotal').val(fpi.total);
            
            closeProce();
        }
    });
    $('#ajaxgridbar').ajaxgridbarLoad(queryObj);
    
    var searchobj = $('#searchDiv_forum').searchCondition({
        searchHandler: function () {
            openProce();
            var returnValue = searchobj.g.getReturnValue();
            if(returnValue!=null){
                queryObj.condition = returnValue.condition;
                queryObj.value = returnValue.value;
                
                if(queryObj.value != null && queryObj.value != ""){
                    pageObject.isQuery = true;
                }
            }
            $('#ajaxgridbar').ajaxgridbarLoad(queryObj);
        },
        conditions: [{
            id: 'docName',
            name: 'docName',
            type: 'input',
            text: "${ctp:i18n('doc.jsp.knowledge.query.name')}",
            value: 'res_frName_String_like'
        }, {
            id: 'contentType',
            name: 'contentType',
            type: 'select',
            text: "${ctp:i18n('doc.jsp.knowledge.query.contentType')}",
            value: 'res_frType_Long_equal',
            codecfg : "codeType:'java',codeId:'com.seeyon.apps.doc.manager.DocSearchContentTypeForAssessEnumImpl'"
        }, {
            id: 'keyword',
            name: 'keyword',
            type: 'input',
            text: "${ctp:i18n('doc.jsp.knowledge.query.key')}",
            value: 'res_keyWords_String_like'
            
        }, {
            id : 'alterUser',
            name : 'alterUser',
            type : 'input',
            text : "${ctp:i18n('doc.metadata.def.forumer')}",
            value : 'OMA_name_String_like'
        }, {
            id : 'createUserId',
            name : 'createUserId',
            type : 'input',
            text : "${ctp:i18n('doc.metadata.def.creater')}",
            value : 'OMC_name_String_like'
        }, {
            id: 'alterDate',
            name: 'alterDate',
            type: 'datemulti',
            text: "${ctp:i18n('doc.metadata.def.forumtime')}",
            value: 'dfp_createTime_Date_between',
            ifFormat:'%Y-%m-%d'
        }]
    });
    searchobj.g.hideItem('createUserId',true);
    // *********************** end with 加载他人评价和我的评价搜索框  ***********************//
    
    $("#div_other_forum").click(function() {//他人评论
    	openFlag = "docComment";
        openProce();
        getA8Top().frames['main'].refreshFlag = 'div_other_forum';
        $("#div_other_forum").addClass("border_b");
        $("#div_my_forum").removeClass("border_b");
        queryObj.flag = 1;
        queryObj.condition = "";
        $('#ajaxgridbar').ajaxgridbarLoad(queryObj);
        searchobj.g.showItem('alterUser');
        searchobj.g.hideItem('createUserId',true);
    });
    $("#div_my_forum").click(function() {//我的评论
    	openFlag = "mydocComment";
        openProce();
        getA8Top().frames['main'].refreshFlag = 'div_my_forum';
        $("#div_my_forum").addClass("border_b");
        $("#div_other_forum").removeClass("border_b");
        queryObj.flag = 0;
        queryObj.condition = "";
        $('#ajaxgridbar').ajaxgridbarLoad(queryObj);
        searchobj.g.showItem('createUserId');
        searchobj.g.hideItem('alterUser',true);
    });
}

//我的知识库
function fnMyDocLib(){
    //ling start
    $(".zhanwei").css("background","#f9f9f9");
    //ling end
    openFlag = "myKnowledgeLib";
    openProce();
    getA8Top().frames['main'].refreshFlag = 'myKnowledgeLib';
    $('#myKnowledgeLib').addClass('current').siblings().removeClass('current');
    $('#isPaging').addClass('display_none');
    $('#contentArea').html("");
    $('#contentArea').html("<div class=\"area_operation\" style='*position:relative; *overflow:visible;'><div id=\"docNavigation\" class=\"area_operation_item\"><a class='set_maxWidth' href=\"javascript:showDocOfTheFolder('"+myDocLib+"');\" id=\"docNavigator_"+myDocLib+"\" class=\"current\"><strong class='set_color_b'>${ctp:i18n('doc.jsp.knowledge.all')}</strong></a></div><div class=\"area_operation_btn\" >" +
            "<span class=\"area_operation_btn_shang\"><em></em></span><span class=\"area_operation_btn_xia\"><em></em></span></div></div><div class='clearfix'><style>.common_search_condition{_float:right;}</style><div id=\"searchDiv\" class=\"align_left padding_l_10 padding_t_15 right\"></div></div><div id=\"docContentList\" class=\"clearFlow\"></div>" +
            "<div id=\"myajaxgridbar\" class=\"number\" ><a href=\"javascript:void(0);\" id=\"_afpNext\" >${ctp:i18n('doc.jsp.knowledge.personal.viewMore')}</a></div>");
    var userId = $.ctx.CurrentUser.id;
    //初始化   我的知识库下   文档夹
    knowledgeManagerAjax.getFirstLevelFolder(userId, {
        success: function(levelOneFolders){
            for(var i=0; i<levelOneFolders.length; i++){
                var folderName = levelOneFolders[i].frName;
                var folderId = levelOneFolders[i].id;
                var aStr = "<a class='set_maxWidth' id=\"docNavigator_"+folderId+"\" title=\""+folderName+"\" href=\"javascript:showDocOfTheFolder('"+folderId+"');\">"+folderName+"</a>";
                $(aStr).appendTo('#docNavigation');
            }
            /***********下拉分类****************/
            $(".area_operation_item a").click(function () {
                $(".area_operation_item a").removeClass("current");
                $(this).addClass("current");
            });
            $(".area_operation_btn .area_operation_btn_xia").click(fnBtnXiaClick);
            $(".area_operation_btn .area_operation_btn_shang").click(fnBtnShangClick);
            
            $(".area_operation_item").css({"overflow-y": "auto" });
            
            var obj = new Object();
            obj.folderId = myDocLib;
            obj.columns = 3;
            $('#myajaxgridbar').ajaxgridbarLoad(obj);
        }
    });
    
    //文档内容列表显示
    $('#myajaxgridbar').ajaxgridbar( {
      managerName :'knowledgeManager',
      managerMethod :'findAllDocsByAjax',
      callback : function(fpi) {
        var result = fpi.data;
        var resultLength = result.length;
        fpi.page = fpi.page==0?1:fpi.page;
        if(((fpi.page-1)*fpi.size+resultLength) == fpi.total) {
            $('#myajaxgridbar').addClass('display_none');
            //$("#_afpNext").attr("disabled", "disabled").html("");
        } else {
            $('#myajaxgridbar').removeClass('display_none');
            //$("#_afpNext").removeAttr("disabled").html('查看更多');
        }
        openFlag = "docNavigator_"+wholeFolderId;
        for(var i=0; i<resultLength; i++) {
          var vForDownload = result[i].vForDocDownload;
          var star = fnGetStarLevelClass(result[i].doc.totalScore,result[i].doc.scoreCount);
          var sOpenSquare = result[i].openSquare?"share_":"";
          var icoClass = "ico32 "+sOpenSquare+"fileType_"+result[i].doc.mimeTypeId+" margin_r_5 left";
          var docTitle= result[i].doc.frName.escapeHTML();
          var docName = docTitle.getLimitLength(40,'...');
          var docNameEscapeJS = fnSubString(result[i].doc.frNameEscapeJS,41);
          var docAttsTitle = docName;
          if(result[i].doc.hasAttachments){
              docAttsTitle += "<span class='ico16 affix_16'></span> ";
          }
          var avgScore = fnGetAvgScore(result[i].doc.avgScore);
          var docId = result[i].doc.id;
          var parentId = result[i].doc.parentFrId;
          var docLibId = result[i].doc.docLibId;
          var docType = result[i].doc.frType;
          var docMimeType = result[i].doc.mimeTypeId;
          var _sourceId = result[i].doc.sourceId;
          var createDate = result[i].doc.createTime;
          var collection = result[i].doc.collectCount;
          var recommendCount = result[i].doc.recommendCount;
          var recommendEnable = result[i].doc.recommendEnable;
          var evaluation = result[i].doc.commentCount;
          var sourceType = result[i].doc.sourceType;
          var docUserId = result[i].doc.createUserId;
          var manualCreate = (result[i].doc.mimeTypeId >=22 && result[i].doc.mimeTypeId <=26);
          var colArchive = result[i].doc.mimeTypeId == 1;
          var linkFile = result[i].doc.mimeTypeId == 51 || result[i].doc.mimeTypeId == 61;
          var isLearningDoc = result[i].doc.isLearningDoc;
          var createUserValid = result[i].createUserValid;
          createUserValid = (createUserValid == null)?false:createUserValid
          var author = result[i].name;
          var createTime = result[i].createTime;
          var isOtherType = isPig(docType);
          var display1 = (colArchive || manualCreate || linkFile || isOtherType ) ? "none" : "";
          var display2 = (colArchive || linkFile || isOtherType )? "none" : "";
          var display3 = linkFile ? "none" : "";
          var display4 = isLearningDoc ? "" : "none";
          var display5 = (linkFile|| isOtherType)? "none" : "";
          //第三根线是否显示
          var showLine = "<li class='line'></li>";
          if(display3=='none' && display4=='none'){
              showLine ="";
          }
          var display51 = recommendEnable ? "" : "none";
          var display52 = recommendEnable ? "none" : "";
          var display6 = docType==2 ||docType==3 ||docType==4 ||docType==5 ||docType==6 ||docType==7 ||docType==8 ||docType==9 ||docType==15 ||docType==16;
          var display7 = (result[i].doc.favoriteSource !== null && linkFile ) ? "none" : "";
          var divStyle = ((i+1)%3 == 0) ? "" : "margin_r_42 margin_r_17";
          var isForward = "";
          var forwardColl = "";
          var forwardMail = "";
          var isOpenSquare = result[i].openSquare; 
          if ((canNewColl=="false" && canNewMail=="false") || display3 == "none" || display6) {
            isForward = "none";
          }
          if (canNewColl == "false") {
            forwardColl = "none";
          }
          if (canNewMail=="false") {
            forwardMail = "none";
          }
          var divStr = "<div class=\"file_box_area "+divStyle+" margin_t_20 \"><div class=\"clearfix padding_10\" style=\"padding-left:6px;padding-right:4px;\"><span class=\""+icoClass+"\"></span><div class=\"over_auto_hiddenY left_ie6\"><p class=\"file_box_area_title\" style=\"height:18px;\" title=\""+docTitle+"\"><a href=\"javascript:fnOpenKnowledge(\'"+docId+"\');\">"+docAttsTitle+"</a>";
          /*if(sourceType == '3' || sourceType == '4'){
              divStr = divStr + "<span class=\"ico16 collection_16\"></span>";
          }*/
          divStr = divStr +"</p>";
          if(!isPig(docType)) {
              divStr = divStr + "<span class=\""+star+"\" title=\"${ctp:i18n('doc.knowledge.doc.score')}:"+avgScore+"\"></span>";
          }else{
              divStr = divStr + "<span class='stars0' style=\"background-image: none;\"></span>";
          }
          var cssStr=!createUserValid?("class='left text_overflow disabled_color' style='max-width:40px;display: inline-block;padding:2px 5px;' title='"+userValid+"'"):"class='left text_overflow' style='max-width:40px;display: inline-block;padding:2px 5px;'";
          
          divStr = divStr + "<p class=\"left margin_t_5 color_gray\"><span class='left'>${ctp:i18n('doc.jsp.knowledge.createUser.label')}</span><a id=\"user"+i+"\" "+cssStr+" title='"+dealMeTxt(author)+"' >"+author+"</a>("+createTime+")</p></div></div>"+
          "<div class=\"clearfix border_t_set\">";
          if(!linkFile) {
              divStr += "<span class=\"color_gray left padding_tb_5 padding_l_10\">${ctp:i18n('doc.jsp.knowledge.collection')}("+collection+")&nbsp;${ctp:i18n('doc.jsp.knowledge.evaluation')}("+evaluation+")&nbsp;<a style=\"display:"+display51+"\" href=\"javascript:doc_recommend(\'"+docId+"\', \'"+recommendEnable+"\');\" >${ctp:i18n('doc.jsp.knowledge.recommend')}("+recommendCount+")</a><span style=\"display:"+display52+"\">${ctp:i18n('doc.jsp.knowledge.recommend')}("+recommendCount+")</span></span>"; 
          }             
          divStr += "<span class=\"right\"><span class=\"file_box_menu\">"+
          "<a href=\"javascript:void(0);\" class=\"ico16 FBM_setting\" title=\"${ctp:i18n('doc.menu.action.label')}\"></a></span>"+
          "<div class=\"file_box_menu_list\"><ul class=\"lvl1\"><li style=\"display:"+display7+"\"><a href=\"javascript:void(0);\">"
          +"<em class=\"ico16 send_16 lvlIcon\"></em>${ctp:i18n('doc.menu.sendto.label')}</a>"
          +"<span class=\"ico16 arrow_gray_r left\"></span><div class=\"lvl2_box\"><ul class=\"lvl2\" style=\"z-index:5;\"><li style=\"display:"+display7+"\">"
          +"<a href=\"javascript:sendToCommonDoc(\'"+docId+"\');\">${ctp:i18n('doc.jsp.home.label.favorite')}</a></li>"
          +"<li style=\"display:"+display3+"\"><a href=\"javascript:sendToMyStudy(\'"+docId+"\');\">${ctp:i18n('doc.menu.sendto.learning.label')}</a>"
          +"</li><li style=\"display:"+display3+"\"><a href=\"javascript:sendToSpecificLocation(\'"+docId+"\',\'"+parentId+"\',\'"+docLibId+"\');\">${ctp:i18n('doc.menu.sendto.other.label')}</a>"
          +"</li></ul></div></li>"
          +"<li style=\"display:"+isForward+"\"><a href=\"javascript:void(0);\"><em class=\"ico16 forwarding_16 lvlIcon\"></em>${ctp:i18n('doc.menu.forward.label')}</a>"
          +"<span class=\"ico16 arrow_gray_r left\"></span><div class=\"lvl2_box\">"
          +"<ul class=\"lvl2\" style=\"z-index:5;\"><li style=\"display:"+forwardColl+"\">"
          +"<a href=\"javascript:forwardDocToCol(\'"+docId+"\', \'"+docLibId+"\', \'"+docType+"\', \'"+_sourceId+"\');\">"
          +"${ctp:i18n('doc.jsp.knowledge.forward.collaboration')}</a></li><li style=\"display:"+forwardMail+"\">"
          +"<a href=\"javascript:forwardDocToEmail(\'"+docId+"\', \'"+docLibId+"\', \'"+docType+"\', \'"+_sourceId+"\');\">"
          +"${ctp:i18n('doc.jsp.knowledge.forward.mail')}</a></li></ul></div></li><li style=\"display:"+display2+"\">"
          +"<a href=\"javascript:downloadDoc(\'"+docId+"\',\'"+docNameEscapeJS+"\',\'"+docMimeType+"\',\'"+_sourceId+"\',\'"+createDate+"\',\'"+vForDownload+"\');\">"
          +"<em class=\"ico16 download_16 lvlIcon\"></em>${ctp:i18n('doc.menu.download.label')}</a></li>";
          // 判断是否显示第一条横线
          if(display7 !== "none" || isForward !== "none" || display2 !== "none") {
              divStr += "<li class='line'></li>";  
          }
          
          var officeTypes  = {"type101":true,"type102":true,"type120":true,"type121":true,"type23":true,"type24":true,"type25":true,"type26":true};
          //非IE下的office文档  不能编辑
          var isNotIE2Office = (officeTypes["type"+docMimeType] && !v3x.isOfficeSupport());
          var editOption =isNotIE2Office ? "":"<a href=\"javascript:edit(\'"+docId+"\',\'"+docNameEscapeJS+"\',\'"+docMimeType+"\');\"><em class=\"ico16 editor_16 lvlIcon\"></em>${ctp:i18n('doc.menu.edit.label')}</a>";
          
          
          divStr += "<li style=\"display:"+display2+"\">"+editOption
          +"</li><li><a href=\"javascript:moveDoc(\'"+docId+"\',\'"+parentId+"\',\'"+docLibId+"\');\">"
          +"<em class=\"ico16 move_16 lvlIcon\"></em>${ctp:i18n('doc.menu.move.label')}</a></li><li style=\"display:"+display1+"\">"
          +"<a href=\"javascript:replaceDoc(\'"+docId+"\',\'"+parentId+"\',\'"+docNameEscapeJS+"\');\"><em class=\"ico16 replace_16 lvlIcon\"></em>"
          +"${ctp:i18n('doc.menu.replace.label')}</a></li><li><a href=\"javascript:deleteDoc(\'"+docId+"\');\"><em class=\"ico16 del_16 lvlIcon\"></em>"
          +"${ctp:i18n('doc.jsp.open.body.delete')}</a></li><li style=\"display:"+display3+"\"><a href=\"javascript:renameDoc(\'"+docId+"\');\">"
          +"<em class=\"ico16 rename_16 lvlIcon\"></em>${ctp:i18n('doc.menu.rename.label')}</a></li><li class='line'></li><li style=\"display:"+display3+"\">"
          +"<a href=\"javascript:borrowDoc(\'"+docId+"\','"+result[i].doc.vForBorrow+"');\"><em class=\"ico16 lending_16 lvlIcon\"></em>"
          +"${ctp:i18n('doc.jsp.properties.label.borrow')}</a></li><li style=\"display:"+display4+"\">"
          +"<a href=\"javascript:learnHistoryView(\'"+docId+"\',false);\"><em class=\"ico16 learning_record_16 lvlIcon\">"
          +"</em>${ctp:i18n('doc.jsp.learn.history.title')}</a></li><li style=\"display:"+display5+"\">"
          +"<a href=\"javascript:openToSquare(\'"+docId+"\');\"><em class=\"ico16 "+fnOpenOrCancelSquareCss(isOpenSquare)+" lvlIcon\"></em>"
          +fnOpenOrCancelSquare(isOpenSquare)+"</a></li>"+showLine
          +"<li><a href=\"javascript:docProperties(\'"+docId+"\','"+ isPig(docType) +"','"+result[i].doc.vForDocPropertyIframe+"');\">"
          +"<em class=\"ico16 attribute_16 lvlIcon\"></em>${ctp:i18n('doc.jsp.open.label.prop')}</a></li></ul></div></span>"
          +"</div></div>";
          $(divStr).appendTo('#docContentList');
        }
        
        
        if(resultLength==0){
            var message = "${ctp:i18n('doc.jsp.knowledge.read.nullMydocLib')}";
            if(pageObject.isQuery){
                message = pageObject.queryAlert;
            }
            pageObject.isQuery = false;
            var empty = "<div class=\"align_center padding_tb_10 color_gray\"><img class=\"valign_m margin_r_10\" src=\"${path}/skin/default/images/zszx_empty.png\" />"+message+"</div>";
            $('#docContentList').html(empty);
        }

        for(var i=0; i<resultLength; i++){
            var createUserValid=result[i].createUserValid;
            if(createUserValid!=null&&createUserValid){
                $("#user"+i).click(function(){
                    var id = $(this).attr("id");
                    var userId = -1;
                    if(id != null && id.length > 4){
                        id = id.substring(4);
                        userId = result[parseInt(id)].doc.createUserId;
                        $.PeopleCard({memberId: userId});
                    }
                });
            }
        }
          
           //小块设置单机事件
        var FBM_setting_mouseOut = true;//判断
        $(".file_box_area .FBM_setting").click(function () {
            //判断超出游览器下方显示区域，调整位置
            var _bodyHeight = $(window.document).height();
            $(this).parents(".file_box_area").find(".file_box_menu_list").show();
            var _fbml_lvl1 = $(this).parents(".file_box_area").find(".file_box_menu_list .lvl1");
            if ($(this).offset().top + _fbml_lvl1.height() + $(this).height() > _bodyHeight) {
                var _top = _fbml_lvl1.height();
                _fbml_lvl1.css({ top: "-" + _top + "px" });
            } else {
                _fbml_lvl1.css({ top: "" });
            }
        }).mouseleave(function () {
            setTimeout(function () {
                if (FBM_setting_mouseOut) {
                    $(".file_box_area .file_box_menu_list").hide();
                }
            }, 100);
        });
        $(".file_box_area .file_box_menu_list").mouseenter(function(){
            FBM_setting_mouseOut = false;
        }).mouseleave(function () {
            FBM_setting_mouseOut = true;
            $(this).hide();
        });
          //小块菜单控制
          $(".file_box_area .lvl1 > li[class!='line']").each(function () {
              var item = $(this).find(".lvl2");
              $(this).mouseenter(function () {
                  $(this).addClass("current");
                  $(this).find("span").toggleClass("arrow_gray_r arrow_white_r");
                  item.show();
              }).mouseleave(function () {
                  $(this).removeClass("current");
                  $(this).find("span").toggleClass("arrow_gray_r arrow_white_r");
                  item.hide();
              });
              $(this).find(".lvl2 li").mouseenter(function () {
                  $(this).addClass("current");
              }).mouseleave(function () {
                  $(this).removeClass("current");
              });
          });
          
          closeProce();
      }
    });
    
    //**********搜索************
    var searchobj = $('#searchDiv').searchCondition({
        searchHandler: function () {
            openProce();
            var jsonParam = searchobj.g.getReturnValue();
            
            $('#docContentList').html('');
            var obj = new Object();
            obj.folderId = focusFolderId;
            if(jsonParam!=null){
                obj.condition = jsonParam.condition;
                obj.value = jsonParam.value;
                
                if(obj.value != null && obj.value != ""){
                    pageObject.isQuery = true;
                }
                obj.search = "search";
            }
            obj.columns = 3;
            $('#myajaxgridbar').ajaxgridbarLoad(obj);
        },
        conditions: [{
            id: 'frName',
            name: 'frName',
            type: 'input',
            text: $.i18n('doc.jsp.knowledge.query.name'),
            value: 'frName'
        }, {
            id: 'contentType',
            name: 'contentType',
            type: 'select',
            text: $.i18n('doc.jsp.knowledge.query.contentType'),
            value: 'contentType',
            codecfg: "codeType:'java',codeId:'com.seeyon.apps.doc.enums.ContentTypeEnums'"
        }, {
            id: 'keyWords',
            name: 'keyWords',
            type: 'input',
            text: $.i18n('doc.jsp.knowledge.query.key'),
            value: 'keyWords'
        }, {
            id: 'createTime',
            name: 'createTime',
            type: 'datemulti',
            text: $.i18n('doc.jsp.knowledge.query.createTime'),
            value: 'createTime',
            ifFormat:'%Y-%m-%d'
        }, {
            id: 'createUser',
            name: 'createUser',
            type: 'input',
            text: $.i18n('doc.jsp.knowledge.query.createUser'),
            value: 'createUser'
        }, {
            id: 'sponsor',
            name: 'sponsor',
            type: 'input',
            text: $.i18n('doc.jsp.knowledge.query.launched'),
            value: 'sponsor'
        }, {
            id: 'startDate',
            name: 'startDate',
            type: 'datemulti',
            text: $.i18n('doc.jsp.knowledge.query.launchedTime'),
            value: 'startDate',
            ifFormat:'%Y-%m-%d'
        }]
    });
}

//我读
function fnMyRead(){
    //ling start
    $(".zhanwei").css("background","#fff");
    //ling end
    openFlag = "docRead";
    openProce();
    getA8Top().frames['main'].refreshFlag = 'docRead';
    $('#docRead').addClass('current').siblings().removeClass('current');
    $('#isPaging').addClass('display_none');
    $('#contentArea').html("");
    var docReadHead = "<div id=\"recentlyRead\" class=\"zszx_title_area\">"+
                            "<span class=\"set_underLine left font_size14\">${ctp:i18n('doc.jsp.knowledge.recent.read')}</span>"+
                        "</div>"+
                        "<div id=\"latestCollect\" class=\"zszx_title_area\">"+
                            "<span class=\"set_underLine left font_size14\">${ctp:i18n('doc.jsp.knowledge.recent.collect')}</span>"+
                            "<div class=\"right margin_t_5\"><a id=\"docMoreCollect\" href=\"javascript:void(0);\">${ctp:i18n('doc.jsp.knowledge.more')}</a></div>"+
                        "</div>";
    $('#contentArea').html(docReadHead);
    $("#docMoreCollect").click(fnleastCollectMore);
        
    var userId = $.ctx.CurrentUser.id;
    docActionUseManagerAjax.findRecentlyReadDoc(userId,15,false, {
        success: function(result){
            if (result.length < 1) {
                var message = "${ctp:i18n('doc.jsp.knowledge.read.nullwarning')}";
                if(pageObject.isQuery){
                    message = pageObject.queryAlert;
                }
                pageObject.isQuery = false;
                var empty = "<div class=\"align_center padding_tb_10 color_gray\"><img class=\"valign_m margin_r_10\" src=\"${path}/skin/default/images/zszx_empty.png\" />"+message+"</div>";
                $(empty).insertAfter("#recentlyRead");
            } else {
                docReadDisplay(result, "docReadUL");
            }
            closeProce();
        }
    });
    docActionUseManagerAjax.findLatestCollectDoc(userId,15,false, {
        success: function(result){
            if (result.length < 1) {
                $("#docMoreCollect").addClass("display_none");
                var message = "${ctp:i18n('doc.jsp.knowledge.collect.nullwarning')}";
                if(pageObject.isQuery){
                    message = pageObject.queryAlert;
                }
                pageObject.isQuery = false;
                var empty = "<div class=\"align_center padding_tb_10 color_gray\"><img class=\"valign_m margin_r_10\" src=\"${path}/skin/default/images/zszx_empty.png\" />"+message+"</div>";
                $(empty).insertAfter("#latestCollect");
            } else {
                docReadDisplay(result, "docCollectUL");
            }
            closeProce();
        }
    });
}


function docReadDisplay(result, docLocation){
    var flag = "";
    if (docLocation == "docReadUL") {
        flag = "read";
        var readUL = "<ul id=\"docReadUL\" class=\"zszx_file_list\"></ul>";
        $(readUL).insertAfter("#recentlyRead");
    } else {
        flag = "collect";
        var collectUL = "<ul id=\"docCollectUL\" class=\"zszx_file_list\"></ul>";
        $(collectUL).insertAfter("#latestCollect");
    }
    for (var i=0; i<result.length; i++) {
        var star = fnGetStarLevelClass(result[i].avgScore);
        var avgScore = fnGetAvgScore(result[i].avgScore);
        var icoClass = "ico32 fileType_"+result[i].mimeTypeId+" margin_r_10 left";
        var docTitle = result[i].frName;
        var docName = result[i].frNameLimtLen;
        if(result[i].hasAttachments){
            docName += "<span class='ico16 affix_16'></span>";
        }
        var docUser = result[i].createUserName;
        var docId = result[i].docResoureId;
        var docUserId = result[i].createUserId;
        var isPig = result[i].pig;
        var sourceType = result[i].sourceType;
        var favoriteSource = result[i].favoriteSource;
        var sourceId = result[i].sourceId;
        var createUserValid=result[i].createUserValid;
        var sourceDocId;
        if(sourceType=='2'){
            sourceDocId = sourceId;
        }else if(sourceType == '3' || sourceType == '4'){
            sourceDocId = favoriteSource;
        }else{
            sourceDocId = docId;
        }
        var liClass = "margin_l_20";
        if (i == 0 || i%3 == 0) {
            liClass = "";
        }
        var liStr = "<li class=\""+liClass+"\"><span class=\""+icoClass+"\"></span><div class=\"clearFlow\"><div class=\"fixedHeigh\"><a href=\"javascript:fnOpenKnowledge(\'"+sourceDocId+"\');\" class=\"set_text_overflow t color_black\" title=\""+docTitle+"\">"+docName+"</a>";
        if(!isPig) {
            liStr = liStr + "<div class=\"clearFlow\"><span title='${ctp:i18n('doc.knowledge.doc.score')}:"+avgScore+"' class=\""+star+" margin_t_5 left\"></span></div>";
        }
        if(createUserValid == null || !createUserValid){
            liStr = liStr + "</div><p class=\"color_gray2\"><a style='margin-right:5px;' id=\"user"+flag+i+"\" userId=\"" + docUserId +"\" isValid=\"false\" class=\"disabled_color\" title='"+userValid+"' >"+docUser+"</a>(" + result[i].createTime + ")</p></div></li>";
        }else{
            liStr = liStr + "</div><p class=\"color_gray2\"><a style='margin-right:5px;' id=\"user"+flag+i
            +"\" userId=\"" + docUserId +"\" title='"+dealMeTxt(docUser)+"'>"
            +fnSubString(docUser,6)+"</a>(" + result[i].createTime + ")</p></div></li>";
        }
        
        $(liStr).appendTo('#'+docLocation);
    }
    for(var i=0; i<result.length; i++){
        $("#user"+flag+i).click(function(){
            if($(this).attr("isValid")==null||$(this).attr("isValid")=='true'){
                $.PeopleCard({memberId: $(this).attr("userId")});
            }
        });
    }
    closeProce();
}

function fnOpenOrCancelSquareCss(isOpenSquare){
    if(isOpenSquare){
        return "unPublicSquare_16";
    }else{
        return "publicSquare_16";
    }
}
function fnOpenOrCancelSquare(isOpenSquare){
    if(isOpenSquare){
        return "${ctp:i18n('doc.menu.openToZone.cancel.label')}";
    }else{
        return "${ctp:i18n('doc.jsp.knowledge.opentosquare')}";
    }
}
//显示某个文件夹下的文档
function showDocOfTheFolder(folderId){
	wholeFolderId = folderId;
	openFlag = "docNavigator_"+folderId;
    $('#docContentList').html('');
    focusFolderId = folderId;
    var obj = new Object();
    obj.folderId = folderId;
    obj.columns = 3;
    $('#myajaxgridbar').ajaxgridbarLoad(obj);
}

/**
 * 人员卡片
 */
function fnPersonCard(_this) {
    var oThis = $(_this);
    var userId = oThis.attr("userId");
    $.PeopleCard({
        memberId : userId
    });
}
/**
 * 人员卡片，onMoueseOver
 */
function initPeopleCardMini(){
    $("img[id^=personCard]").each(function(index) {
        $(this).PeopleCardMini({
            memberId : $(this).attr("userId")
        });
    });
}
/**
 * 封装动态下所有页面加载
 */
function initDynamic() {
    var mySearchObj = new Object();
    mySearchObj.userId = currentUserId;
    //mySearchObj.dynamicType = '3'; // dynamicType:'0' 我的订阅  '1' 组织推送  '2' 他人推荐    '3'或其他： 所有动态
    
    /*==================================== start with 封装所有动态、组织推送、他人推荐、我的订阅 公共方法（搜索框、列表查询）    ====================================*/
    
    var opNames = ["${ctp:i18n('doc.jsp.knowledge.my.subscription')}", "${ctp:i18n('doc.jsp.knowledge.orgPush')}", "${ctp:i18n('doc.jsp.knowledge.others.recommend')}", "${ctp:i18n('doc.jsp.knowledge.my.collect')}"];
    
    /************************ begin with $("A[name=A_get[0|1|2|3|4]").click method **************/
    $('A[name^=A_get]').click(function(){
        openProce();
        getA8Top().frames['main'].refreshFlag = this.name;
        $('#isPaging').addClass('display_none');
       var index= $(this).attr('index');
       mySearchObj.dynamicType = index;
       
       // 如果是全部动态，就不加载搜索框
       if (index === '3') {
           $('#contentArea').html("<ul id=\"ulwithlis_"+ index +"\" class=\"bg_color_white clearfix\"></ul>");
       }else {
           if (index === '4') {
        	   openFlag = "docTrends4";
               $('#contentArea').html(
                       "<div><div class=\"common_crumbs left\" style=\"padding-left:0;\">" +
                           "<span class=\"margin_r_10\">${ctp:i18n('doc.now.location.label.rep')}</span><a id=\"A_ShowMyRead\" href=\"javascript:void(0);\">" +
                           "${ctp:i18n('doc.jsp.knowledge.my.read')}</a><span class=\"common_crumbs_next margin_lr_5\">-</span><a id=\"docMoreCollect\"  class=\"last\" href=\"javascript:void(0);\">${ctp:i18n('doc.jsp.knowledge.recent.collect')}</a>" +
                       "</div>" +
                       "<div id=\"searchDiv_"+ index +"\" class=\"right\"></div></div>" +
                       "<ul id=\"ulwithlis_"+ index +"\" class=\"clearfix margin_t_10\"></ul>");
               
               $("#A_ShowMyRead").click(function(){
                   $('#docRead').click();
               });
               
               $("#docMoreCollect").click(fnleastCollectMore);
           }else {
        	   openFlag = "docTrends"+index;
                $('#contentArea').html(
                        "<div class='margin_t_10'><div class=\"common_crumbs left\">" +
                            "<span class=\"margin_r_10\">${ctp:i18n('doc.now.location.label.rep')}</span><a id=\"A_ShowDynamic\" href=\"javascript:void(0);\">" +
                            "${ctp:i18n('doc.jsp.knowledge.dynamic')}</a><span class=\"common_crumbs_next margin_lr_5\">-</span><a name=\"A_get"+ index +"\" index="+ index +" class=\"last\" href=\"javascript:void(0);\">"+ opNames[index] +"</a>" +
                        "</div>" +
                        "<div id=\"searchDiv_"+ index +"\" class=\"right\"></div></div>" +
                        "<ul id=\"ulwithlis_"+ index +"\" class=\"bg_color_white clearfix margin_t_10\"></ul>");
                
                $("#A_ShowDynamic").click(function(){
                    $('#docTrends').click();
                });
           }
           
           var searchUserValue;
           var serachUser;
           var serachTime;
           if(index==='2') {
               serachUser = "${ctp:i18n('doc.jsp.home.learn.recommender')}";
               searchUserValue = 'OM_name_String_like';
               serachTime = "${ctp:i18n('doc.jsp.home.learn.time')}";
           }else if(index==='4') {
               serachUser = "${ctp:i18n('doc.jsp.knowledge.query.createUser')}";
               searchUserValue = 'OM_name_String_like';
               serachTime = "${ctp:i18n('doc.jsp.knowledge.query.collectTime')}";
           }else {
               serachUser = "${ctp:i18n('doc.metadata.def.lastuser')}";
               searchUserValue = 'OM_name_String_like';
               serachTime = "${ctp:i18n('doc.metadata.def.lastupdate')}";
           }
            
            // ************************** begin with 加载搜索框  **************************//
            var searchobj = $('#searchDiv_'+ index).searchCondition({
                searchHandler: function () {
                    var ssss = searchobj.g.getReturnValue();
                    if(ssss!=null){
                    	mySearchObj.condition = ssss.condition;
                    	mySearchObj.value = ssss.value;
                    	
                    	if(mySearchObj.value != null && mySearchObj.value != ""){
                            pageObject.isQuery = true;
                        }
                    }
                    $('#ajaxgridbar').ajaxgridbarLoad(mySearchObj);
                },
                conditions: [{
                    id: 'docName',
                    name: 'docName',
                    type: 'input',
                    text: "${ctp:i18n('doc.jsp.knowledge.query.name')}",
                    value: 'd_frName_String_like'
                }, {
                    id: 'contentType',
                    name: 'contentType',
                    type: 'select',
                    text: "${ctp:i18n('doc.jsp.knowledge.query.contentType')}",
                    value: 'd_frType_Long_equal',
                    codecfg : "codeType:'java',codeId:'com.seeyon.apps.doc.manager.DocSearchContentTypeEnumImpl',openFlag:'"+openFlag+"'"
                }, {
                    id: 'keyword',
                    name: 'keyword',
                    type: 'input',
                    text: "${ctp:i18n('doc.jsp.knowledge.query.key')}",
                    value: 'd_keyWords_String_like'
                }, {
                    id : 'alterUser',
                    name : 'alterUser',
                    type : 'input',
                    text : serachUser,
                    value : searchUserValue
                }, {
                    id: 'alterDate',
                    name: 'alterDate',
                    type: 'datemulti',
                    text: serachTime,
                    value: 't_actionTime_Date_between',
                    ifFormat:'%Y-%m-%d'
                }]
            });
            // ************************** end with 加载搜索框  **************************//
       } 
        
        // ************************** begin with 加载表格数据  **************************//
        $('#ajaxgridbar').ajaxgridbar({
            managerName : 'docActionUseManager',
            managerMethod : 'findLatestDynamicDocByType',
            callback : function(fpi) {
                $("#ulwithlis_"+ index).html(showDynamicByType(index,fpi));
                $('#_afpPage').val(fpi.page);
                $('#_afpPages').val(fpi.pages);
                $('#_afpSize').val(fpi.size);
                $('#_afpTotal').val(fpi.total);
                initDynamic();
                $('#isPaging').removeClass('display_none');
                //initPeopleCardMini();
//                var $el;
//                for ( var i = 0, len = fpi.data.length; i < len; i++) {
//                    if(fpi.data[i].actionUserValid==null||fpi.data[i].actionUserValid){
//                        $el = $("#personCard-" + i);
//                        $el.PeopleCardMini({memberId: $el.attr("userId")});
//                    }
//                }
                
                //如果没有数据
                if(fpi.data.length==0){
                    var message = "${ctp:i18n('doc.jsp.knowledge.read.dynamic')}";
                    if(pageObject.isQuery){
                        message = pageObject.queryAlert;
                    }
                    pageObject.isQuery = false;
                    var empty = "<div class=\"align_center padding_tb_10 color_gray\"><img class=\"valign_m margin_r_10\" src=\"${path}/skin/default/images/zszx_empty.png\" />"+message+"</div>";
                    $("#ulwithlis_"+ index).html(empty);
                }
            }
        });
        $('#ajaxgridbar').ajaxgridbarLoad(mySearchObj);
        // ************************** end with 加载表格数据  **************************//
    });
    /************************ end with $("A[name=A_get[0|1|2|3|4]").click method **************/
    
    /*==================================== end with 封装所有动态、组织推送、他人推荐、我的订阅 公共方法（搜索框、列表查询）    ====================================*/
}
var _index = 0;
//拼装文档操作的div
function showDocOperateDiv(o, isDocCreateUser, strOperator) {
    var strOperateDiv = new StringBuffer();
    strOperateDiv.append("<div class='clearfix margin_t_10'>");
    strOperateDiv.append(strOperator);
    if(o.mimeTypeId !== '51') {
    	if(o.recommendEnable) {
        	strOperateDiv.append("<span class='right margin_l_10'><a href='javascript:doc_recommend(\"");
            strOperateDiv.append(o.realDocResourceId);
            strOperateDiv.append("\",\"");
            strOperateDiv.append(o.recommendEnable.toString());
            strOperateDiv.append("\");'>${ctp:i18n('doc.jsp.knowledge.recommend')}(");
        } else {
        	strOperateDiv.append("<span class='right margin_l_10 color_gray'>${ctp:i18n('doc.jsp.knowledge.recommend')}(");
        }
        strOperateDiv.append(o.recommendCount.toString());
        strOperateDiv.append(")</a></span><span class='right margin_l_10 color_gray'>${ctp:i18n('doc.jsp.knowledge.evaluation')}(");
        strOperateDiv.append(o.commentCount.toString());
        strOperateDiv.append(")</span><span class='right margin_l_10 color_gray'>${ctp:i18n('doc.menu.download.label')}(");
        strOperateDiv.append(o.downloadCount.toString());
        strOperateDiv.append(")</span>");
        //个人文档库，自己的文档，并且当前文档属于收藏文档
        if (((o.personal&&(o.sourceType==3||o.sourceType==4))
        		//公共文档库，有权限的可以收藏
        		||((o.potent.all || o.potent.read || o.potent.create || o.potent.edit || o.potent.readOnly) && (!o.personal)))
        		//公共文档库，无权限的，必须有取消收藏
        		||((!o.personal) && o.collect && o.realDocResourceId!=null)) {
            strOperateDiv.append("<span class='right margin_l_10'>");
            var sHide = 'display_none',sShow ='';
            if(o.collect && o.realDocResourceId!=null){// 显示取消收藏
                sShow = sHide;
                sHide = '';
            }
            _index++;
            //收藏
            strOperateDiv.append("<a id='favoriteSpan"+o.id+_index+"' href='javascript:favorite(3,\""); 
            strOperateDiv.append(o.id+"\",false, 3,"+_index+");'");
            strOperateDiv.append(" class='set_visible right margin_l_10 "+sShow+"'>${ctp:i18n('doc.jsp.knowledge.collection')}(");
            strOperateDiv.append(o.collectCount.toString());
            strOperateDiv.append(")</a>");
            //取消收藏
            if(openFlag === 'docTrends4'){
                strOperateDiv.append("<a id='cancelFavorite"+o.id+_index+"' href='javascript:void(0);' onclick='cancelFavoriteLocal(3,\"");
            }else{
                strOperateDiv.append("<a id='cancelFavorite"+o.id+_index+"' href='javascript:void(0);' onclick='cancelFavorite(3,\"");
            }
            strOperateDiv.append(o.id+"\",false,3,"+_index+");'");
            strOperateDiv.append(" class='set_visible right margin_l_10 "+sHide+"'>${ctp:i18n('doc.jsp.cancel.collection')}(");
            strOperateDiv.append(o.collectCount.toString());
            strOperateDiv.append(")</a>");
            
            strOperateDiv.append("</span>");
        } else {
        	strOperateDiv.append("<span class='right margin_l_10 color_gray'>${ctp:i18n('doc.jsp.knowledge.collection')}(");
            strOperateDiv.append(o.collectCount.toString());
            strOperateDiv.append(")</span>");
        }
    }
    strOperateDiv.append("</div>");
    return strOperateDiv.toString();
}

function cancelFavoriteLocal(appName, sourceId,hasAtts,type,index){
    if(typeof(index)=== 'undefined' ){
        index = '';
    }
    var cancelFavorite = $("#cancelFavorite"+String(sourceId)+String(index));
    cancelFavorite.attr("disabled","disabled");
    cancelFavorite.jsonSubmit({
        action : _ctxPath+"/doc/knowledgeController.do?method=favoriteCancel",
        paramObj:{'docId':-1,'sourceId':sourceId},
        callback : function(oReturn) {
            fnleastCollectMore();
        }
    }); 
}

//动态页面
function showDynamicByType(index,fpi) {
    var fromType = "", strOperator = "", isDocCreateUser = false, strHtml = new StringBuffer();
    switch (parseInt(index)) {
        case 0:// 动态：alert
        {
            for ( var i = 0, len = fpi.data.length; i < len; i++) {
                isDocCreateUser = (currentUserId === fpi.data[i].createUserId);
                if(fpi.data[i].isFromAcl == "false"){
                	strHtml.append(showAlert(fpi.data[i], fromType, i, isDocCreateUser, showDocOperateDiv(fpi.data[i], isDocCreateUser, strOperator)));
                }
            }
        }
        break;
        case 1:// 动态：orgPush
        {
            for ( var i = 0, len = fpi.data.length; i < len; i++) {
                isDocCreateUser = (currentUserId === fpi.data[i].createUserId);
                if(fpi.data[i].isFromAcl == "true"){
	                strOperator = "<span class='left margin_r_10 color_gray' title='"+fpi.data[i].actionUserName+"'>${ctp:i18n('doc.jsp.knowledge.pusher.label')}" + fnSubString(fpi.data[i].actionUserName,6) + "</span>";
	                strHtml.append(showOrgPush(fpi.data[i], fromType, i, isDocCreateUser, showDocOperateDiv(fpi.data[i], isDocCreateUser, strOperator)));
                }
            }
        }
        break;
        case 2:// 动态：recommend
        {
            for ( var i = 0, len = fpi.data.length; i < len; i++) {
                isDocCreateUser = (currentUserId === fpi.data[i].createUserId);
                //fromType = "<a class=\"right\" name=\"A_get0\" index=\"2\" href=\"javascript:void(0);\">${ctp:i18n('doc.jsp.knowledge.others.recommend')}</a>";
                strOperator = "<span class='left margin_r_10 color_gray' title='"+fpi.data[i].recommendederAll+"'>${ctp:i18n('doc.jsp.knowledge.recommend.area')}：" + fnSubString(fpi.data[i].recommendederAll,10) + "</span>";
                strHtml.append(showOtherRecommend(fpi.data[i], fromType, i, isDocCreateUser, showDocOperateDiv(fpi.data[i], strOperator, strOperator)));
            }
        }
        break;
        case 3:// 动态：alert,orgPush,recommend
        {
            for ( var i = 0, len = fpi.data.length; i < len; i++) {
                isDocCreateUser = (currentUserId === fpi.data[i].createUserId);
                if(fpi.data[i].actionType==13 || fpi.data[i].actionType==21 || fpi.data[i].actionType==22) {
                    fromType = "<a class=\"right otherPt\" name=\"A_get0\" index=\"2\" href=\"javascript:void(0);\">${ctp:i18n('doc.jsp.knowledge.others.recommend')}</a>";
                    strOperator = "<span class='left margin_r_10 color_gray' title='"+fpi.data[i].recommendederAll+"'>${ctp:i18n('doc.jsp.knowledge.recommend.area')}：" + fnSubString(fpi.data[i].recommendederAll,10) + "</span>";
                    strHtml.append(showOtherRecommend(fpi.data[i], fromType, i, isDocCreateUser, showDocOperateDiv(fpi.data[i], isDocCreateUser, strOperator)));
                } else {
                    if(fpi.data[i].isFromAcl == "true"){
                        fromType = "<a class=\"right set_height_color\" name=\"A_get1\" index=\"1\" href=\"javascript:void(0);\">${ctp:i18n('doc.jsp.knowledge.orgPush')}</a>";
                        strOperator = "<span class='left margin_r_10 color_gray' title='"+fpi.data[i].actionUserName+"'>${ctp:i18n('doc.jsp.knowledge.pusher.label')}" + fnSubString(fpi.data[i].actionUserName,6) + "</span>";
                        strHtml.append(showOrgPush(fpi.data[i], fromType, i, isDocCreateUser, showDocOperateDiv(fpi.data[i], isDocCreateUser, strOperator)));
                    } else {
                        fromType = "<a class=\"right\" name=\"A_get2\" index=\"0\" class=\"right\" href=\"javascript:void(0);\">${ctp:i18n('doc.jsp.knowledge.my.subscription')}</a>";
                        strOperator = "";
                        strHtml.append(showAlert(fpi.data[i], fromType, i, isDocCreateUser, showDocOperateDiv(fpi.data[i], isDocCreateUser, strOperator)));
                    }
                }
            }
        }
        break;
        case 4:// 我读：最近收藏更多页面
        {
            for ( var i = 0, len = fpi.data.length; i < len; i++) {
                isDocCreateUser = (currentUserId === fpi.data[i].createUserId);
                strHtml.append(showMoreCollect(fpi.data[i], fromType, i, isDocCreateUser, showDocOperateDiv(fpi.data[i], isDocCreateUser, strOperator)));
            }
        }
    }
    closeProce();
    return strHtml.toString();
}


/**
 * 订阅
 */
function showAlert(o, fromType, i, isDocCreateUser, strDocOperateDiv) {
    var strHtml = new StringBuffer();
    strHtml.append("<li class='padding_10 border_b_gray'><div class='margin_l_10 margin_b_10 margin_r_20' style='width:42px;height:42px;float:left'><img id='personCard-");
    strHtml.append(i.toString());
    strHtml.append("' userId='");
    strHtml.append(o.actionUserId);
    if(o.actionUserValid!=null && o.actionUserValid){//离职人员处理
        strHtml.append("' class='radius hand' src='" + o.userImageSrc + "' width='42' height='42' onclick='$.PeopleCard({memberId:\"");
        strHtml.append(o.actionUserId);
        strHtml.append("\"});' /></div><div class='over_hidden' style='_width:570px; height:71px;'><div class='clearfix'><span class='left'><a class='left margin_r_5' onclick='javascript:$.PeopleCard({memberId:\"");
        strHtml.append(o.actionUserId);
        strHtml.append("\"});' title='"+dealMeTxt(o.actionUserName)+"'>");
    }else{
        strHtml.append("' class='radius hand common_disable' src='" + o.userImageSrc + "' width='42' height='42' title='"+userValid+"' ");
        strHtml.append(" /></div><div class='over_hidden' style='_width:570px; height:71px;'><div class='clearfix'><span class='left'><a href='javascript:void(0);' class='left margin_r_5 disabled_color' ");
        strHtml.append(" title='"+userValid+"'>");
    }
    strHtml.append(fnSubString(o.actionUserName,6));
    strHtml.append("</a><span class='left margin_r_5'>");
    strHtml.append(o.alertOprType);
    strHtml.append("</span><span class='ico16 fileType2_");
    strHtml.append(o.mimeTypeId);
    strHtml.append(" margin_r_5 left'></span><a href='");
    if (isDocCreateUser) {
        strHtml.append("javascript:fnOpenKnowledge(\"");
        strHtml.append(o.docResoureId);
        strHtml.append("\");");
    } else {
        strHtml.append("javascript:fnOpenKnowledge(\"");
        strHtml.append(o.docResoureId);
        strHtml.append("\");");
    }
    strHtml.append("' title=\"");
    strHtml.append(o.frName);
    strHtml.append("\" class='left margin_r_5'>${ctp:i18n('doc.jsp.knowledge.doc.leftBook')}");
    var frName=o.frNameLimtLen;
    if(o.hasAttachments){//附件
        frName += "<span class='ico16 affix_16'></span> ";
    }
    strHtml.append(frName);
    strHtml.append("${ctp:i18n('doc.jsp.knowledge.doc.rightBook')}</a>");
    if(!o.pig) {
    	 strHtml.append("<span class='left ");
    	 strHtml.append(fnGetStarLevelClass(o.avgScore));
    	 strHtml.append("' title=\"${ctp:i18n('doc.knowledge.doc.score')}:");
    	 strHtml.append(o.avgScore.toString());
    	 strHtml.append("\"></span>");
    }
    strHtml.append("</span>");
    strHtml.append(fromType);
    strHtml.append("<span class='color_gray right margin_r_5'>");
    strHtml.append(fnEvalTimeInterval(o.actionTime));
    strHtml.append("</span></div><div class='margin_t_5'>${ctp:i18n('doc.jsp.knowledge.filepath.label')}");
    strHtml.append(o.pathString);
    strHtml.append("</div>");
    strHtml.append(strDocOperateDiv);
    strHtml.append("</div></li>");
    return strHtml.toString();
}

function showOrgPush(o, fromType, i, isDocCreateUser, strDocOperateDiv) {
    var strHtml = new StringBuffer();
    strHtml.append("<li class='padding_t_10 padding_b_10 border_b_set'><div class='margin_b_10 margin_r_20' style='width:42px;height:42px;float:left'><img id='personCard-");
    strHtml.append(i.toString());
    strHtml.append("' userId='");
    strHtml.append(o.actionUserId);
    if(o.actionUserValid!=null&&o.actionUserValid){//离职人员处理
        strHtml.append("' class='radius hand' src='" + o.userImageSrc + "' width='42' height='42' onclick='$.PeopleCard({memberId:\"");
        strHtml.append(o.actionUserId);
        strHtml.append("\"});' /></div><div class='over_hidden' style='_width:570px; height:71px;'><div class='clearfix'><span class='left'><a class='left margin_r_5' onclick='javascript:$.PeopleCard({memberId:\"");
        strHtml.append(o.actionUserId);
        strHtml.append("\"});'  title='"+dealMeTxt(o.actionUserName)+"'>");
    }else{
        strHtml.append("' class='radius hand common_disable' src='" + o.userImageSrc + "' width='42' height='42' ");
        strHtml.append(" title='"+userValid+"'/></div><div class='over_hidden' style='_width:570px; height:71px;'><div class='clearfix'><span class='left'><a class='left margin_r_5 disabled_color' ");
        strHtml.append(o.actionUserId);
        strHtml.append(" title='"+userValid+"'>");
    }
  
    strHtml.append(fnSubString(o.actionUserName,6));
    strHtml.append("</a><span class='left margin_r_5'>");
    strHtml.append(o.alertOprType);
    strHtml.append("</span><span class='ico16 fileType2_");
    strHtml.append(o.mimeTypeId);
    strHtml.append(" margin_r_5 left'></span><a href='");
    if (isDocCreateUser) {
        strHtml.append("javascript:fnOpenKnowledge(\"");
        strHtml.append(o.docResoureId);
        strHtml.append("\");");
    } else {
        strHtml.append("javascript:fnOpenKnowledge(\"");
        strHtml.append(o.docResoureId);
        strHtml.append("\");");
    }
    strHtml.append("' title=\"");
    strHtml.append(o.frName);
    strHtml.append("\" class='left margin_r_5'>${ctp:i18n('doc.jsp.knowledge.doc.leftBook')}");
    strHtml.append(o.frNameLimtLen);
    var hasAttachments = o.hasAttachments ?"<span class='ico16 affix_16'></span>":'';
    strHtml.append(hasAttachments);
    strHtml.append("${ctp:i18n('doc.jsp.knowledge.doc.rightBook')}</a>");
    if(!o.pig) {
    	strHtml.append("<span class='left ");
        strHtml.append(fnGetStarLevelClass(o.avgScore));
        strHtml.append("' title=\"${ctp:i18n('doc.knowledge.doc.score')}:");
        strHtml.append(o.avgScore.toString());
        strHtml.append("\"></span>");
    }
    strHtml.append("</span>");
    strHtml.append(fromType);
    strHtml.append("<span class='color_gray right margin_r_5'>");
    strHtml.append(fnEvalTimeInterval(o.actionTime));
    strHtml.append("</span></div><div class='margin_t_5'>${ctp:i18n('doc.jsp.knowledge.filepath.label')}");
    strHtml.append(o.pathString);
    strHtml.append("</div>");
    strHtml.append(strDocOperateDiv);
    strHtml.append("</div></li>");
    return strHtml.toString();
}
//他人推荐
function showOtherRecommend(o, fromType, i, isDocCreateUser, strDocOperateDiv) {
	var strHtml = new StringBuffer();
	if(o.actionType == 13){//他人推荐给我的动态
	    strHtml.append("<li class='padding_t_15 padding_b_15 border_b_set'><div class='margin_b_10 margin_r_20' style='width:42px;height:42px;float:left'><img id='personCard-");
	    strHtml.append(i.toString());
	    strHtml.append("' userId='");
	    strHtml.append(o.actionUserId);
	    if(o.actionUserValid!=null&&o.actionUserValid){//离职人员处理
	        strHtml.append("' class='radius hand' src='" + o.userImageSrc + "' width='42' height='42' onclick='$.PeopleCard({memberId:\"");
	        strHtml.append(o.actionUserId);
	        strHtml.append("\"});' /></div><div class='over_hidden' style='_width:570px; min-height:65px;'><div class='clearfix'><span class='left'><a onclick='javascript:$.PeopleCard({memberId:\"");
	        strHtml.append(o.actionUserId);
	        strHtml.append("\"});' class='left margin_r_5' title='"+dealMeTxt(o.actionUserName)+"'>");
	        strHtml.append(fnSubString(o.actionUserName,6));
	    }else{
	        strHtml.append("' class='radius hand common_disable' src='" + o.userImageSrc + "' width='42' height='42' ");
	        strHtml.append(o.actionUserId);
	        strHtml.append(" title='"+userValid+"' /></div><div class='over_hidden' style='_width:570px; min-height:65px;'><div class='clearfix'><span class='left'><a href='javascript:void(0);' ");
	        strHtml.append(o.actionUserId);
	        strHtml.append(" title='"+userValid+"' class='left margin_r_5 disabled_color'>");
	        strHtml.append(fnSubString(o.actionUserName,6));
	    }
	    strHtml.append("</a> <span class='left margin_r_5'>${ctp:i18n('doc.txt.recommend.xiang')}");
	    strHtml.append("${ctp:i18n('doc.txt.me')}${ctp:i18n('doc.txt.recommend.tuijianle')} </span>");
	    if(o.createUserValid!=null&&o.createUserValid){//离职人员处理
	        strHtml.append("<a onclick='javascript:$.PeopleCard({memberId:\"");
	        strHtml.append(o.createUserId);
	        strHtml.append("\"});' class='left margin_r_5' title='"+dealMeTxt(o.createUserName)+"'>");
	    }else{
	        strHtml.append("<a ");
	        strHtml.append(o.createUserId);
	        strHtml.append(" title='"+userValid+"' class='left margin_r_5 disabled_color'>");
	    }
	    
	    strHtml.append(fnSubString(o.createUserName,6));
	    strHtml.append("</a><span class='left margin_r_10'>${ctp:i18n('doc.jsp.knowledge.others.doc.label')}");
	    strHtml.append(o.fileType);
	    strHtml.append("</span><span class='ico16 fileType2_");
	    strHtml.append(o.mimeTypeId);
	    strHtml.append(" margin_r_5 left'></span><a href='");
	    if (isDocCreateUser) {
	        strHtml.append("javascript:fnOpenKnowledge(\"");
	        strHtml.append(o.docResoureId);
	        strHtml.append("\");");
	    } else {
	        strHtml.append("javascript:fnOpenKnowledge(\"");
	        strHtml.append(o.docResoureId);
	        strHtml.append("\");");
	    }
	    strHtml.append("' title=\"");
	    strHtml.append(o.frName);
	    strHtml.append("\" class='left margin_r_5'>${ctp:i18n('doc.jsp.knowledge.doc.leftBook')}");
	    strHtml.append(o.frNameLimtLen);
	    var hasAttachments = o.hasAttachments ?"<span class='ico16 affix_16'></span>":'';
	    strHtml.append(hasAttachments);
	    strHtml.append("${ctp:i18n('doc.jsp.knowledge.doc.rightBook')}</a>");
	    if(!o.pig) {
	    	strHtml.append("<span class='left ");
	        strHtml.append(fnGetStarLevelClass(o.avgScore));
	        strHtml.append("' title=\"${ctp:i18n('doc.knowledge.doc.score')}:");
	        strHtml.append(o.avgScore.toString());
	        strHtml.append("\"></span>");
	    }    
	    strHtml.append("</span>");
	    strHtml.append(fromType);
	    strHtml.append("<span class='color_gray right margin_r_5'>");
	    strHtml.append(fnEvalTimeInterval(o.actionTime));
	    strHtml.append("</span></div><div class='margin_t_5 word_break_all'>");
	    strHtml.append(o.description);
	    strHtml.append("</div>");
	    strHtml.append(strDocOperateDiv);
	    strHtml.append("</div></li>");
	    strHtml.append();
	} else if(o.actionType == 21){//我推荐给他人的动态
	    strHtml.append("<li class='padding_t_15 padding_b_15 border_b_set'><div class='margin_b_10 margin_r_20' style='width:42px;height:42px;float:left'><img id='personCard-");
	    strHtml.append(i.toString());
	    strHtml.append("' userId='");
	    strHtml.append(o.actionUserId);
	    if(o.actionUserValid!=null&&o.actionUserValid){//离职人员处理
	        strHtml.append("' class='radius hand' src='" + o.userImageSrc + "' width='42' height='42' onclick='$.PeopleCard({memberId:\"");
	        strHtml.append(o.actionUserId);
	        strHtml.append("\"});' /></div><div class='over_hidden' style='_width:570px; min-height:65px;'><div class='clearfix'><span ");
	        strHtml.append(o.actionUserId);
	        strHtml.append(" class='left' >");
	        strHtml.append("${ctp:i18n('doc.txt.me')}</span>");
	    }else{
		    strHtml.append("' class='radius hand common_disable' src='" + o.userImageSrc + "' width='42' height='42' ");
	        strHtml.append(o.actionUserId);
	        strHtml.append(" title='"+userValid+"' /></div><div class='over_hidden' style='_width:570px; min-height:65px;'><div class='clearfix'><span class='left'><a href='javascript:void(0);' ");
	        strHtml.append(o.actionUserId);
	        strHtml.append(" title='"+userValid+"' class='left margin_r_5 disabled_color'>");
	        strHtml.append(fnSubString(o.actionUserName,6));
	        strHtml.append("</a>");
	    }
	    strHtml.append("<span class='left margin_r_5'> ${ctp:i18n('doc.txt.recommend.tuijianle')} </span>");
	    
	    if(o.createUserValid!=null&&o.createUserValid){//离职人员处理
	    	strHtml.append("<a onclick='javascript:$.PeopleCard({memberId:\"");
	        strHtml.append(o.createUserId);
	        strHtml.append("\"});' class='left margin_r_5 set_normal' title='"+dealMeTxt(o.createUserName)+"'>");
	    }else{
	        strHtml.append("<a ");
	        strHtml.append(o.createUserId);
	        strHtml.append(" title='"+userValid+"' class='left margin_r_5 disabled_color'>");
	    }
	    strHtml.append(fnSubString(o.createUserName,6));
	    strHtml.append("</a><span class='left margin_r_10'>${ctp:i18n('doc.jsp.knowledge.others.doc.label')}");
	    strHtml.append(o.fileType);
	    strHtml.append("</span><span class='ico16 fileType2_");
	    strHtml.append(o.mimeTypeId);
	    strHtml.append(" margin_r_5 left'></span><a href='");
        strHtml.append("javascript:fnOpenKnowledge(\"");
        strHtml.append(o.docResoureId);
        strHtml.append("\");");
	    strHtml.append("' title=\"");
	    strHtml.append(o.frName);
	    strHtml.append("\" class='left margin_r_5 set_normal'>${ctp:i18n('doc.jsp.knowledge.doc.leftBook')}");
	    strHtml.append(o.frNameLimtLen);
	    var hasAttachments = o.hasAttachments ?"<span class='ico16 affix_16'></span>":'';
	    strHtml.append(hasAttachments);
	    strHtml.append("${ctp:i18n('doc.jsp.knowledge.doc.rightBook')}</a>");
	    if(!o.pig) {
	    	strHtml.append("<span class='left ");
	        strHtml.append(fnGetStarLevelClass(o.avgScore));
	        strHtml.append("' title=\"${ctp:i18n('doc.knowledge.doc.score')}:");
	        strHtml.append(o.avgScore.toString());
	        strHtml.append("\"></span>");
	    }    
	    strHtml.append("</span>");
	    strHtml.append(fromType);
	    strHtml.append("<span class='color_gray right margin_r_5'>");
	    strHtml.append(fnEvalTimeInterval(o.actionTime));
	    strHtml.append("</span></div><div class='margin_t_5 word_break_all'>");
	    strHtml.append(o.description);
	    strHtml.append("</div>");
	    strHtml.append(strDocOperateDiv);
	    strHtml.append("</div></li>");
	    strHtml.append();
	} else if(o.actionType == 22){//推荐我的文档的动态
		strHtml.append("<li class='padding_10 border_b_gray'><div class='margin_l_10 margin_b_10 margin_r_20' style='width:42px;height:42px;float:left'><img id='personCard-");
	    strHtml.append(i.toString());
	    strHtml.append("' userId='");
	    strHtml.append(o.actionUserId);
	    
	    if(o.actionUserValid!=null&&o.actionUserValid){//离职人员处理
	    	strHtml.append("' class='radius hand' src='" + o.userImageSrc + "' width='42' height='42' onclick='$.PeopleCard({memberId:\"");
	        strHtml.append(o.actionUserId);
	        strHtml.append("\"});' /></div><div class='over_hidden' style='_width:570px; min-height:65px;'><div class='clearfix'><span class='left'><a onclick='javascript:$.PeopleCard({memberId:\"");
	        strHtml.append(o.actionUserId);
	        strHtml.append("\"});' class='left margin_r_5' title='"+ dealMeTxt(o.actionUserName) +"'>");
	    }else{
		    strHtml.append("' class='radius hand common_disable' src='" + o.userImageSrc + "' width='42' height='42' ");
	        strHtml.append(o.actionUserId);
	        strHtml.append(" title='"+userValid+"' /></div><div class='over_hidden' style='_width:570px; min-height:65px;'><div class='clearfix'><span class='left'><a href='javascript:void(0);' ");
	        strHtml.append(o.actionUserId);
	        strHtml.append(" title='"+userValid+"' class='left margin_r_5 disabled_color'>");
	    }
        strHtml.append(fnSubString(o.actionUserName,6));
	    strHtml.append("</a><span class='left margin_r_5'> ${ctp:i18n('doc.txt.recommend.tuijianle')} </span>");
        strHtml.append("<a onclick='javascript:$.PeopleCard({memberId:\"");
        strHtml.append(o.createUserId);
        strHtml.append("\"});' class='left margin_r_5' title='"+dealMeTxt(o.createUserName)+"'>");
	    strHtml.append(fnSubString(o.createUserName,6));
	    strHtml.append("</a><span class='left margin_r_5'>${ctp:i18n('doc.jsp.knowledge.others.doc.label')}");
	    strHtml.append(o.fileType);
	    strHtml.append("</span><span class='ico16 fileType2_");
	    strHtml.append(o.mimeTypeId);
	    strHtml.append(" margin_r_5 left'></span><a href='");
        strHtml.append("javascript:fnOpenKnowledge(\"");
        strHtml.append(o.docResoureId);
        strHtml.append("\");");
    strHtml.append("' title=\"");
    strHtml.append(o.frName);
    strHtml.append("\" class='left margin_r_5'>${ctp:i18n('doc.jsp.knowledge.doc.leftBook')}");
    strHtml.append(o.frNameLimtLen);
    var hasAttachments = o.hasAttachments ?"<span class='ico16 affix_16'></span>":'';
    strHtml.append(hasAttachments);
    strHtml.append("${ctp:i18n('doc.jsp.knowledge.doc.rightBook')}</a>");
    if(!o.pig) {
    	strHtml.append("<span class='left ");
        strHtml.append(fnGetStarLevelClass(o.avgScore));
        strHtml.append("' title=\"${ctp:i18n('doc.knowledge.doc.score')}:");
        strHtml.append(o.avgScore.toString());
        strHtml.append("\"></span>");
    }    
    strHtml.append("</span>");
    strHtml.append(fromType);
    strHtml.append("<span class='color_gray right margin_r_5'>");
    strHtml.append(fnEvalTimeInterval(o.actionTime));
    strHtml.append("</span></div><div class='margin_t_5 word_break_all'>");
    strHtml.append(o.description);
    strHtml.append("</div>");
    //显示文档操作的Div
    strHtml.append(strDocOperateDiv);
    strHtml.append("</div></li>");
    strHtml.append();
	}
    return strHtml.toString();
}

function dealMeTxt(createUserName){
	 if(createUserName ==="${ctp:i18n('doc.txt.me')}"){
     	 return '${CurrentUser.name}';
     }else{
     	return createUserName;
     }
}

function unescapeHTML(str){
    return str.replace(/<br\/>/g,'&#13;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}

function fnSubString(srcStr,len){
    if(len == null|| typeof(len) != 'number'){
        return srcStr;
    }
    
    if(srcStr != null && srcStr.length > len){
        srcStr = srcStr.substr(0,len-1)+ "..";
    }
    
    return srcStr;
}

function showMoreCollect(o, fromType, i, isDocCreateUser, strDocOperateDiv) {
	var isFjsc = o.realDocResourceId;
    var strHtml = new StringBuffer();
    strHtml.append("<li class='padding_t_20 border_b_set'><div class='margin_b_10 margin_r_20' style='width:42px;height:42px;float:left'><img id='personCard-");
    strHtml.append(i.toString());
    strHtml.append("' userId='");
    strHtml.append(o.createUserId);
    if(o.createUserValid!=null&&o.createUserValid){//离职人员处理
        strHtml.append("' class='radius hand' src='" + o.createUserImageSrc + "' width='42' height='42' onclick='$.PeopleCard({memberId:\"");
        strHtml.append(o.createUserId);
        strHtml.append("\"});' /></div><div class='over_hidden' style='_width:570px; height:71px;'><div class='clearfix'><span class='left'>");
    }else{
        strHtml.append("' class='radius hand common_disable' src='" + o.createUserImageSrc + "' width='42' height='42' ");
        strHtml.append(o.createUserId);
        strHtml.append(" title='"+userValid+"'/></div><div class='over_hidden' style='_width:570px; height:71px;'><div class='clearfix'><span class='left'>");
    }
    strHtml.append("<span class='left margin_r_5'>${ctp:i18n('doc.txt.me')}${ctp:i18n('doc.jsp.knowledge.my.collection.label')}</span>");
   
    if(o.createUserValid!=null&&o.createUserValid){
        strHtml.append("<a onclick='javascript:$.PeopleCard({memberId:\"");
        strHtml.append(o.createUserId);
        strHtml.append("\"});' class='left margin_r_5' title='"+dealMeTxt(o.createUserName)+"'>");
    }else{
        strHtml.append("<a href='javascript:void(0);' title='"+userValid+"'");
        strHtml.append(o.createUserId);
        strHtml.append(" class='left margin_r_5 disabled_color'>");
    }
 
    strHtml.append(fnSubString(o.createUserName,6));
    strHtml.append("</a><span class='left margin_r_5'>${ctp:i18n('doc.jsp.knowledge.others.doc.label')}");
    strHtml.append(o.fileType);
    strHtml.append("</span><span class='ico16 fileType2_");
    strHtml.append(o.mimeTypeId);
    strHtml.append(" margin_r_5 left'></span><a href='");
    var docId = o.docResoureId;
    if(isFjsc){
    	docId = isFjsc;
    }
    if (isDocCreateUser) {
        strHtml.append("javascript:fnOpenKnowledge(\"");
        strHtml.append(docId);
        strHtml.append("\", 1);");
    } else {
        strHtml.append("javascript:fnOpenKnowledge(\"");
        strHtml.append(docId);
        strHtml.append("\");");
    }
    strHtml.append("' title=\"");
    strHtml.append(o.frName);
    strHtml.append("\" class='left margin_r_5'>${ctp:i18n('doc.jsp.knowledge.doc.leftBook')}");
    var frName = o.frNameLimtLen;
    if(o.hasAttachments){//附件处理
        frName += "<span class='ico16 affix_16'></span> ";
    }
    strHtml.append(frName);
    strHtml.append("${ctp:i18n('doc.jsp.knowledge.doc.rightBook')}</a>");
    if(!o.pig && !o.link ) {
    	strHtml.append("<span class='left ");
        strHtml.append(fnGetStarLevelClass(o.avgScore));
        strHtml.append("' title=\"${ctp:i18n('doc.knowledge.doc.score')}:");
        strHtml.append(o.avgScore.toString());
        strHtml.append("\"></span>");
    }
    strHtml.append("</span><span class='color_gray right margin_r_5'>");
    strHtml.append(fnEvalTimeInterval(o.actionTime));
    strHtml.append("</span></div><div class='margin_t_5'>${ctp:i18n('doc.jsp.knowledge.filepath.label')}");
    strHtml.append(o.pathString);
    strHtml.append("</div>");
    strHtml.append(strDocOperateDiv);
    strHtml.append("</div></li>");
    return strHtml.toString();
} ;

/**
 * 我的知识库，向上按钮事件
 */
function fnBtnShangClick() {
    $(".area_operation").css({
        "height":"22",
        "border-bottom":"none"
    });
    $("#docNavigation").css("height","14");
    $("#searchDiv")[0].style.marginTop = "";
    
    $(".area_operation_btn .area_operation_btn_xia").show();
    $(".area_operation_btn .area_operation_btn_shang em").hide();
    $("#docNavigation>a").css("display","none");
}

function fnLoadMyKnowledgeLink(){
	var knowledgeMgr = new knowledgePageManager();
    // 知识链接
    knowledgeMgr.selectKnowledgeLink($.ctx.CurrentUser.id, 16, {
        success:function(list) {
            var strHtml = '';
            if(list.length > 0){
                for(var i=0; i< list.length; i++) {
                    var o = list[i];
                    strHtml += 
                    "<a target='blank' href='" + o.url + "' class='set_color_3 left margin_l_5 margin_t_10 text_overflow color_black w100 display_block' title='"+o.title+"' ><img src='${path}" 
                    + o.image + "' class='valign_m margin_r_5' width='16' height='16' />" + o.title.escapeHTML() + "</a>";
                }
                $("#knowledgeNoneLink").remove();
                $('#div_knowledgeLink').html(strHtml);
                $("#hrefKnowledgeLinkMoreId").removeClass("display_none");
            }else{
                strHtml = "<div id='knowledgeNoneLink' class=\"bj_color_w color_gray align_center padding_10\">${ctp:i18n('doc.knowledge.blank.warning')}</div>";
                $(strHtml).insertAfter("#knowledgeLink");
                $('#div_knowledgeLink').html("");
                $("#hrefKnowledgeLinkMoreId").addClass("display_none");
            }
                
        }
    });
}
/**
 * 我的知识库，向下按钮事件
 */
function fnBtnXiaClick() {
    $(".area_operation").css({
        "height":"80",
        "border-bottom":"1px solid #e9eaec"
    });
    $("#docNavigation").css("height","80");
    $("#searchDiv")[0].style.marginTop = "70px";
    
    $(".area_operation_btn .area_operation_btn_xia").hide();
    $(".area_operation_btn .area_operation_btn_shang em").show();
    $("#docNavigation>a").css("display","block");
    $(".set_maxWidth").css("width","");
}

/**
 * 关闭滚动阻塞
 */
var tout = null;
function closeProce(){
    tout=setTimeout("fnRizeHeight()",100);
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

function openPensonalLink(sUrl){
	$.dialog({
	    id: 'pensonalLink',
	    url: '${path}/portal/linkSystemController.do?method=userLinkMain&isKnowledge=true',
        title: "${ctp:i18n('doc.jsp.knowledge.personal.link.config')}",
		width: 1000,
		height: 550,
		targetWindow: window.top,
		closeParam: {show:true,handler:fnLoadMyKnowledgeLink}
	});
}

/**
 * 最近收藏更多
 */
function fnleastCollectMore(){
	$('html,body').scrollTop(0);
    $('#docRead').addClass('current').siblings().removeClass('current');
    openFlag = "docMoreCollect";
    getA8Top().frames['main'].refreshFlag = 'docMoreCollect';
    openProce();
    
    $('#contentArea').html("<a id=\"initDocCollectContent\" name=\"A_get4\" index=\"4\" class=\"right\" href=\"javascript:void(0);\"></a>");
    initDynamic();
    //初始加载所有动态
    $("#initDocCollectContent").click();
}

function fnRizeHeight(){
    if(tout){
        clearTimeout(tout);
    }
    var pHeight = $(parent.window.document).find("#main_div").height();
    var oContentArea=$("#contentArea");
    oContentArea.removeAttr("style");
    var cHeight=oContentArea.height();
    var nTemp = 15;
    var pagingHeight=$("#isPaging").height();
    var iContentHeight=pHeight-oContentArea.offset().top-pagingHeight-nTemp;
    if(iContentHeight >= cHeight){
        var isVisible=$("#isPaging").is(":visible");
        if(!isVisible){
            pagingHeight = 0;
        }
        oContentArea.height(iContentHeight);
    }
}
// 判断刷新动态下的二级分类
function fnRefreshTrend(name) {
	var _start = name.indexOf('A_get');
	var index = name.charAt(_start+5)
	$('#contentArea').html("<a id=\"initDynamicContent\" name=\""+ name +"\"  index='" + index +"' class=\"right\" href=\"javascript:void(0);\"></a>");
    initDynamic();
    // 初始加载所有动态
    $("#initDynamicContent").click();
}