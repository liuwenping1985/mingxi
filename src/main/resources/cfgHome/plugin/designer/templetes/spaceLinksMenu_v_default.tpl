{if $isAdmin=="false" && $isDesigner=="false"}
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
	<div class="area_r_icon right">
	<div class="area_r_icon left">
		{foreach from=$spaceLinks item=spaceLink name=foo}
		    {if $totalSpacesNum > $spacesNum}
	    		{if $smarty.foreach.foo.index < $spacesNum-1}
	    			{if $smarty.foreach.foo.index == 0}
						<div class="nav_center nav_center_current" title="{$spaceLink[3]}">
							<span class="nav_center_title">{$spaceLink[3]}</span>
							<div class="nav_center_currentIco" id="_currentIco_6548829723565638488">&nbsp;</div>
						</div>
					{/if}
					{if $smarty.foreach.foo.index > 0}
						<div class="nav_center  nav_top_current" title="{$spaceLink[3]}">
							<span class="nav_center_title">{$spaceLink[3]}</span>
							<div class="nav_center_currentIco" id="_currentIco_-6378451255127815423" style="display: none;">&nbsp;</div>
						</div>
					{/if}
				{/if}
			{else}
				{if $smarty.foreach.foo.index < $spacesNum}
	    			{if $smarty.foreach.foo.index == 0}
						<div class="nav_center nav_center_current" title="{$spaceLink[3]}">
							<span class="nav_center_title">{$spaceLink[3]}</span>
							<div class="nav_center_currentIco" id="_currentIco_6548829723565638488">&nbsp;</div>
						</div>
					{/if}
					{if $smarty.foreach.foo.index > 0}
						<div class="nav_center  nav_top_current" title="{$spaceLink[3]}">
							<span class="nav_center_title">{$spaceLink[3]}</span>
							<div class="nav_center_currentIco" id="_currentIco_-6378451255127815423" style="display: none;">&nbsp;</div>
						</div>
					{/if}
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