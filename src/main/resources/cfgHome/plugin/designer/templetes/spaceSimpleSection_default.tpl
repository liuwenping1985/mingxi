{if $isDesigner=="false"}
<iframe id="main" name="main" frameborder="0" allowtransparency="true" onload="setonbeforeunload()" class="w100b h100b" style="position:absolute;">
</iframe>
{/if}
{if $isDesigner=="true"}
<div id="sampleSectionId" style="height:{$v5bodyHeight}px;width:100%;">
{if $isAdmin=="true"}
<iframe src="{$contextPath}/portal/homePageDesigner.do?method=simpleSpace" id="main" name="main" frameborder="0" allowtransparency="true" class="w100b h100b"></iframe>
{/if}
{if $isCommonUser=="true"}
<iframe src="{$commonUserPersonalSpaceUrl}" id="main" name="main" frameborder="0" allowtransparency="true" class="w100b h100b"></iframe>
{/if}
</div>
{/if}