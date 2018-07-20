<%--
 $Author: lilong $
 $Rev: 4423 $
 $Date:: 2012-09-24 18:13:06#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<script type="text/javascript" src="${path}/ajax.do?managerName=accountManager,orgManager"></script>
<script type="text/javascript">
$().ready(function() {
  var aManager = new accountManager();
  var oManager = new orgManager();
  var groupName = "";
  var groupShortName = "";
  //页面按钮
  var toolBarVar = $("#toolbar").toolbar({
    toolbar: [{
      id: "edit4Admin",
      name: "${ctp:i18n('common.button.modify.label')}",
      className: "ico16 editor_16",
      click: edit4Admin
    }]
  });
  //submit
  $("#btnok").click(function() {
    if (! ($("#accountForm").validate())) return;
    $("#accountForm").resetValidate();
    if ($("#checkManager").attr("checked") === "checked") {
      var oldAdminName = $("#oldAdminName").val();
      var adminName = $("#adminName").val();
      if("" == adminName) {
        $.alert("${ctp:i18n('org.alert.oldAdminLoginNameFirst')}");
        $("#adminSourcePass").focus();
        return;
      }
      var adminSourcePass = $("#adminSourcePass").val();
      if("" == adminSourcePass) {
        $.alert("${ctp:i18n('org.alert.oldPassFirst')}");
        $("#adminSourcePass").focus();
        return;
      }
      var isOldCorrect = oManager.isOldPasswordCorrect(oldAdminName, adminSourcePass);
      if ($("#adminPass").val() !== $("#adminPass1").val()) {
        $.alert("${ctp:i18n('account.system.newpassword.again.not.consistent')}");
        $("#adminPass").val("");
        $("#adminPass1").val("");
        $("#adminPass").focus();
        return;
      }
      if(!isOldCorrect || isOldCorrect == 'false') {
        $.alert("${ctp:i18n('org.alert.isNotCorrectOldPass')}");
        return;
      }
    }
    if('true' == "${isLdapEnabled}") {
      if($("#ldapOu").val() == '') {
        $.alert("${ctp:i18n('org.alert.ldapOUNotNull')}");
        return;
      }
    }
    if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
    aManager.updateAcc4Admin($("#accountForm").formobj(), {
        success: function() {
          try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
          $.messageBox({
            'title': "${ctp:i18n('common.prompt')}",
            'type': 0,
            'imgType':0,
            'msg': "${ctp:i18n('organization.ok')}",
            ok_fn: function() {
              var productId = "${ctp:getSystemProperty('system.ProductId')}";
              if(productId == 2) {//集团版
                getCtpTop().refreshAccountName(groupShortName + "&nbsp;&nbsp;&nbsp;&nbsp;" + $("#name").val(),$("#secondName").val());
              } else {//OA-49273
                getCtpTop().refreshAccountName($("#name").val(),$("#secondName").val());//OA-22912
              }
              location.reload();
            }
          });
        }
      });
  });

  //取消按钮
  $("#btncancel").click(function() {
    $("#form_area").clearform();
    location.reload();
  });

  $("#checkManager").click(function() {
    if ($("#checkManager").attr("checked") === "checked") {
      $("#adminName").removeAttr("readonly");
      $("#adminPasswordtr").show();
      $("#validatepasswordtr").show();
      $("#pswpromotetr").show();
      $("#pswchecktr").show();
      $("#checkManager").val("1");
      $("#adminSourcePasswordtr").show();
      $("#adminPass").val("");
      $("#adminPass1").val("");
    } else {
      $("#adminName").attr("readonly", "readonly");
      $("#adminPasswordtr").hide();
      $("#validatepasswordtr").hide();
      $("#pswpromotetr").hide();
      $("#pswchecktr").show();
      $("#adminSourcePasswordtr").hide();
      $("#checkManager").val("0");
      $("#adminPass").val("~`@%^*#?");
      $("#adminPass1").val("~`@%^*#?");
    }
  });
  //填充单位信息
  var accountId = "${id}";
  viewOne4Admin(accountId);

  function viewOne4Admin(id) {
    var aDetail = aManager.viewAccount(id);
    $("#accountForm").disable();
    $("#form_area").show();
    $("#button_area").hide();
    $("#sortIdtype1").attr("checked", "checked");
    $("#checkManager").removeAttr("checked");
    $("#form_area").fillform(aDetail);
    $("#serverPermission").get(0).innerHTML = aDetail.serverPermission;
    $("#m1Permission").get(0).innerHTML = aDetail.m1Permission;
    $("#adminPasswordtr").hide();
    $("#validatepasswordtr").hide();
    $("#pswpromotetr").hide();
    $("#adminSourcePasswordtr").hide();
    $("#orgAccountId").val(id);
    if(aDetail.isGroupVer == false){
      $("tr[class='nonGroup']").hide();
    } else {
      $("tr[class='nonGroup']").show();
    }
    isLdapSet();
    groupName = aDetail.gname;
    groupShortName = aDetail.gshortName;
  }

  function edit4Admin() {
    var aDetail = new Object();
    aDetail = aManager.viewAccount($("#id").val());

    $("#accountForm").enable();
    $("#button_area").show();
    $("#form_area").show();
    $("#form_area").fillform(aDetail);
    $("#serverPermission").get(0).innerHTML = aDetail.serverPermission;
    $("#m1Permission").get(0).innerHTML = aDetail.m1Permission;
    $("#sortIdtype1").attr("checked", "checked");
    $("#permissionType1").attr("checked", "checked");
    $("#checkManager").removeAttr("checked");
    $("#pswchecktr").show();
    //单位管理员框
    $("#adminName").attr("readonly", "readonly");
    $("#adminPasswordtr").hide();
    $("#validatepasswordtr").hide();
    $("#pswpromotetr").hide();
    if(aDetail.isGroupVer == false){
      $("tr[class='nonGroup']").hide();
    } else {
      $("tr[class='nonGroup']").show();
    }
    isLdapSet();
  }

  /******ldap/ad*******/
  //屏蔽和现实ldap的选项
  function isLdapSet() {
    if('true' == $("#isLdapEnabled").val()) {
      $("#ldapSet").show();
    } else {
      $("#ldapSet").hide();
    }
  }
  //弹出选择目录树的界面
  $("#ldapOu").click(function() {
    var sendResult = $.dialog({
    	title:' ',
      url: "${path}/ldap/ldap.do?method=viewOuTree",
      width: "410",
      height: "325",
      scrollbars: "yes",
        buttons: [{
          id: "ldapOK",
          text: "${ctp:i18n('common.button.ok.label')}",
          handler: function() {
           var rvalue = sendResult.getReturnValue();
            if (!rvalue) {
            	sendResult.close();
				      return;
				    } else {
				      $("#ldapOu").val(rvalue);
				    }
            sendResult.close();
          }
        }]
    });
  });
  /********************/
});
</script>