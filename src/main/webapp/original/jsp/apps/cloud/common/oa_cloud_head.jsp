<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link href="${path}/skin/default/skin.css" rel="stylesheet" type="text/css" />
		<!--头部-->
		<div class="m_header">
			<a href="mallindex.do?method=index">
				<div class="m_header_logo">
					<img src="${path}/${resources_cloud_img}/icon/logo.png" class="img" />
				</div>
			</a>
			<div class="m_header_right">
				<!--搜索-->
				<div class="m_header_search">
					<div class="m_search">
						<form name="search_form_name" method="post" action="mallindex.do?method=search">
							<input type="text" class="input" placeholder="大家正在搜索：${hotSearchKeyWords}" k_words="${hotSearchKeyWords}" id="search_input_content"/>
							<i class="searchIcon" id="i_search_btn"></i>
						</form>
					</div>
				</div>
				
				<ul class="m_header_topNav cf">
					<c:choose>
						<c:when test="${oa_cloud_is_index eq 'INDEX'}">
							<li class="selected kfcs_boutique">
								<i class="icon" style="background-image:url(${path}/${resources_cloud_img}/icon/top_nav1.png)"></i>
								精品应用
							</li>
							<li class="kfcs_myapp">
								<i class="icon" style="background-image:url(${path}/${resources_cloud_img}/icon/top_nav2.png)"></i>
								我的应用
							</li>
						</c:when>
						<c:when test="${oa_cloud_is_index eq 'MYAPP'}">
							<li class="kfcs_boutique">
								<i class="icon" style="background-image:url(${path}/${resources_cloud_img}/icon/top_nav1.png)"></i>
								精品应用
							</li>
							<li class="selected kfcs_myapp">
								<i class="icon" style="background-image:url(${path}/${resources_cloud_img}/icon/top_nav2.png)"></i>
								我的应用
							</li>
						</c:when>
						<c:otherwise>
							<li class="selected kfcs_boutique">
								<i class="icon" style="background-image:url(${path}/${resources_cloud_img}/icon/top_nav1.png)"></i>
								精品应用
							</li>
							<li class="kfcs_myapp">
								<i class="icon" style="background-image:url(${path}/${resources_cloud_img}/icon/top_nav2.png)"></i>
								我的应用
							</li>
						</c:otherwise>
					</c:choose>
				</ul>
				
				<!--用户-->
				<div class="m_header_user">
					<div class="userinfo cf">
						<img src="${oa_user_head_img}" class="userImg">
						<span class="username ellip">${oa_user_name}</span>
						<i class="dRowIcon"></i>
					</div>
					<ul class="userMsg">
						<li class="kf_myself">个人中心</li>
						<c:if test="${oa_is_manager eq '1'}">
						<li class="kf_checkService">服务进度查看</li>
						</c:if>
						<c:if test="${userIsBind eq '1'}">
						<li class="kf_rebind">重新绑定</li>
						</c:if>
					</ul>
	            </div>
			</div>
		</div>
		<div><input type="hidden" value="${userIsBind}" id="u_bind_val"></div>
		<div><input type="hidden" value="${mall_ip}" id="u_mall_url"></div>
		<div><input type="hidden" value="${nowPathUrl}" id="now_path_url_id"></div>
		<div><input type="hidden" value="${oa_is_manager}" id="u_is_m_val"></div>
		<div><input type="hidden" value="${oa_is_from_manager}" id="u_is_f_a_val"></div>
		 
		<div id="contain">
		<iframe id="iframe_hidden" src="${iframeUrl}" style="display:none"></iframe>
		</div>
