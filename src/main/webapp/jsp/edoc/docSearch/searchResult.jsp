<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="../edocHeader.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/isearch/css/isearch.css${v3x:resSuffix()}" />">
<style>
SELECT{
	FONT-SIZE: 10pt; 
	FONT-FAMILY: Times New Roman;
	MARGIN-TOP:1px;
}
.nowrap{
	white-space: nowrap;
}
html,body{ height:100%; margin:0; padding:0;}
</style>
<script>
function showDetail2(u){
 
	var url = genericURL + "?method=detail&" + u;
	var retObj = v3x.openWindow({
     	url: url,
     	FullScrean: 'yes',
     	dialogType : "open"
	});
}


</script>

</head>

<body scroll="no" onLoad="setMenuState('menu_pending');"  style="height:100%;">
<input type="hidden" name="colId" id="colId" value="${colId }">

									<c:set var="index" value="0"/>
										<form name="listForm" id="listForm" method="get" onSubmit="return false" style="margin: 0px">
										<v3x:table htmlId="pending" data="result" var="col" className="sort ellipsis">   
											<c:set var="fromValue" value="${col.state==2 ?'sended':'Done'}"/>
											<c:set var="dblclick" value="openDetail('', 'from=${fromValue}&summaryId=${col.summary.id}&affairId=${col.affairId}')"/>
											<c:set var="click" value="${dblclick}"/>
										    <c:if test="${queryState == 0}">
											<c:set value="${v3x:escapeJavascript(col.summary.subject)}" var="subject"  />
											<c:set var="isRead" value="${col.state != 0}"/>
											<v3x:column width="6%" type="String" label="edoc.element.secretlevel.simple" className="cursor-hand sort nowrap" 
											 onDblClick="${dblclick}" onClick="${click}">
											<v3x:metadataItemLabel metadata="${colMetadata.edoc_secret_level}" value="${col.summary.secretLevel}"/>
											</v3x:column>
											<v3x:column width="23%" maxLength="500"  symbol="..." type="String" label="edoc.element.subject" className="cursor-hand sort nowrap  mxtgrid_black" 
											bodyType="${col.bodyType}" value="${col.summary.subject}" hasAttachments="${col.summary.hasAttachments}" onDblClick="${dblclick}" onClick="${click}"  flowState="${col.summary.state}"/>
											<v3x:column width="12%" type="String" label="edoc.element.wordno.label" className="cursor-hand sort nowrap" 
											value="${col.summary.docMark}"  symbol="..." onDblClick="${dblclick}" onClick="${click}" />
											
											<c:if test="${edocType==0}">
											<v3x:column width="14%"  maxLength="20" type="String" label="edoc.element.sendtounit" className="cursor-hand sort nowrap" 
											value="${col.sendToUnit}"  onDblClick="${dblclick}" onClick="${click}" />				
											<v3x:column width="8%" type="String" label="edoc.element.issuer" value="${col.summary.issuer}"
											className="cursor-hand sort nowrap" 
											onDblClick="${dblclick}" onClick="${click}" />
											<v3x:column width="13%" type="Date" label="edoc.element.sendingdate" className="cursor-hand sort nowrap" 
											onDblClick="${dblclick}" onClick="${click}">
												<fmt:formatDate value="${col.summary.signingDate}"  pattern="${datePattern}"/>
											</v3x:column>
                                            
											</c:if>
											
											<c:if test="${edocType==1}">
											<v3x:column width="15%"  maxLength="20" type="String" label="edoc.edoctitle.fromUnit.label" className="cursor-hand sort nowrap" 
											value="${col.summary.sendUnit}"  symbol="..." onDblClick="${dblclick}" onClick="${click}" />				
											<v3x:column width="10%" type="String" label="edoc.edoctitle.regPerson.label" value="${col.summary.createPerson}"
											className="cursor-hand sort" 
											onDblClick="${dblclick}" onClick="${click}" />
											<v3x:column width="10%" type="Date" label="edoc.edoctitle.regDate.label" className="cursor-hand sort nowrap" 
											onDblClick="${dblclick}" onClick="${click}">
												<fmt:formatDate value="${col.summary.createTime}"  pattern="${datePattern}"/>
											</v3x:column>
											</c:if>
											
											<c:if test="${edocType==2}">
											<v3x:column width="15%"  maxLength="20" type="String" label="edoc.element.sendtounit" className="cursor-hand sort" 
											value="${col.sendToUnit}"  onDblClick="${dblclick}" onClick="${click}"/>
											<%--  			
											<v3x:column width="10%" type="String" label="edoc.edoctitle.createPerson.label" value="${col.summary.createPerson}"
											className="cursor-hand sort nowrap" 
											onDblClick="${dblclick}" onClick="${click}" />
											--%>	
											<v3x:column width="10%" type="Date" label="edoc.edoctitle.createDate.label" className="cursor-hand sort nowrap" 
											onDblClick="${dblclick}" onClick="${click}">
												<fmt:formatDate value="${col.summary.createTime}"  pattern="${datePattern}"/>
											</v3x:column>
											</c:if>
											
                                            
                                            <v3x:column width="10%" type="String" label="edoc.edoctitle.createPerson.label" value="${col.summary.createPerson}"
                                                        className="cursor-hand sort nowrap" onClick="${click}"/>
                                            
                                            <v3x:column width="10%" type="String" label="edoc.element.doctype"
                                                        className="cursor-hand sort nowrap" onClick="${click}">
                                                <v3x:metadataItemLabel metadata="${colMetadata.edoc_doc_type}" value="${col.summary.docType }"/>
                                            </v3x:column>
                                            <v3x:column width="10%" type="String" label="edoc.element.sendtype"
                                                        className="cursor-hand sort nowrap" onClick="${click}">
                                                <v3x:metadataItemLabel metadata="${colMetadata.edoc_send_type}" value="${col.summary.sendType}"/>
                                            </v3x:column>
                                            <%-- 根据国家行政公文规范,去掉主题词
                                            <v3x:column width="10%" type="String" label="menu.edoc.keyword.label" value="${col.summary.keywords}"
                                                        className="cursor-hand sort nowrap" onClick="${click}"/> --%>
                                            <v3x:column width="10%" type="String" label="edoc.docmark.inner.title" value="${col.summary.serialNo}"
                                                        className="cursor-hand sort nowrap" onClick="${click}"/>
                                            <%-- 
                                            <v3x:column width="10%" type="String" label="edoc.supervise.serach.startdate"
                                                        className="cursor-hand sort nowrap" onClick="${click}">
                                                 <fmt:formatDate value="${col.summary.createTime}"  pattern="${datePattern}"/>       
                                            </v3x:column>
                                            --%>
                                            <v3x:column width="10%" type="String" label="edoc.element.sendunit" value="${col.summary.sendUnit}"
                                                        className="cursor-hand sort nowrap" onClick="${click}"/>
                                            
                                            
                                            
											<v3x:column width="7%" type="String" label="edoc.edoctitle.ispig.label" className="cursor-hand sort nowrap" 
											 onDblClick="${dblclick}" onClick="${click}">
												<c:if test="${col.summary.hasArchive}"><fmt:message key='common.true' bundle='${v3xCommonI18N}' /></c:if>
												<c:if test="${!col.summary.hasArchive}"><fmt:message key='common.false' bundle='${v3xCommonI18N}' /></c:if>
											</v3x:column>	
											<v3x:column width="10%" type="String" label="edoc.edoctitle.pigeonholePath.label" className="cursor-hand sort nowrap" 
											 onDblClick="${dblclick}" onClick="${click}">
												<span onMouseOver="showWholePath('${col.logicalPath}',this)">${col.archiveName}&nbsp;</span>
											</v3x:column>			
											<v3x:column width="7%" type="Number" align="right" label="edoc.element.copies" className="cursor-hand sort nowrap" 
											onDblClick="${dblclick}" onClick="${click}" value="${col.summary.copies}">					
											</v3x:column>
											</c:if>
											
											<c:if test="${queryState == 1}">
											<c:forEach items="${queryColList }" var="qc" varStatus="status">
											 <c:choose>		 
											  <c:when test="${qc.label == 'edoc.element.secretlevel.simple'}">
											  	<v3x:column width="12%" type="String" label="${qc.label }" className="cursor-hand sort nowrap" 
													symbol="..." >
													<v3x:metadataItemLabel metadata="${colMetadata.edoc_secret_level}" value="${qc.values[index] }"/>
												</v3x:column>
											  </c:when>
											  <c:when test="${qc.label == 'edoc.element.urgentlevel'}">
											  	<v3x:column width="12%" type="String" label="${qc.label }" className="cursor-hand sort nowrap" 
													symbol="..." >
													<v3x:metadataItemLabel metadata="${colMetadata.edoc_urgent_level}" value="${qc.values[index] }"/>
												</v3x:column>
											  </c:when>
											  <c:when test="${qc.label == 'edoc.element.doctype'}">
											  	<v3x:column width="12%" type="String" label="${qc.label }" className="cursor-hand sort nowrap" 
													symbol="..." >
													<v3x:metadataItemLabel metadata="${colMetadata.edoc_doc_type}" value="${qc.values[index] }"/>
												</v3x:column>
											  </c:when>
											   <c:when test="${qc.label == 'edoc.element.sendtype'}">
											  	<v3x:column width="12%" type="String" label="${qc.label }" className="cursor-hand sort nowrap" 
													symbol="..." >
													<v3x:metadataItemLabel metadata="${colMetadata.edoc_send_type}" value="${qc.values[index] }"/>
												</v3x:column>
											  </c:when>
											  <c:when test="${qc.label == 'edoc.edoctitle.regDate.label' || qc.label == 'edoc.edoctitle.createDate.label'}">
											  	<v3x:column width="12%" type="String" label="${qc.label }" className="cursor-hand sort nowrap" 
													  symbol="..."  onClick="${click}">
													  <fmt:formatDate value="${qc.values[index] }"  pattern="${datePattern}"/>
												</v3x:column>	  
											  </c:when>
											   <c:when test="${qc.key == 'subject'}">
												  <v3x:column width="23%" maxLength="36"  symbol="..." type="String" label="edoc.element.subject" className="cursor-hand sort nowrap  mxtgrid_black" 
												bodyType="${col.bodyType}" value="${col.summary.subject}" hasAttachments="${col.summary.hasAttachments}" onDblClick="${dblclick}" onClick="${click}"  flowState="${col.summary.state}"/>
									  		   </c:when>
									  		  <c:otherwise>
											  	<v3x:column width="12%" type="String" label="${qc.label }" className="cursor-hand sort nowrap" 
													value="${qc.values[index] }"  symbol="..."  onClick="${click}"/>
											  </c:otherwise>	
											  </c:choose>
											</c:forEach>
											<c:set var="index" value="${index+1 }"/>
											</c:if>
											
										</v3x:table>
										</form>  

<script type="text/javascript">
showDetailPageBaseInfo("detailFrame", "<fmt:message key='edoc.workitem.state.pending' />", [1,2], pageQueryMap.get('count'), _("edocLang.detail_info_2013"));
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
</script>
</body>
</html>