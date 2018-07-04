<%--
 $Author:  翟锋$
 $Rev:  $
 $Date:: #$:2014-03-11
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="over_hidden h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="${path}/common/seeyonreport/reportShowForPortal.js${ctp:resSuffix()}"></script>

<script type="text/javascript">
	var searchobj = "";
	var cptFilename = "${cptFilename}";
	var cptFiledir = "${cptFiledir}";
	var cptname = "${cptname}";
	$(function() {
		//初始化搜索条件
		init_serach();
		
		// 模版树
		init_tree();

		//调用初始化函数
		init();

		//添加报表分类点击
		init_addCategory();

		//删除选中报表分类点击
		init_deleteCategory();

		//双击事件
		init_dbClick();
		
		//如果是搜索条件查询时，将查询条件返回
		var subject = "${subject}";
		var categoryName = "${categoryName}";
		if(subject != ""){
			searchobj.g.setCondition('subject', subject);
		}else if(categoryName != ""){
			searchobj.g.setCondition('categoryName', categoryName);
		}
		
	});
</script>

</head>

<body class="h100b over_hidden">
	<div class="stadic_layout margin_t_5">
		<div class="stadic_layout_body stadic_body_top_bottom ">
			<table align="center">
				<tr align="center" class="font_size14">
					<!-- 候选报表 -->
					<td>${ctp:i18n('seeyonreport.report.template.portal.unselect.label')}</td>
					<td></td>
					<!-- 选中报表 -->
					<td>${ctp:i18n('seeyonreport.report.template.portal.select.label')}</td>
				</tr>
				<tr>
					<td style="width: 240px; height: 300px;" valign="top"
						class="over_auto border_all bg_color_white">
						<div id="reportShowTree" class="ztree"></div>
					</td>
					<td>
						<!-- 添加 --> <em class="ico16 select_selected" id="toRight"
						title="${ctp:i18n('seeyonreport.report.template.cptfile.add.label')}"></em><br />
					<br /> <!-- 刪除 --> <em class="ico16 select_unselect" id="toLeft"
						title="${ctp:i18n('seeyonreport.report.template.cptfile.delete.label')}"></em>
					</td>
					<td width='240'><select id="selected" name="selected"
						multiple="multiple" style="width: 240px; height: 300px;">
					</select></td>

				</tr>
			</table>
		</div>
	</div>
</body>
</html>