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
		  <div style="width:400px;">	 
			<div style="width:400px;">
				<div class="jieru" style="width:160px;" >
					<div class="jieruLogo" style=" margin-left:40px;"  onclick="window.location.href= '${path}/cip/thirdpartyinterface/interface.do?method=index';return false">
						<i class="backImg jieruImg"  style="background-position:-40px -120PX;"></i>
					</div>
					<div class="jieruTitle"  style=" margin-left:40px;"  onclick="window.location.href= '${path}/cip/thirdpartyinterface/interface.do?method=index';return false">
						<span>${ctp:i18n('cip.reg.regist.inter')}</span>
					</div>
					<div class="btn"  style=" margin-left:20px;" onclick="javascript:openD(1401);">
						<span>${ctp:i18n('cip.sample.of.operat')}</span>
					</div>
				</div>
				<div class="right-flag">
					<i class="backImg rightFlagImg"></i>
				</div>
				<div class="jieru" style="width:160px; background-color: rgb(254,197,59);">
					<div class="jieruLogo" style=" margin-left:40px;background-color: rgb(254,202,74);"  onclick="window.location.href= '${path}/cip/thirdpartyinterface/agent.do?method=index';return false">
						<i class="backImg jieruImg"  style="background-position:-120px -200PX; "></i>
					</div>
					<div class="jieruTitle" style=" margin-left:40px;"    onclick="window.location.href= '${path}/cip/thirdpartyinterface/agent.do?method=index';return false">
						<span>${ctp:i18n('cip.reg.home.agent')}</span>
					</div>
					<div class="btn"  style=" margin-left:20px;"  onclick="javascript:openD(1402);">
						<span>${ctp:i18n('cip.sample.of.operat')}</span>
					</div>
				</div>
			</div>
			<div class="top-flag"  style="float:left;">
				<i class="backImg topFlagImg"></i>
			</div>
			<div class="lanmu" style="float:left;" >
				<div class="lanmuLogo"   onclick="window.location.href= '${path}/cip/thirdpartyinterface/resource.do?method=index';return false">
					<i class="backImg lanmuImg"  style="background-position:-120px -120PX;"></i>
				</div>
				<div class="lanmuTitle"   onclick="window.location.href= '${path}/cip/thirdpartyinterface/resource.do?method=index';return false">
					<span>${ctp:i18n('cip.reg.res.bundle')}</span>
				</div>
				<div class="btn"  style=" float:left;margin-left:20px;margin-top:35px;"  onclick="javascript:openD(1403);">
					<span>${ctp:i18n('cip.sample.of.operat')}</span>
				</div>
			</div>
		   </div>	
		</div>
      </div>
	</div>
</body>
</html>