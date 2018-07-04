<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/xc/js/xc.js"></script>
<script type="text/javascript">
  var _path = "${path}";
  var _apiKey = "${apiKey}";
  var ajax_xcSynManager = new xcSynManager();
  	//var html = "<span class='nowLocation_ico'><img src='/seeyon/main/skin/frame/harmony/menuIcon/personal.png'></img></span><span class='nowLocation_content'>${ctp:i18n('xc.menu.1001')} > ${ctp:i18n('xc.menu.100103')}</span>";
     //   getCtpTop().showLocation(html);
</script>
</head>
<body class="h100b over_hidden">
<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'xc002'"></div>
    <div id="registerXC"></div>
    <div id='layout' class="comp page_color" comp="type:'layout'">
        <div class="layout_north" layout="height:40,sprit:false,border:false">
            <div id="toolbar"></div>
        </div>
        <div class="layout_west bg_color_white stadic_layout_body stadic_body_top_bottom" id="west" layout="width:200">
            <div id="xcTree"></div>
        </div>
        <div class="layout_center over_hidden" layout="border:false">
            <input id="selectType" type="hidden" value="" />
            <input id="selectId" type="hidden" value="" />
            <table id="xcTable" style="display: none;"></table>
        </div>
    </div>
</body>
</html>