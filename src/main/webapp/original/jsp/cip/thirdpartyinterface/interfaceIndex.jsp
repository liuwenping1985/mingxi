<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html class="h100b">
<head>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<style type="text/css">
<!--
.common_tabs a {
	font-size: 12px;
	color: #8A8A8A;
	width: auto;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	max-width: 100px;
	display: inline-block;
	background-position: left top;
	min-width: 50px;
	float: left;
	line-height: 27px;
	height: 27px;
	_height: 26px;
	font-family: 'Microsoft YaHei';
	padding: 0 8px;
	text-align: center;
}
-->
</style>
<link rel="stylesheet" href="${path}/apps_res/cip/common/css/common.css"/>
</head>
<script type="text/javascript">
	$().ready(function(){
		$("ul li:first-child").removeClass("current");
		$("#a_interface").click(function(){
			$("#bgimg").hide();
			$("#interface_iframe").attr("src",src="${path}/cip/thirdpartyinterface/interface.do?method=index&time="+Math.random());
		});
		$("#a_agent").click(function(){
			$("#bgimg").hide();
			$("#agent_iframe").attr("src","${path}/cip/thirdpartyinterface/agent.do?method=index&time="+Math.random());
		});
		$("#a_resource").click(function(){
			$("#bgimg").hide();
			$("#resource_iframe").attr("src","${path}/cip/thirdpartyinterface/resource.do?method=index&time="+Math.random());
		});
		//$("#a_interface").trigger("click");
	});
	function openD(enumKey){
		var dialog = getCtpTop().$.dialog({
            url:"${path}/cip/appIntegrationController.do?method=showExample&enumKey="+enumKey,
            width: 900,
            height: 500,
            title: "示例查看",//示例查看
            buttons: [{
                text: "${ctp:i18n('common.button.cancel.label')}", //取消
                handler: function () {
                    dialog.close();
                }
            }]
    	});
	} 
</script>
<body class="h100b">
  <!-- 面包屑 -->

  <div id='layout' class="comp" comp="type:'layout'">
  <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F21_cip_thirdinterface'"></div>
  <div class="spc_wrap">
    <!-- 页签 -->
    <div id="tabs" class="comp common_tabs" comp="type:'tab'">
      <div id="tabs_head" class="common_tabs clearfix">
        <ul class="left">
          <li class="current">
            <a hidefocus="true" href="javascript:void(0)" tgt="interface_iframe" id="a_interface">
              <span>${ctp:i18n('cip.base.interface.lab.title')}</span>
            </a>
          </li>
          <li>
            <a href="javascript:void(0)" tgt="agent_iframe" id="a_agent">
              <span>${ctp:i18n('cip.localAgent.lab.title')}</span>
            </a>
          </li>
          <li>
            <a href="javascript:void(0)" tgt="resource_iframe" id="a_resource">
              <span>${ctp:i18n('cip.extendedresource.lab.title')}</span>
            </a>
          </li>
        </ul>
      </div>
 		
 		<div id="bgimg" style="margin-top:30px;margin-left:80px; height:170px;">
			 <div class="cip-block" style = "float: left;">
		         <div class="content backColor2" onclick="$('#a_resource').trigger('click');">
					<div class="img-block">
						<div class="img backColor2">
							<i class="icon11" style="background-position:-0px -0px;"></i>
						</div>
					</div>
					<div class="name">
						<span>扩展资源包</span>
					</div>
				</div>
				<div class="operation backColor2"  onclick="javascript:openD(1403);">
					<div class="operation-block">
						<div class="button">
							<span>查看制作案例</span>
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
				<div class="content backColor3"  onclick="$('#a_interface').trigger('click');">
					<div class="img-block">
						<div class="img backColor3">
							<i class="icon01"></i>
						</div>
					</div>
					<div class="name">
						<span>接口注册</span>
					</div>
				</div>
				<div class="operation backColor3" onclick="javascript:openD(1401);">
					<div class="operation-block">
						<div class="button">
							<span>查看制作案例</span>
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
				<div class="content backColor1"  onclick="$('#a_agent').trigger('click');">
					<div class="img-block">
						<div class="img backColor1">
							<i class="icon01" style="background-position:-0px -56px;"></i>
						</div>
					</div>
					<div class="name">
						<span>本地代理</span>
					</div>
				</div>
				<div class="operation backColor1"  onclick="javascript:openD(1402);">
					<div class="operation-block">
						<div class="button">
							<span>查看制作案例</span>
						</div>
					</div>
				</div>
			</div>
		</div>
 		
      <div id="tabs_body" class="common_tabs_body">
        <iframe id="interface_iframe" width="100%" frameborder="no" border="0"></iframe>
      	<iframe id="agent_iframe" width="100%" frameborder="no" border="0"></iframe>
      	<iframe id="resource_iframe" width="100%" frameborder="no" border="0"></iframe>
      </div>
    </div>
  </div>
  </div>
</body>
</html>