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
<body class="h100b">
  <!-- 面包屑 -->

  <div id='layout' class="comp" comp="type:'layout'">
  <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F21_cip_baseconfig'"></div>
  <div class="spc_wrap">
    <!-- 页签 -->
    <div id="tabs" class="comp" comp="type:'tab'">
      <div id="tabs_head" class="common_tabs clearfix">
        <ul class="left">
          <li class="current">
            <a hidefocus="true" href="javascript:void(0)" tgt="product_iframe">
              <span>${ctp:i18n('cip.base.manager.register')}</span>
            </a>
          </li>
          <li>
            <a  href="javascript:void(0)" tgt="instance_iframe">
              <span>${ctp:i18n('cip.service.register')}</span>
            </a>
          </li>
             <li>
            <a  href="javascript:void(0)" tgt="logMonitor_iframe">
              <span>${ctp:i18n('cip.base.log.manager')}</span>
            </a>
          </li>
        </ul>
      </div>
 
      <div id="tabs_body" class="common_tabs_body">
        <iframe id="product_iframe" width="100%" src="${path}/cip/base/product.do" frameborder="no" border="0"></iframe>
        <iframe id="instance_iframe" width="100%" src="${path}/cip/base/instance.do?method=showRegisterInstance" frameborder="no" border="0"></iframe>
        <iframe id="logMonitor_iframe" width="100%" src="${path}/cip/base/logMonitorController.do?method=showLogMonitorView" frameborder="no" border="0"></iframe>
      </div>
    </div>
  </div>
  </div>
</body>
</html>