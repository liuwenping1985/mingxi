<%--
 $Author: lilong $
 $Rev: 32817 $
 $Date:: 2014-01-20 16:45:37#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/WEB-INF/jsp/apps/privilege/menu/menuList_js.jsp"%>
<html>
<head>
<title></title>
</head>
<body class="body-pading" leftmargin="0" topmargin="" marginwidth="0" marginheight="0">
  <div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'T02_menu'"></div>
    <div class="layout_north" id="north" layout="height:30,sprit:false,border:false">
      <div id="toolbar"></div>
    </div>
    <div class="layout_west" layout="width:300,minWidth:50,maxWidth:300" style="overflow: hidden;">
      <div class="bg_color_gray font_size12 border_b" sytle="height:26px;">
        <!-- 资源所属版本 -->
        &nbsp;&nbsp;${ctp:i18n('version.choose')}
        <select id="productVersion" name="productVersion">
          <option value="">${ctp:i18n('privilege.menu.systemDefault.label')}</option>
        </select>
        <!-- 应用资源类型 -->
        <select id="appResCategory" name="appResCategory" class="codecfg"
          codecfg="codeType:'java',codeId:'com.seeyon.ctp.privilege.enums.AppResourceCategoryEnums',defaultValue:1">
        </select>
      </div>
      <!-- 菜单资源树 -->
      <iframe id="selectResouce" frameborder="0" width="100%" height="97%"></iframe>
    </div>
    <div id="center" class="layout_center" style="overflow: hidden;">
      <table id="mytable1" class="mytable" style="display: none"></table>
    </div>
  </div>
  <input type="hidden" id="parnetMenuId"/>
</body>
</html>
