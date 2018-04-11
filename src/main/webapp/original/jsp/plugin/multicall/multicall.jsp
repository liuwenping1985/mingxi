<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<script type="text/javascript">
function multicall(){
	var meetingUrl = callBackendMethod("multiCallManager","isInConferenceCall");
	if(meetingUrl!=null && meetingUrl!=''){
		window.open(meetingUrl);
	}else{
		  var dialog = $.dialog({
              url:"${path}/multiCallController.do?method=launchConferenceCall&summaryId="+summaryId,
              width: 400,
              height: 200,
              title: "${ctp:i18n('multicall.plugin.initiate.call')}",
              buttons: [{
                  text: "${ctp:i18n('common.button.ok.label')}", //确定
                  handler: function () {
                	  var rv = dialog.getReturnValue();
  	               	  if(rv!=false){
  	            	     var noPhoneArr = rv.noPhoneArr;
  	            	     var invalidPhoneArr = rv.invalidPhoneArr;
  	            	     if(noPhoneArr.length>0 || invalidPhoneArr.length>0){
  	            	    	 var message = "";
  	            	    	 if(noPhoneArr.length>0){
  	            	    		message = "${ctp:i18n_1('multicall.plugin.message.phoneisnull','"+noPhoneArr.join(",")+"')}";
  	            	    	 }
  	            	    	 if(invalidPhoneArr.length>0){
  	            	    		message = message+ "${ctp:i18n_1('multicall.plugin.message.phoneisivalid','"+invalidPhoneArr.join(",")+"')}";
  	            	    	 }
  	            	    	 message = message + "${ctp:i18n('multicall.plugin.message.iscontinue')}";
  	       	    		     //var message = "${ctp:i18n('multicall.plugin.confirm.msg1')}"+noPhoneArr.join(",")+"${ctp:i18n('multicall.plugin.confirm.msg2')}";
  		       	    		 var confirm = $.confirm({
  		      	                'msg': message,
  		      	                ok_fn: function() {
  		      	                	launchConference(rv);
  		      	                    dialog.close();
  		      	                },
  		      	                cancel_fn: function() {}
  		      	             });
  	       	    	   }else{
  	       	    		   launchConference(rv);
  	       	    		   dialog.close();
  	            	   }
  	               } 
                  }
              }, {
                  text: "${ctp:i18n('common.button.cancel.label')}", //取消
                  handler: function () {
                      dialog.close();
                  }
              }]
            });
	}
}

function launchConference(rv){
	$("body").append("<form id='multicallform' action='http://meeting.commchina.net/zhiyuan/api/agent_api.php?action=createMeeting' method='post'>" +
 		   		"<input type='hidden' id='company_id' name='company_id'>" +
 		   		"<input type='hidden' id='call_time' name='call_time'>" +
 		   		"<input type='hidden' id='signature' name='signature'>" +
 		   		"<input type='hidden' id='user_name' name='user_name'>" +
 		   		"<input type='hidden' id='user_phone' name='user_phone'>" +
 		   		"<input type='hidden' id='user_role' name='user_role'>" +
 		   		"<input type='hidden' id='parties' name='parties'>" +
 		   		"</form>");
 		   $("#multicallform").fillform(rv);
		   //window.open('about:blank',"mutilCallWindow");
		   var form = document.getElementById("multicallform");
		   form.target = "_blank";
		   form.submit();
		   $("#multicallform").remove();
}
</script>