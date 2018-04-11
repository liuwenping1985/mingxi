<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/hr" prefix="hr" %>

<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources" var="v3xHRI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.calendar.resources.i18n.CalendarResources" var="v3xCalI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.system.resources.i18n.SysMgrResources" />

<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<!--  <script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/bulletin/js/prototype.js${v3x:resSuffix()}" />"></script> ?????????????js-->

<script type="text/javascript">
<!--
var v3x = new V3X();
v3x.init("<c:out value='${pageContext.request.contextPath}' />", "${v3x:getLanguage(pageContext.request)}");
v3x.loadLanguage("/apps_res/hr/js/i18n");
v3x.loadLanguage("/apps_res/organization/js/i18n");
var hrStaffURL = "<html:link renderURL='/hrStaff.do' />";
var hrSalaryURL = "<html:link renderURL='/hrSalary.do' />";
var hrViewSalaryURL = "<html:link renderURL='/hrViewSalary.do' />";
var hrRecordURL = "<html:link renderURL='/hrRecord.do' />";
var hrStatisticURL = "<html:link renderURL='/hrStatistic.do' />";
var hrStaffTransferURL="<html:link renderURL='/hrStaffTransfer.do' />";
var m1RecordURL = "<html:link renderURL='/m1/lbsRecordController.do' />";
var hrUserDefinedURL="<html:link renderURL='/hrUserDefined.do' />";
var hrLogURL="<html:link renderURL='/hrLog.do' />";
var hrOrgMgrURL="<html:link renderURL='/hrOrgMgr.do' />";
var organURL = "<html:link renderURL='/organization.do' />";
var hrAppURL = "<html:link renderURL='/hrApp.do' />";
var detailURL = '<c:url value="/common/detail.jsp" />';
//-->
</script>                                                 
<html:link renderURL="/hrSalary.do" var="urlHrSalary"/>
<html:link renderURL="/hrViewSalary.do" var="urlHrViewSalary"/>
<html:link renderURL="/hrStatistic.do" var="urlHrStatistic"/>
<html:link renderURL="/hr.do" var="urlHR" />
<html:link renderURL="/hrStaff.do" var="hrStaffURL" />
<html:link renderURL="/hrRecord.do" var="hrRecordURL" />
<html:link renderURL="/hrStaffTransfer.do" var="hrStaffTransferURL" />
<html:link renderURL="/hrUserDefined.do" var="hrUserDefined" />
<html:link renderURL="/hrLog.do" var="hrLogURL" />
<html:link renderURL="/hrOrgMgr.do" var="hrOrgMgrURL" />
<html:link renderURL="/organization.do" var="organ" />
<html:link renderURL="/plurality.do" var="plurality" />
<html:link renderURL="/lbsRecordController.do" var="m1RecordURL" />
<html:link renderURL='/collaboration.do' var='collaboration' />
<html:link renderURL='/hrApp.do' var='hrAppURL' />
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xtree.js${v3x:resSuffix()}"/>"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/hr_common.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/toolbar.js${v3x:resSuffix()}" />"></script>

<link type="text/css" rel="stylesheet" href="<c:url value="/common/js/xtree/xtree.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/hr/css/default.css${v3x:resSuffix()}" />">

<c:set var="leastSize" value="0"/>