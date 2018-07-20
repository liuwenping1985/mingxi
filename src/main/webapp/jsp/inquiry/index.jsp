<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp" %>
<html>
<head>
<link rel="STYLESHEET" type="text/css" href="<c:url value="/apps_res/inquiry/css/inquiry.css${v3x:resSuffix()}" />">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script language="javascript">
function inquiryDetail(id,surveytypeid){
	var acturl = "${basicURL}?method=showInquiryFrame&bid=" + id + "&surveytypeid=" + surveytypeid+"&group=${group}";
	//var acturl = "${basicURL}?method=pigeonhole_detail&bid=" + id+ "&surveytypeid=" + surveytypeid;
	<c:if test="${checkerbutton=='inquiry_checker'}">
		acturl = acturl + "&cid=cid";
	</c:if>
	//弹出调查页面
	openWin(acturl);
}
function inquiryDetailMore(){
	var acturl = "${basicURL}?method=more_recent_or_check&group=${group}";
	<c:if test="${checkerbutton=='inquiry_checker'}">
		acturl = acturl + "&cid=cid&group=${group}";
	</c:if>
     document.location.href = acturl;
}
function inquiryCategoryList(id,tname){
     var requestCaller = new XMLHttpRequestCaller(this, "ajaxInquiryManager", "getInquirytypeById", false);
	 requestCaller.addParameter(1, "Long", id);
	 var ds = requestCaller.serviceRequest();
	 if(ds=='false'){
	 	alert("此调查板块已被管理员删除!");
	 	window.location.reload(true);
	 	return;
	 }
	 var acturl="${basicURL}?method=survey_index&surveytypeid=" + id+"&group=${group}";
	 document.location.href = acturl;
}

window.onload = function(){
	showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
}
<c:choose>
	<c:when test="${group=='group'}">
		getA8Top().contentFrame.leftFrame.showSpaceMenuLocation(23);
	</c:when>
	<c:otherwise>
		getA8Top().showLocation(702);
	</c:otherwise>
</c:choose>
</script>
</head>
<body class="padding5" style="overflow: auto;">
<c:set var="current_user_id" value="${sessionScope['com.seeyon.current_user'].id}"></c:set>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
   <tr>
      <td valign="bottom" height="28" class="tab-tag">
		<div class="div-float">
			<div id="Tag0_left" class="tab-tag-left-sel"></div>
			<div id="Tag0_middle" class="tab-tag-middel-sel" onclick="cursorTag(0)"><fmt:message key='inquiry.new.inquiry.label'/></div>			
			<div id="Tag0_right" class="tab-tag-right-sel"></div>
			
			<div class="tab-separator"></div>
			<div id="Tag1_left" class="tab-tag-left"></div>
			<div id="Tag1_middle" class="tab-tag-middel" onclick="cursorTag(1)"><fmt:message key='inquiry.block.inquiry.label'/></div>
			<div id="Tag1_right" class="tab-tag-right"></div>
		</div>
		</td>
	</tr>
	<tr id="content0">
	    <td valign="top" class="tab-body-bg" height="100%" style="padding: 0px;">
	    <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="webfx-menu-bar-gray" height="25" width="100%">
			    <form action="${basicURL}" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
				<input type="hidden" value="<c:out value='${param.method}' />" name="method">
				<input type="hidden" value="${group}" name="group">
				<div class="div-float-right">
					<div class="div-float">
					<select name="condition" id="condition"  onChange="showNextCondition(this)" class="condition">
						<option value="subject"><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}"/></option>
						<option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}"/></option>
						<option value="createDate"><fmt:message key="common.issueDate.label" bundle="${v3xCommonI18N}"/></option>
					</select></div>
						
					<div id="subjectDiv" class="div-float"><input type="text" name="textfield" class="textfield"></div>
					<div id="createDateDiv" class="div-float hidden">
						<input type="text" name="textfield" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,640,265);" readonly> - 
						<input type="text" name="textfield1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,640,265);" readonly>
					</div>
					<div onclick="javascript:doSearch()" class="condition-search-button , button-font-color"></div>
				</div>
				</form>
	    		</td>
			</tr>
			<tr>
				<td height="100%" valign="top">
				<div class="scrollList">
					<form action="" name="articleForm" id="articleForm" method="post" onsubmit="return false" style="margin: 0px">
			    	<v3x:table data="${alist}" var="con">
		               <c:set var="onclick" value="inquiryDetail('${con.inquirySurveybasic.id}','${con.inquirySurveybasic.inquirySurveytype.id}')" />
		               <v3x:column type="String" label="common.subject.label" value=" ${con.inquirySurveybasic.surveyName}" width="18%"
		                  onClick="${onclick}" className="cursor-hand sort" symbol="..." maxLength="20" alt="${con.inquirySurveybasic.surveyName}"></v3x:column>
		               <v3x:column type="String"  label="inquiry.category.label" value="${con.inquirySurveybasic.inquirySurveytype.typeName}" className="sort" width="15%" maxLength="20" alt="${con.inquirySurveybasic.inquirySurveytype.typeName}" symbol="...">
		               </v3x:column>
		              	<v3x:column type="String"  label="common.issueScope.label" className="sort" width="20%"  alt="${v3x:showOrgEntities(con.inquirySurveybasic.inquiryScopes, 'scopeId', 'scopeDesc' , pageContext)}"  symbol="..." maxLength="25" value="${v3x:showOrgEntities(con.inquirySurveybasic.inquiryScopes, 'scopeId', 'scopeDesc' , pageContext)}"></v3x:column>
		               <v3x:column type="String"  label="common.issuer.label" alt="${v3x:showOrgEntitiesOfIds(con.inquirySurveybasic.createrId, 'Member', pageContext)}" value="${v3x:showOrgEntitiesOfIds(con.inquirySurveybasic.createrId, 'Member', pageContext)}" className="sort" width="7%"></v3x:column>
		               <v3x:column type="Date" label="common.issueDate.label" className="sort" width="15%" align="left"><fmt:formatDate value="${con.inquirySurveybasic.sendDate}" pattern="${ datetimePattern }"/></v3x:column>    
		              	 <c:choose>
					           <c:when test="${con.inquirySurveybasic.closeDate eq null}">
					            <v3x:column type="String"  label="inquiry.close.time.label"  className="sort" width="17%" align="left"><fmt:message key="inquiry.no.limit" /></v3x:column>		      
					           </c:when>
							   <c:otherwise>
							    <v3x:column type="Date" label="inquiry.close.time.label"  className="sort" width="15%" align="left"><fmt:formatDate value="${con.inquirySurveybasic.closeDate}" pattern="${ datetimePattern }"/></v3x:column>       
							   </c:otherwise>
		                 </c:choose>
		              </v3x:table>
		           </form>
		       </div>
			 </td>
			 </tr>
		 </table>
    	</td>
	</tr>
	<tr id="content1" style="display:none;">
		<td valign="top" class="tab-body-bg" height="100%" style="padding: 0px;">
			<div class="scrollList">
				<v3x:table data="${tlist}" var="tcon" htmlId="" isChangeTRColor="true"	showHeader="true" showPager="false" >
					<c:set var="onclick" value="inquiryCategoryList('${tcon.inquirySurveytype.id}','${tcon.inquirySurveytype.typeName}')" />					
					<v3x:column width="50%" label="inquiry.categoryName.label" alt="${tcon.inquirySurveytype.typeName}" onClick="${onclick}">
					    <div class="cursor-hand" title="${tcon.inquirySurveytype.typeName}${tcon.inquirySurveytype.surveyDesc!=null? ':&#13;':''}${tcon.inquirySurveytype.surveyDesc}">
							<span class="text-blue"><b>${v3x:getLimitLengthString(tcon.inquirySurveytype.typeName,24,"...")}</b></span>&nbsp;&nbsp;
							<span>${v3x:getLimitLengthString(tcon.inquirySurveytype.surveyDesc, 60, '...')}</span>
						</div>
					</v3x:column>					
					<%-- 
					<v3x:column label="inquiry.categoryDesc.label" onClick="${onclick}"  value="${tcon.inquirySurveytype.surveyDesc}"  className="cursor-hand sort" width="29%" maxLength="24" alt="${tcon.inquirySurveytype.surveyDesc}" symbol="...">
					</v3x:column>
					--%>
					<v3x:column width="10%" label="inquiry.total.label"  type="Number" value="${tcon.count}" className="sort" align="center">
					</v3x:column>
					<v3x:column label="inquiry.manager.label" width="20%" value="${v3x:join(tcon.managers, 'name',pageContext)}" className="sort" alt="${v3x:join(tcon.managers, 'name',pageContext)}"  maxLength="34" symbol="...">
				   </v3x:column>
				   <v3x:column  type="String" width="10%" label="inquiry.audit.whether" onClick="${onclick}" className="cursor-hand sort">
							<c:choose>
								<c:when test="${tcon.inquirySurveytype.censorDesc==0}">
									<fmt:message key="common.true"  bundle="${v3xCommonI18N}" />
								</c:when>
								<c:otherwise>
									<fmt:message key="common.false" bundle="${v3xCommonI18N}" />
								</c:otherwise>
							</c:choose>
					</v3x:column>
					
					<v3x:column  type="String" width="10%" label="inquiry.auditor.label" onClick="${onclick}" className="cursor-hand sort"  value="${v3x:showOrgEntitiesOfIds(tcon.checker.id, 'Member', pageContext)}" maxLength="42" alt="${v3x:showOrgEntitiesOfIds(tcon.checker.id, 'Member', pageContext)}">
						
					</v3x:column>
			    </v3x:table>
			</div>
		</td>
	</tr>
	</table>
</body>
</html>
