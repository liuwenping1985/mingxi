
  <script type="text/javascript">
  $(function() {
    //$( "#tabs" ).tabs();
  });

  </script>



<div class='portal-layout-cell'>
	<div class='common_content_area'>
		<div style='display:none' id='sectionHeader8871289948354295366' class='portal-layout-cell_head'>
			<div class='portal-layout-cell_head_l'></div>
			<div class='portal-layout-cell_head_r'></div>
		</div>
		<div id='title8871289948354295366' class='content_area_head  clearfix' style='background: rgba(255, 255, 255, 0.701961);'>
			<div class='content_area_head_bg' style='background:rgb(208,236,207)'></div>
			<div class='index_tabs'>
				<ul style='float:left;'>
					{foreach from=$sectionTabs item="tab" key="v"}
  						
  						<li style='border-bottom-color:#18a110' class='current' id='section_name_total8871289948354295366' onclick='changPanels('8871289948354295366_0','4789751511939399095','4789751511939399095');showSection('4789751511939399095', true)'>
						<a class='color_black_nohover'>
							<span id='Text8871289948354295366_0' title='{$tab}'>{$tab}</span>
							<span id='Total8871289948354295366_0' class='sectionTitleTotal'></span>
						</a>
						<div style='display:none;' nowrap='' id='8871289948354295366_0' panelid='4789751511939399095' sectionid='doneSection' title='{$tab}'></div>
					</li>
  					{/foreach}
					
				</ul>
			</div>
			<div class='section_right_more' style='display:block;'>
				<a id='moreIco_section_div8871289948354295366_0' class='sectionMoreIco' uid='1' title='更多' style='float:right;' onclick='delete_column(this)'>删除</a>
			</div>
			<div class='section_right_ico' show='0' style='position:relative'>
				<div class='sectionSettingIco' qq='1' title='' style='float: right; display: none;' id='settingIco_section_div8871289948354295366'>
					<iframe class='settingmoreButtonIframe'></iframe>
					<div class='settingmoreButton'>
						<div class='top_l_arrow' style='font-size:23px;top:-1px;left:52px;'>◆</div>
						<div class='top_r_arrow' style='font-size:23px;top:0px;left:52px;'>◆</div>
						<div class='setting_div' style='float:right;cursor:pointer;' id='edit_section_div8871289948354295366' onclick='portalSectionHander.loadSectionPro('4789751511939399095')'>编辑栏目</div>
						<div class='setting_div' id='del_section_div8871289948354295366' onclick='portalSectionHander.deleteFragment('4789751511939399095')' style='float:right;cursor:pointer;'>移除栏目</div>
						<div class='setting_div' style='float:right;cursor:pointer;' id='add_section_div8871289948354295366' onclick='portalSectionHander.addSectionsToFrag('4789751511939399095')'>添加栏目</div>
					</div>
				</div>
			</div>
		</div>
		<div id='editDiv8871289948354295366' class='bg_color_white' style='display:none'></div>
		<div id='8871289948354295366' class='content_area_body common_tabs_body my_task_2 body_transparent' style='display: block; background-color: rgba(255, 255, 255, 0.901961);'>
			<table style='' width='100%' border='0' cellspacing='0' cellpadding='0'>
				<tbody>
				{foreach from=$showSectionList item="data" key="v"}
  					<tr>
						<td width='100%' class='text_overflow    sectionSubjectIcon' title='{$data.subject}'>
							<a class='defaulttitlecss' href='#' title='{$data.subject}'>
								<span class='inline-block'>{$data.subject}</span>
								<span class='attachment_table_ inline-block margin_l_5' style='margin-top:-3px'></span>
							</a>
						</td>
						<td nowrap='nowrap' class='text_overflow   padding_l_10  ' title='{$data.createTime}'>
							<span class='color_gray' title='{$data.createTime}'>{$data.createTime}</span>
						</td>
						<td nowrap='nowrap' width='0%' class='text_overflow   padding_l_10  ' title='{$data.sender}'>{$data.sender}</td>
						<td nowrap='nowrap' width='0%' class='text_overflow   padding_l_10 padding_r_10 ' title='{$data.type}'>
							<a href='#'>{$data.type}</a>
						</td>
					</tr>
  				{/foreach}
				</tbody>
			</table>
			<div id='showPositionDiv' style='position:absolute;z-index:500;padding:5px;clear:both;width:160px;border:1px #000000 solid;display:none;background:#ffffff;' onmouseover='showTemp()' onmouseout='hideTemp()'></div>
		</div>
		<div id='footer8871289948354295366' class='content_area_footer clearfix' style='display: block;'>
			<div id='footer8871289948354295366_button' class='right' style='padding-top: 4px; padding-bottom: 4px; display: none;'></div>
		</div>
	</div>
</div>