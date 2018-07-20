<%--
 $Author: xiangq $
 $Rev: 1784 $
 $Date:: 2013-1-9 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>${ctp:i18n('common.toolbar.statistics.label')}</title>
<style>
.stadic_head_height {
    height: 21px;
}

.stadic_body_top_bottom {
    bottom: 0px;
    top: 21px;
}
</style>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskAjaxManager"></script>
<%@ include file="taskStatisticsIndex.js.jsp" %>
<script>
    $(document).ready(function() {
        new MxtLayout({
            'id' : 'layout',
            'westArea' : {
                'id' : 'west',
                'width' : 220,
                'sprit' : true,
                'minWidth' : 0,
                'maxWidth' : 500,
                'border' : false
            },
            'centerArea' : {
                'id' : 'center',
                'border' : true,
                'minHeight' : 20,
                'border' : false
            }
        });
        initStatisticsTree();
        initTreeSelected();
    });
</script>
</head>
<body class="h100b overflow_hidden page_color" id='layout'>
    <div >
        <div class="layout_west line_col" id="west">
            <div class="tree_area border_all margin_5 over_auto padding_t_10">
                 <ul id="statistics_tree" class="treeDemo_0 ztree"> </ul>
            </div>
        </div>
        <!--查询设置&结果-->
        <div class="layout_center" id="center" style="overflow:hidden;">
            <iframe id="statistics_view_iframe" frameborder="0" width="100%" height="100%" src=""> </iframe>
        </div>  
    </div>
</body>
</html>
