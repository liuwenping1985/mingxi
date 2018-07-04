<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="../../common/INC/noCache.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="Collaborationheader.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"> 
</head>
<body onkeydown="listenerKeyESC()" scroll="no">
<form>
	<div id="print" style="overflow:auto;height: 100%;">
		<v3x:table data="${dataList}" var="model" htmlId="ww" className="sort ellipsis" isChangeTRColor="true" showHeader="true" showPager="true" dragable="true">
			<c:choose>
				<c:when test="${fromOperation eq 'workflowManager'}" >
					<v3x:column width="13%" type="String" label="common.workflow.handler"  value="${model.handler}" alt="${model.handler}" />
					<v3x:column width="10%" type="String" label="common.workflow.policy"  value="${model.policyName}" alt="${model.policyName}" />
					
                    <fmt:formatDate var="createDate" value="${model.createDate}" type="Date" dateStyle="full" pattern="${datePattern}" />
                    <v3x:column width="15%" type="String" label="common.workflow.create.date" alt="${createDate}" >
						${createDate}
					</v3x:column>
					
                    <c:choose>
                            <c:when test="${model.finishDate eq null}">
                                   <c:set var="finishDate" value="-"/>
                            </c:when>
                            <c:otherwise>
                                <fmt:formatDate var="finishDate" value="${model.finishDate}" type="Date" dateStyle="full" pattern="${datePattern}"/>
                            </c:otherwise>
                    </c:choose>
                    <v3x:column alt="${finishDate}" width="15%" align="${model.finishDate eq null?'center':'left'}" label="common.workflow.finish.date"  >
						${finishDate}
					</v3x:column>
					<v3x:column width="15%" align="left" type="String" label="common.workflow.dealTime.date" 
					alt="${model.runWorkTime eq '0'? '－':v3x:showDateByWork(model.runWorkTime)}"  value="${model.runWorkTime eq '0'? '－':v3x:showDateByWork(model.runWorkTime)}" />
					<v3x:column width="15%" align="center" type="String" label="common.workflow.deadline.date" 
					alt="${model.deadline eq '0'? '－':model.deadline}"  value="${model.deadline eq '0'? '－':model.deadline}" />
					<v3x:column width="15%" align="center" type="String" label="common.workflow.deadlineTime.date" 
					alt="${model.deadlineTime eq '0'? '－':model.deadlineTime}"  value="${model.deadlineTime eq '0'? '－':model.deadlineTime}" />
				</c:when>
				<c:otherwise>
					<v3x:column width="12%" type="String" label="common.workflow.handler" className="sort deadline-${model.timeOutFlag}"  
					 value="${model.handler}" />
					<v3x:column width="12%" type="String" label="common.workflow.policy" className="sort deadline-${model.timeOutFlag}" 
					 value="${model.policyName}" />
					<v3x:column width="12%" type="String" label="common.deal.state" className="sort deadline-${model.timeOutFlag}" 
					alt="${model.stateLabel}" value="${model.stateLabel}" />
					
                    <fmt:formatDate var="createDate" value="${model.createDate}" type="Date" dateStyle="full" pattern="${datePattern}" />
                    <v3x:column width="14%" type="String" label="common.workflow.create.date" className="sort deadline-${model.timeOutFlag}" 
					  alt="${createDate}">
						${createDate}
					</v3x:column>
                    
                    <c:choose>
                            <c:when test="${model.finishDate eq null}">
                                <c:set var="finishDate" value="-"/>
                            </c:when>
                            <c:otherwise>
                                <fmt:formatDate var="finishDate" value="${model.finishDate}" type="Date" dateStyle="full" pattern="${datePattern}" />
                            </c:otherwise>
                    </c:choose>
					<v3x:column width="14%" alt="${finishDate}" type="String" align="${model.finishDate eq null?'center':'left'}" label="common.workflow.finish.date" className="sort deadline-${model.timeOutFlag}"  >
						${finishDate}
					</v3x:column>
					
					<v3x:column width="14%" align="center" type="String" label="common.workflow.dealTime.date" 
							className="sort deadline-${model.timeOutFlag}" alt="${v3x:showDateByWork(model.runWorkTime)}" 
							value="${v3x:showDateByWork(model.runWorkTime)}"/>
					
					<v3x:column width="10%" align="center" type="String" label="common.workflow.deadline.date" className="sort deadline-${model.timeOutFlag}"
					alt="${model.deadline eq '0'? '－':model.deadline}"  value="${model.deadline eq '0'? '－':model.deadline}" />
					
				
					
					<v3x:column width="10%" align="center" type="String" label="common.timeouts.label" className="sort deadline-${model.timeOutFlag}" 
								value="${v3x:showDateByWork(model.overWorkTime)}" alt="${v3x:showDateByWork(model.overWorkTime)}"/>
				</c:otherwise>
			</c:choose>
		</v3x:table>
	</div>
</form>
</body>
</html>