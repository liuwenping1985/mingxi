<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
		<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache"> 
		<META HTTP-EQUIV="Expires" CONTENT="0"> 
        <title>${ctp:i18n('uc.title.js')}</title>
        <link type="text/css" rel="stylesheet" href="<c:url value='/apps_res/uc/chat/css/uc.css${ctp:resSuffix()}' />">
        <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/seeyon.ui.uc.card-debug.js${ctp:resSuffix()}" />"></script>
        <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/seeyon.ui.uc.face-debug.js${ctp:resSuffix()}" />"></script>
   		<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/seeyon.ui.uc.upload-debug.js${ctp:resSuffix()}" />"></script>
   		<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/jquery.ztree.all-3.5.js${ctp:resSuffix()}" />"></script>
        <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/json2.js${ctp:resSuffix()}" />"></script>
        <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/shared.js${ctp:resSuffix()}" />"></script>
        <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/uc_org.js${ctp:resSuffix()}" />"></script>
        <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/uc_upload.js${ctp:resSuffix()}" />"></script>
        <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/uc_hismsg.js${ctp:resSuffix()}" />"></script>
        <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/uc_team.js${ctp:resSuffix()}" />"></script>
        <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/uc_relate.js${ctp:resSuffix()}" />"></script>
        <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/uc/chat/js/uc_msg.js${ctp:resSuffix()}" />"></script>
        <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/CollaborationApi.js${ctp:resSuffix()}"/>"></script>
        
		<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/webmail/js/webmail.js${ctp:resSuffix()}" />"></script>
        <object classid="clsid:95E88F55-7F1E-4F5D-AC18-0E1F08BDDF21" id="UC_UPLOAD" data="DATA:application/x-oleobject;BASE64,EcQUs+rmGUC2v8saHQ7GHgADAABoLgAAzxIAABMAzc3NzRMAzc3NzQsA//8=" width="90%" height="0" class="hidden"></object>
        <script type="text/javascript">
        	var msg_data = [];
            var v3x = new V3X();
    	    v3x.init("${pageContext.request.contextPath}", "<%=com.seeyon.ctp.common.i18n.LocaleContext.getLanguage(request)%>");
    	    var connWin = getA8Top().window.opener;
            var isFromA8 = "${param.from}" == "a8";
    	    var defaultPhoto = v3x.baseURL + "/apps_res/v3xmain/images/personal/pic.gif";
    	    var defaultTeamPhoto = v3x.baseURL + "/apps_res/uc/chat/image/Group3.jpg";

    	    var Cache_S_Jids = new Properties();
    	    var Cache_S_Names = new Properties();

    	    var isGroupVer = "${isGroupVer}";
    	    var accessableAccountIds = new Properties();
    	    <c:if test="${isGroupVer == 'true'}">
    		<c:forEach items="${accessableAccountIds}" var="accountId">
    		  accessableAccountIds.put("${accountId}", true);
    		</c:forEach>
    	    </c:if>
    	    <c:if test="${isInternal == 'false'}">
              <c:forEach items="${accessableDepartmentIds}" var="deptId">
                connWin.accessableDepartmentIds.put("${deptId}", true);
              </c:forEach>
              <c:forEach items="${accessableDepartmentId}" var="deptId">
                connWin.accessableDepartmentId.put("${deptId}", true);
              </c:forEach>
              <c:forEach items="${accessableMemberIds}" var="deptId">
                connWin.accessableMemberIds.put("${deptId}", true);
              </c:forEach>
            </c:if>
            
    	    var cacheType = "uc";
            var pageChatMoreData = [];
            function pageChatMore(d) {
            	if(msg_data.lenght > 0){
            		$('#pageChatTabsMore').eq(0).addClass('uc_msg');
            	}
        		$("#pageChatTabsMoreMenuList a").each(function() {
        			if ($(this).hasClass("uc_msg")) {
        				var _id = $(this).attr("id");
        				msg_data.push(_id);
        			}
        		});
        		$("#pageChatTabs a").each(function() {
        			if ($(this).hasClass("uc_msg")) {
        				var _id = $(this).parent().attr("id");
        				msg_data.push(_id);
        			}
        		});
        		$("#pageChatTabsMore").menuSimple({
        			id : "pageChatTabsMoreMenuList",
        			width : 100,
        			offsetTop : -4,
        			data : d
        		});
        		
        	}
            //绑定下拉列表click
                $("#pageChatTabsMoreMenuList a").live("click", function () {
                var filesitem = '';
                if ($('#sendFile').html().indexOf('jid') > 0) {
                    filesitem = {
                        fileMemberList : fileMemberList,
                        fidList : fidList,
                        filePathList : filePathList,
                        fileSize : 1
                    };
                }
                var item = {
                    msg : $('#MessageInput').html(),
                    files : filesitem
                };
				msgHtmlMap.put(toName,item);
                var _jid = $(this).attr("jid");	
                var _id = $(this).attr("id");
                var _title = $(this).text();
                var _name = $(this).attr("name");
                var _time = $(this).attr("time");
                var _pageChatJid = $(this).attr("pageChatJid");
                var _className = $(this)[0].className;
            	var isremoveclass = true; 
               	$(this).eq(0).removeClass('uc_msg');
               	var _index = msg_data.indexOf(_id);
               	msg_data.splice(_index, 1);
                $('#pageChatTabsMoreMenuList a').each(function (){
               		var clasname = $(this)[0].className;
               		if(clasname.indexOf('uc_msg') >= 0){
               			isremoveclass = false;
               		}
               	});
                if(isremoveclass){
                	$('#pageChatTabsMore').eq(0).removeClass('uc_msg');
                }
                saveToName(_name,_time);
                $('#sendFile').html('');
            	$('#sendFile').hide();
            	$('#MessageInput').empty();
                $(".pageChatArea .pageChatArea_textarea").keyup();
                if($('#sendFile').html().indexOf('jid') > 0){
                	$(".pageChatArea .pageChatArea_btnSubmit").removeClass("common_button_emphasize common_button_disable").addClass("common_button_emphasize");
                }else{
                	$(".pageChatArea .pageChatArea_btnSubmit").removeClass("common_button_emphasize common_button_disable").addClass("common_button_disable");
                }
                $('#ids_close').click();
                $('#imgid_close').click();
                clearList();
                if(connWin.roster.DeleteUser.get(_jid)){
                	$('#sendCheck').removeClass('common_button');
        			$('#sendCheck').hide();
                 }else{
                	$('#sendCheck').removeClass('common_button').addClass('common_button');
         			$('#sendCheck').show();
                }
                getA8Top().startProc();
                isHistoryFlush = true;
				if (msgHtmlMap.get(toName) != null && msgHtmlMap.get(msgHtmlMap) != '') {
					$('#MessageInput').html(msgHtmlMap.get(toName).msg);
                    if (msgHtmlMap.get(_name).files != null && msgHtmlMap.get(_name).files != '') {
                        fileMemberList = msgHtmlMap.get(_name).files.fileMemberList; 
                        fidList = msgHtmlMap.get(_name).files.fidList; 
                        filePathList = msgHtmlMap.get(_name).files.filePathList;
                        fileSize =  msgHtmlMap.get(_name).files.fileSize;
                        showFilesHTML($('#sendFile'));
                        $('#sendFile').show();
                    }
				}
                queryHistoryMess(_jid,_name);
                $(".pageChatList").hide();
                $(".pageChatArea").show();
                pageChatMoreData.unshift({
                    id: $("#pageChatTabs li:eq(2)").attr("id"),
                    name: $("#pageChatTabs li:eq(2) a").html(),
                    customAttr : "jid = '"+$("#pageChatTabs li:eq(2)").attr("jid")+"' pageChatJid = '"+$("#pageChatTabs li:eq(2)").attr("jid")+"' name='"+$("#pageChatTabs li:eq(2)").attr("name")+"'"
                });
                for (var i = 0; i < pageChatMoreData.length; i++) {
                    if (pageChatMoreData[i].id == _id) {
                        pageChatMoreData.splice(i, 1);
                    }
                }
                pageChatMore(pageChatMoreData);
                //修改tab第3个li的id和name，并放到第一位
                $("#pageChatTabs li").eq(2).attr("id", _id).attr("jid",_jid).attr("pageChatJid",_pageChatJid).attr("name",_name).find("a").html("<span class=\"ico16 send_messages_16 margin_r_5\"></span>"+_name).attr("title", _title);
                $("#pageChatTabs ul").prepend($("#pageChatTabs li").eq(2));
                //修改tab边线
                $("#pageChatTabs li").removeClass("current").removeClass("border_b");
                $("#pageChatTabs li").eq(0).addClass("current").find("a").addClass("border_b").addClass("text_overflow");
              //设置有未读消息状态
        		$("#pageChatTabs a").removeClass('uc_msg');
       			for ( var i = 0; i < msg_data.length; i++) {
       				$("#pageChatTabsMoreMenuList a[id='" + msg_data[i] + "']").addClass("uc_msg");
       				$("#pageChatTabs li[id='" + msg_data[i] + "'] a").addClass("uc_msg");
       			}
            });
            
	        function focusTab() {
	        	var types = "${v3x:toHTML(param.showtype)}";
	       
	        	if (types.indexOf("msg") > -1) {
	        		
	        		/* $("#Uc_Msg").trigger("click"); */
	        		 $('#all_msg').click();
                } 
	       /*  	else if (types.indexOf("org") > -1) {
                	$("#Uc_Org").trigger("click");
                } */
		    }
            
            $(function(){
            	getA8Top().startProc();
         	try{
         		setCurrentUser(connWin.jid,$.ctx.CurrentUser.loginAccount,$.ctx.CurrentUser.isInternal);
         		focusTab();
         		
                    //getCurrentUser();
            	}catch(e){
            		window.close();
            	} 
                //*************个性签名*****************
                $("#uc_mood").focus(function(){
                    $(this).css({
                        border: "solid 1px #B6B6B6",
                        padding: "5px"
                    });
                    if ($(this).attr("mood") == "") {
                        $(this).text("");
                    }
                    var _lllll = $(this).text().length;
                    var _offset = $(this).offset();
                    $("<span id='number_span_span' class='color_gray2 font_size12'>"+$.i18n('uc.message.enter.check1.js')+"<span id='number_span' class='color_black font_size16'>" + (100 - _lllll) + "</span>"+$.i18n('uc.message.enter.check2.js')+"</span>").css({
                        'position': 'absolute',
                        'top': _offset.top -20 ,
                        'left': _offset.left + $(this).width() - 100
                    }).appendTo($('body'));
                }).focusout(function(){
                    $(this).css({
                        border: "",
                        padding: ""
                    });
                    $('#number_span_span').remove();

                    $(this).find('img').each(function(){
                        $(this).remove();
                    });
                    $(this).find('a').each(function(){
                          $(this).after($(this).text()).remove();
                    });
                    var str = $(this).text();
                    if (str == "") {
                        $(this).text($.i18n('uc.mood.edit.js'));
                        $(this).attr("mood", '');
                    }
                    $(this).attr("mood", str);
                    
                    var iq = parent.window.opener.newJSJaCIQ();
                    iq.setIQ(null, 'set', 'publish1');
                    var text = iq.buildNode('text', '', str.substr(0,100));
                    var mood = iq.buildNode('mood', {
                        'xmlns': 'http://jabber.org/protocol/mood'
                    });
                    var item = iq.buildNode('item');
                    var publish = iq.buildNode('publish', {
                        'node': 'http://jabber.org/protocol/mood'
                    });
                    var pubsub = iq.buildNode('pubsub', {
                        'xmlns': 'http://jabber.org/protocol/pubsub'
                    });
                    mood.appendChild(text);
                    item.appendChild(mood);
                    publish.appendChild(item);
                    pubsub.appendChild(publish);
                    iq.appendNode(pubsub);
                    connWin.con.send(iq);
                    if (str != "") {
                        $('#uc_mood').text(str.substr(0,100));
                    }
                }).keyup(function(event){
                    if (event.keyCode == "13") {
                    	$(this).focusout();
                    	$("#Uc_Msg").focus();
                    }
                    var _length = $(this).text().length;
                    var __ll = 100 - _length;
                    if (__ll < 0) {
                        __ll = 0;
                        $(this).text($(this).text().substr(0, 100));
                        $('#number_span').text(0);
                    }
                    else {
                        $('#number_span').text(__ll);
                    }
                }); 
                
                /************导航菜单******************/
				$(".uc_menu a").click(function(){
				    $('#sendMessageByTeam').hide();
				    isHistoryFlush = false;
				    $('#quertMember').hide();
				    $('#addGroup').hide();
				    $('#addper').hide();
				    $(".uc_menu a").removeClass("current");
				    $(this).addClass("current");
				    if(parent.window.opener.hasMsg){
				    	$('#Uc_Msg').addClass('current');
				    }
				    $("div[id^='Uc_']").hide();
				    $("#" + $(this).attr("id") + "_Content").show();
				    var rootNode;
				   if ($(this).attr("id") == "Uc_Org") {
				    	$('#queryOrgMember').removeClass('color_gray').addClass('color_gray').val($.i18n('uc.staff.name.js'));
				        $('#relate').empty();
				        
				        /* getA8Top().startProc(); */
				    		$("#onlineUserTreeIframe").attr("src",v3x.baseURL + '/uc/chat.do?method=showOnlineUserTree');
				    		$("#onlineUserListIframe").attr("src",v3x.baseURL + '/uc/chat.do?method=showOnlineUserList');
				        /* cacheOrgModel(_CurrentAccountId); */
				        
				    } else 	if ($(this).attr("id") == "Uc_Team") {
				        if (groupclick) {
				            groupclick = false;
				            getA8Top().startProc();
				            $('#groupTitle').empty();
				            $('#grouplist').empty();
				            $('#pageList').empty();
				            $('#groupName').removeClass('color_gray').addClass('color_gray').val($.i18n('uc.group.showname.js'));
				            $('#groupMemberName').removeClass('color_gray').addClass('color_gray').val($.i18n('uc.staff.name.js'));
				            try {
				                groupMap.clear();
				                treeList.length = 0;
				            } catch (e) {
				                $(".uc_tree_list").show();
				                var iq = connWin.newJSJaCIQ();
				                iq.setFrom(_CurrentUser_jid);
				                iq.setIQ('group.localhost', 'get');
				                var query = iq.setQuery('seeyon:group:query:info');
				                connWin.con.send(iq, showGroup);
				            }
				            $(".uc_tree_list").show();
				            var iq = connWin.newJSJaCIQ();
				            iq.setFrom(_CurrentUser_jid);
				            iq.setIQ('group.localhost', 'get');
				            var query = iq.setQuery('seeyon:group:query:info');
				            connWin.con.send(iq, showGroup);
				        }
				    } else if ($(this).attr("id") == "Uc_Relate") {
				    	$('#reMember').removeClass('color_gray').addClass('color_gray').val($.i18n('uc.staff.name.js'));
				        showRelate();
				    } else if ($(this).attr("id") == "Uc_Msg") {
				    	parent.window.opener.hasMsg = false;
				    	$('#Uc_Msg').attr('style','');
				        $('#all_msg').click();
				    }
				    $(window).scrollTop(0);
				});

	            $("#currentAccountId").width($('#select_input_div').width() - 18);
                if (isGroupVer == "true") {
	                $(".select_input_div").click(function(){
	                    try {
	                    	getUnits();
	                    } catch (e) {}
	                });
                } else {
                	$(".select_input_div").hide();
                }
                
                /************消息输入框*************/
                var common_send_toggle = false;
                $(".common_send .common_send_show").click(function(){
                    $(".common_send .common_send_box_btnSubmit").removeClass("common_button_emphasize common_button_disable").addClass("common_button_disable");
                    $(this).hide();
                    $('#common_send_people').hide();
                    $('#common_send_people').removeClass('margin_b_10');
                    $(this).parents(".common_send").find(".common_send_box").show().find(".common_send_textarea").focus();
                });
                
                $(".common_send").mouseenter(function(){
                    common_send_toggle = false;
                }).mouseleave(function(){
                    common_send_toggle = true;
                });
                
                //选人界面
                $('#selectPeople').click(function(){
        			var backData = [];
        			$('#common_send_people span').each(function(i){
        				backData[i] = {'type' : $(this).attr('type'), 'id' : $(this).attr('id'), 'source' : $(this).attr('source'), 'name' : $(this).text()};
        		    });
                	
                	var dialog = $.dialog({
                    	id : 'UC_SelectPeople',
					    title : $.i18n('uc.message.select.people.js'),
					    url : v3x.baseURL + '/uc/chat.do?method=selectPeople',
					    width : 600,
					    height : 415,
					    targetWindow : getA8Top(),
					    transParams : {
						    "showCheck" : true,
						    data : backData
						},
					    buttons : [{
							text : $.i18n('uc.button.ok.js'),
							handler : function() {
					    		$('#common_send_people').empty();
					    		var result = dialog.getReturnValue();
					    		if (result.data.length > 0) {
						    		var cacheJids = result.cacheJids;
						    		for (var i = 0; i < cacheJids.size(); i++) {
							    		var key = cacheJids.keys().get(i) + "";
							    		var value = cacheJids.get(key) + "";
							    		Cache_S_Jids.put(key, value);
							    	}
							    	
						    		var cacheNames = result.cacheNames;
						    		for (var i = 0; i < cacheNames.size(); i++) {
							    		var key = cacheNames.keys().get(i) + "";
							    		var value = cacheNames.get(key) + "";
							    		Cache_S_Names.put(key, value);
							    	}
							    	
						    		var html = '';
						    		for (var i = 0; i < result.data.length; i++) {
							    		var data = result.data[i];
							    		html += '<span class="common_send_people_box" id="' + data.id + '" source="' + data.source + '" type="' + data.type + '">' + data.name + '<em class="ico16 affix_del_16"></em></span>';
							    	}
						    		$('#common_send_people').addClass('margin_b_10');
						    		$('#common_send_people').show();
							    	$('#common_send_people').html(html);
							    	var str = $('#sendInput').text().replace( /^\s*/, '');
                                    if (str.length > 0 || $('#common_send_file').html().indexOf('jid') > 0) {
                                         $(".common_send .common_send_box_btnSubmit").removeClass("common_button_emphasize common_button_disable").addClass("common_button_emphasize");
                                    }
	
							    	$('.common_send_people_box').click(function(){
                                        $(this).remove();
                                        if ($('#common_send_people').html().indexOf('source') < 0) {
                                            $(".common_send .common_send_box_btnSubmit").removeClass("common_button_emphasize common_button_disable").addClass("common_button_disable");
                                        }
		                    		});
                                    dialog.close();
						    	} else {
                                    $.alert($.i18n('uc.group.personnel.check.js'));
                                }
							}
						}, {
							text : $.i18n('uc.button.cancel.js'),
							handler : function() {
								dialog.close();
							}
						}]
					});
                });
                
                $(document).click(function(event){
                	if( event.target.className== 'face_img_class' || event.target.className == 'left margin_t_5' || event.target.className.indexOf('ico16') >= 0 || event.target.className == 'dialog_shadow absolute'|| event.target.className== 'common_send_box_btnSubmit common_button right common_button_disable'|| event.target.className == 'uc_layout_sideL' || event.target.className == 'gravatar left margin_r_20 ucFaceImage' || event.target.className == 'dialog_main_content_html padding_5 margin_5' || event.target.className == 'file_select padding_10 border_all clearFlow' || event.target.className=='current'|| event.target.className== 'inputys' ||event.target.className== 'dialog_close right' ||event.target.className == 'dialog_main_content absolute' || event.target.className == 'myFole' || event.target.className =='clearfix' ||event.target.className =='dialog_main_body left' || event.target.className == 'file_unload clearfix' ||event.target.className == 'common_button common_button_emphasize' ||event.target.className == 'common_button common_button_emphasize' ||event.target.className == 'common_send_people_box' || event.target.className =='ico16 affix_del_16' || event.target.className =='file_select padding_10 border_all clearfix' || event.target.className =='clearfix align_right' || event.target.className =='dialog_close right' || event.target.className =='common_button common_button_emphasize margin_r_10'){
                		
                	}else{
                		if (common_send_toggle) {
                			var myfileStr = '';
                			if($('#mytop').length > 0){
                				myfileStr = $('#mytop').html();
                			}
                			if($('#sendInput').html().length <= 0 || $('#sendInput').html() == '<br>'){
	                			if( $('#common_send_people').html().indexOf('source') < 0 && $('#common_send_file').html().indexOf('jid') < 0 && myfileStr.indexOf('jid') < 0){
	                			//再点击交流区之外的区域之前是关闭所有，但是要求正在上传文件的时候是不能关闭的，所以加了判断是否有正在上穿或者上传完成的文件
	                			if (filePathList.length <= 0) {
	                				$('#common_send_file').hide();
	                				$('#common_send_file').removeClass('margin_b_10');
		                            $(".common_send .common_send_box").hide().find(".common_send_textarea").html("");
		                            $('#common_send_file').html('');
		                            $("#selectPeople_container").remove();
		                            $(".common_send .common_send_show").show();
		                            if(iscloseImg){
		                            	clearFileAndImg(event);
		                            }
		                            isclosefile();
				                    clearFilePath();
		                            $(".common_send .common_send_textarea").keyup();
	                			}
		                            closeWin();
	                			}
                			}
                        }else if(iscloseImg){
                        	clearFileAndImg(event);
                        }
                	}
                	//$(".common_send .common_send_box_btnSubmit").removeClass("common_button_emphasize common_button_disable").addClass("common_button_disable");
                	
                	getA8Top().endUCActionTitle();
                });
                $(".common_send .common_send_textarea").keyup(function(){
                	//谷歌和火狐不支持
                	try{
                		sendPox = document.selection.createRange();
                	}catch(e){
                		sendPox = null;
                	}
                    $(this).find("img").each(function(){
                        $(this).after($(this).attr("code")).remove();
                    });
                	var imgl = 0;
                	$(this).find('img').each(function (){
                		imgl ++;
                	});
                    var sss = $(this).text();
                    var _length = sss.length;
                    var n = 1000 - isOverBytes(sss) / 2;
                    var __ll = 1000-_length;
                    __ll = __ll - imgl;
                    _length = _length + imgl;
                    var str=$(this).text().replace( /^\s*/, '');
                    if(__ll<0){
                    	 $(".common_send .common_send_textarea_length").html(__ll);
                    }else{
                        $(".common_send .common_send_textarea_length").html(__ll);
                        if(str.length > 0 && $('#common_send_people').html().indexOf('source') > 0){
                        $(".common_send .common_send_box_btnSubmit").removeClass("common_button_emphasize common_button_disable").addClass("common_button_emphasize");
                        }
                    }
                    if(_length == 0 || str.length <= 0){
                    	if ($('#common_send_file').html().indexOf('jid') < 0) {
	                        $(".common_send .common_send_box_btnSubmit").removeClass("common_button_emphasize common_button_disable").addClass("common_button_disable");
                    	} 
                      }
                    
                });
                $(".common_send .common_send_people .common_send_people_box").click(function(){
                    $(this).remove();
                });
				var memberID = null;
                $('.common_send .common_send_box_btnSubmit').click(function(){
                    fidList = new Array();
                    $('#common_send_file').find('.common_send_people_box').each(function(){
                        var item = {
                            'date':$(this).attr('fdate'),
                            'fid':$(this).attr('jid'),
                            'fname':$(this).attr('fname'),
                            'fsize':$(this).attr('fsize'),
                            'hash':$(this).attr('hash')
                        };
                        fidList[fidList.length] = item;
                    });
                	memberID = new ArrayList();
                    $('#sendInput').find('img').each(function(){
                        $(this).after($(this).attr('code')).remove();
                    });
                    $('#sendInput').find('br').each(function(){
                    	$(this).replaceWith($(this).html() + '\n');
                    });
                    $('#sendInput').find('p').each(function(){
                    	if ($.trim($(this).text()) == '') {
                    		$(this).remove();
                    	} else {
                    		$(this).replaceWith($(this).html() + '\n');
                    	}
                    });
                    $('#sendInput').find('div').each(function(){
                    	if ($.trim($(this).text()) == '') {
                    		$(this).remove();
                    	} else {
                    		$(this).replaceWith($(this).html() + '\n');
                    	}
                    });
                    
                    var body = $('#sendInput').text();
                    var reg=new RegExp("\n","g"); 
                    var text = body.replace(reg, '');
               		if(text.length > 1000){
               			$.alert($.i18n('uc.titleText.js'));
               			return ;
               		}
                    toMemberList = new ArrayList();
                    var leg = document.getElementById('common_send_people').getElementsByTagName('span').length;
                    var pepoer = document.getElementById('common_send_people').getElementsByTagName('span');
                    for(var k = 0 ; k < leg ; k++){
                    	var type = pepoer[k].getAttribute('type');
                    	if(type == 'Member' || type == 'Team'){
                    		var aname = pepoer[k].innerText;
                    		var jid = pepoer[k].getAttribute('source');
                    		if(type == 'Team'){
                    			jid = jid + "@group.localhost";
                    		}
                    		var items ={
                    			jid : jid,
                    			name : aname
                    		};
                    		toMemberList.addSingle(items);
                    	}else{
                    		var memberList = Cache_S_Jids.get(pepoer[k].getAttribute('source'));
                    		if (memberList) {
	                    		var memberValue = memberList.split(",");
	                    		for(var i = 0 ; i < memberValue.length; i++){
	                    			var jid = memberValue[i];
	                    			if (jid) {
		                    			var name = Cache_S_Names.get(jid);
		                    			var items ={
		                            		jid : jid,
		                            		name : name
		                            	};
		                    			toMemberList.addSingle(items);
	                        		}
	                    		}
                        	}
                    	}
                    }
                    if(body.length > 0 || $('#common_send_file').html().indexOf('jid') > 0){
                    	if($(this)[0].className != 'common_send_box_btnSubmit common_button right common_button_disable'){
	                   		$('.common_send .common_send_box').hide().find('.common_send_textarea').html('');
	                   		$('#common_send_people').html('<p class="common_send_people_tip">'+$.i18n('uc.group.personnel.check.js')+'</p>');
	                    	$("#selectPeople_container").remove();
	                   		$('.common_send .common_send_show').show();
	                   	 	$('#common_send_file').html('');
	                    	$('#common_send_file').hide();
	                    	$('#common_send_file').removeClass('margin_b_10');
	                     	$('#removeSelectPeople').click();
	                     	$(".common_send .common_send_textarea_length").html('1000');
                    	}
                    }
                    sendFileList = fidList;
                    endNumsByMsg = toMemberList.size();
                    sendByMessage(toMemberList.subList(startNumByMsg,startNumByMsg+100),body,parent.window.opener,toMemberList);
                });
                
                /*************列表关闭按钮********/
                $(".pageChatList li").live("mouseenter",function(){
                    $(this).find(".pageChatList_Del").show();
                }).live("mouseleave",function(){
                    $($(this).selector + " .pageChatList_Del").hide();
                });
                
                $("#common_menu li").click(function(){
                    $("#common_menu li").removeClass("current");
                    $("#pageChatTabs li").removeClass("current").removeClass("border_b");
                    $(this).addClass("current");
                    $(".pageChatArea").hide();
                    $(".pageChatList").show();
                });
                
                /*************单人聊天关闭按钮********/
               $(".pageChatArea li").live("mouseenter",function () {
                $(this).find(".pageChatAreaListClose").show();
            }).live("mouseleave",function() {
                $(this).find(".pageChatAreaListClose").hide();
            }).find(".for_close_16").live("click",function (event) {
            	 event.stopPropagation();
            	 if(window.confirm('您确定要删除这条信息?')){
            		var lastMess = indexMessages[indexMessages.length -1];
	            	var dt = $(this).attr('dt');
	            	var from = $(this).attr('from');
	            	var to = $(this).attr('to');
	                var iq = parent.window.opener.newJSJaCIQ();
	          	  	var uids = _CurrentUser_jid;
	                iq.setFrom(uids);
	                iq.setIQ(uids, 'set', 'delete:history:msg');
		  			var query1 = iq.setQuery('delete:history:msg:query');
		  			query1.appendChild(iq.buildNode('delete_record_time',dt));
		  			query1.appendChild(iq.buildNode('query_record_time',lastMess.time));
					connWin.con.send(iq, deleteHiMessageCheck);
					isHistoryFlush = false;
				}else{
					return ;
				}
            });
                function deleteHiMessageCheck(iq){
                	var dtime = iq.getNode().getElementsByTagName('delete_record_time')[0].firstChild.data;
                	totalCountByhis = totalCountByhis -1;
                	var newMessage = initMessageByIq(iq);
                	var newHistoryMessageList = new Array();
                	var k = 0 ;
            		for(var i = 0 ; i < indexMessages.length ; i++){
            			var indexMess = indexMessages[i];
            			if(indexMess.time == dtime){
            				continue;
            			}else{
            				newHistoryMessageList[k] = indexMess;
            				k++;
            			}
            		}
            		if(totalCountByhis % 10 == 0){
            			totalPage = parseInt(totalCountByhis / 10);
            		}else{
            			totalPage = parseInt(totalCountByhis / 10) +1;
            		}
            		
            		indexMessages = newHistoryMessageList;
            		
            		if(newMessage.length > 0){
            			indexMessages[indexMessages.length] = newMessage[0];
            			appendHistoryMessage(indexMessages);
            		}else{
            			if(totalCountByhis > 0 && indexMessages.length == 0){
            				if(currentPage > 1){
            					currentPage = currentPage -1;
            					 var iq = parent.window.opener.newJSJaCIQ();
            		             iq.setFrom(_CurrentUser_jid);
            		             iq.setIQ(_toID, 'get', 'history:msg:delete');
            		             var query = iq.setQuery('history:msg:query');
            		             query.appendChild(iq.buildNode('begin_time',dtime));
            		             query.appendChild(iq.buildNode('end_time'));
            		             query.appendChild(iq.buildNode('count', '10'));
            	                 connWin.con.send(iq, showIndexHistMessage, false);
            				}
            			}else{
            				appendHistoryMessage(indexMessages);
            			}
            		}
                }
                /************单人聊天-回复消息输入框*************/
                $(".pageChatArea .pageChatArea_textarea").keyup(function(){
                	//谷歌火狐不支持此方法
                	try{
                		personPox = document.selection.createRange();
                	}catch(e){
                		personPox = null;
                	}
                    $(this).find("img").each(function(){
                        $(this).after($(this).attr("code")).remove();
                    });
                    var textStr = $(this).text().replace( /^\s*/, '');
                    var n = 1000 - textStr.length;
                    var k = 0;
                  	$(this).find('img').each(function(){
                  		k++;
                  		n--;
                		$(".pageChatArea .pageChatArea_btnSubmit").removeClass("common_button_emphasize common_button_disable").addClass("common_button_emphasize");
                    });
                    if (n == 1000) {
                    	$(".pageChatArea .pageChatArea_btnSubmit").removeClass("common_button_emphasize common_button_disable").addClass("common_button_disable");
                    } else if (n < 0) {
                        $(".pageChatArea .pageChatArea_btnSubmit").removeClass("common_button_emphasize common_button_disable").addClass("common_button_emphasize");
                    }
                    else {
                        $(".pageChatArea .pageChatArea_btnSubmit").removeClass("common_button_emphasize common_button_disable").addClass("common_button_emphasize");
                    }
                    if ($(this).text().length+k == 0) {
                    	if ($('#sendFile').html().indexOf('jid') < 0) {
	                        $(".pageChatArea .pageChatArea_btnSubmit").removeClass("common_button_emphasize common_button_disable").addClass("common_button_disable");
                    	}
                    }
                    $(".pageChatArea .pageChatArea_textarea_length").html(Math.ceil(n));
                });

                <c:if test="${param.from == 'a8'}">
	                if ("${ctp:hasResourceCode('F13_mailinbox')}" == "true") {
		                $('#uc_yj').click(function(){
	                		connWin.focus();
	                		connWin.$('#main').attr('src', _ctxPath + '/webmail.do?method=list&jsp=inbox');
	                		connWin.startActionTitle();
	                		window.setTimeout("connWin.standardTitleFun()", 3000);
		                });
	                }
	                if ("${ctp:hasResourceCode('F09_meetingPending')}" == "true") {
		                $('#uc_sphy').click(function(){
	                		connWin.focus();
	                		connWin.$('#main').attr('src', _ctxPath + '/meetingNavigation.do?method=entryManager&entry=meetingPending&meetingNature=2');
	                		connWin.startActionTitle();
	                		window.setTimeout("connWin.standardTitleFun()", 5000);
		                });
	                }
	                if ("${isShowSMS}" == "true") {
		                $('#uc_dx').click(function(){
	                		connWin.focus();
	                		connWin.$('#main').attr('src', _ctxPath + '/message.do?method=showMessageSetting&messageType=sms');
	                		connWin.startActionTitle();
	                		window.setTimeout("connWin.standardTitleFun()", 5000);
		                });
	                }
                </c:if>
                
                var _ll = new MxtLayout({
                	id:'layout',
                	isFixLayout:false,
                	setCallFun: function (json) {
                		resizeMoodWidth();
                    },
                	westArea:{
                		id:'layout_west',
                		width:220,
                		minWidth:1,
                		maxWidth:345,
                		spiretBar: {
                		    show: true,
                		    handlerL: function () {
                		    	_ll.setWest(1);
                		    },
                		    handlerR: function () {
                		    	_ll.setWest(190);
                		    }
                		}
                	},
                	centerArea:{
                		id:'layout_center'
                	}
                });
            });
            ///字节计算器-区分全角半角
            function isOverBytes(s, maxbytes){
                var i = 0;
                var bytes = 0;
                var uFF61 = parseInt("FF61", 16);
                var uFF9F = parseInt("FF9F", 16);
                var uFFE8 = parseInt("FFE8", 16);
                var uFFEE = parseInt("FFEE", 16);
                while (i < s.length) {
                    var c = parseInt(s.charCodeAt(i));
                    if (c < 256) {
                        bytes = bytes + 1;
                    }
                    else {
                        if ((uFF61 <= c) && (c <= uFF9F)) {
                            bytes = bytes + 1;
                        }
                        else 
                            if ((uFFE8 <= c) && (c <= uFFEE)) {
                                bytes = bytes + 1;
                            }
                            else {
                                bytes = bytes + 2;
                            }
                    }
                    i = i + 1;
                }
                return bytes;
            }
            
          	var iscloseImg = false;
            function showImg(){
            	//打开表情框的是时候是要关闭文件上传的 的框的，所以这边判断  是否正在上传文件 
            	if (!isonupload) {
            		return  ;
            	}
            	iscloseImg = true;
            	$('#ids_close').click();
            	if ($('#sendFile').html().indexOf('jid') < 0) {
	            	clearList();
            	}
                if ($('#' + self.id + '_facediv').length == 0) {
                    new MxtFace({
                        id: self.id + '_facediv',
                        'clickFn': function(){
                        	$(".pageChatArea .pageChatArea_textarea").keyup();
                        	$('#MessageInput').focus();
                        },
                        'fixObj': 'nums',
                        'target': 'MessageInput',
                        sendInputPox:personPox,
                        top: $('#nums').offset().top + 20,
                        left: 200,
                        isUp: true
                    });
                }
                else {
                    $('#' + self.id + '_facediv').show();
                }
            }
            function showImgs(){
           		 //打开表情框的是时候是要关闭文件上传的 的框的，所以这边判断  是否正在上传文件 
            	if (!isonupload) {
            		return  ;
            	}
            	$('#ids_close').click();
            	if ($('#common_send_file').html().indexOf('jid') < 0) {
	            	clearList();
            	}
                if ($('#' + self.id + '_facediv').length == 0) {
                    new MxtFace({
                        id: self.id + '_facediv',
                        'clickFn': function(){
                        	 $(".common_send .common_send_textarea").keyup();
                        	 $(".pageChatArea .pageChatArea_textarea").keyup();
                        	 if($('#common_send_people').html().indexOf('source') > 0){
                				 $(".common_send .common_send_box_btnSubmit").removeClass("common_button_emphasize common_button_disable").addClass("common_button_emphasize");
                			 }
                        	 $('#sendInput').focus();
                        },
                        'fixObj': 'numss',
                        'target': 'sendInput',
                        sendInputPox :sendPox,
                        top: $('#numss').offset().top + 20,
                        isClose : true,
                        left: 200,
                        isUp: true
                    });
                }
                else {
                    $('#' + self.id + '_facediv').show();
                }
            }
            function showFile(){
            	if($('#sendFile').html().indexOf('jid') >= 0){
            		$.alert($.i18n('uc.tab.uploadMax.js'));
            		return ;
            	}
            	iscloseImg = true;
            	$('#imgid_close').click();
            	$('#sendFile').show();
            	if($('#'+self.id+'_facediv').length==0){
        			new UploadChat({
        				id:self.id+'_facediv',
        				fromid:_CurrentUser_jid,
        				toid: _toID,
        				tager: $('#history_message'),
        				iq:parent.window.opener,
        				con : connWin.con,
        				isIndex : true,
        				indexFor : true,
        				tigger : $('#sendFile'),
        				fromName : parent.window.opener.curUserName,
        				'clickFn':function(){
        					self.checkNumber();
        				},
        				'fixObj':'nums',
        				'target':self.id+'_dialogtextarea',
        				top:$('#sendFile').offset().top + 60,
        				left:200,
        				isUp:true
        			});
        		}else{
        			$('#'+self.id+'_facediv').show();
        		}
            }
            function showFiles(){
            	if($('#common_send_file').html().indexOf('jid') >= 0){
            		$.alert($.i18n('uc.tab.uploadMax.js'));
            		return ;
            	}
            	$('#imgid_close').click();
            	$('#common_send_file').addClass('margin_b_10');
            	$('#common_send_file').show();
            	if($('#'+self.id+'_facediv').length==0){
        			new UploadChat({
        				id:self.id+'_facediv',
        				tigger : $('#history_message'),
        				fromid:_CurrentUser_jid,
        				toid: _toID,
        				iq:parent.window.opener,
        				con : connWin.con,
        				isclose : true,
        				isIndex : false,
        				indexFor : true,
        				tigger : $('#common_send_file'),
        				'clickFn':function(){
        					self.checkNumber();
        				},
        				'fixObj':'filss',
        				'target':self.id+'_dialogtextarea',
        				top:$('#filss').offset().top + 20,
        				left:200,
        				isUp:true
        			});
        		}else{
        			$('#'+self.id+'_facediv').show();
        		}
            }
            
              function downLoadFile(fid,fname,type){
            		downFilePath(fid,fname,connWin.con,parent.window.opener,type);
              }
                 
              function showCloseButton(i){
            	 $('#delete'+i).show();
              }
              function queryTitleClass(obj){
            	if($(obj)[0].className.indexOf('color_gray') > 0){
            		$(obj).removeClass('color_gray');
            		$(obj).val('');
            	}
              }
              function queryTeamTitleClass(obj){
            	 if($(obj)[0].className.indexOf('color_gray') > 0){
            		 $(obj).removeClass('color_gray');
             		 $(obj).val('');
            	 }
               }
              function queryTitleClasse(obj){
            	  var values = $(obj).val();
            	  if(values == '' || values.length <=0){
            		 $(obj).addClass('color_gray');
                 	 $(obj).val($.i18n('uc.staff.name.js'));
            	  }
              }
              function queryTeamTitleClasse(obj){
            	  var values = $(obj).val();
            	  if(values == '' || values.length <=0){
            		 $(obj).addClass('color_gray');
                 	 $(obj).val($.i18n('uc.group.showname.js'));
            	  }
              }
              function reomveClassby(obj){
            	  var values = $(obj).val();
            	  if(values == '' || values.length <=0){
            		  if($(obj)[0].className.indexOf('color_gray') > 0){
	            		  $(obj).removeClass('color_gray');
	      	              $(obj).val('');
            		  }
            	  }
            	  
            	  if (event.keyCode == 13) {
                      if (obj.id == 'queryOrgMember') {
                         queryOrgMembers();
                      } else if (obj.id == 'reMember') {
                         reMemberclic();
                      } else if (obj.id == 'groupName') {
                         queryGroup();
                      } else if (obj.id == 'groupMemberName') {
                         queryGroupMember();
                      }
                   }
              }
              function sendDepartmemntMessage(deptid){
            	  	var iq = parent.window.opener.newJSJaCIQ();
	            	iq.setFrom(parent.window.opener.jid);
	          	    iq.setIQ('group.localhost', 'get');
	          	    var query = iq.setQuery('seeyon:department:group:create');
	          	    var groupInfo = iq.buildNode('group_info');
	          	    groupInfo.appendChild(iq.buildNode('group_type', '', '6'));
	          	    groupInfo.appendChild(iq.buildNode('department_id', '', deptid));
	          	  	query.appendChild(groupInfo);
	          	  	connWin.con.send(iq,createDeptTeamChick);
	          	  	
              }
              
              function createDeptTeamChick(iq){
            	  if(iq.getType == 'error'){
            		  alert('创建群组失败');
            	  }else{
	            	  var group_info = iq.getNode().getElementsByTagName('group_info')[0];
	            	  var groupid = group_info.getAttribute('I');
	            	  var groupname = group_info.getAttribute('NA');
	            	  parent.window.opener.openWinIM(groupname,groupid);
            	  }
              }
              function getpox(){
            	  //谷歌火狐不支持此方法
            	  try{
            		  sendPox = document.selection.createRange();
            	  }catch(e){
            		  sendPox = null;
            	  }
              }
              function personPoxFunction(){
            	  try{
            		  personPox = document.selection.createRange();
            	  }catch(e){
            		  personPox = null;
            	  }
              }
              function clearFileAndImg(event){
            	 if(event.target.id == 'nums' || event.target.id == 'fms' || event.target.className =='hand' || event.target.id.indexOf('_facediv') >= 0 || event.target.id =='img' || event.target.className.indexOf('file') >= 0 || event.target.className == 'clearfix align_right' || event.target.id == 'checkon' || event.target.className == 'common_send_people_box' || event.target.className == 'ico16 affix_del_16'){
              		
              	}else{
                  	isclose = true;
                	closeWin();
                	//打开表情框的是时候是要关闭文件上传的 的框的，所以这边判断  是否正在上传文件 
                	if (filePathList.length <= 0 ) {
                		isClose = true; 
                  		isclosefile();
                  	    clearFilePath();
                      	iscloseImg = false;
                	}
              	}
              }
            /**********************************************************************/
        </script>
        <style>
        #Team_Name a{color:#000;}
        .uc_layout_sideL{
            padding: 0;
           
        }
        .uc_layout{
            background: #fff;
        }
        .uc_layout_sideL{
            width: 814px;            
        }
        .ucFaceImage{
            padding-left: 25px;
        }

        .uc_menu{
            background: #edeeed;
            padding: 5px 25px 0px 25px;
        }
        .uc_tool_span{
            color: #fff;
        }
        .layout_bg p{
            color:#fff;
        }
        .color_blue{
           color: #fffcb5; 
        }
        #uc_name em{
            margin-left: 10px;
        }
        .ucFaceImage .img{
            border: 2px solid #fff;
        }
        
        .only_table th {
                background-color: #c8ebf9; 
        }

        #memberList .ucFaceImage{
           padding-left: 0px;
        }
        /*.ztree li a.curSelectedNode{
            background-color:#0052b8;
            color:#ffffff;
            border:1px solid #0052b8;
        }*/
        </style>
    </head>
    <body class="uc_bg_color auto_overflow">
    <div id='mysource'></div>
    <div class="uc_layout" style="min-height:800px;">
        <div class="uc_layout_sideL">
            <div class="clearfix layout_bg">
                <div class="gravatar left margin_r_20 ucFaceImage">
                    <img id="uc_photo" class="img" src="<c:url value='/rest/orgMember/avatar/${CurrentUser.id}?maxWidth=36' />" width="36" height="36" alt=""/>
                </div>
                <div class="over_auto font_size12 line_height90">
                    <p id="uc_name" class="margin_t_10">${CurrentUser.name}</p>
                   <!--  <p id="uc_post"></p> -->
                    <!-- <div id="uc_mood" class="color_blue word_break_all font_size12 margin_b_5" style="min-height: 30px; margin-top:10px;word-wrap:break-word" contenteditable="true" mood=""></div> -->
                </div>
            </div>
            <div class="uc_menu clearfix" style="padding-left: 0px;">
                 
                <a href="javascript:void(0)" class="current" id="Uc_Msg" ><span class="ico16 work_kik_16"></span>${ctp:i18n('uc.tab.message.js')}</a>
               <span class="uc_menu_line">&nbsp;</span>
                <a href="javascript:void(0)" id="Uc_Org"><span class="ico16 our_cadre_16"></span>${ctp:i18n('uc.tab.all.js')}</a>
                <span class="uc_menu_line">&nbsp;</span>
                <!-- kygz 改动：去掉关联人员 -->
                <!-- 
                	<a href="javascript:void(0)" id="Uc_Relate" hidden="hidden"><span class="ico16 associated_persons_16"></span>${ctp:i18n('uc.tab.relate.js')}</a>
              
                
                <span class="uc_menu_line">&nbsp;</span>
                <a href="javascript:void(0)" id="Uc_Team"><span class="ico16 group_16"></span>${ctp:i18n('uc.tab.group.js')}</a> 
                  -->
            </div>
                <!--交流-->
                <div id="Uc_Msg_Content">
                    <div class="margin_t_10 clearfix">
                        <div class="common_tabs clearfix left uc_tabs">
                            <ul class="left" id="common_menu">
                                <li class="current">
                                    <a  href="javascript:void(0)" id="all_msg" title="${ctp:i18n('uc.messageType.all.js')}" onclick="javascript:queryTalk('')">${ctp:i18n('uc.messageType.all.js')}</a>
                                </li>
                                <li>
                                    <a hidefocus="true" href="javascript:void(0)" title="${ctp:i18n('uc.messageType.single.js')}" onclick="javascript:queryTalk('person')">${ctp:i18n('uc.messageType.single.js')}</a>
                                </li>
                                <li>
                                    <a hidefocus="true" href="javascript:void(0)" title="${ctp:i18n('uc.messageType.group.js')}"  onclick="javascript:queryTalk('group')">${ctp:i18n('uc.messageType.group.js')}</a>
                                </li>
                            </ul>
                        </div>
                        <div id="pageChatTabs" class="common_tabs clearfix right margin_l_10 hidden">
                            <ul class="left" style="padding: 0px;"></ul>
                        </div>
                    </div>
                    <ul class="pageChatList padding_lr_10" ></ul>
                    <ul class="pageChatArea margin_t_10 hidden padding_r_10" id ='history_mes' >
                        <li class="pageChatAreaMy">
                            <img class="pageChatAreaMy_img radius" id='myPhotos' width="42" height="42" src="/seeyon/apps_res/uc/chat/image/Male.jpg" /><span class="pageChatAreaArrowRight"></span>
                            <div class="pageChatAreaMy_Send">
                                <div class="pageChatArea_textarea word_break_all font_size12 divhref" style="word-wrap:break-word" id="MessageInput" contenteditable="true" onclick="personPoxFunction()"></div>
                                <div class="font_size12 margin_t_10" id = 'messageli'>
                                	<div id="sendFile" class="hidden clearFlow" style="width:660px;min-height:25px; line-height:25px;border:1px solid #CCC;"></div>
                                    <span class="left">
                                    <a href="javascript:void(0)" id="nums" onclick="javaScript:showImg()"><em class="ico16 face_16 " style="margin-bottom: 3px;" onclick="javaScript:showImg()"></em>&nbsp;${ctp:i18n('uc.message.select.face.js')}</a>
                                    <%-- <a href="javascript:void(0)" id="fms" onclick="javascript:showFile()"><em class="ico16 affix_16 " style="margin-bottom: 3px;"  onclick="javascript:showFile()"></em>&nbsp;${ctp:i18n('uc.message.select.attachment.js')}</a>--%>
                                    <a href="javascript:void(0)" id="open_chat"><em class="ico16 send_messages_16 " style="margin-bottom: 3px;"></em>&nbsp;${ctp:i18n('uc.tab.switch.js')}</a>
                                    <span class="color_gray2 font_size12">${ctp:i18n('uc.message.enter.check1.js')}<span class="pageChatArea_textarea_length color_black font_size16">1000</span>${ctp:i18n('uc.message.enter.check2.js') }</span></span>
                                    <a href="javascript:void(0)" id='sendCheck' class="pageChatArea_btnSubmit common_button common_button_disable right" onclick="javaScript:sendMessage()">${ctp:i18n('uc.message.send.js')}</a>
                                </div>
                            </div>
                        </li>
                        <div id="history_message"></div>
                    </ul>
                    <div id="pageFind">
                    </div>
                </div>
                <div class="uc_shortcut">
                    <c:if test="${param.from == 'a8'}">
                        <c:if test="${ctp:hasResourceCode('F13_mailinbox')}"> <!-- 邮件是否启用 -->
                        <span class="uc_tool_font hand" id="uc_yj"><em class="ico24 email_24"></em><span class="uc_tool_span">${ctp:i18n('uc.tool.yj.js')}</span></span>
                        </c:if>
                    
                    </c:if>
                </div>
                <!--本部门-->
                <div id="Uc_Org_Content" class="hidden">
                    <div class="clearfix">
	                    <div id="layout" style="width:810px;height:680px;">
	                    	<div id="layout_west" class="layout_west">
		                      
		                        <iframe src='' name='onlineUserTreeIframe' id='onlineUserTreeIframe' frameborder='0' width='100%' height='99%' scrolling='no'></iframe>
	                    	</div>
	                    	<div id="layout_center" class="layout_center">
								<iframe src='' name='onlineUserListIframe' id='onlineUserListIframe' frameborder='0' width='100%' height='100%' scrolling='no'></iframe>
	                    	</div>
	                    </div>
					</div>
                </div>
                <!--关联人员-->
                <div id="Uc_Relate_Content" class="hidden">
                          <div class="clearfix font_size12 margin_t_10" style="padding-left: 10px;">
                        <div class="right common_search_box clearfix">
                            <ul class="common_search">
                                <li id="inputBorder" class="common_search_input">
                                    <input class="search_input" type="text" id = "reMember" maxlength="25" onblur="queryTitleClasse(this)"  onfocus = "queryTitleClass(this)" onkeyup ="reomveClassby(this)" >
                                </li>
                                <li>
                                    <a class="common_button common_button_gray search_buttonHand" href="javascript:void(0)" onclick="reMemberclic()"> <em></em></a>
                                </li>
                            </ul>
                        </div>
                        <div class="right margin_t_5 common_checkbox_box clearfix">
                            <label for="Checkbox1" class="margin_r_10 hand color_gray">
                                <input type="checkbox" value="0" id="CheckboxRelate" name="option" class="radio_com" onclick="showOffLineByre()">${ctp:i18n('uc.staff.showOffline.js') }
                            </label>
                        </div>
                        <!-- 屏蔽人数统计 
                        <span class="right margin_t_5 margin_r_10 color_gray">${ctp:i18n('uc.tab.member.js') }:<span class="font_bold green" id="online_numr"></span>/<span id="total_numr"></span></span>
                        -->
                    </div>
                    <div class="clearfix margin_t_10">
                        <div class="uc_tree_list hidden" style="height:100%;width:188px;" id ='relateTree'>
                            <ul id="relateList" class="ztree" style="border:0;height:100%;"></ul>
                        </div>
                        <table width="619" border="0" cellspacing="0" cellpadding="0" class="only_table right" id="relateTable">
                            <thead><tr><th width="115">${ctp:i18n('uc.staff.name.js')}</th><th width="100">${ctp:i18n('uc.staff.dept.js')}</th><th width="100">${ctp:i18n('uc.staff.post.js')}</th><th width="225">${ctp:i18n('uc.staff.mood.js')}</th></tr></thead>
                            <tbody id="relate"></tbody>
                            <tfoot id="reList"></tfoot>
                        </table>
                    </div>
                </div>
				<!--群组-->
                <div id="Uc_Team_Content" class="hidden">
                    <div class="clearfix font_size12 margin_t_10" style="padding-left: 10px;">
                    	<!-- 修改创建群组按钮，一直显示去掉隐藏判断,套用div -->
                        <div id='createGroup' class="left margin_t_5"><a href="javaScript:void(0)" onclick="javaScript:createGroupUi()" ><span class="ico16 margin_r_5"></span>${ctp:i18n('uc.group.create.js')}</a></div>
                        <div id='sendMessageByTeam' class="left margin_t_5 hidden" style="margin-left:230px;"><a onclick='sendTeamMessage()'><span class='ico16 common_language_16 margin_r_5'></span><span>${ctp:i18n('uc.group.sendTeamMessage.js')} </span></a></div>
                        <div class="right common_search_box clearfix hidden" id ="query">
                            <ul class="common_search">
                                <li id="inputBorder" class="common_search_input">
                                    <input class="search_input" type="text" id="groupName" value="${ctp:i18n('uc.group.showname.js') }" maxlength="25"  onfocus ="queryTeamTitleClass(this)" onkeyup ="reomveClassby(this)"  onblur= "queryTeamTitleClasse(this)">
                                </li>
                                <li>
                                    <a class="common_button common_button_gray search_buttonHand" onclick="javaScript:queryGroup()" href="javascript:void(0)"><em></em></a>
                                </li>
                            </ul>
                        </div>
                           <div class="right common_search_box clearfix hidden" id ="quertMember">
                            <ul class="common_search">
                                <li id="inputBorder" class="common_search_input">
                              		 <span class='color_gray'>${ctp:i18n('uc.tab.member.js')}:</span><span id="onlinN"></span>&nbsp;&nbsp;<input type="checkbox" value="0" id="CheckboxGroup" name="option" class="radio_com" onclick="showGroupOffLin()"><sapn class='color_gray'>${ctp:i18n('uc.staff.showOffline.js') }</sapn>
                                    <input class="search_input" type="text" id="groupMemberName" value="${ctp:i18n('uc.staff.name.js')}" maxlength="25" onblur="queryTitleClasse(this)"  onfocus = "queryTitleClass(this)" onkeyup ="reomveClassby(this)">
                                </li>
                                <li>
                                    <a class="common_button common_button_gray search_buttonHand" onclick="javaScript:queryGroupMember()" href="javascript:void(0)"><em></em></a>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="clearfix margin_t_10">
                        <div class="uc_tree_list hidden" style="height:100%;width:188px;" id='teamTree'>
                            <ul id="group" class="ztree" style="border:0;height:100%;"></ul>
                        </div>
                        <table width="76%" border="0" cellspacing="0" cellpadding="0" class="only_table right" id="teamtable">
                            <thead id="groupTitle"></thead>
                            <tbody id="grouplist"></tbody>
                            <tfoot id="pageList"></tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div id="accountListDiv" style="display:none; position:absolute; overflow:hidden; z-index:1001;"><ul id="accountList" class="ztree" style="height: 250px;"></ul></div>
    	<form method="get" target="_blank" id="downloadFileFrom"></form>
        <iframe id="downloadFileFrame" src="" class="hidden"></iframe>
    </body>
</html>