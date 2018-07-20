<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="/WEB-INF/jsp/apps/collaboration/js/template_pub.js.jsp" %>
<script type="text/javascript" src="${path}/ajax.do?managerName=collaborationTemplateManager,templateManager"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/template/js/templateSysMgr.js${ctp:resSuffix()}"></script>
<script>
var isGroup = "${ctp:getSystemProperty('system.ProductId')}"=='4';
var currentSelectCategoryId = "";
var template_dialog;
var categoryType = "${categoryType}";
var categoryId = "${ctp:escapeJavascript(categoryId)}";
// 公文
var edocCategory = "4";
var edocsendCategory = "19";
var edocrecCategory = "20";
var sginReportCategory = "21";
// 协同
var collCategory = "1";
//信息报送
var infoCategory ="32";
var toolbar;
//
var canAdmin = true;
var canCreateCategory = true;
var projectPath = '${path}';
var adminflag ="${isAdmin}" === "false";
var curUserId = "${CurrentUser.id}";
</script>
</head>
<body>
    <c:if test="${param.categoryType == '4' }">
        <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F07_edocSystem1'"></div>
        <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F07_edocSystem1',border:false"></div>
    </c:if>
    <form id="commonForm" action="" method="post">
        <input type="hidden" id="templateId">
        <input type="hidden" id="categoryId">
        <input type="hidden" id="categoryType">
    </form>
    <div id='layout' class="comp f0f0f0" comp="type:'layout'">
        <div class="layout_north f0f0f0" layout="height:28,sprit:false,border:false">
          <div id="toolbar"></div>
        </div>
        <div class="layout_west" id="west" layout="border:true">
            <table width="100%" height="100%" class="page_color" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="padding_10" valign="top">
                        <div id="templateTree" class="ztree"></div>
                    </td>
                </tr>
            </table>
        </div>
        <div class="layout_center" id="center" style="overflow:hidden;" layout="border:false">
            <table id="collaborationTemplateTable" style="display: none;"></table>
            <div id="grid_detail">
                <div class="form_area">
                </div>
                <iframe id="templateOperDes" width="100%" height="100%" frameborder="0" style="overflow-y:hidden" src=""></iframe>
            </div>
        </div>
      </div>
<%@include file="../../ctp/workflow/workflowDesigner_js_api.jsp"%>
</body>
</html>