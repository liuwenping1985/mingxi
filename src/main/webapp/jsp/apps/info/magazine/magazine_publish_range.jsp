<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/apps_res/info/js/magazine_publish.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=infoMagazineManager"></script>
<!-- 初始化加载性的js方法 -->

<!-- 操作性的js方法 -->

<div id="magazinePublishRangeDiv">
   <fieldset class="margin_5 margin_l_20">
    <legend><input type="checkbox" id="viewCheck" name="viewCheck" value="查看页面"/>${ctp:i18n('infosend.score.infoScores.viewPage.label')}<!-- 查看页面 --></legend>
    <div class="form_area align_center relative">
    	<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
	        <tr>
	            <th nowrap="nowrap"><label class="margin_r_5" for="text">${ctp:i18n('infosend.label.seePeople')}<!-- 可查看人员 -->:</label></th>
	            <td width="100%"><div class="common_txtbox_wrap">
	            	<input id="viewPeople" type="text" disabled="disabled" name="viewPeople" />
	            	<input id="viewPeopleId" type="hidden" name="viewPeopleId" />
	            </div></td>
	        </tr>
	     </table>	     
    </div>
</fieldset>
   <fieldset class="margin_5 margin_l_20">
	<legend><input type="checkbox" id="publicInfo" name="publicInfo" value="公共信息"/>${ctp:i18n('infosend.score.infoScores.publicInfo.label')}<!-- 公共信息 --></legend>
	<table id="selectPeopleTable" width="100%"  border="0" class="bg-body1" align="center" cellpadding="0" cellspacing="0" style="display:;">
    <tr valign="top"> 
        <td>
        <div id="tabs2" class="comp" comp="type:'tab',height:313,width:640,showTabIndex:1">
         <table width="100%" border="0" height="100%" cellpadding="0" cellspacing="0">
                        <div id="tabs2_head" class="common_tabs clearfix">
		                     <ul class="left">
		                        <li class="current"><a class="no_b_border" href="javascript:void(0)" tgt="tab1_div" onclick="javascript:checkPublishType(0);">${ctp:i18n('infosend.label.organization')}<!-- 组织 --></a></li>
		                        <li><a  class="no_b_border last_tab" href="javascript:void(0)" tgt="tab2_div" onclick="javascript:checkPublishType(1);">${ctp:i18n('infosend.label.unit')}<!-- 单位 --></a></li>
		                    </ul>
                      	</div>
            <tr>
                <td class="border_t padding_r_10 padding_t_5">
                 <div id="tabs2_body" class="common_tabs_body border_all">
                 <div id="tab1_div">
					<div class="padding_t_5"><em  class="ico16 attribute_16"></em><span style="font-style: oblique; margin-left: 14px;">${ctp:i18n('infosend.magazine.label.publishUnitNote')}<!-- 新闻板块将被发布到整个组织 --></span></div>
                    <table align="center" border="0"  cellspacing="0" cellpadding="0" class="margin_t_5">
                        <tr>
                            <td  valign="top">
                                <div  id="Area2" valign="top" style="width:280px; height:280px; background:#FFF; border:solid 1px #555;overflow:auto;">
                                  <span id="Area2Span" style="display: none"><ul id="orgSectionTree"></span></ul>
                               </div>
                            </td>
                            <td width="50" align="center" class='align_m'>
	                            <span class="ico16 select_selected" title="${ctp:i18n('infosend.label.select')}" onclick="_selectNode()"></span><br><!-- 选择 -->
	                            <span class="ico16 select_unselect" title="${ctp:i18n('infosend.label.delete')}" onclick="_removeNode()"></span><!-- 删除 -->
                            </td>
                            <td valign="top">
                                  <div  style="width:280px; height:280px; background:#FFF; border:solid 1px #555;overflow:auto;">
                                        <ul id="orgSelectedTree"></ul>
                                  </div>
                            </td>
                        </tr>
                    </table>
                   </div>
                   <div id="tab2_div">
					<div class="padding_t_5"><em  class="ico16 attribute_16"></em><span style="font-style: oblique;margin-left: 14px;">${ctp:i18n('infosend.magazine.label.publishNote')}<!-- 新闻板块将被发布到整个单位 --></span></div>
                    <table align="center" border="0"  cellspacing="0" cellpadding="0" class="margin_t_5">
                        <tr>
                            <td  valign="top">
                                 <div id="Area2" valign="top"    style="width:280px; height:280px; background:#FFF; border:solid 1px #555;overflow:auto;">
                                   <span id="Area3Span" style="display: none">  <ul id="UnitSectionTree"></ul></span>
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
                   </div>
                    </div>
                </td>
            </tr>
        </table>
        </div>
        </td>
    </tr>
    
</table>
	     
	    
	    <div class="form_area align_center relative disable" id="viewPublishDiv">
	    	<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
		        <tr>
		            <th nowrap="nowrap"><label class="margin_r_5" for="text">${ctp:i18n('infosend.magazine.label.publishRange')}<!-- 公告发布范围 -->:</label></th>
		            <td width="100%"><div class="common_txtbox_wrap">
		            	<input id="publicViewPeople"  disabled="disabled" name="publicViewPeople" />
		            	<input id="publicViewPeopleId" type="hidden" name="publicViewPeopleId" />
		            </div></td>
		        </tr>
		     </table>	
		     <input id="checkOrgOrUnit" name="checkOrgOrUnit" type="hidden" value="0"/>     
	    </div>
	</fieldset>
</div>

