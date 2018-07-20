<%--
 $Author: xiangq $
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
<title></title>
<script type="text/javascript">
    function changeMenuTab(event) {
//         var obj = $(event).attr("url");
//         var contentIframe = $("#content_iframe");
//         contentIframe.attr("src",obj);
    }
</script>
</head>
<body>
    <div id='layout' class="comp page_color" comp="type:'layout'">
        <div class="layout_north" layout="height:30,sprit:false,border:false" id="north">
            <div id="tabs" class="comp" comp="type:'tab'">
                <div id="tabs_head" class="common_tabs clearfix">
                    <ul class="left">
                        <li class="current"><a href="javascript:void(0)" onclick="changeMenuTab(this)" tgt="content_iframe" url="${path}/taskmanage/taskinfo.do?method=listPersonalTasks&form=${param.form}"><span>${ctp:i18n('taskmanage.detail')}</span></a></li>
                        <li><a href="javascript:void(0)" onclick="changeMenuTab(this)" tgt="content_iframe" url=""><span>${ctp:i18n('taskmanage.feedback')}</span></a></li>
                    </ul>
                </div>
            </div>
            <div class="hr_heng"></div>
        </div>
        <div id="center" class="layout_center page_color over_hidden" layout="border:false">
            <iframe id="content_iframe" width="100%" height="100%" src="" frameborder="no" border="0"></iframe>
        </div>
    </div>
</body>
</html>
