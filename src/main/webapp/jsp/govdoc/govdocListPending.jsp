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
    <title>待办公文</title>
    <script type="text/javascript" src="${path}/ajax.do?managerName=colManager,pendingManager"></script>
    <script type="text/javascript" src="${path}/ajax.do?managerName=batchManager"></script><%--批处理 --%>
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/govdoc/js/govdoc.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/govdoc/js/govdocListPending.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/batch.js${ctp:resSuffix()}"></script>
    <script type="text/javascript">
    	var sub_app = "${param.sub_app}";
	    var secretLevelList = '${secretLevelList}';
	    var urgentLevelList = '${urgentLevelList}';
    	var arr = new Array();
    	arr = eval("(" + secretLevelList + ")");
    	var secretLevelOptions = new Array();
    	for(var i = 0; i<arr.length; i++){
    		secretLevelOptions[i] = {text:arr[i].label,value:arr[i].value};
    	}
    	arr = eval("(" + urgentLevelList + ")");
    	var urgentLevelOptions = new Array();
    	for(var i = 0; i<arr.length; i++){
    		urgentLevelOptions[i] = {text:arr[i].label,value:arr[i].value};
    	}
       var _paramTemplateIds = "${paramMap.templeteIds}";
      
       var paramMethod = "${param.method}";
       //ouyp a6s邮件过滤
       var emailNotShow = ${v3x:getSysFlag('email_notShow')};
       var listCfgId="${param.listCfgId}";
    </script>
</head>
<body>
    <div id='layout'>
        <div class="layout_north bg_color_gray" id="north" style="height:30px">
            <!-- 如果是业务生成器创建的一个列表菜单或来自收文和发文管理的请求，则不显示面包屑 -->
            <c:if test="${param.srcFrom ne 'bizconfig' && (param.govDocSendOrRecManage==null || param.govDocSendOrRecManage != 1) }">
                <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F20_govdocPending'"></div>
            </c:if>
            <input type='hidden' id='frombizconfigIds' value="${param.textfield}"/>
            <input type='hidden' id='bisnissMap' value="${param.textfield}"/>
            <table width="100%" border="0" cellpadding="0">
            	<tr>
            		<td width="80%"><div id="toolbars"></div></td>
            		<td width="20%" align="right" valign="center" class="bg_color_gray">
              			<a id="combinedQuery" class="font_size14" onclick="openQueryViewsForSubApp('listPending', '${param.sub_app}');" >${ctp:i18n("collaboration.advanced.lable") }</a>
            		</td>
            	</tr>
            </table>
            
             
        </div>
        <div class="layout_center over_hidden" id="center">
            <table  class="flexme3 " id="listPending"></table>
            <div id="grid_detail" class="h100b">
                <!-- <iframe id="summary" width="100%" height="100%" frameborder="0" class='calendar_show_iframe' style="overflow-y:hidden"></iframe> -->
            </div>
        </div>
    </div>
</body>
</html>
