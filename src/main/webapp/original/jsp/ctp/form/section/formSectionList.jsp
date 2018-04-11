<%--
 $Author:  $
 $Rev:  $
 $Date:: #$:

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title></title>
</head>
<body >
<div class="comp" comp="type:'breadcrumb',code:'T05_formSection'"></div>
<div id='layout' class="comp page_color" comp="type:'layout'">
    <div class="layout_north" layout="height:40,sprit:false,border:false">

        <div id="toolbar"></div>
    </div>
    <div  id="center" class="layout_center page_color over_hidden" layout="border:false">
        <table class="flexme3" style="display: none" id="mytable"></table>
        <div id="grid_detail">
            <iframe id="viewFrame"  class="calendar_show_iframe" src="" border="0" frameBorder="no" scrolling = "no" style="width: 100%;height:100%"></iframe>
        </div>
    </div>
    <%@ include file="formSectionList.js.jsp" %>
    <script type="text/javascript" src="${path}/ajax.do?managerName=formSectionManager"></script>
    <div id="jsonSubmit"/>
</div>
</body>
</html>