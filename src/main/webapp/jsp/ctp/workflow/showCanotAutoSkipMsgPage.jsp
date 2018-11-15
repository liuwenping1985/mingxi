<%--
/**
 * $Author: wangchw $
 * $Rev: 40258 $
 * $Date:: 2014-09-05 16:35:12#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
 --%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
</head>
<body>
<div class="form_area align_center">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
    <td id="policyDiv" colspan="2" valign="top" style="padding:0 10px;">
        <div id="policyHTML">
            <table class="only_table edit_table" width="100%" border="0" cellspacing="0" cellpadding="0">
            	<thead>
	            	<tr>
	            		<th nowrap="nowrap">${ctp:i18n("workflow.customFunction.list.1")}<!-- 序号 --></th>
	            		<th nowrap="nowrap">${ctp:i18n("workflow.designer.node.name.label")}<!-- 节点名称 --></th>
	            		<th nowrap="nowrap">${ctp:i18n("workflow.replaceNode.14")}<!-- 类型 --></th>
	            		<th nowrap="nowrap">${ctp:i18n("workflow.label.mode")}<!-- 模式 --></th>
	            		<th nowrap="nowrap">${ctp:i18n("workflow.label.result")}<!-- 结果 --></th>
	            		<th style="text-align:left;">${ctp:i18n("workflow.label.branch.calculateProcess")}<!-- 计算过程 --></th>
	            	</tr>
            	</thead>
            	<tbody>
            		<c:forEach items="${canotAutoSkipMsgList}" var="vo" varStatus="status">
	            		<tr class="padding_5">
		            		<td style="text-align:left;">${status.index+1}</td>
		            		<td style="text-align:left;">${vo.nodeName}</td>
		            		<td style="text-align:left;">${vo.nodeType}</td>
		            		<td style="text-align:left;">
		            			<c:forEach items="${vo.processMode}" var="processMode" varStatus="status">
		            				${processMode}
		            			</c:forEach>
		            		</td>
		            		<td style="text-align:left;">
		            			<c:if test='${vo.nodeId != null }'>
			            			<c:choose>
			            				<c:when test='${vo.matchState==0 }'>${ctp:i18n("workflow.label.msg.notNeedSelectStaff")}<!--  不需要选择人员 --></c:when>
			            				<c:when test='${vo.matchState==1 }'>${ctp:i18n("workflow.label.msg.needSelectStaff")}<!--  需要选择人员 --></c:when>
			            				<c:when test='${vo.matchState==2 }'>${ctp:i18n("processLog.action.desc.29_1") }<!--  不能超期自动跳过 --></c:when>
			            				<c:when test='${vo.matchState==3 }'>${ctp:i18n("workflow.processLog.detail.cannot.repeat.skip") }<!--  不能重复合并处理 --></c:when>
										<c:when test='${vo.matchState==4 }'>${ctp:i18n("workflow.label.msg.skip4Timeout") }<!--  超期已自动跳过 --></c:when>
			            			</c:choose>
		            			</c:if>
		            		</td>
		            		<td style="text-align:left;padding: 0px;height: 100%;width: 50%">
							<c:if test="${not empty  vo.workflowMatchMsgMap['step0'] || not empty  vo.workflowMatchMsgMap['step1'] 
							|| not empty  vo.workflowMatchMsgMap['step2'] || not empty  vo.workflowMatchMsgMap['step3'] 
							|| not empty  vo.workflowMatchMsgMap['step4']  || not empty  vo.workflowMatchMsgMap['step5'] 
							|| not empty  vo.workflowMatchMsgMap['step6']}">
		            			<table class="only_table edit_table" width="100%" border="0" cellspacing="0" cellpadding="0" 
		            			 style="table-layout:fixed;word-break:break-all;">
		            				<c:if test="${not empty  vo.workflowMatchMsgMap['step4']}">
		            					<c:forEach items="${vo.workflowMatchMsgMap['step4']}" var="nodeMsg" varStatus="step4status">
			            					<tr>
			            						<c:if test='${step4status.index==0}'>
			            							<td style="width: 80px;" rowspan="${fn:length(vo.workflowMatchMsgMap['step4'])}" >${ctp:i18n("workflow.label.manualBranchSelect") }<!--  手动分支选择 --></td>
			            						</c:if>
			            						<td>${nodeMsg }</td>
			            					</tr>
		            					</c:forEach>
		            				</c:if>
		            				<c:if test="${not empty  vo.workflowMatchMsgMap['step3']}">
		            					<c:forEach items="${vo.workflowMatchMsgMap['step3']}" var="nodeMsg" varStatus="step3status">
			            					<tr>
			            						<c:if test='${step3status.index==0}'>
			            							<td style="width: 80px;"  rowspan="${fn:length(vo.workflowMatchMsgMap['step3'])}" >${ctp:i18n("workflow.label.branch.branchConditionMatch") }<!--  分支条件匹配 --></td>
			            						</c:if>
			            						<td>${nodeMsg }</td>
			            					</tr>
		            					</c:forEach>
		            				</c:if>
		            				<c:if test="${not empty  vo.workflowMatchMsgMap['step0']}">
		            					<c:forEach items="${vo.workflowMatchMsgMap['step0']}" var="nodeMsg" varStatus="step0status">
			            					<tr>
			            						<c:if test='${step0status.index==0}'>
			            							<td  style="width: 80px;" rowspan="${fn:length(vo.workflowMatchMsgMap['step0'])}" >${ctp:i18n("workflow.moreSign.findPerson") }<!--  人员匹配 --></td>
			            						</c:if>
			            						<td>${nodeMsg }</td>
			            					</tr>
		            					</c:forEach>
		            				</c:if>
		            				<c:if test="${not empty  vo.workflowMatchMsgMap['step1']}">
		            					<c:forEach items="${vo.workflowMatchMsgMap['step1']}" var="nodeMsg" varStatus="step1status">
			            					<tr>
			            						<c:if test='${step1status.index==0}'>
			            							<td  style="width: 80px;" rowspan="${fn:length(vo.workflowMatchMsgMap['step1'])}" >${ctp:i18n("workflow.label.branch.skip4NoMatch") }<!--  无人自动跳过校验 --></td>
			            						</c:if>
			            						<td>${nodeMsg }</td>
			            					</tr>
		            					</c:forEach>
		            				</c:if>
		            				<c:if test="${not empty  vo.workflowMatchMsgMap['step2']}">
		            					<c:forEach items="${vo.workflowMatchMsgMap['step2']}" var="nodeMsg" varStatus="step2status">
			            					<tr>
			            						<c:if test='${step2status.index==0}'>
			            							<td  style="width: 80px;" rowspan="${fn:length(vo.workflowMatchMsgMap['step2'])}" >${ctp:i18n("workflow.label.branch.selectStaffRet") }<!--  人员选择结果 --></td>
			            						</c:if>
			            						<td>${nodeMsg }</td>
			            					</tr>
		            					</c:forEach>
		            				</c:if>
		            				<c:if test="${not empty  vo.workflowMatchMsgMap['step5']}">
		            					<c:forEach items="${vo.workflowMatchMsgMap['step5']}" var="nodeMsg" varStatus="step5status">
			            					<tr>
			            						<c:if test='${step5status.index==0}'>
			            							<td  style="width: 80px;" rowspan="${fn:length(vo.workflowMatchMsgMap['step5'])}" >${ctp:i18n("workflow.label.timeoutSkipCheck") }<!--  超期自动跳过校验 --></td>
			            						</c:if>
			            						<td>${nodeMsg }</td>
			            					</tr>
		            					</c:forEach>
		            				</c:if>
		            				<c:if test="${not empty  vo.workflowMatchMsgMap['step6']}">
		            					<c:forEach items="${vo.workflowMatchMsgMap['step6']}" var="nodeMsg" varStatus="step6status">
			            					<tr>
			            						<c:if test='${step6status.index==0}'>
			            							<td  style="width: 80px;" rowspan="${fn:length(vo.workflowMatchMsgMap['step6'])}" >${ctp:i18n("workflow.label.repeatDealCheck") }<!--  重复合并处理校验 --></td>
			            						</c:if>
			            						<td>${nodeMsg }</td>
			            					</tr>
		            					</c:forEach>
		            				</c:if>
		            			</table>
						    </c:if>
		            		</td>
	            		</tr>
            		</c:forEach>
            	</tbody>
        	</table>
      </div>
     </td>
    </tr>
</table>
</div>
</body>
</html>