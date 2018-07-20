<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/info_header.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=infoMagazineManager"></script>
<script type="text/javascript" src="${path}/apps_res/info/js/common/magazine_publish_common.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/info/js/common/magazine_publish_tree.js${ctp:resSuffix()}"></script>
<script>
var isLoad = true;
var isPublishToView = false;
var isPublishToPublic = false;
var parentWindow = window.dialogArguments.window;
var openFromType = parentWindow.$("#openFromType").val();
var publishToViewRangeIds = parentWindow.$("#publishToViewRangeIds").val();
var publishToViewRangeNames = parentWindow.$("#publishToViewRangeNames").val();
var publishToViewRangeNamesOfAll = parentWindow.$("#publishToViewRangeNamesOfAll").val();
var publishToPublicRangeIds = parentWindow.$("#publishToPublicRangeIds").val();
var publishToPublicRangeNames = parentWindow.$("#publishToPublicRangeNames").val();
var publishBullentinOrgRangeIds = parentWindow.$("#publishBullentinOrgRangeIds").val();
var publishBullentinUnitRangeIds = parentWindow.$("#publishBullentinUnitRangeIds").val();
var publishBullentinOrgRangeNames = parentWindow.$("#publishBullentinOrgRangeNames").val();
var publishBullentinUnitRangeNames = parentWindow.$("#publishBullentinUnitRangeNames").val();
var oldPublishToPublicRangeIds = parentWindow.$("#oldPublishToPublicRangeIds").val();
var scoreId = parentWindow.$("#scoreId").val();
var publicViewMembers = publishToViewRangeIds;
var bindPublishRange = "${bindPublishRange}";

/*
var bindPublishRange = "";
var selectMembers;
var publicViewMembers;
var parentWindow=window.dialogArguments.win;
var parentViewPeople=parentWindow.$("#viewPeople").val();
var parentPublicViewPeople=parentWindow.$("#publicViewPeople").val();
var parentPublishRangeIds=parentWindow.$("#publishRangeIds").val();
var parentViewPeopleId=parentWindow.$("#viewPeopleId").val();
var parentpublicViewPeopleId=parentWindow.$("#publicViewPeopleId").val();

//后台入口，组件需要验证数据判重
if(openFromType=="0"){
	var range=parentWindow.$("#bindPublishRange").val();
  	if(range != undefined){
	 	var ranges=range.split(",");
	  	for(var i=0;i<ranges.length;i++){
		  if(i==0){
			  bindPublishRange=ranges[i].split("|")[1];
		  }else{
			  bindPublishRange+=","+ranges[i].split("|")[1];
		  }
	  	}
  	}
}
if("" ==parentViewPeople){
	parentViewPeople="点击选择";
}
if("" == parentPublicViewPeople){
	parentPublicViewPeople="点击选择";
}
*/

if(publishToViewRangeIds != "") {
	isPublishToView = true;
}
if(publishToPublicRangeIds != "") {
	isPublishToPublic = true;
}
$(function() {
	var tabType = 0;
	if(!isGroup) {
		tabType = 1;
	}
	changeCurrentClass(tabType);
	triggerCurrentClick(tabType);
	initPublishDestTree();
	initClick();
	initPublishInfo();
	isLoad = false;
	if(!isGroup) {
		$("#tabs_head").find("li").eq(0).hide();
		$("#tab1_div").hide();
	}
});

</script>
</head>
<body style="overflow:hidden">

<div id="magazinePublishRangeDiv">
	<fieldset class="margin_5 margin_l_20">
    	<legend><input type="checkbox" id="viewCheck" name="viewCheck" value="查看页面" />${ctp:i18n('infosend.score.infoScores.viewPage.label')}<!-- 查看页面 --></legend>
    	<div id="viewPeopleDiv" class="form_area align_center relative">
    		<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
	        	<tr>
	            	<th nowrap="nowrap"><label class="margin_r_5" for="text">${ctp:i18n('infosend.label.seePeople')}<!-- 可查看人员 -->:</label></th>
	            	<td width="100%">
		            	<div class="common_txtbox_wrap">
			            	<input id="viewPeopleName" type="text" disabled="disabled" name="viewPeopleName" />
			            	<input id="viewPeopleId" type="hidden" name="viewPeopleId" />
			            </div>
		            </td>
	        	</tr>
	     	</table>	     
    	</div>
   	</fieldset>
   
	<fieldset class="margin_5 margin_l_20">
		<legend><input type="checkbox" id="publicInfo" name="publicInfo" value="公共信息"/>${ctp:i18n('infosend.score.infoScores.publicInfo.label')}<!-- 公共信息 --></legend>
		<table id="selectPeopleTable" width="100%"  border="0" class="bg-body1" align="center" cellpadding="0" cellspacing="0" style="display:;">
    		<tr valign="top"> 
        		<td>
        			<div id="tabs" class="comp" comp="type:'tab',height:313,width:640,showTabIndex:1">
         				<table width="100%" border="0" height="100%" cellpadding="0" cellspacing="0">
	                      	<thead>
	                      		<tr>
	                      			<td>
	                      				<div id="tabs_head" class="common_tabs clearfix">
						                     <ul class="left">
						                        <li class="current"><a value="0" class="no_b_border" href="javascript:void(0)" tgt="tab1_div" disabled="true" onclick="javascript:changeCurrentClass(0);checkPublishType(0);">${ctp:i18n('infosend.label.organization')}<!-- 组织 --></a></li>
						                        <li><a value="1" class="no_b_border last_tab" href="javascript:void(0)" tgt="tab2_div" disabled="true" onclick="javascript:changeCurrentClass(1);checkPublishType(1);">${ctp:i18n('infosend.label.unit')}<!-- 单位 --></a></li>
						                    </ul>
				                      	</div>
	                      			</td>
	                      		</tr>
	                      	</thead>
	                      	
	                      	<tbody>
	            			<tr>
	                			<td class="border_t padding_r_10 padding_t_5">
	                 				<div id="tabs_body" class="common_tabs_body border_all">
	                 					<div id="tab1_div">
											<div class="padding_t_5"><em  class="ico16 attribute_16"></em><span style="font-style: oblique;margin-left: 14px;">${ctp:i18n('infosend.magazine.label.publishUnitNote')}<!-- 新闻板块将被发布到整个组织 --></span></div>
						                    <table align="center" border="0"  cellspacing="0" cellpadding="0" class="margin_t_5">
						                        <tr>
						                            <td valign="top">
						                                <div  id="Area0" valign="top" style="width:280px; height:280px; background:#FFF; border:solid 1px #555;overflow:auto;">
						                                  <span id="AreaSpan0" class="publish_tree" style="display: none">
						                                  	<ul id="OrgSectionTree"></ul>
						                                  </span>
						                               </div>
						                            </td>
						                            <td width="50" align="center" class='align_m'>
							                            <span class="ico16 select_selected" title="${ctp:i18n('infosend.label.select')}" onclick="_selectNode()"></span><br><!-- 选择 -->
							                            <span class="ico16 select_unselect" title="${ctp:i18n('infosend.label.delete')}" onclick="_removeNode()"></span><!-- 删除 -->
						                            </td>
						                            <td valign="top">
						                                  <div  style="width:280px; height:280px; background:#FFF; border:solid 1px #555;overflow:auto;">
						                                        <ul id="OrgSelectedTree"></ul>
						                                  </div>
						                            </td>
						                        </tr>
						                    </table>
	                   					</div><!-- tab1_div -->
	                   					<div id="tab2_div">
											<div class="padding_t_5"><em  class="ico16 attribute_16"></em><span style="font-style: oblique;margin-left: 14px;">${ctp:i18n('infosend.magazine.label.publishNote')}<!-- 新闻板块将被发布到整个单位 --></span></div>
						                    <table align="center" border="0"  cellspacing="0" cellpadding="0" class="margin_t_5">
						                        <tr>
						                            <td  valign="top">
						                                 <div id="Area1" valign="top"    style="width:280px; height:280px; background:#FFF; border:solid 1px #555;overflow:auto;">
						                                   <span id="AreaSpan1" class="publish_tree" style="display: none">  
						                                   	<ul id="UnitSectionTree"></ul>
						                                  	</span>
						                                </div>
						                            </td>
						                            <td width="50" align="center" class='align_m'>
							                            <span class="ico16 select_selected" title="${ctp:i18n('infosend.label.select')}" onclick="_selectNode()"></span><br><!-- 选择 -->
							                            <span class="ico16 select_unselect" title="${ctp:i18n('infosend.label.delete')}" onclick="_removeNode()"></span><!-- 删除 -->
						                            </td>
						                            <td  valign="top">
						                                  <div  style="width:280px; height:280px; background:#FFF; border:solid 1px #555;overflow:auto;">
						                                        <ul id="UnitSelectedTree"></ul>
						                                  </div>
						                            </td>
						                        </tr>
						                    </table>
						                </div><!-- tab2_div -->
	                    			</div><!-- tabs_body -->
	                			</td>
	            			</tr>
	            			</tbody>
        				</table>
        			</div><!-- tabs -->
        		</td>
    		</tr>
		</table><!-- selectPeopleTable -->
	    
	    <div class="form_area align_center relative disable" id="viewPublishDiv">
	    	<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
		        <tr>
		            <th nowrap="nowrap"><label id="bullentinPublishTypeLabel" class="margin_r_5" for="text">${ctp:i18n('infosend.magazine.label.publishRange')}<!-- 公告发布范围 -->:</label></th>
		            <td width="100%">
			            <div class="common_txtbox_wrap" id="bullentinPublishRangeDiv0">
			            	<input id="bullentinPublishRangeNames0" disabled="disabled" name="bullentinPublishRangeNames0" />
			            	<input id="bullentinPublishRangeIds0" type="hidden" name="bullentinPublishRangeIds0" />
			            </div>
			            <div class="common_txtbox_wrap" id="bullentinPublishRangeDiv1">
			            	<input id="bullentinPublishRangeNames1" disabled="disabled" name="bullentinPublishRangeNames1" />
			            	<input id="bullentinPublishRangeIds1" type="hidden" name="bullentinPublishRangeIds1" />
			            </div>
		            </td>
		        </tr>
		     </table>	
		     <!-- 
			<input id="checkOrgOrUnit" name="checkOrgOrUnit" type="hidden" value="0"/>   publicViewPeople1   -->
		</div>
		
	</fieldset>
</div>

</body>