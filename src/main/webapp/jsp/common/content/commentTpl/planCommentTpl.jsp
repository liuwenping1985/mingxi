<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<script type="text/javascript" src="${path}/ajax.do?managerName=ctpCommentManager"></script>
<input id="commentSum" type="hidden" value="${fn:length(commentList)}">
<c:set var="_sscounter" value="1"></c:set>
		<div class="processing_view" style="padding:1px 0;">
			<li class="view_li margin_b_10 padding_b_10">			
				<span class="title" id="opinionComment">${ctp:i18n_1('plan.opinion.handleOpinion',fn:length(commentList))}</span>
			    <div class="content" id="planReplyContent">
			        <c:forEach items="${commentList}" var="comment" varStatus="status">
			            <h3 class="per_title" >
			                <span class="title align_left">
                      <c:choose>
                      <c:when test="${isRef == 'true'}">
            ${comment.createName}
        </c:when>
        <c:otherwise><a href="javascript:void(0)" class="showPeopleCard" style="font-size: 14px;" onclick="$.PeopleCard({memberId:'${comment.createId}'})" id="commentSearchCreate${_sscounter}">${comment.createName}</a></c:otherwise></c:choose>
			                	${ctp:i18n(comment.extAtt1)}
			                	<span class="align_right" style="font-size: 14px;">${comment.createDateStr}</span>
			                </span>
			                <c:set var="_sscounter" value="${_sscounter+1}"></c:set>
			                <c:if test="${canReply}">
			                    <span onclick="commentShowReply('${comment.id}');" class="add_new font_size12">
			                    	<a href="javascript:void(0)" class="color_blue">${ctp:i18n('plan.summary.tab.reply')}</a>
			                    </span>
			                </c:if>
			            </h3>
			            <input type="hidden" id="mcp_${comment.id}" value="${comment.maxChildPath}">
			            <input type="hidden" id="cp_${comment.id}" value="${comment.path}">
			            <ul class="clearfix">
			                <li class="content_in font_size12">${comment.escapedContent}</li>
                            <c:if test="${comment.hasRelateAttach && comment.canView}">
                                <li>
                                    <span class="font_bold font_size12 left">${ctp:i18n('common.attachment.label')}：</span>
                                    <span><div style="display:none;" class="comp" comp="type:'fileupload',applicationCategory:'${comment.moduleType}',attachmentTrId:'${comment.id}',canDeleteOriginalAtts:false,canFavourite:false" attsdata='${comment.relateInfo}'></div></span>
                                </li>
                            </c:if>
			                <li id="replyContent_${comment.id}" class="color_gray ${fn:length(comment.children) > 0?'':'display_none'}">
			                    <h4>${ctp:i18n('collaboration.opinion.replyOpinion')}</h4>
			                    <c:forEach items="${comment.children}" var="childComment">
			                        <div class="comments_title_in">
			                            <span class="title">
			                            	<a href="javascript:void(0)" class="showPeopleCard" onclick="$.PeopleCard({memberId:'${childComment.createId}'})" id="commentSearchCreate${_sscounter}">${childComment.createName}</a>
			                            </span>
			                            <span class="add_new font_size12">${childComment.createDateStr}</span>
			                            <c:set var="_sscounter" value="${_sscounter+1}"></c:set>
			                        </div>
			                        <div class="comments_content font_size12"  style="color:#111;">${childComment.escapedContent}
			                            <c:if test="${childComment.relateInfo != null}">
			                            <div class="affix_content">
			                                <span class="font_bold font_size12 left">${ctp:i18n('common.attachment.label')}：</span>
			                                <c:if test="${childComment.hasRelateAttach && childComment.canView}">
			                                	<span>
			                                		<div style="display:none;" class="comp" comp="type:'fileupload',applicationCategory:'${comment.moduleType}',attachmentTrId:'${childComment.id}',canDeleteOriginalAtts:false,canFavourite:false" attsdata='${childComment.relateInfo}'></div>
			                                	</span>
			                                </c:if>

			                            </div>
			                            </c:if>
			                        </div>
			                    </c:forEach>
			                </li>
			                <c:if test="${canReply}">
			                    <li id="reply_${comment.id}" class="form_area display_none clearFlow">
			                        <input type="hidden" id="pid" value="${comment.id}">
			                        <input type="hidden" id="clevel" value="${comment.clevel+1}">
			                        <input type="hidden" id="path">
			                        <input type="hidden" id="moduleType" value="${comment.moduleType}">
			                        <input type="hidden" id="moduleId" value="${comment.moduleId}">
			                        <input type="hidden" id="ctype" value="1">
			                        <input type="hidden" id="affairId" value="${contentContext.affairId}">
			                        <div class="common_txtbox clearfix">
			                        	<textarea id="content" name="content" class="validate" validate="notNull:true,maxLength:500" cols="20" rows="5"></textarea>
			                        </div>
			                        
			                          <div class="chearfix">
		                                <table  style="border:0;width: 100%">
		                                  <tbody>
		                                      <tr>
		                                        <td nowrap="nowrap" width="90%">
		                                          <table style="border:0">
		                                            <tbody>
		                                              <tr>
		                                                <td nowrap="nowrap">
		                                                  <span class="left green">${ctp:i18n('collaboration.sender.postscript.lengthRange')}</span> 
		                                                </td>
		                                                <td nowrap="nowrap" width="100%">
		                                                      <span class="bt" style="float:right;vertical-align:bottom;padding-right:30px;">
		                                                    
		                                                        
		                                                          <span>
		                                                            <label class="margin_r_10 hand">
		                                                              <input id="hidden" class="radio_com" name="hidden" value="true" type="checkbox">${ctp:i18n('collaboration.opinion.hidden.label')}
		                                                               <input type="hidden" id="showToId" name="showToId" value="Member|${createUserId}" />
		                                                            </label>
		                                                          </span>
		                                                          <span>
		                                                          <a class="common_button common_button_gray margin_r_5" id="replaybutton" onclick="commentReply('${comment.id}');" href="javascript:void(0)" style="margin-bottom: 7px;">
		                                                          ${ctp:i18n('collaboration.sender.postscript.submit')}
		                                                          </a> 
		                                                          <a onclick="commentHideReply('${comment.id}')" class="common_button common_button_gray" href="javascript:void(0)"  style="margin-bottom: 7px;">
		                                                            ${ctp:i18n('collaboration.sender.postscript.cancel')}
		                                                          </a>
		
		                                                         
		                                                         <div style="display:none" class="common_txtbox common_txtbox_dis clearfix">
		                                                            <input id="reply_pushMessage_${comment.id}" value="${comment.createName}" type="text" onclick="pushMessageToMembers($(this),$('#reply_${comment.id} #pushMessageToMembers'),null,'${comment.createId}')">
		                                                          </div>
		                                                             </span>   
		                                                      </span>
		                                                </td>
		                                              </tr>
		                                          </table>
		                                        </td>
		                                      </tr>
		                                </table>
							  		 </div>
			                    </li>
			                </c:if>
			            </ul>
			        </c:forEach>
			    </div>
			</li>
		</div>
		<div class="processing_view" style="padding:1px 0;">
			<li class="view_li margin_b_10 padding_b_10">
				<span class="title">${ctp:i18n('plan.summary.tab.summary')}</span>
				 <div class="content">
				 	<c:forEach var="summary" items="${summaryList}" varStatus="status">
				 	 	<h3 class="per_title">
			                <span class="title align_left">
			                	<a href="javascript:void(0)" class="showPeopleCard" style='font-size: 14px;' onclick="$.PeopleCard({memberId:'${summary.refUserId}'})">${summary.refUserName}</a>
			                	<span class="align_right" style='font-size: 14px;'>${ctp:formatDateByPattern(summary.createTime,'yyyy-MM-dd HH:mm:ss')}</span>
			                </span>
			            </h3>
			             <ul>
			                <li class="content_in font_size12">${ctp:toHTML(summary.summaryText)}</li>
  			             	<li>
			                    <span class="font_bold font_size12 left">${ctp:i18n('common.attachment.label')}：</span>
			                    <span><div style="display:none;" class="comp" comp="type:'fileupload',applicationCategory:'5',attachmentTrId:'${summary.id}',canDeleteOriginalAtts:false,canFavourite:false" attsdata='${summary.attsInfo}'></div></span>
			                </li>
			             </ul>

				 	</c:forEach>
				 </div>
			</li>
		</div>

<style>
.selectMemberName{
  background-color: #f00;
}
</style>
<script type="text/javascript">
  function _commentHidden(th) {
    var t = $(th), p = t.parent().parent().next();
    if(th.checked) {
      p.show();
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
  var _commentCounter = 0, _commentNum = 0, _commentTotal = ${_sscounter} - 1, currentSelectedObj = null;
  $.content.commentSearchCreate = function(str, flag) {
    if(!str || "" === str)
      return;
    _commentCounter++;
    if(_commentCounter>=3) {
      _commentCounter = 0;
        return; //这个变量又来避免查不到内容的时候死循环。
    }
    if(flag=="forward"){//向前查找
        var c;
        if( _commentNum == _commentTotal) c = 1;
        else c = _commentNum+1; 
        
        if(currentSelectedObj!=null) $(currentSelectedObj).removeClass("selectMemberName");
        
        for(var i =c;i<= _commentTotal ;i++){
            var obj = document.getElementById("commentSearchCreate"+i);
            if(obj){
                if(obj.innerHTML.indexOf(str)!=-1){
                    var path = document.location.href;
                    var jinghao = path.indexOf("#")
                    if(jinghao > 0){
                        path = path.substring(0, jinghao);
                    }
                    document.location.href = path + "#commentSearchCreate" + i;
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

        if(currentSelectedObj!=null) $(currentSelectedObj).removeClass("selectMemberName");
        
        for(var i =c;i>=0 ;i--){
            var obj = document.getElementById("commentSearchCreate"+i);
            if(obj){
                if(obj.innerHTML.indexOf(str)!=-1){
                    var path = document.location.href;
                    var jinghao = path.indexOf("#")
                    if(jinghao > 0){
                        path = path.substring(0, jinghao);
                    }
                    document.location.href = path + "#commentSearchCreate" + i;
                    $(obj).addClass("selectMemberName");
                    _commentNum = i;
                    _commentCounter = 0;
                    currentSelectedObj = obj;
                    break;
                }else if( i==0 ){
                    _commentNum = i;
                    $.content.commentSearchCreate(str,flag);
                }
            }
        }
    }
  };
  function commentShowReply(rid) {
	$("#reply_" + rid).show();
    $("#content", $("#reply_" + rid)).focus();
    unDisablebutton(rid);
  }
  function commentHideReply(rid) {
    $("#reply_" + rid).hide();
    $("#reply_sender #content").val("");
    deleteAllAttachment(0);
  }
  function commentReply(rid) {
    disablebutton();
    var dm = $("#reply_" + rid), mcp = $("#mcp_" + rid).val()+'', cp = $(
        "#cp_" + rid).val();
    var pt = cp;
    if ((mcp).length == 1)
      pt += '00' + mcp;
    else if ((mcp).length == 2)
      pt += '0' + mcp;
    else
      pt += mcp;
    $("#path", dm).val(pt);
    $("#mcp_" + rid).val(parseInt(mcp) + 1);
    var obj = dm.formobj({errorIcon : false});
    var content = obj.content;
    if(typeof(content)!="undefined" && content.length>500){
      $.alert("${ctp:i18n_1('collaboration.common.deafult.commonMaxSize','"+content.length+"')}");
      unDisablebutton(rid);
      return;
    }
    if(typeof(content) == "undefined" || content.length == 0){
      unDisablebutton(rid);
    }
    obj.pushMessage = true;
    var mgr = new ctpCommentManager();
    mgr.insertComment(
            obj,
            {
              success : function(ret) {
                $("#replyContent_" + rid).show();
                $("#replyContent_" + rid)
                    .append(
                        '<div class="comments_title_in"> <span class="title"><a href="javascript:void(0)"  class="showPeopleCard" onclick="$.PeopleCard({memberId:\'${CurrentUser.id}\'})">${CurrentUser.name}</a></span><span class="add_new font_size12">'
                            + ret.createDateStr + '</span></div>');
                var tmp = $('<div class="comments_content font_size12"  style="color:#111;"></div>');
                tmp.html(ret.escapedContent);
                var wrap = $("<div class='affix_content'></div>");
                $("#attachmentAreareply_attach_" + rid).children().removeAttr("style").wrapAll(wrap);
                tmp.append($("#attachmentAreareply_attach_" + rid).children());
                $("#replyContent_" + rid).append(tmp);
                $("#content", dm).val('');
                commentHideReply(rid);
                //unDisablebutton(rid);
              }
            });
  }
  function commentSenderReply() {
    var dm = $("#reply_sender"), obj = dm.formobj({errorIcon : false});
    // 检查附言长度
    var checkLength = $("#content", dm).val().length;
    if(checkLength > 500){
      $("#senderpostscriptDiv").attr("title","内容不能多于500个字，当前共"+checkLength+"个字");
    }
    if($._isInValid(obj)){
      return;
    }
    var mgr = new ctpCommentManager();
    saveAttachment(document.getElementById("reply_sender_attach"));
    obj.attachList = $("#reply_sender_attach").formobj();
    mgr
        .insertComment(
            obj,
            {
              success : function(ret) {
                var tmp = $('<li></li>');
                tmp.html(ret.createDateStr + ' ' + ret.escapedContent);
                $("#reply_sender").before(tmp);
                var wrap = $("<li></li>");
                $("#attachmentAreareply_sender").children().removeAttr("style").wrapAll(wrap);
                $("#reply_sender").before($("#attachmentAreareply_sender").children());
                $("#content", dm).val('');
                commentHideReply('sender');
                deleteAllAttachment(0);
              }
            });
  }
  var _pushMessageLastIdx;
  function pushMessageToMembers(txtObj, valObj, boolPush, moveToTopId) {
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
    $("input:checkbox", $("#comment_pushMessageToMembers_grid")).each(function(){
      var t = $(this);
      if(cv.length > 0 && cv[0].length > 0) {
        for(var i = 0; i < cv.length; i++) {
          if(t.attr("memberId") == cv[i][1]) {
            this.checked = true;
            break;
          }else{
            this.checked = false;
          }
        }
      }else
        this.checked = false;
    });
    //TODO Dialog组件目前存在组件事件被清除的bug，暂时处理为每次弹出时添加事件
    $("#comment_pushMessageToMembers_dialog_searchBtn").click(function(){
      pushMessageToMembersSearch();
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
    var dialog = $.dialog({
      htmlId : 'comment_pushMessageToMembers_dialog',
      title : "${ctp:i18n('collaboration.pushMessageToMembers.choose')}",
      width : 320,
      height : 270,
      buttons : [ {
        text : "${ctp:i18n('collaboration.pushMessageToMembers.confirm')}",
        handler : function() {
          var txt = "", val = [];
          $("input:checkbox", $("#comment_pushMessageToMembers_grid")).each(function(){
            var t = $(this), v = [];
            if(this.checked) {
              if(txt != "")
                txt += ",";
              txt += t.attr("memberName");
              v.push(t.val());
              v.push(t.attr("memberId"));
              val.push(v);
            }
          });
          if(txtObj)
            txtObj.val(txt);
          if(valObj)
            valObj.val($.toJSON(val));
          if(boolPush) {
            if(val.length > 0)
              boolPush.val(true);
            else
              boolPush.val(false);
          }
          dialog.close();
        }
      }, {
        text : "${ctp:i18n('collaboration.pushMessageToMembers.cancel')}",
        handler : function() {
          dialog.close();
        }
      } ]
    });
  }
  function pushMessageToMembersSearch() {
    var txt = $("#comment_pushMessageToMembers_dialog_searchBox").val();
    $("#comment_pushMessageToMembers_grid tbody tr").each(function(i){
      var t = $(this);
      if(!txt || txt == '' || txt.trim() == '')
        t.show();
      else {
        if($($("td", t)[1]).text().indexOf(txt) != -1)
          t.show();
        else
          t.hide();
      }
    });
  }
  $(function(){
    deleteAllAttachment(0);
    $("#comment_forward_region_btn").toggle(function(){
      $("#comment_forward_region").hide();
      $("#comment_forward_region_btn").text($("#comment_forward_region_btn").attr("showTxt"));
    },function(){
      $("#comment_forward_region").show();
      $("#comment_forward_region_btn").text($("#comment_forward_region_btn").attr("hideTxt"));
    });
  });
  
  function disablebutton(){
	$("#replaybutton").addClass("common_button_disable");
	$("#replaybutton").unbind('click');
	$("#replaybutton").removeAttr("onclick");
  }

  function unDisablebutton(rid){
    if($("#replaybutton").attr("class")) {
        if($("#replaybutton").attr("class").indexOf("common_button_disable") > -1) {
            $("#replaybutton").removeClass("common_button_disable");
            $("#replaybutton").unbind('click');
            $("#replaybutton").click(function() {      
              commentReply(rid);
            });
        }
    }
  }
</script>