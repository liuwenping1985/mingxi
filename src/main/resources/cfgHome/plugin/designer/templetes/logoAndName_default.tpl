<div class="area_l left" {if $isDesigner=="true"}style="width:{$companyLogoWidth}px;"{/if}>
	<div class="logodiv left" onclick="logoDivClick();"><img id="logo"  {if $isNotShowLogo=="true"}style="display:none" {/if} src="{$contextPath}/{$logoImagePath}" /></div>
    <div class="comdiv left" id="accountNameDiv" onclick="logoDivClick();">
    	{if $isGroupAdmin=="true"}
    		{if $isNotShowGroup=="false"}
    			{if $groupSecondName ==""}
	    			<div class="comdiv_cn" style="font-size:16px;margin-top:6px;"><span  id="comdiv_group_cn" title="{$groupShortName}" >{$groupShortName}</span><span  id="comdiv_cn" title="{$accountShortName}" style="display:none">{$accountShortName}</span></div>
	        		<div class="comdiv_en"><span  id="comdiv_group_en" title="{$groupSecondName}">{$groupSecondName}</span><span  id="comdiv_en" title="{$accountSecondName}" style="display:none">{$accountSecondName}</span></div>
    			{else}
    				<div class="comdiv_cn" style="font-size:14px;margin-top:0px;"><span  id="comdiv_group_cn" title="{$groupShortName}" >{$groupShortName}</span><span  id="comdiv_cn" title="{$accountShortName}" style="display:none">{$accountShortName}</span></div>
	        		<div class="comdiv_en"><span  id="comdiv_group_en" title="{$groupSecondName}">{$groupSecondName}</span><span  id="comdiv_en" title="{$accountSecondName}" style="display:none">{$accountSecondName}</span></div>
    			{/if}
    		{else}
    			{if $groupSecondName ==""}
	    			<div class="comdiv_cn" style="font-size:16px;margin-top:6px;"><span  id="comdiv_group_cn" title="{$groupShortName}"  style="display:none">{$groupShortName}</span><span  id="comdiv_cn" title="{$accountShortName}" style="display:none">{$accountShortName}</span></div>
	        		<div class="comdiv_en"><span  id="comdiv_group_en" title="{$groupSecondName}" style="display:none">{$groupSecondName}</span><span  id="comdiv_en" title="{$accountSecondName}" style="display:none">{$accountSecondName}</span></div>
    			{else}
    				<div class="comdiv_cn" style="font-size:14px;margin-top:0px;"><span  id="comdiv_group_cn" title="{$groupShortName}"  style="display:none">{$groupShortName}</span><span  id="comdiv_cn" title="{$accountShortName}" style="display:none">{$accountShortName}</span></div>
	        		<div class="comdiv_en"><span  id="comdiv_group_en" title="{$groupSecondName}" style="display:none">{$groupSecondName}</span><span  id="comdiv_en" title="{$accountSecondName}" style="display:none">{$accountSecondName}</span></div>
    			{/if}
    		{/if}
    	{/if}
    	{if $isSystemAdmin=="true" || $isSuperAdmin=="true" || $isAuditAdmin=="true" }
    		{if $systemProductId=="2" || $systemProductId=="4" || $systemProductId=="5"}
    			{if $isNotShowGroup=="false"}
	    			{if $groupSecondName ==""}
		    			<div class="comdiv_cn" style="font-size:16px;margin-top:6px;"><span  id="comdiv_group_cn" title="{$groupShortName}" >{$groupShortName}</span><span  id="comdiv_cn" title="{$accountShortName}" style="display:none">{$accountShortName}</span></div>
		        		<div class="comdiv_en"><span  id="comdiv_group_en" title="{$groupSecondName}">{$groupSecondName}</span><span  id="comdiv_en" title="{$accountSecondName}" style="display:none">{$accountSecondName}</span></div>
	    			{else}
	    				<div class="comdiv_cn" style="font-size:14px;margin-top:0px;"><span  id="comdiv_group_cn" title="{$groupShortName}" >{$groupShortName}</span><span  id="comdiv_cn" title="{$accountShortName}" style="display:none">{$accountShortName}</span></div>
		        		<div class="comdiv_en"><span  id="comdiv_group_en" title="{$groupSecondName}">{$groupSecondName}</span><span  id="comdiv_en" title="{$accountSecondName}" style="display:none">{$accountSecondName}</span></div>
	    			{/if}
	    		{else}
	    			{if $groupSecondName ==""}
		    			<div class="comdiv_cn" style="font-size:16px;margin-top:6px;"><span  id="comdiv_group_cn" title="{$groupShortName}"  style="display:none">{$groupShortName}</span><span  id="comdiv_cn" title="{$accountShortName}" style="display:none">{$accountShortName}</span></div>
		        		<div class="comdiv_en"><span  id="comdiv_group_en" title="{$groupSecondName}" style="display:none">{$groupSecondName}</span><span  id="comdiv_en" title="{$accountSecondName}" style="display:none">{$accountSecondName}</span></div>
	    			{else}
	    				<div class="comdiv_cn" style="font-size:14px;margin-top:0px;"><span  id="comdiv_group_cn" title="{$groupShortName}"  style="display:none">{$groupShortName}</span><span  id="comdiv_cn" title="{$accountShortName}" style="display:none">{$accountShortName}</span></div>
		        		<div class="comdiv_en"><span  id="comdiv_group_en" title="{$groupSecondName}" style="display:none">{$groupSecondName}</span><span  id="comdiv_en" title="{$accountSecondName}" style="display:none">{$accountSecondName}</span></div>
	    			{/if}
	    		{/if}
    		{elseif $isNotShowAccount=="false"}
    			{if $accountSecondName ==""}
	    			<div class="comdiv_cn" style="font-size:16px;margin-top:6px;"><span id="comdiv_group_cn" style="display:none"></span><span id="comdiv_cn">{$accountShortName}</span></div>
	        		<div class="comdiv_en"><span id="comdiv_group_en" style="display:none"></span><span  id="comdiv_en" title="{$accountSecondName}">{$accountSecondName}</span></div>
    			{else}
    				<div class="comdiv_cn" style="font-size:14px;margin-top:0px;"><span id="comdiv_group_cn" style="display:none"></span><span id="comdiv_cn">{$accountShortName}</span></div>
	        		<div class="comdiv_en"><span id="comdiv_group_en" style="display:none"></span><span  id="comdiv_en" title="{$accountSecondName}">{$accountSecondName}</span></div>
    			{/if}
    		{else}
    			{if $accountSecondName ==""}
	    			<div class="comdiv_cn" style="font-size:16px;margin-top:6px;"><span id="comdiv_group_cn" style="display:none"></span><span  id="comdiv_cn" title="{$accountShortName}" style="display:none">{$accountShortName}</span></div>
	        		<div class="comdiv_en"><span id="comdiv_group_en" style="display:none"></span><span  id="comdiv_en" title="{$accountSecondName}" style="display:none">{$accountSecondName}</span></div>
    			{else}
    				<div class="comdiv_cn" style="font-size:14px;margin-top:0px;"><span id="comdiv_group_cn" style="display:none"></span><span  id="comdiv_cn" title="{$accountShortName}" style="display:none">{$accountShortName}</span></div>
	        		<div class="comdiv_en"><span id="comdiv_group_en" style="display:none"></span><span  id="comdiv_en" title="{$accountSecondName}" style="display:none">{$accountSecondName}</span></div>
    			{/if}
    		{/if}
    	{/if}
    	{if $isAdministrator=="true" ||  $isCommonUser=="true"}
    		{if $systemProductId=="2" || $systemProductId=="4" || $systemProductId=="5"}
    			{if $isNotShowGroup=="false"}
    				{if $isNotShowAccount=="false"}
    					{if $accountSecondName ==""}
			    			<div class="comdiv_cn" style="font-size:16px;margin-top:6px;"><span  id="comdiv_group_cn" title="{$groupShortName}" >{$groupShortName}&nbsp;&nbsp;&nbsp;&nbsp;</span><span  id="comdiv_cn" title="{$accountShortName}">{$accountShortName}</span></div>
			        		<div class="comdiv_en"><span id="comdiv_group_en"></span><span  id="comdiv_en" title="{$accountSecondName}">{$accountSecondName}</span></div>
		    			{else}
		    				<div class="comdiv_cn" style="font-size:14px;margin-top:0px;"><span  id="comdiv_group_cn" title="{$groupShortName}" >{$groupShortName}&nbsp;&nbsp;&nbsp;&nbsp;</span><span  id="comdiv_cn" title="{$accountShortName}">{$accountShortName}</span></div>
			        		<div class="comdiv_en"><span id="comdiv_group_en"></span><span  id="comdiv_en" title="{$accountSecondName}">{$accountSecondName}</span></div>
		    			{/if}
    				{else}
		    			{if $accountSecondName ==""}
			    			<div class="comdiv_cn" style="font-size:16px;margin-top:6px;"><span  id="comdiv_group_cn" title="{$groupShortName}" >{$groupShortName}&nbsp;&nbsp;&nbsp;&nbsp;</span><span  id="comdiv_cn" title="{$accountShortName}" style="display:none">{$accountShortName}</span></div>
			        		<div class="comdiv_en"><span id="comdiv_group_en"></span><span  id="comdiv_en" title="{$accountSecondName}" style="display:none">{$accountSecondName}</span></div>
		    			{else}
		    				<div class="comdiv_cn" style="font-size:14px;margin-top:0px;"><span  id="comdiv_group_cn" title="{$groupShortName}" >{$groupShortName}&nbsp;&nbsp;&nbsp;&nbsp;</span><span  id="comdiv_cn" title="{$accountShortName}" style="display:none">{$accountShortName}</span></div>
			        		<div class="comdiv_en"><span id="comdiv_group_en"></span><span  id="comdiv_en" title="{$accountSecondName}" style="display:none">{$accountSecondName}</span></div>
		    			{/if}
    				{/if}
    			{else}
    				{if $isNotShowAccount=="false"}
    					{if $accountSecondName ==""}
			    			<div class="comdiv_cn" style="font-size:16px;margin-top:6px;"><span  id="comdiv_group_cn" title="{$groupShortName}"  style="display:none">{$groupShortName}&nbsp;&nbsp;&nbsp;&nbsp;</span><span  id="comdiv_cn" title="{$accountShortName}">{$accountShortName}</span></div>
			        		<div class="comdiv_en"><span id="comdiv_group_en" style="display:none"></span><span  id="comdiv_en" title="{$accountSecondName}">{$accountSecondName}</span></div>
		    			{else}
		    				<div class="comdiv_cn" style="font-size:14px;margin-top:0px;"><span  id="comdiv_group_cn" title="{$groupShortName}"  style="display:none">{$groupShortName}&nbsp;&nbsp;&nbsp;&nbsp;</span><span  id="comdiv_cn" title="{$accountShortName}">{$accountShortName}</span></div>
			        		<div class="comdiv_en"><span id="comdiv_group_en" style="display:none"></span><span  id="comdiv_en" title="{$accountSecondName}">{$accountSecondName}</span></div>
		    			{/if}
    				{else}
    					{if $accountSecondName ==""}
			    			<div class="comdiv_cn" style="font-size:16px;margin-top:6px;"><span  id="comdiv_group_cn" title="{$groupShortName}"  style="display:none">{$groupShortName}&nbsp;&nbsp;&nbsp;&nbsp;</span><span  id="comdiv_cn" title="{$accountShortName}" style="display:none">{$accountShortName}</span></div>
			        		<div class="comdiv_en"><span id="comdiv_group_en" style="display:none"></span><span  id="comdiv_en" title="{$accountSecondName}" style="display:none">{$accountSecondName}</span></div>
		    			{else}
		    				<div class="comdiv_cn" style="font-size:14px;margin-top:0px;"><span  id="comdiv_group_cn" title="{$groupShortName}"  style="display:none">{$groupShortName}&nbsp;&nbsp;&nbsp;&nbsp;</span><span  id="comdiv_cn" title="{$accountShortName}" style="display:none">{$accountShortName}</span></div>
			        		<div class="comdiv_en"><span id="comdiv_group_en" style="display:none"></span><span  id="comdiv_en" title="{$accountSecondName}" style="display:none">{$accountSecondName}</span></div>
		    			{/if}
    				{/if}
    			{/if}
    		{else}
    			{if $isNotShowAccount=="false"}
    				{if $accountSecondName ==""}
		    			<div class="comdiv_cn" style="font-size:16px;margin-top:6px;"><span id="comdiv_group_cn" style="display:none"></span><span  id="comdiv_cn" title="{$accountShortName}">{$accountShortName}</span></div>
		        		<div class="comdiv_en"><span id="comdiv_group_en" style="display:none"></span><span  id="comdiv_en" title="{$accountSecondName}">{$accountSecondName}</span></div>
	    			{else}
	    				<div class="comdiv_cn" style="font-size:14px;margin-top:0px;"><span id="comdiv_group_cn" style="display:none"></span><span  id="comdiv_cn" title="{$accountShortName}">{$accountShortName}</span></div>
		        		<div class="comdiv_en"><span id="comdiv_group_en" style="display:none"></span><span  id="comdiv_en" title="{$accountSecondName}">{$accountSecondName}</span></div>
	    			{/if}
				{else}
					{if $accountSecondName ==""}
		    			<div class="comdiv_cn" style="font-size:16px;margin-top:6px;"><span id="comdiv_group_cn" style="display:none"></span><span  id="comdiv_cn" title="{$accountShortName}" style="display:none">{$accountShortName}</span></div>
		        		<div class="comdiv_en"><span id="comdiv_group_en" style="display:none"></span><span  id="comdiv_en" title="{$accountSecondName}" style="display:none">{$accountSecondName}</span></div>
	    			{else}
	    				<div class="comdiv_cn" style="font-size:14px;margin-top:0px;"><span id="comdiv_group_cn" style="display:none"></span><span  id="comdiv_cn" title="{$accountShortName}" style="display:none">{$accountShortName}</span></div>
		        		<div class="comdiv_en"><span id="comdiv_group_en" style="display:none"></span><span  id="comdiv_en" title="{$accountSecondName}" style="display:none">{$accountSecondName}</span></div>
	    			{/if}
				{/if}
    		{/if}
    	{/if}
    </div>
</div>