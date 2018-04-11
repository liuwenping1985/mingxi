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
			divHide();
			$("#tab1_iframe").attr("src","${path}/orgSyncController.do?method=SyncSetup&time="+Math.random());
		});
		$("#tab2iframe").click(function(){
			divHide();
			$("#tab2_iframe").attr("src","${path}/orgSyncController.do?method=SyncOpt&time="+Math.random());
		});
		$("#tab3iframe").click(function(){
			divHide();
			$("#tab3_iframe").attr("src","${path}/orgSyncController.do?method=syncLog&time="+Math.random());
		});
		
		function divHide(){//隐藏背景导图
			$("#bgimg").hide();
		}
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
					tgt="tab1_iframe" id="tab1iframe"><span title="${ctp:i18n('cip.xc.syn.ope')}">${ctp:i18n('cip.xc.syn.ope')}</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab2_iframe" id="tab2iframe" ><span title="${ctp:i18n('cip.sync.param.config.operation')}">${ctp:i18n('cip.sync.param.config.operation')}</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab3_iframe" id="tab3iframe"><span title="${ctp:i18n('cip.sync.log.title')}">${ctp:i18n('cip.sync.log.title')}</span></a></li>
			</ul>
		</div>
		<div id="bgimg" style="margin:20px 0 0 100px;">
			<div>
				<div class="cip-block">
					<div class="content backColor1"  onclick="$('#tab1iframe').trigger('click');">
						<div class="img-block">
							<div class="img backColor1">
								<i class="icon12" style="background-position:-56px -168px;"></i>
							</div>
						</div>
						<div class="name">
							<span>${ctp:i18n('cip.xc.syn.ope')}</span>
						</div>
					</div>
					<div class="operation backColor1" onclick="javascript:openD(401);" >
						<div class="operation-block">
							<div class="button">
								<span>${ctp:i18n('cip.intenet.set.case')}</span>
							</div>
						</div>
					</div>
				</div>
				<div class="cip-block" style="margin-top: 20px;margin-left:50px;">
					<div class="content backColor1"  onclick="$('#tab2iframe').trigger('click');">
						<div class="img-block">
							<div class="img backColor1">
								<i class="icon12" style="background-position:-56px -56px;"></i>
							</div>
						</div>
						<div class="name">
							<span>${ctp:i18n('cip.sync.param.config.operation')}</span>
						</div>
					</div>
					<div class="operation backColor1" onclick="javascript:openD(402);">
						<div class="operation-block">
							<div class="button">
								<span>${ctp:i18n('cip.intenet.set.case')}</span>
							</div>
						</div>
					</div>
				</div>
				<div class="cip-block" style="margin-top: 20px;margin-left:50px;">
					<div class="content backColor1" onclick="$('#tab3iframe').trigger('click');">
						<div class="img-block">
							<div class="img backColor1">
								<i class="icon11" style="background-position:-28px -168px;"></i>
							</div>
						</div>
						<div class="name">
							<span>${ctp:i18n('cip.sync.log.title')}</span>
						</div>
					</div>
					<div class="operation backColor1" onclick="javascript:openD(403);">
						<div class="operation-block">
							<div class="button">
								<span>${ctp:i18n('cip.intenet.set.case')}</span>
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
		</div>
    </div>
	</div>
</body>
</html>