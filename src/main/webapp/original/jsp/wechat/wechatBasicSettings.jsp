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
        <div class="before">${ctp:i18n("weixin.system.menu.basicSettings")}</div><span class="gap">/</span><span class="current">${ctp:i18n("weixin.system.menu.wechatBasicSettings")}</span>
	</div>
	<div class="set">
		<div class="setContent" style="font-size: 14px;color: #000;">
			<span>${ctp:i18n("weixin.workbench.setinfo")}：</span>
		</div>
		<div class="setContent" style="margin-top: 17px;">
			<span>${ctp:i18n("weixin.label.oaurltext1")}</span>
		</div>
		<div class="setContent" style="margin-top: 5px;">
			<span>${ctp:i18n("weixin.label.oaurltext2")}</span>
		</div>
        <div class="setContent" style="margin-top: 5px;">
            <span>${ctp:i18n("weixin.label.oaurltext3")}</span>
        </div>
        <div class="setContent" style="margin-top: 5px;">
            <span>${ctp:i18n("weixin.label.oaurltext4")}</span>
        </div>
	</div>
	<div class="on-off">
	    <div class="name">
	        <span><font style="color: #d0021b">*</font>${ctp:i18n("weixin.label.openstate")}：</span>
	    </div>
	    <div class="detail">
            <input id="isOpen1" type="radio" name="isOpen" onclick="radioClickFunction()">
            <label for="isOpen1" style="padding-left: 5px"><span>${ctp:i18n("weixin.label.openon")}</span></label>
	        <input id="isOpen2" type="radio" name="isOpen" style="margin-left: 30px;" onclick="radioClickFunction()">
            <label for="isOpen2" style="padding-left: 5px"><span>${ctp:i18n("weixin.label.openoff")}</span></label>

        </div>
	</div>
	<div class="address">
	    <div class="name">
			<span><font style="color: #d0021b">*</font>${ctp:i18n("weixin.label.oaurl")}：</span>
	    </div>
	    <div class="detail">
	        <div>
	            <input type="text" id="oaAddress">
	        </div>
	        <div>
	            <span>${ctp:i18n("weixin.label.oaurltext")}</span><br/>
	        </div>
	    </div>
	</div>
	<div class="address1">
		<div class="name">
			<span><font style="color: #d0021b">*</font>${ctp:i18n("weixin.label.wechaturl")}：</span>
		</div>
		<div class="detail">
			<div>
				<input type="text" id="wechat" value="http://weixin.seeyon.com" disabled>
			</div>
			<div>
				<span></span>
			</div>
		</div>
	</div>
    <%--<div class="on-off">
        <div class="name">
            <span>${ctp:i18n("weixin.label.openapp")}：</span>
        </div>
        <div class="detail">
            <input id="appOpen1" type="checkbox" name="appOpen" onclick="appOpenClickFunction()">
            <label for="appOpen1" style="padding-left: 5px"><span>${ctp:i18n("weixin.system.menu.appWechatEnterprise")}</span></label>

            <input id="appOpen2" type="checkbox" name="appOpen" style="margin-left: 30px;" onclick="appOpenClickFunction()">
            <label for="appOpen2" style="padding-left: 5px"><span>${ctp:i18n("weixin.system.menu.appDingDing")}</span></label>
        </div>
    </div>--%>
	<div class="bbtn">
	    <div class="submit-btn" id="submitBtn">${ctp:i18n("weixin.set.ok")}</div>
	    <div class="cancel-btn" id="cancelBtn">${ctp:i18n("weixin.set.cancel")}</div>
	</div>
</body>
<script type="text/javascript">
    var ajax_weixinSetManager = new weixinSetManager();
    var isOpen = '${isOpen}';
	var oaAddress = '${oaAddress}';
	var wechat = '${wechatAddress}';
	var appOpen = '${appOpen}';

    $(document).ready(function(){
	/* 初始化状态 */
		$("#isOpen1").prop("checked",isOpen === "1");
		$("#isOpen2").prop("checked",isOpen !== "1");

		$("#oaAddress").val(oaAddress);
		if(isOpen !== "1"){
            $("#oaAddress").prop("disabled",true);
		}
		$("#wechat").val(wechat);

//		var appList = appOpen.split(",");
//		if(appList.length === 2){
//		    $("#appOpen1,#appOpen2").prop("checked",true);
//        }else if(appList.length === 1){
//		    if(appOpen === "weixin"){
//                $("#appOpen1").prop("checked",true);
//            }
//            if(appOpen === "dingding"){
//                $("#appOpen2").prop("checked",true);
//            }
//        }

	/* 按钮事件 */
		$("#submitBtn").click(function () {
			var chooseOpen = $("#isOpen1").prop("checked")?"1":"0";
			var oaAddressInput = $.trim($("#oaAddress").val());
			var wechatAddressInput = $.trim($("#wechat").val());
			var appOpen = "";
//            var weixinOpen = $("#appOpen1").is(":checked");
//            var dingOpen = $("#appOpen2").is(":checked");

			if(chooseOpen === "1"){
				if($.trim(oaAddressInput) === ""){
					$.alert($.i18n("weixin.set.fail2"));
					return false;
				}
			}
			var reg = new RegExp("[><\\'|,\"]");
			if(reg.test(oaAddressInput)){
				$.alert($.i18n("weixin.set.fail3"));
				return false;
			}
//            if(!weixinOpen && !dingOpen){
//                $.alert($.i18n("weixin.set.fail4"));
//                return false;
//            }else{
//                if(weixinOpen){
//                    appOpen = "weixin";
//                }
//                if(dingOpen){
//                   appOpen = appOpen + (weixinOpen ? ",dingding" : "dingding");
//                }
//            }
			var data = {
				"isOpen" : chooseOpen,
				"oaAddress" : oaAddressInput,
				"weixinAddress" : wechatAddressInput
				//"appOpen" : appOpen
			};

			ajax_weixinSetManager.saveBasicWechatSetting(data, {
				success: function (rv) {
					if (rv === "1") {
						var msg = "";
						var img = 0;
						if(rv === "1"){
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
								text: $.i18n('weixin.set.ok'),
								handler: function () {
								    window.location.reload();
								}
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
    function radioClickFunction() {
        $("#oaAddress").prop("disabled",$("#isOpen2").is(":checked"));
    }
    function appOpenClickFunction() {
        var weixinOpen = $("#appOpen1").is(":checked");
        var dingOpen = $("#appOpen2").is(":checked");
        if(!weixinOpen && !dingOpen){
            $.alert($.i18n("weixin.set.fail4"));
        }
    }

</script>
</html>