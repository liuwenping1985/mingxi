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
		if($("#sys_isGroupVer").val() == 'true'){
			$("#U8").hide();
		}
		if($("#sys_isGroupVer").val() == 'false'){
			$("#sap").hide();
			$("#sapk").hide();
		}
	}); 
</script>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
		<div id="tabs_head" class="common_tabs clearfix">
			<ul class="left">
				<li class="current"><a style="max-width: 100px;" hidefocus="true" href="javascript:void(0)" 
					><span title="${ctp:i18n('cip.plugin.menu.erpplugin')}">${ctp:i18n('cip.plugin.menu.erpplugin')}</span></a></li>
			</ul>
		</div>
		<input type="hidden" id="sys_isGroupVer" value="${sys_isGroupVer}" />
		<div id="bgimg" style="margin-top:30px;margin-left:10px; height:170px;">
			 <div class="cip-block" style = "float: left;">
				 <div class="content backColor2" onclick="window.location.href= '/seeyon/cip/appIntegrationController.do?method=integrationPlugin&type=voucher';return false">
					<div class="img-block">
						<div class="img backColor2">
							<i class="icon11" style="background-position:-28px -196px;"></i>
						</div>
					</div>
					<div class="name">
						<span>${ctp:i18n('cip.plugin.voucher')}</span>
					</div>
				</div>
			</div>
			<div style="width: 50px;float: left;">
				<div style="position: relative;width: 30px;height: 1px;margin: 100px 0 0 10px;">
				</div>
			</div>
			<div class="cip-block" style="float: left;">
				<div class="content backColor3" onclick="window.location.href= '/seeyon/cip/appIntegrationController.do?method=integrationPlugin&type=nc';return false">
					<div class="img-block">
						<div class="img backColor3">
							<i class="icon11" style="background-position:-84px -196px;"></i>
						</div>
					</div>
					<div class="name">
						<span>${ctp:i18n('cip.plugin.nc')}</span>
					</div>
				</div>
			</div>
			<div style="width: 50px;float: left;">
				<div style="position: relative;width: 30px;height: 1px;margin: 100px 0 0 10px;">
				</div>
			</div>
			<div class="cip-block" style="float: left;" id="sap">
				<div class="content backColor1"  onclick="window.location.href= '/seeyon/cip/appIntegrationController.do?method=integrationPlugin&type=orgsync';return false">
					<div class="img-block">
						<div class="img backColor1">
							<i class="icon01" style="background-position:-0px -196px;"></i>
						</div>
					</div>
					<div class="name">
						<span>${ctp:i18n('cip.plugin.sap')}</span>
					</div>
				</div>
			</div>
			<div style="width: 50px;float: left;" id="sapk">
				<div style="position: relative;width: 30px;height: 1px;margin: 100px 0 0 10px;">
				</div>
			</div>
			<div class="cip-block" style="float: left;">
				<div class="content backColor4"  onclick="window.location.href= '/seeyon/cip/appIntegrationController.do?method=integrationPlugin&type=eas';return false">
					<div class="img-block">
						<div class="img backColor4">
							<i class="icon12" style="background-position:-56px -196px;"></i>
						</div>
					</div>
					<div class="name">
						<span>${ctp:i18n('cip.plugin.eas')}</span>
					</div>
				</div>
			</div>
			<div style="width: 50px;float: left;">
				<div style="position: relative;width: 30px;height: 1px;margin: 100px 0 0 10px;">
				</div>
			</div>
			<div class="cip-block" id="U8">
				<div class="content backColor2" onclick="window.location.href= '/seeyon/cip/appIntegrationController.do?method=integrationPlugin&type=u8';return false">
					<div class="img-block">
						<div class="img backColor2">
							<i class="icon12" style="background-position:-112px -196px;"></i>
						</div>
					</div>
					<div class="name">
						<span>${ctp:i18n('cip.plugin.u8')}</span>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>