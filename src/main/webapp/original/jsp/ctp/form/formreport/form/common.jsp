<%--
 $Author: hetao $
 $Rev: 7 $
 $Date:: 2012-09-05 13:29:18#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<c:set var="url_ajax_reportDesignManager" value="${path}/ajax.do?managerName=formReportDesignManager"></c:set>
<c:set var="url_ajax_reportSaveManager" value="${path}/ajax.do?managerName=reportSaveManager"></c:set>

<c:set var="url_reportDesign_index" value="${path}/report/reportDesign.do?method=index"/>
<c:set var="url_reporDesign_setReportChartDialog" value="${path}/report/reportDesign.do?method=goSetReportChartDialog" />
<c:set var="url_reporDesign_selectFormField" value="${path}/report/reportDesign.do?method=goSelectFormField" />

<c:set var="url_queryReport_index" value="${path}/report/queryReport.do?method=index" />
<c:set var="url_queryReport_goIndexRight" value="${path}/report/queryReport.do?method=goIndexRight" />
<c:set var="url_queryReport_showReportGrid" value="${path}/report/queryReport.do?method=showReportGrid" />
<c:set var="url_queryReport_showReportPreview" value="${path}/report/queryReport.do?method=showReportPre" />

<c:set var="url_queryReport_goIndexIntro" value="${path}/report/queryReport.do?method=goIndexIntro" />
<script type="text/javascript">
var url_reportDesign_index = '${url_reportDesign_index}';
var url_reporDesign_setReportChartDialog = '${url_reporDesign_setReportChartDialog}';
var url_reporDesign_selectFormField = '${url_reporDesign_selectFormField}';

var url_queryReport_index = "${url_queryReport_index}";
var url_queryReport_goIndexRight = "${url_queryReport_goIndexRight}";
var url_queryReport_showReportGrid = "${url_queryReport_showReportGrid}";
var url_queryReport_goIndexIntro = "${url_queryReport_goIndexIntro}";
</script>