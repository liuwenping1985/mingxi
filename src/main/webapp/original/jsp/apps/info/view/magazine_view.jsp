<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/info_header.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%-- 查看页面 --%>
<title>查看页面</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=magazineListManager"></script>
<script type="text/javascript" src="${path}/apps_res/info/js/view/magazine_view.js${ctp:resSuffix()}"></script>
<script>var listType = "${listType}";</script>
</head>
<body>

<div id='layout'>
        <div class="layout_north bg_color" id="north">
            <div style="float: left" id="toolbars"></div>
            <div style="float: right">
                <ul class="common_search"> <li id="inputBorder" class="common_search_input"> <input id="searchName" class="search_input" type="text" value=""> </li> <li><a class="common_button common_button_gray search_buttonHand" href="javascript:doSearch()"><em></em></a></li> </ul>
            </div>
        </div>
        <div class="layout_center over_hidden" id="center">
            <table  class="flexme3" id="listView"></table>
        </div>
    </div>
    <iframe id="hiddenIframe" name="hiddenIframe" style="display:none"></iframe>
</body>
</html>
