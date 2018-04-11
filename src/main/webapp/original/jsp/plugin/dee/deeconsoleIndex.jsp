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
</head>
<script type="text/javascript">
	$().ready(function(){
		$("#a_deploy").click(function(){
			$("#deploy_iframe").attr("src",src="${path}/deeDeployDRPController.do?method=show&time="+Math.random());
		});
		$("#a_dataSource").click(function(){
			$("#dataSource_iframe").attr("src","${path}/deeDataSourceController.do?method=showDataSourceList&time="+Math.random());
		});
		$("#a_schedule").click(function(){
			$("#schedule_iframe").attr("src","${path}/deeScheduleController.do?method=scheduleFrame&time="+Math.random());
		});
		$("#a_delete").click(function(){
			$("#delete_iframe").attr("src","${path}/deeDeleteController.do?method=getFlowFrame&time="+Math.random());
		});
		$("#a_redo").click(function(){
			$("#redo_iframe").attr("src","${path}/deeSynchronLogController.do?method=synchronLogFrame&time="+Math.random());
		});
		$("#a_deploy").trigger("click");
	});
</script>
<body class="h100b">
  <!-- 面包屑 -->

  <div id='layout' class="comp" comp="type:'layout'">
  <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F21_cip_thirdinterface'"></div>
  <div class="spc_wrap">
    <!-- 页签 -->
    <div id="tabs" class="comp" comp="type:'tab'">
      <div id="tabs_head" class="common_tabs clearfix">
        <ul class="left">
          <li class="current">
            <a hidefocus="true" href="javascript:void(0)" tgt="deploy_iframe" id="a_deploy">
              <span>${ctp:i18n('system.menuname.hotdeploy')}</span>
            </a>
          </li>
          <li>
            <a href="javascript:void(0)" tgt="dataSource_iframe" id="a_dataSource">
              <span>${ctp:i18n('system.menuname.dataSource')}</span>
            </a>
          </li>
          <li>
            <a href="javascript:void(0)" tgt="schedule_iframe" id="a_schedule">
              <span>${ctp:i18n('system.menuname.schedule')}</span>
            </a>
          </li>
          <li>
            <a href="javascript:void(0)" tgt="delete_iframe" id="a_delete">
              <span>${ctp:i18n('system.menuname.delete')}</span>
            </a>
          </li>
          <li>
            <a href="javascript:void(0)" tgt="redo_iframe" id="a_redo">
              <span>${ctp:i18n('system.menuname.redo')}</span>
            </a>
          </li>
        </ul>
      </div>
 
      <div id="tabs_body" class="common_tabs_body">
        <iframe id="deploy_iframe" width="100%" frameborder="no" border="0"></iframe>
      	<iframe id="dataSource_iframe" width="100%" frameborder="no" border="0"></iframe>
      	<iframe id="schedule_iframe" width="100%" frameborder="no" border="0"></iframe>
      	<iframe id="delete_iframe" width="100%" frameborder="no" border="0"></iframe>
      	<iframe id="redo_iframe" width="100%" frameborder="no" border="0"></iframe>
      </div>
    </div>
  </div>
  </div>
</body>
</html>