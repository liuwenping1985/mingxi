<%--
 $Author:  xiangq$
 $Rev:  280$
 $Date:: 2013-3-25 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>任务说明</title>
<script type="text/javascript">
    $(document).ready(function() {
    }); 
</script>
</head>
<body>
    <div class="color_gray margin_l_20">
        <div class="clearfix">
            <c:choose>
                <c:when test="${param.from == 'Manage'}">                   
                    <h2 class="left">${ctp:i18n('menu.taskmanage.managetasks')}</h2>
                </c:when> 
                <c:otherwise>
                    <h2 class="left">${ctp:i18n('menu.taskmanage.mytasks')}</h2>
                </c:otherwise>
            </c:choose>       
            <div class="font_size12 left margin_t_20 margin_l_10">
                <div class="margin_t_10 font_size14">${ctp:i18n("taskmanage.total.label")} <span class="font_bold color_black" id="total">${param.total}</span> ${ctp:i18n("taskmanage.item")}</div>
            </div>
        </div>
        <div class="line_height160 font_size14">
            <c:choose>
                <c:when test="${param.from == 'Manage'}">
                    <p><span class="font_size12">●</span> ${ctp:i18n('taskmanage.manage_description_1')}</p>
                    <p><span class="font_size12">●</span> ${ctp:i18n('taskmanage.manage_description_2')}</p>
                    <p><span class="font_size12">●</span> ${ctp:i18n('taskmanage.manage_description_3')}</p>                   
                </c:when> 
                <c:otherwise>
                    <p><span class="font_size12">●</span> ${ctp:i18n('taskmanage.task_description_1')}</p>
                    <p><span class="font_size12">●</span> ${ctp:i18n('taskmanage.task_description_2')}</p>
                    <p><span class="font_size12">●</span> ${ctp:i18n('taskmanage.task_description_3')}</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
