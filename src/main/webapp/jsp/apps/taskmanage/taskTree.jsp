<%--
 $Author:  xiangq$
 $Rev:  280$
 $Date:: 2012-12-15 13:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>${ctp:i18n("taskmanage.tree")}</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskAjaxManager"></script>
<%@ include file="commonTaskEvent.js.jsp" %>
<%@ include file="taskTreeEvent.js.jsp" %>
<%@ include file="taskTree.js.jsp" %>
<script type="text/javascript">
    $(document).ready(function() {
        initToolBar();
        initListData();
        var _bDiv_h_base=$(window).height()-$(".flexigrid .bDiv").height();
        $(window).resize(function(){
            $(".flexigrid .bDiv").height($(window).height()-_bDiv_h_base)
        });
        var viewType = "${param.viewType}";
        $("body").bind("click", window.parent.validateTask);
    }); 
</script>
</head>
<body>
    <div id='layout' class="comp page_color" comp="type:'layout'">
        <div id="north" class="layout_north" layout="height:30,sprit:false,border:false">
            <div id="toolbar"></div>
        </div>
        <div id="center" class="layout_center page_color over_hidden" layout="border:false">
            <table id="taskInfoList" class="flexme3" style="display: none"></table>
        </div>
    </div>
</body>
</html>