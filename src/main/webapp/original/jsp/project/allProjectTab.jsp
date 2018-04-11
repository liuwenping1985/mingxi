<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=projectQueryManager"></script>
<script type="text/javascript" src="<c:url value='/apps_res/project/js/relateProject.js${v3x:resSuffix()}'/>"></script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
<script type="text/javascript">
	$(function(){
		loadHtml("${ptList}","${dataType}");
	})
</script>
</head>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="border:false,sprit:false,height:40,maxHeight:100,minHeight:40">
        </div>
       <div class="layout_center" id="center" layout="border:false" style="overflow: hidden;">
          <div class="padding_l_15 padding_r_15"><table class="flexme3" style="display: none" id="listStatistic"></table></div>
        </div>
    </div>
    </div>
</body>
</html>