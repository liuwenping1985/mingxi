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
        <div class="before">${ctp:i18n('weixin.system.menu.orgSyn')}</div><span class="gap">/</span><span class="current">${ctp:i18n('weixin.system.menu.orgChange')}</span>
    </div>
    <div class="set">
        <div class="setContent" style="font-size: 14px;color: #000;">
            <span>${ctp:i18n("weixin.workbench.setinfo")}：</span>
        </div>
        <div class="setContent" style="margin-top: 17px;">
            <span><span>${ctp:i18n('weixin.org.synchronization.changeToSyn.description')}</span></span>
        </div>
    </div>
<div id="orgChange" style="width: 100%;">
    <div class="block1">
        <div class="name">
            <span>${ctp:i18n('weixin.org.synchronization.changeToSyn')}:</span>
        </div>
        <div class="content">
            <div>
                <input id="isSync1" name="isSync" type="radio">
                <label for="isSync1" style="padding-left: 5px"><span style="font-size: 14px;color: #000;">${ctp:i18n("weixin.label.yes")}</span></label>
                <input id="isSync2" name="isSync" type="radio" style="margin-left: 50px;">
                <label for="isSync2" style="padding-left: 5px"><span style="font-size: 14px;color: #000;">${ctp:i18n("weixin.label.on")}</span></label>
            </div>
        </div>
        <div style="clear: both;"></div>
        <div class="btns">
            <div id="submitBtn" class="submit">
                <span>${ctp:i18n("weixin.set.ok")}</span>
            </div>
            <div id="cancelBtn" class="cancel">
                <span>${ctp:i18n("weixin.set.cancel")}</span>
            </div>
            <div style="clear: both;"></div>
        </div>
    </div>

    <%--<div class="block1">--%>
        <%--<div class="name">--%>
            <%--<span>组同步机制:</span>--%>
        <%--</div>--%>
        <%--<div class="content">--%>
            <%--<div>--%>
                <%--<input type="radio" checked><span style="font-size: 14px;color: #000;">同步变量</span>--%>
                <%--<input type="radio" checked style="margin-left: 50px;"><span style="font-size: 14px;color: #000;">同步全部</span>--%>
            <%--</div>--%>
            <%--<div class="detail">--%>
                <%--<span>同步变量：协同组织结构调整，同步变化的内容到APP通讯录</span><br>--%>
                <%--<span>同步全部：有调整是，对组织结构进行重新同步</span>--%>
            <%--</div>--%>
        <%--</div>--%>
        <%--<div style="clear: both;"></div>--%>
    <%--</div>--%>
</div>
</body>
<script type="text/javascript">
    var ajax_weixinSetManager = new weixinSetManager();
    var isSyncOrg = '${isSyncOrg}';
    $(document).ready(function(){
        /* 初始化状态 */
        $("#isSync1").prop("checked",isSyncOrg === "1");
        $("#isSync2").prop("checked",isSyncOrg !== "1");


        /* 按钮事件 */
        $("#submitBtn").click(function () {
            var chooseSync = $("#isSync1").prop("checked")?"1":"0";
            var data = {
              "isSyncOrg": chooseSync
            };
            ajax_weixinSetManager.saveOrgChange(data, {
                success: function (rv) {
                    if (rv === "1") {
                        var msg = $.i18n('weixin.set.success');
                        var img = 0;
                        $.messageBox({
                            'type': 100,
                            'imgType':img,
                            'msg': msg,
                            buttons: [{
                                id:'btn1',
                                text: $.i18n('weixin.set.ok'),
                                handler: function () { location.reload(); }
                            }]
                        });
                    }else {
                        $.alert($.i18n('weixin.set.fail'));
                    }
                },
                error: function (rv) {
                    $.alert("出错");
                }
            });

        });
        $("#cancelBtn").click(function () {
            window.location.reload();
        });
    })
</script>
</html>