<%--
 $Author:  zhaifeng$
 $Rev:  $
 $Date:: 2012-09-07#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
<script type="text/javascript">
/***工作需要的参数***/
$(function(){
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

	$("#checkAll").click(function () {//当点击全选框时 
	    var flag = $(this).attr("checked");//判断全选按钮的状态 
	    $(".checkclass").each(function(){
	        if($.trim(flag)==="checked"){
	            $(this).attr("checked","checked");//选中
	        }else{
	            $(this).removeAttr("checked"); //取消选中 
	        }
	    }); 
	});
	//如果全部选中勾上全选框，全部选中状态时取消了其中一个则取消全选框的选中状态  
	  $(".checkclass").click(function () {
	        if ($(".checkclass:checked").length === $(".checkclass").length) { 
	            $("#checkAll").attr("checked", "checked"); 
	        }else 
	            $("#checkAll").removeAttr("checked"); 
	  });
	  if('${mIdStr}'){
		  var array = new Array();
		  array =  '${mIdStr}';
		  var mId =[];
		  <c:forEach items="${mIdStr}" var="xx">
		  	mId.push("${xx[1]}");
		  </c:forEach>
		 $(".checkclass").each(function(){
			if($(this).attr("id") =="checkAll"){
				return;
			}
			var pmid =  $(this).attr("memberid");
			for(var a= 0; a<mId.length ; a++){
				if(mId[a].indexOf(pmid) > -1){
					$(this).attr("checked", "checked");
					break;
				}	
			}
		 }); 		  
	  }
})
function pushMessageToMembersSearch() {
      var txt = $("#comment_pushMessageToMembers_dialog_searchBox").val();
      $("#comment_pushMessageToMembers_tbody").find('tr').each(function(){
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

function OK(){
	var txt = "", val = [];
    $("input:checkbox", $("#comment_pushMessageToMembers_grid")).each(function(){
    	var t = $(this), v = [];
      	if(this.checked) {
      		if(t.val()!='on') {
	        	if(txt != "")
	          		txt += ",";
	        	txt += t.attr("memberName");
	        	v.push(t.val());
	        	v.push(t.attr("memberId"));
	        	val.push(v);
      		}
      	}
    });
    return [txt,$.toJSON(val),val.length];
}
</script>
</head>
<body>
		<div id="comment_pushMessageToMembers_dialog">
                <div class="clearfix">
                    <ul class="common_search right">
                        <li id="inputBorder" class="common_search_input"> 
                            ${ctp:i18n('collaboration.pushMessageToMembers.search')}： <input id="comment_pushMessageToMembers_dialog_searchBox" name="pushMessageSearch" class="search_input" type="text"></li> 
                        <li><a id="comment_pushMessageToMembers_dialog_searchBtn" class="common_button common_button_gray search_buttonHand"><em></em></a></li> 
                    </ul> 
                </div>
                <div class="clearfix" style="padding-top:5px">
                    <table id="comment_pushMessageToMembers_grid" class="only_table border_all" cellSpacing="0" cellPadding="0" width="100%">
                        <thead>
                           <tr style="background-color: #F6F6F6;">
                            <th style="text-align: center;width:20px;" valign="middle"><input type="checkbox" class="checkclass padding_t_5" id="checkAll"></th>
                            <th align="left">${ctp:i18n('collaboration.pushMessageToMembers.name')}</th>
                            <th>&nbsp;</th>
                          </tr>
                        </thead>
                        <tbody id="comment_pushMessageToMembers_tbody">
                        <c:forEach items="${commentPushMessageToMembersList}" var="affair" varStatus="status">
                            <tr class="${affair.state == 2?'_pm_fixed':''}" align="center" memberId="${affair.memberId}">
                                <td class="border_t"><input type="checkbox" class="checkclass" value="${affair.id}" memberName="${ctp:showMemberNameOnly(affair.memberId)}" memberId="${affair.memberId}"></td>
                                <td align="left" class="border_t">${ctp:showMemberNameOnly(affair.memberId)}</td>
                                <%-- 发起人     已处理人   已暂存待办  指定回退 回退者 被回退者 --%>
                                <td align="left" class="border_t">${affair.state == 2?ctp:i18n('cannel.display.column.sendUser.label'):
                                    affair.state == 4?ctp:i18n('collaboration.default.haveBeenProcessedPe'):
                                    affair.subState == 15?ctp:i18n('collaboration.default.stepBack'):
                                    affair.subState == 17?ctp:i18n('collaboration.default.specialBacked'):
                                    (affair.subState == 16 && affair.state == 1)?ctp:i18n('cannel.display.column.sendUser.label'):
                                    affair.subState == 16 ?ctp:i18n('collaboration.default.specialBacked'):
                                    ctp:i18n('collaboration.default.stagedToDo')}</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                	</div>
           </div>
</body>
</html>