<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html class="w100b h100b">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <title>${ctp:i18n('people.card')}</title>
 
<%-- <script src="${path}/ajax.do?managerName=peopleCardManager">
alert(memberid);
var dialog;
var memberid=7610752162676099945;
var pManager = new peopleCardManager();
var memberinfo = pManager.showPeoPleCardMini(memberid);
$("#peoplecardminiform").fillform(memberinfo);

$("#addcorrelation").click(function() {
		alert(123);
		dialog = $.dialog({
		    id: 'url',
		    url: '${path}/relateMember.do?method=addRelativePeople&receiverId=${ffpeoplecardform.id}',
		    width: 500,
		    height: 400,
		    targetWindow:window.parent,
		    title: '选择关联人员类型'
		})

});

</script> --%>
<script src="${path}/ajax.do?managerName=peopleCardManager">
</script>
<script>
	
		var memberid=options.memberId;
	    var pManager = new peopleCardManager();
	    var memberinfo = pManager.showPeoPleCardMini(memberid);
	    $("#peoplecardminiform").fillform(memberinfo);
	
    
    $("#addcorrelation").click(function () {
        alert(30);
    })
</script>
    </head>
    
    <body class="h100b cardmini">
    	<div class="left" style="width:90px;">
    		<div class=" align_center">
	            <span class="people_img relative display_inline-block  over_hidden margin_t_5">
	            	<img src="${ctp:avatarImageUrl(ffpeoplecardminiform.id)}" width="70" height="70">
	                <div class="absolute current_state online"> </div>
	            </span>
	        </div>
	        <div class=" align_center">
	        	<a class="common_button common_button_gray" id="addcorrelation" href="javascript:void(0)">${ctp:i18n('people.add.correlation')}</a>	
	        </div>
    	</div>
    	<form name="peoplecardminiform" id="peoplecardminiform" method="post">
    	<div class="adapt_w font_size12 form_area people_msg" style="width: 240px;">
    		<table cellpadding="0" cellspacing="0" width="100%" class="padding_5">
                <tr>
                    <td class="align_left font_bold margin_5 font_size14"><label id="name"/></td>
                </tr>
    			<tr>
    				<td width="100%" colspan="2" class="font_bold"style="font-size:14px;"><label id="orgDepartmentId"/></td>
    			</tr>
    			<tr>
    				<th nowrap="nowrap">${ctp:i18n('org.account_form.telephone.label')}:</th><td width="100%"><label id="officenumber"/></td>

    			</tr>
    			<tr>
    				<th nowrap="nowrap">${ctp:i18n('member.mobile')}:</th><td><label id="telnumber"/></td>

    			</tr>
    			<tr>
    				<th nowrap="nowrap">${ctp:i18n('member.email')}:</th><td><label id="emailaddress"/></td>

    			</tr>
    		</table>
    	</div>
    	</form>
    	<ul class="font_size12 align_center card_operate border_t clear">
	        <li class="margin_t_5 left" class="left"><a class="img-button" href="javascript:void(0)"><em class="ico16 collaboration_16"> </em>${ctp:i18n('people.send.collaborative')}</a></li>
	        <li class="margin_t_5 left"><a class="img-button" href="javascript:void(0)"><em class="ico16 communication_16"> </em>${ctp:i18n('people.send.msg')}</a></li>
	        <li class="margin_t_5 left"><a class="img-button" href="javascript:void(0)"><em class="ico16 email_16"> </em>${ctp:i18n('people.send.email')}</a></li>
	    	<li class="margin_t_5 left"><a class="img-button" href="javascript:void(0)"><em class="ico16 info_16"> </em>${ctp:i18n('people.send.SMS')}</a></li>
	    </ul>
    </body>
</html>
