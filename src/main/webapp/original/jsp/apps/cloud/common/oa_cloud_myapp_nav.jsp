<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
		<!--导航-->
		<div class="m_rightNav">
			<ul class="ul cf">
				<c:choose>
					<c:when test="${tab eq 'c'}">
						<li attr_name="c" class="selected first">我的收藏</li>
					</c:when>
					<c:otherwise>
						<li attr_name="c" class="first">我的收藏</li>
					</c:otherwise>
				</c:choose>
				<li attr_name="b">已购买</li>
				<c:choose>
					<c:when test="${tab eq 'i'}">
						<li attr_name="i" class="selected">已导入</li>
					</c:when>
					<c:otherwise>
						<li attr_name="i">已导入</li>
					</c:otherwise>
				</c:choose>
				<c:if test="${oa_is_manager eq '1'}">
					<li attr_name="o">单位应用</li>
				</c:if>
			</ul>
		</div>
