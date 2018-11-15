<%--
 $Author: leikj $
 $Rev: 33650 $
 $Date:: 2014-03-07 16:43:47#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>layout</title>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache"> 
<META HTTP-EQUIV="Expires" CONTENT="-1">
<link type="text/css" href="${path}/main/skin/frame/harmony/default.css${ctp:resSuffix()}" rel="stylesheet" />
<link type="text/css" href="${path}/main/frames/defaultV51/index.css${ctp:resSuffix()}" rel="stylesheet" />
<script type="text/javascript" src="${path}/ajax.do?managerName=portalManager,portalTemplateManager"></script>
<script type="text/javascript" src="${path}/main/common/js/skinChangeAdmin.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
portalTemplateManagerObject = new portalTemplateManager();

function toggleSubmitBtn(disabled){
	$("#submitBtn").attr("disabled", disabled);
	if(disabled){
		$("#submitBtn").css("color","#a3a3a3");
	} else {
		$("#submitBtn").css("color","#111");
	}
}

function allowTemplateChoose(){
	var checked = $("#allowTemplateChoose").attr("checked");
    var allowChoose = null;
    if(checked){
      allowChoose = "1";
    } else {
      allowChoose = "0";
    }
    portalTemplateManagerObject.transAllowPortalTemplateChoose(allowChoose);
}

function allowHotSpotChoose(){
	var checked = $("#allowHotSpotChoose").attr("checked");
    var ext5 = null;
    if(checked){
      ext5 = "1";
    } else {
      ext5 = "0";
    }
    portalTemplateManagerObject.transAllowHotSpotChoose(portalskinChange.p.templateId, ext5);
}

function allowHotSpotCustomize(){
	var checked = $("#allowHotSpotCustomize").attr("checked");
    var ext6 = null;
    if(checked){
      ext6 = "1";
    } else {
      ext6 = "0";
    }
    portalTemplateManagerObject.transAllowHotSpotCustomize(portalskinChange.p.templateId, ext6);
}

$(document).ready(function() {
  var hasChangeSkinStyle = false;
  var hasChangeHotSpots = false;
  var hasChangeHotSpotChoose = false;
  var hasChangeHotSpotCustomize = false;
  //获取当前人员是否被上一层级允许切换布局,以及当前人员对下一层级的设置
  var allowTemplateChooseSetting = getCtpTop().$.getSwitchPortalTemplate("true", getCtpTop().isPortalTemplateSwitching);
  if(allowTemplateChooseSetting == null){
	  return;
  }
  var templateData = null;
  //集团/单位管理员是否刚切换过布局（尚未保存到数据库）
  if(getCtpTop().isPortalTemplateSwitching == "true"){
	  templateData = portalTemplateManagerObject.getHotSpotsByTemplateId(getCtpTop().$.ctx.template[0].id);
  } else {
	  templateData = portalTemplateManagerObject.getCurrentPortalTemplateAndHotSpots();
  }
  getCtpTop().$.ctx.template = templateData;
  getCtpTop().refreshCtxHotSpotsData();
  getCtpTop().$.initHotspots();
  $("#portalTemplateLayout").html("");
  getCtpTop().$("#skin_set_iframe").attr("src", "about:blank");
  //获取当前人员是否被上一层级允许选择风格,以及当前人员对下一层级的设置
  var setting5 = portalTemplateManagerObject.getAllowSkinStyleChoose(getCtpTop().$.ctx.template[0].id);
  var parentAllowChoose = setting5.parentAllowChoose;
  var selfAllowChoose = setting5.selfAllowChoose;
  //获取当前人员是否被上一层级允许自定义热点,以及当前人员对下一层级的设置
  var setting6 = portalTemplateManagerObject.getAllowHotSpotCustomize(getCtpTop().$.ctx.template[0].id);
  var parentAllowCustomize = setting6.parentAllowCustomize;
  var selfAllowCustomize = setting6.selfAllowCustomize;
  var skinData = eval(portalTemplateManagerObject.getSkinDatas(getCtpTop().$.ctx.template[0].id));
  portalskinChange = new CtpSkinChange({
    id : 'frountSkin',
    render : 'portalTemplateLayout',
    skinId : getCtpTop().$.ctx.hotspots.topBgImg.ext10,
    templateId : getCtpTop().$.ctx.template[0].id,
    allowTemplateSwitch : allowTemplateChooseSetting.parentAllowChoose,
    topBgImg : getCtpTop().$.ctx.hotspots.topBgImg.hotspotvalue,
    logoImg : getCtpTop().$.ctx.hotspots.logoImg.hotspotvalue,
    mainBgImg : getCtpTop().$.ctx.hotspots.mainBgImg.hotspotvalue,
    topBgColor : {color : getCtpTop().$.ctx.hotspots.topBgColor.hotspotvalue, colorOpacity : getCtpTop().$.ctx.hotspots.topBgColor.ext5, colorList : getCtpTop().$.ctx.hotspots.topBgColor.ext7, colorIndex : getCtpTop().$.ctx.hotspots.topBgColor.ext8},
    lBgColor : {color : getCtpTop().$.ctx.hotspots.lBgColor.hotspotvalue, colorOpacity : getCtpTop().$.ctx.hotspots.lBgColor.ext5, colorList : getCtpTop().$.ctx.hotspots.lBgColor.ext7, colorIndex : getCtpTop().$.ctx.hotspots.lBgColor.ext8},
    cBgColor : {color : getCtpTop().$.ctx.hotspots.cBgColor.hotspotvalue, colorOpacity : getCtpTop().$.ctx.hotspots.cBgColor.ext5, colorList : getCtpTop().$.ctx.hotspots.cBgColor.ext7, colorIndex : getCtpTop().$.ctx.hotspots.cBgColor.ext8},
    mainBgColor : {color : getCtpTop().$.ctx.hotspots.mainBgColor.hotspotvalue, colorOpacity : getCtpTop().$.ctx.hotspots.mainBgColor.ext5, colorList : getCtpTop().$.ctx.hotspots.mainBgColor.ext7, colorIndex : getCtpTop().$.ctx.hotspots.mainBgColor.ext8},
    breadFontColor : {color : getCtpTop().$.ctx.hotspots.breadFontColor.hotspotvalue, colorOpacity : getCtpTop().$.ctx.hotspots.breadFontColor.ext5, colorList : getCtpTop().$.ctx.hotspots.breadFontColor.ext7, colorIndex : getCtpTop().$.ctx.hotspots.breadFontColor.ext8},
    sectionContentColor : {color : getCtpTop().$.ctx.hotspots.sectionContentColor.hotspotvalue, colorOpacity : getCtpTop().$.ctx.hotspots.sectionContentColor.ext5, colorList : getCtpTop().$.ctx.hotspots.sectionContentColor.ext7, colorIndex : getCtpTop().$.ctx.hotspots.sectionContentColor.ext8},
    changeSkin : parentAllowChoose == "1" ? true : false,
    changeBg : parentAllowCustomize == "1" ? true : false,
    onClose : function(){
      getCtpTop().$('#skin_set_iframe').hide('fast',function(){
        $('#portalTemplateLayout').hide('fast');
      });
    },
    onChange : function(){
      //修改热点
      //getCtpTop().$.saveHotSpots(null, this);
      hasChangeHotSpots = true;
      toggleSubmitBtn(false);
    },
    onChooseSkinStyle : function(){
      //选择风格
      portalTemplateManagerObject.getHotSpotsByExt10(portalskinChange.p.templateId, portalskinChange.p.skinId, {
        success : function(tmpHotspots) {
          if(tmpHotspots && tmpHotspots.length > 0){
        	getCtpTop().$.ctx.template[0].id = portalskinChange.p.templateId;
        	getCtpTop().$.ctx.template[0].portalHotspots = tmpHotspots;
        	getCtpTop().refreshCtxHotSpotsData();
            getCtpTop().$.initHotspots();
            portalskinChange.p.topBgImg = getCtpTop().$.ctx.hotspots.topBgImg.hotspotvalue;
            portalskinChange.p.logoImg = getCtpTop().$.ctx.hotspots.logoImg.hotspotvalue;
            portalskinChange.p.mainBgImg = getCtpTop().$.ctx.hotspots.mainBgImg.hotspotvalue;
            portalskinChange.p.topBgColor.color = getCtpTop().$.ctx.hotspots.topBgColor.hotspotvalue;
            portalskinChange.p.topBgColor.colorList = getCtpTop().$.ctx.hotspots.topBgColor.ext7;
            portalskinChange.p.topBgColor.colorIndex = getCtpTop().$.ctx.hotspots.topBgColor.ext8;
            portalskinChange.p.lBgColor.color = getCtpTop().$.ctx.hotspots.lBgColor.hotspotvalue;
            portalskinChange.p.lBgColor.colorList = getCtpTop().$.ctx.hotspots.lBgColor.ext7;
            portalskinChange.p.lBgColor.colorIndex = getCtpTop().$.ctx.hotspots.lBgColor.ext8;
            portalskinChange.p.cBgColor.color = getCtpTop().$.ctx.hotspots.cBgColor.hotspotvalue;
            portalskinChange.p.cBgColor.colorList = getCtpTop().$.ctx.hotspots.cBgColor.ext7;
            portalskinChange.p.cBgColor.colorIndex = getCtpTop().$.ctx.hotspots.cBgColor.ext8;
            portalskinChange.p.mainBgColor.color = getCtpTop().$.ctx.hotspots.mainBgColor.hotspotvalue;
            portalskinChange.p.mainBgColor.colorList = getCtpTop().$.ctx.hotspots.mainBgColor.ext7;
            portalskinChange.p.mainBgColor.colorIndex = getCtpTop().$.ctx.hotspots.mainBgColor.ext8;
            portalskinChange.p.breadFontColor.color = getCtpTop().$.ctx.hotspots.breadFontColor.hotspotvalue;
            portalskinChange.p.breadFontColor.colorList = getCtpTop().$.ctx.hotspots.breadFontColor.ext7;
            portalskinChange.p.breadFontColor.colorIndex = getCtpTop().$.ctx.hotspots.breadFontColor.ext8;
            if(typeof(portalskinChange) != "undefined"){
              $("#notShowLogo").attr("checked", getCtpTop().$.ctx.hotspots.logoImg.display == 0);
              if(getCtpTop().$.ctx.hotspots.groupName){
                  $("#notShowGroupShortName").attr("checked", getCtpTop().$.ctx.hotspots.groupName.display == 0);
              }
              $("#notShowAccountName").attr("checked", getCtpTop().$.ctx.hotspots.accountName.display == 0);
            }
            if(portalskinChange.p.topBgImg != ""){
    			$(".skin_head_img_remove[templateId='" + portalskinChange.p.templateId + "']").show();
    		} else {
    			$(".skin_head_img_remove[templateId='" + portalskinChange.p.templateId + "']").hide();
    		}
    		if(portalskinChange.p.mainBgImg != ""){
    			$(".skin_mainBody_img_remove[templateId='" + portalskinChange.p.templateId + "']").show();
    		} else {
    			$(".skin_mainBody_img_remove[templateId='" + portalskinChange.p.templateId + "']").hide();
    		}
            hasChangeSkinStyle = true;
            toggleSubmitBtn(false);
          }
        }
      });
    },
    data : skinData,
    onSuccess : function(){
      //加载完后把是否允许用户选择，是否允许用户选择等加上
      var html = "";
      if (getCtpTop().isCurrentUserGroupAdmin == "true") {
        //如果是集团管理员
        html += '<div class="common_checkbox_box clearfix ">';
        var groupNameDisplayChecked = getCtpTop().$.ctx.hotspots.groupName.display == 0 ? "checked='checked'" : "";
        //集团简称
        var groupShortName = new portalManager().getGroupShortName();
        var logoDisplayChecked = getCtpTop().$.ctx.hotspots.logoImg.display == 0 ? "checked='checked'" : "";
        html += '<label class="margin_t_5 hand display_block" for="notShowLogo" style="width:350px">';
        html += '<input class="radio_com" id="notShowLogo" type="checkbox" ' + logoDisplayChecked + ' ' + allowHotSpotCustomizeDisabled + ' />${ctp:i18n("template.portal.fontnotshow")}Logo</label>';
        html += '<label class="margin_t_5 hand display_block" for="notShowGroupShortName">';
        if(getCtpTop().productVersion == "G6"){
          labelName = "${ctp:i18n("hotspot.name.orgName")}";
        } else {
          labelName = "${ctp:i18n("hotspot.name.groupName")}";
        }
        html += '<input class="radio_com" id="notShowGroupShortName" type="checkbox" ' + groupNameDisplayChecked + ' />${ctp:i18n("template.portal.fontnotshow")} '+ labelName + '：<input title="' + groupShortName + '" style="width:100px;" disabled value="'+groupShortName+'"/>'  + '</label>';
        html += '</div>';
        $("#group-bottom").append(html);
        var htmlCustom = '<div class="common_checkbox_box clearfix ">';
        var allowTemplateChooseChecked = allowTemplateChooseSetting.selfAllowChoose == "1"? "checked='checked'" : "";
        var allowHotSpotChooseChecked = selfAllowChoose == "1"? "checked='checked'" : "";
        var allowHotSpotCustomizeChecked = selfAllowCustomize == "1"? "checked='checked'" : "";
        htmlCustom += '<label class="margin_t_5 hand display_block" for="allowHotSpotCustomize">';
        htmlCustom += '<input class="radio_com" id="allowHotSpotCustomize" type="checkbox" ' + allowHotSpotCustomizeChecked + ' />${ctp:i18n("portal.skin.allowunit.customize")}</label>';
        htmlCustom += "</div>";
        var htmlCustomSelect = '<div class="common_checkbox_box clearfix ">';
        htmlCustomSelect += '<label class="margin_t_5 hand display_block" for="allowHotSpotChoose">';
        htmlCustomSelect += '<input class="radio_com" id="allowHotSpotChoose" type="checkbox" ' + allowHotSpotChooseChecked + ' />${ctp:i18n("portal.skin.allowunit.choose")}</label>';
        htmlCustomSelect += "</div>";
        $("#skin_right").html(htmlCustom);
        $('#recommend_right').html(htmlCustomSelect);
        var htmlAllowTemplateSelect = '<label class="margin_t_5 hand display_block" style="font-size:12px; font-family:none" for="allowTemplateChoose">';
        htmlAllowTemplateSelect += '<input class="radio_com" id="allowTemplateChoose" type="checkbox" ' + allowTemplateChooseChecked + ' />${ctp:i18n("portal.skin.allowunit.choose")}</label>';
        $("#allowTemplateChooseDiv").html(htmlAllowTemplateSelect);
      } else if (getCtpTop().isCurrentUserAdministrator == "true") {
        //如果是单位管理员
        var allowTemplateChooseChecked = (allowTemplateChooseSetting.parentAllowChoose == "1" && allowTemplateChooseSetting.selfAllowChoose == "1")? "checked='checked'" : "";
        var allowTemplateChooseDisabled = (allowTemplateChooseSetting.parentAllowChoose == "0")? "disabled='disabled'" : "";
        var allowTemplateChooseFontDisabled = (allowTemplateChooseSetting.parentAllowChoose == "0")? " color_gray " : "";
        var allowHotSpotChooseChecked = (parentAllowChoose == "1" && selfAllowChoose == "1")? "checked='checked'" : "";
        var allowHotSpotCustomizeChecked = (parentAllowCustomize == "1" && selfAllowCustomize == "1")? "checked='checked'" : "";
        var allowHotSpotChooseDisabled = parentAllowChoose == "0" ? "disabled='disabled' " : "";
        var allowHotSpotChooseFontDisabled = parentAllowChoose == "0" ? " color_gray " : "";
        var allowHotSpotCustomizeDisabled = parentAllowCustomize == "0" ? "disabled='disabled'" : "";
        var allowHotSpotCustomizeFontDisabled = parentAllowCustomize == "0" ? " color_gray " : "";
        html += '<div class="common_checkbox_box clearfix ">';
        var groupNameDisplayChecked = (getCtpTop().$.ctx.hotspots.groupName && getCtpTop().$.ctx.hotspots.groupName.display == 0) ? "checked='checked'" : "";
        var accountNameDisplayChecked = getCtpTop().$.ctx.hotspots.accountName.display == 0 ? "checked='checked'" : "";
        var logoDisplayChecked = getCtpTop().$.ctx.hotspots.logoImg.display == 0 ? "checked='checked'" : "";
        //集团简称
        var groupShortName = new portalManager().getGroupShortName();
        //当前单位名称
        var accountName = new portalManager().getAccountName();
        //当前单位外文名称
        var accountSecondName = new portalManager().getAccountSecondName();
        if (!accountSecondName) accountSecondName = "";
        html += '<label class="margin_t_5 hand display_block " for="notShowLogo" style="width:350px">';
        html += '<input class="radio_com" id="notShowLogo" type="checkbox" ' + logoDisplayChecked + ' ' + allowHotSpotCustomizeDisabled + ' />${ctp:i18n("template.portal.fontnotshow")}Logo</label>';
        if(getCtpTop().systemProductId == 2 || getCtpTop().systemProductId == 4 || getCtpTop().systemProductId == 5){
          html += '<label class="margin_t_5 hand display_block" for="notShowGroupShortName" style="width:350px">';
          var labelName = null;
          if(getCtpTop().productVersion == "G6"){
            labelName = "${ctp:i18n("hotspot.name.orgName")}";
          } else {
            labelName = "${ctp:i18n("hotspot.name.groupName")}";
          }
          html += '<input class="radio_com" id="notShowGroupShortName" type="checkbox" ' + groupNameDisplayChecked + ' ' + allowHotSpotCustomizeDisabled + ' />${ctp:i18n("template.portal.fontnotshow")} ' + labelName + '：<input title="' + groupShortName + '" style="width:100px;" value="'+groupShortName + '" disabled="disabled" />' + '</label>';
        }
        html += '<label class="margin_t_5 hand display_block" for="notShowAccountName" style="width:350px">';
        html += '<input class="radio_com" id="notShowAccountName" type="checkbox" ' + accountNameDisplayChecked + ' ' + allowHotSpotCustomizeDisabled + ' />${ctp:i18n("template.portal.fontnotshow")} ${ctp:i18n("hotspot.name.accountName")}：<input title="'+ accountName + ' ' + escapeStringToHTML(accountSecondName + "", false) + '" style="width:100px;" value="'+ accountName + ' ' + escapeStringToHTML(accountSecondName + "", false) + '" disabled="disabled" />' + '</label>';
        html += '</div>';
        $("#group-bottom").append(html);
        if(getCtpTop().systemProductId != 7){
            var htmlCustom = '<div class="common_checkbox_box clearfix ">';
            htmlCustom += '<label class="margin_t_5 hand display_block '+allowHotSpotCustomizeFontDisabled+' " for="allowHotSpotCustomize">';
            htmlCustom += '<input class="radio_com" id="allowHotSpotCustomize" type="checkbox" ' + allowHotSpotCustomizeChecked + ' ' + allowHotSpotCustomizeDisabled + ' />${ctp:i18n("portal.skin.allowuser.customize")}</label>';
            htmlCustom += "<div/>";
            
            var htmlCustomSelect = '<div class="common_checkbox_box clearfix ">';
            htmlCustomSelect += '<label class="margin_t_5 hand display_block '+allowHotSpotChooseFontDisabled+' " for="allowHotSpotChoose">';
            htmlCustomSelect += '<input class="radio_com" id="allowHotSpotChoose" type="checkbox" ' + allowHotSpotChooseChecked + ' ' + allowHotSpotChooseDisabled + ' />${ctp:i18n("portal.skin.allowuser.choose")}</label>';
            htmlCustomSelect += "</div>";
            $("#skin_right").html(htmlCustom);
            $('#recommend_right').html(htmlCustomSelect);
            var htmlAllowTemplateSelect = '<label class="margin_t_5 hand display_block '+allowTemplateChooseFontDisabled+'" style="font-size:12px" for="allowTemplateChoose">';
            htmlAllowTemplateSelect += '<input class="radio_com" id="allowTemplateChoose" type="checkbox" ' + allowTemplateChooseChecked + ' ' + allowTemplateChooseDisabled + ' />${ctp:i18n("portal.skin.allowuser.choose")}</label>';
            $("#allowTemplateChooseDiv").html(htmlAllowTemplateSelect);
        }
      }
      $("#group-bottom").append("<div class='stadic_layout_footer stadic_footer_height align_center' style='background-color:rgb(77,77,77);position:fixed'><input title='${ctp:i18n("portal.skin.adminsave.prompt")}' id='submitBtn' type='button' class='common_button common_button_emphasize' style='margin-top:3px;line-height:22px' value='${ctp:i18n("common.button.ok.label")}' disabled='disabled'/>&nbsp;&nbsp;<input id='cancelBtn' type='button' class='common_button' style='margin-top:3px;line-height:22px' value='${ctp:i18n("common.button.cancel.label")}' /></div>");
      if("true" == getCtpTop().isPortalTemplateSwitching){
    	toggleSubmitBtn(false);
      } else {
    	toggleSubmitBtn(true);
      }
      //logo可以自定义上传，在这里绑定上传事件
      dymcCreateFileUpload("hiddenLogoImg",1,"jpg,jpeg,gif,bmp,png",1,false,"logoImgUploadCallBack", "poiLogoImg",true,true,null,false,true,512000);
      $(".skin_logo").click(function(){
        if(portalskinChange.p.changeBg){
          insertAttachmentPoi("poiLogoImg");
        }
      });
      //横幅可以自定义上传，在这里绑定上传事件
      dymcCreateFileUpload("hiddenTopBgImg",1,"jpg,jpeg,gif,bmp,png",1,false,"topBgImgUploadCallBack", "poiTopBgImg",true,true,null,false,true,512000);
      $(".skin_head_img").click(function(){
        if(portalskinChange.p.changeBg){
          insertAttachmentPoi("poiTopBgImg");
        }
      });
      // 大背景图可以自定义上传，在这里绑定上传事件
      dymcCreateFileUpload("hiddenMainBgImg",1,"jpg,jpeg,gif,bmp,png",1,false,"mainBgImgUploadCallBack", "poiMainBgImg",true,true,null,false,true,2048000);
      $(".skin_mainBody_img").click(function(){
        if(portalskinChange.p.changeBg){
          insertAttachmentPoi("poiMainBgImg");
        }
      });
      //允许单位/用户选择布局
      $("#allowTemplateChoose").click(function(){
    	toggleSubmitBtn(false);
      });
      //允许单位/用户选择配色
      $("#allowHotSpotChoose").click(function(){
    	hasChangeHotSpotChoose = true;
    	toggleSubmitBtn(false);
      });
      //允许单位/用户自定义
      $("#allowHotSpotCustomize").click(function(){
    	hasChangeHotSpotCustomize = true;
    	toggleSubmitBtn(false);
      });
      //前端不显示Logo
      $("#notShowLogo").click(function(){
        var checked = $("#notShowLogo").attr("checked");
        var display = null;
        if(checked){
          display = 0;
          getCtpTop().$("#logo").hide();
        } else {
          display = 1;
          getCtpTop().$("#logo").hide();
          getCtpTop().$("#logo").attr("src", "");
          getCtpTop().$("#logo").attr("src", _ctxPath + "/" + portalskinChange.p.logoImg);
          getCtpTop().$("#logo").show();
        }
        getCtpTop().$.ctx.hotspots.logoImg.display = display;
        if(portalskinChange.p.onChange!=null) portalskinChange.p.onChange();
      });
      //前端不显示集团简称
      $("#notShowGroupShortName").click(function(){
        var checked = $("#notShowGroupShortName").attr("checked");
        var display = null;
        if(checked){
          display = 0;
        } else {
          display = 1;
        }
        getCtpTop().$.ctx.hotspots.groupName.display = display;
        getCtpTop().$.refreshGroupAndAccountNameInfo();
        if(portalskinChange.p.onChange!=null) portalskinChange.p.onChange();
      });
      //前端不显示单位名称
      $("#notShowAccountName").click(function(){
        var checked = $("#notShowAccountName").attr("checked");
        var display = null;
        if(checked){
          display = 0;
        } else {
          display = 1;
        }
        getCtpTop().$.ctx.hotspots.accountName.display = display;
        getCtpTop().$.refreshGroupAndAccountNameInfo();
        if(portalskinChange.p.onChange!=null) portalskinChange.p.onChange();
      });
      //恢复默认
      $("#reDefaultBtn").click(function(){
        $.confirm({
          'msg': getCtpTop().i18n_toDefault,
          ok_fn: function () {
            portalTemplateManagerObject.transReSetToDefault(portalskinChange.p.templateId, portalskinChange.p.skinId,{
              success : function(){
            	  toggleSubmitBtn(true);
            	  self.location.href = "${path}/portal/portalTemplateController.do?method=portalTemplateMainV51";
              }
            });
          }
        });
      });
      $(".skin_admin_content_tabs a").click(function(){
    	  toggleSubmitBtn(true);
    	  if($(this).hasClass("skinSwitchDisabled")){
    		  return;
    	  }
    	  var templateId = $(this).attr("templateId");
    	  if(templateId != null && templateId == getCtpTop().$.ctx.template[0].id){
    		  return;
    	  }
    	  var allowTemplateChooseSetting = getCtpTop().$.getSwitchPortalTemplate("true", "true");
    	  if(allowTemplateChooseSetting == null){
    		  return;
    	  }
		  getCtpTop().onbeforunloadFlag = false;
          getCtpTop().isOpenCloseWindow = false;
          getCtpTop().isDirectClose = false;
          try{
    		  getCtpTop().location.href = _ctxPath + "/main.do?method=changeTemplate&portalTemplateId=" + templateId + "&showSkinchoose=true&isPortalTemplateSwitching=true";
          }catch(e){}
      });
      $("#submitBtn").click(function(){
        $.confirm({
          'msg': "${ctp:i18n('portal.skin.adminsave.prompt')}",
          ok_fn: function () {
        	var allowTemplateChooseSetting = getCtpTop().$.getSwitchPortalTemplate("true", "true");
        	if(allowTemplateChooseSetting == null){
        	  return;
        	}
            if(getCtpTop().isCurrentUserAdministrator == "true"){
                var allowTemplateChooseSetting =  portalTemplateManagerObject.getAllowPortalTemplateChoose();
                if(allowTemplateChooseSetting.parentAllowChoose == "0"){
                	$("#allowTemplateChoose").attr("checked", false);
                } else {
                	allowTemplateChoose();
                }
            } else {
                allowTemplateChoose();  
            }
            if(hasChangeHotSpots){
            	var needSaveHotSpots = true;
            	if(getCtpTop().isCurrentUserAdministrator == "true"){
            		var setting6 = portalTemplateManagerObject.getAllowHotSpotCustomize(portalskinChange.p.templateId);
                	if(setting6.parentAllowCustomize == "0"){
                		needSaveHotSpots = false;
                	}
                }
            	if(needSaveHotSpots){
                	getCtpTop().$.saveHotSpots(null, portalskinChange.p);
            	}
            } else {
            	portalTemplateManagerObject.transSwitchPortalTemplate(portalskinChange.p.templateId);
            }
            if(hasChangeSkinStyle || "true" == getCtpTop().isPortalTemplateSwitching){
            	var needSwitchStyle = true;
            	if(getCtpTop().isCurrentUserAdministrator == "true"){
            		var setting5 = portalTemplateManagerObject.getAllowSkinStyleChoose(portalskinChange.p.templateId);
                	if(setting5.parentAllowChoose == "0"){
                		needSwitchStyle = false;
                	}
                }
            	if(needSwitchStyle){
                    portalTemplateManagerObject.transSwitchSkinStyle(portalskinChange.p.templateId, portalskinChange.p.skinId);
            	}
            }
            if(hasChangeHotSpotChoose){
            	if(getCtpTop().isCurrentUserAdministrator == "true"){
            		var setting5 = portalTemplateManagerObject.getAllowSkinStyleChoose(portalskinChange.p.templateId);
            		if(setting5.parentAllowChoose == "0"){
            			$("#allowHotSpotChoose").attr("checked", false);
            		} else {
            			allowHotSpotChoose();
            		}
              	} else {
              		allowHotSpotChoose();  
              	}
            }
            if(hasChangeHotSpotCustomize){
                if(getCtpTop().isCurrentUserAdministrator == "true"){
                    var setting6 = portalTemplateManagerObject.getAllowHotSpotCustomize(portalskinChange.p.templateId);
                    if(setting6.parentAllowCustomize == "0"){
                    	$("#allowHotSpotCustomize").attr("checked", false);
                    } else {
                    	allowHotSpotCustomize();
                    }
                } else {
                    allowHotSpotCustomize();
                }
            }
            getCtpTop().isPortalTemplateSwitching = "false";
            toggleSubmitBtn(true);
            self.location.href = "${path}/portal/portalTemplateController.do?method=portalTemplateMainV51";
          }
        });
      });
      $("#cancelBtn").click(function(){
    	  toggleSubmitBtn(true);
    	  getCtpTop().isPortalTemplateSwitching = "false";
    	  var allowTemplateChooseSetting = getCtpTop().$.getSwitchPortalTemplate("true", getCtpTop().isPortalTemplateSwitching);
    	  if(allowTemplateChooseSetting == null){
    		  return;
    	  } else {
    		  self.location.href = "${path}/portal/portalTemplateController.do?method=portalTemplateMainV51";
    	  }
      });
    }
  });
  $("#skin_set_close").remove();
  $('#portalTemplateLayout').show('fast',function(){
    getCtpTop().$('#skin_set_iframe').height($('#portalTemplateLayout').height()).show();
  });
});

$(self).unbind("beforeunload").bind("beforeunload", function(){
	var disabled = $("#submitBtn").attr("disabled");
	if(!disabled && $("#submitBtn").length > 0){
		return '';
	}
});

$(self).unload(function(){
	var disabled = $("#submitBtn").attr("disabled");
	if(!disabled && $("#submitBtn").length > 0){
		toggleSubmitBtn(true);
		var allowTemplateChooseSetting = getCtpTop().$.getSwitchPortalTemplate("true", "false");
		if(allowTemplateChooseSetting == null){
			return;
		} else {
			var templateData = portalTemplateManagerObject.getHotSpotsByTemplateId(getCtpTop().$.ctx.template[0].id);
			getCtpTop().$.ctx.template = templateData;
			getCtpTop().refreshCtxHotSpotsData();
			getCtpTop().$.initHotspots();
		}
	}
});
</script>
</head>
<body style="margin-left:auto; margin-right:auto;background:#f5f5f5;">
    <c:if test="${isSuperAdmin}">
    <div class="comp" comp="type:'breadcrumb',code:'T03_portalTemplateList'"></div>
    </c:if>
    <c:if test="${isGroupAdmin}">
    <div class="comp" comp="type:'breadcrumb',code:'T03_portalTemplateListGroup'"></div>
    </c:if>
    <c:if test="${isAccountAdmin}">
    <div class="comp" comp="type:'breadcrumb',code:'T03_portalTemplateListAccount'"></div>
    </c:if>
    <div id='portalTemplateLayout'  style="position: relative;" class="border_all"></div>
</body>
</html>