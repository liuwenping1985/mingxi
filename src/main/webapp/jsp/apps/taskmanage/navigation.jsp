<%--
 $Author:  xiangq$
 $Rev:  280$
 $Date:: 2012-12-26 14:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<html class="h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>任务导航</title>
<style>
.stadic_head_height {
    height: 30px;
}

.stadic_body_top_bottom {
    bottom: 0px;
    top: 30px;
}
</style>
<%@ include file="navigation.js.jsp" %>
<script type="text/javascript">
    $(document).ready(function() {
        var type = '${param.type}';
        initUI();
        initBtnEvent();
        if(type != "Project") {   
            changeMemberListData(userId);
        } else {
            initPorjectTree();
            initTreeSelected();
        }
    });
</script>
</head>
<body class="h100b">
    <div class="stadic_layout">
        <div class="stadic_layout_head stadic_head_height align_center">
            <div class="common_radio_box clearfix padding_t_10">
                <label class="margin_r_10 hand" for="member_radio"> <input id="member_radio" class="radio_com"
                    name="navigation_type" value="Member" type="radio">${ctp:i18n("taskmanage.navigation.bymember")}
                </label> 
                <label class="margin_r_10 hand" for="project_radio"> <input id="project_radio"
                    class="radio_com" name="navigation_type" value="Project" type="radio">${ctp:i18n("taskmanage.navigation.byproject")}
                </label>
            </div>
        </div>
        <div class="stadic_layout_body stadic_body_top_bottom">
            <table class="only_table edit_table" id="member_table" border="0" cellSpacing="0" cellPadding="0" width="100%">
                <thead>
                    <tr>
                        <th>${ctp:i18n("common.name.label")}</th>
                    </tr>
                </thead>
                <tbody id="member_list">
                    <c:forEach var="members" items="${memberList}">
                    <tr>
                        <td>
                            <input id="mid${members.id}" class="radio_com" name="option" value="${members.idStr}" type="radio" onclick="changeMemberListData('${members.idStr}')" ${members.idStr == currentUserId ? 'checked' : ''} />${members.userName}
                        </td>
                    </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div class="zTreeDemoBackground left" id="project_tree">
                <ul id="tree_list" class="treeDemo_0 ztree"></ul>
            </div>
        </div>
    </div>
</body>
</html>
