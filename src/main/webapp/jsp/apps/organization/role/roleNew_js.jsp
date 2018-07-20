<%--
 $Author: sunzhemin $
 $Rev: 42478 $
 $Date:: 2014-11-27 19:45:05#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=roleManager"></script>
<script type="text/javascript">
  $(function() {
	var roletype =   "${ffmyfrm.type}";
    var isAccountAdmin = "${isAccountAdmin}";
    var isGroupAdmin = "${isGroupAdmin}";
    var orgAccountId = "${orgAccountId}";
    if(roletype!=""){
    	$("#bond").disable();
    }
    if(roletype!=""&&roletype!="3"){
    	$("#code").disable();
    	   	
    }
    var sortId = $("#sortId").val();
    $("#orgAccountId").val(orgAccountId);
    if($("#type").val()==""){
    	$("#type").val(3);
    }
    /* if (isGroupAdmin === "true") {
      $("#type").append("<option value=\"3\">集团自定义</option>");
    } else {
      $("#type").append("<option value=\"3\">单位自定义</option>");
    } */
    // 设置初始焦点防止IE下出现无法输入的情况
    $("#name").focus();
    /* // 检查角色显示号是否重复
    $("#sortId").blur(function() {
      
      if ($("#sortId").val() === "")
        return;
      var frmobj = $("#myfrm").formobj();
      var valid = $._isInValid(frmobj);
      if(valid)
    	  return;
      var callerResponder = new CallerResponder();
      callerResponder.success = function(jsonObj) {
        if (jsonObj) {
          $.messageBox({
            'title' : "${ctp:i18n('label.prompt')}",
            'type' : 0,
            'msg' : "${ctp:i18n('org.account_form.sortId.repetition')}"
          });
          $("#sortId").val(sortId);
        }
      };
      callerResponder.sendHandler = function(b, d, c) {
        if (confirm("${ctp:i18n('label.submit.or.not')}")) {
          b.send(d, c);
        }
      };
      var rManager = new roleManager();
      rManager.checkDulipSortId($("#sortId").val(), callerResponder);
    }); */

/*     // 检查角色编号是否重复
    $("#code").blur(function() {
      var callerResponder = new CallerResponder();
      callerResponder.success = function(jsonObj) {
        if (jsonObj) {
          $.alert("${ctp:i18n('role.repeat')}");
          $("#code").val("");
        }
      };
      callerResponder.sendHandler = function(b, d, c) {
        if (confirm("${ctp:i18n('label.whether.submit')}")) {
          b.send(d, c);
        }
      };
      var rManager = new roleManager();
      rManager.checkDulipCode($("#code").val(), callerResponder);
    }); */
    changetype();
    $("#bond").change(function(){ 
    	changetype();
    });
  });

  //
  function changetype() {
  
  if ($("#bond").val() == "0") {
    $("#categorydiv").hide();
    $("#statusdiv").hide();
    $("#frontdescription").hide();
  } else if($("#bond").val() == "1") {
   	$("#categorydiv").show();
   	$("#statusdiv").hide();
   	$("#frontdescription").show();
  }else{
	$("#categorydiv").show();  
	$("#statusdiv").show();
	$("#frontdescription").show();
	
  }
}
  function OK() {
    var frmobj = $("#myfrm").formobj();
    var valid = $._isInValid(frmobj);
    frmobj.valid = valid;
    return frmobj;
  }
</script>
