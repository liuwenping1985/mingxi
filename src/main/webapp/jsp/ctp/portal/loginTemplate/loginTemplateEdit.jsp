<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript" src="${path}/decorations/js/jquery.loginSlide.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/main/login/default/loginColorPicker.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/main/login/default/loginPreview.js${ctp:resSuffix()}"></script>
<link rel="stylesheet" type="text/css" href="${path}/common/designer/css/pageDesigner.css${ctp:resSuffix()}" />
<link rel="stylesheet" type="text/css" href="${path}/main/login/default/css/loginSlide.css${ctp:resSuffix()}" />
<link rel="stylesheet" type="text/css" href="${path}/main/login/default/css/loginPreview.css${ctp:resSuffix()}" />
<style type="text/css">
    .stadic_layout{
        background:#C4CBCE;
    }
    .stadic_right {
        top:20px;
        right:0;
        bottom: 0;
        left:20px;
        position: absolute;
        z-index: 100;
    }
    .stadic_right .stadic_content {
        height: 100%;
        margin: 0 406px 0 0;
        overflow: hidden;
        background:#fff;
    }
    .stadic_left {
        width: 366px;
        height: 100%;
        position: absolute;
        z-index: 300;
        right: 20px;
        top:20px;
    }
    .stadic_flex{
        width: 20px;
        height: 100%;
        position: absolute;
        z-index: 300;
        right: 386px;
        top:20px;
        background-color: #C4CBCE;
    }
    .expand{
        width: 20px;
        height: 100px;
        position: absolute;
        top: 50%;
        left:0;
        margin-top: -50px;
        cursor: pointer;
        background-image: url(${path}/main/skin/frame/default/images/designer-ss-zk.png?V=V6_1_2017-04-13);
        background-position: center;
        background-repeat: no-repeat;
    }
    .expand.zk{
        background-position: 0 0;
    }
    .expand.zk:hover{
        background-position: -20px 0;
    }
    .expand.sq{
        background-position: -40px 0;
    }
    .expand.sq:hover{
        background-position: -60px 0;
    }
    #previewDiv{
        position: relative;
    }
    .common_txtbox_wrap{
        width: 242px;
    }
</style>
<script type="text/javascript">
    var entityLevel = "${param.entityLevel}";
    var entityId = "${param.entityId}";
    var resSuffix="${ctp:resSuffix()}";
    var login_index = "adminLogin";//普通用户和管理员判断
    var _layout = "${layout}"; //模板布局：all，全屏；t_b，上下；l_r，左右；center，上下留白；
    var imgId=parent.imgId;//url添加登录页背景图参数
    var init_w ;//初始化登录框在登录框面板所在的位置 只记录宽度
    var left;
    $.ctx.hotSpots = <c:out value="${hotSpotsJsonStr}" default="null" escapeXml="false" />;
    var imgSize=<c:out value="${bgImgSize}" default="null" escapeXml="false" />;
    var dueRemind="${dueRemind}";
    var dueRemindV="${dueRemindV}";
    $(document).ready(function() {
        //颜色选择面板
        new LoginColorPicker();
        //重新修改布局属性
        function selfAdaption() {
            var layoutHeight = $("#form_area").height() - 20;
            $("#stadic_left_div,#stadic_content,#stadic_right_div").css("height", layoutHeight);
            $("#tabs2_body,#tab1_div,#tab2_div").css("height", layoutHeight - 40);
            $("#previewDiv").css("height", layoutHeight - 50);
        }
        selfAdaption();
        $(window).resize(function() {
            selfAdaption();
        });

        var topbgiVal = $("#topbgi").val();
        if (topbgiVal != "") {
            if (topbgiVal.indexOf("fileId") != -1) {
                $("#topbgiShow").val("fileUpload.do?method=showRTE&" + topbgiVal + "&type=image");
            } else {
                $("#topbgiShow").val(topbgiVal);
            }
            $(".skin_head_img_remove").show();
        } else {
            $("#topbgiShow").val("${ctp:i18n('hotspot.name.topbgi.alert')}");
            $(".skin_head_img_remove").hide();
        }
        setChangebgiUl();
        //上传组件：LOGO
        dymcCreateFileUpload("myfile1", 0, "jpg,jpeg,gif,bmp,png", 1, false, "uploadCallBack1", "poi1", true, true, null, false, true, 10485760);
        //上传组件：登录页背景图片
        dymcCreateFileUpload("myfile2", 0, "jpg,jpeg,gif,bmp,png", 1, false, "uploadCallBack2", "poi2", true, true, null, false, true, 10485760);
		var isClick=0;
        $("#submitbtn").click(function() {
        	isClick++;
            if (!setChangebgi()) {
            	isClick=0;
                return;
            }
            //LOGO位置，登录框位置
            setPosition();
            if($("#name").val()==""||$("#name").val().length>85||$("#description").val().length>500||
            		$("#sort").val()==""||$("#sort").val()>9999||$("#sort").val()<1||!isNum($("#sort").val())||
            		$("#icp").val().length>30||($('#showIcp').attr('checked')&&$("#icp").val().length<5)||$("#icpUrl").val().length>300||
				    ($('#showIcp').attr('checked')&&!checkIcpUrl())){
            	$("a[tgt='tab2_div']").click();
            	if(!$(".expand").hasClass("zk")){
            		expandDesigner();
            	}
            	isClick=0;
            	$._isInValid($("#form_area").formobj());
            	return ;
            }else{
                $("a[tgt='tab2_div']").click();
            }
            var formobj = $("#form_area").formobj();
            if (!$._isInValid(formobj)) {
                showMask();
				if(isClick>1){return ;}
                new loginTemplateManager().transSaveTemplate($("#form_area").formobj(), {
                    success: function() {
                        hideMask();
						if(!$('#setDefault').attr('checked')){
							$.confirm({
								'type': 1,
								'msg': "${ctp:i18n('login.template.setdefault.confirm')}",
								ok_fn: function() {
									$("#setDefault").attr('checked','true');
									new loginTemplateManager().transSaveTemplate($("#form_area").formobj(), {
										 success: function() {
											 setDefaultSuccess();
										 }
									});
								},
								cancel_fn: function() {
									setDefaultSuccess();
								}
							});
						}else{
							refreshTable(true);
						}
                    }
                });
            }else{
            	isClick=0;
            }
        });

        $("#reDefaultbtn").click(function() {
        	isClick++;
            var confirm = $.confirm({
                'msg': "${ctp:i18n('channel.button.toDefault')}",
                ok_fn: function() {
                    var templateId = $("#id").val();
					if(isClick > 1){return;}
                    new loginTemplateManager().transReSetToDefault(templateId, entityId, {
                        success: function() {
                            refreshTable(false);
                        }
                    });
                },
                cancel_fn:function() {
                    isClick=0;
                },
                close_fn:function() {
                    isClick=0;
                }
            });
        });
        if($('#setDefault').attr('checked')){
        	parent.replaceDefaultTemplate($("#id").val());
        }
		function checkIcpUrl(){
			if($("#icpUrl").val()==''){
				return true;
			}
			var r= new RegExp("^(http|https)\://[a-zA-Z0-9-.]+\\.[a-zA-Z0-9]{2,3}(:[0-9]*)?/?([a-zA-Z0-9-._?,\'/\\+&%$#=~])*$");
			return r.test($("#icpUrl").val());
		}
        //登录模板预览
        loginDefault();

        $(".loginboxmainbgc").css('background', _loginboxmainbgc);
        $(".loginboxbottombgc").css('background', _loginboxbottombgc);
        $(".loginboxbuttonbgc").css('background', _loginboxbuttonbgc);
        $("#loginboxmainbgc").val(_loginboxmainbgc);
        $("#loginboxbottombgc").val(_loginboxbottombgc);
        $("#loginboxbuttonbgc").val(_loginboxbuttonbgc);
        $("#loginboxmainbgc_ext5").val(_loginboxmainbgcOpacity);
        $("#loginboxbottombgc_ext5").val(_loginboxbottombgcOpacity);
        $("#loginboxbuttonbgc_ext5").val(_loginboxbuttonbgcOpacity);

        $("#login_contents").click(function() {
            $("#tabs2").tabCurrent("tab1_div");
            $("#loginbox_properties").hide();
            $("#template_properties").show();
            $(this).focus();
        });
        $(".login_area_div").click(function() {
            $("#tabs2").tabCurrent("tab1_div");
            $("#template_properties").hide();
            $("#loginbox_properties").show();
            $(this).focus();
        });
        $("#newfeature").click(function() {
            var isChecked = $(this).is(":checked");
            if (isChecked) {
                $("#new56").show();
            } else {
                $("#new56").hide();
            }
        });
        $("#shownumber").click(function() {
            var isChecked = $(this).is(":checked");
            if (isChecked) {
                $("#login_text_div").css({"visibility":"visible"});
            } else {
                $("#login_text_div").css({"visibility":"hidden"});
            }
        });
        $("#showQr").click(function() {
            var isChecked = $(this).is(":checked");
            if (isChecked) {
                $(".two_code").css({"visibility":"visible"});
            } else {
                $(".two_code").css({"visibility":"hidden"});
            }
        });
        if(imgId){//如果url中添加imgId参数并传值则按照参数值添加图片
			addLoginBgImg(imgId);
		}
        init_w = $("#login_wrap").width();
        left = $("#login_area").position().left;
        $("#login_wrap").resize(function(){
            init_w = $("#login_wrap").width();
            left = $("#login_area").position().left;
        });
    });
    function setDefaultSuccess() {
        $.confirm({
                "msg": "${ctp:i18n('portal.design.home.close')}",
                ok_fn: function () {
                    parent.window.close();
                },
                cancel_fn:function(){
                    window.location.href = "${path}/portal/loginTemplateController.do?method=loginTemplateEdit&templateId=${pt.id}&entityLevel=" + entityLevel + "&entityId=" + entityId;
                }
        });
    }
    function uploadCallBack1(attachment) {
        $("#topbgiShow").val("fileUpload.do?method=showRTE&fileId=" + attachment.instance[0].fileUrl + "&type=image");
        $(".skin_head_img_remove").show();
        $("#topbgi").val("fileId=" + attachment.instance[0].fileUrl);
        var url = "${path}/fileUpload.do?method=showRTE&fileId=" + attachment.instance[0].fileUrl + "&type=image";
        $("#login_logo img").attr("src",url).show();
    }

    function delTopbgi() {
        $("#topbgiShow").val("${ctp:i18n('hotspot.name.topbgi.alert')}");
        $(".skin_head_img_remove").hide();
        $("#topbgi").val("");
        $("#login_logo img").attr("src", "").hide();
    }
	function getWH(imgId){
		var url="/seeyon/portal/loginTemplateController.do?method=getWH&imgId="+imgId;
		$.ajax({
	        url:url,
	        type:'POST',
	        dataType : 'json',
	        success:function(obj){
				for(var i in obj){
				   imgSize[i] = obj[i];
				}
				previewIMG(imgId);//左侧预览
	        }
	    });
	}
    var changebgiLi;
    function setChangebgiLi(obj) {
        changebgiLi = $(obj).parent();
        if (changebgiLi.attr("isAdd") == "true") {
            var length = $("#changebgiUl li").length;
            if (length > 30) {
                $.alert("${ctp:i18n('hotspot.name.changebgi.alert3')}");
                return;
            }
        }
        insertAttachmentPoi('poi2');
    }
    function uploadCallBack2(attachment) {
        var fileId = attachment.instance[0].fileUrl;
        getWH(fileId);
    }
	function previewIMG(fileID){
		 var imgSrc = "${path}/fileUpload.do?method=showRTE&fileId=" + fileID + "&type=image&uu="+getUUID();
		 var fileUrl="fileId="+fileID;
        if (changebgiLi.attr("isAdd") == "true") {
            var length = $("#changebgiUl li").length;
            var temp = "<li class=\"hand\" fileId=\"" + fileUrl + "\"><img src=\"" + imgSrc + "\" width=\"90\" height=\"50\" onclick=\"setChangebgiLi(this);\" /><p><input type=\"checkbox\" onclick=\"previewChangebgi(this)\" /></p><span class=\"deleteThisSkin hidden\" onclick=\"delChangebgi(this)\"></span></li>";
            changebgiLi.before(temp);
        } else {
            changebgiLi.attr("fileId", fileUrl);
            changebgiLi.find("img").attr("src", imgSrc);
        }
        setChangebgiUl();
        previewChangebgi(null);
	}
	/**
	*添加登录页背景图,参数为图片ID
	**/
	function addLoginBgImg(imgId){
		var length = $("#changebgiUl li").length;
        if (length > 30) {
            $.alert("${ctp:i18n('hotspot.name.changebgi.alert3')}");
            return;
        }
		if(changebgiLi==null){
			changebgiLi=$("#changebgiUl li:last");
		}
		previewIMG(imgId);
	}

    function delChangebgi(obj) {
    	var count = 0;
	    $("#changebgiUl li:not(:last)").each(function() {
			var isChecked = $(this).find("input[type='checkbox']").is(':checked');
			if(isChecked)
	        count ++;
	    });
		var isChecked=$(obj).parent().find("input[type='checkbox']").attr("checked");
		if(count>1){
			$(obj).parent().remove();
			previewChangebgi(null);
		}else{
			if(!isChecked){
				$(obj).parent().remove();
				previewChangebgi(null);
			}else{
				$.alert("${ctp:i18n('hotspot.name.changebgi.alert1')}");
			}
		}
    }

    function setChangebgiUl() {
        $("#changebgiUl li:not(:last)").unbind().bind({
            mouseover: function() {
                $(this).find(".deleteThisSkin").removeClass("hidden");
            },
            mouseleave: function() {
                $(this).find(".deleteThisSkin").addClass("hidden");
            }
        });
    }

    function setChangebgi() {
        var changebgiVal = "";
        var changebgi_ext3Val = "";
        var checkedLength = 0;
        $("#changebgiUl li:not(:last)").each(function() {
            changebgiVal += $(this).attr("fileId") + ",";
            var isChecked = $(this).find("input[type='checkbox']").is(':checked');
            if (isChecked) {
                checkedLength ++;
                changebgi_ext3Val += "1,";
            } else {
                changebgi_ext3Val += "0,";
            }
        });
        if (checkedLength == 0) {
            $.alert("${ctp:i18n('hotspot.name.changebgi.alert1')}");
            return false;
        } else if (checkedLength > 5) {
            $.alert("${ctp:i18n('hotspot.name.changebgi.alert2')}");
            return false;
        } else {
            $("#changebgi").val(changebgiVal.substring(0, changebgiVal.length - 1));
            $("#changebgi_ext3").val(changebgi_ext3Val.substring(0, changebgi_ext3Val.length - 1));
            return true;
        }
    }

    function previewChangebgi(obj) {
        if (obj) {
            var length = $("#changebgiUl").find("input:checked").length;
            if (length == 0) {
                $.alert("${ctp:i18n('hotspot.name.changebgi.alert1')}");
                $(obj).attr("checked", true);
            } else if (length > 5) {
                $.alert("${ctp:i18n('hotspot.name.changebgi.alert2')}");
                $(obj).attr("checked", false);
            }
        }
        //图片改变之后，重置并归零
        $("#scroll_ul").html("").css("left",0);
        $("#changebgiUl li:not(:last)").each(function() {
            var isChecked = $(this).find("input[type='checkbox']").is(':checked');
            if (isChecked) {
                var url = "";
                var fileId = $(this).attr("fileId");
                if (fileId.indexOf("fileId") != -1) {
                    url = "${path}/fileUpload.do?method=showRTE&" + fileId + "&type=image";
                } else {
                    url = "${path}/main/login/" + fileId;
                }
                if ($("#bgialign").val() == "center") {
                    var _setBgDom = new changeDomImg("center");
                } else if ($("#bgialign").val() == "left") {
                    var _setBgDom = new changeDomImg("left");
                } else{
                    var _setBgDom = new changeDomImg("zoom");
                }
            }
        });
        changeSlide($("#changebgispeed").val());
    }

    function setBgialign(index, bgialign) {
        $("#bgialignUl li").removeClass("radio_tab_alive");
        $("#bgialignUl li:eq(" + index + ")").addClass("radio_tab_alive");
        $("#bgialign").val(bgialign);
        if (bgialign == "center") {
            var _setBgDom = new changeDomImg("center");
        } else if (bgialign == "left") {
            var _setBgDom = new changeDomImg("left");
        } else{
            var _setBgDom = new changeDomImg("zoom");
        }
        changeSlide($("#changebgispeed").val());
    }

    function setChangebgispeed(index, speed) {
        $("#changebgispeedUl li").removeClass("radio_tab_alive");
        $("#changebgispeedUl li:eq(" + index + ")").addClass("radio_tab_alive");
        $("#changebgispeed").val(speed);
        changeSlide(speed);
    }

    function setPosition() {
        var head_h = 0;//头像超出登录框的部分
        var previewDiv_w = $("#previewDiv").width();
        var previewDiv_h = $("#previewDiv").height();

        var topbgiposition_t = $("#login_logo").offset().top - 20;
        var topbgiposition_l = $("#login_logo").offset().left - 20;
        var topbgiposition = parseInt((topbgiposition_t / previewDiv_h) * 100) + "%," + parseInt((topbgiposition_l / previewDiv_w) * 100) + "%";


        var loginboxposition_t = $(".login_area_div").position().top;
        var loginboxposition_l = $(".login_area_div").position().left;
        var loginboxposition = "";
        if (_layout == "all") {
            loginboxposition = Number(((previewDiv_w - loginboxposition_l - 252) / previewDiv_w) * 100).toFixed(2) + "%," + Number((loginboxposition_t / previewDiv_h) * 100).toFixed(2) + "%";
            //loginPreview.js 239行设置了一个margin-top：50,这里先减去在即算，这里px转换有丢失，无法保证100%精准
        } else if (_layout == "center") {
             loginboxposition = Number(((previewDiv_w - loginboxposition_l - 252) / previewDiv_w) * 100).toFixed(2) + "%," + Number((loginboxposition_t / previewDiv_h) * 100).toFixed(2) + "%";
        }else if (_layout == "t_b") {
            loginboxposition = parseInt(((previewDiv_h - head_h - loginboxposition_t - 210) / previewDiv_h) * 100) + "%,0";
        } else if (_layout == "l_r") {
            loginboxposition = parseInt(((previewDiv_w - loginboxposition_l - 300) / previewDiv_w) * 100) + "%,0";
        }

        $("#topbgiposition").val(topbgiposition);
        $("#loginboxposition").val(loginboxposition);
    }

    function refreshTable(isConfirm) {
        if (isConfirm) {
            $.confirm({
                "msg": "${ctp:i18n('login.template.confirm')}",
                ok_fn: function () {
                    parent.window.close();
                },
                cancel_fn:function(){
                    window.location.href = "${path}/portal/loginTemplateController.do?method=loginTemplateEdit&templateId=${pt.id}&entityLevel=" + entityLevel + "&entityId=" + entityId;
                }
            });
        } else {
            window.location.href = "${path}/portal/loginTemplateController.do?method=loginTemplateEdit&templateId=${pt.id}&entityLevel=" + entityLevel + "&entityId=" + entityId;
        }
    }

    function expandDesigner(){
        if($(".expand").hasClass("zk")){
            $("#stadic_content").css("margin-right","20px");
            $("#stadic_flex").css("right","0");
            $("#stadic_left_div").hide();
            $(".expand").removeClass("zk").addClass("sq");
            $("#login_bg").width($(".stadic_content").width());
            setSliderBgImgForExpand();
             loginPosition();
        }else{
            $("#stadic_content").css("margin-right","406px");
            $("#stadic_flex").css("right","386px");
            $("#stadic_left_div").show();
            $(".expand").removeClass("sq").addClass("zk");
            setSliderBgImgForExpand();
            loginPosition();
        }

    }
    //计算登录框在收起/展开右侧面板的相对位置
    function loginPosition(){
        var width = $("#login_wrap").width();
        var le;
        var right;
        if (_layout == "all" || _layout == "center") {
            right = init_w - left - 252;
        }else if (_layout == "l_r") {
            right = init_w - left - 302;
        }
        if (left <= right) {
            le = parseInt((left/init_w)*width);
            $("#login_area").css("left", le);
        }else{
            le = parseInt((right/init_w)*width);
            $("#login_area").css({"right": le,"left":""});
        }
        previewChangebgi();
    }
    function setSliderBgImgForExpand(){
        var _bgialign=$("#bgialign").val();
        if (_bgialign == "center") {
            var _setBgDom = new changeDomImg("center");
        } else if(_bgialign == "left") {
            var _setBgDom = new changeDomImg("left");
        } else {
             var _setBgDom = new changeDomImg("zoom");
        }
    }
    function isNum(arry){
    	var flag=true;
    	for(var i=0;i<arry.length;i++){
    		var cur = arry[i];
            if (!/^\d+$/.test(cur)) {
            	flag = false;
            }
    	}
    	return flag;
    }
    function disableButtons(){
    	$("#reDefaultbtn").attr("disabled","disabled");
    	$("#submitBtn").attr("disabled","disabled");
    }

    function enableButtons(){
    	$("#reDefaultbtn").removeAttr("disabled");
    	$("#submitBtn").removeAttr("disabled");
    }
</script>
</head>
<body class="h100b over_hidden">
    <div class="stadic_layout form_area" id="form_area">
        <div class="stadic_right" id="stadic_right_div">
            <div class="stadic_content" id="stadic_content">
                <div id="previewDiv">
                    <div id="login_wrap">
                        <div id="login_bg" class="slideBox">
                            <ul id="scroll_ul" class="slideImgs"></ul>
                        </div>
                        <div id="login_logo"><img src=""></div>
                        <div id="login_contents">

                            <div id="new56"></div>
                        </div>
                        <c:if test="${layout != 't_b'}">
                            <div id="login_area" class="login_area_div login_area_${layout}">
                                <div class="login_body">
                                    <div class="login_top">
                                        <div class="touxiang"><img src="${path}/main/login/default/images/touxiang.png" /></div>
                                        <div id="login_text_div" class="text">${ctp:i18n(productCategory)}${ctp:i18n_1("login.edition.number",maxOnline)}</div>
                                        <input id="login_username" type="text" disabled="disabled" />
                                        <input id="login_password" type="text" disabled="disabled" />
                                        <input id="login_button" type="button" value="${ctp:i18n('login.label.Login')}" style="margin-top:22px;">
                                    </div>
                                    <div id="login_bottom_div" class="login_bottom">
                                        <span>${ctp:i18n("login.tip.retrievepwd")}</span>
                                        <span>[${ctp:i18n("login.tip.assistantSetup")}]</span>
                                        <span>中文（简体）</span>
                                    </div>
                                </div>
                                <div class="two_code" ${showQr!=null && showQr.hotspotvalue!=1 ? 'style="color: rgb(255, 255, 255); visibility: hidden;"' : ''}></div>
                            </div>
                        </c:if>
                        <c:if test="${layout == 't_b'}">
                            <div id="login_area" class="login_area_botttom login_area_div">
                                <div class="login_bottom_wrap">
                                    <div id="login_text_div" class="b_text">${ctp:i18n(productCategory)}${ctp:i18n_1("login.edition.number",maxOnline)}</div>
                                    <div class="login_inputs">
                                        <div id="login_usernames"></div>
                                        <div id="login_password"></div>
                                        <input id="login_button" type="button" value="${ctp:i18n('login.label.Login')}" style="width:200px;border:none;">
                                    </div>
                                    <div id="login_bottom_div" class="zhixin_bottom">
                                         <span>中文（简体）</span>
                                         <span>[${ctp:i18n("login.tip.assistantSetup")}]</span>
                                         <span>${ctp:i18n("login.tip.retrievepwd")}</span>
                                    </div>
                                </div>
                                <div class="two_code" ${showQr!=null && showQr.hotspotvalue!=1 ? 'style="color: rgb(255, 255, 255); visibility: hidden;"' : ''}></div>
                            </div>
                        </c:if>
                        <div class="masks top_mask"></div>
                        <div class="masks bottom_mask"></div>
                        <div class="icp_info"></div>
                    </div>
                </div>
                <div id="button_area" class="common_button_action">
                    <a href="javascript:void(0);" id="reDefaultbtn" class="common_button common_button_emphasize left margin_t_10">${ctp:i18n("space.button.toDefault")}</a>
                    <a href="javascript:parent.window.close();" class="common_button common_button_gray right margin_t_10 margin_r_10">${ctp:i18n("common.button.cancel.label")}</a>
                    <a href="javascript:void(0);" id="submitbtn" class="common_button common_button_emphasize right margin_t_10 margin_r_10">${ctp:i18n("common.button.ok.label")}</a>
                </div>
            </div>
        </div>
        <div class="stadic_left" id="stadic_left_div">
            <div id="tabs2" class="comp" comp="type:'tab',width:366,showTabIndex:0">
                <div id="tabs2_head" class="common_tabs loginTab clearfix margin_b_10">
                    <ul class="left">
                        <li class="current" onclick="javascript:$(this).focus();"><a href="javascript:void(0)" tgt="tab1_div"><span>${ctp:i18n("template.login.propertyset")}</span></a></li>
                        <li><a href="javascript:void(0)" tgt="tab2_div"><span>${ctp:i18n("template.login.basicinfo")}</span></a></li>
                    </ul>
                </div>
                <div id="tabs2_body" class="common_tabs_body">
                    <div id="tab1_div">
                        <div id="hotspotDiv">
                            <div class="tabs_body_div">
                                <div id="template_properties" >
                                    <table class="tabs_body_div_table" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td class="tabs_body_div_line">
                                                <label for="newfeature" style="display:none;">
                                            	    <span class="left_radio_com"><input id="newfeature" type="checkbox" class="radio_com" ${param.entityLevel == 'system' ? '' : 'disabled'} ${newfeature.hotspotvalue == 'show' ? 'checked' : ''} /></span>${ctp:i18n(newfeature.name)}
                                                </label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="tabs_body_div_line">
                                                ${ctp:i18n(mainbgc.name)}<a href="#" class="pickColor mainbgc" style="background-color: ${mainbgc.hotspotvalue};"></a>
                                                <input type="hidden" id="mainbgc" value="${mainbgc.hotspotvalue}" />
                                                <input type="hidden" id="mainbgc_ext5" value="${mainbgc.ext5}" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="tabs_body_div_line">
                                                <div>logo ${ctp:i18n("portal.design.login.advice")} 300*300</div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="tabs_body_div_line">
                                                ${ctp:i18n(topbgi.name)}<input id="topbgiShow" type="text" class="path_text hand" style="width: 240px;" value="" onclick="insertAttachmentPoi('poi1');" readonly="readonly" /><span class="ico16 skin_head_img_remove" onclick="delTopbgi()"></span>
                                                <input type="hidden" id="myfile1" />
                                                <input type="hidden" id="topbgi" value="${topbgi.hotspotvalue}" />
                                                <input type="hidden" id="topbgiposition" value="${topbgiposition.hotspotvalue}" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="tabs_body_div_line">
                                                <div>
                                                    <span>
                                                        ${ctp:i18n(changebgi.name)}${ctp:i18n("hotspot.name.changebgi.tip")}
                                                    </span>
                                                    <!-- 在线图片 -->
                                                    <a class="common_button common_button_new hand" href="${path}/mallindex.do?method=category&c_id=374&templateId=${pt.id}&loginSource=cloud_login" target="_blank">${ctp:i18n("cloudapp.online.picture")}</a>

                                                </div>
                                                <ul id="changebgiUl" class="skinList clearfix">
                                                    <c:set value="${fn:split(changebgi.ext3, ',')}" var="imgSelected" />
                                                    <c:forEach items="${fn:split(changebgi.hotspotvalue, ',')}" var="changeImg" varStatus="status">
                                                        <c:set value="${path}/main/login/${changeImg}" var="imgPath" />
                                                        <c:if test="${fn:indexOf(changeImg, 'fileId') != '-1'}">
                                                            <c:set value="${path}/fileUpload.do?method=showRTE&${changeImg}&type=image" var="imgPath" />
                                                        </c:if>
                                                        <li class="hand" fileId="${changeImg}"><img src="${imgPath}" width="90" height="50" onclick="setChangebgiLi(this);" /><p><input type="checkbox" ${imgSelected[status.index] == '1' ? 'checked' : ''} onclick="previewChangebgi(this)" /></p><span class="deleteThisSkin hidden" onclick="delChangebgi(this)"></span></li>
                                                    </c:forEach>
                                                    <li class="hand" isAdd="true"><img src="${path}/main/login/default/images/addChangeImg.png" width="90" height="50" onclick="setChangebgiLi(this);" /></li>
                                                    <input type="hidden" id="myfile2" />
                                                    <input type="hidden" id="changebgi" value="${changebgi.hotspotvalue}" />
                                                    <input type="hidden" id="changebgi_ext3" value="${changebgi.ext3}" />
                                                </ul>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="tabs_body_div_line">
                                                <p>${ctp:i18n(bgialign.name)}</p>
                                                <ul id="bgialignUl" class="radio_tab clearfix">
                                                    <li class="first ${bgialign.hotspotvalue == 'center' ? 'radio_tab_alive' : ''}" onclick="setBgialign('0', 'center')">${ctp:i18n("portal.design.login.center")}</li>
                                                    <li class="${bgialign.hotspotvalue == 'left' ? 'radio_tab_alive' : ''}" onclick="setBgialign('1', 'left')">${ctp:i18n("portal.design.login.left")}</li>
                                                    <li class="end ${bgialign.hotspotvalue == 'zoom' ? 'radio_tab_alive' : ''}" onclick="setBgialign('2','zoom')">${ctp:i18n("portal.design.login.zoom")}</li>
                                                </ul>
                                                <input type="hidden" id="bgialign" value="${bgialign.hotspotvalue}" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="tabs_body_div_line">
                                                <p>${ctp:i18n(changebgispeed.name)}</p>
                                                <ul id="changebgispeedUl" class="radio_tab clearfix">
                                                    <li class="first ${changebgispeed.hotspotvalue == 'speed1' ? 'radio_tab_alive' : ''}" onclick="setChangebgispeed('0', 'speed1')">${ctp:i18n('hotspot.name.changebgispeed.value1')}</li><li class="${changebgispeed.hotspotvalue == 'speed2' ? 'radio_tab_alive' : ''}" onclick="setChangebgispeed('1', 'speed2')">${ctp:i18n('hotspot.name.changebgispeed.value2')}</li><li class="end ${changebgispeed.hotspotvalue == 'speed3' ? 'radio_tab_alive' : ''}" onclick="setChangebgispeed('2', 'speed3')">${ctp:i18n('hotspot.name.changebgispeed.value3')}</li>
                                                </ul>
                                                <input type="hidden" id="changebgispeed" value="${changebgispeed.hotspotvalue}" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div id="loginbox_properties" class="hidden">
                                    <table class="tabs_body_div_table" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td class="tabs_body_div_line">
                                                ${ctp:i18n(loginboxmainbgc.name)}<a href="#" class="pickColor loginboxmainbgc" style="background-color: ${loginboxmainbgc.hotspotvalue};"></a>
                                                <input type="hidden" id="loginboxmainbgc" value="${loginboxmainbgc.hotspotvalue}" />
                                                <input type="hidden" id="loginboxmainbgc_ext5" value="${loginboxmainbgc.ext5}" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="tabs_body_div_line">
                                                ${ctp:i18n(loginboxbottombgc.name)}<a href="#" class="pickColor loginboxbottombgc" style="background-color: ${loginboxbottombgc.hotspotvalue};"></a>
                                                <input type="hidden" id="loginboxbottombgc" value="${loginboxbottombgc.hotspotvalue}" />
                                                <input type="hidden" id="loginboxbottombgc_ext5" value="${loginboxbottombgc.ext5}" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="tabs_body_div_line">
                                                ${ctp:i18n(loginboxbuttonbgc.name)}<a href="#" class="pickColor loginboxbuttonbgc" style="background-color: ${loginboxbuttonbgc.hotspotvalue};"></a>
                                                <input type="hidden" id="loginboxbuttonbgc" value="${loginboxbuttonbgc.hotspotvalue}" />
                                                <input type="hidden" id="loginboxbuttonbgc_ext5" value="${loginboxbuttonbgc.ext5}" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="tab2_div">
                        <div class="tabs_body_div baseInfo_div">
                            <table class="tabs_body_div_table" border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
                                <input type="hidden" id="id" value="${pt.id}" />
                                <c:set value="${param.entityLevel == 'system' ? '' : 'disabled'}" var="disabledVal" />
                                <tr>
                                    <th width="80"><label for="text"><font color="red">*&nbsp;</font>${ctp:i18n("template.portal.name")}</label></th>
                                    <td>
                                        <div class="common_txtbox_wrap">
                                            <input ${disabledVal} type="text" id="name" value="${ctp:toHTMLWithoutSpace(ctp:i18n(pt.name))}" class="validate" validate="type:'string',name:'${ctp:i18n("template.portal.name")}',notNull:true,minLength:1,maxLength:85,character:'!@#$%^*()<>'" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th valign="top" width="80"><label for="text">${ctp:i18n("template.portal.description")}</label></th>
                                    <td>
                                        <div class="common_txtbox clearfix">
                                            <textarea ${disabledVal} id="description" style="height:85px;" class="validate" validate="type:'string',name:'${ctp:i18n("template.portal.description")}',maxLength:500,character:'!@#$%^*()<>'">${ctp:i18n(pt.description)}</textarea>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th width="80"><label for="text"><font color="red">*&nbsp;</font>${ctp:i18n("sortnum.label")}</label></th>
                                    <td>
                                        <div class="common_txtbox_wrap">
                                            <input ${disabledVal} type="text" id="sort" value="${pt.sort}" class="validate" validate="name:'${ctp:i18n("sortnum.label")}',notNull:true,isInteger:true,min:1,max:9999,errorMsg:'${ctp:i18n("sortnum.positiveInteger.prompt")}'" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th width="80"><label for="text">${ctp:i18n("template.portal.path")}</label></th>
                                    <td>
                                        <div class="common_txtbox_wrap">
                                            <input type="text" id="path" value="${pt.path}" disabled />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th width="80"><label for="text">${ctp:i18n(note.name)}</label></th>
                                    <td>
                                        <div class="common_txtbox_wrap">
                                            <input ${disabledVal} id="note" type="text" value="${ctp:toHTMLWithoutSpace(title)}" class="validate" validate="type:'string',name:'${ctp:i18n(note.name)}',maxLength:85,character:'!@#$%^*()<>'" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <div class="setDefault_div">
                                            <label for="setDefault">
                                                <input type="checkbox" id="setDefault" ${setDefault ? 'checked' : ''} ${setDefault ? 'disabled' : ''} />&nbsp;${ctp:i18n("template.login.settodefault")}
                                            </label>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
										<div class="icp_line"></div>
										<div class="loginBase_div">
										(${ctp:i18n("login.template.remind")})<br/>
										</div>
                                        <div class="loginBase_div">
                                            <label for="showQr">
                                                <input type="checkbox" id="showQr" ${showQr==null||showQr.hotspotvalue==1 ? 'checked' : ''}  />&nbsp;${ctp:i18n("login.template.showQr")}
                                            </label>
                                        </div>
                                    </td>
                                </tr>
								<tr>
                                     <td colspan="2">
										<div class="loginBase_div">
											<input type="hidden" id="loginboxposition" value="${loginboxposition.hotspotvalue}" />
											<label for="shownumber">
											<input id="shownumber" type="checkbox" ${shownumber.hotspotvalue == 'show' ? 'checked' : ''} />&nbsp;${ctp:i18n(shownumber.name)}
											</label>
										</div>
                                     </td>
                                </tr>
								<tr>
                                    <td colspan="2">
                                        <div class="loginBase_div">
                                            <label for="showIcp">
                                                <input type="checkbox" ${icp.display==1 ? 'checked' : ''} id="showIcp" onclick="javascript:changeIcpStatus()" />&nbsp;${ctp:i18n("template.login.showicp")}
                                            </label>
                                        </div>
                                    </td>
                                </tr>
								<tr>
                                    <th width="80"><label for="text">${ctp:i18n("template.login.icp")}</label></th>
                                    <td>
                                        <div class="common_txtbox_wrap">
                                            <input id="icp" type="text" class="validate"
                                            validate="type:'string',name:'${ctp:i18n('template.login.icp')}',notNullWithoutTrim:true,minLength:5,maxLength:30" value="${ctp:toHTMLWithoutSpace(icp.hotspotvalue)}" onkeyup="javascript:changeIcpText()" />
                                        </div>
                                    </td>
                                </tr>
								<tr>
                                    <th width="80"><label for="text">${ctp:i18n("template.login.icpurl")}</label></th>
                                    <td>
                                        <div class="common_txtbox_wrap">
                                            <input id="icpUrl" type="text" class="validate" validate="type:'string',name:'${ctp:i18n('template.login.icpurl')}',maxLength:300,regExp:'^(http|https)\://[a-zA-Z0-9-.]+\\.[a-zA-Z0-9]{2,3}(:[0-9]*)?/?([a-zA-Z0-9-._?,\'/\\+&%$#=~])*$',errorMsg:'${ctp:i18n('template.login.icpurl.check')}'" value="${icp.description}" onkeyup="javascript:changeIcpText()" />
                                        </div>
                                    </td>
                                </tr>
								<tr>
                                    <td colspan="2">
                                        <div class="loginBase_div">
                                            <label for="dueRemind">
                                                <input type="checkbox" ${showDueRemind==false?'disabled' : '' } id="dueRemind" ${dueRemindV=='1' ? 'checked' : ''} onclick="javascript:changeDueRamind();" />&nbsp;${ctp:i18n('login.template.dueRemind')}
                                            </label>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="stadic_flex" id="stadic_flex"><span class="expand zk" onClick="expandDesigner()"></span></div>
    </div>
</body>
</html>