<%@ page contentType="text/html; charset=UTF-8"%>
var docURL = "${path}"+"/doc.do";
var jsURL = docURL;
var layout = null;
var cPageData = new Object();
var toolbar = null;
var sStarts = null;
var _dialog = null;
var sAvg = 0;
// TODO 验证是否有协同/邮件,现在用的是V3X中的方法
var canNewColl = "${v3x:hasNewCollaboration()}";
var canNewMail = "${v3x:hasNewMail()}";
var tout;
$(function() {
    cPageData._path = "${path}/";
    cPageData.publishCommentLabel="<${ctp:i18n('doc.input.comment.remind')}>";
    cPageData.replyCommentLabel="<${ctp:i18n('doc.input.comment.reply')}>";
    cPageData.ajaxPageManager = new knowledgePageManager();
    cPageData.ajaxKnowledgeManager = new knowledgeManager();
    sStarts=$("#starAvgSpan").attr("class");
    sAvg=$("#spanAvgSpan").text();
    fnPageInit();
    
    if (fromGenius) {
    	toolbar.disabled('toolBar_transmit');
    }
    
    var isV5Member = '${CurrentUser.externalType == 0}';
	if (isV5Member != "true") {
		toolbar.hideBtn('tooBarSendToId');
	}
    
    if('${forumFlag}'==='true'){
      //评分事件
        fnforScoreEvent();
    }
});
/**
 * 评分星星事件
 */
function fnStartClick(){
    var starAvg= $("#starAvgSpan");
    var oSpanAvgSpan=$("#spanAvgSpan");
    var param={"actionUserId":$.ctx.CurrentUser.id,"subjectId":starAvg.attr("docId")};
    if('${param.openFrom}' === 'glwd') {
        $.alert("${ctp:i18n('doc.alert.limit.grade')}");
        return;
    }
    if($.ctx.CurrentUser.id==='${doc.createUserId}'){// 如果登录者是与文档创建者一致，不评分
        $.alert("${ctp:i18n('doc.self.score.warning')}！");
        return;
    } else if('${doc.commentEnabled}' === 'false'){
        $.alert("${ctp:i18n('doc.enable.score.warning')}！");
        return;
    }
    // 查询当前人，有没有评过分
    cPageData.ajaxPageManager.isForums(param,{
        success:function(oReturn){
            if(!oReturn){
                var oThis=$("#starAvgSpan");
                // oThis.unbind();
                fnAddScore(oThis);
                
            }else{
                $.alert("${ctp:i18n('doc.already.score.warning')}！");
            }
        }
    });
}
/**
 * 页面初始化
 */
function fnPageInit(){
    toolbar = $("#toolbar").toolbar(fnGetToolBarParam());
    //页面样式控制
    fnMonitorPageCss();
    // 初始化评论发布提示信息
    new inputChange($("#body"), cPageData.publishCommentLabel);
    if('${forumFlag}'==='true'){
        // 加载评论列表
        fnLoadComment();
    }
    //初始化按钮
    fnInitToolBarEditSendTo();
    //区隔
    if('${docOpenFlag}'==='false'){
        $(".seperate").hide();
    }
}

/**
 * 页面样式控制
 */
function fnMonitorPageCss(){
	var a6sTopHeight = 0;
    /* 设置正文编辑区域 */
    $("#iframe_area").css({
        "overflow" : "hidden"
    });
    
    if('${onlyA6}' === 'true' || '${onlyA6s}' === 'true' || '${isGov}' =='true'){
     a6sTopHeight = 20;
   	 var _layout_b = $("#iframe_area");
   	 _layout_b.css("top", Number(_layout_b.css("top").replace("px", "")) + a6sTopHeight + "px");
    }
    // 避免双滚动条
    if ($.browser.msie) {
        if ($.browser.version < 8) {
            $("#iframe_content").css("height", $("#iframe_area").height()-a6sTopHeight);
            $("#docOpenBodyFrame").height($("#iframe_area").height()-a6sTopHeight);
        }
    }
    
    //修改样式
    $("#center").css("borderTopWidth","0px").css("borderLeftWidth","0px").css("borderBottomWidth","0px");
    $(".common_toolbar_box").css("border","0px");
    $("#east").css("borderTopWidth","0px").css("borderRightWidth","0px").css("borderBottomWidth","0px");
    
    //解决附件，关联文档，高度与正文组件高度问题
    setAttachmentsLayoutHeight({
        fj_id: "docAttachment",
        wd_id: "relaAttachment",
        layout_head_id: "layout_hhh",
        layout_body_id:"iframe_area"
    });
    $("#docOpenBodyFrame").height($("#iframe_area").height()-a6sTopHeight);
    
    $("#add_new").click(function() {
        $(".textarea").removeClass("display_none");
    });
    $("#cancel").click(function() {
        $(".textarea").addClass("display_none");
    });

    $("#deal_area_show").click(function() {
        $("#layout #eastSp_layout .spiretBarHidden2").trigger("click");
    });
}

function fnReloadKnowledgeBrowse(){
    cPageData.ajaxPageManager.getDocDocResourceById('${doc.id}', {
        success : function(doc) {
            if(doc!=null){
                $("#spanRecommendCountId").html(doc.recommendCount);
                $("#spanCollectCountId,#spanCollectCountId2").html(doc.collectCount);
            }
        }
    });
}

function fnforScoreEvent(){
    if('${doc.commentEnabled}'==='false'){//评论和评分关闭
        $("#divAvgSpanId").hide();
    }else if('${param.versionFlag}'!='HistoryVersion' && '${param.openFrom}' !== 'glwd' && ($.ctx.CurrentUser.id!=='${doc.createUserId}')){//历史版本去掉评分
        //评分事件
        $("#starAvgSpan").click(fnStartClick);
        $("#starAvgSpan td").mouseenter(function (e) {
            var i=$(this).index()+1;
            var _parentObj=$("#starAvgSpan");
            _parentObj.attr("x", i);
            _parentObj.removeClass("stars0 stars1 stars2 stars3 stars4 stars5");
            _parentObj.addClass("stars" + i);
            //$(this).attr("title" ,"文档被评分："+ _x+".0 分");
            $("#spanAvgSpan").text(i+".0");
            $("#remindToolTipAvgSpan").show();
        });
        $("#starAvgSpan").mouseout(function(){
            $(this).removeClass("stars0 stars1 stars2 stars3 stars4 stars5");
            $(this).addClass(sStarts);
            $("#spanAvgSpan").text(sAvg);
            $("#remindToolTipAvgSpan").hide();
        });
    }
}

function fnDocDownLoad(fileId){
    docDownLoad('${doc.id}','${isUploadFile}','${doc.sourceId}','${ctp:escapeJavascript(doc.frName)}','${fileCreateDate}','${vForDocFileDownload}');
    //    if("${CurrentUser.id}"!=="${doc.createUserId}"){
    var oDownloadCountId=$("#spanDownloadCountId");
    var iCount=oDownloadCountId.text()===''?"0":oDownloadCountId.text();
    oDownloadCountId.text(parseInt(iCount)+1);
        //    }
}

function fnOpenWindow(surl) {
	getA8Top().LibPropWin = $.dialog({
        id : "properties",
        title : "${ctp:i18n('doc.jsp.open.label.prop')}",
        url : surl,
        width : 500,
        height : 500,
        targetWindow : window,
        isDrag : false,
        checkMax : false,
        transParams : {'parentWin':window}
    });
}

function fnDocProperty(){
	var cUrl = null;
	if('${isHistory}' === 'true') {
		cUrl=docURL+"?method=docPropertyIframe&isP=true&isB=false&isM=false&isC=false"+
	    "&docLibType=${docLibType}&docLibId=${doc.docLibId}"
	    +"&all=true&edit=true&create=true&readonly=true&read=true&list=true"
	    +"&parentCommentEnabled=true&parentRecommendEnable=${doc.recommendEnable}&flag=&isShareAndBorrowRoot=true"
	    +"&docResId=${doc.id}&isFolder=${doc.isFolder}&isPersonalLib=true&propEditValue=true"
	    +"&all=true&frType=${doc.frType}&versionFlag=HistoryVersion&docVersionId=${param.docVersionId}&isFolder=false&v=${vForDocPropertyIframe}";
	} else {
		cUrl=docURL+"?method=docPropertyIframe&isP=true&isB=false&isM=false&isC=false"+
	    "&docLibType=${docLibType}&docLibId=${doc.docLibId}"
	    +"&all=true&edit=true&create=true&readonly=true&read=true&list=true"
	    +"&parentCommentEnabled=true&parentRecommendEnable=${doc.recommendEnable}&flag=&isShareAndBorrowRoot=true"
	    +"&docResId=${doc.id}&isFolder=${doc.isFolder}&isPersonalLib=true&propEditValue=true"
	    +"&all=true&frType=${doc.frType}&v=${vForDocPropertyIframe}";
	}
    
    fnOpenWindow(cUrl+"&isDailog=true&from=knowledgeBrowse");
}

function popupContentWin(){
	_loadOfficeControll();
	window.setTimeout(function(){
		document.getElementById("docOpenBodyFrame").contentWindow.fullSize();
	},3000);
    
}
function _loadOfficeControll(){
	var docOpenBodyFrame =  document.getElementById("docOpenBodyFrame").contentWindow;
	if(docOpenBodyFrame.loadOfficeControll){
		docOpenBodyFrame.loadOfficeControll();
		docOpenBodyFrame.document.getElementById("officeFrameDiv").parentElement.parentElement.parentElement.parentElement.setAttribute("style","width:0px;height:0px;overflow:hidden; position: absolute;");
	}
	
}
function printDocLog() {
    if("${isHistory}" != "true") {
      ajaxRecordOptionLog('${doc.id}', "docPrint") ;
    }
	_loadOfficeControll();
	window.setTimeout(printDoc,1000);
}

/**
 * 评分
 */
function fnAddScore(oThis){
    var  docId = oThis.attr("docId");
    var  score = oThis.attr("x");
    var logInUserId=$.ctx.CurrentUser.id;
    var param={"docId":docId,"docScore":score,"userId":logInUserId};
    cPageData.ajaxKnowledgeManager.saveDocGrade(param, {
        success : function(data) {
            $.infor("${ctp:i18n('doc.alert.thanks.score')}");            
            // 返回评分平均值
            $("#spanAvgSpan").text(data.avgScore); 
            $("#starAvgSpan").attr("title","${ctp:i18n('doc.knowledge.doc.score')}："+data.avgScore);
            $("#starAvgSpan").removeClass("stars0 stars1 stars2 stars3 stars4 stars5").addClass(data.avgScoreCss);
            sAvg = data.avgScore;
            sStarts=$("#starAvgSpan").attr("class");
        }
    });
}
/**
 * 
 * @returns
 */
function fnReplyBlur(_this){
	  var oThis=$(_this);
	  var id=oThis.attr("id")+"Div";
	  $("#"+id).removeClass("error-form");
}
/**
 * 点击回复
 */
function fnReplyBtn(_this){
    var oThis=$(_this);
    var formId=oThis.attr("forumId");
    var oDivForm=$("#divForum"+formId);
    if(oDivForm.hasClass("display_none")){
        oDivForm.removeClass("display_none");
        $("#forumsId").append("&nbsp;");//兼容ie7 不显示的问题，在只有一条评论的时候，回复不刷新；
    }else{
        oDivForm.addClass("display_none");
    }
    var replyBody = $('#replyBody'+formId);
    new inputChange(replyBody, cPageData.replyCommentLabel);
}
/**
 * 回复提交
 */
function fnReplyForum(_this){
    var oThis=$(_this);
    var parentForumId=oThis.attr("parentForumId");
    // 验证
    var replyBody = $("#replyBody"+parentForumId);
    var body = replyBody.val().trim();
    if (body === cPageData.replyCommentLabel) {
        $("#replyBody"+parentForumId).val("");
    }
    replyBody.validateChange({notNull:true});
    var isPass = $("#replyBody"+parentForumId).validate({
        validate : true
    });
    if(!isPass){
        return;
    }
    replyBody.val("");//防止重复提交
    var docId=oThis.attr("docId");
    var parentForumId=oThis.attr("parentForumId");
    var createUserId=$.ctx.CurrentUser.id;
    var param={"docId":docId,"parentForumId":parentForumId,"createUserId":createUserId,"body":body};
    
    cPageData.ajaxPageManager.insertForums(param, {
        success : function(returnVal) {           
        	if(returnVal === null) {
        		fnConfirm("${ctp:i18n('doc.alert.comment.inexistence')}",function(){
        			fnLoadComment();
        		});
        		return;
        	} else {
        		// 载入评论
            fnLoadComment();
        	}      	
        	replyBody.validateChange({notNull:false});
        }
    });
}

/**
 * 删除回复
 */
function fnDelForum(_this){
    var oThis=$(_this);
    var docId=oThis.attr("docId");
    var param={"docId":docId};
    
    if(oThis.attr("forumId")!=undefined){
        var forumId=oThis.attr("forumId");
        param.forumId=forumId;
    }else if(oThis.attr("parentFormId")!=undefined){
        var parentFormId=oThis.attr("parentFormId");
        param.parentFormId=parentFormId;
    }
    cPageData.ajaxPageManager.delForum(param,{
         success : function(returnVal) {
             // 载入评论
             fnLoadComment();
         }
     });
}

/**
 * 发表评论
 */
function fnPublishComment(_this){
    var docId=$(_this).attr("docId");
    // 验证
    var val = $("#body").val().trim();
    if (val === cPageData.publishCommentLabel) {
        $("#body").val("");
    }
    $("#body").validateChange({notNull:true});
    var isPass = $("#body").validate({
        validate : true
    });
    
    if(!isPass){
        return;
    }
    $("#body").val("");//防止重复提交
    var param={"docId":docId,"body":val,"createUserId":$.ctx.CurrentUser.id,"parentForumId":"0"};
    cPageData.ajaxPageManager.insertForums(param, {
        success : function(returnVal) {
            // 载入评论
            fnLoadComment();
            $("#body").validateChange({notNull:false});
        }
    });
}

/**
 * 加载评论信息
 */
function fnLoadComment(){
    if('${doc.commentEnabled}'==='false'){
        return;
    }
    $("#forumsSpace").height($('body').height() - 330);
    var forumsId = $("#forumsId");
    var spanForumsNum = $("#spanInputForumNum");
    var forumsSpace = $("#forumsSpace");
    
    $("#fromDiv").jsonSubmit({
        action : _ctxPath + '/doc.do?method=getForums&docId=${doc.id}&docCreateUserId=${doc.createUserId}&versionFlag=${param.versionFlag}',
        callback : function(oReturn) {
            forumsId[0].innerHTML = oReturn;
            //initPeopleCardMini();//onMouseOver 性能问题
            // 初始化评论条数
            var forumsNum = $("#spanForumsNum").text();
            spanForumsNum.text(forumsNum);
            if(forumsNum === '0') {
                forumsId.removeClass();
                forumsSpace.removeClass("bg_color_white");
                forumsSpace.addClass("page_color");
            }else{
                forumsSpace.addClass("bg_color_white");
                forumsSpace.removeClass("page_color");
            	forumsId.addClass("clearFlow border_t");
            }
        }
    });
}

/**
 * 布局初始化对象
 */
function fnGetLayoutParam(){
  var layoutParam=   {
        'id' : 'layout',
        'eastArea' : {
            'id' : 'east',
            'width' : 350,
            'sprit' : true,
            'minWidth' : 350,
            'maxWidth' : 500,
            'border' : true,
            spiretBar : {
                show : true,
                handlerL : function() {
                    layout.setEast(348);
                    $("#deal_area").show();
                    $("#deal_area_show").hide();
                },
                handlerR : function() {
                    layout.setEast(38);
                    $("#deal_area").hide();
                    $("#deal_area_show").show();
                }
            }
        },
        'centerArea' : {
            'id' : 'center',
            'border' : true,
            'minHeight' : 20
        }
    }
  return layoutParam;
}

function sendToCollOrEmail(location, rowid, docLibId, entrance) {
    var url = location + "&docResId=" + rowid + "&docLibId=" + docLibId + "&entrance=" + entrance;
    openCtpWindow({
        'url': url
    });
}

function fnCloseDialog() {
	if(window.parentDialogObj) {
		window.parentDialogObj['docOpenDialogOnlyId'].close();
	} else if(parent.parentDialogObj){
		parent.parentDialogObj['docOpenDialogOnlyId'].close();
	} else {
		var _dialog = getA8Top()._dialog;
		getA8Top()._dialog = null;
		_dialog.close();
	}
}
/**
 * 返回工具条参数
 */
function fnGetToolBarParam(){
	if('${param.openFrom}' !== 'glwd') {
		var toolBarParam={
	            borderTop : false,
	            isPager : false,
	            toolbar : [  {
	                id : "toolBar_edit",
	                name : "${ctp:i18n('doc.menu.edit.label')}",
	                click : function() {
	                	if('${doc.isCheckOut}' === "true" && '${doc.checkOutUserId}' !== $.ctx.CurrentUser.id) {
	                		$.alert($.i18n('doc.alert.edit.locked','${ctp:toHTML(doc.frName)}','${checkname}'));
	                		return;
	                	}
	                    var msg_status = getLockMsgAndStatus('${doc.id}');
	                      if(msg_status && msg_status[0] != LOCK_MSG_NONE && msg_status[1] != LockStatus_None) {
	                        if(msg_status[1] == LockStatus_DocInvalid) {
	                          $.alert(parent.v3x.getMessage('DocLang.doc_alert_source_deleted_doc'));
	                        }else {
	                          $.alert(msg_status[0]);
	                        }
	                        return false;
	                      }
	                    var isUploadFileMimeType = false;
	                    if('${isUploadFile}'==='true' && '${doc.mimeTypeId}'!=='101' && '${doc.mimeTypeId}'!=='102' && '${doc.mimeTypeId}' !== '120' && '${doc.mimeTypeId}' !== '121') {
	                        isUploadFileMimeType = true;
	                    }
	                    if(isUploadFileMimeType) {
	                    		var dialog = $.dialog({
	                                url : jsURL+"?method=theNewEditDoc&docResId=${doc.id}&docLibType=1&isUploadFile=${isUploadFile}&isUploadFileMimeType="+isUploadFileMimeType+"&openFrom=${param.openFrom}",
	                                title : "${ctp:i18n('doc.knowledge.edit')}",
	                                id : "uploadFileDialog",
	                                targetWindow : top,
	                                height : 320,
	                                width :400,
	                                buttons: [{
	                                	id : 'ok',
	                                    text: "${ctp:i18n('common.button.ok.label')}",
                                      isEmphasize: true, //蓝色按钮
	                                    handler: function () {
	                                    	var returnValue = dialog.getReturnValue();
	                                    	if(returnValue) {
	                                    		dialog.close();
	                                        	// 刷新知识查看页面
	                                    		getA8Top().location.reload();
	                                    	}                                    	
	                                    }
	                                }, {
	                                	id : 'cancel',
	                                    text: "${ctp:i18n('common.button.cancel.label')}",
	                                    handler: function () {
	                                        dialog.close();
	                                    }
	                                }]

	                            });

	                    } else {
	                    	if(window.parentDialogObj) {
	                    		dialog= window.parentDialogObj['docOpenDialogOnlyId'];
	                    		getA8Top()._dialog = dialog;
	                    		dialog.setTitle("${ctp:i18n('doc.knowledge.edit')}");
	                            dialog.reloadUrl("${path}/doc.do?method=theNewEditDoc&docResId=${doc.id}&docLibType=1&isUploadFile=${isUploadFile}&isUploadFileMimeType="+isUploadFileMimeType);
	                    	} else if(parent.parentDialogObj) {
	                    		dialog= parent.parentDialogObj['docOpenDialogOnlyId'];
	                    		getA8Top()._dialog = dialog;
	                    		dialog.setTitle("${ctp:i18n('doc.knowledge.edit')}");
	                            dialog.reloadUrl("${path}/doc.do?method=theNewEditDoc&docResId=${doc.id}&docLibType=1&isUploadFile=${isUploadFile}&isUploadFileMimeType="+isUploadFileMimeType);
	                    	} else {
	                    		if(getA8Top()._dialog && getA8Top()._dialog.setTitle) {
	                    			getA8Top()._dialog.setTitle("${ctp:i18n('doc.knowledge.edit')}");
	                    		}		
	                    		window.location.href = "${path}/doc.do?method=theNewEditDoc&docResId=${doc.id}&docLibType=1&isUploadFile=${isUploadFile}&isUploadFileMimeType="+isUploadFileMimeType;
	                    	}
	                    }
	                },
	                className : "ico16 editor_16"
	            }, {
	                id : "toolBar_transmit",
	                name : "${ctp:i18n('doc.menu.forward.label')}",
	                className : "ico16 forwarding_16",
	                subMenu : [{
	                    id : "sendToColl",
	                    name : "${ctp:i18n('doc.jsp.knowledge.forward.collaboration')}",
	                    click : function() {
	                        var params = {
	    						    manual : 'true',
	    						    personId : '',
	    						    from : '',
	    						    handlerName : 'doc',
	    						    sourceId : '${doc.id}',
	    						    ext : '${param.entranceType}'+","+'${doc.docLibId}'
	    						}
	                        collaborationApi.newColl(params);
	                        return ;
	                    }
	                }, {
	                    id : "sendToEmail",
	                    name : "${ctp:i18n('doc.jsp.knowledge.forward.mail')}",
	                    click : function() {
	                    	if(hasDefaultMailBox()){
	                            var emailUrl = "${path}/doc.do?method=sendToWebMail";
	                            sendToCollOrEmail(emailUrl, '${doc.id}', '${doc.docLibId}','${param.entranceType}');
	                        }
	                    }
	                }]
	               
	            }, {
	                id:"tooBarSendToId",
	                name : "${ctp:i18n('doc.menu.sendto.label')}",
	                className : "ico16 sent_to_16",
	                subMenu : [{
	                    id : "favorite",
	                    name : "${ctp:i18n('doc.favorite.title')}",
	                    click : function() {
	                        addMyFavorite_V5('${doc.id}');
	                    }
	                }, {
	                    id : "publish",
	                    name : "${ctp:i18n('doc.account.doc.title')}",
	                    click : function() {
	                        publishDoc_V5('${doc.id}');
	                    }
	                }, {
	                    id : "deptDoc",
	                    name : "${ctp:i18n('doc.menu.sendto.deptDoc.label')}",
	                    click : function() {
	                        sendToDeptDoc_V5('${depAdminSize}','${doc.id}');
	                    }
	                }, {
	                    id : "group",
	                    name : "${ctp:i18n('doc.group.doc.title')}",
	                    click : function() {
	                        sendToGroup_V5('${doc.id}');
	                    }
	                }, {
	                    id : "learning",
	                    name : "${ctp:i18n('doc.menu.sendto.learning.label')}",
	                    click : function() {
	                	    if("${docPotent.all}"=="true"){
	                            $.selectPeople({
	                                type : 'selectPeople',  
	                                text : "${ctp:i18n('inquiry.choose.label')}", 
	                                mode : 'open',
	                                showMe : 'true',
	                                selectType : 'Member,Team,Post,Level',
	                                panels : 'Department,Team,Post,Level,Outworker',
	                                onlyCurrentDepartment : false,
	                                onlyLoginAccount:'${isGroupLib}'==='false',
	                                params : {
	                                     value: ''
	                                },
	                                callback : function(ret) {
	                                    sendToLearn_V5(ret,'${doc.id}');
	                                }
	                        });
	                	    }else{
	                	    	sendToLearn_V5({value:"Member|"+currentUserId},'${doc.id}');
	                	    }
	                   }
	                }, {
	                    id : "deptLearn",
	                    name : "${ctp:i18n('doc.menu.sendto.deptLearn.label')}",
	                    click : function() {
	                        sendToDeptLearn_V5('${depAdminSize}','${doc.id}');
	                    }
	                }, {
	                    id : "accountLearn",
	                    name : "${ctp:i18n('doc.menu.sendto.accountLearn.label')}",
	                    click : function() {
	                        sendToAccountLearn_V5('${doc.id}');
	                    }
	                }, {
	                    id : "groupLearn",
	                    name : "${ctp:i18n('doc.menu.sendto.group.learning')}",
	                    click : function() {
	                        sendToGroupLearn_V5('${doc.id}');
	                    }
	                }, {
	                    id : "link",
	                    name : "${ctp:i18n('doc.menu.sendto.other.label')}",
	                    click : function() {
	                        selectDestFolder_V5('${doc.id}','${doc.parentFrId}','${doc.docLibId}','${docLibType}','link');
	                    }
	                }]
	            
	            }]
	        };
	} else {
		var toolBarParam={
	            borderTop : false,
	            isPager : false,
	            toolbar : [  {
	                id : "toolBar_edit",
	                name : "${ctp:i18n('doc.menu.edit.label')}",
	                className : "ico16 editor_16"
	            }, {
	                id : "toolBar_transmit",
	                name : "${ctp:i18n('doc.menu.forward.label')}",
	                className : "ico16 forwarding_16"
	            }, {
	                id:"tooBarSendToId",
	                name : "${ctp:i18n('doc.menu.sendto.label')}",
	                className : "ico16 sent_to_16"
	            }]
	        };
	}
    
    return toolBarParam;
}

/**
 * 选择目标文档夹。 移动、映射、归档时调用此方法。
 * @param action [move | link | pigeonhole]
 * @param flag 是否从文档工作区操作
 */
function selectDestFolder_V5(checkid, parentId, docLibId, docLibType, action) {
	var surl = jsURL + "?method=docTreeMoveIframe&parentId=" + parentId	+ "&isrightworkspace=" + action 
			+ "&docLibId=" + docLibId + "&docLibType=" + docLibType + "&id=" + checkid + "&flag=true";
	if(v3x.getBrowserFlag('openWindow')){
		result = v3x.openWindow({url:surl, width:"500", height:"500", resizable:"false"});
	} else {
		openDialog4Ipad(surl+"&newFlag=true");
	}
}
/**
 * 封装对按钮的初始化
 */
function fnInitToolBarEditSendTo(){
	if('${isHistory}' === 'true' || '${isCollCube}'== 1) {
		toolbar.disabled('toolBar_edit');
		toolbar.disabled("tooBarSendToId");
		toolbar.disabled('toolBar_transmit');
		
	} else {
		toolBarEditInit();
		toolBarTurnTo();
		toolBarSendTo();
	}
    
}
/**
 * 初始化编辑按钮
 * @param
 * 
 */
function toolBarEditInit(){
  var typeid = "type${doc.mimeTypeId}";
  //非IE下的office文档  不能编辑
  var officeTypes  = {"type101":true,"type102":true,"type120":true,"type121":true,"type23":true,"type24":true,"type25":true,"type26":true};
  if (officeTypes[typeid] && !v3x.isOfficeSupport()) {
  		toolbar.disabled('toolBar_edit');
  }
	if ("${(docPotent.all || docPotent.edit) && param.openFrom != 'glwd'}" === 'false') {
		toolbar.disabled('toolBar_edit');
	}
}
/**
 * 初始化转发按钮
 */
function toolBarTurnTo(){
    if('${param.openFrom}' === 'glwd') {
    	toolbar.disabled('toolBar_transmit');
    } else {
    	if ('${docPotent.all||docPotent.edit||docPotent.readOnly}'==='false') {
    	    if('${docPotent.create}' === 'false' || '${CurrentUser.id}' !== '${doc.createUserId}') {
    	        toolbar.disabled('toolBar_transmit'); 
    	    }
    	}
    }
    // 如果没有协同/邮件就不显示相应的按钮
	var len = 2;
    if(canNewColl === "false") {
        toolbar.hideBtn("sendToColl");
        len -= 1; 
    }
    if(canNewMail === "false") {
        toolbar.hideBtn("sendToEmail");
        len -= 1;
    }
    if(len === 0) {
    	toolbar.hideBtn('toolBar_transmit');
    }
}

/**
 * 初始化发送到
 * @returns
 */
function toolBarSendTo(){
    if ('${docPotent.all||docPotent.edit||docPotent.readOnly}'==='false') {
	    if('${docPotent.create}' === 'false' || '${CurrentUser.id}' !== '${doc.createUserId}') {
	    	toolbar.disabled('link'); 
	    }
    }
    
    if('${isAdministrator}' !== 'true'){
        toolbar.disabled('publish');
        toolbar.disabled('accountLearn');
    }   
    
    if('${isGroupAdmin}' !== 'true'){
        toolbar.disabled('group');
        toolbar.disabled('groupLearn');
    }
    
    if('${depAdminSize}' === '0' || '${docPotent.all||docPotent.edit||docPotent.create||docPotent.read||docPotent.readOnly}'==='false'){
        toolbar.disabled('deptDoc');
        toolbar.disabled('deptLearn');
    }
    
    if('${depAdminSize}' !== '0' && '${docPotent.all||docPotent.edit||docPotent.create||docPotent.read||docPotent.readOnly}'==='true'){
        toolbar.enabled('deptDoc');
        toolbar.enabled('deptLearn');
    }
    
    if('${isPrivateLib}' === 'true' ||('${isPrivateLib}' === 'true' && '${isShareAndBorrowRoot}' === 'true')
     || ('${isPrivateLib}' !== 'true' && '${isShareAndBorrowRoot}' === 'true' && '${docPotent.all||docPotent.edit}'==='false' )){
        toolbar.hideBtn('deptDoc');
        toolbar.hideBtn('publish');
        toolbar.hideBtn('deptLearn');
        toolbar.hideBtn('accountLearn');
    }
    if('${isGroupLib}' !== 'true' || '${isPrivateLib}' === 'true' || '${isShareAndBorrowRoot}' === 'true'){
        toolbar.hideBtn('group');
        toolbar.hideBtn('groupLearn');
    }
    if(('${isPrivateLib}' === 'true' && '${isShareAndBorrowRoot}' === 'true')
        ||('${isPrivateLib}' !== 'true' && '${isShareAndBorrowRoot}' === 'true' && '${docPotent.all||docPotent.edit}'==='false' ) || '${docPotent.pShare}' === 'true') {
        toolbar.hideBtn('favorite');
        toolbar.hideBtn('learning');
        toolbar.hideBtn('link');
    }
    
    //如果是a6直接隐藏发送到部门的只是文档和
    if('${onlyA6}' === 'true' && '${onlyA6s}' === 'true'){
    	toolbar.hideBtn('deptDoc');
    	toolbar.hideBtn('deptLearn');
    }
    
    //查找被隐藏的子菜单，如果全部被找到，flag就为true，说明所有子菜单都被隐藏；
    var allItems = ['publish','accountLearn','group','groupLearn','deptLearn','deptDoc','favorite','learning','link'];
    if(toolbar.getMenuButton("tooBarSendToId").subMenu && toolbar.getMenuButton("tooBarSendToId").subMenu.allItems){
    	allItems = toolbar.getMenuButton("tooBarSendToId").subMenu.allItems;
    }
    var hideIdArray = toolbar.hideIdArray;
    var flag = true;
    for ( var int = 0; int < allItems.length; int++) {
    	var itemId = allItems[int].id;
    	if($.inArray(itemId,hideIdArray)==-1){
    		flag = false;
    		break;
    	}
    }
    
    if(flag || '${param.openFrom}' === 'glwd') {
        toolbar.disabled("tooBarSendToId");
    }
    
    if('${docPotent.all||docPotent.edit||docPotent.readOnly || docPotent.read || (docPotent.create && CurrentUser.id == doc.createUserId)}'==='false') {
    	toolbar.disabled("tooBarSendToId");
    }
    
   
}
/**
 * 选择当前查看界面的弹出窗口
 * @returns
 */
function fnSelectCurrentDialog() {
	if(window.parentDialogObj) {
		return window.parentDialogObj['docOpenDialogOnlyId'];
	} else {
		return getA8Top()._dialog;
	}
}
/**
 * 转协同 sendToCollFromOpen
 */

function sendToCollFromOpen_V5(id){
	window.location.href = docURL + "?method=sendToColl&docResId=" + id + "&docLibId=${doc.docLibId}";
}

/**
 * 转邮件
 */

function sendToMailFromOpen_V5(id){
	window.location.href = docURL + "?method=sendToWebMail&docResId=" + id + "&docLibId=";
}

/**
 * 添加到常用文档
 */
function addMyFavorite_V5(docId){
	var iframeUrl = docURL + "?method=sendToFavorites&userType=member&docId=" + docId;
	fnSendToDialog(iframeUrl,"${ctp:i18n_2('doc.send.to.airm.msg',2,1)}");
	//$("#iframe_empty").attr("src",iframeUrl);
}

/**
 * 发送到个人学习文档
 */
function sendToLearn_V5(elements, docId){
	if(!elements) {
		return;
	}
	var ids = "";
	var val = elements.value;
	var idsMeber = val.split(",");
	var flag=false;
	// 将 Member|123 转换为 123|Member这种类型，或者反过来，差不多那个意思吧，为了满足后台的格式需求
	for(var i = 0; i < idsMeber.length; i++) {
		var id = idsMeber[i];
		var idM = id.split("|");
		if(flag){
			ids += ",";
		}
		ids +=idM[1]+"|"+idM[0];
		flag=true;
	}
	
	var iframeUrl = docURL + "?method=sendToLearn&docId=" + docId
	+ "&userIds=" + encodeURI(ids) + "&userType=member";
	fnSendToDialog(iframeUrl,"${ctp:i18n_2('doc.send.to.airm.msg',1,2)}");
	//$("#iframe_empty").attr("src",iframeUrl);
}

/**
 * 发送到部门文档
 */
var sendToDeptDocItems = {};
function sendToDeptDoc_V5(depAdminSize,docId){
	sendToDeptDocItems.docId = docId;
	if(depAdminSize == '1'){
		var iframeUrl = docURL + "?method=sendToFavorites&docId=" + docId  
			+ "&userIds=&userType=dept";
		fnSendToDialog(iframeUrl,"${ctp:i18n_2('doc.send.to.airm.msg',1,3)}");
	}else{
		var theURL = docURL + "?method=selectDepts";
		getA8Top().selectDeptWin = getA8Top().$.dialog({
            title:" ",
            transParams:{'parentWin':window,'type':'doc'},
            url: theURL,
            width: 360,
            height: 240,
            isDrag:false
        });
	}
}


function sendToDeptDocCollBack(depts,types) {
	getA8Top().selectDeptWin.close();
	if(depts == "" || depts == undefined)
		return;
	if (types == 'doc') {
		var iframeUrl = docURL + "?method=sendToFavorites&docId=" + sendToDeptDocItems.docId
		+ "&userIds="+ depts +"&userType=dept";
		fnSendToDialog(iframeUrl,"${ctp:i18n_2('doc.send.to.airm.msg',1,3)}");
	} else if (types == 'lean') {
		var iframeUrl = docURL + "?method=sendToLearn&docId=" + sendToDeptDocItems.docId  
		+ "&userIds="+ depts +"&userType=dept";
		fnSendToDialog(iframeUrl,"${ctp:i18n_2('doc.send.to.airm.msg',1,4)}");
	}
}

/**
 * 发送到部门学习区
 */
function sendToDeptLearn_V5(depAdminSize,docId){
	sendToDeptDocItems.docId = docId;
	if(depAdminSize == '1'){
		var iframeUrl = docURL + "?method=sendToLearn&docId=" + docId
			+ "&userIds=&userType=dept";
		fnSendToDialog(iframeUrl,"${ctp:i18n_2('doc.send.to.airm.msg',1,4)}");
	}else{
		var theURL = docURL + "?method=selectDepts";
		getA8Top().selectDeptWin = getA8Top().$.dialog({
            title:" ",
            transParams:{'parentWin':window,'type':'lean'},
            url: theURL,
            width: 360,
            height: 240,
            isDrag:false
        });
	}
}

/**
 * 发布文档或文档夹到单位空间
 */
function publishDoc_V5(docId){
	var iframeUrl = docURL + "?method=sendToFavorites&userType=account";
	if (docId == "undefined"){
	    fnSendToDialog(iframeUrl,"${ctp:i18n_2('doc.send.to.airm.msg',3,5)}");
	}else {
		iframeUrl += "&docId=" + docId;
		fnSendToDialog(iframeUrl,"${ctp:i18n_2('doc.send.to.airm.msg',3,5)}");
	}
}

/**
 * 发送到单位学习区
 */
function sendToAccountLearn_V5(docId){
	var iframeUrl = docURL + "?method=sendToLearn&docId=" + docId
		+ "&userIds=&userType=account";
	fnSendToDialog(iframeUrl,"${ctp:i18n_2('doc.send.to.airm.msg',1,6)}");
}
/**
 * 发送到集团首页
 */
function sendToGroup_V5(docId){
	var iframeUrl = docURL + "?method=sendToFavorites&userType=group";
	if (docId == "undefined"){	
	  fnSendToDialog(iframeUrl,"${ctp:i18n_2('doc.send.to.airm.msg',1,7)}");
	}
	else {
		iframeUrl += "&docId=" + docId;
		fnSendToDialog(iframeUrl,"${ctp:i18n_2('doc.send.to.airm.msg',1,7)}");
	}
}

/**
 * 发送到集团学习区
 */

function sendToGroupLearn_V5(docId){
    var iframeUrl = docURL + "?method=sendToLearn&docId=" + docId
    	+ "&userIds=&userType=group";
    fnSendToDialog(iframeUrl,"${ctp:i18n_2('doc.send.to.airm.msg',1,8)}");
}

/**
 *  'MyFavorite'=1
 *  'ToLearn'=2
 *  'ToDeptDoc'=3
 *  'ToDeptLearn'=4
 *  'publishDoc'=5
 *  'ToAccountLearn'=6
 *  'ToGroup'=7
 *  'ToGroupLearn'=8
 * @param _this
 * @returns
 */
function fnSendToDialog(url,msg){
    $("#fromDiv").jsonSubmit({
        action : url+"&isNewFrame=true",
        callback : function(oReturn) {
            if(oReturn!=null&&typeof(oReturn)!='undefined'){
               $.infor($.parseJSON(oReturn).message);
            }else{
                $.infor(msg);
            }
        }
    });
}
// 人员卡片,点击
function showCTPMemberCard(_this){
    var userId=$(_this).attr("userId");
    $(this).PeopleCard({
        memberId : userId
    });  
}
/**
 * 人员卡片，onMoueseOver
 */
function initPeopleCardMini(){
    $("img[id^=personCard]").each(function(index) {
        if($(this).attr("isValid")!=null&&$(this).attr("isValid")=='true'){
            $(this).PeopleCardMini({
                memberId : $(this).attr("userId")
            });
        }else{
            $(this).addClass("common_disable").attr("title","${ctp:i18n('doc.alert.user.inexistence')}");
        }
    });
}


/**
 * 人员卡片
 */
function fnPersonCard(userId) {
    var userIdTemp = '${doc.createUserId}';
    if(typeof(userId)!=='undefined'){
        userIdTemp = userId;
    }
	if("glwd"=="${param.openFrom}"){
		targetW=window;
	}else{
		targetW=top;
	}
	$.PeopleCard({
		targetWindow:targetW,
        memberId : userIdTemp
    });
}

/**
 * 文档推荐
 */
function fnCommend(docId, recommendEnable) {
	doc_recommend(docId, recommendEnable);	
}
/**
 * 睡眠函数
 * @param millisecondi
 * @returns
 */
function pause(millisecondi)
{
    var now = new Date();
    var exitTime = now.getTime() + millisecondi;

   while(true)
    {
        now = new Date();
        if(now.getTime() > exitTime) return;
    }
}
