<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="../include/taglib.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="mainResource"/>
<html>
<head>
<%@ include file="../include/header.jsp"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"> 
${v3x:skin()}
	
<script type="text/javascript">
var theHtml;
	if('18'=='${param.spaceType}'||'17'=='${param.spaceType}'){
       theHtml=toHtml("${v3x:toHTML(spaceName)}",'<fmt:message key="bul.data_shortname"/><fmt:message key="oper.manage"/>');
	}else if('3'=='${param.spaceType}'){
	       theHtml=toHtml("${v3x:toHTML(spaceName)}",'<fmt:message key="menu.group.bul.manage" bundle="${v3xMainI18N}"/>');
	}else if('2'=='${param.spaceType}'){
	       theHtml=toHtml("${v3x:toHTML(spaceName)}",'<fmt:message key="menu.account.bul.manage" bundle="${v3xMainI18N}"/>');
	}
	showCtpLocation("",{html:theHtml});
</script>
<script type="text/javascript">
<c:if test="${more==null}">
	window.onload = function(){
		showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	}
</c:if>	
</script>
<script type="text/javascript">
	function viewTypeList(typeId,baseUrl){
		var flag = validTypeExist(typeId, 'ajaxBulDataManager');
 		if(flag == 'false'){
 			alert(v3x.getMessage("bulletin.type_deleted"));
 			window.location.reload(true);
 		}else{
 			document.location.href = baseUrl;
 		}
		
	}
</script>
</head>
</script>
<body scroll="no" >
	<div class="main_div_row2">
	  <div class="right_div_row2">
	    <div class="top_div_row2">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
            <c:if test="${showBoard == true && showAudit == false }"><!-- 当只有管理权限没有审核权限时候 -->
                <tr>
                   <td height="24" class="webfx-menu-bar page2-list-header border-top border-left" >
                        <b>
                           <fmt:message key="groupSpace.menu.bulletin.manage" bundle="${v3xMainI18N}"/>
                        </b>
                   </td>
                   <td height="24" class="webfx-menu-bar border-top border-right">&nbsp;
                 </td>      
                </tr>
            </c:if>
            <c:if test="${showBoard == false && showAudit == true }"><!-- 当只有审核权限没有管理权限时候 -->
                    <tr>
                       <td height="24" class="webfx-menu-bar page2-list-header border-top border-bottom border-left" >
                            <b>
                               <fmt:message key="bul.data_shortname" /><fmt:message key="label.audit" />
                            </b>
                       </td>
                       <td height="24" class="webfx-menu-bar border-top border-bottom border-right">&nbsp;
                     </td>      
                    </tr>
            </c:if>        
<c:if test="${showBoard == true && showAudit == true }"><!-- 当既有管理板块权限又有审核权限时候 -->
	<tr>
		<td valign="bottom" height="26" class="tab-tag">
			<div class="div-float">
					<div class="tab-separator"></div>
					<div class="tab-tag-left-sel"></div>
					<div class="tab-tag-middel-sel"><a href="#" class="non-a"><fmt:message key="bul.data_shortname" /><fmt:message key="oper.manage" /></a></div>
					<div class="tab-tag-right-sel"></div>
				
							
					<div class="tab-separator"></div>
					<div class="tab-tag-left"></div>
					<div class="tab-tag-middel"><a href="${bulDataURL}?method=auditListMain&spaceType=${spaceType}&from=${from}&spaceId=${param.spaceId}" class="non-a"><fmt:message key="bul.data_shortname" /><fmt:message key="oper.audit" /></a></div>
					<div class="tab-tag-right"></div>
					<div class="tab-separator"></div>
			
			</div>
		</td>
	
	</tr>
	
</c:if>	
</table></div>
<c:if test="${showBoard == true}">
	<div class="center_div_row2" id="scrollListDiv" style="overflow:hidden;">
	<form name="listForm" id="listForm" method="post">
	<v3x:table htmlId="listTable" data="${typeList}" var="bean" isChangeTRColor="true" dragable="true">
		<c:set var="onClick" value="javascript:viewTypeList('${bean.id}', '${bulDataURL}?method=listBoardIndex&bulTypeId=${bean.id}&spaceType=${bean.spaceType}&spaceId=${param.spaceId}');" />
		<v3x:column width="30%" type="String" label="bul.type.typeName" className="cursor-hand sort">
			<a class="black_link" href="${onClick}"><strong>${v3x:toHTML(bean.typeName)}</strong></a>
		</v3x:column>
		
		<v3x:column width="20%" type="String" label="bul.type.description" className="cursor-hand sort" 
			alt="${bean.description}" value="${bean.description}" maxLength="30" symbol="..." onClick="${onClick}">
		</v3x:column>
		
		<v3x:column width="15%" type="Number" 
			label="label.totals" className="cursor-hand sort" onClick="${onClick}" >
			${bean.totalItems}
		</v3x:column>
		
		<v3x:column width="15%" type="String"
			label="bul.type.managerUsers" className="cursor-hand sort" value="${v3x:showOrgEntitiesOfIds(bean.managerUserIds, 'Member', pageContext)}"
			alt="${v3x:showOrgEntitiesOfIds(bean.managerUserIds, 'Member', pageContext)}" onClick="${onClick}" />
			
		<v3x:column width="10%" type="String" label="bul.type.auditFlag" className="cursor-hand sort" maxLength="7" symbol="..." onClick="${onClick}" >
			<c:if test="${bean.auditFlag==false }">
				<fmt:message key="common.false" bundle="${v3xCommonI18N}"/>
			</c:if>
			<c:if test="${bean.auditFlag==true }">
				<fmt:message key="common.true" bundle="${v3xCommonI18N}"/>
			</c:if>
		</v3x:column>
		
		<v3x:column width="10%" type="String" label="bul.type.auditUser" className="cursor-hand sort" maxLength="7" onClick="${onClick}" >
		 	<c:if test="${bean.auditFlag==false }"></c:if>
			<c:if test="${bean.auditFlag==true }">${v3x:showMemberName(bean.auditUser)}</c:if>
		</v3x:column>	
	</v3x:table>
	</form>
	</div>
</c:if>
<!-- 当没有管理权限时候只有审核时候 -->
<c:if test="${showBoard == false && showAudit == true }">
    <div class="center_div_row2" style="overflow:hidden;">
         <iframe noresize src="${bulDataURL}?method=entry&spaceType=${param.spaceType}&from=${from}&showAudit=${showAudit}&spaceId=${param.spaceId}" frameborder="no" name="detailIframe" style="width:100%;height: 100%;" border="0px" scrolling="no"></iframe> 
    </div>
</c:if>
</div></div>

</body>
</html>