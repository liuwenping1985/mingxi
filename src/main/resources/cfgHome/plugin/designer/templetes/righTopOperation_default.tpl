{if $isAdmin=="false" || $isDesigner=="true"}
	<div myCustomWidth="296" class="area_r_images right" style="text-align:right;">
	<!----切换到工作桌面-->
	{if $appcenterEnabled=="true"}
	<a><div title="{$appCenterName}" onclick="appcenter_idClick();" id="appcenter_id" class="top_ico return_ioc left"></div><div class="top_ico return_ioc2 left hidden"></div></a>
	{/if} 
	<!----搜索-->
	<a><div title="{$searchName}" onclick="search_ico_idClick();" id="search_ico_id" class="top_ico search_ico searchButton left hand {if $isShowSearch=="false"}display_none{/if}"></div></a>
	<!----后退-->
	<a><div title="{$backName}" onclick="backPageClick();" id="backPage" class="top_ico back_ico left {if $isShowBack=="false"}display_none{/if}"></div></a>
	<!----前进-->
	<a><div title="{$forwardName}" onclick="forwardPageClick();" id="forwardPage" class="top_ico forward_ico left {if $isShowForward=="false"}display_none{/if}"></div></a>
	<!----刷新-->
	<a><div title="{$refreshName}" onclick="refreshPageClick();" id="refreshPage" class="top_ico f5_ioc left {if $isShowRefresh=="false"}display_none{/if}"></div></a>
	<!----消息-->
	{if $isHasUc =="true"}
		<a><div title="{$zhixinName}" id="ucMsg" onclick="downloadZX()" class="top_ico msg_ioc left {if $isShowUC=="false"}display_none{/if}";"><div id='ucMsg_point' class="point_more  {if $isShowUC=="false"}display_none{/if}"></div></div></a>
	{/if}
	<!----关于-->
	<a><div id="about_ioc" title="{$aboutName}" class="top_ico {$version}_ioc left" onclick="startA8genius();"></div></a>
	<a><div title="{$settingName}" class="top_ico setting_ico left"></div></a>
	<div style="clear:both;"></div>
	</div>
{/if}
{if $isAdmin=="true" && $isDesigner=="false"}
	<div class="area_r_images right" style="border:0px;">
	<!----退出-->
	<a ><div class="top_ico admin_exit_ico right" onclick="logoutClick();"></div></a>
	<!----刷新-->
	<a ><div id="homeIcon" class="top_ico f5_ioc1 right"></div></a>
	<!----帮助-->
	<a ><div class="top_ico help_ioc right hand" id="helpIcon"></div></a>
	<div style="clear:both;"></div>
</div>
{/if}
{if $isSystemAdmin=="true" && $isDesigner=="false"}
	<div class="banner_line right"></div>
	<div class="area_r_icon right">
	</div>
	<div style="clear:both;"></div>
{/if}