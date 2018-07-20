<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp" %>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="mainResource"/>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/inquiry/js/inquiry.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<link rel="STYLESHEET" type="text/css" href="<c:url value="/apps_res/inquiry/css/inquiry.css${v3x:resSuffix()}" />">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script language="javascript">
var theHtml;
if('18'=='${param.spaceType}'||'17'=='${param.spaceType}'){
	theHtml=toHtml('${spaceName}','<fmt:message key="inquiry.manage"/>');
}else if('3'=='${param.spaceType}'){
    theHtml=toHtml("${v3x:toHTML(spaceName)}",'<fmt:message key="menu.group.inquiry.manage" bundle="${v3xMainI18N}"/>');
}else if('2'=='${param.spaceType}'){
       theHtml=toHtml("${v3x:toHTML(spaceName)}",'<fmt:message key="menu.account.inquiry.manage" bundle="${v3xMainI18N}"/>');
}
showCtpLocation("",{html:theHtml});
</script>
<script language="javascript">
function inquiryCategoryList(typeId){
	//判断该板块是否存在   加防护
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxInquiryManager", "getInquirytypeById", false);
	requestCaller.addParameter(1, "Long", typeId);
	var ds = requestCaller.serviceRequest();
	if(ds=='false'){
		alert("该调查板块已被管理员删除!");
		window.location.reload(true);
		return;
	}

	document.location.href = "${basicURL}?method=survey_index&surveytypeid=" + typeId +"&mid=mid&group=${group}&hasCheckAuth=${hasCheckAuth}&spaceType=${param.spaceType}&spaceId=${param.spaceId}&where=${param.where}";
}
</script>
</head>
<body scroll = 'no' >
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">

		<c:if test="${hasCheckBoard==true && hasCheckAuth==false}"><!-- 当只有管理权限没有审核权限时候 -->
			<tr>
			   <td height="24" class="webfx-menu-bar page2-list-header border-top border-left" >
		       		<b><fmt:message key="groupSpace.menu.inquiry.manage" bundle="${v3xMainI18N}"/></b>
		       </td>
		    <td height="24" class="webfx-menu-bar border-top border-right">&nbsp;
		    </td>
		       
		    </tr>
		</c:if>
        <c:if test="${hasCheckBoard==false && hasCheckAuth==true}"><!-- 当只有审核权限没有管理权限时候 -->
            <tr>
               <td height="24" class="webfx-menu-bar page2-list-header border-top border-left" >
                    <b><fmt:message key="inquiry.auditor.manage.label"/></b>
               </td>
            <td height="24" class="webfx-menu-bar border-top border-right">&nbsp;
            </td>
               
            </tr>
        </c:if>    
		
			<c:if test="${hasCheckAuth && hasCheckBoard}"><!-- 当既有管理板块权限又有审核权限时候 -->
				<tr>
					<td valign="bottom" height="26" class="tab-tag">
					<div class="div-float">
					<div class="tab-separator"></div>
					<div class="tab-tag-left-sel"></div>
					<div class="tab-tag-middel-sel"><a href="${basicURL}?method=getAuthoritiesTypeList&group=${group}&spaceType=${param.spaceType}&spaceId=${param.spaceId}" class="non-a"><fmt:message key="inquiry.manage.inquiry.label"></fmt:message></a></div>
					<div class="tab-tag-right-sel"></div>
			
					<div class="tab-separator"></div>
					
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel"><a href="${basicURL}?method=checkerListFrame&group=${group}&spaceType=${param.spaceType}&spaceId=${param.spaceId}" class="non-a">
					<fmt:message key="inquiry.auditor.manage.label"></fmt:message></a>
					</div>
					<div class="tab-tag-right"></div>
					<div class="tab-separator"></div>
					</div>
					</td>
				</tr>
			</c:if>	
		</table>	
    </div>
    <div class="center_div_row2" id="scrollListDiv" style="overflow:hidden;">
	<c:if test="${ hasCheckBoard}"><!-- 当有管理板块权限时候 -->
		 <form action="" name="mainForm" id=""mainForm"" method="post">
 				<v3x:table	data="${tlist}" var="tcon" htmlId="asdsad" isChangeTRColor="true" dragable="true">
				<c:set var="admin" value="${v3x:showOrgEntitiesOfIds(bean.managerUserIds, 'Member', pageContext)}" />
				<c:set var="onclick" value="inquiryCategoryList('${tcon.inquirySurveytype.id}')" />
				<v3x:column  type="String" label="inquiry.categoryName.label"  className="cursor-hand sort"  width="20%"  alt="${tcon.inquirySurveytype.typeName}" >
				<a class="black_link" href="javascript:${onclick}"><strong>${v3x:toHTML(v3x:getLimitLengthString(tcon.inquirySurveytype.typeName,26,"..."))}</strong></a>
				</v3x:column>
				
				<v3x:column type="String" label="inquiry.categoryDesc.label"  value="${tcon.inquirySurveytype.surveyDesc}"  onClick="${onclick}" 
					className="sort" width="30%" maxLength="30" alt="${tcon.inquirySurveytype.surveyDesc}" symbol="..." />
				
				<v3x:column label="inquiry.total.label" type="Number" value="${tcon.count}" className="sort" width="10%" onClick="${onclick}" />
				
				<c:set var="managerName" value="${v3x:showOrgEntities(tcon.managers, 'id', 'entityType' , pageContext)}"/>
				<v3x:column type="String" label="inquiry.manager.label"  value="${managerName}" className="sort" width="20%" alt="${managerName}"  maxLength="30" symbol="..." onClick="${onclick}" />
			   
			   <v3x:column  type="String" width="10%" label="inquiry.audit.whether"  className="sort" onClick="${onclick}">
						<c:choose>
							<c:when test="${tcon.inquirySurveytype.censorDesc==0}">
								<fmt:message key="common.true"  bundle="${v3xCommonI18N}" />
							</c:when>
							<c:otherwise>
								<fmt:message key="common.false" bundle="${v3xCommonI18N}" />
							</c:otherwise>
						</c:choose>
				</v3x:column>
				
				<v3x:column  type="String" width="10%" label="inquiry.auditor.label"  className="sort"  
					value="${v3x:showOrgEntitiesOfIds(tcon.checker.id, 'Member', pageContext)}" maxLength="42" 
					alt="${v3x:showOrgEntitiesOfIds(tcon.checker.id, 'Member', pageContext)}" onClick="${onclick}" />
		    </v3x:table>
        </form>
	</c:if>	
	<!-- 当没有管理权限时候只有审核时候 -->
	<c:if test="${hasCheckBoard == false && hasCheckAuth == true }">
		<iframe noresize src="${basicURL}?method=checkerListFrameInner&group=${group}&spaceType=${param.spaceType}&spaceId=${param.spaceId}&where=${param.where}" frameborder="no" name="detailIframe" style="width:100%;height: 100%;" border="0px" scrolling="no"></iframe>	
		<!--  
		<iframe noresize src="${basicURL}?method=getAllCheck&group=${group}" frameborder="no" name="detailIframe" style="width:100%;height: 100%;" border="0px" scrolling="no"></iframe>	
	    -->
	</c:if>
    </div>
  </div>
</div>

	

	
</body>
</html>
