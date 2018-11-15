<%--
 $Author: 黄奎 $
 $Rev: 9416 $
 $Date:: 2016-12-02 12:46:11#$:
  
 Copyright (C) 2016 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n("form.formmasterdatalist.title")}</title>
</head>
    
    <!-- 获取服务器端返回的参数值 -->
	<script type="text/javascript">
    	var formId = "${formId}";
    </script>
    
    <!-- bootstrap组件引用 -->
    <script type="text/javascript" src="${path}/common/form/common/bootstrap/bootstrap.js${ctp:resSuffix()}"></script>
   	<link href="${path}/common/form/common/bootstrap/bootstrap.css${ctp:resSuffix()}" rel="stylesheet" />
    
    <!-- bootstrap table组件以及中文包的引用 -->
    <script type="text/javascript" src="${path}/common/form/common/bootstrap-table/bootstrap-table.js${ctp:resSuffix()}"></script>
    <link href="${path}/common/form/common/bootstrap-table/bootstrap-table.css${ctp:resSuffix()}" rel="stylesheet" />
	<c:choose>
		<c:when test="${language == 'zh_CN'}">
			<script type="text/javascript" src="${path}/common/form/common/bootstrap-table/locale/bootstrap-table-zh-CN.js${ctp:resSuffix()}"></script>
		</c:when>
		<c:otherwise>
			<script type="text/javascript" src="${path}/common/form/common/bootstrap-table/locale/bootstrap-table-en-US.js${ctp:resSuffix()}"></script>
		</c:otherwise>
	</c:choose>
    <!-- bootstrap table 行拖拽顺序的引用
    <link href="${path}/common/form/common/bootstrap-table/extensions/reorder-rows/bootstrap-table-reorder-rows.css${ctp:resSuffix()}" rel="stylesheet" />
    <script type="text/javascript" src="${path}/common/form/common/bootstrap-table/extensions/reorder-rows/bootstrap-table-reorder-rows.min.js${ctp:resSuffix()}"></script>
     -->
     
    <!-- bootstrap table 列拖拽顺序的引用
    <link href="${path}/common/form/common/bootstrap-table/extensions/dragtable/dragtable.css${ctp:resSuffix()}" rel="stylesheet" />
    <script type="text/javascript" src="${path}/common/form/common/bootstrap-table/extensions/reorder-columns/bootstrap-table-reorder-columns.min.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" src="${path}/common/form/common/bootstrap-table/extensions/dragtable/jquery-ui.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" src="${path}/common/form/common/bootstrap-table/extensions/dragtable/jquery.dragtable.js${ctp:resSuffix()}"></script>
     -->
     
    <!-- 业务模块Js文件的引用 -->
	<script type="text/javascript" src="${path}/ajax.do?managerName=formDesignManager"></script>
	<script type="text/javascript" src="${path}/common/form/relation/relationDetailView.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" src="${path}/common/form/relation/relationViewTable.js${ctp:resSuffix()}"></script>
    <script type="text/javascript">
		var _isA6 = "${isA6}";
	    $(document).ready(function() {
	    	//1.初始化Table
	        var oTable = new TableInit();
	        oTable.Init();
            $(window).resize(function () {
                $('#tb_relationTable').bootstrapTable('resetView');
            });
		});
    </script>
<body class="h100b over_hidden">
	<%-- 中间是主表数据列表 --%>
	<table id="tb_relationTable" data-use-row-attr-func="true" data-reorderable-rows="true" data-reorderable-columns="true"></table>
	<!-- Start 模态框（Modal） -->
	<div style="display:none;" class="modal fade" id="capModalWin" tabindex="-1" role="dialog" aria-labelledby="capModalWinLabel" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	                <h4 class="modal-title" id="capModalWinLabel">模态框（Modal）标题</h4>
	            </div>
	            <div class="modal-body">在这里添加模态框内容</div>
	            <!-- <div class="modal-footer"><button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button></div> -->
	        </div>
	    </div>
	</div>
	<!-- End 模态框（Modal） -->
</body>
</html>