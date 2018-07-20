<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum"%>
<%@ include file="/WEB-INF/jsp/common/common4coll.jsp"%>
<html class="h100b over_hidden">
<style>
 .bgcolor{background-color:transparent;}
 /*覆盖表单引过来的样式*/
body th { background: #FAFAFA;}
/*xl 6-24*/
.layout_east,.layout_east .clearfix table th{
	background-color:#f0f6f8;
}
.layout_east .new_page{
	padding-top:0;
	margin-bottom:0;
}
.layout_center .common_tabs a{line-height:32px;}
.xl_block{
	background-color:#f8f8f8;
	padding:15px 0;
	border-bottom:1px solid #e4e4e4;
	border-top:1px solid #ddd;
	-moz-box-shadow: 0px 0px 20px 0px #ddd;/*firefox*/
	-webkit-box-shadow: 0px 0px 20px 0px #ddd;/*safari或chrome*/
	box-shadow: 0px 0px 20px 0px #ddd;/*opera或ie9*/
	position:relative;
	z-index:99999;
}
.layout_east .w30b{
	width:80%;
}
.layout_east .xl_padding_r_0{
	padding-right:0;
}

</style>
<head>
	<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x" %>
	<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/template/template.js.jsp" %>
    <%@ include file="/WEB-INF/jsp/apps/collaboration/new_print.js.jsp" %>
    <%@ include file="/WEB-INF/jsp/ctp/form/design/formDevelopmentOfadv.jsp" %>
	<%@ include file="/WEB-INF/jsp/project/project_select.js.jsp"%>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<script type="text/javascript" src="${path}/ajax.do?managerName=trackManager,formManager,orgManager,edocDocTemplateManager,govdocExchangeManager,edocManager,memberManager,docHierarchyManager"></script>
	<title>${ctp:i18n('collaboration.newcoll.htmltitle')}</title>
    <c:set value="${vobj.template.type != 'text'}" var="nonTextTemplete" />
    <c:set value="${vobj.template.type != 'workflow'}" var="notworkflowTemplate" />
    <c:set value="${vobj.template!=null && vobj.systemTemplate}" var="isSystemTemplete" />
    <c:set value="${zwModuleId != null ? zwModuleId : '-1'}" var="zwModuleId" />
    <c:set value="${zwContentType != null ? zwContentType : '10'}" var="zwContentType" />
    <c:set value="${zwRightId != null ? zwRightId : ''}" var="zwRightId" />
    <c:set value="${zwIsnew != null ? zwIsnew : 'true'}" var="zwIsnew" />
    <c:set value="${zwViewState != null ? zwViewState : ''}" var="zwViewState" />
	<script type="text/javascript">
			var allowCommentInForm = "${allowCommentInForm}";
			var newGovdocView = "${newGovdocView}";
			//新布局设置
			getCtpTopFromOpener(window).token_flowup = "${newGovdocView}" == '1'?true:false;
			var reSendSeceretLevel = "${vobj.summary.secretLevel}";
			if(reSendSeceretLevel){
				flowSecretLevel_wf = reSendSeceretLevel;
			}
			var resourceCode = "${param._resourceCode}";
			var vobjTemplateId = "${vobj.templeteId}";
			var isWaitSend = "${isWaitSend}";
			var isNewGovdoc = "${govdocBodyType}";
			var forwardFawen = "${forwardFawen}";
			var contentT = "${contentT}";
			var isGovdocTemplate = "${isGovdocTemplate }";
			var isGovdocSystemTemplate = "${isGovdocSystemTemplate }";
			var noContent = "${noContent }";
			var taohongTemplete = "${taohongTemplete }";
			var noselfflow = "${noselfflow }";
			var zwModuleId = "${zwModuleId}";
			var jsonPerm = $.parseJSON('${curJsonPerm}');
			var _govDocFormType = "${_govDocFormType}";
	        var fullEditorURL="${path}/edocController.do?method=fullEditor";
	   		// 正文组件判断，新建页面
    		var bIsContentNewPage = true;
			var bIsClearContentPadding = ${vobj.template.bodyType == 20 ? false : true};
			var checkPDFIsNull=false; //保存个人模板的标记，个人协同模板允PDF正文许为空
			//服务器时间和本地时间的差异
			var server2LocalTime = <%=System.currentTimeMillis()%> - new Date().getTime();
			var isForm ='${vobj.form}';
			var isFromTemplate = '<c:out value="${isFromTemplate}" default="false" />';
			var templateFlag = '<c:out value="${isSystemTemplete}" default="false" />';
			//移动newCollaboration.js.jsp 变量开始
			var zdgzid ="${vobj.forGZShow}";
			var htdbry ="${vobj.forShow}";
			var officeOcxUploadMaxSize = "${officeOcxUploadMaxSize}";
			var bodyType = '${vobj.summary.bodyType}';
			var bodyType_govdoc = "${govdocBodyType=='' || (govdocBodyType==null) ? 'OfficeWordOrWps' : govdocBodyType}"; //新增公文正文bodytype，默认officeWord
			var paramfrom = "${ctp:escapeJavascript(param.from)}";
            var from = "${ctp:escapeJavascript(from)}";
			var wfXmlInfo = '${vobj.wfXMLInfo}';
			var _callTemplateId = '${param.templateId}';
			var isformTemplate = '${vobj.template!=null && vobj.template.bodyType == 20}';
			var uuidlong = '${uuidlong}';
			var ishideconotentType = ('${vobj.systemTemplate}' == 'true' && ('${vobj.template.type}' != 'workflow')) || ('${_hideContentType}' =='1');
			var istranstocol = '${transtoColl}' =='true';
			var transOfficeId ='${transOfficeId}' != '';
			var isneedsendcheck = '${vobj.summary.newflowType}' != '2' && '${subState}' != '16';
			var isSysTem = ${vobj.template!=null && vobj.systemTemplate};
			var isTemFlag = '${vobj.template ne null}';
			var importantL = '${vobj.summary.importantLevel}';
			var curSummaryID = '${!empty vobj.summary.id?vobj.summary.id:param.curSummaryID}';
			var deadl = '${vobj.summary.deadline}';
			var advanceR = '${vobj.summary.advanceRemind}';
			var vobjtrackids = "${vobj.trackIds}";
			var vobjcolsupnames = '${vobj.colSupervisorNames}';
			var vobjcolSupors = '${vobj.colSupervisors}';
			var vobjcolsupDate = '${vobj.superviseDate}';
			var sumcanforward = !"${vobj.summary.canForward}";
			var sumcanmodify = !"${vobj.summary.canModify}";
			var sumcanEdit = !"${vobj.summary.canEdit}";
			var sumcanEditAtt = !"${vobj.summary.canEditAttachment}";
			var sumcanArchive = !"${vobj.summary.canArchive}";
			var sumcanautostop = "${vobj.summary.canAutostopflow}" && "${vobj.summary.canAutostopflow}" =="0";
			var vobjreadonly = '${vobj.readOnly}' == 'true';
			var isneedsetDetailwhenwftem =  '${vobj.templeteId}' && '${vobj.template.type}' =='workflow' && '${isSystemTemplete}'=='true';
			var vobjparentColTem = '${vobj.parentColTemplete}'=='true';
			var vobjparenttexttype = '${vobj.template.type}' =='text';
			var waitsendflag = "${ctp:escapeJavascript(vobj.from)}" != 'waitSend';
			var vobjparentwftem = '${vobj.parentWrokFlowTemplete}' =='true';
			var vobjstanddur = '${vobj.standardDuration}';
			var frompeoplecardflag = '${ctp:toHTML(peopeleCardInfo)}';
			var peoplecardinfoID = '${peopeleCardInfo.id}';
			var peoplecardinfoname = '${peopeleCardInfo.name}';
			var peoplecardinfoaccountid = '${peopeleCardInfo.orgAccountId}';
			var issameaccountflag = ${isSameAccount == 'false'};
			var accountobjsn = '${accountObj.shortName}';
			var warnforsupervise = '${noDepManager}' == 'true' && ${param.from ne 'waitSend'};
			var tracktypeeq2 = ${trackType eq 2};
			var fgzids = '${forGZIds}';
			var tracktypeeq0 = ${trackType eq 0};
			var savedrafttemVal = '${subState}' != '16';
			var issystemtemflag = '${vobj.template!=null && vobj.systemTemplate}' == 'true';
			var curlocationPath = '${path}';
			var useforsavetemsubjectflag = "${ctp:toHTML(vobj.template.subject)}";
			var useforsavetemsubject = '${ctp:escapeJavascript(vobj.template.subject)}';
			var saveastemtype ='${vobj.template.type}';
			var pipeinfo1 = v3x.getMessage("collaborationLang.collaboration_alertPigeonholeItemFailure");
			var pipeinfo2 = v3x.getMessage("collaborationLang.file_save");
			var pipeinfo3 = v3x.getMessage("collaborationLang.submit");
			var pipeinfo4 = v3x.getMessage("collaborationLang.collaboration_alertPigeonholeItemFailure");
			var pipeinfo5 = v3x.getMessage("collaborationLang.cancel");
			var contentViewState = '${contentViewState}';
			var ordinalTemplateIsSys ='${ordinalTemplateIsSys}';
			var superviseTip = "${ctp:i18n('collaboration.common.common.supervise.specialCharacters')}";
			var _expansion ="${ctp:i18n('collaboration.new.label.expansion')}";
			var _collapse ="${ctp:i18n('collaboration.new.label.collapse')}";
			var customSetTrackFlag = '${customSetTrack}' == 'true';
			var _bizConfig = "${vobj.from eq 'bizconfig'}" == "true";
			var projectId ="${vobj.projectId}";
			var _isProjectDisabled = ${disabledProjectId eq '1'};
			var _isResendFlag = ${isResend eq '1'};
			//移动newCollaboration.js.jsp 变量结束
			//工作流相关的信息  摘自 include_variables.jsp 开始
			var mtCfg = ${contentCfg != null?contentCfg.mainbodyTypeListJSONStr:'[]'};
			var mtCfg_govdoc = ${contentCfg != null?contentCfg.mainbodyTypeListJSONStr:'[]'}; //为公文正文建立正文类型变量
			var useWorkflow = "${contentCfg.useWorkflow}";
			var app = "${app}";
			var sub_app = "${sub_app}";
			var defaultFormId = "${defaultFormId}";
			var allFormList = ${formList};
			var distributeContentDataId  = "${distributeContentDataId }";
			var isFenban = "${isFenban }";
			var distributeContentTemplateId  = "${distributeContentTemplateId }";
			var distributeAffairId  = "${distributeAffairId }";
			var oldSummaryId  = "${oldSummaryId }";
			var forwardText = "${forwardText }";
			var forwardAffairId = "${forwardAffairId}";
			<c:if test="${contentCfg.useWorkflow}">
				var wfItemId = '${contentContext.wfItemId}';
				var wfProcessId = '${contentContext.wfProcessId}';
				var wfActivityId = '${contentContext.wfActivityId}';
				var CurrentUserId = '${CurrentUser.id}';
				var wfCaseId = '${contentContext.wfCaseId}';
				var loginAccount = '${CurrentUser.loginAccount}';
				var moduleTypeName = '${contentContext.moduleTypeName}';
			</c:if>
			//工作流相关的信息  摘自 include_variables.jsp 结束
			//快速发文  xuker add 20160314 start
			var isQuickSend ="${isQuickSend}";

			//记录是否进行了正文修改
			var contentUpdate=false;
			var changeWord = false ;//正文修改，主要用于区别套红 签章操作与修改正文
			var hasTaohong = false;//套红记录
			var changeSignature = false ;//签章
			var extendArray = new Array();
			var taohongFileUrl="";
			var currContentNum = 0;
			var contentOfficeId=new Properties();
			//快速发文  xuker add 20160314 end
			//***************
			//lilong 快速选人变量 0326
			getCtpTopFromOpener(window).distroy_token = false;
			<c:if test="${subState ne '16'}">
			    <c:if test="${((onlyViewWF && isSystemTemplete)  || vobj.parentWrokFlowTemplete || vobj.parentColTemplete) && nonTextTemplete}">
			    //正常但是有模板，需要屏蔽token
			    getCtpTopFromOpener(window).distroy_token = true;
			    </c:if>
			</c:if>
			<c:if test="${subState eq '16'}">
			  //指定回退
			  getCtpTopFromOpener(window).distroy_token = true;
			</c:if>
			if((paramfrom && paramfrom == 'resend')  //重复发起 OA-55334
					|| (isTemFlag && isTemFlag == 'true') //个人模板 OA-55428
					|| (paramfrom && paramfrom == 'waitSend')){  //OA-55492 撤销或者保存待发过来的屏蔽

				getCtpTopFromOpener(window).distroy_token = true;

			}
			if(frompeoplecardflag){
				getCtpTopFromOpener(window).distroy_token = true;
			}
			//xuker 快速发文 流程input下拉框置灰，不允许编辑 start
			if(isQuickSend=='true'){
				getCtpTopFromOpener(window).distroy_token = true;
			}
			//xuker 快速发文 流程input下拉框置灰，不允许编辑 end
			$("#process_info_div").click(function(){
				$("#token-input-process_info").css("color","#111");
			});
			$("#token-input-process_info").live("keydown", function(){
				$("#token-input-process_info").css("color","#111");
			});
			var edocDocTemplateManager = new edocDocTemplateManager();
			var workflowId = '${vobj.template.workflowId}';
			//**************
			function createWorkflowView(){
			    tidyDatas("process_info");
				var au = $.ctx.CurrentUser;
				showWFTDiagram(getCtpTop(), '${contentContext.wfProcessId==null ? "-1" : contentContext.wfProcessId}', window,au.name,au.loginAccountName);
			}

			//580督查督办增加
			var operType="${operType}";
			var supType="${supType}";
			var relationJson=<c:out value="${relationJson}" default="null" escapeXml="false"/>;
			var supervisionFormId="${supervisionFormId}";
			var supRalationField="${relationField}";
			
			function showDetail(forwardSummaryId){
				if(forwardSummaryId == null || forwardSummaryId == ""){
					alert("流程已经撤销");
					return;
				}
				var url = "/seeyon/collaboration/collaboration.do?method=summary&openFrom=formQuery&summaryId=" + forwardSummaryId;
				openCtpWindow({"url":url,"id":"showDetail"});
			}
	</script>
	<script type="text/javascript">
     <!--
       isNewOfficeFilePage=true;
     //-->
    </script>
	<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/govdoc/js/newGovdoc.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/govdoc/js/govdoc_mark.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/govdocbody.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/common/barCode/js/barCode.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/office/js/office.js${ctp:resSuffix()}" />"></script>
</head>
<body class="h100b page_color" onunload="removeSessionMasterData('${vobj.summary.formRecordid}');">
<iframe id="forwardSummaryContent" style="display: none;"></iframe>
<form method="post" id="sendForm"  name="sendForm" action='<%=ctxServer%>/collaboration/collaboration.do?method=send&from=${param.from}&reqFrom=${param.reqFrom}&distributeAffairId=${distributeAffairId}' class="h100b">
    <div id='newColl_layout' class="comp" comp="type:'layout'">
    	<c:if test="${newGovdocView==1 }"><div class="layout_east" id= "east" layout="maxWidth:380,minWidth:380,width:380,border:false,sprit:false"></c:if>
       <c:if test="${newGovdocView!=1 }"> <div class="layout_north" layout="height:105,border:false,sprit:false"></c:if>
            <div id="north_area_h" <c:if test="${newGovdocView==1 }">style="padding-bottom:100px"</c:if>>
			    <!--当前位置-->
			    <c:if test="${from eq '' or from eq 'report' or
                    (from ne 'a8genius' and vobj.from ne 'bizconfig' and from ne 'peopleCard' )}">
                    <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F01_newColl'"></div>
                </c:if>
                 <c:if test="${vobj.from eq 'bizconfig'}">
                    <div class="comp" comp="type:'breadcrumb',comptype:'location'"></div>
                </c:if>
			    <!--toolbar-->
			    <c:if test="${newGovdocView!=1 }">
			    <div class="padding_l_5 border_b">
				    <div id="toolbar"></div>
			    </div>
			    </c:if>
			    <!--toolbar结束-->
				<script>
					
					$(document).ready(function(){
						$("#scan_barcode_a").hide();
					});
				
				
				</script>
			    <div id="colMainData" class="form_area new_page">

			    	<%-- 公文文号相关 --%>
			    	<input type="hidden" id="doc_mark"/>
					<input type="hidden" name="isSystemTemplete" id="isSystemTemplete" value="${(isSystemTemplete or not empty vobj.temformParentId)}"/>
			    	<input type="hidden" name="markDefinitionId" id="markDefinitionId" value="${markDefinitionId}"/>
			    	<input type="hidden" name="jianbanType" id="jianbanType" value="${jianbanType}"/>
			    	<input type="hidden" name="oldJianbanType" id="oldJianbanType" value="${jianbanType}"/>
			    	<input type="hidden" name="subApp" id="subApp" value="${sub_app}"/>
					<input type="hidden" name="orgAccountId" id="orgAccountId" value="${vobj.summary.orgAccountId}"/>
					<input type="hidden" name="summaryId" id="summaryId" value='${vobj.summaryId}'/>

				    <c:if test="${param.from eq 'resend'}">
					    <c:set var="resentTime" value="${vobj.summary.resentTime + 1}" />
				    </c:if>
				    <c:set value="${(isSystemTemplete or not empty vobj.temformParentId)}" var="isFromSystem"/>
				    <c:set value="${isFromSystem ? (not empty vobj.temformParentId) ? vobj.temformParentId : vobj.template.id : ''}" var="tempId" />
				    <input type="hidden" id="hasnibanComment" name="hasnibanComment" value="0"/>
				    <input type="hidden" id="temformParentId" name="temformParentId" value="${vobj.temformParentId}" />
				    <input type="hidden" id="resend" name="resend" value="${vobj.resendFlag}" />
				    <input type="hidden" id="newBusiness" name="newBusiness" value="${vobj.newBusiness}" />
				    <input type="hidden" id="id" name="id" value='${vobj.summaryId}'/>
				    <input type="hidden" id="parentSummaryId" name="parentSummaryId" value='${parentSummaryId}'/>
				    <input type="hidden" id="tId" name="tId" value='${tempId}'/>
				    <INPUT TYPE="hidden" id="curTemId" name="curTemId" value="${curTemplateID}" />
				    <input type="hidden" id="resentTime" name="resentTime" value="${resentTime}"/>
				    <input type="hidden" id="archiveId" name="archiveId" value="${vobj.summary.archiveId}" />
				    <input type="hidden" id="prevArchiveId" name="prevArchiveId" value="${vobj.summary.archiveId}" />
				    <!-- 当前处理人信息 -->
				    <input type="hidden" id="currentNodesInfo" name="currentNodesInfo" value="${vobj.summary.currentNodesInfo}" />

				    <input type="hidden" id="tembodyType" name="tembodyType" value="${vobj.template.bodyType}" />
				    <input type="hidden" id="formtitle" name="formtitle" value="<c:out value='${vobj.formtitle}' escapeXml='true' />" />
				    <input type="hidden" id="saveAsTempleteSubject" name="saveAsTempleteSubject" value="">
				    <input type="hidden" id="phaseId" name="phaseId" value="${projectPhaseId}" />
                    <input type="hidden" id="caseId" name="caseId" value="${vobj.summary.caseId }">
                    <input type="hidden" id="currentaffairId" name="currentaffairId" value="${ctp:toHTML(vobj.affairId) }">
                    <input type="hidden" id="createDate" name="createDate" value="${ctp:formatDateByPattern(vobj.createDate, 'yyyy-MM-dd HH:mm:ss')}" />
                    <input type="hidden" id="useForSaveTemplate" name="useForSaveTemplate" value='no'/>
                    <input type="hidden" id="oldProcessId" name="oldProcessId" value="${vobj.processId }"/>
                    <input type="hidden" id="temCanSupervise" name="temCanSupervise" value="${vobj.template.canSupervise}" />
                    <input type="hidden" id="standardDuration" name="standardDuration"  value="<c:if test='${vobj.template.standardDuration ne null}'>${vobj.template.standardDuration}</c:if>"></input>
                    <input type="hidden" id="forwardMember" name="forwardMember" value="${vobj.summary.forwardMember}" />
                    <input type="hidden" id="saveAsFlag" name="saveAsFlag"/>
                    <input type="hidden" id='transtoColl' name='transtoColl' value='0'></input>
                    <input type="hidden" id='bzmenuId' name='bzmenuId' value='${param.menuId}'></input>
                    <input type="hidden" id='newflowType' name='newflowType' value='${vobj.summary.newflowType}'></input>
                    <input type="hidden" id='contentViewState' name='contentViewState' value='${contentViewState}'></input>
                    <input type="hidden" id="isOpenWindow" name="isOpenWindow" value=""></input>
                    <input type="hidden" id='canTrackWorkFlow' name='canTrackWorkFlow'></input>
                    <input type="hidden" id="bodyType" name="bodyType" value="${govdocBodyType}"></input>
                    <input type="hidden" id="govdocBodyType" name="govdocBodyType" value="${govdocBodyType}"></input><!-- 公文正文类型文字，officeWord -->
                    <input type="hidden" id="govdocContent" name="govdocContent"></input><!-- 公文正文id-->
                    <input type="hidden" id="myContentNameId" name="myContentNameId" value="${myContentNameId }"/><!-- 签章文件名 -->
                    <input type="hidden" id="govdocContentType" name="govdocContentType" value="${govdocContentObj.contentType}"></input><!-- 公文正文类型value，41,42,43-->
                    <input type="hidden" id="formRecordid" name="formRecordid"></input>
                    <input type="hidden" id="contentSaveId" name="contentSaveId"></input>
                    <input type="hidden" id="contentDataId" name="contentDataId"></input>
                    <input type="hidden" id="distributeContentDataId" name="distributeContentDataId" value="${distributeContentDataId }"></input>
                    <input type="hidden" id="distributeContentTemplateId" name="distributeContentTemplateId" value="${distributeContentTemplateId }"></input>
                    <input type="hidden" id="contentTemplateId" name="contentTemplateId"></input>
                    <input type="hidden" id="contentRightId" name="contentRightId"></input>
                    <input type='hidden' id='contentZWID' name="contentZWID" value="0"></input>
                    <input type="hidden" id='contentSwitchId' name="contentSwitchId" value=""></input>
                    <input type="hidden" id= "signAndDistribute" name="signAndDistribute" value="${signAndDistribute}"></input>
                    <input type="hidden" id="isDistribute" name="isDistribute" value="${isDistribute }"/>
                    <%--高级归档 --%>
                    <input type="hidden" id="advancePigeonhole" name="advancePigeonhole" value='${vobj.advancePigeonhole}'></input>
                    <input type='hidden' id='contentIdUseDelete' name="contentIdUseDelete" value="0"></input>
                    <input type='hidden' id='formId' name="formId"></input>
                    <input type="hidden" id='app' name="app" value="${app }"></input>
                    <input type="hidden" id='sub_app' name="sub_app" value="${sub_app }"></input>
 				    <input type="hidden" id="serial_no"/>
                    <input type="hidden" id='oldSummaryId' name="oldSummaryId" value="${oldSummaryId }"></input>
                    <input type="hidden" id='forwardAffairId' name="forwardAffairId" value="${forwardAffairId }"></input>
                    <input type="hidden" id='govdocRelation1' name="govdocRelation1" value="${govdocRelation1 }"></input>
                    <input type="hidden" id='govdocRelation2' name="govdocRelation2" value="${govdocRelation2 }"></input>

					<%--快速发文  xuker add 20160314--%>
					<input type="hidden" id='isQuickSend' name="isQuickSend" value="${isQuickSend}"/>
					<%--快速发文送往的单位  xuker add 20160315 start--%>
					<input  type = "hidden"  id="fenfa_input_value" name="fenfa_input_value"/>
					<input  type = "hidden"  id="fenfa_input" name="fenfa_input"/>
					<input  type = "hidden"  id="quickSendUnit" name="quickSendUnit"/>

					<%--快速发文送往的单位  xuker add 20160315 end--%>
					<c:choose>
						<c:when test="${newGovdocView==1 }">
						<div class="clearfix padding_l_20">
							
						<table border="0" cellspacing="0" cellpadding="0" width="100%" >
						<tr>
							<th style="padding-left:10px">
<!-- 								<div class="nodePerm" baseAction="UploadAttachment" -->
<%--     			style="display: inline;"><a id="uploadAttachmentID" title="${ctp:i18n('collaboration.summary.label.att')}" --%>
<!--     			class="margin_r_5"><span class="ico16 affix_16"></span></a>(<span -->
<%--     			id="attachmentNumberDiv${commentId}">0</span>)</div> --%>
								<div class="left color_gray2">插入：<a onClick="insertAttachmentPoi('Att')"><span class="ico16 affix_16"></span>本地文件</a> | <span class="ico16 associated_document_16"></span><a onClick="quoteDocument('Doc1')">关联文档</a></div>
							</th>
							<td style="padding-right:10px">
							</td>
						</tr>
						</table>
						<table border="0" cellspacing="0" cellpadding="0" width="100%" >
					<!-- 附件列表 -->
						<tr>
							<th width="1%" nowrap="nowrap" class='color_gray2' style="padding-left:10px">正式附件：</th>
							<td>
							<div id="attachmentTRAtt" style="display:none; margin-bottom:5px">
		                        <table border="0" cellspacing="0" cellpadding="0" width="100%" class="line_height180">
		                            <tr id="attList">
		                                <td width="1%">&nbsp;</td>
		                                <td class="align_right" valign="top" width="1%" nowrap="nowrap">
		                                	<div class="div-float margin_t_5" ><em class="ico16 affix_16"></em>(<span id="attachmentNumberDivAtt"></span>) </div>
		                                </td>
		                                <td class="align_left">
		                                    <div id="attFileDomain"  class="comp" comp="type:'fileupload',newGovdocView:2,attachmentTrId:'Att',applicationCategory:'1',canFavourite:false,canDeleteOriginalAtts:true,originalAttsNeedClone:${vobj.cloneOriginalAtts},autoHeight:true,callMethod:'insertAtt_AttCallback',takeOver:false" attsdata='${vobj.attListJSON }'></div>
		                                </td>
		                            </tr>
		                        </table>
		                    </div>
		                    <div id="attachment2TRDoc1" style="display:none;">
		                        <table border="0" cellspacing="0" cellpadding="0"  class="line_height180">
		                            <tr id="docList">
		                                <td width="1%">&nbsp;</td>
		                                <td class="align_right" width="1%" valign="top" nowrap="nowrap"><div class="div-float margin_t_5"><span class="ico16 associated_document_16"></span>(<span id="attachment2NumberDivDoc1"></span>) </div></td>
		                                <td class="align_left">
		                                    <div class="comp" id="assDocDomain" comp="type:'assdoc',displayMode:'auto',attachmentTrId:'Doc1',modids:'1,3',applicationCategory:'1',referenceId:'${vobj.summary.id}',canDeleteOriginalAtts:true,originalAttsNeedClone:${vobj.cloneOriginalAtts},callMethod:'quoteDoc_Doc1Callback'" attsdata='${vobj.attListJSON }'></div>
		                                </td>
		                            </tr>
		                        </table>
		                    </div>
							</td>
						</tr>
						</table>
						<c:if test="${govdocRelation1=='true' }">
						<table border="0" cellspacing="0" cellpadding="0" width="100%" >
							<tr>
								<td style="padding-left:5px;text-align:left" colspan="2">
									<span class="hand" onclick="showDetail('${forwardSummaryId}');"><span class="ico16 view_log_16 margin_lr_5" ></span>原收文流程</span>
								</td>
							</tr>
						</table>
						</c:if>
						<table border="0" cellspacing="0" cellpadding="0" width="100%" >
							<tr>
							<th></th>
							<td style="text-align:right;padding-right:14px">
								<div class="hidden right"  id="commonuse">
							<a id="cphrase" curUser="${CurrentUser.id}">${ctp:i18n('collaboration.common.commonLanguage')}<!-- 常用语 --></a></div>
							</td>
						</tr>
						</table>
					<!-- 处理意见区域 -->

					<textarea id="content_deal_comment" name="content_deal_comment"
		class="hidden padding_5 margin_t_5" errorIcon="false" style="width: 90%; height: 200px;font-size:14px;"><c:forEach items="${commentNibanSenderList}" var="csl"><c:out value="${csl.content}"></c:out><c:out value="${__huanhang}" escapeXml="false"></c:out></c:forEach></textarea>


					<table border="0" cellspacing="0" cellpadding="0" width="100%" style="margin-top:5px">

						<c:if test = "${isQuickSend}">
						<tr>
							<th nowrap="nowrap" width="8%" class="color_gray2 ">
								<div id="sel_label_taohong" class="padding_l_30">
									${ctp:i18n('edoc.action.form.template')}：
								</div>
							</th>
							<td nowrap="nowrap" width="20%">
								<div class="common_selectbox_wrap w80b left">
									<select id="fileUrl" name="fileUrl" class="input-100per" style="" onchange="sendQuick_taohong('edoc')">
										<option value="">${ctp:i18n('templete.select_template.label')}</option>
										<c:forEach items="${taohongList}" var="taohong">
											<c:if test="${taohong.status eq 1}">
											<c:set var="taohongurl" value="${taohong.fileUrl}&${taohong.textType}" />
											<option value="${taohong.fileUrl}&${taohong.textType}"
													<c:if test="${edocSummaryQuick.taohongTemplateUrl eq taohongurl}">selected='true'</c:if>>
													${taohong.name}</option>
											</c:if>
										</c:forEach>
									</select>
								</div>
							</td>
						</tr>
						</c:if>
					<!-- 流程期限 -->
						<tr>
							<th width="1%" id="liuchengqx" nowrap="nowrap" class='color_gray2' style="padding-left:10px">${ctp:i18n('collaboration.newcoll.lcqx')}</th>
							<td width="30%">
								<c:set value= "${vobj.templeteHasDeadline && (isSystemTemplete || vobj.parentColTemplete || vobj.parentTextTemplete || vobj.parentWrokFlowTemplete || vobj.fromSystemTemplete)}" var ="isDisabled"/>
                                <div class="common_selectbox_wrap  left">
                                    <c:choose>
                                        <c:when test="${isDisabled}">
                                            <select id="deadLineselect" name="deadLineselect"
                                                disabled="true" class="codecfg"
                                                codecfg="codeId:'collaboration_deadline',defaultValue:'${vobj.summary.deadline}'">
                                            </select>
                                            <input type="hidden" name="deadLine" id="deadLine" value="${vobj.summary.deadline}" />
                                        </c:when>
                                        <c:otherwise>
                                            <select name="deadLineselect" id="deadLineselect" class="codecfg"
                                                codecfg="codeId:'collaboration_deadline',defaultValue:'${vobj.summary.deadline}'"/>
                                            </select>
                                            <input type="hidden" name="deadLine" id="deadLine" value="${vobj.summary.deadline}" />
                                        </c:otherwise>
                                    </c:choose>
							    </div>
							    <div class="right" style="width:66%">
							    	<c:choose>
	                                    <c:when test="${isDisabled}">
	                                        <div id="deadLineCalender" style="display:none">
			                                	<input id="deadLineDateTime" type="text"  class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true,onUpdate:checkDeadLineDateTime">
			                                </div>
			                                <input type="hidden" name="deadLineDateTimeHidden" id="deadLineDateTimeHidden" value="${vobj.deadLineDateTimeHidden}" />
	                                    </c:when>
	                                    <c:otherwise>
									    	<div id="deadLineCalender" style="display:none">
			                                	<input id="deadLineDateTime" type="text" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true,onUpdate:checkDeadLineDateTime">
			                                </div>
			                                <input type="hidden" name="deadLineDateTimeHidden" id="deadLineDateTimeHidden" value="${vobj.deadLineDateTimeHidden}" />
	                                    </c:otherwise>
	                                </c:choose>
							    </div>
							</td>
						</tr>
						<!--提前提醒 -->
						<tr>
							<th id="tiqiantix" width="1%" nowrap="nowrap" class='color_gray2'>${ctp:i18n('collaboration.newcoll.beforetx')}</th>
				            <td >
                                <div class="common_selectbox_wrap w80b left">
                                    <c:set  var ="reminddiabled"  value="${vobj.templeteHasRemind && (isSystemTemplete || vobj.parentColTemplete || vobj.parentTextTemplete || vobj.parentWrokFlowTemplete || vobj.fromSystemTemplete)}" />
                                    <c:choose>
                                        <c:when test = "${reminddiabled}">
                                            <select id="advanceRemindselect" name="advanceRemindselect"
                                                disabled=true  class="codecfg"
                                                codecfg="codeId:'common_remind_time',defaultValue:'${vobj.summary.advanceRemind}'">
                                            </select>
                                            <input type="hidden" value="${vobj.summary.advanceRemind}" name="advanceRemind" id="advanceRemind"/>
                                        </c:when>
                                        <c:otherwise>
                                            <select name="advanceRemind" id="advanceRemind"  class="codecfg"
                                                codecfg="codeId:'common_remind_time',defaultValue:'${vobj.summary.advanceRemind}'"/>
                                            </select>
                                        </c:otherwise>
                                    </c:choose>
				          	    </div>
                            </td>
						</tr>
						<!-- 预归档到 -->
						<tr>
							<!-- xuker  快速发文 套红和归档 add-->
				        	 <!-- 预归档到 -->
				            <th nowrap="nowrap" width="1%" class='color_gray2 padding_l_25'>${ctp:i18n('collaboration.newcoll.ygdd')}</th>
				            <td width="150" class="padding_r_25 xl_padding_r_0">
				          	    <div class="common_selectbox_wrap w80b left">
									<c:set var="isPrePighole" value="${canEditColPigeonhole and vobj.archiveName ne null && vobj.archiveName ne '' && vobj.fromTemplate == true  && (isSystemTemplete && vobj.template.type == 'template' || vobj.parentColTemplete)}"/>
									<input type="hidden" name="isTemplateHasPigeonholePath" id="isTemplateHasPigeonholePath" value="${isPrePighole}"/>

									<select id="colPigeonhole" class="input-100per" onchange="pigeonholeEvent(this)"
										${isPrePighole || setDisabled ? 'disabled=disabled' : "" }>
										<option id="defaultOption" value="1">${ctp:i18n('collaboration.deadline.no')}</option>
										<!-- 请选择 -->
										<option id="modifyOption" value="2">${ctp:i18n('collaboration.newColl.pleaseSelect')}</option>
										<c:if test="${vobj.archiveName ne null && vobj.archiveName ne ''}" >
											<option value="3" selected>${ctp:toHTML(vobj.archiveName)}</option>
										</c:if>
									</select>
								</div>
						    </td>
						</tr>

						     <%
					            	if(AppContext.hasPlugin("secret")){
					            %>
					     <tr style="display:none">
						    <th style="visibility:hidden;"  nowrap="nowrap" width="8%" class="color_gray2 padding_l_30">${ctp:i18n('secret.secretLevel')}：</th>
						    <td style="visibility:hidden;">
						          	<select name="secretLevel" id="secretLevel" class="codecfg" style="width: 80px"  onchange="changeSecretLevel(this,<c:choose><c:when test="${vobj.template == null || vobj.template.workflowId == null}">null</c:when><c:otherwise>'${vobj.template.workflowId}'</c:otherwise></c:choose>);">
							    		<option value="">  </option>
							    		<c:forEach items="${secretLevelList }" var="item" varStatus="status">
											<option value="${item.value }"<c:if test="${item.value == ctp:toHTMLWithoutSpace(vobj.summary.secretLevel)}" > selected="selected"</c:if>>${item.label }</option>
										</c:forEach>
						    		</select>
						    </td>
						  </tr>
						  <%
						 	   }
						    %>
						  <c:choose>
							    <c:when test="${vobj.collSubjectNotEdit == 'true'}">
                                    <!-- 标题 -->
				                    <td style="width:100%;display:none"><div class="common_txtbox_wrap"><input  id="subject" inputName="${ctp:i18n('collaboration.newcoll.subject')}" class="w100b"  type="text"  name="subject" title="${ctp:i18n('collaboration.newcoll.clickfortitle')}" value="<c:out value='${vobj.collSubject}'></c:out>" readonly="readonly"/></div></td>
				           	    </c:when>
				           	    <c:otherwise>
                                    <!-- 标题 -->
				                    <td style="width:100%;display:none"><div class="common_txtbox_wrap"><input  id="subject" inputName="${ctp:i18n('collaboration.newcoll.subject')}" class="w100b" type="text" name="subject" title="${ctp:i18n('collaboration.newcoll.clickfortitle')}" value="${ctp:toHTMLWithoutSpace(vobj.summary.subject)}" defaultValue="${ctp:i18n('common.default.subject.value2')}"/></div></td>
							    </c:otherwise>
				            </c:choose>
						  <tr>
						  	<td width="80" class="padding_l_5" style="display:none">
				                <div class="common_selectbox_wrap">
                                    <select id="importantLevel" name="importantLevel" class="codecfg "
                                        codecfg="codeId:'common_importance',defaultValue:1">
                                    </select>
				                </div>
				            </td>

						  </tr>

						<tr><td></td>
							
							<td class="padding_r_25" style="padding-right:10px" nowrap="nowrap" align="right">
				            	<!-- <a id="show_more" class="clearfix" style="width:50px;">${ctp:i18n('collaboration.newcoll.show')}<span class="ico16 arrow_2_b"></span></a> -->
				            </td>
						</tr>
					</table>
					</div>
						</c:when>
						<c:otherwise>
						<input type="hidden" id="content_deal_comment" name="content_deal_comment" value="" />
						<table border="0" cellspacing="0" cellpadding="0" width="100%">
			            	<tr>
				            <td rowspan="2" width="8%" nowrap="nowrap" align="center">
				            	<a id='sendId' class="display_inline-block align_center new_btn">${ctp:i18n('collaboration.newcoll.send')}</a>
				            </td>
				            <!-- 流程 -->
				            <th width="5%" nowrap="nowrap" class='align_right color_gray2'>${ctp:i18n('collaboration.newcoll.lc')}</th>
							<%--xuker 快速发文 后台设置一个空节点流程 如果是快速发文进来，该input直接disabled--%>
							<td width="40%"><div id="process_info_div" class="common_txtbox_wrap <c:choose><c:when test="${((onlyViewWF && isSystemTemplete|| isQuickSend) || vobj.parentWrokFlowTemplete || vobj.parentColTemplete) && nonTextTemplete || subState eq '16'}">common_txtbox_wrap_dis</c:when></c:choose>">
                                <input readonly="readonly" class="w100b validate" type="text" id="process_info"
                                    defaultValue="${ctp:i18n('collaboration.default.workflowInfo.value')}"
                                    <c:choose><c:when test="${((onlyViewWF && isSystemTemplete|| isQuickSend) || vobj.parentWrokFlowTemplete || vobj.parentColTemplete) && nonTextTemplete || subState eq '16' || noselfflow eq 'noselfflow'}">disabled</c:when><c:otherwise>style="color: black;"</c:otherwise></c:choose>
                                    value="<c:out value='${contentContext.workflowNodesInfo}'></c:out>" name="process_info" title="${ctp:i18n('collaboration.newcoll.clickforprocess')}"/>
                                </div>
                            </td>
				            <td width="3%" class="padding_l_5">
				                <div id="workflowInfo">
									<c:if test="${noselfflow eq 'noselfflow'}">
										<a style="border-radius:0; background:#FFF;" comp="type:'workflowEdit',defaultPolicyId:'${curPerm.defaultPolicyId}',defaultPolicyName:'${curPerm.defaultPolicyName}',moduleType:'${curPerm.appName}',isTemplate:${isSystemTemplete?true:false },isView:true,workflowId:'${contentContext.wfProcessId==null ? "-1" : contentContext.wfProcessId}',caseId : '${contentContext.wfCaseId==null ? "-1" : contentContext.wfCaseId}'"
                                            class="common_button common_button_icon comp edit_flow" href="#">
                                            <em class="ico16 process_16"> </em>${ctp:i18n('collaboration.newColl.findFlow')}</a><!-- 查看流程 -->
									</c:if>
									<%--xuker 快速发文查看流程 20160316 start--%>
									<%--oldcode start --%>
									<%--<c:if test="${subState ne '16' && noselfflow ne 'noselfflow'}">
										<a style="border-radius:0; background:#FFF;" comp="type:'workflowEdit',defaultPolicyId:'${curPerm.defaultPolicyId}',defaultPolicyName:'${curPerm.defaultPolicyName}',moduleType:'${curPerm.appName}',<c:if test="${vobj.templeteId ne null && (vobj.fromSystemTemplete) && vobj.template.type ne 'text'}">isTemplate:true,</c:if><c:if test="${((onlyViewWF && isSystemTemplete)  || vobj.parentWrokFlowTemplete || vobj.parentColTemplete) && nonTextTemplete }">isView:true,</c:if>workflowId:'${contentContext.wfProcessId==null ? "-1" : contentContext.wfProcessId}'"
										   class="common_button common_button_icon comp edit_flow" href="#">
											<em class="ico16 process_16"> </em><c:if test="${!((onlyViewWF && isSystemTemplete) || vobj.parentWrokFlowTemplete || vobj.parentColTemplete) || vobj.template.type eq 'text'}">${ctp:i18n('collaboration.newcoll.bjlc')}</c:if><c:if test="${((onlyViewWF && isSystemTemplete) || vobj.parentWrokFlowTemplete || vobj.parentColTemplete)&& nonTextTemplete}">${ctp:i18n('collaboration.newColl.findFlow')}</c:if></a><!-- 查看流程 -->
									</c:if>--%>
									<%--oldcode end --%>
									<%--快速发文直接加载一个空流程，不允许修改--%>
									<%--new start --%>
									<c:if test="${subState ne '16' && noselfflow ne 'noselfflow'}">
										<a style="border-radius:0; background:#FFF;" comp="type:'workflowEdit',defaultPolicyId:'${curPerm.defaultPolicyId}',defaultPolicyName:'${curPerm.defaultPolicyName}',moduleType:'${curPerm.appName}',<c:if test="${vobj.templeteId ne null && (vobj.fromSystemTemplete) && vobj.template.type ne 'text' ||isQuickSend}">isTemplate:true,</c:if><c:if test="${((onlyViewWF && isSystemTemplete || isQuickSend )  || vobj.parentWrokFlowTemplete || vobj.parentColTemplete) && nonTextTemplete}">isView:true,</c:if>workflowId:'${contentContext.wfProcessId==null ? "-1" : contentContext.wfProcessId}'"
										   class="common_button common_button_icon comp edit_flow" href="#">
											<em class="ico16 process_16"> </em><c:if test="${!((onlyViewWF && isSystemTemplete||isQuickSend) || vobj.parentWrokFlowTemplete || vobj.parentColTemplete) || vobj.template.type eq 'text'}">${ctp:i18n('collaboration.newcoll.bjlc')}</c:if><c:if test="${((onlyViewWF && isSystemTemplete||isQuickSend) || vobj.parentWrokFlowTemplete || vobj.parentColTemplete)&& nonTextTemplete}">${ctp:i18n('collaboration.newColl.findFlow')}</c:if></a><!-- 查看流程 -->
									</c:if>
									<%--newcode end --%>
									<%--xuker 快速发文查看流程 20160316 end--%>
                                    <c:if test="${subState eq '16' && noselfflow ne 'noselfflow'}">
                                        <a style="border-radius:0; background:#FFF;" comp="type:'workflowEdit',defaultPolicyId:'${curPerm.defaultPolicyId}',defaultPolicyName:'${curPerm.defaultPolicyName}',moduleType:'${curPerm.appName}',isTemplate:true,isView:true,workflowId:'${contentContext.wfProcessId==null ? "-1" : contentContext.wfProcessId}',caseId : '${contentContext.wfCaseId==null ? "-1" : contentContext.wfCaseId}'"
                                            class="common_button common_button_icon comp edit_flow" href="#">
                                            <em class="ico16 process_16"> </em>${ctp:i18n('collaboration.newColl.findFlow')}</a><!-- 查看流程 -->
                                    </c:if>
				                </div>
				            </td>

                            <!-- 流程期限 -->
				            <th width="1%" nowrap="nowrap" class='color_gray2' style="padding-left:100px">${ctp:i18n('collaboration.newcoll.lcqx')}</th>
				            <td width="30%">
                                <c:set value= "${vobj.templeteHasDeadline && (isSystemTemplete || vobj.parentColTemplete || vobj.parentTextTemplete || vobj.parentWrokFlowTemplete || vobj.fromSystemTemplete)}" var ="isDisabled"/>
                                <div class="common_selectbox_wrap w30b left">
                                    <c:choose>
                                        <c:when test="${isDisabled}">
                                            <select id="deadLineselect" name="deadLineselect"
                                                disabled="true" class="codecfg"
                                                codecfg="codeId:'collaboration_deadline',defaultValue:'${vobj.summary.deadline}'">
                                            </select>
                                            <input type="hidden" name="deadLine" id="deadLine" value="${vobj.summary.deadline}" />
                                        </c:when>
                                        <c:otherwise>
                                            <select name="deadLineselect" id="deadLineselect" class="codecfg"
                                                codecfg="codeId:'collaboration_deadline',defaultValue:'${vobj.summary.deadline}'"/>
                                            </select>
                                            <input type="hidden" name="deadLine" id="deadLine" value="${vobj.summary.deadline}" />
                                        </c:otherwise>
                                    </c:choose>
							    </div>
							    <div class="right" style="width:66%">
							    	<c:choose>
	                                    <c:when test="${isDisabled}">
	                                        <div id="deadLineCalender" style="display:none">
			                                	<input id="deadLineDateTime" type="text"  class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true,onUpdate:checkDeadLineDateTime">
			                                </div>
			                                <input type="hidden" name="deadLineDateTimeHidden" id="deadLineDateTimeHidden" value="${vobj.deadLineDateTimeHidden}" />
	                                    </c:when>
	                                    <c:otherwise>
									    	<div id="deadLineCalender" style="display:none">
			                                	<input id="deadLineDateTime" type="text" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true,onUpdate:checkDeadLineDateTime">
			                                </div>
			                                <input type="hidden" name="deadLineDateTimeHidden" id="deadLineDateTimeHidden" value="${vobj.deadLineDateTimeHidden}" />
	                                    </c:otherwise>
	                                </c:choose>
							    </div>
                               </td>
							<!-- 提前提醒 -->
					            <th width="1%" nowrap="nowrap" class='padding_l_10 color_gray2'>${ctp:i18n('collaboration.newcoll.ygdd')}</th>
					            <td width="20%">
	                                <!-- <div class="common_selectbox_wrap w100b">
	                                    <c:set  var ="reminddiabled"  value="${vobj.templeteHasRemind && (isSystemTemplete || vobj.parentColTemplete || vobj.parentTextTemplete || vobj.parentWrokFlowTemplete || vobj.fromSystemTemplete)}" />
	                                    <c:choose>
	                                        <c:when test = "${reminddiabled}">
	                                            <select id="advanceRemindselect" name="advanceRemindselect"
	                                                disabled=true  class="codecfg"
	                                                codecfg="codeId:'common_remind_time',defaultValue:'${vobj.summary.advanceRemind}'">
	                                            </select>
	                                            <input type="hidden" value="${vobj.summary.advanceRemind}" name="advanceRemind" id="advanceRemind"/>
	                                        </c:when>
	                                        <c:otherwise>
	                                            <select name="advanceRemind" id="advanceRemind"  class="codecfg"
	                                                codecfg="codeId:'common_remind_time',defaultValue:'${vobj.summary.advanceRemind}'"/>
	                                            </select>
	                                        </c:otherwise>
	                                    </c:choose>
									  </div> -->
									  <div class="common_selectbox_wrap" style="width:150px;">
											<c:set var="isPrePighole" value="${canEditColPigeonhole and vobj.archiveName ne null && vobj.archiveName ne '' && vobj.fromTemplate == true  && (isSystemTemplete && vobj.template.type == 'template' || vobj.parentColTemplete)}"/>
											<input type="hidden" name="isTemplateHasPigeonholePath" id="isTemplateHasPigeonholePath" value="${isPrePighole}"/>
		
											<select id="colPigeonhole" class="input-100per" onchange="pigeonholeEvent(this)"
												${isPrePighole || setDisabled ? 'disabled=disabled' : "" }>
												<option id="defaultOption" value="1">${ctp:i18n('collaboration.deadline.no')}</option>
												<!-- 请选择 -->
												<option id="modifyOption" value="2">${ctp:i18n('collaboration.newColl.pleaseSelect')}</option>
												<c:if test="${vobj.archiveName ne null && vobj.archiveName ne ''}" >
													<option value="3" selected>${ctp:toHTML(vobj.archiveName)}</option>
												</c:if>
											</select>
										</div>
	                            </td>
			            </tr>
			            <tr>
			            	<th nowrap="nowrap" class='color_gray2' style="text-align: left; display:none">${ctp:i18n('collaboration.newcoll.title')}</th>
			            	<th nowrap="nowrap" class='align_right color_gray2' width="5%">公文单：</th>
			            	<td colspan="2">
			            		<div>
			            			<select class="w30b left" id="edocCategoryList" onchange="changeFormList(this)" <c:if test="${isGovdocSystemTemplate }">disabled</c:if>>
			            				<c:forEach items="${edocCategoryList }" var="item" varStatus="status">
											<option value="${item.id }"<c:if test="${item.id == defaultCategoryId}" > selected="selected"</c:if>>${item.name }</option>
										</c:forEach>
			            			</select>
									<select style="width:68%" class="right" onchange="reloadFormContent(this)" id="formList" <c:if test="${isGovdocSystemTemplate }">disabled</c:if>>
									</select>
			            		</div>
			            	</td>
						    <c:choose>
							    <c:when test="${vobj.collSubjectNotEdit == 'true'}">
                                    <!-- 标题 -->
				                    <td style="width:100%;display:none"><div class="common_txtbox_wrap"><input  id="subject" inputName="${ctp:i18n('collaboration.newcoll.subject')}" class="w100b"  type="text"  name="subject" title="${ctp:i18n('collaboration.newcoll.clickfortitle')}" value="<c:out value='${vobj.collSubject}'></c:out>" readonly="readonly"/></div></td>
				           	    </c:when>
				           	    <c:otherwise>
                                    <!-- 标题 -->
				                    <td style="width:100%;display:none"><div class="common_txtbox_wrap"><input  id="subject" inputName="${ctp:i18n('collaboration.newcoll.subject')}" class="w100b" type="text" name="subject" title="${ctp:i18n('collaboration.newcoll.clickfortitle')}" value="${ctp:toHTMLWithoutSpace(vobj.summary.subject)}" defaultValue="${ctp:i18n('common.default.subject.value2')}"/></div></td>
							    </c:otherwise>
				            </c:choose>
				            <td width="80" class="padding_l_5" style="display:none">
				                <div class="common_selectbox_wrap">
                                    <select id="importantLevel" name="importantLevel" class="codecfg "
                                        codecfg="codeId:'common_importance',defaultValue:1">
                                    </select>
				                </div>
				            </td>
                            <th nowrap="nowrap">
                                <div class="common_checkbox_box clearfix ">
                                    <label class="hand" for="canTrack">
                                        <input id="canTrack" name="canTrack" value="1"  class="radio_com" type="checkbox">${ctp:i18n('collaboration.newcoll.gz')}</label>
                                </div>
                            </th>
                            <!-- xl 7-8 原佈局-->
                            <td nowrap="nowrap">
                                <div class="common_checkbox_box clearfix left" style="line-height:20px; width:50%">
                                    <label class="hand disabled_color" for="radioall">
                                        <input id="radioall" name="radioperson" value="0" type="radio"  disabled="disabled" class="radio_com">${ctp:i18n('collaboration.newcoll.allpeople')}</label>
                                    <label class="hand disabled_color" for="radiopart">
                                        <input id="radiopart" name="radioperson" value="0" type="radio" disabled="disabled" class="radio_com">${ctp:i18n('collaboration.newcoll.spepeople')}</label>
                                        <input type="hidden" id="zdgzry" name="zdgzry" />

                                </div>
                                <div class="left"><input type="text" class="" style="display: none" id="zdgzryName" name="zdgzryName" size="15" onclick="$('#radiopart').click()"/></div>
                            </td>
							<!-- xuker 快速发文 套红和归档 add-->
							<c:if test = "${isQuickSend}">
								<th nowrap="nowrap" width="8%" class="color_gray2 ">
									<div id="sel_label_taohong" class="padding_l_30">
										${ctp:i18n('edoc.action.form.template')}：
									</div>
								</th>
								<td nowrap="nowrap" width="20%">
									<div class="common_selectbox_wrap">
										<select id="fileUrl" name="fileUrl" class="input-100per" style="" onchange="sendQuick_taohong('edoc')">
											<option value="">${ctp:i18n('templete.select_template.label')}</option>
											<c:forEach items="${taohongList}" var="taohong">
												<c:if test="${taohong.status eq 1}">
												<c:set var="taohongurl" value="${taohong.fileUrl}&${taohong.textType}" />
												<option value="${taohong.fileUrl}&${taohong.textType}"
														<c:if test="${edocSummaryQuick.taohongTemplateUrl eq taohongurl}">selected='true'</c:if>>
														${taohong.name}</option>
												</c:if>
											</c:forEach>
										</select>
									</div>
								</td>
							</c:if>
						<!-- xuker  快速发文 套红和归档 add-->
				        	 <!-- 预归档到 -->
				            <th nowrap="nowrap" width="1%" class='color_gray2 padding_l_25'></th>
				            <td width="220px" class="padding_r_25">
				          	    
						    </td>
						     <%
					            	if(AppContext.hasPlugin("secret")){
					            %>
						    <th style="visibility:hidden;"  nowrap="nowrap" width="8%" class="color_gray2 padding_l_30">${ctp:i18n('secret.secretLevel')}：</th>
						    <td style="visibility:hidden;">
						          	<select name="secretLevel" id="secretLevel" class="codecfg" style="width: 80px"  onchange="changeSecretLevel(this,<c:choose><c:when test="${vobj.template == null || vobj.template.workflowId == null}">null</c:when><c:otherwise>'${vobj.template.workflowId}'</c:otherwise></c:choose>);">
							    		<option value="">  </option>
							    		<c:forEach items="${secretLevelList }" var="item" varStatus="status">
											<option value="${item.value }"<c:if test="${item.value == ctp:toHTMLWithoutSpace(vobj.summary.secretLevel)}" > selected="selected"</c:if>>${item.label }</option>
										</c:forEach>
						    		</select>
						    </td>
						    <%
						 	   }
						    %>
							<!-- <td class="padding_r_25" nowrap="nowrap" align="right">
				            	<a id="show_more" class="clearfix" style="width:50px;">${ctp:i18n('collaboration.newcoll.show')}<span class="ico16 arrow_2_b"></span></a>
							</td> -->
							<td  class="padding_r_25"></td>
			            </tr>
			            </table>
						</c:otherwise>
					</c:choose>
					<c:choose>
						<c:when test="${newGovdocView==1 }">
							<!--更多--><!-- xl 6-24 -->
						<div class="clearfix padding_l_20">
						<table class="newinfo_more hidden"   border="0" cellspacing="0" cellpadding="0" width="100%">
							<tr>
                                <th class="color_gray2" style="width:1%;padding-left:25px;" nowrap="nowrap">${ctp:i18n('collaboration.newcoll.jjsc')}</th>
                                <td width="30%" class='color_gray2' nowrap="nowrap">
									<label style="display: none;" class="hand" for="canAutostopflow">
                                        <input id="canAutostopflow" value="1" name="canAutostopflow" disabled
                                            <c:if test='${vobj.summary.canAutostopflow}'>checked</c:if>   class="radio_com" type="checkbox">${ctp:i18n('collaboration.newcoll.lcqxdszdzz')} </label>
                                <span id='standdc' nowarp="nowarp" ><c:if test="${vobj.standardDuration ne null}">${vobj.standardDuration}</c:if><c:if test="${vobj.standardDuration eq null}">${ctp:i18n('collaboration.newcoll.wu')}</c:if></td>
			            	</tr>
						<!-- 跟踪 -->
							<tr>
								<th class="color_gray2 " style="width:1%;padding-left:25px;" nowrap="nowrap">
	                                <div class="common_checkbox_box clearfix ">
	                                    <label class="hand" for="canTrack">
	                                        <input id="canTrack" name="canTrack" value="1"  class="radio_com" type="checkbox">${ctp:i18n('collaboration.newcoll.gz')}</label>
	                                </div>
	                            </th>
	                            <!-- xl 7-8 -->
	                            <td nowrap="nowrap">
	                                <div class="common_checkbox_box clearfix left" style="line-height:20px; width:52%">
	                                    <label class="hand disabled_color" for="radioall">
	                                        <input id="radioall" name="radioperson" value="0" type="radio"  disabled="disabled" class="radio_com">${ctp:i18n('collaboration.newcoll.allpeople')}</label>
	                                    <label class="hand disabled_color" for="radiopart">
	                                        <input id="radiopart" name="radioperson" value="0" type="radio" disabled="disabled" class="radio_com">${ctp:i18n('collaboration.newcoll.spepeople')}</label>
	                                        <input type="hidden" id="zdgzry" name="zdgzry" />

	                                </div>
	                                <div class="left"><input type="text" class="" style="display: none" id="zdgzryName" name="zdgzryName" size="15" onclick="$('#radiopart').click()"/></div>
	                            </td>
							</tr>
						</table>
						<table class="newinfo_more hidden"   border="0" cellspacing="0" cellpadding="0" width="100%">

							<tr>
			            		<%--是否追溯流程： --%>
                                <th class="color_gray2 " style="width:1%;text-align:left;" nowrap="nowrap">${ctp:i18n("collaboration.newcoll.isNoProcess")}</th>
                                <td id='canTrackWorkFlowTd' width="30%" >
									<%-- 由撤销/回退人决定 --%>
									<c:if test="${vobj.template eq null || (vobj.template ne null && vobj.template.canTrackWorkflow eq 0)}">${ctp:i18n("collaboration.newcoll.undoRollback")}</c:if>
									<c:if test="${vobj.template ne null && vobj.template.canTrackWorkflow eq 1}">${ctp:i18n("collaboration.newcoll.trace") }</c:if><%--追溯 --%>
									<c:if test="${vobj.template ne null && vobj.template.canTrackWorkflow eq 2}">${ctp:i18n("collaboration.newcoll.noTrace") }</c:if><%--不追溯 --%>
                                </td>
                             </tr>
						</table>
			            <table class="newinfo_more hidden" border="0" cellspacing="0" cellpadding="0" width="100%">

                             <tr>
                                <!-- 允许操作 -->
                                <th nowrap="nowrap" valign="top" align="right" class='color_gray2 padding_l_25'>${ctp:i18n('collaboration.newcoll.yxcz')}</th>
                                <td width="30%" valign="top">
                                    <!--规则：系统流程模板改变流程置灰   其余4个都可以修改，不置灰的。
                                		系统格式模板改变流程可以修改不置灰，其他都灰色不能修改。-->
                                    <div class="common_checkbox_box clearfix " style="width:210px;">
                                    	<label style="display: none;" class="margin_r_10 margin_t_10 hand display_block left" for="canForward"><input id="canForward" value="1" ${(vobj.fromTemplate == true || vobj.form == true)&&nonTextTemplete && notworkflowTemplate && isSystemTemplete ? 'disabled=disabled' : ""} class="radio_com" type="checkbox" }>${ctp:i18n('collaboration.newcoll.zf')}</label>
                                        <label class="margin_r_10 margin_t_10 hand display_block left" for="canModify"><input id="canModify" value="1" ${(vobj.fromTemplate == true || vobj.form == true) && nonTextTemplete && isSystemTemplete ? 'disabled=disabled' : ""} class="radio_com" type="checkbox" <c:if test="${vobj.summary.canModify}">checked</c:if> >${ctp:i18n('collaboration.newcoll.gblc')}</label>
                                        <label style="display: none;" class="display_block right margin_t_10" for="canEdit"><input id="canEdit" value="1" ${vobj.fromTemplate == true && nonTextTemplete && notworkflowTemplate && isSystemTemplete ? 'disabled=disabled' : ""} class="radio_com" type="checkbox" >${ctp:i18n('collaboration.newcoll.xgzw')}</label>
                                        <label class="margin_r_10 margin_t_10 hand display_block left" for="canEditAttachment"><input id="canEditAttachment" value="1" ${vobj.fromTemplate == true && nonTextTemplete && notworkflowTemplate && isSystemTemplete ? 'disabled=disabled' : ""} class="radio_com" type="checkbox" ${vobj.summary.canEditAttachment ? 'checked' : ''}>${ctp:i18n('collaboration.newcoll.xgfj')}</label>
                                        <label class="margin_r_10 margin_t_10 hand display_block left" for="canArchive"><input id="canArchive" value="1" ${(vobj.fromTemplate == true || vobj.form == true) && nonTextTemplete && notworkflowTemplate && isSystemTemplete ? 'disabled=disabled' : ""} class="radio_com" type="checkbox" ${vobj.summary.canArchive ? 'checked' : ''}>${ctp:i18n('collaboration.newcoll.gd')}</label>
                                        <label style="display: none;" class="margin_t_10 hand display_block left" for="canMergeDeal"><input id="canMergeDeal" disabled="disabled" value="1" class="radio_com" type="checkbox" >${ctp:i18n('collaboration.allow.canmergedeal.label')}</label>
                                    </div>
                                </td>
                              </tr>

			            	<tr>
			            		<!-- 督办人员 -->
				            	<th width="1%" nowrap="nowrap" class='color_gray2'>${ctp:i18n('collaboration.newcoll.dbry')}</th>
                                <td width="395" class="padding_r_25" style="padding-right:50px">
				    				<input type="hidden" name="unCancelledVisor" id="unCancelledVisor" value="${_SSVO.unCancelledVisor }">
					    			<input type="hidden" name="supervisorIds" id="supervisorIds" value="${_SSVO.supervisorIds }"/>
					    			<input type="hidden" name="detailId" id="detailId" value="${_SSVO.detailId}" />
                                    <div class="common_txtbox_wrap">
                                        <%--允许发起人设置督办人  <c:if test="${vobj.template ne null && !vobj.template.canSupervise}">disabled</c:if> --%>
                                        <c:if test="${vobj.template ne null && !vobj.template.canSupervise}">
                                            <input value="${_SSVO.supervisorNames}" type="text" disabled/>
                                            <input type="hidden" id="supervisorNames" name="supervisorNames" value="${_SSVO.supervisorNames}" >
                                        </c:if>
                                        <c:if test="${vobj.template eq null || vobj.template.canSupervise}">
                                            <input id="supervisorNames" name="supervisorNames" value="${_SSVO.supervisorNames}" type="text" />
                                        </c:if>
								    </div>
                                </td>
                            </tr>
                            <tr>
								<!-- 督办期限 -->
                                <th nowrap="nowrap" class='color_gray2 padding_l_25'>${ctp:i18n('collaboration.newcoll.dbqx')}</th>
                                <td class="padding_r_25" style="padding-right:50px;">
                                    <div class="common_txtbox_wrap">
                                        <%--允许发起人设置督办人  <c:if test="${vobj.template eq null || !vobj.template.canSupervise}">disabled</c:if> --%>
                                        <c:if test="${vobj.template ne null && !vobj.template.canSupervise}">
                                            <input class="comp" value="${_SSVO.awakeDate}" type="text" disabled>
                                            <input id="awakeDate" class="comp" value="${_SSVO.awakeDate}" type="hidden" >
                                        </c:if>
                                        <c:if test="${vobj.template eq null or vobj.template.canSupervise}">
                                            <input id="awakeDate" class="comp" value="${_SSVO.awakeDate}" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true,onUpdate:checkAwakeDate" readonly>
                                        </c:if>
                                    </div>
                                </td>
                             </tr>
                             <tr>
	                            <%--督办主题 --%>
	                            <th nowrap="nowrap" class='color_gray2 padding_l_25'>${ctp:i18n('collaboration.newcoll.dbzt')}</th>
	                            <td class="padding_r_25" style="padding-right:50px;">
	                                <%--允许发起人设置督办人   <c:if test="${vobj.template ne null && !vobj.template.canSupervise}">disabled</c:if> --%>
	                                <c:if test="${vobj.template ne null && !vobj.template.canSupervise}">
	                                    <textarea class="w100b font_size12" title="${_SSVO.title}" style="height: 53px;resize:none;" disabled>${_SSVO.title}</textarea>
	                                    <input type="hidden" id="title" name="superviseTitle" value="${_SSVO.title}" >
	                                </c:if>
	                                <c:if test="${vobj.template eq null or vobj.template.canSupervise}">
	                                    <textarea class="w100b font_size12"  title="${_SSVO.title}"  style="height: 20px;resize:none;" id="title" name="superviseTitle" >${_SSVO.title}</textarea>
	                                </c:if>
	                            </td>
			            	</tr>
			            	<tr>
	                            <%--附言--%>
	                            <th nowrap="nowrap" class='color_gray2 padding_l_25'>附言：</th>
	                            <td class="padding_r_25" style="padding-right:50px;">
	                                <div  id="comment_deal" >
										<input type="hidden" id="id" value="${commentSenderList[0].id}">
							            <input type="hidden" id="pid" value="0">
							            <input type="hidden" id="clevel" value="1"> <input type="hidden" id="path" value="00">
							            <input type="hidden" id="moduleType" value="${contentContext.moduleType}">
							            <input type="hidden" id="moduleId" value="${contentContext.moduleId}">
										<input type="hidden" id="extAtt1">
							            <input type="hidden" id="relateInfo">
							            <input type="hidden" id="ctype" value="-1">
							            <textarea class="w100b font_size12" style="height:60px; font-size:12px;"  id="content_coll" name="content_coll" onclick="checkContent();" onblur="checkContentOut();"><c:forEach items="${commentSenderList}" var="csl" begin="0" varStatus="status"><c:out value="${csl.content}"></c:out><c:if test="${!status.last }"><c:out value="${__huanhang}" escapeXml="false"></c:out ></c:if></c:forEach></textarea>
							        </div>
	                            </td>
			            	</tr>
			            </table>
							</div>
						</c:when>
						<c:otherwise>
						 <!--更多-->
			            <table class="newinfo_more hidden" border="0" cellspacing="0" cellpadding="0" width="100%">
			            	<tr>
			            		<%--是否追溯流程： --%>
                                <th class="color_gray2 padding_l_20" style="text-align:left" nowrap="nowrap">${ctp:i18n("collaboration.newcoll.isNoProcess")}</th>
                                <td id='canTrackWorkFlowTd' width="30%">
									<%-- 由撤销/回退人决定 --%>
									<c:if test="${vobj.template eq null || (vobj.template ne null && vobj.template.canTrackWorkflow eq 0)}">${ctp:i18n("collaboration.newcoll.undoRollback")}</c:if>
									<c:if test="${vobj.template ne null && vobj.template.canTrackWorkflow eq 1}">${ctp:i18n("collaboration.newcoll.trace") }</c:if><%--追溯 --%>
									<c:if test="${vobj.template ne null && vobj.template.canTrackWorkflow eq 2}">${ctp:i18n("collaboration.newcoll.noTrace") }</c:if><%--不追溯 --%>
                                </td>
                                <!-- 允许操作 -->
                                <th nowrap="nowrap" valign="top" align="right" class='color_gray2 padding_l_25'>${ctp:i18n('collaboration.newcoll.yxcz')}</th>
                                <td width="30%" valign="top">
                                    <!--规则：系统流程模板改变流程置灰   其余4个都可以修改，不置灰的。
                                		系统格式模板改变流程可以修改不置灰，其他都灰色不能修改。-->
                                    <div class="common_checkbox_box clearfix " style="width:210px;">
                                    	<label style="display: none;" class="margin_r_10 margin_t_10 hand display_block left" for="canForward"><input id="canForward" value="1" ${(vobj.fromTemplate == true || vobj.form == true)&&nonTextTemplete && notworkflowTemplate && isSystemTemplete ? 'disabled=disabled' : ""} class="radio_com" type="checkbox" }>${ctp:i18n('collaboration.newcoll.zf')}</label>
                                        <label class="margin_r_10 margin_t_10 hand display_block left" for="canModify"><input id="canModify" value="1" ${(vobj.fromTemplate == true || vobj.form == true) && nonTextTemplete && isSystemTemplete ? 'disabled=disabled' : ""} class="radio_com" type="checkbox" <c:if test="${vobj.summary.canModify}">checked</c:if> >${ctp:i18n('collaboration.newcoll.gblc')}</label>
                                        <label style="display: none;" class="display_block right margin_t_10" for="canEdit"><input id="canEdit" value="1" ${vobj.fromTemplate == true && nonTextTemplete && notworkflowTemplate && isSystemTemplete ? 'disabled=disabled' : ""} class="radio_com" type="checkbox" >${ctp:i18n('collaboration.newcoll.xgzw')}</label>
                                        <label class="margin_r_10 margin_t_10 hand display_block left" for="canEditAttachment"><input id="canEditAttachment" value="1" ${vobj.fromTemplate == true && nonTextTemplete && notworkflowTemplate && isSystemTemplete ? 'disabled=disabled' : ""} class="radio_com" type="checkbox" ${vobj.summary.canEditAttachment ? 'checked' : ''}>${ctp:i18n('collaboration.newcoll.xgfj')}</label>
                                        <label class="margin_r_10 margin_t_10 hand display_block left" for="canArchive"><input id="canArchive" value="1" ${(vobj.fromTemplate == true || vobj.form == true) && nonTextTemplete && notworkflowTemplate && isSystemTemplete ? 'disabled=disabled' : ""} class="radio_com" type="checkbox" ${vobj.summary.canArchive ? 'checked' : ''}>${ctp:i18n('collaboration.newcoll.gd')}</label>
                                        <label style="display: none;" class="margin_t_10 hand display_block left" for="canMergeDeal"><input id="canMergeDeal" disabled="disabled" value="1" class="radio_com" type="checkbox" >${ctp:i18n('collaboration.allow.canmergedeal.label')}</label>
                                    </div>
                                </td>
                                <th class="color_gray2">${ctp:i18n('collaboration.newcoll.jjsc')}</th>
                                <td width="30%" class='color_gray2' nowrap="nowrap">
<label style="display: none;" class="hand" for="canAutostopflow">
                                        <input id="canAutostopflow" value="1" name="canAutostopflow" disabled
                                            <c:if test='${vobj.summary.canAutostopflow}'>checked</c:if>   class="radio_com" type="checkbox">${ctp:i18n('collaboration.newcoll.lcqxdszdzz')} </label>
                                <span id='standdc' nowarp="nowarp" ><c:if test="${vobj.standardDuration ne null}">${vobj.standardDuration}</c:if><c:if test="${vobj.standardDuration eq null}">${ctp:i18n('collaboration.newcoll.wu')}</c:if></td>

			            	</tr>
			            	<tr>
			            		<!-- 督办人员 -->
				            	<th width="1%" nowrap="nowrap" class='color_gray2'>${ctp:i18n('collaboration.newcoll.dbry')}</th>
                                <td width="395" class="padding_r_25" style="padding-right:50px">
				    				<input type="hidden" name="unCancelledVisor" id="unCancelledVisor" value="${_SSVO.unCancelledVisor }">
					    			<input type="hidden" name="supervisorIds" id="supervisorIds" value="${_SSVO.supervisorIds }"/>
					    			<input type="hidden" name="detailId" id="detailId" value="${_SSVO.detailId}" />
                                    <div class="common_txtbox_wrap">
                                        <%--允许发起人设置督办人  <c:if test="${vobj.template ne null && !vobj.template.canSupervise}">disabled</c:if> --%>
                                        <c:if test="${vobj.template ne null && !vobj.template.canSupervise}">
                                            <input value="${_SSVO.supervisorNames}" type="text" disabled/>
                                            <input type="hidden" id="supervisorNames" name="supervisorNames" value="${_SSVO.supervisorNames}" >
                                        </c:if>
                                        <c:if test="${vobj.template eq null || vobj.template.canSupervise}">
                                            <input id="supervisorNames" name="supervisorNames" value="${_SSVO.supervisorNames}" type="text" />
                                        </c:if>
								    </div>
                                </td>
								<!-- 督办期限 -->
                                <th nowrap="nowrap" class='color_gray2 padding_l_25'>${ctp:i18n('collaboration.newcoll.dbqx')}</th>
                                <td class="padding_r_25" style="padding-right:50px;">
                                    <div class="common_txtbox_wrap">
                                        <%--允许发起人设置督办人  <c:if test="${vobj.template eq null || !vobj.template.canSupervise}">disabled</c:if> --%>
                                        <c:if test="${vobj.template ne null && !vobj.template.canSupervise}">
                                            <input class="comp" value="${_SSVO.awakeDate}" type="text" disabled>
                                            <input id="awakeDate" class="comp" value="${_SSVO.awakeDate}" type="hidden" >
                                        </c:if>
                                        <c:if test="${vobj.template eq null or vobj.template.canSupervise}">
                                            <input id="awakeDate" class="comp" value="${_SSVO.awakeDate}" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true,onUpdate:checkAwakeDate" readonly>
                                        </c:if>
                                    </div>
                                </td>
	                            <%--督办主题 --%>
	                            <th nowrap="nowrap" class='color_gray2 padding_l_25'>${ctp:i18n('collaboration.newcoll.dbzt')}</th>
	                            <td class="padding_r_25" style="padding-right:50px;">
	                                <%--允许发起人设置督办人   <c:if test="${vobj.template ne null && !vobj.template.canSupervise}">disabled</c:if> --%>
	                                <c:if test="${vobj.template ne null && !vobj.template.canSupervise}">
	                                    <textarea class="w100b font_size12" title="${_SSVO.title}" style="height: 53px;resize:none;" disabled>${_SSVO.title}</textarea>
	                                    <input type="hidden" id="title" name="superviseTitle" value="${_SSVO.title}" >
	                                </c:if>
	                                <c:if test="${vobj.template eq null or vobj.template.canSupervise}">
	                                    <textarea class="w100b font_size12"  title="${_SSVO.title}"  style="height: 20px;resize:none;" id="title" name="superviseTitle" >${_SSVO.title}</textarea>
	                                </c:if>
	                            </td>
			            	</tr>
			            </table>
			            <div id="attachmentTRAtt" style="display:none; margin-bottom:5px">
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" class="line_height180">
                            <tr id="attList">
                                <td width="3%">&nbsp;</td>
                                <td class="align_right" valign="top" width="80" nowrap="nowrap">
                                	<div class="div-float margin_t_5" ><em class="ico16 affix_16"></em> (<span id="attachmentNumberDivAtt"></span>) </div>
                                </td>
                                <td class="align_left">
                                    <div id="attFileDomain"  class="comp" comp="type:'fileupload',attachmentTrId:'Att',applicationCategory:'1',canFavourite:false,canDeleteOriginalAtts:true,originalAttsNeedClone:${vobj.cloneOriginalAtts},callMethod:'insertAtt_AttCallback',takeOver:false" attsdata='${vobj.attListJSON }'></div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="attachment2TRDoc1" style="display:none;">
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" class="line_height180">
                            <tr id="docList">
                                <td width="3%">&nbsp;</td>
                                <td class="align_right" valign="top" width="80" nowrap="nowrap"><div class="div-float margin_t_5"><span class="ico16 associated_document_16"></span> (<span id="attachment2NumberDivDoc1"></span>) </div></td>
                                <td class="align_left">
                                    <div class="comp" id="assDocDomain" comp="type:'assdoc',attachmentTrId:'Doc1',modids:'1,3',applicationCategory:'1',referenceId:'${vobj.summary.id}',canDeleteOriginalAtts:true,originalAttsNeedClone:${vobj.cloneOriginalAtts},callMethod:'quoteDoc_Doc1Callback'" attsdata='${vobj.attListJSON }'></div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <c:if test="${govdocRelation1=='true' }">
			           	 <table border="0" cellspacing="0" cellpadding="0" width="100%">
			            		<tr>
			            		<td colspan="3" style="padding-left:70px;padding-top:5px">
			            		<div class="hand" onclick="showDetail('${forwardSummaryId}');"><span class="ico16 view_log_16 margin_lr_5" ></span>原收文流程</div>
			            		</td>
			            		</tr>
			            		</table>
			            	</c:if>
						</c:otherwise>
					</c:choose>

                    <!-- xl 6-24 -->
                    <c:if test="${newGovdocView==1 }">
                    	<div class="clearfix right"  style="background:#d1d4d6;opacity:0.9;filter:alpha(opacity = 90);position:fixed;bottom:0px;width:360px;right:0px;padding:20px;" >
	                	<table border="0" cellspacing="0" cellpadding="0" width="100%"<c:if test="${isQuickSend }"> style="visibility:hidden"</c:if>>
	                		<tr>
				            <!-- 流程 -->
				            <td width="5%" nowrap="nowrap" class='align_right' style="padding-left:10px">${ctp:i18n('collaboration.newcoll.lc')}</td>
							<%--xuker 快速发文 后台设置一个空节点流程 如果是快速发文进来，该input直接disabled--%>
							<td width="40%"><div id="process_info_div" class="common_txtbox_wrap <c:choose><c:when test="${((onlyViewWF && isSystemTemplete|| isQuickSend) || vobj.parentWrokFlowTemplete || vobj.parentColTemplete) && nonTextTemplete || subState eq '16'}">common_txtbox_wrap_dis</c:when></c:choose>">
                                <input readonly="readonly" class="w100b validate" type="text" id="process_info"
                                    defaultValue="${ctp:i18n('collaboration.default.workflowInfo.value')}"
                                    <c:choose><c:when test="${((onlyViewWF && isSystemTemplete|| isQuickSend) || vobj.parentWrokFlowTemplete || vobj.parentColTemplete) && nonTextTemplete || subState eq '16' || noselfflow eq 'noselfflow'}">disabled</c:when><c:otherwise>style="color: black;"</c:otherwise></c:choose>
                                    value="<c:out value='${contentContext.workflowNodesInfo}'></c:out>" name="process_info" title="${ctp:i18n('collaboration.newcoll.clickforprocess')}"/>
                                </div>
                            </td>
				            <td width="3%" class="padding_l_5">
				                <div id="workflowInfo">
									<c:if test="${noselfflow eq 'noselfflow'}">
										<a style="border-radius:0; background:#FFF;" comp="type:'workflowEdit',defaultPolicyId:'${curPerm.defaultPolicyId}',defaultPolicyName:'${curPerm.defaultPolicyName}',moduleType:'${curPerm.appName}',isTemplate:${isSystemTemplete?true:false },isView:true,workflowId:'${contentContext.wfProcessId==null ? "-1" : contentContext.wfProcessId}',caseId : '${contentContext.wfCaseId==null ? "-1" : contentContext.wfCaseId}'"
                                            class="common_button common_button_icon comp edit_flow" href="#">
                                            <em class="ico16 process_16"> </em>${ctp:i18n('collaboration.newColl.findFlow')}</a><!-- 查看流程 -->
									</c:if>
									<%--xuker 快速发文查看流程 20160316 start--%>
									<%--oldcode start --%>
									<%--<c:if test="${subState ne '16' && noselfflow ne 'noselfflow'}">
										<a style="border-radius:0; background:#FFF;" comp="type:'workflowEdit',defaultPolicyId:'${curPerm.defaultPolicyId}',defaultPolicyName:'${curPerm.defaultPolicyName}',moduleType:'${curPerm.appName}',<c:if test="${vobj.templeteId ne null && (vobj.fromSystemTemplete) && vobj.template.type ne 'text'}">isTemplate:true,</c:if><c:if test="${((onlyViewWF && isSystemTemplete)  || vobj.parentWrokFlowTemplete || vobj.parentColTemplete) && nonTextTemplete }">isView:true,</c:if>workflowId:'${contentContext.wfProcessId==null ? "-1" : contentContext.wfProcessId}'"
										   class="common_button common_button_icon comp edit_flow" href="#">
											<em class="ico16 process_16"> </em><c:if test="${!((onlyViewWF && isSystemTemplete) || vobj.parentWrokFlowTemplete || vobj.parentColTemplete) || vobj.template.type eq 'text'}">${ctp:i18n('collaboration.newcoll.bjlc')}</c:if><c:if test="${((onlyViewWF && isSystemTemplete) || vobj.parentWrokFlowTemplete || vobj.parentColTemplete)&& nonTextTemplete}">${ctp:i18n('collaboration.newColl.findFlow')}</c:if></a><!-- 查看流程 -->
									</c:if>--%>
									<%--oldcode end --%>
									<%--快速发文直接加载一个空流程，不允许修改--%>
									<%--new start --%>
									<c:if test="${subState ne '16' && noselfflow ne 'noselfflow'}">
										<a style="border-radius:0; background:#FFF;" comp="type:'workflowEdit',defaultPolicyId:'${curPerm.defaultPolicyId}',defaultPolicyName:'${curPerm.defaultPolicyName}',moduleType:'${curPerm.appName}',<c:if test="${vobj.templeteId ne null && (vobj.fromSystemTemplete) && vobj.template.type ne 'text' ||isQuickSend}">isTemplate:true,</c:if><c:if test="${((onlyViewWF && isSystemTemplete || isQuickSend )  || vobj.parentWrokFlowTemplete || vobj.parentColTemplete) && nonTextTemplete}">isView:true,</c:if>workflowId:'${contentContext.wfProcessId==null ? "-1" : contentContext.wfProcessId}'"
										   class="common_button common_button_icon comp edit_flow" href="#">
											<em class="ico16 process_16"> </em><c:if test="${!((onlyViewWF && isSystemTemplete||isQuickSend) || vobj.parentWrokFlowTemplete || vobj.parentColTemplete) || vobj.template.type eq 'text'}">${ctp:i18n('collaboration.newcoll.bjlc')}</c:if><c:if test="${((onlyViewWF && isSystemTemplete||isQuickSend) || vobj.parentWrokFlowTemplete || vobj.parentColTemplete)&& nonTextTemplete}">${ctp:i18n('collaboration.newColl.findFlow')}</c:if></a><!-- 查看流程 -->
									</c:if>
									<%--newcode end --%>
									<%--xuker 快速发文查看流程 20160316 end--%>
                                    <c:if test="${subState eq '16' && noselfflow ne 'noselfflow'}">
                                        <a style="border-radius:0; background:#FFF;" comp="type:'workflowEdit',defaultPolicyId:'${curPerm.defaultPolicyId}',defaultPolicyName:'${curPerm.defaultPolicyName}',moduleType:'${curPerm.appName}',isTemplate:true,isView:true,workflowId:'${contentContext.wfProcessId==null ? "-1" : contentContext.wfProcessId}',caseId : '${contentContext.wfCaseId==null ? "-1" : contentContext.wfCaseId}'"
                                            class="common_button common_button_icon comp edit_flow" href="#">
                                            <em class="ico16 process_16"> </em>${ctp:i18n('collaboration.newColl.findFlow')}</a><!-- 查看流程 -->
                                    </c:if>
				                </div>
				            </td>
				            </tr>
	                	</table>
	                	<!-- xl 6-24 -->
						<div align="right" style="margin-top:10px">
							<!-- 发送 -->
							<div class="right"><a id="sendId"
								class="common_button common_button_emphasize margin_r_5" style="padding:0 22px;">${ctp:i18n('collaboration.newcoll.send')}</a></div>
							<c:if test="${isQuickSend==false}">
							<!-- 保存待发 -->
							<div class="right"><a id="saveDraft" onClick="saveDraft()"
								class="common_button common_button_gray margin_r_5">${ctp:i18n("collaboration.newcoll.save")}</a></div>
							<!-- 存为模板 -->
							<div class="right"><a id="refresh1" onClick="saveAsTemplete()"
								class="common_button common_button_gray margin_r_5">${ctp:i18n("collaboration.newcoll.saveAsTemplate")}</a></div>
							</c:if>
						</div>
					</div>
                    </c:if>
                </div>
            </div>
        </div>
        <div class="layout_center"  id="centerBar" style="background:#fff;<c:if test="${newGovdocView==1 }">overflow:hidden</c:if>" layout="border:false,spiretBar:{show:false}">
        <c:if test="${newGovdocView==1 }">
        <table  border="0" cellspacing="0" cellpadding="0" style="width:100%;background:#f0f0f0">
        <!-- xl 6-24 -->
        	<tr>
        		<th style="background-color:#f0f0f0;font-size:13px;padding-left:10px" width="55px">公文单：</th>
        		<td width="35%">
	        		 <div>
						<select class="w30b left" id="edocCategoryList" onchange="changeFormList(this)" <c:if test="${isGovdocSystemTemplate }">disabled</c:if>>
						<c:forEach items="${edocCategoryList }" var="item" varStatus="status">
							<option value="${item.id }"<c:if test="${item.id == defaultCategoryId}" > selected="selected"</c:if>>${item.name }</option>
						</c:forEach>
						</select>
						<select style="width:68%" class="right" onchange="reloadFormContent(this)" id="formList" <c:if test="${isGovdocSystemTemplate }">disabled</c:if>>
						</select>
					</div>
        		</td>
        		<td >
        		<div style="float:left" id="toolbar" ></div>
        		</td>
        	</tr>
        </table>
        <!-- xl 6-24 -->
        <div class="xl_block">
        	<div class="common_tabs common_tabs_big clearfix margin_t_5 padding_l_5" style="clear:both;">
				<ul class="left margin_l_4">
			    	<li id="content_view_li" class="current" ><a onclick="showContentView()">${ctp:i18n('govdoc.form.text')}</a></li>
					<li id="govdoc_content_view_li" ><a onclick="dealPopupContentWin(true,true);">${ctp:i18n('govdoc.summary.text')}</a></li>
					<li id="workflow_view_li" >
						<a onclick="createWorkflowView()">${ctp:i18n('collaboration.workflow.label')} </a>
					</li>
				</ul>
		 	</div>
        </div>
        </c:if>
        <!--jsp:include page="/WEB-INF/jsp/common/content/content.jsp" /-->
        <jsp:include page="/WEB-INF/jsp/common/content/workflow.jsp" />
        <textarea id='formTextId' class='hidden'>${contentTextData}</textarea>
        <iframe id='zwIframe' name='zwIframe' style="border: 0;width:100%;height:100%;<c:if test='${newGovdocView==1 }'>height:83%;</c:if>display: block;" frameborder="0" marginheight="0" marginwidth="0" onload="_contentSetText()"></iframe>
        </div>
        <div name="edocContentDiv" id="edocContentDiv" style="width:0px;height:0px;overflow:hidden; position: absolute;">
    <v3x:editor htmlId="content" editType="${editType }"
	  content="${govdocContentObj.content== null ? '' : govdocContentObj.content}"
	  type="${govdocBodyType=='' || (govdocBodyType==null) ? 'OfficeWord' : govdocBodyType}"
	  originalNeedClone="${cloneOriginalAtts == null ? false : cloneOriginalAtts}"
	  createDate="${govdocContentCreateTime}"
	  category="4"
    />
</div>
	<c:if test= "${newGovdocView!=1 }">
        <div class="layout_east over_hidden padding_l_5" id="comment_deal" layout="width:35,border:false,sprit:false">
			<input type="hidden" id="id" value="${commentSenderList[0].id}">
            <input type="hidden" id="pid" value="0">
            <input type="hidden" id="clevel" value="1"> <input type="hidden" id="path" value="00">
            <input type="hidden" id="moduleType" value="${contentContext.moduleType}">
            <input type="hidden" id="moduleId" value="${contentContext.moduleId}">
			<input type="hidden" id="extAtt1">
            <input type="hidden" id="relateInfo">
            <input type="hidden" id="ctype" value="-1">
			<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0" class="border_all">
				<tr>
					<td id="adtional" valign="middle" height="20" class="padding_t_5 align_center font_size12">
                        <em id="adtional_ico" class="ico16 arrow_2_l"></em>
                        <span class="adtional_text display_block margin_t_5">${ctp:i18n('collaboration.newcoll.dangfu')}</span>
						<span class="adtional_text display_block margin_t_5">${ctp:i18n('collaboration.newcoll.dangyan')}</span>
					</td>
				</tr>
				<tr id="fuyan_area" class="hidden">
					<td id="fuyan" valign="top" align="center" class="editadt_box hidden">
						<textarea style="width:150px; padding: 0 5px;font-size:12px;" class="h100b" id="content_coll" name="content_coll" onclick="checkContent();" onblur="checkContentOut();"><c:forEach items="${commentSenderList}" var="csl" varStatus="status" begin="0"><c:out value="${csl.content}"></c:out><c:if test="${!status.last }"><c:out value="${__huanhang}" escapeXml="false"></c:out ></c:if></c:forEach></textarea>
					</td>
				</tr>
			</table>
        </div>
        </c:if>
    </div>
</form>
<v3x:webBarCode readerId="PDF417Reader" readerCallBack="initData" />
<script type="text/javascript">
var myContentNameId= "${myContentNameId}";
OfficeObjExt.showExt = newColOfficeObjExtshowExt;
</script>
</body>
</html>
<style type="text/css">
	/*include页面引入其他样式，导致页面checkbox公共样式被覆盖，故这里做样式重置 */
	.radio_com { margin-right: 6px;}
</style>
