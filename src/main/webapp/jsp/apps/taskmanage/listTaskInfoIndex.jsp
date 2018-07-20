<%--
 $Author: wuym $
 $Rev: 1783 $
 $Date:: 2012-10-30 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>layout</title>
<script type="text/javascript">
    var from = '${param.from}';
    var listType = '${param.listType}';

    function contentIframeSrc(url) {
        var contentIframe = $("#content_iframe");
        contentIframe.attr("src", url);
    }
    function changeMenuTab(event) {
        var obj = $(event).attr("url");
        $("#tab_list").find("li.current").removeClass("current");
        $(event).parent().addClass("current");
        contentIframeSrc(obj);
    }
    function initSelectedTab() {
        var url;
        if (from != "Manage") {
            url = _ctxPath + "/taskmanage/taskinfo.do?method=list" + from
                    + "Tasks&from=" + from + "&listType=" + listType;
        }
        contentIframeSrc(url);
    }
    $(document).ready(function() {
        initSelectedTab();
    });
</script>
</head>
<body>
    <div>
        <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F02_taskPage'"></div>
    </div>
    <div id='layout' class="comp page_color" comp="type:'layout'">
        <div class="layout_north" layout="height:32,sprit:false,border:false" id="north">
            <div id="tabs" class="margin_l">
                <div id="tabs_head" class="common_tabs clearfix margin_t_5">
                    <ul class="left" id="tab_list">
                        <li class="current"><a hideFocus="true" class="no_b_border" href="javascript:void(0)" onclick="changeMenuTab(this)"
                            index="1" url="${path}/taskmanage/taskinfo.do?method=list${param.from}Tasks&from=${param.from}"><span>${ctp:i18n('menu.taskmanage.mytasks')}</span></a></li>
                        <li><a hideFocus="true" class="last_tab no_b_border" href="javascript:void(0)" onclick="changeMenuTab(this)"
                            index="2" url="${path}/taskmanage/taskinfo.do?method=taskManageFrame&from=manage"><span>${ctp:i18n('menu.taskmanage.managetasks')}</span></a></li>
<!-- 任务统计现阶段屏蔽，等SP1再完善 -->
<!--                         <li><a hideFocus="true" class="last_tab no_b_border" href="javascript:void(0)" onclick="changeMenuTab(this)" -->
<%--                             index="3" url="${path}/taskmanage/taskstatistics.do?method=taskStatisticsIndex"><span>${ctp:i18n('common.toolbar.statistics.label')}</span></a></li> --%>
                    </ul>
                </div>
            </div>
            <div class="hr_heng"></div>
        </div>
        <div id="center" class="layout_center page_color over_hidden" layout="border:false" style="overflow:hidden;">
            <iframe id="content_iframe" name="content_iframe" width="100%" height="100%" src="" frameborder="no"
                border="0"></iframe>
        </div>
    </div>
</body>
</html>
