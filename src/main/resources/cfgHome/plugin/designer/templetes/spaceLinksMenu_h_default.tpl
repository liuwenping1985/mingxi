{if $isAdmin=="false" && $isDesigner=="false"}
	<li id="agentli"><a id="agentli_a" href="javascript:void(0)">{$menu_personal_agent_label}</a></li>
	<div id="spaceArea" pager="1"></div>
	<div class="spacePager">
		<span id='space_pre' class="space_left"></span>
		<span id='space_next' class="space_right"></span>
	</div>
{/if}
{if $isDesigner=="true"}
<div style="width:{$spacesNavWidth + 63}px;">
	<div id="spaceArea" pager="1" style="width:{$spacesNavWidth}px;">
		<ul class="spaceList">
		{foreach from=$spaceLinks item=spaceLink name=foo}
			{if $smarty.foreach.foo.index < $spacesNum}
	    		<li  class="space_item" title="{$spaceLink[3]}"><span class="space_title " style="width:56px ">{$spaceLink[3]}</span></li>
			{/if}
		{/foreach} 
		</ul>
	</div>
	{if $totalSpacesNum > $spacesNum}
	<div class="spacePager" style="display:block">
		<span id='space_pre' class="space_left" style="display:block"></span>
		<span id='space_next' class="space_right" style="display:block"></span>
	</div>
	{/if}
</div>
{/if}