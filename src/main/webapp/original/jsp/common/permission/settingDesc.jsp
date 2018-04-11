<%--
 $Author: wuym $
 $Rev: 1697 $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <!-- 节点权限操作说明 -->
    <title>${ctp:i18n('permission.node.description.lable')}</title>
</head>
<body class="color_gray2 margin_l_20">
    <div class="clearfix">
        <h2 class="left">${ctp:i18n('permission.setting')}</h2><!-- 节点权限设置 -->
        <div class="font_size12 left margin_t_20 margin_l_10">
            <div class="margin_t_10 font_size14">${ctp:i18n('collaboration.stat.all')}<%--总计 --%> 
                 <span class="font_bold color_black">${size}</span> ${ctp:i18n('collaboration.stat.records')}<%--条 --%>
            </div>
        </div>
    </div>
    <div class="line_height160 font_size14">
        <!-- 单击“新建”菜单，新建节点权限。新建节点权限时，设置节点权限对应的动作。 -->
        <p><span class="font_size12">●</span> ${ctp:i18n('template.common.settingDesc.label1')}</p>
        <!-- 勾选一条节点权限记录后单击“修改”菜单或双击列表中的节点权限记录，修改节点权限信息。 -->
        <p><span class="font_size12">●</span> ${ctp:i18n('template.common.settingDesc.label2')}</p>
        <!-- 勾选列表中的节点权限记录，单击“删除”菜单，删除选中的节点权限。 -->
        <p><span class="font_size12">●</span> ${ctp:i18n('template.common.settingDesc.label3')}</p>
        <!-- 不允许删除系统节点权限。 -->
        <p><span class="font_size12">●</span> ${ctp:i18n('template.common.settingDesc.label4')}</p>
    </div>
</body>
</html>