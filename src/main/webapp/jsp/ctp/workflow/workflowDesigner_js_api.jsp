<%--
/**
 * $Author: wangchw $
 * $Rev: 38538 $
 * $Date:: 2014-06-14 08:22:22#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
 --%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.workflow.event.WorkflowEventManager"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<script type="text/javascript">
  var _wfctxPath = '<%=request.getContextPath()%>';
  var _ctxPath = '<%=request.getContextPath()%>';
  var _wfcurrentUserId = '<%=AppContext.currentUserId()%>'+'';
  var hasWorkflowEvent = '<%=!WorkflowEventManager.isEmptyEventMangerMap()%>';
</script>
<script type="text/javascript" src="<%=request.getContextPath() %>/common/workflow/workflowDesigner_ajax.js${ctp:resSuffix()}"></script>
<%
    if (AppContext.isRunningModeDevelop()) {//开发态
%>
<script type="text/javascript" src="<%=request.getContextPath() %>/common/workflow/workflowDesigner_api.js${ctp:resSuffix()}"></script>
<%
    }else{//生产态，对js进行压缩
%>
<script type="text/javascript" src="<%=request.getContextPath() %>/common/workflow/workflowDesigner_api-min.js${ctp:resSuffix()}"></script>
<%
    }
%>
