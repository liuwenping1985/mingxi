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
	<div id="bgimg" style="margin-top:60px;margin-left:80px; height:170px;">
		 <div class="cip-block" style = "float: left;">
			 <div class="content backColor2" style ="cursor:auto;">
				<div class="img-block">
					<div class="img backColor2" style ="cursor:auto;">
						<i class="icon11" style="background-position:0px -84px;"></i>
					</div>
				</div>
				<div class="name">
					<span>${ctp:i18n('cip.xc.auth.ope')}</span>
				</div>
			</div>
			<div class="operation backColor2"  onclick="javascript:openD(601);">
				<div class="operation-block">
					<div class="button">
						<span>${ctp:i18n('cip.intenet.set.case')}</span>
					</div>
				</div>
			</div>
		</div>
		<div style="width: 50px;float: left;">
			<div style="position: relative;width: 30px;height: 1px;border-top: 1px solid #000;margin: 70px 0 0 10px;">
				<img src="${path}/apps_res/cip/common/img/right.png" style="position: absolute;top: -6px;right: 0;z-index: 10;">
			</div>
		</div>
		<div class="cip-block" style="float: left;">
			<div class="content backColor3" style ="cursor:auto;">
				<div class="img-block">
					<div class="img backColor3" style ="cursor:auto;">
						<i class="icon11" style="background-position:-28px -84px;"></i>
					</div>
				</div>
				<div class="name">
					<span>${ctp:i18n('cip.dd.menu.main')}</span>
				</div>
			</div>
			<div class="operation backColor3" onclick="javascript:openD(602);">
				<div class="operation-block">
					<div class="button">
						<span>${ctp:i18n('cip.intenet.set.case')}</span>
					</div>
				</div>
			</div>
		</div>
		<div style="width: 50px;float: left;">
			<div style="position: relative;width: 30px;height: 1px;border-top: 1px solid #000;margin: 70px 0 0 10px;">
				<img src="${path}/apps_res/cip/common/img/right.png" style="position: absolute;top: -6px;right: 0;z-index: 10;">
			</div>
		</div>
		<div class="cip-block" style="float: left;">
			<div class="content backColor1" style ="cursor:auto;">
				<div class="img-block">
					<div class="img backColor1" style ="cursor:auto;">
						<i class="icon01" style="background-position:-56px -84px;"></i>
					</div>
				</div>
				<div class="name">
					<span>${ctp:i18n('cip.dd.menu.allot')}</span>
				</div>
			</div>
			<div class="operation backColor1"  onclick="javascript:openD(603);">
				<div class="operation-block">
					<div class="button">
						<span>${ctp:i18n('cip.intenet.set.case')}</span>
					</div>
				</div>
			</div>
		</div>
		<div style="width: 50px;float: left;">
			<div style="position: relative;width: 30px;height: 1px;border-top: 1px solid #000;margin: 70px 0 0 10px;">
				<img src="${path}/apps_res/cip/common/img/right.png" style="position: absolute;top: -6px;right: 0;z-index: 10;">
			</div>
		</div>
		<div class="cip-block">
			<div class="content backColor4" style ="cursor:auto;">
				<div class="img-block">
					<div class="img backColor4" style ="cursor:auto;">
						<i class="icon12" style="background-position:-84px -84px;"></i>
					</div>
				</div>
				<div class="name">
					<span>${ctp:i18n('cip.dd.menu.car')}</span>
				</div>
			</div>
			<div class="operation backColor4" onclick="javascript:openD(604);">
				<div class="operation-block">
					<div class="button">
						<span>${ctp:i18n('cip.intenet.set.case')}</span>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
