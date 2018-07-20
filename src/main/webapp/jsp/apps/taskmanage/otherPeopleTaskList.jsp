<%--
 $Author:  he.t$
 $Rev:  280$
 $Date:: 2014-12-17 17:28:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html class="h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>他人任务看版</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/project/js/jquery.ui.scrollpage.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/otherPeopleTaskList.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/otherPeopleTaskListEvent.js${ctp:resSuffix()}"></script>
</head>
<body class="h100b over_hidden">
<div class="stadic_layout">
<div class="stadic_layout_head stadic_head_height">
<%--他人任务，被授权JSON数据--%>
<input id="otherMembersJSON" type="hidden" value="${fn:escapeXml(otherMembers)}"/>
<style>
  .stadic_head_height{
    height:40px;
  }
  .stadic_body_top_bottom{
    top: 40px;
    bottom: 0px;
    margin-left : 5px;
  }
  .condition{
  	margin-top: 8px;
  	position: absolute;
  	z-index:900;
  	right:18px;
  }
</style>
<%--条件区--%>
<form id="searchForm" name="searchForm" action="${path}/taskmanage/taskinfo.do?method=otherPeopleTaskList" method="post">
<ul class="common_search condition">
    <li id="inputBorder" class="common_search_input">
        <input class="search_input" id="inputCondition" name="inputCondition" type="text" value="${inputCondition}">
    </li>
    <li>
        <a id="aCondition" class="common_button common_button_gray search_buttonHand" href="javascript:void(0);">
            <em></em>
        </a>
    </li> 
</ul> 
</form>
</div>
<%--他人任务卡片结果区--%>
<div class="stadic_layout_body stadic_body_top_bottom clearfix">
	<div class="projectTask_taskOtherList" style="margin-top:10px;">
		<ul class="list clearfix" id="otherPeopleUl">
			
		</ul>
	</div>
</div><%--end of stadic_layout_body stadic_body_top_bottom--%>
</div>
</body>
</html>