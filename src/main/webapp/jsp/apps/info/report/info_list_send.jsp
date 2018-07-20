<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/info_header.jsp"%>
<!DOCTYPE html>
<html>
<head> 
<%-- 已上报信息 --%>
<title>${ctp:i18n("infosend.listInfo.listSend")}</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=infoManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=infoListManager"></script>
<script type="text/javascript" src="${path}/apps_res/info/js/info_list.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/info/js/listSend.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/info/js/common/pigeonhole.js${ctp:resSuffix()}"></script>
</head>
<body>
<div id='layout'>
        <div class="layout_north bg_color" id="north" style="background:#f0f0f0">
            <div style="float: left" id="toolbars"></div>
            <div style="float: right">
                <a id="combinedQuery" onclick="openQueryViews('${listType}');" style="margin-right: 5px;margin-top:2px;" class="common_button common_button_gray">${ctp:i18n('infosend.listInfo.combinedQuery')}<!-- 组合查询 --></a>
            </div>
        </div>
        <div class="layout_center over_hidden" id="center">
            <table  class="flexme3" id="listSend"></table>
            <!-- 
            <div id="grid_detail" class="h100b">
                <iframe id="summary" name='summaryF' width="100%" height="100%" frameborder="0"  class="calendar_show_iframe" style="overflow-y:hidden"></iframe>
            </div>
             -->
        </div>
        <jsp:include page="/WEB-INF/jsp/common/content/workflow.jsp"/>
    </div>
<iframe id="hiddenIframe" name="hiddenIframe" style="display:none"></iframe>
</body>
</html>