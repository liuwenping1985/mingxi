<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./include/taglib.jsp" %>
<%@ include file="./include/header.jsp" %>
<%
	String summaryId = request.getParameter("summaryId");
	String affairId = request.getParameter("affairId");
	String bodyType = request.getParameter("bodyType"); 
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js" />"></script>
<title><fmt:message key="select.space.type" bundle='${v3xCommonI18N}' /></title>
<script type="text/javascript">
/**
 * 初始设置，默认选中第一个新闻版块
 */
window.onload = function(){
	var selectedArr = document.getElementsByName("issus_space_type");
	if(selectedArr && selectedArr.length>0){
		//默认选中列表中的第一个新闻板块
		selectedArr[0].checked = true;
	}
};

/**
 * 处理弹出窗口的回调函数
 */
function OK(){
	var selectedArr = document.getElementsByName("issus_space_type");
 	var selectedValue = null;
 	var selectedType = null;
 	
	for(var i=0; i<selectedArr.length; i++){
		if(selectedArr[i].checked == true){
			selectedValue = selectedArr[i].value;
			selectedType = selectedArr[i].getAttribute("extAttribute1");
			break;
		}
	}

	var imageIdStr = document.getElementById("imageId").value;
	var filenameStr = document.getElementById("filename").value;
	var filesizeStr = document.getElementById("filesize").value;
	var imageNewsStr = document.getElementById("imageNews").value;
	var showPublishUserFlag = document.getElementById("showPublishUserFlag").value;
	if( imageNewsStr && imageNewsStr=="1" ){
		if( !imageIdStr || imageIdStr=="" ){
			alert(v3x.getMessage("NEWSLang.imagenews_must_upload_image"));
			return false;
		}
	}
   var bodyType = "${bodyType}";
   var changePdf = document.getElementById("toPDF");
   var ext5="";
   if(bodyType == "OfficeWord" && changePdf && changePdf.checked){
       ext5="1";
    }
    summaryId = "<%=summaryId%>";
	affairId = "<%=affairId%>";
	result = [ summaryId,affairId,selectedValue,imageIdStr,imageNewsStr,ext5,bodyType,filenameStr,filesizeStr,showPublishUserFlag];
	return result;
}
/**
 * 处理选中 或者 取消 图片新闻复选框
 */
function changeCheckBox( imageNewsObj ){
	var imageNews = document.getElementById("imageNews");
	if( imageNewsObj.checked ){
		imageNewsObj.value="1";
	}else{
		imageNewsObj.value="0";
	}
	var upload = document.getElementById("upload");
	if(imageNews.checked ){
		upload.style.display = "";
	} else {
		upload.style.display = "none";
	}
}

function changeCheckBoxPublishUserFlag( PublishUserFlag ){
    var PublishUserFlagvalue = document.getElementById("showPublishUserFlag");
    if( PublishUserFlagvalue.checked ){
    	PublishUserFlag.value="1";
    }else{
    	PublishUserFlag.value="0";
    }
}
/**
* 上传图片
*/
var uploadImageItem = {};
var downloadURL = "<html:link renderURL='/fileUpload.do?type=5&applicationCategory=0&extensions=jpeg,jpg,png,gif'/>";
function uploadImage4News(){
	var imageId = document.getElementById("imageId");
	var filename = document.getElementById("filename");
	var filesize = document.getElementById("filesize");
	if(imageId.value != null && imageId.value != "" && imageId.value != 1){
		alert(v3x.getMessage("NEWSLang.imagenews_imageuploaded"));
		return ;
	}
	var url = downloadURL;
	var quantity = fileUploadQuantity;
	var attachments = fileUploadAttachments;
	var oldSize = fileUploadAttachments.size();
	uploadImageItem.oldSize = oldSize;
	uploadImageItem.url = url;
	uploadImageItem.quantity = quantity;
	uploadImageItem.filename = filename;
	fileUploadQuantity = 1;
	insertAttachment(null, null, 'newsbackInsertAttachment', 'false');

	
}

function newsbackInsertAttachment() {
	var newSize = fileUploadAttachments.size();
    if(newSize != uploadImageItem.oldSize){
        var imgAttId = fileUploadAttachments.keys().get(fileUploadAttachments.size()-1);//获得上传图片ID
        var keys=fileUploadAttachments.keys();
        var attach=fileUploadAttachments.get(keys.get(0),null); // 附件对象
        uploadImageItem.filename.value = attach.filename;
        var filesize = document.getElementById("filesize");
        var imageId = document.getElementById("imageId");
        filesize.value = attach.size;
        imageId.value = imgAttId;
    }
    downloadURL = uploadImageItem.url;
    fileUploadQuantity = uploadImageItem.quantity;
}

</script>
</head>
<body scroll="no" style="overflow: hidden" onkeydown="listenerKeyESC()" >
<form name="preIssusForm" action="" target="preIssusIframe" method="post" >
<input type="hidden" id="memberIdsStr" name="memberIdsStr" value=""/>
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="15" class="PopupTitle" colspan="2"><fmt:message key="newsaudit.space" bundle='${v3xCommonI18N}' />:</td>
	</tr>
	<tr>
		<td class="bg-advance-middel">
			<div style="border: solid 1px #666666;  overflow-y:auto; height:320px">
				<table class="sort" width="100%" border="0" cellspacing="0" cellpadding="0" onClick="sortColumn(event, true)">
					<thead>
					<tr class="sort">
						<td type="String" colspan="2"><fmt:message key="space.name" bundle='${v3xCommonI18N}' /></td>
					</tr>
					</thead>
					<tbody>
						<c:forEach items="${typeList}" var="typeData">
						<tr class="sort" align="left" >
							<td align="center" class="sort" width="5%">
								<input type="radio" name="issus_space_type" id="spaceTypeName" value="${typeData.id}" extAttribute1="${typeData.spaceType}" extAttribute2="${typeData.accountId}" />
							</td>
							<td class="sort" type="String">
								${v3x:toHTML(typeData.typeName)}
							</td>
						</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</td>
	</tr>
  	
  	<tr id="ctrl_print_read" style="background-color: #F6F6F6;">
		<td height="40" nowrap="nowrap" style="padding-left:6px;padding-right:16px;">
			<div class="div-float">
                <input type="checkbox" name="showPublishUserFlag" id="showPublishUserFlag" value="0"  onclick="changeCheckBoxPublishUserFlag(this)"/>&nbsp;<label for="showPublishUserFlag"><fmt:message key="news.dataEdit.showPublishUser"/></label>   
	   			<input type="checkbox" name="imageNews" id="imageNews" onclick="changeCheckBox(this)" value="0"/><label for="imageNews"><fmt:message key='news.image_news' /></label>		
	   			<input type="hidden" name="filename" id="filename" value="">
	   		    <input type="hidden" name="filesize" id="filesize" value="">
	   			<input type="hidden" name="imageId" id="imageId" value="">&nbsp;&nbsp;
	   		</div>
			<span id="upload" style="display:none;">
				<div class="div-float">
					<input type="button" name="uploadImage" id="uploadImage" value="<fmt:message key='news.upload.image' />" onclick="javascript:uploadImage4News();">
				</div>
				<div id="attachment5Area" style="width:50%;height:10px;" class="div-float "></div>
			</span>
			<script type="text/javascript">
				var imageNews = document.getElementById("imageNews");
				if( imageNews.checked ){
					document.getElementById("upload").style.display = "";
				}
			</script>
		</td>
  	</tr>
  	<tr id="ctrl_print_read" style="background-color: #F6F6F6;">
        <td height="20" nowrap="nowrap" style="padding-left:6px;padding-right:16px;">
            <c:if test="${bodyType == 'OfficeWord' || bodyType == 'WpsWord'}">
                    <label for="toPDF">
                        <input type="checkbox" name="changePdf" id="toPDF" /><fmt:message key="common.transmit.pdf" bundle='${v3xCommonI18N}' />
                    </label>
                  </c:if>
        </td>
    </tr>
</table>
</form>
<iframe src="" name="preIssusIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>