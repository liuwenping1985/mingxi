<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title></title>
<link rel="stylesheet" href="${path}/apps_res/cip/common/css/index2.css"/>
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
			<div id="bgimg">
				<div class="v-block zhangT" >
			        <div class="logo">
			            <i style="background-position:-40px -160px;"></i>
			        </div>
			        <div class="name">
			            <span>${ctp:i18n('cip.scheme.param.init.sync')}</span>
			        </div>
			        <div class="btn">
			            <span>${ctp:i18n('cip.intenet.set.case')}</span>
			        </div>
			    </div>
			    <div class="flag">
			        <i></i>
			    </div>
			    <div class="v-block liucheng">
			        <div class="logo">
			            <i style="background-position:-80PX -160px;"></i>
			        </div>
			        <div class="name">
			            <span>${ctp:i18n('cip.sync.param.config.init')}</span>
			        </div>
			        <div class="btn">
			            <span>${ctp:i18n('cip.intenet.set.case')}</span>
			        </div>
			    </div>
			     <div class="flag">
			        <i></i>
			    </div>
			    <div class="v-block lan">
			        <div class="logo">
			            <i style="background-position:-200px -80px;"></i>
			        </div>
			        <div class="name">
			            <span>${ctp:i18n('cip.sync.param.config.operation')}</span>
			        </div>
			        <div class="btn">
			            <span>${ctp:i18n('cip.intenet.set.case')}</span>
			        </div>
			    </div>
			     <div class="flag">
			        <i></i>
			    </div>
			    <div class="v-block doc">
			        <div class="logo">
			            <i style="background-position:-120PX -160px;"></i>
			        </div>
			        <div class="name">
			            <span>${ctp:i18n('cip.sync.param.config.log')}</span>
			        </div>
			        <div class="btn">
			            <span>${ctp:i18n('cip.intenet.set.case')}</span>
			        </div>
			    </div>
			</div>
		</div>
    </div>
	</div>
</body>
</html>