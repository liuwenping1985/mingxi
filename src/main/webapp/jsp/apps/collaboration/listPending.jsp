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
    <title>待办事项</title>
    <script type="text/javascript" src="${path}/ajax.do?managerName=colManager,pendingManager"></script>
    <script type="text/javascript" src="${path}/ajax.do?managerName=batchManager"></script><%--批处理 --%>
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/collaboration.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/listPending.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/batch.js${ctp:resSuffix()}"></script>
    <script type="text/javascript">
       var _paramTemplateIds = "${paramMap.templeteIds}";
      
       var paramMethod = "${param.method}";
       //ouyp a6s邮件过滤
       var emailNotShow = ${v3x:getSysFlag('email_notShow')}; 
    </script>
</head>
<body unselectable="on">
    <div id='layout'>
        <div class="layout_north bg_color" id="north">
            <!-- 如果是业务生成器创建的一个列表菜单，则不显示面包屑 -->
            <c:if test="${param.srcFrom ne 'bizconfig' }">
                <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F01_listPending'"></div>
            </c:if>
            <input type='hidden' id='frombizconfigIds' value="${param.textfield}"/>
            <input type='hidden' id='bisnissMap' value="${param.textfield}"/>
            <table width="100%" border="0" cellpadding="0">
            	<tr>
            		<td><div id="toolbars"></div></td>
            		<td width="100" align="right" valign="center" class="bg_color_gray">
              			<a id="combinedQuery" class="font_size14" onclick="openQueryViews('listPending');" >${ctp:i18n("collaboration.advanced.lable") }</a>
            		</td>
            	</tr>
            </table>
            
             
        </div>
        <div class="layout_center over_hidden" id="center">
            <table  class="flexme3 " id="listPending"></table>
            <div id="grid_detail" class="h100b">
                <iframe id="summary" width="100%" height="100%" frameborder="0" class='calendar_show_iframe' style="overflow-y:hidden"></iframe>
            </div>
        </div>
    </div>
</body>
</html>