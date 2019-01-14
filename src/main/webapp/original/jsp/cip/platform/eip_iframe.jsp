<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>CIP-EIP</title>
<link rel="stylesheet" href="${path}/apps_res/cip/common/css/common.css"/>
</head>

<style type="text/css">
<!--
.common_tabs a {
	font-size: 12px;
	color: #8A8A8A;
	width: auto;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	max-width: 100px;
	display: inline-block;
	background-position: left top;
	min-width: 50px;
	float: left;
	line-height: 27px;
	height: 27px;
	_height: 26px;
	font-family: 'Microsoft YaHei';
	padding: 0 8px;
	text-align: center;
}
-->
</style>
<script type="text/javascript">
	$().ready(function(){
		$("ul li:first-child").removeClass("current");
		$("#tab1iframe").click(function(){
			divHide();
			$("#tab1_iframe").attr("src","${path}/eipPortalTemplateController.do?method=main&"+Math.random());
		});
		$("#tab2iframe").click(function(){
			divHide();
			$("#tab2_iframe").attr("src","${path}/eipPortalSetupController.do?method=main&"+Math.random());
		});
		$("#tab3iframe").click(function(){
			divHide();
			$("#tab3_iframe").attr("src","${path}/eipPortalColumnController.do?method=main&"+Math.random());
		});
		$("#tab4iframe").click(function(){
			divHide();
			$("#tab4_iframe").attr("src","${path}/eipPortalAppController.do?method=main&"+Math.random());
		});
		$("#tab5iframe").click(function(){
			divHide();
			$("#tab5_iframe").attr("src","${path}/eipPortalColumnDetailController.do?method=main&"+Math.random());
		});
		
		function divHide(){//隐藏背景导图
			$("#bgimg").hide();
		}
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
    	<div class="comp" comp="type:'breadcrumb',code:'F21_cip_eip'"></div>
        <div id="tabs" style="height: 100%"  class="comp"
		comp="type:'tab',parentId:'tabs'">
		<div id="tabs_head" class="common_tabs clearfix">
			<ul class="left">
				<li><a hidefocus="true"
					href="javascript:void(0)" tgt="tab1_iframe" id="tab1iframe"><span title="${ctp:i18n('eip.manager.template')}">${ctp:i18n('eip.manager.template')}</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab2_iframe" id="tab2iframe" ><span title="${ctp:i18n('eip.manager.setup')} ">${ctp:i18n('eip.manager.setup')} </span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab3_iframe" id="tab3iframe"><span title="${ctp:i18n('eip.manager.column')}">${ctp:i18n('eip.manager.column')}</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab4_iframe" id="tab4iframe"><span title="${ctp:i18n('eip.manager.app')}">${ctp:i18n('eip.manager.app')}</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab5_iframe" id="tab5iframe"><span title="${ctp:i18n('eip.manager.columndetail')}">${ctp:i18n('eip.manager.columndetail')}</span></a></li>
			</ul>
		</div>
		<div id="bgimg" style="margin-top:50px;margin-left:80px; ">
			<div style="width: 200px;float: left;margin-top: 170px;">
				<div class="cip-block">
					<div class="content backColor2"  onclick="$('#tab2iframe').trigger('click');">
						<div class="img-block">
							<div class="img backColor2">
								<i class="icon12" style="background-position:-140px -28px;"></i>
							</div>
						</div>
						<div class="name">
							<span>${ctp:i18n('cip.intenet.set.eipmh')}</span>
						</div>
					</div>
					<div class="operation backColor2"  onclick="javascript:openD(1005);">
						<div class="operation-block">
							<div class="button">
								<span>${ctp:i18n('cip.intenet.set.case')}</span>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div style="width: 50px;height:600px;float: left;position: relative;margin-left:-10px;">
				<div style="position: absolute;width: 1px;height: 340px;border-left: 1px solid #000;top: 70px;left: 25px;"></div>
				<div style="position: absolute;width: 25px;height: 1px;border-top: 1px solid #000;left: 25px;top: 70px;">
					<img src="${path}/apps_res/cip/common/img/right.png" style="position: absolute;top: -6px;right: 0;z-index: 10;">
				</div>
				<div style="position: absolute;width: 25px;height: 1px;border-top: 1px solid #000;left: 25px;top: 240px;">
					<img src="${path}/apps_res/cip/common/img/right.png" style="position: absolute;top: -6px;right: 0;z-index: 10;">
				</div>
				<div style="position: absolute;width: 25px;height: 1px;border-top: 1px solid #000;left: 25px;top: 410px;">
					<img src="${path}/apps_res/cip/common/img/right.png" style="position: absolute;top: -6px;right: 0;z-index: 10;">
				</div>
				<div style="position: absolute;width: 25px;height: 1px;border-top: 1px solid #000;left: 0;top: 240px;">
					
				</div>
			</div>
			<div style="width: 200px;float: left;margin-left:10px;">
				<div class="cip-block">
					<div class="content backColor3"  onclick="$('#tab1iframe').trigger('click');">
						<div class="img-block">
							<div class="img backColor3">
								<i class="icon11" style="background-position:-140px -56px;"></i>
							</div>
						</div>
						<div class="name">
							<span>${ctp:i18n('cip.intenet.plat.mb')}</span>
						</div>
					</div>
					<div class="operation backColor3" onclick="javascript:openD(1001);">
						<div class="operation-block">
							<div class="button">
								<span>${ctp:i18n('cip.intenet.set.case')}</span>
							</div>
						</div>
					</div>
				</div>
				<div class="cip-block" style="margin-top: 30px;">
					<div class="content backColor1"  onclick="$('#tab4iframe').trigger('click');">
						<div class="img-block">
							<div class="img backColor1">
								<i class="icon12" style="background-position:-140px -84px;"></i>
							</div>
						</div>
						<div class="name">
							<span>${ctp:i18n('cip.intenet.set.eiplm')}</span>
						</div>
					</div>
					<div class="operation backColor1" onclick="javascript:openD(1003);">
						<div class="operation-block">
							<div class="button">
								<span>${ctp:i18n('cip.intenet.set.case')}</span>
							</div>
						</div>
					</div>
				</div>
				<div class="cip-block" style="margin-top: 30px;">
					<div class="content backColor3"  onclick="$('#tab3iframe').trigger('click');">
						<div class="img-block">
							<div class="img backColor3">
								<i class="icon12" style="background-position:-140px -140px;"></i>
							</div>
						</div>
						<div class="name">
							<span>${ctp:i18n('eip.manager.column')}</span>
						</div>
					</div>
					<div class="operation backColor3" onclick="javascript:openD(1002);">
						<div class="operation-block">
							<div class="button">
								<span>${ctp:i18n('cip.intenet.set.case')}</span>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div style="position: relative;width: 30px;height: 1px;border-top: 1px solid #000;left: 440px;top: 235px;">
				<img src="${path}/apps_res/cip/common/img/left.png" style="position: absolute;top: -6px;left: 0;z-index: 10;">
			</div>
			<div class="cip-block" style="margin-top: 168px;margin-left:20px;">
					<div class="content backColor4"  onclick="$('#tab5iframe').trigger('click');">
						<div class="img-block">
							<div class="img backColor4">
								<i class="icon12" style="background-position:-140px -112px;"></i>
							</div>
						</div>
						<div class="name">
							<span>${ctp:i18n('cip.intenet.set.eipnr')}</span>
						</div>
					</div>
					<div class="operation backColor4" onclick="javascript:openD(1004);">
						<div class="operation-block">
							<div class="button">
								<span>${ctp:i18n('cip.intenet.set.case')}</span>
							</div>
						</div>
					</div>
				</div>
		</div>
		<div id="tabs_body" class="common_tabs_body" style="height: 100%;">
			<iframe id="tab1_iframe" width="100%" height="100%" frameborder="no"
				border="0"></iframe>
			<iframe id="tab2_iframe" width="100%" height="100%" frameborder="no" border="0"
				class="hidden"></iframe>
			<iframe id="tab3_iframe" width="100%" height="100%" frameborder="no" border="0"
				class="hidden"></iframe>
			<iframe id="tab4_iframe" width="100%" height="100%" frameborder="no" border="0"
				class="hidden"></iframe>
			<iframe id="tab5_iframe" width="100%" height="100%" frameborder="no" border="0"
				class="hidden"></iframe>
		</div>
    </div>
	</div>
</body>
</html>