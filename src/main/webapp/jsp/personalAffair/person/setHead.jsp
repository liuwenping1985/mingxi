<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<!DOCTYPE html>
<%@ include file="../header.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<html style="height: 100%;width: 100%;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources" var="v3xHRI18N" />
<title><fmt:message key="hr.staffInfo.selfSet.label" bundle="${v3xHRI18N}"/></title>
<script type="text/javascript">

	function doOnclick(){
	  try{
		  getA8Top().headImgCuttingWin = getA8Top().$.dialog({
			    id : "headImgCutDialog",
	            title : "${ctp:i18n("personal.headImg.cuttingAndUpload")}",
	            transParams:{'parentWin':window},
	            url: "${pageContext.request.contextPath}/portal/portalController.do?method=headImgCutting",
	            width: 650,
	            height: 500,
	            isDrag:false
	     });
	  }catch(e){}	  
	}
	
	function headImgCuttingCallBack (retValue) {
		getA8Top().headImgCuttingWin.close();
		if(retValue != undefined){
	          $("#image2").attr("src", "${pageContext.request.contextPath}/fileUpload.do?method=showRTE&fileId=" + retValue + "&type=image");
	          $("#filename2").val("fileId=" + retValue);
	    }
	}
	
	function returnText(){
		if(encodeURIComponent(document.getElementById("image2").src) != getParameter("filename")){
	         var returnValue = document.getElementById("filename2").value + "," + document.getElementById("image2").src;
	         transParams.parentWin.setHeadCollback(returnValue);
		} else {
			 getA8Top().setHeadWind.close();
		}
	}
	
	function selectHead(def){
		document.getElementById("filename2").value = def.name + ".gif";
		var str = "<img id='image2' class='radius' src='" + def.src + "' width='104' height='104'>";
		document.getElementById("thePicture1").innerHTML = str;
	}
</script>
</head>
<body scroll="no" style="height: 100%;width: 100%;overflow: hidden;">
<form name="setHeadForm" method="post" action="" target="setHeadFrame" onsubmit="" style="height: 100%;overflow: hidden;">
<input type="hidden" id="filename1" name="filename1" value="<%=com.seeyon.ctp.util.Strings.toHTML(request.getParameter("filename"))%>">
<input type="hidden" id="filename2" name="filename2" value="">
<div style="height: 85%;overflow-y: hidden;">
<table border="0" cellspacing="0" cellpadding="0" width="100%" height="100%">
    <tr>
        <td width="75%" height="100%" valign="top">
            <table cellspacing="0"  cellpadding="0" width="100%" height="100%" style="padding-top:5px;  padding-left:5px;  padding-right:5px;">
                <tr bgcolor="#ecf4fe" style="padding-top:0px;">
                    <td colspan="4" height="10%"><b><fmt:message key="hr.staffInfo.ladyself.label" bundle="${v3xHRI18N}" /></b></td>
                </tr>
                <tr style="padding-top:0px;">
                    <c:forEach begin="1" end="4" step="1" varStatus="status">
                        <td align="center" height="40%">
                            <img src="${pageContext.request.contextPath}/apps_res/v3xmain/images/personal/user-${status.index}.gif" name="user-${status.index}"
                                width="104" height="104" class="radius cursor-hand" onclick="selectHead(this)" style="border: 1px #CCC solid;">
                        </td>
                    </c:forEach>
                </tr>
                <tr bgcolor="#ecf4fe" style="padding-top:0px;">
                    <td colspan="4" height="10%"><b><fmt:message key="hr.staffInfo.manself.label" bundle="${v3xHRI18N}" /></b></td>
                </tr>
                <tr style="padding-top:0px;">
                    <c:forEach begin="5" end="8" step="1" varStatus="status">
                        <td align="center" height="40%">
                            <img src="${pageContext.request.contextPath}/apps_res/v3xmain/images/personal/user-${status.index}.gif" name="user-${status.index}"
                                width="104" height="104" class="radius cursor-hand" onclick="selectHead(this)" style="border: 1px #CCC solid;">
                        </td>
                    </c:forEach>
                </tr>
            </table>
        </td>
        <td width="25%" bgcolor="#f7fbfe">
            <table cellspacing="0" cellpadding="0" width="100%" height="100%" style="padding:2px;">
                <tr>
                    <td>&nbsp;&nbsp;<fmt:message key="hr.staffInfo.preview.label" bundle="${v3xHRI18N}" />:</td>
                </tr>
                <tr>
                    <td align="center" class="description-lable">
                        <div id="thePicture1" style="cursor: pointer;" onclick="doOnclick()">
                            <img id="image2" class="radius" src="<%=com.seeyon.ctp.util.Strings.toHTML(request.getParameter("filename"))%>" width="104" height="104" />
                        </div>
                        <br>
                        104*104px
                        <br><br>
                        <input type="button" value="<fmt:message key="hr.staffInfo.local.label" bundle="${v3xHRI18N}" />" onclick="doOnclick()">
                        <br><br>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</div>

<div style="height: 15%">
    <table border="0" cellspacing="0" cellpadding="0" width="100%" height="100%">
        <tr>
        <td height="35" align="right" class="bg-advance-bottom" colspan="2">
            <input type="submit" id="check" name="check" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize" onclick="returnText();">
            <input type="button" name="submintCancel" onclick="getA8Top().setHeadWind.close();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
        </td>
    </tr>
    </table>
</div>
<div style="display:none;">
	<table>
		<tr id="attachmentTR" class="bg-summary" style="display:none;">
			<td nowrap="nowrap" height="18" class="bg-gray" valign="top"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /></td>
			<td colspan="8" valign="top"><div class="div-float">(<span id="attachmentNumberDiv"></span>)</div>
			<v3x:fileUpload extensions="gif,jpg,jpeg,bmp,png" maxSize="307200" />
			<script>
				var fileUploadQuantity = 1;
			</script>
			</td>
		</tr>	
	</table>
</div>
	
</form>
<iframe name="setHeadFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>