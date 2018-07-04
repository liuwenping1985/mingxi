<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ page language="java" import=" com.seeyon.apps.m3.app.enums.M3StartPageCustomEnum"%>
<%@ page language="java" import="com.seeyon.ctp.common.authenticate.domain.User"%>
<%@ page language="java" import="com.seeyon.ctp.common.constants.ProductEditionEnum"%>
<!DOCTYPE html>
<html class="h100b">
<head>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
</head>
<body class="h100b">
  <!-- 面包屑 -->
       <% 
       String methordRole = "customAccountSet";
       String bread = "m3_startpage";
       User user = (User)request.getAttribute("CurrentUser");
       if(user.isSystemAdmin()||ProductEditionEnum.getCurrentProductEditionEnum()==ProductEditionEnum.a6){
    	  methordRole = "customSystemSet";
    	  bread ="m3_sys_startpage";
      }
      %>
  <div id='layout' class="comp" comp="type:'layout'">
  <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'<%=bread%>'"></div>
  <div class="spc_wrap">
    <!-- 页签 -->
    <div id="tabs" class="comp" comp="type:'tab'">
      <div id="tabs_head" class="common_tabs clearfix">
        <ul class="left">
          <li class="current">
            <a hidefocus="true" href="javascript:void(0)" tgt="iphone_iframe">
              <span><%=M3StartPageCustomEnum.PhoneEnum.iPhone.name() %></span>
            </a>
          </li>
          <li>
            <a hidefocus="true" href="javascript:void(0)" tgt="android_iframe">
              <span><%=M3StartPageCustomEnum.PhoneEnum.Android.name() %></span>
            </a>
          </li>
        </ul>
      </div>
 
      <div id="tabs_body" class="common_tabs_body">
        <iframe id="iphone_iframe" width="100%" src="${path}/m3/appStartMgrController.do?method=<%=methordRole%>&phoneType=<%=M3StartPageCustomEnum.PhoneEnum.iPhone.name() %>" frameborder="no" border="0"></iframe>
        <iframe id="android_iframe" width="100%" src="${path}/m3/appStartMgrController.do?method=<%=methordRole%>&phoneType=<%=M3StartPageCustomEnum.PhoneEnum.Android.name() %>" frameborder="no" border="0" class="hidden"></iframe>
      </div>
    </div>
  </div>
  </div>
</body>
</html>