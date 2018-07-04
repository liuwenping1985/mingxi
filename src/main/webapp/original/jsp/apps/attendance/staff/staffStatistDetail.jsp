<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
 	<link rel="stylesheet" type="text/css" href="${path}/apps_res/attendance/css/common.css${ctp:resSuffix()}"/>
	<link rel="stylesheet" type="text/css" href="${path}/apps_res/attendance/css/index.css${ctp:resSuffix()}"/>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <style>
    	.body{font-size:12px;}
        .stadic_head_height{ height:30px;}
        .stadic_body_top_bottom{ bottom: 0px;top: 30px;}
        .classification{background-color:#fff;}
    </style>
</head>
<body class="h100b over_hidden">
    <div class="stadic_layout">
        <div class="classification h100b">
            <div class="list h100b">
	          <div class="button_box clearfix h100b" id="statistDetailTable-parent">
	              <table id="statistDetailTable" style="display: none"></table>
	          </div>
      		</div>
        </div>
    </div>
</body>
<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
<script type="text/javascript" src="${path}/common/js/laytpl.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/attendance/js/staffStatistDetail.js${ctp:resSuffix()}"></script>
</html>

