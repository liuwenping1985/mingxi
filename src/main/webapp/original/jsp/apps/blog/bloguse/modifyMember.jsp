<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ include file="../header.jsp" %>
<%@ include file="../../../common/INC/noCache.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
<style type="text/css">
.border_b {
  border-bottom: 1px solid #b6b6b6;
}
</style>
</head>
<script type="text/javascript">
</script>
<script type="text/javascript">
<!--

	function submitForm(){
		var theForm = document.getElementsByName("theForm")[0];
		if (!theForm) {
        	return;
    	}
    	theForm.target = "_self";
		theForm.action = "${detailURL}?method=modifyEmployee";
	
		if (checkForm(theForm)) {
		if(theForm.introduce.value.length>1000)
		      alert('<fmt:message key="blog.alert.toolong" />');
	    else
        	theForm.submit();
   	 	}
	}
//-->
</script>
<script type="text/javascript">
	function doOnclick(){
		fileUploadAttachments.clear();
		insertAttachment();
		if(fileUploadAttachments.isEmpty() == false){
			var theList=fileUploadAttachments.keys();	//key
			var attach=fileUploadAttachments.get(theList.get(0),null);	//��������
			var _fileId=attach.fileUrl;
			var _createDate=attach.createDate;
			var _filename=attach.filename;
			var str1="<img src='/seeyon/fileUpload.do?method=download&fileId="+_fileId+"&createDate="+_createDate+"&filename="+_filename+"' width='50px' height='50px' border='0'>";
			var str2="<a href='#' onclick='doOnclick();'>" + v3x.getMessage("<fmt:message key="org.member_form.pic.upload"/>") + "</a> ";
	//		document.getElementById("testImage").innerHTML="<img src='/seeyon/fileUpload.do?method=download&fileId="+_fileId+"&createDate="+_createDate+"&filename="+_filename+"' id=imageName >";
	//		var theImage=document.getElementById("imageName");
			document.getElementById("thePicture").innerHTML=str1+str2;
			document.getElementById("image").value=str1;
			
			
		}

	}
	

	
	function resetInfo(){

		//document.getElementById("thePicture").innerHTML=oldPic;
		//document.getElementById("image").value=oldImage;
		document.getElementById("introduce").value="";
		document.getElementById("introduce").focus();
	}

	var sxUpConstants = {
	status_0 : "0,*",
	status_1 : "20%,*"
}
var sxDownConstants = {
	status_0 : "*,12",
	status_1 : "20%,*"
}
	
</script>
<body scroll="no">
<form action="" method="post" id="theForm" name="theForm" >
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
<tr>
	<td valign="top">
		<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
			<tr>
				<td valign="top">
					<table width="100%" border="0" cellpadding="0" cellspacing="0" class="page2-header-line border_b" >
						  <tr>
							<td width="80" class="page2-header-img"><img src="<c:url value='/apps_res/peoplerelate/images/pic1.gif' />" width="80" height="60" /></td>
							<td class="page2-header-bg">&nbsp;<fmt:message key="blog.blogmanager.employee.lable"/></td>
							<td>
								<div class="blog-div-float-right">
								<!-- ���� -->
								<a href="${detailURL}?method=blogHome" class="hyper_link2">
										[<fmt:message key="common.toolbar.back.label" bundle="${v3xCommonI18N}" />]
								</a>&nbsp;&nbsp;
								</div>
							</td>
						  </tr>
					</table>
				</td>
			</tr>
		</table>
	</td>
</tr>
<tr>
	<td  align="center">
		<table width="100%" border="0"    cellspacing="0" cellpadding="0" align="center" height="100%" >
			<tr><td height="8%" colspan="3">&nbsp;&nbsp;</td></tr>
			<tr>
				<td  width="34%" nowrap align="right" valign="top">
					<fmt:message key="blog.label.introduce"/>:
				</td>					
				<td  width="32%" valign="top" align="left">
					<textarea id="introduce" name="introduce"  cols="60"
					rows="10"><c:out value="${blogEmployee.introduce}" escapeXml="true"/></textarea><br>
					<font color='red'>(<fmt:message key='blog.alert.maxlength'/>1000<fmt:message key='blog.alert.maxword'/>)</font>
				</td>
				<td width="34%"></td>
			</tr>
<!-- 
			<tr>
				<td  width="25%" nowrap align="right" valign="top"><fmt:message key='blog.label.pic'/>:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td  width="50%" id="thePicture" valign="top">
			
					<c:if test="${image != '0' }">
					${image}
					</c:if>
					<c:if test="${image == '0' }">
					<img src="${pageContext.request.contextPath}/apps_res/blog/images/default-info.gif" width="50" height="50" />
					</c:if>
				</td>
				<td  width="25%">
				
				</td>
			</tr>
						<tr height="25">
				<td  width="25%" nowrap align="right" valign="top"></td>
				<td  width="50%" id="thePicture" valign="top">
					<a href="javascript:doOnclick();" class="hyper_link2" >[<fmt:message key='blog.label.pic.update'/>]</a>
				</td>
				<td  width="25%">
				
				</td>
			</tr>
 -->
		</table>
	</td>
</tr>
    <tr id="editButton"  valign="bottom">
        <td align="center" class="bg-advance-bottom"> 
            <input type="button" class="button-default-2"  onclick="submitForm()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />"    >
            <input type="button" class="button-default-2"  onclick="resetInfo()" value="<fmt:message key='blog.button.reset' />"    >
        </td>
    </tr>
</table>
<!-- 	
	<div style="display:none;"><table>
	<tr id="attachmentTR" class="bg-summary" style="display:none;">
      <td nowrap="nowrap" height="18" class="bg-gray" valign="top"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /></td>
      <td colspan="8" valign="top"><div class="div-float">(<span id="attachmentNumberDiv"></span>��)</div>
<v3x:fileUpload extensions="gif,jpg,jpeg,bmp,png" />
<script>
var fileUploadQuantity = 1;
</script>
</td>
	</tr>	
	</table></div>
 -->	
	<div id="memberId"></div>
	<input type="hidden" id="image" name="image" value="${image}" >
	<input type="hidden"  name="id"  value="${blogEmployee.id}">
	<div  id="testImage" ></div>
</form>

<iframe id="linkIframe" name="linkIframe" frameborder="0" marginwidth="0" marginheight="0" height="0" width="0" scrolling="no" ></iframe>

</body>
</html>