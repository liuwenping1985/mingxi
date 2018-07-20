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
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/project/js/projectStage.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
    $(document).ready(function() {
    	init();
    }); 
</script>
</head>

<body class="h100b over_hidden">
    <div id="tabs2" class="form_area comp" comp="type:'tab',tabsEquallyWidth:true">
        <div id="tabs2_body" class="common_tabs_body color_gray2 font_size14">
            <div id="tab1_div" class="padding_lr_15">
                <table width="100%" border="0" cellspacing="5" cellpadding="0" align="center" style="table-layout:fixed;">
                    <tr>
                        <td colspan="2" class="padding_t_15"><span class="color_red">*</span>${ctp:i18n('project.phase.name.label')}</td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div class="common_txtbox_wrap">
                            	<input type="hidden" id="phaseId" />
                            	<input type="hidden" id="projectId"/>
                                <input type="text" id="phaseName" name="phaseName" class="validate" maxlength="30" validate="name:'${ctp:i18n('project.phase.name.label')}',type:'string',notNullWithoutTrim:true,avoidChar:'-!@#$%^&*()_+\'&quot;<>',maxLength:30" onchange="isChange();"/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="padding_t_10"><span class="color_red">*</span>${ctp:i18n('project.body.startdate.label')}</td>
                        <td class="padding_t_10"><span class="color_red">*</span>${ctp:i18n('project.body.enddate.label')}</td>
                    </tr>
                    <tr>
                        <td class="padding_r_20">
                            <div>
                                <input id="phaseBegintime" name="phaseBegintime" style="width:98%" type="text" class="comp validate" comp="type:'calendar',ifFormat:'%Y-%m-%d'" validate="name:'${ctp:i18n('project.body.startdate.label')}',type:'3',notNull:true" onchange="isChange();">
                            </div>
                        </td>
                        <td>
                            <div>
                                <input id="phaseClosetime" name="phaseClosetime" style="width:98%" type="text" class="comp validate" comp="type:'calendar',ifFormat:'%Y-%m-%d'" validate="name:'${ctp:i18n('project.body.enddate.label')}',type:'3',notNull:true" onchange="isChange();">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="padding_t_10" width="50%">${ctp:i18n('project.event.alarmFlag')}</td>
                        <td class="padding_t_10" width="50%">${ctp:i18n('project.event.alarmFlag.beforend')}</td>
                    </tr>
                    <tr>
                        <td class="padding_r_20">
                            <div class="common_selectbox_wrap">
                            	<select id="beforeAlarmDate" name="beforeAlarmDate" class="codecfg"  style="vertical-align: top"
    								codecfg="codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.RemindTimeEnums',defaultValue:-1" onchange="isChange();">
                                </select>
                            </div>
                        </td>
                        <td class="padding_r_20">
                            <div class="common_selectbox_wrap">
                            	<select id="endAlarmDate" name="endAlarmDate" class="codecfg"  style="vertical-align: top"
                                	codecfg="codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.RemindTimeEnums',defaultValue:-1" onchange="isChange();">
                                </select>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="padding_t_10">${ctp:i18n('project.body.desc.label')}</td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div class="common_txtbox  clearfix">
                                <textarea id="phaseDesc" name="phaseDesc" cols="30" rows="5" class="w100b validate" maxlength="150" validate="name:'${ctp:i18n('project.body.desc.label')}',notNull:false,maxLength:150" onchange="isChange();"></textarea>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
