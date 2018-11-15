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
<%@ include file="/WEB-INF/jsp/ctp/view/developcenter/restusermanage/authorizeUser_js.jsp"%>
<html>
<head>
<title></title>
</head>
<body>
    <div class="form_area" id='form_area'>
       <div class="margin_lr_15 ">
            <form id="myfrm" name="myfrm" method="post">
              <input type="hidden" id="id" />
              <input type="hidden" id="resourceId" />
              <input type="hidden" id="callType" />
            </from>
            <div class="common_checkbox_box clearfix " id="resourceGroup"></div>
       </div>
    </div>
</body>
</html>