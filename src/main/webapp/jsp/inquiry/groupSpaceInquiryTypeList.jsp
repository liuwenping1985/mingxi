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

getA8Top().contentFrame.leftFrame.showSpaceMenuLocation(23); 

function inquiryCategoryList(id,tname){
	 var acturl="${basicURL}?method=survey_index&surveytypeid="+id+"&group=${group}";
	 document.location.href = acturl;
}
</script>
</head>
<body style="padding:5px;">
    <form action="" name="mainForm" id=""mainForm"" method="post">
       <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
			  	<td valign="bottom" height="26" class="tab-tag">
			  		<div class="div-float">
					<div class="tab-tag-left-sel"></div>
					<div class="tab-tag-middel-sel"><fmt:message key='inquiry.block.inquiry.label'/></div>
					<div class="tab-tag-right-sel"></div>
				</div>
			  	</td>
			</tr>		         
	        <tr>
	            <td class="tab-body-border">
	              <div class="scrollList">
							<v3x:table	data="${inquiryTypeList}" var="tcon" htmlId="" isChangeTRColor="false"	showHeader="true" showPager="false" >
								<c:set var="onclick" value="inquiryCategoryList('${tcon.inquirySurveytype.id}','${tcon.inquirySurveytype.typeName}')" />
								<v3x:column label="inquiry.categoryName.label"  onClick="${onclick}"  className="cursor-hand type-name"  width="20%"  alt="${tcon.inquirySurveytype.typeName}" 
								onmouseover="titlemouseover(this);" onmouseout="titlemouseout(this);">
								  <img  src='<c:url value="/apps_res/inquiry/images/tname.gif"/>' align="absmiddle"> ${v3x:getLimitLengthString(tcon.inquirySurveytype.typeName,20,"...")}
								</v3x:column>
								<v3x:column label="inquiry.categoryDesc.label"  value="${tcon.inquirySurveytype.surveyDesc}"  className="sort" width="30%" maxLength="24" alt="${tcon.inquirySurveytype.surveyDesc}" symbol="...">
								</v3x:column>
								<v3x:column label="inquiry.total.label"  type="Number" value="${tcon.count}" className="sort" width="10%" align="center">
								</v3x:column>
								<v3x:column label="inquiry.manager.label" value="${v3x:join(tcon.managers, 'name',pageContext)}" className="sort" width="20%" alt="${v3x:join(tcon.managers, 'name',pageContext)}"  maxLength="34" symbol="...">
							   </v3x:column>
							   <v3x:column  type="String" width="10%" label="inquiry.audit.whether" className="sort">
										<c:choose>
											<c:when test="${tcon.inquirySurveytype.censorDesc==0}">
												<fmt:message key="common.true"  bundle="${v3xCommonI18N}" />
											</c:when>
											<c:otherwise>
												<fmt:message key="common.false" bundle="${v3xCommonI18N}" />
											</c:otherwise>
										</c:choose>
								</v3x:column>
								
								<v3x:column  type="String" width="10%" label="inquiry.auditor.label"  className="sort"  value="${v3x:showOrgEntitiesOfIds(tcon.checker.id, 'Member', pageContext)}" maxLength="42" alt="${v3x:showOrgEntitiesOfIds(tcon.checker.id, 'Member', pageContext)}">
									
								</v3x:column>
						    </v3x:table>
				      </div>
		         </td>
		   </tr>
	</table>
</form>
</body>
</html>
