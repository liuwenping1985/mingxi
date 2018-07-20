<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/shared.js${ctp:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/jsjac.js${ctp:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/uc_onlinemsg.js${ctp:resSuffix()}" />"></script>
<script type="text/javascript">
	//-1：普遍失败
	//-2：人员未同步
	//-3：UC服务器未启动
	//-4：UC服务器地址不正确、防火墙阻止
	//-5：IE插件未安装
	var connectionStatus = 0;
	var winUC = null; //UC中心
	var winIM = null; //聊天窗口
	var hasMsg = false; //是否有消息
	var isIMonload = true;//im页面是否加载完毕
	var onlineStatus = 'ico16 online1'; //如果A8 打开 uc未打开的时候默认的uc状态为上线
	var ucSSOManager = RemoteJsonService.extend({
    	jsonGateway: "/seeyon/ajax.do?method=ajaxAction&managerName=ucSSOManager",
    	loginUC: function(){
			return this.ajaxCall(arguments,"loginUC");
    	}
	});
	var ssoManager = new ucSSOManager();
	var _ctpPath = _ctxPath;
	var host;
	var outherHost;//uc外网ip
	var port;
	var jid;
	var pass;
	var status;
	var fileSize;
	var curUserName = "${ctp:escapeJavascript(CurrentUser.name)}";
	var curUserPhoto;
	try {
		curUserPhoto = memberImageUrl;
	} catch (e) {
		curUserPhoto = "${ctp:avatarImageUrl(CurrentUser.id)}";
	}
    var accessableDepartmentIds = new Properties();
    var accessableDepartmentId = new Properties();
    var accessableMemberIds = new Properties();
	var roster;
	var con;
	var _PhotoMap = new Properties();
	var _MemberId2Jid= new Properties();
	var noticeProperties = new Properties();

	function newJSJaCIQ() {
		return new JSJaCIQ();
	}

	function newJSJaCMessage() {
		return new JSJaCMessage();
	}

	function handleIQ(aIQ) {
	}

	function handlePresence(aPresence) {
	}

	function handleMessage(oMsg) {
		var from = cutResource(oMsg.getFrom());
		var msgType = oMsg.getType();
		if (msgType ==  "filetrans_result" || msgType == "group_system" || msgType == "group_info_notice_update" || msgType == "group_delete_file" || msgType == "group_info_update") { 
			return ;
		}
		if (msgType == 'error') {
			var errorType = oMsg.getNode().getElementsByTagName('service-unavailable');
			if (errorType.length < 1) {
				return;
			} else {
				roster.DeleteUser.put(from, true);
			}
		}
		//项目组系统组添加时发起协议
		if (msgType == 'no_tip_kitout_group' || msgType == 'no_tip_destroy_group') {
			roster.DisabledChatUser.put(from, true);
			return ;
		}
		//项目组系统租剔除人员以及删除时发起协议
		if (msgType == 'no_tip_add_group') {
			roster.DisabledChatUser.remove(from);
			return ;
		}
		if (msgType == 'add_group' || msgType == 'destroy_group' || msgType == 'exit_group' || msgType == 'kitout_group') {
			var notice = '';
			var groupname = oMsg._getAttribute("groupname");
			if (msgType == 'add_group') {
				if ("" != oMsg._getAttribute("name")) {
		          roster.DisabledChatUser.remove(from);
		          notice = $.i18n('uc.title.addgroup.js', groupname);
				} else {
					return;
				}
			} else if (msgType == 'destroy_group') {
				roster.DisabledChatUser.put(from, true);
				notice = $.i18n('uc.title.groupdissolved.js', groupname);
			} else if (msgType == 'exit_group') {
				var memberName = '';
				try{
					memberName = oMsg._getAttribute("name");
				}catch(e){
					
				}
				notice = memberName + $.i18n('uc.title.groupexit.js', groupname);
			} else if (msgType == 'kitout_group') {
				if ("" != oMsg._getAttribute("name")) {
					roster.DisabledChatUser.put(from, true);
	                notice = $.i18n('uc.title.groupkicked.js', groupname);
				} else {
					return;
				}
			}
			
            var random = Math.floor(Math.random() * 100000000);
            noticeProperties.put(random, notice);
            showPerNotice(random, notice, isA8geniusMsg ? "genius" : "a8");
			return;
		}
		

		var user = roster.getChatUserByJID(from);
		if (user == null) {
			user = roster.addChatUser(from);
		}

		var atts = new ArrayList();
		if (msgType == 'filetrans') {
			var items = oMsg.getNode().getElementsByTagName('filetrans');
			for (var i = 0; i < items.length; i++) {
				try {
					var item = items.item(i);
					var attId = item.getElementsByTagName('id').item(0).firstChild.nodeValue;
					var attName = item.getElementsByTagName('name').item(0).firstChild.nodeValue;
					var attSize = item.getElementsByTagName('size').item(0).firstChild.nodeValue;
					atts.add(new UC_ATTACHMENT(attId, attName, attSize));
				} catch(e) {}
			}
		}
		if (msgType == 'image') {
			var items = oMsg.getNode().getElementsByTagName('image');
			for (var i = 0; i < items.length; i++) {
				try {
					var item = items.item(i);
					var attId = item.getElementsByTagName('id').item(0).firstChild.nodeValue;
					var attName = item.getElementsByTagName('name').item(0).firstChild.nodeValue;
					var attSize = item.getElementsByTagName('size').item(0).firstChild.nodeValue;
					atts.add(new UC_ATTACHMENT(attId, attName, attSize));
				} catch(e) {}
			}
		}
		
		var vcard = null;
		if (msgType == 'vcard') {
			var items = oMsg.getNode().getElementsByTagName('vcard');
			try {
				var item = items.item(0);
				var iphone = new ArrayList();
				var otherF = new ArrayList();
				var address = new ArrayList();
				var workPhone = new ArrayList();
				var hPhone = new ArrayList();
				var adPhone = new ArrayList();
				var workF = new ArrayList();
				var ppG = new ArrayList();
				var other = new ArrayList();
				var addressMail = new ArrayList();
				var workMail = new ArrayList();
				var otherMail = new ArrayList();
				var name = new ArrayList();
				var mobliePhone = new ArrayList();
				name = getChildValue(item,'N');
				mobliePhone = getChildValue(item,'MT');
				iphone = getChildValue(item,'IPH');
				address = getChildValue(item,'AD');
				workPhone = getChildValue(item,'WK');
				hPhone = getChildValue(item,'HE');
				adPhone = getChildValue(item,'ADF');
				workF = getChildValue(item,'WKF');
				otherF = getChildValue(item,'OTF');
				ppG = getChildValue(item,'PG');
				other = getChildValue(item,'OT');
				addressMail = getChildValue(item,'ADE');
				workMail = getChildValue(item,'WKE');
				otherMail = getChildValue(item,'OTE');
				var vcard = {
						'name':name,
						'mobliePhone':mobliePhone,
						'iphone':iphone,
						'address':address,
						'workPhone':workPhone,
						'hPhone':hPhone,
						'adPhone':adPhone,
						'workF':workF,
						'otherF':otherF,
						'ppG':ppG,
						'other':other,
						'addressMail':addressMail,
						'workMail':workMail,
						'otherMail':otherMail
				}
				vcard = new UC_VCRAD(vcard);
			} catch(e) {}
		}
		var microtalk = null;
		if (msgType == 'microtalk') {
	         var items = oMsg.getNode().getElementsByTagName('microtalk');
	            try {
	                var item = items.item(0);
	                var mId = item.getElementsByTagName('id').item(0).firstChild.nodeValue;
	                var mSize = item.getElementsByTagName('size').item(0).firstChild.nodeValue;
	                microtalk = new UC_ATTACHMENT(mId, 'mictalk', mSize);
	            } catch(e) {}
		}
		var msg;
		var time = oMsg._getAttribute('timestamp');
		if (time != null) {
			time = hrTime(time);
		} else {
			time = $.i18n('uc.title.today.js') + parseDateTime();
		}
		if (oMsg.getType() == 'error') {
			user.name = oMsg.getGroupname();
			msg = new UC_MESSAGE(oMsg.getType(), from, oMsg.getGroupname(), oMsg.getUser(), oMsg.getName(), oMsg.getBody(), atts, microtalk, true, time,vcard);
		}else{
			if (from.indexOf('@group') >= 0) {
				user.name = oMsg.getGroupname();
				msg = new UC_MESSAGE(oMsg.getType(), from, oMsg.getGroupname(), oMsg.getUser(), oMsg.getName(), oMsg.getBody(), atts, microtalk, false, time,vcard);
			} else {
				user.name = oMsg.getName();
				msg = new UC_MESSAGE(oMsg.getType(), from, oMsg.getName(), from, oMsg.getName(), oMsg.getBody(), atts, microtalk,false, time,vcard);
			}
		}
		var showMsgBox = true;
		if (winUC && !winUC.closed) {//页签模式聊天已打开
			try {
				if (!winIM || winIM.closed || !winIM.chat.getTab(user.id)) {
					winUC.document.getElementById('ucmain').contentWindow.$('#Uc_Msg').attr('style', 'background:#FDD664');
					winUC.document.getElementById('ucmain').contentWindow.$('#Uc_Msg').addClass('current');
					hasMsg = true;
				}
				var pageChat = winUC.document.getElementById('ucmain').contentWindow.$("li[pageChatJid='" + from + "']");
				var pageChatMore = winUC.document.getElementById('ucmain').contentWindow.$("a[pageChatJid='" + from + "']");
				if (pageChat.length > 0) {
					pageChat.eq(0).find('a').addClass('uc_msg');
	  		    	showMsgBox = false;
	  		    } else if (pageChatMore.length > 0) {
	  		    	winUC.document.getElementById('ucmain').contentWindow.$('#pageChatTabsMore').eq(0).addClass('uc_msg');
	  		    	pageChatMore.addClass('uc_msg');
	  		    	showMsgBox = false;
	  		    }
			} catch (e) {}
		}
		
		if (winIM && !winIM.closed && winIM.chat.getTab(user.id)) {//聊天窗口已打开
			try {
				winIM.putMsgHTML(user.id, msg);
				showMsgBox = false;
				winIM.startUCActionTitle(winIM.ucStandardTitle, $.i18n('uc.title.msg.js', user.name));
			} catch (e) {}
		}

		if (showMsgBox) {
			user.chatmsgs.add(msg);
			var photo = _PhotoMap.get(msg.userjid);
		    var msgFrom = cutResource(oMsg.getFrom());
		    if (photo == null) {
		        var iq = new JSJaCIQ();
                iq.setIQ(msg.userjid, 'get');
                iq.appendNode(iq.buildNode('vcard', {'xmlns' : 'vcard-photo'}));
                con.send(iq, getMemberPhoto, '2');
            }
            showMessage(msg, null, "", isA8geniusMsg ? "genius" : "a8");
		}
	}
	
	
	function getMemberPhoto(iq, type) {
		var photo = v3x.baseURL + "/apps_res/v3xmain/images/personal/pic.gif";
		var item = iq.getNode().getElementsByTagName('photo').item(0);
		if (item && item.firstChild) {
			photo = item.firstChild.nodeValue;
		}
		_PhotoMap.put(iq.getFrom(), photo);
	}

	function handleError(e) {
		switch (e.getAttribute('code')) {
		case '401':
			try {
				console.log("Exception: 401");
			} catch (e) {}
			//$.alert("身份验证失败!");
			//window.close();
			break;
		case '503':
			try {
				console.log("Exception: 503");
			} catch (e) {}
			if (host != outherHost) { 
				if (!outherHost || outherHost == "") { 
					connectionStatus = -4;
				} else { 
					host = outherHost;
					connectionStatus = 0;
					createConnection();
				}
				
			} else { 
				connectionStatus = -4;
			}
			if (connectionStatus == -4) { 
				jid = null;
				if (winUC && !winUC.closed) {
					winUC.alert($.i18n('uc.title.ucnotconnect.2.js'));
				}
				closeUC();
			}
			break;
		case '500':
			try {
				console.log("Exception: 500");
			} catch (e) {}
			break;
		case '600':
			//getA8Top().showLogoutMsg($.i18n("uc.loginUserState.loginAnotherone.js"));
			break;
		default:
			$.alert("An Error Occured:\nCode: " + e.getAttribute('code') + "\nType: " + e.getAttribute('type') + "\nCondition: " + e.firstChild.nodeName);
			break;
		}
	}

	function handleConnected() {
		con.send(new JSJaCPresence());
		connectionStatus = 1;
	}

	function handleDisconnected() {
		if (!isA8Exit) {
			if (host != outherHost) { 
				if (!outherHost || outherHost == "") { 
					connectionStatus = -1;
				} else { 
					host = outherHost;
					connectionStatus = 0;
					createConnection();
				}
				
			} else { 
				connectionStatus = -1;
			}
			
		}
	}

	function initConnection() {
		try {
		    try {
		        console.log("S:" + connectionStatus + ",D:" + ucDisconnect + ",O:" + messageTask.outNumber);
		    } catch (e) {}
		    //重连场景：掉线，切网，人员未同步
		    //不重连场景：UC服务器未启动，IE插件未安装（容易引起服务器连接线程过多）
			if (connectionStatus == -3 || connectionStatus == -5) {
				return;
			}
		    
		    if (connectionStatus == 1 && !ucDisconnect) {
		        return;
		    }
		    
		    ucDisconnect = false;
		    
			ssoManager.loginUC("${CurrentUser.id}", {
	            success: function(result){
					if (!result) {
						connectionStatus = -3;
						return;
					}
		
					status = result['state'];
					if (status == '-1') {
						connectionStatus = -3;
						return;
					} else if (status == '-2') {
						connectionStatus = -2;
						return;
					}
					
					var islocal = result['islocal'];
					host = result['intranetIp'];
					if (!host || host == "") { 
						host = result['extranetIp'];
					}
					outherHost = result['extranetIp'];
					port = result['port'];
					jid = result['jid'];
					pass = result['token'];
					fileSize = result['fileSize'];
					if (islocal == "true") {
						var documentLocation = document.location.href;
						documentLocation = documentLocation.substring(documentLocation.indexOf('//') + 2);
						if (documentLocation.indexOf('/') > -1) {
							documentLocation = documentLocation.substring(0, documentLocation.indexOf('/'));
							if (documentLocation.indexOf(':') > -1) {
								documentLocation = documentLocation.substring(0, documentLocation.indexOf(':'));
							}
						}
						try{
							host =  host.substring(0, host.indexOf('//') + 2) + documentLocation;
							if (host.indexOf("//") < 0) { 
								host = "http://" + host;
							}
						}catch(e){}
					}
					if (!host || !port || !jid) {
						connectionStatus = -1;
						return;
					}
					createConnection();
	            }
	        });
		} catch (e) {
			connectionStatus = -5;
			try {
				console.log("Exception: " + e);
			} catch (e) {}
		}
	}

	function createConnection() {
		try {
			var HTTPBASE = host + ":" + port + "/http-bind/";
			var	JABBERSERVER = jid.substring(jid.indexOf('@') + 1, jid.length);
			var DEFAULTRESOURCE = "web";
			
			roster = new Roster();
			
			var oArgs = {
				httpbase : HTTPBASE,
				timerval : 2000
			};
			
			con = new JSJaCHttpBindingConnection(oArgs);
			con.registerHandler('message', handleMessage);
			con.registerHandler('presence', handlePresence);
			con.registerHandler('iq', handleIQ);
			con.registerHandler('onconnect', handleConnected);
			con.registerHandler('onerror', handleError);
			con.registerHandler('ondisconnect', handleDisconnected);

			oArgs = {
				domain : JABBERSERVER,
				resource : DEFAULTRESOURCE,
				username : jid.substring(0, jid.indexOf('@')),
				pass : pass,
				uchost : host
			};
			con.connect(oArgs);
		} catch (e) {
			connectionStatus = -5;
			try {
				console.log("Exception: " + e);
			} catch (e) {}
		}
	}

	function clickCloseUC() {
		try {
			//关闭聊天窗口
			if (winIM && !winIM.closed) {
				if (confirm($.i18n('uc.title.winImExit.js'))) {
					return true;
				} else {
					return false;
				}
			}
		} catch (e) {}
		return true;
	}

	var ucnotconnectDialog;
	function checkUCStatus() {
		if (connectionStatus != 1) {
			if (connectionStatus == 0) {
				showAlertBox($.i18n('uc.title.ucconnect.js'));
			} else if (connectionStatus == -1 || connectionStatus == -4) {
				showAlertBox($.i18n('uc.title.ucnotconnect.2.js'));
			} else if (connectionStatus == -2) {
				showAlertBox($.i18n('uc.title.notMember.js'));
			} else if (connectionStatus == -3) {
				showAlertBox($.i18n('uc.title.ucnotconnect.1.js'));
			} else if (connectionStatus == -5) {
				if (isA8geniusMsg) {
					alert($.i18n('uc.title.ucnotconnect.4.js'));
				} else {
					if (v3x.isMSIE) {
						ucnotconnectDialog = $.dialog({
				            htmlId: 'ucnotconnect',
				            title: $.i18n('uc.title.ucnotconnect.0.js'),
				            url: "${pageContext.request.contextPath}/genericController.do?ViewPage=apps/uc/downLoadIESet",
				            isClear: false,
				            width: 425,
				            height: 150
				        });
					} else {
						$.alert($.i18n('uc.title.ucnotconnect.2.js'));
					}
				}
			}
			return false;
		}
		return true;
	}
	
	function getUCStatus() {
		if (connectionStatus != 1) {
			if (connectionStatus == 0) {
				return $.i18n('uc.title.ucconnect.js');
			} else if (connectionStatus == -1 || connectionStatus == -4 || connectionStatus == -5) {
				return $.i18n('uc.title.ucnotconnect.2.js');
			} else if (connectionStatus == -2) {
				return $.i18n('uc.title.notMember.js');
			} else if (connectionStatus == -3) {
				return $.i18n('uc.title.ucnotconnect.1.js');
			}
		}
		return '';
	}

	//打开UC中心
	function openWinUC(from, type) {
		if (!checkUCStatus()) {
			return;
		}

		if (!type) {
			type = "msg";
		}
		
		if (winUC && !winUC.closed) {
        	winUC.focus();
        	try {
            	if (type) {
        			winUC.clickAll(type);
                }
            } catch (e) {}
        } else {
            var height = window.screen.availHeight - 40;
            var left = (window.screen.availWidth - 850 - 20) / 2;
        	colseMessageWindow("person", "a8");
        	winUC = window.open(_ctxPath + "/uc/chat.do?method=index&from=" + from + "&showtype=" + type, "", "left=" + left + ",top=0,width=850,height=" + height + ",location=no,menubar=no,resizable=no,scrollbars=no,titlebar=no,toolbar=no,status=no,depended=yes,alwaysRaised=yes");
        }
	}

	
	function openDetailURLByUc(url){
		grtA8Top().openDetailURL(url);
	}
	
	function sendUCMessage(name, memberId) {
		if (!checkUCStatus()) {
			return;
		}
		
		if (_MemberId2Jid.get(memberId)) {
			openWinIM(name, _MemberId2Jid.get(memberId));
		} else {
			getJids(name, memberId);
		}
	}

	function getJids(name, memberId) {
		var iq = newJSJaCIQ();
		iq.setIQ(null, 'get');
		var query = iq.setQuery('jabber:iq:seeyon:office-auto');
		var organization = iq.buildNode('organization', {'xmlns': 'organization:staff:getjid:query'});
		var memberids = iq.buildNode('memberids');
		memberids.appendChild(iq.buildNode('memberid', memberId));
		organization.appendChild(memberids);
		query.appendChild(organization);
		var params= new Properties();
		params.put("name", name);
		params.put("memberId", memberId);
		con.send(iq, handleJids, params);
	}

	function handleJids(iq, params) {
	    var items = iq.getNode().getElementsByTagName('jid');
	    if (!items) {
	        return;
	    }
	    for (var i = 0; i < items.length; i++) {
		    try {
		    	_MemberId2Jid.put(items.item(i).getAttribute('memberid'), items.item(i).firstChild.nodeValue);
			} catch(e){}
	    }
	    if (_MemberId2Jid.get(params.get("memberId"))) {
		    openWinIM(params.get("name"), _MemberId2Jid.get(params.get("memberId")));
		} else {
			$.alert("人员不存在");
		}
	}

	function openWinIM(name, jid){
		//判断是否加载完毕im页面如果没有加载完毕等待1秒在执行函数
		if (isIMonload) {
			openWinIMEscape(name, jid, true);
		} else {
			setTimeout(function (){
				openWinIMEscape(name, jid, true);
			},1000);
		}
	}
	


	//打开聊天窗口
	function openWinIMEscape(name, jid, isEscape){
	    if (name == "all") {
            if (!winIM || winIM.closed) {
                var left = (window.screen.availWidth - 520 - 20) / 2;
                var top = (window.screen.availHeight - 520 - 40) / 2;
                winIM = window.open(_ctxPath + "/uc/chat.do?method=chat&jid=all&from=" + (isA8geniusMsg ? "genius" : "a8"), "", "left=" + left + ",top=" + top + ",width=520,height=520,location=no,menubar=no,resizable=no,scrollbars=no,titlebar=no,toolbar=no,status=no,depended=yes,alwaysRaised=yes");
            } else {
                try {
                    winIM.focus();
                    var chatusers = roster.chatusers;
                    for (var i = 0; i < chatusers.length; i++) {
                        var chatuser = chatusers[i];
                        if (chatuser.chatmsgs.size() > 0) {
                        	winIM.chat.addSingleTab({id:chatuser.id, name:chatuser.name, jid:chatuser.jid});
                            for (var j = 0; j < chatuser.chatmsgs.size(); j++) {
                                winIM.putMsgHTML(chatuser.id, chatuser.chatmsgs.get(j));
                            }
                            chatuser.chatmsgs.clear();
                        }
                    }
                } catch (e) {}
            }
            return;
	    }
	    
		if (roster.DisabledChatUser.get(jid)) {
			alert($.i18n('uc.group.notinfo.js'));
			return;
		}
		
		var user = roster.getChatUserByJID(jid);
		if (user == null) {
			user = roster.addChatUser(jid);
 		}
 		if (name) {
 			if (isEscape) {
 				user.name = name.escapeHTML();
 			} else {
 				user.name = name;
 			}
 	 	}
 		
	    try {
		    //关闭消息提示框
		    var tId = jid.substring(0, jid.indexOf('@'));
		    var tableId = tId + "_Table";
		    ignoreOne(tId);
	    	if ($("#" + tableId).length > 0) {
		    	removeMsgFromBox("person", tableId, tId, isA8geniusMsg ? "genius" : "a8");
		    }
		} catch (e) {}
		
	    if (!winIM || winIM.closed) {
	    	//每次重新打开im页面时将参数表示制成false，加载完毕后制成true
	    	isIMonload = false;
	        var left = (window.screen.availWidth - 520 - 20) / 2;
	        var top = (window.screen.availHeight - 520 - 40) / 2;
	        winIM = window.open(_ctxPath + "/uc/chat.do?method=chat&jid=" + user.jid + "&from=" + (isA8geniusMsg ? "genius" : "a8"), "", "left=" + left + ",top=" + top + ",width=520,height=520,location=no,menubar=no,resizable=no,scrollbars=no,titlebar=no,toolbar=no,status=no,depended=yes,alwaysRaised=yes");
	    } else {
        	try {
		        winIM.focus();
		        if (winIM.chat.getTab(user.id)) {
		            winIM.chat.setCurrentTab(user.id);
		        } else {
		            winIM.chat.addSingleTab({
		                id: user.id,
		                name: user.name,
		                jid: user.jid
		            });
		            
		            if (user.chatmsgs.size() > 0) {
		                for (var i = 0; i < user.chatmsgs.size(); i++) {
		                    winIM.putMsgHTML(user.id, user.chatmsgs.get(i));
		                }
		                user.chatmsgs.clear();
		            }
		        }
            } catch (e) {}
	    }
	}

	var isA8Exit = false;
    function closeUC(){
    	try {
			isA8Exit = true;
			
			//关闭聊天窗口
			if (winIM && !winIM.closed) {
				winIM.close();
			}
			
			//关闭UC中心
			if (winUC && !winUC.closed) {
				winUC.close();
			}
		} catch (e) {}
	}
    
    function showAlertBox(msg) {
    	if (isA8geniusMsg) {
    		alert(msg);
    	} else {
    		$.alert(msg);
    	}
    }
    
    function checkCreateCollBoration (colMembers) {
    	var returnValue = getUCStatus();
    	if (returnValue == '') {
    		if (colMembers.length > 100) {
                returnValue = $.i18n('uc.tab.max300.js');
    		}
    	}
    	return returnValue;
    }
	
	/**
	  * 创建协同讨论组
	  * colId 协同ID
	  * colName 协同标题
	  * colMembers 协同参与人员ID集合
	*/
    function createCollaborationTeam(colMembers , colId , colName) {
    	if (!checkUCStatus()) {
			return;
		}
		
    	var isIncludeUserId = false;
    	if (colMembers.length > 100) {
    		$.alert($.i18n('uc.tab.max300.js'));
    	} else {
        	var memberList = new ArrayList();
        	memberList.addSingle("${CurrentUser.id}");
    		for (var i = 0; i < colMembers.length; i++) {
    			memberList.addSingle(colMembers[i]);
    	    }
    		colName = colName.replace(new RegExp('&nbsp;', 'g'), ' ');
    		var iq = newJSJaCIQ();
    		iq.setFrom(jid);
    	    iq.setIQ('group.localhost', 'get');
    	    var query = iq.setQuery('seeyon:coporaty:group:create');
    	    var groupInfo = iq.buildNode('group_info');
    	    groupInfo.appendChild(iq.buildNode('group_type', '', '5'));
    	    groupInfo.appendChild(iq.buildNode('coporaty_id', '', colId));
    	    groupInfo.appendChild(iq.buildNode('group_name', '', colName));
    	    var groupMembers = iq.buildNode('group_members');
    	    for (var j = 0; j < memberList.size(); j++) {
    	    	groupMembers.appendChild(iq.buildNode('group_member', '', memberList.get(j)));
    	    }
    	    groupInfo.appendChild(iq.buildNode('group_member_num', '', memberList.size()));
    	    groupInfo.appendChild(groupMembers);
    	    query.appendChild(groupInfo);
    	    con.send(iq, createCollaborationResult);
    	}
	}

	/**
	  * 创建协同讨论组结果
	*/
    function createCollaborationResult(iq) {
    	if (iq.getType == 'error') {
    		$.alert($.i18n('uc.group.Notcreate.js'));
    	} else {
        	var groupInfo = iq.getNode().getElementsByTagName('group_info')[0];
    		var groupId = groupInfo.getAttribute('I');
    		var groupName = groupInfo.getAttribute('NA');
    		openWinIMEscape(groupName, groupId,false);
    	}
    }
    
   	function pushOnlineState(onlineStae) {
   		if (getUCStatus() != '') {
			return;
		}
		
		var onlineStatus = "";
		if (onlineStae == "online3") {
			onlineStatus = "busy";
		}
		if (onlineStae == "online1") {
			onlineStatus = "available";
		}
		if (onlineStae == "online2") {
			onlineStatus = "away";
		}
		if (onlineStae == "online4") {
			onlineStatus = "nodisturb";
		}
		
		var presscen = new JSJaCPresence();
		presscen.setType('available');
		presscen.setStatus(onlineStatus);
		presscen.setShow('chat');
		presscen.setPriority('10');
		con.send(presscen, getStateByPush);
   	}
   	
   	function getStateByPush(ps){
   		try {
	   		var status = '';
	   		switch(ps.getStatus()) {
		   		case 'available' : 
		   			status = 1; 
		   			break;
		   		case 'busy' : 
		   			status = 3; 
		   			break;
		   		case 'away' : 
		   			status = 2; 
		   			break;
		   		case 'nodisturb' : 
		   			status = 4; 
		   			break;
		   		default : 
		   			status = 0;		
	   		}
	   		if (winUC && !winUC.closed) {
	   			if (status != 0) {
	   				winUC.document.getElementById('ucmain').contentWindow.$('#onlinState').attr('class', 'ico16 online' + status + ' margin_r_5');
	   				if (winUC.document.getElementById('ucmain').contentWindow.$('#myselfstatus')) {
	   					winUC.document.getElementById('ucmain').contentWindow.$('#myselfstatus').attr('class', 'onlineState ico16 online' + status);
	   				}
	   			}
	   		} else {
	   			//如果uc中心未打开则保存修改的状态
	   			onlineStatus = 'ico16 online' + status;
	   		}
	   	}catch(e){
	
	   	}
   	}
   	
   	function getChildValue (item,name) {
   	    var valueList = new ArrayList();
   		var nodeVal = '';
        if (item.getElementsByTagName(name).length > 0) {
            var nameChild = item.getElementsByTagName(name).item(0).firstChild;
            if (nameChild && typeof(nameChild) != 'undefined') {
            	nodeVal = nameChild.nodeValue;
            	var nodeVals = nodeVal.split(",");
            	for (var i = 0; i < nodeVals.length; i ++) {
            		valueList.add(nodeVals[i]);
            	}
            }
        }
        return valueList;
   	}

</script>