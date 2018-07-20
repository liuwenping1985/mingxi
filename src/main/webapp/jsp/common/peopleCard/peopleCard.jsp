<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html class="w100b h100b">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ include file="../../common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=orgManager"></script>
<script type="text/javascript"  src="<c:url value="/common/collaboration/collFacade.js" />"></script>
<script type="text/javascript"  src="<c:url value="/apps_res/webmail/js/webmail.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript"  src="<c:url value="/apps_res/sms/js/sms.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" >
var dialog;
$().ready(function() {
	var top = getA8Top();
	var i = 0;
	while ($(top.document).find("#main").length == 0 && i < 5) {
		top = top.v3x.getParentWindow().getA8Top();
		i++;
	}
	if('${ffpeoplecardform.relateType}'==''){
    	$("#addcorrelation").click(function() {
    		dialog = $.dialog({
    		    id: 'url',
    		    url: '${path}/relateMember.do?method=addRelativePeople&receiverId=${ffpeoplecardform.id}',
    		    width: 400,
    		    height: 200,
    		    title: "${ctp:i18n('peoplecard.addrelpeple.js')}"
    		});
        });
	}else{
	  $("#addcorrelation").text('${ffpeoplecardform.relateType}');
	}
	$("#sendemail").click(function() {
		if($("#emailaddress").html()!=""){
			sendMail($("#emailaddress").html());
		}
	});
	$("#sendcollaboration").click(function() {
	    appToColl('peopleCard','${ffpeoplecardform.id}');
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
	if(!$.ctx.resources.contains("F01_newColl")){
		$("#sendcollaboration").hide();
	}
	
	if(!$.ctx.resources.contains("F12_mailcreate") || i > 1 || ("${v3x:getSysFlagByName('email_notShow')}" == 'true')){
		$("#sendemail").hide();
	}
	if(!$.ctx.CurrentUser.canSendSMS){
		$("#sendSMS").hide();
	}
	if($.ctx.CurrentUser.admin||!$.ctx.plugins.contains('uc') || i > 1){
		$("#sendmsg").hide();
	}
	
	//备注数据，清理<br>
	$("#description").text($("#description").text());
});
</script>


</head>
   <body class="h100b">
    	<div class="left border_r h100b page_color" style="width:100px;">
    		<div class=" align_center">
	            <span class="vst relative display_inline-block  over_hidden margin_t_5">
	            
	            	<img class="radius" src="${ctp:avatarImageUrl(ffpeoplecardform.id)}" width="60" height="60">
	                
	            </span>
	        </div>
	        <div class=" align_center">
	        
	        	<c:if test ="${(ffpeoplecardform.id!=CurrentUser.id)}">
	        	<a class="common_button common_button_gray" id="addcorrelation" href="javascript:void(0)">${ctp:i18n('people.add.correlation')}</a>	
	        	</c:if>
	        </div>
	        <ul class="font_size12 align_center card_operate">
	        	
	        	<li class="margin_t_5"><a id="sendcollaboration" class="img-button" href="javascript:void(0)"><em class="ico16 collaboration_16"> </em>${ctp:i18n('people.send.collaborative')}</a></li>
	        	<%-- <c:if test="${ctp:hasPlugin('uc')}"> --%>
	        	<c:if test ="${(ffpeoplecardform.id!=CurrentUser.id)}">
	        	<li class="margin_t_5"><a id="sendmsg" class="img-button" href="javascript:void(0)"><em class="ico16 communication_16"> </em>${ctp:i18n('people.send.msg')}</a></li>
	        	</c:if>
	        	<%-- </c:if> --%>
	        	<c:if test ="${(ffpeoplecardform.emailaddress!='')}">
	        	<li class="margin_t_5"><a id="sendemail" class="img-button" href="javascript:void(0)"><em class="ico16 email_16"> </em>${ctp:i18n('people.send.email')}</a></li>
	        	</c:if>
	        	<li class="margin_t_5"><a id="sendSMS" class="img-button" href="javascript:void(0)"><em class="ico16 info_16"> </em>${ctp:i18n('people.send.SMS')}</a></li>
	        </ul>
    	</div>
    	<form name="peoplecardform" id="peoplecardform" method="post">
    	<div class="adapt_w font_size12 form_area people_msg  h100b" style="background:#fff;width: 370px;">
    		<table cellpadding="0" cellspacing="0" width="100%" class="padding_5">
    			<caption class="align_left font_bold margin_t_5"><div class="text_overflow" style="width:300px;"><label id="name"/></div></caption>
    			<tr>
    			
    			
    				<th nowrap="nowrap">${ctp:i18n('people.code')}:</th><td width="50%"><div class="text_overflow" style="width:100px;"><label id="code"/></div></td>
    				<th nowrap="nowrap">${ctp:i18n('people.dept')}:</th><td width="50%"><div class="text_overflow" style="width:100px;"><label id="orgDepartmentId"/></div></td>
    			</tr>
    			<tr>
    				<th nowrap="nowrap">${ctp:i18n('org.dept.main.duty')}:</th><td><div class="text_overflow" style="width:100px;"><label id="orgPostId"/></div></td>
    				<th nowrap="nowrap">${ctp:i18n('org.dept.vice.duty')}:</th><td><div class="text_overflow" style="width:100px;"><label id="secondPost"/></div></td>
    			</tr>
    			<tr>
    				<th nowrap="nowrap">${ctp:i18n('org.dept.position.level')}:</th><td><div class="text_overflow" style="width:100px;"><label id="orgLevelId"/></div></td>
    				<th nowrap="nowrap">${ctp:i18n('org.dept.parttime.jobs')}:</th><td><div class="text_overflow" style="width:100px;"><label id="concurrentPost"/></div></td>
    			</tr>
    		</table>
    		<table cellpadding="0" cellspacing="0" width="100%" class="padding_5">
    			<caption class="align_left font_bold border_t margin_t_10 padding_t_10">${ctp:i18n('people.basic.info')}</caption>
                <tr>
                    <th nowrap="nowrap">${ctp:i18n('org.memberext_form.base_fieldset.sexe')}:</th><td colspan="3" width="100%"><div class="text_overflow" style="width:300px;"><label id="gender" class="codecfg" codecfg="codeId:'hr_sex_type'"/></div></td>
                </tr>
                <tr>
                    <th nowrap="nowrap">${ctp:i18n('member.move.phone.office')}:</th><td colspan="3" width="100%"><div class="text_overflow" style="width:300px;"><label id="officenumber"/></div></td>
                </tr>
    			<tr>
    				<th nowrap="nowrap">${ctp:i18n('member.mobile.phone')}:</th><td colspan="3" width="100%"><div class="text_overflow" style="width:300px;"><label id="telnumber"/></div></td>
    			</tr>
    			<tr>
    				<th nowrap="nowrap">${ctp:i18n('org.member.emailaddress')}:</th><td colspan="3" width="100%"><div class="text_overflow" style="width:300px;"><label id="emailaddress"/></div></td>
    			</tr>
    			<tr>
    				<th nowrap="nowrap">${ctp:i18n('people.postal.code')}:</th><td colspan="3" width="100%"><div class="text_overflow" style="width:300px;"><label id="postalcode"/></div></td>
    			</tr>
    			<tr>
    				<th nowrap="nowrap">${ctp:i18n('people.home.page')}:</th><td colspan="3" width="100%"><div class="text_overflow" style="width:300px;"><label id="website"/></div></td>
    			</tr>
    			<tr>
    				<th nowrap="nowrap">${ctp:i18n('people.blog.address')}:</th><td colspan="3" width="100%"><div class="text_overflow" style="width:300px;"><label id="blog"/></div></td>
    			</tr>
    			<tr>
    				<th nowrap="nowrap">${ctp:i18n('people.remarks')}:</th><td colspan="3" width="100%"><div class="text_overflow" style="width:300px;"><label id="description"/></div></td>
    			</tr>
    			
    		</table>
    	</div>
    	</form>
    </body>
</html>
