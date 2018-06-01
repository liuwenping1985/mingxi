<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
	<head>
	    <%@ include file="/main/common/frame_header.jsp" %>
	    <!-- 外部扩展的jsp页面加载到首页 -->
	    <c:forEach var="expandJSP" items="${ExpansionJsp}">
			<jsp:include page="${expandJSP}" />
		</c:forEach>
  
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>${pageTitle}</title>
		<link type="text/css" href="${path}/common/css/common-debug.css${ctp:resSuffix()}" rel="stylesheet" />
		<link type="text/css" href="${path}/main/frames/defaultV56/index.css${ctp:resSuffix()}" rel="stylesheet" />
		<c:if test="${CurrentUser.skin != null}">
		<link rel="stylesheet" href="${path}/skin/${CurrentUser.skin}/skin${CurrentUser.fontSize}.css${ctp:resSuffix()}">
		</c:if>
		<c:if test="${CurrentUser.skin == null}">
		<link rel="stylesheet" href="${path}/skin/default/skin${CurrentUser.fontSize}.css${ctp:resSuffix()}">
		</c:if>
		<link id="skinFrameCSS" type="text/css" href="${path}/main/skin/frame56/${skinPathKey}/default.css${ctp:resSuffix()}" rel="stylesheet" />
		<link id="portalMenuIconCSS" type="text/css" href="${path}/main/common/css/portal_menuIcon.css${ctp:resSuffix()}" rel="stylesheet" />
		<style>
		.nav_uc_left_main{
			width:70px;
			height:14px;
			white-space: nowrap;
			overflow: hidden;
			text-overflow: ellipsis;
			color:#414141;
			margin-top: 10px;
			margin-bottom: 4px;
		}
		.nav_uc_msg_sender{
			width:32px;
			height:32px;
			margin:0px 20px 0px 5px;
			color:#FFF;
		}
		.uc_tabs{
            padding: 0;
            height: 44px;
            line-height: 44px;
            +width: 324px;
            
        }
        .uc_tabs .uc_tabs_span{
            width: 50%;
            float: left;
            display: inline-block;
            text-align: center;
           
        }
        .uc_tabs_span{
           cursor:pointer;
        }
        .uc_tabs .normal{
            overflow: hidden;
            display: inline-block;
            position: relative;
            background: #C6E8F7;
        }
		 .uc_tabs .normal span{
			color:#000; 
		}
        .normal_span{
            position: relative;
        }
        .uc_tabs .current{
            background-color: #0484be;
        }
        .uc_tabs .current span{
            color: #fff;
        }
        .uc_tabs .space_item02 {
            font-size: 30px;
            color: #fff;
            position: absolute;
            top: 22px;
            right: 236px;
            z-index: 0;
        }
        .uc_tabs .space_item01 {
            font-size: 30px;
            color: #fff;
            position: absolute;
            top: 22px;
            right: 236px;
			z-index:0;
        }
        .uc_list,.dajia_list{
            z-index: 10;
            overflow: hidden;
            margin: 0;
            padding: 0;
            position: relative;
        }
       
        /*修改的css*/
		.msg_setting_ucMsg{
			background:#f1f1f1;
			border-top:none;
            position: relative;
		}
        .space_item02 {
            font-size: 30px;
            color: #fff;
            position: absolute;
            top: -20px;
            right: 200px;
            z-index: -1;
        }
         .space_item01 {
            font-size: 30px;
            color: #c6e8f7;
            position: absolute;
            top: -20px;
            right: 200px;
            z-index: 1;
        }
        .uc_container ul li{
            color: #000;
            cursor: pointer;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            display: block;
            width: 115px;
            /*height: 39px;*/
            height: 51px;
            padding:0px 12px;
			padding-bottom:5px;
            color: #000;
            cursor: pointer;
            /*padding-left: 20px;*/
            /*line-height: 56px;*/
        }
        .nav_uc_ico {
            width: 32px;
            height: 32px;
            /*margin: 9px 10px 0 5px;*/
            margin: 5px 10px 5px 0;
        }
         .nav_uc_num {
            display: inline-block;
            width: 30px;
            height: 17px;
            line-height: 17px;
            vertical-align: middle;
            -moz-binding: url("ellipsis.xml#ellipsis");
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            font-size: 12px;
            float: right;
            /*margin-right: 10px;*/
            background: #F63;
            -moz-border-radius: 7px;
            -khtml-border-radius: 7px;
            -webkit-border-radius: 7px;
            border-radius: 7px;
            color: #FFF;
            text-align: center;
            margin-top: 16px;
            margin-bottom: 5px;
        }
        .uc_container {
            width: auto;
            height: auto;
            position: absolute;
            z-index: 1000;
            background: #FFF;
            display: none;
            border: 1px solid #999;
            -moz-box-shadow: 0px 0px 10px #333;
            -webkit-box-shadow: 0px 0px 10px #333;
            box-shadow: 0px 0px 10px #333;
            /*padding: 1px;*/
            font-size: 12px;
            border-bottom: 4px solid #42B3E5;
            padding:0px;
        }
        .msg_setting_uc {
            float: left;
            text-align: center;
            color: #787878;
            font-size: 12px;
            /*width: 90px;*/
            width: 86px;
            height: 15px;
            text-shadow: 1px 1px 1px #FFF;
            cursor: pointer;
        }

		 .eb_open {
            margin: 10px 5px 0 5px;
        }
        
        .eb_ignore, .eb_all {
            margin-top: 10px;
        }
		</style>
        <script type="text/javascript" src="${path}/common/js/v3x-debug.js${ctp:resSuffix()}"></script>
        <script type="text/javascript" src="${path}/main/common/js/skinChange.js${ctp:resSuffix()}"></script>
        <script type="text/javascript">
        var i18n_toDefault = "${ctp:i18n('channel.button.toDefault')}";     
        var ajaxCalEventBean = new calEventManager();
        var ajaxTimeLineBean = new timeLineManager();
        var curUserID = "${CurrentUser.id}";
        var menucolorset = false;
        var _mainMenuId = "${mainMenuId}";
        var _clickMenuId = "${clickMenuId}";
        var _shortCutId = "${shortCutId}";
        var sectionTabColor = "#15a4fa";
        var sectionTabTextColor = "#d7e4f4";
        var hasAgent = "${hasAgent}";
        var isShowHr = "${ctp:hasPlugin('hr')}";
        var isA6s = "${ctp:getSystemProperty('system.ProductId') == 7}";
        var messageIntervalSecond = "${ctp:getSystemProperty('message.interval.second')}";
        var geniusRedirect = "${param.geniusRedirect}";
        var LoginOpenWindow = <%=BrowserFlag.LoginOpenWindow.getFlag(request)%>;        
        var _zoomParam = parseFloat("${zoomParam}") > 1? parseFloat("${zoomParam}") : 1;
        //大家Work消息集成
        var hasUC = false, hasEveryBody = false;
        <c:if test="${ctp:hasPlugin('uc') && !CurrentUser.admin}">
            hasUC = true;
        </c:if>
        <c:if test="${ctp:hasPlugin('everybodyWork') && !CurrentUser.admin}">
            hasEveryBody = true;
        </c:if>
        </script>
		<script type="text/javascript" src="${path}/main/frames/defaultV56/frount-debug.js${ctp:resSuffix()}"></script>
	</head>
	<body class="w100b h100b" style="background-image:none">
	    <div id="second_menu" class="second_menu_contaner clearfix"></div>
	    <iframe id="second_menu_iframe" class="menu_iframe"  frameborder="0"></iframe>
	    <iframe id="third_menu_iframe" class="menu_iframe"  frameborder="0"></iframe>
        <div class="shortcut_pop"></div>
        <iframe class="shortcut_iframe"  frameborder="0"></iframe>
		<div class="space_pop"></div>
        <iframe class="space_iframe"  frameborder="0"></iframe>
        <div class="pulldown"></div>
        <iframe class="pulldownIframe"  frameborder="0"></iframe>
        <div class="uc_container"></div>
        <iframe class="uc_iframe"  frameborder="0"></iframe>
        <div class="djwk_container"></div>
        <iframe class="djwk_iframe"  frameborder="0" ></iframe>
        <div class="person_container" ></div>
        <iframe class="person_iframe"  frameborder="0" ></iframe>
        <div id="account_container" class="account_container accountSelectorOptions"></div>
        <iframe class="account_iframe"  frameborder="0"></iframe>
		<iframe class="searchAreaIframe"  frameborder="0"></iframe>
		<!-- 屏蔽首页时间线 -->
		<!-- div id='dragSkin' class='dragSkinlowe'></div -->
        <div class="searchArea">
            <!-- 搜索 -->
            <a id="searchAreaAButton" class="searchAreaA hand">${ctp:i18n('advance.search.label')}</a>
            <input type='text' id="searchAreaInput" class='searchAreaInput'/>
            <div id="seachIconButton" class="seach_icon_button hand">${ctp:i18n('index.search.button')}</div>
            <div class="search_them1">◆</div>
            <div class="search_them2">◆</div> 
            <div id="searchClose" class="search_close"></div>
        </div>
    	<%--单位切换--%>
        <c:if test="${!CurrentUser.admin}">
          	<div id="accountSelector"  class="accountdiv left"></div>
        </c:if>
 		<div class="warp" style="background-image:none">
            <div class="layout_header" style="background-image:none">
            	<div class="area">
	                <div class="area_l left">
	                	<div class="logodiv left"><img id="logo"  height="48" src="" style="display:none"/></div>
	                    <div class="comdiv left" id="accountNameDiv">
	                    	<div class="comdiv_cn"></div>
	                        <div class="comdiv_en"></div>
	                    </div>
	                </div>
	                <div class="area_r right">
		                	<c:choose>
		                		<c:when test="${!CurrentUser.admin}">
				                	<div class="area_r_images right">
				                		<%--切换到工作桌面--%>
				                		<c:if test="${ctp:getSystemProperty('system.ProductId') != 7 }">
                                        <a ><div title="${ctp:i18n('menu.workDesktop.label')}" class="return_ioc left"></div><div class="return_ioc2 left hidden"></div></a>
				                		<%--搜索--%>
                                        <a ><div title="${ctp:i18n('index.search.button')}" id="search_ico_id" class="search_ico searchButton left hand"></div></a>
                                        </c:if>
                                        <%--后退--%>
                                        <a ><div title="${ctp:i18n('seeyon.top.back.alt')}" id="backPage" class="back_ico left"></div></a>
                                        <%--前进--%>
                                        <a ><div title="${ctp:i18n('seeyon.top.forward.alt')}" id="forwardPage" class="forward_ico left"></div></a>
                                        
                                        <%--刷新--%>
                                        <a ><div title="${ctp:i18n('common.toolbar.refresh.label')}" id="refreshPage" class="f5_ioc left"></div></a>
                                        <%--消息--%>
                                        <c:if test="${ctp:hasPlugin('uc') && !CurrentUser.admin}">
                                        <a ><div title="${ctp:i18n('menu.ucMsg.label')}" id="ucMsg" class="msg_ioc left"><div id='ucMsg_point' class="point_more"></div></div></a>
                                        </c:if>
                                        <%--大家work
                                        <a ><div title="${ctp:i18n('menu.dajiawork.label')}" id="" class="dajia_work_ico left"><div id='dajia_point' class="point_more"></div></div></a>
                                        --%>
                                        <%-- <c:if test="${ctp:getSystemProperty('system.ProductId') != 3 && ctp:getSystemProperty('system.ProductId') != 4 && ctp:getSystemProperty('system.ProductId') != 0 && ctp:getSystemProperty('system.ProductId') != 7}">
                                        产品导航
                                        <a ><div title="${ctp:i18n('menu.productNavigation.label')}" id="productView_btn" class="main_ioc left"></div></a>
                                        </c:if> --%>
                                        <c:if test="${ctp:getSystemProperty('portal.porletSelectorFlag') eq 'A8'}">
                                        <a ><div id="about_ioc" title="${ctp:i18n('menu.tools.about')}" class="a8_${ctp:getSystemProperty('portal.about')}ioc left" onclick="startA8genius();"></div></a>
                                        </c:if>
                                        <c:if test="${ctp:getSystemProperty('portal.porletSelectorFlag') eq 'G6'}">
                                        <a ><div id="about_ioc" title="${ctp:i18n('menu.tools.about')}" class="g6_ioc left" onclick="startA8genius();"></div></a>
                                        </c:if>
                                        <c:if test="${ctp:getSystemProperty('portal.porletSelectorFlag') eq 'A6' or ctp:getSystemProperty('portal.porletSelectorFlag') eq 'A6s'}">
                                        <a ><div id="about_ioc" title="${ctp:i18n('menu.tools.about')}" class="a6_${ctp:getSystemProperty('portal.about')}ioc left" onclick="startA8genius();"></div></a>
                                        </c:if>
                                        <%--设置--%>
                                        <%--<div class="set_right_ico right"></div>--%>
                                        <a ><div title="${ctp:i18n('menu.setting.label')}" class="setting_ico left"></div></a>
			                            <div style="clear:both;"></div>
				                    </div>
									<div class="banner_line right"></div>
				                	<div class="area_r_icon right">
			                           
				                    </div>
			                        <div style="clear:both;"></div>
		                		</c:when>
		                		<c:otherwise>
			                		<div class="area_r_images right" style="border:0px;">
				                		<%--退出--%>
				                        <a ><div class="admin_exit_ico right"></div></a>
				                        <%--刷新--%>
			                            <a ><div id="homeIcon" class="f5_ioc1 right"></div></a>
			                             <%--帮助--%>
                                        <a ><div class="help_ioc right hand" id="helpIcon"></div></a>
			                			<div style="clear:both;"></div>
					                </div>
					                <c:if test="${CurrentUser.systemAdmin}">					                
									<div class="banner_line right"></div>
				                	<div class="area_r_icon right">
				                		<div class="nav_center" title="${ctp:i18n("portal.pingtaikeshihua.label")}" onclick="showPingTaiKeShiHua(this,'pingtaikeshihua');" iconName="menu_personal.png"><span class="nav_center_title">${ctp:i18n("portal.pingtaikeshihua.label")}</span><div id="_currentIco_pingtaikeshihua" class="nav_center_currentIco">&nbsp;</div></div>
				                    </div>
			                        <div style="clear:both;"></div>
			                        </c:if>
		                		</c:otherwise>
		                	</c:choose>
	                </div>
					<img id="layout_header_bg" class="layout_header_bg" src="${path}/main/skin/desktop/${skinPathKey}/images/skin/desktop_default.jpg" defaultsrc="${path}/main/skin/desktop/${skinPathKey}/images/skin/desktop_default.jpg" width="100%" height="100%" style="display:none;">
					<div id="layout_header_bg_mask" class="layout_header_bg_mask" style="display:none;">&nbsp;</div>
				</div>
            </div>
            <div id="layout_nav" class="layout_nav clearfix">
            	<div class="layout_nav_left clearfix">
            	
                      <c:choose>
                          <c:when test="${(CurrentUser.admin) == true}">
                          	   <div class="lineAdmin">
                              <div class="vst_online hand" id="vst_online">
                                  <span class="margin_l_5 margin_t_5 display_inline-block font_bold"></span>
                                  <span id="onlineNum_adm" name="onlineNum_adm">${onlineNumber}</span>${ctp:i18n('portal.onlineNum.label')}
                              </div>
                              </div>
                          </c:when>
                          <c:otherwise>
							<div class="avatar hand">
								<img src="" width="36" height="36">
							</div>
							<div class="vst_online hand"  id="vst_online">
								<div class="vst_online_box">
									<span id="vst_online_state">
										<em class="skin_ico16 online1"></em>
										<span class="padding_l_5"></span>
									</span>
									<span id="online_uc" style="cursor:pointer;">
										<span id="onlineNum" name="onlineNum">${onlineNumber}</span>
										${ctp:i18n('portal.onlineNum.label')}
									</span>
									<c:if test="${isCanSendSMS}">
									<span class="ico16 head_msg_16 margin_l_5" onclick="sendSMSV3X()"></span>
									</c:if>
									<c:if test="${cardEnabled == true }">
									<span id="onlineCard" class="ico16 head_online_16 margin_l_5" title="${ctp:i18n('menu.hr.personal.attendance.manager')}"></span>
									</c:if>
								</div>
							</div>
							<div class="vst_state" id="vst_state">
								<div class="vst_boxbg"></div>
								<a href="javascript:void(0)"  id="online1" value="0" class="vst_state_item vst_fun"><em class="skin_ico16 online1 margin_lr_5"></em>&nbsp;${ctp:i18n('portal.onlineState.label1')}</a>
								<a href="javascript:void(0)"  id="online2" value="1" class="vst_state_item vst_fun"><em class="skin_ico16 online2 margin_lr_5"></em>&nbsp;${ctp:i18n('portal.onlineState.label2')}</a>
								<a href="javascript:void(0)"  id="online3" value="2" class="vst_state_item vst_fun"><em class="skin_ico16 online3 margin_lr_5"></em>&nbsp;${ctp:i18n('portal.onlineState.label3')}</a>
								<a href="javascript:void(0)"  id="online4" value="3" class="vst_state_item vst_fun"><em class="skin_ico16 online4 margin_lr_5"></em>&nbsp;${ctp:i18n('portal.onlineState.label4')}</a>
							</div>
                          </c:otherwise>
                       </c:choose>

            	</div>
            	<div class="layout_nav_right" id="layout_nav_right">
            		<ul id="navUi" class="navUi">
            		    <c:if test="${(CurrentUser.admin) != true}">
	            			<li id="shortcutli" title="${ctp:i18n('portal.menu.shortcut.label')}"><a id="shortcutli_a" href="javascript:void(0)"></a></li>
	            			<c:if test="${hasAgent}">
	            				<li id="agentli"><a id="agentli_a" href="javascript:void(0)">${ctp:i18n('menu.personal.agent.label')}</a></li>
	            			</c:if>
            			</c:if>
            			<li id="mainNavLi">
            				<ul id="mainNavUi" class="mainNavUi" pager="1"></ul>
            			</li>
            			<li id="prevli"><em class="prev_em"></em></li>
            			<li id="nextli"><em class="next_em"></em></li>
            		</ul>
            	</div>
            </div>
            <div class="layout_content clearfix">
                <div class="layout_right">
                    <div class="layout_content_main">
				 		<div id="content_layout_body_left_content" class="layout_content_main_warp">
					        <div id="nowLocation" class="layout_location">
                            </div>
				            <div class="layout_content_main_content clearfix">
					           <iframe src="" id="main" name="main" frameborder="0"  allowTransparency="true" onload="setonbeforeunload()" class="w100b h100b" style="position:absolute;"></iframe>
                               <div class="noneDiv w100b h100b"></div>
				            </div>
				        </div>
                    </div>
                </div>
            </div>
        </div>
       <!-- 工作桌面代码start -->
       <iframe id="desktopIframe" width="100%" height="100%" src=""></iframe>
       <!-- 消息盒子播放声音 -->
       <iframe id="playSoundHelper" class="hidden" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
	</body>
	<script>
	
	</script>
</html>
