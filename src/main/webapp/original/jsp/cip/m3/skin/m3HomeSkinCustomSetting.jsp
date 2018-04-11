<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<!DOCTYPE html>
<html class="h100b">
<head>
  <title>${ctp:i18n('cip.service.login.skin.title')}</title>
  <style type="text/css">
  	.m3-label {
  		font-size: 12px;
  	}
  	.div-bg-phone {
  		width: 210px;
  		height: 410px;
  		background-image: url("${path}/apps_res/m3/img/phone.png");
  		position: relative;
  	}
  	.bg-img-preview{
  		position: absolute;
  		width:167px;
  		height:297px;
  		top:57px;
  		left:22px;
  		background-size: 100%;
  	}
  	.logo-img-preview{
  		position:absolute;
  		width:96px;
  		height:71px;
  		top:100px;
  		left:60px;
  		background-size: 100%;
  	}
  	.bg-img-preview:HOVER, .logo-img-preview:HOVER{
		border: 1px solid red;
		margin-left: -1px;
		margin-top: -1px;
		cursor: pointer;
	}
	#attachmentAreabgImg, #attachmentArealogImg{
		display: none;
	}
	.bg-img {
		width: 100%;
		height : 100%;
		display: none;
	}
  </style>
</head>
<body class="h100b">
<div class="scrollList">
	<input id="inputbgImg" type="hidden" class="comp hidden" comp="attachmentTrId:'bgImg',type:'fileupload',applicationCategory:'54',
	maxSize:5242880,quantity:1,
	callMethod:'uploadCallBack',extensions:'jpg,jpeg,gif,bmp,png',
	takeOver:false,firstSave:true" attsdata='${ attachmentsJSON}'>
	
	<input id="inputlogImg" type="hidden" class="comp hidden" comp="attachmentTrId:'logImg',type:'fileupload',applicationCategory:'54',maxSize:5242880,quantity:1,
	callMethod:'uploadCallBack',extensions:'jpg,jpeg,gif,bmp,png',
	takeOver:false,firstSave:true" attsdata='${ attachmentsJSON}'>
	
	<form id="formUpload" name="formUpload" method="post" action="${path}/m3/homeSkinController.do?method=upload">
		<input type="hidden" id="hd-phone-type" name="phoneType" value="${phoneType}">
		<input type="hidden" id="hd-bg-img-create-date" name="bgImgCreateDate">
		<input type="hidden" id="hd-bg-img-file-id" name="bgImgFileId">
		<input type="hidden" id="hd-logo-img-create-date" name="logoImgCreateDate">
		<input type="hidden" id="hd-logo-img-file-id" name="logoImgFileId">
		
		<table style="width: 100%; height: 100%; border: 0px;">
			<colgroup>
				<col width="10%" />
				<col width="20%" />
				<col width="70%" />
			</colgroup>
			<tbody>
				<tr >
					<td style="text-align: right;">
						<label class="m3-label">${ctp:i18n('cip.service.login.skin.background')}</label>
					</td>
					<td style="text-align: left;"><input type="text" id="txt-bg-img" style="width: 99%" readonly="readonly" /></td>
					<td style="text-align: left;"><input type="button" id="btn-upload-bg-img" value="${ctp:i18n('cip.service.login.skin.upload')}" class="common_button common_button_gray"/><span>${ctp:i18n('cip.service.homeSkin.background.size')}</span></td>
				</tr>
				<tr style="display:none;">
					<td style="text-align: right;">
						<label class="m3-label">Logo</label>
					</td>
					<td style="text-align: left;"><input type="text" id="txt-logo-img" style="width: 99%" readonly="readonly"/></td>
					<td style="text-align: left;"><input type="button" id="btn-upload-logo-img" value="${ctp:i18n('cip.service.login.skin.upload')}" class="common_button common_button_gray"/><span>${ctp:i18n('cip.service.homeSkin.logo.size')}</span></td>
				</tr>
				<tr>
					<td></td>
					<td>
						<div class="div-bg-phone">
							<div class="bg-img-preview">
							<img class="bg-img" src="">
							</div >
							<div class="logo-img-preview" style="display: none;">
							</div>
						</div>
					</td>
					<td></td>
				</tr>
				<tr>
					<td></td>
					<td height="42px" class="bg-advance-bottom">
						<input type="button" id="btn-save-upload-img" value="${ctp:i18n('cip.service.login.skin.save')}" class="common_button common_button_gray"/>
					</td>
					<td></td>
				</tr>
			</tbody>
		</table>
	</form>
</div>
</body>
<script type="text/javascript">
	var isDisabled = false;
	// 设备类型：1Android; 2iPhone;
	var phoneType;
	var imgAtt;
	var imgURL;
	var image;
	// 图片类型：1背景图; 2Logo;
	var imageType;
	var maxSize = 1024*1024;
	var downloadURL = "/seeyon/fileUpload.do?type=&applicationCategory=0&extensions=png&maxSize=" + maxSize ;
	$(document).ready(function(){
		phoneType = $("#hd-phone-type").val();
		if (phoneType && phoneType === "android") {
			phoneType = 1;
		} else if (phoneType && phoneType === "iphone") {
			phoneType = 2;
		} else {
			phoneType = 1;
		}
		$("#btn-upload-bg-img").click(function (evt) {
			uploadFile(1);
		});
		$("#btn-upload-logo-img").click(function (evt) {
			uploadFile(2);
		});
		$("#btn-save-upload-img").click(function (evt) {
			$("#formUpload").submit();
		});
		
		$(".bg-img-preview").click(function (evt) {
			if (!isDisabled) uploadFile(1);
		});
		$(".logo-img-preview").click(function (evt) {
			if (!isDisabled) uploadFile(2);
		});
		var newBgImg = "${newBgImg}";
		if (newBgImg) {
			showBgImg("${path}" + newBgImg);
		}
		/* $(".bg-img-preview").css("backgroundImage","url(${path}${bgImg}?t=${refreshTime})"); */
		/* $(".logo-img-preview").css("backgroundImage","url(${path}${logoImg}?t=${refreshTime})"); */
	});
	
	function showBgImg(newBgImg) {
		$(".bg-img").show();
		$(".bg-img").attr("src", newBgImg);
	}
	
	function disabled(is) {
		isDisabled = is;
		$("#btn-upload-bg-img").attr("disabled", is);
		$("#btn-upload-logo-img").attr("disabled", is);
		$("#btn-save-upload-img").attr("disabled", is);
	}
	
	// 上传文件
	function uploadFile(imgType) {
		imageType = imgType;
		switch (imgType) {
		case 1:
			insertAttachmentPoi("bgImg");
		break;
		case 2:
			insertAttachmentPoi("logImg");
		break;
		}
		/*
		fileUploadQuantity = 1;
		var url = downloadURL + "&quantity=" + fileUploadQuantity;
		v3x.openWindow({
			url			: url,
			width		: 400,
			height		: 250,
			resizable	: "yes"
		});
		if (fileUploadAttachments.isEmpty()) {
		   return ;
		}
		disabled(true);
		imgAtt = fileUploadAttachments.values().get(0);
		imgURL = "/seeyon/fileUpload.do?method=showRTE&fileId=" 
				+ imgAtt.fileUrl + "&createDate=" 
				+ imgAtt.createDate.substring(0, 10) + "&type=image";
		fileUploadAttachments.clear();
		
		image = new Image();
		image.src = imgURL;
		
		setTimeout("checkFile()",3500);
		*/
	}
	function uploadCallBack(obj) {
		//console.log(obj);
		imgAtt = obj.instance[0];
		imgURL = "/seeyon/fileUpload.do?method=showRTE&fileId=" 
				+ imgAtt.fileUrl + "&createDate=" 
				+ imgAtt.createDate + "&type=image";		
		image = new Image();
		image.src = imgURL;
		
		checkFile();
	}
	
	// 验证文件
	function checkFile() {
		var img_width = image.width;
		var img_height = image.height;
		
		var createDate = "";
		if (imgAtt.createDate) {
			createDate = imgAtt.createDate;
		} else if (imgAtt.createdate) {
			createDate = imgAtt.createdate;
			createDate = createDate.split(" ")[0];
		}
		
		switch (imageType) {
		// 背景
		case 1:
			if (phoneType == 1/*  && img_width == 480 && img_height == 760 */) {			// Android设备背景图大小验证 
				$("#hd-bg-img-create-date").val(createDate);
				$("#hd-bg-img-file-id").val(imgAtt.fileUrl);
			} else if (phoneType == 2/*  && img_width == 640 && img_height == 920  */) { 	// iPhone设备背景图片打小验证
				$("#hd-bg-img-create-date").val(createDate);
				$("#hd-bg-img-file-id").val(imgAtt.fileUrl);
			} else {
				if (phoneType == 1) {
					alert("Android BG Error");
				} else if (phoneType == 2) {
					alert("Android BG Error");
				}
				return;
			}
			//$(".bg-img-preview").css("backgroundImage","url(" + imgURL + ")");
			showBgImg(imgURL);
			$("#txt-bg-img").val(imgAtt.filename);
		break;
		// Logo
		case 2:
			// 设备Logo图大小验证 
			/* if (img_width == 320 && img_height == 270) {
				
			} else {
				alert("Logo Error");
			} */
			$("#hd-logo-img-create-date").val(createDate);
			$("#hd-logo-img-file-id").val(imgAtt.fileUrl);
			
			//$(".logo-img-preview").css("backgroundImage","url(" + imgURL + ")");//
			showBgImg(imgURL);
			$("#txt-logo-img").val(imgAtt.filename);
		break;
		}
		disabled(false);
	}
</script>
</html>