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
</script>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
    	<div class="comp" comp="type:'breadcrumb',code:'F21_cip_orgsyn'"></div>
        <div id="tabs" style="height: 100%"  class="comp"
		comp="type:'tab',parentId:'tabs'">
		<div id="tabs_body" class="common_tabs_body" style="height: 100%;">
			<div class="jieru" >
				<div class="jieruLogo">
					<i class="backImg jieruImg"  style="background-position:0px 0PX;"></i>
				</div>
				<div class="jieruTitle">
					<span>${ctp:i18n('cip.plugin.eip')}</span>
				</div>
			</div>
		</div>
	  </div>
	</div>
</body>
</html>