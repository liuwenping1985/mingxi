<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/gov_header.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>信息类型</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=categoryManager"></script>
<script type="text/javascript" src="${path}/apps_res/gov/category/js/list.js${ctp:resSuffix()}"></script>
</head>
<body>
    <div id='layout'>
        <div class="layout_north bg_color" id="north">
            <div id="toolbars"> </div>
        </div>
        
        <div class="layout_center over_hidden" id="center">
            <table class="flexme3" id="listGrid"></table>
            <div id="grid_detail" class="h100b">
                <iframe id="summary" name='summaryF' width="100%" height="100%" frameborder="0"  class='calendar_show_iframe' style="overflow-y:hidden"></iframe>
            </div>
        </div>
    </div>
</body>
</html>
