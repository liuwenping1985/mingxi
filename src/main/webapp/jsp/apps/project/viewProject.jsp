<%--
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
<script type="text/javascript" src="${path}/ajax.do?managerName=projectConfigManager"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/project/js/createProject.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
    $(document).ready(function() {
    	init();
    }); 
</script>
<style type="text/css">
	.padding_lr_24{padding-left: 24px;padding-right: 24px;}
	.padding_t_18{padding-top:18px}
</style>
</head>

<body class="h100b over_hidden">
<form id="formObj" action="#" method="post">
    <div id="tabs2" class="comp" comp="type:'tab',tabsEquallyWidth:true">
        <div id="tabs2_head" class="common_tabs_3 clearfix">
            <ul class="left">
                <li class="current"><a href="javascript:void(0)" tgt="tab1_div"><span>${ctp:i18n('project.body.basicInfo.label')}</span></a></li>
                <li><a href="javascript:void(0)" tgt="tab2_div"><span>${ctp:i18n('project.body.personInfo.label')}</span></a></li>
                <li><a href="javascript:void(0)" tgt="tab3_div"><span>${ctp:i18n('project.body.advancedInfo.label')}</span></a></li>
            </ul>
        </div>
        <div id="tabs2_body" class="common_tabs_body color_gray2 font_size14">
            <div id="tab1_div" class="padding_lr_24">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                    <tr>
                        <td colspan="2" class="padding_t_15"><span class="color_red margin_r_6">*</span>${ctp:i18n('project.body.projectName.label')}</td>
                    </tr>
                    <tr>
                        <td colspan="2" class="padding_t_10">
                            <div class="common_txtbox_wrap">
                            	<input id="projectId" type="hidden"/>
                                <input id="projectName" name="projectName" type="text" disabled="" class="validate" validate="type:'string',notNull:true,maxLength:30"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="padding_t_10" width="50%"><span class="color_red margin_r_6">*</span>${ctp:i18n('project.body.projectType.label')}</td>
                        <td class="padding_t_10 padding_l_15">${ctp:i18n('project.body.projectNum.label')}</td>
                    </tr>
                    <tr>
                        <td class="padding_r_15 padding_t_18">
                            <div class="common_selectbox_wrap">
                                <select id="projectType" name="projectType" disabled>
                                <c:forEach var="projectTypeInfo" items="${projectTypeList}">
                                    <option value="${projectTypeInfo.id}">${ctp:toHTML(projectTypeInfo.name)}</option>
                                </c:forEach>
                                </select>
                            </div>
                        </td>
                        <td class="padding_l_15 padding_t_18">
                            <div class="common_txtbox_wrap">
                                <input type="text" name="projectNum" id="projectNum" disabled=""/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="padding_t_10"><span class="color_red margin_r_6">*</span>${ctp:i18n('project.body.startdate.label')}</td>
                        <td class="padding_t_10 padding_l_15"><span class="color_red margin_r_6">*</span>${ctp:i18n('project.body.enddate.label')}</td>
                    </tr>
                    <tr>
                        <td class="padding_r_15 padding_t_18">
                            <div class="common_txtbox_wrap">
                                <input disabled="" id="begintime" type="text" class="comp validate" />
                            </div>
                        </td>
                        <td class="padding_l_15 padding_t_18">
                            <div class="common_txtbox_wrap">
                                <input disabled="" id="closetime" type="text" class="comp validate" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="padding_t_10">${ctp:i18n('project.body.state.label')}</td>
                        <td class="padding_t_10 padding_l_15">${ctp:i18n('project.process.label')}</td>
                    </tr>
                    <tr>
                        <td>
                            <label for="radio1" class="margin_r_10"><input disabled="" type="radio" value="0" id="projectState" name="projectState" class="radio_com"/>${ctp:i18n('project.body.projectstate.0')}</label>
                            <label for="radio2" class="margin_r_10"><input disabled="" type="radio" value="2" id="projectState" name="projectState" class="radio_com"/>${ctp:i18n('project.body.projectstate.2')}</label>
                            <a href="javascript:void(0)" class="common_button common_button_gray" id="restarteProject" onclick="restarteProject();">${ctp:i18n('project.body.restart.label')}</a>
                        </td>
                        <td class="padding_l_15">
                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <div class="common_txtbox_wrap">
                                            <input disabled="" type="text" id="projectProcess">
                                        </div>
                                    </td>
                                    <td width="15" align="right">%</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="padding_t_10">${ctp:i18n('project.body.desc.label')}</td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div class="common_txtbox  clearfix">
                                <textarea disabled="" cols="30" rows="5" class="w100b" id="projectDesc" class="validate" validate="maxLength:1000"></textarea>
                            </div>
                        </td>
                    </tr>
                    <tr style="display:none">
                        <td colspan="2">
                            <a href="javascript:void(0)" class="common_button common_button_gray">${ctp:i18n('project.body.configuration.label')}</a>
                        </td>
                    </tr>
                </table>
            </div>
            <div id="tab2_div" class="hidden padding_lr_15">
                <table width="100%" border="0" cellspacing="5" cellpadding="0" align="center">
                    <tr>
                        <td class="padding_t_15" width="50%"><span class="color_red margin_r_6">*</span>${ctp:i18n('project.body.responsible.label')}</td>
                        <td class="padding_t_15">${ctp:i18n('project.body.assistant.label')}</td>
                    </tr>
                    <tr>
                        <td class="padding_r_20">
                            <div class="common_txtbox_wrap">
                            	<input disabled="" id="managers_text" type="text" name="managers_text" readonly="readonly" style="cursor: default;" class="validate" validate="notNull:true"/> 
                            	<input id="managers" type="hidden" name="responsible" />
                            </div>
                        </td>
                        <td>
                            <div class="common_txtbox_wrap">
                            	<input disabled="" id="assistant_text" type="text" name="assistant_text" readonly="readonly" style="cursor: default;"/> 
                            	<input id="assistant" type="hidden" name="assistant" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="padding_t_10">${ctp:i18n('project.body.members.label')}</td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div class="common_txtbox  clearfix">
                                <textarea disabled="" id="members_text" name="members_text" cols="30" rows="3" class="w100b" readonly="readonly" style="cursor: default;" ></textarea>
                            	<input id="members" type="hidden" name="members" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="padding_t_10">${ctp:i18n('project.body.manger.label')}</td>
                        <td class="padding_t_10">${ctp:i18n('project.body.related.label')}</td>
                    </tr>
                    <tr>
                        <td class="padding_r_20">
                            <div class="common_txtbox_wrap">
                            	<input disabled="" id="charges_text" type="text" name="charges_text" readonly="readonly" style="cursor: default;"/> 
                            	<input id="charges" type="hidden" name="manger" />
                            </div>
                        </td>
                        <td>
                            <div class="common_txtbox_wrap">
                            	<input disabled="" id="related_text" type="text" name="related_text" readonly="readonly" style="cursor: default;"/> 
                            	<input id="related" type="hidden" name="related" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="padding_t_10">
                            <a href="###" onclick="javascript:showDescription();" >[${ctp:i18n('project.toolbar.comment.label')}]</a>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div><span class="color_red margin_r_6">*</span>${ctp:i18n('project.body.teamopen.label.new')}</div>
                            <div class="common_radio_box clearfix margin_t_5">
                                <label for="radio1" class="margin_r_10  color_gray2"><input disabled="" type="radio" value="0" id="publicGroup" name="publicGroup" class="radio_com">${ctp:i18n('project.body.teamopen.label.open')}</label>
                                <label for="radio2" class="margin_r_10  color_gray2"><input disabled="" type="radio" value="1" id="publicGroup" name="publicGroup" class="radio_com">${ctp:i18n('project.body.teamopen.label.noopen')}</label>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
            <div id="tab3_div" class="hidden padding_l_20 padding_r_20">
                <div class="padding_t_10 padding_b_5">${ctp:i18n('project.body.templates.label')}</div>
                <div class="common_txtbox  clearfix">
                    <textarea disabled="" cols="30" rows="3" class="w100b" name="templatesWeb" id="templatesWeb" readonly="readonly"></textarea>
					<input type="hidden" name="templates" id="templates" value=""/>
                </div>
                <div  class="padding_t_10 padding_b_5 clearfix">
                    <span class="left">${ctp:i18n('project.body.phase.label')}</span>
                    <span class="right display_none">
                    	<em class="ico16 task_add_16 margin_l_5" title="${ctp:i18n('common.toolbar.new.label')}" onclick="stageOperation('add');"></em>
                    	<em class="ico16 task_edit_16 margin_l_5" title="${ctp:i18n('common.toolbar.update.label')}" onclick="stageOperation('update');"></em>
                    	<em class="ico16 del_16 margin_l_5" title="${ctp:i18n('common.toolbar.delete.label')}" onclick="stageOperation('delete');"></em>
                    </span>
                </div>
                <div class="list_content relative" style="height:125px;">
                    <div class=" table_head relative"><!--表头-->
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table edit_table">
                            <tbody>
                                <tr>
                                    <th width="">${ctp:i18n('project.body.StageName.label')}</th>
                                    <th width="35%">${ctp:i18n('project.body.StageTime.label')}</th>
                                </tr>
                            </tbody>
                        </table> 
                    </div>
                    <div class="table_body absolute">
                        <table id="displayStage" width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table edit_table">
                            <tbody id="stageList">
                            	<c:forEach var="projectPhaseInfo" items="${projectPhaseSet}">
                                <tr class="" id="demo">
                                    <td>${projectPhaseInfo.phaseName}</td>
                                    <td width="35%">${ctp:formatDate(projectPhaseInfo.phaseBegintime)} ~ ${ctp:formatDate(projectPhaseInfo.phaseClosetime)}</td>
                                </tr>
                                </c:forEach>
                            </tbody>
                        </table>    
                    </div>
                </div>
                <c:if test="${0 != projectPhaseSize}">
                <div id="phaseIdTitle" class="padding_t_10 padding_b_5"><span class="color_red margin_r_6">*</span>${ctp:i18n('project.body.phase.current.label')}</div>
                <div id="phaseIdDiv" class="common_selectbox_wrap" >
                    <select disabled id="currentPhaseId" name="currentPhaseId">
                    	<c:forEach var="projectPhaseInfo" items="${projectPhaseSet}">
                    		<option value="${projectPhaseInfo.id}">${projectPhaseInfo.phaseName}</option>
                    	</c:forEach>
                    </select>
                    <input type="hidden" id="initPashList" value="${fn:escapeXml(initPashJSON)}"/>
                </div>
                </c:if>
                <div class="padding_t_10 padding_b_5">${ctp:i18n('project.body.backGround.label')}</div>
                <div class="color_selecter" style="background:${backGround};cursor: default;"><input type="hidden" id="backGround" value=""/></div>
            </div>
        </div>
    </div>
</body>
</form>
</html>
