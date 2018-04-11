<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title></title>
<link rel="stylesheet" href="${path}/apps_res/cip/common/css/common.css"/>
</head>
<script type="text/javascript">
	 $().ready(function(){
		$("ul li:first-child").removeClass("current");
		$("#tab1iframe").click(function(){
			$("#bgimg").hide();
			$("#tab1_iframe").attr("src","/seeyon/cip/userBindingController.do");
		});
		$("#tab2iframe").click(function(){
			$("#bgimg").hide();
			$("#tab2_iframe").attr("src","/seeyon/cip/portalConfigController.do");
		});
		$("#tab3iframe").click(function(){
			$("#bgimg").hide();
			$("#tab3_iframe").attr("src","/seeyon/cip/messageConfigController.do?type=0&time="+Math.random());
		});
		$("#tab4iframe").click(function(){
			$("#bgimg").hide();
			$("#tab4_iframe").attr("src","/seeyon/cip/messageConfigController.do?type=1&time="+Math.random());
		});
	}); 
	function openD(enumKey){
		var dialog = getCtpTop().$.dialog({
            url:"${path}/cip/appIntegrationController.do?method=showExample&enumKey="+enumKey,
            width: 900,
            height: 500,
            title: "${ctp:i18n('cip.intenet.plat.sample')}",//示例查看
            buttons: [{
                text: "${ctp:i18n('common.button.cancel.label')}", //取消
                handler: function () {
                    dialog.close();
                }
            }]
    	});
	}
</script>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
    	<div class="comp" comp="type:'breadcrumb',code:'F21_cip_orgsyn'"></div>
        <div id="tabs" style="height: 100%"  class="comp"
		comp="type:'tab',parentId:'tabs'">
		<div id="tabs_head" class="common_tabs">
			<ul class="left">
				<li class="current"><a hidefocus="true" href="javascript:void(0)" 
					tgt="tab1_iframe" id="tab1iframe"><span title="${ctp:i18n('cip.plugin.menu.binduser')}">${ctp:i18n('cip.plugin.menu.binduser')}</span></a></li>
				<li class="current"><a hidefocus="true" href="javascript:void(0)" 
					tgt="tab3_iframe" id="tab3iframe"><span title="${ctp:i18n('cip.plugin.menu.message')}">${ctp:i18n('cip.plugin.menu.message')}</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab4_iframe" id="tab4iframe" ><span title="${ctp:i18n('cip.plugin.menu.pending')}">${ctp:i18n('cip.plugin.menu.pending')}</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab2_iframe" id="tab2iframe" ><span	title="${ctp:i18n('cip.plugin.menu.ssologin')}">${ctp:i18n('cip.plugin.menu.ssologin')}</span></a></li>
			</ul>
		</div>

		<div id="bgimg" style="margin-top:10px;margin-left:80px; ">
			<div style="width: 200px;float: left;margin-top: 190px;">
				<div class="cip-block">
					<div class="content backColor2"  onclick="$('#tab1iframe').trigger('click');">
						<div class="img-block">
							<div class="img backColor2">
								<i class="icon12"></i>
							</div>
						</div>
						<div class="name">
							<span>${ctp:i18n('cip.plugin.menu.binduser')}</span>
						</div>
					</div>
					<div class="operation backColor2"  onclick="javascript:openD(1701);">
						<div class="operation-block">
							<div class="button">
								<span>${ctp:i18n('cip.intenet.set.case')}</span>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div style="width: 50px;height:600px;float: left;position: relative;">
				<div style="position: absolute;width: 1px;height: 380px;border-left: 1px solid #000;top: 70px;left: 25px;"></div>
				<div style="position: absolute;width: 25px;height: 1px;border-top: 1px solid #000;left: 25px;top: 70px;">
					<img src="${path}/apps_res/cip/common/img/right.png" style="position: absolute;top: -6px;right: 0;z-index: 10;">
				</div>
				<div style="position: absolute;width: 25px;height: 1px;border-top: 1px solid #000;left: 25px;top: 260px;">
					<img src="${path}/apps_res/cip/common/img/right.png" style="position: absolute;top: -6px;right: 0;z-index: 10;">
				</div>
				<div style="position: absolute;width: 25px;height: 1px;border-top: 1px solid #000;left: 25px;top: 450px;">
					<img src="${path}/apps_res/cip/common/img/right.png" style="position: absolute;top: -6px;right: 0;z-index: 10;">
				</div>
				<div style="position: absolute;width: 25px;height: 1px;border-top: 1px solid #000;left: 0;top: 260px;">
					<img src="${path}/apps_res/cip/common/img/left.png" style="position: absolute;top: -6px;left: 0;z-index: 10;">
				</div>
			</div>
			<div style="width: 200px;float: left;margin:0 15px;">
				<div class="cip-block">
					<div class="content backColor3"  onclick="$('#tab4iframe').trigger('click');">
						<div class="img-block">
							<div class="img backColor3">
								<i class="icon11" style="background-position:-140px -168px;"></i>
							</div>
						</div>
						<div class="name">
							<span>${ctp:i18n('cip.plugin.menu.pending')}</span>
						</div>
					</div>
					<div class="operation backColor3"  onclick="javascript:openD(1702);">
						<div class="operation-block">
							<div class="button">
								<span>${ctp:i18n('cip.intenet.set.case')}</span>
							</div>
						</div>
					</div>
				</div>
				<div class="cip-block" style="margin-top: 50px;">
					<div class="content backColor3"  onclick="$('#tab3iframe').trigger('click');">
						<div class="img-block">
							<div class="img backcColor3">
								<i class="icon12" style="background-position:-168px -140px;"></i>
							</div>
						</div>
						<div class="name">
							<span>${ctp:i18n('cip.plugin.menu.message')}</span>
						</div>
					</div>
					<div class="operation backColor3"  onclick="javascript:openD(1703);">
						<div class="operation-block">
							<div class="button">
								<span>${ctp:i18n('cip.intenet.set.case')}</span>
							</div>
						</div>
					</div>
				</div>
				<div class="cip-block" style="margin-top: 50px;">
					<div class="content backColor3"  onclick="$('#tab2iframe').trigger('click');">
						<div class="img-block">
							<div class="img backcColor3">
								<i class="icon12" style="background-position:-168px -56px;"></i>
							</div>
						</div>
						<div class="name">
							<span>${ctp:i18n('cip.plugin.menu.ssologin')}</span>
						</div>
					</div>
					<div class="operation backColor3"  onclick="javascript:openD(1704);">
						<div class="operation-block">
							<div class="button">
								<span>${ctp:i18n('cip.intenet.set.case')}</span>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div id="tabs_body" class="common_tabs_body" style="height: 100%;">
		 	<iframe id="tab1_iframe" width="100%" height="100%" frameborder="no" src ="" border="0" 
				class="hidden"></iframe>
			<iframe id="tab2_iframe" width="100%" height="100%" frameborder="no" border="0" src=""
				class="hidden"></iframe>
			<iframe id="tab3_iframe" width="100%" height="100%" frameborder="no" src ="" border="0" 
				class="hidden"></iframe>
			<iframe id="tab4_iframe" width="100%" height="100%" frameborder="no" border="0" src=""
				class="hidden"></iframe>
		</div>
      </div>
	</div>
</body>
</html>