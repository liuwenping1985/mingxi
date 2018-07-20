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
	var i=0;
	while($(top.document).find("#main").length==0&&i<5) {
            top = getA8Top().v3x.getParentWindow().getA8Top();
			i++;
        }
	if('${ffpeoplecardform.relateType}'==''){
    	$("#addcorrelation").click(function() {
    		
    		dialog = $.dialog({
    		    id: 'url',
    		    url: '${path}/relateMember.do?method=addRelativePeople&receiverId=${ffpeoplecardform.id}',
    		    width: 400,
    		    height: 200,
    		    targetWindow:window.parent.top,
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
		appToColl4DialogMode('peopleCard','${ffpeoplecardform.id}');
	});
	$("#sendmsg").click(function() {
		top.sendUCMessage('${ffpeoplecardform.name}', '${ffpeoplecardform.id}');
	});
	$("#sendSMS").click(function() {
		sendSMS('${ffpeoplecardform.id}');
	});
	if(!$.ctx.resources.contains("F01_newColl")){
		$("#sendcollaboration").hide();
	}
	if(!$.ctx.resources.contains("F12_mailcreate")){
		$("#sendemail").hide();
	}
	if(!$.ctx.CurrentUser.canSendSMS){
		$("#sendSMS").hide();
	}
	if($.ctx.CurrentUser.admin||!$.ctx.plugins.contains('uc')){
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
	            
	            	<img src="${ctp:avatarImageUrl(ffpeoplecardform.id)}" width="60" height="60">
	                
	            </span>
	        </div>
	        <div class=" align_center">
	        
	        	
	        </div>
	        <ul class="font_size12 align_center card_operate">
	        	
	        	
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
    				<th nowrap="nowrap">${ctp:i18n('org.memberext_form.base_fieldset.sexe')}:</th><td width="50%"><label id="gender" class="codecfg" codecfg="codeId:'hr_sex_type'"/></td>
    				<th nowrap="nowrap">${ctp:i18n('member.move.phone.office')}:</th><td width="50%"><div class="text_overflow" style="width:100px;"><label id="officenumber"/></div></td>
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
