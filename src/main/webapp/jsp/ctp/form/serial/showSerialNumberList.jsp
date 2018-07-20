<%--
 $Author: dengxj $
 $Rev: 509 $
 $Date:: 2012-09-06 16:08:40#$:

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>${ctp:i18n('form.showSerialNumberList.title')}</title>
<style>
    .stadic_body_top_bottom{
        bottom: 40px;
        top: 0px;
    }
    .stadic_footer_height{
        height:40px;
    }
    .input_div{
        width: 240px;
        margin-top: 5px;
    }
    .div_style{
        margin-top:5px;
        line-height: 25px;
    }
</style>
</head>
<body>
<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'T05_serialNumber'"></div>
<div id='layout' class="comp page_color" comp="type:'layout'">
    <div class="layout_north" layout="height:30,sprit:false,border:false">
        <div id="toolbar"></div>
    </div>
    <div  id="center" class="layout_center page_color over_hidden" layout="border:false">
        <table class="flexme3" style="display: none" id="mytable"></table>
        <div id="grid_detail" style="overflow: hidden;">
            <iframe id="viewFrame" src="${path }/form/serialNumber.do?method=desc&total=0" frameborder="0" style="width: 100%;height:100%;"></iframe>
        </div>
      </div>
      <!-- 作为删除或者其他动作用的,对于页面显示没有任何作用的 -->
	  <iframe class="hidden" id="delIframe" src=""></iframe>
</div>
 <%@ include file="showSerialNumberList.js.jsp" %>
 <script type="text/javascript" src="${path}/ajax.do?managerName=serialNumberManager"></script>
</body>
</html>