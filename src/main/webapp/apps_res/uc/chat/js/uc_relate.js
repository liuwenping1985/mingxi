/****************************************关联人员****************************************/
var relatTreeList;
var relateMemberidList;
var relateMemberList;
var newrelateMemberList;
var ronlineNum = 0;
var isreOnline = false;
var ronlineNumber = 0;
var rcountMember = 0;
var AllRelateMemberList;
function showRelate(){
	getA8Top().startProc();
    var iq = parent.window.opener.newJSJaCIQ();
    var uid = _CurrentUser_jid;
    iq.setFrom(uid);
    iq.setIQ(uid, 'get');
    var query = iq.setQuery('jabber:iq:relategroup');
    connWin.con.send(iq, getRelate);
    $(".uc_tree_list").show();
}

function getRelate(iq){
    relatTreeList = new Array();
    //在请求关联人员组的时候先生成树，防止后台请求返回数据为空
    initretree(relatTreeList);
    var relateGroup = iq.getNode().getElementsByTagName('item');
    if (relateGroup.length <= 0) {
    	return ;
    }
    for (var i = 0; i < relateGroup.length; i++) {
        var reid = relateGroup[i].getAttribute('relategroupid');
        var count = relateGroup[i].getAttribute('count');
        var name = "";
        var type = "";
        if (reid == 'leader') {
            name = $.i18n('uc.relate.leader.js')+"(" + count + ")";
            type = $.i18n('uc.relate.leader.js');
        }
        else 
            if (reid == 'junior') {
                name = $.i18n('uc.relate.junior.js')+"(" + count + ")";
                type = $.i18n('uc.relate.junior.js');
            }
            else 
                if (reid == 'confrere') {
                    name = $.i18n('uc.relate.confrere.js')+"(" + count + ")";
                    type = $.i18n('uc.relate.confrere.js');
                }
                else {
                    name = $.i18n('uc.relate.assistant.js')+"(" + count + ")";
                    type = $.i18n('uc.relate.assistant.js');
                }
        var items = {
            id: reid,
            showname: name,
            parentId: 'p1',
            type : type,
            count : count
        };
        if (items.id == "leader") {
            relatTreeList[1 + 0] = items;
        }
        if (items.id == "junior") {
            relatTreeList[1 + 1] = items;
        }
        if (items.id == "confrere") {
            relatTreeList[1 + 2] = items;
        }
        if (items.id == "assistant") {
            relatTreeList[1 + 3] = items;
        }
        
    }
    
    
    
    var iqbycount = parent.window.opener.newJSJaCIQ();
    var uid = _CurrentUser_jid;
    iqbycount.setFrom(uid);
    iqbycount.setIQ(uid, 'get');
    var query = iqbycount.setQuery('jabber:iq:online:relatemember');
    connWin.con.send(iqbycount, getOnlineCount);
}

function getOnlineCount(iq){
	 var items = iq.getNode().getElementsByTagName('item');
	 var onlineMap = new Properties();
	 for (var i = 0; i < items.length ; i++) {
	 	 var relateItem = items[i];
		 var relateType = relateItem.getAttribute('relategroupid');
		 var onlineCount = relateItem.getAttribute('count');
		 onlineMap.put(relateType,onlineCount);
	 }
	 var item1 = relatTreeList[1];
	 item1.showname =  item1.type+"("+item1.count+")";
	 relatTreeList[1] = item1;
	 var item2 = relatTreeList[2];
	 item2.showname =  item2.type+"("+item2.count+")";
	 relatTreeList[2] = item2;
	 var item3 = relatTreeList[3];
	 item3.showname =  item3.type+"("+item3.count+")";
	 relatTreeList[3] = item3;
	 var item4 = relatTreeList[4];
	 item4.showname =  item4.type+"("+item4.count+")";
	 relatTreeList[4] = item4;
	 initretree(relatTreeList);
}

function initretree(relatTreeList){
	 var relateString = {
		        data: {
		            key: {
		                name: "showname"
		            },
		            simpleData: {
		                enable: true,
		                idKey: "id",
		                pIdKey: "parentId",
		                rootPId: null
		            }
		        },
		        callback: {
		            onClick: showMember
		        }
		    };
		    var item1 = {
		        id: 'p1',
		        showname: $.i18n('uc.relate.all.js'),
		        parentId: '',
		        open: true
		    };
		    relatTreeList[0] = item1;
		    if (relatTreeList.length <= 1) {
		        var item2 = {
		            id: 'leader',
		            showname: $.i18n('uc.relate.leader.js')+'(0)',
		            parentId: 'p1',
		            type: $.i18n('uc.relate.leader.js')
		        };
		        var item3 = {
		            id: 'junior',
		            showname: $.i18n('uc.relate.junior.js')+'(0)',
		            parentId: 'p1',
		            type: $.i18n('uc.relate.junior.js')
		        };
		        var item4 = {
		            id: 'assistant',
		            showname: $.i18n('uc.relate.assistant.js')+'(0)',
		            parentId: 'p1',
		            type: $.i18n('uc.relate.assistant.js')
		        };
		        var item5 = {
		            id: 'confrere',
		            showname: $.i18n('uc.relate.confrere.js')+'(0)',
		            parentId: 'p1',
		            type: $.i18n('uc.relate.confrere.js')
		        };
		        relatTreeList[1] = item2;
		        relatTreeList[2] = item3;
		        relatTreeList[4] = item4;
		        relatTreeList[3] = item5;
		    }
		    $.fn.zTree.init($("#relateList"), relateString, eval(relatTreeList));
		    var accountObj = $.fn.zTree.getZTreeObj("relateList");
		    var selectAccountNode = accountObj.getNodeByParam("id", "leader", null);
		    accountObj.selectNode(selectAccountNode);
		    queryRelateMeber("leader");
}

function showMember(e, treeId, treeNode){
    if (treeNode.id != 'p1') {
        queryRelateMeber(treeNode.id);
    }
}

function queryRelateMeber(rgid){
	getA8Top().startProc();
    var iq = parent.window.opener.newJSJaCIQ();
    var uid = _CurrentUser_jid;
    iq.setFrom(uid);
    iq.setIQ(uid, 'get', 'get_relatemember');
    var query = iq.setQuery('jabber:iq:relatemember');
    query.appendChild(iq.buildNode('relategroupid', rgid));
    query.appendChild(iq.buildNode('dataType', "json"));
    connWin.con.send(iq, getRelateMember);
}

function getRelateMember(iq){
    relateMemberidList = new ArrayList();
    var relateGroup = iq.getNode().getElementsByTagName('query');
    if (relateGroup && relateGroup.length > 0) {
    	try{
        	var item = '';
        	if (v3x.isFirefox) {
        		item = relateGroup.item(0).innerHTML;
        	} else {
        		item = relateGroup.item(0).firstChild.nodeValue;
        	}
            var json = null;
            try {
                eval("json = " + item);
            } catch (e) {
            }
            var relateGroupMembersJson = json["jid"];
            for (var i = 0; i < relateGroupMembersJson.length; i++) {
            	var relateGroupMemberJson = relateGroupMembersJson[i];
                var jid = relateGroupMemberJson['J'];
                var sortid = relateGroupMemberJson['S']; 
                var item = {
                		jid : jid,
                		sortid :parseInt(sortid)
                };
                relateMemberidList.add(item);
            }
    	}catch(e){
    		
    	}
    }
    QuickSortArrayList(relateMemberidList, "sortid");
    queryMemberInfo();
}

function queryMemberInfo(){
    var iq = parent.window.opener.newJSJaCIQ();
    var uid = _CurrentUser_jid;
    iq.setFrom(uid);
    iq.setIQ(uid, 'get', 'memberinfo');
    var query = iq.setQuery('jabber:iq:seeyon:office-auto');
    var org = iq.buildNode('organization', {
        'xmlns': 'organization:staff:info:query'
    });
    var staff = iq.buildNode('staff',{'dataType': 'json'});
    for (var j = 0; j < relateMemberidList.size(); j++) {
        var jid = relateMemberidList.get(j).jid;
        var jidE = iq.buildNode('jid', jid);
        jidE.setAttribute('deptid', '');
        staff.appendChild(jidE);
    }
    org.appendChild(staff);
    query.appendChild(org);
    connWin.con.send(iq, showMessMember);
    
}

function showMessMember(iq){
    ronlineNumber = 0;
    rcountMember = 0;
    if (!iq || iq.getType() == 'eror') {
    	$.alert('获取人员信息失败!');
    }
    else {
        var items = iq.getNode().getElementsByTagName('staff');
        relateMemberList = new Array();
        if (items && items.length > 0) {
        	try{
        		var json = null;
        		try{
                	var item = '';
                	if (v3x.isFirefox) {
                		item = items.item(0).innerHTML;
                	} else {
                		item = items.item(0).firstChild.nodeValue;
                	}
            		eval("json =" + item);
        		}catch(e){
        			
        		}
                var membersJson = json["M"];
                var x = 0;
                for (var i = 0; i < membersJson.length; i++) {
                	var memberJson = membersJson[i];
                	var member = new OrgMemberSimple();
                    var jid = memberJson['J'];
                    var name = memberJson['N'];
                    var photo =  memberJson['H'];
                    var online =  memberJson['O'];
                    var dName =  memberJson['DM'];
                    var postName =  memberJson['PM'];
                    var mood =  memberJson['M'];
                    var memberId =  memberJson['I'];
                    var AccoundId = memberJson['A'];
                    var levelid = memberJson['L'];
                    var departmentId = memberJson['D'];
                    if(memberId != '' && name !=''){
        	            var relateMember = {
        	                id: jid,
        	                name: name,
        	                postname: postName,
        	                dName: dName,
        	                online: online,
        	                photo: photo,
        	                mood: mood,
        	                memberId: memberId
        	            };
        	            //判断职务级别控制youhb2014年1月26日11:29:20
                    	member.unitid = AccoundId;
    					member.deptid = departmentId;
    					member.levelid = levelid;
    					if (!checkLevelScope(member)) {
    						continue;
    					}
    					
        	            if (online != 0) {
        	                ronlineNumber++;
        	            }
        	            rcountMember++;
        	            if (!isreOnline) {
        	                if (online != 0) {
        	                    ronlineNum++;
        	                    relateMemberList[x] = relateMember;
        	                    x++;
        	                }
        	                else {
        	                    continue;
        	                }
        	            }
        	            else {
        	                if (online != 0) {
        	                    ronlineNum++;
        	                }
        	                relateMemberList[x] = relateMember;
        	                x++;
        	            }
                    }
                }
        	}catch(e){
        		
        	}
        }
        $('#online_numr').text(ronlineNumber);
        $('#total_numr').text(rcountMember);
        var treeObj = $.fn.zTree.getZTreeObj("relateList");
        var nodes = treeObj.getSelectedNodes();
        if (nodes.length > 0) {
            nodes[0].showname = nodes[0].type +"("+rcountMember+")";
            treeObj.updateNode(nodes[0]);
        }
        AllRelateMemberList = relateMemberList;
    }
    var tPage = 0;
    if (relateMemberList.length % 10 == 0) {
        tPage = parseInt(relateMemberList.length / 10);
    }
    else {
        tPage = parseInt(relateMemberList.length / 10 + 1);
    }
    totalPage = tPage;
    currentPage = 1;
    initRMember(currentPage);
}

function initRMember(thisPage){
    currentPage = thisPage;
    var starNum = (thisPage - 1) * 10;
    var endNum = starNum + 10;
    if (endNum > relateMemberList.length) {
        endNum = relateMemberList.length;
    }
    newrelateMemberList = relateMemberList.slice(starNum, endNum);
    showMemberToTbale();
}

function showMemberToTbale(){
    $('#relate').empty();
    var rmembersHtml = "";
    var trCount = 0;
    for (var i = 0; i < newrelateMemberList.length; i++) {
        var random = Math.floor(Math.random() * 100000000);
        var user = newrelateMemberList[i];
        //心情处理脚本
        var moods = user.mood.escapeHTML();
        rmembersHtml += "<tr>";
        rmembersHtml += "<td><div class='ucFaceImage'>";
        var status = "";
        if (user.online != 0){
           status = "ico16 online" + user.online;
        }
        rmembersHtml += "<span class='onlineState_box'><span class='onlineState " + status + "' style='cursor: default;'></span></span>";
        rmembersHtml += "<img id='" + random + "'Img' jid='" + user.id + "' class='img' src='" + user.photo + "' width='48' height='48' onmouseover='showPeopleCard(this, false)' onmouseout=\'showPeopleCard_type=false;\' >";
    	rmembersHtml += "<span class='name text_overflow hand' title='" + user.name + "' onclick='parent.window.opener.openWinIM(\"" + user.name + "\", \"" + user.id + "\")'>" + user.name + "</span>";
        rmembersHtml += "</div></td>";
        rmembersHtml += "<td><div class='w100 text_overflow' title='" + user.dName + "'>" + user.dName + "</div></td>";
        rmembersHtml += "<td><div class='w100 text_overflow' title='" + user.postname + "'>" + user.postname + "</div></td>";
        rmembersHtml += "<td><div class='signiture_w1 text_overflow left' title ='" + moods + "'>&nbsp;" + moods + "</div></td>";
        rmembersHtml += "</tr>";
        trCount ++;
    }
    for (var j = 0; j < 10 - trCount; j++) {
    	rmembersHtml += "<tr height='60'><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>";
    }
    $('#relate').append(rmembersHtml);
    initPageNum(false);
    $('#relateTree').height($('#relateTable').height());
    var height = parseInt($('#relateTable').height())-10;
    $('#relateList').height(height);
    getA8Top().endProc();
}

function showOffLineByre(){
	if ($('#reMember')[0].className.indexOf('color_gray') < 0) {
		 $('#reMember').addClass('color_gray');
     	 $('#reMember').val($.i18n('uc.staff.name.js'));
	}
    var isRflage = $('#CheckboxRelate')[0].checked;
    if (isRflage) {
        $('#showOrgOffLine')[0].checked = 'checked';
        $('#CheckboxGroup')[0].checked = 'checked';
        isShowOrgOffLine = true;
        isreOnline = true;
        isGroupOnline = true;
    } else {
    	$('#showOrgOffLine')[0].checked = '';
    	$('#CheckboxGroup')[0].checked = '';
    	isShowOrgOffLine = false;
    	isreOnline = false;
        isGroupOnline = false;
    }
    queryMemberInfo();
}

function reMemberclic(){
	var rname = '';
	if($('#reMember')[0].className.indexOf('color_gray')>0){
		rname = '';
	}else{
		rname = $('#reMember').val();
	}
    relateMemberList = new Array();
    if (rname == '') {
        relateMemberList = AllRelateMemberList;
    }
    else {
        var x = 0;
        for (var i = 0; i < AllRelateMemberList.length; i++) {
            if (AllRelateMemberList[i].name.indexOf(rname.trim()) >= 0) {
                relateMemberList[x] = AllRelateMemberList[i];
                x++;
            }
            else {
                continue;
            }
        }
    }
    var tPage = 0;
    if (relateMemberList.length % 10 == 0) {
        tPage = parseInt(relateMemberList.length / 10);
    }
    else {
        tPage = parseInt(relateMemberList.length / 10 + 1);
    }
    totalPage = tPage;
    currentPage = 1;
    initRMember(currentPage, true);
}
