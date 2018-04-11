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
		$("ul li").removeClass("current");
		$("#tab1iframe").click(function(){
			$("#bgimg").hide();
			$("iframe").hide();
			$("ul li").removeClass("current");
			$("ul li:eq(0)").addClass("current");
			$("#tab1_iframe").show();
			$("#tab1_iframe").attr("src","${path}/cip/base/product.do");
		});
		$("#tab2iframe").click(function(){
			$("#bgimg").hide();
			$("iframe").hide();
			$("ul li").removeClass("current");
			$("ul li:eq(1)").addClass("current");
			$("#tab2_iframe").show();
			$("#tab2_iframe").attr("src","${path}/cip/base/instance.do?method=showRegisterInstance&time="+Math.random());
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
        <div id="tabs" style="height: 100%"  class="comp common_tabs"
		comp="type:'tab',parentId:'tabs'">
		<div id="tabs_head" class="common_tabs clearfix">
			<ul class="left">
				<li class="current"><a hidefocus="true" href="javascript:void(0)" 
					tgt="tab1_iframe" id="tab1iframe"><span title="${ctp:i18n('cip.xc.menu.100101')}">${ctp:i18n('cip.plugin.menu.productregister')}</span></a></li>
				<li><a hidefocus="true" href="javascript:void(0)"
					tgt="tab2_iframe" id="tab2iframe" ><span title="${ctp:i18n('cip.xc.persion.syn')}">${ctp:i18n('cip.base.system.register')}</span></a></li>
				
			</ul>
		</div>
		<div id="bgimg" style="margin-top:30px;margin-left:80px; height:170px;">
			 <div class="cip-block" style = "float: left;">
		         <div class="content backColor2" onclick="$('#tab1iframe').trigger('click');">
					<div class="img-block">
						<div class="img backColor2">
							<i class="icon11" style="background-position:-84px -28px;"></i>
						</div>
					</div>
					<div class="name">
						<span>${ctp:i18n('cip.plugin.menu.productregister')}</span>
					</div>
				</div>
				<div class="operation backColor2"  onclick="javascript:openD(1201);">
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
				<div class="content backColor3"  onclick="$('#tab2iframe').trigger('click');">
					<div class="img-block">
						<div class="img backColor3">
							<i class="icon11" style="background-position:-0px -56px;"></i>
						</div>
					</div>
					<div class="name">
						<span>${ctp:i18n('cip.base.system.register')}</span>
					</div>
				</div>
				<div class="operation backColor3" onclick="javascript:openD(1202);">
					<div class="operation-block">
						<div class="button">
							<span>${ctp:i18n('cip.intenet.set.case')}</span>
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
		</div>
      </div>
	</div>
</body>
</html>