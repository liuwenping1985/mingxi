<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>仿真报告</title>
<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
</head>
<body>
<div id='layout'>
    <div class="layout_north bg_color" id="north">
        <div id="toolbars" class="f0f0f0"> </div>  
    </div>
    <div class="layout_center over_hidden" id="center">
        <table  class="flexme3" id="list"></table>
        <div id="grid_detail" class="h100b">
            <iframe id="reportDetail" name='reportDetailF' width="100%" height="100%" frameborder="0"  class='calendar_show_iframe' style="overflow-y:hidden"></iframe>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
<script type="text/javascript" src="${path}/common/workflow/simulation/js/listReports.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
   var simulationId = "${simulationId}";
</script>
</body>
</html>