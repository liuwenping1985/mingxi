<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.exchange.resources.i18n.ExchangeResource" var="exchangeI18N"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="edocHeader.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/edocBar.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/batch.js${v3x:resSuffix()}" />"></script>
<style type="text/css">
html,body{height:100%;width: 100%;border: 0;padding: 0;margin: 0}
</style>
<script type="text/javascript">

var jsEdocType=${edocType};
var edocType = ${edocType};
var openFrom = "${ctp:escapeJavascript(param.openFrom)}";
var isEdocCreateRole = ${isEdocCreateRole};
var hasRegistButton = ${hasRegistButton};
var isExchangeRole = ${isExchangeRole};
var defaultURL = "${ctp:escapeJavascript(param.listType)}";
if(defaultURL==""){defaultURL="listPending";}
var list = "${ctp:escapeJavascript(param.list)}";
function indexLoad() {
	if(window.dialogArguments) {
		document.getElementById("tabTr").style.display = "none";
	} else {
	}
}
</script>

</head>
<body scroll="no" class="padding5" onload="indexLoad()">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	   <tr id="tabTr">
	      <td valign="bottom" height="30" class="tab-tag">
				<div class="div-float">
					<div class="tab-separator"></div>
					<c:choose>
						
						<%-----------------*** 收文 ***-----------------%>
						<c:when test="${edocType==1}">
							
							<%-- 收文签收 isExchangeRole --%>
						    <%--
						    <c:set var="isCurrentFrom" value="${param.listType=='listRecieve'||param.listType=='listRecieveRetreat' }" />
							<c:set var="listType" value="toReceive" />
						    <c:set var="listMethod" value="${param.listMethod==null||param.listMethod==''||param.listMethod=='null'?'toReceive':param.listMethod}" />
							<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}" />
							<span class="resCode" resCode="F07_toReceive" resCodeParent="F07_recManager" current="${isCurrentFrom ? 'true':'false'}">
								<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
								<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
									<fmt:message key='exchange.edoc.qianshou' bundle='${exchangeI18N}' />
								</div>
								<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
								<div class="tab-separator"></div>
							</span>
                            --%>
                            
							<%-- 收文登记 isEdocCreateRegister --%>
							<%--
							<c:set var="isCurrentFrom" value="${param.listType=='listRegister'||param.listType=='newEdocRegister' }" />
							<c:set var="listType" value="listRegister" />
							<c:set var="listMethod" value="${param.listMethod==null||param.listMethod==''||param.listMethod=='null'?'listRegister':param.listMethod}" />
							<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}&exchangeId=${param.exchangeId}&edocId=${param.edocId}" />
							<span class="resCode" resCode="F07_recDengji" resCodeParent="F07_recManager" current="${isCurrentFrom ? 'true':'false'}">
								<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
								<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
									<fmt:message key='edoc.new.type.rec'/>
								</div>					
								<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
								<div class="tab-separator"></div>
							</span>
							--%>

							<%-- 收文分发 isEdocDistribute --%>
							<%--
							<c:set var="isCurrentFrom" value="${param.listType=='listDistribute' || param.listType=='newEdoc' }" />
							<c:set var="listType" value="listDistribute" />
							<c:set var="listMethod" value="${param.listType=='newEdoc' ? param.listType : 'listDistribute'}" />
							<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}" />
							<span class="resCode" resCode="F07_toFenfa" resCodeParent="F07_recManager" current="${isCurrentFrom ? 'true':'false'}">
								<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
								<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
									 <fmt:message key='edoc.element.receive.distribute' />
								</div>
								<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>	
								<div class="tab-separator"></div>
							</span>
							 --%>
							
							<%-- V5收文待登记 --%>
							<c:if test="${!isG6Ver}">
							<c:set var="isCurrentFrom" value="${param.listType=='listV5Register' || param.listType=='newEdoc' }" />
							<c:set var="listType" value="listV5Register" />
							<c:set var="listMethod" value="${param.listType=='newEdoc' ? param.listType : 'listV5Register'}" />
							<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}" />
							<c:if test="${ctp:hasRoleName('RecEdoc') == true}">
								<span class="resCode" resCodeParent="F07_recManager" current="${isCurrentFrom ? 'true':'false'}">
									<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
		                            <div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
		                                <fmt:message key='edoc.workitem.state.register'/>
		                            </div>
		                            <div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
		                            <div class="tab-separator"></div>
	                            </span>
                            </c:if>
                            </c:if>
                            
                            <%--G6收文待登记 --%>
                            <c:if test="${isOpenRegister}">
                            <c:set var="isCurrentFrom" value="${param.recListType=='registerPending'}" />
							<c:set var="listType" value="listRegister" />
							<c:set var="listMethod" value="${param.listMethod==null||param.listMethod==''||param.listMethod=='null'?'listRegister':param.listMethod}" />
							<c:set var="listRenderURL" value="edocController.do?method=listIndex&edocType=1&listType=listRegister&recListType=registerPending" />
							<c:if test="${ctp:hasResourceCode('F07_recListRegistering') == true}">
								<span class="resCode" resCodeParent="F07_recManager" current="${isCurrentFrom ? 'true':'false'}">
									<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
									<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
										<fmt:message key='edoc.workitem.state.register'/>
									</div>					
									<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
									<div class="tab-separator"></div>
								</span>
							</c:if>
							</c:if>
                            
                            <%--G6收文登记待发 --%>
                            <c:if test="${isOpenRegister}">
                            <c:set var="isCurrentFrom" value="${param.recListType=='registerDraft'}" />
							<c:set var="listType" value="listRegister" />
							<c:set var="listMethod" value="${param.listMethod==null||param.listMethod==''||param.listMethod=='null'?'listRegister':param.listMethod}" />
							<c:set var="listRenderURL" value="edocController.do?method=listIndex&edocType=1&listType=listRegister&recListType=registerDraft" />
							<c:if test="${ctp:hasResourceCode('F07_recListWaitRegister') == true}">
								<span class="resCode" resCodeParent="F07_recManager" current="${isCurrentFrom ? 'true':'false'}">
									<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
									<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
										<fmt:message key='edoc.register.draft'/>
									</div>					
									<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
									<div class="tab-separator"></div>
								</span>
							</c:if>
                            </c:if>
                            
                            <%--G6收文已登记 --%>
                            <c:if test="${isOpenRegister}">
                            <c:set var="isCurrentFrom" value="${param.recListType=='registerDone' }" />
							<c:set var="listType" value="listRegister" />
							<c:set var="listMethod" value="${param.listMethod==null||param.listMethod==''||param.listMethod=='null'?'listRegister':param.listMethod}" />
							<c:set var="listRenderURL" value="edocController.do?method=listIndex&edocType=1&listType=listRegister&recListType=registerDone" />
							<c:if test="${ctp:hasResourceCode('F07_recListRegistered') == true}">
								<span class="resCode" resCodeParent="F07_recManager" current="${isCurrentFrom ? 'true':'false'}">
									<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
									<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
										<fmt:message key='exchange.edoc.registered' bundle='${exchangeI18N }'/>
									</div>					
									<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
									<div class="tab-separator"></div>
								</span>
							</c:if>
							</c:if>
                            
                            <%--G6收文待分发 --%>
                            <c:if test="${isG6Ver}">
                            <c:set var="isCurrentFrom" value="${param.listType=='listDistribute' ||param.recListType=='listDistribute' || param.listType=='newEdoc'}" />
							<c:set var="listType" value="listDistribute" />
							<c:set var="listMethod" value="${param.listType=='newEdoc' ? param.listType : 'listDistribute'}" />
							<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}&list=aistributining&btnType=2" />
							<c:if test="${ctp:hasResourceCode('F07_recListFenfaing') == true}">
								<span class="resCode" resCodeParent="F07_recManager" current="${isCurrentFrom ? 'true':'false'}">
									<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
									<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
										 <fmt:message key='edoc.receive.toAttribute'/>
									</div>
									<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>	
									<div class="tab-separator"></div>
								</span>
							</c:if>
							</c:if>
                            
                            <%--G6收文分发待发 --%>
                            <c:if test="${isG6Ver}">
                            <c:set var="isCurrentFrom" value="${param.listType=='listWaitSend' }" />
							<c:set var="listType" value="listWaitSend" />
							<c:set var="listMethod" value="listWaitSend" />
							<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}&list=draftBox&subState=2" />
							<c:if test="${ctp:hasResourceCode('F07_recListWaitFenfa') == true}">
								<span class="resCode" resCodeParent="F07_recManager" current="${isCurrentFrom ? 'true':'false'}">
									<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
									<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
										 <fmt:message key='edoc.fenfa.draft'/>
									</div>
									<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>	
									<div class="tab-separator"></div>
								</span>
							</c:if>
							</c:if>
                            
                            <%--G6收文已分发 --%>
                            <c:if test="${isG6Ver}">
                            <c:set var="isCurrentFrom" value="${param.listType=='listSent' }" />
							<c:set var="listType" value="listSent" />
							<c:set var="listMethod" value="listSent" />
							<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}" />
							<c:if test="${ctp:hasResourceCode('F07_recListFenfaed') == true}">
								<span class="resCode" resCodeParent="F07_recManager" current="${isCurrentFrom ? 'true':'false'}">
									<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
									<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
										 <fmt:message key='edoc.receive.attributed'/>
									</div>
									<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>	
									<div class="tab-separator"></div>
								</span>
							</c:if>
                            </c:if>
                            
                            
                            <%-- V5收文待发 --%>
                            <c:if test="${!isG6Ver}">
	                            <c:set var="isCurrentFrom" value="${param.listType=='listWaitSend' }" />
	                            <c:set var="listType" value="listWaitSend" />
								<c:set var="listMethod" value="listWaitSend" />
								<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}" />		
	                            <c:if test="${ctp:hasResourceCode('F07_recManager') == true}">
		                            <span class="resCode" resCodeParent="F07_recManager" current="${isCurrentFrom ? 'true':'false'}">
		                            	<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
										<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
											<fmt:message key='common.toolbar.state.darft.label' bundle='${v3xCommonI18N}'/>
										</div>
										<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
										<div class="tab-separator"></div>
									</span>
								</c:if>
							</c:if>
							
							<%-- v5收文已发--%>
							<c:if test="${!isG6Ver}">
							<c:set var="isCurrentFrom" value="${param.listType=='listSent' }" />
							<c:set var="listType" value="listSent" />
							<c:set var="listMethod" value="listSent" />
							<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}" />
							<c:if test="${ctp:hasResourceCode('F07_recManager') == true}">
								<span class="resCode"  resCodeParent="F07_recManager" current="${isCurrentFrom ? 'true':'false'}">
				     				<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
									<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
										<fmt:message key='common.toolbar.state.sended.label' bundle='${v3xCommonI18N}'/>
									</div>
									<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
									<div class="tab-separator"></div>
								</span>
							</c:if>
							</c:if>
							
							<%-- 收文待办 --%>
							<c:set var="isCurrentFrom" value="${param.listType=='listPending'||param.listType=='listPendingAll' }" />
							<c:set var="listType" value="listPending" />
							<c:set var="listMethod" value="listPending" />
							<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}" />
							<span class="resCode"  resCodeParent="F07_recManager" current="${isCurrentFrom ? 'true':'false'}">
			     				<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
								<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
									<fmt:message key='common.toolbar.state.pending.label' bundle='${v3xCommonI18N}'/>
								</div>
								<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
								<div class="tab-separator"></div>
							</span>
							
							<%-- 收文在办 --%>
							<c:if test="${!hasEdocLeft}">
								<c:set var="isCurrentFrom" value="${param.listType=='listZcdb' }" />
								<c:set var="listType" value="listZcdb" />
								<c:set var="listMethod" value="listZcdb" />
								<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}" />
								<span class="resCode"  resCodeParent="F07_recManager" current="${isCurrentFrom ? 'true':'false'}">
			     					<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
									<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
										<fmt:message key='edoc.receive.appending'/>
									</div>
									<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
									<div class="tab-separator"></div>
								</span>
							</c:if>
							
							<%-- 收文已办 --%>
							<c:set var="isCurrentFrom" value="${param.listType=='listDone'||param.listType=='listDoneAll' }" />
							<c:set var="listType" value="listDoneAll" />
							<c:set var="listMethod" value="listDone" />
							<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}" />
							<span class="resCode"  resCodeParent="F07_recManager" current="${isCurrentFrom ? 'true':'false'}">
								<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
								<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
									<fmt:message key='common.toolbar.state.done.label' bundle='${v3xCommonI18N}' />
								</div>
								<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
								<div class="tab-separator"></div>	
							</span>
							
							<%-- 收文待阅 --%>
							<c:if test="${showBanwenYuewen}">
								<c:set var="isCurrentFrom" value="${param.listType=='listReading' }" />
								<c:set var="listType" value="listReading" />
								<c:set var="listMethod" value="listReading" />
								<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}" />
	                            <span class="resCode" resCode="" resCodeParent="F07_recManager" current="${isCurrentFrom ? 'true':'false'}">
									<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
									<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
										<fmt:message key='edoc.element.receive.reading' />
									</div>
									<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
									<div class="tab-separator"></div>
	                            </span>
							</c:if>
                            
							<%-- 收文已阅 --%>
							<c:if test="${showBanwenYuewen}">
								<c:set var="isCurrentFrom" value="${param.listType=='listReaded' }" />
								<c:set var="listType" value="listReaded" />
								<c:set var="listMethod" value="listReaded" />
								<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}" />
	                            <span class="resCode" resCode="" resCodeParent="F07_recManager" current="${isCurrentFrom ? 'true':'false'}">
									<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
									<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
										<fmt:message key='edoc.element.receive.readed' />
									</div>
									<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
									<div class="tab-separator"></div>
							    </span>
							</c:if>
						    
						    <%-- 收文登记薄 
						    <c:set var="isCurrentFrom" value="${param.listType=='recRegister' }" />
							<c:set var="listType" value="recRegister" />
							<c:set var="listMethod" value="recRegister" />
							<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&recRegister=${recRegister}&listType=${listType}" />
                            <span class="resCode" resCode="F07_recDJSearch" resCodeParent="F07_recManager" current="${isCurrentFrom ? 'true':'false'}">
								<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
							    <div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">	
							     	<fmt:message key='edoc.rec.register' />
								</div>
								<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
								<div class="tab-separator"></div>
                             </span>--%>
						    
						</c:when>
						
						<%-----------------*** 签报 ***-----------------%>
						<c:when test="${edocType==2}">
							<!-- 多浏览器屏蔽 -->
					   		<%-- 签报拟文 --%>
							<c:set var="isCurrentFrom" value="${param.listType=='newEdoc' }" />
							<c:set var="listType" value="newEdoc" />
							<c:set var="listMethod" value="isEdocCreateRole?'newEdoc':'listSent'" />
							<c:set var="listRenderURL" value="edocController.do?method=listIndex&edocType=${edocType}&listType=${listType}" />                            
                            <c:if test="${ctp:hasRoleName('SignEdoc') == true}">
	                            <span class="resCode" resCodeParent="F07_signReport" current="${isCurrentFrom ? 'true':'false'}">
									<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
									<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
										<fmt:message key='edoc.new.type.send'/>
									</div>	
									<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>	
									<div class="tab-separator"></div>
								</span>
							</c:if>
							
							<%-- 签报待发 --%>
							<c:if test="${!hasEdocLeft}">
								<c:set var="isCurrentFrom" value="${param.listType=='listWaitSend' }" />
								<c:set var="listType" value="listWaitSend" />
								<c:set var="listMethod" value="listWaitSend" />
								<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}" />                            
								<span class="resCode" resCodeParent="F07_signReport" current="${isCurrentFrom ? 'true':'false'}">
									<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
									<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
										<fmt:message key='common.toolbar.state.darft.label' bundle='${v3xCommonI18N}' />
									</div>
									<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
									<div class="tab-separator"></div>
								</span>
							</c:if>
							
							<%-- 签报已发--%>
							<c:set var="isCurrentFrom" value="${param.listType=='listSent' }" />
							<c:set var="listType" value="listSent" />
							<c:set var="listMethod" value="listSent" />
							<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}" />                            
							<span class="resCode" resCodeParent="F07_signReport" current="${isCurrentFrom ? 'true':'false'}">
								<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
								<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
									<fmt:message key='common.toolbar.state.sended.label' bundle='${v3xCommonI18N}'/>
								</div>
								<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
								<div class="tab-separator"></div>
							</span>
							
							<%-- 签报待办 --%>
							<c:set var="isCurrentFrom" value="${param.listType=='listPending'||param.listType=='listPendingAll' }" />
							<c:set var="listType" value="listPending" />
							<c:set var="listMethod" value="listPending" />
							<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}" />                            
							<span class="resCode"  resCodeParent="F07_signReport" current="${isCurrentFrom ? 'true':'false'}">
								<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
								<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
									<fmt:message key='common.toolbar.state.pending.label' bundle='${v3xCommonI18N}'/>
								</div>
								<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
								<div class="tab-separator"></div>	
							</span>
							
							<%-- 签报在办 --%>
							<c:if test="${!hasEdocLeft}">
								<c:set var="isCurrentFrom" value="${param.listType=='listZcdb' }" />
								<c:set var="listType" value="listZcdb" />
								<c:set var="listMethod" value="listZcdb" />
								<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}" />                            
								<span class="resCode" resCodeParent="F07_signReport" current="${isCurrentFrom ? 'true':'false'}">
									<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
									<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
										<fmt:message key='edoc.receive.appending'/>
									</div>
									<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
									<div class="tab-separator"></div>
								</span>
							</c:if>
							
							<%-- 签报已办 --%>
							<c:set var="isCurrentFrom" value="${param.listType=='listDone'||param.listType=='listDoneAll' }" />
							<c:set var="listType" value="listDoneAll" />
							<c:set var="listMethod" value="listDone" />
							<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}" />                            
							<span class="resCode" resCodeParent="F07_signReport" current="${isCurrentFrom ? 'true':'false'}">
								<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
								<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
									<fmt:message key='common.toolbar.state.done.label' bundle='${v3xCommonI18N}' />
								</div>
								<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
								<div class="tab-separator"></div>
							</span>
						</c:when>
										
                    	<c:otherwise>
                    	<%-----------------*** 发文 ***-----------------%>
                    		<!-- 多浏览器屏蔽 -->
							<c:set var="isCurrentFrom" value="${param.listType=='newEdoc' }" />
							<c:set var="listType" value="newEdoc" />
							<c:set var="listMethod" value="newEdoc" />
							<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}" />             		
	                    	<%-- 发文拟文 resCode="F07_sendNewEdoc" // RBAC权限改造 --%>
	                    	<c:if test="${ctp:hasRoleName('SendEdoc') == true}">
		                        <span class="resCode" resCodeParent="F07_sendManager" current="${isCurrentFrom ? 'true':'false'}">
									<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
									<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
										<fmt:message key='edoc.new.type.send'/>
									</div>	
									<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
									<div class="tab-separator"></div>
								</span>
							</c:if>
						
							<%-- 发文待发 --%>
							<c:if test="${!hasEdocLeft}">
								<c:set var="isCurrentFrom" value="${param.listType=='listWaitSend' }" />
								<c:set var="listType" value="listWaitSend" />
								<c:set var="listMethod" value="listWaitSend" />
								<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}" />             		
								<span class="resCode" resCodeParent="F07_sendManager" current="${isCurrentFrom ? 'true':'false'}">
									<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
									<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
										<fmt:message key='common.toolbar.state.darft.label' bundle='${v3xCommonI18N}' />
									</div>
									<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
									<div class="tab-separator"></div>
								</span>
							</c:if>
							
							<%-- 发文已发--%>
							<c:set var="isCurrentFrom" value="${param.listType=='listSent' }" />
							<c:set var="listType" value="listSent" />
							<c:set var="listMethod" value="listSent" />
							<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}" />
							<span class="resCode" resCodeParent="F07_sendManager" current="${isCurrentFrom ? 'true':'false'}">
								<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
								<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
									<fmt:message key='common.toolbar.state.sended.label' bundle='${v3xCommonI18N}'/>
								</div>
								<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
								<div class="tab-separator"></div>
							</span>
							
							<%-- 发文待办 --%>
							<c:set var="isCurrentFrom" value="${param.listType=='listPending'||param.listType=='listPendingAll' }" />
							<c:set var="listType" value="listPending" />
							<c:set var="listMethod" value="listPending" />
							<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}" />
							<span class="resCode" resCodeParent="F07_sendManager" current="${isCurrentFrom ? 'true':'false'}">
								<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
								<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
									<fmt:message key='common.toolbar.state.pending.label' bundle='${v3xCommonI18N}'/>
								</div>
								<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
								<div class="tab-separator"></div>	
							</span>
							
							<%-- 发文在办 --%>
							<c:if test="${!hasEdocLeft}">
								<c:set var="isCurrentFrom" value="${param.listType=='listZcdb' }" />
								<c:set var="listType" value="listZcdb" />
								<c:set var="listMethod" value="listZcdb" />
								<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}" />
								<span class="resCode" resCodeParent="F07_sendManager" current="${isCurrentFrom ? 'true':'false'}">
									<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
									<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
										<fmt:message key='edoc.receive.appending'/>
									</div>
									<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
									<div class="tab-separator"></div>
								</span>
							</c:if>
							
							<%-- 发文已办 --%>
							<c:set var="isCurrentFrom" value="${param.listType=='listDone'||param.listType=='listFinish'||param.listType=='listDoneAll' }" />
							<c:set var="listType" value="listDoneAll" />
							<c:set var="listMethod" value="listDone" />
							<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}" />
							<span class="resCode"  resCodeParent="F07_sendManager" current="${isCurrentFrom ? 'true':'false'}">
								<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
								<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
									<fmt:message key='common.toolbar.state.done.label' bundle='${v3xCommonI18N}' />
								</div>
								<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
								<div class="tab-separator"></div>
							</span>
							
							<%-- 发文分发 --%>
							<c:if test="${hasEdocLeft}">
								<c:set var="isCurrentFrom" value="${param.listType=='listFenfa' }" />
								<c:set var="listType" value="listFenfa" />
								<c:set var="listMethod" value="listFenfa" />
								<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}" />
								<c:if test="${ctp:hasResourceCode('F07_listFenfa') == true}">
									<span class="resCode" resCodeParent="F07_sendManager" current="${isCurrentFrom ? 'true':'false'}">
										<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
										<div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">
											<fmt:message key='edoc.element.receive.distribute' />
										</div>
										<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
										<div class="tab-separator"></div>
									</span>
								</c:if>
							</c:if>
							
							<%-- 发文登记薄
							<c:set var="isCurrentFrom" value="${param.listType=='sendRegister' }" />
							<c:set var="listType" value="sendRegister" />
							<c:set var="listMethod" value="sendRegister" />
							<c:set var="listRenderURL" value="edocController.do?method=listIndex&from=${listMethod }&edocType=${edocType}&listType=${listType}" />
							<span class="resCode" resCode="F07_sendDJSearch" resCodeParent="F07_sendManager" current="${isCurrentFrom ? 'true':'false'}">
								<div class="${isCurrentFrom ? 'tab-tag-left-sel':'tab-tag-left'}"></div>
							    <div class="${isCurrentFrom ? 'tab-tag-middel-sel':'tab-tag-middel'} cursor-hand" onclick="javascript:location.href='<html:link renderURL='${listRenderURL }' />'">	
									<fmt:message key='edoc.send.register' />
								</div>
								<div class="${isCurrentFrom ? 'tab-tag-right-sel':'tab-tag-right'}"></div>
								<div class="tab-separator"></div>
                            </span>--%>
							
                   		</c:otherwise>
					</c:choose>
				</div>
				
				<!-- 权限控制 -->
				<%@ include file="/WEB-INF/jsp/migrate/checkResource.jsp" %>
				
				<!-- 当前位置 -->
				<%@ include file="currentLocation.jsp" %>
				
		  </td>
	  </tr>
	  
	  <tr>
	    <td valign="top" width="100%" height="100%" align="center" class="page-list-border-LRD border-top" style="padding-top:1px;">
		     <iframe style="display: block;border: 0" width="100%" height="100%" frameborder="0" marginheight="0" marginwidth="0" frameborder="0" src="edocController.do?method=edocFrame&from=${param.listType==null?'listPending':(param.listType)}&edocType=${edocType}&track=${ctp:toHTML(param.track)}&listType=${ctp:toHTML(param.listType)}&recListType=${ctp:toHTML(param.recListType)}&sendUnitId=${param.sendUnitId}&id=${param.id}&meetingSummaryId=${meetingSummaryId}&comm=${ctp:toHTML(param.comm)}&edocId=${ctp:toHTML(param.edocId)}&recieveId=${param.recieveId}&forwordType=${param.forwordType}&checkOption=${ctp:toHTML(param.checkOption)}&newContactReceive=${ctp:toHTML(param.newContactReceive)}&subType=${param.subType}&exchangeId=${param.exchangeId}&templeteId=${ctp:toHTML(param.templeteId)}&affairId=${ctp:toHTML(param.affairId)}&app=${param.app}&transmitSendNewEdocId=${ctp:toHTML(param.transmitSendNewEdocId)}&registerId=${param.registerId}&recAffairId=${ctp:toHTML(param.recAffairId)}&modelType=${param.modelType}&summaryId=${ctp:toHTML(param.summaryId)}&backBoxToEdit=${ctp:toHTML(param.backBoxToEdit)}&canOpenTemplete=${param.canOpenTemplete}&registerType=${registerType}&openFrom=${param.openFrom}" name="mainIframe" id="mainIframe"></iframe>
		</td>
	</tr>
</table>


</body>		
</html>