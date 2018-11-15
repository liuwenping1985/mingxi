<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html  class="over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="${path}/common/designer/css/simpleSpace.css${ctp:resSuffix()}"/>
<link rel="stylesheet" type="text/css" href="${path}/common/designer/css/pageDesigner.css${ctp:resSuffix()}"/>
<title>空间栏目样例页面</title>
</head>
<body class="over_hidden">
	<div id="normalDiv" class="portal-layout ${isEdit?'layout-edit':'' }">
		
<div id="pure-layout" class="padding_l_15">
	<div class="pure-g">
		<div class="pure-u-1-1 pureflag">
			<div id="normalDiv" class="portal-layout portal-layout-ThreeColumns ">
				<div class="pure-g">
					<div class="pure-u-1-1 pureflag">
						<div id="banner" class="portal-layout-column margin_r_15 ui-sortable">
							<div class="fragment" x="0" y="0" id="fragment_0_0" swidth="10" celladd="true" maxsection="-1"></div>
							
<div class="portal-layout-cell">
	

	<div class="common_content_area">
	  <div class="bg_color_white" style="display:none"></div>
	  <div>
	    <div class="portal-layout-cell-banner" style="background:none;">
	      <div class="portal_shortcut_area">
	        <div class="portal_shortcut_box clearfix">
	          <div class="list_item">
	            <div class="img"><img src="/seeyon/main/skin/desktop/tint60/portletImages/d_newaffair.png" alt=""></div>
	            <div class="text" title="${ctp:i18n('system.menuname.NewAffair')}">${ctp:i18n('system.menuname.NewAffair')}</div>
	            <div class="tip_number hidden"></div>
	          </div>
	          <div class="list_item">
	            <div class="img"><img src="/seeyon/main/skin/desktop/tint60/portletImages/d_newmeeting.png" alt=""></div>
	            <div class="text" title="${ctp:i18n('system.menuname.NewConference')}">${ctp:i18n('system.menuname.NewConference')}</div>
	            <div class="tip_number hidden"></div>
	          </div>
	          <div class="list_item">
	            <div class="img"><img src="/seeyon/main/skin/desktop/tint60/portletImages/d_newplan.png" alt=""></div>
	            <div class="text" title="${ctp:i18n('system.menuname.NewPlan')}">${ctp:i18n('system.menuname.NewPlan')}</div>
	            <div class="tip_number hidden"></div>
	          </div>
	          <div class="list_item">
	            <div class="img"><img src="/seeyon/main/skin/desktop/tint60/portletImages/d_contacts.png" alt=""></div>
	            <div class="text" title="${ctp:i18n('menu.address.list')}">${ctp:i18n('menu.address.list')}</div>
	            <div class="tip_number hidden"></div>
	          </div>
	          <div class="list_item">
	            <div class="img"><img src="/seeyon/main/skin/desktop/tint60/portletImages/d_searchengine.png" alt=""></div>
	            <div class="text" title="${ctp:i18n('menu.tools.isearch')}">${ctp:i18n('menu.tools.isearch')}</div>
	            <div class="tip_number hidden"></div>
	          </div>
	          <div class="list_item" id="shortcutMore">
	            <div class="img"><img src="/seeyon/main/frames/desktop/images/shortcutBlock_more.png" alt=""></div>
	            <div class="text" title="${ctp:i18n('desk.btn.addshortcut')}">${ctp:i18n('desk.btn.addshortcut')}</div>
	          </div>
	        </div>
	      </div>
	    </div>
	  </div>
	  <div class="content_area_footer clearfix" style="display: block;">
	    <div class="right" style="padding-top: 4px; padding-bottom: 4px; display: none;"></div>
	  </div>
	</div>


</div>

							
						</div>
					</div>
				</div>
				<div class="pure-g">
					<div class="pure-u-4-5 pureflag">
						<div class="pure-g">
							<div class="pure-u-2-5 pureflag">
								<div id="column-0" class="portal-layout-column margin_r_15 ui-sortable">
									<div class="fragment" x="0" y="3" id="fragment_3_0" swidth="4" celladd="true" maxsection="-1"></div>
									
										
											
<div class="portal-layout-cell">


	<div class="common_content_area">
	  <div style="display:none" class="portal-layout-cell_head">
	    <div class="portal-layout-cell_head_l"></div>
	    <div class="portal-layout-cell_head_r"></div>
	  </div>
	  <div class="content_area_head  clearfix">
	    <div class="content_area_head_bg"></div>
	    <div class="index_tabs">
	      <ul style="float:left;">
	        <li class="current"><a class="color_black_nohover"><span title="待办工作">${ctp:i18n_1('common.my.pending.label',0)}</span></a></li>
	      </ul>
	    </div>
	    <div class="section_right_more" style="display:block;"><a class="sectionMoreIco" uid="1" title="更多" style="float:right;">${ctp:i18n('common.more.label')}</a></div>
	  </div>
	  <div class="bg_color_white" style="display:none"></div>
	  <div class="content_area_body common_tabs_body my_task_2" style="display: block;">
	    <table style="" width="100%" border="0" cellspacing="0" cellpadding="0">
	      <tbody>
	        <tr>
	          <td style="overflow:hidden;font-size:0px;height: 468px;"></td>
	        </tr>
	      </tbody>
	    </table>
	  </div>
	  <div class="content_area_footer clearfix" style="display: block;">
	    <div class="right" style="padding-top: 4px; padding-bottom: 4px; display: none;"></div>
	  </div>
	</div>


</div>



								
								</div>
							</div>
							<div class="pure-u-3-5 pureflag">
								<div id="column-1" class="portal-layout-column margin_r_15 ui-sortable">
									<div class="fragment" x="0" y="4" id="fragment_3_0" swidth="4" celladd="true" maxsection="-1"></div>
									
										
											
<div class="portal-layout-cell">


	<div class="common_content_area">
	  <div style="display:none"  class="portal-layout-cell_head">
	    <div class="portal-layout-cell_head_l"></div>
	    <div class="portal-layout-cell_head_r"></div>
	  </div>
	  <div class="content_area_head  clearfix">
	    <div class="content_area_head_bg"></div>
	    <div class="index_tabs">
	      <ul style="float:left;">
	        <li class="current"><a class="color_black_nohover"><span title="跟踪事项">${ctp:i18n_1('common.my.track.label',0)}</span></a></li>
	      </ul>
	    </div>
	    <div class="section_right_more" style="display:block;"><a class="sectionMoreIco" uid="1" title="更多" style="float:right;">${ctp:i18n('common.more.label')}</a></div>
	  </div>
	  <div class="bg_color_white" style="display:none"></div>
	  <div class="content_area_body common_tabs_body my_task_2" style="display: block;height: 250px;"></div>
	  <div class="content_area_footer clearfix" style="display: block;">
	    <div class="right" style="padding-top: 4px; padding-bottom: 4px; display: none;"></div>
	  </div>
	</div>



</div>

											
<div class="portal-layout-cell">

	<div class="common_content_area">
	  <div style="display:none" class="portal-layout-cell_head">
	    <div class="portal-layout-cell_head_l"></div>
	    <div class="portal-layout-cell_head_r"></div>
	  </div>
	  <div  class="content_area_head  clearfix">
	    <div class="content_area_head_bg"></div>
	    <div class="index_tabs">
	      <ul style="float:left;">
	        <li class="current"><a class="color_black_nohover"><span title="我的模板">${ctp:i18n('common.my.template')}</span><span class="sectionTitleTotal"></span></a></li>
	      </ul>
	    </div>
	    <div class="section_right_more" style="display:block;"><a class="sectionMoreIco" uid="1" title="更多" style="float:right;">${ctp:i18n('common.more.label')}</a></div>
	  </div>
	  <div class="bg_color_white" style="display:none"></div>
	  <div class="content_area_body common_tabs_body my_task_2" style="display: block;height: 250px;"></div>
	  <div class="content_area_footer clearfix" style="display: block;">
	    <div class="right" style="padding-top: 4px; padding-bottom: 4px; display: none;"></div>
	  </div>
	</div>

</div>

											
										
										
									
								</div>
							</div>
						</div>
					</div>
					<div class="pure-u-1-5 pureflag">
						<div class="pure-g">
							<div class="pure-u-1-1 pureflag">
								<div id="column-2" class="portal-layout-column margin_r_15 ui-sortable">
									<div class="fragment" x="0" y="5" id="fragment_5_0" swidth="2" celladd="true" maxsection="-1"></div>
									
										
											
<div class="portal-layout-cell">

	<div class="common_content_area">
	  <div style="display:none" class="portal-layout-cell_head">
	    <div class="portal-layout-cell_head_l"></div>
	    <div class="portal-layout-cell_head_r"></div>
	  </div>
	  <div class="content_area_head  clearfix">
	    <div class="content_area_head_bg"></div>
	    <div class="index_tabs">
	      <ul style="float:left;">
	        <li class="current"><a class="color_black_nohover"><span title="日程事件">${ctp:i18n('menu.calendar.manage')}</span><span class="sectionTitleTotal"></span></a></li>
	      </ul>
	    </div>
	    <div class="section_right_more" style="display:block;"><a class="sectionMoreIco" uid="1" title="更多" style="float:right;">${ctp:i18n('common.more.label')}</a></div>
	  </div>
	  <div class="bg_color_white" style="display:none"></div>
	  <div class="content_area_body common_tabs_body my_task_2" style="display: block;">
	    <table style="" width="100%" border="0" cellspacing="0" cellpadding="0">
	      <tbody>
	        <tr>
	          <td id="7212122152259270361TD" style="overflow:hidden;font-size:0px;height: 348px; "></td>
	        </tr>
	      </tbody>
	    </table>
	  </div>
	  <div class="content_area_footer clearfix" style="display: block;">
	    <div class="right" style="padding-top: 4px; padding-bottom: 4px; display: none;"></div>
	  </div>
	</div>

</div>

											
<div class="portal-layout-cell">

	<div class="common_content_area">
	  <div style="display:none" class="portal-layout-cell_head">
	    <div class="portal-layout-cell_head_l"></div>
	    <div class="portal-layout-cell_head_r"></div>
	  </div>
	  <div class="content_area_head  clearfix">
	    <div class="content_area_head_bg"></div>
	    <div class="index_tabs">
	      <ul style="float:left;">
	        <li class="current"><a class="color_black_nohover"><span title="关联人员">${ctp:i18n('common.my.peoplerelate')}</span><span class="sectionTitleTotal"></span></a></li>
	      </ul>
	    </div>
	    <div class="section_right_more" style="display:block;"><a class="sectionMoreIco" uid="1" title="更多" style="float:right;">${ctp:i18n('common.more.label')}</a></div>
	  </div>
	  <div class="bg_color_white" style="display:none"></div>
	  <div class="content_area_body common_tabs_body my_task_2" style="display: block;height: 250px;"></div>
	  <div class="content_area_footer clearfix" style="display: block;">
	    <div  class="right" style="padding-top: 4px; padding-bottom: 4px; display: none;"></div>
	  </div>
	</div>


</div>

											
										
										
									
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

	</div>
</body>
</html>