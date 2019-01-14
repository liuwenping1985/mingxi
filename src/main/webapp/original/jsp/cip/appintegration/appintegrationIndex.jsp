<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html class="h100b">
<head>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

</head>
<body class="h100b">
  <div id='layout' class="comp" comp="type:'layout'">
  <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'cip_app'"></div>
  <div class="spc_wrap">
    <div id="tabs" class="comp" comp="type:'tab'">
      <div id="tabs_head" class="common_tabs clearfix">
        <ul class="left">
          <li class="current">
             <a  hidefocus="true" href="javascript:void(0)" tgt="user_iframe">
              <span>${ctp:i18n('cip.manager.user')}</span>
            </a>
          </li>
             <li>
            <a  href="javascript:void(0)" tgt="message_iframe">
              <span>${ctp:i18n('cip.manager.message')}</span>
            </a>
          </li>
            <li>
            <a  href="javascript:void(0)" tgt="pending_iframe">
              <span>${ctp:i18n('cip.manager.pending')}</span>
            </a>
          </li>
            <li>
            <a  href="javascript:void(0)" tgt="portal_iframe">
              <span>${ctp:i18n('cip.manager.portal')}</span>
            </a>
          </li>
        </ul>
      </div>
 
      <div id="tabs_body" class="common_tabs_body">
      <!--<iframe id="register_iframe" width="100%" src="${path}/cip/registerController.do" frameborder="no" border="0"></iframe>-->
        <iframe id="user_iframe" width="100%" src="${path}/cip/userBindingController.do" frameborder="no" border="0"></iframe>
        <iframe id="message_iframe" width="100%" src="${path}/cip/messageConfigController.do?type=0" frameborder="no" border="0"></iframe>
        <iframe id="pending_iframe" width="100%" src="${path}/cip/pendingConfigController.do?type=1" frameborder="no" border="0"></iframe>
        <iframe id="portal_iframe" width="100%" src="${path}/cip/portalConfigController.do" frameborder="no" border="0"></iframe>
      </div>
    </div>
  </div>
  </div>
</body>
</html>