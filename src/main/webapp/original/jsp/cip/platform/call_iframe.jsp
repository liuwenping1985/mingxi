<%@page import="com.seeyon.ctp.common.AppContext"%>
<%@page import="com.seeyon.ctp.common.flag.SysFlag"%>
<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>${ctp:i18n('cip.intenet.plat.calltitle')}</title>
</head>
<script type="text/javascript">
	 $().ready(function(){
		 $("#tab2iframe").click(function(){
				$("#tab2_iframe").attr("src","${path}/multiCallController.do?method=multiCallSSO&time="+Math.random());
			});
		 //是否是集团版下的单位管理员
		var isAdministrator = <%=(Boolean)SysFlag.sys_isGroupVer.getFlag() && AppContext.isAdministrator() %>;
		if(isAdministrator){
			$("#tab1li").hide();
			$("#tab2li").addClass("current");
			$("#tab2iframe").trigger('click');
		}
		if(<%=AppContext.isGroupAdmin()%> && !${ctp:hasMultiCallConfig()}){
			$("#tab2li").hide();
		}
	}); 
</script>
<body>
<div id='layout' class="comp" comp="type:'layout'">
	<div id="tabs" class="comp" comp="type:'tab',parentId:'tabs'" style="height: 100%">
		<div id="tabs_head" class="common_tabs clearfix">
			<ul class="left">
				<li class="current" id="tab1li"><a hidefocus="true"
					href="javascript:void(0)" tgt="tab1_iframe"><span>${ctp:i18n('cip.intenet.plat.calltitle')}</span></a></li>
				<li id="tab2li"><a hidefocus="true" href="javascript:void(0)"
					tgt="tab2_iframe" id="tab2iframe" ><span>${ctp:i18n('multicall.plugin.menu.manager')}</span></a></li>
			</ul>
		</div>
		<div id="tabs_body" class="common_tabs_body " style="height: 100%;">
			<iframe id="tab1_iframe" width="100%"  src="${path}/multiCallController.do?method=listConfig" frameborder="no"
				border="0"></iframe>
			<iframe id="tab2_iframe" width="100%"  src="" frameborder="no"
				border="0"></iframe>
		</div>
	</div>
</div>
</body>
</html>