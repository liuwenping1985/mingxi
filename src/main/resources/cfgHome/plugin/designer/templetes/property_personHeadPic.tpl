<table border="0" cellspacing="0" cellpadding="0">
	<tr><td class="font_bold">{$currenthead}</td></tr>
	<tr>
		<td class="padding_l_30 padding_t_10 padding_b_5">
		{if $isAllowUpdateAvatarEnable=="true" }
		<div onclick="page_c004_p003_onclick();" class="radiusPic"><img src="{$personHeadImgPath}" /></div>
		{/if}
		{if $isAllowUpdateAvatarEnable=="false" }
		<div onclick="" class="radiusPic"><img src="{$personHeadImgPath}" /></div>
		{/if}
		</td>
		</td>
	</tr>
	<tr>
		<td class="padding_l_30 padding_t_10 padding_b_5">
		{if $isAllowUpdateAvatarEnable=="true" }
		<input class="common_Newbutton" type="button" value="{$edithead}" onclick="page_c004_p003_onclick();" >
		{/if}
		{if $isAllowUpdateAvatarEnable=="false" }
		<input disabled="" style="border-radius: 4px; border: currentColor; width: 70px; height: 25px; color: rgb(177, 177, 177); overflow: hidden; white-space: nowrap; cursor: pointer; text-overflow: ellipsis; background-color: rgb(238, 238, 238);" type="button" size="100" value="{$edithead}">
		{/if}
		</td>
	</tr>
</table>