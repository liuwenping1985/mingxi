<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>发文登记簿查询结果</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="edocHeader.jsp" %>
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
function showEdocDetail(affairId,edocType,edocId,state){
  //OA-33399 应用检查：本单位下外部门人员封发完成的数据，发文登记簿时查询出来了，单击穿透查看，已办结的公文还有督办设置功能，自己本单位本部门已办结的公文没有督办设置功能
  //改为已办的链接
  var fromValue="Done";
  if(state=='2'){
	  fromValue="sended";
  }
  var url = "from="+fromValue+"&affairId="+affairId+"&edocType="+edocType+"&edocId="+edocId+"&openEdocByForward=true&openFrom=sendRegisterResult";//从登记簿查询结果中穿透查看公文页面，不进行安全性检查，虽然是转发文的参数，为了不再增加多余的参数，就传这个了
  url = genericURL + "?method=detailIFrame&" + url;
  v3x.openWindow({
    url: url,
    FullScrean: 'yes',
    dialogType: 'open'
  });  
}
</script>
</head>
<body scroll="no" onload="setMenuState('menu_pending');">
	<c:set var="index" value="0"/>
	<form name="listForm" id="listForm" method="get" onsubmit="return false" style="margin: 0px;height:100%;">
	<v3x:table htmlId="pending" data="result" var="col" className="sort ellipsis">                			
		<c:set value="${v3x:escapeJavascript(col.summary.subject)}" var="subject"  />
		<c:set var="isRead" value="${col.state != 0}"/>
		<c:set var="width" value="${100/fn:length(queryColList)+1}"/>
		<c:set var="click" value="showEdocDetail('${col.affairId}','${col.summary.edocType}','${col.summary.id}','${col.state}')"/>
            
		
		<c:if test="${queryState == 1}">
		<c:forEach items="${queryColList }" var="qc" varStatus="status">
		
		
		 <c:choose>		 
		  <c:when test="${qc.label == 'edoc.element.secretlevel.simple'}">
		  	<v3x:column width="${width }%" type="String" label="${qc.label }" className="cursor-hand sort nowrap" 
				symbol="..." onClick="${click}">
				<v3x:metadataItemLabel metadata="${colMetadata.edoc_secret_level}" value="${qc.values[index] }"/>
			</v3x:column>
		  </c:when>
		  <c:when test="${qc.label == 'edoc.element.urgentlevel'}">
		  	<v3x:column width="${width }%" type="String" label="${qc.label }" className="cursor-hand sort nowrap" 
				symbol="..." onClick="${click}">
				<v3x:metadataItemLabel metadata="${colMetadata.edoc_urgent_level}" value="${qc.values[index] }"/>
			</v3x:column>
		  </c:when>
          <c:when test="${qc.label == 'edoc.edoctitle.createDate.label'}">
            <v3x:column width="${width }%" type="String" label="${qc.label }" className="cursor-hand sort nowrap" 
                onClick="${click}">
                <fmt:formatDate value="${qc.values[index] }"  pattern="yyyy-MM-dd"/>
            </v3x:column>
          </c:when>
          <c:when test="${qc.label == 'edoc.element.keepperiod'}">
            <v3x:column width="${width }%" type="String" label="${qc.label }" className="cursor-hand sort nowrap">
                <div id="keepPeriod" show="divType">
                    <v3x:metadataItemLabel metadata="${edocKeepPeriodData}" value="${qc.values[index] }"/>
                </div>
            </v3x:column>
          </c:when>
  		  <c:otherwise>
		  	<v3x:column width="${width }%" type="String" label="${qc.label }" className="cursor-hand sort nowrap" 
				value="${qc.values[index] }"  symbol="..." onClick="${click}" alt="${qc.values[index]}"/>
		  </c:otherwise>	
		  </c:choose>
		
		</c:forEach>
		<c:set var="index" value="${index+1 }"/>
		</c:if>
		 
		<c:if test="${queryState == 0}">
                
            
			<v3x:column width="14%" maxLength="36"  symbol="..." type="String" label="edoc.element.subject" className="cursor-hand sort nowrap" 
			bodyType="${col.bodyType}" value="${col.summary.subject}" hasAttachments="${col.summary.hasAttachments}" onClick="${click}" />
			
			<v3x:column width="13%"  maxLength="20" type="String" label="edoc.element.senddepartment" className="cursor-hand sort nowrap" 
            value="${col.departmentName}" onClick="${click}"/>  
            
			<v3x:column width="13%"  maxLength="20" type="String" label="edoc.edoctitle.createDate.label" className="cursor-hand sort nowrap" 
             onClick="${click}">   
                <fmt:formatDate value="${col.summary.createTime}"  pattern="yyyy-MM-dd"/>
            </v3x:column>
            
			<v3x:column width="12%" type="String" label="edoc.element.wordno.label" className="cursor-hand sort nowrap" 
			value="${col.summary.docMark}"  symbol="..." onClick="${click}"/>
            
            <v3x:column width="12%" type="String" label="edoc.docmark.inner.title" className="cursor-hand sort nowrap" 
            value="${col.summary.serialNo}"  symbol="..." onClick="${click}"/>
            
			<v3x:column width="13%"  maxLength="20" type="String" label="edoc.element.issuer" className="cursor-hand sort nowrap" 
            value="${col.summary.issuer}" onClick="${click}"/> 
            
			<v3x:column width="13%" type="Date" label="edoc.element.sendingdate" className="cursor-hand sort nowrap" onClick="${click}">
				<fmt:formatDate value="${col.summary.signingDate}"  pattern="yyyy-MM-dd" />
			</v3x:column>
			
			<v3x:column width="10%" type="String" label="edoc.edoctitle.createPerson.label" value="${col.summary.createPerson}"
			className="cursor-hand sort nowrap" onClick="${click}"/>
			
			<v3x:column width="10%" type="String" label="edoc.element.review" value="${col.summary.review}"
			className="cursor-hand sort nowrap" onClick="${click}"/>
		
            <%--OA-30287 test01在发文登记簿中查询，查询结果显示了分发人 --%>
            <c:choose>
            <c:when test="${isG6Ver==true}">
                <v3x:column width="13%"  maxLength="20" type="String" label="edoc.element.receive.distributer" className="cursor-hand sort nowrap" 
                value="${col.sender}" onClick="${click}"/>  
            </c:when>
            <c:otherwise>
                <v3x:column width="13%"  maxLength="20" type="String" label="exchange.edoc.sendpeople" className="cursor-hand sort nowrap" 
                value="${col.sender}" onClick="${click}"/>  
            </c:otherwise>
            </c:choose>
										
		</c:if>
	</v3x:table>
	</form>  
<script type="text/javascript">
showDetailPageBaseInfo("detailFrame", "<fmt:message key='edoc.workitem.state.pending' />", [1,2], pageQueryMap.get('count'), _("edocLang.detail_info_2013"));
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
</script>

</body>
</html>