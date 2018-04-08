{if $isAdmin=="false" && $isDesigner=="false"}
<div class="banner_line right"></div>
<div class="area_r_icon right"></div>
{/if}
{if $isDesigner=="true"}
<div class="area_r_icon right" style="width:{$spacesNavWidth}px; text-align:right;">
<div class="right">
{foreach from=$spaceLinks item=spaceLink name=foo}
    {if $smarty.foreach.foo.index < $spacesNum}
		<div class="nav_center nav_center_current" title="{$spaceLink[3]}">
		<span class="nav_center_title">{$spaceLink[3]}</span>
		{if $smarty.foreach.foo.index == 0}
			<div class="nav_center_currentIco" id="_currentIco_6548829723565638488">&nbsp;</div>
		{/if}
		</div>
	{/if}
{/foreach}
</div>
</div>
{/if}