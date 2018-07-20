<%--
 $Author:  翟锋$
 $Rev:  $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>待发事项</title>
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/collaboration.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/govdoc/js/listWaitSend.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" src="${path}/ajax.do?managerName=colManager,pendingManager"></script>
    <script type="text/javascript">
	    var secretLevelList = '${secretLevelList}';
		var arr = new Array();
		arr = eval("(" + secretLevelList + ")");
		var secretLevelOptions = new Array();
		for(var i = 0; i<arr.length; i++){
			secretLevelOptions[i] = {text:arr[i].label,value:arr[i].value};
		}
  		//服务器时间和本地时间的差异
    	var server2LocalTime = <%=System.currentTimeMillis()%> - new Date().getTime();
        var _paramTemplateIds = "${paramMap.templeteIds}";
        
        var paramMethod = "${param.method}";
        
        //ouyp a6s邮件过滤
		var emailNotShow = ${v3x:getSysFlag('email_notShow')};
		var sub_app = "${param.sub_app}";
		var _app = "${param.app}";
        
    </script>
</head>
<div id="workflow_definition" style="display: none">
    <input type="hidden" id="process_desc_by">
    <input type="hidden" id="process_xml">
    <input type="hidden" id="readyObjectJSON">
    <input type="hidden" id="workflow_data_flag" name="workflow_data_flag" value="WORKFLOW_SEEYON">
    <input type="hidden" id="process_info">
    <input type="hidden" id="process_subsetting">
    <input type="hidden" id="moduleType" value='1' >
    <input type="hidden" id="workflow_newflow_input">
    <input type="hidden" id="process_rulecontent"/>
    <input type="hidden" id="workflow_node_peoples_input">
    <input type="hidden" id="workflow_node_condition_input">
</div>
<body>
    <div id='layout'>
        <div class="layout_north bg_color border_t" id="north">
            <!-- 如果是业务生成器创建的一个列表菜单或来自发文和收文管理的请求，则不显示面包屑 -->
            <c:if test="${param.srcFrom ne 'bizconfig' && (param.govDocSendOrRecManage==null || param.govDocSendOrRecManage != 1) }">
                <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F20_govDocWaitSend'"></div>
            </c:if>
            <input type='hidden' id='frombizconfigIds' value="${param.textfield}"/>
            <input type='hidden' id='bisnissMap' value="${param.textfield}"/>
            <div id="toolbars" class="f0f0f0"></div>
            <form id="sendForm" method="post">
            	<input type="hidden" id="affairId" name="affairId" />
            	<input type="hidden" id="summaryId" name="summaryId" />
            </form>
        </div>
        <div class="layout_center over_hidden" id="center">
            <table  class="flexme3" id="listWaitSend"></table>
            <div id="grid_detail" class="h100b">
                <!-- <iframe id="summary"  width="100%" height="100%" frameborder="0" class='calendar_show_iframe' style="overflow-y:hidden"></iframe> -->
            </div>
        </div>
    </div>
</body>
</html>
