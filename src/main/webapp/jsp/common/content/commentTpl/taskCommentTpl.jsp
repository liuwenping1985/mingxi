<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<script type="text/javascript" src="${path}/ajax.do?managerName=ctpCommentManager"></script>
<c:set var="_sscounter" value="1"></c:set>
<div class="font_size12 clear margin_l_5 stadic_left_head_height valign_m">${ctp:i18n("taskmanage.reply")}(${ctp:i18n("taskmanage.common")}<span id="replyCount">${fn:length(commentList)}</span></>${ctp:i18n("taskmanage.item")})：</div>
<div style="background: #fff;" class="font_size12 margin_lr_5" id="replyAreaDiv">
	    
     <c:forEach items="${commentList}" var="comment" varStatus="status">
         <ul style="background: #fff;margin-bottom:10px;" class=" border_all  font_size12">
         <li class="padding_5 border_b bg_color" style="height:20px; background:#ebf3fd;">
             <span class="left">
             	<a href="javascript:void(0)" class="showPeopleCard color_blue" onclick="$.PeopleCard({memberId:'${comment.createId}'})" id="commentSearchCreate${_sscounter}">${comment.createName}</a>${ctp:i18n(comment.extAtt1)}
             	<span class="w1em"></span>
             	<span class="align_right color_gray2">${comment.createDateStr}</span>
             </span>
             <c:set var="_sscounter" value="${_sscounter+1}"></c:set>
                <c:choose>
                    <c:when test="${param.isBtnEidt == 1}">
                        <span onclick="commentShowReply('${comment.id}');" class="add_new right">
                    </c:when>
                    <c:otherwise>
                        <span disabled class="add_new right">
                    </c:otherwise>
                </c:choose>
                	<a href="javascript:void(0)">${ctp:i18n("taskmanage.reply.action")}</a>
                </span>
         </li>
         <input type="hidden" id="mcp_${comment.id}" value="${comment.maxChildPath}">
         <input type="hidden" id="cp_${comment.id}" value="${comment.path}">
             <li style="background: #fff;" class="padding_5 word_break_all" >${comment.escapedContent}</li>
             <li id="replyContent_${comment.id}" class="padding_5 ${fn:length(comment.children) > 0?'':'display_none'}">
                 <div class="padding_lr_10 bg_color padding_tb_5" style="background:#ebf3fd; border-top:1px solid #b6b6b6; border-right:1px solid #b6b6b6; border-left:1px solid #b6b6b6;" >${ctp:i18n('collaboration.opinion.replyOpinion')}</div>
                 <c:forEach items="${comment.children}" var="childComment" varStatus="status">
                 	<div class="border_all">
	                     <div class="comments_title_in padding_10 clearfix" >
	                         <span class="title">
	                         	<a href="javascript:void(0)" class="showPeopleCard color_blue" onclick="$.PeopleCard({memberId:'${childComment.createId}'})" id="commentSearchCreate${_sscounter}">${childComment.createName}</a>
	                         </span>
	                         <span class="w1em"></span>
	                         <span class="add_new color_gray2 right">${childComment.createDateStr}</span>
	                         <c:set var="_sscounter" value="${_sscounter+1}"></c:set>
	                     </div>
	                     <div class="comments_content margin_10 word_break_all">${childComment.escapedContent}
	                         <c:if test="${childComment.relateInfo != null}">
	                         <div class="affix_content">
	                             <span class="font_bold">${ctp:i18n('common.attachment.label')}：</span>
	                             <c:if test="${childComment.hasRelateAttach}">
	                             	<span>
	                             		<div style="display:none;" class="comp" comp="type:'fileupload',applicationCategory:'${comment.moduleType}',attachmentTrId:'${childComment.id}',canDeleteOriginalAtts:false" attsdata='${childComment.relateInfo}'></div>
	                             	</span>
	                             </c:if>
	                         </div>
	                         </c:if>
	                     </div>
                     </div>
                 </c:forEach>
             </li>
            <li id="reply_${comment.id}" class="form_area display_none w90b">
                <input type="hidden" id="pid" value="${comment.id}">
                <input type="hidden" id="clevel" value="${comment.clevel+1}">
                <input type="hidden" id="path">
                <input type="hidden" id="moduleType" value="${comment.moduleType}">
                <input type="hidden" id="moduleId" value="${comment.moduleId}">
                <input type="hidden" id="ctype" value="1">
                <input type="hidden" id="affairId" value="${contentContext.affairId}">
                <div class="common_txtbox clearfix">
                	<textarea id="content" name="回复内容" class="validate margin_l_5" validate="notNull:true,maxLength:500" cols="35" rows="5"></textarea>
                </div>
                <div class="common_checkbox_box clearfix">
               		<label class="margin_r_10 hand margin_l_5">
               			<input id="pushMessage" class="radio_com" name="pushMessage" value="true" type="checkbox">${ctp:i18n("taskmanage.sendMessage.label")}
               		</label>
               		<span class="green right">${ctp:i18n('collaboration.sender.postscript.lengthRange')}</span> 
               	</div>
                <div class="bt" align="right">
                	<a class="common_button common_button_gray padding_5 margin_r_5 margin_b_5"  onclick="commentReply('${comment.id}')" href="javascript:void(0)">
                		${ctp:i18n('common.button.ok.label')}
                	</a> 
                    <a onclick="commentHideReply('${comment.id}')" class="common_button common_button_gray padding_5 margin_b_5" href="javascript:void(0)">
                    	${ctp:i18n('common.button.cancel.label')}
                    </a>
                </div>
            </li>
         </ul>
     </c:forEach>
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
                    var jinghao = path.indexOf("#");
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
                    var jinghao = path.indexOf("#");
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
    $("#reply_" + rid).slideDown();
    $("#content", $("#reply_" + rid)).focus();
  }
  function commentHideReply(rid) {
    $("#reply_" + rid).slideUp();
    $("#reply_sender #content").val("");
    deleteAllAttachment(0);
  }
  function commentReply(rid) {
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
    var checkLength = $("#content", dm).val().length;
    if(checkLength == 0){
        $.alert("${ctp:i18n('taskmanage.alert.enter_reply_content')}");
        return;
    }
    if(checkLength > 500){
        $.alert("${ctp:i18n_1('taskmanage.alert.reply_content_more_than_500','"+ checkLength +"')}");
        return;
    }
    var mgr = new ctpCommentManager();
    mgr.insertComment(
            obj,
            {
              success : function(ret) {
                $("#replyContent_" + rid).show();
                var title = $('<div class="comments_title_in padding_10 clearfix"><span class="title"><a href="javascript:void(0)" class="showPeopleCard color_blue" onclick="$.PeopleCard({memberId:\'${CurrentUser.id}\'})">${CurrentUser.name}</a></span><span class="add_new color_gray2 right">'
                        + ret.createDateStr + '</span></div>');
                //title.css("background", "#eaefef");
                var content = $('<div class="comments_content margin_10 word_break_all"></div>');
                content.html(ret.escapedContent);

                var tmp = $("<div class='border_all'></div>");
                tmp.append(title);
                tmp.append(content);
                $("#replyContent_" + rid).append(tmp);
                $("#content", dm).val('');
                commentHideReply(rid);
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
</script>