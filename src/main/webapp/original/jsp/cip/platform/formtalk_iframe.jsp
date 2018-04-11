<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title></title>
<link rel="stylesheet" href="${path}/apps_res/cip/common/css/common.css" />
</head>
<script type="text/javascript">
	$().ready(
			function() {
				$("ul li:first-child").removeClass("current");
				$("#tab1iframe").click(
						function() {
							divHide();
							$("#tab1_iframe").attr(
									"src",
									"${path}/formtalkFormMapperController.do?method=index&time="
											+ Math.random());
						});

				function divHide() {//隐藏背景导图
					$("#bgimg").hide();
				}
			});
	function openD(enumKey) {
		var dialog = getCtpTop().$
				.dialog({
					url : "${path}/cip/appIntegrationController.do?method=showExample&enumKey="
							+ enumKey,
					width : 900,
					height : 500,
					title : "${ctp:i18n('cip.intenet.plat.sample')}",//示例查看
					buttons : [ {
						text : "${ctp:i18n('common.button.cancel.label')}", //取消
						handler : function() {
							dialog.close();
						}
					} ]
				});
	}
</script>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
		<div class="comp" comp="type:'breadcrumb',code:'F21_cip_orgsyn'"></div>
		<div id="tabs" style="height: 100%" class="comp"
			comp="type:'tab',parentId:'tabs'">
			<div id="tabs_head" class="common_tabs clearfix">
				<ul class="left">
					<li><a hidefocus="true" href="javascript:void(0)"
						tgt="tab1_iframe" id="tab1iframe"><span title="${ctp:i18n('cip.formtalk.syn.conf')}">${ctp:i18n('cip.formtalk.syn.conf')}</span></a></li>
				</ul>
			</div>
			<div id="bgimg"
				style="margin-top: 30px; margin-left: 80px; height: 170px;">
				<div class="cip-block" style="float: left;">
					<div class="content backColor2"
						onclick="$('#tab1iframe').trigger('click');">
						<div class="img-block">
							<div class="img backColor2">
								<i class="icon11" style="background-position: -168px -0px;"></i>
							</div>
						</div>
						<div class="name">
							<span>${ctp:i18n('cip.formtalk.syn.conf')}</span>
						</div>
					</div>
					<div class="operation backColor2" onclick="javascript:openD(901);">
						<div class="operation-block">
							<div class="button">
								<span>${ctp:i18n('cip.intenet.set.case')}</span>
							</div>
						</div>
					</div>
				</div>
				<div style="width: 50px; float: left;">
					<div
						style="position: relative; width: 30px; height: 1px; border-top: 1px solid #000; margin: 70px 0 0 10px;">
						<img src="${path}/apps_res/cip/common/img/right.png"
							style="position: absolute; top: -6px; right: 0; z-index: 10;">
					</div>
				</div>
				<div class="cip-block" style="float: left;">
					<div class="content backColor3" style="cursor: auto;">
						<div class="img-block">
							<div class="img backColor3" style="cursor: auto;">
								<i class="icon11" style="background-position: -84px -168px;"></i>
							</div>
						</div>
						<div class="name">
							<span>${ctp:i18n('cip.intenet.set.formtalkfl')}</span>
						</div>
					</div>
					<div class="operation backColor3" onclick="javascript:openD(902);">
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
					src="" border="0" class="hidden"></iframe>
			</div>
		</div>
	</div>
</body>
</html>