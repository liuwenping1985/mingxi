
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/form/common/common.js.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/form/design/formDevelopmentOfadv.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>流程仿真</title>
    <script type="text/javascript" src="${path}/ajax.do?managerName=simulationManager"></script>
    <script type="text/javascript" charset="UTF-8" src="${path}/common/workflow/simulation/js/list.js${ctp:resSuffix()}"></script>
    <script type="text/javascript">
    	//流程模板id
    	var templateId = "${param.templateId}";
    </script>
</head>
<body>
	
    <div id='layout' comp="type:'layout',border:false">
        <div class="layout_north bg_color" id="north">
            <div id="toolbars" class="f0f0f0"> </div>  
        </div>
        <div class="layout_center over_hidden" id="center">
            <table   id="list"></table>
        </div> 
    </div>
</body>
</html>
