<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common4coll.jsp"%>
<html class="h100b over_hidden">
<head>

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>${ctp:i18n('collaboration.newcoll.htmltitle')}</title>
	
	<script type="text/javascript" src="/seeyon/common/js/orgIndex/jquery.tokeninput.js${ctp:resSuffix()}"></script>
	<link rel="stylesheet" href="/seeyon/common/js/orgIndex/token-input.css${ctp:resSuffix()}" type="text/css" />
	<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x" %>
	<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/template/template.js.jsp" %>
    <%@ include file="/WEB-INF/jsp/apps/collaboration/new_print.js.jsp" %>
    <%@ include file="/WEB-INF/jsp/ctp/form/design/formDevelopmentOfadv.jsp" %>
    <c:if test="${ctp:hasPlugin('project')}">
		<jsp:include page="/WEB-INF/jsp/project/project_select.js.jsp" flush="true"/>
	</c:if>
	
	<c:set value="${vobj.template.type != 'text'}" var="nonTextTemplete" />
    <c:set value="${vobj.template.type != 'workflow'}" var="notworkflowTemplate" />
    <c:set value="${vobj.template!=null && vobj.systemTemplate}" var="isSystemTemplete" />
    <c:set value="${zwModuleId != null ? zwModuleId : '-1'}" var="zwModuleId" />
    <c:set value="${zwContentType != null ? zwContentType : '10'}" var="zwContentType" />
    <c:set value="${zwRightId != null ? zwRightId : ''}" var="zwRightId" />
    <c:set value="${zwIsnew != null ? zwIsnew : 'true'}" var="zwIsnew" />
    <c:set value="${zwViewState != null ? zwViewState : ''}" var="zwViewState" />
    <c:set value="${empty param.templateId ? vobj.summary.templeteId:param.templateId}" var="currentTemplateId" /> <!-- 当前的模板Id,个人模板的话是自己的Id,不是其父模板的Id -->
    
	
	<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/newCollaboration.js${ctp:resSuffix()}"></script>
    <c:if test="${(isSystemTemplete and ctp:hasPlugin('workflowAdvanced'))}">
        <link rel="stylesheet" href="${path}/apps_res/collaboration/css/dataRelation.css${ctp:resSuffix()}">
        <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/dataRelation.js${ctp:resSuffix()}"></script>
    </c:if>
	
	<style type="text/css">
 .bgcolor{
    background-color:transparent;
 }
 
 .align_left{
                text-align: left;
            }
            .common_contact{
                width: 100%;
                display: inline-block;
                height: auto;
                overflow: auto;
            }
            .common_contact li{
                font-size: 12px;
            }
            .common_contact li.common_contact_li{
                margin-top: 8px;
                margin-bottom: 8px;
            }
            .common_contact li.common_contact_li .ico16{
                margin-right: 8px;
            }
            .common_contact .common_contact_title{
                height: 36px;
                line-height: 36px;
                background: #e6e9ec;
                padding-left: 16px;
                font-size: 14px;
                margin-bottom: 15px;
                color:#797b73;
            }
            .common_people{
                color:#333;
            }
            .set_color_666{
                color:#666;
            }
            .common_contact ul li{
                height: 20px;
                line-height: 20px;
                padding-left: 26px;
                color:#666;
            }
            .common_contact ul li:hover{
                background: #3498da;
                color: #fff;
            }
            .layout_east{
                position: relative;
            }
            .shou{
                width: 7px;
                height: 48px;
                background: #ccc;
                position: absolute;
                left: 0;
                top: 40%;

            }
            .hide_span,.hide_span_people{
                position: absolute;
                left: 15px;
                display: none;
            }
            .hide_span{
                top: 50%;
                margin-top:-33px;
            }
            .hide_span_people{
                top: 50%;
                margin-top:-40px;
            }
            .common_button.common_button_icon.comp.edit_flow:hover{
                color: #333;
            }
            .common_contact_title{
                height:36px;
                line-height:36px;
                background:#e6e9ec;
                padding-left:16px;
                font-size:14px;
                color:#797b73;
            }
            
            #north_area_h{
                background: #f7f7f7;
            }
            #process_info_div{
                position: relative;
                height: 26px !important;
                font-size: 14px;
                margin-top: 5px;
            }
            #process_info_div .ico16{
                position: absolute;
                right: 3px;
                bottom: 6px;
                z-index: 2;
            }
            .attachmentArea{
            	max-height: 90px;
            	overflow-x: hidden;
            	overflow-y: auto;
            }
/* include页面引入其他样式，导致页面checkbox公共样式被覆盖，故这里做样式重置 */
     .radio_com {
        margin-right: 6px;
    }
    .span-ellipsis{
        width:210px !important;
        overflow: hidden;
        text-overflow: ellipsis;
        word-wrap: normal;
        white-space: nowrap;
        display: inline-block;
    }
</style>
	<script type="text/javascript" src="/seeyon/common/js/laytpl.js"></script>
	<script type="text/javascript">
			var pTemp = {"nodePolicy":'${newColNodePolicy}',"jval":"${jval}"};
			var isV5Member = ${CurrentUser.externalType == 0};
			var hasDoc = "${ctp:hasPlugin('doc')}";
			var DR = "${DR}";
			var summaryId = "${vobj.summaryId}";
			var _summaryId = "${vobj.summaryId}";
			var tps = '${param.tps}';
			var senderId = "${vobj.summary.startMemberId}";
			var nodePolicy = "newCol";;
			//取新建节点权限
			var nodePolicy = $.parseJSON(pTemp.nodePolicy);
			var officecanPrint = nodePolicy.print.toString();
			var affairState = "-1";
	   		// 正文组件判断，新建页面
  			var bIsContentNewPage = true;
	   		var openFrom = "newColl";//数据关联使用
			var bIsClearContentPadding = ${vobj.template.bodyType == 20 ? false : true};
			var hasColSubject = ${vobj.template.colSubject == null || vobj.template.colSubject == "" ? false : true};//判断是否有标题规则
			var checkPDFIsNull=false; //保存个人模板的标记，个人协同模板允PDF正文许为空
			//服务器时间和本地时间的差异
			var server2LocalTime = <%=System.currentTimeMillis()%> - new Date().getTime();
			var isForm ='${vobj.form}';
			var isFromTemplate = '<c:out value="${isFromTemplate}" default="false" />';
			var isSystemTemplete = '<c:out value="${isSystemTemplete}" default="false" />';
			//移动newCollaboration.js.jsp 变量开始
			var zdgzid ="${vobj.forGZShow}";
			var htdbry ="${vobj.forShow}";
			var officeOcxUploadMaxSize = "${officeOcxUploadMaxSize}";
			var bodyType = '${vobj.summary.bodyType}';
			var paramfrom = "${ctp:escapeJavascript(param.from)}";
            var from = "${ctp:escapeJavascript(from)}";
			var wfXmlInfo = '${vobj.wfXMLInfo}';
			var _callTemplateId = '${param.templateId}';
			var templateId = '${empty param.templateId ? vobj.summary.templeteId:param.templateId}';
			//系统模板ID,如果本身是系统模板取自己的ID，如果是个人模板存为的系统模板，取父模板ID
			var systemTemplateId = '${empty vobj.temformParentId  ? currentTemplateId :   vobj.temformParentId }';
			var canCopy = '${vobj.template.canCopy}';
			var _summaryActivityId = "start";
			var affairId = "${empty vobj.affairId  ? '-1' : vobj.affairId }";
			var isformTemplate = '${vobj.template!=null && vobj.template.bodyType == 20}';
			var uuidlong = '${uuidlong}';
			var ishideconotentType = ('${vobj.systemTemplate}' == 'true' && ('${vobj.template.type}' != 'workflow')) || ('${_hideContentType}' =='1');
			var istranstocol = '${transtoColl}' =='true';
			var transOfficeId ='${transOfficeId}' != '';
			var isneedsendcheck = '${vobj.summary.newflowType}' != '2' && '${subState}' != '16';
			var _subState = '${subState}';
			var isSysTem = ${vobj.template!=null && vobj.systemTemplate};
			var isTemFlag = '${vobj.template ne null}';
			var importantL = '${vobj.summary.importantLevel}';
			var deadl = '${vobj.summary.deadline}';
			var formAppid = '${vobj.summary.formAppid}';
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
			var waitsendflagnew = "${vobj.from}" == 'waitSend' && _subState !='1';
			var vobjparentwftem = '${vobj.parentWrokFlowTemplete}' =='true';
			var vobjstanddur = '${vobj.standardDuration}';
			var frompeoplecardflag = ${empty peopeleCardInfo ? 'false' : 'true'};
			var peoplecardinfoID = '${peopeleCardInfo.id}';
			var peoplecardinfoname = '${peopeleCardInfo.name}';
			var peoplecardinfoaccountid = '${peopeleCardInfo.orgAccountId}';
			var issameaccountflag = ${isSameAccount == 'false'};
			var accountobjsn = '${accountObj.shortName}';
			var warnforsupervise = '${noDepManager}' == 'true' && ${param.from ne 'waitSend'};
			var tracktypeeq2 = ${trackType eq 2};
			var formRecordid  = "${vobj.summary.formRecordid}" ;
			var fgzids = '${forGZIds}';
			var tracktypeeq0 = ${trackType eq 0};
			var savedrafttemVal = '${subState}' != '16';
			var issystemtemflag = '${vobj.template!=null && vobj.systemTemplate}' == 'true';
			var curlocationPath = '${path}';
			var useforsavetemsubjectflag = "${ctp:escapeJavascript(vobj.template.subject)}";
			var useforsavetemsubject = "${ctp:escapeJavascript(vobj.template.subject)}";
			var saveastemtype ='${vobj.template.type}';
			var pipeinfo1 = v3x.getMessage("collaborationLang.collaboration_alertPigeonholeItemFailure");
			var pipeinfo2 = v3x.getMessage("collaborationLang.file_save");
			var pipeinfo3 = v3x.getMessage("collaborationLang.submit");
			var pipeinfo4 = v3x.getMessage("collaborationLang.collaboration_alertPigeonholeItemFailure");
			var pipeinfo5 = v3x.getMessage("collaborationLang.cancel");
			var contentViewState = '${contentViewState}';
			var ordinalTemplateIsSys ='${ordinalTemplateIsSys}';
			var superviseTip = "${ctp:escapeJavascript(ctp:i18n('collaboration.common.common.supervise.specialCharacters'))}";
			var _expansion ="${ctp:i18n('collaboration.new.label.expansion')}";
			var _collapse ="${ctp:i18n('collaboration.new.label.collapse')}";
			var customSetTrackFlag = '${customSetTrack}' == 'true';
			var _bizConfig = "${vobj.from eq 'bizconfig'}" == "true";
			var projectId ="${vobj.projectId}";
			var _isProjectDisabled = ${disabledProjectId eq '1'};
			if(!${CurrentUser.externalType == 0}){//非A8人员
			    _isProjectDisabled = true;
			}
			var _isResendFlag = ${isResend eq '1'};
			var newColl = true;
			var affairMemberId = '${CurrentUser.id}';
			var affairMemberName = '${ctp:escapeJavascript(CurrentUser.name)}';
			var _affairMemberId = affairMemberId;
			//移动newCollaboration.js.jsp 变量结束
			//工作流相关的信息  摘自 include_variables.jsp 开始
			var mtCfg = ${contentCfg != null?contentCfg.mainbodyTypeListJSONStr:'[]'};
			var useWorkflow = "${contentCfg.useWorkflow}";
			<c:if test="${contentCfg.useWorkflow}">
				var wfItemId = '${contentContext.wfItemId}';
				var wfProcessId = '${contentContext.wfProcessId}';
				var wfProcessTemplateId = '${contentContext.processTemplateId}';
				var wfActivityId = '${contentContext.wfActivityId}';
				var CurrentUserId = '${CurrentUser.id}';
				var wfCaseId = '${contentContext.wfCaseId}';
				var loginAccount = '${CurrentUser.loginAccount}';
				var moduleTypeName = '${contentContext.moduleTypeName}';
			</c:if>
			//工作流相关的信息  摘自 include_variables.jsp 结束
			//***************
			if(getCtpTopFromOpener(window)!=null){  //如果顶层不为空
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
				<%-- 致信屏蔽快速选人 --%>
				if(paramfrom == 'a8genius'){
					 getCtpTopFromOpener(window).distroy_token = true;
				}
				<%-- V-Join屏蔽快速选人 --%>
				<c:if test="${CurrentUser.externalType != 0}">
			        getCtpTopFromOpener(window).distroy_token = true;
			    </c:if>
			}
			$("#process_info_div").click(function(){
				$("#token-input-process_info").css("color","#111");
			});
			$("#token-input-process_info").live("keydown", function(){
				$("#token-input-process_info").css("color","#111");
			});
			
			var defaultNodeName = "${defaultNodeName}";
			var defaultNodeLable = "${defaultNodeLable}";
			var isHistoryFlag = "false";
			//**************
			
			var canTrackWorkFlowValue = 0;
			<c:if test="${vobj.template eq null || (vobj.template ne null && vobj.template.canTrackWorkflow eq 0)}">
				canTrackWorkFlowValue = 0;
			</c:if>
            <c:if test="${vobj.template ne null && vobj.template.canTrackWorkflow eq 1}">
            	canTrackWorkFlowValue = 1;
            </c:if><%--追溯 --%>
            <c:if test="${vobj.template ne null && vobj.template.canTrackWorkflow eq 2}">
            	canTrackWorkFlowValue = 2;
            </c:if><%--不追溯 --%>
	</script>
</head>
<body class="h100b page_color" onunload="removeSessionMasterData('${vobj.summary.formRecordid}');">
<c:if test="${vobj.summary.bodyType eq '20' && scanCodeInput eq '1' }">
	<a style="margin-left: 200px;margin-top: 0; display: inline;z-index: 2;" id="GoTo_Top_scan" class="GoTo_Top_scan" title="二维码" href="javascript:void(0)" onclick="barCode()"></a>
</c:if>
<form method="post" id="sendForm"  name="sendForm" action='${path}/collaboration/collaboration.do?method=send&from=${param.from}&reqFrom=${param.reqFrom}' class="h100b">
    <div id='newColl_layout' class="comp" comp="type:'layout'">
        <div class="layout_north f0f0f0" layout="height:41,border:false,sprit:false">
            <%--toolbar--%>
		    <div class="padding_l_5 border_b">
			    <div id="toolbar"></div>
		    </div>
		    <%--toolbar结束--%>
        </div>
        <div class="layout_center" id="centerBar" style="overflow-y:hidden;background:#fff;" layout="">
        	<div id="north_area_h">
			    <!--当前位置-->
			    <c:if test="${from eq '' or from eq 'report' or
                    (from ne 'a8genius' and vobj.from ne 'bizconfig' and from ne 'peopleCard' )}">
                    <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F01_newColl'"></div>
                </c:if>
                 <c:if test="${vobj.from eq 'bizconfig'}">
                    <div class="comp" comp="type:'breadcrumb',comptype:'location'"></div>
                </c:if>
			  
			    <!-- <div id="colMainData" class="form_area new_page"> -->
			    <div id="colMainData" class="form_area padding_t_10">
			        <c:set var="resentTime" value="${vobj.summary.resentTime}" />
				    <c:if test="${param.from eq 'resend'}">
					    <c:set var="resentTime" value="${vobj.summary.resentTime + 1}" />
				    </c:if>
				    <c:set value="${(isSystemTemplete or not empty vobj.temformParentId)}" var="isFromSystem"/>
				    <c:set value="${isFromSystem ? (not empty vobj.temformParentId) ? vobj.temformParentId : vobj.template.id : ''}" var="tempId" />
				    <input type="hidden" id="temformParentId" name="temformParentId" value="${vobj.temformParentId}" />
				    <input type="hidden" id="resend" name="resend" value="${vobj.resendFlag}" />
				    <input type="hidden" id="newBusiness" name="newBusiness" value="${vobj.newBusiness}" />
				    <input type="hidden" id="id" name="id" value='${vobj.summaryId}'/>
				    <input type="hidden" id="parentSummaryId" name="parentSummaryId" value='${parentSummaryId}'/>
					<input type="hidden" id="attachmentArchiveId" name="attachmentArchiveId" value='${vobj.attachmentArchiveId}'/>
				    <input type="hidden" id="tId" name="tId" value='${tempId}'/>
				    <INPUT TYPE="hidden" id="curTemId" name="curTemId" value="${curTemplateID}" />
				    <input type="hidden" id="resentTime" name="resentTime" value="${resentTime}"/>
				    <input type="hidden" id="archiveId" name="archiveId" value="${vobj.summary.archiveId}" />
				    <input type="hidden" id="prevArchiveId" name="prevArchiveId" value="${vobj.summary.archiveId}" />
				    <!-- 当前处理人信息 -->
				    <input type="hidden" id="currentNodesInfo" name="currentNodesInfo" value="${vobj.summary.currentNodesInfo}" />

				    <input type="hidden" id="tembodyType" name="tembodyType" value="${vobj.template.bodyType}" />
				    <input type="hidden" id="formtitle" name="formtitle" value="${ctp:toHTML(vobj.formtitle)}" />
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
                    <input type="hidden" id="bodyType" name="bodyType"></input>
                    <input type="hidden" id="formRecordid" name="formRecordid"></input>
                    <input type="hidden" id="formAppid" name="formAppid" value="${vobj.template.formAppId}"></input>
                    <input type="hidden" id="formOperationId" name="formOperationId" value="${_formOperationId}"></input>
                    <input type="hidden" id="formParentid" name="formParentid" value="${vobj.template.formParentid}"></input>
                                        
                    
                    <input type="hidden" id="contentSaveId" name="contentSaveId"></input>
                    <input type="hidden" id="contentDataId" name="contentDataId"></input>
                    <input type="hidden" id="contentTemplateId" name="contentTemplateId"></input>
                    <input type="hidden" id="contentRightId" name="contentRightId"></input>
                    <input type='hidden' id='contentZWID' name="contentZWID" value="0"></input>
                    <input type="hidden" id='contentSwitchId' name="contentSwitchId" value=""></input>
                    <input type="hidden" id='DR' name="DR" value="${DR}"></input>
                    <%--高级归档 --%>
                    <input type="hidden" id="advancePigeonhole" name="advancePigeonhole" value="${v3x:toHTML(vobj.advancePigeonhole)}"></input>
                    <input type='hidden' id='contentIdUseDelete' name="contentIdUseDelete" value="0"></input>
 				    <table border="0" cellspacing="0" cellpadding="0" width="100%">
			            <tr>
				            <td rowspan="2" width="1%" nowrap="nowrap" class="padding_l_10">
				            	<a id='sendId' onclick="send()" class="margin_r_10 display_inline-block align_center new_btn">${ctp:i18n('collaboration.newcoll.send')}</a>
				            </td>
				            <th nowrap="nowrap" width="1%" class=''>${ctp:i18n('collaboration.newcoll.title')}</th>
						    <c:choose>
							    <c:when test="${vobj.collSubjectNotEdit == 'true'}">
                                    <!-- 标题 -->
				                    <td style="width:100%;"><div class="common_txtbox_wrap"><input  id="subject" inputName="${ctp:i18n('collaboration.newcoll.subject')}" class="w100b"  type="text"  name="subject" title="${ctp:i18n('collaboration.newcoll.clickfortitle')}" value="<c:out value='${ctp:toHTMLWithoutSpace(vobj.collSubject)}'></c:out>" readonly="readonly"style="height:26px;line-height:26px;"/></div></td>
				           	    </c:when>
				           	    <c:otherwise>
                                    <!-- 标题 -->
				                    <td style="width:100%;"><div class="common_txtbox_wrap"><input  id="subject" inputName="${ctp:i18n('collaboration.newcoll.subject')}" class="w100b" type="text" name="subject" title="${ctp:i18n('collaboration.newcoll.clickfortitle')}" value="${ctp:toHTMLWithoutSpace(vobj.summary.subject)}" defaultValue="${ctp:i18n('common.default.subject.value2')}" style="height:26px;line-height:26px;"/></div></td>
							    </c:otherwise>
				            </c:choose>
				            <td width="80" class="padding_l_5">
				                <div class="common_selectbox_wrap">
                                   <!--  <select id="importantLevel" name="importantLevel" class="codecfg "
                                        codecfg="codeId:'common_importance',defaultValue:1">
                                    </select> -->

										<select name="importantLevel" id="importantLevel" >
											<v3x:metadataItem itemList="${comImportanceMetadata}"
												showType="option" name="importantLevel"
												selected="${vobj.summary.importantLevel == null ? 1 : vobj.summary.importantLevel}" />
										</select>
									</div>
				            </td>
                            <!-- 关联项目 -->
                            <c:choose>
							    <c:when test="${(v3x:getSysFlagByName('col_showRelatedProject') == 'false')}">
							    <input type="hidden" id="projectId" name="projectId" value="${vobj.projectId}">
							    </c:when>
				           	    <c:otherwise>
				           	    <th width="1%" class=' padding_l_25' nowrap="nowrap" >
			           	    		<c:if test="${ctp:hasPlugin('project')}">
		            					${ctp:i18n('collaboration.newcoll.relatepro')}
		            				</c:if>
								</th>
			            		<td width="150" class="padding_r_20">
			           	    		<c:if test="${ctp:hasPlugin('project')}">
				            			<div class="common_selectbox_wrap" id="selectRelatepro" style="width:150px;"></div>
										<input type="hidden" id="projectId" name="projectId" value="${vobj.projectId}">
					            	</c:if>
			            		</td>
				           	    </c:otherwise>
				            </c:choose>
				           
			            <tr>
				            <th width="" nowrap="nowrap" class=''>${ctp:i18n('collaboration.newcoll.lc')}</th>
				            <td width=""><div id="process_info_div" class="common_txtbox_wrap <c:choose><c:when test="${((onlyViewWF && isSystemTemplete) || vobj.parentWrokFlowTemplete || vobj.parentColTemplete) && nonTextTemplete || subState eq '16'}">common_txtbox_wrap_dis</c:when></c:choose>">
                                <input readonly="readonly" class="w100b validate" type="text" id="process_info"
                                    defaultValue="${ctp:i18n('collaboration.default.workflowInfo.value')}"
                                    <c:choose><c:when test="${((onlyViewWF && isSystemTemplete) || vobj.parentWrokFlowTemplete || vobj.parentColTemplete) && nonTextTemplete || subState eq '16'}">disabled</c:when><c:otherwise>style="color: black;"</c:otherwise></c:choose>
                                    value="<c:out value='${contentContext.workflowNodesInfo}'></c:out>" name="process_info" title="${ctp:i18n('collaboration.newcoll.clickforprocess')}"/>
                                </div>
                            </td>
				            <td width="" class="padding_l_5">
				                <div id="workflowInfo" style="height:26px;margin-top:5px;" onclick="workflowClick()">
				                
				                	<c:set var="varWfProcessId" value="${contentContext.wfProcessId==null ? '-1' : contentContext.wfProcessId}"/>
				                	<c:set var="varFinalWfProcessId" value="${contentContext.processTemplateId ==null || contentContext.processTemplateId eq -1  ? varWfProcessId  : contentContext.processTemplateId}"/>
                                    <c:if test="${subState ne '16'}">
				            	    <a id="workflow_btn" style="border-radius:0; background:#FFF;height:24px;line-height:24px;color:#333;" comp="type:'workflowEdit',defaultPolicyId:'${defaultNodeName }',defaultPolicyName:'${defaultNodeLable }',moduleType:'${contentContext.moduleTypeName}',<c:if test="${vobj.templeteId ne null && vobj.fromSystemTemplete && vobj.template.type ne 'text'}">isTemplate:true,</c:if><c:if test="${((onlyViewWF && isSystemTemplete)  || vobj.parentWrokFlowTemplete || vobj.parentColTemplete) && nonTextTemplete}">isView:true,</c:if>workflowId:'${varFinalWfProcessId}'"
                                            class="common_button common_button_icon comp edit_flow" href="#">
                                            <em class="ico16 process_16"> </em><c:if test="${!((onlyViewWF && isSystemTemplete) || vobj.parentWrokFlowTemplete || vobj.parentColTemplete) || vobj.template.type eq 'text'}">${ctp:i18n('collaboration.newcoll.bjlc')}</c:if><c:if test="${((onlyViewWF && isSystemTemplete) || vobj.parentWrokFlowTemplete || vobj.parentColTemplete)&& nonTextTemplete}">${ctp:i18n('collaboration.newColl.findFlow')}</c:if></a><!-- 查看流程 -->
                                    </c:if>
                                    <c:if test="${subState eq '16'}">
                                        <a id="workflow_btn" style="border-radius:0; background:#FFF;height:24px;line-height:24px;" comp="type:'workflowEdit',defaultPolicyId:'${defaultNodeName }',defaultPolicyName:'${defaultNodeLable }',moduleType:'${contentContext.moduleTypeName}',isTemplate:false,isView:true,workflowId:'${varFinalWfProcessId}',caseId : '${contentContext.wfCaseId==null ? "-1" : contentContext.wfCaseId}'"
                                            class="common_button common_button_icon comp edit_flow" href="#">
                                            <em class="ico16 process_16"> </em>${ctp:i18n('collaboration.newColl.findFlow')}</a><!-- 查看流程 -->
                                    </c:if>
				                </div>
				            </td>
				            <th nowrap="nowrap" width="1%" class=' padding_l_25'>
				            	<c:if test="${ctp:hasPlugin('doc')}">
				            		${ctp:i18n('collaboration.newcoll.ygdd')}
				            	</c:if>
				            </th>
				            <td width="150" class="padding_r_25" style="padding-right:20px;padding-top:4px;">
				          	    <c:if test="${ctp:hasPlugin('doc')}">
					          	    <div class="common_selectbox_wrap" style="width:150px;">
	
					          	    <c:set var="isPrePighole" value="${canEditColPigeonhole and vobj.archiveName ne null && vobj.archiveName ne '' && vobj.fromTemplate == true  && (isSystemTemplete && vobj.template.type == 'template' || vobj.parentColTemplete)}"/>
					          	   	<input type="hidden" name="isTemplateHasPigeonholePath" id="isTemplateHasPigeonholePath" value="${isPrePighole}"/>
	
					          	    <select id="colPigeonhole" title="${ctp:toHTML(vobj.archiveAllName)}" class="input-100per" onchange="pigeonholeEvent(this)"
								        ${isPrePighole || setDisabled ? 'disabled=disabled' : "" }>
								        <option id="defaultOption" value="1">${ctp:i18n('collaboration.deadline.no')}</option>
                                        <!-- 请选择 -->
								        <option id="modifyOption" value="2">${ctp:i18n('collaboration.newColl.pleaseSelect')}</option>
								        <c:if test="${vobj.archiveName ne null && vobj.archiveName ne ''}" >
								    	    <option value="3" selected>${ctp:toHTML(vobj.archiveName)}</option>
								        </c:if>
								    </select>
								    </div>
								 </c:if>
						    </td>
			            </tr>
			          
			            </table>
			             <!--更多-->
			            <table class="newinfo_more hidden" border="0" cellspacing="0" cellpadding="0" width="100%" style=" margin-top:10px;">
			            	<tr>
			            		<th nowrap="nowrap" class=''>
                                <div class="common_checkbox_box clearfix ">
                                    <label class="hand" for="canTrack">
                                        <input id="canTrack" name="canTrack" onclick="trackOrnot()" value="1"  class="radio_com" type="checkbox">${ctp:i18n('collaboration.newcoll.gz')}</label>
                                </div>
	                            </th>
	                            <td nowrap="nowrap">
	                                <div class="common_checkbox_box clearfix ">
	                                    <label class="margin_r_10 hand disabled_color" for="radioall">
	                                        <input id="radioall" name="radioperson" onclick="_hiddenPartTrackNameInput()" value="0" type="radio"  disabled="disabled" class="radio_com">${ctp:i18n('collaboration.newcoll.allpeople')}</label>
	                                    <label class="margin_r_10 hand disabled_color" for="radiopart">
	                                        <input id="radiopart" name="radioperson"  onclick="trackPart()" value="0" type="radio" disabled="disabled" class="radio_com">${ctp:i18n('collaboration.newcoll.spepeople')}</label>
	                                        <input type="hidden" id="zdgzry" name="zdgzry" />
	
	                                </div>
	                            </td>
	                            <td style="padding-left:6px;"><input type="text" style="display: none; width:131px;" id="zdgzryName" readonly name="zdgzryName" size="15" onclick="$('#radiopart').click()"/></td>
					           
                             
                                <!-- 允许操作 -->
                                <th nowrap="nowrap" rowspan="3" valign="top" align="right" class=' padding_l_25' style="padding-top:3px;">${ctp:i18n('collaboration.newcoll.yxcz')}</th>
                                <td width="" rowspan="3" valign="top">
                                    <!--规则：系统流程模板改变流程置灰   其余4个都可以修改，不置灰的。
                                		系统格式模板改变流程可以修改不置灰，其他都灰色不能修改。-->
                                    <div class="common_checkbox_box clearfix " style="width:290px;">
                                       <span style="display:inline-block;margin-top:10px;">
                                        <label class="margin_r_10  hand display_block left" style="min-width:68px;" for="canForward"><input id="canForward" value="1" ${(vobj.fromTemplate == true || vobj.form == true)&&nonTextTemplete && notworkflowTemplate && isSystemTemplete ? 'disabled=disabled' : ""} class="radio_com" type="checkbox" ${vobj.summary.canForward ? 'checked' : ''}>${ctp:i18n('collaboration.newcoll.zf')}</label>

				           	    		<c:if test="${ctp:hasPlugin('doc')}">
                                        	<label class="margin_r_10  hand display_block right" for="canArchive"><input id="canArchive" value="1" ${(vobj.fromTemplate == true || vobj.form == true) && nonTextTemplete && notworkflowTemplate && isSystemTemplete ? 'disabled=disabled' : ""} class="radio_com" type="checkbox" ${vobj.summary.canArchive ? 'checked' : ''}>${ctp:i18n('collaboration.newcoll.gd')}</label>
                                        </c:if>
                                        </span>
                                        	
                                       <span style="display:inline-block;margin-top:7px;">
                                        <label class="margin_r_10 hand display_block left" for="canEditAttachment"><input id="canEditAttachment" value="1" ${vobj.fromTemplate == true && nonTextTemplete && notworkflowTemplate && isSystemTemplete ? 'disabled=disabled' : ""} class="radio_com" type="checkbox" ${vobj.summary.canEditAttachment ? 'checked' : ''}>${ctp:i18n('collaboration.newcoll.xgfj')}</label>
                                        
                                        <label class="display_block left margin_r_10" for="canEdit"><input id="canEdit" value="1" ${vobj.fromTemplate == true && nonTextTemplete && notworkflowTemplate && isSystemTemplete ? 'disabled=disabled' : ""} class="radio_com" type="checkbox" ${vobj.summary.canEdit ? 'checked' : ''}>${ctp:i18n('collaboration.newcoll.xgzw')}</label>
                                        <label class="margin_r_10 hand display_block left" for="canModify"><input id="canModify" value="1" ${(vobj.fromTemplate == true || vobj.form == true) && nonTextTemplete && isSystemTemplete ? 'disabled=disabled' : ""} class="radio_com" type="checkbox" <c:if test="${vobj.summary.canModify}">checked</c:if> >${ctp:i18n('collaboration.newcoll.gblc')}</label>
                                       </span>
                                        
                                       
                                        <label class="hand display_block left" for="canMergeDeal" style="margin-top:7px;"><input id="canMergeDeal" disabled="disabled" value="1" class="radio_com" type="checkbox" <c:if test="${vobj.summary.canMergeDeal}">checked</c:if> >${ctp:i18n('collaboration.allow.canmergedeal.label')}</label>
                                      <label class="margin_t_10 hand display_block left" style="margin-top:10px;" for="canAnyMerge"><input id="canAnyMerge" disabled="disabled" value="1" class="radio_com" type="checkbox" <c:if test="${vobj.summary.canAnyMerge}">checked</c:if> >${ctp:i18n('collaboration.allow.before.same.merge.label')}</label> 
                                    </div>
                                </td>
								<!-- 督办人员 -->
				            	<th width="1%" nowrap="nowrap" class='padding_l_25'>${ctp:i18n('collaboration.newcoll.dbry')}</th>
                                <td width="150" class="padding_r_25" style="padding-right:20px; padding-bottom:10px;">
				    			 	<input type="hidden" name="unCancelledVisor" id="unCancelledVisor" value="${_SSVO.unCancelledVisor }">
				    			 	<input type="hidden" name="supervisorIds" id="supervisorIds" value="${_SSVO.supervisorIds }"/>
				    			 	<input type="hidden" name="detailId" id="detailId" value="${_SSVO.detailId}" />
                                    <div class="common_txtbox_wrap ">
                                        <%--允许发起人设置督办人  <c:if test="${vobj.template ne null && !vobj.template.canSupervise}">disabled</c:if> --%>
                                        <c:choose>
                                            <c:when test="${(vobj.template ne null && !vobj.template.canSupervise) || CurrentUser.externalType != 0}">
                                                <input value="${_SSVO.supervisorNames}" type="text" disabled/>
                                                <input type="hidden" id="supervisorNames" name="supervisorNames" value="${_SSVO.supervisorNames}" >
                                            </c:when>
                                            <c:otherwise>
                                                <input id="supervisorNames" name="supervisorNames" onclick="superviseNamesClick()" value="${_SSVO.supervisorNames}" type="text"/>
                                            </c:otherwise>
                                        </c:choose>
								    </div>
                                </td>
			            	</tr>
			            	<tr>
			            		<!-- 流程期限 -->
					            <th width="110" nowrap="nowrap" class=' padding_l_10'>${ctp:i18n('collaboration.newcoll.lcqx')}</th>
					            <td width="100">
	                                <c:set value= "${vobj.templeteHasDeadline && (isSystemTemplete || vobj.parentColTemplete || vobj.parentTextTemplete || vobj.parentWrokFlowTemplete || vobj.fromSystemTemplete)}" var ="isDisabled"/>
	                                <div class="common_selectbox_wrap">
				                        <select name="deadLine" id="deadLine" ${isDisabled ? 'disabled=disabled' : ''} style="width: 100%" onchange="valiDeadAndLcqx(this)">
								   			<v3x:metadataItem itemList="${collaborationDeadlines}" showType="option" name="deadline" selected="${vobj.summary.deadline}" />
									    </select>
								    </div>
                                </td>
                                <td width="140" style="padding-left:6px;">
                                    <div id="deadLineCalender" style="display:none">
	                                   <input id="deadLineDateTime" type="text" style="width:131px;" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true,onUpdate:checkDeadLineDateTime">
	                                </div>
	                                <input type="hidden" name="deadLineDateTimeHidden" id="deadLineDateTimeHidden" value="${vobj.deadLineDateTimeHidden}" />
                                </td>
								<!-- 督办期限 -->
                                <th nowrap="nowrap" class='padding_l_25'>${ctp:i18n('supervise.col.deadline')}</th>
                                <td class="padding_r_25" style="padding-right:20px;padding-bottom:10px;">
                                    <div class="common_txtbox_wrap">
                                        <%--允许发起人设置督办人  <c:if test="${vobj.template eq null || !vobj.template.canSupervise}">disabled</c:if> --%>
                                        <c:choose>
                                            <c:when test="${(vobj.template ne null && !vobj.template.canSupervise) || CurrentUser.externalType != 0}">
                                                <input class="comp" value="${_SSVO.awakeDate}" type="text" disabled>
                                                <input id="awakeDate" class="comp" value="${_SSVO.awakeDate}" type="hidden" >
                                            </c:when>
                                            <c:otherwise>
                                                <input id="awakeDate" class="comp" value="${_SSVO.awakeDate}" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true,onUpdate:checkAwakeDate" readonly>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>
			            	</tr>
			            	<tr>
			            		<!-- 提前提醒 -->
					            <th nowrap="nowrap" class=' padding_l_10'>${ctp:i18n('collaboration.newcoll.beforetx')}</th>
					            <td>
	                                <div class="common_selectbox_wrap">
	                                    <c:set  var ="reminddiabled"  value="${vobj.templeteHasRemind && (isSystemTemplete || vobj.parentColTemplete || vobj.parentTextTemplete || vobj.parentWrokFlowTemplete || vobj.fromSystemTemplete)}" />
	                                    <select name="advanceRemind" id="advanceRemind" ${reminddiabled ? 'disabled=disabled' : ''} style="width: 100%" onchange="valiDeadAndLcqx(this)">
								   			<v3x:metadataItem itemList="${commonRemindTimes}" showType="option" name="deadline" selected="${vobj.summary.advanceRemind}" />
									    </select>
					          	    </div>
	                            </td>
	                            <td/>
	                             <%--督办主题 --%>
                                <th nowrap="nowrap" class=' padding_l_25'>${ctp:i18n('supervise.col.title')}</th>
                                <td class="padding_r_25" style="padding:0 20px 10px 0px;">
                                    <%--允许发起人设置督办人   <c:if test="${vobj.template ne null && !vobj.template.canSupervise}">disabled</c:if> --%>
                                    <c:choose>
                                        <c:when test="${(vobj.template ne null && !vobj.template.canSupervise) || CurrentUser.externalType != 0}">
                                            <textarea class="w100b font_size12" title="${_SSVO.title}" style="height: 53px;resize:none;" disabled>${_SSVO.title}</textarea>
                                            <input type="hidden" id="title" name="superviseTitle" value="${_SSVO.title}" >
                                        </c:when>
                                        <c:otherwise>
                                            <textarea class="w100b font_size12"  title="${_SSVO.title}"  style="height: 24px;resize:none;width:148px;margin-left:0;" id="title" name="superviseTitle">${_SSVO.title}</textarea>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
			            	</tr>
			            	<tr>
			            		<td nowrap="nowrap" class="padding_l_10 padding_l_5" colspan="3" align="left">
			            			<!-- 只有自由协同勾选了流程期限才可以勾选自动终止 -->
                            	    <div class="common_checkbox_box clearfix left" style="padding-left:40px;text-align:left;display:inline-block;">
							            <label class="hand" for="canAutostopflow">
                                        <input id="canAutostopflow" value="1" name="canAutostopflow" disabled
                                            <c:if test='${vobj.summary.canAutostopflow}'>checked</c:if>   class="radio_com" type="checkbox">${ctp:i18n('collaboration.newcoll.lcqxdszdzz')} </label>
                            	    </div>
                            	    <!-- 基准时长 -->
                                	<div class='left padding_l_30' nowrap="nowrap" style="display:inline-block;">${ctp:i18n('collaboration.newcoll.jjsc')}
                                		<span id='standdc' nowarp="nowarp" ><c:if test="${vobj.standardDuration ne null}">${vobj.standardDuration}</c:if><c:if test="${vobj.standardDuration eq null}">${ctp:i18n('collaboration.newcoll.wu')}</c:if>
                                	</div>
                                </td>
                            	
			            		<%--是否追溯流程： --%>
                                <td  nowrap="nowrap" align="right">
	                                	${ctp:i18n("collaboration.newcoll.isNoProcess")}
                                </td>
                                <td id='canTrackWorkFlowTd'>
                                    <%-- 由撤销/回退人决定 --%>
                                	<c:if test="${vobj.template eq null || (vobj.template ne null && vobj.template.canTrackWorkflow eq 0)}">${ctp:i18n("collaboration.newcoll.undoRollback")}</c:if>
                                	<c:if test="${vobj.template ne null && vobj.template.canTrackWorkflow eq 1}">${ctp:i18n("collaboration.newcoll.trace") }</c:if><%--追溯 --%>
                                	<c:if test="${vobj.template ne null && vobj.template.canTrackWorkflow eq 2}">${ctp:i18n("collaboration.newcoll.noTrace") }</c:if><%--不追溯 --%>
                                </td>
                               <td></td>
			            	</tr>
			            </table>
			            <div style="height:33px;overflow:hidden;">
			            	  <!--Jerry start-->
			            	<span style="display:inline-block; margin-left:88px; margin-top:10px;margin-bottom:5px;">
			            		<c:if test="${newColNodePolicyVO.uploadAttachment}">
				            		<span class="font_size12 color_666 margin_r_20 hand" onclick="insertAttachmentPoi('Att')">
				            			<span class="ico16 affix_16 margin_b_5"></span>
				            			${ctp:i18n('permission.operation.UploadAttachment')}
				            		</span>
			            		</c:if>
			            		<c:if test="${newColNodePolicyVO.uploadRelDoc}">
				            		<span class="font_size12 color_666 hand" onclick="quoteDocument('Doc1')">
				            			<span class="ico16 associated_document_16 margin_b_5"></span>
				            			${ctp:i18n('permission.operation.UploadRelDoc')}
				            		</span>
								</c:if>
			            	</span>
			            	
			            	 <span class="padding_r_25 right"  style="display:inline-block;text-align:right; margin-top:10px;margin-bottom:5px;">
				            	<a id="show_more" class="clearfix" style="width:100px;"><span class="ico16 arrow_2_b"></span>${ctp:i18n('collaboration.newcoll.show')}</a>
				            </span>
			            
			            <!--Jerry end-->
			            </div>
			            <div class="attachmentArea">
			            <div id="attachmentTRAtt" style="display:none;">
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" class="line_height180">
                            <tr id="attList">
                                <td class="align_right" valign="top" style="width: 104px">
                                	<div class="div-float margin_t_5">
                                	<em class="ico16 affix_16"></em>
                                	</div>
                                </td>
                                <td valign="top" width="30" nowrap="nowrap"><div class="div-float margin_t_5 margin_r_5">(<span id="attachmentNumberDivAtt"></span>) </div></td>
                                <td class="align_left">
                                    <div id="attFileDomain"  class="comp" comp="type:'fileupload',attachmentTrId:'Att',applicationCategory:'1',canFavourite:false,canDeleteOriginalAtts:true,originalAttsNeedClone:${vobj.cloneOriginalAtts},callMethod:'insertAtt_AttCallback',delCallMethod:'insertAtt_AttCallback',takeOver:false,noMaxheight:true" attsdata='${vobj.attListJSON }'></div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="attachment2TRDoc1" style="display:none; margin-top:4px;">
                        <table border="0" cellspacing="0" cellpadding="0" width="100%" class="line_height180">
                            <tr id="docList">
                                <td class="align_right" valign="top" style="width: 104px"><div class="margin_t_5"><span class="ico16 associated_document_16"></span></div> </td>
                                <td valign="top" width="30" nowrap="nowrap"><div class="div-float margin_t_5 margin_r_5">(<span id="attachment2NumberDivDoc1"></span>) </div></td>
                                <td class="align_left">
                                    <div class="comp" id="assDocDomain" comp="type:'assdoc',attachmentTrId:'Doc1',modids:'1,3',applicationCategory:'1',referenceId:'${vobj.summary.id}',canDeleteOriginalAtts:true,originalAttsNeedClone:${vobj.cloneOriginalAtts},callMethod:'insertAtt_AttCallback',delCallMethod:'insertAtt_AttCallback',noMaxheight:true" attsdata='${vobj.attListJSON }'></div>
                                </td>
                            </tr>
                        </table>
                    </div>
                    </div>
			           
                </div>
            </div>
        <!--jsp:include page="/WEB-INF/jsp/common/content/content.jsp" /-->
        <jsp:include page="/WEB-INF/jsp/common/content/workflow.jsp" />
        <textarea id='formTextId' class='hidden'>${contentTextData}</textarea>
        <div class="overflow_auto" id="contentAndComment" style="overflow-y:auto; background:#d8d9db;">
        <iframe id='zwIframe' name='zwIframe' style="border: 0;width:100%;height:100%;display: block;" frameborder="0" marginheight="0" marginwidth="0" onload="_contentSetText()"
        src="/seeyon/content/content.do?method=index&isFullPage=true&formpage=newcol&isNew=${zwIsnew}&moduleId=${zwModuleId}&moduleType=1&rightId=${zwRightId}&contentType=${zwContentType}&&originalNeedClone=true&transOfficeId=${transOfficeId}<c:if test='${"" ne zwViewState}'>&viewState=${zwViewState}</c:if><c:if test='${"resend" eq param.from}'>&resend=true</c:if>&rnd=<%=java.lang.Math.random()%>"></iframe>
       	 	<iframe id='zwOfficeIframe' hasLoad="false" name='zwOfficeIframe' src="/seeyon/collaboration/collaboration.do?method=tabOffice" style="width:100%;height:786px;display:none;" frameborder="0"></iframe>
			<c:if test="${vobj.from  eq 'waitSend' and subState !='1'}">
			<ul class="content_view" style="background:#d8d9db; border-top: 1px solid transparent;">
			<jsp:include page="/WEB-INF/jsp/common/content/commentForSummary.jsp" />
			</ul>
			</c:if>
		</div>
           <div class="over_hidden" id="comment_deal" style="z-index:2; height: 41px; background:#d8d9db; width:100%; text-align:center;position:absolute;bottom:0;">
				<input type="hidden" id="id" value="${commentSenderList[0].id}">
	            <input type="hidden" id="pid" value="0">
	            <input type="hidden" id="clevel" value="1"> <input type="hidden" id="path" value="00">
	            <input type="hidden" id="moduleType" value="${contentContext.moduleType}">
	            <input type="hidden" id="moduleId" value="${contentContext.moduleId}">
				<input type="hidden" id="extAtt1">
	            <input type="hidden" id="relateInfo">
	            <input type="hidden" id="ctype" value="-1">
	            
				<table style="border-top:1px solid #ccc;background:#f7f7f7;position: relative;width:786px;left: 50%;margin-left: -393px;" class="h100b" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td id="adtional" valign="middle" align="left" height="35" class="padding_t_5 font_size12">
	                        <em id="adtional_ico" class="ico16 arrow_2_b msg_expansionIco margin_ico margin_b_5"></em>
	                        <span class="adtional_text margin_t_5 font_size14 color_666">${ctp:i18n('collaboration.newcoll.dangfuyan')}</span>
						</td>
					</tr>
					<tr id="fuyan_area" class="hidden">
						<td id="fuyan" valign="top" align="center" class="editadt_box padding_l_5">
							<textarea style="width:766px; padding: 0 5px;font-size:12px; min-height:115px;" class="h100b" id="content_coll" name="content_coll" onclick="checkContent();" onblur="checkContentOut();"><c:forEach items="${commentSenderList}" var="csl"><c:out value="${csl.content}"></c:out><c:out value="${__huanhang}" escapeXml="false"></c:out></c:forEach></textarea>
						</td>
					</tr>
				</table>
	        </div>
        </div>
        
        <c:set var="hasPeoplesArea" value="${((empty param.from or param.from=='relateProject') && empty contentContext.workflowNodesInfo && empty peopeleCardInfo) || showTraceWorkflows}"/>
        <c:if test="${(hasPeoplesArea and CurrentUser.externalType == 0) or (isSystemTemplete and ctp:hasPlugin('workflowAdvanced'))}">
        	<div class="layout_east over_hidden" layout="minWidth:270,maxWidth:270,sprit:false">
	        	<img id="hidden_side"  class="shou" src="/seeyon/common/images/shou.jpg">
	        	<span class="hide_span" style="font-size:12px;color:#333;" title='${ctp:i18n("collaboration.newcoll.common.related.data")}'>${ctp:i18n("collaboration.newcoll.common.related.data")}</span><!-- 相<br/>关<br/>数<br/>据 -->
	        	<span class="hide_span_people" style="font-size:12px;color:#333;" title='${ctp:i18n("collaboration.newcoll.common.Contacts")}'>${ctp:i18n("collaboration.newcoll.common.Contacts")}</span><!--  常<br/>用<br/>联<br/>系<br/>人-->
	        	<!--数据关联区域-->
	        	<c:choose>
	        		<c:when test="${isSystemTemplete}">
	        			 <jsp:include page="/WEB-INF/jsp/apps/collaboration/dataRelation.jsp" />
	        		</c:when>
	        		<c:otherwise>
	        			<%-- 
	        			1.新建的时候显示最近联系人
	        			2.项目协同显示
	        			3.待发/人员卡片/关联人员进入的不显示 paramform
	        			4.有流程的不显示  （js控制）
	        			 --%>
	        			<div class="common_contact_title">${ctp:i18n("collaboration.newcoll.common.peoples")}</div><%-- 常用联系人--%>
	        			<c:if test="${hasPeoplesArea}">
		        			<ul class="common_contact" id ="hasPeoplesArea">
								<li class="margin_l_10 common_contact_li">
									<span class="common_people" onclick="showOrHiddenCommonPeoples(this,'rp')"><span class="ico16 arrow_toggle_ss_16 margin_b_5"></span>${ctp:i18n("collaboration.newcoll.relative.peoples")}<div id="relativePeopleNum" style="display:inline-block"></div></span><%-- 关联人员--%>
									<ul class="hidden" id="relativePeopleArea">
									</ul>
								</li>
								<li class="margin_l_10  common_contact_li">
									<span class="common_people" onclick="showOrHiddenCommonPeoples(this,'cp')"><span class="ico16 arrow_toggle_zk_16 margin_b_5"></span>${ctp:i18n("collaboration.newcoll.recent.peoples")}（${recentPeoplesLength}）</span><%--最近联系人 --%>
									<ul class="dele_ovarflow" style="margin-top:1px;">
										<c:forEach items="${recentPeoples}" var="p"><li v="${ctp:toHTML(p.v)}" k="${p.k}" d="${p.d}" s="${p.s}" title="${ctp:toHTML(p.v)}" class="text_overflow" onclick="clickName(this);">${ctp:toHTML(p.v)}</li></c:forEach>
									</ul>
								</li>
							</ul> 
						</c:if>
	        		</c:otherwise>
	        	</c:choose>
       		</div>
        </c:if>
    </div>
</form>
<c:if test="${(isSystemTemplete and ctp:hasPlugin('workflowAdvanced')) || param.from == 'waitSend'}">
<%@ include file="/WEB-INF/jsp/ctp/form/formreport/form/queryReport/formreport_chart.js.jsp"%>
</c:if>
<script type="text/javascript">
OfficeObjExt.showExt = newColOfficeObjExtshowExt;
</script>
<c:if test="${vobj.from  eq 'waitSend' and subState !='1'}">
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/comment.js${ctp:resSuffix()}"></script>
</c:if>
</body>
</html>