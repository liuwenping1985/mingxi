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
<html>
<head>
<title>个人设置</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=spaceManager,spaceSecurityManager"></script>
<script>
  $(document).ready(function() {
    //$("#content_div").attr("heigth",$("body").css("height")-$("#personalSet").css("height"));
    $("#submitbtn").click(function(){
      $("#personalSetContent").find("iframe")[0].contentWindow.save();
    });
    $("#cancelbtn").click(function(){
      $("#personalSetContent").find("iframe")[0].contentWindow.cancel();
    });
  });
  function showCurrentTab(id,url){
    $.each($("#personalSetTab").find("li"),function(i,obj){
      var objId = $(obj).attr("id");
      if(objId == id){
        $(obj).attr("class","current");
        $("#content_div").attr("src",_ctxPath+url);
      }else{
        $(obj).attr("class","");
      }
    });
  }
</script>
</head>
<body>
    <div id="personalSet" class="comp" comp="type:'tab',width:'100%'">
        <div id="personalSetTab" class="common_tabs clearfix">
            <ul class="left">
                <li class="current" id="tab1"><a href="javascript:showCurrentTab('tab1','')" tgt="tab1_div" ><span>${ctp:i18n('personalInfo.title')}</span></a></li>
                <li id="tab2"><a href="javascript:showCurrentTab('tab2','')" tgt="tab2_div"><span>${ctp:i18n('menu.individual.manager')}</span></a></li>
                <li id="tab3"><a href="javascript:showCurrentTab('tab3','/portal/portalController.do?method=showSpaceNavigation')" tgt="tab3_div"><span>${ctp:i18n('menu.space.navigationConfig')}</span></a></li>
                <li id="tab4"><a href="javascript:showCurrentTab('tab4','/portal/portalController.do?method=showMenuSetting')" tgt="tab4_div"><span>${ctp:i18n('personalSetting.menu.label')}</span></a></li>
                <li id="tab5"><a href="javascript:showCurrentTab('tab5','/portal/portalController.do?method=showShortcutSet')" tgt="tab5_div"><span>${ctp:i18n('personalSetting.shortcut.label')}</span></a></li>
                <li id="tab6"><a href="javascript:showCurrentTab('tab6','')" tgt="tab6_div" class="last_tab"><span>${ctp:i18n('personalInfo.storeSpace.look')}</span></a></li>
            </ul>
        </div>
        <div id="personalSetContent" class="common_tabs_body border_all">
            <iframe  id="content_div" src="#" border="0"  frameborder="no" width="100%" height="420"></iframe>
        </div>
        <div class="align_center">
            <a href="javascript:void(0)" id="submitbtn" class="common_button common_button_gray">保存</a> 
            <a href="javascript:void(0)" id="cancelbtn" class="common_button common_button_gray">取消</a>
        </div>
    </div>
</body>
</html>