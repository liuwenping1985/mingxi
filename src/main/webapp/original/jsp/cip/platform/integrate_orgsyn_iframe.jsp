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
</script>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
		<div id="tabs_head" class="common_tabs clearfix">
			<ul class="left">
				<li class="current"><a hidefocus="true" href="javascript:void(0)" 
					><span title="${ctp:i18n('cip.plugin.menu.masterdata')}">${ctp:i18n('cip.plugin.menu.masterdata')}</span></a></li>
			</ul>
		</div>
		<div id="bgimg" align="center" style="margin:30px 0 0 60px;" >
			 <div class="cip-block" style = "float: left;">
				 <div class="content backColor2"  onclick="window.location.href= '/seeyon/cip/org/synOrgController.do';return false">
					<div class="img-block">
						<div class="img backColor2">
							<i class="icon11" style="background-position:-196px -140px;"></i>
						</div>
					</div>
					<div class="name">
						<span>${ctp:i18n('cip.plugin.menu.orgsyn')}</span>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>