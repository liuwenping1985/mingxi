<%@ page import="com.seeyon.v3x.common.constants.Constants" %>
<%@ page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<html:link renderURL="/bulType.do" var="bulTypeURL" />
<html:link renderURL="/bulTemplate.do" var="bulTemplateURL" />
<html:link renderURL="/bulData.do" var="bulDataURL" />
<html:link renderURL="/doc.do" var="docURL" />
<html:link renderURL="/collaboration.do" var="colDetailURL" />
<html:link renderURL="/edocController.do" var="edocDetailURL" />
<c:url value="/common/detail.jsp" var="commonDetailURL" />
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:message key="common.datetime.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<fmt:setBundle basename="com.seeyon.v3x.bbs.resources.i18n.BBSResources"/>
<fmt:setBundle basename="com.seeyon.v3x.inquiry.resources.i18n.InquiryResources" var="inquiryI18N"/>


<script type="text/javascript">

var docURL = "${docURL}";
var jsColURL = "${colDetailURL}";
var edocDetailURL = "${edocDetailURL}";
</script>