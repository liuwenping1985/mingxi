<%--
 $Author:  翟锋$
 $Rev:  $
 $Date:: #$:2014-03-16
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>协同驾驶舱 > 报表分析 </title>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'T7_reportShowIndex'"></div>
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
        <div class="layout_center" id="center" layout="border:true">
            <iframe id="reportShowDes" width="100%" height="99%" frameborder="0" style="overflow-y:hidden" src=""></iframe>
        </div>
     </div>
</body>
<script type="text/javascript" src="${path}/common/seeyonreport/reportShowIndex.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
var categoryId = '${categoryId}', orgAccountId = '${orgAccountId}', subject = '${subject}', categoryName = '${categoryName}';
var searchobj;
$(document).ready(function(){
	initSearch();
	initTree();
	$("#reportShowDes").attr("src",_ctxPath+"/seeyonReport/seeyonReportController.do?method=reportShowDes&total=${count}");
});
</script>
</html>