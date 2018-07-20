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
<html style="height:100%;">
<head>
<title>个人空间设置</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=spaceManager,spaceSecurityManager"></script>
<script>
  $(document).ready(function() {
    if("${allowed}" == "true"){
      $("#spaceSettingFrame").attr("src","${defaultSpacePath}?showState=personEdit");
      $("#notAllowedDefineMsg").hide();
    }else{
      $("#spaceSettingFrame").attr("src","").hide();
      $("#notAllowedDefineMsg").show();
      var parentDocument = window.parent.document;
      $("#submitbtn",parentDocument).hide();
      $("#toDefaultBtn",parentDocument).hide();
    }
    $("#personalSet_head a :last").addClass("last_tab");
    $("#personalSet_head a").addClass("no_b_border");
    parent.$("#personalSet_body").css("border", "none");
	//iframe高度不对，js控制
   var tabIframeObj= $("#personalSet_body");
   tabIframeObj.find("iframe").height(tabIframeObj.height());
  });
  function save(){
    $("#personalSet_body").find("iframe")[0].contentWindow.updateSpace();
  }
  function toDefault(){
	parent.$("#toDefaultBtn").attr("disabled",true);
    $("#personalSet_body").find("iframe")[0].contentWindow.toDefaultPersonal();
    parent.$("#toDefaultBtn").attr("disabled",false);
  }
  function cancel(){
    $("#personalSet_body").find("iframe")[0].contentWindow.cancelPersonalEdit();
  }
  function showCurrentTab(id,pagePath,allowDefined){
    $.each($("#personalSet_head").find("li"),function(i,obj){
      var objId = $(obj).attr("id");
      if(objId == id){
        $(obj).addClass("current").find("a").css("height","23px");
        var parentDocument = window.parent.document;
        if(allowDefined == 'true'){
          $("#spaceSettingFrame").show();
          $("#spaceSettingFrame").attr("src",pagePath+'?showState=personEdit&d='+(new Date()));
          $("#notAllowedDefineMsg").hide();
          $("#submitbtn",parentDocument).show();
          $("#toDefaultBtn",parentDocument).show();
        }else{
          $("#spaceSettingFrame").hide();
          $("#spaceSettingFrame").attr("src","");
          $("#notAllowedDefineMsg").show();
          $("#submitbtn",parentDocument).hide();
          $("#toDefaultBtn",parentDocument).hide();
        }
      }else{
        $(obj).removeClass("current").find("a").css("height","24px");
      }
    });
  }
  window.onresize = function(){   
	  $('#personalSet_head').width($('body').width());
	  $('#personalSet_body').width($('body').width());
  }
</script>
</head>
<body id="ssBody" style="height:100%;">
    <div id="personalSet" class="comp h100b border_lr over_hidden" comp="type:'tab'" style="border: none">
        <div id="personalSet_head" class="common_tabs clearfix margin_l_5 margin_t_5">
            <ul class="left">
                <c:forEach items="${spaceList}" var="space" varStatus="index">
                    <li class="${index.index=='0'?'current':''}" id="tab${index.index}"><a href="javascript:showCurrentTab('tab${index.index}','${space[3]}','${space[4]}')" tgt="tab${index.index}_div" title="${v3x:toHTML(space[2])}">${v3x:toHTML(space[2])}</a></li>
                </c:forEach>
            </ul>
        </div>
        <div id="personalSet_body" class="common_tabs_body border_t bg_color_white padding_l_5 padding_r_5" style="height: 100%" >
            <iframe id="spaceSettingFrame" name="spaceSettingFrame" src="" width="100%" height="434" border="0px" frameborder="0" ></iframe>
            <table id="notAllowedDefineMsg" align="center" style="height:90%; color: red; font-size: 14px; font-weight: bolder;display:none">
                <tr>
                    <td valign="middle" height="100%">${ctp:i18n("space.forbiddendefined.label")}</td>
                </tr>
            </table>
        </div>
    </div>
</body>
</html>