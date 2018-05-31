<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
    <link rel="stylesheet" href="${path}/common/all-min.css${ctp:resSuffix()}">
	<link rel="stylesheet" href="${path}/main/frames/desktop/index.css" />
    <link rel="stylesheet" href="${path}/main/skin/desktop/${ctp:toHTML(skinPathKey)}/default.css${ctp:resSuffix()}">
    <link rel="stylesheet" href="${path}/decorations/css/jquery-ui.custom.css${ctp:resSuffix()}">
	<!--<script type="text/javascript" src="${path}/common/js/jquery-debug.js"></script>-->
	<!--<script type="text/javascript" src="${path}/decorations/js/jquery-ui.custom.js"></script>-->
    <script type="text/javascript" src="${path}/decorations/js/jquery.metadata.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" src="${path}/decorations/js/jquery-ui.custom.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" src="${path}/main/frames/desktop/js/sort.js"></script>
    <!--<script type="text/javascript" src="${path}/main/frames/desktop/js/jquery-ui.js"></script> -->
    <script type="text/javascript" src="${path}/main/frames/desktop/index.js"></script>
	<script type="text/javascript" src="${path}/main/frames/desktop/js/desktop-ajax.js"></script>
	<script type="text/javascript" src="${path}/main/common/js/frame-ajax.js${ctp:resSuffix()}"></script>
    <script>
    //需要刷新的缓存集合
    var refreshPortletArray =  new Array();
    refreshPortletArray.push("GroupImageNews");//集团图片新闻
    refreshPortletArray.push("AccountImageNews");//单位图片新闻
    refreshPortletArray.push("sendManagerPortlet");//发文管理 
    refreshPortletArray.push("waitSendPortlet");//待发事项 
    refreshPortletArray.push("workingTaskPortlet");//工作任务 
    refreshPortletArray.push("trackPortlet");//跟踪事项 
    refreshPortletArray.push("meetingPendingPortlet");//待开会议 
    refreshPortletArray.push("signReportPortlet");//签报管理 
    refreshPortletArray.push("recManagerPortlet");//收文管理 
    refreshPortletArray.push("edocSupervisePortlet");//公文督办 
    refreshPortletArray.push("pendingPortlet");//待办事项 
    refreshPortletArray.push("supervisePortlet");//督办事项 
    refreshPortletArray.push("infoMagazinePublishPortlet");//待发布期刊 
    refreshPortletArray.push("infoWaitAuditPortlet");//待审核信息 
    refreshPortletArray.push("infoWaitSendPortlet");//待发 
    refreshPortletArray.push("infoMagazineWaitAuditPortlet");//待审核期刊 
    refreshPortletArray.push("edocExchangePortlet");//公文交换 
    //皮肤标记
    var skinPathKey = '${ctp:toHTML(skinPathKey)}';
    //初始化是否显示工作桌面
    var initShowDeskTop = false;
	var currentTemplate = getCtpTop().$.ctx.template[0].id;
    //当前正在编辑的容器Id
	var currentLayoutId;
    //当前正在编辑的容器Portlet排序
    var currentPortletOrder;
    //当前分类Id
    var currentDeskCateId;
    //快捷库分类下拉对象
    var metroCategoryDropdown = null;
    //编辑状态标记
    var portletState = "show";
	var deskMgr = new deskManager();
	
	var deskCateList = <c:out value="${deskCateList}" default="null" escapeXml="false"/>;
    var dataCount = "4";
	//var pendingList = <c:out value="${pendingList}" default="null" escapeXml="false"/>;
    //全局变量，用来显示分类
	var category = {};
	//全局变量，用来显示当前桌面添加的快捷
    var addedPortletList = new Array();
	function showPendingList(){
		getCtpTop().showMenu(_ctxPath+"/collaboration/pending.do?method=morePending",null,null,"main");
		getCtpTop().$(".return_ioc2").click();
	}
    </script>
</head>
<body class="h100b over_hidden">
<div id="desktop_body_box">
<div id="desktop_body" class="desktop_body">
    <div class="stadic_layout">
        <div id="desktop_stadic_layout_head" class="stadic_layout_head stadic_head_height">
            <div class="headArea clearfix">
                <ul id="sortTabArea" class="sortTabArea left">
                    <!--<li class="current text_overflow">最常使用</li>
                    <li class="text_overflow">SAP应用</li>
                    <li class="text_overflow">小工具</li>-->
                    <li noclick="true" class="addBtn"><span class="desktop_icon24 shortcutModify_24"></span></li>
                </ul>
                <div class="homePage">
                    <div class="homePage_box">
                        <span id="setHomepage" class="setHomepage hand">${ctp:i18n("desk.txt.sethomepage")}</span>
                        <span id="skin" title="${ctp:i18n('desk.skin.name')}" class="skin desktop_icon24 addSort_24 margin_l_10" ></span>
                        <span id="editBtn" title="${ctp:i18n('desk.skin.edit')}" class="editBtn desktop_icon24 skin_24 margin_l_10"></span>
                    </div>
                    <div class="homePage_bg"></div>
                </div>
                <div class="headArea_bg">&nbsp;</div>
            </div>
        </div>
        <div id="desktop_stadic_layout_body" class="stadic_layout_body stadic_body_top_bottom">
            <div id="desktop_body_area" class="desktop_body_area clearFlow" style="width: 3000px;">
				<!-- 待办列表 -->
                <%-- <div id="toDoList" class="toDoList">
                    <div class="toDoList_box">
                        <ul id="pendingList" class="toDoList_item">
                        </ul>
                        <div class="chuli_area clearFlow">
                            <span class="chuli_text hand" onclick="showPendingList();">${ctp:i18n('common.my.pending.title')}</span>
                            <span class="chuli_area_num hand" onclick="showPendingList();">23</span>
                        </div>
                    </div>
                    <div class="toDoList_bg">&nbsp;</div>
                </div> --%>
                <!-- 待办列表 dialog -->
                <!-- <div class="toDoListDialog">

                </div> -->
                <!-- 快捷区域 -->
                 
            </div>
        </div>
    </div>
    <div class="metroShortAddDialog">
        <div class="stadic_layout">
            <div class="stadic_layout_head stadic_head_height">
                <div class="metroShortAddDialog_title">
                    <span class="left">${ctp:i18n("desk.metro.all")}</span>
                    <span class="dialogCloseBtn hand"></span>
                </div>
                <div class="metroShortAddDialog_search">
                    <span class="metroShortAddDialog_search_nav" style="width:100px">
                        <select id="metroCategory" class="common_drop_down">
                        	<c:forEach items="${metroCategoryList}" var="categroy">
                        		<c:if test="${categroy == 'PortletCategory'}">
		                            <option value="PortletCategory">${ctp:i18n("desk.metro.col")}</option>
                        		</c:if>
                                <c:if test="${categroy == 'BusinessAppCategory'}">
                                    <option value="BusinessAppCategory">${ctp:i18n("desk.metro.business")}</option>
                                </c:if>
                                <c:if test="${categroy == 'ThirdPartyProducts'}">
                                    <option value="ThirdPartyProducts">${ctp:i18n("desk.metro.thirdpartyproducts")}</option>
                                </c:if>
                        		<c:if test="${categroy == 'PortletAppCategory'}">
		                            <option value="PortletAppCategory">${ctp:i18n("desk.metro.Integrate")}</option>
                        		</c:if>
                        	</c:forEach>
                        </select>
                    </span>
                    <div class="metroShortAddDialog_search_textbox">
                        <span class="ico16" id="metroShortSearch"></span><input id="metroShortAddDialog_search_textbox" type="text" name="name" value="${ctp:i18n('desk.alert.searchtip')}" />
                    </div>
                </div>
            </div>
            <div class="stadic_layout_body stadic_body_top_bottom clearfix">
                <div class="stadic_right">
                    <div class="stadic_content scrollAuto">
                        <!-- 快捷库 所有 -->
                        <div class="roundabout_area scrollAuto">
                                <ul id="roundabout">
                                    
                                </ul>
                        </div>
                        <div id="metroShortAddDialog_itemList" class="metroShortAddDialog_itemList"></div>
                    </div>
                </div>
                <div class="stadic_left scrollAuto">
                    <!-- 左侧导航 -->
                    <ul id="metroShortAddDialog_navList" class="metroShortAddDialog_navList"></ul>
                </div>
            </div>
        </div>	
    </div>
    <div class="metroShortAddDialog_mask"></div>
</div>
    <img id="desktop_body_bg" class="desktop_body_bg" src="${path}/main/skin/desktop/${ctp:toHTML(skinPathKey)}/images/skin/desktop_default.jpg" defaultsrc="${path}/main/skin/desktop/${ctp:toHTML(skinPathKey)}/images/skin/desktop_default.jpg" width="100%" height="100%" />
</div>
</body>
</html>
