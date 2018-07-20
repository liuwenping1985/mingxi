<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link type="text/css" rel="stylesheet" href="<c:url value='/apps_res/uc/chat/css/uc.css${ctp:resSuffix()}' />">
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/seeyon.ui.uc.face-debug.js${ctp:resSuffix()}" />"></script>
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/seeyon.ui.uc.card-debug.js${ctp:resSuffix()}" />"></script>
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/seeyon.ui.uc.upload-debug.js${ctp:resSuffix()}" />"></script>
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/seeyon.ui.uc-debug.js${ctp:resSuffix()}" />"></script>
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/jquery.ztree.all-3.5.js${ctp:resSuffix()}" />"></script>
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/json2.js${ctp:resSuffix()}" />"></script>
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/uc_team.js${ctp:resSuffix()}" />"></script>
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/uc_org.js${ctp:resSuffix()}" />"></script>
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/shared.js${ctp:resSuffix()}" />"></script>
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/uc_upload.js${ctp:resSuffix()}" />"></script>
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/uc_hismsg.js${ctp:resSuffix()}" />"></script>
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/common/collaboration/collFacade.js${ctp:resSuffix()}" />"></script>
	<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/webmail/js/webmail.js${ctp:resSuffix()}" />"></script>
    <object classid="clsid:95E88F55-7F1E-4F5D-AC18-0E1F08BDDF21" id="UC_UPLOAD" data="DATA:application/x-oleobject;BASE64,EcQUs+rmGUC2v8saHQ7GHgADAABoLgAAzxIAABMAzc3NzRMAzc3NzQsA//8=" width="90%" height="0"></object>
    <style type="text/css">
    	ul.ztree {margin-top: 10px; border: 1px solid #617775; background: #fff; height: 200px; overflow-y: auto; overflow-x: auto;}
    </style>
    <script>
    	var v3x = new V3X();
    	v3x.init("${pageContext.request.contextPath}", "<%=com.seeyon.v3x.common.i18n.LocaleContext.getLanguage(request)%>");
    	var connWin = getA8Top().window.opener;
    	var isFromA8 = "${param.from}" == "a8";
        var groupId = '';
        var group_nike = '';
        var vcardMap = new Properties();
        var projectNoShow = "${v3x:getSysFlagByName('project_notShow')}"; //uc是否显示项目
        
    	function downLoadFile(id, name,type){
			downFilePath(id, name, window.opener.con, window.opener,type);
		}
		
        function stopEventUps(oevent){
            if (oevent && oevent.stopPropagation) {
                oevent.stopPropagation();
            } else {
                window.event.cancelBubble = true;
            }
    	}
        
        function putMsgHTML(id, msg) {
        	var defaultphoto = v3x.baseURL + "/apps_res/v3xmain/images/personal/pic.gif";
        	var random = Math.floor(Math.random() * 100000000);
        	if(msg.isDelete){
        		alert($.i18n('uc.title.memberDelte.js'));
        		$('#'+chat.id+'_send').hide();
        		return;
        	}
	        var htmlStr = "";
  
	        var body = msg.content;
	        body = body.escapeHTML();
	        var time = msg.time;
    		for(var j = 0; j < face_texts_replace.length; j++){
    			body = body.replace(face_texts_replace[j], "<img src='" + v3x.baseURL + "/apps_res/uc/chat/image/face/5_" + (j + 1) + ".gif' />");
    		}
    		//收到的消息显示的时候需要替换url youhb 2013年11月4日11:37:22
    		body = replaceRegUrl(body);
			var microtalk = msg.microtalk;
			var vcard = msg.vcard;
		    var photoImg = '';
			if(!connWin._PhotoMap.get(msg.userjid)){
	        photoImg = defaultphoto;
	        var iq = parent.window.opener.newJSJaCIQ();
	        iq.setIQ(msg.userjid, 'get');
	        iq.appendNode(iq.buildNode('vcard', {
	                      'xmlns': 'vcard-photo'
	        }));
	        connWin.con.send(iq, photoToHTMLByIm, random);
			}else{
	        	 photoImg = connWin._PhotoMap.get(msg.userjid);
		    }
		    //修改消息区域自适应 youhb 2013年11月25日16:25:46
			htmlStr += "<tr class='ucChat_left'>";
			htmlStr +='<td valign="top">';
			htmlStr +="<img class='ucChat_pic' id='" + random + "Img' jid='"+ msg.userjid +"' src='" + photoImg + "' onmouseover='showPeopleCard(this, false)' onmouseout=\'showPeopleCard_type=false;\'/></td>";
			//加入人员卡片弹出方法，补充属性jid为人员卡片使用
			var showName = "";
			var userName = msg.username;
	        if (microtalk != null) {
	        	var msize = microtalk.size;
	        	if (parseInt(msize) < 6) {
	        		showName = userName.getLimitLength(2,'...');
	        		msize = 1;
	        	}
	        	if (parseInt(msize) > 5 && parseInt(msize) <= 10) {
	        		showName = userName.getLimitLength(8,'...');
	        		msize = 2;
	        	}
	        	if (parseInt(msize) > 10 && parseInt(msize) <= 20) {
	        		showName = userName.getLimitLength(12,'...');
	        		msize = 3;
	        	}
	        	if (parseInt(msize) > 20) {
	        		showName = userName.getLimitLength(16,'...');
	        		msize = 4;
	        	}
	        	//修改消息区域自适应 youhb 2013年11月25日16:25:46
	        	htmlStr +="<td colspan='2' valign='top'>";
	        	htmlStr +="<span class='left'><span class='ucChat_arrow'><span></span></span></span>";
	        	htmlStr +="<div class='ucChat_content ucChat_content_w" + msize + "' onclick =\"downPlayMicTalkByIm('', '" + microtalk.id + "', '" + microtalk.size + "', '" + j + "')\">";
	        	htmlStr +="<span class='right color_gray2 margin_t_5'>" + time + "</span>";
	        	htmlStr += "<span class='color_blue'><a onclick=\"openIM('" + msg.username + "', '" + msg.userjid + "');stopEventUps(event)\" title='"+msg.username+"'>" + showName + ":&nbsp;</a></span><span class='ico16 speech_read_16 margin_tb_5'></span>";
				htmlStr += "</div>";
				htmlStr += "<span class='ucChat_close hidden'><span class='ico16 for_close_16' id='" + j + "clase1'></span></span>";
				htmlStr += "<div class='ucChat_content_time color_gray2'>" + microtalk.size + "'</div></td><td colspan='2'></td></tr>";
				htmlStr +="<tr class='ucChat_gap'><td colspan='5'></td></tr>";
	        } else if (vcard != null ) {
	        	vcardMap.put(vcard.name,vcard);
                htmlStr +='<td colspan="2">';
                htmlStr +='<span class="left"><span class="ucChat_arrow"><span></span></span></span>';
                htmlStr +='<div class="ucChat_content">';
                htmlStr +="<span class='color_blue'><a onclick=\"openIM('" + msg.username + "', '" + msg.userjid + "')\">" + msg.username + ":&nbsp;</a></span><span class='font_size12 color_gray2'>" + time + "</span><br />";
                htmlStr +='<table width="100%" class="margin_t_5">';
                htmlStr +='<tr>';
                htmlStr +='<td colspan="2" align="center" style="font-weight:bold;"><b>'+$.i18n('uc.message.vcard.js')+'</b><br/><hr width="100%"/></td>';
                htmlStr +='</tr>';
                htmlStr += addTr($.i18n('uc.message.name.js'),vcard.name);
                htmlStr += addTr($.i18n('uc.message.Mobiletelephone.js'),vcard.mobliePhone);
                htmlStr += addTr($.i18n('uc.message.iphone.js'),vcard.iphone);
                htmlStr += addTr($.i18n('uc.message.HomePhone.js'),vcard.address);
                htmlStr += addTr($.i18n('uc.message.workPhone.js'),vcard.workPhone);
                htmlStr += addTr($.i18n('uc.message.mainphone.js'),vcard.hPhone);
                htmlStr += addTr($.i18n('uc.message.HomeFax.js'),vcard.adPhone);
                htmlStr += addTr($.i18n('uc.message.WorkFax.js'),vcard.workF);
                htmlStr += addTr($.i18n('uc.message.Paging.js'),vcard.ppG);
                if (isFromA8) {
                    htmlStr +='<tr>';
                    htmlStr +="<td colspan='2' align='right'><a onclick=\"saveVcard('" + vcard.name + "', '" + id + "')\" class='color_blue'>"+$.i18n('uc.title.sava.js')+"</a></td>";
                    htmlStr +='</tr>';
                }
                htmlStr +='</table>';
                htmlStr += "</div>";
	        } else if (msg.type == 'image') {
	        	var _type ="image";
	            htmlStr +='<td colspan="2">';
                htmlStr +='<span class="left"><span class="ucChat_arrow"><span></span></span></span>';
                htmlStr +='<div class="ucChat_content">';
                htmlStr +="<span class='color_blue'><a onclick=\"openIM('" + msg.username + "', '" + msg.userjid + "')\">" + msg.username + ":&nbsp;</a></span><span class='font_size12 color_gray2'>" + time + "</span><br />";
                var atts = msg.atts;
                var random = Math.floor(Math.random() * 100000000);
                var _html = "";
                if (atts.size() > 0) {
                	queryShowImgPath(atts.get(0).id,random);
                	_html = "<img src='' fid='"+atts.get(0).id+"' fname='"+atts.get(0).name+"' class='maxHeight_300' id='"+random+"_img' ondblclick='showImgFile(this)'/>";
                }
                htmlStr +="<p class='margin_l_5' align='center'><table width='100%' height='100%''><tr><td align='center'>"+_html+"</td></tr><tr><td align='right'><a onclick='downLoadFile(\"" + atts.get(0).id + "\", \"" + atts.get(0).name + "\", \"" + _type + "\")'>"+$.i18n('uc.title.sava.js')+"</a></td></td></table></p>";
	        } else {
	        	//修改消息区域自适应 youhb 2013年11月25日16:25:46
				htmlStr +='<td colspan="2">';
				htmlStr +='<span class="left"><span class="ucChat_arrow"><span></span></span></span>';
				htmlStr +='<div class="ucChat_content">';
				htmlStr +="<span class='color_blue'><a onclick=\"openIM('" + msg.username + "', '" + msg.userjid + "')\">" + msg.username + ":&nbsp;</a></span><span class='font_size12 color_gray2'>" + time + "</span><br />";
				htmlStr +='<p class="margin_l_5">'+body+'</p>';
	            var atts = msg.atts;
	            if (atts.size() > 0) {
	            	htmlStr += "<p class='padding_l_10'>";
	            	var str ='';
	            	var mstr ='';
	            	var _type ="file";
		            for(var k = 0; k < atts.size(); k++){
		                var att = atts.get(k);
		                if(k == 0){
		                	mstr += "<span class='font_size12'><span class='" + querySpanClass(att.name) + "' style='cursor: default;'></span>" + att.name + "<span style='font-size: 12px;'>(" + att.size + "KB)</span>" + "<a style='font-size: 12px;' onclick='downLoadFile(\"" + att.id + "\", \"" + att.name + "\", \"" + _type + "\")'>"+$.i18n('uc.title.download.js')+"</a></span><br/>";
		                }else{
		                 	str += "<span class='font_size12'><span class='" + querySpanClass(att.name) + "' style='cursor: default;'></span>" + att.name + "<span style='font-size: 12px;'>(" + att.size + "KB)</span>" + "<a style='font-size: 12px;' onclick='downLoadFile(\"" + att.id + "\", \"" + att.name + "\", \"" + _type + "\")'>"+$.i18n('uc.title.download.js')+"</a></span>";
		                 	if (k < atts.size() - 1) {
				            	str += "<br />";
					        }
		                }
		    		}
		            htmlStr += "<div width='80px'><span class='font_size12'>" + $.i18n('uc.title.sendafiletoyou.js') + "</span></div>"+mstr;
		            htmlStr += str;
		            htmlStr += "</p>";
	            }
	            
	            htmlStr += "</div>";
	        }
			htmlStr +='<span class="ucChat_close hidden"><span class="ico16 for_close_16"></span></span>';
			htmlStr +='</td><td colspan="2"></td></tr>';
			htmlStr +='<tr class="ucChat_gap"><td colspan="5"></td></tr>';
            $('#' + id + '_ul').append(htmlStr);
            try {
                var scrollTop = $("#" + chat.id + "_dialogcontentbody")[0].scrollHeight - $("#" + chat.id + "_dialogcontentbody").height();
                if (scrollTop > 50) {
                    $("#" + chat.id + "_dialogcontentbody").scrollTop(scrollTop);
                }
            } catch (e) {}
        }

        function popMsgs(msgs) {
    	    while (msgs.length > 0) {
    	        var msg;
    	        if (is.ie5 || is.op) {
    	            msg = msgs[0];
    	            msgs = msgs.slice(1, msgs.length);
    	        } else {
        	        msg = msgs.shift();
                }
    	        putMsgHTML(msg);
    	    }
        }
        
        /**
         * 发送消息
         * @param {Object} jid
         * @param {Object} body
         */
        function submitClicked(jid,name, body) {
        	 var items ={
        		jid: jid,
	            name: name
        	 };
        	 subMessage(items,body,connWin);
        }
        
        var chat;
        $(document).ready(function () {
            getArgs();
            if (passedArgs['jid'] == 'all') {
                chat = new Mxtchat();
                var chatusers = window.opener.roster.chatusers;
                for (var i = 0; i < chatusers.length; i++) {
                    var chatuser = chatusers[i];
                    if (chatuser.chatmsgs.size() > 0) {
                        chat.addSingleTab({id:chatuser.id, name:chatuser.name, jid:chatuser.jid});
                        document.title = $.i18n('uc.title.chat.js', chatuser.name);
                        for (var j = 0; j < chatuser.chatmsgs.size(); j++) {
                            putMsgHTML(chatuser.id, chatuser.chatmsgs.get(j));
                        }
                        chatuser.chatmsgs.clear();
                    }
                }
            } else {
                chat = new Mxtchat();
                var user = window.opener.roster.getChatUserByJID(passedArgs['jid']);
                chat.addSingleTab({id:user.id, name:user.name, jid:user.jid});
                document.title = $.i18n('uc.title.chat.js', user.name);
                
                if (user.chatmsgs.size() > 0) {
                    for (var i = 0; i < user.chatmsgs.size(); i++) {
                        putMsgHTML(user.id, user.chatmsgs.get(i));
                    }
                    user.chatmsgs.clear();
                }
            }
            
            window.onfocus = function(e) {
            	endUCActionTitle();
            };
        });
		
        /********************历史记录********************/
        var messgaeMap;
        var totalPage = 0;
        var startNum = 0;
        var endNum = 0;
        var currentPage = 1;
        var _toID = '';
		var isShowStartPage = false;
        var startLimeTime = null;
        var endLimeTime = null;
        function getHisMessage(toId,startTime,endTime){
            getA8Top().startProc();
            _toID = toId;
            startLimeTime = startTime;
            endLimeTime  = endTime;
            iq = window.opener.newJSJaCIQ();
            iq.setFrom(window.opener.parent.jid);
            iq.setIQ(cutResource(toId), 'get', 'history:msg');
            var query = iq.setQuery('history:msg:query');
            query.appendChild(iq.buildNode('begin_time',startTime));
            query.appendChild(iq.buildNode('end_time',endTime));
            query.appendChild(iq.buildNode('count', '100'));
            connWin.con.send(iq, showHistMessage,true);
            
        }
        
        /**
         * 初始化历史记录总页数，数据缓存
         */
        function showHistMessage(iq,iscount){
            var flag = false;
            //缓存总记录数
            if(iscount){
            	if (iq.getNode().getElementsByTagName('totalnum').length != 0) {
            			count = iq.getNode().getElementsByTagName('totalnum')[0].firstChild.nodeValue;
                  	  	var intCount = parseInt(count);
                    	if (intCount % 20 == 0) {
                        	totalPage = parseInt(intCount / 20);
                    	}
                    	else {
                        	totalPage = parseInt(intCount / 20 + 1);
                    	}
                   		currentPage = totalPage;
                   		flag = true;
            	}
            }
            _toID = iq.getFrom();
            var messages = initMessageByIq(iq);
            messages = endArray(messages);
            initHistMessage(messages, flag);
        }
        
        
        function photoToHTMLByIm(iq, memberId){
            var photo = '';
            var item = iq.getNode().getElementsByTagName('photo').item(0);
            if (item && item.firstChild) {
                photo = item.firstChild.nodeValue;
                connWin._PhotoMap.put(iq.getFrom(), photo);
                $('#' + memberId + 'Img').attr("src", photo);
            }
        }
        
        /**
         * 缓存历史记录
         */
        function initHistMessage(messages, flag){
            if (flag) {
                endNum = totalPage;
            }
            messgaeMap = new Properties();
            if (messages.length % 20 == 0) {
                leng = parseInt(messages.length / 20);
            }
            else {
                leng = parseInt(messages.length / 20 + 1);
            }
            startNum = endNum - leng + 1;
            var b = startNum + 1;
            if (b <= 1) {
                b = 2;
            }
            //计算最后一页改显示的内容
            var nums = startNum;
            if (nums <= 0) {
                nums = 1;
            }
			var g = 0; 
            var isShow = true;
            if (messages.length % 20 != 0) {
                messgaeMap.put(nums, messages.slice(0, messages.length % 20));
                isShow = false;
            }
            else {
                messgaeMap.put(nums, messages.slice(0, 20));
            }
            var s = 1;
            for (var i = endNum; i >= startNum; i--) {
                var array = new Array();
                var j = 0;
                if (!isShow) {
                    j = messages.length % 20;
                    isShow = true;
                }
                else {
					if (g == 0) {
						j = s * 20;
					}else{
						j = g;
					}
                }
                g = j + 20;
                if (g > messages.length) {
                    g = messages.length;
                }
                s++;
                j = parseInt(j);
                g = parseInt(g);
                messgaeMap.put(b, messages.slice(j, g));
                b++;
            }
            if(isShowStartPage){
				addHistorys(startNum);
				isShowStartPage = false;
			}else{
				addHistorys(endNum);
			}
        }
        
        /**
         * 设置聊天消息记录
         */
        function addHistorys(num){
            currentPage = num;
            var items = messgaeMap.get(currentPage);
			var lengths = 0;
			try {
				lengths = items.length;
			}catch(e){
				lengths = 0;
			}
            $('#' + chat.id + '_historytabbodytop').empty();
            var strTemp = "";
            for (var i = 0; i < lengths; i++) {
                var item = items[i];
                if (typeof(item) == "undefined") {
                	continue;
                }
                var body = item.body;
                for (var j = 0; j < face_texts_replace.length; j++) {
                    body = body.replace(face_texts_replace[j], "<img src='" + v3x.baseURL + "/apps_res/uc/chat/image/face/5_" + (j + 1) + ".gif' code='"+face_texts_replace[j].toString().substr(2,face_texts_replace[j].toString().length -6)+"]'/>");
                }
                var datetime = hrTime(item.time);
                var type = item.type;
                strTemp += "<div class='border_b padding_b_5 padding_t_5 font_size12 clearfix'>";
                strTemp += "<ul>";
                strTemp += "<li class='padding_0'>";
                strTemp += "<div><span class='color_gray margin_l_5'>" + item.name + "</span><span class='color_gray margin_r_5 margin_l_5'>" + datetime + "</span>";
                strTemp += "</div>";
            	if(type == 'filetrans'){
            		 var str ="";
            		 var _type = "file";
                     for(var k = 0 ; k < item.files.length ;k++){
                   	  str+="<span class ='"+querySpanClass(item.files[k].fileName)+"' style='cursor: default;'></span><font size ='2px'>"+item.files[k].fileName +"("+item.files[k].size+"KB)&nbsp;&nbsp;&nbsp;<a href='#'  id='12232' fid='"+item.files[k].fileId+"''  fname = '"+item.files[k].fileName+" 'onclick='downLoadFiles(\""+item.files[k].fileId+"\", \""+item.files[k].fileName+"\", \""+_type+"\")'>"+$.i18n('uc.title.download.js')+"</a> </font><br/>";
                     }
                     var fileNames ='';
                     if(body.length > 0 && body != ''){
                    	 body = body + "<br/>";
                     }
                     strTemp += "<div class='margin_t_10 word_break_all' style='margin-left:5px;word-wrap:break-word'><span class='font_size12'>" + body + fileNames+str + "</span></div>";
                } else if (type == 'image') {
                     var str ="";
                     var _type = "image";
                     for(var k = 0 ; k < item.files.length ;k++){
                       str+="<span class ='"+querySpanClass(item.files[k].fileName)+"' style='cursor: default;'></span><font size ='2px'>"+item.files[k].fileName +"("+item.files[k].size+"KB)&nbsp;&nbsp;&nbsp;<a href='#'  id='12232' fid='"+item.files[k].fileId+"''  fname = '"+item.files[k].fileName+" 'onclick='downLoadFiles(\""+item.files[k].fileId+"\", \""+item.files[k].fileName+"\", \""+_type+"\")'>"+$.i18n('uc.title.download.js')+"</a> </font><br/>";
                     }
                     var fileNames ='';
                     if(body.length > 0 && body != ''){
                        body = body + "<br/>";
                     }
                     strTemp += "<div class='margin_t_10 word_break_all' style='margin-left:5px;word-wrap:break-word'><span class='font_size12'>" + body + fileNames+str + "</span></div>";
                } else if(type == 'microtalk'){
                	var fname = item.files[0].fileName;
                	var size = item.files[0].size;
                	var fid = item.files[0].fileId;
                	var msize = size;
            		if(size < 10){
            			size = 1;
            		}else if(size < 20){
            			size = 2;
            		}else if(size < 30){
            			size = 3;
            		}else if(size < 40){
            			size = 4;
            		}else if(size < 50){
            			size = 5;
            		}else {
            			size = 6;
            		}
                	strTemp += "<div class='im_talk"+size+" margin_l_5' onclick =\"downPlayMicTalkByIms('"+fname+"','"+fid+"','"+msize+"','"+ i +"')\">";
                	strTemp += "<span class='ico16 speech_read_16 left' id ='"+i+"clase2'></span>";
                	strTemp += "<span class='color_gray right'>"+msize+"'</span>";
                	strTemp += "</div>";
                } else if (type == "vcard") {
                	var vcard = item.vcard;
                	var vcardStr = "<b style='font-weight: bold;'>"+$.i18n('uc.message.vcard.js')+"</b><br/><br/>";
                	if (vcard && vcard.name != '') {
                		vcardStr += addBr($.i18n('uc.message.name.js') ,vcard.name);
                	}
                    if (vcard && vcard.mobliePhone != '') {
                    	vcardStr += addBr($.i18n('uc.message.Mobiletelephone.js') ,vcard.mobliePhone);
                    }
                    if (vcard && vcard.iphone != '') {
                    	 vcardStr += addBr($.i18n('uc.message.iphone.js'),vcard.iphone);
                    }
                    if (vcard && vcard.address != '') {
                    	vcardStr += addBr($.i18n('uc.message.HomePhone.js') ,vcard.address);
                    }
                    if (vcard && vcard.workPhone != '') {
                    	vcardStr += addBr($.i18n('uc.message.workPhone.js') ,vcard.workPhone);
                    }
                    if (vcard && vcard.hPhone != '') {
                    	vcardStr += addBr($.i18n('uc.message.mainphone.js') ,vcard.hPhone);
                    }
                    if (vcard && vcard.adPhone != '') {
                    	vcardStr += addBr($.i18n('uc.message.HomeFax.js') ,vcard.adPhone);
                    }
                    if (vcard && vcard.workF != '') {
                    	vcardStr += addBr($.i18n('uc.message.WorkFax.js') ,vcard.workF);
                    }
                    if (vcard && vcard.ppG != '') {
                    	vcardStr += addBr($.i18n('uc.message.Paging.js') ,vcard.ppG);
                    }
                	strTemp += "<div class='margin_t_10 word_break_all' style='margin-left:5px;word-wrap:break-word'><span class='font_size12'>" + vcardStr + "</span></div>";
                } else{
                	strTemp += "<div class='margin_t_10 word_break_all' style='margin-left:5px;word-wrap:break-word'><span class='font_size12'>" + body + "</span></div>";
                }
              
                strTemp += "</li>";
                strTemp += "</ul>";
                strTemp += "</div>";
            }
            $('#' + chat.id + '_historytabbodytop').append(strTemp);
            //分页
            $('#' + chat.id + '_historytabbodybottom').empty();
            var x = startNum;
            if (x == 0) {
                x = 1;
            }
            var htmlstr = "";
            //在ie7低分辨率下因为不出滚动条，所以如果按照 padding_t_10 就会使分页整体下移
			htmlstr+="<div class='common_over_page right margin_r_10 padding_t_3 padding_r_5'>";
			if(startNum > 1){
            }else{
			}
			if(currentPage > 1){
				htmlstr+="<a href='#' class='common_over_page_btn' title='"+$.i18n('uc.page.prev.js')+"' onclick='javaScript:pageTurning(" + 2 + ")'><em class='pagePrev'></em></a>";
			}else{
			}
			htmlstr += "&nbsp;";
			if(endNum - x < 5){
				var c = 5-endNum - x;
				for(var g = 0; g < c; g++){
					htmlstr += "&nbsp;&nbsp;";
				}
			}
			for (var x; x <= endNum; x++) {
                if (x == currentPage) {
                    htmlstr += "<u>"+x + "</u>&nbsp;";
                }
                else {
                    htmlstr += "<a href='#' onclick='javaScript:addHistorys(" + x + ")'>" + x + "</a>&nbsp;";
                }
            }
			if(currentPage < totalPage){
				htmlstr+="<a href='#' class='common_over_page_btn' title='"+$.i18n('uc.page.next.js')+"' onclick='javaScript:pageTurning(" + 3 + ")'><em class='pageNext'></em></a>";
           	}else{
			}
			if(endNum < totalPage){
			}else{
			}
			 htmlstr +=  totalPage + $.i18n('uc.page.total.js');
			htmlstr+="</div>";
            $('#' + chat.id + '_historytabbodybottom').append(htmlstr);
            var elements = chat.id + "_historytabbodytop";
            var ex = document.getElementById(elements); 
            ex.scrollTop = ex.scrollHeight;   
            getA8Top().endProc();
        }
        
        /**
         * 翻页操作
         */
        function pageTurning(actions){
        	try{ //异常处理 ，防止后台请求总数据条数不为0 ，而数据为空时翻页报错
        		 if (actions == 1) {//向后翻页
                     getA8Top().startProc();
                     var endMessage = messgaeMap.get(endNum);
                     var endMessage1 = messgaeMap.get(endNum);
                     var mes = endMessage[endMessage.length - 1];
                     iq = window.opener.newJSJaCIQ();
                     iq.setFrom(window.opener.parent.jid);
                     iq.setIQ(_toID, 'get', 'history_msg2');
                     var query = iq.setQuery('history:msg:query');
                     query.appendChild(iq.buildNode('begin_time', mes.time));
                     query.appendChild(iq.buildNode('end_time'));
                     if (startLimeTime != null && endLimeTime != null) {
                        query.appendChild(iq.buildNode('limit_begin_time', startLimeTime));
                        query.appendChild(iq.buildNode('limit_end_time', endLimeTime));
                     }
                     query.appendChild(iq.buildNode('count', '100'));
                     endNum = endNum + 5;
     				if(endNum > totalPage){
     					endNum = totalPage;
     				}
     				connWin.con.send(iq, showHistMessage,false);
                 }
                 else if(actions == 0) {//向前翻页
                     getA8Top().startProc();
                     endNum = startNum - 1;
                     var endMessage = messgaeMap.get(startNum);
                     var mes = endMessage[0];
                     iq = window.opener.newJSJaCIQ();
                     iq.setFrom(window.opener.parent.jid);
                     iq.setIQ(_toID, 'get', 'history_msg1');
                     var query = iq.setQuery('history:msg:query');
                     query.appendChild(iq.buildNode('begin_time'));
                     query.appendChild(iq.buildNode('end_time',mes.time));
                     if (startLimeTime != null && endLimeTime != null) {
                        query.appendChild(iq.buildNode('limit_begin_time', startLimeTime));
                        query.appendChild(iq.buildNode('limit_end_time', endLimeTime));
                     }
                     query.appendChild(iq.buildNode('count', '100'));
                     connWin.con.send(iq, showHistMessage,false);
                     
                 }
     			else if(actions == 3){//后一页
     				var pageCont = currentPage + 1;
     				var endMessage = messgaeMap.get(pageCont);
     				if(endMessage.length > 0){
     					addHistorys(pageCont);
     				}else{
     					pageTurning(1);
     					isShowStartPage = true;
     				}
     				
     			}else if(actions == 2){//前一页
     				var pageCont = currentPage - 1;
     				var endMessage = messgaeMap.get(pageCont);
     				try {
     					if (endMessage.length > 0) {
     						addHistorys(pageCont);
     					}
     					else {
     						pageTurning(0);
     					}
     				}catch(e){
     					pageTurning(0);
     				}
     			}
        	}catch(e){
        		
        	}
        }
	
        /********************历史记录********************/
		/********************群成员********************/
		//方法用户缓存中没有群成员数量信息时请求服务器获取 youhb 2013年11月1日10:54:25
		function getGorupMember(gid){
			$('#' + chat.id + '_grouptabbody').empty();
            groupId = gid;
            iq = window.opener.newJSJaCIQ();
            iq.setFrom(window.opener.parent.jid);
            iq.setIQ(gid, 'get');
            var query = iq.setQuery('seeyon:group:query:info');
            connWin.con.send(iq, chaheGroupInfo);
		}

        function chaheGroupInfo(iq) {
            try {
                var info = iq.getNode().getElementsByTagName('group_info');
                var type = info[0].getAttribute('T'); 
                var groupjid = info[0].getAttribute('I');
                var count = info[0].getAttribute('M');
                $('#groupMemberCount').html("&nbsp;(" + count + ")");
                //更新缓存信息将请求的到的群成员数量，群主信息更新到缓存中 youhb 2013年11月1日10:54:18
                connWin.roster.groupMemberCountCache.put(groupjid,count);
                if (type == '4') {
                    group_nike = info[0].getAttribute('NI');
                    connWin.roster.groupNickCache.put(groupjid,group_nike);
                }
            }catch(e){
            	
            }
        }

        function getGroupInfoMember(gid) {
        	getA8Top().startProc();
        	groupId = gid;
        	//请求群成员信息时从缓存中获取群主信息 youhb 2013年11月1日 11:04:47
            var groupnike = connWin.roster.groupNickCache.get(gid);
            if (groupnike != null &&  typeof(groupnike) != 'undefined') {
            	group_nike = groupnike;
            }
            $('#' + chat.id + '_grouptabbody').empty();
            iq = window.opener.newJSJaCIQ();
            iq.setFrom(window.opener.parent.jid);
            iq.setIQ(gid, 'get', 'groupMemberByTalk');
            var query = iq.setQuery('seeyon:group:query:member');
            connWin.con.send(iq, showGroupMemberByTalk);
        }

		var groupMemberListByTalk;
		function showGroupMemberByTalk(iq){
		   groupMemberListByTalk = new Array();
            var members = iq.getNode().getElementsByTagName('jid');
            for (var i = 0; i < members.length; i++) {
                var memberid = members[i].getAttribute('J');
                groupMemberListByTalk[i] = memberid;
            }
			queryMemberInfoByTalk();
		}
		function queryMemberInfoByTalk(){
			var iq = window.opener.newJSJaCIQ();
                var uid = window.opener.parent.jid;
                iq.setFrom(uid);
                iq.setIQ(uid, 'get', 'groupmemberinfo');
                var query = iq.setQuery('jabber:iq:seeyon:office-auto');
				var org = iq.buildNode('organization',{'xmlns': 'organization:staff:info:query'});
				var staff = iq.buildNode('staff',{'dataType': 'json'});
				for(var j = 0 ;j<groupMemberListByTalk.length;j++){
					var jid = groupMemberListByTalk[j];
					var jidE = iq.buildNode('jid',jid);
					jidE.setAttribute('deptid','');
					staff.appendChild(jidE);
				}
				org.appendChild(staff);
				query.appendChild(org);
				connWin.con.send(iq, showGroupMessMemberByTalk);
		}
        
        
		function showGroupMessMemberByTalk(iq){
			groupMemberListByTalk = new Array();
            var groupMemberArray = new Array()
            var jids = iq.getNode().getElementsByTagName('staff');
            if (jids && jids.length > 0) {
            	try {
                    var item = '';
                    if (v3x.isFirefox) {
                        item = jids.item(0).innerHTML;
                    } else {
                        item = jids.item(0).firstChild.nodeValue;
                    }
                    var json = null;
                    try {
                        eval("json = " + item);
                    } catch (e) {
                    }
                    var membersJson = json["M"];
                    var count = 0;
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
                        if(memberId != '' && name != ''){
                            var items = {
                                id: jid,
                                name: name,
                                postname: postName,
                                dName: dName,
                                online: online,
                                photo: photo,
                                mood:mood,
                                memberId:memberId
                            };
                            
                            if (subResourcesByIm(group_nike) == subResourcesByIm(jid)) {
                                groupMemberArray[0] = items;
                                continue;
                            } else {
                                groupMemberListByTalk[count] = items;
                                count ++;
                            }
                        }                        
                    }                   
            	}catch(e){
            		
            	}
            }
			var memberCount = groupMemberArray.length + groupMemberListByTalk.length;
			//每次重新请求群成员时重新更新缓存信息 youhb 2013年11月1日10:52:51
			connWin.roster.groupMemberCountCache.put(groupId,memberCount);
			$('#groupMemberCount').html("&nbsp;(" + memberCount + ")")
            QuickSortArrayByTeamMember(groupMemberListByTalk,'name');
            if (groupMemberArray.length > 0) {
                if (addMemberByTalk(groupMemberArray,false)){
                    addMemberByTalk(groupMemberListByTalk,true);
                }
            } else {
                addMemberByTalk(groupMemberListByTalk,true);
            }
		}
		
		function addMemberByTalk(groupMemberListByTalk,isEnd){
			for (var i=0; i<groupMemberListByTalk.length; i++) {
				var people = groupMemberListByTalk[i];
                var nikeTitle = "";
                if (subResourcesByIm(people.id) == subResourcesByIm(group_nike)) {
                    nikeTitle ="<span class=' margin_r_5 groupnick_king'></span>";
                }
				var memberHTML = "<div class='clearfix border_b font_size12'>";
				   memberHTML += "  <div class='left margin_tb_5' style='height:30px;'><img class='radius' src='" + people.photo + "' height='30' width='30' /></div>";
				   memberHTML += "  <div class='left margin_l_5 margin_tb_5'>";
				   if (window.opener.parent.jid ==  people.id) {
					   memberHTML += "    <p> " + nikeTitle + people.name +"</p>" ;
				   } else {
					   memberHTML += "    <p><a onclick='window.opener.openWinIM(\"" + people.name  + "\", \"" + people.id + "\")'>" + nikeTitle +  people.name + "</a></p>";
				   }
				   memberHTML += "    <p>" + people.dName + "</p>";
				   memberHTML += "  </div>";
				   memberHTML += "</div>";
				$('#' + chat.id + '_grouptabbody').append(memberHTML);
			}
			if (isEnd) {
				getA8Top().endProc();
			}
            return true;
		}
        function downLoadFiles(fid,fname,type){
    		downFilePath(fid,fname,window.opener.parent.con,window.opener,type);
      }
        var obj = '';
        function downPlayMicTalkByIm(fname,fid,size,i){
        	var ischeck = checkPlugins('QuickTime','');
        	if (ischeck) {
	        	$('#'+i+'clase1').removeClass('speech_read_16').addClass('speech_gif_16');
	        	obj = $('#'+i+'clase1');
        	}
        	downMicTalkPath(fid,fname,size,'implay',window.opener.parent.con,window.opener);
        	if (ischeck) {
        		var zsize = parseInt(size)+2;
       	  		window.setTimeout("closeClass1()",zsize*1000);
        	}
        }
        function downPlayMicTalkByIms(fname,fid,size,i){
        	var ischeck = checkPlugins('QuickTime','');
        	if (ischeck) {
	        	$('#'+i+'clase2').removeClass('speech_read_16').addClass('speech_gif_16');
	        	obj = $('#'+i+'clase2');
        	}
        	downMicTalkPath(fid,fname,size,'implay',window.opener.parent.con,window.opener);
        	if (ischeck) {
        	 	var zsize = parseInt(size)+2;
       	  		window.setTimeout("closeClass1()",zsize*1000);
        	}
        }
        function closeClass1(){
      	  obj.removeClass('speech_gif_16').addClass('speech_read_16');
        }
        
        function endArray(array){
            var array1 = new Array();
            var k = 0;
            for (var i = array.length - 1; i >= 0; i--) {
                array1[k] = array[i];
                k++;
            }
            return array1;
        }
        $(document).click(function(event){
        	if(event.target.className == 'img-button cursor-hand left' || event.target.className == 'common_button common_button_gray margin_r_10 hand' || event.target.className.indexOf('ico16') >= 0|| event.target.className == 'dialog_close right' || event.target.className =='hand' || event.target.id.indexOf('_facediv') >= 0 || event.target.id =='img' || event.target.className.indexOf('file') >= 0 || event.target.className == 'clearfix align_right' || event.target.id == 'checkon' || event.target.className == 'common_send_people_box' || event.target.className == 'ico16 affix_del_16'){
        	
        	}else{
        		if (filePathList.length <= 0) {
        			isclose = true;
                	isClose = true; 
                	isclosefile();
                    clearFilePath();
                    closeWin();
        		}
        	}
        });
        
        function openIM(name,jid) {
        	connWin.openWinIM(name,jid);
        }
        
        function saveVcard(vcardName,htmlId){
        	var vcards = new Properties();
        	var vcard = vcardMap.get(vcardName);
        	//处理名片信息对应通讯录
        	var vcardName = '';
        	if (vcard.name != null && vcard.name.size() > 0) {
        		vcardName = vcard.name.get(0);
        	}
        	var vcardMobliePhone = '';
        	if (vcard.mobliePhone != null && vcard.mobliePhone.size() > 0) {
        		vcardMobliePhone = vcard.mobliePhone.get(0);
            } else {
            	var iphoneLength = getItemLength('iphone',vcards);
            	var addressLength = getItemLength('address',vcards);
            	var workPhoneLength = getItemLength('workPhone',vcards);
                if (vcard.iphone != null && vcard.iphone.size() > iphoneLength) {
                	vcardMobliePhone = vcard.iphone.get(iphoneLength);
                    vcards.put('iphone',iphoneLength);
                } else if (vcard.address != null && vcard.address.size() > addressLength) {
                	vcardMobliePhone = vcard.address.get(addressLength);
                    vcards.put('address',addressLength);
                } else if (vcard.workPhone != null && vcard.workPhone.size() > workPhoneLength) {
                	vcardMobliePhone = vcard.workPhone.get(workPhoneLength);
                    vcards.put('workPhone',workPhoneLength);
                }
            }
        	var vcardWorkPhone = '';
        	if (vcard.workPhone != null && vcard.workPhone.size() > 0) {
        		vcardWorkPhone = vcard.workPhone.get(0);
        	} else {
                var iphoneLength = getItemLength('iphone',vcards);
                var addressLength = getItemLength('address',vcards);
                var mobliePhoneLength = getItemLength('mobliePhone',vcards);
                if (vcard.iphone != null && vcard.iphone.size() > iphoneLength) {
                	vcardWorkPhone = vcard.iphone.get(iphoneLength);
                    vcards.put('iphone',iphoneLength);
                } else if (vcard.address != null && vcard.address.size() > addressLength) {
                	vcardWorkPhone = vcard.address.get(addressLength);
                    vcards.put('address',addressLength);
                } else if (vcard.mobliePhone != null && vcard.mobliePhone.size() > mobliePhoneLength) {
                	vcardWorkPhone = vcard.mobliePhone.get(mobliePhoneLength);
                    vcards.put('mobliePhone',mobliePhoneLength);
                }
        	}
        	var vcardAddress = '';
            if (vcard.address != null && vcard.address.size() > 0) {
            	vcardAddress = vcard.address.get(0);
            } else {
                var iphoneLength = getItemLength('iphone',vcards);
                var workPhoneLength = getItemLength('workPhone',vcards);
                var mobliePhoneLength = getItemLength('mobliePhone',vcards);
                if (vcard.iphone != null && vcard.iphone.size() > iphoneLength) {
                	vcardAddress = vcard.iphone.get(iphoneLength);
                    vcards.put('iphone',iphoneLength);
                } else if (vcard.workPhone != null && vcard.workPhone.size() > workPhoneLength) {
                	vcardAddress = vcard.workPhone.get(workPhoneLength);
                    vcards.put('workPhone',workPhoneLength);
                } else if (vcard.mobliePhone != null && vcard.mobliePhone.size() > mobliePhoneLength) {
                	vcardAddress = vcard.mobliePhone.get(mobliePhoneLength);
                    vcards.put('mobliePhone',mobliePhoneLength);
                }
            }
            var vcardFax = '';
            if (vcard.workF != null && vcard.workF.size() > 0) {
            	vcardFax = vcard.workF.get(0);
            } else {
            	if (vcard.adPhone != null && vcard.adPhone.size() > 0) {
            		vcardFax = vcard.adPhone.get(0);
            	} else if (vcard.otherF != null && vcard.otherF.size() > 0) {
            		vcardFax = vcard.otherF.get(0);
            	}
            }
            
            var vcardEmail = '';
            if (vcard.workMail != null && vcard.workMail.size() > 0) {
            	vcardEmail = vcard.workMail.get(0);
            } else {
            	if (vcard.addressMail != null && vcard.addressMail.size() > 0) {
            		vcardEmail = vcard.addressMail.get(0);
            	} else if (vcard.otherMail != null && vcard.otherMail.size() > 0) {
            		vcardEmail = vcard.otherMail.get(0);
            	}
            }     
        	var datas = {
        			'name':vcardName,
        			'mobilePhone':vcardMobliePhone,
        			'familyPhone':vcardAddress,
        			'companyPhone':vcardWorkPhone,
        			'fax':vcardFax,
        			'email':vcardEmail,
        			'isCreated':'true'
        	}
            $.ajax({
                type: "POST" , 
                data: datas,
                url : window.opener._ctpPath+"/addressbook.do?method=creatVcardByUc",
                timeout : 10000,
                success : function (jessn){
                	try{
                        var jso = eval(jessn);
                        if (jso[0].res == '1') {
                        	var  htmlStr ='<tr class="ucChat_gap"><td colspan="5" align="center" class="color_gray2">----名片成功保存在私人通讯录中----</td></tr>';
                        	htmlStr +='<tr class="ucChat_gap"><td colspan="5"></td></tr>'
                        	$('#' + htmlId + '_ul').append(htmlStr);
                        } else if (jso[0].res == '2') {
                        	var htmlStr ='<tr class="ucChat_gap"><td colspan="5" align="center" class="color_gray2">----私人通讯录已存在相同姓名的人----</td></tr>';
                        	htmlStr +='<tr class="ucChat_gap"><td colspan="5"></td></tr>'
                        	$('#' + htmlId + '_ul').append(htmlStr);
                        } else {
                        	var htmlStr ='<tr class="ucChat_gap"><td colspan="5" align="center" class="color_gray2">----名片保存出错----</td></tr>';
                        	htmlStr +='<tr class="ucChat_gap"><td colspan="5"></td></tr>'
                        	$('#' + htmlId + '_ul').append(htmlStr);
                        }
                	}catch(e){
                		alert('异常 ');
                	}
                }
            });
        }
        
        function queryShowImgPath (fid, tagger) {
        	var iqs = window.opener.newJSJaCIQ();
        	iqs.setFrom(window.opener.jid);
            iqs.setIQ('filetrans.localhost', 'get');
            var query1 = iqs.setQuery('filetrans');
            query1.setAttribute('type' ,'get_picture_download_url');
            query1.appendChild(iqs.buildNode('id', '', fid+"_1"));
            connWin.con.send(iqs, showImgFunByIm,tagger);
        }
        
        function showImgFunByIm (iq, tagger) {
        	if (iq && iq.getType() != 'error') {
        		var url = iq.getNode().getElementsByTagName('downloadurl')[0].firstChild.data;
        		document.getElementById(tagger+"_img").src = url;
        	}
        }
        
        function addTr (name,nodeList) {
        	var htmlStr = '';
            if (nodeList != null && nodeList.size() > 0) {
            	for (var i = 0 ; i < nodeList.size(); i ++) {
            		var showName = name;
                    htmlStr +='<tr>';
                    htmlStr +='<td align="right">'+showName+':</td>';
                    htmlStr +='<td align="left">'+nodeList.get(i)+'</td>';
                    htmlStr +='</tr>';
            	}
            }
        	return htmlStr;
        }
        function addBr (name,nodeList) {
            var htmlStr = '';
            if (nodeList != null && nodeList.size() > 0) {
                for (var i = 0 ; i < nodeList.size(); i ++) {
                    var showName = name;
                    htmlStr += showName +":" + nodeList.get(i) +"<br/>";
                }
            }
            return htmlStr;
        }
        
        function getItemLength (name , itemMap) {
        	var retLength = 0;
            if (itemMap.get(name) != null && typeof(itemMap.get(name)) != 'undefined') {
            	retLength = itemMap.get(name) + 1;
            }
            return retLength;
        }
        
        function subResourcesByIm (jids) {
            var newJid = '';
            if (jids.indexOf('@') > -1) {
                newJid = jids.substr(0,jids.indexOf('@'));
            } else {
                newJid = jids;
            }
            return newJid;
        }
        window.onload = function () {
        	connWin.isIMonload = true;
        }
		/********************群成员********************/
    </script>
</head>
<body class="h100b" style="background-color:#D9D9D9;">
	<div id='implay'></div>
	<iframe id="downloadFileFrame" src="" class="hidden"></iframe>
    <form method="get" target="_blank" id="downloadFileFrom"></form>
</body>
</html>