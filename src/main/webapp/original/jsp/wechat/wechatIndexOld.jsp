<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
    <title>${ctp:i18n('weixin.menuname.wechatset')}</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <script type="text/javascript">
        var _path = "${path}";
        //var _apiKey = "${apiKey}";
        var ajax_weixinSetManager = new weixinSetManager();
    </script>
    <link rel="stylesheet" type="text/css" href="${path}/apps_res/weixin/css/wechatIndex.css${v3x:resSuffix()}"/>
</head>
<body class="h100b over_hidden">
<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'${_resourceCode}'"></div>
<div class="align_center" style="width: 700px;margin: auto">
    <div class="common_checkbox_box clearfix" style="font-weight: bold;text-align: left;padding: 20px 5px">
        ${ctp:i18n('weixin.label.openstate')}
        <label for="isOpenWechat1" class="margin_r_10 hand">
            <input type="radio" value="1" id="isOpenWechat1" name="isOpenWechat" class="radio_com" style="font-weight: normal" <c:if test="${isOpen=='1'}">checked</c:if>>启用</label>
        <label for="isOpenWechat2" class="margin_r_10 hand">
            <input type="radio" value="0" id="isOpenWechat2" name="isOpenWechat" class="radio_com" style="font-weight: normal" <c:if test="${isOpen=='0'}">checked</c:if>>不启用</label>
    </div>
    <fieldset>
        <legend style="font-weight: bold">${ctp:i18n('weixin.menuname.wechatset')}</legend>
        <div class="form_area align_center">
            <form id="wechatForm" action="list.htm" class="align_center">
                <table border="0" cellspacing="0" cellpadding="0" width="500" align="center">
                    <tbody>
                        <tr style="height: 35px">
                            <th nowrap="nowrap"><label class="margin_r_5" for="OAAddress">${ctp:i18n('weixin.label.oaurl')}:</label></th>
                            <td width="100%">
                                <div class="common_txtbox_wrap">
                                    <input id="OAAddress" name="OAAddress" type="text" class="validate" validate="type:'string',name:'协同服务器地址',notNull:true,character:'-!@#$%^&*()_+'" value="${oaAddress}">
                                </div>
                            </td>
                        </tr>
                        <tr style="height: 12px">
                            <th nowrap="nowrap"></th>
                            <td width="100%" style="text-align: left">
                                <b style="font-size: 12px;color: green;">OA的外网访问地址，如：http(s)://oa.seeyon.com:8080</b>
                            </td>
                        </tr>
                        <tr style="height: 35px">
                            <th nowrap="nowrap"><label class="margin_r_5" for="wechatAddress">${ctp:i18n('weixin.label.issyncorg')}:</label></th>
                            <td align="left">
                                <label for="isSyncOrg1" class="margin_r_10 hand">
                                    <input type="radio" value="1" id="isSyncOrg1" name="isSyncOrg" class="radio_com" <c:if test="${isSyncOrg=='1'}">checked</c:if>>是</label>
                                <label for="isSyncOrg2" class="margin_r_10 hand">
                                    <input type="radio" value="0" id="isSyncOrg2" name="isSyncOrg" class="radio_com" <c:if test="${isSyncOrg=='0' ||isSyncOrg == null}">checked</c:if>>否</label>
                            </td>
                        </tr>
                        <tr style="height: 12px">
                            <th nowrap="nowrap"></th>
                            <td width="100%" style="text-align: left">
                                <b style="font-size: 12px;color: green;">监听OA组织模型修改，并同步到企业号通讯录</b>
                            </td>
                        </tr>
                        <tr style="height: 35px">
                            <th nowrap="nowrap"><label class="margin_r_5">${ctp:i18n('weixin.label.issendmsg')}:</label></th>
                            <td align="left">
                                <label for="isSyncMsg1" class="margin_r_10 hand">
                                    <input type="radio" value="1" id="isSyncMsg1" name="isSyncMsg" class="radio_com" <c:if test="${isSendMsg=='1'}">checked</c:if>>是</label>
                                <label for="isSyncMsg2" class="margin_r_10 hand">
                                    <input type="radio" value="0" id="isSyncMsg2" name="isSyncMsg" class="radio_com" <c:if test="${isSendMsg=='0'}">checked</c:if>>否</label>
                            </td>
                        </tr>
                        <tr style="height: 35px">
                            <th nowrap="nowrap"><label class="margin_r_5">${ctp:i18n('weixin.label.ishavinglinks')}:</label></th>
                            <td align="left">
                                <label for="isHavingLinks1" class="margin_r_10 hand">
                                    <input type="radio" value="1" id="isHavingLinks1" name="isHavingLinks" class="radio_com" <c:if test="${isHavingLinks=='1'||isHavingLinks == null}">checked</c:if>>是</label>
                                <label for="isHavingLinks2" class="margin_r_10 hand">
                                    <input type="radio" value="0" id="isHavingLinks2" name="isHavingLinks" class="radio_com" <c:if test="${isHavingLinks=='0'}">checked</c:if>>否</label>
                            </td>
                        </tr>
                        <tr style="height: 35px">
                            <th nowrap="nowrap"><label class="margin_r_5" for="wechatAddress">${ctp:i18n('weixin.label.wechaturl')}:</label></th>
                            <td><div class="common_txtbox_wrap">
                                <input id="wechatAddress" name="wechatAddress" type="text" class="validate" value="${weChatAddress}" disabled validate="type:'string',name:'微信访问地址',notNull:true,character:'-!@#$%^&*()_+'">
                            </div></td>
                        </tr>

                    </tbody>
                </table>
            </form>
        </div>
        <div class="align_center padding_b_10">
            <a href="javascript:void(0)" class="common_button common_button_emphasize hand" style="" id="configSubmit" onclick="configSubmit();">确定</a>
            <a href="javascript:void(0)" class="common_button common_button_gray hand" id="configCancel" onclick="configCancel();">取消</a>
        </div>
    </fieldset>
    <fieldset style="margin-top: 20px">
        <legend style="font-weight: bold">相关设置</legend>
        <div class="form_area align_center">
            <table border="0" cellspacing="0" cellpadding="0" width="700" align="center">
                <tbody>
                    <tr style="height: 100px;">
                        <td style="width:33%;text-align: center" >
                            <div style="width: 100%;height: 100%" onclick="openOtherConfigUrl('http://weixin.seeyon.com/service.jsp');">
                                <span class="wechatIcon64 hand" ></span><br>
                                <span class="hand">微信服务号集成配置</span>
                            </div>
                        </td>
                        <td style="width:33%;text-align: center" >
                            <div style="width: 100%;height: 100%" onclick="openOtherConfigUrl('http://weixin.seeyon.com/company.jsp');">
                                <span class="qiyehaoIcon64 hand" ></span><br>
                                <span class="hand">微信企业号集成配置</span>
                            </div>
                        </td>
                        <td style="width:33%;text-align: center" >
                            <div style="width: 100%;height: 100%" onclick="openOtherConfigUrl('http://weixin.seeyon.com/dingding.jsp');">
                                <span class="dingdingIcon64 hand" ></span><br>
                                <span class="hand">钉钉集成配置</span>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </fieldset>
</div>
</body>
<footer>
    <script type="text/javascript">
        function configSubmit() {
            getCtpTop().startProc();
            var data = {};
            var isOpenWechat = $('input[name="isOpenWechat"]:checked').val();
            var isSyncMsg = $('input[name="isSyncMsg"]:checked ').val();
            var isHavingLinks = $('input[name="isHavingLinks"]:checked ').val();
            var oaAddress = $("#OAAddress").val();
            var wechatAddress = $("#wechatAddress").val();
            var isSyncOrg =  $('input[name="isSyncOrg"]:checked').val();

            data.isOpenWechat = isOpenWechat;
            data.isSyncMsg = isSyncMsg;
            data.isHavingLinks = isHavingLinks;
            data.oaAddress = oaAddress;
            data.wechatAddress = wechatAddress;
            data.isSyncOrg = isSyncOrg;
            ajax_weixinSetManager.saveWechatSetting(data, {
                success: function (rv) {
                    if (rv == "1" || rv =="2") {
                        var msg = "";
                        var img = 0;
                        if(rv == "1"){
                            msg = $.i18n('weixin.set.success');
                        }
                        if(rv == "2"){
                            msg = $.i18n('weixin.set.success1');
                            img = 2;
                        }
                        getCtpTop().endProc();
                        $.messageBox({
                            'type': 100,
                            'imgType':img,
                            'msg': msg,
                            buttons: [{
                                id:'btn1',
                                text: "确定",
                                handler: function () { location.reload(); }
                            }]
                        });
                    } else if(rv == "-1"){
                        getCtpTop().endProc();
                        $.alert($.i18n("weixin.set.fail1"));
                    }else if(rv == "-2"){
                        getCtpTop().endProc();
                        $.alert("设置失败，oa域名连接超时！");
                    }else if(rv == "-3"){
                        getCtpTop().endProc();
                        $.alert("设置失败，oa域名不存在！");
                    }else if(rv == "-4"){
                        getCtpTop().endProc();
                        $.alert("设置失败，oa域名连接失败！");
                    }else {
                        getCtpTop().endProc();
                        $.alert($.i18n('weixin.set.fail'));
                    }
                },
                error: function (rv) {
                    $.alert("出错");
                }
            });
        }
        function configCancel() {
            location.reload();
        }
        function openOtherConfigUrl(url) {
            window.open(url);
        }
    </script>
</footer>
</html>