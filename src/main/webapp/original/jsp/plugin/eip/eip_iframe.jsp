<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>CIP-EIP</title>
</head>
<script type="text/javascript">
	$().ready(function(){
		$("#scheme").click(function(){
			$("#tab1_iframe").attr("src","${path}/eipPortalTemplateController.do?method=main&"+Math.random());
		});
		$("#schemeInit").click(function(){
			$("#tab2_iframe").attr("src","${path}/eipPortalSetupController.do?method=main&"+Math.random());
		});
		$("#operation").click(function(){
			$("#tab3_iframe").attr("src","${path}/eipPortalColumnController.do?method=main&"+Math.random());
		});
		$("#record0").click(function(){
			$("#tab4_iframe").attr("src","${path}/eipPortalAppController.do?method=main&"+Math.random());
		});
		$("#record1").click(function(){
			$("#tab5_iframe").attr("src","${path}/eipPortalColumnDetailController.do?method=main&"+Math.random());
		});
		$("#scheme").trigger("click");
		
	});
</script>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
    	<div class="comp" comp="type:'breadcrumb',code:'F21_cip_eip'"></div>
        <div id="tabs" style="height: 100%"  class="comp"
		comp="type:'tab',parentId:'tabs'">
		<div id="tabs_head" class="common_tabs clearfix">
			<ul class="left">
				<li class="current"><a hidefocus="true"
					href="javascript:void(0)" tgt="tab1_iframe" id="scheme"><span title="模板管理">模板管理</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab2_iframe" id="schemeInit" ><span title="门户设置 ">门户设置 </span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab3_iframe" id="operation"><span title="栏目设置">栏目设置</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab4_iframe" id="record0"><span title="栏目内容管理">栏目内容管理</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab5_iframe" id="record1"><span title="内容管理">内容管理</span></a></li>
			</ul>
		</div>
		<div id="tabs_body" class="common_tabs_body" style="height: 100%;">
			<iframe id="tab1_iframe" width="100%" height="100%" frameborder="no"
				border="0"></iframe>
			<iframe id="tab2_iframe" width="100%" height="100%" frameborder="no" border="0"
				class="hidden"></iframe>
			<iframe id="tab3_iframe" width="100%" height="100%" frameborder="no" border="0"
				class="hidden"></iframe>
			<iframe id="tab4_iframe" width="100%" height="100%" frameborder="no" border="0"
				class="hidden"></iframe>
			<iframe id="tab5_iframe" width="100%" height="100%" frameborder="no" border="0"
				class="hidden"></iframe>
		</div>
    </div>
	</div>
</body>
</html>