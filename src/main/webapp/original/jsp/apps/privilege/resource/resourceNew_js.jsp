<%--
 $Author: gaohang $
 $Rev: 15611 $
 $Date:: 2013-03-07 18:27:11#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript">

  $(function() {
    // 判断资源类型
    resCategoryChange(); 
    $("#ext1").change(function(){
      resCategoryChange();
    });
    // 判断应用资源类型
    appResChange();
    $("#ext4").change(function(){
      appResChange();
    });
    // 选择归属资源
    $("#belongtoButton").click(function(){
      selectBelongToRes();
    });
    // 选择主资源
    $("#mainResButton").click(function(){
      selectMainRes();
    });
  });
  //
  function showResDialog(toUrl, toTitle, toMathod){
    var dialog = parent.$.dialog({
      url : toUrl, width : 800, targetWindow:top,height : 400, title : toTitle,
      buttons : [ {
        text : "${ctp:i18n('privilege.resource.submit.label')}",
        handler : function() {
          toMathod(dialog);
        }
      }, {
        text : "${ctp:i18n('privilege.resource.cancel.label')}",
        handler : function() {
          dialog.close();
        }
      }]
    });
    return dialog;
  }
  //
  function selectBelongToRes(){
    if(typeof opendialog1 != "undefined"){ 
      opendialog1.getDialog(); 
      opendialog1.autoMinfn(); 
      return; 
    }
    var toUrl = _ctxPath+'/privilege/resource.do?method=select&cmd=pageRes';
    var toTitle = "${ctp:i18n('privilege.resource.selectPageRes.label')}";
    opendialog1 = showResDialog(toUrl, toTitle, selectBelongToResHandler);
  }
  function selectBelongToResHandler(dialog){
    var res = dialog.getReturnValue();
    var selected = res[res.length-1].gridradio;
    if(selected === null){
      $("#belongto").val("");
      $("#belongtoId").val("0");
      dialog.close();
    }
    $(res).each(function(index, elem){
      if(index === (res.length-1))return;
      if(elem.id === selected){
        $("#belongto").val(elem.resourceName);
        $("#belongtoId").val(selected);
        dialog.close();
      }
    });
  }
  //
  function selectMainRes(){
    if(typeof opendialog2 != "undefined"){ 
      opendialog2.getDialog(); 
      opendialog2.autoMinfn(); 
      return;
    }
    var toUrl = _ctxPath+'/privilege/resource.do?method=select&cmd=mainRes';
    var toTitle = "${ctp:i18n('privilege.resource.selectManiRes.label')}";
    opendialog2 = showResDialog(toUrl, toTitle, selectMainResHandler);
  }
  function selectMainResHandler(dialog){
    var res = dialog.getReturnValue();
    var selected = res[res.length-1].gridradio;
    if(selected === null){
      $("#mainResName").val("");
      $("#mainResUrl").val("");
      $("#mainResId").val("0");
      dialog.close();
    }
    $(res).each(function(index, elem){
      if(index === (res.length-1))return;
      if(elem.id === selected){
        $("#mainResName").val(elem.resourceName);
        $("#mainResUrl").val(elem.navurl);
        $("#mainResId").val(selected);
        dialog.close();
      }
    });
  }
  //  
  function resCategoryChange(){
    var resCategory = $("#ext1").val();
    // 当选择是其它资源，则需要选择归属的入口资源
    if(resCategory == 2){
      $("#belongto").removeAttr("disabled");
      $("#belongtoButton").show();
    }else{
      $("#belongto").val("");
      $("#belongtoId").val("0");
      $("#belongto").attr("disabled", "disabled");
      $("#belongtoButton").hide();
    }
  }
  
  function appResChange(){
    var resCategory = $("#ext4").val();
    // 当选择是其它资源，则需要选择归属的入口资源
    if(resCategory == 2 || resCategory == 3){
      $(".mainRes").css("display","");
      // 前台提醒资源，前台快捷资源这两种应用资源类型不能是入口资源和导航资源
      $(".belongTo").hide();
      $("#ext1").val("0");
      $("#belongtoId").val("0");
      $("#belongto").removeAttr("disabled");
    }else{
      $(".belongTo").show();
      $("#mainResName").val("");
      $("#mainResUrl").val("");
      $("#mainResId").val("0");
      $(".mainRes").css("display","none");
    }
  }

  function OK() {
    var frmobj = $("#myfrm").formobj();
    var valid = $._isInValid(frmobj);
    frmobj.valid = valid;
    return frmobj;
  }

  function validateUrl(input){
    /* if ($("#resourceType").val() === "0" && input.val().substring(0,1) != "/") {
      $.messageBox({
        'title': "${ctp:i18n('privilege.resource.message.label')}", 
        'type' : 0, 
        'msg' : "${ctp:i18n('privilege.resource.resUrlCheck.info')}"
      });
      return false;
    } */
    return true;
  }
</script>
