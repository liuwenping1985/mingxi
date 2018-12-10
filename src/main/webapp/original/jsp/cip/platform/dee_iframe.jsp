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
		$("ul li:first-child").removeClass("current");
		$("#tab1iframe").click(function(){
			divHide();
			$("#tab1_iframe").attr("src","${path}/ncOrgController.do?method=handSynch&time="+Math.random());
		});
		$("#tab2iframe").click(function(){
			divHide();
			$("#tab2_iframe").attr("src","${path}/ncAutoSynch.do?method=autoSynch&time="+Math.random());
		});
		$("#tab3iframe").click(function(){
			divHide();
			$("#tab3_iframe").attr("src","${path}/ncSynchLog.do?method=synchLog&time="+Math.random());
		});
		$("#tab4iframe").click(function(){
			divHide();
			$("#tab4_iframe").attr("src","${path}/ncUserMapper.do?method=userMapper&time="+Math.random());
		});
		$("#tab5iframe").click(function(){
			divHide();
			$("#tab5_iframe").attr("src","${path}/ncMultiJCController.do?method=showNCConfframe&time="+Math.random());
		});
		
		function divHide(){//隐藏背景导图
			$("#bgimg").hide();
		}
	}); 
</script>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
    	<div class="comp" comp="type:'breadcrumb',code:'F21_cip_orgsyn'"></div>
        <div id="tabs" style="height: 100%"  class="comp"
		comp="type:'tab',parentId:'tabs'">
		<div id="tabs_head" class="common_tabs clearfix">
			<ul class="left">
				<li><a hidefocus="true" href="javascript:void(0)" 
					tgt="tab1_iframe" id="tab1iframe"><span title="${ctp:i18n('cip.intenet.plat.data')}">${ctp:i18n('cip.intenet.plat.data')}</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab2_iframe" id="tab2iframe" ><span title="${ctp:i18n('cip.dee.tab.time')}">${ctp:i18n('cip.dee.tab.time')}</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab3_iframe" id="tab3iframe"><span title="${ctp:i18n('cip.dee.tab.quatz')}">${ctp:i18n('cip.dee.tab.quatz')}</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab4_iframe" id="tab4iframe"><span title="${ctp:i18n('cip.intenet.plat.Task')}">${ctp:i18n('cip.intenet.plat.Task')}</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab5_iframe" id="tab5iframe"><span title="${ctp:i18n('cip.dee.tab.tks')}">${ctp:i18n('cip.dee.tab.tks')}</span></a></li>	
			</ul>
		</div>
		<div id="bgimg" align="center"><img alt="" src="/seeyon/apps_res/cip/common/img/1.png"></div>
		<div id="tabs_body" class="common_tabs_body" style="height: 100%;">
			<iframe id="tab1_iframe" width="100%" height="100%" frameborder="no" src ="" border="0" 
				class="hidden"></iframe>
			<iframe id="tab2_iframe" width="100%" height="100%" frameborder="no" border="0" src=""
				class="hidden"></iframe>
			<iframe id="tab3_iframe" width="100%" height="100%" frameborder="no" border="0" src=""
				class="hidden"></iframe>
			<iframe id="tab4_iframe" width="100%" height="100%" frameborder="no" src="" border="0" 
				class="hidden"></iframe>
			<iframe id="tab5_iframe" width="100%" height="100%" frameborder="no" src="" border="0" 
				class="hidden"></iframe>	
		</div>
    </div>
	</div>
</body>
</html>