<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../common/INC/noCache.jsp" %>
<%@ include file="inquiryHeader.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<html>
<head>
<script type="text/javascript">
<!--
	window.onload = function(){
		showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	}
	function inquiryDetail(id,typeId){
		var acturl = "${basicURL}?method=showInquiryFrame&bid=" + id + "&surveytypeid=" + typeId+"&group=${group}&spaceId=${param.spaceId}";
		openWin(acturl);
	}
	//TODO wanguangdong 2012-10-30 getA8Top().hiddenNavigationFrameset();
//-->
</script>
<style>
.mxtgrid div.hDiv,.mxtgrid div.bDiv,.page2-list-border{border-width:1px 0;}
</style>
</head>
<body scroll="no" class="with-header">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">		
	<tr class="page2-header-line"  height="41">
		<td height="41">
			<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
				<tr class="page2-header-line" height="41">
					<td width="80" height="41" class="page2-header-img"><img align="absmiddle" src="<c:url value="/apps_res/bulletin/images/pic.gif"/>" /></td>
					<td class="page2-header-bg" width="500">${spaceName}<fmt:message key='application.10.label' bundle="${v3xCommonI18N}" /></td>
					<td class="page2-header-line padding-right" align="right"></td>
				</tr>	
			</table>
		</td>
	</tr>
	<tr>
		<td >
		<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0" class="page2-list-border">
			<tr>
				<td height="22" class="webfx-menu-bar page2-list-header">
					<b><fmt:message key='application.10.label' bundle="${v3xCommonI18N}" /><fmt:message key='inquiry.search.button.label' /></b>
	       		</td>
				<td class="webfx-menu-bar ">
					<form action="${basicURL}" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
						<input type="hidden" value="inquirySearch" name="method">
						<input type="hidden" value="${group}" name="group">
                        <input type="hidden" value="${param.spaceId}" name="spaceId" id="spaceId">
                        <input type="hidden" value="${param.spaceType}" name="spaceType" id="spaceType">
						<div class="div-float-right">
							<div class="div-float">
							<select name="condition" id="condition" onChange="showNextCondition(this)" class="condition">
								<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}"/></option>
								<option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}"/></option>
								<option value="creater"><fmt:message key="inquiry.creater.label"/></option>
								<option value="createDate"><fmt:message key="common.issueDate.label" bundle="${v3xCommonI18N}"/></option>
							</select></div>
							<div id="subjectDiv" class="div-float hidden"><input type="text"  maxlength="50" name="textfield" class="textfield" onkeydown="javascript:searchWithKey()"></div>
							<div id="createrDiv" class="div-float hidden"><input type="text"  maxlength="50" name="textfield" class="textfield" onkeydown="javascript:searchWithKey()"></div>
							<div id="createDateDiv" class="div-float hidden">
								<input type="text" id="startdate" name="textfield" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,640,265);" readonly onkeydown="javascript:searchWithKey()"> - 
								<input type="text" id="enddate" name="textfield1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,640,265);" readonly onkeydown="javascript:searchWithKey()">
							</div>
							<div onclick="doSearch()" class="div-float condition-search-button button-font-color"></div>
						</div>
					</form>
				</td>
			</tr>	
			</table> 
	</td>
            </tr>
        </table>     
    </div>
		 <div class="center_div_row2" id="scrollListDiv">
						<form>
							<v3x:table htmlId="leaveWord" data="${inquiryBasicList}" showPager="true" var="basic">
								<c:set value="inquiryDetail('${basic.inquirySurveybasic.id}','${basic.surveyTypeCompose.inquirySurveytype.id}')" var="clickEvent"/>
								<v3x:column width="45%" type="String" label="common.subject.label" className="cursor-hand sort" alt="${basic.inquirySurveybasic.surveyName}" onClick="${clickEvent}"
									onmouseover="titlemouseover(this);" onmouseout="titlemouseout(this);">
									${v3x:toHTML(v3x:getLimitLengthString(basic.inquirySurveybasic.surveyName,33,'...'))}
								</v3x:column>
								<v3x:column width="15%" type="String" align="left" label="inquiry.scope.label" value="${v3x:showOrgEntities(basic.inquirySurveybasic.inquiryScopes, 'scopeId', 'scopeDesc' , pageContext)}" 
									maxLength="20" symbol="...">
								</v3x:column>
								<v3x:column width="10%" type="String" label="inquiry.creater.label" value="${v3x:showOrgEntitiesOfIds(basic.inquirySurveybasic.createrId, 'Member', pageContext)}" />
								<v3x:column width="17%" type="Date" label="inquiry.date.create">
									<fmt:formatDate value="${basic.inquirySurveybasic.sendDate}" pattern="${datePattern}"/>
								</v3x:column>
								<c:choose>
								   <c:when test="${basic.inquirySurveybasic.closeDate eq null}">
								     <v3x:column type="String"  label="inquiry.close.time.label"  className="sort" width="13%" align="left"><fmt:message key="inquiry.no.limit" /></v3x:column>		      
								   </c:when>
									<c:otherwise>
								   		<v3x:column type="Date" label="inquiry.close.time.label"  className="sort" width="13%" align="left"><fmt:formatDate value="${basic.inquirySurveybasic.closeDate}" pattern="${ datePattern }"/></v3x:column>       
									</c:otherwise>
						        </c:choose>
							</v3x:table>
						</form>
					</div>
  </div>
</div>
</body>
</html>