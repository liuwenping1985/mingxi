<%@page import="java.util.Date"%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>CIP-OrgSyn</title>
<link rel="stylesheet" href="${path}/apps_res/cip/common/css/common.css"/>
</head>
<script type="text/javascript">
	 $().ready(function(){
		$("ul li:first-child").removeClass("current");
		$("#tab1_iframe").hide();
		$("#scheme").click(function(){
			$("#bgimg").hide();
			$("#tab1_iframe").show();
			$("#tab1_iframe").attr("src","${path}/cip/org/synOrgController.do?method=scheme&time="+Math.random());
		});
		$("#schemeInit").click(function(){
			$("#bgimg").hide();
			$("#tab1_iframe").hide();
			$("#tab2_iframe").attr("src","${path}/cip/org/synOrgController.do?method=schemeInit&time="+Math.random());
		});
		$("#operation").click(function(){
			$("#bgimg").hide();
			$("#tab1_iframe").hide();
			$("#tab3_iframe").attr("src","${path}/cip/org/synOrgController.do?method=operation&time="+Math.random());
		}); 
		$("#record").click(function(){
			$("#bgimg").hide();
			$("#tab1_iframe").hide();
			$("#tab4_iframe").attr("src","${path}/cip/org/synOrgController.do?method=record&time="+Math.random());
		});
		//$("#scheme").trigger("click");
		
	}); 
	function openD(enumKey){
			var dialog = getCtpTop().$.dialog({
	            url:"${path}/cip/appIntegrationController.do?method=showExample&enumKey="+enumKey,
	            width: 900,
	            height: 500,
	            title: "${ctp:i18n('cip.intenet.set.look')}",//示例查看
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
        <div id="tabs" style="height: 100%"  class="comp common_tabs"
		comp="type:'tab',parentId:'tabs'">
		<div id="tabs_head" class="common_tabs clearfix">
			<ul class="left">
				<li class="current"><a hidefocus="true"
					href="javascript:void(0)" tgt="tab1_iframe" id="scheme"><span title="${ctp:i18n('cip.sync.param.config.title')}">${ctp:i18n('cip.sync.param.config.title')}</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab2_iframe" id="schemeInit" ><span title="${ctp:i18n('cip.sync.param.config.init')}">${ctp:i18n('cip.sync.param.config.init')}</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab3_iframe" id="operation"><span title="${ctp:i18n('cip.sync.param.config.operation')}">${ctp:i18n('cip.sync.param.config.operation')}</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab4_iframe" id="record"><span title="${ctp:i18n('cip.sync.param.config.log')}">${ctp:i18n('cip.sync.param.config.log')}</span></a></li>
			</ul>
		</div>
		<div id="bgimg" style="margin-top:30px;margin-left:80px; height:170px;">
			 <div class="cip-block" style = "float: left;">
				 <div class="content backColor2" onclick="$('#scheme').trigger('click');">
					<div class="img-block">
						<div class="img backColor2">
							<i class="icon11" style="background-position:-0px -140px;"></i>
						</div>
					</div>
					<div class="name">
						<span>${ctp:i18n('cip.sync.param.config.title')}</span>
					</div>
				</div>
				<div class="operation backColor2"  onclick="javascript:openD(1301);">
					<div class="operation-block">
						<div class="button">
							<span>${ctp:i18n('cip.intenet.set.case')}</span>
						</div>
					</div>
				</div>
			</div>
			<div style="width: 50px;float: left;">
				<div style="position: relative;width: 30px;height: 1px;border-top: 1px solid #000;margin: 70px 0 0 10px;">
					<img src="${path}/apps_res/cip/common/img/right.png" style="position: absolute;top: -6px;right: 0;z-index: 10;">
				</div>
			</div>
			<div class="cip-block" style="float: left;">
				<div class="content backColor3"  onclick="$('#schemeInit').trigger('click');">
					<div class="img-block">
						<div class="img backColor3">
							<i class="icon11" style="background-position:-28px -140px;"></i>
						</div>
					</div>
					<div class="name">
						<span>${ctp:i18n('cip.sync.param.config.init')}</span>
					</div>
				</div>
				<div class="operation backColor3" onclick="javascript:openD(1302);">
					<div class="operation-block">
						<div class="button">
							<span>${ctp:i18n('cip.intenet.set.case')}</span>
						</div>
					</div>
				</div>
			</div>
			<div style="width: 50px;float: left;">
				<div style="position: relative;width: 30px;height: 1px;border-top: 1px solid #000;margin: 70px 0 0 10px;">
					<img src="${path}/apps_res/cip/common/img/right.png" style="position: absolute;top: -6px;right: 0;z-index: 10;">
				</div>
			</div>
			<div class="cip-block" style="float: left;">
				<div class="content backColor1"  onclick="$('#operation').trigger('click');">
					<div class="img-block">
						<div class="img backColor1">
							<i class="icon01"  style="background-position:-56px -56px;"></i>
						</div>
					</div>
					<div class="name">
						<span>${ctp:i18n('cip.sync.param.config.operation')}</span>
					</div>
				</div>
				<div class="operation backColor1"  onclick="javascript:openD(1303);">
					<div class="operation-block">
						<div class="button">
							<span>${ctp:i18n('cip.intenet.set.case')}</span>
						</div>
					</div>
				</div>
			</div>
			<div style="width: 50px;float: left;">
				<div style="position: relative;width: 30px;height: 1px;border-top: 1px solid #000;margin: 70px 0 0 10px;">
					<img src="${path}/apps_res/cip/common/img/right.png" style="position: absolute;top: -6px;right: 0;z-index: 10;">
				</div>
			</div>
			<div class="cip-block">
				<div class="content backColor4" onclick="$('#record').trigger('click');">
					<div class="img-block">
						<div class="img backColor4">
							<i class="icon12" style="background-position:-28px -56px;"></i>
						</div>
					</div>
					<div class="name">
						<span>${ctp:i18n('cip.sync.param.config.log')}</span>
					</div>
				</div>
				<div class="operation backColor4" onclick="javascript:openD(1304);">
					<div class="operation-block">
						<div class="button">
							<span>${ctp:i18n('cip.intenet.set.case')}</span>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div id="tabs_body" class="common_tabs_body" style="height: 100%;">
			<iframe id="tab1_iframe" width="100%" height="100%" frameborder="no"  border="0" src ="${path}/cip/org/synOrgController.do?method=scheme&time=<%=Math.random()%>"
				class="hidden"></iframe>
			<iframe id="tab2_iframe" width="100%" height="100%" frameborder="no" border="0" src="${path}/cip/org/synOrgController.do?method=schemeInit&time=<%=Math.random()%>"
				class="hidden"></iframe>
			<iframe id="tab3_iframe" width="100%" height="100%" frameborder="no" border="0" src="${path}/cip/org/synOrgController.do?method=operation&time=<%=Math.random()%>"
				class="hidden"></iframe>
			<iframe id="tab4_iframe" name="tab4_iframe" width="100%" height="100%" frameborder="no" border="0" 
				class="hidden"></iframe>
		</div>
    </div>
	</div>
</body>
</html>