<%--
 $Author:  翟锋$
 $Rev:  $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/form/common/common.js.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>已发事项</title>
<script type="text/javascript" charset="UTF-8"
	src="${path}/apps_res/collaboration/js/collaboration.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
	function pushMessageToMembersSearch() {
		var txt = $("#comment_pushMessageToMembers_dialog_searchBox").val();
		$("#comment_pushMessageToMembers_tbody").find('tr').each(function() {
			var t = $(this);
			if (!txt || txt == '' || txt.trim() == '') {
				t.show();
			} else {
				if(t.find("td:first").text().indexOf(txt) != -1){
					t.show();
				} else {
					t.hide();
				}
			}
		});
	}
	$(function() {
	    
	  //var wParams = window.transParams || {};
        var wParams = $.parseJSON("${ctp:escapeJavascript(commentPushMessageToMembersList)}");
        if(!wParams || wParams.length == 0){
            $("#comment_pushMessageToMembers_dialog").hide();
            $("#not_found_div").show();
            return;
        }
	    
		// TODO Dialog组件目前存在组件事件被清除的bug，暂时处理为每次弹出时添加事件
		$("#comment_pushMessageToMembers_dialog_searchBtn").click(function() {
			pushMessageToMembersSearch();
		});

		$("#comment_pushMessageToMembers_dialog_searchBox").keypress(
				function(e) {
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
		
		if(wParams){
		    var trHtml = "";
		    for(var i = 0, len = wParams.length; i < len; i++){
		        var r = wParams[i];
		        trHtml +="<tr ";
		        if(r[2] == 2){
		            trHtml += " class='_pm_fixed' ";
		        }
		        trHtml += " align='center' memberId='"+r[0]+"'>";
		        //trHtml += '<td align="left">&nbsp;</th>';
		        trHtml += '<td class="border_t" style="word-break: break-all;text-align:left;border-right:none;">'+r[1]+'</td>';
		        
		        var stateHtml = "";
		        
		        if(r[2] == 1){
		        	if(r[3] == 16){
		        		stateHtml = "${ctp:i18n('cannel.display.column.sendUser.label')}";
		        	}else{
		        		<%-- 已暂存待办 --%>
		        		stateHtml = "${ctp:i18n('collaboration.default.tempToDo')}";
		        	}
		        }else if(r[2] == 2){
		        	stateHtml = "${ctp:i18n('cannel.display.column.sendUser.label')}";
		        }else if(r[2] == 3){
			        	if(r[3] == 13){
			        		//暂存待办
			        		stateHtml = "${ctp:i18n('collaboration.default.tempToDo')}";
			        	}else if(r[3] == 15 || r[3] == 17){
			        		//指定回退
			        		stateHtml = "${ctp:i18n('collaboration.default.stepBack')}";
			        	}else if(r[3] != 13 && r[3] != 15 && r[3] != 17 && r[4] != null){      	
			        		//被回退
			        		stateHtml = "${ctp:i18n('collaboration.default.beBack')}";
			        	}else if(r[3] == 11){
			        		//未读
			        		stateHtml = "${ctp:i18n('collaboration.default.unread')}";
			        	}else{
			        		//已读
			        		if( "${readSwitch}" != "disable"){
			        			stateHtml = "${ctp:i18n('collaboration.default.read')}";
			        		}
			        		else{
			        			stateHtml = "${ctp:i18n('collaboration.default.unread')}";
			        		}
			        		
			        	}
		            
		        }else if(r[2] == 4){
		        	stateHtml = "${ctp:i18n('collaboration.default.done')}";
		        }else{
		        	stateHtml = "${ctp:i18n('collaboration.default.tempToDo')}";
		        }
                
		        trHtml += '<td class="border_t" style="text-align:left;">'+stateHtml+'</td>';
                trHtml += "</tr>";
		    }
		}
		$("#comment_pushMessageToMembers_tbody").html(trHtml);
	})
</script>
</head>
<body style="background:#fafafa;">
	<div id="comment_pushMessageToMembers_dialog" style="display :block;padding:0 20px;background:#fafafa;">
		<div class="clearfix">
			<ul class="common_search right">
				<li id="inputBorder" class="common_search_input">
					${ctp:i18n('collaboration.pushMessageToMembers.search')}： <input
					id="comment_pushMessageToMembers_dialog_searchBox"
					name="pushMessageSearch" class="search_input" type="text" />
				</li>
				<li><a id="comment_pushMessageToMembers_dialog_searchBtn"
					class="common_button search_buttonHand"> <em></em>
				</a></li>
			</ul>
		</div>
		<div class="clearfix" style="padding-top: 10px">
			<table id="comment_pushMessageToMembers_grid"
				class="only_table border_all" cellSpacing="0" cellPadding="0" width="100%">
				<thead>
					<tr>
						<!-- <th style="text-align: center; width: 20px;" valign="middle">
							<input type="checkbox" class="checkclass padding_t_5"
							id="checkAll">
						</th> -->
						<!-- <th align="left" width="20px" style="background-color: rgb(128,171,211);"></th> -->
						<th align="left" style="background-color: rgb(128,171,211);width:201px;bor">${ctp:i18n('collaboration.pushMessageToMembers.name')}</th>
						<th style="background-color: rgb(128,171,211);"></th>
					</tr>
				</thead>
				<tbody id="comment_pushMessageToMembers_tbody">
					<%-- <c:forEach items="${commentPushMessageToMembersList}" var="affair"
						varStatus="status">
						<tr class="${affair.state == 2?'_pm_fixed':''}" align="center"
							memberId="${affair.memberId}">
							<td align="left" class="border_t">${ctp:showMemberNameOnly(affair.memberId)}</td>
							<td align="left" class="border_t">${affair.state == 2 ? ctp:i18n('cannel.display.column.sendUser.label') : affair.state == 3 ? '当前待办人' : affair.state == 4 ? ctp:i18n('collaboration.default.haveBeenProcessedPe') : affair.subState== 15 ? ctp:i18n('collaboration.default.stepBack') : affair.subState== 17 ? ctp:i18n('collaboration.default.specialBacked') : (affair.subState== 16 && affair.state ==1) ? ctp:i18n('cannel.display.column.sendUser.label') : ctp:i18n('collaboration.default.stagedToDo')}</td>
						</tr>
					</c:forEach> --%>
				</tbody>
			</table>
		</div>
	</div>
	<div id="not_found_div" style="display: none;text-align: center;padding-top: 120px">
	          <img alt="没有数据或没有激活" src="${path}/common/images/not_found.png"/><br/>
	          <span style="font-size: 16px;color: #aaa">${ctp:i18n('collaboration.label.receiver.noneNode')}<%-- 当前节点未被激活或者为空节点，暂无人员显示 --%></span>
      </div>
</body>
</html>
