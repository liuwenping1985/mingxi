{if $isAdmin=="false" && $isDesigner=="false"}
<div id="myShortcutDiv" class="shortcut_nav_item" style="width: 100%;">
	<div style="width: 142px;" class="mynav_box_bgcolor"></div>
	<div style="width: 0px;" class="mynav_box_color"></div>
	<span style="margin-top: 0px; margin-left: 15px;" class="nav_icon"><span style="display: inline-block;" class="portal_menu_icon portalIndex_shortcut"></span></span>
	<!-- 我的快捷 -->
	<span id="shortCutTitle" class="nav_title">{$portal_menu_shortcut_label}</span>
</div>
{/if}
{if $isDesigner=="true"}
<div id="myShortcutDiv" class="shortcut_nav_item" style="width: 142px;">
	<div style="width: 142px;" class="mynav_box_bgcolor"></div>
	<div style="width: 0px;" class="mynav_box_color"></div>
	<span style="margin-top: 0px; margin-left: 15px;" class="nav_icon"><span style="display: inline-block;" class="portal_menu_icon portalIndex_shortcut"></span></span>
	<!-- 我的快捷 -->
	<span id="shortCutTitle" class="nav_title">{$portal_menu_shortcut_label}</span>
</div>
{/if}