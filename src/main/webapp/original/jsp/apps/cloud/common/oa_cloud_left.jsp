<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
		<div class="m_content_left">
			<ul class="m_content_leftNav">
				<a href="mallindex.do?method=index">
					<c:choose>
						<c:when test="${oa_cloud_is_index eq 'INDEX'}">
							<li class="ellip selected">
						</c:when>
						<c:otherwise>
							<li class="ellip">
						</c:otherwise>
					</c:choose>
						<i class="icon" style="background-image:url(${path}/${resources_cloud_img}/icon/left_nav1.png)"></i>
						广场
					</li>
				</a>
				<c:forEach items="${categoryList}" var="category">
					<!-- 第三方插件 -->
					<c:if test="${category.belong_type eq 'THIRD-PARTY'}">
						<a href="mallindex.do?method=channel&c_id=${category.cat_id}">
					</c:if>
					<!-- 服务 -->
					<c:if test="${category.belong_type eq 'SERVICE'}">
						<a href="mallindex.do?method=service&c_id=${category.cat_id}">
					</c:if>
					<!-- 普通分类 -->
					<c:if test="${category.belong_type eq 'COMMON'}">
						<a href="mallindex.do?method=category&c_id=${category.cat_id}">
					</c:if>
					<!-- 按属性分类 -->
					<c:if test="${category.belong_type eq 'ATTRIBUTE'}">
						<a href="mallindex.do?method=attribute&attr_id=${category.filter_attr}">
					</c:if>
						<c:choose>
							<c:when test="${oa_category_cid eq category.cat_id}">
								<li class="ellip selected">
							</c:when>
							<c:otherwise>
								<li class="ellip">
							</c:otherwise>
						</c:choose>
							<i class="icon" style="background-image:url(${mall_ip}/${category.cat_upload_image})"></i>
							${category.cat_name}
						</li>
					</a>
				</c:forEach>
			</ul>
		</div>
