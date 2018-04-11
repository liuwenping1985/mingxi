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
		<!--中间-->
		<div class="m_content">
			<!-- OA云左侧树 -->
			<%@ include file="../common/oa_cloud_left.jsp"%>
			<div class="m_content_right">
				<!--导航-->
				<div class="m_rightNav">
					<c:if test="${not empty categoryChildList}">
						<ul class="ul cf">
							<li c_id="${oa_category_cid}" class="selected first" id="category_child_all_id">全部</li>
							<c:forEach items="${categoryChildList}" var="categoryChild">
								<li c_id="${categoryChild.cat_id}">${categoryChild.cat_name}</li>
							</c:forEach>
						</ul>
					</c:if>
					
					<c:if test="${empty categoryChildList}">
						<ul class="ul cf">
							<li c_id="${oa_category_cid}" class="selected first" id="category_child_all_id">全部</li>
						</ul>
					</c:if>
				</div>
				<!--列表-->
				<ul class="m_list cf" id="cat_goods_list_ul">
					<c:forEach items="${goodsList}" var="goodsArray">
						<li class="li">
							<a href="${mall_ip}/goods.php?id=${goodsArray.goods_id}" target="_blank">
								<div class="m_list_imgDiv">
									<img src="${mall_ip}/${goodsArray.goods_original_img}" class="img" />
								</div>
							</a>
							<div class="m_list_content">
								<a href="${mall_ip}/goods.php?id=${goodsArray.goods_id}" target="_blank">
									<div class="title ellip" title="${goodsArray.goods_name}">
										${goodsArray.goods_name}
									</div>
								</a>
								<div class="bottom">
									<div class="price">
										<!-- 货币交易 -->
										<c:if test="${goodsArray.trade_type eq 1}">
											<c:choose>
												<c:when test="${goodsArray.shop_price_price_change eq '0'}">
													免费
												</c:when>
												<c:when test="${goodsArray.shop_price_price_change eq 0.01}">
													面议
												</c:when>
												<c:otherwise>
													${goodsArray.shop_price_price_change}元
												</c:otherwise>
											</c:choose>
											
										</c:if>
										<!-- 积分兑换 -->
										<c:if test="${goodsArray.trade_type eq 2}">
											<c:choose>
												<c:when test="${goodsArray.goods_integral_price gt 0}">
													${goodsArray.goods_integral_price}积分
												</c:when>
												<c:otherwise>
													免费
												</c:otherwise>
											</c:choose>
										</c:if>
									</div>
									<ul class="m_list_iconList cf">
										<li>
											<c:choose>
												<c:when test="${goodsArray.is_collect eq 1}">
													<i class="icon icon1 i_collect selected" g_id="${goodsArray.goods_id}"></i>
												</c:when>
												<c:otherwise>
													<i class="icon icon1 i_collect" g_id="${goodsArray.goods_id}"></i>
												</c:otherwise>
											</c:choose>
											<em>收藏</em>
										</li>
										<c:if test="${goodsArray.trade_type eq 1 && goodsArray.shop_price_price_change eq '0'}">
											<li><i class="icon icon2 i_import" g_id="${goodsArray.goods_id}" plg="${goodsArray.oa_adapte_plugin}" ftype="${goodsArray.up_file_type}" bbh="${goodsArray.oa_adapte_version}" cpx="${goodsArray.oa_adapte_product}"></i>
												<em>导入</em>
											</li>
										</c:if>
									</ul>
								</div>
							</div>
						</li>
					</c:forEach>
				</ul>
				
				<div class="m_listBottom">
					<!--加载更多-->
					<a href="${mall_ip}" target="_blank">
						<img src="${path}/${resources_cloud_img}/icon/bottom_img.png" class="logo" />
					</a>
				</div>
				
				<div>
					<input type="hidden" value="${oa_product}" id="oa_product_id" />
					<input type="hidden" value="${oa_version}" id="oa_version_id" />
					<input type="hidden" value="${oa_goods_page}" id="oa_goods_page_id" />
					<input type="hidden" value="${oa_goods_size}" id="oa_goods_size_id" />
					<input type="hidden" value="${oa_attribute_id}" id="oa_attribute_id" />
					<input type="hidden" value="${oa_page_count}" id="oa_page_count_id" />
					<input type="hidden" value="${oa_cloud_is_index}" id="oa_cloud_is_index_id" />
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
		
		$.scrollBottom(function(){
			console.log('滚动翻页');
		});
	</script>
</html>