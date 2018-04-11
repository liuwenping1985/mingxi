<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<jsp:include page="/WEB-INF/jsp/apps/uc/conf/rong_config_groupinfo_js.jsp"></jsp:include>
<html class="over_hidden h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<style type="text/css">
	#searchHTML input,#searchHTML textarea{
		width:500px;
		padding-left:5px;
	}
	#searchHTML textarea {
		height: 44px;
	}
	#searchHTML button{
		 margin: auto;
	}
	#searchHTML table th {
		text-align: right;
	}
	.table{
		margin:auto;
	}
</style>
</head>
<body class="over_hidden h100b">
	<div id='layout' class="comp" comp="type:'layout'">
	    <!-- <div class="comp" comp="type:'breadcrumb',code:'T01_i18nresource'"></div> -->
		<div class="layout_north" layout="height:40,sprit:false,border:false">
			<div id="toolbar"></div>
            <div id="searchDiv"></div>
		</div>
		<div id='layoutCenter' class="layout_center over_hidden" layout="border:true">
			<table id="mytable" class="mytable" style="display: none"></table>	
		</div>  
	</div>
</html>