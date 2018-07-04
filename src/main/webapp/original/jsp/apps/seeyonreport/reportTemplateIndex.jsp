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
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>报表应用设置</title>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="height:30,sprit:false,border:false">
          <div id="toolbar"></div>
        </div>
        <div class="layout_west" id="west" layout="border:true">
            <table width="100%" style="height: 100%">
                <tr>
                    <td class="padding_10" valign="top">
                        <div id="templateTree" class="ztree"></div>
                    </td>
                </tr>
            </table>
        </div>
        <div class="layout_center" id="center" style="overflow:hidden;" layout="border:false">
            <table id="reportTemplateTable" style="display: none;"></table>
            <div id="grid_detail">
                <iframe id="templateOperDes" width="100%" height="100%" frameborder="0" style="overflow-y:hidden" src=""></iframe>
            </div>
        </div>
     </div>
<script type="text/javascript" src="${path}/common/seeyonreport/reportTemplateIndex.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
$(document).ready(function(){
	initCrumb();
	initToolbar();
	initSearch();
	initTree();
	initTable();
});
</script>
</body>
</html>