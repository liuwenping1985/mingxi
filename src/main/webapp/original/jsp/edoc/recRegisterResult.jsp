<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<%@ include file="edocHeader.jsp" %>
<title><fmt:message key='edoc.Receipt.register.results'/></title>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
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
</style>
<script>
function showEdocDetail(summaryId,affairId,state){
  var fromValue="Done";
  if(state=='2'){
	  fromValue="sended";
  }
  var url = "from="+fromValue+"&summaryId="+summaryId+"&affairId="+affairId+"&openEdocByForward=true&openFrom=recRegisterResult";
  url = genericURL + "?method=detailIFrame&" + url;
  v3x.openWindow({
      url: url,
      workSpace: 'yes',
      dialogType: "open"
  });;  
} 

</script>
</head>
<body scroll="no"  onload="setMenuState('menu_pending');">
<div class="main_div_row2">
  <div class="right_div_row2">
<input type="hidden" name="colId" id="colId" value="${colId }">
<div class="scrollList" style="<c:if test="${empty colId }">width:100%; </c:if>overflow:hidden;">
	<c:set var="index" value="0"/>
	<form name="listForm" id="listForm" method="get" onsubmit="return false" style="margin: 0px">
	<v3x:table htmlId="pending" data="result" var="col" className="sort ellipsis">                			
		<c:set value="${v3x:escapeJavascript(col.summary.subject)}" var="subject"  />
		<c:set var="click" value="showEdocDetail('${col.summary.id}','${col.affairId }','${col.state}')"/>
		<c:set var="isRead" value="${col.state != 0}"/>
		
		
		<c:choose>
		<c:when test="${ fn:length(queryColList) > 10}">
			<c:set var="width" value="${(100 + 8 * (fn:length(queryColList)-10) )/fn:length(queryColList)}"/>
		</c:when>
		<c:otherwise>
			<c:set var="width" value="${100/fn:length(queryColList)}"/>
		</c:otherwise>
		</c:choose>
		
		
		
		<c:if test="${queryState == 1}">
		<c:forEach items="${queryColList }" var="qc" varStatus="status">
		
		
		 <c:choose>		 
		  <c:when test="${qc.label == 'edoc.element.secretlevel.simple'}">
		  	<v3x:column width="${width }%" type="String" label="${qc.label }" className="cursor-hand sort nowrap" 
				symbol="..."  onClick="${click}">
				<span title="<v3x:metadataItemLabel metadata="${colMetadata.edoc_secret_level}" value="${qc.values[index]}"/>">
				<v3x:metadataItemLabel metadata="${colMetadata.edoc_secret_level}" value="${qc.values[index] }"/>
				</span>
			</v3x:column>
		  </c:when>
		  <c:when test="${qc.label == 'edoc.element.urgentlevel'}">
		  	<v3x:column width="${width }%" type="String" label="${qc.label }" className="cursor-hand sort nowrap" 
				symbol="..."  onClick="${click}">
				<span title="<v3x:metadataItemLabel metadata="${colMetadata.edoc_urgent_level}" value="${qc.values[index]}"/>">
				<v3x:metadataItemLabel metadata="${colMetadata.edoc_urgent_level}" value="${qc.values[index] }"/>
				</span>
			</v3x:column>
		  </c:when>
		  <c:when test="${qc.label == 'edoc.element.communication.date'}">
		  	<v3x:column width="${width }%" type="String" label="${qc.label }" className="cursor-hand sort nowrap" 
				symbol="..."  onClick="${click}">
				<span title="<fmt:formatDate value="${qc.values[index] }"  pattern="${datePattern}"/>">
				<fmt:formatDate value="${qc.values[index] }"  pattern="${datePattern}"/>
				</span>
			</v3x:column>
		  </c:when>
		  
          <c:when test="${qc.label == 'edoc.element.keepperiod'}">
            <v3x:column width="${width }%" type="String" label="${qc.label }" className="cursor-hand sort nowrap" onClick="${click}">
                <div id="keepPeriod" show="divType">
                    <v3x:metadataItemLabel metadata="${edocKeepPeriodData}" value="${qc.values[index] }"/>
                </div>
            </v3x:column>
          </c:when>
          
          <c:when test="${qc.label == 'edoc.element.receive.send_unit_type'}">
            <v3x:column width="${width }%" type="String" label="${qc.label}" className="cursor-hand sort nowrap" onClick="${click}">
                <div id="send_unit_type" show="divType">
                    <v3x:metadataItemLabel metadata="${docTypeData}" value="${qc.values[index]}"/>
                </div>
            </v3x:column>
          </c:when>
          
		  
  		  <c:otherwise>
		  	<v3x:column width="${width }%" type="String" label="${qc.label }" className="cursor-hand sort nowrap"
				value="${qc.values[index] }"  symbol="..."  onClick="${click}" alt="${qc.values[index] }" />
		  </c:otherwise>	
		  </c:choose>
		
		</c:forEach>
		<c:set var="index" value="${index+1 }"/>
		</c:if>
		 
		<c:if test="${queryState == 0}">
			<v3x:column width="15%" maxLength="36"  symbol="..." type="String" label="edoc.element.subject" className="cursor-hand sort nowrap" 
			bodyType="${col.bodyType}" value="${col.summary.subject}"  onClick="${click}" hasAttachments="${col.summary.hasAttachments}" alt="${col.summary.subject}"/>
			<v3x:column width="10%"  maxLength="20" type="String" label="edoc.element.communication.date" className="cursor-hand sort nowrap" 
			  onClick="${click}">
			 <span title="<fmt:formatDate value="${col.recieveDate}"  pattern="${datePattern}"/>">
				<fmt:formatDate value="${col.recieveDate}"  pattern="${datePattern}"/>
			 </span>
			</v3x:column>
			<v3x:column width="10%"  maxLength="20" type="String" label="edoc.edoctitle.fromUnit.label" className="cursor-hand sort nowrap" 
			value="${col.summary.sendUnit}"  onClick="${click}" alt="${col.summary.sendUnit}"/>	
			<v3x:column width="10%"  maxLength="20" type="String" label="edoc.element.docmark" className="cursor-hand sort nowrap" 
			value="${col.summary.docMark}"  onClick="${click}" alt="${col.summary.docMark}"/>
			<v3x:column width="10%" type="String" label="edoc.element.receive.serial_no" className="cursor-hand sort nowrap" 
			value="${col.summary.serialNo}" onClick="${click}"  symbol="..." alt="${col.summary.serialNo}"/>

			<%--
			<v3x:column width="10%" type="String" label="edoc.rec.undertaker.dep" className="cursor-hand sort nowrap" 
			value="${col.summary.undertakerDep}" onClick="${click}"  symbol="..." alt="${col.summary.undertakerDep}"/>
			--%>
			<v3x:column width="10%" type="String" label="edoc.element.undertaker" className="cursor-hand sort nowrap" 
			value="${col.summary.undertaker}" onClick="${click}"  symbol="..." alt="${col.summary.undertaker}"/>
			
			<v3x:column width="6%" type="String" onClick="${click}" label="edoc.edoctitle.regDate.label" className="cursor-hand sort nowrap" 
			value="${col.registerDate}" alt="${col.registerDate}"/>
			
            <c:if test="${isG6 == 'true' }">
			<v3x:column width="6%" type="String" onClick="${click}" label="edoc.element.receive.distributer" className="cursor-hand sort nowrap" 
			value="${col.distributer}" alt="${col.distributer}"/>
			</c:if>	
			
			<%-- 
			<v3x:column width="7%" type="Number" align="right" label="edoc.element.copies" className="cursor-hand sort nowrap" 
			value="${col.summary.copies}">					
			</v3x:column>		
			 --%>
			 																			
		</c:if>
	</v3x:table>
	</form>  
</div></div></div>
<script type="text/javascript">
showDetailPageBaseInfo("detailFrame", "<fmt:message key='edoc.workitem.state.pending' />", [1,2], pageQueryMap.get('count'), _("edocLang.detail_info_2013"));
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
</script>
</body>
</html>