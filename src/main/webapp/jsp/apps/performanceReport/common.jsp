<%--
 $Author: hetao $
 $Rev: 7 $
 $Date:: 2012-09-05 13:29:18#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<c:set var="url_ajax_performanceReportManager" value="${path}/ajax.do?managerName=performanceReportManager"></c:set>
<c:set var="url_performanceReport_performanceTree" value="${path}/performanceReport/performanceReport.do?method=performanceTree"></c:set>
<c:set var="url_performanceReport_centerGrid" value="${path}/performanceReport/performanceReport.do?method=centerGrid"></c:set>
<c:set var="url_performanceReport_personRight" value="${path}/performanceReport/performanceReport.do?method=personRight"></c:set>
<c:set var="url_performanceReport_authSave" value="${path}/performanceReport/performanceReport.do?method=authSave"></c:set>
<c:set var="url_performanceReport_authEdit" value="${path}/performanceReport/performanceReport.do?method=authEdit"></c:set>

<c:set var="url_ajax_workFlowAnalysisManager" value="${path}/ajax.do?managerName=workFlowAnalysisManager"/>

<script type="text/javascript">
var url_performanceReport_authSave = "${url_performanceReport_authSave}";
var url_performanceReport_performanceTree = "${url_performanceReport_performanceTree}";
var url_performanceReport_centerGrid = "${url_performanceReport_centerGrid}";
</script>