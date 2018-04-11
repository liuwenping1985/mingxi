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
				<!--图片切换-->
				<div class="i_imgBoxDiv">
					<div class="imgBox">
						<ul class="imgs">
							<c:forEach items="${marquees}" var="marquee">
								<li class="li">
									<a href="${marquee.ad_link}" target="_blank">
										<img src="${mall_ip}/${marquee.ad_img}" class="img" obj_flag="${marquee.ad_id}_${marquee.simple_tab_name}" obj_name="${marquee.ad_name}" />
									</a>
								</li>
							</c:forEach>
						</ul>
					</div>
					
					<div class="imgLeft">&lt;</div>
					<div class="imgRight">&gt;</div>
					<ul class="imgDot"></ul>
				</div>
				<!--导航-->
				<div class="i_title cf">
					<ul class="i_nav cf">
						<c:forEach items="${configTypeList}" var="ctype">
							<c:choose>
								<c:when test="${ctype.selected eq 1}">
								<li data="${ctype.alias}" class="index_li_w selected">${ctype.name}
								</c:when>
								<c:otherwise>
								<li data="${ctype.alias}" class="index_li_w">${ctype.name}
								</c:otherwise>
							</c:choose>
								<c:if test="${ctype.img ne ''}"><img src="${ctype.img}" class="icon"></c:if>
								</li>
						</c:forEach>
					</ul>
					<a href="${mall_ip}" class="more" target="_blank">查看更多</a>
				</div>
				
				
				
				
				
				
				
				<!-- ********************************************************************************* -->
				<div class="m_listDiv">
					<ul class="m_list cf" id="goods_list_ul">
						<!-- 固定广告 -->
						<c:forEach items="${product_ads}" var="ads">
							<a href="${ads.url}" target="_blank">
								<li class="li">
									<img src="${mall_ip}/${ads.img}" class="picture"  obj_flag="${ads.id}_${ads.simple_tab_name}" obj_name="${ads.name}">
								</li>
							</a>
						</c:forEach>
						
						<!-- 商品列表 -->
						<c:forEach items="${goodsList}" var="goodsArray">
							<li class="li">
								<div class="m_list_imgDiv">
		                            <img src="${mall_ip}/${goodsArray.goods_original_img}" class="img" />
		                        </div>
		                        <div class="m_list_bottom">
		                            <h2 class="ellip" title="${goodsArray.goods_name}">${goodsArray.goods_name}</h2>
		                            <div class="num"><img src="${path}/${resources_cloud_img}/icon/eye.png" class="icon">${goodsArray.click_count}</div>
		                        </div>
		                        <div class="m_list_bg">
		                        	<div class="bg"></div>
		                        	<!-- 收藏 -->
		                        	<c:choose>
										<c:when test="${goodsArray.is_collect eq 1}">
											<button class="m_starbtn checked" g_id="${goodsArray.goods_id}" title="${goodsArray.collect_msg}">
												<!--等待中loading,选中checked-->
												<i class="icon"></i>
				                            </button>
										</c:when>
										<c:otherwise>
											<button class="m_starbtn" g_id="${goodsArray.goods_id}" title="${goodsArray.collect_msg}">
												<!--等待中loading,选中checked-->
												<i class="icon"></i>
				                            </button>
										</c:otherwise>
									</c:choose>
		                            <!-- 导入 -->
		                            <c:if test="${(goodsArray.trade_type eq 1 && goodsArray.shop_price_price_change eq '0') && goodsArray.increment_type eq '1'}">
			                            <div class="m_btn1Div">
			                            	<c:choose>
			                            		<c:when test="${goodsArray.isEnableImportBtn eq 1}">
			                            			<button class="m_btn1" g_id="${goodsArray.goods_id}" plg="${goodsArray.oa_adapte_plugin}" ftype="${goodsArray.up_file_type}" bbh="${goodsArray.oa_adapte_version}" cpx="${goodsArray.oa_adapte_product}">
					                            		导入
					                            	</button>
			                            		</c:when>
			                            		<c:otherwise>
			                            			<button class="m_btn1 disabled" title="${goodsArray.msg_str}">
					                            		导入
					                            	</button>
			                            		</c:otherwise>
				                            </c:choose>
			                            </div>
			                        </c:if>
		                            <!-- 详情 -->
		                            <div class="m_detailbtnDiv">
		                            	<i class="m_detailbtn" g_id="${goodsArray.goods_id}" obj_flag="${goodsArray.goods_id}_${goodsArray.simple_tab_name}"></i>
		                            </div>
		                        </div>
							</li>
						</c:forEach>
					</ul>
				</div>
				<!-- ********************************************************************************* -->
				
				
				
				
				
				
				
				
				<div class="m_listBottom">
					<!--加载更多-->
					<%-- <span id="load_more_span">滚动鼠标加载更多...</span> --%>
					<a href="${mall_ip}" target="_blank">
						<img  id="go_mall" src="${path}/${resources_cloud_img}/icon/bottom_img.png" class="logo" />
					</a>
				</div>
				<div>
					<input type="hidden" value="${oa_product}" id="oa_product_id" />
					<input type="hidden" value="${oa_version}" id="oa_version_id" />
					<input type="hidden" value="${oa_goods_type}" id="oa_goods_type_id" />
					<input type="hidden" value="${oa_goods_page}" id="oa_goods_page_id" />
					<input type="hidden" value="${oa_goods_size}" id="oa_goods_size_id" />
					<input type="hidden" value="${oa_page_count}" id="oa_page_count_id" />
					<input type="hidden" value="${oa_cloud_is_index}" id="oa_cloud_is_index_id" />
				</div>
			</div>
		</div>
    	
		<!-- 账户绑定 -->
		<%@ include file="../common/oa_cloud_bind.jsp"%>
		
		<!-- 弹出层商品详情 -->
		<%@ include file="../common/goods_detail_templet.jsp"%>
		
		<!--导入遮罩层-->
		<div class="m_alert none" id="m_alert_id"></div>
		
		<!-- 底部及其他 -->
		<%@ include file="../common/oa_cloud_foot.jsp"%>
		
	</body>
	<script type="text/javascript">
	//var bizDataManager1 = new bizDataManager();
	var currentUserId = "${currentUserId}";

	</script>
	<%-- <script src="${path}/${resources_cloud_js}/jquery-1.8.3.min.js"></script> --%>
	<script src="${path}/${resources_cloud_js}/common.js"></script>
	<script src="${path}/${resources_cloud_js}/mall.js"></script>
    <script type="text/javascript" src="${path}/ajaxStub.js?v=<%=com.seeyon.ctp.common.SystemEnvironment.getServerStartTime()%>"></script>
    <script src="${path}/${resources_cloud_js}/bizCloudAppImport.js"></script>
    <script src="${path}/${resources_cloud_js}/bind.js"></script>
	<script src="${path}/${resources_cloud_js}/oacloud.js?20170324"></script>
	<script type="text/javascript">
	
		mall.index();
		
		/**滑动到底部执行**/
		$.scrollBottom(function(){
			
			if (_flip_page) {
				_flip_page = false;
				
				var nowPage = $('#oa_goods_page_id').val();
				var pageCount = $('#oa_page_count_id').val();
				
				var nextPage = parseInt(nowPage) + 1;
				if (nextPage > pageCount) {
					return;
				}
				
				flipIndexPage();
			}
		});
		
	</script>
</html>