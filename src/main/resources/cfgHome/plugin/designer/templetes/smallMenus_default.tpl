{if $isDesigner=="false"}
<div class="layout_nav_right" id="layout_nav_right">
<ul id="navUi" class="navUi">
{if $isAdmin=="false"}
<li id="agentli"><a id="agentli_a" href="javascript:void(0)">{$menu_personal_agent_label}</a></li>
{/if}
<li id="mainNavLi">
	<ul id="mainNavUi" class="mainNavUi" pager="1"></ul>
</li>
<li id="prevli"><em class="prev_em"></em></li>
<li id="nextli"><em class="next_em"></em></li>
</ul>
</div>
{/if}
{if $isDesigner=="true"}
<div class="layout_nav_right" id="layout_nav_right" style="width: {$menusWidth}px;"> 
<ul id="navUi" class="navUi" style="width: {$menusWidth}px;"> 
{if $totalMenusNum > $menusNum}
<li id="mainNavLi" style="width: {$menusWidth-50}px;"> 
{else}
<li id="mainNavLi" style="width: {$menusWidth}px;"> 
{/if}
<ul id="mainNavUi" class="mainNavUi" pager="1">
	{foreach from=$menus item=menu name=foo}
		{if $totalMenusNum > $menusNum}
			{if $smarty.foreach.foo.index < $menusNum-1}
			<li id="{$menu.id}" title="{$menu.name}" class="nav_item"><a _width="56" href="javascript:void(0)" style="width:56px">{$menu.name}</a></li>
			{/if}
		{else}
			{if $smarty.foreach.foo.index < $menusNum}
			<li id="{$menu.id}" title="{$menu.name}" class="nav_item"><a _width="56" href="javascript:void(0)" style="width:56px">{$menu.name}</a></li>
			{/if}
		{/if}
	{/foreach} 
</ul>
</li>
{if $totalMenusNum > $menusNum}
<li id="prevli" style="display:block"><em class="prev_em"></em></li>
<li id="nextli" style="display:block"><em class="next_em"></em></li>
{/if}
</ul> 
</div>
{/if}