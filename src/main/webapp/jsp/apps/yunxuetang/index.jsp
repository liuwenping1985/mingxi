<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/yunxuetang/js/yunxuetang.js"></script>
<script type="text/javascript">
  var _path = "${path}";
  var _apiKey = "${apiKey}";
  var ajax_yxtSynManager = new yxtSynManager();
</script>
</head>
<body class="h100b over_hidden">
    <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F13_yunxuetangSyn'"></div>
    <div id="registerYXT"></div>
    <div id='layout' class="comp page_color" comp="type:'layout'">
        <div class="layout_north" layout="height:30,sprit:false,border:false">
            <div id="toolbar"></div>
        </div>
        <div class="layout_west bg_color_white stadic_layout_body stadic_body_top_bottom" id="west" layout="width:200">
            <div id="yxtTree"></div>
        </div>
        <div class="layout_center page_color over_hidden" layout="border:false">
            <input id="selectType" type="hidden" value="" />
            <input id="selectId" type="hidden" value="" />
            <table id="yxtTable" style="display: none;"></table>
            <div class="stadic_layout_footer stadic_footer_height border_t padding_tb_5 align_center bg_color_black hidden" id="btnDiv" style="z-index: 2;">
                <a id="btn_ok" class="common_button common_button_emphasize" href="javascript:void(0)" style="max-width: 150px;">${ctp:i18n('yunxuetang.index.saveconfig.js')}</a>
            </div>
        </div>
        <div id="dyncid"></div>
    </div>
</body>
</html>