<%--
 $Author: leikj $
 $Rev: 4195 $
 $Date:: 2012-09-19 18:18:30#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title>个人设置</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=spaceManager,spaceSecurityManager"></script>
<script>
  $(document).ready(function() {
    //$("#content_div").attr("heigth",$("body").css("height")-$("#personalSet").css("height"));
    $("#submitbtn").click(function(){
    	if($("#content_div").contents().find("#spaceSettingFrame").length > 0){
        	var result = $("#content_div").contents().find("#spaceSettingFrame")[0].contentWindow.isThisSpaceExist();
        	if(!result){
        		return;
        	}
    	}
    	$("#personalSetContent").find("iframe")[0].contentWindow.save();
    });
    $("#toDefaultBtn").click(function(){
      $("#personalSetContent").find("iframe")[0].contentWindow.toDefault();
    });
    $("#cancelbtn").click(function(){
      window.location.href = _ctxPath + "/portal/portalController.do?method=personalInfo";
    });
    
    if("${ctp:escapeJavascript(targetURL)}".indexOf("SpacesSetting")>0){
      $("#toDefaultBtn").show();
    }else{
      $("#toDefaultBtn").hide();
    }
    if("${ctp:escapeJavascript(targetURL)}".indexOf("hrRecord")>0){
    	$("#btn").css("background-color","#e6e6e6");
    }
    if("${ctp:escapeJavascript(targetURL)}".indexOf("storeSpaceLook")>0){
   	 	$("#submitbtn").hide();
        $("#cancelbtn").text("${ctp:i18n('doc.space.returnprv')}");
    }
    $("#content_div").attr("src",_ctxPath+"${ctp:escapeJavascript(targetURL)}");
  });
</script>
<style>
    .stadic_head_height{
        height:0px;
    }
    .stadic_body_top_bottom{
        bottom: 50px;
        top: 0px;
    }
    .stadic_footer_height{
        height:50px;
    }
    .border_tb{
        border:none;
    }
    .padding_tb_5{
        padding-top: 12px;
    }
</style>

</head>
<body class="h100b over_hidden">
    <div id="personalSet" class="stadic_layout">
        <div class="stadic_layout_head stadic_head_height"></div>
        <div id="personalSetContent" class="stadic_layout_body stadic_body_top_bottom ${fn:indexOf(targetURL,'hrViewSalary.do') > -1 ? 'h100b' : ''}">
            <iframe  id="content_div" src="#" border="0"  frameborder="no" scrolling="yes" class="w100b h100b absolute over_hidden"></iframe>
        </div>
        <div class="stadic_layout_footer stadic_footer_height align_center ${fn:indexOf(targetURL,'hrViewSalary.do') > -1 ? 'hidden' : ''}" id="btn" style="background-color:#4d4d4d;">
            <div class="border_tb padding_tb_5">
                <span id="submitbtn" class="common_button common_button_emphasize" style="cursor:pointer">${ctp:i18n("common.button.ok.label")}</span>
                <a href="javascript:void(0)" id="toDefaultBtn" class="common_button common_button_gray" style="border: 1px solid #42b3e5;background-color: #42b3e5;">${ctp:i18n('space.button.toDefault')}</a>  
                <a href="javascript:void(0)" id="cancelbtn" class="common_button common_button_gray" style="color:#ffffff; background-color: #99948c;margin-left: 6px;">${ctp:i18n("common.button.cancel.label")}</a>
            </div>
        </div>
    </div>
</body>
</html>