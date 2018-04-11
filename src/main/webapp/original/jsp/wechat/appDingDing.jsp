<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="${path}/apps_res/weixin/css/common.css"/>
</head>
<body class="h100b over_hidden">
	<div class="crumbly">
        <div class="before">${ctp:i18n('weixin.system.menu.appIntegratedConfig')}</div><span class="gap">/</span><span class="current">${ctp:i18n('weixin.system.menu.appDingDing')}</span>
    </div>
    <div class="set">
        <div class="setContent" style="font-size: 14px;color: #000;">
            <span>配置说明：</span>
        </div>
        <div class="setContent" style="margin-top: 17px;">
            <span>1、请确认您的企业已经注册钉钉，并且已经通过“认证”</span>
        </div>
        <div class="setContent" style="margin-top: 5px;">
            <span>2、请确认协同系统的访问地址（IP）是公网地址</span>
        </div>
        <div class="setContent" style="margin-top: 5px;">
            <span>3、请确认协同系统可以访问外网</span>
        </div>
    </div>
    <div class="process">
        <div class="firstStep">
            <div class="blocks">
                <div class="block">
                    <span style="margin-top: 25px;display: inline-block;">登录钉钉后台</span>
                </div>
                <div class="leftTag">
                    <div style="width: 29px;height: 1px;border-bottom: 1px solid #000;position: relative;margin-top: 35px;margin-left: 6px;">
                        <img style="top: -4px; right: 0; position: absolute; z-index: 10;" src="${path}/apps_res/weixin/img/right.png">
                    </div>
                </div>
                <div class="block">
                    <span style="margin-top: 15px;display: inline-block;">获取企业账号信息</span><br>
                    <span>（CorpID，CorpSecret）</span>
                </div>
                <div class="leftTag">
                    <div style="width: 29px;height: 1px;border-bottom: 1px solid #000;position: relative;margin-top: 35px;margin-left: 6px;">
                        <img style="top: -4px; right: 0; position: absolute; z-index: 10;" src="${path}/apps_res/weixin/img/right.png">
                    </div>
                </div>
                <div class="block">
                    <span style="margin-top: 15px;display: inline-block;">新建微协同应用</span><br>
                    <span>（获取AgentID）</span>
                </div>
                <div style="clear: both;"></div>
            </div>
            <div class="content">
                <span>步骤一：登录钉钉操作</span>
            </div>
        </div>
        <div class="secondStep">
            <div style="position: absolute;left: -26px;top: 10px;">
                <div class="leftTag">
                    <div style="width: 29px;height: 1px;border-bottom: 1px solid #000;position: relative;margin-top: 35px;margin-left: 6px;">
                        <img style="top: -4px; right: 0; position: absolute; z-index: 10;" src="${path}/apps_res/weixin/img/right.png">
                    </div>
                </div>
            </div>
            <div class="blocks">
                <div class="block">
                    <span style="margin-top: 25px;display: inline-block;">绑定</span>
                </div>
            </div>
            <div class="content">
                <span>步骤二：绑定</span>
            </div>
        </div>
        <div style="clear: both;"></div>
    </div>
    <form id="myform" name="myform" method="post">
    <div class="aInput form_area">
        <div class="firstStep">
            <span>步骤一：此阶段操作在钉钉后台，详细操作说明<span id="helpDoc" class="link">请点击此处</span>，点击进入钉钉官网：<span id="dingtalk" class="link">http://www.dingtalk.com</span></span>
        </div>
        <div class="secondStep">
            <span>步骤二：绑定/修改信息请点击</span>
            <div class="modify">
                <span>修改</span>
            </div>
        </div>
        <div class="allInput">
            <input type="hidden" id="companyId">
            <input type="hidden" id="flag">
            <div class="inputRow">
                <div class="name">
                    <span><span class="node">*</span>企业名称：</span>
                </div>
                <div class="input">
                    <input id="companyName" type="text" class="validate" validate="type:'string',name:'企业名称',notNull:true,maxLength:50,avoidChar:'!@#$%^&amp;*+|,'"/>
                </div>
            </div>
            <div class="inputRow">
                <div class="name">
                    <span><span class="node">*</span>钉钉CorpID：</span>
                </div>
                <div class="input">
                    <input id="corpId" type="text" class="validate" validate="type:'string',name:'钉钉corpID',notNull:true,maxLength:50,avoidChar:'!@#$%^&amp;*+|,'"/>
                </div>
                <div class="showDetail">
                    <span class="ico16 help_16 margin_l_5" onmouseover="javascript:document.querySelector('.corpIDImg').style.display='block';" onmouseout="javascript:document.querySelector('.corpIDImg').style.display='none';"></span>
                </div>
            </div>
            <div class="inputRow">
                <div class="name">
                    <span><span class="node">*</span>钉钉CorpSecret：</span>
                </div>
                <div class="input">
                    <input id="secretId" type="text" class="validate" validate="type:'string',name:'钉钉secreID',notNull:true,maxLength:100,avoidChar:'!@#$%^&amp;*+|,'"/>
                </div>
                <div class="showDetail">
                    <span class="ico16 help_16 margin_l_5" onmouseover="javascript:document.querySelector('.secreIDImg').style.display='block';" onmouseout="javascript:document.querySelector('.secreIDImg').style.display='none';"></span>
                </div>
            </div>
            <div class="inputRow">
                <div class="name">
                    <span><span class="node">*</span>钉钉AgentID：</span>
                </div>
                <div class="input">
                    <input id="agentId" type="text" class="validate" validate="type:'string',name:'钉钉agentID',notNull:true,maxLength:50,avoidChar:'!@#$%^&amp;*+|,'"/>
                </div>
                <div class="showDetail">
                    <span class="ico16 help_16 margin_l_5" onmouseover="javascript:document.querySelector('.agentIDImg').style.display='block';" onmouseout="javascript:document.querySelector('.agentIDImg').style.display='none';"></span>
                </div>
            </div>
        </div>
        <div class="submitBtn">
            <div class="dingbtn">
                <span>提交</span>
            </div>
        </div>
    </div>
    </form>
    <img class="corpIDImg" src="${path}/apps_res/weixin/img/ding-CropID.png"/>
    <img class="secreIDImg" src="${path}/apps_res/weixin/img/ding-Cropsecret.png"/>
    <img class="agentIDImg" src="${path}/apps_res/weixin/img/ding-AgentID.png"/>
</body>
<script type="text/javascript">
    $().ready(function(){
        $(".submit").css("display","none");
        $(".modify").bind("click",function(){
            $("#flag").val("flag");
            corpIdDialog();
            
        });

        $(".dingbtn").bind("click",function(){
            var formobj = $("#myform").formobj();
            var valid = $._isInValid(formobj);
            $(".error-form").width(370);
            if (valid) {
                return;
            }
            saveConfig();
        });

        $("#helpDoc").bind("click",function(){
            var url = "/seeyon/H5/wechat/html/dingDingHelpDoc.html"
            openCtpWindow({
                'url': url
            });
        });

        //不允许在框架中打开钉钉首页
        $("#dingtalk").bind("click",function(){
            var url = "http://www.dingtalk.com";
            openCtpWindow({
                'url': url
            });
        });
    });
    //根据corpid获取单位信息
    function getAccountByCorpId(corpId, dialog){
        var ajax_weixinSetManager = new weixinSetManager();
        ajax_weixinSetManager.getAccountByCorpId(encodeURI(corpId),{
            success : function(result) {
                var msg = result.msg;
                var type = result.type;
                if(type == "1"){
                    ctpAlert(msg, type, 0);
                } else {
                    $("#companyName").val(msg.accountName);
                    $("#corpId").val(msg.corpid);
                    $("#corpId").attr("disabled","disabled");
                    $("#secretId").val(msg.secret);
                    $("#agentId").val(msg.agentid);
                    $("#companyId").val(msg.companyId);
                    dialog.close();
                }
            }
        });
    }

    //保存钉钉配置
    function saveConfig(){
        var data = {};
        data.companyId = $("#companyId").val();
        data.companyName = $("#companyName").val();
        data.corpId = $("#corpId").val();
        data.secretId = $("#secretId").val();
        data.agentId = $("#agentId").val();
        data.flag = $("#flag").val();
        var ajax_weixinSetManager = new weixinSetManager();
        ajax_weixinSetManager.updateAccount(data,{
            success : function(result) {
                var msg = result.msg;
                var type = result.type;
                var state = 1;
                if($("#flag").val() == "flag"){
                    state = 0;
                }
                ctpAlert(msg, type, state);
            }
        });
    }
    //type:0,成功;1,失败
    function ctpAlert(msg, type, state) {
        $.messageBox({
            'type' : 100,
            'imgType' : type,
            'msg' : msg,
            cancel_fn : function() {
                if (state == 1) {
                    location.reload();
                }
            },
            buttons : [ {
                id : 'btn1',
                text : "确定",
                handler : function() {
                    if (type == "0") {
                        var corpId = $("#corpId").val();
                        location.href = _ctxPath + "/wechat/wechatSet.do?method=orgSynDingDing&corpId="+corpId;
                    }
                }
            }, {
                id : 'btn2',
                text : "取消",
                handler : function() {
                	if (state == 1) {
                        location.reload();
                    }
                }
            } ]
        });
    }

    function corpIdDialog(){
        var dialog = $.dialog({
            url : _ctxPath + "/wechat/wechatSet.do?method=corpIdDialog",
            htmlId : 'searchId',
            title : '企业信息查询',
            width : '570',
            height : '70',
            cancel_fn : function() {
                $("#flag").val("");
            },
            buttons : [ {
              text : "确定",
              handler : function() {
                var corpid = dialog.getReturnValue();
                if(corpid == null){
                    return;
                } else{
                    getAccountByCorpId(corpid,dialog);
                    
                }
              }
            }, {
              text : "取消",
              handler : function() {
            	$("#flag").val("");
                dialog.close();
              }
            } ]
          });
    }
</script>
</html>