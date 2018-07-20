<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<body class="h100b over_hidden">
  <!-- 项目任务－查看页－内容 -->
  <div id="taskDetailInfo">
  <!-- 项目任务－查看页－任务树 -->
  <div class="projectTask_detail_taskTree">
    <div class="head_area clearfix">
      <span class="title">${ctp:i18n('taskmanage.tree')}</span>
      <span class="taskClose"><em class="ico24 close_24" onclick="javascript:closeTreePage()"></em></span>
    </div>
    <div class="body_area">
    	<div id="onlyTree" class="clearfix"></div>
    	</div>
  	</div>
  </div>
</body>
<script type="text/javascript" src="${path}/ajax.do?managerName=taskDetailTreeManager"></script>
<script type="text/javascript" src="<c:url value='/apps_res/taskmanage/js/taskTreePage.js${v3x:resSuffix()}'/>"></script>
<script type="text/javascript">
	  //任务id
	  var taskId="${taskId}";
	  $(function () {
	  		//加载树
            initTree(eval(${taskTreeData}));
        })
</script>
</html>