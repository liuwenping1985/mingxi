<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
    <meta charset="UTF-8">
    <title></title>
    <link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/addressbook/css/common.css${v3x:resSuffix()}" />" />
    <link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/addressbook/css/index.css${v3x:resSuffix()}" />" />
    <script src="<c:url value="/apps_res/addressbook/js/index.js${v3x:resSuffix()}" />"></script>
    <script src="<c:url value="/apps_res/addressbook/js/common.js${v3x:resSuffix()}" />"></script>
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
    <script type="text/javascript" src="<c:url value="/apps_res/collaboration/js/CollaborationApi.js${v3x:resSuffix()}"/>"></script>
	<script type="text/javascript"  src="<c:url value="/apps_res/webmail/js/webmail.js${v3x:resSuffix()}" />"></script>
	<script type="text/javascript"  src="<c:url value="/apps_res/sms/js/sms.js${v3x:resSuffix()}" />"></script>
    <script type="text/javascript">
    var curUserId = $.ctx.CurrentUser.id;
    $().ready(function() {
    	$("#contactInfoDiv").hide();
    	frameId = "contactsFrame";
    	accountId = '${loginAccount}';
    	accountName = '${loginAccountName}';
    	isGroupVer = '${isGroupVer}';
    	
    	if(isGroupVer == false || isGroupVer == 'false' || $.ctx.CurrentUser.isInternal == false) {
    		$("#downCheck").removeClass("downCheck_icon16");
    	}
    	
    	$("#currentAccountId").html(getSubValue(accountName,34));
    	$("#accountId").val(accountId);
    	$("#allContacts").attr("src","/seeyon/addressbook.do?method=home&addressbookType=0&contactFrame=allContacts&accountId="+accountId);
    	
    	creataAccountTree();
    	
    	$('#searchContent').keydown(function(e){
    		if(e.keyCode==13){
    			searchContacts();
    		}
    		}); 
    	
    	$("#baseinfoArea ").mouseover(function(even){
    		$("#baseinfoArea ").css("overflow-y","auto");
    	}).mouseout(function(event){
    		$("#baseinfoArea ").css("overflow-y","hidden");
    	});
    	
    	//当浏览器不支持placeholder属性时，调用placeholder函数
    	if(!supportPlaceholder){
    	    $('input').each(function(){
    	        text = $(this).attr("placeholder");
    	        if($(this).attr("type") == "text"){
    	            placeholder($(this));
    	        }
    	    });
    	}
    	
    });
     
    function searchContacts(){
    	var searchContent = $("#searchContent").val().trim();
    	$("#allContacts").attr("src","/seeyon/addressbook.do?method=home&addressbookType=0&contactFrame=allContacts&accountId="+accountId+"&searchContent="+encodeURIComponent(searchContent));
    }
    
    function addActive(content){
    	var top = getA8Top();
    	var i = 0;
    	while ($(top.document).find("#main").length == 0 && i < 5) {
    		top = top.v3x.getParentWindow().getA8Top();
    		i++;
    	}
    	//发消息
    	$('#sendmsg').unbind("click"); 
    	if($.ctx.CurrentUser.admin||!$.ctx.plugins.contains('uc') || i > 1 || curUserId == content.memberId){
    		$("#sendmsg").hide();
    	}else{
    		$("#sendmsg").show();
    	    $("#sendmsg").click(function() {
    		var message = top.getUCStatus();
    		if (message != '') {
    		  try{
    			$.alert(message);
    		  }catch(e){
    		    alert(message);
    		  }
    		  return;
    		}
    		top.sendUCMessage(content.memberName,content.memberId);
    	});
    	}
    	
    	//发协同
    	$('#sendcollaboration').unbind("click"); 
    	if(!$.ctx.resources.contains("F01_newColl") || ("${v3x:hasPlugin('collaboration')}" == 'false')){
    		$("#sendcollaboration").hide();
    	}else{
    		$("#sendcollaboration").show();
    		$("#sendcollaboration").click(function() {
    		    var params = {
    		            personId : content.memberId,
    		            from : 'peopleCard'
    		    }
    		    collaborationApi.newColl(params);
    		});
    	}
    	
    	//加为关联
    	$('#addcorrelation').unbind("click"); ;
    	if(curUserId == content.memberId){
    		$("#addcorrelation").hide();
    	}else{
    		$("#addcorrelation").attr("title","${ctp:i18n('addressbook.set.addRelation')}");
    		$("#addcorrelation").show();
        	$("#addcorrelation").click(function() {
        		dialog = $.dialog({
        		    id: 'url',
        		    url: '/seeyon/relateMember.do?method=addRelativePeople&receiverId='+content.memberId,
        		    width: 400,
        		    height: 200,
        		    title: "${ctp:i18n('peoplecard.addrelpeple.js')}"
        		});
            });
    	}
    	
    	//发送邮件
    	$('#sendemail').unbind("click"); 
    	if(!$.ctx.resources.contains("F12_mailcreate") || i > 1 || ("${v3x:hasPlugin('webmail')}" == 'false') || $("#email").html()==""){
    		$("#sendemail").hide();
    	}else{
    		$("#sendemail").show();
    		$("#sendemail").click(function() {
    			if($("#email").html()!=""){
    				sendMail($("#email").html());
    			}
    		});
    		
    	}
    	//发消息
    	$('#sendSMS').unbind("click"); 
    	if(!$.ctx.CurrentUser.canSendSMS){
    		$("#sendSMS").hide();
    	}else{
    		$("#sendSMS").show();
    		$("#sendSMS").click(function() {
    			sendSMS(content.memberId);
    		});		
    	}
    	
    }
    
    </script>
</head>

<body style="background:#e9eaec;overflow-y:hidden; overflow-x:auto;">
<input type="hidden" id="accountId" value=""/>
 <div class="container">
	<div class="centerBar  left ">
		<div class="header">
			<div>
				<div class="searchBox">
					<input id="searchContent" maxlength="12" type="text" placeholder="${ctp:i18n('addressbook.set.inputkeyword')}"/>
					<em class="icon16 search_icon16" onclick="searchContacts()"></em>
				</div>
			</div>
		</div>
		<div class="orgnazitionTree  overflow">
			<div class="contacts_li_div  " >
				<div class="companyCheck" onclick="showMenu(); return false;">
					<span name="currentAccountId" id="currentAccountId"></span>
					<em id="downCheck" class="icon16 downCheck_icon16 "></em>
				</div>
			</div>
		</div>
			<div id="accountContent" class="border_all bg_color_white" style="width:270px; position: absolute;display: none;height:480px;overflow-y: auto;" >
					<ul id="accountTree" name="accountTree" class="ztree" style="margin-top:0; width:90%;"></ul>
		    </div>
			<iframe id="allContacts" name="allContacts" src="" frameborder="0"></iframe>
	</div>
	
		<div class="rightBar  left " id="contactInfoDiv">
		<!--联系人页面-->
			<div  class="workerRel " style="overflow-y:hidden;">
			<div class="overflow workerRel_div">
				<!--大卡片-->
				<div class="bigCard left " id="contactCard">
					<div class="cd_list overflow " id="contactCardinner">
						
						<div class="cd_img left" >
							<span class=""  style="cursor: default;">
								<img width="50" height="50" id="fileName" src="/seeyon/apps_res/v3xmain/images/personal/pic.gif" class="radius">
							</span>
							
						</div>
						<dl class="left">
							<dd class="cd_name" style="color:#5193e1"></dd>
							<dt class="cd_detail">
								<span class="cd_bar">${ctp:i18n('relate.memberinfo.dep')}</span>
								<span class="cd_message" id="deptName"></span>
							</dt>
							<dt class="cd_detail">
								<span class="cd_bar">${ctp:i18n('relate.memberinfo.post1')}</span>
								<span class="cd_message" id="postName"></span>
							</dt>
							<dt class="cd_detail">
								<span class="cd_bar">${ctp:i18n('relate.memberinfo.officeNum')}</span>
								<span class="cd_message" id="officeNum"></span>
							</dt>
							<dt class="cd_detail">
								<span class="cd_bar">${ctp:i18n('relate.memberinfo.handphone')}</span>
								<span class="cd_message" id="mobilePhone"></span>
							</dt>
							<dt class="cd_detail">
								<span class="cd_bar">${ctp:i18n('relate.memberinfo.email')}</span>
								<span class="cd_message cd_email" id="email"></span>
							</dt>
							<div id="innerArea">
								<dt class="cd_detail">
									<span class="cd_bar">${ctp:i18n('member.location')}:</span>
									<span class="cd_message" id="location"></span>
								</dt>
								<dt class="cd_detail">
									<span class="cd_bar">${ctp:i18n('member.report2')}:</span>
									<span class="cd_message" id="reporter"></span>
								</dt>
							</div>
							<!-- 用来占位 -->
							<div id="blankArea">
								<dt class="cd_detail">
									<span class="cd_bar"></span>
									<span class="cd_message"></span>
								</dt>
								<dt class="cd_detail">
									<span class="cd_bar"></span>
									<span class="cd_message"></span>
								</dt>
							</div>
							
							
							
						</dl>
						<dl class="basicMsg">
							<dd class="msgWord">${ctp:i18n('relate.memberinfo.baseinfo')}</dd>
							<div id="baseinfoArea" style="height:225px; overflow-x: hidden;overflow-y: hidden; ">
							<dt class="cd_detail">
								<span class="cd_bar">${ctp:i18n('relate.memberinfo.sex')}</span>
								<span class="cd_message" id="gender"></span>
							</dt>
							<dt class="cd_detail">
								<span class="cd_bar">${ctp:i18n('relate.memberinfo.memberno')}</span>
								<span class="cd_message" id="code"></span>
							</dt>
							<dt class="cd_detail">
								<span class="cd_bar">${ctp:i18n('relate.memberinfo.memberleavel')}</span>
								<span class="cd_message" id="levelName"></span>
							</dt>
							<dt class="cd_detail">
								<span class="cd_bar">${ctp:i18n('relate.memberinfo.postcode')}</span>
								<span class="cd_message" id="postCode"></span>
							</dt>
							<dt class="cd_detail">
								<span class="cd_bar">${ctp:i18n('relate.memberinfo.webpage')}</span>
								<span class="cd_message" id="website"></span>
							</dt>
							<dt class="cd_detail">
								<span class="cd_bar">${ctp:i18n('relate.memberinfo.blog')}</span>
								<span class="cd_message" id="blog"></span>
							</dt>
							<dt class="cd_detail">
								<span class="cd_bar">${ctp:i18n('relate.memberinfo.weixin')}</span>
								<span class="cd_message" id="weixin"></span>
							</dt>
							<div id="customerField">
								<input type="hidden" id="showArea"/>
							</div>
							<dt class="cd_detail">
								<span class="cd_bar">${ctp:i18n('relate.memberinfo.memo')}</span>
								<span class="cd_message" id="memo"></span>
							</dt>							
							<!-- 占位  -->
							<div style="height: 10px;">
							</div>		
												
							</div>
						</dl>
						

					</div>
					<div class="sendMessage overflow">
							<div class="msgImg_list">
								<a href="javascript:void(0)" class="button margin_l_92" id="sendcollaboration" title="${ctp:i18n('addressbook.set.sendcollaboration')}" onmouseenter="$(this).children('em').css('background-position','-176px -31px');" onmouseleave="$(this).children('em').css('background-position','0 -32px');"><em class="icon16 addConection_icon16"></em></a>
								<!-- 致信2.0功能调整，屏蔽WEB端主动发起聊天，主要是因为无法通过接口获取到致信中的JID
								<a href="javascript:void(0)" class="button " id="sendmsg" title="${ctp:i18n('addressbook.set.sendmsg')}" onmouseenter="$(this).children('em').css('background-position','-192px -31px');" onmouseleave="$(this).children('em').css('background-position','-16px -31px');"><em class="icon16 sendSeeyon_icon16"></em></a>
								 -->
								<a href="javascript:void(0)" class="button " id="sendemail" title="${ctp:i18n('addressbook.set.sendemail')}"><em class="icon16 sendMsg_icon16"></em></a>
								<a href="javascript:void(0)" class="button " id="sendSMS" title="${ctp:i18n('addressbook.set.sendSMS')}"><em class="icon16 sendShortMsg_icon16"></em></a>
								<a href="javascript:void(0)" class="button " id="addcorrelation" title="${ctp:i18n('addressbook.set.addRelation')}" onmouseenter="$(this).children('em').css('background-position','-241px -31px');" onmouseleave="$(this).children('em').css('background-position','-65px -31px');"><em class="icon16 sendEmail_icon16"></em></a>
							</div>

					</div>		
				</div>
				<div class="relation left " id="relationpage"> 
					<%-- <div class="relationship">${ctp:i18n('addressbook.set.colleaguerelationship')}</div> --%>
					<div class="relationList overflow">
<%-- 						<dl class="relation_DP overflow">
							<dd class="relation_HEAD">${ctp:i18n('addressbook.set.superiorleaders')}</dd>
							<div id="leaderDiv">
								<input id="showleadersArea" type="hidden"/>
						    </div>
						    <div class="showMoreLeaders" id="showMoreLeaders">
								<a onclick="javascript:allContacts.window.showMore('leaders');"><font >${ctp:i18n('addressbook.set.showmore')}</font></a>
						    </div>
						</dl> --%>
						<dl class="relation_DP overflow">
							<dd class="relation_HEAD">${ctp:i18n('addressbook.set.colleagues')}</dd>
						     <div id="colleaguesDiv">
								<input id="showColleaguesArea" type="hidden" />
						    </div>
						    <div class="showMoreLeaders" id="showMoreColleagues">
								<a onclick="javascript:allContacts.window.showMore('colleagues');"><font >${ctp:i18n('addressbook.set.showmore')}</font></a>
						    </div>
						</dl>
					</div>
				</div>
			</div>
				
		</div>
		
	</div>
	
</div> 

</body>
</html>