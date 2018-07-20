<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/info_header.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>信息报送应用设置</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script>
$(document).ready(function () {
	$("div.layout_center").height($("#layout").height());
	$("div.layout_west").height($("#layout").height());
	
	//IE7西面组件显示有问题
	if($("#westSp_layout")!=null) {
		$("#westSp_layout").height($("#layout").height());
		var tableEl = $("#westSp_layout").find("table").eq(0);
		if(tableEl){
			var tempHeight = $("#layout").height();
			tableEl.css("margin-top", (tempHeight - 54)/2);
		}
	}
	
	//收起首页左导航
	if(getCtpTop() && getCtpTop().$.hideLeftNavigation) {
		getCtpTop().$.hideLeftNavigation();
	}
	
	//IE7下可能导致Iframe宽度未加载完成的情况下，内部html已经进行加载了
	$("#tab_iframe").attr("src", "${rightUrl}");
	
});

</script>
</head>
<body class="h100b over_hidden">
<div id='layout' class="comp over_hidden" comp="type:'layout'">
	<div class="layout_center over_hidden">
		<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'${resCode_2 }'"></div>
		<iframe id="tab_iframe" width="100%" height="100%" frameborder="0"></iframe>
	</div>
	<c:if test="${hasLeft }">
	<div class="layout_west over_hidden" layout="width:140,minWidth:50,maxWidth:140,spiretBar:{show:true,handlerL:function(){$('#layout').layout().setWest(0);},handlerR:function(){$('#layout').layout().setWest(130);}}" style="border:none;">
		<jsp:include page="/WEB-INF/jsp/apps/${leftUrl }.jsp" flush="true" />
	</div>
	</c:if>
</div>

</body>
</html>
