<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>  
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../header.jsp" %>
<%@ include file="../../common/INC/noCache.jsp"%>
<title>Insert title here</title>
<script type="text/javascript">
var imgSrc=null;
var downloadURL = null;
<c:set var="url" value='<%="/fileUpload.do?type=&applicationCategory=0&extensions=jpeg,jpg,png,gif&destFilename=" + application.getRealPath("/apps_res/v3xmain/images/logo")%>' />
var downloadURL1 = "<html:link renderURL='${url}/temp_${fileNameAccountId}.gif'/>";
<c:set var="url" value='<%="/fileUpload.do?type=&applicationCategory=0&extensions=jpeg,jpg,png,gif&destFilename=" + application.getRealPath("/apps_res/v3xmain/images/banner")%>' />
var downloadURL2 = "<html:link renderURL='${url}/temp_${fileNameAccountId}.gif'/>";
 
<%--
//恢复默认Banner
function toDefault()
{
   imgSrc = "<c:url value='/apps_res/v3xmain/images/banner.gif'/>"; 
   document.all.isBannerReplaced.value = "false";
   document.all.submit.disabled = false ;
   document.frames("showImgIframe2").location.reload(true);
}
--%>
 
<%-- 恢复到默认配置，如果是非根单位恢复到集团的设置，如果是集团则恢复到系统设置 --%>
function toDefaultConfig(){
	if(confirm(_('sysMgrLang.space_alert_sureToDefault'))){
		location.href = "${accountManagerURL}?method=updateAccountInfoConfig&isGroupAdmin=${isGroupAdmin}&toDefault=true";
 	}
}
<%-- 显示所选图片 --%>
 function changeImage(flag)
 {
    switch(flag)
    {
     case 1: imgSrc = "<c:url value='/apps_res/v3xmain/images/logo/temp_${fileNameAccountId}.gif'/>";  
             downloadURL = downloadURL1;
             document.all.isLogoReplaced.value = "true";
             break;
             
     case 2: imgSrc = "<c:url value='/apps_res/v3xmain/images/banner/temp_${fileNameAccountId}.gif'/>";  
             downloadURL = downloadURL2;
             document.all.isBannerReplaced.value = "true";
             break;
    }
    
    insertAttachment();
    if(fileUploadAttachments.isEmpty())
    {
       return ;
    }
    fileUploadAttachments.clear();
    document.all.submit.disabled = false ;
	document.frames("showImgIframe" + flag).location.reload(true);
 }

<%-- 刷新top --%>
if("${isReloadTop}" == "true"){
	getA8Top().contentFrame.topFrame.location.reload();
}

<%-- 当前位置 --%>
</script>
</head>
<body scroll="no" style="overflow: no;padding:5px;">
<form action="${accountManagerURL}" method="get">
<input type="hidden" name="method" value="updateAccountInfoConfig">
<input type="hidden" name="isGroupAdmin" value="${isGroupAdmin}">
<input type="hidden" name="realPath" value="<%=application.getRealPath("/")%>">
<table width="100%" height="100%" align="center" style="border:solid 0px #A4A4A4;" cellpadding="0" cellspacing="0">  
  <tr>
  <td valign="bottom" height="26" class="tab-tag" colspan="2">
		<c:choose>
			<c:when test="${isGroupAdmin == true}">
				<div id="aa" class="tab-tag-left"></div>
				<div id="bb" class="tab-tag-middel cursor-hand" onclick="location.href='<html:link renderURL="/organization.do"/>?method=editGroupAccount&from=updateAccount&accountAdminis=account&isDetail=readOnly&isSystemOperation=true&showLocation=true&tag=0'">
				<fmt:message key="group.detailed.message" bundle="${organizations}"/></div>
				<div id="cc" class="tab-tag-right"></div>
						
				<div class="tab-separator"></div>
				<div id="dd" class="tab-tag-left"></div>
				<div id="ee" class="tab-tag-middel cursor-hand" onclick="location.href='<html:link renderURL="/organization.do"/>?method=editGroupAccount&from=updateAccount&accountAdminis=account&isDetail=readOnly&isSystemOperation=true&showLocation=true&tag=1'">
				<fmt:message key="group.role.manager" bundle="${organizations}"/></div>
				<div id="ff" class="tab-tag-right"></div>		
	
				<div class="tab-separator"></div>
				<div id="dd" class="tab-tag-left-sel"></div>
				<div id="ee" class="tab-tag-middel-sel cursor-hand" onclick="location.href='<html:link renderURL="/accountManager.do?method=showAccountInfoConfig&isGroupAdmin=true"/>'">
				<fmt:message key="group.symbol.config.label" bundle="${organizations}"/></div>
				<div id="ff" class="tab-tag-right-sel"></div>
			</c:when>
			<c:otherwise>
				<div id="aa" class="tab-tag-left"></div>
				<div id="bb" class="tab-tag-middel cursor-hand" onclick="location.href='<html:link renderURL="/organization.do"/>?method=editGroupAccount&from=updateGroupAccount&accountAdminis=account&isDetail=readOnly&showSymbol=true&tag=0'">
				<fmt:message key="account.detailed.message" bundle="${organizations}"/></div>
				<div id="cc" class="tab-tag-right"></div>
						
				<div class="tab-separator"></div>
				<div id="dd" class="tab-tag-left"></div>
				<div id="ee" class="tab-tag-middel cursor-hand" onclick="location.href='<html:link renderURL="/organization.do"/>?method=editGroupAccount&from=updateGroupAccount&accountAdminis=account&isDetail=readOnly&showSymbol=true&tag=1'">
				<fmt:message key="account.role.manager" bundle="${organizations}"/></div>
				<div id="ff" class="tab-tag-right"></div>
						
				<div id="gg" class="tab-separator"></div>
				<div id="hh" class="tab-tag-left-sel"></div>
				<div id="ii" class="tab-tag-middel-sel cursor-hand" onclick="location.href='<html:link renderURL="/accountManager.do"/>?method=showAccountInfoConfig'">
				<fmt:message key='account.symbol.config' bundle="${organizations}"/></div>
				<div class="tab-tag-right-sel"></div>
			</c:otherwise>
		</c:choose>	
		</td>
   </tr>
   <tr>
   	<td width="100%">
   		<table width="100%" height="100%" align="center" style="border-left:solid 1px #A4A4A4;border-right:solid 1px #A4A4A4;border-bottom:solid 1px #A4A4A4;" cellpadding="0" cellspacing="0">  
		   	<tr>
		   	<td height="30">&nbsp;
		   	</td>
		   	</tr>
		   	<tr height="80">
		      <td align="right" width="20%" ><fmt:message key="corporation.config.logo"/>:<br>
		      	( <fmt:message key="corporation.config.imageSize"/>: 82px * 83px )</td>
		      <td style=" padding-left: 6px;">
		      <iframe id="showImgIframe1" name="showLogoIframe" width="82" height="83" scrolling="no" src="<c:url value='/common/showImg.html'/>?width=82&height=83&src=<c:url value='/apps_res/v3xmain/images/${logoFileName}'/>">
		      </iframe>
		      <input type="button" name="button" value="<fmt:message key="corporation.config.uploadImage"/>" class="button-default-4" onClick="changeImage(1)"/>
		      <input type="hidden" name="isLogoReplaced" value="${isLogoReplaced}">
		      </td>
		   </tr>
		   <tr height="100">
		      <td align="right"><fmt:message key="corporation.config.banner"/><br>
		      	( <fmt:message key="corporation.config.imageSize.height"/>: 83px )</td>
		      <td style=" padding-left: 6px;">
		      <br>
		      <iframe id="showImgIframe2" name="showBannerIframe" width="600" height="83" scrolling="no" src="<c:url value='/common/showImg.html'/>?width=600&height=83&src=<c:url value='/apps_res/v3xmain/images/${bannerFileName}'/>&expand=true">
		      </iframe>
		      <br>
		      <c:if test="${isGroupAdmin == false}">
		      <label for="hiddenAccountName">
		        <input id="hiddenAccountName" name="hiddenAccountName" type="checkbox" onclick="document.all.submit.disabled=false;" <c:if test="${isHiddenName=='true'}">checked</c:if> >
		        <fmt:message key="corporation.config.hiddenName"/>
		      </label>
		      </c:if>
		      &nbsp;&nbsp;&nbsp;&nbsp;
		      <input type="button" name="button" value="<fmt:message key='corporation.config.uploadImage'/>" class="button-default-4" onClick="changeImage(2)"/>&nbsp;&nbsp;
		      <input type="hidden" name="isBannerReplaced" value="${isBannerReplaced}">
		      <br><br>
		      </td>
		      <td></td>
		   </tr>
		   <tr>
		   <td colspan="2">&nbsp;</td>
		   </tr>
		   <tr>
					<td height="42" align="center" class="bg-advance-bottom" colspan="2">
						<input type="submit" name="submit" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2" disabled="disabled">&nbsp;&nbsp;
						<input type="button" id="toDefultBtn" value="<fmt:message key='space.button.toDefault'/>" class="button-default-4" onclick="toDefaultConfig()">&nbsp;&nbsp;
						<input type="button" onclick="location.reload();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
					</td>
			</tr>
		</table>
   	</td>
   </tr> 
</table>
</form>
</body>
</html>