<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 $Author: muyx $ 
 $Rev: 1.0 $
 $Date:: 2012-9-7 上午10:55:54#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@page import="java.util.*"%>
<html>
<head>
<title></title>
<script type="text/javascript">
  <%@include file="/WEB-INF/jsp/apps/rss/js/rssMain.js"%>
</script>
</head>
<body>
<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F04_rssMain'"></div>
    <div id='layout' class="comp" comp="type:'layout'">
         <div class="layout_north" layout="height:30,border:false,sprit:false">
            <div id="toolbar"></div>
        </div>
        <div id="west" style="background:#fff;" class="layout_west"
            layout="width:140,minWidth:40,maxWidth:180,spiretBar:{show:true,handlerL:function(){$('#layout').layout().setWest(0);},handlerR:function(){$('#layout').layout().setWest(140);}}">
            <div id="rssTree"></div>
        </div>
        <div class="layout_center" id="center" layout="border:true">
            <%--内容 --%>
            <div id="div_center_content_for_rss" class="common_center w90b padding_t_10"></div>
        </div>
    </div>
</body>
</html>