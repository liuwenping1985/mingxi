/**
 * 单位、部门信息
 */
function OrgUnit(){
    this.id = null;
    this.name = null;
    this.showname = null;
    this.type = null;
    this.sort = null;
    this.levelScope = null;
    this.path = null;
    this.online = null;
    this.total = null;
    this.parentId = null;
    this.parentPath = null;
    this.isinternal = null;
    this.icon = null;
}

/**
 * 岗位信息
 */
function OrgPost(){
    this.id = null;
    this.name = null;
    this.account = null;
    this.sort = null;
}

/**
 * 职务级别信息
 */
function OrgLevel(){
    this.id = null;
    this.name = null;
    this.account = null;
    this.level = null;
    this.groupLevel = null;
    this.sort = null;
}

/**
 * 人员信息
 */
function OrgMember(){
    this.jid = '';
    this.memberid = '';
    this.name = '';
    this.unitid = '';
    this.deptid = '';
    this.postid = '';
    this.levelid = '';
    this.unitname = '';
    this.deptname = '';
    this.postname = '';
    this.levelname = '';
    this.sex = '';
    this.mobile = '';
    this.telephone = '';
    this.email = '';
    this.isinternal = '';// 0:外部人员,1:内部人员
    this.sortid = '0';
    this.online = '0';// 0:不在线,1:在线
    this.photo = v3x.baseURL + '/apps_res/v3xmain/images/personal/pic.gif';// 默认头像
    this.mood = '';
}

/**
 * 人员在线信息
 */
function OrgMemberSimple(){
    this.jid = '';
    this.sortid = 0;
    this.online = 0;// 0:不在线,1:在线
    this.name = '';
    this.levelid = '';
}

/**
 * 解析单位信息
 */
function initAllOrgUnits(items){
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
            var unitsJson = json["U"];
            for (var i = 0; i < unitsJson.length; i++) {
            	var unitJson = unitsJson[i];
            	
                var id = unitJson['I'];
                if (_AccountMap.get(id)) {
                    continue;
                }
                
                var orgUnit = new OrgUnit();
                orgUnit.id = id;
                orgUnit.name = unitJson['N'];
                orgUnit.type = unitJson['T'];
                orgUnit.sort = parseInt(unitJson['S']);
                orgUnit.levelScope = parseInt(unitJson['L']);
                orgUnit.path = unitJson['P'];
                orgUnit.total = unitJson['C'];
                orgUnit.isinternal = unitJson['W'];
                orgUnit.showname = orgUnit.name + '(' + orgUnit.total + ')';
                orgUnit.icon = v3x.baseURL + '/apps_res/addressbook/images/templete.gif';
                
                if (isGroupVer != 'true' || accessableAccountIds.get(id)) {
                    _AccountMap.put(orgUnit.id, orgUnit);
                    _UnitPathToIdMap.put(orgUnit.path, orgUnit.id);
                }
            }
        } catch (e) {}
    }
}

/**
 * 解析部门信息
 */
function initOrgDepts(items, accountId){
    var depts = new ArrayList();
    
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
            var deptsJson = json["U"];
            for (var i = 0; i < deptsJson.length; i++) {
            	var deptJson = deptsJson[i];
            	
                var orgUnit = new OrgUnit();
                orgUnit.id = deptJson['I'];
                orgUnit.name = deptJson['N'];
                orgUnit.type = deptJson['T'];
                orgUnit.sort = parseInt(deptJson['S']);
                orgUnit.path = deptJson['P'];
                orgUnit.total = deptJson['C'];
                orgUnit.isinternal = deptJson['W'];
                orgUnit.showname = orgUnit.name + '(' + orgUnit.total + ')';
                
                if (orgUnit.isinternal == '1') {
                    orgUnit.icon = v3x.baseURL + '/apps_res/uc/chat/image/dept.png';
                } else {
                    orgUnit.icon = v3x.baseURL + '/apps_res/uc/chat/image/idept.png';
                }
                
                if (_CurrentUserInternal == '1' || connWin.accessableDepartmentIds.get(orgUnit.id)) {
	                depts.add(orgUnit);
	                _UnitPathToIdMap.put(orgUnit.path, orgUnit.id);
                }
            }
        } catch (e) {}
    }
    
    dataCenter.get(accountId).get(Constants_Department).addList(depts);
}

/**
 * 解析岗位信息
 */
function initAllOrgPosts(items, accountId){
    var posts = new ArrayList();
    
    if (items) {
        for (var i = 0; i < items.length; i++) {
            try {
                var item = items.item(i);
                
                var orgPost = new OrgPost();
                orgPost.id = item.getAttribute('I');
                orgPost.name = item.getAttribute('N');
                orgPost.account = item.getAttribute('A');
                orgPost.sort = item.getAttribute('S');
                
                posts.add(orgPost);
                dataCenterMap[accountId][Constants_Post][orgPost.id] = orgPost;
            } catch (e) {}
        }
    }
    
    dataCenter.get(accountId).get(Constants_Post).addList(posts);
}

/**
 * 解析职务级别信息
 */
function initAllOrgLevels(items, accountId){
    var levels = new ArrayList();
    
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
            var levelsJson = json["L"];
            for (var i = 0; i < levelsJson.length; i++) {
            	var levelJson = levelsJson[i];
            	
                var orgLevel = new OrgLevel();
                orgLevel.id = levelJson['I'];
                orgLevel.name = levelJson['N'];
                orgLevel.account = levelJson['A'];
                orgLevel.level = levelJson['L'];
                orgLevel.groupLevel = levelJson['G'];
                
                levels.add(orgLevel);
                dataCenterMap[accountId][Constants_Level][orgLevel.id] = orgLevel;
            }
        } catch (e) {}
    }
    
    dataCenter.get(accountId).get(Constants_Level).addList(levels);
}

/**
 * 解析人员信息
 */
function initOrgMembers(items){
    var result = new ArrayList();
    
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
            	
                var member = new OrgMember();
                member.jid = memberJson['J'];
                member.memberid = memberJson['I'];
                member.name = memberJson['N'];
                member.unitid = memberJson['A'];
                member.deptid = memberJson['D'];
                member.postid = memberJson['P'];
                member.levelid = memberJson['L'];
                member.unitname = memberJson['AM'];
                member.deptname = memberJson['DM'];
                member.postname = memberJson['PM'];
                member.levelname = memberJson['LM'];
                member.sex = memberJson['G'];
                member.mobile = memberJson['Y'];
                member.telephone = memberJson['T'];
                member.email = memberJson['E'];
                member.isinternal = memberJson['W'];
                member.sortid = parseInt(memberJson['S']);
                member.online = memberJson['O'];
                
                var photo = memberJson['H'];
                if (photo) {
                	var re = /&amp;/g; 
                	member.photo = photo.replace(re,"&");
                }
                
                var mood = memberJson['M'];
                if (mood) {
                    member.mood = mood;
                }
                
                result.add(member);
            }
        } catch (e) {}
    }
    
    return result;
}

/**
 * 解析单位关联信息
 */
function initUnitsRelation(){
    if (!_AccountMap.isEmpty()) {
        for (var i = 0; i < _AccountMap.keys().size(); i++) {
            try {
                var key = _AccountMap.keys().get(i);
                if (_AccountMap.get(key).path.length > 4) {
                    var pPath = _AccountMap.get(key).path.substring(0, _AccountMap.get(key).path.length - 4);
                    
                    _AccountMap.get(key).parentPath = pPath;
                    _AccountMap.get(key).parentId = _UnitPathToIdMap.get(pPath);
                }
            } catch (e) {}
        }
    }
}

/**
 * 解析部门关联信息
 */
function initDeptsRelation(accountId){
    var depts = dataCenter.get(accountId).get(Constants_Department);
    
    if (!depts.isEmpty()) {
        for (var i = 0; i < depts.size(); i++) {
            try {
                if (depts.get(i).path.length > 4) {
                    var pPath = depts.get(i).path.substring(0, depts.get(i).path.length - 4);
                    
                    depts.get(i).parentPath = pPath;
                    depts.get(i).parentId = _UnitPathToIdMap.get(pPath);
                    
                    dataCenterMap[accountId][Constants_Department][depts.get(i).id] = depts.get(i);
                }
            } catch (e) {}
        }
    }
}

/**
 * 获取子部门信息
 */
function getChildDepartments(unit, accountId){
    var result = new Array();
    
    var depts = dataCenter.get(accountId).get(Constants_Department);
    QuickSortArrayList(depts, "sort");
    if (!depts.isEmpty()) {
        for (var i = 0; i < depts.size(); i++) {
            try {
                if (depts.get(i).path.indexOf(unit.path) == 0 && depts.get(i).path != unit.path) {
                    result[result.length] = depts.get(i);
                }
            } catch (e) {}
        }
    }
    
    return result;
}

/**
 * 获取部门人员信息
 */
function getDepartmentMembers(items){
    var result = new ArrayList();
    
    if (items) {
        for (var i = 0; i < items.length; i++) {
            try {
                var item = items.item(i);
                var member = new OrgMemberSimple();
                member.jid = item.getAttribute('J');
                member.name = item.getAttribute('N');
                member.sortid = item.getAttribute('S');
                member.online = item.getAttribute('O');
                result.add(member);
            } catch (e) {}
        }
    }
    
    return result;
}

/**
 * 职务级别控制
 */
function checkLevelScope(member){
	try {
		var memberAccountId = member.unitid;
		var memberDeptId = member.deptid;
		var memberOrgDeptId = member.orgDeptid;
		var memberLevelId = member.levelid;
		var memberAccountLevelScope = _AccountMap.get(memberAccountId).levelScope;
		
		//外部人员
        if (_CurrentUserInternal == '0') {
        	if (_CurrentUser.jid == member.jid) {
        		return true;
        	}
    		if (_CurrentDeptId == memberOrgDeptId) {
    			return true;
    		}
        	var memberId = '';
        	if (member.jid.indexOf('@') > -1) {
        		memberId = member.jid.substr(0,member.jid.indexOf('@'));
        	} else {
        		memberId = member.jid
        	}
            if (connWin.accessableDepartmentId.get(memberOrgDeptId) || connWin.accessableMemberIds.get(memberId)) {
                return true;
            } else {
                return false;
            }
        }
        
        //内部人员，职务级别为-1，如NC同步过来的
        if (_CurrentUserInternal == '1' && _CurrentLevelId == -1) {
            return false;
        }
        
		//同一个部门
		if (_CurrentDeptId == memberDeptId) {
			return true;
		}
		
		//兼职部门
		if (departmentsCache.get(memberDeptId)) {
			return true;
		}
		
		//同一个职务级别
		if (_CurrentLevelId == memberLevelId) {
			return true;
		}
		
		//当前单位工作范围控制
		if (_CurrentAccountLevelScope < 0) {
			return true;
		}
		
		//切换单位工作范围控制
		if (memberAccountLevelScope < 0) {
			return true;
		}
		
		var currentMemberLevelSortId = 0;
		var memberLevelSortId = dataCenterMap[memberAccountId][Constants_Level][memberLevelId].level;
		var accountLevelScope = 0;
		if (memberAccountId == _CurrentAccountId) {
			currentMemberLevelSortId = _CurrentUserLevelSortId;
			accountLevelScope = _CurrentAccountLevelScope;
		} else {
			var levelIdOfGroup = (_CurrentLevelId != -1) ? dataCenterMap[_CurrentAccountId][Constants_Level][_CurrentLevelId].groupLevel : -1;
			var levels = dataCenter.get(memberAccountId).get(Constants_Level);
			for (var i = 0; i < levels.size(); i++) {
				if (levelIdOfGroup != 'null' && levelIdOfGroup == levels.get(i).groupLevel) {
					currentMemberLevelSortId = levels.get(i).level;
					break;
				}
			}
			accountLevelScope = memberAccountLevelScope;
		}
		
		if (currentMemberLevelSortId - memberLevelSortId <= accountLevelScope) {
			return true;
		}
		
		return false;
	} catch (e) {
		return true;
	}
}

/** **************************************UC组织机构缓存*************************************** */
var Constants_Department = "Department";
var Constants_Post = "Post";
var Constants_Level = "Level";
var Constants_Group = "-1730833917365171641";

var dataCenter = new Properties();
var dataCenterMap = {};

var _AccountMap = new Properties();
var _UnitPathToIdMap = new Properties();
var _DeptMSMap = new Properties();
var _CurrentUser = null;
var _CurrentUserInternal = null;
var _CurrentUser_jid = null;
var _CurrentUserLevelSortId = null; // 当前用户的职务级别序号
var _CurrentAccountId = null;
var _CurrentDeptId = null;
var _CurrentPostId = null;
var _CurrentLevelId = null;
var _CurrentAccountLevelScope = -1; // 当前单位的职务级别范围
var _CurrentSelectAccountId = null;

var orgTotalSize = 0;//总共条数
var orgPageSize = 10;//每页条数
var orgTotalPage = 1;//总共页数
var orgCurrentPage = 1;//当前页数
var orgStart = 0;//开始条数
var orgEnd = 0;//线束条数
var Org_AllMembers = new ArrayList();//所有结果
var Org_SearchMembers = new ArrayList;//查询结果
var Org_SelectDeptId = null;//当前选中的节点
var departmentsCache = new Properties(); // 缓存当前用户的所有部门
/** **************************************UC组织机构缓存*************************************** */

/**
 * 获取当前用户信息
 */
function getCurrentUser(){
    var iq = connWin.newJSJaCIQ();
    iq.setIQ(null, 'get');
    var query = iq.setQuery('jabber:iq:seeyon:office-auto');
    var organization = iq.buildNode('organization', {'xmlns': 'organization:staff:info:query'});
    var staff = iq.buildNode('staff', {'dataType': 'json'});
    staff.appendChild(iq.buildNode('jid', {'deptid': ''}, connWin.jid));
    organization.appendChild(staff);
    query.appendChild(organization);
    connWin.con.send(iq, getCurrentAccount);
}

/**
 * 获取当前单位信息
 */
function getCurrentAccount(iq){
    _CurrentUser = initOrgMembers(iq.getNode().getElementsByTagName('staff')).get(0);
    _CurrentUserInternal = _CurrentUser.isinternal;
    _CurrentUser_jid = _CurrentUser.jid;
    _CurrentAccountId = _CurrentUser.unitid;
    _CurrentDeptId = _CurrentUser.deptid;
    _CurrentPostId = _CurrentUser.postid;
    _CurrentLevelId = _CurrentUser.levelid;
    
    if (_CurrentUser_jid == '' || _CurrentUser.name == '') {
    	$.alert($.i18n('uc.title.notMember.js'));
    	getA8Top().endProc();
    	return;
    }
    
    if (cacheType == 'uc') {
        $('#uc_photo').attr('src', _CurrentUser.photo);
        $('#uc_name').html(_CurrentUser.name + '<em id="onlinState" class="' + connWin.onlineStatus + ' margin_r_5" style="cursor: default;"></em>');
        var deptAndPost = _CurrentUser.deptname + "-" + _CurrentUser.postname;
        $('#uc_post').attr('title', deptAndPost);
        $('#uc_post').text(deptAndPost.getLimitLength(60, '...'));
        var mood = _CurrentUser.mood;
        $('#uc_mood').attr('mood', mood);
        if (!mood && mood == '') {
            $('#uc_mood').text($.i18n('uc.mood.edit.js'));
        } else {
        	$('#uc_mood').text(mood);
        }
    }
    
    //获取完个人信息之后获取当前登陆人的所有部门信息(新增协议只可获取当前登陆人的)做缓存 youhb 2013年11月4日17:47:07
    iq = connWin.newJSJaCIQ();
    iq.setIQ(null, 'get');
    var query = iq.setQuery('jabber:iq:seeyon:office-auto');
    query.appendChild(iq.buildNode('client_version', '', '1.2'));
    var organization = iq.buildNode('organization', {'xmlns': 'organization:staff:department:query'});
    var unit = iq.buildNode('staffdepartment');
    organization.appendChild(unit);
    query.appendChild(organization);
    connWin.con.send(iq, handleCurrentDepartments);
}

/**
 * 解析当前登陆人员所有的部门信息 youhb 2013年11月4日16:35:05
 */
function handleCurrentDepartments(iq) {
	var depmartments = iq.getNode().getElementsByTagName('department');
	if (depmartments != null && depmartments.length > 0) {
		for (var i = 0 ; i < depmartments.length; i ++) {
			var depidNode = depmartments.item(i);
			var depid = '';
			try{
				depid = depidNode.firstChild.data
			}catch(e){
			}
			//解析部们信息并放到缓存中以true标示 youhb 2013年11月4日17:47:40
			if (depid != '') {
				departmentsCache.put(depid,true);
			}
		}
	}
	
    iq = connWin.newJSJaCIQ();
    iq.setIQ(null, 'get');
    var query = iq.setQuery('jabber:iq:seeyon:office-auto');
    query.appendChild(iq.buildNode('client_version', '', '1.2'));
    var organization = iq.buildNode('organization', {'xmlns': 'organization:unit:info:query'});
    var unit = iq.buildNode('unit', {'dataType': 'json'});
    unit.appendChild(iq.buildNode('id', '', _CurrentAccountId));
    organization.appendChild(unit);
    query.appendChild(organization);
    connWin.con.send(iq, handleCurrentAccount);
}

/**
 * 解析当前单位信息
 */
function handleCurrentAccount(iq){
    initAllOrgUnits(iq.getNode().getElementsByTagName('units'));
    if (cacheType == 'uc') {
    	focusTab();
    } else if (cacheType == 'selectPeople') {
    	cacheOrgModel(_CurrentAccountId);
    }
}

/**
 * 获取所有单位
 */
function getUnits(){
    if (_AccountMap.size() > 1) {
        showAccountTree();
    } else {
    	getA8Top().startProc();
        var iq = connWin.newJSJaCIQ();
        iq.setIQ(null, 'get');
        var query = iq.setQuery('jabber:iq:seeyon:office-auto');
        query.appendChild(iq.buildNode('client_version', '', '1.2'));
        var organization = iq.buildNode('organization', {'xmlns': 'organization:unit:query'});
        var unit = iq.buildNode('unit', {'dataType': 'json'});
        unit.appendChild(iq.buildNode('type', '', 'unit'));
        unit.appendChild(iq.buildNode('accid'));
        unit.appendChild(iq.buildNode('update_time'));
        organization.appendChild(unit);
        query.appendChild(organization);
        connWin.con.send(iq, getAccountTree);
    }
}

var accountPackageCount = 0;

/**
 * 解析单位树
 */
function getAccountTree(iq){
	accountPackageCount ++;
    var last = true;
    var units = iq.getNode().getElementsByTagName('units').item(0);
    if (units) {
        last = accountPackageCount == units.getAttribute("total");
        connWin.con._regIDs[iq.getID()].last = last;
    }
    
    initAllOrgUnits(iq.getNode().getElementsByTagName('units'));
    
    if (last) {
    	accountPackageCount = 0;
        initUnitsRelation();
        var accountSetting = {
            data: {
                simpleData: {
                    enable: true,
                    idKey: "id",
                    pIdKey: "parentId",
                    rootPId: null
                }
            }, callback: {
                onClick: onAccountTreeClick
            }
        };
        
        var accounts = _AccountMap.values();
        QuickSortArrayList(accounts, "sort");
        var accountNodes = JSON.stringify(accounts.toArray());
        $.fn.zTree.init($("#accountList"), accountSetting, eval(accountNodes));
        
        showAccountTree();
        getA8Top().endProc();
    }
}

/**
 * 单位树节点点击事件
 */
function onAccountTreeClick(e, treeId, treeNode){
	// 点击集团不做响应
	if (treeNode.id == Constants_Group) {
		return;
	}
	
    $("#accountListDiv").fadeOut("fast");
    $("body").unbind("mousedown", onBodyDown);
    
    cacheOrgModel(treeNode.id);
}

/**
 * 显示单位树
 */
function showAccountTree(){
    var accountObj = $("#select_input_div");
    var accountOffset = $("#select_input_div").offset();
    $("#accountListDiv").css({left: accountOffset.left + "px", top: (accountOffset.top + accountObj.height() - 1) + "px", width: accountObj.width() + "px"}).fadeIn("fast");
    
    var treeObj = $.fn.zTree.getZTreeObj("accountList");
    var selectedNode = treeObj.getNodeByParam("id", _CurrentAccountId, null);
    if (selectedNode) {
        treeObj.selectNode(selectedNode);
    }
    
    $("body").bind("mousedown", onBodyDown);
}

/**
 * 绑定body显示单位树事件
 */
function onBodyDown(event){
    if (!(event.target.id == "accountListDiv" || $(event.target).parents("#accountListDiv").length > 0)) {
        $("#accountListDiv").fadeOut("fast");
        $("body").unbind("mousedown", onBodyDown);
    }
}

/**
 * 缓存组织模型
 */
function cacheOrgModel(accountId){
    var accountDataCenter = dataCenter.get(accountId);
    
    if (!accountDataCenter) {
        accountDataCenter = new Properties();
        
        var departments = new ArrayList(); // 部门
        var posts = new ArrayList(); // 岗位
        var levels = new ArrayList(); // 职务级别
        accountDataCenter.put(Constants_Department, departments);
        accountDataCenter.put(Constants_Post, posts);
        accountDataCenter.put(Constants_Level, levels);
        
        dataCenter.put(accountId, accountDataCenter);
        
        var accountDataCenterMap = {};
        
        departmentsMap = {};
        postsMap = {};
        levelsMap = {};
        
        accountDataCenterMap[Constants_Department] = departmentsMap;
        accountDataCenterMap[Constants_Post] = postsMap;
        accountDataCenterMap[Constants_Level] = levelsMap;
        
        dataCenterMap[accountId] = accountDataCenterMap;
        
        getAccountLevels(accountId);
    }
    else {
        getUCOnline(accountId);
    }
}

/**
 * 获取单位下职务级别
 */
function getAccountLevels(accountId){
    var iq = connWin.newJSJaCIQ();
    iq.setIQ(null, 'get');
    var query = iq.setQuery('jabber:iq:seeyon:office-auto');
    query.appendChild(iq.buildNode('client_version', '', '1.2'));
    var organization = iq.buildNode('organization', {'xmlns': 'organization:level:query'});
    var level = iq.buildNode('level', {'dataType': 'json'});
    level.appendChild(iq.buildNode('account_id', '', accountId));
    level.appendChild(iq.buildNode('update_time'));
    organization.appendChild(level);
    query.appendChild(organization);
    connWin.con.send(iq, getAccountDepts, accountId);
}

var levelPackageCount = 0;

/**
 * 获取单位下部门
 */
function getAccountDepts(iq, accountId){
	levelPackageCount ++;
    var last = true;
    var levels = iq.getNode().getElementsByTagName('levels').item(0);
    if (levels) {
        last = levelPackageCount == levels.getAttribute("total");
        connWin.con._regIDs[iq.getID()].last = last;
    }
    
    initAllOrgLevels(iq.getNode().getElementsByTagName('levels'), accountId);
    
    if (last) {
    	//获取部门信息如果不是精灵登陆就从A8 获取
    	levelPackageCount = 0;
    	if (isFromA8) {
    		var datas = {
    			'accountId':accountId
    		}
    		$.ajax({
    			type: "POST" , 
    			data: datas,
    			url : connWin._ctpPath+"/uc/chat.do?method=getDeptByAccount",
    			timeout : 10000,
    			dataType:"html",
    			success : function (jessn){
    				getDeptByIdForA8(jessn, accountId);
    			}
    		});
    	} else {
    		iq = connWin.newJSJaCIQ();
            iq.setIQ(null, 'get');
            var query = iq.setQuery('jabber:iq:seeyon:office-auto');
            query.appendChild(iq.buildNode('client_version', '', '1.2'));
            var organization = iq.buildNode('organization', {'xmlns': 'organization:unit:query'});
            var unit = iq.buildNode('unit', {'dataType': 'json'});
            unit.appendChild(iq.buildNode('type', '', 'dept'));
            unit.appendChild(iq.buildNode('accid', '', accountId));
            unit.appendChild(iq.buildNode('update_time'));
            organization.appendChild(unit);
            query.appendChild(organization);
            connWin.con.send(iq, handleAccountDepts, accountId);
    	}
    }
}
var catchDeptList = null;
function getDeptByIdForA8 (jsonStr, accountId) {
	catchDeptList = new ArrayList();
	var allDeptList = new ArrayList();
	var json = null;
    try {
		eval("json = " + jsonStr);
	} catch (e) {
	}
    var deptsJson = json["U"];
    if (deptsJson.length <= 0) {
    	return ;
    }
    for (i = 0 ; i < deptsJson.length ; i ++) {
    	allDeptList.add(deptsJson[i]);
    }
    if (allDeptList.size() <= 1000) { 
    	var tempList = allDeptList;
    } else { 
    	var tempList = allDeptList.subList(0,1000);
    	catchDeptList = allDeptList.subList(1000,allDeptList.size());
    }
    queryDeptInfo(tempList,accountId);
}

function queryDeptInfo (deptList,accountId) { 
    iq = connWin.newJSJaCIQ();
    iq.setIQ(null, 'get');
    var query = iq.setQuery('jabber:iq:seeyon:office-auto');
    query.appendChild(iq.buildNode('client_version', '', '1.2'));
    var organization = iq.buildNode('organization', {'xmlns': 'organization:unit:info:query'});
    var unit = iq.buildNode('unit', {'dataType': 'list'});
    var ids = "";
    for (i = 0 ; i < deptList.size() ; i ++) {
    	var onlineJson = deptList.get(i);
        var id = onlineJson['I'];
        ids += id+",";
    }
    if (ids != "" && ids.length > 0) { 
    	ids = ids.substring(0,ids.length -1);
    }
	unit.appendChild(iq.buildNode('id', '', ids));
	organization.appendChild(unit);
    query.appendChild(organization);
    connWin.con.send(iq, handleAccountDeptsByA8, accountId);
}

function handleAccountDeptsByA8 (iq, accountId) {
	initOrgDepts(iq.getNode().getElementsByTagName('units'), accountId);
	if (catchDeptList == null || catchDeptList.size() <= 0) { 
        initDeptsRelation(accountId);
        if (cacheType == 'uc') {
            getUCOnline(accountId);
        } else if (cacheType == 'selectPeople') {
        	changeAccount(accountId);
        }
	} else { 
		if (catchDeptList.size() <= 1000) { 
			var tempList = catchDeptList;
			catchDeptList = new ArrayList();
		} else { 
			var tempList = catchDeptList.subList(0,1000);
			catchDeptList = catchDeptList.subList(1000,catchDeptList.size());
		}
		queryDeptInfo(tempList,accountId);
	}
}

var deptPackageCount = 0;

/**
 * 解析单位下部门
 */
function handleAccountDepts(iq, accountId){
	deptPackageCount ++;
    var last = true;
    var units = iq.getNode().getElementsByTagName('units').item(0);
    if (units) {
        last = deptPackageCount == units.getAttribute("total");
        connWin.con._regIDs[iq.getID()].last = last;
    }
    
    initOrgDepts(iq.getNode().getElementsByTagName('units'), accountId);
    
    if (last) {
    	deptPackageCount = 0;
        initDeptsRelation(accountId);
        if (cacheType == 'uc') {
            getUCOnline(accountId);
        } else if (cacheType == 'selectPeople') {
        	changeAccount(accountId);
        }
    }
}

var catchDeptList = null;
/**
 * 获取所有部门在线人数
 *
 * @param accountId 获取单位
 * @return
 */
function getUCOnline(accountId){
	var depts = new ArrayList();
	depts = dataCenter.get(accountId).get(Constants_Department);
	if (depts.size() > 500) { 
		var itemList = depts.subList(0,500);
		catchDeptList = depts.subList(500,depts.size());
		packageUcOnline(itemList,accountId);
	} else { 
    	catchDeptList = new ArrayList();
    	var iq = connWin.newJSJaCIQ();
        iq.setIQ(null, 'get');
        var query = iq.setQuery('jabber:iq:seeyon:office-auto');
        var organization = iq.buildNode('organization', {'xmlns': 'organization:staff:num:query'});
        var staffnums = iq.buildNode('staffnums', {'dataType': 'json'});
    	for (var i = 0; i < depts.size(); i++) {
            staffnums.appendChild(iq.buildNode('id', '', depts.get(i).id));
        }
        staffnums.appendChild(iq.buildNode('id', '', accountId));
        organization.appendChild(staffnums);
        query.appendChild(organization);
        connWin.con.send(iq, showUCOnline, accountId);
	}
}

function packageUcOnline (dataList,accountId) {
	var iq = connWin.newJSJaCIQ();
    iq.setIQ(null, 'get');
    var query = iq.setQuery('jabber:iq:seeyon:office-auto');
    var organization = iq.buildNode('organization', {'xmlns': 'organization:staff:num:query'});
    var staffnums = iq.buildNode('staffnums', {'dataType': 'json'});
	for (var i = 0; i < dataList.size(); i++) {
        staffnums.appendChild(iq.buildNode('id', '', dataList.get(i).id));
    }
    staffnums.appendChild(iq.buildNode('id', '', accountId));
    organization.appendChild(staffnums);
    query.appendChild(organization);
    connWin.con.send(iq, showUCOnline, accountId);
}

/**
 * 解析所有部门在线人数
 */
function showUCOnline(iq, accountId){
    var items = iq.getNode().getElementsByTagName('staffnums');
    
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
            var onlinesJson = json["N"];
            for (var i = 0; i < onlinesJson.length; i++) {
            	var onlineJson = onlinesJson[i];
            	
                var id = onlineJson['I'];
                var online = onlineJson['O'];
                var total = onlineJson['T'];
                
                var data = dataCenterMap[accountId][Constants_Department][id];
                
                if (data) {
                    data.online = online;
                    data.showname = data.name + "(" + online + "/" + total + ")";
                } else if (_AccountMap.get(id)) {
                    _AccountMap.get(id).online = online;
                    _AccountMap.get(id).showname = _AccountMap.get(id).name + "(" + online + "/" + total + ")";
                }
            }
        } catch (e) {}
    }
    if (catchDeptList == null || catchDeptList.size() <= 0) {
    	changeAccount(accountId);
    } else {
    	var itemList = new ArrayList();
    	if (catchDeptList.size() < 500) {
    		itemList = catchDeptList.subList(0,catchDeptList.size());
    		catchDeptList = new ArrayList();
    	} else {
    		itemList = catchDeptList.subList(0,500);
    		catchDeptList = catchDeptList.subList(500,catchDeptList.size());
    	}
    	packageUcOnline(itemList,accountId);
    }
}

/**
 * 切换单位
 */
function changeAccount(accountId){
    var rootNode = _AccountMap.get(accountId);
    if (isGroupVer == "true") {
    	$("#currentAccountId").val(rootNode.name);
    	$("#currentAccountId").attr('title', rootNode.name);
    	$("#currentAccountId").width($('#select_input_div').width() - 18);
    }
    
    _CurrentAccountLevelScope = _AccountMap.get(_CurrentAccountId).levelScope;
    if (_CurrentLevelId != "-1") {
        _CurrentUserLevelSortId = dataCenterMap[_CurrentAccountId][Constants_Level][_CurrentLevelId].level;
    }
    
    if (cacheType == 'uc') {
        _CurrentSelectAccountId = accountId;
    } else if (cacheType == 'selectPeople') {
        curSelectAccountId = accountId;
        getTabContent(null, true);
        return;
    }
    
    var deptSetting = {
        data: {
            key: {
                name: "showname",
                title: "showname"
            }, simpleData: {
                enable: true,
                idKey: "id",
                pIdKey: "parentId",
                rootPId: null
            }
        }, callback: {
            onClick: onDeptTreeClick
        }
    };
    
    var _childDepts = getChildDepartments(rootNode, accountId);
    _childDepts[_childDepts.length] = rootNode;
    var deptNodes = JSON.stringify(_childDepts);
    $.fn.zTree.init($("#deptList"), deptSetting, eval(deptNodes));
    var deptObj = $.fn.zTree.getZTreeObj("deptList");
    var selectDeptNode = deptObj.getNodeByParam("id", _CurrentDeptId, null);
    if (accountId != _CurrentAccountId) {
        selectDeptNode = deptObj.getNodes()[0];
    }
    deptObj.selectNode(selectDeptNode);
    getMembersByDeptId(selectDeptNode.id,selectDeptNode.type);
}

/**
 * 部门树节点点击事件
 */
function onDeptTreeClick(e, treeId, treeNode){
	getA8Top().startProc();
    getMembersByDeptId(treeNode.id,treeNode.type);
}

/**
 * 获取部门下人员
 */
function getMembersByDeptId(deptId,selectType){
	Org_AllMembers = new ArrayList();
	onlineN = 0;
	totalN = 0;
    //当前选中部门
	//修改从A8获取能看到的人员,通过Ajax请求
	Org_SelectDeptId = deptId;
	if (isFromA8) {
		var datas = {
		    'type':selectType,
			'accountId':deptId
		}
		$.ajax({
		    type: "POST" , 
		    data: datas,
		    url : connWin._ctpPath+"/uc/chat.do?method=getAllAccounts",
		    timeout : 10000,
		    dataType:"html",
		    success : function (jessn){
		    	getMsByDeptIdForA8(jessn, deptId);
		    }
		});
	} else {
	    var iq = connWin.newJSJaCIQ();
	    iq.setIQ(null, 'get');
	    var query = iq.setQuery('jabber:iq:seeyon:office-auto');
	    query.appendChild(iq.buildNode('client_version', '', '1.2'));
	    var organization = iq.buildNode('organization', {'xmlns': 'organization:staff:query'});
	    var staff = iq.buildNode('staff', {'dataType': 'json'});
	    staff.appendChild(iq.buildNode('department_id', '', deptId));
	    staff.appendChild(iq.buildNode('update_time'));
	    organization.appendChild(staff);
	    query.appendChild(organization);
	    connWin.con.send(iq, getMSByDeptId,deptId);
	}
	

}
/**
 * 做人员拆包发送用
 */
var catchMemberList = null;

function getMsByDeptIdForA8 (jsonStr,deptId) {
	var allMemberList = new ArrayList();
	var json = null;
    try {
		eval("json = " + jsonStr);
	} catch (e) {
	}
	var membersJson = json['M'];
	for (var i = 0 ; i < membersJson.length ; i ++) {
		var memberId = membersJson[i]["M"];
		allMemberList.add(memberId);
	}
	if (allMemberList.size() > 1000) {
		var itemList = allMemberList.subList(0,1000);
		catchMemberList = allMemberList.subList(1000,allMemberList.size());
		getMemberInfoForA8(itemList,deptId);
	} else {
		catchMemberList = new ArrayList();
		getMemberInfoForA8(allMemberList,deptId);
	}
}

function getMemberInfoForA8(memberList,deptId) {
	var iq = connWin.newJSJaCIQ();
	iq.setIQ(null, 'get');
	var query = iq.setQuery('jabber:iq:seeyon:office-auto');
	query.appendChild(iq.buildNode('client_version', '', '1.2'));
	var organization = iq.buildNode('organization', {'xmlns': 'organization:memberid:info:query'});
	var staff = iq.buildNode('staff', {'dataType': 'json'});
	var memberIdStr = "";
	for (i = 0; i < memberList.size() ; i ++) {
		var memberId = memberList.get(i);
		memberIdStr += memberId+"|" + deptId + ",";
	}
	if (memberIdStr.length > 0) { 
		memberIdStr.substring(0,memberIdStr.length -1);
	}
	staff.appendChild(iq.buildNode('member', memberIdStr ));
	organization.appendChild(staff);
	query.appendChild(organization);
	connWin.con.send(iq, getMSByDeptId,deptId);
}

/**
 * 解析部门下人员
 */
function getMSByDeptId(iq,deptId){
    var items = iq.getNode().getElementsByTagName('staffs');
    if (items && items.length > 0) {
    	var temp = new Properties();
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
                if (!temp.containsKey(jid)) {
                	temp.put(jid, true);
                	
                	var member = new OrgMemberSimple();
                	member.unitid = _CurrentSelectAccountId;
					member.deptid = Org_SelectDeptId;
					member.orgDeptid = memberJson['D'];
					member.levelid = memberJson['L'];
					member.jid = jid;
					if (!checkLevelScope(member)) {
						continue;
					}
                	
                	member.name = memberJson['N'];
                	member.sortid = parseInt(memberJson['S']);
                	member.online = memberJson['O'];
                	
                	if (member.online != '0') {
                		onlineN++;
                	}
                	totalN++;
                	
                	Org_AllMembers.add(member);
                }
            }
        } catch (e) {}
    }
    
    if (catchMemberList == null || catchMemberList.size() <= 0) {
    	updateDeptTree();
    } else {
    	var itemList = new ArrayList();
    	if (catchMemberList.size() < 1000) {
    		itemList = catchMemberList.subList(0,catchMemberList.size());
    		catchMemberList = new ArrayList();
    	} else {
    		itemList = catchMemberList.subList(0,1000);
    		catchMemberList = catchMemberList.subList(1000,catchMemberList.size());
    	}
    	getMemberInfoForA8(itemList,deptId);
    }
}

function updateDeptTree () {
	var isShowSendMessButt = departmentsCache.get(Org_SelectDeptId);
    if (isShowSendMessButt != null && isShowSendMessButt) {
        var html = "<a onclick='sendDepartmemntMessage(\"" + Org_SelectDeptId + "\")'><span class='ico16 common_language_16 margin_r_5'></span><span>" + $.i18n('uc.tab.sendMessageDept.js') + "</span></a>";
        $('#sendMessageBydept').html(html);
        $('#sendMessageBydept').show();
    } else {
        $('#sendMessageBydept').empty();
        $('#sendMessageBydept').hide();
    }
    
    //更新人数
    try {
        dataCenterMap[_CurrentSelectAccountId][Constants_Department][Org_SelectDeptId].online = onlineN;
        dataCenterMap[_CurrentSelectAccountId][Constants_Department][Org_SelectDeptId].total = totalN;
        dataCenterMap[_CurrentSelectAccountId][Constants_Department][Org_SelectDeptId].showname = dataCenterMap[_CurrentSelectAccountId][Constants_Department][Org_SelectDeptId].name + "(" + onlineN + "/" + totalN + ")";
        $("#online_num").text(onlineN);
        $("#total_num").text(totalN);
        var treeObj = $.fn.zTree.getZTreeObj("deptList");
        var nodes = treeObj.getSelectedNodes();
        if (nodes.length > 0) {
            nodes[0].showname = dataCenterMap[_CurrentSelectAccountId][Constants_Department][Org_SelectDeptId].showname;
            treeObj.updateNode(nodes[0]);
        }
    } catch (e) {
        try {
            _AccountMap.get(Org_SelectDeptId).online = onlineN;
            _AccountMap.get(Org_SelectDeptId).total = totalN;
            _AccountMap.get(Org_SelectDeptId).showname = _AccountMap.get(Org_SelectDeptId).name + "(" + onlineN + "/" + totalN + ")";
            $("#online_num").text(onlineN);
            $("#total_num").text(totalN);
            var treeObj = $.fn.zTree.getZTreeObj("deptList");
            var nodes = treeObj.getSelectedNodes();
            if (nodes.length > 0) {
                nodes[0].showname = _AccountMap.get(Org_SelectDeptId).showname;
                treeObj.updateNode(nodes[0]);
            }
        } catch (e) {}
    }
    
    cacheOrgSearchMembers('');
}

/**
 * 显示离线人员
 */
var isShowOrgOffLine = false;
function showOrgOffLine(){
	if ($('#queryOrgMember')[0].className.indexOf('color_gray') < 0){
		$('#queryOrgMember').addClass('color_gray');
		$('#queryOrgMember').val($.i18n('uc.staff.name.js'));
	}
	getA8Top().startProc();
    var showOrgOffLine = $('#showOrgOffLine')[0].checked;
    if (showOrgOffLine) {
        $('#CheckboxRelate')[0].checked = 'checked';
        $('#CheckboxGroup')[0].checked = 'checked';
        isShowOrgOffLine = true;
        isreOnline = true;
        isGroupOnline = true;
    } else {
        $('#CheckboxRelate')[0].checked = '';
        $('#CheckboxGroup')[0].checked = '';
        isShowOrgOffLine = false;
        isreOnline = false;
        isGroupOnline = false;
    }
    
    cacheOrgSearchMembers('');
}

/**
 * 查询人员
 */
function queryOrgMembers(){
	getA8Top().startProc();
    var inputValue = $.trim($('#queryOrgMember').val());
    if (($('#queryOrgMember').hasClass('color_gray') && inputValue == $.i18n('uc.staff.name.js')) || inputValue == '') {
        cacheOrgSearchMembers('');
    } else {
        cacheOrgSearchMembers(inputValue);
    }
}

/**
 * 缓存人员
 */
function cacheOrgSearchMembers(name){
    Org_SearchMembers = new ArrayList();
    
    //显示在线人数|显示全部人员|显示查询人员
    for (var i = 0; i < Org_AllMembers.size(); i++) {
        var member = Org_AllMembers.get(i);
        
        if (!isShowOrgOffLine && member.online == '0') {
            continue;
        }
        
        if (name == '' || member.name.indexOf(name) >= 0) {
            Org_SearchMembers.add(member);
        }
    }
    
    QuickSortArrayList(Org_SearchMembers, "sortid");
    
    orgTotalSize = Org_SearchMembers.size();
    orgTotalPage = parseInt((orgTotalSize + orgPageSize - 1) / orgPageSize);
    if (orgTotalPage == 0) {
        orgTotalPage = 1;
    }
    orgCurrentPage = 1;
    pageOrgSearchMembers();
}

/**
 * 上一页响应
 */
function orgPrevPage(){
    if (orgCurrentPage == 1) {
        return;
    }
    getA8Top().startProc();
    orgCurrentPage = orgCurrentPage - 1;
    pageOrgSearchMembers();
}

/**
 * 下一页响应
 */
function orgNextPage(){
    if (orgCurrentPage == orgTotalPage) {
        return;
    }
    getA8Top().startProc();
    orgCurrentPage = orgCurrentPage + 1;
    pageOrgSearchMembers();
}

/**
 * 人员分页
 */
function pageOrgSearchMembers(){
    $('#Org_currentPage').text(orgCurrentPage);
    $('#Org_totalPage').text(orgTotalPage);
    
    orgStart = (orgCurrentPage - 1) * orgPageSize;
    orgEnd = orgStart + orgPageSize;
    if (orgEnd > orgTotalSize) {
        orgEnd = orgTotalSize;
    }
    
    getMByDeptId();
}

/**
 * 获取人员详细信息
 */
function getMByDeptId(){
    var deptId = Org_SelectDeptId;
    var account = _AccountMap.get(Org_SelectDeptId);
    
    var members = Org_SearchMembers.subList(orgStart, orgEnd);
    var iq = connWin.newJSJaCIQ();
    iq.setIQ(null, 'get');
    var query = iq.setQuery('jabber:iq:seeyon:office-auto');
    var organization = iq.buildNode('organization', {'xmlns': 'organization:staff:info:query'});
    var staff = iq.buildNode('staff', {'dataType': 'json'});
    for (var i = 0; i < members.size(); i++) {
        staff.appendChild(iq.buildNode('jid', {'accid': _CurrentSelectAccountId, 'deptid': deptId}, members.get(i).jid));
    }
    organization.appendChild(staff);
    query.appendChild(organization);
    connWin.con.send(iq, membersToHTML);
}

/**
 * 生成列表
 */
function membersToHTML(iq){
    var membersHtml = "";
    var trCount = 0;
    var members = initOrgMembers(iq.getNode().getElementsByTagName('staff'));
    if (!members.isEmpty()) {
    	//QuickSortArrayList(members, "sortid"); 按游洪波说，这个地方收到的members已经是排过序的 先去掉
        for (var i = 0; i < members.size(); i++) {
            try {
                var member = members.get(i);
                var mood = member.mood.escapeHTML();
                membersHtml += "<tr height='50'>";
                membersHtml += "<td width='108'><div class='ucFaceImage'>";
                
      			var status = "ico16 online" + member.online;
                if (isShowOrgOffLine) {
                    status = member.online == 0 ? "" : "ico16 online" + member.online;
                }
                
                var isSelf = cutResource(_CurrentUser_jid) == member.jid;
                var onlineid = isSelf == true ? 'myselfstatus' : 'otherstatus';
                membersHtml += "<span class='onlineState_box'><span id='" + onlineid + "' class='onlineState " + status + "'></span></span>";                
                var photo = member.photo;
                if (isSelf) {
                	photo = _CurrentUser.photo;
                }
                membersHtml += "<img id='" + member.memberid + "Img' jid='" + member.jid + "' class='img' src='" + photo + "' width='48' height='48' onmouseover='showPeopleCard(this, false)' onmouseout=\'showPeopleCard_type=false;\'>";
                if (!isSelf) {
                    membersHtml += "<span class='name text_overflow hand' title='" + member.name + "' onclick='connWin.openWinIM(\"" + member.name + "\", \"" + member.jid + "\")'>" + member.name + "</span>";
                } else {
                    membersHtml += "<span class='name text_overflow hand' title='" + _CurrentUser.name + "'>" + _CurrentUser.name + "</span>";
                }
                membersHtml += "</div></td>";
                
                membersHtml += "<td width='92'><div class='w100 text_overflow' title='" + member.deptname + "'>" + member.deptname + "</div></td>";
                membersHtml += "<td width='92'><div class='w100 text_overflow' title='" + member.postname + "'>" + member.postname + "</div></td>";
                membersHtml += "<td><div style='width:205px;' class='moodCss text_overflow' title ='" + mood + "'>&nbsp;" + mood + "</div></td>";
                membersHtml += "</tr>";
                trCount += 1;
            } catch (e) {}
        }
    }
    
    for (var j = 0; j < 10 - trCount; j++) {
        membersHtml += "<tr height='62'><td width='120'>&nbsp;</td><td width='100'>&nbsp;</td><td width='100'>&nbsp;</td><td>&nbsp;</td></tr>";
    }
    
    $("#memberList").html(membersHtml);
    $('#deptTree').height(680 - 5);
    if (!isGroupVer) {
    	 $('#deptList').height(680 - 5);
    } else {
    	 var height = 680 - 36;
    	 $('#deptList').height(height);
    }
    
    resizeMoodWidth();
    getA8Top().endProc();
}

function resizeMoodWidth() {
	$(".moodCss").hide();
    $(".moodCss").width($(".moodCss").parent().width());
    $(".moodCss").show();
}
