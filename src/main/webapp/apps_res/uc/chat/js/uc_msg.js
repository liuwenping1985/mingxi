/** **************************************交流*************************************** */
var talkType = '';
var obj = '';
var isFoat = false;
var isFlush = true;
var indexMessages;
var totalPage = 0;
var startNum = 0;
var endNum = 0;
var currentPage = 1;
var _toID = "";
var publicToid = '';
var toName = '';
var timespace = '';
var istotalNum = true;
var _toName = '';
var isflas = true;
var isHistoryFlush = false;
var totalCountByre = '';
var msgHtmlMap = new Properties();
var totalCountByhis = '';
var sendPox = '';
var personPox ='';
var isdeleteMsg = false;
var startNumByMsg = 0;
var endNumsByMsg = 0;
var toMemberList = null;
var sendFileList = new Array();
function queryTalkByIndex() {
	istotalNum = true;
	isflas = true;
	iq = parent.window.opener.newJSJaCIQ();
	iq.setIQ(parent.window.opener.jid, 'get');
	var query = iq.setQuery('recently:msg:query');
	query.appendChild(iq.buildNode('begin_time'));
	query.appendChild(iq.buildNode('type', talkType));
	query.appendChild(iq.buildNode('end_time'));
	query.appendChild(iq.buildNode('count', '', '10'));
	connWin.con.send(iq, cacheCommunication, true);
	isFlush = true;
}

function cacheCommunication(iq, istrueflag) {
	istrueflag = isflas;
	var flag = false;
	if (istrueflag) {
		if (iq.getNode().getElementsByTagName('totalnum').length != 0) {
			startNum = 0;
			var count = iq.getNode().getElementsByTagName('totalnum')[0].firstChild.nodeValue;
			var intCount = parseInt(count);
			totalCountByre = intCount;
			if (intCount % 10 == 0) {
				totalPage = parseInt(intCount / 10);
			} else {
				totalPage = parseInt(intCount / 10 + 1);
			}
			currentPage = 1;
			flag = true;
		}
	}
	indexMessages = initMessageByIq(iq);
	indexMessages = endArraybyIndex(indexMessages);
	if (flag) {
		startNum = 1;
		endNum = startNum + 4;
		if (endNum > indexMessages.legth) {
			endNum = indexMessages.legth;
		}
		flag = false;
	}
	initHistMessage(1, false, true);

}

// window.setInterval("queryTalkByIndex()", 1000 * 30);
function showCommunication(messages) {
	$(".pageChatList").empty();
	var html = "";
	for ( var i = 0; i < messages.length; i++) {
		try {
			if (typeof(messages[i]) == "undefined") {
            	continue;
            }
			var random = Math.floor(Math.random() * 100000000);
			var showName = '';
			var openName = '';
			var showMe = "给你";
			var photo = null;
			var imfrom = '';
			var fromgroup = '';
			var isshowdown = true;
			if (messages[i].to.indexOf('@group') > 0) {
				if (messages[i].from == _CurrentUser_jid) {
					isshowdown = false;
					showMe = "";
				} else {
					showName = "<span class='color_gray'>"
							+ messages[i].name + ":</span>";
				}
				imfrom = messages[i].to;
				openName = messages[i].groupname;
				photo = v3x.baseURL + "/apps_res/uc/chat/image/Group3.jpg";
				var shwogroupName = messages[i].groupname;
				if (shwogroupName.length > 10) {
					shwogroupName = shwogroupName.substr(0, 10) + "...";
				}
				fromgroup += "&nbsp;&nbsp;&nbsp;&nbsp;"
						+ $.i18n('uc.title.fromgroup.js')
						+ "<a onclick=\"parent.window.opener.openWinIM('"
						+ openName + "', '" + imfrom + "')\" title = '"
						+ messages[i].groupname
						+ "'><span class='text_overflow'>" + shwogroupName
						+ "</span></a>";
			} else if (messages[i].from.indexOf('@group') > 0) {
				showName = "<span class='color_gray'>"
						+ messages[i].name + ":</span>";
				imfrom = messages[i].from;
				openName = messages[i].groupname;
				photo = v3x.baseURL + "/apps_res/uc/chat/image/Group3.jpg";
				var shwogroupName = messages[i].groupname;
				if (shwogroupName.length > 10) {
					shwogroupName = shwogroupName.substr(0, 10) + "...";
				}
				fromgroup += "&nbsp;&nbsp;&nbsp;&nbsp;"
						+ $.i18n('uc.title.fromgroup.js')
						+ "<a onclick=\"parent.window.opener.openWinIM('"
						+ openName + "', '" + imfrom + "')\" title = '"
						+ messages[i].groupname
						+ "'><span class='text_overflow'>" + shwogroupName
						+ "</span></a>";
			} else {
				var jids = '';
				if (messages[i].from == _CurrentUser_jid) {
					isshowdown = false;
					showMe = "";
					openName = messages[i].toname;
					jids = messages[i].to;
					imfrom = messages[i].to;
				} else {
					showName = "";
					openName = messages[i].name;
					imfrom = messages[i].from;
					jids = messages[i].from;
				}
				photo = connWin._PhotoMap.get(jids);
				if (!photo) {
					var iq = parent.window.opener.newJSJaCIQ();
					iq.setIQ(jids, 'get');
					iq.appendNode(iq.buildNode('vcard', {
						'xmlns' : 'vcard-photo'
					}));
					connWin.con.send(iq, photoToHTML, random);
				}
			}

			html += '<li class="clearfix border_b_gray margin_t_10 line_height180" onmouseover="showCloseButton('
					+ i + ')">';
			html += ' <div class="color_blue pageChatList_pic">';
			html += '<img class="left" width="48" height="48" id="'
					+ random
					+ 'Img" jid="'
					+ imfrom
					+ '" onmouseover="showPeopleCard(this, false)" onmouseout=\'showPeopleCard_type=false;\' src="'
					+ (photo != null ? photo : '') + '" />';
			html += "<a onclick=\"parent.window.opener.openWinIM('" + openName
					+ "', '" + imfrom
					+ "')\"><span class='margin_t_5' title = '" + openName
					+ "'>" + openName + "</span></a>";
			html += '</div>';
			html += '<div class="over_auto  left_ie6">';

			var body = messages[i].body;
			var oldBody = body;
			var regOld = new RegExp("<br/>","g");
			oldBody = oldBody.replace(regOld, "&#10;");
			var reg1Old=new RegExp("</p>","g");
			oldBody = oldBody.replace(reg1Old, "&#10;");
			
			var type = messages[i].type;
			if (type == 'filetrans' || type == 'image') {
				var str = "";
				var mstr = "";
				for ( var k = 0; k < messages[i].files.length; k++) {
					var fname = messages[i].files[k].fileName;
					if (fname.length > 10) {
						fname = fname.substr(0, 10) + "...";
					}
					var downhtml = "<a href='#'  title='"+$.i18n('uc.title.download.js')+"' id='12232' fid='"
							+ messages[i].files[k].fileId + "''  fname = '"
							+ messages[i].files[k].fileName
							+ " 'onclick='downLoadFile(\""
							+ messages[i].files[k].fileId + "\", \""
							+ messages[i].files[k].fileName + "\", \""
							+ type + "\")'>"
							+ $.i18n('uc.title.download.js') + "</a>";
					if (!isshowdown) {
						downhtml = '';
					}
					if (k != 0) {
						str += "<span class='font_size12'><span class ='"
								+ querySpanClass(messages[i].files[k].fileName)
								+ "' style='cursor: default;'></span><span title='"
								+ messages[i].files[k].fileName + "'>" + fname
								+ "(" + messages[i].files[k].size
								+ "KB)</span>&nbsp;&nbsp;&nbsp;" + downhtml
								+ "&nbsp;&nbsp;&nbsp;</span>";
					} else {
						mstr += "<span style='' class='font_size12'><span class ='"
								+ querySpanClass(messages[i].files[k].fileName)
								+ "' style='cursor: default;'></span><span title='"
								+ messages[i].files[k].fileName
								+ "'>"
								+ fname
								+ "("
								+ messages[i].files[k].size
								+ "KB)</span>&nbsp;&nbsp;&nbsp;"
								+ downhtml
								+ "&nbsp;&nbsp;&nbsp;</span>";
					}
				}
				var fileNames = '';
				if (str != '' || mstr != '') {
					fileNames = "<font color='#888888' class='font_size12'>"
							+ $.i18n('uc.title.sendafile.js')
							+ "</font>"+ mstr;
							
				}
				html += "<p class='chatList_content hand' onclick=\"parent.window.opener.openWinIM('" + openName
				+ "', '" + imfrom
				+ "')\">";
				html += showName;
				var brhtml = "";
				if (body.trim().length > 0) {
					brhtml = "<br/>";
				}
				var reg=new RegExp("<br/>","g");
				body = body.replace(reg, "<p/>");
				if (fileNames != '') {
					if (body.indexOf("<p/>") > 0) {
						body = body.substr(0,body.indexOf("<p/>"));
					}
					body = getMsgLimitLength(body,106);
				} else {
					var firstBody = '';
					var lastBody = '';
					if (body.indexOf("<p/>") > -1) {
						firstBody = body.substr(0,body.indexOf("<p/>"));
						lastBody = body.substr(body.indexOf("<p/>") + 4 ,body.length);
						if (firstBody.getBytesLength() > 220) {
							body = getMsgLimitLength(firstBody,220);
						} else {
							if (lastBody.indexOf("<p/>") > -1) {
								lastBody = lastBody.substr(0,lastBody.indexOf("<p/>"));
								body = firstBody + "<br/>" + getMsgLimitLength(lastBody,106);
							}
						}
					} else {
						body = getMsgLimitLength(body,220);
					}
				}
				for ( var j = 0; j < face_texts_replace.length; j++) {
					body = body.replace(face_texts_replace[j], "<img src='"
							+ v3x.baseURL
							+ "/apps_res/uc/chat/image/face/5_"
							+ (j + 1)
							+ ".gif' code='"
							+ face_texts_replace[j].toString().substr(2,
									face_texts_replace[j].toString().length - 6)
							+ "]' />");
				}
				if (messages[i].files.length <= 1) {
					html += "<span class='font_size12' title='"+oldBody+"'>" + body + brhtml
							+ fileNames + str + "</span>";
				} else {
					html += "<span class='font_size12' title='"+oldBody+"'>" + body + brhtml
							+ fileNames + str + "</span>";
				}

				html += '</p>';
			} else if (type == 'microtalk') {
				var fname = messages[i].files[0].fileName;
				var fid = messages[i].files[0].fileId;
				var size = messages[i].files[0].size;
				html += "<p class='chatList_content' onclick=\"parent.window.opener.openWinIM('" + openName
				+ "', '" + imfrom
				+ "')\">";
				html += showName;
				html += "<span class=\"im_talk1\" onclick =\"downPlayMicTalks('"
						+ fname
						+ "','"
						+ fid
						+ "','"
						+ size
						+ "','"
						+ i
						+ "')\"><span id=\""
						+ i
						+ "clase\" class=\"ico16 speech_read_16 left\" ></span><span class=\"color_gray right\">"
						+ size + "'</span></span>";
				html += '</p>';
			} else if (type == 'vcard') {
				html += "<p class='chatList_content hand' onclick=\"parent.window.opener.openWinIM('" + openName
				+ "', '" + imfrom
				+ "')\">";
				html += showName;
				html +=  showMe + "发送一个名片<br/><br/>";
				html += '</p>';
			} else {
				var reg=new RegExp("<br/>","g");
				body = body.replace(reg, "<p/>");
				var reg1=new RegExp("</p>","g");
				body = body.replace(reg1, "<p/>");
				var firstBody = '';
				var lastBody = '';
				if (body.indexOf("<p/>") > -1) {
					firstBody = body.substr(0,body.indexOf("<p/>"));
					lastBody = body.substr(body.indexOf("<p/>") + 4 ,body.length);
					if (firstBody.getBytesLength() > 220) {
						body = getMsgLimitLength(firstBody,220);
					} else {
						if (firstBody.getBytesLength() > 120) {
							body = firstBody + "...";
						} else {
							if (lastBody.indexOf("<p/>") > -1) {
								var str = lastBody.substr(lastBody.indexOf("<p/>") + 4,lastBody.length);
								lastBody = lastBody.substr(0,lastBody.indexOf("<p/>"));
								body = firstBody + "<br/>" + getMsgLimitLength(lastBody,106);
								if (lastBody.getBytesLength() <= 106 && str.length > 0) {
									body = body + "...";
								}
							}
						}
					}
				} else {
					body = getMsgLimitLength(body,220);
				}
				for ( var j = 0; j < face_texts_replace.length; j++) {
					body = body.replace(face_texts_replace[j], "<img src='"
							+ v3x.baseURL
							+ "/apps_res/uc/chat/image/face/5_"
							+ (j + 1)
							+ ".gif' code='"
							+ face_texts_replace[j].toString().substr(2,
									face_texts_replace[j].toString().length - 6)
							+ "]'  height='15'/>&nbsp;");
				}
				var regx=new RegExp("<p/>","g");
				body = body.replace(regx, "<br/>");
				html += "<p class='chatList_content hand' title='"+oldBody+"' onclick=\"parent.window.opener.openWinIM('" + openName
				+ "', '" + imfrom
				+ "')\">";
				html += showName;
				html += body + "<br/><br/>";
				html += '</p>';
			}
			html += '<p class="font_size12">';
			html += '<span class="left color_gray">' + hrTime(messages[i].time)
					 + '</span>';
			html += '<span class="right" onmouseover=>';
			html += "<a class='margin_r_10 pageChatList_Del hidden' style ='display: none;'  href=\"javascript:deleteMessage('"
					+ messages[i].time
					+ "',true,'"
					+ imfrom
					+ "')\"  id =\"delete"
					+ i
					+ "'\" >"
					+ $.i18n('uc.button.delete.js') + "|</a>";
			html += '<a href="javascript:void(0)" class="pageChatOpen color_blue" tid="'
					+ imfrom + '" jid="' + imfrom + '" name="' + openName
					+ '" time ="' + messages[i].time + '">'
					+ $.i18n('uc.message.Common.js') + '<b>'
					+ parseInt(messages[i].count) + '</b>'
					+ $.i18n('uc.message.seeion.js') + '</a>';
			html += '</span>';
			html += '</p>';

			html += '</div>';
			html += '</li>';

		} catch (e) {

		}
	}
	getA8Top().endProc();
	function photoToHTML(iq, memberId) {
		var photo = v3x.baseURL + "/apps_res/v3xmain/images/personal/pic.gif";
		var item = iq.getNode().getElementsByTagName('photo').item(0);
		if (item && item.firstChild) {
			photo = item.firstChild.nodeValue;
		}
		connWin._PhotoMap.put(iq.getFrom(), photo);
		$('#' + memberId + 'Img').attr("src", photo);
	}

	$(".pageChatList").append(html);

	$('#pageFind').empty();
	var htmlstr = getPageLine(true);
	$('#pageFind').append(htmlstr);

	// 点击添加聊天页签
	$(".pageChatList .pageChatOpen")
			.click(
					function() {
						$("#common_menu li").removeClass("current");
						var _jid = $(this).attr("jid");
						var _id = $(this).attr("tid");
						var _name = $(this).attr("name");
						var _time = $(this).attr("time");
						var _length = $("#pageChatTabs li").length;
						$("#pageChatTabs").show();
						// 判断是否已经打开页签，如果打开激活页签
						for ( var i = 0; i < $("#pageChatTabs li").length; i++) {
							if ($("#pageChatTabs li").eq(i).attr("id") == _id) {
								var _this = $("#pageChatTabs li").eq(i);
								$("#pageChatTabs li").removeClass("current");
								$("#common_menu li").removeClass("current");
								$('#sendFile').html('');
								$('#sendFile').hide();
								$('#MessageInput').empty();
								$('#ids_close').click();
								$('#imgid_close').click();
								clearList();
								if (msgHtmlMap.get(_name) != null
										&& msgHtmlMap.get(_name) != '') {
									$('#MessageInput').html(
											msgHtmlMap.get(_name).nsg);
									if (msgHtmlMap.get(_name).files != null
											&& msgHtmlMap.get(_name).files != '') {
										fileMemberList = msgHtmlMap.get(_name).files.fileMemberList;
										fidList = msgHtmlMap.get(_name).files.fidList;
										filePathList = msgHtmlMap.get(_name).files.filePathList;
										fileSize = msgHtmlMap.get(_name).files.fileSize;
										showFilesHTML($('#sendFile'));
										$('#sendFile').show();
									}
								}
								$(".pageChatArea .pageChatArea_textarea")
										.keyup();
								if ($('#sendFile').html().indexOf('jid') > 0) {
									$(".pageChatArea .pageChatArea_btnSubmit")
											.removeClass(
													"common_button_emphasize common_button_disable")
											.addClass("common_button_emphasize");
								} else {
									$(".pageChatArea .pageChatArea_btnSubmit")
											.removeClass(
													"common_button_emphasize common_button_disable")
											.addClass("common_button_disable");
								}
								saveToName(_name, _time);
								getA8Top().startProc();
								isHistoryFlush = true;
								if (connWin.roster.DeleteUser.get(_jid)) {
									$('#sendCheck')
											.removeClass('common_button');
									$('#sendCheck').hide();
								} else {
									$('#sendCheck')
											.removeClass('common_button')
											.addClass('common_button');
									$('#sendCheck').show();
								}
								queryHistoryMess(_jid, _name);
								$(".pageChatList").hide();
								$(".pageChatArea").show();

								$("#open_chat").unbind().click(
										function() {
											parent.window.opener.openWinIM(
													_this.attr("name"), _this
															.attr("jid"));
										});

								return;
							}
						}
						for ( var i = 0; i < pageChatMoreData.length; i++) {
							if (pageChatMoreData[i].id == _id) {
								$(
										"#pageChatTabsMoreMenuList a[id='"
												+ _id + "']").trigger("click");
								return;
							}
						}

						// 插入页签
						if (_length == 0) {
							$('#sendFile').html('');
							$('#sendFile').hide();
							$('#MessageInput').empty();
							if ($('#sendFile').html().indexOf('jid') > 0) {
								$(".pageChatArea .pageChatArea_btnSubmit")
										.removeClass(
												"common_button_emphasize common_button_disable")
										.addClass("common_button_emphasize");
							} else {
								$(".pageChatArea .pageChatArea_btnSubmit")
										.removeClass(
												"common_button_emphasize common_button_disable")
										.addClass("common_button_disable");
								$(".pageChatArea .pageChatArea_textarea")
										.keyup();
							}
							saveToName(_name, _time);
							$('#ids_close').click();
							$('#imgid_close').click();
							if (connWin.roster.DeleteUser.get(_jid)) {
								$('#sendCheck').removeClass('common_button');
								$('#sendCheck').hide();
							} else {
								$('#sendCheck').removeClass('common_button')
										.addClass('common_button');
								$('#sendCheck').show();
							}
							clearList();
							getA8Top().startProc();
							isHistoryFlush = true;
							queryHistoryMess(_jid, _name);
							$("#pageChatTabs ul")
									.html(
											"<li name=\""
													+ _name
													+ "\" id=\""
													+ _id
													+ "\"  pageChatJid=\""
													+ _jid
													+ "\" jid=\""
													+ _jid
													+ "\" class=\"current display_block left\"><a hidefocus=\"true\" href=\"javascript:void(0)\" class=\"text_overflow\" title=\""
													+ _name
													+ "\"><span class=\"ico16 send_messages_16 margin_r_5\"></span>"
													+ _name
													+ "</a><span class='pageChatTabsClose_box'><span class='pageChatTabsClose'><span class=\"ico16 for_close_16\"></span></span></span></li>");
							$(".pageChatList").hide();
							$(".pageChatArea").show();
						} else {
							if (1 <= _length && _length <= 2) {
								if (toName != '' && toName != null) {
									var filesItem = '';
									if ($('#sendFile').html().indexOf('jid') > 0) {
										filesItem = {
											fileMemberList : fileMemberList,
											fidList : fidList,
											filePathList : filePathList,
											fileSize : 1
										}
									}
									var item = {
										msg : $('#MessageInput').html(),
										files : filesItem
									};
									msgHtmlMap.put(toName, item);
								}
								$('#ids_close').click();
								$('#imgid_close').click();
								clearList();
								if (msgHtmlMap.get(_name) == null
										|| msgHtmlMap.get(_name) == '') {
									$('#sendFile').html('');
									$('#sendFile').hide();
									$('#MessageInput').empty();
								} else {
									$('#MessageInput').html(
											msgHtmlMap.get(_name).msg);
									if (msgHtmlMap.get(_name).files != null
											&& msgHtmlMap.get(_name).files != '') {
										fileMemberList = msgHtmlMap.get(_name).files.fileMemberList;
										fidList = msgHtmlMap.get(_name).files.fidList;
										filePathList = msgHtmlMap.get(_name).files.filePathList;
										fileSize = msgHtmlMap.get(_name).files.fileSize;
										showFilesHTML($('#sendFile'));
										$('#sendFile').show();
									}
								}
								saveToName(_name, _time);
								if ($('#sendFile').html().indexOf('source') > 0) {
									$(".pageChatArea .pageChatArea_btnSubmit")
											.removeClass(
													"common_button_emphasize common_button_disable")
											.addClass("common_button_emphasize");
								} else {
									$(".pageChatArea .pageChatArea_btnSubmit")
											.removeClass(
													"common_button_emphasize common_button_disable")
											.addClass("common_button_disable");
									$(".pageChatArea .pageChatArea_textarea")
											.keyup();
								}
								if (connWin.roster.DeleteUser.get(_jid)) {
									$('#sendCheck')
											.removeClass('common_button');
									$('#sendCheck').hide();
								} else {
									$('#sendCheck')
											.removeClass('common_button')
											.addClass('common_button');
									$('#sendCheck').show();
								}
								getA8Top().startProc();
								isHistoryFlush = true;
								queryHistoryMess(_jid, _name);
								$("#pageChatTabs li").removeClass("current");
								$("#pageChatTabs li:first")
										.before(
												"<li name=\""
														+ _name
														+ "\" id=\""
														+ _id
														+ "\"  pageChatJid=\""
														+ _jid
														+ "\"  jid=\""
														+ _jid
														+ "\" class=\"current display_block left\"><a hidefocus=\"true\" href=\"javascript:void(0)\" class=\"border_b text_overflow\" title=\""
														+ _name
														+ "\"><span class=\"ico16 send_messages_16 margin_r_5\"></span>"
														+ _name
														+ "</a><span class='pageChatTabsClose_box'><span class='pageChatTabsClose'><span class=\"ico16 for_close_16\"></span></span></span></li>");
								$(".pageChatList").hide();
								$(".pageChatArea").show();
							} else {
								if ($("#pageChatTabs li:last a").attr("id") != "pageChatTabsMore") {
									$("#pageChatTabs li a").removeClass(
											"last_tab");
									$("#pageChatTabs li:last")
											.after(
													"<li><a id=\"pageChatTabsMore\" hidefocus=\"true\" href=\"javascript:void(0)\" class=\"last_tab more\">更多<span class=\"ico16 arrow_1_b\"></span></a></li>");
								}
								// 生成下拉列表
								pageChatMoreData
										.unshift({
											id : _id,
											name : "<span class=\"ico16 send_messages_16 margin_r_5\"></span>"
													+ _name,
											customAttr : "jid='" + _jid
													+ "' name='" + _name
													+ "' pageChatJid='" + _jid
													+ "'"
										});
								pageChatMore(pageChatMoreData);
							}
						}
						// /绑定页签切换事件
						$("#pageChatTabs li")
								.unbind()
								.click(
										function() {
											if (!isdeleteMsg) {
												if (toName != ''
														&& toName != null) {
													var filesitems = '';
													if ($('#sendFile').html()
															.indexOf('jid') > 0) {
														filesitems = {
															fileMemberList : fileMemberList,
															fidList : fidList,
															filePathList : filePathList,
															fileSize : 1
														};
													}
													var item = {
														msg : $('#MessageInput')
																.html(),
														files : filesitems
													};
													msgHtmlMap
															.put(toName, item);
												}
											} else {
												isdeleteMsg = false;
											}
											if ($(this).attr("id")) {
												var name = $(this).attr("name");
												toName = name;
												var jid = $(this).attr("jid");
												$("#pageChatTabs li")
														.removeClass("current")
														.removeClass("border_b");
												$("#common_menu li")
														.removeClass("current");
												$(this).addClass("current")
														.find("a").addClass(
																"border_b");
												$('#sendFile').html('');
												$('#sendFile').hide();
												$('#MessageInput').empty();
												$('#ids_close').click();
												$('#imgid_close').click();
												clearList();
												if (msgHtmlMap.get(name) != ''
														&& msgHtmlMap.get(name) != null) {
													$('#MessageInput')
															.html(
																	msgHtmlMap
																			.get(name).msg);
													if (msgHtmlMap.get(name).files != null
															&& msgHtmlMap
																	.get(name).files != '') {
														fileMemberList = msgHtmlMap
																.get(name).files.fileMemberList;
														fidList = msgHtmlMap
																.get(name).files.fidList;
														filePathList = msgHtmlMap
																.get(name).files.filePathList;
														fileSize = msgHtmlMap
																.get(name).files.fileSize;
														showFilesHTML($('#sendFile'));
														$('#sendFile').show();
													}
												}
												if ($('#sendFile').html()
														.indexOf('jid') > 0) {
													$(
															".pageChatArea .pageChatArea_btnSubmit")
															.removeClass(
																	"common_button_emphasize common_button_disable")
															.addClass(
																	"common_button_emphasize");
												} else {
													$(
															".pageChatArea .pageChatArea_btnSubmit")
															.removeClass(
																	"common_button_emphasize common_button_disable")
															.addClass(
																	"common_button_disable");
													$(
															".pageChatArea .pageChatArea_textarea")
															.keyup();
												}
												if (connWin.roster.DeleteUser
														.get($(this)
																.attr("jid"))) {
													$('#sendCheck')
															.removeClass(
																	'common_button');
													$('#sendCheck').hide();
												} else {
													$('#sendCheck')
															.removeClass(
																	'common_button')
															.addClass(
																	'common_button');
													$('#sendCheck').show();
												}
												getA8Top().startProc();
												isHistoryFlush = true;
												$(this).find('a').eq(0)
														.removeClass('uc_msg');
												queryHistoryMess($(this).attr(
														"jid"), $(this).attr(
														"name"));
												$(".pageChatList").hide();
												$(".pageChatArea").show();

												$("#open_chat")
														.unbind()
														.click(
																function() {
																	parent.window.opener
																			.openWinIM(
																					name,
																					jid);
																});
											}
										}).mouseenter(function() {
									$(this).find(".pageChatTabsClose").show();
								}).mouseleave(function() {
									$(this).find(".pageChatTabsClose").hide();
								});

						$("#open_chat").unbind().click(function() {
							parent.window.opener.openWinIM(_name, _jid);
						});

						// 页签关闭操作
						$("#pageChatTabs li .pageChatTabsClose")
								.unbind()
								.click(
										function() {
											var delteName = $(this).parents(
													"li").attr('name');
											isdeleteMsg = true;
											if (delteName != null
													&& delteName != '') {
												msgHtmlMap.remove(delteName);
											}

											// 页签只有一个的情况
											if ($("#pageChatTabs li").length == 1) {
												$("#pageChatTabs").attr('style','display:none;');
												$(this).parents("li").remove();
												$("#all_msg").trigger("click");
												return;
											}
											// 多页签，但是没有更多的情况
											if (pageChatMoreData.length == 0) {
												$(this).parents("li").remove();
												$("#pageChatTabs li:last a")
														.addClass("last_tab");
												$("#pageChatTabs li:first")
														.trigger("click");
												return;
											}
											// var indexNumber =
											// $("#pageChatTabs
											// li").indexof($(this).parents("li"));
											// 多页签，并且有更多的情况
											if (pageChatMoreData.length > 0) {
												var obj = $(this).parents("li");// 当前click的li的DOM对象
												var simplemenuObj = $('#pageChatTabsMoreMenuList a:eq(0)');// 下拉列表的第1个DOM对象
												// 获取下拉列表第1项的内容，赋给当前click页签，并移动位置
												obj.attr("id", simplemenuObj
														.attr("id"));
												obj.find("a").html(
														simplemenuObj.html());
												obj.attr("jid", simplemenuObj
														.attr("jid"));
												obj.attr("name", simplemenuObj
														.attr("name"));
												obj.find("a").attr(
														"title",
														simplemenuObj
																.attr("name"));
												obj
														.attr(
																"pageChatJid",
																simplemenuObj
																		.attr("pageChatJid"));
												if (obj.index() != 2) {
													$("#pageChatTabs li:eq(2)")
															.after(obj);
												}
												// 判断下拉列表删除后的显示
												if (pageChatMoreData.length == 1) {
													// 下拉列表为空，删除更多按钮
													$("#pageChatTabs li:last")
															.remove();
													$("#pageChatTabs li:last a")
															.addClass(
																	"last_tab");
												} else {
													// 更新下拉列表
													pageChatMoreData.shift();
													pageChatMore(pageChatMoreData);
												}
											}
										})
								.mouseenter(
										function() {
											$(this)
													.find(".ico16")
													.removeClass(
															"for_close_16 hover_close_16")
													.addClass("hover_close_16");
										})
								.mouseleave(
										function() {
											$(this)
													.find(".ico16")
													.removeClass(
															"for_close_16 hover_close_16")
													.addClass("for_close_16");
										});
						if (pageChatMoreData.length > 0) {
							$("#pageChatTabsMoreMenuList a[id='" + _id + "']")
									.trigger("click");
						}
					});
}

function getCommunication() {
	isflas = true;
	var iq = parent.window.opener.newJSJaCIQ();
	iq.setIQ(_CurrentUser_jid, 'get');
	var query = iq.setQuery('recently:msg:query');
	query.appendChild(iq.buildNode('begin_time'));
	query.appendChild(iq.buildNode('type'));
	query.appendChild(iq.buildNode('end_time'));
	query.appendChild(iq.buildNode('count', '', '10'));
	connWin.con.send(iq, cacheCommunication, true);
}
function ontimeQueryMess() {
	queryHistoryMess(_toID, _toName);
}

// window.setInterval("ontimeQueryMess()", 1000 * 30);

function queryHistoryMess(toId, toName) {
	//清空消息提示
	var tId = toId.substring(0, toId.indexOf('@'));
	connWin.ignoreOne(tId);
	//---------------//
	istotalNum = true;
	_toID = toId;
	_toName = toName;
	publicToid = toId;
	isFlush = false;
	var uid = parent.window.opener.jid;
	var iq = parent.window.opener.newJSJaCIQ();
	iq.setFrom(uid);
	iq.setIQ(cutResource(toId), 'get', 'history_msg');
	var query = iq.setQuery('history:msg:query');
	query.appendChild(iq.buildNode('begin_time'));
	query.appendChild(iq.buildNode('end_time'));
	query.appendChild(iq.buildNode('count', '10'));
	connWin.con.send(iq, showIndexHistMessage, true);
}

function saveToName(name, time) {
	timespace = time, toName = name;
}

function showIndexHistMessage(iq, flahg) {
	istotalNum = flahg;
	var flag = false;
	if (iq.getNode().getElementsByTagName('totalnum').length != 0) {
		if (istotalNum) {
			startNum = 0;
			var count = iq.getNode().getElementsByTagName('totalnum')[0].firstChild.nodeValue;
			var intCount = parseInt(count);
			totalCountByhis = intCount;
			if (intCount % 10 == 0) {
				totalPage = parseInt(intCount / 10);
			} else {
				totalPage = parseInt(intCount / 10 + 1);
			}
			currentPage = 1;
			flag = true;
		}
	}
	var newArrays = initMessageByIq(iq);
	if (newArrays.length > 0) {
		if (newArrays[0].type == 'error') {
			getA8Top().endProc();
			deleteMessage(timespace, false);
			return;
		}
	}
	indexMessages = newArrays;
	if (flag) {
		startNum = 1;
		endNum = startNum + 4;
		if (endNum > indexMessages.legth) {
			endNum = indexMessages.legth;
		}
		flag = false;
	}
	initHistMessage(currentPage, false, false);
}

function initHistMessage(num, isPage, isPorte) {
	var startLeng = 0;
	if (isPage) {
		if (num > 5) {
			startLeng = (num - 5 - 1) * 20;
		} else {
			startLeng = (num - 1) * 20;
		}
		var endLeng = startLeng + 20;
		var newMessage = indexMessages.slice(0, 10);
		return newMessage;
	} else {
		var startLeng = (num - startNum) * 20;
		var endLeng = startLeng + 20;
		var newMessage = indexMessages.slice(0, 10);
		if (isPorte) {
			showCommunication(newMessage);
		} else {
			appendHistoryMessage(newMessage);
		}
	}
}

function stopEventUp(oevent) {
	if (oevent && oevent.stopPropagation) {
		oevent.stopPropagation();
	} else {
		window.event.cancelBubble = true;
	}
}
$(".pageChatArea li").find('.pageChatAreaMy_content').live("click", function() {
	var type = $(this).attr('ftype');
	if (type == 'microtalk') {
		var fname = $(this).attr('fname');
		var fsize = $(this).attr('fsize');
		var fid = $(this).attr('fid');
		var fi = $(this).attr('fi');
		downPlayMicTalk(fname, fid, fsize, fi);
	} else {
		return;
	}
});

function appendHistoryMessage(historyMessage) {
	var defaultphoto = v3x.baseURL
			+ "/apps_res/v3xmain/images/personal/pic.gif";
	$('#myPhotos')[0].src = _CurrentUser.photo;
	$('#history_message').empty();
	var historyMessStr = "";
	for ( var i = 0; i < historyMessage.length; i++) {
		var items = historyMessage[i];
		if (typeof(items) == "undefined") {
        	continue;
        }
		var type = items.type;
		var body = items.body;
		var photo = '';
		for ( var j = 0; j < face_texts_replace.length; j++) {
			body = body.replace(face_texts_replace[j], "<img src='"
					+ v3x.baseURL
					+ "/apps_res/uc/chat/image/face/5_"
					+ (j + 1)
					+ ".gif' code='"
					+ face_texts_replace[j].toString().substr(2,
							face_texts_replace[j].toString().length - 6)
					+ "]' />");
		}
		var datetime = hrTime(items.time);
		var random = Math.floor(Math.random() * 100000000);
		var isShowClose = true;
		if (items.to.indexOf('@group') > 0) {
			isShowClose = false;
		}
		if (items.from == _CurrentUser_jid) {
			photo = _CurrentUser.photo;
			if (!photo) {
				var iq = parent.window.opener.newJSJaCIQ();
				iq.setIQ(items.from, 'get');
				iq.appendNode(iq.buildNode('vcard', {
					'xmlns' : 'vcard-photo'
				}));
				connWin.con.send(iq, flushPhoto, random);
			}
			if (type == 'filetrans') {
				historyMessStr += "<li class='pageChatAreaMy'>";
				historyMessStr += "<img class='pageChatAreaMy_img radius' width='48' height='48' src='"
						+ (photo != null ? photo : '')
						+ "' id='"
						+ random
						+ "img' jid='"
						+ items.from
						+ "' onmouseover='showPeopleCard(this, false)' onmouseout='showPeopleCard_type=false;' /><span class='pageChatAreaArrowRight'></span>";
				historyMessStr += "<div class='pageChatAreaMy_content' style='width: 640.03px; float: right;'>";
				if (isShowClose) {
					historyMessStr += '<span class="pageChatAreaListClose"><span class="pageChatAreaListClose_box"><span class="ico16 for_close_16" dt="'
							+ items.time
							+ '" from = "'
							+ items.from
							+ '" to ="' + items.to + '"></span></span></span>';
				}
				var str = "";
				var mstr = "";
				for ( var k = 0; k < items.files.length; k++) {
					var fnames = items.files[k].fileName;
					if (fnames.length > 10) {
						fnames = fnames.substr(0, 10) + "....";
					}
					if (k == 0) {
						mstr += "<span class=''><span class ='"
								+ querySpanClass(items.files[k].fileName)
								+ "' style='cursor: default;'></span><span class='font_size12' title='"
								+ items.files[k].fileName + "'\>" + fnames
								+ "(" + items.files[k].size
								+ "KB)</span>&nbsp;&nbsp;&nbsp; </span><br/>";
					} else {
						str += "<span ><span class ='"
								+ querySpanClass(items.files[k].fileName)
								+ "' style='cursor: default;'></span><span class='font_size12' title='"
								+ items.files[k].fileName + "'>" + fnames + "("
								+ items.files[k].size
								+ "KB)</span>&nbsp;&nbsp;&nbsp;</span><br/>";
					}
				}
				var fileNames = '';
				if (str != '' || mstr != '') {
					fileNames = "<div width='80px' style='' class='font_size12'><font  color='#888888'>"
							+ $.i18n('uc.title.sendafile.js')
							+ "</font></div>"
							+ mstr;
				}
				if (body.length > 0 && body != '') {
					body = body + "<br/>";
				}
				historyMessStr += "<span class='font_size12'><font color='#888888'>"
						+ items.name
						+ ":</font></span><p class='font_size12' style='word-wrap:break-word'><span class='font_size12'>"
						+ body + fileNames + str + "</span></p>";
				historyMessStr += "<p class='font_size12 color_gray'>"
						+ datetime + "</p></div> </li>";
			} else if (type == 'microtalk') {
				var size = items.files[0].size;
				var fname = items.files[0].fileName;
				var fid = items.files[0].fileId;
				var msize = size;
				if (size < 10) {
					size = 1;
				} else if (size < 20) {
					size = 2;
				} else if (size < 30) {
					size = 3;
				} else if (size < 40) {
					size = 4;
				} else if (size < 50) {
					size = 5;
				} else {
					size = 6;
				}
				historyMessStr += "<li class='pageChatAreaMy'>";
				historyMessStr += "<img class='pageChatAreaMy_img radius' width='48' height='48' src='"
						+ (photo != null ? photo : defaultphoto)
						+ "' id='"
						+ random
						+ "img' jid='"
						+ items.from
						+ "' onmouseover='showPeopleCard(this, false)' onmouseout='showPeopleCard_type=false;'/><span class='pageChatAreaArrowRight'></span>";
				if (datetime.length > 10) {
					if (size < 3) {
						size = 3;
					}
				}
				historyMessStr += "<div class='pageChatAreaMy_content speech_w_"
						+ size
						+ "' ftype='microtalk' fname='"
						+ fname
						+ "' fid='"
						+ fid
						+ "' fsize='"
						+ msize
						+ "' fi='"
						+ i
						+ "'>";
				if (isShowClose) {
					historyMessStr += '<span class="pageChatAreaListClose"><span class="pageChatAreaListClose_box"><span class="ico16 for_close_16" dt="'
							+ items.time
							+ '" from = "'
							+ items.from
							+ '" to ="' + items.to + '"></span></span></span>';
				}
				historyMessStr += "<p class='speech_height'>";
				historyMessStr += " <span class='left font_size12 color_gray'>";
				historyMessStr += "<span class='speech_time_box'><span>"
						+ msize + "'</span></span>" + datetime;
				historyMessStr += "</span>";
				historyMessStr += " <span class='right'>";
				historyMessStr += "<span id=\""
						+ i
						+ "clas\" class='ico16 speech_unread_16' ></span><span class='color_blue' onclick ='stopEventUp(event)'>&nbsp;"
						+ items.name + "</span>";
				historyMessStr += " </span></p></div>";
				historyMessStr += "</li>";
			} else if (type == 'vcard') {
            	var vcard = items.vcard;
            	var vcardStr = "<b style='font-weight: bold;'>"+$.i18n('uc.message.vcard.js')+"</b><br/>";
            	if (vcard && vcard.name != '') {
            		vcardStr += addBrByMsg($.i18n('uc.message.name.js'),vcard.name);
            	}
                if (vcard && vcard.mobliePhone != '') {
                	vcardStr += addBrByMsg($.i18n('uc.message.Mobiletelephone.js') ,vcard.mobliePhone);
                }
                if (vcard && vcard.iphone != '') {
                	 vcardStr += addBrByMsg($.i18n('uc.message.iphone.js') ,vcard.iphone);
                }
                if (vcard && vcard.address != '') {
                	vcardStr += addBrByMsg($.i18n('uc.message.HomePhone.js') ,vcard.address);
                }
                if (vcard && vcard.workPhone != '') {
                	vcardStr += addBrByMsg($.i18n('uc.message.workPhone.js') ,vcard.workPhone);
                }
                if (vcard && vcard.hPhone != '') {
                	vcardStr += addBrByMsg($.i18n('uc.message.mainphone.js') ,vcard.hPhone);
                }
                if (vcard && vcard.adPhone != '') {
                	vcardStr += addBrByMsg($.i18n('uc.message.HomeFax.js') ,vcard.adPhone);
                }
                if (vcard && vcard.workF != '') {
                	vcardStr += addBrByMsg($.i18n('uc.message.WorkFax.js') ,vcard.workF);
                }
                if (vcard && vcard.ppG != '') {
                	vcardStr += addBrByMsg($.i18n('uc.message.Paging.js'),vcard.ppG);
                }
				historyMessStr += "<li class='pageChatAreaMy'>";
				historyMessStr += "<img class='pageChatAreaMy_img radius' width='48' height='48' src='"
						+ (photo != null ? photo : defaultphoto)
						+ "' id='"
						+ random
						+ "img' jid='"
						+ items.from
						+ "' onmouseover='showPeopleCard(this, false)' onmouseout='showPeopleCard_type=false;' /><span class='pageChatAreaArrowRight'></span>";
				historyMessStr += "<div class='pageChatAreaMy_content' style='width: 640.03px; float: right;'>";
				if (isShowClose) {
					historyMessStr += '<span class="pageChatAreaListClose"><span class="pageChatAreaListClose_box"><span class="ico16 for_close_16" dt="'
							+ items.time
							+ '" from = "'
							+ items.from
							+ '" to ="' + items.to + '"></span></span></span>';
				}
				historyMessStr += "<span class='font_size12'><font color='#888888'>"
						+ items.name
						+ ":</font></span><p class='font_size12' style='word-wrap:break-word'><span class='font_size12'>"
						+ vcardStr + "</span></p>";
				historyMessStr += "<p class='font_size12 color_gray'>"
						+ datetime + "</p></div> </li>";
			} else if (type == 'image') {
				historyMessStr += "<li class='pageChatAreaMy'>";
				historyMessStr += "<img class='pageChatAreaMy_img radius' width='48' height='48' src='"
						+ (photo != null ? photo : '')
						+ "' id='"
						+ random
						+ "img' jid='"
						+ items.from
						+ "' onmouseover='showPeopleCard(this, false)' onmouseout='showPeopleCard_type=false;' /><span class='pageChatAreaArrowRight'></span>";
				historyMessStr += "<div class='pageChatAreaMy_content' style='width: 640.03px; float: right;'>";
				if (isShowClose) {
					historyMessStr += '<span class="pageChatAreaListClose"><span class="pageChatAreaListClose_box"><span class="ico16 for_close_16" dt="'
							+ items.time
							+ '" from = "'
							+ items.from
							+ '" to ="' + items.to + '"></span></span></span>';
				}
				var str = "";
				var mstr = "";
				for ( var k = 0; k < items.files.length; k++) {
					var fnames = items.files[k].fileName;
					if (fnames.length > 10) {
						fnames = fnames.substr(0, 10) + "....";
					}
					if (k == 0) {
						mstr += "<span class=''><span class ='"
								+ querySpanClass(items.files[k].fileName)
								+ "' style='cursor: default;'></span><span class='font_size12' title='"
								+ items.files[k].fileName + "'\>" + fnames
								+ "(" + items.files[k].size
								+ "KB)</span>&nbsp;&nbsp;&nbsp; </span><br/>";
					} else {
						str += "<span ><span class ='"
								+ querySpanClass(items.files[k].fileName)
								+ "' style='cursor: default;'></span><span class='font_size12' title='"
								+ items.files[k].fileName + "'>" + fnames + "("
								+ items.files[k].size
								+ "KB)</span>&nbsp;&nbsp;&nbsp;</span><br/>";
					}
				}
				var fileNames = '';
				if (str != '' || mstr != '') {
					fileNames = "<div width='80px' style='' class='font_size12'><font  color='#888888'>"
							+ $.i18n('uc.title.sendafile.js')
							+ "</font></div>"
							+ mstr;
				}
				if (body.length > 0 && body != '') {
					body = body + "<br/>";
				}
				historyMessStr += "<span class='font_size12'><font color='#888888'>"
						+ items.name
						+ ":</font></span><p class='font_size12' style='word-wrap:break-word'><span class='font_size12'>"
						+ body + fileNames + str + "</span></p>";
				historyMessStr += "<p class='font_size12 color_gray'>"
						+ datetime + "</p></div> </li>";
			} else {
				historyMessStr += "<li class='pageChatAreaMy'>";
				historyMessStr += "<img class='pageChatAreaMy_img radius' width='48' height='48' src='"
						+ (photo != null ? photo : defaultphoto)
						+ "' id='"
						+ random
						+ "img' jid='"
						+ items.from
						+ "' onmouseover='showPeopleCard(this, false)' onmouseout='showPeopleCard_type=false;' /><span class='pageChatAreaArrowRight'></span>";
				historyMessStr += "<div class='pageChatAreaMy_content' style='width: 640.03px; float: right;'>";
				if (isShowClose) {
					historyMessStr += '<span class="pageChatAreaListClose"><span class="pageChatAreaListClose_box"><span class="ico16 for_close_16" dt="'
							+ items.time
							+ '" from = "'
							+ items.from
							+ '" to ="' + items.to + '"></span></span></span>';
				}
				historyMessStr += "<span class='font_size12'><font color='#888888'>"
						+ items.name
						+ ":</font></span><p class='font_size12' style='word-wrap:break-word'><span class='font_size12'>"
						+ body + "</span></p>";
				historyMessStr += "<p class='font_size12 color_gray'>"
						+ datetime + "</p></div> </li>";
			}
		} else {
			photo = connWin._PhotoMap.get(items.from);
			if (!photo) {
				var iq = parent.window.opener.newJSJaCIQ();
				iq.setIQ(items.from, 'get');
				iq.appendNode(iq.buildNode('vcard', {
					'xmlns' : 'vcard-photo'
				}));
				connWin.con.send(iq, flushPhoto, random);
			}
			if (type == 'filetrans' || type == 'image') {
				historyMessStr += "<li class='pageChatAreaOther'>";
				historyMessStr += "<img class='pageChatAreaOther_img radius' width='48' height='48' src='"
						+ (photo != null ? photo : defaultphoto)
						+ "' id='"
						+ random
						+ "img' jid='"
						+ items.from
						+ "' onmouseover='showPeopleCard(this, false)' onmouseout='showPeopleCard_type=false;'/><span class='pageChatAreaArrowLeft'></span>";
				historyMessStr += "<div class='pageChatAreaMy_content' style='width:640.03px;'>";
				if (isShowClose) {
					historyMessStr += '<span class="pageChatAreaListClose"><span class="pageChatAreaListClose_box"><span class="ico16 for_close_16" dt="'
							+ items.time
							+ '" from = "'
							+ items.from
							+ '" to ="' + items.to + '"></span></span></span>';
				}
				var str = "";
				var mstr = "";
				for (k = 0; k < items.files.length; k++) {
					var fnames = items.files[k].fileName;
					if (fnames.length > 10) {
						fnames = fnames.substr(0, 10) + "....";
					}
					if (k == 0) {
						mstr += "<span ><span class ='"
								+ querySpanClass(items.files[k].fileName)
								+ "' style='cursor: default;'></span><font size ='2px'><span title='"
								+ items.files[k].fileName
								+ "'>"
								+ fnames
								+ "("
								+ items.files[k].size
								+ "KB)</span>&nbsp;&nbsp;&nbsp;<a href='#'   fid='"
								+ items.files[k].fileId + "''  fname = '"
								+ items.files[k].fileName
								+ " 'onclick='downLoadFile(\""
								+ items.files[k].fileId + "\", \""
								+ items.files[k].fileName + "\", \""
								+ type + "\")'>"
								+ $.i18n('uc.title.download.js')
								+ "</a> </font></span>";
					} else {
						str += "<span ><span class ='"
								+ querySpanClass(items.files[k].fileName)
								+ "' style='cursor: default;'></span><font size ='2px'><span title='"
								+ items.files[k].fileName
								+ "'>"
								+ fnames
								+ "("
								+ items.files[k].size
								+ "KB)</span>&nbsp;&nbsp;&nbsp;<a href='#'   fid='"
								+ items.files[k].fileId + "''  fname = '"
								+ items.files[k].fileName
								+ " 'onclick='downLoadFile(\""
								+ items.files[k].fileId + "\", \""
								+ items.files[k].fileName + "\")'>"
								+ $.i18n('uc.title.download.js')
								+ "</a> </font></span><br/>";
					}
				}
				var fileNames = '';
				if (str != '' || mstr != '') {
					fileNames = "<div width='80px;' class='font_size12'><font size='2px' color='#888888'>"
							+ $.i18n('uc.title.sendafiletoyou.js')
							+ "</font></div>" + mstr;
				}
				if (body.length > 0 && body != '') {
					body = body + "<br/>";
				}
				historyMessStr += "<span class='font_size12'><a onclick = \"parent.window.opener.openWinIM('"
						+ items.name
						+ "', '"
						+ items.from
						+ "')\">"
						+ items.name
						+ ":</a></span><p><span class='font_size12'>"
						+ body
						+ fileNames + str + "</span></p>";
				historyMessStr += "<p class='font_size12 color_gray'>"
						+ datetime + "</p> </div></li>";
			} else if (type == 'microtalk') {
				var size = items.files[0].size;
				var fname = items.files[0].fileName;
				var fid = items.files[0].fileId;
				var msize = size;
				if (size < 10) {
					size = 1;
				} else if (size < 20) {
					size = 2;
				} else if (size < 30) {
					size = 3;
				} else if (size < 40) {
					size = 4;
				} else if (size < 50) {
					size = 5;
				} else {
					size = 6;
				}
				historyMessStr += "<li class='pageChatAreaOther'>";
				historyMessStr += "<img class='pageChatAreaOther_img radius' width='48' height='48' src='"
						+ (photo != null ? photo : defaultphoto)
						+ "' id='"
						+ random
						+ "img' jid='"
						+ items.from
						+ "' onmouseover='showPeopleCard(this, false)' onmouseout='showPeopleCard_type=false;'/><span class='pageChatAreaArrowLeft'></span>";
				if (datetime.length > 10) {
					if (size < 3) {
						size = 3;
					}
				}
				historyMessStr += "<div class='pageChatAreaMy_content speech_w_"
						+ size
						+ "' ftype='microtalk' fname='"
						+ fname
						+ "' fid='"
						+ fid
						+ "' fsize='"
						+ msize
						+ "' fi='"
						+ i
						+ "'>";
				if (isShowClose) {
					historyMessStr += '<span class="pageChatAreaListClose"><span class="pageChatAreaListClose_box"><span class="ico16 for_close_16" dt="'
							+ items.time
							+ '" from = "'
							+ items.from
							+ '" to ="' + items.to + '"></span></span></span>';
				}
				historyMessStr += "<p class='speech_height'>";
				historyMessStr += " <span class='left'>";
				historyMessStr += "<span class='color_blue'><a  onclick = \"parent.window.opener.openWinIM('"
						+ items.name
						+ "', '"
						+ items.from
						+ "');stopEventUp(event)\">"
						+ items.name
						+ "：</a></span><span id=\""
						+ i
						+ "clas\" class='ico16 speech_read_16' onclick =\"downPlayMicTalk('"
						+ fname
						+ "','"
						+ fid
						+ "','"
						+ msize
						+ "','"
						+ i
						+ "')\"></span>";
				historyMessStr += "</span>";
				historyMessStr += " <span class='right font_size12 color_gray'>";
				historyMessStr += datetime
						+ "<span class='speech_time_box'><span>" + msize
						+ "'</span></span>";
				historyMessStr += " </span></p></div>";
				historyMessStr += "</li>";
			} else if (type == 'vcard') {
				historyMessStr += "<li class='pageChatAreaOther'>";
				historyMessStr += "<img class='pageChatAreaOther_img radius' width='48' height='48' src='"
						+ (photo != null ? photo : defaultphoto)
						+ "'id='"
						+ random
						+ "img' jid='"
						+ items.from
						+ "' onmouseover='showPeopleCard(this, false)' onmouseout='showPeopleCard_type=false;' /><span class='pageChatAreaArrowLeft'></span>";
				historyMessStr += "<div class='pageChatAreaMy_content' style='width:640.03px;'>";
				if (isShowClose) {
					historyMessStr += '<span class="pageChatAreaListClose"><span class="pageChatAreaListClose_box"><span class="ico16 for_close_16" dt="'
							+ items.time
							+ '" from = "'
							+ items.from
							+ '" to ="' + items.to + '"></span></span></span>';
				}
            	var vcard = items.vcard;
            	var vcardStr = "<b style='font-weight: bold;'>名片</b><br/>";
            	if (vcard && vcard.name != '') {
            		vcardStr += addBrByMsg("姓名",vcard.name);
            	}
                if (vcard && vcard.mobliePhone != '') {
                	vcardStr += addBrByMsg("移动电话",vcard.mobliePhone);
                }
                if (vcard && vcard.iphone != '') {
                	 vcardStr += addBrByMsg("iphone电话",vcard.iphone);
                }
                if (vcard && vcard.address != '') {
                	vcardStr += addBrByMsg("住宅电话",vcard.address);
                }
                if (vcard && vcard.workPhone != '') {
                	vcardStr += addBrByMsg("工作电话",vcard.workPhone);
                }
                if (vcard && vcard.hPhone != '') {
                	vcardStr += addBrByMsg("主要电话",vcard.hPhone);
                }
                if (vcard && vcard.adPhone != '') {
                	vcardStr += addBrByMsg("住宅传真",vcard.adPhone);
                }
                if (vcard && vcard.workF != '') {
                	vcardStr += addBrByMsg("工作传真",vcard.workF);
                }
                if (vcard && vcard.ppG != '') {
                	vcardStr += addBrByMsg("传呼",vcard.ppG);
                }
				historyMessStr += "<span class='font_size12'><a  onclick = \"parent.window.opener.openWinIM('"
						+ items.name
						+ "', '"
						+ items.from
						+ "')\">"
						+ items.name
						+ ":</a></span><p style='word-wrap:break-word'><span class='font_size12'>"
						+vcardStr+ "</span></p>";
				historyMessStr += "<p class='font_size12 color_gray'>"
						+ datetime + "</p> </div></li>";
			} else {
				historyMessStr += "<li class='pageChatAreaOther'>";
				historyMessStr += "<img class='pageChatAreaOther_img radius' width='48' height='48' src='"
						+ (photo != null ? photo : defaultphoto)
						+ "'id='"
						+ random
						+ "img' jid='"
						+ items.from
						+ "' onmouseover='showPeopleCard(this, false)' onmouseout='showPeopleCard_type=false;' /><span class='pageChatAreaArrowLeft'></span>";
				historyMessStr += "<div class='pageChatAreaMy_content' style='width:640.03px;'>";
				if (isShowClose) {
					historyMessStr += '<span class="pageChatAreaListClose"><span class="pageChatAreaListClose_box"><span class="ico16 for_close_16" dt="'
							+ items.time
							+ '" from = "'
							+ items.from
							+ '" to ="' + items.to + '"></span></span></span>';
				}
				historyMessStr += "<span class='font_size12'><a  onclick = \"parent.window.opener.openWinIM('"
						+ items.name
						+ "', '"
						+ items.from
						+ "')\">"
						+ items.name
						+ ":</a></span><p style='word-wrap:break-word'><span class='font_size12'>"
						+ body + "</span></p>";
				historyMessStr += "<p class='font_size12 color_gray'>"
						+ datetime + "</p> </div></li>";
			}
		}
	}
	$('#history_message').append(historyMessStr);
	$('#pageFind').empty();
	var htmlstr = getPageLine(false);
	$('#pageFind').append(htmlstr);
	getA8Top().endProc();
	var top = $('#MessageInput').offset().top;
	$(document).scrollTop(top - 40);
	$('#MessageInput').focus();
}
function flushPhoto(iq, memberId) {
	var photo = v3x.baseURL + "/apps_res/v3xmain/images/personal/pic.gif";
	var item = iq.getNode().getElementsByTagName('photo').item(0);
	if (item && item.firstChild) {
		photo = item.firstChild.nodeValue;
	}
	connWin._PhotoMap.put(iq.getFrom(), photo);
	$('#' + memberId + 'Img').attr("src", photo);
}

function floatClose(i) {
	$('#close_' + i).show();
}

function removeClose(i) {
	$('#close_' + i).hide();
}

function getPageLine(flag) {
	var isPort = false;
	if (flag) {
		isPort = true;
	}
	var htmlstr = "";
	htmlstr += "<div class='common_over_page right margin_r_10 padding_t_10 padding_r_5'>";
	if (currentPage > 1) {
		htmlstr += "<a href='#' class='common_over_page_btn' title='"
				+ $.i18n('uc.page.prev.js')
				+ "' onclick='javaScript:pageTurning(" + 2 + "," + isPort
				+ ")'><em class='pagePrev'></em></a>";
	} else {
		htmlstr += "<a class='common_over_page_btn' title='"
				+ $.i18n('uc.page.prev.js')
				+ "' ><em class='pagePrev_disable'></em></a>";
	}
	var mytotalPage = totalPage;
	if (mytotalPage < 1) {
		mytotalPage = 1;
	}
	htmlstr += "&nbsp;&nbsp;&nbsp;&nbsp;" + $.i18n('uc.page.current.js')
			+ "&nbsp;&nbsp;" + currentPage + "/" + mytotalPage + "&nbsp;&nbsp;"
			+ $.i18n('uc.page.total.js');
	if (currentPage < totalPage) {
		htmlstr += "<a href='#' class='common_over_page_btn' title='"
				+ $.i18n('uc.page.next.js')
				+ "' onclick='javaScript:pageTurning(" + 3 + "," + isPort
				+ ")'><em class='pageNext'></em></a>";
	} else {
		htmlstr += "<a class='common_over_page_btn' title='"
				+ $.i18n('uc.page.next.js')
				+ "' ><em class='pageNext_disable'></em></a>";
	}

	return htmlstr;
}

function pageTurning(actions, flags) {
	isHistoryFlush = false;
	isflas = false;
	isFlush = false;
	istotalNum = false;
	getA8Top().startProc();
	if (flags) {
		if (actions == 1) {// 向后翻页
			var page1 = startNum + 4;
			if (page1 > totalPage) {
				page1 = totalPage;
			}
			var endMessage = initHistMessage(1, true, true);
			var mes = endMessage[endMessage.length - 1];
			var iq = parent.window.opener.newJSJaCIQ();
			iq.setIQ(_CurrentUser_jid, 'get', 'history:msg');
			var query = iq.setQuery('recently:msg:query');
			query.appendChild(iq.buildNode('type', talkType));
			query.appendChild(iq.buildNode('begin_time'));
			query.appendChild(iq.buildNode('end_time', mes.time));
			query.appendChild(iq.buildNode('count', '10'));
			connWin.con.send(iq, cacheCommunication, false);
		} else if (actions == 0) {// 向前翻页
			var endMessage = initHistMessage(1, true, true);
			var mes = endMessage[0];
			var iq = parent.window.opener.newJSJaCIQ();
			iq.setIQ(_CurrentUser_jid, 'get', 'history:msg');
			var query = iq.setQuery('recently:msg:query');
			query.appendChild(iq.buildNode('type', talkType));
			query.appendChild(iq.buildNode('begin_time', mes.time));
			query.appendChild(iq.buildNode('end_time'));
			query.appendChild(iq.buildNode('count', '10'));
			connWin.con.send(iq, cacheCommunication, false);

		} else if (actions == 3) {// 后一页
			var pageCont = currentPage + 1;
			currentPage = pageCont;
			pageTurning(1, true);
			isShowStartPage = true;
		} else if (actions == 2) {// 前一页
			var pageCont = currentPage - 1;
			currentPage = pageCont;
			try {
				pageTurning(0, true);
			} catch (e) {

			}
		}
	} else {
		if (actions == 1) {// 向后翻页
			var page1 = startNum + 4;
			if (page1 > totalPage) {
				page1 = totalPage;
			}
			var endMessage = initHistMessage(1, true, false);
			var mes = endMessage[endMessage.length - 1];
			var iq = parent.window.opener.newJSJaCIQ();
			iq.setFrom(_CurrentUser_jid);
			iq.setIQ(_toID, 'get', 'history:msg');
			var query = iq.setQuery('history:msg:query');
			query.appendChild(iq.buildNode('begin_time'));
			query.appendChild(iq.buildNode('end_time', mes.time));
			query.appendChild(iq.buildNode('count', '10'));
			connWin.con.send(iq, showIndexHistMessage, false);
		} else if (actions == 0) {// 向前翻页
			var endMessage = initHistMessage(1, true, false);
			var mes = endMessage[0];
			var iq = parent.window.opener.newJSJaCIQ();
			iq.setFrom(_CurrentUser_jid);
			iq.setIQ(_toID, 'get', 'history:msg');
			var query = iq.setQuery('history:msg:query');
			query.appendChild(iq.buildNode('begin_time', mes.time));
			query.appendChild(iq.buildNode('end_time'));
			query.appendChild(iq.buildNode('count', '10'));
			connWin.con.send(iq, showIndexHistMessage, false);

		} else if (actions == 3) {// 后一页
			var pageCont = currentPage + 1;
			currentPage = pageCont;
			var ppPage = pageCont - startNum + 1;
			pageTurning(1, false);
			isShowStartPage = true;
		} else if (actions == 2) {// 前一页
			var pageCont = currentPage - 1;
			currentPage = pageCont;
			try {
				pageTurning(0, false);
			} catch (e) {

			}
		}
	}
}

function sendMessage() {
	checkMemberIsDelete();
}

function queryTalk(type) {
	isHistoryFlush = false;
	talkType = type;
	getA8Top().startProc();
	isFlush = true;
	queryTalkByIndex();
}

function deleteMessage(timeSpaces, isalert, jid) {
	try {
		var lastMess = indexMessages[indexMessages.length - 1];
		var iq = parent.window.opener.newJSJaCIQ();
		var uids = _CurrentUser_jid;
		iq.setFrom(uids);
		iq.setIQ(uids, 'set', 'delete:recently:msg');
		var query1 = iq.setQuery('delete:recently:msg:query');
		query1.appendChild(iq.buildNode('delete_record_time', timeSpaces));
		query1.appendChild(iq.buildNode('query_record_time', lastMess.time));
		query1.appendChild(iq.buildNode('type', talkType));
		if (isalert) {
			if (window.confirm($.i18n('uc.title.deletet.js'))) {
				connWin.con.send(iq, deleteMessageCheck);
				$('#pageChatTabs').find('li').each(function() {
					var id = $(this).attr('jid');
					if (id == jid) {
						$(this).find('.pageChatTabsClose')[0].click();
					}
				});
				getA8Top().startProc();
			} else {
				return;
			}
		} else {
			connWin.con.send(iq, deleteMessageCheck, jid);
		}
	} catch (e) {

	}
}
function deleteMessageCheck(iq, jid) {
	try {
		var detime = iq.getNode().getElementsByTagName('delete_record_time')[0].firstChild.data;
		totalCountByre = totalCountByre - 1;
		var newMessage = initMessageByIq(iq);
		var newindexMessageList = new Array();
		var k = 0;
		for ( var i = 0; i < indexMessages.length; i++) {
			var indexMess = indexMessages[i];
			if (indexMess.time == detime) {
				continue;
			} else {
				newindexMessageList[k] = indexMess;
				k++;
			}
		}
		if (totalCountByre % 10 == 0) {
			totalPage = parseInt(totalCountByre / 10);
		} else {
			totalPage = parseInt(totalCountByre / 10) + 1;
		}
		indexMessages = newindexMessageList;
		if (newMessage.length > 0) {
			indexMessages[indexMessages.length] = newMessage[0];
			showCommunication(indexMessages);
		} else {
			if (totalCountByre > 0 && indexMessages.length == 0) {
				if (currentPage > 1) {
					currentPage = currentPage - 1;
					var iq = parent.window.opener.newJSJaCIQ();
					iq.setFrom(_CurrentUser_jid);
					iq.setIQ(_toID, 'get', 'history:msg');
					var query = iq.setQuery('recently:msg:query');
					query.appendChild(iq.buildNode('type', talkType));
					query.appendChild(iq.buildNode('begin_time', detime));
					query.appendChild(iq.buildNode('end_time'));
					query.appendChild(iq.buildNode('count', '10'));
					connWin.con.send(iq, cacheCommunication, false);
				}
			} else {
				showCommunication(indexMessages);
			}
		}
		isFlush = false;
	} catch (e) {

	}
}

function downPlayMicTalk(fname, fid, size, i) {
	var ischeck = checkPlugins('QuickTime', '');
	if (ischeck) {
		if ($('#' + i + 'clas')[0].className.indexOf('speech_unread_16') > 0) {
			$('#' + i + 'clas').removeClass('speech_unread_16').addClass(
					'speech_gif2_16');
			$(this).find(".speech_unread_16").toggleClass(
					"speech_unread_16 speech_gif2_16");
		} else {
			$('#' + i + 'clas').removeClass('speech_read_16').addClass(
					'speech_gif_16');
			$(this).find(".speech_read_16").toggleClass(
					"speech_read_16 speech_gif_16");
		}
		obj = $('#' + i + 'clas');
	}
	downMicTalkPath(fid, fname, size, 'mysource', connWin.con,
			parent.window.opener);
	if (ischeck) {
		var zsize = parseInt(size) + 2;
		window.setTimeout("closeClass()", zsize * 1000);
	}
}
function downPlayMicTalks(fname, fid, size, i) {
	var ischeck = checkPlugins('QuickTime', '');
	if (ischeck) {
		$('#' + i + 'clase').removeClass('speech_read_16').addClass(
				'speech_gif_16');
		$(this).find(".speech_read_16").toggleClass(
				"speech_read_16 speech_gif_16");
		obj = $('#' + i + 'clase');
	}
	downMicTalkPath(fid, fname, size, 'mysource', connWin.con,
			parent.window.opener);
	if (ischeck) {
		var zsize = parseInt(size) + 2;
		window.setTimeout("closeClass()", zsize * 1000);
	}
}

function endArraybyIndex(array) {
	var array1 = new Array();
	var k = 0;
	for ( var i = array.length - 1; i >= 0; i--) {
		array1[k] = array[i];
		k++;
	}
	return array1;
}
function closeClass() {
	if (obj[0].className.indexOf('speech_gif2_16') > 0) {
		obj.removeClass('speech_gif2_16').addClass('speech_unread_16');
	} else {
		obj.removeClass('speech_gif_16').addClass('speech_read_16');
	}
}
function winChat(name, jid) {
	if (jid.indexOf('@group') < 0) {
		var iq = retIq(name, jid);
		connWin.con.send(iq, checkWinChat);
	} else {
		parent.window.opener.openWinIM(name, jid);
	}
}

function retIq(name, jid) {
	var iq = parent.window.opener.newJSJaCIQ();
	var uid = _CurrentUser_jid;
	iq.setFrom(uid);
	iq.setIQ(uid, 'get', 'groupmemberinfo');
	var query = iq.setQuery('jabber:iq:seeyon:office-auto');
	var org = iq.buildNode('organization', {
		'xmlns' : 'organization:staff:info:query'
	});
	var staff = iq.buildNode('staff');
	var jidE = iq.buildNode('jid', jid);
	jidE.setAttribute('deptid', '');
	staff.appendChild(jidE);
	org.appendChild(staff);
	query.appendChild(org);
	return iq;
}

function checkWinChat(iq) {
	if (iq.getType != 'error') {
		var items = iq.getNode().getElementsByTagName('jid');
		var item = items.item(0);
		var memberId = item.getAttribute('I');
		var jid = item.getAttribute('J');
		var name = item.getAttribute('N');
		if (memberId != '' && name != '') {
			parent.window.opener.openWinIM(name, jid);
		} else {
			$.alert($.i18n('uc.title.memberDelte.js'));
		}
	}
}

function memberDelete() {
	$.alert($.i18n('uc.title.memberDelte.js'));
}

function checkMemberIsDelete() {
	if (_toID.indexOf('@group') < 0) {
		var iq = retIq(_toName, _toID);
		connWin.con.send(iq, checkBySendMessage);
	} else {
		if (connWin.roster.DisabledChatUser.get(_toID)) {
			$.alert($.i18n('uc.group.notinfo.js'));
			$('#sendCheck').removeClass('common_button');
			$('#sendCheck').hide();
		} else {
			sendMes();
		}
	}
}

function checkBySendMessage(iq) {
	if (iq.getType != 'error') {
		var items = iq.getNode().getElementsByTagName('jid');
		var item = items.item(0);
		var memberId = item.getAttribute('I');
		var jid = item.getAttribute('J');
		var name = item.getAttribute('N');
		if (memberId != '' && name != '') {
			sendMes();
		} else {
			$.alert($.i18n('uc.title.memberDelte.js'));
			connWin.roster.DeleteUser.put(_toID, true);
			$('#sendCheck').removeClass('common_button');
			$('#sendCheck').hide();
		}
	}
}

function sendMes() {
	isFoat = false;
	self.close();
	fidList = new Array();
	$('#sendFile').find('.common_send_people_box').each(function() {
		var item = {
			'date' : $(this).attr('fdate'),
			'fid' : $(this).attr('jid'),
			'fname' : $(this).attr('fname'),
			'fsize' : $(this).attr('fsize'),
			'hash' : $(this).attr('hash')
		}
		fidList[fidList.length] = item;
	});
	$('#sendFile').html('');
	$('#sendFile').hide();
	$('#MessageInput').find("img").each(function() {
		$(this).after($(this).attr("code")).remove();
	});
	$('#MessageInput').find('p').each(function() {
		if ($.trim($(this).text()) == '') {
			$(this).remove();
		} else {
			$(this).replaceWith($(this).html() + '\n');
		}
	});
	$('#MessageInput').find('br').each(function() {
		$(this).replaceWith($(this).html() + '\n');
	});
	$('#MessageInput').find('div').each(function() {
		if ($.trim($(this).text()) == '') {
			$(this).remove();
		} else {
			$(this).replaceWith($(this).html() + '\n');
		}
	});
	var body = $('#MessageInput').text();
	var reg = new RegExp("\n", "g");
	var text = body.replace(reg, '');
	if (text.length > 300) {
		$.alert($.i18n('uc.titleText.js'));
		return;
	}
	var items = {
		jid : _toID,
		name : _toName
	};
	subMessage(items, body, parent.window.opener);
	fidList = new Array();
	filePathList = new Array();
	$('#MessageInput').empty();
	// 回调历史记录
	if (isFoat) {
		getA8Top().startProc();
		isHistoryFlush = true;
		queryHistoryMess(_toID, _toName);
		isFoat = false;
	}
	$(".pageChatArea .pageChatArea_textarea").keyup();
	$(".pageChatArea .pageChatArea_btnSubmit").removeClass(
			"common_button_emphasize common_button_disable").addClass(
			"common_button_disable");
}

var msgbody = null;
function sendByMessage(lists, msgBody, openers, allList) {
	getA8Top().startProc('', true);
	fidList = sendFileList;
	toMemberList = allList;
	msgbody = msgBody;
	memberID = new ArrayList();
	if (lists.size() > 0) {
		for ( var i = 0; i < lists.size(); i++) {
			var isContanis = false;
			if (lists.get(i).jid != _CurrentUser_jid) {
				for ( var j = 0; j < memberID.size(); j++) {
					if (memberID.get(j) == lists.get(i).jid) {
						isContanis = true;
						break;
					} else {
						isContanis = false;
					}
				}
				if (!isContanis) {
					memberID.addSingle(lists.get(i).jid);
					subMessage(lists.get(i), msgBody, parent.window.opener,
							true);
				}
			}
		}

	}
	startNumByMsg = startNumByMsg + 100;
	if (startNumByMsg < endNumsByMsg) {
		window.setTimeout('subMsgList()', 2000);
	} else {
		sendFileList = new Array();
		fidList = new Array();
		filePathList = new Array();
		startNumByMsg = 0;
		endNumsByMsg = 0;
		isFlush = true;
		queryTalkByIndex();
		getA8Top().endProc('');
	}

}
function subMsgList() {
	sendByMessage(toMemberList.subList(startNumByMsg, startNumByMsg + 100),
			msgbody, parent.window.opener, toMemberList);
}

function addBrByMsg (name,nodeList) {
    var htmlStr = '';
    var showName = name;
    if (nodeList != null && nodeList.size() > 0) {
        for (var i = 0 ; i < nodeList.size(); i ++) {
            htmlStr += showName +":" + nodeList.get(i) +"<br/>";
        }
    }
    return htmlStr;
}

/**
 *字符截取
 * @param s
 * @returns {Number}
 */
function get_length(s){
    var char_length = 0;
    for (var i = 0; i < s.length; i++){
        var son_char = s.charAt(i);
        encodeURI(son_char).length > 2 ? char_length += 1 : char_length += 0.5;
    }
    return char_length;
}
function cut_str(str, len){
    var char_length = 0;
    for (var i = 0; i < str.length; i++){
        var son_str = str.charAt(i);
        encodeURI(son_str).length > 2 ? char_length += 1 : char_length += 0.5;
        if (char_length >= len){
            var sub_len = char_length == len ? i+1 : i;
            return str.substr(0, sub_len);
            break;
        }
    }
}



function getMsgLimitLength(text, maxLength) {
	var len = text.getBytesLength();
	if (len <= maxLength) {
		return text;
	}

	var symbol = "...";
	maxLength = maxLength - symbol.length;

	var a = 0;
	var temp = '';
	for ( var i = 0; i < text.length; i++) {
		if (text.charCodeAt(i) > 255) {
			a += 2;
		} else {
			a++;
		}

		temp += text.charAt(i);

		if (a >= maxLength) {
			break;
		}
	}
	var start = temp.substring(0, temp.length - 7);
	var end = temp.substring(temp.length - 7, temp.length);
	if (end.lastIndexOf("]") > -1) {
		start += end.substring(0, end.lastIndexOf("]") +1);
	} else {
		start += end;
	}

	start += symbol;

	return start;
}
