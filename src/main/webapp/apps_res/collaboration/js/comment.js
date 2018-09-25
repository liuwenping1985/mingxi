function showOrCloseNamesDiv(commentId){
	if($("#likeIcoNumber"+commentId)[0].innerText =="0"){
		$("#likeIcoDiv"+commentId).addClass("hidden");
		return;
	}
	var cmr = new ctpCommentManager();
	var obj = new Object();
	obj.moduleId = commentId;
	var pn = cmr.getPraiseNames(obj);
	if($("#likeIcoDiv"+commentId).is(":hidden")){
		var numbertop = $("#likeIcoNumber"+commentId).position().top;
		var numberLeft = $("#likeIcoNumber"+commentId).position().left;
		$("#likeIcoDiv"+commentId).removeClass("hidden").html(pn);
		$("#triangle"+commentId).removeClass("hidden");
		if($.browser.msie && $.browser.version == "7.0"){
			$("#likeIcoDiv"+commentId).css("top",numbertop-25);
			$("#likeIcoDiv"+commentId).css("left",numberLeft-28).css("border","1px solid #D2D2D2");
		}else{
			setTimeout(function(){
				$("#likeIcoDiv"+commentId).css("top",numbertop-$("#likeIcoDiv"+commentId).height()-10);;
			},0);
			$("#likeIcoDiv"+commentId).css("left",numberLeft-$("#likeIcoDiv"+commentId).width()).css("border","1px solid #D2D2D2");
		}
	}else{
		$("#likeIcoDiv"+commentId).addClass("hidden");
		$("#triangle"+commentId).addClass("hidden");
	}
}
function praiseComment(commentId){
	var cmr = new ctpCommentManager();
	var obj = new Object();
	obj.moduleId = commentId;
	obj.praiseMemberId = $.ctx.CurrentUser.id;
	//删除
	if($("#likeIco"+commentId).hasClass("like_16")){
		cmr.deletePraise(obj,{
			success : function(flag){

	            	//回填名字  人数 
	            	
	            	$("#likeIcoNumber"+commentId)[0].innerText = flag;
	            	
	            	//改变图标的颜色 +title
	            	$("#likeIco"+commentId).removeClass("like_16").addClass("no_like_16");
	            	$("#likeIco"+commentId)[0].title=_praise;

        	}, 
        	error : function(request, settings, e){
        		$.alert(e);
        	}
		});
	//新增
	}else if($("#likeIco"+commentId).hasClass("no_like_16")){
		obj.subject = parent.summaryId;
		cmr.addPraise(obj,{
	        success : function(flag){
	
	            	//回填名字  人数 
	            	$("#likeIcoNumber"+commentId)[0].innerText = flag;
	            	//改变图标的颜色 +title
	            	$("#likeIco"+commentId).removeClass("no_like_16").addClass("like_16");
	            	$("#likeIco"+commentId)[0].title=_praiseC;

	        }, 
	        error : function(request, settings, e){
	            $.alert($.i18n('collaboration.error.net.alert'));
	        }
	    });
	}else{
		return;
	}
	
	

}
 function showPropleCard(memberId){
       if(openForm != 'glwd' && openForm != 'docLib'){
           targetW = getCtpTop();
       } else {
           targetW = window;
       }
       if(newGovdocView==1){
    	   targetW = getCtpTop();
       }
       $.PeopleCard({
           targetWindow:targetW,
           memberId:memberId
       });
   }
function _commentHidden(th) {
    var t = $(th), p = t.parent().parent().next();
    if(th.checked) {
      p.css("display","inline");
    }else {
      p.hide();
    }
  }


function _pushMessageHidden(th) {
  var t = $(th), p = t.parent().parent().next();
  if(th.checked) {
    p.show();
  }else {
    p.hide();
  }
}



var _commentCounter = 0;
var  _commentNum = 0;
var  currentSelectedObj = null;
$.content.commentSearchCreate = function(str, flag) {
  if(!str || "" === str){
      return;
  }
  _commentCounter++;
  if(_commentCounter>=3) {
    _commentCounter = 0;
      return; //这个变量又来避免查不到内容的时候死循环。
  }
  if(flag == "forward"){//向前查找
      var c;
      if( _commentNum == _commentTotal) { 
          c = 1;
      } else { 
          c = _commentNum+1; 
      }       
      if(currentSelectedObj != null) {
          $(currentSelectedObj).removeClass("selectMemberName");
      }  
      for(var i =c;i<= _commentTotal;i++){
          var obj = document.getElementById("commentSearchCreate"+i);
          if(obj){
              if(obj.innerHTML.indexOf(str) != -1){
                  
                  $('html,body').animate({scrollTop: $(obj).offset().top}, 100);
                  
                  /*这种跳转到锚点的方式会导致Iframe上移动
                  var path = document.location.href;
                  var jinghao = path.indexOf("#");
                  if(jinghao > 0){
                      path = path.substring(0, jinghao);
                  }
                  document.location.href = path + "#commentSearchCreate" + i;*/
                  $(obj).addClass("selectMemberName");
                  _commentNum = i;
                  _commentCounter = 0;
                  currentSelectedObj = obj;
                  break;
              }else if( i == _commentTotal){
                  _commentNum = i;
                  $.content.commentSearchCreate(str,flag);
              }
          }
      }
  }else if(flag == "back"){ //向后查找
      var c;
      if(_commentNum <= 1){
          c = _commentTotal;
      }else{
          c = _commentNum - 1;
      }
      if(currentSelectedObj!=null) {
          $(currentSelectedObj).removeClass("selectMemberName");
      }
      for(var i =c;i>=1 ;i--){
          var obj = document.getElementById("commentSearchCreate"+i);
          if(obj){
              if(obj.innerHTML.indexOf(str) != -1){
                  
                  $('html,body').animate({scrollTop: $(obj).offset().top}, 100);
                  
                  /*这种跳转到锚点的方式会导致Iframe上移动
                  var path = document.location.href;
                  var jinghao = path.indexOf("#");
                  if(jinghao > 0){
                      path = path.substring(0, jinghao);
                  }
                  document.location.href = path + "#commentSearchCreate" + i;*/
                  $(obj).addClass("selectMemberName");
                  _commentNum = i;
                  _commentCounter = 0;
                  currentSelectedObj = obj;
                  break;
              }else if( i == 1 ){
                  _commentNum = 1;
                  $.content.commentSearchCreate(str,flag);
              }
          }
      }
  }
};

  function showToIdSelectPeople(commonId){
      $.selectPeople({
          callback : function(rv){
              $("#reply_" + commonId + " #showToIdText").val(rv.text);
              $("#reply_" + commonId + " #showToIdText")[0].title = rv.text;
              $("#reply_" + commonId + " #showToId").val(rv.value);
          },
          showBtn:false,
          params : {
              text : $("#reply_" + commonId + " #showToIdText").val(),
              value: $("#reply_" + commonId + " #showToId").val()
          },
          mode:"open",
          panels:"Department,Team,Post,Outworker,RelatePeople",
          minSize:0,
          selectType:"Member",
          showFlowTypeRadio: false
      });      

  }

  function commentShowReplyComment(commentObj, obj){
	  //流程追溯，普通回退的时候要允许回复。   
	  if(workflowTraceType != '6' && openForm != 'supervise' ){
		  if(!parent.isAffairValid(contentAffairId)) {
			  return;
		  }
	  }
      function replaceAll(htm, a, b) {
          return htm.replace(new RegExp("\{" + a + "\}", "gm"), b);
      };
  
      var html = $("#commentHTMLDiv").html().toString();
      
      html = replaceAll(html, "comment.id",         commentObj.id);
      html = replaceAll(html, "comment.clevel",     commentObj.clevel);
      html = replaceAll(html, "comment.moduleType", commentObj.moduleType);
      html = replaceAll(html, "comment.moduleId",   commentObj.moduleId);
      html = replaceAll(html, "comment.createId",   commentObj.createId);
      if (commentObj.affairId == "" || commentObj.affairId == null) {
          html = replaceAll(html, "comment.pushMsgAffairId", contentAffairId);
      } else {
          html = replaceAll(html, "comment.pushMsgAffairId", commentObj.affairId);
      }
      var temp = $(html);
      //alert($("#content",document.getElementById("#reply_"+commentObj.id)));
      $("#content",temp).on("keyup",function(e){
    	  	//alert(e.keyCode)
    	  	if(e.keyCode != 50){
    		//if(e.keyCode == 8 || e.keyCode == 16 || e.keyCode == 13){//backspace || shift
    			return;
    		}
    		var cursorPosObj = parent.getTextAreaPosition(this);
    		//alert(this.value +"***"+cursorPosObj.endPos-1);
    		if(this.value.charAt(cursorPosObj.endPos-1) == '@'){
    			isclickInput = false;
    			parent.cursorPos = cursorPosObj.endPos-1;
    			//alert(3);
    			pushMessageToMembers2($("#replyMesP",document.getElementById("#reply_"+commentObj.id)),this);
    			$("#content",temp).trigger("blur");
    		}
    	});
      $("#reply_" + commentObj.id).empty().append(temp);
      commentShowReply(commentObj.id, commentObj.createName, obj);
  };
  //删除意见
  function delComment(commentId){
	  
    var mgr = new colManager();	
    if(confirm("确定要删除本条意见吗？"))
    {
    mgr.delComment(
    		commentId,
            {
              success : function(ret) {
            	  if(ret == "1"){
            		  alert("删除成功");
            	  }else{
            		  alert("删除失败");
            	  }
            	  parent.window.location.href=parent.window.location;
              }
            });
    }
  }
  //修改意见
  function ModifyComment(commentObj, obj){
      function replaceAll(htm, a, b) {
          return htm.replace(new RegExp("\{" + a + "\}", "gm"), b);
      };
  
      var html = $("#modifyCommentHTMLDiv").html().toString();
      
      html = replaceAll(html, "comment.id",         commentObj.id);
      html = replaceAll(html, "comment.moduleId",   commentObj.moduleId);
      if (commentObj.affairId == "" || commentObj.affairId == null) {
          html = replaceAll(html, "comment.pushMsgAffairId", contentAffairId);
      } else {
          html = replaceAll(html, "comment.pushMsgAffairId", commentObj.affairId);
      }
      var temp = $(html);
      //alert($("#content",document.getElementById("#reply_"+commentObj.id)));
      $("#modifyContent",temp).on("keyup",function(e){
    	  	//alert(e.keyCode)
    	  	if(e.keyCode != 50){
    		//if(e.keyCode == 8 || e.keyCode == 16 || e.keyCode == 13){//backspace || shift
    			return;
    		}
    		var cursorPosObj = parent.getTextAreaPosition(this);
    		//alert(this.value +"***"+cursorPosObj.endPos-1);
    		if(this.value.charAt(cursorPosObj.endPos-1) == '@'){
    			isclickInput = false;
    			parent.cursorPos = cursorPosObj.endPos-1;
    			//alert(3);
    			$("#modifyContent",temp).trigger("blur");
    		}
    	});
      $("#reply_" + commentObj.id).empty().append(temp);
      var tempContent = commentObj.content.replace(/<br\s*\/?\s*>/ig, '\r\n');
      var dm = $("#reply_"+commentObj.id);
      $("#modifyContent",dm).val(tempContent);
      commentModifyShowReply(commentObj.id,obj);    
  };
  
  //点击‘编辑’调用方法
  function commentModifyShowReply(rid,obj) {
	$("#ulcomContent"+rid).removeClass("hiddenNullOpinion");
    $("#reply_" + rid).show();
    $(window).scrollTop($(obj).position().top);
    if (rid != "sender"){
        $("#modifyContent", $("#reply_" + rid)).focus();
    }else{
    	 $("div[id^=likeIcoDiv]").addClass("hidden");
    }
   
  }
  //点击‘发起人附言’调用方法
  function commentShowReply(rid,createName,obj) {
	$("#ulcomContent"+rid).removeClass("hiddenNullOpinion");
	if(workflowTraceType != '6' && openForm != 'supervise'){
      if(!parent.isAffairValid(contentAffairId)) {
          return;
      }
	}
    $("#reply_" + rid).show();
    if($("#reply_" + rid).length>0){
    	 $(window).scrollTop($("#reply_" + rid).position().top);
    }
    if (rid != "sender"){
        $("#content", $("#reply_" + rid)).focus();
    }else{
    	 checkCommonContentOut("mutclick");
    	 $("div[id^=likeIcoDiv]").addClass("hidden");
    }
    if($.ctx.CurrentUser.name != createName){
      $("#pushMessage",$("#reply_"+rid)).attr("checked",true);
    }else{
        if($.browser.msie || $.browser.version=='6.0'){
            $("#reply_pushMessage_div_"+rid).css("display","inline-none");
        } else{
            $("#reply_pushMessage_"+rid).parent().hide();
        }
    }
    if($.browser.msie && $.browser.version=='6.0'){
      $("#reply_pushMessage_div_"+rid).css("display","inline");
    }else if (_currentUserName != createName){
      $("#pushMessage",$("#reply_"+rid)).parent().parent().next().css("display","inline-block");
    }
    if (createName!="" && _currentUserName != createName) {
        $("#reply_pushMessage_"+rid).val(createName);
    } else {
        $("#reply_pushMessage_"+rid).val();
    }
    if($.i18n("collaboration.newcoll.fywbzyl") == $("#senderpostscriptDiv #content").val()){
    	$("#senderpostscriptDiv #content").val($.i18n("collaboration.newcoll.fywbzyl"));
    }else{
    	$("#senderpostscriptDiv #content").val($("#senderpostscriptDiv #content").val());
    }
  }
  
  
  
  
  
  
  //点击 ‘取消'调用方法
  function commentHideReply(rid) {
	$("h3.per_title").css("clear","none");
    $("#reply_" + rid).hide();
    //将选中的'意见隐藏'置为不可选，并且隐藏相应的区域
    $("[name='hidden']").each(function(){
        //取消全选
        $(this).removeAttr("checked");
        _commentHidden(this);
    });
    //将选中的'消息推送'置为不可选，并且隐藏相应的区域
    $("[name='pushMessage']").each(function(){
        //取消全选
        $(this).removeAttr("checked");
        _pushMessageHidden(this);
    });
    $("#reply_"+rid+" #pushMessageToMembers").val("[]");
    
    clearAtt(rid);
  }
  var tempAttActionLog = null;  
  //编辑意见修改保存
  function saveCommentModfiy(rid,t){
    $("#ulcomContent"+rid).show();
    var  dm = $("#reply_" + rid);
    var contentArea = $("#modifyContent", dm);
    var tempContent = contentArea.val();
    if ($.trim(tempContent) == ""){
        var colm = new colManager();
        var reval = colm.needFillOpinion(rid);//处理时必须填写意见
        if(reval=="needFillOpinion"){
    		 $.alert($.i18n('collaboration.common.deafult.dealCommentNotNull'));
    		 contentArea.focus();
    	     i = 0;
    		 return;
    	}
    }
  
    var theForm = document.getElementById("opinionForm");
    if(attActionLog){
        $(theForm).append(attActionLog.toInput());
     }
    attActionLog=tempAttActionLog;
    for (var i=0;i<theForm.length;i++)
    {
	   if(theForm.elements[i].name=="modifyContent"){
		   theForm.elements[i].value = tempContent;
	   }
    }   
    try{
    	 theForm.action = _ctxPath
    			+"/collaboration/collaboration.do?method=editOpinion&editOpinionId="+rid+"&affairId="+affairId;
    }catch(e){
    	theForm.action = _ctxPath+"/collaboration/collaboration.do?method=editOpinion&editOpinionId="+rid;
    }
    theForm.method = "POST";
    theForm.submit();
  }
  //弹出修改附件页面
  function opinionEditAttachment(_subRef){
	    var _ref = parent.summaryId;
		var temp_attrs = new ArrayList();
	    var keys = fileUploadAttachments.keys();
	    // 过滤非正文区域的附件
	    for(var i = 0; i < keys.size(); i++) {
	    	var att = fileUploadAttachments.get(keys.get(i));
	    	if(att.subReference==_subRef){
	    		temp_attrs.add(att);
	    	}
	    }
	    editOpinionAttachments(temp_attrs,_ref,_subRef,'4');
  }
//弹出修改附件页面
  function editOpinionAttachments(atts, reference, subReference, category) {
  		attActionLog = new AttActionLog(reference, subReference, null, atts);
  	reference = reference || "";
  	subReference = subReference || "";
  	var dialog = $.dialog({
  		id : "showForwardDialog",
  		url : _ctxPath
  				+ "/genericController.do?ViewPage=apps/collaboration/fileUpload/attEdit&category="
  				+ category + "&reference=" + reference
  				+ "&subReference=" + subReference
  				+ "&secretLevel="+$("#secretLevel").val()+"&v="+new Date(),
  		title : $.i18n("collaboration.nodePerm.allowUpdateAttachment"),
  		targetWindow : getCtpTop(),
  		transParams : {
  			attActionLog : attActionLog
  		},
  		width : 550,
  		height : 430,
  		buttons : [
  			{
  				id : "okButton",
  				text : $.i18n("common.button.ok.label"),
  				handler : function() {
  					var retValue = dialog.getReturnValue();
  					if (retValue) {
  						var attachmentList = new ArrayList();
  						var inst = retValue[0].instance;
  						var delIds = retValue[2].instance;
  						for(var i =0;i<delIds.length;i++){
  							fileUploadAttachments.remove(delIds[i]);
  						}
  						$("#attachmentAreareply_modify_attach_"+subReference).html("");
  						$("#attachment2Areareply_modify_attach_"+subReference).html("");
  						$("#attachmentTRreply_modify_attach_"+subReference).css("display","none");
  						$("#attachment2TRreply_modify_attach_"+subReference).css("display","none");
  						for (var i = 0; i < inst.length; i++) {
  							var att = copyAttachment(inst[i]);
  							att.onlineView = false;
  							attachmentList.add(att);
  							addAttachmentPoi(att.type, att.filename, att.mimeType,
  									att.createDate, att.size,
  	                              att.fileUrl, false, att.needClone,
  	                              att.description, att.extension, att.icon, "reply_modify_attach_"+subReference,
  	                              att.reference, att.category, false,null,'',true, false, "", false,false,att.id,false);
  						}
  						var logList = new ArrayList();
  				
  						for (var i = 0; i < inst.length; i++) {
  							var att = copyActionLog(inst[i]);
  							att.action = 0;
  							att.des = inst[i].filename;
  							logList.add(att);
  						}
  						var save = saveEditAttachments(logList,
  								attachmentList);
  						if (!save) {
  							dialog.close();// 关闭窗口
  							return null;
  						}else{
  							for(var k = 0;k<attachmentList.size();k++){
  								var att = attachmentList.get(k);
  								fileUploadAttachments.put(att.fileUrl,att);
  							}
  							dialog.close();
  							return null;
  						}
  						
  					}
  					
  					dialog.close();// 关闭窗口
  				},
  				OKFN : function() {
  					
  					dialog.close();
  				}
  			}, {
  				id : "cancelButton",
  				text : $.i18n("common.button.cancel.label"),
  				handler : function() {
  					dialog.close();
  				}
  			} ]
  	});
  }
  function commentReply(rid,t) {
	
	$("#ulcomContent"+rid).show();
    i = addOne(i);
    if(parseInt(i)>=2){
      if(i>=3) i = 0;
      return;
    }
    var  dm = $("#reply_" + rid);
    var mcp = $("#mcp_" + rid).val()+'';
    var  cp = $("#cp_" + rid).val();
    var pt = cp;
    if ((mcp).length == 1) {
      pt += '00' + mcp;
    } else if ((mcp).length == 2) {
      pt += '0' + mcp;
    } else {
      pt += mcp;
    }
    var contentArea = $("#content", dm);
    if ($.trim(contentArea.val()) == ""){
        $.alert($.i18n('collaboration.common.deafult.commonNotNull'));
        contentArea.focus();
        i = 0;
        return;
    }
    // 检查回复内容长度
    var checkLength = contentArea.val().length;
    if(checkLength > 500){
        $.alert($.i18n('collaboration.common.deafult.commonMaxSize',checkLength));
        contentArea.focus();
        i = 0;
        return;
    }
    $("#path", dm).val(pt);
    $("#mcp_" + rid).val(parseInt(mcp) + 1);
    //先清空上一次保存的附件信息，否则会ID重复
    document.getElementById("reply_attach_"+rid).innerHTML="";
    document.getElementById("reply_assdoc_"+rid).innerHTML="";
    //add by libing
    var srcObj = document.getElementById("#reply_"+rid);
    parent.mergeMesPushFun($("#reply_"+rid+" #replyMesP"),$("#reply_"+rid+" #pushMessageToMembers"),$("#reply_"+rid+" #content"));
    
    var obj = dm.formobj({errorIcon : false});
    var mgr = new colManager();
    saveAttachmentPart("reply_attach_" + rid);
    obj.attachList = $("#reply_attach_" + rid).formobj();
    mgr.insertComment(
            obj,
            openForm,
            {
              success : function(ret) {
            	  if(newGovdocView==1){
						var atts = null;
						if(fileUploadAttachment != null){
							atts = fileUploadAttachment.values();
						}else{
							atts = fileUploadAttachments.values();
						}
						if(atts!=null){
							for(var j = 0; j < atts.size(); j++) {
								var att = atts.get(j);
								if(att.showArea&&att.showArea=='reply_attach_'+rid){
									parent.addAttachmentPoi(att.type, att.filename, att.mimeType,
											att.createDate, att.size,
		                                  att.fileUrl, false, att.needClone,
		                                  att.description, att.extension, att.icon, "ATT",
		                                  att.reference, att.category, false,null,'',true, false, "", false,false,att.id,false);
								}
							}
						}
            	  }
                  var createName = '<a class="font_bold color_blue padding_lr_10" onclick="showPropleCard('+"'"+ret.createId+"'"+')">' + ret.createName;
                  if(ret.extAtt2 != null && ret.extAtt2 != ""){
                      createName = createName + "<div class='display_inline color_red'>"+$.i18n('collaboration.agent.label',ret.extAtt2)+"</div>";
                  }
                  createName = createName + '</a>';
                $("#replyContent_" + rid).show();
                $("#replyContent_" + rid)
                    .append(
                        '<div class="comments_title_in"> <span class="title">'+createName+'</span><span class="right font_size12 color_gray margin_t_5">'+ret.createDateStr+'</span></div>');
                var tmp = $('<div id="hideReplay'+rid+'" class="comments_content"></div>');
                tmp.html("<div class='clearfix' style='word-break: normal; word-wrap:break-word; text-justify: auto; text-align: justify;font-size:12px;'>"+ret.escapedContent+"</div>");
                //如果插入了本地文档
                if(hasUploadAttachment( obj.attachList)){
                  var htm = $("#attachmentTRreply_attach_" + rid)[0].innerHTML ;
                  var ht = htm.replace(/reply_attach_/gi,'');
                  tmp.append($("<div class='clearfix'>"+ht+"</div>"));
                }

                //如果插入了关联附件
                if(hasUploadDocument( obj.attachList)){
                  var htm = $("#attachment2TRreply_attach_" + rid)[0].innerHTML ;
                  var ht = htm.replace(/reply_attach_/gi,'');
                  tmp.append($("<div class='clearfix'>"+ht+"</div>"));
                }
                //tmp.append('<div class="color_gray2">'+ ret.createDateStr + '<div>');
                $("#replyContent_" + rid).append(tmp);
                $(".affix_del_16",$("#replyContent_"+rid)).each(function(){
                  var t = $(this);
                  t.removeClass("affix_del_16 ico16");
                });
                $("#content", dm).val('');
                clearAtt(rid);
                commentHideReply(rid);
                i = 0;
              }
            });
  }
  function hasUploadAttachment (attachList){
    if(attachList == null) return false;
    for(var i = 0; i < attachList.length; i++){
      var att = attachList[i];
      if(att.attachment_type == '0') return true;
    }
    return false;
  }
  
  
  
  function hasUploadDocument (attachList){
    if(attachList == null) return false;
    for(var i = 0; i < attachList.length; i++){
      var att = attachList[i];
      if(att.attachment_type == '2') return true;
    }
    return false;
  }

  function clearAtt(rid){
    //清空正文
    $("#reply_" + rid + " #content").val("");
    //清空附件区，包括附件及统计数字label
    $("#attachmentAreareply_attach_" + rid).children().remove();
    $("#attachment2Areareply_attach_" + rid).children().remove();
    $("#attachmentTRreply_attach_" + rid).attr("style","display:none");
    $("#attachment2TRreply_attach_" + rid).attr("style","display:none");
    $("#attachmentNumberDivreply_attach_" + rid).val("");
    $("#attachment2NumberDivreply_attach_" + rid).val("");
    deleteAllAttachment(0,"reply_attach_"+rid);
    deleteAllAttachment(2,"reply_attach_"+rid);
  }
  function addOne(n){
    return parseInt(n)+1;
  }
  
  
  //发起人附言提交
  var i = 0; //重复提交计算器
  function commentSenderReply(t) {
      checkCommonContent();
    //重复提交检验，点的太快了disable也不管用
    i = addOne(i);
    if(parseInt(i)>=2){
     if(i>=3) i = 0;
      return;
    }
    if($("#pushMessage",$("#reply_sender")).is(":checked")) {
      $("#pushMessage",$("#reply_sender")).val(true);
    }else{
      $("#pushMessage",$("#reply_sender")).val(false);
    }
    var dm = $("#reply_sender");
    //清空上次操作saveAttachmentPart生产的Input隐藏域
    $("#reply_attach_sender").html("");
    var obj = dm.formobj({errorIcon : false});
    if($("#pushMessage",$("#reply_sender")).val()=="true"){
    	obj.pushMessage = true;
    }else if($("#pushMessage",$("#reply_sender")).val()=="false"){
    	obj.pushMessage = false;
    }
    if ($.trim($("#content", dm).val()) == ""){
        $.alert($.i18n('collaboration.common.default.fuyanNotNull'));  //附言内容不能为空！
        $("#content", dm).focus();
        i = 0;
        return;
    }
    // 检查附言长度,不能超过500
    var checkLength = $("#content", dm).val().length;
    if(checkLength > 500){
        $.alert($.i18n('collaboration.common.deafult.commonMaxSize',checkLength)); 
        $("#content", dm).focus();
        i = 0;
        return;
    }
    if($._isInValid(obj)){
      i = 0;
      return;
    }
    var mgr = new colManager();
    saveAttachmentPart("reply_attach_sender");
    obj.attachList = $("#reply_attach_sender").formobj();
    mgr.insertComment(
        obj,
        openForm,
        {
          success : function(ret) {
        	  if(newGovdocView==1){
					var atts = null;
					if(fileUploadAttachment != null){
						atts = fileUploadAttachment.values();
					}else{
						atts = fileUploadAttachments.values();
					}
					if(atts!=null){
						for(var j = 0; j < atts.size(); j++) {
							var att = atts.get(j);
							if(att.showArea&&att.showArea=='reply_attach_sender'){
								parent.addAttachmentPoi(att.type, att.filename, att.mimeType,
										att.createDate, att.size,
	                                  att.fileUrl, false, att.needClone,
	                                  att.description, att.extension, att.icon, "ATT",
	                                  att.reference, att.category, false,null,'',true, false, "", false,false,att.id,false);
							}
						}
					}
        	  }
            var tmp = $('<li></li>');
            tmp.html("<div style='word-wrap:break-word;'><span class='font_size12'>" + ret.escapedContent + '</span></div>');
           
           // var wrap = $("<li></li>");
           // $("#attachmentAreareply_sender").children().removeAttr("style").wrapAll(wrap);
           // $("#reply_sender").before($("#attachmentAreareply_sender").children());
            if(hasUploadAttachment( obj.attachList)){
              var htm = $("#attachmentTRreply_attach_sender")[0].innerHTML ;
              var ht = htm.replace(/reply_attach_/gi,'');
              tmp.append($("<div class='clearfix' style='word-break: normal; word-wrap:break-word; text-justify: auto; text-align: justify;font-size:12px;'>"+ht+"</div>"));
            }

            //如果插入了关联附件
            if(hasUploadDocument( obj.attachList)){
              var htm = $("#attachment2TRreply_attach_sender")[0].innerHTML ;
              var ht = htm.replace(/reply_attach_/gi,'');
              tmp.append($("<div class='clearfix'>"+ht+"</div>"));
            }
            tmp.append('<div class="color_gray2">'+ ret.createDateStr + '<div>');
            $("#reply_sender").before(tmp);
            //去掉删除图标
            $(".affix_del_16",$("#replyContent_sender")).each(function(){
              var t = $(this);
              t.removeClass("affix_del_16 ico16");
            });
            $("#content", dm).val('');
            clearAtt('sender');
            commentHideReply('sender');
            i = 0;
          }
        });
  }
  
  
  
  var _pushMessageLastIdx;
  var dialog;
  function pushMessageToMembers(txtObj, valObj, boolPush, moveToTopId,affairId) {
      try{
      if($.browser.mozilla || $.browser.version=='6.0'|| $.browser.version=='7.0') {
          if ($.browser.version=='6.0'|| $.browser.version=='7.0'){
              parent.showContentView();
           }
          $("#comment_pushMessageToMembers_dialog").css({'display':'block'});
      } 
      if (txtObj && txtObj.val() != "" && valObj &&  valObj.val() == "[]") {
          valObj.val('[["'+affairId+'","'+moveToTopId+'"]]');
      }
    //置顶还原
    $("tbody tr._topped", $("#comment_pushMessageToMembers_grid")).each(function(){
      var t = $(this);
      if(_pushMessageLastIdx) {
        var par = $("tbody tr", $("#comment_pushMessageToMembers_grid"))[_pushMessageLastIdx];
        if(par != this)
          $(par).after(t);
      }
      t.removeClass("_topped");
    });
    if(moveToTopId) {
      //根据传入的优先排序记录ID进行排序
      $("tbody tr", $("#comment_pushMessageToMembers_grid")).each(function(i){
        var t = $(this);
        if(!t.hasClass("_pm_fixed") && t.attr("memberId") == moveToTopId) {
          var _pushMessageFixObj = $("tbody tr._pm_fixed", $("#comment_pushMessageToMembers_grid"));
          if(_pushMessageFixObj.length > 0)
            _pushMessageFixObj.after(t);
          else
            $("tbody", $("#comment_pushMessageToMembers_grid")).prepend(t);
          _pushMessageLastIdx = i;
          t.addClass("_topped");
          return false;
        }
      });
    }
    var cv = valObj.val();
    if(cv && cv != '') {
      cv = $.parseJSON(cv);
    }
    var count = 0;
    $(".checkclass").each(function(){
      var t = $(this);
      if(cv.length > 0 && cv[0].length > 0) {
        for(var i = 0; i < cv.length; i++) {
          if(t.attr("memberId") == cv[i][1]) {
            this.checked = true;
            count += 1;
            break;
          }else{
            this.checked = false;
          }
        }
      }else {
        this.checked = false;
      }
    });
    if (count !=0 && count == $(".checkclass").length-1) {
        $("#checkAll").attr("checked","checked");
    }
    //TODO Dialog组件目前存在组件事件被清除的bug，暂时处理为每次弹出时添加事件
    $("#comment_pushMessageToMembers_dialog_searchBtn").click(function(){
      pushMessageToMembersSearch();
    });
    
    $("#checkAll").click(function () {//当点击全选框时 
        var flag = $(this).attr("checked");//判断全选按钮的状态 
        dialog.getObjectByClass("checkclass").each(function(){
            if($.trim(flag)==="checked"){
                $(this).attr("checked","checked");//选中
            }else{
                $(this).removeAttr("checked"); //取消选中 
            }
        }); 
    });
    //如果全部选中勾上全选框，全部选中状态时取消了其中一个则取消全选框的选中状态  
      $(".checkclass").click(function () {
            if (dialog.getObjectByClass("checkclass:checked").length === dialog.getObjectByClass("checkclass").length) { 
                dialog.getObjectById("checkAll").attr("checked", "checked"); 
            }else 
                dialog.getObjectById("checkAll").removeAttr("checked"); 
      });
        
    $("#comment_pushMessageToMembers_dialog_searchBox").keypress(function(e){
      var c;
      if ("which" in e) {
        c = e.which;
      } else if ("keyCode" in e) {
        c = e.keyCode;
      }
      if (c == 13) {
        pushMessageToMembersSearch();
      }
    });
    var targetVer = getCtpTop();
    if ($.browser.version=='6.0' || $.browser.version=='7.0') {
        //targetVer = window;
    }
    dialog = $.dialog({
      htmlId : 'comment_pushMessageToMembers_dialog',
      title : $.i18n('collaboration.pushMessageToMembers.choose'),
      width : 320,
      height : 270,
      targetWindow:targetVer,
      buttons : [ {
        text : $.i18n('collaboration.pushMessageToMembers.confirm'),
        btnType:1,
        handler : function() {
          var txt = "", val = [];
          var _textTxt = "";
          dialog.getObjectByClass("checkclass").each(function(){
            var t = $(this), v = [];
            if(t.is(":hidden")){
            	return;
            }
            if($(this).is(":checked")) {
              if(txt != "" && txt != "undefined") {
                  txt += ",";
              } else {
                  txt = "";
              }
              if(_textTxt ==""  && !parent.isclickInput){
            	  _textTxt +=t.attr("memberName");
              }else{
            	  _textTxt += "@"+ t.attr("memberName");
              }
              txt += t.attr("memberName");
              if (t.attr("memberId") != undefined && t.attr("memberId") !="undefined"){
                  v.push(t.val());
                  v.push(t.attr("memberId"));
                  val.push(v);
              } 
            }
          });
          if(txtObj && txt != "undefined"){
            txtObj.val(txt);
            try{txtObj[0].title = txt;}catch(e){}
          }
          if(valObj){
            valObj.val($.toJSON(val));
          }
          if(boolPush) {
            if(val.length > 0) {
              boolPush.val(true);
            }else {
              boolPush.val(false);
            }
          }
          dialog.close();
        }
      }, {
        text : $.i18n('collaboration.pushMessageToMembers.cancel'),
        handler : function() {
          dialog.close();
        }
      }]
    });
      }catch(e){}
  }
  
  
  function pushMessageToMembers2($obj,textAreaObj) {
      try{
    	//TODO Dialog组件目前存在组件事件被清除的bug，暂时处理为每次弹出时添加事件
	    $("#comment_pushMessageToMembers_dialog_searchBtn").click(function(){
	      pushMessageToMembersSearch();
	    });
    	    
	    $("#checkAll").click(function () {//当点击全选框时 
	        var flag = $(this).attr("checked");//判断全选按钮的状态 
	        dialog.getObjectByClass("checkclass").each(function(){
	            if($.trim(flag)==="checked"){
	                $(this).attr("checked","checked");//选中
	            }else{
	                $(this).removeAttr("checked"); //取消选中 
	            }
	        }); 
	    });
    	    
      //如果全部选中勾上全选框，全部选中状态时取消了其中一个则取消全选框的选中状态  
      $(".checkclass").click(function () {
            if (dialog.getObjectByClass("checkclass:checked").length === dialog.getObjectByClass("checkclass").length) { 
                dialog.getObjectById("checkAll").attr("checked", "checked"); 
            }else 
                dialog.getObjectById("checkAll").removeAttr("checked"); 
      });
    	
      $(".checkclass").each(function(){
    	  this.checked = false;
      });
      //结束
    var targetVer = getCtpTop();
    if ($.browser.version=='6.0' || $.browser.version=='7.0') {
        targetVer = window;
    }
    dialog = $.dialog({
      htmlId : 'comment_pushMessageToMembers_dialog',
      title : $.i18n('collaboration.pushMessageToMembers.chooseB'),
      width : 320,
      height : 270,
      targetWindow:targetVer,
      buttons : [ {
        text : $.i18n('collaboration.pushMessageToMembers.confirm'),
        btnType:1,
        handler : function() {
    	  //转换前一次的成数组
    	  var cvold = $obj.val();
    	  if(cvold && cvold != '') {
    		  cvold = $.parseJSON(cvold);
    	  }
    	  //赋值
          var txt = "", val = [];
          if(cvold.length > 0){
        	  val = cvold;
          }
          
          var _textTxt = "";
          dialog.getObjectByClass("checkclass").each(function(){
            var t = $(this), v = [];
            if(t.is(":hidden")){
            	return;
            }
            if($(this).is(":checked")) {
              if(txt != "" && txt != "undefined") {
                  txt += ",";
              } else {
                  txt = "";
              }
              if(t.attr("memberName") != undefined){
            	  if(_textTxt ==""  && !parent.isclickInput){
            		  _textTxt +=t.attr("memberName")+" ";
            	  }else{
            		  _textTxt += "@"+ t.attr("memberName")+" ";
            	  }
              }
              txt += t.attr("memberName");
              if (t.attr("memberId") != undefined && t.attr("memberId") !="undefined"){
                  v.push(t.val());
                  v.push(t.attr("memberId"));
                  v.push("@"+t.attr("memberName"));
                  val.push(v);
              } 
            }
          });
          if(textAreaObj){
        	  parent.addToTextArea(textAreaObj,_textTxt);
          }else{
        	  parent.addToTextArea(null,_textTxt);
          }
          if($obj){
        	  $obj.val($.toJSON(val));
          }
          dialog.close();
        }
      }, {
        text : $.i18n('collaboration.pushMessageToMembers.cancel'),
        handler : function() {
          dialog.close();
        }
      }]
    });
      }catch(e){}
  }
  
  
  
  function pushMessageToMembersSearch() {
      var txt = dialog.getObjectById("comment_pushMessageToMembers_dialog_searchBox").val();
      dialog.getObjectById("comment_pushMessageToMembers_tbody").find('tr').each(function(){
          var t = $(this);
          if(!txt || txt == '' || txt.trim() == '') {
              t.show();
          } else {
              if($($("td", t)[1]).text().indexOf(txt) != -1) {
                  t.show();
              } else {
                  t.hide();
              }
          }
      });
  }

  $(function(){
	  if($.browser.mozilla){
		  window.location.hash = "#"+window.parent.contentAnchor;
	  }
    $(".attachment_block").css("margin-top","5px");
    $(".attachment_block a").css("display","inline");
    $(".attachment_block a").css("max-width","none");
    $("#comment_forward_region_btn").toggle(function(){
      $("#commentForwardDiv").hide();
      $("#comment_forward_region_btn").text($("#comment_forward_region_btn").attr("showTxt"));
    },function(){
      $("#commentForwardDiv").show();
      $("#comment_forward_region_btn").text($("#comment_forward_region_btn").attr("hideTxt"));
    });
    $("span[name=outerPraiseDiv]").each(function(){
    	try{
    		var pconut = $(this).find("span[name=praiseInSpan]").size();
    		var ptext =$(this).find("span[name=ppraiseCount]").html().replace("null",pconut);
    		$(this).find("span[name=ppraiseCount]").html(ptext);
    	}catch(e){}
    });
  });
  
  function checkCommonContent(){
      var content = $("#senderpostscriptDiv #content").val();
      var defaultValue = $.i18n("collaboration.newcoll.fywbzyl");
      if (content == defaultValue) {
          $("#senderpostscriptDiv #content").val("");
      }
  }
  function checkCommonContentOut(mutclick){
      var content = $("#senderpostscriptDiv #content").val();
      var defaultValue = $.i18n("collaboration.newcoll.fywbzyl");
      if (content == "") {
           $("#senderpostscriptDiv #content").val(defaultValue);
           $("#senderpostscriptDiv #content").css("color","#a3a3a3");
        }else{
        	if(!mutclick){
        		$("#senderpostscriptDiv #content").css("color","#111");
        	}
      }
  }