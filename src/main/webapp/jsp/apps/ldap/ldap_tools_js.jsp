<%--
 $Author: lilong $
 $Rev: 4423 $
 $Date:: 2012-09-24 18:13:06#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<script type="text/javascript">
$().ready(function() {
  var ldapManager = null;
  if ($.ctx.plugins.contains('ldap')) {
    ldapManager = new ldapBindingMgr();
  }
  //****ldap/ad******
  $("#ldapUserCodes").click(function(){
    var disableModifyLdapPsw = "${disableModifyLdapPsw}";
    if(true==disableModifyLdapPsw || 'true'==disableModifyLdapPsw) {
      openUserTree("false", "true");
    } else {
      openUserTree("false", "false");
    }
  });
  $("#selectOU").click(function(){
    openLdap();
  });
  function openUserTree(editstate, isModify) {
    var checkOnlyLoginName = document.getElementById("checkOnlyLoginName");
    var checked = "false";
    if(checkOnlyLoginName){
      checked = document.getElementById("checkOnlyLoginName").value;
    }
    
    var rvalue=null;
    var sendResult = $.dialog({
        url: "/seeyon/ldap/ldap.do?method=viewUserTree&checkOnlyLoginName="+checked,
        title: " ",
        width: "440",
        height: "325",
        isDrag: false,
        scrollbars: "yes",
        //targetWindow: window.parent,
        //transParams: tRoles,
        buttons: [{
          id: "ldapOK",
          text: "${ctp:i18n('common.button.ok.label')}",
          handler: function() {
            rvalue = sendResult.getReturnValue();
            if (!rvalue) {
              if(document.getElementById("checkOnlyLoginName")){
                document.getElementById("checkOnlyLoginName").value = "false";
              }
              sendResult.close();
              return;
            } else {
              var stringLenth = rvalue.split("::" + "check" + "::");
              if(stringLenth.length == 2){
              	if(document.getElementById("checkOnlyLoginName")){
                	document.getElementById("checkOnlyLoginName").value = "true";
                }
              }else{
              	if(document.getElementById("checkOnlyLoginName")){
                	document.getElementById("checkOnlyLoginName").value = "false";
                }
              }
              if (stringLenth != null && stringLenth != '' && stringLenth != "undefined") {
                document.getElementById("ldapUserCodes").value = stringLenth[0];
              }
              if (stringLenth.length == 1) {
                if ($.ctx.plugins.contains('ldap')) {
                  var userInfo = ldapManager.getUserAttributes(stringLenth[0]);
                  if (null != userInfo && "undefined" != userInfo) {
                    if (null != userInfo[1] && 'undefined' != userInfo[1] && '' != userInfo[1]) {
                      document.getElementById("name").value = userInfo[1];
                    }
                    if (null != userInfo[2] && userInfo[2] != 'undefined' && userInfo[2] != '') {
                      document.getElementById("telnumber").value = userInfo[2];
                    }
                    if (null != userInfo[0] && userInfo[0] != 'undefined' && userInfo[0] != '') {
                      isNewMember = document.getElementById("isNewMember").value;
                      if (editstate == "" || editstate == null || editstate == "null" ||isNewMember == true ||isNewMember == "true") {
                        document.getElementById("loginName").value = userInfo[0];
                      } else {
                        if (isModify == "true" || isModify == true) {
                        	sendResult.close();
                        	return;
                        }
                        if (confirm("确认修改人员登录信息吗？")) {
                          document.getElementById("loginName").value = userInfo[0];
                          //document.getElementById("name").value = userInfo[1];
                          setPassword();
                        }
                      }
                    }
                  }
                }
              }
            }
            sendResult.close();
          }
        },
        {
            id: "ldapConcel",
            text: "${ctp:i18n('common.button.cancel.label')}",
            handler: function() {
            	sendResult.close();
            }
          }]
      });
  }
  function enableLdap() {
    document.getElementById("ldapUserCodes").disabled = true;
    document.getElementById("ldapUserCodes").value = "";
    //document.getElementById("ldapUserCodes").validate = "";
  }
  function disableLdap() {
    document.getElementById("ldapUserCodes").readOnly = true;
    //document.getElementById("ldapUserCodes").validate = "notNull";
  }
  function showEntry() {
    document.getElementById("entryLable").style.display = "block";
    document.all("ldapUserCodes").disabled = false;
    disableLdap();
    document.getElementById("newEntryLable").style.display = "none";
  }
  function hiddenEntry() {
    document.getElementById("entryLable").style.display = "none";
    enableLdap();
    document.getElementById("newEntryLable").style.display = "block";
  }
  function setPassword() {
    document.getElementById("password").value = "";
    document.getElementById("password2").value = "";
    $("#isChangePWD").val("true");
  }
  function openLdap() {
	    var sendResult =  $.dialog({
	      url: "/seeyon/ldap/ldap.do?method=viewOuTree",
	      width: "410",
	      height: "325",
	      scrollbars: "yes",
	      title: " ",
	      buttons: [{
		    id: "ldapOK",
		    text: "${ctp:i18n('common.button.ok.label')}",
		    handler: function() {
		      var rvalue = sendResult.getReturnValue();
		      if (!rvalue) {
		      	sendResult.close();
			      return;
			    } else {
			      document.getElementById("selectOU").value = rvalue;
			    }
		      sendResult.close();
		    }
		  }]
	    });
	  }
});
</script>