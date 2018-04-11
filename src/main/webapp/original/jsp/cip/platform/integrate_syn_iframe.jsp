<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title></title>
<link rel="stylesheet" href="${path}/apps_res/cip/common/css/common.css"/>
</head>
<style type="text/css">
.cip-block{
    display: inline-block;
    width: 170px;
    height: 140px;
}
</style>
<script type="text/javascript">
	 $().ready(function(){
		if($("#sys_isGroupVer").val() == 'true' && $("#adminVer").val() == 'false'){
			$("#formtalk").hide();
			$("#formtalkk").hide();
		}
		if($("#sys_isGroupVer").val() == 'true' && $("#adminVer").val() == 'true'){
			$("#didi").hide();
			$("#didik").hide();
			$("#video").hide();
			$("#videok").hide();
			$("#neigou").hide();
			$("#neigouk").hide();
		}
	}); 
</script>
<body>
	<input type="hidden" id="sys_isGroupVer"  value="${sys_isGroupVer}"/>
	<input type="hidden" id="adminVer"  value="${adminVer}"/>
	<div id='layout' class="comp" comp="type:'layout'">
		<div id="tabs_head" class="common_tabs clearfix">
			<ul class="left">
				<li class="current"><a style="max-width: 120px;" hidefocus="true" href="javascript:void(0)" 
					><span title="${ctp:i18n('cip.plugin.menu.collaboration.add')}">${ctp:i18n('cip.plugin.menu.collaboration.add')}</span></a></li>
			</ul>
		</div>
		<div id="bgimg" style="margin-top:30px;margin-left:10px; height:170px;">
				 <div class="cip-block" style = "float: left;" id="didi">
					 <div class="content backColor2" onclick="window.location.href= '/seeyon/cip/appIntegrationController.do?method=integrationPlugin&type=didicar';return false">
						<div class="img-block">
							<div class="img backColor2">
								<i class="icon11" style="background-position:-196px -56px;"></i>
							</div>
						</div>
						<div class="name">
							<span>${ctp:i18n('cip.plugin.didicar')}</span>
						</div>
					</div>
				</div>
				<div style="width: 50px;float: left;" id="didik">
					<div style="position: relative;width: 30px;height: 1px;margin: 100px 0 0 10px;">
					</div>
				</div>
				<div class="cip-block" style="float: left;" id="video">
					<div class="content backColor3" onclick="window.location.href= '/seeyon/cip/appIntegrationController.do?method=integrationPlugin&type=videoconference';return false">
						<div class="img-block">
							<div class="img backColor3">
								<i class="icon11" style="background-position:-196px -84px;"></i>
							</div>
						</div>
						<div class="name">
							<span>${ctp:i18n('cip.plugin.videoconference')}</span>
						</div>
					</div>
				</div>
				<div style="width: 50px;float: left;" id="videok">
					<div style="position: relative;width: 30px;height: 1px;margin: 100px 0 0 10px;">
					</div>
				</div>
				<div class="cip-block" style="float: left;">
					<div class="content backColor1"  onclick="window.location.href= '/seeyon/cip/appIntegrationController.do?method=integrationPlugin&type=xc';return false">
						<div class="img-block">
							<div class="img backColor1">
								<i class="icon01" style="background-position:-140px -196px;"></i>
							</div>
						</div>
						<div class="name">
							<span>${ctp:i18n('cip.plugin.xc')}</span>
						</div>
					</div>
				</div>
				<div style="width: 50px;float: left;">
					<div style="position: relative;width: 30px;height: 1px;margin: 100px 0 0 10px;">
					</div>
				</div>
				<div class="cip-block" style="float: left;" id="formtalk">
					<div class="content backColor4"  onclick="window.location.href= '/seeyon/cip/appIntegrationController.do?method=integrationPlugin&type=formtalk';return false">
						<div class="img-block">
							<div class="img backColor4">
								<i class="icon12" style="background-position:-196px 0px;"></i>
							</div>
						</div>
						<div class="name">
							<span>${ctp:i18n('cip.plugin.formtalk')}</span>
						</div>
					</div>
				</div>
				<div style="width: 50px;float: left;" id="formtalkk">
					<div style="position: relative;width: 30px;height: 1px;margin: 100px 0 0 10px;">
					</div>
				</div>
				<div class="cip-block"  style="float: left;"  id="neigou">
					<div class="content backColor2" onclick="window.location.href= '/seeyon/cip/appIntegrationController.do?method=integrationPlugin&type=neigou';return false">
						<div class="img-block">
							<div class="img backColor2">
								<i class="icon12" style="background-position:-196px -28px;"></i>
							</div>
						</div>
						<div class="name">
							<span>${ctp:i18n('cip.plugin.neigou')}</span>
						</div>
					</div>
				</div>
					<div style="width: 50px;float: left;" id="neigouk">
					<div style="position: relative;width: 30px;height: 1px;margin: 100px 0 0 10px;">
					</div>
				</div>
				<div class="cip-block" id="multicall">
					<div class="content backColor3" onclick="window.location.href= '/seeyon/cip/appIntegrationController.do?method=integrationPlugin&type=multicall';return false">
						<div class="img-block">
							<div class="img backColor3">
								<i class="icon11" style="background-position:-112px -56px;"></i>
							</div>
						</div>
						<div class="name">
							<span>${ctp:i18n('cip.plugin.multicall')}</span>
						</div>
					</div>
				</div>
			</div>
		</div>
</body>
</html>