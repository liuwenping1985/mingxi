/**
 * 创建讨论组
 */
function createTeam(type, id){
	if(type != "1"){
		getA8Top().$('#onlineUserTreeIframe').contents().find('#currentAccountId').attr('disabled', true);
	}
	var topBodyWidth = parseInt(getA8Top().document.body.clientWidth);
	if(topBodyWidth < 650){
		getA8Top().window.resizeTo(1015, 640);
	}
	var dID = getUUID();
	var divObj = "<div id=\"" + dID + "_DIV\" closed=\"true\" iconCls=\"icon-comments\">" +
			"<iframe id=\"" + dID + "_Iframe\" name=\"" + dID + "_Iframe\" width=\"100%\" height=\"100%\" scrolling=\"no\" frameborder=\"0\"></iframe>" +
			"</div>";
	getA8Top().$(divObj).appendTo("body");
	getA8Top().$('#' + dID + "_DIV").dialog({
		title: _("MainLang.message_select_contact"),
		width: 620,
		height: 550,
		closed: false,
		modal: true,
		minimizable: false,
		maximizable: false,
		closable: false,
		tools:[{
					iconCls:'panel-tool-close',
					handler:function(){
						if(type != "1"){
							getA8Top().$('#onlineUserTreeIframe').contents().find('#currentAccountId').attr('disabled', false);
						}
						getA8Top().$("#" + dID + "_DIV").dialog('destroy');
					}
				}],
		buttons:[{
					text:_("MainLang.okbtn"),
					handler:function(){
						if(type != "1"){
							getA8Top().$('#onlineUserTreeIframe').contents().find('#currentAccountId').attr('disabled', false);
						}
						saveTeam(dID, type, id);
					}
				},{
					text:_("MainLang.cancelbtn"),
					handler:function(){
						if(type != "1"){
							getA8Top().$('#onlineUserTreeIframe').contents().find('#currentAccountId').attr('disabled', false);
						}
						getA8Top().$("#" + dID + "_DIV").dialog('destroy');
					}
				}]
	});
	getA8Top().$('#' + dID + "_Iframe").attr("src",messageURL+"?method=createTeam&createType=" + type + "&otherId=" + id + "&random=" + Math.random());
}

/**
 * 保存讨论组
 */
function saveTeam(dID, type, id){
	var elements = getA8Top().$('#' + dID + "_Iframe")[0].contentWindow.$("#selectForCreateTeam_IFRAME")[0].contentWindow.OK();
	if (!elements) {
    	return;
	}
	var ids = getIdsString(elements, false);
	try {
		if(type != "3"){
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxMessageController", "isExist", false);
			var teamName = getA8Top().$('#' + dID + "_Iframe")[0].contentWindow.$("#name").attr("value");
			if(teamName == null || teamName.trim() == ""){
				alert(_("MainLang.message_team_name_input"));
				return;
			}
			requestCaller.addParameter(1, "String", teamName);
			var rs = requestCaller.serviceRequest();
			if(rs == "true"){
				alert(_("MainLang.message_team_name_exist"));
				return;
			}
		}
		$.ajax({
			async: false,
			type: "POST",
			url: messageURL + "?method=saveTeam",
			data: {"name": teamName, "dID": dID, "teamMemIDs": ids, "createType": type, "otherId": id},
			success: function(data){
			    getA8Top().$("#" + dID + "_DIV").dialog("destroy");
			    if(type == "1"){
			    	getA8Top().onlineUserTeamIframe.location.reload(true);
			    }else if(type == "2"){
			    	getA8Top().onlineUserTeamIframe.location.reload(true);
			    	getA8Top().showIMTab("5", dID, teamName, "false");
			    }else if(type == "3"){
			    	var obj = $("#teamMembersList tr:first-child");
			    	for (var i = 0; i < elements.length; i++) {
			   			var e = elements[i];
			   			var requestCaller1 = new XMLHttpRequestCaller(this, "ajaxMessageController", "isOnline", false);
						requestCaller1.addParameter(1, "Long", e.id);
						var rs1 = requestCaller1.serviceRequest();
						var style = rs1 == "true" ? "pcOnline" : "pcOffline";
						var trObj = "<tr valign='middle' height='25' class='tr-no-select' onclick='selectListRow(this)' ondblclick='top.showIMTab(\"1\", \"" + e.id + "\", \"" + e.name + "\", \"false\")'>" + 
										"<td width='30' align='center'><span class='" + style + "'></span></td>" + 
										"<td><input type='hidden' id='memberId' name='memberId' value='" + e.id + "'>" + e.name + "</td>" + 
									"</tr>";
						if(rs1 == "true"){
							obj.before(trObj);
						}else{
							$("#teamMembersList").append(trObj);
						}
			    	}
			    }
			}
		});
	}catch(e){
		
	}	
}

/**
 * 选中讨论组
 */
function selectTeam(condition, obj, teamId){
	//判断讨论组是否可用
	if(condition == "ByTeam" && getA8Top().isDeleted(teamId) == "true"){
		alert(_("MainLang.message_team_already_delete"));
		getA8Top().onlineUserTeamIframe.location.reload(true);
		return;
	}
	//获取同辈元素,取消同辈元素的选中状态
	var objs = $(obj).siblings();
	for(var i = 0; i < objs.length; i ++){
		objs[i].className = "team-no-select";
	}
	if(obj.className == "team-no-select"){
		obj.className = "team-select";
	}
	var url = onlineURL + "?method=showOnlineUserList&condition=" + condition + "&departmentId=" + teamId + "&currentAccountId=" + userLoginAccountId;
	
	var a = parent.onlineUserListIframe.document;
	a = a.getElementById("showOfflineList");
	if(a && a.checked){
		url += "&showoffline=checked";
	}
	
	getA8Top().$("#onlineUserListIframe").attr("src", url);
}

/**
 * 选中行改变颜色
 */
function selectListRow(obj){
	//获取同辈元素,取消同辈元素的选中状态
	var objs = $(obj).siblings();
	for(var i = 0; i < objs.length; i ++){
		o = objs[i];
		if(o.className.indexOf("offline")==-1){
			o.className = "tr-no-select";
		}
	}
	if(obj.className == "tr-no-select"){
		obj.className = "tr-select";
	}
}

/**
 * 删除讨论组
 */
function deleteTeam(){
	if($(".team-select").length > 0){
		if($(".team-select").attr("teamType") == "4"){
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxMessageController", "isOwner", false);
			var teamId = $(".team-select").attr("teamId");
			var teamName = $(".team-select").attr("teamName");
			requestCaller.addParameter(1, "Long", teamId);
			var rs = requestCaller.serviceRequest();
			if(rs == "true"){
				if(confirm(_("MainLang.message_team_delete_confirm"))){
					$.ajax({
						async: false,
						type: "POST",
						url: messageURL + "?method=deleteTeam",
						data: {"teamId": teamId},
						success: function(data){
						    getA8Top().onlineUserTeamIframe.location.reload(true);
						    getA8Top().closeIMTab(teamName);
						}
					});
				}
			}else{
				alert(_("MainLang.message_team_not_delete"));
			}
			
		}else{
			alert(_("MainLang.message_team_system_not_delete"));
		}
	}else{
		alert(_("MainLang.message_select_2"));
	}
}

/**
 * 切换单位,更换部门树结构、在线人员列表
 */
function changeComboTree(value){
	var url = onlineURL + "?method=showOnlineUserTree&currentAccountId=" + value;
	var a = parent.onlineUserListIframe.document;
	a = a.getElementById("showOfflineList");
	if(a && a.checked){
		url += "&showoffline=checked";
	}
	parent.onlineUserTreeIframe.location.href = url;
	showAccountUser(value);
}

/**
 * 显示根单位在线人员
 */
function showAccountUser(id){
	var url = onlineURL + "?method=showOnlineUserList&condition=SelectAccount&currentAccountId=" + id;
	var a = parent.onlineUserListIframe.document;
	a = a.getElementById("showOfflineList");
	if(a && a.checked){
		url += "&showoffline=checked";
	}
	parent.onlineUserListIframe.location.href = url;
}

/**
 * 显示所选部门在线人员
 */
function showSelDep(id){
	var url = onlineURL + "?method=showOnlineUserList&condition=ByDepartment&departmentId=" + id;
	var a = parent.onlineUserListIframe.document;
	a = a.getElementById("showOfflineList");
	if(a && a.checked){
		url += "&showoffline=checked";
	}
	parent.onlineUserListIframe.location.href = url;
}

/**
 * 显示本部门在线人员
 */
function showMyDeptUser(){
	var url = onlineURL + "?method=showOnlineUserList";
	var a = parent.onlineUserListIframe.document;
	a = a.getElementById("showOfflineList");
	if(a && a.checked){
		url += "&showoffline=checked";
	}
	parent.onlineUserListIframe.location.href = url;
}

/**
 * 显示关联人员中在线人员
 */
function showMyRelate(){
	var url = onlineURL + "?method=showOnlineUserList&condition=MyRelate";
	var a = parent.onlineUserListIframe.document;
	a = a.getElementById("showOfflineList");
	if(a && a.checked){
		url += "&showoffline=checked";
	}
	parent.onlineUserListIframe.location.href = url;
}

/**
 * 按姓名搜索在线人员列表-回车
 */
function onEnterPress(isRoot, queryType, queryValue){
	if(v3x.getEvent().keyCode == 13){
		showByName(isRoot, queryType, queryValue);
	}
}

/**
 * 按姓名搜索在线人员列表-点击查询按钮
 */
function showByName(isRoot, queryType, queryValue){
	var userName = document.userForm.userName.value;
	if(userName.trim() == ""){
		alert(_("V3XLang.index_input_error"));
		return;
	}
	var url = onlineURL + "?method=showOnlineUserList&condition=ByName&isRoot=" + isRoot + "&queryType=" + queryType + "&queryValue=" + queryValue + "&userName=" + encodeURI(userName.trim());
	var a = parent.onlineUserListIframe.document;
	a = a.getElementById("showOfflineList");
	if(a && a.checked){
		url += "&showoffline=checked";
	}
	parent.onlineUserListIframe.location.href = url;
}

/******聊天窗口历史记录中事件******/

/**
 * 首页响应
 */
function firstPage(type, id){
	var createDate = document.getElementById("createDate").value;
	window.location.href = messageURL + "?method=showThisHistoryMessage&type=" + type + "&id=" + id + "&createDate=" + createDate + "&nowPagePara=1";
}

/**
 * 上一页响应
 */
function prevPage(type, id, page){
	var createDate = document.getElementById("createDate").value;
	var nowPage = eval(parseInt(page)-1);
	window.location.href = messageURL + "?method=showThisHistoryMessage&type=" + type + "&id=" + id + "&createDate=" + createDate + "&nowPagePara=" + nowPage;
}

/**
 * 下一页响应
 */
function nextPage(type, id, page){
	var createDate = document.getElementById("createDate").value;
	var nowPage = eval(parseInt(page)+1);
	window.location.href = messageURL + "?method=showThisHistoryMessage&type=" + type + "&id=" + id + "&createDate=" + createDate + "&nowPagePara=" + nowPage;
}

/**
 * 末页响应
 */
function endPage(type, id, page){
	var createDate = document.getElementById("createDate").value;
	window.location.href = messageURL + "?method=showThisHistoryMessage&type=" + type + "&id=" + id + "&createDate=" + createDate + "&nowPagePara=" + page;
}

/**
 * 回车
 */
function changePage(type, id, page){				
    if(event.keyCode==13){
        goPage(type, id, page);            
    }
}

/**
 * 切换页数
 */
function goPage(type, id, page){
	var nowPageStr = document.getElementById("nowPage").value.trim();
	if(!new RegExp("^-?[0-9]*$").test(nowPageStr)){
		return;
	}
	var createDate = document.getElementById("createDate").value;
	var nowPage = parseInt(nowPageStr);
	if(nowPage > page){
		nowPage = page;
	}
	if(nowPage <= 0){
		nowPage = 1;
	}
	window.location.href = messageURL + "?method=showThisHistoryMessage&type=" + type + "&id=" + id + "&createDate=" + createDate + "&nowPagePara=" + nowPage;
}

/**
 * 选择日期
 */
function selectDateTime(contextPath, type, id, ipad){
	var object = document.getElementById("createDate");
	if(ipad == "true"){
		whenstart(contextPath, object);
	}
	window.location.href = messageURL + "?method=showThisHistoryMessage&type=" + type + "&id=" + id + "&createDate=" + object.value;
}

function showOfflineList(){
	var url = parent.onlineUserListIframe.location.href;
	if(url.indexOf("&showoffline=checked")==-1){
		url = url+"&showoffline=checked";
	}else{
		url=url.substring(0,url.indexOf("&showoffline=checked"));
		if($("#showOfflineList").attr("checked")==true){
			url = url+"&showoffline=checked";
		}else{
		}
	}
	parent.onlineUserListIframe.location.href = url;
}