<select {if $id!=null}id="{$id}"{/if} {if $name!=null}name="{$name}{/if}">
{foreach from=$options item="text"key="v"}
    <option value="{$v}" {if $v==$defaultValue} selected="selected" {/if}>{$text}</option>
{/foreach}
</select>
