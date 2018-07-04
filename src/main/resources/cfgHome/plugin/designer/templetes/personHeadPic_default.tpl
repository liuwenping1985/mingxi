{if $isAdmin=="false"}
{if $isDesigner=="true"}
<div style="height:142px;width:142px;display:none"></div>
{/if}
<div class="change_nav_left"><span class="collapseIco"></span></div>
<div class="lineBg"></div>
<div class="line">
	<div class="avatar hand" onclick="personalInfoClick();">
		<img src="{$personHeadImgPath}" height="94" width="94">
	</div>
	<div class="vst_online hand" id="vst_online">
		<div class="vst_online_box">
			<span id="vst_online_state">
			<em class="ico16 online1"></em>
			<span class="padding_l_5"></span>
	        </span>
	        <span id="online_uc" style="cursor: pointer;"><span id="onlineNum" name="onlineNum">{$onlineNum}</span>{$portal_onlineNum_label}</span>
	        {if $isCanSendSMS=="true"}
            	<span class="ico16 head_msg_16 margin_l_5" onclick="sendSMSV3X()"></span>
        	{/if}
        	{if $cardEnabled=="true"}
            	<span id="onlineCard"  onclick="onlineCardClick();" class="ico16 head_online_16 margin_l_5" title="{$menu_hr_personal_attendance_manager}"></span>
            {/if}            
         </div>
         <div class="vst_state" id="vst_state">
		 <div class="vst_boxbg"></div>
			<a href="javascript:void(0)" id="online1" value="0" class="vst_state_item vst_fun"><em class="ico16 online1 margin_lr_5"></em>&nbsp;{$portal_onlineState_label1}</a>
	        <a href="javascript:void(0)" id="online2" value="1" class="vst_state_item vst_fun"><em class="ico16 online2 margin_lr_5"></em>&nbsp;{$portal_onlineState_label2}</a>
	        <a href="javascript:void(0)" id="online3" value="2" class="vst_state_item vst_fun"><em class="ico16 online3 margin_lr_5"></em>&nbsp;{$portal_onlineState_label3}</a>
	        <a href="javascript:void(0)" id="online4" value="3" class="vst_state_item vst_fun"><em class="ico16 online4 margin_lr_5"></em>&nbsp;{$portal_onlineState_label4}</a>
		 </div>
	</div>
</div>
{/if}
{if $isAdmin=="true"}
	{if $isDesigner=="true"}
		<div style="height:142px;width:142px;display:none"></div>
		<div class="change_nav_left"><span class="collapseIco"></span></div>
		<div class="lineBg"></div>
		<div class="line">
		   <div class="avatar hand">
		       <img src="{$personHeadImgPath}" height="91" width="94">
		   </div>
		   <div class="vst_online hand" id="vst_online">
		       <span class="ico16 online1"></span>
		       <span id="onlineNum_adm" name="onlineNum_adm">{$onlineNum}</span>{$portal_onlineNum_label}
		   </div>
		</div>
	{else}
		<div class="lineAdmin" style="width:142px;">
		   <div class="vst_online hand" id="vst_online">
		       <span class="ico16 online1"></span>
		       <span id="onlineNum_adm" name="onlineNum_adm">{$onlineNum}</span>{$portal_onlineNum_label}
		   </div>
		</div>
	{/if}
{/if}