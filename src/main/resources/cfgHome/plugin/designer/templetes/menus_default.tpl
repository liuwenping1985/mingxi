{if $isDesigner=="false"}
{if $isAdmin=="false"}
<div class='nav_border'></div>
<div class='agent_nav_item' id='agentNav'>
	<div class='mynav_box_bgcolor'></div>
	<div class='mynav_box_color'></div>
	<span class='nav_icon'><span class="portal_menu_icon agentnavtitle" style="display: inline-block;"></span></span>
	<span class='nav_title' id="agentNavTitle">{$menu_personal_agent_label}</span>
</div>
{/if}
<div class="nav needCountHeight" deductHeight="47" pager="1"></div>
<div class="navPager">
<div class="nav_moreIco"><span class="portal_menu_icon portalIndex_moreIco" style="display: inline-block;"></span></div>
<span id='nav_pre' class="nav_left"></span>
<span id='nav_next' class="nav_right"></span>
</div>
<div class='nav_border hidden' id="navPager_border"></div>
{/if}
{if $isDesigner=="true"}
<div class="nav needCountHeight" deductheight="47" pager="1" style="height: {$menusHeight}px; width: 142px;">
	<div class="nav_border"></div>
	{foreach from=$menus item=menu name=foo}
		{if $totalMenusNum > $menusNum}
			{if $smarty.foreach.foo.index < $menusNum-1}
				<div class="nav_item" index="0" id="{$menu.id}" title="{$menu.name}">
					<div class="nav_box_bgcolor" style="width: 142px;"></div>
					<div class="nav_box_color" ></div>
					<span class="nav_icon" style="margin-left: 15px; margin-top: 0px;">
						<span class="portal_menu_icon menu_one_collaboration" style="display:inline-block;"></span>
					</span>
					<span class="nav_title">{$menu.name}</span>
				</div>
				<div class="nav_border"></div>
			{/if}
		{else}
			{if $smarty.foreach.foo.index < $menusNum}
				<div class="nav_item" index="0" id="{$menu.id}" title="{$menu.name}">
					<div class="nav_box_bgcolor" style="width: 142px;"></div>
					<div class="nav_box_color" ></div>
					<span class="nav_icon" style="margin-left: 15px; margin-top: 0px;">
						<span class="portal_menu_icon menu_one_collaboration" style="display:inline-block;"></span>
					</span>
					<span class="nav_title">{$menu.name}</span>
				</div>
				<div class="nav_border"></div>
			{/if}
		{/if}
	{/foreach} 
	{if $totalMenusNum > $menusNum}	
		<div class="navPager" style="display:block;">
			<div class="nav_moreIco"><span class="portal_menu_icon portalIndex_moreIco" style="display: inline-block;"></span></div>
			<span id='nav_pre' class="nav_left" style="display:inline-block;"></span>
			<span id='nav_next' class="nav_right" style="display:inline-block;"></span>
		</div>
	{/if}
</div>
{/if}