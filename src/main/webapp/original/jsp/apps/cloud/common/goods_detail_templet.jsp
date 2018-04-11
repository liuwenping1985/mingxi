<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

	<!--详情填出层-->
	<div class="detail_dialog none">
    	<div class="m_detailDialog">
        	<div class="imgBox">
                <ul class="imgs">
                    <!-- 相册列表 -->
                </ul>
            </div>
            <i class="imgLeft"></i>
            <i class="imgRight"></i>
            <i class="m_d_closeIcon closeIcon"></i>
            <ul class="imgDot">
			</ul>
            <!--底部-->
            <div class="m_d_bottom">
            	<div class="cf">
                	<div class="text lf">
                		<!-- 名称 -->
                    	<h2 class="ellip kaifa_g_name"></h2>
                    	<!-- 简介 -->
                        <p class="ellip kaifa_g_introduce"></p>
                    </div>
                    <div class="btns rf">
                    	<!-- 价格 -->
                    	<span class="price kaifa_g_price"></span>
                    	<!-- 收藏 -->
                    	<button class="m_starbtn kaifa_g_btn_collect"><i class="icon"></i></button>
                    	<!-- 导入 -->
                        <button class="m_btn1 kaifa_g_btn_import disabled" bbh="" cpx="" plg="">导入</button><!-- disabled -->
                        <!-- 去购买 -->
                        <button class="m_btn1 kaifa_g_btn_gobuy none">去购买</button><!-- 显示隐藏 none -->
                    </div>
                </div>
                <ul class="m_d_ul cf">
                	<!-- 查看次数 -->
                	<li>
                		<img src="${path}/${resources_cloud_img}/icon/eye.png" class="icon">
                		<span class="kaifa_g_click_num"></span>人查看
                	</li>
                	<!-- 下载/导入次数 -->
                    <li>
                    	<img src="${path}/${resources_cloud_img}/icon/lead.png" class="icon">
                    	<span class="kaifa_g_down_num"></span>人下载
                    </li>
                </ul>
            </div>
        </div>
    </div>