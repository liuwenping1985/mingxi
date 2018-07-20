<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b" style="${transparentStyle}">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=calEventManager"></script>
<script type="text/javascript" src="${path}/apps_res/calendar/js/showTimeLineData.js"></script>
<script type="text/javascript" src="<c:url value='/apps_res/project/js/projectSpace.js${v3x:resSuffix()}'/>"></script>
<style>
  .stadic_head_height{
    height:70px;
  }
  .stadic_body_top_bottom{
    top: 85px;
    bottom: 0px;
  }
</style>
<title>项目空间</title>
</head>
<body class="h100b" style="${transparentStyle}overflow-x:auto;overflow-y:hidden;">
	<div class="stadic_layout  over_hidden" style="overflow: hidden;">
		<div class="stadic_layout_head stadic_head_height banner-layout">
			<div class="portal-layout-cell">
				<input type="hidden" id="projectId" value="${project.id }"/>
				<input type="hidden" id="projectName" value="${ctp:toHTML(project.projectName )}"/>
				<input type="hidden" id="from" value="${from}"/>
				<iframe onload="init_location4roject();projectHeadListener()" src="${headUrl}" id="head" name="head" frameborder="0" allowtransparency="true" class="w100b h100b" style="position:absolute;"></iframe>
			</div>
		</div>
		<div class="stadic_layout_body stadic_body_top_bottom clearfix">
			<iframe onload="projectBodyListener()" src="${bodyUrl}" id="body" name="body" frameborder="0" allowtransparency="true" class="w100b h100b" style="position:absolute;"></iframe>
		</div>
	</div>
</body>
<script>
</script>
</html>