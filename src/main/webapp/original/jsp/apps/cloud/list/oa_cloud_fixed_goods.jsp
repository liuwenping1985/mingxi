<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
		<li class="li">
			<div class="m_list_imgDiv">
				<img src="${mall_ip}/${fixedGoods.original_img}" class="img" />
			</div>
			<div class="m_list_bottom">
				<h2 class="ellip" title="${fixedGoods.goods_name}">${fixedGoods.goods_name}</h2>
				<div class="num">
					<img src="${path}/${resources_cloud_img}/icon/eye.png" class="icon">${fixedGoods.click_count}</div>
			</div>
			<div class="m_list_bg">
				<div class="bg"></div>
				<!-- 收藏 -->
				<c:choose>
					<c:when test="${fixedGoods.is_collect eq 1}">
						<button class="m_starbtn checked" g_id="${fixedGoods.goods_id}"
							title="${fixedGoods.collect_msg}">
							<!--等待中loading,选中checked-->
							<i class="icon"></i>
						</button>
					</c:when>
					<c:otherwise>
						<button class="m_starbtn" g_id="${fixedGoods.goods_id}"
							title="${fixedGoods.collect_msg}">
							<!--等待中loading,选中checked-->
							<i class="icon"></i>
						</button>
					</c:otherwise>
				</c:choose>
				<!-- 详情 -->
				<div class="m_detailbtnDiv">
					<i class="m_detailbtn" g_id="${fixedGoods.goods_id}" obj_flag="${fixedGoods.goods_id}_${fixedGoods.simple_tab_name}"></i>
				</div>
			</div>
		</li>
