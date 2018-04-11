<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title></title>
</head>
<script type="text/javascript">
	 $().ready(function(){
		
		$("#tab1iframe").click(function(){
			$("#tab1_iframe").attr("src","${path}/ cip/deployment/createCheckReportController.do?method=showDeploymentForm&time="+Math.random());
		});
	}); 
</script>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
    	<div class="comp" comp="type:'breadcrumb',code:'F21_cip_orgsyn'"></div>
        <div id="tabs" style="height: 100%"  class="comp"
		comp="type:'tab',parentId:'tabs'">
		<div id="tabs_head" class="common_tabs clearfix">
			<ul class="left">
				<li class="current"><a hidefocus="true" href="javascript:void(0)" 
					tgt="tab1_iframe" id="scheme"><span title="${ctp:i18n('cip.deployment.NCPlugin')}">${ctp:i18n('cip.deployment.NCPlugin')}</span></a></li>
			</ul>
		</div>
		<div id="tabs_body" class="common_tabs_body" style="height: 100%;">
			<iframe id="tab1_iframe" width="100%" height="100%" frameborder="no" src ="" border="0" 
				class="hidden"></iframe>
		</div>
    </div>
	</div>
</body>
</html>