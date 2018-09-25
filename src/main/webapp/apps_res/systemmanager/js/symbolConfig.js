//设置按钮状态
function setSubmitBtnEnable(flag){
	document.getElementById('submitBtn').disabled = !flag;
}
//设置LOGO不显示
function setLogoHidden(){
	imgSrc = imgSrc1;
	var checkFlag = document.all.isHiddenLogo.checked;
	document.all.uploadLogoBtn.style.display = checkFlag ? "none" : "";
	document.all.showImgIframe1.style.display = checkFlag ? "none" : "";
}

//更改Banner是否平铺的状态
function setBannerTile(){
	var checkedFlag = document.all.isTileBanner.checked;
    var bannerSrc = document.all.showImgIframe2.src;
    imgSrc = imgSrc2;
	if(checkedFlag){
	    if(bannerSrc.indexOf("&expand=false") != -1){
	    	document.all.showImgIframe2.src = bannerSrc.replace(/\&expand=false/g, "&expand=true");
	    }else{
	    	if(bannerSrc.indexOf("&expand=true") == -1){
	    		document.all.showImgIframe2.src += "&expand=true";
	    	}
   	    }
	}
	else{
		if(bannerSrc.indexOf("&expand=true") != -1){
	    	document.all.showImgIframe2.src = bannerSrc.replace(/\&expand=true/g, "&expand=false");
	    }
	}
   	//document.frames("showImgIframe2").location.reload(true);
}