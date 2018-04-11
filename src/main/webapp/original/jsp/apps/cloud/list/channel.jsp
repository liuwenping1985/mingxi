<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="s" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="path" value="${pageContext.request.contextPath}" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<%@ include file="/main/common/frame_header.jsp" %>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link href="${path}/${resources_cloud_css}/common.css" rel="stylesheet" type="text/css" />
		<link href="${path}/${resources_cloud_css}/mall.css" rel="stylesheet" type="text/css" />
		<title>${mall_title}</title>
	</head>
	
	<body>
		<!-- OA云头部文件 -->
		<%@ include file="../common/oa_cloud_head.jsp"%>
		<div class="m_content">
			<!-- OA云左侧树 -->
			<%@ include file="../common/oa_cloud_left.jsp"%>
			<div class="m_content_right">
				<!--列表-->
				<div class="m_listDiv">
					<ul class="m_list cf" id="ad_list_ul">
						<c:forEach items="${adList}" var="ad">
							<a href="${ad.url}" target="_blank">
								<li class="li">
									<img src="${mall_ip}/${ad.img}" class="picture" obj_flag="${ad.id}_${ad.simple_tab_name}" obj_name="${ad.name}">
								</li>
							</a>
						</c:forEach>
					</ul>
				</div>
				<div class="m_listBottom">
					<!--加载更多-->
					<a href="${mall_ip}" target="_blank">
						<img src="${path}/${resources_cloud_img}/icon/bottom_img.png" class="logo" />
					</a>
				</div>
			</div>
		</div>
		
		<!-- 账户绑定 -->
		<%@ include file="../common/oa_cloud_bind.jsp"%>
    
        <!--导入遮罩层-->
        <div class="m_alert none" id="m_alert_id"></div>
		
		<!-- 底部及其他 -->
		<%@ include file="../common/oa_cloud_foot.jsp"%>
	</body>
	
	<%-- <script src="${path}/${resources_cloud_js}/jquery-1.8.3.min.js"></script> --%>
	<script src="${path}/${resources_cloud_js}/common.js"></script>
	<script src="${path}/${resources_cloud_js}/mall.js"></script>
    <script type="text/javascript" src="${path}/ajaxStub.js?v=<%=com.seeyon.ctp.common.SystemEnvironment.getServerStartTime()%>"></script>
    <script src="${path}/${resources_cloud_js}/bizCloudAppImport.js"></script>
    <script src="${path}/${resources_cloud_js}/bind.js"></script>
	<script src="${path}/${resources_cloud_js}/oacloud.js"></script>
	
	<script type="text/javascript">
	
	</script>
</html>