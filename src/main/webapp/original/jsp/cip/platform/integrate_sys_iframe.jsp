<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title></title>
<link rel="stylesheet" href="${path}/apps_res/cip/common/css/index4.css"/>
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
	<div id='layout' class="comp" comp="type:'layout'">
    	<div class="comp" comp="type:'breadcrumb',code:'F21_cip_orgsyn'"></div>
        <div id="tabs" style="height: 100%"  class="comp"
		comp="type:'tab',parentId:'tabs'">
		<div id="tabs_body" class="common_tabs_body" style="height: 100%;">
			<div id="bgimg" style="width:400px;">	 
			<div style="width:400px;">
				<div class="jieru" style="width:160px; background-color: rgb(161,146,241);">
					<div class="jieruLogo" style=" margin-left:40px;background-color: rgb(169,155,243);"  onclick="window.location.href= '/seeyon/cip/base/product.do';return false">
						<i class="backImg jieruImg"  style="background-position:-40px -120PX;"></i>
					</div>
					<div class="jieruTitle"  style=" margin-left:40px;"  onclick="window.location.href= '/seeyon/cip/base/product.do';return false">
						<span>${ctp:i18n('cip.plugin.menu.productregister')}</span>
					</div>
					 <div class="btn"  style=" margin-left:20px;"  onclick="javascript:openD(1201);">
						<span>${ctp:i18n('cip.sample.of.operat')}</span>
					</div>
				</div>
				<div class="right-flag">
					<i class="backImg rightFlagImg"></i>
				</div>
				<div class="jieru" style="width:160px; background-color: rgb(91,188,255);">
					<div class="jieruLogo" style="  margin-left:40px;background-color: rgb(103,193,255);"  onclick="window.location.href= '/seeyon/cip/base/instance.do?method=showRegisterInstance';return false">
						<i class="backImg jieruImg"  style="background-position:-120px -200PX; "></i>
					</div>
					<div class="jieruTitle" style=" margin-left:40px;"  onclick="window.location.href= '/seeyon/cip/base/instance.do?method=showRegisterInstance';return false">
						<span>${ctp:i18n('cip.base.system.register')}</span>
					</div>
					<div class="btn"  style=" margin-left:20px;" onclick="javascript:openD(1202);">
						<span>${ctp:i18n('cip.sample.of.operat')}</span>
					</div>
				</div>
			  </div>
		   </div>
		</div>
	  </div>
	</div>
</body>
</html>