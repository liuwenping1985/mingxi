<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../header.jsp" %>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/systemmanager/js/symbolConfig.js${v3x:resSuffix()}"/>"></script>
<title>Insert title here</title>
<script type="text/javascript">
var isA8geniusAdded;
try{
  var ufa = new ActiveXObject('UFIDA_IE_Addin.Assistance');
  isA8geniusAdded = true;
}catch(e){
  isA8geniusAdded = false;
}
var geniusSurfix = '&isA8geniusAdded=' + isA8geniusAdded;
var imgSrc1=null;
var imgSrc2=null;
var imgSrc=null;
var downloadURL = "<html:link renderURL='/fileUpload.do?type=&applicationCategory=0&extensions=jpeg,jpg,png,gif'/>";

<%-- 恢复到默认配置，如果是非根单位恢复到集团的设置，如果是集团则恢复到系统设置 --%>
function toDefaultConfig(){
	if(confirm(_('sysMgrLang.space_alert_sureToDefault'))){
		location.href = "${accountManagerURL}?method=updateAccountSymbolConfig&accountId=${accountId}&toDefault=true";
 	}
}
<%-- 显示所选图片 --%>
 function changeImage(flag)
 {
    fileUploadQuantity = 1;
    insertAttachment();
    if(fileUploadAttachments.isEmpty())
    {
       return ;
    }
	var imgAtt = fileUploadAttachments.values().get(0);
	var imgURL = "fileUpload.do?method=showRTE&fileId="+imgAtt.fileUrl+"&createDate="+imgAtt.createDate.substring(0, 10) + "&type=image";
    fileUploadAttachments.clear();

	switch(flag)
    {
     case 1:
			imgSrc = imgSrc1 = imgURL;
			document.all.fileId1.value = imgAtt.fileUrl;
			document.all.fileCreateDate1.value = imgAtt.createDate.substring(0, 10);
             document.all.isLogoReplaced.value = "true";
             break;

     case 2:
			imgSrc = imgSrc2 = imgURL;
			document.all.fileId2.value = imgAtt.fileUrl;
			document.all.fileCreateDate2.value = imgAtt.createDate.substring(0, 10);
             document.all.isBannerReplaced.value = "true";
             break;
    }
    setSubmitBtnEnable(true);
	document.frames("showImgIframe" + flag).location.reload(true);
 }

function checkTopIsReady(){
	if(getA8Top().contentFrame.topFrame.document.readyState == "complete"){
		//getA8Top().showLocation(1420);
	
	}else{
		window.setTimeout("checkTopIsReady()", 200);
	}
}
checkTopIsReady();
</script>
</head>
<body scroll="no" style="overflow: auto;" class="">
<form action="${accountManagerURL}" method="get" onsubmit="setSubmitBtnEnable(false);document.getElementById('toDefultBtn').disabled=true;">
<input type="hidden" name="method" value="updateAccountSymbolConfig">
<input type="hidden" name="accountId" value="${accountId}">

<input type="hidden" name="fileId1" value="">
<input type="hidden" name="fileCreateDate1" value="">
<input type="hidden" name="fileId2" value="">
<input type="hidden" name="fileCreateDate2" value="">

<input type="hidden" name="groupAccountId" value="${groupAccountId}">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="">
	<tr class="page2-header-line">
		<td width="100%" height="41" valign="top" class="page-list-border-LRD">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     	<tr class="page2-header-line">
		        <td width="45" class="page2-header-img"><div class="accountSymbolConfig"></div></td>
			        <td class="page2-header-bg"><fmt:message key='account.symbol.config' bundle="${organizations}"/></td>
			        <td class="page2-header-line page2-header-link" align="right"></td>
				</tr>
				</table>
			</td></tr>
    <tr>
   	<td>
   		<div class="scrollList">
   		<table width="85%" border="0" height="300" align="center" cellpadding="0" cellspacing="0">
		   	<tr>
		      <td height="200">
			      <fieldset style="padding:20px 20px 0 20px; height:180px;">
			     	<legend><b><fmt:message key="corporation.config.logo"/>:</b>&nbsp;&nbsp;( <fmt:message key="corporation.config.imageSize"/>: 96px * 60px )</legend>
						<div style="width: 100%; height: 100px; padding-top: 6px;">
						<iframe id="showImgIframe1" name="showImgIframe1" ${isHiddenLogo==true? 'style="display:none;"':''} width="96" height="60" scrolling="no" src="<c:url value='/showImg.html'/>?height=60&src=<c:url value='${logoFileName}'/>">
						</iframe>&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="button" id="uploadLogoBtn" ${isHiddenLogo==true? 'style="display:none;"':''} value="<fmt:message key="corporation.config.uploadImage"/>" class="button-default-4" onClick="changeImage(1)"/>
						<input type="hidden" name="isLogoReplaced" value="false">
						</div>
						<label for="isHiddenLogo">
						<input id="isHiddenLogo" name="isHiddenLogo" type="checkbox" onclick="setLogoHidden()" <c:if test="${isHiddenLogo==true}">checked</c:if> >
						<fmt:message key="corporation.config.hiddenLogo"/>
						</label>
			     </fieldset>
		      </td>
		   </tr>
		   <tr>
		      <td height="100">
		      <fieldset style="padding: 20px">
			     	<legend><b><fmt:message key="corporation.config.banner"/>:</b>&nbsp;&nbsp;( <fmt:message key="corporation.config.imageSize.height"/>: 76px )</legend>
		      <br>
		      <iframe name="showImgIframe2" width="85%" height="76" scrolling="no" src="<c:url value='/showImg.html'/>?src=<c:url value='${bannerFileName}'/>&expand=${isTileBanner==true}">
		      </iframe>
		      &nbsp;&nbsp;
		      <input type="button" name="button" value="<fmt:message key='corporation.config.uploadImage'/>" class="button-default-4" onClick="changeImage(2)"/>&nbsp;&nbsp;
		      <input type="hidden" name="isBannerReplaced" value="false">
		      <br/>
		      <label for="isTileBanner">
		        <input id="isTileBanner" name="isTileBanner" type="checkbox" onclick="setBannerTile()" <c:if test="${isTileBanner==true}">checked</c:if> >
		        <fmt:message key="corporation.config.tileBanner"/>
		      </label>
		      <br/>
		      <label for="isHiddenAccountName">
		        <input id="isHiddenAccountName" name="isHiddenAccountName" type="checkbox" <c:if test="${isHiddenAccountName==true}">checked</c:if> >
		        <fmt:message key="corporation.config.hiddenName"/>
		      </label>
		      <c:if test="${groupAccountId!=null}">
		      <br/>
		      <label for="isHiddenGroupName">
		        <input id="isHiddenGroupName" name="isHiddenGroupName" type="checkbox" <c:if test="${isHiddenGroupName==true}">checked</c:if> >
		        <fmt:message key="group.config.hiddenName${v3x:suffix()}"/>
		      </label>
		      </c:if>
		       </fieldset>
		      </td>
		   </tr>
		</table>
		</div>
   	</td>
   </tr>
   <tr>
		<td height="42" align="center" class="tab-body-bg bg-advance-bottom">
			<input type="submit" id="submitBtn" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2 button-default_emphasize">&nbsp;&nbsp;
			<input type="button" id="toDefultBtn" value="<fmt:message key='space.button.toDefault'/>" class="button-default-4" onclick="toDefaultConfig()">&nbsp;&nbsp;
			<input type="button" onclick="getA8Top().backToHome();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
</table>
</form>
</body>
</html>