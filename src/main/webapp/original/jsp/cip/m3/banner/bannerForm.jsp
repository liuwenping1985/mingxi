<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="${path}/apps_res/m3/css/banner.css">
</head>

<body>
	<input id="inputBannerImg" type="hidden" class="comp hidden" comp="attachmentTrId:'bannerImg',type:'fileupload',applicationCategory:'54',
	maxSize:5242880,quantity:1, callMethod:'uploadCallBack',extensions:'jpg,png', takeOver:false,firstSave:true" 
	attsdata='${ attachmentsJSON}'>
	
	<form name="bannerForm" id="bannerForm" method="post" target="" class="validate">
		<input type="hidden" id="id" name="id" />
		<input type="hidden" id="view" name="view"/>
		<input type="hidden" id="imageUrl" name="imageUrl"/>
		<input type="hidden" id="uploadDate" name="uploadDate" />
		<table class="formTable">
			<colgroup>
				<col align="center" width="30%" />
				<col align="right" width="40%" />
				<col align="left" width="30%" />
			</colgroup>
			<tbody>
				<tr><td></td><td class="tdLbl"><font style="color: red;">*</font>${ctp:i18n('m3.banner.form.banner.name')}</td><td></td></tr>
				<tr>
					<td></td><td>
						<input type="text" id="bannerName" name="bannerName"/>
					</td><td></td>
				</tr>
				<tr><td></td><td class="tdLbl"><font style="color: red;">*</font>${ctp:i18n('m3.banner.form.banner.img')}</td><td></td></tr>
				<tr>
					<td></td><td class="td-img">
						<img id="bannerImage" class="banner-image" alt="" src="">
						<span class="span-delete-image"></span>
					</td><td></td>
				</tr>
				<tr>
					<td></td><td class="td-btn">
						<input type="button" id="btn-upload-img" value="${ctp:i18n('cip.manager.login.skin.upload')}" class="common_button common_button_gray"><span id="uploadMsg">&nbsp;&nbsp;${ctp:i18n('m3.banner.form.upload.msg')}<span>
					</td><td></td>
				</tr>
				<tr><td></td><td class="tdLbl">${ctp:i18n('m3.banner.form.url')}</td><td></td></tr>
				<tr>
					<td></td><td>
						<input type="text" id="bannerUrl" name="bannerUrl"/>
					</td><td></td>
				</tr>
			</tbody>
		</table>
	</form>
</body>
</html>