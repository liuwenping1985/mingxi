<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html class="w100b h100b">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/PeopleCard/css/peoplecard.css${ctp:resSuffix()}" />" />
<c:if test="${v3x:hasPlugin('collaboration')}">
<script type="text/javascript" src="<c:url value="/apps_res/collaboration/js/CollaborationApi.js${v3x:resSuffix()}"/>"></script>
</c:if>
<script type="text/javascript"  src="<c:url value="/apps_res/webmail/js/webmail.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript"  src="<c:url value="/apps_res/sms/js/sms.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" >
var dialog;
$().ready(function() {

	if($(".bigCard").height() - $(".sendMessage .msgImg_list").height() > $("body").height()){
		$("body ").mouseover(function(even){
		$("body").css("overflow-y","auto");
		}).mouseout(function(event){
		$("body").css("overflow-y","hidden");
		});
	}

	
	//设置滚动条
	$("#baseinfoArea ").mouseover(function(even){
	$("#baseinfoArea ").css("overflow-y","auto");
	}).mouseout(function(event){
		$("#baseinfoArea ").css("overflow-y","hidden");
	});
	
	//添加事件
	var top = getA8Top();
	var i = 0;
	while ($(top.document).find("#main").length == 0 && i < 5) {
		top = top.v3x.getParentWindow().getA8Top();
		i++;
	}
/* 	if('${ffpeoplecardform.relateType}'==''){ */
    	$("#addcorrelation").click(function() {
    		dialog = $.dialog({
    		    id: 'url',
    		    url: '${path}/relateMember.do?method=addRelativePeople&receiverId=${ffpeoplecardform.id}',
    		    width: 400,
    		    height: 200,
    		    title: "${ctp:i18n('peoplecard.addrelpeple.js')}"
    		});
        });
/* 	}else{
	  $("#addcorrelation").text('${ffpeoplecardform.relateType}');
	} */
	$("#sendemail").click(function() {
		if($("#emailaddress").html()!=""){
			sendMail($("#emailaddress").html());
		}
	});
	$("#sendcollaboration").click(function() {
	    
	    var params = {
	            personId : '${ffpeoplecardform.id}',
	            from : 'peopleCard'
	    }
	    collaborationApi.newColl(params);
	});
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
		var sendName = $("#name").text();
		if (sendName == "") { 
			sendName = '${ffpeoplecardform.name}';
		}
		top.sendUCMessage(sendName,'${ffpeoplecardform.id}');
	});
	$("#sendSMS").click(function() {
		sendSMS('${ffpeoplecardform.id}');
	});
	
	
	if($.ctx.resources == null || !$.ctx.resources.contains("F01_newColl") || ("${v3x:hasPlugin('collaboration')}" == 'false')){
		$("#sendcollaboration").hide();
	}
	
	if($.ctx.resources == null || !$.ctx.resources.contains("F12_mailcreate") || ("${v3x:hasPlugin('webmail')}" == 'false')){
		$("#sendemail").hide();
	}
	if($.ctx.CurrentUser == null || !$.ctx.CurrentUser.canSendSMS || "${CurrentUser.externalType}" != "0"){
		$("#sendSMS").hide();
	}
	if($.ctx.CurrentUser == null || $.ctx.plugins == null || $.ctx.CurrentUser.admin || !$.ctx.plugins.contains('uc')){
		$("#sendmsg").hide();
	}
	//非a8人员不显示关联人员操作 && 基本信息
	if('${ffpeoplecardform.externalType}' != '0'){
		$("#addcorrelation").hide();
		$(".basicMsg").hide();
	}

	fillDetailInfo();
});

function  fillDetailInfo(){
    $("#name").html("${ctp:toHTML(v3x:getLimitLengthString(ffpeoplecardform.name,28,'...'))}");
    $("#name").attr("title",'${ctp:escapeJavascript(ffpeoplecardform.name)}');
	
    $("#orgDepartmentId").html("${ctp:toHTML(v3x:getLimitLengthString(ffpeoplecardform.orgDepartmentId,44,'...'))}");
    $("#orgDepartmentId").attr("title",'${ctp:escapeJavascript(ffpeoplecardform.orgDepartmentId)}');
    
    $("#currentOrgDepartmentId").html("${ctp:toHTML(v3x:getLimitLengthString(ffpeoplecardform.currentOrgDepartmentId,44,'...'))}");
    $("#currentOrgDepartmentId").attr("title",'${ctp:escapeJavascript(ffpeoplecardform.currentOrgDepartmentId)}');
	
    $("#orgPostId").html("${ctp:toHTML(v3x:getLimitLengthString(ffpeoplecardform.orgPostId,30,'...'))}");
    $("#orgPostId").attr("title",'${ctp:escapeJavascript(ffpeoplecardform.orgPostId)}');
	
    $("#officenumber").html("${ctp:toHTML(v3x:getLimitLengthString(ffpeoplecardform.officenumber,30,'...'))}");
    $("#officenumber").attr("title",'${ctp:escapeJavascript(ffpeoplecardform.officenumber)}');
	
    $("#telnumber").html("${ctp:toHTML(v3x:getLimitLengthString(ffpeoplecardform.telnumber,30,'...'))}");
    $("#telnumber").attr("title",'${ctp:escapeJavascript(ffpeoplecardform.telnumber)}');
    
    $("#emailaddress").html("${ctp:toHTML(v3x:getLimitLengthString(ffpeoplecardform.emailaddress,30,'...'))}");
    $("#emailaddress").attr("title",'${ctp:escapeJavascript(ffpeoplecardform.emailaddress)}');
    
    $("#address").html("${ctp:toHTML(v3x:getLimitLengthString(ffpeoplecardform.address,30,'...'))}");
    $("#address").attr("title",'${ctp:escapeJavascript(ffpeoplecardform.address)}');
	
	if(${ffpeoplecardform.isInternal == true || ffpeoplecardform.isInternal == 'true'}){		
	    $("#reportTo").html("${ctp:toHTML(v3x:getLimitLengthString(ffpeoplecardform.reportTo,30,'...'))}");
	    $("#reportTo").attr("title",'${ctp:escapeJavascript(ffpeoplecardform.reportTo)}');
	    
	    $("#worklocal").html("${ctp:toHTML(v3x:getLimitLengthString(ffpeoplecardform.worklocal,30,'...'))}");
	    $("#worklocal").attr("title",'${ctp:escapeJavascript(ffpeoplecardform.worklocal)}');
	}
	var gender='${ffpeoplecardform.gender}';
    if(gender=="1"){
        $("#gender").html('${ctp:i18n("org.memberext_form.base_fieldset.sexe.man")}');
        $("#gender").attr("title",'${ctp:i18n("org.memberext_form.base_fieldset.sexe.man")}');
        
    }else if(gender=="2"){
    	$("#gender").html('${ctp:i18n("org.memberext_form.base_fieldset.sexe.woman")}');
    	$("#gender").attr("title",'${ctp:i18n("org.memberext_form.base_fieldset.sexe.woman")}');
    }
    
    $("#code").html('${ffpeoplecardform.code}',18);
    $("#code").attr("title",'${ffpeoplecardform.code}');
    
    $("#orgLevelId").html("${ctp:toHTML(v3x:getLimitLengthString(ffpeoplecardform.orgLevelId,30,'...'))}");
    $("#orgLevelId").attr("title",'${ctp:escapeJavascript(ffpeoplecardform.orgLevelId)}');
    
    $("#postalcode").html("${ctp:toHTML(v3x:getLimitLengthString(ffpeoplecardform.postalcode,30,'...'))}");
    $("#postalcode").attr("title",'${ctp:escapeJavascript(ffpeoplecardform.postalcode)}');
    
    $("#website").html("${ctp:toHTML(v3x:getLimitLengthString(ffpeoplecardform.website,30,'...'))}");
    $("#website").attr("title",'${ctp:escapeJavascript(ffpeoplecardform.website)}');

    $("#blog").html("${ctp:toHTML(v3x:getLimitLengthString(ffpeoplecardform.blog,30,'...'))}");
    $("#blog").attr("title",'${ctp:escapeJavascript(ffpeoplecardform.blog)}');
    
    $("#weixin").html("${ctp:toHTML(v3x:getLimitLengthString(ffpeoplecardform.weixin,30,'...'))}");
    $("#weixin").attr("title",'${ctp:escapeJavascript(ffpeoplecardform.weixin)}');
    
    var des = "${ctp:toHTML(v3x:getLimitLengthString(ffpeoplecardform.description,30,'...'))}";
	des = des.replace(new RegExp("<br/>", 'g'), "");
    $("#description").html(des);
    $("#description").attr("title",'${ctp:escapeJavascript(ffpeoplecardform.description)}');
    
	<c:forEach items="${bean}" var="bean" varStatus="status">
		var key = '${bean.id}_label';
		 $("#"+key).html("${ctp:toHTML(v3x:getLimitLengthString(bean.label,8,'...'))}"+":");
		 $("#"+key).attr("title",'${ctp:escapeJavascript(bean.label)}');
	</c:forEach>
    
	 <c:forEach items="${beanValue}" var="beanValue">
	        var key='${beanValue.key}';
	        $("#"+key).html("${ctp:toHTML(v3x:getLimitLengthString(beanValue.value,30,'...'))}");
	        $("#"+key).attr("title",'${ctp:escapeJavascript(beanValue.value)}');
	 </c:forEach> 
   
}

var transParams = window.dialogArguments;
function closePeopleCardDialog(){
	transParams.parentWin.newPeopleCardDialog.close();
}

</script>
</head>
<body style="overflow:hidden; height: 100%;width: 100%;background:#e9eaec;" >
     <div class="container overflow ">
        <div style="height:100px; overflow-x: hidden;overflow-y: hidden;">
           	<div class="left" style="width: 100%;">
		    <div class="cardList">
		    <div class="shade show"></div>
			<div class="bigCard" style="top: 0px;display: block;right:0px;">
				<em class="close" style="position:absolute;" onclick="closePeopleCardDialog();"></em>
				<c:set value="${ffpeoplecardform.externalType == 0?'':'height:200px'}" var="h"/>
				<div class="cd_list overflow" style="position:relative;overflow-y: hidden;overflow-x: hidden;${h}">
					<div class="cd_img left">
						<span class="">
							<img src="${ctp:avatarImageUrl(ffpeoplecardform.id)}" id="fileName"  width='50' height='50' class='radius'>
						</span>
						
					</div>
					<dl class="left">
						<dd class="cd_name"><span id="name"></span></dd>
						<c:choose>
							<c:when test="${ffpeoplecardform.externalType == 0}">
								<c:set value="${ctp:i18n('relate.memberinfo.dep')}" var="dep"/>
								<c:set value="${ctp:i18n('relate.memberinfo.handphone')}" var="telnumber"/>
								<c:set value="${ctp:i18n('relate.memberinfo.email')}" var="email"/>
							</c:when>
							<c:otherwise>
								<c:set value="${ctp:i18n('org.JoinOrganization.label')}:" var="dep"/>
								<c:set value="${ctp:i18n('relate.send.email')}:" var="email"/>
								<c:set value="${ctp:i18n('relate.memberinfo.handphone')}" var="telnumber"/>
							</c:otherwise>
						</c:choose>
						<dt class="cd_detail">
							<span class="cd_bar" title="${dep}">${dep}</span>
							<span class="cd_message" id="orgDepartmentId"></span>
						</dt>
						<c:if test="${ffpeoplecardform.externalType == 1}">
							<dt class="cd_detail">
								<span class="cd_bar" title="${ctp:i18n('org.JoinAccount.label')}:">${ctp:i18n('org.JoinAccount.label')}:</span>
								<span class="cd_message" id="currentOrgDepartmentId"></span>
							</dt>
						</c:if>
						<dt class="cd_detail">
							<span class="cd_bar" title="${ctp:i18n('relate.memberinfo.post1')}">${ctp:i18n('relate.memberinfo.post1')}</span>
							<span class="cd_message" id="orgPostId"></span>
						</dt>
						<c:if test="${ffpeoplecardform.externalType == 0}">
							<dt class="cd_detail">
								<span class="cd_bar" title="${ctp:i18n('relate.memberinfo.officeNum')}">${ctp:i18n('relate.memberinfo.officeNum')}</span>
								<span class="cd_message" id="officenumber"></span>
							</dt>
						</c:if>
						<dt class="cd_detail">
							<span class="cd_bar" title="${telnumber}">${telnumber}</span>
							<span class="cd_message" id="telnumber"></span>
						</dt>
						<dt class="cd_detail">
							<span class="cd_bar" title="${email}">${email}</span>
							<span class="cd_message cd_email" id="emailaddress"></span>
						</dt>
						<c:if test="${ffpeoplecardform.externalType != 0}">
							<dt class="cd_detail">
								<span class="cd_bar" title="${ctp:i18n('addressbook.postAddress.label')}:">${ctp:i18n('addressbook.postAddress.label')}:</span>
								<span class="cd_message cd_email" id="address"></span>
							</dt>
						</c:if>
						
						
						<c:choose>
							<c:when test ="${ffpeoplecardform.isInternal == true || ffpeoplecardform.isInternal == 'true'}">
							<dt class="cd_detail">
								<span class="cd_bar" title="${ctp:i18n('member.location')}">${ctp:i18n('member.location')}:</span>
								<span class="cd_message" id="worklocal"></span>
							</dt>
							
							<dt class="cd_detail">
								<span class="cd_bar" title="${ctp:i18n('member.report2')}">${ctp:i18n('member.report2')}:</span>
								<span class="cd_message" id="reportTo"></span>
							</dt>
							</c:when>
							<c:otherwise>
							<dt class="cd_detail">
								<span class="cd_bar"></span>
								<span class="cd_message"></span>
							</dt>
							
							<dt class="cd_detail">
								<span class="cd_bar"></span>
								<span class="cd_message"></span>
							</dt>
							
							</c:otherwise>
						</c:choose>
						
					</dl>
					<dl class="basicMsg">
						<div class="msgWord">${ctp:i18n('relate.memberinfo.baseinfo')}</div>
						<div  id="baseinfoArea" style="height:160px; overflow-x: hidden;overflow-y: hidden; ">
						<dt class="cd_detail" title="${ctp:i18n('relate.memberinfo.sex')}">
							<span class="cd_bar">${ctp:i18n('relate.memberinfo.sex')}</span>
							<span class="cd_message" id="gender">
								<!-- <label id="gender" class="codecfg" codecfg="codeId:'hr_sex_type'"/>		 -->
							</span>  		      
<!-- 							 <script type="text/javascript">
				  		        var gender=$("#gender").html();
				  		         if(gender=="1"){
				  		            $("#gender").html('${ctp:i18n("org.memberext_form.base_fieldset.sexe.man")}');
				  		        }else if(gender=="2"){
				  		        	alert(gender);
				  		        	$("#gender").html('${ctp:i18n("org.memberext_form.base_fieldset.sexe.woman")}');
				  		        }else{
				  		        	$("#gender").html('');
				  		        }
		                     </script> -->
						</dt>
						<dt class="cd_detail">
							<span class="cd_bar" title="${ctp:i18n('relate.memberinfo.memberno')}">${ctp:i18n('relate.memberinfo.memberno')}</span>
							<span class="cd_message" id="code"></span>
						</dt>
						<dt class="cd_detail">
							<span class="cd_bar" title="${ctp:i18n('relate.memberinfo.memberleavel')}">${ctp:i18n('relate.memberinfo.memberleavel')}</span>
							<span class="cd_message" id="orgLevelId"></span>
						</dt>
						<dt class="cd_detail">
							<span class="cd_bar" title="${ctp:i18n('relate.memberinfo.postcode')}">${ctp:i18n('relate.memberinfo.postcode')}</span>
							<span class="cd_message" id="postalcode"></span>
						</dt>
						<dt class="cd_detail">
							<span class="cd_bar" title="${ctp:i18n('relate.memberinfo.webpage')}">${ctp:i18n('relate.memberinfo.webpage')}</span>
							<span class="cd_message" id="website"></span>
						</dt>
						<dt class="cd_detail">
							<span class="cd_bar" title="${ctp:i18n('relate.memberinfo.blog')}">${ctp:i18n('relate.memberinfo.blog')}</span>
							<span class="cd_message" id="blog"></span>
						</dt>
						<dt class="cd_detail">
							<span class="cd_bar" title="${ctp:i18n('relate.memberinfo.weixin')}">${ctp:i18n('relate.memberinfo.weixin')}</span>
							<span class="cd_message" id="weixin"></span>
						</dt>


    			<c:forEach items="${bean}" var="bean" varStatus="status">
    					<dt class="cd_detail">
							<span class="cd_bar" id="${bean.id}_label"></span>
							<span class="cd_message" id="${bean.id}"></span>
						</dt>
		  		 </c:forEach>
						<dt class="cd_detail">
							<span class="cd_bar" title="${ctp:i18n('relate.memberinfo.memo')}">${ctp:i18n('relate.memberinfo.memo')}</span>
							<span class="cd_message" id="description" ></span>
						</dt>
						</div>
					</dl>
					
			
				</div>
				<div class="sendMessage overflow">
						<div class="msgImg_list">
							<a href="javascript:void(0)" onmouseenter="$(this).css('background','#5093e1');$(this).children('em').css('background-position','-176px -31px');" onmouseleave="$(this).css('background','#f3f3f3');$(this).children('em').css('background-position','0 -32px');" class="button margin_l_92" id="sendcollaboration" title="${ctp:i18n('addressbook.set.sendcollaboration')}" ><em class="icon16 addConection_icon16" style="margin-bottom:3px;"></em></a>
							<!-- 致信2.0功能调整，屏蔽WEB端主动发起聊天，主要是因为无法通过接口获取到致信中的JID						
							<c:if test ="${(ffpeoplecardform.id!=CurrentUser.id)}">
								<a href="javascript:void(0)" onmouseenter="$(this).css('background','#5093e1');$(this).children('em').css('background-position','-192px -31px');" onmouseleave="$(this).css('background','#f3f3f3');$(this).children('em').css('background-position','-16px -31px');" class="button " id="sendmsg" title="${ctp:i18n('addressbook.set.sendmsg')}"><em class="icon16 sendSeeyon_icon16" style="margin-bottom:3px;"></em></a>
							</c:if>
							 -->
							<c:if test ="${(ffpeoplecardform.emailaddress!='')}">
								<a href="javascript:void(0)" onmouseenter="$(this).css('background','#5093e1');$(this).children('em').css('background-position','-209px -31px');" onmouseleave="$(this).css('background','#f3f3f3');$(this).children('em').css('background-position','-33px -31px');" class="button " id="sendemail" title="${ctp:i18n('addressbook.set.sendemail')}"><em class="icon16 sendMsg_icon16" style="margin-bottom:3px;"></em></a>
							</c:if>
							<a href="javascript:void(0)" onmouseenter="$(this).css('background','#5093e1');$(this).children('em').css('background-position','-224px -32px');" onmouseleave="$(this).css('background','#f3f3f3');$(this).children('em').css('background-position','-48px -32px');" class="button " id="sendSMS" title="${ctp:i18n('addressbook.set.sendSMS')}"><em class="icon16 sendShortMsg_icon16" style="margin-bottom:3px;"></em></a>
							<c:if test ="${(ffpeoplecardform.id!=CurrentUser.id) && CurrentUser.externalType == 0}">
								<a href="javascript:void(0)" onmouseenter="$(this).css('background','#5093e1');$(this).children('em').css('background-position','-241px -31px');" onmouseleave="$(this).css('background','#f3f3f3');$(this).children('em').css('background-position','-65px -31px');" class="button " id="addcorrelation" title="${ctp:i18n('addressbook.set.addRelation')}"><em class="icon16 sendEmail_icon16" style="margin-bottom:3px;"></em></a>
							</c:if>
						</div>
			
				</div>	
				</div> 
			  </div>
			</div>
        </div>
    </div>
</body>
</html>
