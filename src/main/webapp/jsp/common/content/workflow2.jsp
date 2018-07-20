<%--
 $Author: wangwy $
 $Rev: 13277 $
 $Date:: 2014-06-17 11:22:48#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp"%>
<div id="workflow_definition" style="display: none">
<input type="hidden" id="workflow_data_flag" name="workflow_data_flag" value="WORKFLOW_SEEYON">
<input type="hidden" id="process_info_selectvalue">
<input type="hidden" id="process_message_data">
<input type="hidden" id="processChangeMessage">
<input type="hidden" id="process_event">
</div>
<script type="text/javascript">
  $.content.getWorkflowDomains = function(moduleType, domains) {
    if (!domains)
      domains = [];
    $("#workflow_definition #moduleType").val(moduleType);
    domains.push("workflow_definition");
    return domains;
  };

</script>