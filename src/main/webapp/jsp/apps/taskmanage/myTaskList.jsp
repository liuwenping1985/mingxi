<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/plan/reference/planReferList.js.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>指定任务</title>
</head>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/dataUtil.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/taskmanage/js/myTaskList.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
    $(document).ready(function() {
        initSearchDiv();
        initData();
        var pv = getA8Top().paramValue;
        if(pv != null && pv.length > 0){
            var taskId = pv.split(",");
            for(var i = 0;i < taskId.length;i ++){
                $("input[value='"+taskId[i]+"']").attr("checked", true); 
            }
        }
    }); 
</script>
<body>
 	<div id='layout' class="comp page_color" comp="type:'layout'">
        <div id="north" class="layout_north" layout="height:30,sprit:false,border:false">
            <div id="toolbar"></div>
        </div>
        <div id="center" class="layout_center page_color over_hidden" layout="border:false">
            <table id="taskInfoList" class="flexme3" style="display: none"></table>
        </div>
   	</div>
</body>
</html>