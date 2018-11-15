<%--
 $Author: 黄奎 $
 $Rev: 9416 $
 $Date:: 2016-12-02 12:46:11#$:
  
 Copyright (C) 2016 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n("form.business.relationship.diagram")}</title>
</head>
    
    <!-- 获取服务器端返回的参数值 -->
	<script type="text/javascript">
    	var formId = "${formId}";
		var basePath = "${path}";
    	
    	//制作表单间逻辑关系视图，暂时屏蔽掉设计模式不断向后台服务器发连接请求，以后再做表单设计器的时候在考虑放开
    	var autoCommit = false;//是否自动提交设计模板数据到服务器
    	
        var chartId = "52c5096c0cf22b592924695d";
		var pageWidth = $(window).width();
		var pageHeight = $(window).height();
        var definition = {"page":{"width":pageWidth,"padding":2,"height":pageHeight,"backgroundColor":"245,245,245","showGrid":false,"gridSize":15},"elements":{}};

        var role = "owner";
        var userId = "521dcb690cf20afe916bb48f";
        var userName = "softfn";
        var time = "1388644792184";
    </script>
    
    <!-- HK定义的关系图工具类引用 -->
    <link href="${path}/common/form/relation/chart/themes/default/global.css${ctp:resSuffix()}" rel="stylesheet" />
    <script type="text/javascript" src="${path}/common/form/relation/chart/js/relation.util_min.js${ctp:resSuffix()}"></script>
   	
    <link href="${path}/common/form/relation/chart/themes/default/diagraming/designer.css${ctp:resSuffix()}" rel="stylesheet" />
    <link href="${path}/common/form/relation/chart/themes/default/diagraming/ui.css${ctp:resSuffix()}" rel="stylesheet" />
    
    
    <!-- HK定义的关系图组件的引用 -->
    <script type="text/javascript" src="${path}/common/form/relation/chart/js/diagraming/schema/relation.schema_min.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" src="${path}/common/form/relation/chart/js/diagraming/schema/categories/form_relation.js${ctp:resSuffix()}"></script>
    
    <!-- HK开发的关系图内核模块的引用 -->
    <script type="text/javascript" src="${path}/common/form/relation/chart/js/diagraming/relation.collaboration_min.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" src="${path}/common/form/relation/chart/js/diagraming/relation.core_min.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" src="${path}/common/form/relation/chart/js/diagraming/relation.methods_min.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" src="${path}/common/form/relation/chart/js/diagraming/relation.events_min.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" src="${path}/common/form/relation/chart/js/diagraming/relation.ui_min.js${ctp:resSuffix()}"></script>
    
    <!-- 业务模块Js文件的引用 -->
	<script type="text/javascript" src="${path}/ajax.do?managerName=formManager"></script>
    <script type="text/javascript" src="${path}/common/form/relation/chart/js/relation.layout.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path}/common/form/relation/relationDetailView.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" src="${path}/common/form/relation/relationViewChart.js${ctp:resSuffix()}"></script>
<body>

<!-- 半透明的遮罩层 -->
<div id="overlay" style="display: none;"></div>

<!-- Start 首页框架头部 -->
<div id="designer_header">
    <div class="titlebar">
        <div class="row row1">
            <div id="title_container">
               	<div class="diagram_title_ico"></div>
               	<span class="diagram_title readonly" style="color:#e5fbff; font-size: 22px;">${ctp:i18n('form.business.relationship.diagram')}</span><span class="diagram_title readonly" style="color:#9fc7f8;font-size: 16px;">${ctp:i18n('form.relation.center.form')}: <span id="centerFormName" style="color:#9fc7f8;">${formName}</span></span>
            </div>
        </div>
        <div class="row row2 menubar"></div>
        <div class="share_container">
        	<div class="header_right_btn">
				<div id="btnChartPage" class="tabbar_button active" style="padding: 0px 10px;" onclick="loadChartPage()">
					${ctp:i18n('form.relation.graphic')}
				</div>
			</div>
			<div class="header_right_last_btn">
				<div id="btnTablePage" class="tabbar_button" loaded="false" style="padding: 0px 10px;" onclick="loadTablePage()">
					${ctp:i18n('form.relation.list')}
				</div>
			</div>
        </div>
    </div>
    <div id="chartToolbar" class="toolbar">
        <!-- 工具按钮 -->
        <div id="bar_front" title='置于顶层 (Ctrl+] )' class="toolbar_button" style="display: none;"><div class="ico ico_front"></div></div>
        <div id="bar_back" title='置于底层 (Ctrl+[ )' class="toolbar_button" style="display: none;"><div class="ico ico_back"></div></div>
        <div class="toolbar_devider" style="display: none;"></div>
        <div id="bar_lock" title='锁定 (Ctrl+L)' class="toolbar_button" style="display: none;"><div class="ico ico_lock"></div></div>
        <div id="bar_unlock" title='解锁 (Ctrl+Shift+L)' class="toolbar_button" style="display: none;"><div class="ico ico_unlock"></div></div>
        <div class="toolbar_devider" style="display: none;"></div>
        <div id="bar_lock" title='导出 (Ctrl+O)' class="toolbar_button" style="display: none;"><div class="ico ico_lock"></div></div>
        <div class="toolbar_small_devider" style="display: none;"></div>
        
        <div id="bar_unlock" title="" class="toolbar_button" onclick="Dock.print()">&nbsp;${ctp:i18n('form.print.printbutton')}&nbsp;</div>
        <div class="toolbar_small_devider"></div>
        <div id="bar_relayout" title="" class="toolbar_button" onclick="relayoutChartView();">&nbsp;${ctp:i18n('form.trigger.triggerSet.reset.label')}&nbsp;</div>
        
        <!-- 保存进度提示信息 -->
        <div id="saving_tip" style="display: none;"></div>
        
        <div class="toolbar_right">
        	<div class="dock_buttons" style="float: left;">
		        <div id="dock_btn_navigator" title="${ctp:i18n('form.pagesign.navigation.label')}" class="toolbar_button" onclick="Dock.showView('navigator')"><div class="ico ico_dock_nav"></div></div>
		    	<div class="toolbar_small_devider"></div>
		    	<div id="dock_btn_page" title="${ctp:i18n('form.stat.legend')}" class="toolbar_button selected" onclick="Dock.showView('page')"><div class="ico ico_dock_page"></div></div>
		    	<div class="toolbar_small_devider"></div>
		    	<div id="dock_btn_level" title="${ctp:i18n('form.pagesign.hierarchical.relationship')}" class="toolbar_button" onclick="Dock.showView('level')"><div class="ico ico_dock_level"></div></div>
		    </div>
		    <div class="toolbar_devider" style="display: none;"></div>
            <div id="bar_collapse" title="折叠" disableTitle="true" class="toolbar_button"  style="display: none;"><div class="ico collapse"></div></div>
        </div>
        <div class="toolbar_devider" style="display: none;"></div>
        <a id="bar_return" class="toolbar_button" style="display: none;" href="./diagraming/back?id=52c5096c0cf22b592924695d" title='${ctp:i18n('form.pagesign.quit.label')}'><span class="ico ico_goback"></span></a>
    </div>
</div>
<!-- End 首页框架头部 -->

<!-- 逻辑关系列表展现容器 -->
<div id="tableViewContainer" style="display: none;"></div>

<!-- Start 逻辑关系图形呈现 -->
<div id="designer">
	<div id="shape_panel" class="layout" style="display: none;"></div>
	<div id="designer_viewport">
		<div id="designer_layout" class="layout">
		    <div id="canvas_container">
		        <div id="designer_canvas">
		            <canvas id="designer_grids"></canvas>
		            <ul id="designer_contextmenu" class="menu list options_menu">
		                <li ac="cut"><div class="ico cut"></div>剪切<div class="extend">Ctrl+X</div></li>
		                <li ac="copy"><div class="ico copy"></div>复制<div class="extend">Ctrl+C</div></li>
		                <li ac="paste"><div class="ico paste"></div>粘贴<div class="extend">Ctrl+V</div></li>
		                <li ac="duplicate">复用<div class="extend">Ctrl+D</div></li>
		                <li class="devider devi_clip"></li>
		                <li ac="front"><div class="ico ico_front"></div>置于顶层<div class="extend">Ctrl+]</div></li>
		                <li ac="back"><div class="ico ico_back"></div>置于底层<div class="extend">Ctrl+[</div></li>
		                <li ac="lock"><div class="ico ico_lock"></div>锁定<div class="extend">Ctrl+L</div></li>
		                <li ac="hide"><div class="ico ico_hide"></div>隐藏<div class="extend">Ctrl+H</div></li>
		                <li ac="unlock"><div class="ico ico_unlock"></div>解锁<div class="extend">Ctrl+Shift+L</div></li>
		                <li ac="group">组合<div class="extend">Ctrl+G</div></li>
		                <li ac="ungroup">取消组合<div class="extend">Ctrl+Shift+G</div></li>
		                <li id="ctxmenu_align">
		                    图形对齐<div class="extend ex_arrow">►</div>
		                    <ul class="menu list extend_menu">
		                        <li ac="align_shape" al="left">左对齐</li>
		                        <li ac="align_shape" al="center">居中对齐</li>
		                        <li ac="align_shape" al="right">右对齐</li>
		                        <li class="devider"></li>
		                        <li ac="align_shape" al="top">顶端对齐</li>
		                        <li ac="align_shape" al="middle">垂直居中对齐</li>
		                        <li ac="align_shape" al="bottom">底端对齐</li>
		                    </ul>
		                </li>
		                <li class="devider devi_shape"></li>
		                <li ac="changelink"><div class="ico ico_link"></div>修改链接</li>
		                <li ac="edit"><div class="ico edittext"></div>编辑文本<div class="extend">空格</div></li>
		                <li ac="delete"><div class="ico remove"></div>删除<div class="extend">Delete/Backspace</div></li>
		                <li class="devider devi_del"></li>
		                <li ac="selectall">全选<div class="extend">Ctrl+A</div></li>
		                <li class="devider devi_selectall"></li>
		                <li ac="drawline"><div class="ico linkertype_normal"></div>创建连线<div class="extend">L</div></li>
		            </ul>
		        </div>
		    </div>
		    <div id="shape_img_container"></div>
		    <div id="layout_block"></div>
		</div>
		<div id="shape_thumb" class="menu"><canvas width="160px"></canvas><div></div></div>
		<div id="dock" style="display: none;">
		    <div class="dock_header"></div>
		    <div class="dock_buttons">
		        <div id="dock_btn_navigator" title="导航" disableTitle="true" class="toolbar_button" onclick="Dock.showView('navigator')"><div class="ico ico_dock_nav"></div></div>
		    	<div id="dock_btn_page" title="图例" disableTitle="true" class="toolbar_button selected" onclick="Dock.showView('page')"><div class="ico ico_dock_page"></div></div>
		    </div>
		</div>
		<div id="navigation_view" class="dock_view dock_view_navigator">
		    <div class="dock_view_header" style="display: none;">
		                       导航<div class="ico ico_dock_collapse"></div>
		    </div>
		    <div class="navigation_bounding">
		        <div class="navigation_view_container">
		            <canvas id="navigation_canvas" width="120px" height="160px"></canvas>
		            <div id="navigation_eye"></div>
		        </div>
		    </div>
		    <div class="dock_devider" style="margin: 0px 10px"></div>
		    <div class="navigation_view_bar">
				${ctp:i18n('form.relation.zoom')}：
		        <div id="dock_zoom" class="spinner active"></div>
		        <div style="display: none;" class="toolbar_button active" onclick="Dock.enterFullScreen()" title='${ctp:i18n('form.relation.full.screen.view')} (F11)'><div class="ico ico_fullscreen"></div></div>
		        <div style="display: none;" class="toolbar_button active" onclick="Dock.enterPresentation()" title='演示视图 (F10)'><div class="ico ico_presentation"></div> </div>
		    </div>
		</div>
		<div id="dock_view_page" class="dock_view dock_view_page">
		    <div class="dock_view_header" style="display: none;">
		    	图例<div class="ico ico_dock_collapse"></div>
		    </div>
		    <div class="dock_content">
		        <div class="navigation_bounding">
			        <div class="sign_view_container">
			        	<div class="combox_relation">
			        		<input id="all" text="${ctp:i18n('form.relation.all.highlighted')}" onclick="checkShowRelations(this);" name="all" value="all" type="checkbox" />
			        		<span>${ctp:i18n('form.relation.all.highlighted')}</span>
			        	</div>
						<c:if test="${!isA6}">
			        	<div class="combox_relation" style="background: url('${path}/common/form/relation/chart/themes/default/images/seeyon/calaulate.png') no-repeat;background-position: 40% 100%;">
			        		<input id="calaulate" text="${ctp:i18n('form.formrelation.listtable.datawriteback')}" onclick="checkShowRelations(this);" name="calaulate" checked="checked" value="calaulate" type="checkbox" />
							<span style="display:inline-block;margin-left:52px;color: #ff5051;"title="${ctp:i18n('form.formrelation.listtable.datawriteback')}">${ctp:getLimitLengthString(ctp:i18n('form.formrelation.listtable.datawriteback'), 8, '...')}</span>
			        	</div>
						</c:if>
			        	<div class="combox_relation" style="background: url('${path}/common/form/relation/chart/themes/default/images/seeyon/relation.png') no-repeat;background-position: 40% 100%;">
			        		<input id="relation" text="${ctp:i18n('form.relation.form.association')}" onclick="checkShowRelations(this);" name="relation" checked="checked" value="relation" type="checkbox" />
							<span style="display:inline-block;margin-left:52px;color: #25c190;" title="${ctp:i18n('form.relation.form.association')}">${ctp:getLimitLengthString(ctp:i18n('form.relation.form.association'), 8, '...')}</span>
						</div>
			        	<div class="combox_relation" style="background: url('${path}/common/form/relation/chart/themes/default/images/seeyon/flow.png') no-repeat;background-position: 40% 100%;">
			        		<input id="flow" text="${ctp:i18n('form.formrelation.listtable.triggerprocess')}" onclick="checkShowRelations(this);" name="flow" checked="checked" value="flow" type="checkbox" />
							<span style="display:inline-block;margin-left:52px;color: #4fa4fb;" title="${ctp:i18n('form.formrelation.listtable.triggerprocess')}">${ctp:getLimitLengthString(ctp:i18n('form.formrelation.listtable.triggerprocess'), 8, '...')}</span>
						</div>
						<c:if test="${!isA6}">
			        	<div class="combox_relation" style="background: url('${path}/common/form/relation/chart/themes/default/images/seeyon/unflow.png') no-repeat;background-position: 40% 100%;">
			        		<input id="unflow" text="${ctp:i18n('form.formrelation.listtable.dataarchive')}" onclick="checkShowRelations(this);" name="unflow" checked="checked" value="unflow" type="checkbox" />
							<span style="display:inline-block;margin-left:52px;color: #ffc167;" title="${ctp:i18n('form.formrelation.listtable.dataarchive')}">${ctp:getLimitLengthString(ctp:i18n('form.formrelation.listtable.dataarchive'), 8, '...')}</span>
						</div>
			        	<div class="combox_relation" style="background: url('${path}/common/form/relation/chart/themes/default/images/seeyon/distribution.png') no-repeat;background-position: 40% 100%;">
			        		<input id="distribution" text="${ctp:i18n('form.formrelation.listtable.distributionlinkage')}" onclick="checkShowRelations(this);" name="distribution" checked="checked" value="distribution" type="checkbox" />
							<span style="display:inline-block;margin-left:52px;color: #9a54f7;" title="${ctp:i18n('form.formrelation.listtable.distributionlinkage')}">${ctp:getLimitLengthString(ctp:i18n('form.formrelation.listtable.distributionlinkage'), 8, '...')}</span>
						</div>
			        	<div class="combox_relation" style="background: url('${path}/common/form/relation/chart/themes/default/images/seeyon/gather.png') no-repeat;background-position: 40% 100%;">
			        		<input id="gather" text="${ctp:i18n('form.formrelation.listtable.summarylinkage')}" onclick="checkShowRelations(this);" name="gather" checked="checked" value="gather" type="checkbox" />
							<span style="display:inline-block;margin-left:51px;color: #8dba08;" title="${ctp:i18n('form.formrelation.listtable.summarylinkage')}">${ctp:getLimitLengthString(ctp:i18n('form.formrelation.listtable.summarylinkage'), 8, ' ....')}</span>
						</div>
			        	<div class="combox_relation" style="background: url('${path}/common/form/relation/chart/themes/default/images/seeyon/bilateral.png') no-repeat;background-position: 40% 100%;">
			        		<input id="bilateral" text="${ctp:i18n('form.formrelation.listtable.twowaylinkage')}" onclick="checkShowRelations(this);" name="bilateral" checked="checked" value="bilateral" type="checkbox" />
							<span style="display:inline-block;margin-left:52px;color: #25c190;" title="${ctp:i18n('form.formrelation.listtable.twowaylinkage')}">${ctp:getLimitLengthString(ctp:i18n('form.formrelation.listtable.twowaylinkage'), 8, ' ...')}</span>
						</div>
						</c:if>
			        </div>
			    </div>
		    </div>
		</div>
		<div id="dock_view_level" class="dock_view dock_view_level">
		    <div class="dock_view_header" style="display: none;">
		    	层级关系<div class="ico ico_dock_collapse"></div>
		    </div>
		    <div class="navigation_bounding">
		        <div class="level_view_container">
		        	<div class="radio_relation" style="display:none;">
		        		<span>${ctp:i18n('form.relation.display.level')}</span>
		        	</div>
		        	<div id="level_btn_container">
			        	<div id="btnChartLevel_-1" class="level_button selected" style="width: 70px;" onclick="changeLevelRelations(-1)">
							${ctp:i18n('form.relation.all')}
						</div>
					</div>
		        </div>
		    </div>
		    <div class="dock_devider" style="display:none;margin: 0px 10px"></div>
		    <div class="navigation_view_bar" style="display:none;">
		    	<div class="radio_relation" style="text-align: center;">
	        		<input id="all" text="${ctp:i18n('form.relation.positive.and.negative.stacking')}" onchange="radioShowRelations(this);" name="all" checked="checked" value="all" type="radio" />
	        		<span title="${ctp:i18n('form.relation.positive.and.negative.stacking')}">${ctp:getLimitLengthString(ctp:i18n('form.relation.positive.and.negative.stacking'), 8, ' ...')}</span>
	        		<input id="from" text="${ctp:i18n('form.relation.positive')}" onchange="radioShowRelations(this);" name="all" value="from" type="radio" />
	        		<span>${ctp:i18n('form.relation.positive')}</span>
	        	</div>
		    </div>
		</div>
	</div>
</div>
<!-- End 逻辑关系图形呈现 -->
</body>
</html>