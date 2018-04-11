<%--
 $Author:  jiahl$
 $Rev:  $
 $Date:2014-01-21:#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page import="java.util.Map"%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/usersystem/authorizeUser_js.jsp"%>
<html>
<head>
<title></title>
</head>
<body style="height: 330px;">
    <div class="form_area" id='form_area'>
       <div class="margin_lr_15 ">
            <form id="myfrm" name="myfrm" method="post" style="height: 330px; position: relative;">
              <input type="hidden" id="id" />
              <input type="hidden" id="resourceId" />
              <input type="hidden" id="callType" />
            </from>
            <div class="common_checkbox_box clearfix " id="resourceGroup"></div>
            <div style="left: 0px; bottom: 0px; position: absolute;">
            <label class="margin_t_5 hand display_block" ><input class="radio_com" id="all" type="checkbox" >${ctp:i18n("online.selectall.label")}</label>
            </div>
       </div>
    </div>
</body>
</html>