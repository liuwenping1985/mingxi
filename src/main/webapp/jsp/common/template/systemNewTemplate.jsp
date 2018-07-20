<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style type="text/css">
    /*固定宽度的样式*/
    .fixed_width { width: 170px; _width: 180px; }
    /*自适应宽度的样式*/
    .adapt_width { overflow: hidden; margin: auto; }
    .adtional { width: 30px; }
    th{padding-left: 10px;padding-right: 10px;}
</style>
<%@ include file="/WEB-INF/jsp/common/template/collaborationTemplate_pub.js.jsp" %>
<script type="text/javascript" src="${path}/ajax.do?managerName=templateManager"></script>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/collaboration/collFacade.js.jsp" %>
<script type="text/javascript" src="${path}/ajax.do?managerName=colManager,pendingManager"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/collaboration.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/systemNewTemplate.js${ctp:resSuffix()}"></script>

<%@ include file="/WEB-INF/jsp/apps/collaboration/js/template_pub.js.jsp" %>
<script type="text/javascript">
var checkPDFIsNull=true; //标记是新建模板
var templateAuthInfo = '${templateAuthInfo}';
var isSubmitOperation; //直接离开窗口做出提示的标记位 
var _summary_deadline = '${summary.deadline}';
var _summary_advanceRemind = "${summary.advanceRemind}";
var _template_standardDuration = "${template.standardDuration}";
var _summary_importantLevel = "${summary.importantLevel}";
var _categoryId = "${categoryId}" ;
var _template_type = "${template.type}";
var _templateNotNull = "${template ne null}";
var _applicationCategoryEnum_collaboration_key = '<%=ApplicationCategoryEnum.collaboration.key()%>';
var _template_cantrackworkflowtype ='${template.canTrackWorkflow}';
var _bodyType = '${template.bodyType}';
</script>
</head>
<body  scroll="no" style="overflow: hidden">
<form name="sendForm" id="sendForm" action="${path}/collTemplate/collTemplate.do?method=saveCollaborationTemplate" method="post" class="h100b display_block" style="border: 0px;">
<div id='layout' class="comp" comp="type:'layout'">
    <%@ include file="/WEB-INF/jsp/common/supervise/supervise.js.jsp" %>
    <div id="templateMainData" class="layout_north page_color" layout="height:95,maxHeight:350,minHeight:0">
        <div id="toolbar"></div>
        <div class="hr_heng"></div>
        <input type="hidden" name="newBusiness" id="newBusiness" value="${newBusiness}" />
        <input type="hidden" name="id" id="id" value='${id}' />
        <input type="hidden" name="from" id ="from"  value="${param.from}" />
        <input type="hidden" id="categoryType" name="categoryType" value="${categoryType}" />
        <input type="hidden" id="authInfo" name="authInfo" value="${authInfo}" />
        <input type="hidden" id="archiveId" name="archiveId" value="${summary.archiveId}" />
        <input type="hidden" id="prevArchiveId" name="prevArchiveId" value="${summary.archiveId}" />
        <input type="hidden" id="process_info_bak" name="process_info_bak" value="" />
        <input type="hidden" id="process_xml_bak" name="process_xml_bak" value="" />
        <div class="form_area">
            <table border="0" id='tbTab' cellspacing="0" cellpadding="0" width="100%" align="center">
                <tr>
                    <th width="5%" nowrap="nowrap" style="padding-left:25px">
                        ${ctp:i18n('common.subject.label')}:
                    </th>
                    <td width="28%" colspan="2">
                        <div class="common_form_wrap">
                            <!-- 标题 -->
                            <input name="subject" type="text" id="subject" style="color: #000" maxlength="60" inputName="${ctp:i18n('common.subject.label')}" 
                            validate="name:'${ctp:i18n('collaboration.newcoll.subject') }',type:'string',notNull:true,maxLength:60,character:'<>|\'&quot;'" value="${ctp:toHTML(template.subject) }" defaultValue="${ctp:i18n('common.default.subject.value')}">
                        </div>
                    </td>
                    <th width="9%" nowrap="nowrap">
                    	<%-- 模板类型 --%>
                        ${ctp:i18n('collaboration.template.type.label')}:
                    </th>
                    <td width="20%">
                        <div class="common_form_wrap">
                            <select id="type" name="type" onchange="preAlertChangeType(this)">
                                <%-- 动态参数 <fmt:message key='templete.category.type.${param.categoryType}' /></option> --%>
                                <option value="template" ${template.type eq 'templete' ? 'selected' : '' }>${ctp:i18n('collaboration.template.category.type.0')}</option>
                                <option value="text" ${template.type eq 'text' ? 'selected' : '' }>${ctp:i18n('collaboration.template.text.label')}</option>
                                <option value="workflow" ${template.type eq 'workflow' ? 'selected' : '' }>${ctp:i18n('collaboration.template.workflow.label')}</option>
                            </select>
                        </div>
                    </td>
                    <th width="9%" nowrap="nowrap">
                    	<%-- 模板分类 --%>
                         ${ctp:i18n('collaboration.template.toolbar.category')}:
                    </th>
                    <td width="23%" colspan="3">
                        <div class="common_form_wrap">
                            <select name="categoryId" id="categoryId" class="input-100per">
                                ${categoryHTML}
                            </select>
                        </div>
                    </td>
                    <th nowrap="nowrap" width="6%">
                        <a id="advance" href="#"  class="margin_r_20">${ctp:i18n('common.advance.label')}</a>
                    </th>
                </tr>
                <tr>
                    <th nowrap="nowrap" width="5%"  style="padding-left:25px">
                    	<%-- 流程 --%>
                        ${ctp:i18n('collaboration.workflow.label')}:
                    </th>
                    <td width="20%">
                        <div class="common_form_wrap" style="width: 100%;">
                            <input id="process_info" name="process_info" style="font-size:12px;" value="${ctp:toHTML(contentContext.workflowNodesInfo)}" 
                            readonly="readonly" class="comp edit_flow w100b"
                            comp="type:'workflowEdit',
                            defaultPolicyId:'collaboration',
                            defaultPolicyName:'${ctp:i18n("collaboration.newColl.collaboration")}',
                            formApp:'-1',
                            formId:'-1',
                            flowPermAccountId:'<%=AppContext.currentAccountId() %>',
                            operationName:'-1',
                            startOperationName:'-1',
                            moduleType:'${contentContext.moduleTypeName}',
                            isTemplate:true,
                            workflowId:'${contentContext.wfProcessId==null ? "-1" : contentContext.wfProcessId}'"
                                            class="common_button_icon comp"  value="${ctp:i18n('common.default.subject.value')}"/>
                        </div>
                    </td>
                    <td width="8%" style="text-align: right;" class="padding_l_10">
                        <div class="common_form_wrap" >
                            <!--复制自 -->
                            <input type="button" value="${ctp:i18n('template.systemNewTem.copyForm')}" 
                            id="copyFlow" class="common_button_icon comp" style="height: 25px;font-size: 12px;border: 1px solid #CCC;background: #EAEAEA;border-radius: 5px;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;max-width: 91px;display: inline-block;padding: 0 10px;line-height: 24px;vertical-align: middle;_vertical-align: baseline;display: inline-block;"/>
                        </div>
                    </td>
                    <th nowrap="nowrap" width="9%">
                    	<%-- 重要程度 --%>
                        ${ctp:i18n('common.importance.label')}:
                    </th>
                    <td width="20%">
                        <div class="common_form_wrap">
                            <select id="importantLevel" name="importantLevel" class="codecfg" codecfg="codeId:'common_importance',defaultValue:1"></select>
                        </div>
                    </td>
                    <th nowrap="nowrap" width="9%">
                    	<%--  预归档到 --%>
                        ${ctp:i18n('collaboration.prep-pigeonhole.label')}:
                    </th>
                    <td width="9%">
                        <div class="common_form_wrap">
                            <select id="colPigeonhole" ${templete.type eq 'text' or templete.type eq 'workflow' ? 'disabled' : '' } class="" onchange="pigeonholeEvent(this)">
                                <option id="defaultOption" value="1">${ctp:i18n('collaboration.deadline.no')}</option><!-- 无 -->
                                <option id="modifyOption" value="2">${ctp:i18n('collaboration.newColl.pleaseSelect')}</option><!-- --请选择-- -->
                                <c:if test="${archiveName ne null && archiveName ne ''}" >
                                    <option value="3" selected>${archiveName}</option>
                                </c:if>
                            </select>
                        </div>
                    </td>
                    <c:if test="${v3x:getSysFlagByName('project_notShow')!='true'}">
	                    <th width="5%" nowrap="nowrap">
	                    	<%--  关联项目 --%>
	                        ${ctp:i18n('collaboration.project.label')}:
	                    </th>
	                    <td width="9%">
	                        <div class="common_form_wrap">
	                            <select id="projectId" name="projectId" ${templete.type eq 'text' or templete.type eq 'workflow' ? 'disabled' : '' }>
	                                <option value="">${ctp:i18n('collaboration.project.nothing.label')}</option>
	                                <c:forEach items="${relevancyProject}" var="project">
	                                    <option value="${project.id}" ${summary.projectId == project.id ? 'selected' : ''}>${v3x:toHTML(project.projectName)}</option>
	                                </c:forEach>
	                            </select>
	                        </div>
	                    </td>
                    </c:if>
                    <td width="6%" >
                    </td>
                </tr>
                <tr>
                    <td colspan="9">
                    </td>
                </tr>
           </table>
        </div>
        <div id="attachmentTR" style="display:none;">
            <div id='myAttonly' class="clearfix margin_t_5">
                <div class="font_size12 left margin_r_5 margin_l_5"><span class="padding_r_5">${ctp:i18n('common.attachment.label')}: </span>(<span id="attachmentNumberDiv"></span>)</div>
                <div id="myfile" style="display:none;float: right;" class="comp" comp="type:'fileupload',applicationCategory:'1',canDeleteOriginalAtts:true,originalAttsNeedClone:true,canFavourite:false" attsdata='${attListJSON}'></div>
            </div>
        </div>
    </div>
    <div class="layout_center over_hidden page_color" layout="border:false">
        <div class="stadic_layout h100b w100b">
                    <div id="comment_deal" class="fixed_width right h100b border_all adtional">
                        <input type="hidden" id="id" value="${commentSenderList[0].id}">
                        <input type="hidden" id="pid" value="0">
                        <input type="hidden" id="clevel" value="1">
                        <input type="hidden" id="path" value="00">
                        <input type="hidden" id="moduleType" value="${contentContext.moduleType}">
                        <input type="hidden" id="moduleId" value="${contentContext.moduleId}">
                        <input type="hidden" id="extAtt1">
                        <input type="hidden" id="ctype" value="-1">
                        <table class="newTemplateTableHeight" width="100%" height="100%" cellpadding="0" cellspacing="0">
                            <tr>
                                <td class="absolute" height="20" class="padding_t_5">
                                    <div id="adtional_ico" class="adtional_ico"><em class="ico16 arrow_2_l margin_t_5"></em></div>
                                    <%-- 附言 --%>
                                    <span class="adtional_text font_size12">${ctp:i18n('collaboration.newcoll.dangfu')}<em></em>${ctp:i18n('collaboration.newcoll.dangyan')}</span>
                                    <%-- 附言(500字以内) --%>
                                    <div class="color_gray editadt_title margin_lr_5 padding_tb_5 hidden">${ctp:i18n('collaboration.newcoll.fywbzyl')}</div>
                                </td>
                            </tr>
                            <tr>
                                <td class="editadt_box hidden">
                                    <div class="absolute" id="colTem" name="colTem">
                                        <c:set value="${ctp:i18n('collaboration.newcoll.fuyan')}" var="sdfy"/>
                                        <textarea class="validate" validate="maxLength:500,name:'${sdfy}'" id="content_coll" name="content_coll" >${commentSenderList[0].content}</textarea>
                                    </div>
                                </td>
                            </tr>                   
                        </table>
                    </div>
           <div class="over_hidden h100b">
                <jsp:include page="/WEB-INF/jsp/common/content/content.jsp" />
           </div>
        </div>
    </div>
    <div id="advanceHTML" class="hidden">
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="font_size12 margin_t_5">
            <tr>
            	<%-- 流程期限 --%>
                <td width="30%" nowrap="nowrap" class="bg-gray align_right">${ctp:i18n('collaboration.process.cycle.label')}：</td>
                <td width="70%">
                    <select id="deadline" name="deadline" onchange="checkDeadLine()" class="codecfg" value="${summary.deadline}"
                        codecfg="codeId:'collaboration_deadline',defaultValue:1">
                    </select>
                </td>
            </tr>
            <tr>
                <td colspan="2" height="5"></td>
            </tr>
            <tr>
            	<%--基准时长 --%>
                <td width="30%" nowrap="nowrap" class="bg-gray align_right">${ctp:i18n('common.reference.time.label')}：</td>
                <td width="70%">
                    <select id="referenceTime" name="referenceTime" class="codecfg"
                        codecfg="codeId:'collaboration_deadline',defaultValue:1">
                    </select>
                </td>
            </tr>
            <tr>
                <td colspan="2" height="5"></td>
            </tr>
            <tr>
            	<%--提前提醒时间 --%>
                <td width="30%" nowrap="nowrap" class="bg-gray align_right">${ctp:i18n('collaboration.node.advanceremindtime')}：</td>
                <td width="70%">
                    <select id="advanceRemind" name="advanceRemind" onchange="checkDeadLine();" value="${summary.advanceRemind }" class="codecfg"
                        codecfg="codeId:'common_remind_time',defaultValue:1">
                    </select>
                </td>
            </tr>
             <tr>
                <td colspan="2" height="5"></td>
            </tr>
            <tr>
            	<%--是否追溯流程 --%>
                <td width="30%" nowrap="nowrap" class="bg-gray align_right">${ctp:i18n("collaboration.newcoll.isNoProcess")}</td>
                <td width="70%">
                    <select id="canTrackWorkFlow" name="canTrackWorkFlow" onchange="" value="" <c:if test='${template.type == "text"}'>disabled</c:if> >
                    	<option value="0">${ctp:i18n("collaboration.newcoll.undoRollback")}</option>
                    	<option value="1">${ctp:i18n("collaboration.newcoll.trace") }</option>
                    	<option value="2">${ctp:i18n("collaboration.newcoll.noTrace") }</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td colspan="2" class="separatorDIV" height="2"></td>
            </tr>
            <tr>
                <td colspan="2" style="padding-left: 116px"  class="padding_t_5">
                    <div style="height: 28px;">
                        <label for="canForward">
                        	<%--转发 --%>
                            <input type="checkbox" class="padding_r_5" name="canForward" id="canForward" value="1" <c:if test="${template.type == 'workflow'}">disabled</c:if> <c:if test="${summary.canForward}">checked</c:if> />
                            ${ctp:i18n('collaboration.allow.transmit.label')}
                        </label>
                    </div>

                    <div style="height: 28px;">
                        <label for="canModify">
                        	<%--改变流程 --%>
                            <input type="checkbox" class="padding_r_5" name="canModify" id="canModify"  value="1" <c:if test='${template.type == "text"}'>disabled</c:if> <c:if test="${summary.canModify}">checked</c:if> />
                            ${ctp:i18n('collaboration.allow.chanage.flow.label')}
                        </label>
                    </div>

                    <div style="height: 28px;">
                        <label for="canEdit">
                        	<%--修改正文 --%>
                            <input type="checkbox" class="padding_r_5" name="canEdit" id="canEdit"  value="1" <c:if test="${template.type == 'workflow'}">disabled</c:if> <c:if test="${summary.canEdit}">checked</c:if> />
                            ${ctp:i18n('collaboration.allow.edit.label')}
                        </label>
                    </div>
                    <div style="height: 28px;">
                        <label for="canEditAttachment">
                        	<%--修改附件 --%>
                            <input type="checkbox" class="padding_r_5" name="canEditAttachment" id="canEditAttachment" value="1" <c:if test="${template.type == 'workflow'}">disabled</c:if> <c:if test="${summary.canEditAttachment}">checked</c:if> />
                            ${ctp:i18n('collaboration.allow.edit.attachment.label')}
                        </label>
                    </div>
                    <div style="height: 28px;">
                        <label for="canArchive">
                        	<%--归档 --%>
                            <input type="checkbox" class="padding_r_5" name="canArchive" id="canArchive" value="1" <c:if test="${template.type == 'workflow'}">disabled</c:if>  <c:if test="${summary.canArchive}">checked</c:if> />
                            ${ctp:i18n('collaboration.allow.pipeonhole.label')}
                        </label>
                    </div>
                    <div style="height: 28px;">
                        <label for="canAutoStopFlow">
                        	<%--流程期限到时自动终止 --%>
                            <input type="checkbox" class="padding_r_5" name="canAutoStopFlow" id="canAutoStopFlow" value="1"  disabled="true" <c:if test="${template.type == 'workflow'}">disabled</c:if> <c:if test="${summary.canAutostopflow}">checked</c:if> />
                            ${ctp:i18n('collaboration.allow.autostopflow.label')}
                        </label>
                    </div>
                     <div style="height: 28px;">
                        <label for="isMergeDeal">
                            <%--合并处理 --%>
                            <input type="checkbox" class="padding_r_5" name="canMergeDeal" id="canMergeDeal" value="1"  <c:if test="${template.type == 'text'}">disabled</c:if> <c:if test="${summary.canMergeDeal}">checked</c:if> />
                            ${ctp:i18n('collaboration.allow.canmergedeal.label')}
                        </label>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2" class="separatorDIV" height="2"></td>
            </tr>
            <tr>
                <td width="30%" class="bg-gray align_right">${ctp:i18n('collaboration.template.number.label')}：</td>
                <td width="70%"><input type="text" id="templeteNumber" name="templeteNumber" class="" value="${template.templeteNumber}" maxlength="20">
                <input type="hidden" name="templeteId4Number" value="">
                </td>
            </tr>
            <tr>
                <td colspan="2" height="28" class="description-lable padding_t_5 color_gray2" style="padding-left: 116px">${ctp:i18n('collaboration.template.number.description.label')}</td>
            </tr>
        </table>
    </div>
</div>
</form>
</body>
</html>