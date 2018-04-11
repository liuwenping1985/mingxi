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
<title>个人事务</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=signetManager,spaceManager"></script>
<script>
//隐藏或显示印章菜单设置
$().ready(function(){
    var curUserId = $.ctx.CurrentUser.id;
        new signetManager().findSignetByMemberId(curUserId, {
            success: function(result){
                if(result.length > 0){
                    $("#perMessageSetting").css("display","");
                }
                else{
                    $("#perMessageSetting").css("display","none");
                }
            }
        });
        new spaceManager().getSettingThemSpace({
        	success : function(list){
        		if(list.length>0){
        			$("#themSpaceSetting").show();
        		}else{
        			$("#themSpaceSetting").hide();
        		}
        	}
        });
});
</script>
<script>
$().ready(function(){
	var html = "<span class='nowLocation_ico'><img src='/seeyon/main/skin/frame/harmony/menuIcon/personal.png'/></span>";
    html += "<span class='nowLocation_content'>";
    html += "<a class=\"hand\" onclick=\"showMenu('"+_ctxPath+"/portal/portalController.do?method=personalInfo')\">${ctp:i18n('menu.personal.affair')}</a>";
    html += "</span>";
    getCtpTop().showLocation(html);
    /**
    $(".file_list_four li").mouseenter(function () {
        $(this).addClass("cursor");
    }).mouseleave(function () {
        $(this).removeClass("cursor");
    });
    $(".li_t").bind("mouseover",function(){
        $(this).css("background","#ebf1dd");
    })
    $(".li_t").bind("mouseout",function(){
        $(this).css("background","");
    })**/
    if(!$.ctx.resources.contains('F12_perSignet')){
        $("#perMessageSetting").css("display","none");
    }
    
    var _phr = "${ctp:hasPlugin('hr')}";
    var _ihr = "${isInternal}";
    
    li_t_resize();
    $(window).resize(function(){
        li_t_resize();
    });
});
function li_t_resize (){
    var _ww = $('body').width();
    var _m = (_ww - 180*5) / 6;
    if (_m < 0) {
        _m = 0;
    };
    $('.li_t').css("margin-left",_m);
}
function showCurrentHrefLocation(obj,url,bool){
    var hrefName = $(obj).html();
    var html = "<span class='nowLocation_ico'><img src='/seeyon/main/skin/frame/harmony/menuIcon/personal.png'/></span>";
    html += "<span class='nowLocation_content'>";
    html += "<a class=\"hand\" onclick=\"showMenu('"+_ctxPath+"/portal/portalController.do?method=personalInfo')\">${ctp:i18n('menu.personal.affair')}</a>";
    if(bool){
    	html += " &gt; <a class=\"hand\" onclick=\"showMenu('" + _ctxPath+ "/portal/portalController.do?method=personalInfoFrame&path="+url + "')\">"+hrefName+"</a>";
    }else{
    	html += " &gt; <a class=\"hand\" onclick=\"showMenu('" + _ctxPath+url + "')\">"+hrefName+"</a>";
    }
    html += "</span>";
    getCtpTop().showLocation(html);
}
function showCurrentHref(obj,url,bool,isShow,pass){
    if(pass){
        getA8Top()._pwdModify("${ctp:i18n('menu.login.pwd.modify')}");
    }else{
    	if(isShow){
            showCurrentHrefLocation(obj,url,bool);
        }
        if(bool==true||bool==undefined){
            getCtpTop().showMenu(_ctxPath + "/portal/portalController.do?method=personalInfoFrame&path="+url);
        }else{
            getCtpTop().showMenu(_ctxPath+url);
        }
    }


}
function showDocSpaceDialog(url,width,height){
	 var docSpaceDialog= getA8Top().$.dialog({
        title:"${ctp:i18n('personalInfo.storeSpace.look')}",
        transParams:{'parentWin':window},
        url: url,
        width: width,
        height: height,
        isDrag:true,
        buttons: [{
			text: "${ctp:i18n('common.button.close.label')}",
			handler: function() {
				docSpaceDialog.close();
			}
		}]
    });
}
//显示在线设备管理的对话框
function showOnlineDeviceManageDialog(url,width,height){
	 var onlineDeviceManageDialog= getA8Top().$.dialog({
      // title:"当前在线情况",
       id: 'onlineDeviceManage',
       title:"${ctp:i18n('current.online.state')}",
       transParams:{'parentWin':window},
       url: url,
       width: width,
       height: height,
       isDrag:true,
       buttons: [{
			text: "${ctp:i18n('common.button.close.label')}",
			handler: function() {
				onlineDeviceManageDialog.close();
			}
		}]
   });
}
//this,'/portal/everybodyWork.do',false,true
function openCurrentHref(obj,url,bool,isShow){
  if($.browser.msie){
    getCtpTop().open(_ctxPath+url);
  }else{
    showCurrentHref(obj,url,bool,isShow);
  }
}
</script>
<style type="text/css">
    .list_ul { overflow: hidden; *zoom: 1; min-width: 720px;}
    .li_t{
        float: left;
        overflow: hidden;
        margin-top:30px;
    	width:180px;
        height:300px;
    }
    .li_t .set_page_1,.li_t .set_page_2,.li_t .set_page_3,.li_t .set_page_4,.li_t .set_page_5,.li_t .set_page_6{
   	 	margin-left: auto;
    	margin-right: auto;
    	margin-top: 0px;
    }
    .li_t .set_content{
    	margin-top: 10px;
    }
    .li_t .title{
    	font-size: 16px;
    	color: #a3a3a3;
    	padding-bottom: 5px;
    	font-family: "Microsoft YaHei",SimSun, Arial,Helvetica,sans-serif;
    }
    .div_t { }
    .div_t td{
        color: #414141;
        font-size: 14px;
        line-height: 100%;
        text-align:left;
        font-family: "Microsoft YaHei",SimSun, Arial,Helvetica,sans-serif;
    }
    .file_name:hover{
    color:#3181d9;
    }
    .div_t td.file_name { padding-top: 10px; padding-right: 5px; cursor: pointer;font-family: "Microsoft YaHei",SimSun, Arial,Helvetica,sans-serif;}
 
</style>
</head>
<body class="set_page_bg2">
<c:if test="${ctp:hasPlugin('nc') && ctp:hasPlugin('u8business')}">
<style type="text/css">
    .li_t{
        height:300px;
    }
</style>
</c:if>
        <div class="list_ul" id="list_ul">
            <!-- 应用设置 -->
            <div class="li_t">
                <div id="individual_template" class="set_page_1" > </div>
                <div class="set_content">
                    <table class="div_t" align="center" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td class="title">${ctp:i18n('menu.personalSet.AppSet')}</td>
                        </tr>
                        <!-- 代理人设置 -->
                        <c:if test="${isInternal}">
                            <tr>
                                <td class="file_name" onclick="showCurrentHref(this,'/agent.do?method=agentFrame',false,true)">${ctp:i18n('menu.individual.agent')}</td>
                            </tr>
                        </c:if>
                        <!-- 个人模板设置 -->
                        <tr>
                            <td class="file_name" onclick="showCurrentHref(this,'/mytemplate.do?method=myTemplate',false,true)">${ctp:i18n('menu.individual.template.set')}</td>
                        </tr>
                        <!-- 消息提示设置 -->
                        <tr>
                            <td class="file_name" onclick="showCurrentHref(this,'/message.do?method=showMessageSetting',false,true)">${ctp:i18n('message.setting.title')}</td>
                        </tr>
                        <!-- NC账号设置 -->
                        <c:if test="${ctp:hasPlugin('nc')||ctp:hasPlugin('ncbusinessplatform')}">
                            <tr>
                                <td class="file_name" onclick="showCurrentHref(this,'/ncUserMapper.do?method=viewBindingMapper',false,true)">${ctp:i18n('nc.user.mapper')}</td>
                            </tr>
                         </c:if>
                        <!-- U8账号设置 -->
                        <c:if test="${ctp:hasPlugin('u8business')}">
                            <tr>
                                <td class="file_name" onclick="showCurrentHref(this,'/u8BusinessUserMapper.do?method=viewBindingMapper',false,true)">${ctp:i18n('u8business.user.mapper')}</td>
                            </tr>
                        </c:if>
                        <!-- cip 设置 -->
                         <c:if test="${ctp:hasPlugin('cip')}">
                         	<c:if test="${cipEnabled == true }">
	                            <tr>
	                                <td class="file_name" onclick="showCurrentHref(this,'/cip/userBindingController.do?method=bindingMySelf',false,true)">${ctp:i18n('cip.service.binding.path.person')}</td>
	                            </tr>
                            </c:if>
                        </c:if>
                    </table>
                </div>
            </div>
            <!-- 关联应用设置 -->
            <div class="li_t">
                <div id="peoplerelate_options" class="set_page_2" > </div>
                <div class="set_content">
                    <table class="div_t" align="center" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td class="title">${ctp:i18n('menu.application.setting')}</td>
                        </tr>
                        <!-- 关联人员 -->
                        <tr>
                            <td class="file_name" onclick="showCurrentHref(this,'/relateMember.do?method=relate',false,true)">${ctp:i18n('menu.peoplerelate.info')}</td>
                        </tr>
                        <!-- 关联项目 -->
                        <!-- <tr>
                            <td class="file_name" onclick="showCurrentHref(this,'/project.do?method=myTemplateBorderMain',false,true)">${ctp:i18n('menu.projecerelate.info')}</td>
                        </tr>   -->
                        <!-- 关联系统 -->
                        <tr>
                            <td class="file_name" onclick="showCurrentHref(this,'/portal/linkSystemController.do?method=userLinkMain',false,true)">${ctp:i18n('menu.relateSystem.info')}</td>
                        </tr>
                        <c:if test="${ctp:hasPlugin('everybodyWork')}">
                            <tr>
                                <td class="file_name" onclick="openCurrentHref(this,'/portal/everybodyWork.do',false,true)">${ctp:i18n('everybodyWork.button.label') }</td>
                            </tr>
                        </c:if>
                      
                    </table>
                </div>
            </div>
            <!-- HR管理 -->
            <c:if test="${(ctp:hasPlugin('hr') || ctp:hasPlugin('attendance')) && isInternal}">
            <div class="li_t">
                <div id="peoplerelate_options" class="set_page_3" > </div>
                <div class="set_content">
                    <table class="div_t" align="center" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td class="title">${ctp:i18n('menu.personalSet.HRManager')}</td>
                        </tr>
                        <!-- 薪资查看 -->
                        <c:if test="${ctp:hasPlugin('hr') && v3x:getSysFlagByName('hr_salary') && salaryEnabled}">
	                        <tr>
	                            <td class="file_name" onclick="showCurrentHref(this,'/hrViewSalary.do?method=viewSalary',false,true)">${ctp:i18n('menu.hr.salary.show')}</td>
	                        </tr>
                        </c:if>
                         <!-- 个人考勤 -->
                        <c:if test="${ctp:hasPlugin('attendance') && cardEnabled}">
                            <tr>
                                <td class="file_name" onclick="showCurrentHref(this,'/attendance/attendance.do?method=intoMyAttendance',false,true)">${ctp:i18n('menu.hr.personal.attendance.manager')}</td>
                            </tr>
                        </c:if>
                    </table>
                </div>
            </div>
            </c:if>
            <!-- 首页设置 -->
            <div class="li_t">
                <div id="personalSetting_message" class="set_page_5" > </div>
                <div class="set_content">
                    <table class="div_t" align="center" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td class="title">${ctp:i18n('menu.portal.setting')}</td>
                        </tr>
                        <!-- 首页设计 -->
                        <c:if test="${v3x:getSysFlagByName('portal_homeDesign') == 'true'}">
                        <tr>
                            <td class="file_name" onclick="getCtpTop().showHomePageDesignerPage();">${ctp:i18n('menu.page.setting')}</td>
                        </tr>
                        </c:if>
                        <!-- 空间栏目 -->
                        <tr>
                            <td class="file_name" onclick="openCtpWindow({'url':'${path}/portal/spaceController.do?method=personalSpaceSetting'})">${ctp:i18n('menu.space.setting')}</td>
                        </tr>
                    </table>
                </div>
            </div>
            <!-- 个人设置 -->
            <div class="li_t">
                <div id="personalSetting_message" class="set_page_6" > </div>
                <div class="set_content">
                    <table class="div_t" align="center" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td class="title">${ctp:i18n('personal.message.setting')}</td>
                        </tr>
                        <!-- 个人信息 -->
                        <tr>
                            <td class="file_name" id="a_personalInfo" onclick="showCurrentHref(this,'/personalAffair.do?method=personalInfo',true,true)">${ctp:i18n('personal.message.label')}</td>
                        </tr>
                        <!-- 登录密码修改 -->
                        <c:if test="${personModifyPwd}">
                            <tr>
                                <td class="file_name" onclick="showCurrentHref(this,'/individualManager.do?method=managerFrame',true,true,true)">${ctp:i18n('menu.login.pwd.modify')}</td>
                            </tr>
                        </c:if>
                        <!-- 印章密码管理 -->
                        <tr id="perMessageSetting">
                            <td class="file_name" onclick="showCurrentHref(this,'/signet.do?method=modifyPasswordSignet',false,true)">${ctp:i18n('menu.print.cipher.manage')}</td>
                        </tr>
                        <!-- 查看存储空间 -->
                        <tr>
                            <td class="file_name" onclick="showDocSpaceDialog('docSpace.do?method=storeSpaceLook',491,250)">${ctp:i18n('personalInfo.storeSpace.look')}</td>
                        </tr>
                         <!-- 在线管理 -->
                        <tr>
                            <td class="file_name" onclick="showOnlineDeviceManageDialog('individualManager.do?method=showOnlineDevice',491,250)">${ctp:i18n('online.device.manage')}</td>
                        </tr>
                    </table>
                </div>
            </div>
    </div>
</body>
</html>