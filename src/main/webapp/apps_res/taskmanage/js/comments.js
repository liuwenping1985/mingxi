/**
 * 页签切换
 */
function taskLiEvent(ulFlag){
    if(areaObj==null){
        areaObj = $("#replyArea");
    }
    areaObj.hide();
    if(!ulObj){
        ulObj=$("#task_reply_li");
    }
    ulObj.removeClass("current");
    //时间线背景图
    $("#tabs_area").removeClass("tabs_area_body_timeLineBg");
    switch(ulFlag){
    case 0:
        $("#task_reply_li").addClass("current");
        ulObj=$("#task_reply_li");
        areaObj=$("#replyArea");
        areaObj.show();
        $("#tabs_area").height($("#replyArea").height());
        break;
    case 1:
        $("#task_sta_li").addClass("current");
        ulObj=$("#task_sta_li");
        areaObj=$("#feedbackAreaIframe");
        areaObj.show();
        if(!hasLoadingFeedback){
        	$("#feedbackAreaIframe").attr("src",$("#feedbackAreaIframe").attr("hrefAttr"));
        	hasLoadingFeedback = true;
        }else{
        	$("#feedbackAreaIframe")[0].contentWindow.setHeight();
        }
         $("#feedBackHtml,#domain_task_feedback").css("background-color","rgb(246, 246, 246)");
         //时间线背景图  时间线设置一调整到taskFeedbackIndex.jsp-->setHeight()
         //$("#tabs_area").addClass("tabs_area_body_timeLineBg");
        break;
    case 2:
        $("#task_log_li").addClass("current");
        // $("#body_area").css("overflow","scroll");
        ulObj=$("#task_log_li");
        areaObj=$("#logArea");
        areaObj.show();
        if(!hasLoadingLog){
        	$("#task_log_iframe").attr("src",$("#task_log_iframe").attr("hrefAttr"));
        	hasLoadingLog = true;
        }else{
        	$("#task_log_iframe")[0].contentWindow.setNotContent();
        }
        //时间线背景图
        $("#tabs_area").addClass("tabs_area_body_timeLineBg");
        break;
    }
}


/**
 * 加载回复区域(无论回复区域是否已经加载)
 */
$.fn.loadCommentArea = function(moduleType, moduleId){
    var commentArea = $(this);
    commentArea.find("ul.commentParent > li:gt(1)").remove();
    var url = _ctxPath+"/comments/comments.do?moduleType="+moduleType+"&moduleId="+moduleId;
    if(from=="planTask"||from=="bnOperate"){
    	url = url + "&canfeedBack=false";
    }
    if(commentArea.size()>0){
        commentAjax(url
           ,"get", {}, ""
           ,function(text){
               if(text!=null){
                   text = $.trim(text);
                   if(text!=""){
                	   $(".have_a_rest_area").hide();
                       commentArea.find("ul.commentParent").append(text);
                   }else if(from=='bnOperate'||from=='planTask'){
                	   $(".have_a_rest_area").show();
                   }
               }
               window.setTimeout(function(){
                    commentArea.find("ul.commentParent > li:gt(1)").find("div.comp").each(function(){
                    	$(this).compThis();
                    });
                    commentArea.find("span.right").each(function(){
                        $(this).bindMouseOut();
                    });
                    commentArea = null;
                    bindHoverEvent();
               },500);
           });
    }
}
$.fn.textareaGray = function(value){
	if(this){
	   var textArea = $(this);
       var defaultValue = value || textArea.attr("defaultValue");
       if(defaultValue){
		   textArea.html(defaultValue).addClass("color_gray");
		   textArea.focus(function(){
		   	   var val = $(this).val();
		   	   if(val==defaultValue){
		   	   	   $(this).removeClass("color_gray").val("");
		   	   }
		   }).blur(function(){
		       var val = $(this).val();
	           if(val==null || val==""){
	               $(this).addClass("color_gray").val(defaultValue);
	           }
		   });
       }
	   textArea = null;
	}
}
/**
 * 这个功能花费了不少时间，终于使用延迟解决了。
 * 两个区域都不在的时候，才去隐藏点赞区域
 */
$.fn.bindMouseOut = function(){
	var btnout = true, areaout = true;
    var priseTextArea = $(this).find("div.tabs_reply_like > div");
    priseTextArea.unbind();
    priseTextArea.mouseout(function(){
    	var tempObj = $(this).parent();
    	window.setTimeout(function(){
    		areaout = true;
	        if(btnout && areaout){
	           tempObj.addClass("hidden");
	        }
	        tempObj = null;
    	},500);
    });
    priseTextArea.mouseover(function(){
    	areaout = false;
    });
    var priseBtn = $(this).find("span.praiseBtn");
    priseBtn.unbind();
    priseBtn.mouseover(function(){
    	btnout = false;
    	showPraiseText($(this).attr("commentId"), $(this));
    });
    priseBtn.mouseout(function(){
    	var tempObj = $(this).parent().find("div.tabs_reply_like");
    	window.setTimeout(function(){
	        btnout = true;
	        if(btnout && areaout){
	            tempObj.remove();
	        }
	        tempObj = null;
    	},100);
    });
    priseTextArea = priseBtn = null;
}
/**
*绑定hover效果
*/
function bindHoverEvent(){
	$("[name='memberName']").live("mouseover",function(){
    	$(this).css("color","#318ed9");
    }).live("mouseout",function(){
    	$(this).css("color","gray");
    })
    $("[name='attrFileUpload']").next().find(".attachment_block").css("color","gray");
    $("[name='attachmentResourceTR']+div a").css("color","gray").live("mouseover",function(){
    	$(this).css("color","#318ed9");
    }).live("mouseout",function(){
    	$(this).css("color","gray");
    })
}
function showPropleCard(memberId){
    $.PeopleCard({
        targetWindow:getCtpTop(),
        memberId:memberId
    });
}
function showValideError(text, areaObj){
	if(areaObj.size()>0 && areaObj.hasClass("hidden") && text!=null && $.trim(text)!=''){
		areaObj.removeClass("hidden");
		areaObj.find("span").text(text);
		window.setTimeout(function(){
			areaObj.addClass("hidden");
            areaObj.find("span").text("");
            areaObj = null;
		},3000)
	}else{
		areaObj = null;
	}
}
/**
 * 添加一条新的回复
 */
var __addNewCommentFlag = true;//true表示可以添加
function addNewComment(obj, moduleType, moduleId){
	$(obj).addClass("common_button_disable");
	if(!__addNewCommentFlag){
		$(obj).removeClass("common_button_disable");
		return;
	}
	__addNewCommentFlag = false;
    var replyArea = $(obj).closest("li.tabs_reply_list");
    var comData = {};
    var content = $("#commentContent").val();
    var result = simpleCommentValidate(content,501,true,$("#commentContent").attr("defaultValue"));
    comData.method = "addNewComment";
    comData.moduleType = ""+moduleType;
    comData.moduleId = ""+moduleId;
    comData.content = result.content;
    comData.path = "pc";
    $("#content_deal_attach_comment").html("");
    $("#content_deal_assdoc_comment").html("");
    //关联和附件
    saveAttachmentPart("content_deal_attach_comment");
    var tempAtt = $("#content_deal_attach_comment").formobj();
    if(tempAtt!=null){
    	if($.isArray(tempAtt)){
    	   comData.attachList = $.toJSON(tempAtt);
    	}else{
    		comData.attachList = $.toJSON([tempAtt]);
    	}
    }
    if(result.success==false && (comData.attachList==""||comData.attachList=="[]")){
        //$.alert(result.msg);
        showValideError(result.msg, $("#commentErrorArea"));
        $(obj).removeClass("common_button_disable");
        __addNewCommentFlag = true;
        return;
    }
    commentAjax(_ctxPath+"/comments/comments.do?method="+comData.method
            ,"post", comData, ""
            ,function(text){
                if(text){
                    text = $.trim(text);
                    if(text!=""){
                        //添加成功，清空正文内容和关联、附件的内容
                        $("#commentContent").val("").blur();
                        var attAreaObj = $("#commentsAttmentDiv");
                        var moduleType = attAreaObj.attr("moduleType");
                        attAreaObj.html("");
                        var temp = getAttAreaHtml(moduleType);
                        attAreaObj.html(temp);
                        deleteAllAttachment(2,$("#attachment2Area_comment").attr("poi"));
                        deleteAllAttachment(0,"_comment");
                        var tempObj = $(text);
                        tempObj.find("p").attr("style","word-wrap:break-word;word-break:break-all;");
                        replyArea.after(tempObj);
//		                window.setTimeout(function(){
		                    tempObj.find("div.comp").each(function(){
		                        $(this).compThis();
		                    });
                            tempObj.find("span.right").each(function(){
                                $(this).bindMouseOut();
                            });
		                    attAreaObj.find("div.comp").each(function(){
                                $(this).compThis();
                            });
                            attAreaObj = null;
		                    tempObj = null;
		                    bindHoverEvent();
//		               },500);
                    }
                }
                __addNewCommentFlag = true;
                replyArea = null;
                $(obj).removeClass("common_button_disable");
            });
}
function getAttAreaHtml(moduleType){
	return '<div id="attachmentTR" style="display:none;"></div>' +
    '<div id="content_deal_attach_comment" class="comp clearfix" comp="type:\'fileupload\',applicationCategory:\'' + moduleType +
    '\',attachmentTrId:\'_comment\',canDeleteOriginalAtts:true,canFavourite:false" attsdata=\'\'></div>' +
    '<div id="content_deal_assdoc_comment" class="comp clearfix" comp="type:\'assdoc\',applicationCategory:\'' + moduleType +
    '\',attachmentTrId:\'_comment\',canDeleteOriginalAtts:true, modids:\'1,3,6\'" attsdata=\'\'></div>';
}
/**
 * 
 */
var __NewCommentComFlag = true;
function showNewCommentComArea(obj){
    var comArea = $(obj).closest("ul.tabs_reply_content");
    if(comArea.find("li.comArea").size()<=0){
        var comcomreplyArea = $("#comcomArea");
        var temp = '<li class="tabs_reply_content_list comArea">'+comcomreplyArea.html()+'</li>';
        tempObj = $(temp);
        //点击添加一条新的震荡回复
        tempObj.find("a.common_button_emphasize").click(function(){
        	$(this).addClass("common_button_disable");
        	if(!__NewCommentComFlag){
        		$(this).removeClass("common_button_disable");
        		return;
        	}
        	__NewCommentComFlag = false;
            var comcomArea = $(this).closest("li");
            var dataArea = comcomArea.parent("ul").find("li:eq(0)");
            var contentTextArea = comcomArea.find("textarea");
            var content = contentTextArea.val();
            var result = simpleCommentValidate(content,501,true,contentTextArea.attr("defaultValue"));
            if(result.success==false){
                contentTextArea = dataArea = comcomArea = null;
            	showValideError(result.msg, $(this).parent().find("div.tabs_reply_error"));
            	__NewCommentComFlag = true;
            	$(this).removeClass("common_button_disable");
            	return;
            }
            var pid = dataArea.attr("cid");
            var moduleId = dataArea.attr("mid");
            var moduleType = dataArea.attr("mtp");
            dataArea = null;
            var comData = {};
            comData.method = "addNewComCom";
            comData.moduleType = ""+moduleType;
            comData.moduleId = ""+moduleId;
            comData.pid = ""+pid;
            comData.content = result.content;
            comData.path = "pc";
            commentAjax(_ctxPath+"/comments/comments.do?method="+comData.method
                    ,"post", comData, ""
                    ,function(text){
                        if(text!=null){
                            text = $.trim(text);
                            if(text!=""){
                            	var tempObj = $(text);
                            	tempObj.find("p").attr("style","word-wrap:break-word;word-break:break-all;");
                                comcomArea.before(tempObj);
                                comcomArea.remove();
                            }
                        }
                        __NewCommentComFlag = true;
                        contentTextArea = dataArea = comcomArea = null;
                        bindHoverEvent();
                    });
        });
        tempObj.find("a.common_button_gray").click(function(){
            $(this).closest("li").remove();
        });
        comArea.append(tempObj);
        tempObj.find("textarea").textareaGray();
        tempObj.find("textarea").focus();
        tempObj = comcomreplyArea = null;
    }
    $(this).removeClass("common_button_disable");
    comArea = null;
}
/**
 * 简单校验组件
 */
function simpleCommentValidate(content,maxLength,notNull,defaultValue){
	var success=true,msg="",realCon="";
	if(content==null || $.trim(content)=='' || content==defaultValue){
		success=false;
		realCon="";
		//msg="回复内容不能为空！";
		msg = $.i18n("taskmanage.comment.content.notnull");
	}else if(maxLength && content.length>=maxLength){
		success=false;
		realCon="";
        //msg="回复内容不能超过500字！";
        msg = $.i18n("taskmanage.comment.content.maxLength",500);
	}else{
		realCon=content;
	}
	return {success:success, msg:msg, content:realCon};
}
function insertAttachmentComment(){
	insertAttachmentPoi("_comment");
}
function quoteDocumentComment(){
	quoteDocument("_comment");
}
/**
 * 点赞
 */
function praiseComment(commentId, domObj){
	var tempDom = $("#replyArea");
	tempDom = null;
    var cmr = new ctpCommentManager();
    var obj = new Object();
    obj.moduleId = commentId;
    obj.praiseMemberId = $.ctx.CurrentUser.id;
    //删除
    var priseObj = $(domObj);
    var numberObj = $(domObj).next("span");
    if(priseObj.hasClass("like_16")){
        cmr.deletePraise(obj,{
            success : function(flag){
                if(flag){
                    //回填名字  人数 
                    if(numberObj[0].innerText !=""){
                    	var number = parseInt(numberObj[0].innerText) - 1;
                    	if(number==0){
                    		number = "";
                    	}
                        numberObj[0].innerText = number;
                    }else{
                    	numberObj[0].innerText = "";
                    }
                    //改变图标的颜色 +title
                    priseObj.removeClass("like_16").addClass("no_like_16");
                    var newTitle = $.i18n("taskmanage.reply.prise");
                    priseObj.attr("title", newTitle);
                }
                priseObj = numberObj = null;
            }, 
            error : function(request, settings, e){
            	priseObj = numberObj = null;
                $.alert(e);
            }
        });
    //新增
    }else if(priseObj.hasClass("no_like_16")){
        obj.subject = $("#replyArea").attr("moduleId")||"";
        cmr.addPraise(obj,{
            success : function(flag){
                if(flag){
                    //回填名字  人数 
                    numberObj[0].innerText = parseInt(numberObj[0].innerText||"0") + 1;
                    //改变图标的颜色 +title
                    priseObj.removeClass("no_like_16").addClass("like_16");
                    var newTitle = $.i18n("taskmanage.reply.noprise");
                    priseObj.attr("title", newTitle);
                }
                priseObj = numberObj = null;
            }, 
            error : function(request, settings, e){
                priseObj = numberObj = null;
                $.alert(e);
            }
        });
    }
}
/**
 * 显示点赞人数
 */
function showPraiseText(commentId, domObj){
    var numberObj = $(domObj);
    if($.trim(numberObj.text())!=""){
    	//var areaObj = numberObj.parent().find("div.tabs_reply_like");
	        var cmr = new ctpCommentManager();
	        var obj = new Object();
	        obj.moduleId = commentId;
	        var text = cmr.getPraiseNames(obj);
	        if(text==null || $.trim(text)!=""){
	            //$.alert(pn)s;
	            //areaObj.removeClass("hidden");
	            var tabsReplayNameHtml="<div class='tabs_reply_like'><div style='font-size: 12px;'>"+text+"</div><em class='tabs_reply_like_arrow'></em></div>";
	            numberObj.before(tabsReplayNameHtml);
	            var height=numberObj.parent().find("div.tabs_reply_like").height();
	            numberObj.parent().find("div.tabs_reply_like").css({"position":"fixed","top":numberObj.offset().top-height-10,"right":"60px","bottom":"auto"});
	            numberObj.parent().find("em.tabs_reply_like_arrow").css({"position":"fixed","top":numberObj.offset().top-9,"right":"85px","bottom":"auto"})
	            //areaObj.find("div").text(text);
	    	}
	    areaObj = null;
    }
    numberObj = null;
}
/**
 * ajax方法
 */
function commentAjax(url, method, data, errorText, callback){
	var tempTime = new Date().getTime();
	url = url + "&temp=" + tempTime;
    $.ajax({
        url:url
        ,type:method
        ,data:data
        ,success:function(text){
            if(typeof callback == 'function'){
                callback(text);
            }
        }
        ,error:function(){
            if(typeof callback == 'function'){
                callback();
            }
            var obj = $.alert(errorText||$.i18n('taskmanage.operate.often.label'));
            window.setTimeout(function(){
                obj.close();
                obj = null;
            }, 3000);
        }
    });
}