<%--
 $Author: ouyp $
 $Rev:  $
 $Date:: 2015-04-24 14:05:18#$:
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<!-- report.portal.commons setting -->
<c:set var="url_performanceReport_performanceTree" value="${path}/performanceReport/performanceReport.do?method=performanceTree"></c:set>
<c:set var="url_performanceReport_centerGrid" value="${path}/performanceReport/performanceReport.do?method=centerGrid"></c:set>
<c:set var="url_performanceReport_personRight" value="${path}/performanceReport/performanceReport.do?method=personRight"></c:set>
<c:set var="url_performanceReport_authSave" value="${path}/performanceReport/performanceReport.do?method=authSave"></c:set>
<c:set var="url_performanceReport_authEdit" value="${path}/performanceReport/performanceReport.do?method=authEdit"></c:set>
<script type="text/javascript">
    var url_performanceReport_authSave = "${url_performanceReport_authSave}";
    var url_performanceReport_performanceTree = "${url_performanceReport_performanceTree}";
    var url_performanceReport_centerGrid = "${url_performanceReport_centerGrid}";
</script>
<%@ include file="/WEB-INF/jsp/apps/performanceReport/query/queryCommon.jsp" %>
<!-- 若为图表，加载表格相关js -->
<c:if test="${tableChartTab == 2 }">
<!-- report.portal.chart setting -->
<script type="text/javascript" src="${path}/common/report/chart/js/AnyChart.js"></script>
<script type="text/javascript" src="${path}/common/report/chart/js/AnyChartHTML5.js"></script>
<script type="text/javascript" src="${path}/common/report/chart/js/seeyon.ui.chart.js"></script>
<!-- 图表展示控制文件:5.6前端优化从showChart.jsp中拆分过来 -->
<script type="text/javascript" src="${path}/apps_res/performanceReport/js/showChart.js"></script> <!-- 可以对其进行压缩 -->
</c:if>
<!-- 若为表格，加载图表相关js -->
<c:if test="${tableChartTab == 1 }">
<!-- report.portal.table setting -->
<script type="text/javascript" src="${path}/apps_res/performanceReport/js/showTable.js"></script> <!-- 可以对其进行压缩 -->
<script type="text/javascript" src="${path}/apps_res/performanceReport/js/showChart.js"></script> <!-- 可以对其进行压缩 -->
</c:if>

<!-- report.portal.other setting -->
<script type="text/javascript" src="${path}/apps_res/performanceReport/js/showPortal.js"></script> <!-- 可以对其进行压缩 -->


