<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>CIP-OrgSyn</title>
</head>
<script type="text/javascript">
	 $().ready(function(){
		 $("#scheme").click(function(){
			$("#tab1_iframe").attr("src","${path}/cip/base/deploymentCheck.do?method=showDeploymentForm");
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
				<li class="current"><a hidefocus="true"
					href="javascript:void(0)" tgt="tab1_iframe" id="scheme"><span title="${ctp:i18n('cip.deployment.NCPlugin')}">${ctp:i18n('cip.deployment.NCPlugin')}</span></a></li>
			</ul>
		</div>
		<div id="tabs_body" class="common_tabs_body" style="height: 100%;">
			<iframe id="tab1_iframe" width="100%" height="100%" frameborder="no" src ="${path}/cip/base/deploymentCheck.do?method=showDeploymentForm">
				border="0"></iframe>
		</div>
    </div>
	</div>
</body>
</html>