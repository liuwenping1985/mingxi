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
		$("ul li:first-child").removeClass("current");
		$("#tab1iframe").click(function(){
			$("#bgimg").hide();
			$("#tab1_iframe").attr("src","${path}/deeDeployDRPController.do?method=show&time="+Math.random());
		});
		$("#tab2iframe").click(function(){
			$("#bgimg").hide();
			$("#tab2_iframe").attr("src","${path}/deeDataSourceController.do?method=dataSourceFrame&time="+Math.random());
		});
		$("#tab3iframe").click(function(){
			$("#bgimg").hide();
			$("#tab3_iframe").attr("src","${path}/deeScheduleController.do?method=scheduleFrame&time="+Math.random());
		});
		$("#tab4iframe").click(function(){
			$("#bgimg").hide();
			$("#tab4_iframe").attr("src","${path}/deeDeleteController.do?method=getFlowFrame&time="+Math.random());
		});
		$("#tab5iframe").click(function(){
			$("#bgimg").hide();
			$("#tab5_iframe").attr("src","${path}/deeSynchronLogController.do?method=synchronLogFrame&time="+Math.random());
		});
		
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
		<div id="tabs_head" class="common_tabs clearfix">
			<ul class="left">
				<li><a hidefocus="true" href="javascript:void(0)" 
					tgt="tab1_iframe" id="tab1iframe"><span title="${ctp:i18n('cip.dee.tab.res')}">${ctp:i18n('cip.dee.tab.res')}</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab4_iframe" id="tab4iframe"><span title="${ctp:i18n('cip.dee.tab.tkm')}">${ctp:i18n('cip.dee.tab.tkm')}</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab5_iframe" id="tab5iframe"><span title="${ctp:i18n('cip.dee.tab.tks')}">${ctp:i18n('cip.dee.tab.tks')}</span></a></li>	
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab2_iframe" id="tab2iframe" ><span title="${ctp:i18n('cip.dee.tab.time')}">${ctp:i18n('cip.dee.tab.time')}</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab3_iframe" id="tab3iframe"><span title="${ctp:i18n('cip.dee.tab.quatz')}">${ctp:i18n('cip.dee.tab.quatz')}</span></a></li>
			</ul>
		</div>
		<div id="bgimg">
			 <div style="width: 100%;">
				<div style="width: 710px;margin: 0 auto;">
					<div style="width: 250px;height: 170px;display: inline-block;">
						<div style="position: relative;width: 1px;height: 115px;border-left: 1px solid #000;margin: 105px 0 0 80px;"></div>
						<div style="position: relative;width: 160px;height: 1px;border-top: 1px solid #000;margin: -115px 0 0 80px;">
							<img src="${path}/apps_res/cip/common/img/right.png" style="position: absolute;top: -6px;right: 0;z-index: 10;">
						</div>
					</div>
					<div class="cip-block">
						<div class="content backColor3" onclick="$('#tab4iframe').trigger('click');">
							<div class="img-block">
								<div class="img backColor3">
									<i class="icon01" style="background-position:-0px -28px;"></i>
								</div>
							</div>
							<div class="name">
								<span>${ctp:i18n('cip.dee.tab.tkm')}</span>
							</div>
						</div>
						<div class="operation backColor3"  onclick="javascript:openD(1502);">
							<div class="operation-block">
								<div class="button">
									<span>${ctp:i18n('cip.intenet.set.case')}</span>
								</div>
							</div>
						</div>
					</div>
					<div style="width: 250px;height: 170px;display: inline-block;">
						<div style="position: relative;width: 1px;height: 115px;border-left: 1px solid #000;margin: 105px 0 0 170px;">
							<img src="${path}/apps_res/cip/common/img/down.png" style="position: absolute;left: -6px;bottom: 0;z-index: 10;">
						</div>
						<div style="position: relative;width: 160px;height: 1px;border-top: 1px solid #000;margin: -115px 0 0 10px;"></div>
					</div>
				</div>
			</div>
			<div style="position: relative;width: 1px;height: 30px;border-left: 1px solid #000;margin: 18px 550px;" >
				<img src="${path}/apps_res/cip/common/img/up.png" style="position: absolute;left: -6px;top: 0;z-index: 10;">
			</div>
			<div style="width: 100%;margin-top:-15px;">
				<div style="width: 710px;margin: 0 auto;">
					<div class="cip-block">
						<div class="content backColor2" onclick="$('#tab2iframe').trigger('click');">
							<div class="img-block">
								<div class="img backColor2">
									<i class="icon01" style="background-position:-84px -0px;"></i>
								</div>
							</div>
							<div class="name">
								<span>${ctp:i18n('cip.dee.tab.time')}</span>
							</div>
						</div>
						<div class="operation backColor2"  onclick="javascript:openD(1501);">
							<div class="operation-block">
								<div class="button">
									<span>${ctp:i18n('cip.intenet.set.case')}</span>
								</div>
							</div>
						</div>
					</div>
					<div class="cip-block" style="margin-left: 80px;">
						<div class="content backColor1" onclick="$('#tab5iframe').trigger('click');">
							<div class="img-block">
								<div class="img backColor1">
									<i class="icon01" style="background-position:-28px -28px;"></i>
								</div>
							</div>
							<div class="name">
								<span>${ctp:i18n('cip.dee.tab.tks')}</span>
							</div>
						</div>
						<div class="operation backColor1" onclick="javascript:openD(1503);">
							<div class="operation-block">
								<div class="button">
									<span>${ctp:i18n('cip.intenet.set.case')}</span>
								</div>
							</div>
						</div>
					</div>
					<div class="cip-block" style="margin-left: 80px;">
						<div class="content backColor4" onclick="$('#tab3iframe').trigger('click');">
							<div class="img-block">
								<div class="img backColor4">
									<i class="icon01" style="background-position:-56px -28px;"></i>
								</div>
							</div>
							<div class="name">
								<span>${ctp:i18n('cip.dee.tab.quatz')}</span>
							</div>
						</div>
						<div class="operation backColor4" onclick="javascript:openD(1504);">
							<div class="operation-block">
								<div class="button">
									<span>${ctp:i18n('cip.intenet.set.case')}</span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div style="width: 100%;">
				<div style="width: 710px;margin: 0 auto;position: relative;">
					<div style="position: relative;width: 1px;height: 30px;border-left: 1px solid #000;margin: 18px 340px;;">
						<img src="${path}/apps_res/cip/common/img/up.png" style="position: absolute;left: -6px;top: 0;z-index: 10;">
					</div>
					<div style="position: absolute;width: 515px;height: 1px;border-top: 1px solid #000;top: 20px;left: 90px;z-index: 10;">
						<div style="position: absolute;width: 1px;height: 20px;border-left: 1px solid #000;left: 0;top: -20px;z-index: 10;">
							<img src="${path}/apps_res/cip/common/img/up.png" style="position: absolute;left: -6px;top: 0;z-index: 10;">
						</div>
						<div style="position: absolute;width: 1px;height: 20px;border-left: 1px solid #000;right: 0;top: -20px;z-index: 10;">
							<img src="${path}/apps_res/cip/common/img/up.png" style="position: absolute;left: -6px;top: 0;z-index: 10;">
						</div>
					</div>
				</div>
			</div>
			<div style="width: 100%;margin-top:-10px;" >
				<div style="width: 200px;margin: 0 auto;">
					<div class="cip-block">
						<div class="content backColor3" onclick="$('#tab1iframe').trigger('click');">
							<div class="img-block">
								<div class="img backColor3">
									<i class="icon01"  style="background-position:0 0;"></i>
								</div>
							</div>
							<div class="name">
								<span>${ctp:i18n('cip.dee.tab.res')}</span>
							</div>
						</div>
						<div class="operation backColor3" onclick="javascript:openD(1505);">
							<div class="operation-block">
								<div class="button">
									<span>${ctp:i18n('cip.intenet.set.case')}</span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
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