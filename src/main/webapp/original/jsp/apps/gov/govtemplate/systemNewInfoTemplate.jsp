<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../info/include/info_header.jsp" %>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum" %>
<html>
<style>
 .bgColor{
 	background-color:transparent;
 }
</style>
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
<script type="text/javascript" src="${path}/ajax.do?managerName=govformAjaxManager,govTemplateManager,templateManager"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/info/js/systemNewInfoTemplate.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/info/js/content.js${ctp:resSuffix()}"></script>

<%@ include file="/WEB-INF/jsp/common/template/template_pub.js.jsp" %>
<script type="text/javascript">
var editorStartupFocus = false;
var templateAuthInfo = '${templateAuthInfo}';
var isSubmitOperation; //直接离开窗口做出提示的标记位 
var _summary_deadline = '${infoSum.deadline}';
var _summary_advanceRemind = '${infoSum.advanceRemind}';
var _summary_formId ='${infoSum.formId}';
var _categoryId = "${categoryId}" ;
var _applicationCategoryEnum_collaboration_key = '<%=ApplicationCategoryEnum.info.key()%>';
var appType = '${appType}';
var formDisableName = "${formDisableName}";
</script>
</head>
<body  scroll="no" style="overflow: hidden">
<form name="sendForm" id="sendForm" action="${path}/govTemplate/govTemplate.do?method=saveInfoTemplate" method="post" class="h100b display_block" style="border: 0px;">
<div id='layout' class="comp" comp="type:'layout'">
    <div id="templateMainData" class="layout_north page_color" layout="height:95,maxHeight:350,minHeight:0">
        <div id="toolbar"></div>
        <div class="hr_heng"></div>
        <input type="hidden" name="newBusiness" id="newBusiness" value="${newBusiness}" />
        <input type="hidden" name="id" id="id" value='${id}' />
        <input type="hidden" name="from" id ="from"  value="${v3x:toHTML(param.from)}" />
        <input type="hidden" id="categoryType" name="categoryType" value="${categoryType}" />
        <input type="hidden" id="appType" name="appType" value="${appType}" />
        <input type="hidden" id="authInfo" name="authInfo" value="${authInfo}" />
        <input type="hidden" name="archiveId" value="${infoSum.archiveId}"/>
        <input type="hidden" name="prevArchiveId" value="${infoSum.archiveId}"/>
        <div class="form_area">
            <table border="0" id='tbTab' cellspacing="0" cellpadding="0" width="100%" align="center">
            <%-- IE9 </td><td>之间有空格，样式错位，只在国产化环境有问题 --%>
                <tr><th width="5%" nowrap="nowrap" style="padding-left:25px" class='bgColor'>
                        	${ctp:i18n('infosend.label.template')}<!-- 模版名称 -->:
                    </th><td width="28%">
                        <div class="common_form_wrap">
                            <!-- 标题 -->
                            <input name="subject" class='w100b' type="text" id="subject" style="color: #000" maxlength="85" inputName="${ctp:i18n('common.subject.label')}" 
                            validate="name:'${ctp:i18n('collaboration.newcoll.subject') }',type:'string',notNull:true,maxLength:85,character:'<>|\'&quot;'" value="${ctp:toHTML(template.subject)}" defaultValue="${ctp:i18n('common.default.subject.value')}">
                        </div>
                    </td><th width="9%" nowrap="nowrap" class='bgColor'>
                    	${ctp:i18n('infosend.govform.withspaceLabel')}<!-- 报&nbsp;送&nbsp;单 -->:
                    </th><td width="23%">
                        <div class="common_form_wrap">
                            <select id="formId" name="formId">
								<c:forEach items="${formNameList }" var="formName">
									<option value="${formName.id }" ${(infoSum.formId==formName.id)?'selected':'' } title="${formName.name }">${formName.name }</option>
								</c:forEach>
                            </select>
                        </div>
                    </td><th nowrap="nowrap" width="9%" class='bgColor'>
                    	<%--  预归档到 --%>
                        ${ctp:i18n('collaboration.prep-pigeonhole.label')}:
                    </th><td width="9%">
                        <div class="common_form_wrap">
                            <select id="colPigeonhole" ${templete.type eq 'text' or templete.type eq 'workflow' ? 'disabled' : '' } class="" onchange="pigeonholeEvent(this)">
                                <option id="defaultOption" value="1">${ctp:i18n('collaboration.deadline.no')}</option><!-- 无 -->
                                <option id="modifyOption" value="2">${ctp:i18n('collaboration.newColl.pleaseSelect')}</option><!-- --请选择-- -->
                                <c:if test="${archiveName ne null && archiveName ne ''}" >
                                    <option value="3" selected>${archiveName}</option>
                                </c:if>
                            </select>
                        </div>
                    </td><th nowrap="nowrap" width="4%" class='bgColor'>
                    </th>
                </tr>
                <tr><th nowrap="nowrap"  style="padding-left:25px" class='bgColor'>
                        <%-- 流程 --%>${ctp:i18n('collaboration.workflow.label')}:
                    </th><td>
	                    <div class="common_form_wrap" style="width: 100%;">
	                            <input id="process_info" name="process_info"  value="${ctp:toHTML(contentContext.workflowNodesInfo)}" 
	                            defaultValue="${ctp:i18n('collaboration.default.workflowInfo.value')}"
	                            readonly="readonly" class="comp edit_flow w100b"
	                            comp="type:'workflowEdit',
	                            defaultPolicyId:'shenhe',
	                            defaultPolicyName:'${ctp:i18n('infosend.magazine.label.audit')}',
	                            formApp:'-1',
	                            formId:'-1',
	                            flowPermAccountId:'<%=AppContext.currentAccountId() %>',
	                            operationName:'-1',
	                            startOperationName:'-1',
	                            moduleType:'info',
	                            isTemplate:true,
	                            workflowId:'${contentContext.wfProcessId==null ? "-1" : contentContext.wfProcessId}'"
	                                            class="common_button_icon comp"  value="${ctp:i18n('common.default.subject.value')}"/>
	                        </div>
                    </td><th nowrap="nowrap" class='bgColor'>
                    	<%-- 流程期限 --%>
                        	${ctp:i18n('infosend.label.process.limit')}<!-- 流程期限 -->:
                    </th><td>
                        <div class="common_form_wrap">
                            <select name="deadline" id="deadline" class="codecfg" onchange="checkDeadLine()"
                                                codecfg="codeId:'collaboration_deadline',defaultValue:'1'">
                            </select>
                        </div>
                    </td><th nowrap="nowrap" class='bgColor'>
                    	<%--  提醒 --%>
                       		${ctp:i18n('common.remind.time.label')}<!-- 提醒 -->:
                    </th><td>
                        <div class="common_form_wrap">
                            <select name="advanceRemind" id="advanceRemind"  class="codecfg" onchange="checkDeadLine()"
                                                codecfg="codeId:'common_remind_time',defaultValue:'1'">
                            </select>
                        </div>
                    </td><th>
                    </th></tr>
                
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
        	<div style="width:0px;height:0px;overflow:hidden; position: absolute;" id="forformlist">
        		<jsp:include page="/WEB-INF/jsp/common/content/content.jsp" />
        		<textarea id="content"></textarea>
        	</div>
           <div class="over_hidden h100b" id="summaryDiv" style="overflow:auto;">
                 <%@ include file="../govform/form_show.jsp" %>
           </div>
        </div>
    </div>
</div>
</form>
</body>
</html>