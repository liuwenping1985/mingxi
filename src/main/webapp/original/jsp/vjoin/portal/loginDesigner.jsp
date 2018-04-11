<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
    <title>登录页设计器</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <%@include file="/WEB-INF/jsp/common/common.jsp"%>
	<link rel="stylesheet" href="${path}/apps_res/vjoin/portal/designer/css/loginDesigner.css${v3x:resSuffix()}">
</head>
<body class="h100b" style="overflow-y: auto">
<div class="wrapper" style="background:rgb(51,51,51);">
	<div class="design-top">
		<span>登录页面设计</span>
        <input type="hidden"  id="templateId" value="${templateId}">
        <input type="hidden"  id="entityId" value="${entityId}">
	</div>
	<div class="design-middle" style="overflow-y: hidden;margin:auto;">
		<div class="bgArea">
			<img id="bgImg" src="${path}/apps_res/vjoin/portal/designer/images/login_bg1.jpg"/>
		</div>
		<div id="logoImgDrag" class="logoImg">
			<div class="logoSet">
				<div style="width: 220px;margin: auto">
					<div class="logoChange" onclick="upLoadLogoImg()">
						<span>更换</span>
					</div>
					<div class="logoClear" onclick="resetLogoImg()">
						<span>恢复默认</span>
					</div>
					<div style="clear:both;"></div>
				</div>
			</div>
			<div class="logoPic">
				<img id="logoImg" src="${path}/apps_res/vjoin/portal/designer/images/logo.png" onload="imgOnload();"/>
				<input id="logoSrc" name="logoImg" type="hidden">
				<div id="logoImgDivParam"></div>
			</div>
            <div class="logoReset">
                <span>LOGO设置</span>
            </div>
		</div>
		<div id="loginDrag" class="loginArea">
			<form id="loginForm" class="loginForm" method="post" action="${path}/main/login">
				<!--右侧的logo-->
				<div id="formLogo" class="formLogo">
					<img src="${path}/apps_res/vjoin/portal/designer/images/logo-200x70.png" />
				</div>
				<div id="login_error" class="login_error"></div>
				<!--用户名、密码、登录按钮-->
				<div class="formContent">
					<div class="iconic-input left iptDiv iptUsr">
						<i class="glyphicon glyphicon-user"></i>
						<input disabled type="password" class="form-control" id="login_username" name="login_username" placeholder="请输入账号" style="width: 357px">
					</div>
					<div class="iconic-input left iptDiv iptPsw">
						<i class="glyphicon glyphicon-lock"></i>
						<input disabled type="password" class="form-control" id="login_password" name="login_password" placeholder="请输入密码" style="width: 357px">
					</div>
					<div>
						<button disabled type="submit" class="iptDiv iptBtn">登录</button>
					</div>
				</div>
			</form>
		</div>
		<div class="bgImgSet">
			<div class="set" onclick="upLoadBGImg()">更换</div>
			<div class="reset" onclick="resetBGImg()" style="display:none;">恢复默认</div>
			<div id="bgImgDivParam"></div>
			<input type="hidden" id="bgImgUrl" name="mainBgImg" value="">
		</div>
		<div class="bgImgDe">
			<div>背景图设置</div>
			<div class="size">(建议尺寸1920*1080)</div>
		</div>
		<div id="icpDiv" class="bgDetail">
			<div class="bgSet">
				<div class="bgChange" onclick="icpClick()">
					<span>更换</span>
				</div>
				<div class="bgClear" onclick="icpReset()">
					<span>清空</span>
				</div>
				<div style="clear:both;"></div>
			</div>
			<div class="bgDefault">
				<span id="icpShow">备案信息设置</span>
				<input type="hidden" id="icpVal" name="icp" value="">
				<input type="hidden" id="icpDesc" name="icp" value="">
			</div>
		</div>
	</div>
	<div class="design-bottom">
		<div class="btn_group">
			<button class="btn-sub" onclick="saveConfig()">确定</button>
			<button class="btn-cancel" onclick="window.opener=null;window.close();">取消</button>
		</div>
        <div class="btn-reset" onclick="resetToDef()"><span>恢复默认</span></div>
	</div>
</div>
</body>
<script type="text/javascript">
    var ajax_joinPortalManager = new joinPortalManager();
    function init() {
        if(isOldIE()){
            $("input:password").css("width","320px");
		}
        $(".design-middle").css("height",(document.body.clientHeight-105)+"px");
        $(".design-middle").css("width",(document.body.clientHeight-105) * 16 / 9 +"px");

        $("#logoImgDrag").draggable({
            containment: "parent",
            cursor: "move",
            scroll : false,
            drag : function (event, ui) {
                var dom =$(event.target);
//                changPos(dom);
            }
        });
		$("#logoImgDrag").hover(function (event) {
			$(".logoSet").show();
        },function (event) {
            $(".logoSet").hide();
        })
		$("#icpDiv").hover(function (event) {
			$(".bgSet").show();
        },function (event) {
            $(".bgSet").hide();
        })
        $(".bgImgDe").on("mouseover",function(){
            $(this).hide();
            $(".bgImgSet").show();
        });
        $(".bgImgSet").on("mouseout",function(){
            $(this).hide();
            $(".bgImgDe").show();
        });
        $("#bgImg").load(function(){
            if($("#bgImg").height() < $(".design-middle").height()){
                $("#bgImg").css("height",$(".design-middle").height() + "px");
            }
        });
    }
    function imgOnload(){
        $(".logoSet").css({"width":$("#logoImgDrag").width()-40 + "px","height":$("#logoImgDrag").height()-40 + "px"});
        $(".logoReset").css({"width":$("#logoImgDrag").width()-40 + "px","height":$("#logoImgDrag").height()-40 + "px","line-height":$("#logoImgDrag").height()-40 + "px"});
    }
//    //动画
//    function changPos(dom) {
//        var logoT =  dom.offset().top;
//        var logoL = dom.offset().left;
//        var width = dom.width();
//        var height = dom.height();
//        var allHeight = $(".design-middle").height();
//        var allWidth = $(".design-middle").width();
//        var logoSet = dom.find(".logoSet");
//        var goLeft = allWidth -width-logoL-120<150;
//        var goTop = allHeight + 55 -logoT - height<150;
//        if(goLeft && goTop){
//            var offsetW = 0;
//            if(width<122){
//                offsetW = Math.abs(width - 122)
//            }
//            logoSet.offset({top:logoT-112,left:logoL-offsetW});
//        }else if(goLeft && !goTop){
//            logoSet.offset({top:logoT,left:logoL-122});
//        }else if(!goLeft && goTop){
//            logoSet.offset({top:logoT-112,left:logoL});
//        }else{
//            logoSet.css({'top' : 0,'left': parseInt(width+1)});
//        }
//    }
    //背景图片三操作
    function upLoadBGImg() {
        var poiAddParamImageId = "bgImg";
        dymcCreateFileUpload("bgImgDivParam", 0, 'jpg,jpeg,gif,bmp,png', 1, false, 'addBGImageCallBack', poiAddParamImageId, true, true, null, false, true, 5048000);
        insertAttachmentPoi(poiAddParamImageId);
    }
    function addBGImageCallBack(attachments) {
        $("#bgImgUrl").val("");
        var attachment = attachments.instance[0];
        $("#bgImgUrl").val(attachment.fileUrl);
        $("#bgImg").attr("src", _ctxPath + "/commonimage.do?method=showImage&id=" + attachment.fileUrl + "");//&size=custom&h=320&w=880
        $("#bgImg").load(function(){
            if($("#bgImg").height() < $(".design-middle").height()){
                $("#bgImg").css("height",$(".design-middle").height() + "px");
            }
        });
    }
    function resetBGImg() {
        $("#bgImgUrl").val("");
        $("#bgImg").attr("src", "${path}/apps_res/vjoin/portal/designer/images/login_bg1.jpg");
    }
    //logo上传三操作
    function upLoadLogoImg() {
        var poiAddParamImageId = "logoImg";
        dymcCreateFileUpload("logoImgDivParam", 0, 'jpg,jpeg,gif,bmp,png', 1, false, 'addLogoImageCallBack', poiAddParamImageId, true, true, null, false, true, 5048000);
        insertAttachmentPoi(poiAddParamImageId);
    }
    function addLogoImageCallBack(attachments) {
        $("#logoSrc").val("");
        var attachment = attachments.instance[0];
        $("#logoSrc").val(attachment.fileUrl);
        $("#logoImg").attr("src", _ctxPath + "/commonimage.do?method=showImage&id=" + attachment.fileUrl + "");//&size=custom&h=320&w=880
        imgOnload();
    }
    function resetLogoImg() {
        $("#logoSrc").val("");
        $("#logoImg").attr("src", "${path}/apps_res/vjoin/portal/designer/images/logo.png");
    }
    //备案二操作
    function icpClick(){
        var icpVal = $("#icpVal").val();
        var icpDesc = $("#icpDesc").val();
        var dialog = $.dialog({
            html:"<table style='width: 75%;margin: 25px auto;'>" +
            "<tr style='height: 40px;font-size: 14px;'>" +
            "<td width='30%'><label for='icp1'><span>备案信息</span></label></td>" +
            "<td><input type='text' id='icp1' style='width: 220px' value='"+icpVal+"'></td>" +
            "</tr>" +
            "<tr style='height: 40px;font-size: 14px;'>" +
            "<td width='30%'><label for='icp2'><span>备案跳转链接</span></label></td>" +
            "<td><input type='text' id='icp2' style='width: 220px' value='"+icpDesc+"'></td>" +
            "</tr>" +
            "</table>",
            height:150,
            width: 500,
            title: '备案信息设置',
            overflow:'hidden',
            buttons: [{
                //id: 'ok',
                text: "确定",
                handler: function () {
                    var icp1 = $("#icp1").val();
                    var icp2 = $("#icp2").val();
                    var reg = new RegExp("[><\\'|,\"]");
                    if($.trim(icp1) === ""){
                        $.alert("备案信息不能为空！");
                    }else if (icp1.length>30){
                        $.alert("备案信息不能超过30个字！");
                    }else if(reg.test(icp1)||reg.test(icp2)) {
                        $.alert("备案信息与链接不能使用特殊字符！");
                    }else if (icp2!==""&&!(icp2.indexOf("http://")===0||icp2.indexOf("https://")===0)){
                        $.alert("备案跳转链接应以http://或https://为开头");
                    }else{
                        $("#icpVal").val(icp1);
                        $("#icpDesc").val(icp2);
                        $("#icpShow").text(icp1);
                        dialog.close();
                    }
                }
            }, {
                //id: 'cancel',
                //disabled: true,
                //hide:true,
                text: "取消",
                handler: function () {
                    dialog.close();
                }
            }]
        });
    }
    function icpReset() {
        $("#icpShow").text("备案信息设置");
        $("#icpVal,#icpDesc").val("");
    }

    function saveConfig() {
        var templateId = $("#templateId").val();
        var logoT =  ($("#logoImgDrag").offset().top-55) / $(".design-middle").height() * 100;
        var logoL = ($("#logoImgDrag").offset().left - ($("body").width() - $(".design-middle").width())/2) / $(".design-middle").width() * 100;
        var data = {
            templateId: templateId,
            mainBgImg: $("#bgImgUrl").val(),
            logoImg: $("#logoSrc").val(),
            icp: $("#icpVal").val(),
            icpDesc: $("#icpDesc").val(),
            topbgiposition: parseInt(logoT) + "%," + parseInt(logoL) + "%"
        };
        ajax_joinPortalManager.saveLoginDesigner(data, {
            success: function (rv) {
                alert("保存成功");
            },
            error: function (rv) {
                alert("出错")
            }
        })
    }
    function loadConfig() {
        var templateId = $("#templateId").val();
        var entityId = $("#entityId").val();
        var data = {
            templateId: templateId,
            entityId: entityId
        };
        ajax_joinPortalManager.getHotspotByTemplateId(data, {
            success: function (rv) {
                if(rv !== "" && rv !==null){
                    var hotSpotList = $.parseJSON(rv);
                    for(var i = 0;i<hotSpotList.length;i++){
                        var hotSpot = hotSpotList[i];
                        var key = hotSpot.hotspotkey;
                        var value = hotSpot.hotspotvalue;
                        if(key === "topBgImg"){
                            $("#bgImgUrl").val(value);
                            $("#bgImg").attr("src", _ctxPath + "/commonimage.do?method=showImage&id=" + value + "");//&size=custom&h=320&w=880
						}
                        if(key === "logoImg"){
                            $("#logoSrc").val(value);
                            $("#logoImg").attr("src", _ctxPath + "/commonimage.do?method=showImage&id=" + value + "");//&size=custom&h=320&w=880
						}
                        if(key === "icp"){
                            $("#icpVal").val(value);
                            $("#icpDesc").val(hotSpot.description);
                            if(value){
                                $("#icpShow").text(value);
                            }else{
                                $("#icpShow").text("备案信息设置");
                            }

						}
                        if(key === "topHeight"){
							var top = value.split(",")[0];
							var left = value.split(",")[1];
                            $("#logoImgDrag").css("top",top).css("left",left);
						}
					}
				}
            },
            error: function (rv) {
                alert("出错")
            }
        })
    }
    function resetToDef() {
        var templateId = $("#templateId").val();
        var data = {
            templateId: templateId,
            isClear: "1"
        };
        ajax_joinPortalManager.saveLoginDesigner(data, {
            success: function (rv) {
                alert("恢复默认成功!");
                document.location.reload();
            },
            error: function (rv) {
                alert("出错")
            }
        })
    }
    function isOldIE() {
        if(navigator.appName == "Microsoft Internet Explorer" && navigator.appVersion .split(";")[1].replace(/[ ]/g,"")=="MSIE6.0")
        {
            return true;
        }
        else if(navigator.appName == "Microsoft Internet Explorer" && navigator.appVersion .split(";")[1].replace(/[ ]/g,"")=="MSIE7.0")
        {
            return true;
        }
        else if(navigator.appName == "Microsoft Internet Explorer" && navigator.appVersion .split(";")[1].replace(/[ ]/g,"")=="MSIE8.0")
        {
            return true;
        }
        else if(navigator.appName == "Microsoft Internet Explorer" && navigator.appVersion .split(";")[1].replace(/[ ]/g,"")=="MSIE9.0")
        {
            return true;
        }else return false;
    }
    init();
    loadConfig();
</script>
</html>