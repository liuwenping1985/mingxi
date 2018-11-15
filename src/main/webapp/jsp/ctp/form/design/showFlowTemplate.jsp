<%--
 $Author: dengcg $
 $Rev: 509 $
 $Date:: 2013-01-07 00:08:40#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>${ctp:i18n('form.flow.templete')}</title>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <c:if test = "${canSelect }">
    <div class="layout_north" id="north"  layout="height:50,sprit:false,border:false">
     <div id="toolbar"  class="font_size12 margin_t_5 margin_l_5" >${ctp:i18n('form.bind.confirm') }</div>
    </div>
    </c:if>
<div class="layout_center" style="overflow:hidden;" id="center" layout="border:false">
            <table class="flexme3 " style="display: none" id="mytable"></table>
            <div id="grid_detail">
              <iframe id="viewFrame" src="" width="100%" height="100%" frameborder="no"></iframe>
            </div>
             </div>
 </div>
 
 <%@ include file="showFlowTemplate.js.jsp" %>
 <script type="text/javascript" src="${path}/ajax.do?managerName=formListManager"></script>
</body>
</html>