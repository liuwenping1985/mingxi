<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript" charset="UTF-8" src="${path}/common/workflow/simulation/js/simulationEntry.js${ctp:resSuffix()}"></script>
<script>
var currentSelectCategoryId = "";
var categoryType = "${categoryType}";
var categoryId = "${ctp:escapeJavascript(categoryId)}";
var categoryIds = "";
</script>
</head>
<body>
   
    <form id="commonForm" action="" method="post">
        <input type="hidden" id="templateId">
        <input type="hidden" id="categoryId">
        <input type="hidden" id="categoryType">
    </form>
    <div id='layout' class="comp f0f0f0" comp="type:'layout'">
    	<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F13_workflowSimulation'"></div>
        <div class="layout_north f0f0f0" layout="height:40,sprit:false,border:false">
          <div id="toolbar"></div>
        </div>
        <div class="layout_west" id="west" layout="border:true">
            <table width="100%" height="100%" class="page_color" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="padding_10" valign="top">
                        <div id="simulationMainTree" class="ztree"></div>
                    </td>
                </tr>
            </table>
        </div>
        <div class="layout_center" id="center" style="overflow:hidden;" layout="border:false">
            <table id="simulationMainTable" style="display: none;"></table>
            <div id="grid_detail">
                <div class="form_area">
                </div>
                <iframe id="simulationMainOperDes" width="100%" height="100%" frameborder="0" style="overflow-y:hidden" src=""></iframe>
            </div>
        </div>
      </div>
</body>
</html>