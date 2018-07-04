{if $isAdmin=="false" && $isDesigner=="false"}
	<!-- 空间列表 -->
	<div id="spaceLeftArea" pager="1"></div>
	<div class="spacePager">
		<div class="space_moreIco">
			<span class="portal_menu_icon portalIndex_moreIco" style="display: inline-block;"></span>
		</div>
		<span id='space_pre' class="space_left"></span>
		<span id='space_next' class="space_right"></span>
	</div>
{/if}
{if $isDesigner=="true"}
	<div class="nav" id="spaceLeftArea" pager="1" style="height: {$spacesLinkHieght}px; width: 142px;">
		<div class="nav_border"></div>
		{foreach from=$spaceLinks item=spaceLink name=foo}
			{if $smarty.foreach.foo.index < $spacesNum}
					{if $smarty.foreach.foo.index == 0}
						<div class="space_item current_space_item" title="{$spaceLink[3]}"><span class="space_icon" style="margin-left: 15px;"><span class="portal_menu_icon b_menu_personal"></span></span><span class="space_title">{$spaceLink[3]}</span></div>
					{/if}
					{if $smarty.foreach.foo.index > 0}
						<div class="space_item" title="{$spaceLink[3]}"><span class="space_icon" style="margin-left: 15px;"><span class="portal_menu_icon b_menu_personal"></span></span><span class="space_title">{$spaceLink[3]}</span></div>
					{/if}
				{/if}
		{/foreach} 
		{if $totalSpacesNum > $spacesNum}
			<div class="spacePager" style="display:block;">
				<div class="space_moreIco"><span class="portal_menu_icon portalIndex_moreIco" style="display: inline-block;"></span></div>
				<span id='space_pre' class="space_left" style="display:inline-block;"></span>
				<span id='space_next' class="space_right" style="display:inline-block;"></span>
			</div>
		{/if}
	</div>
{/if}