<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="${path}/apps_res/weixin/css/common.css"/>
<script type="text/javascript" language="javascript">
$().ready(function() {
	var mytable = $("#messageInfo").ajaxgrid({
	    colModel: [{
	      display: "部门",
	      name: 'deptName',
	      sortable: true,
	      width: '15%'
	    },
	    {
	      display: "岗位",
	      name: 'postName',
	      sortable: true,
	      width: '15%'
	    },
	    {
	      display: "登录名",
	      name: 'loginName',
	      sortable: true,
	      width: '15%'
	    },
	    {
	      display: "警告信息",
	      name: 'warnInfo',
	      sortable: true,
	      width: '50%'
	    }],
	    width: 'auto',
	    parentId: 'center',
	    usepager : false,
	    managerName: "weixinSetManager",
		managerMethod: "getWarnMemberInfo"
	});
	var o = new Object();
	o.corpId = "${corpId}";
	$("#messageInfo").ajaxgridLoad(o);
  
});

</script>
  
</head>
<body class="h100b over_hidden">
	<div id='layout' class="comp" comp="type:'layout'">
		<div class="layout_center over_hidden" layout="border:false" id="center">
			<div id="viewmembers">
				<table id="messageInfo" class="flexme3" border="0" cellspacing="0" cellpadding="0"></table>
			</div>
		</div>
	</div>
</body>
</html>