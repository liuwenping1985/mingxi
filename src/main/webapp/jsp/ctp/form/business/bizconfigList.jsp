<%--
 $Author: wusb $
 $Rev: 509 $
 $Date:: 2012-07-21 00:08:40#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title></title>
</head>
<body>
<div id='layout' class="comp page_color" comp="type:'layout'">
        <div class="comp" comp="type:'breadcrumb',code:'${param._resourceCode }'"></div>
    <div class="layout_north" id="north" layout="height:40,sprit:false,border:false">
        <div id="toolbar"></div>
    </div>
    <div class="layout_center" id="center" style="overflow:hidden;">
        <table class="flexme3" style="display: none" id="mytable"></table>
        <div id="grid_detail">
            <iframe id="viewFrame" class="calendar_show_iframe" src="${path }/form/business.do?method=desc" frameborder="0" style="width: 100%;height:100%"></iframe>
            <input id="myfile" type="hidden" class="comp hidden" comp="type:'fileupload',applicationCategory:'1',extensions:'biz',quantity:1,firstSave:true,attachmentTrId:'biz',callMethod:'importBiz'">
        </div>
    </div>
    </div>
    <iframe id="exportBiz" style="display: none"></iframe>
 <script type="text/javascript" src="${path}/ajax.do?managerName=businessManager,bizDataManager"></script>
 <%@ include file="bizconfigList.js.jsp" %>
<script type="text/javascript" src="${path}/common/content/formCommon.js${ctp:resSuffix()}"></script>
</body>
</html>