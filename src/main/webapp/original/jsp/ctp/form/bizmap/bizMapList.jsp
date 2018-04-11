<%--
 $Author: zhaifeng $
 $Rev: 509 $
 $Date:: 2015-01-07 #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>${ctp:i18n('form.bizmap.create.label')}</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=bizMapManager"></script>
<script type="text/javascript"
  src="${path}/common/form/bizmap/bizmap.js${ctp:resSuffix()}"></script>
</head>
<script type="text/javascript">
    $(document).ready(function() {
        //初始化工具栏
        initToolbar();
        //初始化查询条件
        initSearch();
        //构建初始化列表
        initGridTable();
    });
</script>
<body>
  <div id='layout' class="comp page_color" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'T05_bizMap'"></div>
    <div class="layout_north" id="north"
      layout="height:40,sprit:false,border:false">
      <div id="toolbar"></div>
    </div>
    <div class="layout_center" id="center" style="overflow: hidden;">
      <table class="flexme3" style="display: none" id="mytable"></table>
      <div id="grid_detail">
        <iframe id="viewFrame" class="calendar_show_iframe" src=""
          frameborder="0" style="width: 100%; height: 100%"></iframe>
      </div>
    </div>
  </div>
</body>
</html>