<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/info_header.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%-- 已审核期刊列表 --%>
<title>${ctp:i18n("infosend.score.magazine.auditDone.title")}</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=infoManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=magazineListManagerr"></script>
<script type="text/javascript" src="${path}/apps_res/info/js/info_list.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/info/js/magazine/magazine_audit_list_done.js${ctp:resSuffix()}"></script>
<script>var listType = "${listType}";</script>
</head>
<body>
<div id='layout'>
        <div class="layout_north bg_color" id="north">
            <div style="float: left" id="toolbars"></div>
        </div>
        <div class="layout_center over_hidden" id="center">
            <table  class="flexme3" id="listDone"></table>
        </div>
    </div>
    <iframe id="hiddenIframe" name="hiddenIframe" style="display:none"></iframe>
</body>
</html>