/**
 * 信息的转换
 * 
 * @param iq
 * @returns {Array}
 */
function initMessageByIq(iq) {
	try {
		var messages = new Array();
		if (iq.getType() == 'error') {
			var code = iq.getNode().getElementsByTagName('error')[0]
					.getAttribute('code');
			var from = iq.getFrom();
			if (code == '404') {
				$.alert($.i18n('uc.group.notinfo.js'));
				$('#pageChatTabs').find('li').each(function() {
					var id = $(this).attr('id');
					if (id == from) {
						$(this).find('.pageChatTabsClose')[0].click();

					}
				});
				var items = {
					type : 'error'
				};
				messages[0] = items;
				return messages;
			}
		}
		var message = iq.getNode().getElementsByTagName('message');
		if (message && message.length > 0) {
			var _index = 0;
			for ( var i = 0; i < message.length; i++) {
				var type = message[i].getAttribute('type');
				var name = '匿名好友';
				if (message[i].getElementsByTagName('name').length > 0) {
					if (!name) {
						name = '匿名好友';
					} else {
						name = message[i].getElementsByTagName('name')[0].firstChild.data;
					}

				}
				var toname = '';
				if (message[i].getElementsByTagName('toname').length > 0) {
					if (message[i].getElementsByTagName('toname')[0].firstChild) {
						toname = message[i].getElementsByTagName('toname')[0].firstChild.data;
					}
				}
				var count = 0;
				if (message[i].getElementsByTagName('count').length > 0) {
					count = message[i].getElementsByTagName('count')[0].firstChild.data;
				}
				var time = message[i].getAttribute('timestamp');
				var to = message[i].getAttribute('to');
				var from = message[i].getAttribute('from');
				if (typeof(from) == "undefined" || from == null || from == "") { 
					continue;
				}
				if (typeof(to) == "undefined" || to == null || to == "") { 
					continue;
				}
				from = cutResource(from);
				to = cutResource(to);
				var body = '';
				if (message[i].getElementsByTagName('body').length > 0) {
					body = message[i].getElementsByTagName('body')[0].firstChild;
					if (!body) {
						body = '';
					} else {
						body = message[i].getElementsByTagName('body')[0].firstChild.data;
					}
				}
				body = body.escapeHTML();
				var groupName = '';
				var user = '';
				if (to.indexOf('@group') >= 0) {
					var groupName = '';
					try {
						groupName = message[i]
								.getElementsByTagName('groupname')[0].firstChild;
						if (!groupName) {
							groupName = '未命名组';
						} else {
							groupName = message[i]
									.getElementsByTagName('groupname')[0].firstChild.data;
						}
					} catch (e) {
						groupName = '未命名组';
					}
				}
				if (from.indexOf('@group') >= 0) {
					var groupName = '';
					try {
						groupName = message[i]
								.getElementsByTagName('groupname')[0].firstChild;
						user = message[i].getElementsByTagName('user')[0].firstChild.data;

						if (!groupName) {
							groupName = '未命名组';
						} else {
							groupName = message[i]
									.getElementsByTagName('groupname')[0].firstChild.data;
						}
					} catch (e) {
						groupName = '未命名组';
					}
				}
				if (type == 'filetrans') {
					var fileList = new Array();
					if (message[i].getElementsByTagName('filetrans').length > 0) {
						for (j = 0; j < message[i]
								.getElementsByTagName('filetrans').length; j++) {
							var fileName = message[i]
									.getElementsByTagName('filetrans')[j]
									.getElementsByTagName('name')[0].firstChild.data;
							var fileId = message[i]
									.getElementsByTagName('filetrans')[j]
									.getElementsByTagName('id')[0].firstChild.data
							var size = '';
							if (message[i].getElementsByTagName('filetrans')[j]
									.getElementsByTagName('size')[0].firstChild != null) {
								size = message[i]
										.getElementsByTagName('filetrans')[j]
										.getElementsByTagName('size')[0].firstChild.data
							}
							var files = {
								fileName : fileName,
								fileId : fileId,
								size : size
							};
							fileList[j] = files;
						}
					}
					var items = {
						type : type,
						from : from,
						to : to,
						name : name,
						toname : toname,
						body : body,
						time : time,
						files : fileList,
						user : user,
						groupname : groupName.escapeHTML(),
						count : count
					};
					messages[_index] = items;
				} else if (type == 'filetrans_result') { 
					var fileName = "";
					var status = "";
					if (message[i].getElementsByTagName('filetrans_result').length > 0) { 
						fileName = message[i].getElementsByTagName('filetrans_result')[0].getElementsByTagName('name')[0].firstChild.data;
						status = message[i].getElementsByTagName('filetrans_result')[0].getElementsByTagName('result')[0].firstChild.data;
					}
					body = "对方";
					if (status == "4") { 
						body =  body + $.i18n("uc.msg.fileResult1.js");
					} else if (status == "5") { 
						body =  body + $.i18n("uc.msg.fileResult2.js");
					}
					body = body +  "“"+fileName+"”";
					var items = {
							type : type,
							from : from,
							to : to,
							user : user,
							groupname : groupName.escapeHTML(),
							name : name,
							toname : toname,
							body : body,
							time : time,
							count : count
					};
					messages[_index] = items;
				} else if (type == 'image') {
					var fileList = new Array();
					if (message[i].getElementsByTagName('image').length > 0) {
						for (j = 0; j < message[i]
								.getElementsByTagName('image').length; j++) {
							var fileName = message[i]
									.getElementsByTagName('image')[j]
									.getElementsByTagName('name')[0].firstChild.data;
							var fileId = message[i]
									.getElementsByTagName('image')[j]
									.getElementsByTagName('id')[0].firstChild.data
							var size = '';
							if (message[i].getElementsByTagName('image')[j]
									.getElementsByTagName('size')[0].firstChild != null) {
								size = message[i].getElementsByTagName('image')[j]
										.getElementsByTagName('size')[0].firstChild.data
							}
							var files = {
								fileName : fileName,
								fileId : fileId,
								size : size
							};
							fileList[j] = files;
						}
					}
					var items = {
						type : 'image',
						from : from,
						to : to,
						name : name,
						toname : toname,
						body : body,
						time : time,
						files : fileList,
						user : user,
						groupname : groupName.escapeHTML(),
						count : count
					};
					messages[_index] = items;
				} else if (type == 'microtalk') {
					if (message[i].getElementsByTagName('microtalk').length > 0) {
						var mid = message[i].getElementsByTagName('microtalk')[0]
								.getElementsByTagName('id')[0].firstChild.data;
						var msize = message[i]
								.getElementsByTagName('microtalk')[0]
								.getElementsByTagName('size')[0].firstChild.data;
						var files = {
							fileName : mid + ".amr",
							fileId : mid,
							size : msize
						};
						var fileList = new Array();
						fileList[0] = files;
						var items = {
							type : 'microtalk',
							from : from,
							to : to,
							name : name,
							toname : toname,
							body : body,
							time : time,
							user : user,
							groupname : groupName.escapeHTML(),
							files : fileList,
							count : count
						};
						messages[_index] = items;
					}
				} else if (type == 'vcard') {
					var items = message[i].getElementsByTagName('vcard');
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
					var vcardName = new ArrayList();
					var mobliePhone = new ArrayList();
					vcardName = getChildValueByHis(item, 'N');
					mobliePhone = getChildValueByHis(item, 'MT');
					iphone = getChildValueByHis(item, 'IPH');
					address = getChildValueByHis(item, 'AD');
					workPhone = getChildValueByHis(item, 'WK');
					hPhone = getChildValueByHis(item, 'HE');
					adPhone = getChildValueByHis(item, 'ADF');
					workF = getChildValueByHis(item, 'WKF');
					otherF = getChildValueByHis(item, 'OTF');
					ppG = getChildValueByHis(item, 'PG');
					other = getChildValueByHis(item, 'OT');
					addressMail = getChildValueByHis(item, 'ADE');
					workMail = getChildValueByHis(item, 'WKE');
					otherMail = getChildValueByHis(item, 'OTE');
					var vcard = {
						'name' : vcardName,
						'mobliePhone' : mobliePhone,
						'iphone' : iphone,
						'address' : address,
						'workPhone' : workPhone,
						'hPhone' : hPhone,
						'adPhone' : adPhone,
						'workF' : workF,
						'otherF' : otherF,
						'ppG' : ppG,
						'other' : other,
						'addressMail' : addressMail,
						'workMail' : workMail,
						'otherMail' : otherMail
					}
					var items = {
						type : type,
						from : from,
						to : to,
						user : user,
						groupname : groupName.escapeHTML(),
						name : name,
						toname : toname,
						body : body,
						time : time,
						count : count,
						vcard : vcard
					};
					messages[_index] = items;
				} else {
					var items = {
						type : type,
						from : from,
						to : to,
						user : user,
						groupname : groupName.escapeHTML(),
						name : name,
						toname : toname,
						body : body,
						time : time,
						count : count
					};
					messages[_index] = items;
				}
				_index ++;
			}
		}
		return messages;
	} catch (e) {
		return messages;
	}
}

function getChildValueByHis(item, name) {
	var valueList = new ArrayList();
	var nodeVal = "";
	if (item.getElementsByTagName(name).length > 0) {
		var nameChild = item.getElementsByTagName(name).item(0).firstChild;
		if (nameChild && typeof (nameChild) != 'undefined') {
			nodeVal = nameChild.nodeValue;
			var nodeVals = nodeVal.split(",");
        	for (var i = 0; i < nodeVals.length; i ++) {
        		valueList.add(nodeVals[i]);
        	}
		}
	}
	return valueList;
}
