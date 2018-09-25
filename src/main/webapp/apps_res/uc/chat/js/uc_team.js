/****************************************群组****************************************/
/**获取全部群组信息**/
var groupMap = new Properties();
var groupMapByCurrent = new Properties();
var treeList = new Array();
var grouptype;
var group;
var groupNice = '';
var groupids = '';
var groupNames = '';
var groupMemberList;
var groupMemberInfo;
var groupNewMemberInfo;
var groupAllMemberInfo;
var isGroupOnline = false;
var onlineNum;
var groupId = '';
var groupnamebyupdate ='';
var memberJid = '';
var groupclick = true;
var current = 1;
var total = 1;
var teamPackageCount = 0;
function showGroup(iq){
	teamPackageCount ++;
	treeList = new Array();
	isFlush = false;
	isHistoryFlush = false;
	initTreeRoot();
    var last = true;
    var groups = iq.getNode().getElementsByTagName('groups').item(0);
    if (groups) {
        last = teamPackageCount == groups.getAttribute("total");
        total = groups.getAttribute("total");
        current = groups.getAttribute("current");
        connWin.con._regIDs[iq.getID()].last = last;
    }
    var groupInfo = iq.getNode().getElementsByTagName('group_info');
    groupMapByCurrent.put(current,groupInfo);
    
    if (last) {
    	teamPackageCount = 0;
    	groupListInit();
    }
}
 
function groupListInit (){
	groupMap = new Properties();
	for(var k = 1 ; k <=  total ; k++){
		var groupInfo = groupMapByCurrent.get(k);
		for (var i = 0; i < groupInfo.length; i++) {
	        var message = groupInfo[i].getElementsByTagName('message');
	        var time = '';
	        var name = '';
	        var body = '';
	        var onbody = '';
	        if (message.length > 0) {
	            name = "<font class='color_gray'>"+message[0].getElementsByTagName('name')[0].firstChild.data + "</font>&nbsp;&nbsp;";
	            var bodys = message[0].getElementsByTagName('body');
	            time = message[0].getAttribute('timestamp');
	            var type = message[0].getAttribute('type');
	            if (type == 'microtalk') {
	                body = '发送了语音';
	                onbody = body;
	            }
	            else 
	                if (type == 'filetrans') {
	                	var messbody = '';
	                	var onmessbody ='';
	                    var files = message[0].getElementsByTagName('filetrans');
	                    var fnames = '';
	                    for (var x = 0; x < files.length; x++) {
	                        if (x >= 2) {
	                            break;
	                        }
	                        var fname = files[x].getElementsByTagName('name')[0].firstChild.data;
	                        if (fname.length > 10) {
	                            fname = fname.getLimitLength(10,'...');
	                        }
	                        fnames += fname + ",";
	                    }
	                    var moreHtml = "等" + files.length + "个文件";
	                    if (files.length <= 2) {
	                        moreHtml = '';
	                    }
	                    try{
	                    	messbody = message[0].getElementsByTagName('body')[0].firstChild.data.escapeHTML();
	                    	onmessbody = messbody;
	                    	
                            var bodys = messbody;
                            var len = 0;
                            var bodyStr = '';
                            while(true) {
                                if (bodys.indexOf('<br/>') < 0){
                                    break;
                                } else {
                                    if (len < 1) {
                                        bodyStr = bodyStr + bodys.substr(0,bodys.indexOf('<br/>')+5);
                                    }
                                        bodys = bodys.substr(bodys.indexOf('<br/>') + 5 ,bodys.length);
                                        len ++;
                                }
                            }
                            if (len >= 1) {
                                    messbody = bodyStr;
                                    if (messbody.indexOf('<br/>') == messbody.length -5){
                                        messbody = messbody.substr(0,messbody.length -5);
                                    }
                            }
                            
	                    	for (var j = 0; j < face_texts_replace.length; j++) {
	                    		messbody = messbody.replace(face_texts_replace[j], "<img src='" + v3x.baseURL + "/apps_res/uc/chat/image/face/5_" + (j + 1) + ".gif' />");
	                        }
	                    }catch(e){
	                    	messbody = '';
	                    	onmessbody = '';
	                    }
	                    if(messbody != ''){
	                    	body = messbody +'<br/>发送了文件:' + fnames.substr(0, fnames.length - 1) + moreHtml;
	                    	onbody = onmessbody +'发送了文件:' + fnames.substr(0, fnames.length - 1) + moreHtml;
	                    }else{
	                    	body = messbody +'发送了文件:' + fnames.substr(0, fnames.length - 1) + moreHtml;
	                    	onbody = onmessbody +'发送了文件:' + fnames.substr(0, fnames.length - 1) + moreHtml;
	                    }
	                    
	                }
	                else {
	                    if (bodys.length > 0) {
	                        if (bodys[0].firstChild != null) {
	                            body = bodys[0].firstChild.data.escapeHTML();
	                            onbody = body.escapeHTML();
	                            
                                var bodys = body;
                                var len = 0;
                                var bodyStr = '';
                                while(true) {
                                    if (bodys.indexOf('<br/>') < 0){
                                        break;
                                    } else {
                                        if (len < 2) {
                                            bodyStr = bodyStr + bodys.substr(0,bodys.indexOf('<br/>')+5);
                                        }
                                        bodys = bodys.substr(bodys.indexOf('<br/>') + 5 ,bodys.length);
                                        len ++;
                                    }
                                }
                                if (len >= 2) {
                                    body = bodyStr;
                                }
                                
	                            if(body.length > 40){
	                            	var unbody = '';
	                            	body = body.getLimitLength(40,'');
	                            	unbody = body.split("").reverse().join("");
	                            	if(unbody.indexOf('[') < 3){
	                            		body = body.substr(0,body.length-body.indexOf('['));
	                            	}
	                            	body = body +"...";
	                            }
	                            
	                            for (var j = 0; j < face_texts_replace.length; j++) {
	                                body = body.replace(face_texts_replace[j], "<img src='" + v3x.baseURL + "/apps_res/uc/chat/image/face/5_" + (j + 1) + ".gif' code='"+face_texts_replace[j].toString().substr(2,face_texts_replace[j].toString().length -6)+"]'/>");
	                            }
	                        }
	                    }
	                }
	        }
	        var groupMess = groupInfo[i];
	        var groupName = groupMess.getAttribute('NA');
	        groupName = groupName.replace(new RegExp('&nbsp;', 'g'), ' ').escapeHTML();
	        var groupId = groupMess.getAttribute('I');
	        var groupType = groupMess.getAttribute('T');
	        var creatTime = groupMess.getAttribute('C');
	        var updateTime = groupMess.getAttribute('U');
	        var memberCount = groupMess.getAttribute('M');
	        var groupnice = groupMess.getAttribute('NI');
	        var onlinMember = groupMess.getAttribute('OM');
	        var showname = groupName + '(' + onlinMember+"/"+memberCount + ')';
	        connWin.roster.groupMemberCountCache.put(groupId,memberCount);
	        if (groupType == '4') {
	        	connWin.roster.groupNickCache.put(groupId,groupnice);
	        }
	        var items = {
	            id: groupId,
	            showname: showname,
	            parentId: groupType,
	            shortname: groupName,
	            membercount: memberCount,
	            onlinecount : onlinMember,
	            createTime: updateTime,
	            updateTime: updateTime,
	            groupnice: groupnice,
	            name: name,
	            body: body,
	            time: time,
	            onbody:onbody
	        };
	        treeList[treeList.length] = items;
	        var groupArray = groupMap.get(groupType);
	        try {
	        	var o = groupArray.length;
	        	groupArray[o] = items;
	        	groupMap.put(groupType, groupArray);
	        } 
	        catch (e) {
	        	groupArray = new Array();
	        	groupArray[0] = items;
	        	groupMap.put(groupType, groupArray);
	        }
	    }
	}
	initTreeRoot();
    initTree();
}
/******初始化树*******/
function initTree(){
    $("#group").empty();
    var groupString = {
        data: {
            key: {
                name: "showname",
                title : "shortname"
            },
            simpleData: {
                enable: true,
                idKey: "id",
                pIdKey: "parentId",
                rootPId: null
            }
        },
        callback: {
            onClick: showGroupList
        }
    };
    group = groupMap.get(4);
    try {
        group.length;
    } 
    catch (e) {
        group = new Array();
    }
    grouptype = 4;
    checkGroup();
    var newTreeList = new Array();
    var o = 0; 
    
    for (var k = 0 ; k < treeList.length ; k ++) {
    	var treeTeam = treeList[k];
    	if(treeTeam.parentId != 6){
    		newTreeList[o] = treeTeam;
    		o++;
    	}
    }
    treeList = newTreeList;
    $.fn.zTree.init($("#group"), groupString, eval(treeList));
    var accountObj = $.fn.zTree.getZTreeObj("group");
    var selectAccountNode = accountObj.getNodeByParam("id", 4, null);
    accountObj.selectNode(selectAccountNode);
    groupclick = true;
}

/**树的根节点**/
function initTreeRoot(){
    var xtcount = 0;
    var xmcount = 0;
    var xitcount = 0;
    var lscount = 0;
    if (groupMap.get(2)) {
        xtcount = groupMap.get(2).length;
    }
    if (groupMap.get(3)) {
        xmcount = groupMap.get(3).length;
    }
    if (groupMap.get(4)) {
        lscount = groupMap.get(4).length;
    }
    if (groupMap.get(5)) {
        xitcount = groupMap.get(5).length;
    }
    var item1 = {
        id: '011',
        showname: $.i18n('uc.group.all.js'),
        parentId: '',
        shortname: '',
        membercount: '',
        createTime: '',
        updateTime: '',
        open: true
    };
    var item5 = {
            id: '4',
            showname: $.i18n('uc.group.msg.js')+'(' + lscount + ')',
            parentId: '011',
            shortname: '',
            membercount: '',
            createTime: '',
            updateTime: '',
            open: true
    };
    treeList[0] = item1;
    treeList[1] = item5;
    //youhb V5.6去掉项目组和系统组
//    var item2 = {
//        id: '2',
//        showname: $.i18n('uc.group.system.js')+'(' + xtcount + ')',
//        parentId: '011',
//        shortname: '',
//        membercount: '',
//        createTime: '',
//        updateTime: ''
//    };
//    if (projectNoShow == 'false') { //uc是否显示项目
//    	var item3 = {
//    	        id: '3',
//    	        showname: $.i18n('uc.group.project.js')+'(' + xmcount + ')',
//    	        parentId: '011',
//    	        shortname: '',
//    	        membercount: '',
//    	        createTime: '',
//    	        updateTime: ''
//    	    };
//    }
//youhb V5.6去掉项目组和系统组
//    treeList[1] = item2;
//    if (projectNoShow == 'false') { //uc是否显示项目
//    	treeList[2] = item3;
//    	treeList[3] = item5;
//    } else {
//    	
//    }
    
}

/**选择树节点的**/
function showGroupList(e, treeId, treeNode) {
	if (treeNode.id == '011') {

	} else if (treeNode.id == '2' || treeNode.id == '3' || treeNode.id == '4') {
		$('#sendMessageByTeam').hide();
		group = groupMap.get(treeNode.id);
		grouptype = treeNode.id;
		checkGroup();
		$('#addClick').hide();
		$('#addper').hide();
	} else {
		if (connWin.roster.DisabledChatUser.get(treeNode.id)) {
			groupMapByCurrent = new Properties();
			$.alert($.i18n('uc.group.notinfo.js'));
			$(".uc_tree_list").show();
			var iq = parent.window.opener.newJSJaCIQ();
			var uid = _CurrentUser_jid;
			iq.setFrom(uid);
			iq.setIQ('group.localhost', 'get');
			var query = iq.setQuery('seeyon:group:query:info');
			connWin.con.send(iq, showGroup);
		} else {
			getA8Top().startProc();
			groupNice = treeNode.groupnice;
			groupids = treeNode.id;
			groupNames = treeNode.shortname;
			requestGroupMember(treeNode.id);
			$('#addClick').hide();
			$('#addper').hide();
		}
	}
}

function checkGroup(){
    try {
        group.length;
    } 
    catch (e) {
        group = new Array();
    }
    var tPage = 0;
    if (group.length % 10 == 0) {
        tPage = parseInt(group.length / 10);
    }
    else {
        tPage = parseInt(group.length / 10 + 1);
    }
    totalPage = tPage;
    currentPage = 1;
    initPageMessage(currentPage);
}

function initPageMessage(thiPage){
    currentPage = thiPage;
    var startNums = (thiPage - 1) * 10;
    var endNums = startNums + 10;
    if (endNums > group.length) {
        endNums = group.length;
    }
    if (group.length % 10 == 0) {
    	totalPage = parseInt(group.length / 10);
    }
    else {
    	totalPage = parseInt(group.length / 10 + 1);
    }
    initGroupList(group.slice(startNums, endNums));
}

function initGroupList(groupListMessage){
    $('#quertMember').hide();
    $('#addClick').hide();
    $('#addMember').hide();
    $('#query').show();
    $('#groupTitle').empty();
    var title = "";
    title += "<tr><th width='195'>"+$.i18n('uc.group.showname.js')+"</th><th width='285'>"+$.i18n('uc.group.lastMsg.js')+"</th><th width='70'>"+$.i18n('uc.group.operate.js')+"</th></tr>";
    $('#groupTitle').append(title);
    $('#grouplist').empty();
    var membersHtml = "";
    var trCount = 0;
    for (var i = 0; i < groupListMessage.length; i++) {
        var groupName = groupListMessage[i].shortname;
        groupName = groupName.escapeHTML();
        var groupId = groupListMessage[i].id;
        var nice = groupListMessage[i].groupnice;
        var name = groupListMessage[i].name;
        var body = groupListMessage[i].body;
        var time = groupListMessage[i].time;
        var onbody = groupListMessage[i].onbody;
        if(time != ''){
        	time = hrTime(time)+":";
        }
        var flag = false;
        if (_CurrentUser_jid.indexOf(nice) >= 0) {
            flag = true;
        }
        membersHtml += "<tr>";
        membersHtml += "<td class='dotted'><div class='ucFaceImage' style='padding:0px;'>";
        membersHtml += "<img id='groupImg' class='img' src='" + defaultTeamPhoto + "' height='42' alt='" + groupName + "'>";
        membersHtml += "<span class='teamName text_overflow'><a  onclick='openWinIMflag(\"" + groupName + "\", \"" + groupId + "\")' title='" + groupName + "'>" + groupName + "</a></span>";
        membersHtml += "</div></td>";
        membersHtml += "<td class = 'dotted'>" + name +"<span class='color_gray'>"+time+"</span><br/><div title='"+onbody+"' style='width: 295px;' class='text_overflow'> "+ body +" </div></td>";
        if (grouptype != '4') {
            membersHtml += " <td class = 'dotted'><a href='javaScript:void(0)'title='"+$.i18n('uc.group.member.js')+"' onclick='requestGroupMemberByspan(\"" + groupId + "\",\"" + groupName + "\")'><em class='ico16 staff_16'></em></a></td>";
        }
        else {
            if (flag) {
                membersHtml += "<td class = 'dotted'><a href='javaScript:void(0)' onclick='javascript:deleteGroup(\"" + groupId + "\")' title='"+$.i18n('uc.group.disband.js')+"'><em class='ico16 affix_del_16'></em></a>    <a href='javaScript:void(0)' id = 'updateGroup' title='"+$.i18n('uc.group.update.js')+"' onclick='javascript:reNameGroup(\"" + groupId + "\",\"" + groupName + "\")'> <em class='ico16 number_change_16'></em></a>  <a href='javaScript:void(0)' title='"+$.i18n('uc.group.member.js')+"' onclick='requestGroupMemberByspan(\"" + groupId + "\",\"" + groupName + "\")'><em class='ico16 staff_16'></em></a></td>";
            }
            else {
                membersHtml += "<td class = 'dotted'><a href='javaScript:void(0)' onclick='javascript:outGroup(\"" + groupId + "\")' title='"+$.i18n('uc.group.exit.js')+"'><em class='ico16 publicSquare_16'></em></a> <a href='javaScript:void(0)' title='"+$.i18n('uc.group.member.js')+"' onclick='requestGroupMemberByspan(\"" + groupId + "\",\"" + groupName + "\")'><em class='ico16 staff_16'></em></a></td>";
            }
        }
        trCount ++;
    }
    for (var j = 0; j < 10 - trCount; j++) {
    	membersHtml += "<tr height='60'><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>";
    }
    $('#grouplist').append(membersHtml);
    initPageNum(true);
    $('#teamTree').height($('#teamtable').height());
    var heigth = parseInt($('#teamtable').height()) - 10;
    $('#group').height(heigth);
    getA8Top().endProc();
}

/***组内分页****/
function initPageNum(flage){
    if (flage) {
        $('#pageList').empty();
    }
    else {
        $('#reList').empty();
    }
    var pagString = "";
    
    pagString += "<tr><td colspan='4' class='border_t_gray' align='right'>";
    pagString += "<div class='common_over_page padding_tb_10'>";
    var totalPages = totalPage;
    if (totalPages <= 0) {
        totalPages = 1;
    }
    if (flage) {
        if (currentPage > 1) {
            pagString += "<a href='#' class='common_over_page_btn' onclick='javaScript:initPageMessage(" + (currentPage - 1) + ")' title='"+$.i18n('uc.page.prev.js')+"'><em class='pagePrev'></em></a>";
        }else{
        	pagString += "<a class='common_over_page_btn' title='"+$.i18n('uc.page.prev.js')+"'><em class='pagePrev_disable'></em></a>";
        }
        pagString += "<span class='margin_l_10'>"+$.i18n('uc.page.current.js')+"</span>" + currentPage + "/" + totalPages + $.i18n('uc.page.total.js');
        if (currentPage < totalPage) {
        	pagString += "<a href='#' class='common_over_page_btn' onclick='javaScript:initPageMessage(" + (currentPage + 1) + ")' title='"+$.i18n('uc.page.next.js')+"'><em class='pageNext'></em></a>";
        }else{
        	pagString += "<a class='common_over_page_btn' title='"+$.i18n('uc.page.next.js')+"'><em class='pageNext_disable'></em></a>";
        }
    }
    else {
        if (currentPage > 1) {
            pagString += "<a href='#' class='common_over_page_btn' onclick='javaScript:initRMember(" + (currentPage - 1) + ")' title='"+$.i18n('uc.page.prev.js')+"'><em class='pagePrev'></em></a>";
        }else{
        	pagString += "<a class='common_over_page_btn' title='"+$.i18n('uc.page.prev.js')+"'><em class='pagePrev_disable'></em></a>";
        }
        pagString += "<span class='margin_l_10'>"+$.i18n('uc.page.current.js')+"</span>" + currentPage + "/" + totalPages + $.i18n('uc.page.total.js');
        if (currentPage < totalPage) {
           pagString += "<a href='#' class='common_over_page_btn' onclick='javaScript:initRMember(" + (currentPage + 1) + ")' title='"+$.i18n('uc.page.next.js')+"'><em class='pageNext'></em></a>";
        }else{
        	pagString += "<a class='common_over_page_btn' title='"+$.i18n('uc.page.next.js')+"'><em class='pageNext_disable'></em></a>";
        }
    }
    pagString += "</div> </td></tr>";
    if (flage) {
        $('#pageList').append(pagString);
    }
    else {
        $('#reList').append(pagString);
    }
}

/***请求组内人****/
function requestGroupMember(groupid){
	if (connWin.roster.DisabledChatUser.get(groupid)){
		groupMapByCurrent = new Properties();
		$.alert($.i18n('uc.group.notinfo.js'));
		 $(".uc_tree_list").show();
         var iq = parent.window.opener.newJSJaCIQ();
         var uid = _CurrentUser_jid;
         iq.setFrom(uid);
         iq.setIQ('group.localhost', 'get');
         var query = iq.setQuery('seeyon:group:query:info');
         connWin.con.send(iq, showGroup);
	}else{
		groupids = groupid;
	    iq = parent.window.opener.newJSJaCIQ();
	    iq.setFrom(_CurrentUser_jid);
	    iq.setIQ(groupid, 'get', 'group1');
	    var query = iq.setQuery('seeyon:group:query:member');
	    connWin.con.send(iq, initGroupMember);
	}
}

function initGroupMember(iq){
    groupMemberList = new Array();
    var members = iq.getNode().getElementsByTagName('jid');
    for (var i = 0; i < members.length; i++) {
        var memberid = members[i].getAttribute('J');
        groupMemberList[i] = memberid;
    }
    groupMemberInfos();
}

function initGroupMemberPage(thiPage){
    currentPage = thiPage;
    var startNums = (thiPage - 1) * 10;
    var endNums = startNums + 10;
    if (endNums > groupMemberInfo.length) {
        endNums = groupMemberInfo.length;
    }
    groupNewMemberInfo = groupMemberInfo.slice(startNums, endNums);
    showMemberList();
}

function groupMemberInfos(){
    var iq = parent.window.opener.newJSJaCIQ();
    var uid = _CurrentUser_jid;
    iq.setFrom(uid);
    iq.setIQ(uid, 'get', 'groupmemberinfo');
    var query = iq.setQuery('jabber:iq:seeyon:office-auto');
    var org = iq.buildNode('organization', {
        'xmlns': 'organization:staff:info:query'
    });
    var staff = iq.buildNode('staff',{'dataType': 'json'});
    for (var j = 0; j < groupMemberList.length; j++) {
        var jid = groupMemberList[j];
        var jidE = iq.buildNode('jid', jid);
        jidE.setAttribute('deptid', '');
        staff.appendChild(jidE);
    }
    org.appendChild(staff);
    query.appendChild(org);
    connWin.con.send(iq, showGroupMessMember);
}

function showGroupMessMember(iq){
	var membercount = groupMemberList.length;
    onlineNum = 0;
    groupMemberInfo = new Array();
    var items = iq.getNode().getElementsByTagName('staff');
    if (items && items.length > 0) {
    	try{
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
            var x = 0;
            for (var i = 0; i < membersJson.length; i++) {
            	var memberJson = membersJson[i];
                var jid = memberJson['J'];
                var memberId = memberJson['I'];
                var name = memberJson['N'];
                var dName = memberJson['DM'];
                var postName = memberJson['PM'];
                var online = memberJson['O'];
                var photo = memberJson['H'];
                var mood = memberJson['M'];
                if(memberId != '' && name !=''){
                	var groupMembers = {
                            id: jid,
                            name: name,
                            postname: postName,
                            dName: dName,
                            online: online,
                            photo: photo,
                            mood: mood,
                            memberId: memberId
                    };
                	if (!isGroupOnline) {
                        if (online != 0) {
                            onlineNum++;
                            groupMemberInfo[x] = groupMembers;
                            x++;
                        }
                        else {
                            continue;
                        }
                    }else {
                        if (online != 0) {
                            onlineNum++;
                        }
                        groupMemberInfo[x] = groupMembers;
                        x++;
                    }
                }else{
                	membercount --;
                }
            }
    	}catch(e){
    		
    	}
    }

    var accountObj = $.fn.zTree.getZTreeObj("group");
    var selectAccountNode = accountObj.getNodeByParam("id", groupids, null);
    accountObj.selectNode(selectAccountNode);
    selectAccountNode.showname = selectAccountNode.shortname+"("+onlineNum+"/"+membercount+")";
    accountObj.updateNode(selectAccountNode);
    
    $('#onlinN').empty();
    $('#onlinN').append("<font color='blue'>" + onlineNum + "</font>/" +membercount );
    QuickSortArrayByTeamMember(groupMemberInfo,"name");
    groupAllMemberInfo = groupMemberInfo;
    var tPage = 0;
    if (groupMemberInfo.length % 10 == 0) {
        tPage = parseInt(groupMemberInfo.length / 10);
    }
    else {
        tPage = parseInt(groupMemberInfo.length / 10 + 1);
    }
    
    var newGroupMemberInfo = new Array();
    for (var x = 0 ; x < groupMemberInfo.length ; x ++) {
    	var members = groupMemberInfo[x];
    	if (members.id == groupNice) {
    		newGroupMemberInfo[0] = members;
    	}
    }
    for (var y = 0 ; y < groupMemberInfo.length ; y ++) {
    	var members = groupMemberInfo[y];
    	if (members.id != groupNice) {
    		newGroupMemberInfo[newGroupMemberInfo.length] = members;
    	}
    }
    groupMemberInfo = newGroupMemberInfo;
    totalPage = tPage;
    currentPage = 1;
    initGroupMemberPage(currentPage);
}


function showMemberList(){
	$('#sendMessageByTeam').show();
    $('#query').hide();
    $('#quertMember').show();
    if (subResources(groupNice) == subResources(_CurrentUser_jid)) {
    }
    else {
        $('#addClick').hide();
        $('#addMember').hide();
    }
    $('#groupTitle').empty();
    var title = "<tr><th width='125'>"+$.i18n('uc.staff.name.js')+"</th><th width='90'>"+$.i18n('uc.staff.dept.js')+"</th><th width='100'>"+$.i18n('uc.staff.post.js')+"</th><th width='225'>"+$.i18n('uc.staff.mood.js')+"</th></tr>";
    $('#groupTitle').append(title);
    $('#grouplist').empty();
    var membersHtml = "";
    var trCount = 0;
    for (var i = 0; i < groupNewMemberInfo.length; i++) {
        var random = Math.floor(Math.random() * 100000000);
        var guser = groupNewMemberInfo[i];
        membersHtml += "<tr>";
        membersHtml += "<td><div class='ucFaceImage' style='padding:0px;'>";
        var status = "";
        if (guser.online != 0){
            status = "ico16 online" + guser.online;
        }
        membersHtml += "<span class='onlineState_box'><span class='onlineState " + status + "' style='cursor: default;'></span></span>";
        var flagName = '';
        var moodsublength = 30;
        if (subResources(groupNice) == subResources(guser.id)) {
            flagName = "<span class='margin_r_5 groupnick_king' title='" + $.i18n('uc.group.groupnick.js') + "'></span>";
        }
        membersHtml += "<img class='img' src='" + guser.photo + "' id ='" + random + "img' width='48' height='48' alt='' jid='" + guser.id + "' height='42' alt='' onmouseover='showPeopleCard(this, false)' onmouseout=\'showPeopleCard_type=false;\'>";
        if(guser.id == _CurrentUser_jid){
        //群成员名称如果太长，改成了按照样式截取
        	membersHtml += "<span class='name text_overflow' title='"+guser.name+"'>" + flagName + guser.name +"</span>" ;
        }else{
        	membersHtml += "<span class='name text_overflow' title='"+guser.name+"'>" + flagName + "<a onclick='parent.window.opener.openWinIM(\"" + guser.name + "\", \"" + guser.id + "\")'>" + guser.name +"</a></span>";
        }
        membersHtml += "</div></td>";
        membersHtml += "<td><div class='w100 text_overflow' title='" + guser.dName + "'>" + guser.dName + "</div></td>";
        membersHtml += "<td><div class='w100 text_overflow' title='" + guser.postname + "'>" + guser.postname + "</div></td>";
        var isSelf = cutResource(_CurrentUser_jid) == guser.id;
        var outMember = "";
        if (grouptype == '4') {
            if (subResources(groupNice) == subResources(_CurrentUser_jid)) {
           		moodsublength = 25;
                outMember = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id='del' class='hidden'><a href='javaScript:void(0)' onclick='javascript:exitPer(\"" + guser.name + "\", \"" + guser.id + "\")' title='"+$.i18n('uc.groupmemberexit.js')+"'><span class='ico16 hover_close_16 right margin_t_5'></span></a></span> ";
            }
        }
        var strs = '';
        if (guser.mood.length > 20) {
            strs = '...';
        }
        if (isSelf) {
        //如果群成员心情太长，而宽度小的话，会导致剔除成员按钮下移,顾少截取2个字
            membersHtml += "<td class='mytd'><span title='" + guser.mood.escapeHTML() + "'>" + guser.mood.escapeHTML().getLimitLength(moodsublength,'...') +  "</span>";
        }
        else {
            membersHtml += "<td class='mytd'><span title='" + guser.mood.escapeHTML() + "'>" + guser.mood.escapeHTML().getLimitLength(moodsublength,'...') +  "</span>" + outMember;
        }
        membersHtml += "<div  class='over_auto'></div></td>";
        membersHtml += "</tr>";
        flagName = "";
        trCount ++;
    }
    for (var j = 0; j < 10 - trCount; j++) {
    	membersHtml += "<tr height='60'><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>";
    }
    $('#grouplist').append(membersHtml);
    $('#pageList').empty();
    var tPage = 0;
    if (groupMemberInfo.length % 10 == 0) {
        tPage = parseInt(groupMemberInfo.length / 10);
    }
    else {
        tPage = parseInt(groupMemberInfo.length / 10 + 1);
    }
    totalPage = tPage;
    var pagString = "";
    pagString += "<tr><td colspan='4' class='border_t_gray' align='right'>";
    pagString += "<div class='common_over_page padding_tb_10'>";
    if (currentPage > 1) {
    	pagString += "<a href='#' class='common_over_page_btn' onclick='javaScript:initGroupMemberPage(" + (currentPage - 1) + ")' title='"+$.i18n('uc.page.prev.js')+"'><em class='pagePrev'></em></a>";
    }else{
    	pagString += "<a class='common_over_page_btn' title='"+$.i18n('uc.page.prev.js')+"'><em class='pagePrev_disable'></em></a>";
    }
    var mttpage = totalPage;
    if (totalPage <= 0) {
        mttpage = 1;
    }
    pagString += "<span class='margin_l_10'>"+$.i18n('uc.page.current.js')+"</span>" + currentPage + "/" + mttpage + $.i18n('uc.page.total.js');
    if (currentPage < totalPage) {
        pagString += "<a href='#' class='common_over_page_btn' onclick='javaScript:initGroupMemberPage(" + (currentPage + 1) + ")' title='"+$.i18n('uc.page.next.js')+"'><em class='pageNext'></em></a>";
    }else{
    	pagString += "<a class='common_over_page_btn' title='"+$.i18n('uc.page.next.js')+"'><em class='pageNext_disable'></em></a>";
    }
    pagString += "</div> </td></tr>";
    $('#pageList').append(pagString);
    $('#teamTree').height($('#teamtable').height());
    var heigth = parseInt($('#teamtable').height()) - 10;
    $('#group').height(heigth);
     getA8Top().endProc();
}

/**创建组**/
function createGroupUi(){
    crateGrouppe();
}

function crateGrouppe(){
    $('.common_send_people_tip').remove();
    
	var dialog = new MxtDialog({
    	id : 'UC_SelectPeople',
	    title : $.i18n('uc.group.create.js'),
	    url : v3x.baseURL + '/uc/chat.do?method=selectPeople&from=' + (isFromA8 ? 'a8' : 'genius'),
	    width : 500,
	    height : 450,
	    targetWindow : getA8Top(),
	    transParams : {
	    	showName : true
		},
	    buttons : [{
			text : $.i18n('uc.button.ok.js'),
			handler : function() {
	    		var result = dialog.getReturnValue();
	    		if(result != null)  {
	    			var groupname = result.name;
	    			groupname = groupname.replace(new RegExp('&nbsp;', 'g'), ' ');
	    			var groupMemberList = new Array();
	    			for (var i = 0; i < result.data.length; i++) {
	    				var data = result.data[i];
	    				groupMemberList[i] = data.source;
	    			}
	    			if (groupMemberList.length < 100) {
	    				if(groupname.indexOf('<script>') >=  0 || groupname.indexOf('</script>') >= 0){
	    					$.alert($.i18n('uc.groupnamecheck.js'));
	    				}else{
	    					createChick(groupname,groupMemberList);
		    				dialog.close();
	    				}
	    			}else{
	    				$.alert($.i18n('uc.group.membermax.js'));
	    			}
	    		}
			}
		}, {
			text : $.i18n('uc.button.cancel.js'),
			handler : function() {
				dialog.close();
			}
		}]
	});
}

function createChick(groupName,groupMemberList){
    creatGroupXmpp(groupName,groupMemberList);
}

function creatGroupXmpp(groupName,toMemberList){
    var iqsend = parent.window.opener.newJSJaCIQ();
    var uids = _CurrentUser_jid;
    iqsend.setFrom(uids);
    iqsend.setIQ('group.localhost', 'get', 'group1');
    var query1 = iqsend.setQuery('seeyon:group:create');
    var groupInfo = iqsend.buildNode('group_info');
    groupInfo.appendChild(iqsend.buildNode('group_name', '', groupName));
    groupInfo.appendChild(iqsend.buildNode('group_type', '', '4'));
    groupInfo.appendChild(iqsend.buildNode('group_member_num', '', toMemberList.length + 1));
    var members = iqsend.buildNode('group_members');
    members.appendChild(iqsend.buildNode('group_member', '', _CurrentUser_jid.replace('/jwchat', '')));
    for (var j = 0; j < toMemberList.length; j++) {
        members.appendChild(iqsend.buildNode('group_member', '', toMemberList[j]));
    }
    groupInfo.appendChild(members);
    query1.appendChild(groupInfo);
    connWin.con.send(iqsend, createGroup, toMemberList.length + 1);
}

function createGroup(iq, coun){
    if (!iq || iq.getType() != 'result') {
    	$.alert($.i18n('uc.group.Notcreate.js'));
    }
    else {
        var groupMess = iq.getNode().getElementsByTagName('group_info')[0];
        var groupName = groupMess.getAttribute('NA');
        var groupId = groupMess.getAttribute('I');
        var groupType = groupMess.getAttribute('T');
        var creatTime = groupMess.getAttribute('C');
        var updateTime = groupMess.getAttribute('U');
        var onlineCount = groupMess.getAttribute('OM');
        var memberCount = groupMess.getAttribute('M');
        var groupnice = groupMess.getAttribute('NI');
        var items = {
            id: groupId,
            showname: groupName + "("+onlineCount+"/"+ coun + ")",
            parentId: groupType,
            shortname: groupName,
            membercount: memberCount,
            onlinecount: onlineCount,
            createTime: updateTime,
            updateTime: updateTime,
            groupnice: groupnice,
            body: '',
            name: '',
            time: ''
        };
        var groupList = groupMap.get(4);
        try {
            groupList.length;
        } 
        catch (e) {
            groupList = new Array();
        }
        groupList[groupList.length] = items;
        groupMap.put(4, groupList);
        treeList[treeList.length] = items;
        initTreeRoot();
        initTree();
        $('#Uc_Team_Content').show();
        $('#addGroup').hide();
        $('#newgroupName').val('');
    }
}

/**查询组**/
function queryGroup(){
    var xt = groupMap.get(2);
    var xiet = groupMap.get(3);
    var xm = groupMap.get(4);
    var ls = groupMap.get(5);
    try {
        xt.length;
    } 
    catch (e) {
        xt = new Array();
    }
    try {
        xiet.length;
    } 
    catch (e) {
        xiet = new Array();
    }
    try {
        xm.length;
    } 
    catch (e) {
        xm = new Array();
    }
    try {
        ls.length;
    } 
    catch (e) {
        ls = new Array();
    }
    group = new Array();
    var str = "";
    if($('#groupName')[0].className.indexOf('color_gray') > 0){
    	str = '';
    }else{
    	str = $('#groupName').val().trim();
    }
    var o = 0;
    for (var i = 0; i < xt.length; i++) {
        var item = xt[i];
        if (item.shortname.indexOf(str) >= 0) {
            group[o] = item;
            o++;
        }
    }
    for (var i = 0; i < xiet.length; i++) {
        var item = xiet[i];
        if (item.shortname.indexOf(str) >= 0) {
            group[o] = item;
            o++;
        }
    }
    for (var i = 0; i < xm.length; i++) {
        var item = xm[i];
        if (item.shortname.indexOf(str) >= 0) {
            group[o] = item;
            o++;
        }
    }
    for (var i = 0; i < ls.length; i++) {
        var item = ls[i];
        if (item.shortname.indexOf(str) >= 0) {
            group[o] = item;
            o++;
        }
    }
    checkGroup();
}

/**解散组**/
function deleteGroup(gid){
    if (window.confirm($.i18n('uc.group.dissolve.js'))) {
        var iqsend = parent.window.opener.newJSJaCIQ();
        var uids = _CurrentUser_jid;
        iqsend.setFrom(uids);
        iqsend.setIQ(gid, 'set', 'group1');
        var query1 = iqsend.setQuery('seeyon:group:destroy');
        connWin.con.send(iqsend, deleteGroupMessage);
    }
    else {
        return;
    }
}

function deleteGroupMessage(iq){
    if (!iq || iq.getType() == 'eror') {
    	$.alert($.i18n('uc.group.Ungroup.failed.js'));
    }
    else {
        group = new Array();
        var groid = iq.getFrom();
        var group1 = groupMap.get(grouptype);
        var u = 0;
        for (var i = 0; i < group1.length; i++) {
            var g1 = group1[i];
            if (g1.id.indexOf(groid) < 0) {
                group[u] = g1;
                u++;
            }
        }
        groupMap.put(grouptype, group);
        checkGroup();
        var newTree = treeList;
        var x = 0;
        treeList = new Array();
        for (var j = 0; j < newTree.length; j++) {
            if (newTree[j].id == groid) {
            
            }
            else {
                treeList[x] = newTree[j];
                x++;
            }
        }
        initTreeRoot();
        initTree();
    }
}

/**退出**/
function outGroup(gid){
    if (window.confirm($.i18n('uc.group.currentgroup.js'))) {
        var name = _CurrentUser.name;
        var iqsend = parent.window.opener.newJSJaCIQ();
        var uids = _CurrentUser_jid;
        iqsend.setFrom(uids);
        iqsend.setIQ(gid, 'set', 'group1');
        var query1 = iqsend.setQuery('seeyon:group:exit');
        query1.appendChild(iqsend.buildNode('name', '', name));
        connWin.con.send(iqsend, outGroupMessage);
    }
    else {
        return;
    }
    
}

function outGroupMessage(iq){
    if (!iq || iq.getType() == 'eror') {
    	$.alert($.i18n('uc.group.exit.groupfailed.js'));
    }
    else {
        group = new Array();
        var groid = iq.getFrom();
        connWin.roster.DisabledChatUser.put(groid, true);
        var group1 = groupMap.get(grouptype);
        var u = 0;
        for (var i = 0; i < group1.length; i++) {
            var g1 = group1[i];
            if (g1.id.indexOf(groid) < 0) {
                group[u] = g1;
                u++;
            }
        }
        groupMap.put(grouptype, group);
        var newTree = treeList;
        var x = 0;
        treeList = new Array();
        for (var j = 0; j < newTree.length; j++) {
            if (newTree[j].id == groid) {
            
            }
            else {
                treeList[x] = newTree[j];
                x++;
            }
        }
        initTreeRoot();
        initTree();
    }
}

function reNameGroup(gid, gname){
	groupId = gid;
	groupnamebyupdate = gname;
	queryTeamMember(gid,false);
}

function queryTeamMember(groupid,isChatcreateTeam){
	var iq = parent.window.opener.newJSJaCIQ();
    iq.setFrom(parent.window.opener.jid);
    iq.setIQ(groupid, 'get', 'group1');
    var query = iq.setQuery('seeyon:group:query:member');
    connWin.con.send(iq, getMembersByTeam,isChatcreateTeam);
}

function getMembersByTeam(iq,isChatcreateTeam){
	try{
		var groupMembers = iq.getNode().getElementsByTagName('jid');
		var groupMemberinfoList = new Array();
		 for (var i = 0; i < groupMembers.length; i++) {
			 var mjid = groupMembers[i].getAttribute('J');
			 groupMemberinfoList[i] = mjid;
		 }
		 if(isChatcreateTeam){
			 queryMemberBySelectPeolpe(groupMemberinfoList,true);
		 }else{
			 queryMemberBySelectPeolpe(groupMemberinfoList,false);
		 }
	}catch(e){
		
	}
}

function queryMemberBySelectPeolpe(groupMembers,isChatcreateTeam){
	var iqs = parent.window.opener.newJSJaCIQ();
    iqs.setIQ(null, 'get');
    var query = iqs.setQuery('jabber:iq:seeyon:office-auto');
    var organization = iqs.buildNode('organization', {'xmlns': 'organization:staff:info:query'});
    var staff = iqs.buildNode('staff');
    for (var i = 0; i < groupMembers.length; i++) {
    	var jid = groupMembers[i];
    	if(jid != parent.window.opener.jid){
    		staff.appendChild(iqs.buildNode('jid', {'deptid': ''}, jid));
    	}
    }
    organization.appendChild(staff);
    query.appendChild(organization);
    if(!isChatcreateTeam){
    	connWin.con.send(iqs, cacheTeamMemberInfo);
    }
}

function cacheTeamMemberInfo(iq){
	try{
		var items = iq.getNode().getElementsByTagName('jid');
		var groupMemberdata = [];
		for(var i = 0 ; i < items.length; i ++){
			var item = items.item(i);
			var memberid = item.getAttribute('I');
			var name = item.getAttribute('N');
			var jid = item.getAttribute('J');
			groupMemberdata[i] = {'type' : 'Member', 'id' : memberid + 'InBox', 'source' : jid, 'name' : name};
		}
		var dialog = new MxtDialog({
	    	id : 'UC_SelectPeople',
		    title : $.i18n('uc.group.update.js'),
		    url : v3x.baseURL + '/uc/chat.do?method=selectPeople&from=' + (isFromA8 ? 'a8' : 'genius'),
		    width : 500,
		    height : 450,
		    targetWindow : getA8Top(),
		    transParams : {
		    	showName : true,
		    	name : groupnamebyupdate,
		    	data : groupMemberdata
			},
		    buttons : [{
				text : $.i18n('uc.button.ok.js'),
				handler : function() {
		    		var result = dialog.getReturnValue();
		    		if(result != null){
		    			var groupname = result.name;
		    			var groupMemberList = new Array();
		    			for (var i = 0; i < result.data.length; i++) {
		    				var data = result.data[i];
		    				groupMemberList[i] = data.source;
		    			}
		    			if (groupMemberList.length < 100) {
		    				if(groupname.indexOf('<script>') >=  0 || groupname.indexOf('</script>') >= 0){
		    					$.alert($.i18n('uc.groupnamecheck.js'));
		    				}else{
			    				updateTeam(groupId,groupname,groupMemberList);
				    			dialog.close();
		    				}
		    			}else{
		    				$.alert($.i18n('uc.group.membermax.js'));
		    			}
		    		}
				}
			}, {
				text :  $.i18n('uc.button.cancel.js'),
				handler : function() {
					dialog.close();
				}
			}]
		});
		
	}catch(e){
	}
}

function updateTeam(gid,gname,gmemberList){
	var iqsend = connWin.newJSJaCIQ();
    var uids = _CurrentUser_jid;
    iqsend.setFrom(uids);
    iqsend.setIQ(gid, 'set', 'group1');
    var query1 = iqsend.setQuery('seeyon:group:modify:info');
    var groupInfo = iqsend.buildNode('group_info');
    groupInfo.appendChild(iqsend.buildNode('group_name', '',gname));
    groupInfo.appendChild(iqsend.buildNode('group_type', '','4'));
    var members = iqsend.buildNode('group_members');
    var istome = false;
    for(var j = 0 ; j < gmemberList.length; j++){
   	if(_CurrentUser_jid.replace('/jwchat', '') == gmemberList[j]){
   		istome = true;
   	}
    	members.appendChild(iqsend.buildNode('group_member', '', gmemberList[j]));
    }
    if(!istome){
   	groupInfo.appendChild(iqsend.buildNode('group_member_num', '', gmemberList.length+1));
   	members.appendChild(iqsend.buildNode('group_member', '', _CurrentUser_jid.replace('/jwchat', '')));
    }else{
   	groupInfo.appendChild(iqsend.buildNode('group_member_num', '', gmemberList.length));
    }
    groupInfo.appendChild(members);
    query1.appendChild(groupInfo);
    connWin.con.send(iqsend, reNameGroupState);
}


function reNameGroupState(iq){
    if (!iq || iq.getType() == 'error') {
    	$.alert($.i18n('uc.group.modifygroup.js'));
    } else {
        var NewName = iq.getNode().getElementsByTagName('group_info')[0].getAttribute('NA');
        NewName = NewName.replace(new RegExp('&nbsp;', 'g'), ' ');
        var memberCount = iq.getNode().getElementsByTagName('group_info')[0].getAttribute('M');
        var onlinCount = iq.getNode().getElementsByTagName('group_info')[0].getAttribute('OM');
        var xt = groupMap.get(2);
        var xiet = groupMap.get(3);
        var xm = groupMap.get(5);
        var ls = groupMap.get(4);
        try {
            xt.length;
        } 
        catch (e) {
            xt = new Array();
        }
        try {
            xiet.length;
        } 
        catch (e) {
            xiet = new Array();
        }
        try {
            xm.length;
        } 
        catch (e) {
            xm = new Array();
        }
        try {
            ls.length;
        } 
        catch (e) {
            ls = new Array();
        }
        for (var i = 0; i < xt.length; i++) {
            var item = xt[i];
            if (item.id == groupId) {
                item.shortname = NewName;
                xt[i] = item;
            }
        }
        for (var i = 0; i < xiet.length; i++) {
            var item = xiet[i];
            if (item.id == groupId) {
                item.shortname = NewName;
                xiet[i] = item;
            }
        }
        for (var i = 0; i < xm.length; i++) {
            var item = xm[i];
            if (item.id == groupId) {
                item.shortname = NewName;
                xm[i] = item;
            }
        }
        for (var i = 0; i < ls.length; i++) {
            var item = ls[i];
            if (item.id == groupId) {
                item.shortname = NewName;
                ls[i] = item;
            }
        }
        
        groupMap.put(2, xt);
        groupMap.put(3, xiet);
        groupMap.put(5, xm);
        groupMap.put(4, ls);
        for (var i = 0; i < treeList.length; i++) {
            var item = treeList[i];
            if (item.id == groupId) {
                item.membercount = memberCount;
                item.showname = NewName + "("+ onlinCount +"/" + item.membercount + ")";
                treeList[i] = item;
            }
        }
        group = groupMap.get(4);
        checkGroup();
        initTree();
        groupId = '';
    }
}

/***踢除人员***/

function exitPer(memberName, mjid){
    memberJid = mjid;
    var iq = parent.window.opener.newJSJaCIQ();
    var uids = _CurrentUser_jid;
    iq.setFrom(uids);
    iq.setIQ(groupids, 'set', 'removeGroupMember');
    var query1 = iq.setQuery('seeyon:group:remove');
//    var groupinfo = iq.buildNode('group_info');
    var members = iq.buildNode('group_members');
    members.appendChild(iq.buildNode('group_member', mjid));
//    groupinfo.appendChild(members);
    query1.appendChild(members);
    connWin.con.send(iq, removeMemberState);
}

function removeMemberState(iq){
    if (!iq || iq.getType() == 'eror') {
    	$.alert($.i18n('uc.group.Kicksfailed.js'));
    }
    else {
        var newGroupMemberList = new Array();
        var u = 0;
        for (var i = 0; i < groupNewMemberInfo.length; i++) {
            var member = groupNewMemberInfo[i];
            if (member.id == memberJid) {
            	if(member.online == 1){
            		onlineNum --;
            	}
                continue;
            }
            else {
                newGroupMemberList[u] = member;
                u++;
            }
        }
        var newGroupMemberIdList = new Array();
        var p = 0;
        for (var i = 0; i < groupMemberList.length; i++) {
            if (groupMemberList[i] == memberJid) {
                continue;
            }
            else {
                newGroupMemberIdList[p] = groupMemberList[i];
                p++;
            }
        }
        var newGroupMemberInfoList = new Array();
        var k = 0;
        for (var i = 0 ; i < groupMemberInfo.length; i++){
        	var memberinfo = groupMemberInfo[i];
        	if(memberinfo.id == memberJid){
        		
        	}else{
        		newGroupMemberInfoList[k] = memberinfo;
        		k++;
        	}
        }
        var accountObj = $.fn.zTree.getZTreeObj("group");
        var selectAccountNode = accountObj.getNodeByParam("id", groupids, null);
        selectAccountNode.membercount = parseInt(selectAccountNode.membercount)-1;
        selectAccountNode.showname = selectAccountNode.shortname + "("+onlineNum+"/" + selectAccountNode.membercount + ")";
        accountObj.updateNode(selectAccountNode);
        groupMemberList = newGroupMemberIdList;
        groupMemberInfo = newGroupMemberInfoList;
        groupNewMemberInfo = newGroupMemberList;
        $('#onlinN').empty();
        $('#onlinN').append("<font color='blue'>" + onlineNum + "</font>/" + groupMemberList.length);
        initGroupMemberPage(currentPage);
     
    }
}

/***查询组内人员***/
function queryGroupMember(){
	var str ='';
	if($('#groupMemberName')[0].className.indexOf('color_gray') >0){
		str = '';
	}else{
		str = $('#groupMemberName').val();
	}
    if (str == '') {
        groupMemberInfo = groupAllMemberInfo;
    }
    else {
        var x = 0;
        groupMemberInfo = new Array();
        for (var i = 0; i < groupAllMemberInfo.length; i++) {
            if (groupAllMemberInfo[i].name.indexOf(str.trim()) >= 0) {
                groupMemberInfo[x] = groupAllMemberInfo[i];
                x++;
            }
        }
    }
    var tPage = 0;
    if (groupMemberInfo.length % 10 == 0) {
        tPage = parseInt(groupMemberInfo.length / 10);
    }
    else {
        tPage = parseInt(groupMemberInfo.length / 10 + 1);
    }
    totalPage = tPage;
    currentPage = 1;
    initGroupMemberPage(currentPage);
}

function showGroupOffLin(){
	if ($('#groupMemberName')[0].className.indexOf('color_gray') < 0){
		$('#groupMemberName').addClass('color_gray');
		$('#groupMemberName').val($.i18n('uc.staff.name.js'));
	}
    var isflag = $('#CheckboxGroup')[0].checked;
    if (isflag) {
        $('#showOrgOffLine')[0].checked = 'checked';
        $('#CheckboxRelate')[0].checked = 'checked';
        isShowOrgOffLine = true;
        isreOnline = true;
        isGroupOnline = true;
    } else {
    	$('#showOrgOffLine')[0].checked ='';
        $('#CheckboxRelate')[0].checked ='';
        isShowOrgOffLine = false ;
        isreOnline = false;
        isGroupOnline = false;
    }
    groupMemberInfos();
}
function openWinIMflag(name,id){
	if (connWin.roster.DisabledChatUser.get(id)){
		$.alert($.i18n('uc.group.notinfo.js'));
		 $(".uc_tree_list").show();
         var iq = parent.window.opener.newJSJaCIQ();
         var uid = _CurrentUser_jid;
         iq.setFrom(uid);
         iq.setIQ('group.localhost', 'get');
         var query = iq.setQuery('seeyon:group:query:info');
         connWin.con.send(iq, showGroup);
	}else{
		parent.window.opener.openWinIM(name,id);
	}
}

function checkGroupInfo(groupid){
	var iq = parent.window.opener.newJSJaCIQ();
    var uid = parent.window.opener.jid;
    iq.setFrom(uid);
    iq.setIQ(groupid, 'get', 'groupInfo');
    var query = iq.setQuery('seeyon:group:query:info');
    connWin.con.send(iq, checkGroupinfoMessage);
}

function checkGroupinfoMessage(iq){
	
}

function createCTeam(){
	
}

function sendTeamMessage(){
	try{
		openWinIMflag(groupNames,groupids);
	}catch(e){
	}
}

$(".mytd").live("mouseenter",function(){
	$(this).find('#del').show();
}).live("mouseleave",function(){
	$(this).find('#del').hide();
});

/**
 * 点击群成员按钮进入群成员列表
 */
function  requestGroupMemberByspan(groupid , gname){
	groupNames = gname;
	requestGroupMember(groupid);
}

/**
 * 排序
 */
function QuickSortArrayByTeamMember(arr, comparatorProperies) {
    if(comparatorProperies){
        arr.sort(function(o1, o2){
        return o1[comparatorProperies].localeCompare(o2[comparatorProperies]);
        });
    } else {
        arr.sort();
    }
}

function subResources (jids) {
    var newJid = '';
    if (jids.indexOf('@') > -1) {
        newJid = jids.substr(0,jids.indexOf('@'));
    } else {
        newJid = jids;
    }
    return newJid;
}