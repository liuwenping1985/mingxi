<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="/WEB-INF/jsp/apps/collaboration/js/template_pub.js.jsp" %>
<script type="text/javascript" src="${path}/ajax.do?managerName=collaborationTemplateManager,templateManager,govdocTemplateDepAuthManager"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/template/js/templateSysMgrNew.js${ctp:resSuffix()}"></script>
<script>
var isGroup = "${ctp:getSystemProperty('system.ProductId')}"=='4';
var currentSelectCategoryId = "";
var template_dialog;
var categoryType = "${categoryType}";
var categoryId = "${ctp:escapeJavascript(categoryId)}";
// 公文
var edocCategory = "4";
var govOnly = "${govOnly}";
var edocsendCategory = "19";
var edocrecCategory = "20";
var sginReportCategory = "21";
//新公文
var govdocsendCategory = "401";
var govdocrecCategory = "402";

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
var app = 4;

var categoryTip = "${ctp:i18n('template.templateSysMgr.specialCharacters')}";
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
            	<div class="common_tabs clearfix" style="display:none" id="left_div">
	                <ul class="left">
						<li id="govdocArticleBut" class="current"><a hidefocus="true" href="javascript:govdocShowDocPage()" class="border_b">${ctp:i18n('template.templateChoose.textAlone')}</a></li><!-- 文单 -->
						<li id="govdocContentBut"><a hidefocus="true" href="javascript:showGovdocContent()">${ctp:i18n('collaboration.summary.text')}</a></li><!-- 新公文正文 -->
	                    <li id="workFlowBut"><a hidefocus="true" href="javascript:showWorkFlow()">${ctp:i18n('collaboration.workflow.label')}</a></li><!-- 流程 -->
	                </ul>
	            </div>
                <div class="form_area">
                </div>
                <iframe id="templateOperDes" width="100%" height="100%" frameborder="0" style="overflow-y:hidden" src=""></iframe>
            </div>
        </div>
      </div>
<%@include file="../../ctp/workflow/workflowDesigner_js_api.jsp"%>
<iframe id="editFrame" name = "editFrame" src="${path }/form/bindDesign.do?method=editFrame&defaultBodyType=HTML" style="height:0;width:0;"></iframe>
</body>
</html>