<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<head>
<script type="text/javascript" src="<c:url value="/apps_res/collaboration/js/CollaborationApi.js${v3x:resSuffix()}"/>"></script>
<script type="text/javascript"  src="<c:url value="/apps_res/webmail/js/webmail.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript"  src="<c:url value="/apps_res/sms/js/sms.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
var curUserId = $.ctx.CurrentUser.id;
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
	$('#addcorrelation').unbind("click"); 
/* 	if(content.relateType==''){ */
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
/* 	}else{
		$("#addcorrelation").attr("title",content.relateType);
		//$("#addcorrelation").hide();
	} */
	
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

function showDetail(memberId){
 	clearCard();
	fillCardInfo(memberId); 
}
function clearCard(){
	$("#cd_name").html("&nbsp;");
    $("#deptName").html("");
    $("#postName").html("");
    $("#officeNum").html("");
    $("#mobilePhone").html("");
    $("#location").html("");
    $("#reporter").html("");
    $("#email").html("");
    $("#gender").html("");
    $("#code").html("");
    $("#levelName").html("");
    $("#postCode").html("");
    $("#website").html("");
    $("#blog").html("");
    $("#weixin").html("");
    $("#memo").html("");
    $("#fileName").attr('src',"/seeyon/apps_res/v3xmain/images/personal/pic.gif");
}

function initCardinfo(content){
	$("#sendmsg").show();
	$("#sendemail").show();
	$("#sendSMS").show();
	$("#customerField").children('dt').remove();  
	$(".cd_name").html(getSubValue(content.memberName,28));
    $("#deptName").html(getSubValue(content.deptName,30));
    $("#postName").html(getSubValue(content.postName,30));
    $("#officeNum").html(getSubValue(content.officeNum,30));
    $("#mobilePhone").html(getSubValue(content.mobilePhone,30));
    $("#location").html(getSubValue(content.location,30));
    $("#reporter").html(getSubValue(content.reporter,30));
    $("#email").html(getSubValue(content.email,30));
    if(content.gender=="1"){
        $("#gender").html("${ctp:i18n('org.memberext_form.base_fieldset.sexe.man')}");
    }else if(content.gender=="2"){
    	$("#gender").html("${ctp:i18n('org.memberext_form.base_fieldset.sexe.woman')}");
    }
    $("#code").html(content.code);
    $("#levelName").html(getSubValue(content.levelName,30));
    $("#postCode").html(getSubValue(content.postCode,30));
    $("#website").html(getSubValue(content.website,30));
    $("#blog").html(getSubValue(content.blog,30));
    $("#weixin").html(getSubValue(content.weixin,30));
    $("#memo").html(getSubValue(content.memo,30));
    $("#fileName").attr('src',content.fileName);
    
    var htmlStr="";
    var customerAddressbookSize=content.customerAddressbookSize;
    	if(parseInt(customerAddressbookSize)>0){
    		for(var i=0;i<parseInt(customerAddressbookSize);i++){
    			var customerName = eval("content.customerName"+i);
    			var customerValue = eval("content.customerValue"+i);
    			customerValue = getSubValue(customerValue,30);
    			htmlStr+="<dt class='cd_detail'><span class='cd_bar'>"+customerName+" :</span><span class='cd_message'>&nbsp;"+customerValue+"</span></dt>"
    		}
    	}
     $("#showArea").before(htmlStr);
   	 addActive(content);
   	 
	//不能发信息
 	if($.ctx.CurrentUser.admin||!$.ctx.plugins.contains('uc')){
 		$("#sendmsg").hide();
 	}
 	//不能发邮件
	if(!$.ctx.resources.contains("F12_mailcreate") || ("${v3x:hasPlugin('webmail')}" == 'false')){
		$("#sendemail").hide();
	}
		//不能发短信
 	if(!$.ctx.CurrentUser.canSendSMS){
 		$("#sendSMS").hide();
 	}
}

//卡片信息
function fillCardInfo(memberId){
	var acId=$("#accountId").val();
 	$.ajax({
		sync : true,
		type: "POST",
		url: "/seeyon/addressbook.do?method=getMemberInfoById",
		data: {"memberId": memberId,"accountId":acId},
		dataType : 'text',
	        success : function(data) {
	    	  var content = jQuery.parseJSON(data);
	    	  initCardinfo(content);
	        },
	        error : function(XMLHttpRequest, textStatus, errorThrown) {
	          clearCard();
	          alert("失败");
	        }
	}); 
}
</script>
</head>
<body style="background:#e9eaec;" >
<div class="shade hide"></div>
<!--大卡片-->
<div class="bigCard" style="top: 50px;">
	<div class="cd_list overflow">
		<em class="close" style="left:180px;"></em>
		<div class="cd_img left">
			<span class="">
				<img src="" id="fileName"  width='50' height='50' class='radius'>
			</span>
			
		</div>
		<dl class="left">
			<dd class="cd_name"><span id="cd_name"></span></dd>
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
			<dt class="cd_detail">
				<span class="cd_bar">${ctp:i18n('member.location')}:</span>
				<span class="cd_message" id="location"></span>
			</dt>
			<dt class="cd_detail">
				<span class="cd_bar">${ctp:i18n('member.report2')}:</span>
				<span class="cd_message" id="reporter"></span>
			</dt>
			
		</dl>
		<dl class="basicMsg">
			<dd class="msgWord">${ctp:i18n('relate.memberinfo.baseinfo')}</dd>
			<div style="height:160px; overflow-x: hidden;overflow-y: auto; ">
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
			</div>
		</dl>
		

	</div>
	<div class="sendMessage overflow">
			<div class="msgImg_list">
				<a href="javascript:void(0)" class="button margin_l_92" id="sendcollaboration" title="${ctp:i18n('addressbook.set.sendcollaboration')}" ><em class="icon16 addConection_icon16"></em></a>
				<!-- 致信2.0功能调整，屏蔽WEB端主动发起聊天，主要是因为无法通过接口获取到致信中的JID
				<a href="javascript:void(0)" class="button " id="sendmsg" title="${ctp:i18n('addressbook.set.sendmsg')}"><em class="icon16 sendSeeyon_icon16"></em></a>
				 -->
				<a href="javascript:void(0)" class="button " id="sendemail" title="${ctp:i18n('addressbook.set.sendemail')}"><em class="icon16 sendMsg_icon16"></em></a>
				<a href="javascript:void(0)" class="button " id="sendSMS" title="${ctp:i18n('addressbook.set.sendSMS')}"><em class="icon16 sendShortMsg_icon16"></em></a>
				<a href="javascript:void(0)" class="button " id="addcorrelation" title="${ctp:i18n('addressbook.set.addRelation')}"><em class="icon16 sendEmail_icon16"></em></a>
								
			</div>

	</div>	
</div> 

</body>
</html>