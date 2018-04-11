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
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/project/js/projectCommon.js${ctp:resSuffix()}"></script>
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
    <%-- 增加快捷提交操作(回车即提交) --%>
	<span id="spanOk" class="display_none"><a id="btnok" class="common_button common_button_gray" href="javascript:void(0)" onclick="OK()"></a></span>
    <div id="tabs2" class="form_area comp" comp="type:'tab',tabsEquallyWidth:true">
        <div id="tabs2_head" class="common_tabs_3 clearfix">
            <ul class="left">
                <%--基础信息 --%>
                <li id="page1" class="current" onclick="doValidate(1);"><a href="javascript:void(0)"><span>${ctp:i18n('project.body.basicInfo.label')}</span></a></li>
                <%--人员设置 --%>
                <li id="page2" onclick="doValidate(2);"><a href="javascript:void(0)"><span>${ctp:i18n('project.body.personInfo.label')}</span></a></li>
                <%--高级设置 --%>
                <li id="page3" onclick="doValidate(3);"><a href="javascript:void(0)"><span>${ctp:i18n('project.body.advancedInfo.label')}</span></a></li>
            </ul>
        </div>
        <div id="tabs2_body" class="common_tabs_body color_gray2 font_size14">
            <%--基础信息 --%>
            <div id="tab1_div" class="padding_lr_24">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" style="table-layout:fixed;">
                    <%--项目名称:最长100个字 --%>
                    <tr>
                        <td colspan="2" class="padding_t_15"><span class="color_red" style="margin-right:6px;">*</span>${ctp:i18n('project.body.projectName.label')}</td>
                    </tr>
                    <tr>
                        <td colspan="2" class="padding_t_10">
                            <div class="common_txtbox_wrap">
                            	<input id="projectId" type="hidden"/>
                                <input id="projectName" name="projectName" type="text" maxlength="100"  validate="name:'${ctp:i18n('project.body.projectName.label')}',type:'string',notNullWithoutTrim:true,maxLength:100"/>
                            </div>
                        </td>
                    </tr>
                    <%--项目类型&项目编号 --%>
                    <tr>
                        <td class="padding_t_10" width="50%"><span class="color_red" style="margin-right:6px;">*</span>${ctp:i18n('project.body.projectType.label')}</td>
                        <td class="padding_t_10 padding_l_15">${ctp:i18n('project.body.projectNum.label')}</td>
                    </tr>
                    <tr>
                        <td class="padding_r_15 padding_t_10">
                            <div class="common_selectbox_wrap">
                                <select id="projectType" name="projectType" style="vertical-align: top">
                                <c:forEach var="projectType" items="${projectTypeList}">
                                    <option value="${projectType.id}">${ctp:toHTML(projectType.name)}</option>
                                </c:forEach>
                                </select>
                                <input type="hidden" id="projectTypeName"/>
                            </div>
                        </td>
                        <td class="padding_l_15 padding_t_10">
                            <div class="common_txtbox_wrap">
                                <%--项目编号：最长100个字 --%>
                                <input type="text" name="projectNum" id="projectNum" class="validate" maxlength="40" validate="name:'${ctp:i18n('project.body.projectNum.label')}',type:'string',notNull:false,maxLength:40"/>
                            </div>
                        </td>
                    </tr>
                    <%--开始日期&结束日期 --%>
                    <tr>
                        <td class="padding_t_10"><span class="color_red" style="margin-right:6px;">*</span>${ctp:i18n('project.body.startdate.label')}</td>
                        <td class="padding_t_10 padding_l_15"><span class="color_red" style="margin-right:6px;">*</span>${ctp:i18n('project.body.enddate.label')}</td>
                    </tr>
                    <tr>
                        <td class="padding_r_15 padding_t_10">
                            <div class="common_txtbox_wrap" style="width: 210px;margin:0px">
                                <input id="begintime" type="text" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d'" validate="name:'${ctp:i18n('project.body.startdate.label')}',type:'3',notNull:true,needfloat:true"/>
                            </div>
                        </td>
                        <td class="padding_l_15 padding_t_10">
                            <div class="common_txtbox_wrap" style="width: 210px;margin:0px">
                                <input id="closetime" type="text" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d'" validate="name:'${ctp:i18n('project.body.enddate.label')}',type:'3',notNull:true,needfloat:true"/>
                            </div>
                        </td>
                    </tr>
                    <%--项目状态&项目进度（非创建时候显示） --%>
                    <tr id="stateProcessTh" class="display_none">
                        <td class="padding_t_10">${ctp:i18n('project.body.state.label')}</td>
                        <td class="padding_t_10 padding_l_15">${ctp:i18n('project.process.label')}</td>
                    </tr>
                    <tr id="stateProcessTr" class="display_none">
                        <td>
                            <label for="radio1" class="margin_r_10 hand"><input type="radio" value="0" id="projectState" name="projectState" class="radio_com"/>${ctp:i18n('project.body.projectstate.0')}</label>
                            <label for="radio2" class="margin_r_10 hand"><input type="radio" value="2" id="projectState" name="projectState" class="radio_com"/>${ctp:i18n('project.body.projectstate.2')}</label>
                        </td>
                        <td class="padding_l_15 padding_t_10">
                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <div class="common_txtbox_wrap">
                                            <input type="text" id="projectProcess" class="validate" validate="name:'${ctp:i18n('project.process.label')}',isInteger:true, maxValue:100,minValue:0,notNull:true,errorMsg:'${ctp:i18n('taskmanage.input.tips')}'">
                                        </div>
                                    </td>
                                    <td width="15" align="right">%</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <%--描述 --%>
                    <tr>
                        <td colspan="2" class="padding_t_10">${ctp:i18n('project.body.desc.label')}</td>
                    </tr>
                    <tr>
                        <td colspan="2" class="padding_t_10">
                            <div class="common_txtbox  clearfix">
                                <textarea cols="30" rows="5" class="w100b validate" id="projectDesc" validate="name:'${ctp:i18n('project.body.desc.label')}',type:'string',notNull:false,maxLength:1000"></textarea>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
            <%--人员设置 --%>
            <div id="tab2_div" class="hidden padding_lr_15">
                <table width="100%" border="0" cellspacing="5" cellpadding="0" align="center">
                    <%--项目负责人&项目助理 --%>
                    <tr>
                        <td class="padding_t_15" width="50%"><span class="color_red" style="margin-right:6px;">*</span>${ctp:i18n('project.body.responsible.label')}</td>
                        <td class="padding_t_15">${ctp:i18n('project.body.assistant.label')}</td>
                    </tr>
                    <tr>
                        <td class="padding_r_20">
                            <div class="common_txtbox_wrap">
                            	<input id="managers_text" type="text" name="managers_text" readonly="readonly" style="cursor: pointer;" class="validate" validate="notNull:true" onclick="selectProjectPersion('managers');"/> 
                            	<input id="managers" type="hidden" name="managers" />
                            </div>
                        </td>
                        <td>
                            <div class="common_txtbox_wrap">
                            	<input id="assistant_text" type="text" name="assistant_text" readonly="readonly" style="cursor: pointer;" onclick="selectProjectPersion('assistant');"/> 
                            	<input id="assistant" type="hidden" name="assistant" />
                            </div>
                        </td>
                    </tr>
                    <%--项目成员 --%>
                    <tr>
                        <td colspan="2" class="padding_t_10">${ctp:i18n('project.body.members.label')}</td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div class="common_txtbox  clearfix">
                                <textarea id="members_text" name="members_text" cols="30" rows="3" class="w100b" readonly="readonly" style="cursor: pointer;" onclick="selectProjectPersion('members');"></textarea>
                            	<input id="members" type="hidden" name="members" />
                            </div>
                        </td>
                    </tr>
                    <%--项目领导 & 相关人员 --%>
                    <tr>
                        <td class="padding_t_10">${ctp:i18n('project.body.manger.label')}</td>
                        <td class="padding_t_10">${ctp:i18n('project.body.related.label')}</td>
                    </tr>
                    <tr>
                        <td class="padding_r_20">
                            <div class="common_txtbox_wrap">
                            	<input id="charges_text" type="text" name="charges_text" readonly="readonly" style="cursor: pointer;" onclick="selectProjectPersion('charges');"/> 
                            	<input id="charges" type="hidden" name="charges" />
                            </div>
                        </td>
                        <td>
                            <div class="common_txtbox_wrap">
                            	<input id="related_text" type="text" name="related_text" readonly="readonly" style="cursor: pointer;" onclick="selectProjectPersion('related');"/> 
                            	<input id="related" type="hidden" name="related" />
                            </div>
                        </td>
                    </tr>
                    <%--人员权限解释 --%>
                    <tr>
                        <td colspan="2" class="padding_t_10">
                            <a href="###" onclick="javascript:showDescription();">[${ctp:i18n('project.toolbar.comment.label')}]</a>
                        </td>
                    </tr>
                    <%--组公开
                    	不公开：只项目组内可以在选人界面【组】下看到；
                    	公开：非项目组人员的本单位人员可以
                     --%>
                    <tr>
                        <td colspan="2" class="padding_t_8">
                            <div><span class="color_red" style="margin-right:6px;">*</span>${ctp:i18n('project.body.teamopen.label.new')}</div>
                            <div class="common_radio_box clearfix margin_t_5">
                                <label for="radio1" class="margin_r_10 hand color_gray2"><input type="radio" value="0" id="publicGroup" name="publicGroup" class="radio_com">${ctp:i18n('project.body.teamopen.label.open')}</label>
                                <label for="radio2" class="margin_r_10 hand color_gray2"><input type="radio" checked value="1" id="publicGroup" name="publicGroup" class="radio_com">${ctp:i18n('project.body.teamopen.label.noopen')}</label>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
            <%-- 高级设置 --%>
            <div id="tab3_div" class="hidden padding_l_20 padding_r_20">
                <%--项目流程模板 --%>
                <div class="padding_t_10 padding_b_5">${ctp:i18n('project.body.templates.label')}</div>
                <div class="common_txtbox  clearfix">
                    <textarea cols="30" rows="3" class="w100b" name="templatesWeb" id="templatesWeb" onclick="setProjectTemplete('false')" readonly="readonly"></textarea>
					<input type="hidden" name="templates" id="templates" value=""/>
                </div>
                <%--项目阶段 --%>
                <div class="padding_t_10 padding_b_5 clearfix">
                    <span class="left">${ctp:i18n('project.body.phase.label')}</span>
                    <span class="right">
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
                                    <th width="20" align="center"><input type="checkbox" class="padding_l_3" onclick="selectAll(this);" style="margin-left: 4px;"/></th>
                                    <th width="">${ctp:i18n('project.body.StageName.label')}</th>
                                    <th width="35%">${ctp:i18n('project.body.StageTime.label')}</th>
                                </tr>
                            </tbody>
                        </table> 
                    </div>
                    <div class="table_body absolute">
                        <table id="displayStage" width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table edit_table">
                            <tbody id="stageList">
                                <tr class="display_none" id="demo">
                                    <td width="20" align="center"><input type="checkbox" class="margin_b_3"/></td>
                                    <td>2</td>
                                    <td width="35%">3</td>
                                </tr>
                                <c:forEach var="projectPhaseInfo" items="${projectPhaseSet}">
                                <tr>
                                	<td width="20" align="center"><input type="checkbox" value="${projectPhaseInfo.id}" class="margin_b_3"/></td>
                                    <td>${projectPhaseInfo.phaseName}</td>
                                    <td width="35%">${ctp:formatDate(projectPhaseInfo.phaseBegintime)} ~ ${ctp:formatDate(projectPhaseInfo.phaseClosetime)}</td>
                                </tr>
                                </c:forEach>
                            </tbody>
                        </table>    
                    </div>
                </div>
                <div id="autoChangePhaseDiv" class="common_selectbox_wrap <c:if test="${0 == projectPhaseSize}">display_none</c:if>" >
                    <%-- 自动切换项目阶段 --%>
                    <input type="hidden" id="autoChnagePhaseValue" value="${autoChangePhase }">
                	<input type="checkbox" name="autoChangePhase" id="autoChangePhase" onchange="changeCurrentPhaseSelect(this.checked)"/>${ctp:i18n('project.phase.auto.change.label')}
                </div>
                <div id="phaseIdTitle" class="padding_t_10 padding_b_5 <c:if test="${0 == projectPhaseSize}">display_none</c:if>"><span class="color_red" style="margin-right:6px;">*</span>${ctp:i18n('project.body.phase.current.label')}</div>
                <div id="phaseIdDiv" class="common_selectbox_wrap <c:if test="${0 == projectPhaseSize}">display_none</c:if>" >
                    <select id="currentPhaseId" name="currentPhaseId" style="vertical-align: top">
                    	<c:forEach var="projectPhaseInfo" items="${projectPhaseSet}">
                    		<option value="${projectPhaseInfo.id}">${projectPhaseInfo.phaseName}</option>
                    	</c:forEach>
                    </select>
                    <input type="hidden" name="phaseAddList" id="phaseAddList"/>
                    <input type="hidden" name="phaseUpdateList" id="phaseUpdateList"/>
                    <input type="hidden" name="phaseDeleteList" id="phaseDeleteList"/>
                    <input type="hidden" id="initPashList" value="${fn:escapeXml(initPashJSON)}"/>
                </div>
                <%--点击修改项目颜色 --%>
                <div class="padding_t_10 padding_b_5">${ctp:i18n('project.body.backGround.label')}</div>
                <div id="backGroundDiv" class="color_selecter" style="background:${backGround};" onclick="doChangeColor();"><input type="hidden" id="backGround"/></div>
            </div>
        </div>
    </div>
</body>
</form>
<input type="text" id="projectProcessOld" class="hidden" value="${projectProcess}">
</html>
