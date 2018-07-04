<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/info_header.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%--待发信息列表--%>
<title>${ctp:i18n("infosend.listInfo.listDraft")}</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=infoListManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=infoManager"></script>
<script type="text/javascript" src="${path}/apps_res/info/js/info_list.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/info/js/listDraft.js${ctp:resSuffix()}"></script>
<script>var listType = "${listType}";</script>
</head>
<body>
<div id="workflow_definition" style="display: none">
    <input type="hidden" id="process_desc_by">
    <input type="hidden" id="process_xml">
    <input type="hidden" id="readyObjectJSON">
    <input type="hidden" id="process_info">
    <input type="hidden" id="process_subsetting">
    <input type="hidden" id="moduleType" value='32' >
    <input type="hidden" id="workflow_newflow_input">
    <input type="hidden" id="process_rulecontent"/>
    <input type="hidden" id="workflow_node_peoples_input">
    <input type="hidden" id="workflow_node_condition_input">
</div>
<form id="sendForm" method="post">
    <input type="hidden" id="affairId" name="affairId" />
    <input type="hidden" id="summaryId" name="summaryId" />
    <input type="hidden" id="listType" name="${listType}" />
</form>
<div id='layout'>
	<div class="layout_north bg_color" id="north">
            <div style="float: left" id="toolbars"></div>
            <div style="float: right">
                <a id="combinedQuery" onclick="openQueryViews('${listType}');" style="margin-right: 5px;margin-top:2px;" class="common_button common_button_gray">${ctp:i18n("infosend.listInfo.combinedQuery")}</a>
            </div>
        </div>
        <div class="layout_center over_hidden" id="center">
            <table class="flexme3" id="listDraft"></table>
            <!--
            <div id="grid_detail" class="h100b">
                <iframe id="summary" name='summaryF' width="100%" height="100%" frameborder="0"  class="calendar_show_iframe" style="overflow-y:hidden"></iframe>
            </div> -->
        </div>
    </div>
    <iframe id="hiddenIframe" name="hiddenIframe" style="display:none"></iframe>
</body>
</html>