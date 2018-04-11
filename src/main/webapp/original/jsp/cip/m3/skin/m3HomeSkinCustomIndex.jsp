<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ page language="java" import="com.seeyon.apps.m3.skin.enums.M3HomeSkinEnum"%>
<%@ page language="java" import="com.seeyon.ctp.common.authenticate.domain.User"%>
<!DOCTYPE html>
<html class="h100b">
<head>
  <title>移动M3登录页主题设置</title>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
</head>
<body class="h100b">
  <!-- 面包屑 -->
    <% 
      String methordRole = "accountAdminSettings";
      String bread = "m3_homeSkinConfig";
      User user = (User)request.getAttribute("CurrentUser");
      if(user.isSystemAdmin()){
    	  methordRole = "systemAdminSettings";
    	  bread = "m3_sys_homeSkinConfig";
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
              <span><%=M3HomeSkinEnum.PhoneEnum.iphone.name() %></span>
            </a>
          </li>
          <li>
            <a hidefocus="true" href="javascript:void(0)" tgt="android_iframe">
              <span><%=M3HomeSkinEnum.PhoneEnum.android.name() %></span>
            </a>
          </li>
        </ul>
      </div>
    
      <div id="tabs_body" class="common_tabs_body">
        <iframe id="iphone_iframe" width="100%" src="${path}/m3/homeSkinController.do?method=<%=methordRole%>&phoneType=<%=M3HomeSkinEnum.PhoneEnum.iphone.name() %>" frameborder="no" border="0"></iframe>
        <iframe id="android_iframe" width="100%" src="${path}/m3/homeSkinController.do?method=<%=methordRole%>&phoneType=<%=M3HomeSkinEnum.PhoneEnum.android.name() %>" frameborder="no" border="0" class="hidden"></iframe>
      </div>
    </div>
  </div>
  </div>
</body>
</html>