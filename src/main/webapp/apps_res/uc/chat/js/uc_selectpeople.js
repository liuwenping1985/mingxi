var curSelectAccountId;
var curSelectDeptId;
var curTabId = 'Dept';
var teams;
var totalSize = 0;
var pageSize = 12;
var totalPage = 1;
var currentPage = 1;
var start = 0;
var end = 0;
var tempForA8 = null;
var jidsForA8  = "";
var membersForA8 = null;

/**
 * 加载页签内容
 */
function getTabContent(_id, _needRefresh) {
	if (_id) {
		curTabId = _id;
	}
	
	$('#select_search_input').removeClass('color_gray').addClass('color_gray');
	$('#select_search_input').val($.i18n('uc.staff.name.js'));
    $('.P_SelectContent').empty();
    
    var treeObj = $.fn.zTree.getZTreeObj(curTabId + '_SelectTree'); 
    if (!_needRefresh && treeObj) {
        var selectedNode = treeObj.getSelectedNodes()[0];
        if (selectedNode) {
        	if (curTabId == 'Dept') {
        		getSTMembersByDept(selectedNode.id);
        	} else if (curTabId == 'Team') {
        		if (!selectedNode.nocheck) {
        			getSTMembersByTeam(selectedNode.id, selectedNode.jid);
        	    } else {
        	    	$('#' + curTabId + '_SelectContent').empty();
        	    	endProc();
        	    }
        	} else if (curTabId == 'Post') {
        		if (selectedNode.id != 0) {
        			getSTMembersByPost(selectedNode.id, selectedNode.accountid);
        	    } else {
        	    	$('#' + curTabId + '_SelectContent').empty();
        	    	endProc();
        	    }
        	}else if (curTabId == 'Relate') {
        		if (selectedNode.id != 0) {
        			getSTMembersByRelate(selectedNode.id, selectedNode.type);
    		    } else {
    		    	$('#' + curTabId + '_SelectContent').empty();
    		    	endProc();
    		    }
        	}
        } else {
        	endProc();
        }
        return;
    }
    
    if (curTabId == "Dept") {
        var DeptSelectSetting = {
            data: {
                simpleData: {
                    enable: true,
                    idKey: "id",
                    pIdKey: "parentId",
                    rootPId: null
                }
            }, callback: {
                onClick: onDeptSelectTreeClick,
                onCheck: zTreeOnDeptCheck
            }, check: {
            	enable: showCheck,
            	chkStyle: "checkbox",
            	chkboxType: {"Y": "", "N": ""}
            }
        };
        
        var rootNode = _AccountMap.get(curSelectAccountId);
        rootNode.nocheck = true;
        var _childNodes = getChildDepartments(rootNode, curSelectAccountId);
        _childNodes[_childNodes.length] = rootNode;
        var nodes = JSON.stringify(_childNodes);
        $.fn.zTree.init($('#' + curTabId + '_SelectTree'), DeptSelectSetting, eval(nodes));
        
        var treeObj = $.fn.zTree.getZTreeObj(curTabId + '_SelectTree');
        var _selectNode = treeObj.getNodeByParam("id", _CurrentDeptId, null);
        if (_selectNode) {
        	treeObj.selectNode(_selectNode);
        	getSTMembersByDept(_selectNode.id,_selectNode.type);
        }
    } else if (curTabId == "Team") {
    	teams = new Array();
        var iq = connWin.newJSJaCIQ();
        iq.setFrom(_CurrentUser_jid);
        iq.setIQ('group.localhost', 'get');
        iq.setQuery('seeyon:group:query:info');
        connWin.con.send(iq, getTeamTreeNode, curTabId);
    } else if (curTabId == "Post") {
        if (dataCenter.get(curSelectAccountId).get(Constants_Post).size() > 0) {
            showPostTree(curTabId);
        } else {
            var iq = connWin.newJSJaCIQ();
            iq.setIQ(null, 'get');
            var query = iq.setQuery('jabber:iq:seeyon:office-auto');
            query.appendChild(iq.buildNode('client_version', '', '1.2'));
            var organization = iq.buildNode('organization', {'xmlns': 'organization:post:query'});
            var post = iq.buildNode('post');
            post.appendChild(iq.buildNode('account_id', '', curSelectAccountId));
            post.appendChild(iq.buildNode('update_time'));
            organization.appendChild(post);
            query.appendChild(organization);
            connWin.con.send(iq, getPostTreeNode, curTabId);
        }
	} else if (curTabId == "Relate") {
        var RelateSelectSetting = {
            data: {
                simpleData: {
                    enable: true,
                    idKey: "id",
                    pIdKey: "parentId",
                    rootPId: null
                }
            }, callback: {
                onClick: onRelateSelectTreeClick,
                onCheck: zTreeOnRelateCheck
            }, check: {
            	enable: showCheck,
            	chkStyle: "checkbox"
            }
        };
        
        var nodes = [{
            id: 0,
            parentId: null,
            name: $.i18n('uc.relate.all.js'),
            open: true,
            nocheck: true
        }, {
            id: 11,
            parentId: 0,
            name: $.i18n('uc.relate.leader.js'),
            type: "leader"
        }, {
            id: 12,
            parentId: 0,
            name: $.i18n('uc.relate.junior.js'),
            type: "junior"
        }, {
            id: 13,
            parentId: 0,
            name: $.i18n('uc.relate.assistant.js'),
            type: "assistant"
        }, {
            id: 14,
            parentId: 0,
            name: $.i18n('uc.relate.confrere.js'),
            type: "confrere"
        }];
        
        $.fn.zTree.init($('#' + curTabId + '_SelectTree'), RelateSelectSetting, nodes);
        var treeObj = $.fn.zTree.getZTreeObj(curTabId + '_SelectTree');
        var _selectNode = treeObj.getNodeByParam("id", 11, null);
    	treeObj.selectNode(_selectNode);
        getSTMembersByRelate(_selectNode.id, _selectNode.type);
	}
}


var S_AllMembers = new ArrayList();//所有结果
var S_SearchMembers = new ArrayList;//查询结果

/**
 * 清理结果
 */
function clearSearchMembers() {
	$('#' + curTabId + '_SelectContent').empty();
	
	S_AllMembers = new ArrayList();
	S_SearchMembers = new ArrayList;
}

function zTreeOnCheck(type, checked, id, name) {
	if(checked) {
		$('<span class="common_send_people_box font_size12" id="' + id + 'InBox" source="' + id + '" type="' + type + '">' + name.getLimitLength(20, "...") + '<em class="ico16 affix_del_16"></em></span>').click(function(){
			$(this).remove();
			var treeObj = $.fn.zTree.getZTreeObj(curTabId + '_SelectTree');
	        var checkNode = treeObj.getNodeByParam("id", id, null);
	        if (checkNode) {
	        	treeObj.checkNode(checkNode, false, false);
	        }
		}).appendTo($('#Selected_Member').selector);
	}else{
		$('#' + id + 'InBox').remove();
	}
}

/****************************************全部****************************************/
function zTreeOnDeptCheck(event, treeId, treeNode) {
	zTreeOnCheck("Dept", treeNode.checked, treeNode.id, treeNode.name);
	if (treeNode.checked) {
		var treeObj = $.fn.zTree.getZTreeObj(curTabId + '_SelectTree');
    	treeObj.selectNode(treeNode);
		getSTMembersByDept(treeNode.id, treeNode.type);
	}
}

function onDeptSelectTreeClick(e, treeId, treeNode) {
	startProc();
    getSTMembersByDept(treeNode.id, treeNode.type);
}

function getSTMembersByDept(deptId,type) {
	//当前选中部门
	curSelectDeptId = deptId;
	
    if (_DeptMSMap.get(deptId)) {
    	cacheAllMembers(deptId);
    } else {
    	if (isFromA8) {
    		tempForA8 = new Properties();
    		jidsForA8  = "";
    		membersForA8 = new ArrayList();
    		var datas = {
    			    'type':type,
    				'accountId':deptId
    		}
    		$.ajax({
    			type: "POST" , 
    			data: datas,
    			url : connWin._ctpPath+"/uc/chat.do?method=getAllAccounts",
    			dataType:"html",
    			timeout : 10000,
    			success : function (jessn){
    				getSTMsByDeptIdForA8(jessn, deptId);
    			}
    		});
    	} else {
    		var iq = connWin.newJSJaCIQ();
            iq.setIQ(null, 'get');
            var query = iq.setQuery('jabber:iq:seeyon:office-auto');
            query.appendChild(iq.buildNode('client_version', '', '1.2'));
            var organization = iq.buildNode('organization', {'xmlns': 'organization:staff:query'});
            var staff = iq.buildNode('staff');
            staff.appendChild(iq.buildNode('department_id', '', deptId));
            staff.appendChild(iq.buildNode('update_time'));
            organization.appendChild(staff);
            query.appendChild(organization);
            connWin.con.send(iq, getSTMSByDept, deptId);
    	}
    }
}
var allMemberList = null;
function getSTMsByDeptIdForA8 (jsonStr,deptId) {
	var json = null;
    try {
		eval("json = " + jsonStr);
	} catch (e) {
	}
	var membersJson = json['M'];
	var memberIds = new ArrayList();
	for (i = 0; i < membersJson.length ; i ++) {
		var memberJson = membersJson[i];
		var memberId = memberJson['M'];
		memberIds.add(memberId);
	}
	if (memberIds.size () > 500) {
		var itemList = memberIds.subList(0,500);
		allMemberList = memberIds.subList(500,memberIds.size());
		queryMemberInfoForA8(itemList,deptId);
	} else {
		allMemberList = new ArrayList();
		queryMemberInfoForA8(memberIds,deptId);
	}
}

function queryMemberInfoForA8 (memberlist ,deptId) {
	var iq = connWin.newJSJaCIQ();
	iq.setIQ(null, 'get');
	var query = iq.setQuery('jabber:iq:seeyon:office-auto');
	query.appendChild(iq.buildNode('client_version', '', '1.2'));
	var organization = iq.buildNode('organization', {'xmlns': 'organization:memberid:info:query'});
	var staff = iq.buildNode('staff',{'dataType': 'json'});
	var memberIdStr = "";
	for (i = 0; i < memberlist.size() ; i ++) {
		var memberId = memberlist.get(i);
		memberIdStr += memberId+"|" + deptId + ",";
	}
	if (memberIdStr.length > 0) { 
		memberIdStr.substring(0,memberIdStr.length -1);
	}
	staff.appendChild(iq.buildNode('member', memberIdStr));
	organization.appendChild(staff);
	query.appendChild(organization);
	connWin.con.send(iq, getSTMSByDeptForA8,deptId);
}

function getSTMSByDeptForA8(iq, deptId) {
	getSTDepartmentMembersByDept(iq.getNode().getElementsByTagName('staffs'), deptId);
}

function getSTMSByDept(iq, deptId) {
    getSTDepartmentMembers(iq.getNode().getElementsByTagName('jid'), deptId);
    cacheAllMembers(deptId);
}

function getSTDepartmentMembersByDept(items, deptId) {
	if (items && items.length > 0) { 
		try {
        	var item = '';
        	if (v3x.isFirefox) {
        		item = items.item(0).innerHTML;
        	} else {
        		item = items.item(0).firstChild.nodeValue;
        	}
            var json = null;
            try {
				eval("json = " + item);
			} catch (e) {
			}
			var membersJson = json["M"];
			for (var i = 0; i < membersJson.length; i++) { 
				var memberJson = membersJson[i];
				var jid = memberJson['J'];
				if (!tempForA8.containsKey(jid) && jid != _CurrentUser_jid) { 
					tempForA8.put(jid, true);
					var member = new OrgMemberSimple();
					member.unitid = curSelectAccountId;
					member.deptid = curSelectDeptId;
					member.orgDeptid = deptId;
					member.levelid = memberJson['L'];
					member.jid = jid;
					if ((curTabId == 'Dept' || curTabId == 'Post') && !checkLevelScope(member)) {
						continue;
					}
					member.name = memberJson['N'];
					member.sortid = parseInt(memberJson['S']);
                	jidsForA8 += member.jid + ",";
                	cacheNames.put(member.jid, member.name);
                	membersForA8.add(member);
				}
			}
		} catch(e) { 
		}
	}
	if (allMemberList == null || allMemberList.size() <= 0) {
		cacheJids.put(deptId, jidsForA8);
		QuickSortArrayList(membersForA8, "sortid");
		_DeptMSMap.put(deptId, membersForA8);
		cacheAllMembers(deptId);
	} else {
		var itemList = new ArrayList();
		if (allMemberList.size() < 500) {
			itemList = allMemberList.subList(0,allMemberList.size());
			allMemberList = new ArrayList();
		} else {
			itemList = allMemberList.subList(0,500);
			allMemberList = allMemberList.subList(500,allMemberList.size());
		}
		queryMemberInfoForA8(itemList,deptId);
	}
}


function cacheAllMembers(deptId) {
	S_AllMembers = _DeptMSMap.get(deptId);
	S_SearchMembers = S_AllMembers;
	cacheSearchMembers();
}

function cacheSearchMembers() {
	totalSize = S_SearchMembers.size();
	totalPage = parseInt((totalSize + pageSize - 1) / pageSize);
	if (totalPage == 0) {
		totalPage = 1;
	}
	currentPage = 1;
	pageSearchMembers();
}

function pageSearchMembers() {
	$('#' + curTabId + '_currentPage').text(currentPage);
	$('#' + curTabId + '_totalPage').text(totalPage);
	
	start = (currentPage - 1) * pageSize;
	end = start + pageSize;
	if (end > totalSize) {
		end = totalSize;
	}
	
	getSTMByDept();
}

function getSTMByDept() {
	var deptId = '';
	if (curTabId == 'Dept') {
		deptId = curSelectDeptId;
		
		var account = _AccountMap.get(curSelectDeptId);
		if (account) {
	        deptId = '';
	    }
	}
	
    var members = S_SearchMembers.subList(start, end);
    var iq = connWin.newJSJaCIQ();
    iq.setIQ(null, 'get');
    var query = iq.setQuery('jabber:iq:seeyon:office-auto');
    var organization = iq.buildNode('organization', {'xmlns': 'organization:staff:info:query'});
    var staff = iq.buildNode('staff');
    for (var i = 0; i < members.size(); i++) {
    	if (curTabId == 'Dept') {
    		staff.appendChild(iq.buildNode('jid', {'accid': curSelectAccountId, 'deptid': deptId}, members.get(i).jid));
    	} else {
    		staff.appendChild(iq.buildNode('jid', {'deptid': ''}, members.get(i).jid));
    	}
    }
    organization.appendChild(staff);
    query.appendChild(organization);
    connWin.con.send(iq, STMembersToHTML);
}

function STMembersToHTML(iq) {
	var members = initSTOrgMembers(iq.getNode().getElementsByTagName('jid'));
	
	$('#' + curTabId + '_SelectContent').empty();
    if (!members.isEmpty()) {
    	QuickSortArrayList(members, "sortid");
		var data = new Properties();
		$('#Selected_Member span').each(function(i){
			data.put($(this).attr('source'), true);
	    });
		
        for (var i = 0; i < members.size(); i++) {
            try {
                var member = members.get(i);
                
                //过滤自己
                if (member.jid == _CurrentUser_jid) {
                	continue;
                }
                
                //过滤不可用人员
                if (member.name == '') {
                	continue;
                }
                
                var className = data.get(member.jid) ? 'ico16 handled_16' : '';
                
                var strBuffer = new StringBuffer();
                strBuffer.append("<div id='" + member.memberid + "People' jid='" + member.jid + "' name='" + member.name + "' class='ucFaceImage hand left relative' style='width:100px'>");
                strBuffer.append("<span class='onlineState_box'><span id='" + member.memberid + "InBoxState' class='onlineState " + className + "'></span></span>");
                strBuffer.append("<img class='img' src='" + member.photo + "' width='35' height='35' alt=''>");
                strBuffer.append("<span class='name' title='" + member.name + "'>" + member.name.getLimitLength(8, "...") + "</span>");
                strBuffer.append("</div>");
                
                $('#' + curTabId + '_SelectContent').append(strBuffer.toString());
                strBuffer.clear();
                
                (function(obj){
                    $('#' + obj.memberid + 'People').click(function(){
                    	if($('#' + obj.memberid + 'InBox').length > 0) {
                    		$('#' + obj.memberid + 'InBox').remove();
                    		$('#' + obj.memberid + 'InBoxState').removeClass('ico16 handled_16');
                    	}else{
                    		$('<span title="' + obj.name + '" class="common_send_people_box font_size12" id="' + obj.memberid + 'InBox" source="' + obj.jid + '" type="Member"><span style="max-width: 50px;*width:50px; display:inline-block;white-space:nowrap;" class="text_overflow">' + obj.name.getLimitLength(20, "...") + '</span><em class="ico16 affix_del_16"></em></span>').click(function(){
                    			$(this).remove();
                    			$('#' + obj.memberid + 'InBoxState').removeClass('ico16 handled_16');
                    		}).appendTo($('#Selected_Member').selector);
                    		$('#' + obj.memberid + 'InBoxState').addClass('ico16 handled_16');
                    	}
                    	$('#Selected_Member').scrollTop($('#Selected_Member')[0].scrollHeight);
                    });
                })(member);
            } catch (e) {}
        }
    }
    
    endProc();
}

/****************************************群组****************************************/
var groupPackageCount = 0;
function getTeamTreeNode(iq) {
	groupPackageCount ++;
    var last = true;
    var groups = iq.getNode().getElementsByTagName('groups').item(0);
    if (groups) {
        last = groupPackageCount == groups.getAttribute("total");
        connWin.con._regIDs[iq.getID()].last = last;
    }
    
    var items = iq.getNode().getElementsByTagName('group_info');
    if (items) {
    	for (var i = 0; i < items.length; i++) {
    		try {
                var item = items.item(i);
    			var teamtype = item.getAttribute('T');
    			//过滤部门组
    			if (teamtype == '6') {
    				continue;
    			}
    			var teamjid = item.getAttribute('I');
    			var teamname = item.getAttribute('NA');
    			teams[teams.length] = {
					id: teamjid.substring(0, teamjid.indexOf('@')),
					parentId: teamtype,
					jid: teamjid,
					name: teamname
    			};
    		} catch (e) {}
    	}
    }
    
    if (last) {
    	groupPackageCount = 0;
        showTeamTree();
    }
}

function showTeamTree() {
	var TeamSelectSetting = {
        data: {
            simpleData: {
                enable: true,
                idKey: "id",
                pIdKey: "parentId",
                rootPId: null
            }
        }, callback: {
            onClick: onTeamSelectTreeClick,
            onCheck: zTreeOnTeamCheck
        }, check: {
        	enable: showCheck,
        	chkStyle: "checkbox"
        }
    };
    
    var nodes = [{
        id: 100,
        parentId: null,
        name: $.i18n('uc.group.all.js'),
        open: true,
        nocheck: true
    }, {
        id: 2,
        parentId: 100,
        name: $.i18n('uc.group.system.js'),
        nocheck: true
    }, {
        id: 3,
        parentId: 100,
        name: $.i18n('uc.group.project.js'),
        nocheck: true
    }, {
        id: 4,
        parentId: 100,
        name: $.i18n('uc.group.msg.js'),
        open: true,
        nocheck: true
    }];
    
    for (var i = 0; i < teams.length; i++) {
    	nodes[nodes.length] = teams[i];
	}
    
    $.fn.zTree.init($('#' + curTabId + '_SelectTree'), TeamSelectSetting, eval(nodes));
    var treeObj = $.fn.zTree.getZTreeObj(curTabId + '_SelectTree');
    var _selectNodes = treeObj.getNodeByParam("id", 4, null);
    if (_selectNodes.children) {
    	var _selectNode = _selectNodes.children[0];
    	treeObj.selectNode(_selectNode);
    	getSTMembersByTeam(_selectNode.id, _selectNode.jid);
    } else {
    	treeObj.selectNode(_selectNodes);
    	endProc();
    }
}

function zTreeOnTeamCheck(event, treeId, treeNode) {
	zTreeOnCheck("Team", treeNode.checked, treeNode.id, treeNode.name);
	if (treeNode.checked) {
		var treeObj = $.fn.zTree.getZTreeObj(curTabId + '_SelectTree');
    	treeObj.selectNode(treeNode);
		getSTMembersByTeam(treeNode.id, treeNode.jid);
	}
}

function onTeamSelectTreeClick(e, treeId, treeNode) {
	startProc();
    if (!treeNode.nocheck) {
    	getSTMembersByTeam(treeNode.id, treeNode.jid);
    } else {
    	clearSearchMembers();
    	endProc();
    }
}

function getSTMembersByTeam(id, jid) {
	if (_DeptMSMap.get(id)) {
		cacheAllMembers(id);
    } else {
    	var iq = connWin.newJSJaCIQ();
        iq.setFrom(_CurrentUser_jid);
        iq.setIQ(jid, 'get', 'group1');
        var query = iq.setQuery('seeyon:group:query:member');
        connWin.con.send(iq, getSTMSByDept, id);
    }
}

/****************************************岗位****************************************/
var postPackageCount = 0;
function getPostTreeNode(iq) {
	postPackageCount ++;
    var last = true;
    var posts = iq.getNode().getElementsByTagName('posts').item(0);
    if (posts) {
        last = postPackageCount == posts.getAttribute("total");
        connWin.con._regIDs[iq.getID()].last = last;
    }
    
    initAllOrgPosts(iq.getNode().getElementsByTagName('post'), curSelectAccountId);
    
    if (last) {
    	postPackageCount = 0;
        showPostTree();
    }
}

function showPostTree() {
    var RelateSelectSetting = {
        data: {
            simpleData: {
                enable: true,
                idKey: "id",
                pIdKey: "parentId",
                rootPId: null
            }
        }, callback: {
            onClick: onPostSelectTreeClick,
            onCheck: zTreeOnPostCheck
        }, check: {
        	enable: showCheck,
        	chkStyle: "checkbox"
        }
    };
    
    var nodes = [{
        id: 0,
        parentId: null,
        name: $.i18n('uc.selectType.post.js'),
        open: true,
        nocheck: true
    }];
    
    var postList = dataCenter.get(curSelectAccountId).get(Constants_Post);
    for (var i = 0; i < postList.size(); i++) {
        nodes[nodes.length] = {
            id: postList.get(i).id,
            parentId: 0,
            name: postList.get(i).name,
            accountid: postList.get(i).account
        };
    }
    $.fn.zTree.init($('#' + curTabId + '_SelectTree'), RelateSelectSetting, eval(nodes));
    
    var treeObj = $.fn.zTree.getZTreeObj(curTabId + '_SelectTree');
    var _selectNode = treeObj.getNodeByParam("id", _CurrentPostId, null);
    if (_selectNode) {
    	treeObj.selectNode(_selectNode);
    	getSTMembersByPost(_selectNode.id, _selectNode.accountid);
    } else {
    	endProc();
    }
}

function zTreeOnPostCheck(event, treeId, treeNode) {
	zTreeOnCheck("Post", treeNode.checked, treeNode.id, treeNode.name);
	if (treeNode.checked) {
		var treeObj = $.fn.zTree.getZTreeObj(curTabId + '_SelectTree');
    	treeObj.selectNode(treeNode);
		getSTMembersByPost(treeNode.id, treeNode.accountid);
	}
}

function onPostSelectTreeClick(e, treeId, treeNode) {
	startProc();
    if (treeNode.id != 0) {
        getSTMembersByPost(treeNode.id, treeNode.accountid);
    } else {
    	clearSearchMembers();
    	endProc();
    }
}

function getSTMembersByPost(postId, unitId) {
    if (_DeptMSMap.get(postId)) {
        cacheAllMembers(postId);
    } else {
        var iq = connWin.newJSJaCIQ();
        iq.setFrom(_CurrentUser_jid);
        iq.setIQ(null, 'get');
        var query = iq.setQuery('jabber:iq:seeyon:office-auto');
        var organization = iq.buildNode('organization', {'xmlns': 'organization:post:getjid:query'});
        var staff = iq.buildNode('staff');
        staff.appendChild(iq.buildNode('unitid', unitId));
        staff.appendChild(iq.buildNode('postid', postId));
        organization.appendChild(staff);
        query.appendChild(organization);
        connWin.con.send(iq, getSTMSByDept, postId);
    }
}

/****************************************关联人员****************************************/
function zTreeOnRelateCheck(event, treeId, treeNode) {
	zTreeOnCheck("Relate", treeNode.checked, treeNode.id, treeNode.name);
	if (treeNode.checked) {
		var treeObj = $.fn.zTree.getZTreeObj(curTabId + '_SelectTree');
    	treeObj.selectNode(treeNode);
		getSTMembersByRelate(treeNode.id, treeNode.type);
	}
}

function onRelateSelectTreeClick(e, treeId, treeNode) {
	startProc();
	if (treeNode.id != 0) {
		getSTMembersByRelate(treeNode.id, treeNode.type);
    } else {
    	clearSearchMembers();
    	endProc();
    }
}

function getSTMembersByRelate(id, type) {
	if (_DeptMSMap.get(id)) {
		cacheAllMembers(id);
    } else {
    	var iq = connWin.newJSJaCIQ();
        iq.setFrom(_CurrentUser_jid);
        iq.setIQ(_CurrentUser_jid, 'get', 'get_relatemembers1');
        var query = iq.setQuery('jabber:iq:relatemember');
        query.appendChild(iq.buildNode('relategroupid', type));
        connWin.con.send(iq, getSTMSByDept, id);
    }
}

/**
 * 获取部门、关联组、群组人员jid,name
 */
function getSTDepartmentMembers(items, deptId) {
	if (items) {
		var temp = new Properties();
		var jids  = "";
		var members = new ArrayList();
		for (var i = 0; i < items.length; i++) {
			try {
				var item = items.item(i);
				var jid = item.getAttribute('J');
				
				if (!temp.containsKey(jid) && jid != _CurrentUser_jid) {
					temp.put(jid, true);
					
					var member = new OrgMemberSimple();
					member.unitid = curSelectAccountId;
					member.deptid = curSelectDeptId;
					member.orgDeptid = deptId;
					member.levelid = item.getAttribute('L');
					member.jid = jid;
					if ((curTabId == 'Dept' || curTabId == 'Post') && !checkLevelScope(member)) {
						continue;
					}
					member.name = item.getAttribute('N');
					member.sortid = parseInt(item.getAttribute('S'));
					
                	jids += member.jid + ",";
                	cacheNames.put(member.jid, member.name);
                	members.add(member);
				}
			} catch (e) {}
		}
		
		cacheJids.put(deptId, jids);
		QuickSortArrayList(members, "sortid");
		_DeptMSMap.put(deptId, members);
	}
}

/**
 * 获取部门、关联组、群组人员详细信息
 */
function initSTOrgMembers(items) {
	var result = new ArrayList();
	
	if (items) {
		for (var i = 0; i < items.length; i++) {
			try {
				var member = new OrgMember();
				var item = items.item(i);
				member.jid = item.getAttribute('J');
				member.memberid = item.getAttribute('I');
				member.name = item.getAttribute('N');
				member.sortid = parseInt(item.getAttribute('S'));
				var photo = item.getAttribute('H');
				if (photo) {
					member.photo = photo;
				}
				
				result.add(member);
			} catch (e) {}
		}
	}
	
	return result;
}
