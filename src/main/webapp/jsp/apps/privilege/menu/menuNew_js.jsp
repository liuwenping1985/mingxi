<%--
 $Author: lilong $
 $Rev: 32817 $
 $Date:: 2014-01-20 16:45:37#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript">

$(function() {
  if ($._autofill) {
    var $af = $._autofill, $afg = $af.filllists;
  }
  // 是否虚节点
  isVirtualNode();
  // 设置初始焦点防止IE下出现无法输入的情况
  $("#name").focus();
  $("#icon").disable();;
  //
  $("#selectPageRes").click(function(){
    if(typeof opendialogPageRes != "undefined"){ 
      opendialogPageRes.getDialog(); 
      opendialogPageRes.autoMinfn(); 
      return; 
    }
    var dialog = parent.$.dialog({
      url : _ctxPath+'/privilege/resource.do?method=select&cmd=pageRes&appResCategory=${appResCategory}&productVersion=${productVersion}',
      width : 800, 
      height : 400, 
      title : "${ctp:i18n('privilege.resource.selectPageRes.label')}",
      buttons : [ {
        text : "${ctp:i18n('privilege.resource.submit.label')}",
        handler : function() {
          var res = dialog.getReturnValue();
          var selected = res[res.length-1].gridradio;
          if(selected === null){
            $("#enterResourceId").val("");
            $("#enterResourceName").val("");
            $("#enterResourceUrl").val("");
            dialog.close();
          }
          $(res).each(function(index, elem){
            if(index === (res.length-1))return;
            if(elem.id === selected){
              $("#enterResourceId").val(selected);
              $("#enterResourceName").val(elem.resourceName);
              $("#enterResourceUrl").val(elem.navurl);
              dialog.close();
            }
          });
        }
      }, {
        text : "${ctp:i18n('privilege.resource.cancel.label')}",
        handler : function() {
          dialog.close();
        }
      }]
    });
    opendialogPageRes = dialog;
  });

  // 导航资源
  $("#selectNaviRes").click(function(){
    if(typeof opendialogNaviRes != "undefined"){
      reOpenDialog(opendialogNaviRes);
      return;
    }
    var dialog = parent.$.dialog({
      url : _ctxPath+'/privilege/resource.do?method=select&cmd=naviRes&appResCategory=${appResCategory}&productVersion=${productVersion}',
      width : 800, 
      height : 400, 
      title : "${ctp:i18n('privilege.resource.selectNaviRes.label')}",
      buttons : [ {
        text : "${ctp:i18n('privilege.resource.submit.label')}",
        handler : function() {
          var res = dialog.getReturnValue();
          if(res.length === 0){
            $("#naviResUrl").val("");
            $("#naviResName").val("");
            $("#naviResIds").val("");
            dialog.close();
          }else{
            var naviResName = "";
            var naviResUrl = "";
            var naviResIds = "";
            $(res).each(function(index, elem){
              if(index != 0){
                naviResName += ",";
                naviResUrl += "\n";
                naviResIds += ",";
              }
              naviResName += elem.resourceName;
              naviResUrl += elem.navurl;
              naviResIds += elem.id;
            });
            $("#naviResUrl").val(naviResUrl);
            $("#naviResName").val(naviResName);
            $("#naviResIds").val(naviResIds);
            dialog.close();
          }
        }
      }, {
        text : "${ctp:i18n('privilege.resource.cancel.label')}",
        handler : function() {
          dialog.close();
        }
      }]
    });
    opendialogNaviRes = dialog;
  });
  
  // 快捷资源
  $("#selectShortCutRes").click(function(){
    if(typeof opendialogScRes != "undefined"){
      reOpenDialog(opendialogScRes);
      return;
    }
    var dialog = parent.$.dialog({
      url : _ctxPath+'/privilege/resource.do?method=select&cmd=shortcutRes&appResCategory=${appResCategory}&productVersion=${productVersion}',
      width : 800, 
      height : 400, 
      title : "${ctp:i18n('privilege.resource.selectShortcutRes.label')}",
      buttons : [ {
        text : "${ctp:i18n('privilege.resource.submit.label')}",
        handler : function() {
          var res = dialog.getReturnValue();
          if(res.length === 0){
            $("#shortCutResourceUrl").val("");
            $("#shortCutResourceName").val("");
            $("#shortCutResourceId").val("");
            dialog.close();
          }else{
            var shortCutResourceName = "";
            var shortCutResourceUrl = "";
            var shortCutResourceId = "";
            $(res).each(function(index, elem){
              if(index != 0){
                shortCutResourceName += ",";
                shortCutResourceUrl += "\n";
                shortCutResourceId += ",";
              }
              shortCutResourceName += elem.resourceName;
              shortCutResourceUrl += elem.navurl;
              shortCutResourceId += elem.id;
            });
            $("#shortCutResourceUrl").val(shortCutResourceUrl);
            $("#shortCutResourceName").val(shortCutResourceName);
            $("#shortCutResourceId").val(shortCutResourceId);
            dialog.close();
          }
        }
      }, {
        text : "${ctp:i18n('privilege.resource.cancel.label')}",
        handler : function() {
          dialog.close();
        }
      }]
    });
    opendialogScRes = dialog;
  });
    
  //
  $("input[name='target']").change(function(){
    isVirtualNode();
  });
});

//
function isVirtualNode(){
  // 菜单的应用类型
  var appResCategory = "${appResCategory}";
  $("#ext4").val(appResCategory);
  // 是否为虚节点
  var target = $("input[name='target']:checked").val();
  if(target == 1){
    $(".istarget").css("display","none");
    $(".appResCategoryShortCut").css("display","none");
    //如果是虚节点，没有入口资源等
    $("#enterResourceId").val(0);
  }else{
    if(appResCategory != "0" && appResCategory != "1"){
      $(".istarget").not(".appResCategoryFornt").css("display","");
      if(appResCategory === "2"){
        $(".appResCategoryShortCut").css("display","");
      }
    }else{
      $(".istarget").css("display","");
    }
  }
}

// 打开之前已经打开的dialog
function reOpenDialog(opendialog){
  opendialog.getDialog(); opendialog.autoMinfn(); return;
}  

// 确定提交
function OK() {
  isVirtualNode();
  var frmobj = $("#myfrm").formobj();
  var valid = $._isInValid(frmobj);
  frmobj.valid = valid;
  return frmobj;
}

// 上传菜单图片
function resCallBack(attachment){
  var fileName = attachment.instance[0].filename;
  $("#icon").val(fileName);
  $("#downLoadIFrame").attr("src", 
      "${path}/privilege/menu.do?method=uploadMenuIcon&fileid="+attachment.instance[0].fileUrl+"&filename="+fileName);
}
</script>
