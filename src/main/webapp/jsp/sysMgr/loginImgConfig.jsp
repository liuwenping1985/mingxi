<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="header.jsp" %>
<%@ include file="../common/INC/noCache.jsp"%>
<title>Insert title here</title>
<script type="text/javascript">
//TODO getA8Top().hiddenNavigationFrameset(2303);
var imgSrc=null;
var downloadURL = "<html:link renderURL='/fileUpload.do?type=&applicationCategory=0&extensions=jpeg,jpg,png,gif'/>";
<c:set var="titleResource" value="common.page.title${v3x:oemSuffix()}${v3x:suffix()}"/>
<c:set value="${v3x:_(pageContext, titleResource)}" var="pageTitle" />
//恢复默认
function setLoginBgToDefault(){
    document.all.imageModify.value='true';
	document.all.titleModify.value='true';
	imgSrc = "<c:url value='${defaultLoginImgFilePath}'/>";
	document.all.toImageDefault.value = "true";
	document.all.toTitleDefault.value = "true";
	document.all.submit.disabled = false;
	document.getElementById("showImgIframe").contentWindow.location.reload(true);
	document.getElementById("title").value ='${pageTitle}';
}

 //显示所选图片
function changeImage(){
    document.all.imageModify.value='true';
	fileUploadQuantity = 1;
	document.all.toImageDefault.value = "false";
	//imgSrc = "<c:url value='/USER-DATA/IMAGES/LOGIN/temp_login.gif'/>";
	insertAttachment();
	if(fileUploadAttachments.isEmpty()){
	      return ;
	}
	var imgAtt = fileUploadAttachments.values().get(0);
	imgSrc = "${pageContext.request.contextPath}/fileUpload.do?method=showRTE&fileId="+imgAtt.fileUrl+"&createDate="+imgAtt.createDate.substring(0, 10) + "&type=image";
	document.all.fileId.value=imgAtt.fileUrl;
	document.all.fileCreateDate.value=imgAtt.createDate.substring(0, 10);

	fileUploadAttachments.clear();
	document.all.submit.disabled = false ;
	document.getElementById("showImgIframe").contentWindow.location.reload(true);
}
function changeTitle(){
    document.all.submit.disabled =false;
    document.all.titleModify.value='true';
    document.all.toTitleDefault.value = "false";
}
</script>
</head>
<body scroll="no" style="overflow: auto;">
<form action="${accountManagerURL}" method="post" onsubmit="return checkForm(this)">
<input type="hidden" name="method" value="updateLoginImage">
<input type="hidden" name="toImageDefault" value="false">
<input type="hidden" name="toTitleDefault" value="false">
<input type="hidden" name="imageModify" value="false">
<input type="hidden" name="titleModify" value="false">
<input type="hidden" name="fileId" value="">
<input type="hidden" name="fileCreateDate" value="">
<TABLE width="100%" height="100%" align="center" border="0" cellpadding="0" cellspacing="0" class="border_lr">
	<tr class="page2-header-line">
		<td width="100%" height="41" valign="top" class="">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     	<tr class="page2-header-line">
		        <td width="45" class="page2-header-img"><div class="showLoginImage"></div></td>
        <td class="page2-header-bg"><fmt:message key="system.login.imageConfig.title"/></td>
        <td class="page2-header-line">&nbsp;</td>
	</tr>
</table>
</td>
</tr>
<tr valign="top">
<td valign="middle" height="100%">
<div id="titleload" align="center" class="scrollList">
<table>
<tr>
<td>
<fmt:message key='system.login.titleConfig.title'/>:&nbsp;&nbsp;
<c:if test="${loginTitleName!=null}">
<input type="text" id="title" name="title" onChange="changeTitle()" onpropertychange="changeTitle()"  value="${loginTitleName}" size="40" maxSize="30" maxlength="30" validate="notSpecChar" inputName="<fmt:message key='system.login.titleConfig.title'/>">
</c:if>
<c:if test="${loginTitleName==null}">
<input type="text" id="title" name="title" onChange="changeTitle()" onpropertychange="changeTitle()"  value="${pageTitle}" size="40" maxSize="30" maxlength="30" validate="notSpecChar" inputName="<fmt:message key='system.login.titleConfig.title'/>">
</c:if>
</td>
</tr>
<tr valign="top">
<td>
<fmt:message key="system.login.imageConfig.title"/>:
</td>
</tr>
<tr>
      <td valign="top">
      <iframe id="showImgIframe" name="showBannerIframe" width="750" height="380" scrolling="yes" src="<c:url value='/apps_res/systemmanager/showImg.html'/>?src=<c:url value='${loginImgFilePath}'/>">
      </iframe>
	  <br>
	  <br>
      <input type="button" name="button" value="<fmt:message key='corporation.config.uploadImage'/>" class="button-default-4" onClick="changeImage()"/>
      &nbsp;&nbsp;( <fmt:message key="corporation.config.imageSize"/>: ${v3x:getSysFlagByName('sys_isGovVer')=='true'?'780px * 404px':'822px * 456px'} )
      </td>
</tr>
</table>
</div>
</td>
</tr>
<tr>
	<td colspan="3" height="40" align="center" class="bg-advance-bottom" >
	<input type="hidden" name="weatherConfig" value="0,0">
      	<input type="submit" name="submit" disabled="disabled" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}'/>" class="button-default-2"/>&nbsp;&nbsp;&nbsp;&nbsp;
        <input type="button" name="button" value="<fmt:message key='channel.button.toDefault' bundle='${v3xMainI18N}'/>" class="button-default-4" onClick="setLoginBgToDefault()"/>&nbsp;&nbsp;&nbsp;&nbsp;
      	<input type="button" name="cancel" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}'/>" class="button-default-2" onclick="getA8Top().backToHome()"/>
   </td>
</tr>

</table>
</form>
</body>
</html>