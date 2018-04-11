<%--
 $Author:  翟锋$
 $Rev:  $
 $Date:: #$:2014-03-11
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="over_hidden h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body class="h100b over_hidden">
    <div class="stadic_layout margin_t_5">
        <div class="stadic_layout_body stadic_body_top_bottom ">
            <table align="center" style="table-layout:fixed">
            	<tr align="center" class="font_size14">
            		<%-- 候选模板文件 --%>
            		<td>${ctp:i18n('seeyonreport.report.template.cptfile.unselect.label')}</td>
            		<td></td>
            		<%-- 选中模板文件 --%>
            		<td>${ctp:i18n('seeyonreport.report.template.cptfile.select.label')}</td>
            	</tr>
                <tr>
                    <td style="width: 240px; height: 300px;" valign="top" class=" border_all bg_color_white">
                    	<div class="over_auto" style="width: 240px; height: 300px;">
                    		<div id="cptFileTree" class="ztree"></div>
                    	</div>
                    </td>
                    <td>
                    	<%-- 添加 --%>
                        <em class="ico16 select_selected" id="toRight" title="${ctp:i18n('seeyonreport.report.template.cptfile.add.label')}"></em><br/><br/>
                        <%-- 刪除 --%>
                        <em class="ico16 select_unselect" id="toLeft" title="${ctp:i18n('seeyonreport.report.template.cptfile.delete.label')}"></em>
                    </td>
                    <td width='240'>
                        <select id="selected" name="selected" multiple="multiple" style="width: 240px; height: 300px;">
                            <c:if test="${!empty cptFilename && !empty cptFiledir}">
                                <option value='${cptFiledir}'>${cptFilename }</option>
                            </c:if>
                        </select>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</body>
<script type="text/javascript" src="${path}/common/seeyonreport/selectCptFile.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
var cptname = '${cptname}';
var searchobj, treeObj;
$(document).ready(function(){
	initTree();
	initSearch();
	initEvent();
});
</script>
</html>