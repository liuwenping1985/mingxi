<%--
 $Author: hetao $
 $Rev: 7 $
 $Date:: 2012-09-05 13:29:18#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<c:set var="url_reorting_index" value="${path}/report/reporting.do?method=index" />
<c:set var="url_reporting_new" value="${path}/report/reporting.do?method=goToNew" />
<c:set var="url_reporting_edit" value="${path}/report/reporting.do?method=goToEdit" />
<c:set var="url_reporting_stepOne" value="${path}/report/reporting.do?method=goStepOne" />
<c:set var="url_reporting_stepTwo" value="${path}/report/reporting.do?method=goStepTwo" />
<c:set var="url_reporting_stepThree" value="${path}/report/reporting.do?method=goStepThree" />
<c:set var="url_reporting_save" value="${path}/report/reporting.do?method=saveReporting" />
<c:set var="url_reporting_selectFormField" value="${path}/report/reporting.do?method=goSelectFormField" />
<c:set var="url_reporting_sumDataListDialog" value="${path}/report/reporting.do?method=goSumDataListDialog"/>
<c:set var="url_reporting_setFilterDialog" value="${path}/report/reporting.do?method=goSetFilterDialog"/>
<c:set var="url_reporting_setUserConditionDialog" value="${path}/report/reporting.do?method=goSetUserConditionDialog"/>
<c:set var="url_reporting_setReportChartDialog" value="${path}/report/reporting.do?method=goReportChartDialog"/>
<c:set var="url_reportView_goIndexRight" value="${path}/report/reportView.do?method=goIndexRight" />
<c:set var="url_reportView_showReportGrid" value="${path}/report/reportView.do?method=showReportGrid" />
<c:set var="url_reportView_goIndexIntro" value="${path}/report/reportView.do?method=goIndexIntro" />



<script type="text/javascript">
var url_reporting_exampleTutorial ="${path}/report/reporting.do?method=exampleTutorial";
var url_reporting_exampleTutorialTwo ="${path}/report/reporting.do?method=exampleTutorial&step=two";
var url_reporting_exampleTutorialThree ="${path}/report/reporting.do?method=exampleTutorial&step=three";
var url_reorting_index = "${url_reorting_index}";
var url_reporting_new = "${url_reporting_new}";
var url_reporting_edit = "${url_reporting_edit}";
var url_reporting_stepOne = "${url_reporting_stepOne}";
var url_reporting_stepTwo = "${url_reporting_stepTwo}";
var url_reporting_stepThree = "${url_reporting_stepThree}";
var url_reporting_save = "${url_reporting_save}";
var url_reporting_selectFormField = "${url_reporting_selectFormField}";
var url_reporting_sumDataListDialog = "${url_reporting_sumDataListDialog}";
var url_reporting_setFilterDialog = "${url_reporting_setFilterDialog}";
var url_reporting_setUserConditionDialog = "${url_reporting_setUserConditionDialog}";
var url_reporting_setReportChartDialog = "${url_reporting_setReportChartDialog}";

var url_reportView_goIndexRight = "${url_reportView_goIndexRight}";
var url_reportView_showReportGrid = "${url_reportView_showReportGrid}";
var url_reportView_goIndexIntro = "${url_reportView_goIndexIntro}";
</script>