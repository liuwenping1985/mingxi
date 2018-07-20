<%--
 $Author:  zhaifeng$
 $Rev:  $
 $Date:: 2012-09-07#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ include file="include/info_header.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/info/common/info_print.js.jsp" %>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> 
<script type="text/javascript" src="${path}/ajax.do?managerName=colManager,phraseManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=infoManager"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/doc/js/knowledgeBrowseUtils.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/common/office/js/office.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/doc/js/docFavorite.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path }/apps_res/info/js/common/gov_content.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/info/js/summary.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/info/js/summary_topic.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/info/js/summary/deal.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/info/js/summary/stepBack.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path }/apps_res/info/js/summary/info_opinion.js${ctp:resSuffix()}"></script>

<c:set value="${summaryVO.infoOpinion==null ? 0 : summaryVO.infoOpinion.id }" var="commentId" />
<script type="text/javascript">
    $(function(){
        
    })
</script>
<!-- 查看处理页面 -->
<title>${ctp:i18n('collaboration.summary.pageTitle')}</title>
<style type="text/css">
	.page_color {
		background-color:white;
	}
    .stadic_head_height{}
    .stadic_body_top_bottom{bottom: 0;overflow:hidden;}
    	.metadataItemDiv {
		float: left;
		padding-right: 5px;
		font-size: 12px;
		color: black;
	}
	.edoc_deal_table{
		margin:0 -10px;
	}
	.edoc_deal{
		border-top:1px #bebdbd solid;
		border-bottom:1px #bebdbd solid;
	}
	
	.attach_font_size_fix{
	   font-size: 12px;
	}
</style>
<script type="text/javascript">
var editorStartupFocus = false;
var sendAffairId = '${sendAffairId}';
var _summaryProcessId = '${summaryVO.summary.processId}';
var _summaryActivityId = '${summaryVO.activityId}';
var _summaryCaseId = '${summaryVO.summary.caseId}';
var _summaryItemId=  '${summaryVO.workitemId}';

var _contextProcessId = '${contentContext.wfProcessId}';
var _contextActivityId = '${contentContext.wfActivityId}';
var _contextCaseId = '${contentContext.wfCaseId}';
var _contextItemId = '${contentContext.wfItemId}';

var show1 = '${show1}';
var show2 = '${show2}';

var curUser ='${CurrentUser.id}';
var _ctxPath='${path}';
var summaryId = '${summaryVO.summary.id}';
var affairId  = '${summaryVO.affairId}';
var commentId = '${summaryVO.infoOpinion==null? 0 : summaryVO.infoOpinion.id}';
<%--后台已经使用ctp:toHTML()进行了一次转义了，所以这个地方不能重复转义了--%>
var subject = '${ctp:escapeJavascript(summaryVO.summary.subject)}';
var hasUpdateInfoForm = false;
var show_MoreSign = false;
var show_InfoContent = false;
var show_UpdateAtt = false;
var show_SpecifiesReturnBack = false;
var nodePerm_ActionList = <c:out value="${totalActions}" default="null" escapeXml="false"/>;
var openFrom = "${ctp:escapeJavascript(summaryVO.openFrom)}";
var _isOfficeTrans = ${v3x:isOfficeTran()};
var _contentType = '${summaryVO.summary.bodyType}';
var proce = "";
var layout = null;
var _disPosition = "${disPosition}";//当前的节点权限，(意见定位的显示)
var canShowAttitude = "false";
var canShowOpinion="${v3x:containInCollection(totalActionList, 'Opinion')}";  //允许显示处理意见
var canShowCommonPhrase="${v3x:containInCollection(totalActionList, 'CommonPhrase')}"; //允许显示常用语
var canUploadRel="${v3x:containInCollection(totalActionList, 'UploadRelDoc')}";//允许关联文档
var canUploadAttachment="${v3x:containInCollection(totalActionList, 'UploadAttachment')}";//可以上传附件
var canEdit="false";//这个参数控制了Office的正文修改按钮是否可用"${(v3x:containInCollection(totalActionList, 'Edit') or v3x:containInCollection(totalActionList, 'Edit'))}";
var isSupervise = '';  //是否督办
var isCurSuperivse = '';
var isFinish = ${(summaryVO.finishDate!= null) ? true : false}; //流程是否已完成
var isFromTemplate = '';//当前信息是否有模板ID 
var _scene = "${scene}"; //流程需要传的url参数之一
var _contextProcessId = "${contentContext.wfProcessId}";// 流程的ProcessId
var _contextActivityId = "${contentContext.wfActivityId}";
var _contextCaseId = "${contentContext.wfCaseId}";
var _contextItemId = "${contentContext.wfItemId}";
var _nodePolicyOpinionPolicy = "${nodePolicyOpinionPolicy}";//流程节点处理意见是否必填 1 ： 必填
var operationId = "${summaryVO.operationId}";
var summaryReadOnly = "${summaryVO.readOnly}";
var affairState = "${summaryVO.affairState}";//affair的state
var subState = '${summaryVO.affair.subState}';
var _currentUserId = "${user.id}";
var _currentUserName = "${user.name}";
var accountId ="${user.accountId}";
var loginAccount ="${user.loginAccount}";
var departmentId="${user.departmentId}";
var departmentName = "${departNameForPrint}";
var rightId = '';//TODO
var isCurrentUserSupervisor = "${summaryVO.isCurrentUserSupervisor}";
/***工作需要的参数***/
var activityId = "${summaryVO.affair.activityId}";
var performer = "${summaryVO.affair.memberId}";
var accountId ="${summaryVO.summary.orgAccountId}";
var flowPermAccountId = "${flowPermAccountId}";
var trackMember="${trackIds}";
var trackType = '${trackType}';
var opinionJson = '${opinionJSON}'
var beCalledFlag ='${beCalledFlag}';
/***工作需要的参数***/
$(function(){
    
})

/******* 指定回退参数定义 start *******/
var optionType = '${optionType}';
var stepBackAffairState = '${stepBackAffairState}';//上一次退回状态
var fromSendBack = ${summaryVO.fromSendBack=='true'};//被退回人
/******* 指定回退参数定义 end ********/

/******* 报送单意见显示参数定义 start *******/
${opinionsJs}
${opinionElementsJs}
var isOutOpinions = false;
var _showHastenButton='true';
/******* 报送单意见显示参数定义 end ********/
</script>

<!-- 判断是否有正文保存权限 -->
<c:if test="${!ctp:containInCollection(totalActionList, 'SaveContentAcc')}">
   <script>
      var officecanSaveLocal = 'false';//没有保存正文的权限
   </script>
</c:if>

<!-- 判断是否有正文打印权限 -->
<c:if test="${!ctp:containInCollection(totalActionList, 'ContentSave')}">
   <script>
      var officecanPrint = 'false';//没有打印正文的权限
   </script>
</c:if>

</head>
<body class="h100b over_hidden page_color">
	<v3x:attachmentDefine attachments="${attachments}" />
    <div id='layout'>
        <%--<%@ include file="/WEB-INF/jsp/common/supervise/supervise.js.jsp" %> --%>
        <input type="hidden" id="content" name="content" value="" />
        <div class="layout_center over_hidden h100b" id="center">
                <c:set var="summary" value="${summaryVO.summary}" />
                <!--查看区域-->
                <div class="h100b stadic_layout">
                    <div class="stadic_head_height" id="summaryHead">
                        <!--标题+附件区域-->
                        <c:if test="${summaryVO.openFrom == 'Pending' and summaryVO.affairState == '3'}">
                        <div id="colSummaryData" class="newinfo_area title_view">
                        	<input type="hidden" id="fromSendBack" value="${fromSendBack }" />
							<input type="hidden" id="optionType" value="${optionType }" />
							<input type="hidden" id="stepBackWay" />
							<input id="infoFlag" name="infoFlag" type="hidden"/>
                        	<input type="hidden" name="affairId" id="affairId" value="${summaryVO.affairId}"/>
                            <input type="hidden" value="" id="contentstr" name ="contentstr"/>
                            <input type="hidden" name="summaryId" id="summaryId" value="${summaryVO.summary.id}">
                            <input id="subject" name="subject" type="hidden" value="${summaryVO.summary.subject}">
                            <input id="bodyType" name="bodyType" type="hidden" value="${summaryVO.summary.bodyType}">
                            <input id="processChangeMessage1" name="processChangeMessage1" type="hidden" value=""/>
                            <input type="hidden" id="pushMessageMemberIds" name="pushMessageMemberIds" value="">
                            <input id="attitudeFlag" name="attitudeFlag" type="hidden" value="${summaryVO.infoOpinion.attribute==null?0:summaryVO.infoOpinion.attribute}"/><!-- 意见表示标志位 -->
                            <input id="attitudeOp" name="attitudeOp" type="hidden" value="${fn:escapeXml(summaryVO.infoOpinion.content)}"/>
                            <input id="attModifyFlag" name="attModifyFlag" type="hidden" value="0"/><!-- 修改附件标志位 -->
                            <input type="hidden" id="nodePolicy" name="nodePolicy" value="${summaryVO.affair.nodePolicy }" />
                            <input type="hidden" name="oldOpinionId" id="oldOpinionId" value="${summaryVO.infoOpinion.id}" />
                            <input id="modifyFlag" name="modifyFlag" type="hidden" value="0"/>
                            <input type="hidden" name="folderId" id="folderId">
                            <c:if test="${attitudes != 3}">
						        <div id="processAttitude" style="display:none">
						        	<c:set var="enclude" value="${attitudes==2?'1':'' }"/>
							       	<c:set var="select" value="${attitudes==2?'2':'1' }"/>
							        <v3x:metadataItem metadata="${colMetadata['collaboration_attitude']}" showType="radio" name="attitude" selected="${draftOpinion == null ? select : summaryVO.infoOpinion.attribute}"  enclude="${enclude }"/>
							    </div>
							</c:if>
                            <%@ include  file="summary/deal.jsp" %>
                        </div>
                        <!--分隔线区域-->
                        <div class="hr_heng margin_t_5"></div>
                        </c:if>
                        <div>
                        	<table border="0" cellspacing="0" cellpadding="0" width="100%">
                        		<tr>
                        			<td colspan="2">
                        				<%--关联附件--%>
                        				<div id="attachmentTRshowAttFile" style="display: none;">
                                          <div style="float:left;" class="margin_l_10 margin_r_5 margin_t_5"><span style="color: #717171">${ctp:i18n('collaboration.summary.attachment')}: </span> (<span id="attachmentNumberDivshowAttFile"></span>) </div>
                                          <div id="attFileDomain" isGrid="true" class="comp" comp="type:'fileupload',attachmentTrId:'showAttFile',canFavourite:${canFavorite},applicationCategory:'32',canDeleteOriginalAtts:false" attsdata='${attListJSON }'> </div>
                                    	</div>
                        			</td>
                        		</tr>
                        		<tr>	
                        			<td colspan="2">
                        			<%--关联文档 --%>
                        				<div id="attachment2TRDoc1" style="display: none;">
                                            <div style="float:left;" class="margin_l_10 margin_r_5 margin_t_5"><span style="color: #717171">${ctp:i18n('collaboration.sender.postscript.correlationDocument')}: </span> (<span id="attachment2NumberDivDoc1"></span>)</div>
                                            <div style="float: right;" id="assDocDomain" isCrid="true" class="comp" comp="type:'assdoc',attachmentTrId:'Doc1',applicationCategory:'32',referenceId:'${summaryVO.summary.id}',modids:1,canDeleteOriginalAtts:false" attsdata='${attListJSON }'></div>
                                        </div>
                                        <div id="attActionLogDomain" style="display: none;"></div>
                        			</td>
                        		</tr>
                        	</table>
                        </div>
                        <!--视图切换区域-->
                        <div class="common_tabs clearfix margin_t_5  margin_l_10">
                            <ul class="left">
                                <!-- 文单 -->
                                <li id="form_view_li" class="current"><a onclick="showFormView()" class="border_b">${ctp:i18n('infosend.label.wendan')}<!-- 文单 --></a></li>
                                <!-- 正文 -->
                                <li id="content_view_li"><a onclick="showContentView('${summaryVO.summary.bodyType}','${summaryVO.affairId}','32','')" class="border_b">${ctp:i18n('collaboration.summary.text')}</a></li>
                                <!-- 流程 -->
                                <li id="workflow_view_li"><a onclick="refreshWorkflow()" class="last_tab border_b" >${ctp:i18n('collaboration.workflow.label')}</a></li>
                            </ul>
                            <!--命令按钮区域-->
                        <div class="orderBt right margin_r_10 margin_t_5 align_center">
                             <c:set value="1" var="countBtn" />
                             <!-- 跟踪 -->
                             <!-- 
                                <c:if test="${ctp:containInCollection(totalActionList, 'Track')}">
                                <c:set value="${countBtn+1}" var="countBtn" />
                                <span class="hand left" id="gzbutton"><span class="ico16 track_16 margin_lr_5" title="${ctp:i18n('collaboration.forward.page.label4')}"></span>${ctp:i18n('collaboration.forward.page.label4')}</span>
                                </c:if> -->
                             <!-- 属性状态 -->                                      
                             <c:set value="${countBtn+1}" var="countBtn" />
                                <span class="hand left" id="attributeSetting"><span class="ico16 attribute_16 margin_lr_5 display_none" title="${ctp:i18n('collaboration.common.flag.findAttributeSetting')}"></span>${ctp:i18n('collaboration.common.flag.attributeSetting')}</span>
                             <!-- 明细日志 -->                                 
                             <c:set value="${countBtn+1}" var="countBtn" />
                                 <span class="hand left" id="showDetailLog"><span class="ico16 view_log_16 margin_lr_5" title="${ctp:i18n('collaboration.sendGrid.findAllLog')}"></span>${ctp:i18n('collaboration.common.flag.showDetailLog')}</span>
                             
                             <!-- 打印 -->
                             <!-- 已上报信息的打印不受权限控制，要显示打印 -->
                             <c:if test="${ctp:containInCollection(totalActionList, 'Print') or summaryVO.openFrom == 'Send'}">
                             <c:set value="${countBtn+1}" var="countBtn" />
                             <span class="hand left" id="print"><span class="ico16 print_16 margin_lr_5" title="${ctp:i18n('collaboration.newcoll.print')}"></span>${ctp:i18n('collaboration.newcoll.print')}</span>
                             </c:if>
                             <c:choose>
                                  <c:when test="${param.openFrom eq 'listSent'}">
                                      <%--如果是已发，则显示督办设置 --%>
                                      <c:set value="${countBtn+1}" var="countBtn" />
                                      <c:if test="${countBtn<=5}">
                                          <span class="hand left" id="showSuperviseSettingWindow"><span class="ico16 setting_16 margin_lr_5" title="${ctp:i18n('collaboration.common.flag.showSuperviseSetting')}"></span>${ctp:i18n('collaboration.common.flag.showSuperviseSetting')}</span>
                                      </c:if>
                                      <c:if test="${countBtn>5}">
                                          <input id="showSuperviseSettingWindowFlag" type="hidden"/>    
                                      </c:if>
                                  </c:when>
                                  <c:when test="${(param.openFrom eq 'listDone' and summaryVO.isCurrentUserSupervisor) or param.openFrom eq 'supervise'}">
                                      <c:set value="${countBtn+1}" var="countBtn" />
                                          <c:if test="${countBtn<=5}">
                                              <!-- 督办 -->
                                              <span class="hand left"  id="showSuperviseWindow"><span class="ico16 meeting_look_1 margin_lr_5" title="${ctp:i18n('collaboration.common.flag.showSupervise')}"></span>${ctp:i18n('collaboration.common.flag.showSupervise')}</span>
                                          </c:if>
                                          <c:if test="${countBtn>5}">
                                             <input id="showSuperviseWindowFlag" type="hidden"/>    
                                          </c:if>
                                  </c:when>
                              </c:choose>
                             <!-- <c:if test="${countBtn>5}">
                                <span id="caozuo_more" class="ico16 arrow_2_b left margin_l_5"></span>
                             </c:if> -->
                        </div>
                        <div style="clear: both;"></div>
                        </div>
                        <div class="padding_l_10 padding_t_5 hidden" id="show_edit_workFlow">
                            <%-- 修改流程 --%>
                            <a id="edit_workFlow" class="common_button common_button_gray" >${ctp:i18n('collaboration.summary.updateFlow')}</a>
                        </div>
                   </div>
                    <div id="content_workFlow" class="stadic_layout_body stadic_body_top_bottom processing_view align_center border_t" style="width: 100%;top:30;visibility: visible;">
                        <iframe  frameborder="0" style="display:none;position:absolute;top:0px;right:20px;width:650px;z-index:200;height: 180px" id="attachmentList" class="over_auto align_right" src="" >
                        </iframe>
                        <c:set var="securityCheckParam" value="&docResId=${param.docResId}&docId=${param.docId}&baseObjectId=${param.baseObjectId}&baseApp=${param.baseApp}&fromEditor=${param.fromEditor}&eventId=${param.eventId}&relativeProcessId=${param.relativeProcessId}&processId=${param.processId}"/> 
                        <iframe id="iframeright" class="hidden bg_color_white" src="about:blank"  width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
                        
                        <%-- Office多浏览器兼容原因对Iframe进行设置 --%>
                        <c:choose>
                            <c:when test="${summaryVO.summary.bodyType == '10'}">
                               <c:set var="_contentDivStyle" value="width:100%;height:100%;display:none;"/>
                            </c:when>
                            <c:otherwise>
                               <c:set var="_contentDivStyle" value="width:0px;height:0px;"/>
                            </c:otherwise>
                        </c:choose>
                        
                        <iframe style="${_contentDivStyle}overflow:hidden; position: absolute;" id="contentDiv" class="bg_color_white" frameborder="0" src="${path}/info/infoDetail.do?method=contentPage&affairId=${summaryVO.affairId}&id=${summaryVO.summary.id }&appType=32&rightId="></iframe>
                        
                        <div id="componentDiv" name="componentDiv" style="display: inline;">
                        	<%-- 文单区域 --%>
							<%@ include  file="/WEB-INF/jsp/apps/gov/govform/form_show.jsp" %>
							<%@ include  file="/WEB-INF/jsp/apps/info/summary/opinion.jsp" %>
							
							<jsp:include page="/WEB-INF/jsp/common/content/workflow.jsp"/>
							<div style="width:0px;height:0px;overflow:hidden; position: absolute;">
                       	 		<jsp:include page="/WEB-INF/jsp/common/content/content.jsp" />
                        	</div>
                        </div>
                        
                    </div>
                    <%-- TODO:跟踪相关html --%>
            </div>  
        </div>
       
    </div>
</body>
</html>

