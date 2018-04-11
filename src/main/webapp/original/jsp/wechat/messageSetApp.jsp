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
	    <div class="before">${ctp:i18n("weixin.system.menu.messageSet")}</div><span class="gap">/</span><span class="current">${ctp:i18n("weixin.system.menu.messageSetApp")}</span>
	</div>
	<div class="set">
		<div class="setContent" style="font-size: 14px;color: #000;">
			<span>${ctp:i18n("weixin.workbench.setinfo")}：</span>
		</div>
		<div class="setContent" style="margin-top: 17px;">
			<span>${ctp:i18n("weixin.label.msgdesc")}</span>
		</div>
	</div>
	<div id="APPMessage">
	    <div class="ncMess">
	        <div class="name">
	            <span>${ctp:i18n("weixin.label.issendmsg1")}：</span>
	        </div>
	        <div class="radios">
	            <input id="isSendMsg1" name="isSendMsg" type="radio" style="margin-left: 30px;">
				<label for="isSendMsg1" style="padding-left: 5px"><span>${ctp:i18n("weixin.label.yes")}</span></label>
				<input id="isSendMsg2" name="isSendMsg" type="radio" style="margin-left: 30px;">
				<label for="isSendMsg2" style="padding-left: 5px"><span>${ctp:i18n("weixin.label.on")}</span></label>

			</div>
	        <div style="clear: both;"></div>
	    </div>
	    <div class="link">
	        <div class="name">
	            <span>${ctp:i18n("weixin.label.ishavinglinks1")}：</span>
	        </div>
	        <div class="radios">
	            <input id="isHavingLinks1" name="isHavingLinks" type="radio" style="margin-left: 30px;">
				<label for="isHavingLinks1" style="padding-left: 5px"><span>${ctp:i18n("weixin.label.yes")}</span></label>
				<input id="isHavingLinks2" name="isHavingLinks" type="radio" style="margin-left: 30px;">
				<label for="isHavingLinks2" style="padding-left: 5px"><span>${ctp:i18n("weixin.label.on")}</span></label>

			</div>
	        <div style="clear: both;"></div>
	    </div>
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
</body>
<script type="text/javascript">
    var ajax_weixinSetManager = new weixinSetManager();
    var isSendMsg = '${isSendMsg}';
    var isHavingLinks = '${isHavingLinks}';
    $(document).ready(function(){
        /* 初始化状态 */
		$("#isSendMsg1").prop("checked",isSendMsg === "1");
		$("#isSendMsg2").prop("checked",isSendMsg !== "1");
		$("#isHavingLinks1").prop("checked",isHavingLinks === "1");
		$("#isHavingLinks2").prop("checked",isHavingLinks !== "1");

        /* 按钮事件 */
		$("#submitBtn").click(function () {
			var chooseSend = $("#isSendMsg1").prop("checked")?"1":"0";
			var chooseLink = $("#isHavingLinks1").prop("checked")?"1":"0";


			var data = {
				"isSendMsg" : chooseSend,
				"isHavingLinks" : chooseLink
			};
			ajax_weixinSetManager.saveMessageConfig(data, {
				success: function (rv) {
					if (rv === "1") {
						var msg = "";
						var img = 0;
						if(rv == "1"){
							msg = $.i18n('weixin.set.success');
						}
//                            if(rv == "2"){
//                                msg = $.i18n('weixin.set.success1');
//                                img = 2;
//                            }
						$.messageBox({
							'type': 100,
							'imgType':img,
							'msg': msg,
							buttons: [{
								id:'btn1',
								text: $.i18n("weixin.set.ok"),
								handler: function () { location.reload(); }
							}]
						});
					}else {
						getCtpTop().endProc();
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