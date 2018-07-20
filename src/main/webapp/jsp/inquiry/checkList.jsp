<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="mainResource"/>
<html>
<head>
<script type="text/javascript">
	<c:if test="${group!=null&&group!=''}">
		getA8Top().contentFrame.leftFrame.showSpaceMenuLocation(27); 
	</c:if>
	
	<c:if test="${group==null}">
		getA8Top().showLocation(null, getA8Top().findMenuName(7), getA8Top().findMenuItemName(705),"<fmt:message key='publicManager.select.menu.inquiry'  bundle='${mainResource}'/>" );
	</c:if>

</script>
<link rel="STYLESHEET" type="text/css" href="<c:url value="/apps_res/inquiry/css/inquiry.css${v3x:resSuffix()}" />">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<script type="text/javascript">
    function inquiryCheck(id,tid){
    	var requestCaller = new XMLHttpRequestCaller(this, "ajaxInquiryManager", "hasInquiryExist", false);
		requestCaller.addParameter(1, "Long", id);
		var ds = requestCaller.serviceRequest();
		if(ds=='false'){
			alert("该调查已被管理员删除!");
			window.location.reload(true);
			return;
		}
    	var acturl = "${basicURL}?method=survey_check&bid="+id+"&tid="+tid+"&group=${group}&from=list";
	    //弹出调查页面
		openWin(acturl);
	    //document.location.href = "${basicURL}?method=survey_check&bid="+id+"&tid="+tid+"&group=${group}";
    }
 // getA8Top().showLocation(705);
</script>
<body class="tab-body" scroll = 'auto' style="padding:5px;">

<table width="100%" height="100%" border="0" cellspacing="0"
	cellpadding="0">
	<tr>
		<td valign="bottom" height="26" class="tab-tag">
		<div class="div-float">
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"><a href="${basicURL}?method=getAuthoritiesTypeList&group=${group}" class="non-a"><fmt:message key="inquiry.manage.inquiry.label"></fmt:message></a></div>
		<div class="tab-tag-right"></div>

		<div class="tab-separator"></div>

		<div class="tab-tag-left-sel"></div>
		<div class="tab-tag-middel-sel"> <a href="${basicURL}?method=getAllCheck&group=${group}" class="non-a"><fmt:message key="inquiry.auditor.manage.label"></fmt:message></a></div>
		<div class="tab-tag-right-sel"></div>
		</div>
		</td>
	</tr>
	<tr>
		<td class="tab-body-border" valign="top">
				<form action="" name="mainForm" id="" mainForm"" method="get">
				  <v3x:table data="${blist}" var="con" htmlId=""
					  isChangeTRColor="true" showHeader="true">
					<c:set var="onclick" value="inquiryCheck('${con.inquirySurveybasic.id}','${con.inquirySurveybasic.inquirySurveytype.id}')" />
					<v3x:column type="String" label="common.subject.label"
						value="${con.inquirySurveybasic.surveyName}" width="25%"
						onClick="${onclick}" className="cursor-hand sort" symbol="..."
						maxLength="32" alt="${con.inquirySurveybasic.surveyName}"></v3x:column>
				    <v3x:column type="String" label="common.issuer.label" value="${v3x:showOrgEntitiesOfIds(con.inquirySurveybasic.createrId, 'Member', pageContext)}" alt="${v3x:showOrgEntitiesOfIds(con.inquirySurveybasic.createrId, 'Member', pageContext)}"
							onClick="${onclick}" className="cursor-hand sort"></v3x:column>
					<v3x:column type="String" label="common.issueScope.label" onClick="${onclick}"
						className="cursor-hand sort"
						alt="${v3x:showOrgEntities(con.inquirySurveybasic.inquiryScopes, 'scopeId', 'scopeDesc' , pageContext)}" symbol="..."
						maxLength="32"
						value="${v3x:showOrgEntities(con.inquirySurveybasic.inquiryScopes, 'scopeId', 'scopeDesc' , pageContext)}">
					</v3x:column>
					<v3x:column type="Date" label="common.issueDate.label"
						onClick="${onclick}" className="cursor-hand sort" align="left">
						<fmt:formatDate value="${con.inquirySurveybasic.sendDate}"
							pattern="${ datetimePattern }" />
					</v3x:column>
					<c:choose>
					           <c:when test="${ con.inquirySurveybasic.closeDate eq null }">
					                 <v3x:column  label="inquiry.close.time.label" onClick="${onclick}" className="cursor-hand sort" width="20%" align="left"><fmt:message key="inquiry.no.limit" /></v3x:column>		      
					           </c:when>
							  <c:otherwise>
							         <v3x:column type="Date" label="inquiry.close.time.label" onClick="${onclick}" className="cursor-hand sort" width="20%" align="left"><fmt:formatDate value="${con.inquirySurveybasic.closeDate}" pattern="${ datetimePattern }"/></v3x:column>		      
							   </c:otherwise>	         
	              </c:choose>
				</v3x:table>
			 </form>
		</td>
	</tr>
</table>
</body>
</html>
