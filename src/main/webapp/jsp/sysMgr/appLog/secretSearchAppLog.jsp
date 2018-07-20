<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@include file="head.jsp" %>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>    
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<body style="overflow: hidden;">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
		<table border="0" cellSpacing="0" cellPadding="0" width="100%" class="main-bg border-top">
			<tr>
				<td class="border-padding">
					<c:choose>
						<c:when test="${param.dept == 'dept'}">
							<span class="searchSectionTitle"><fmt:message key="common.department.applog.label" bundle="${v3xCommonI18N}" /></span>
						</c:when>
						<c:otherwise>
							<span class="searchSectionTitle"><fmt:message key="common.system.applog.label" bundle="${v3xCommonI18N}" /></span>
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
		</table>
    
    </div>
    <div class="center_div_row2" id="scrollListDiv">
	    <c:if test="${not empty isShowIndexSummary&&isShowIndexSummary=='false'}">
		 	<c:set value="true" var="isIndexSummary"/>
		</c:if> 
		<form action="" >
		<v3x:table data="appLogsList" var="bean" htmlId="listTable" showHeader="true" showPager="true" className="sort ellipsis" dragable="true" formMethod="post">
		    <%-- --因为目前不是所有日志操作类型都加了针对政务版的信息，这里只能加判断了  --%>
		    <c:choose>
		        <c:when test="${bean.appLog.actionId == 861||bean.appLog.actionId == 862||bean.appLog.actionId == 871||bean.appLog.actionId == 872||bean.appLog.actionId == 873}">
		            <c:set value='${v3x:suffix()}' var="actionType"></c:set>     
		        </c:when>
		        <c:otherwise>
		            <c:set value='' var="actionType"></c:set>       
		        </c:otherwise>
		    </c:choose>   
		    <v3x:column width="15%" type="String" value="${bean.user}"
				align="left" label="log.toolbar.title.stuff" className=" sort" >
			</v3x:column>
			
			<v3x:column width="14%" type="String" align="left" value="${bean.actionType}"
				label="log.toolbar.title.optionActon" className=" sort" >	
			</v3x:column>	
			
			<v3x:column width="25%" align="left" type="String" value="${bean.actionDesc}" alt="${bean.actionDesc }"
				label="log.toolbar.title.optionActionDesc" className=" sort" >
			</v3x:column>
			
			<v3x:column width="10%" type="String" align="left"
				label="log.toolbar.title.operationTime" className=" sort" >
			<fmt:formatDate value="${bean.actionTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd HH:mm"/>
			</v3x:column>
			
			<v3x:column width="10%" align="left" value="${bean.ipAddress }"
				label="logon.search.ip"   />	
			
			<v3x:column width="15%" type="String" align="left" value="${bean.account}"
				label="log.toolbar.title.account" className=" sort" >
			</v3x:column>
			
			<v3x:column width="10%" type="String" align="left" value="${bean.modelName}"
				label="log.toolbar.title.category" className=" sort" >
			</v3x:column>
			
		</v3x:table>
		</form>
    </div>
  </div>
</div>
<div id="temp-div" name="temp-div" style="display:none">
<iframe name="temp-iframe" id="temp-iframe">&nbsp;</iframe>
</div>
<script type="text/javascript">
if(${v3x:currentUser().auditAdmin}){
showCtpLocation('F13_appLog');
}
if(${v3x:currentUser().groupAdmin}){
	showCtpLocation('F13_groupLog');
}
showDetailPageBaseInfo("detailFrame", "<fmt:message key='menu.log' bundle='${v3xMainI18N}'/>", [3,2], pageQueryMap.get('count'), _("LogLang.detail_info_2401"));	
</script>
</body>
</html>