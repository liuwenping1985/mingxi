<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
</head>
<body scroll="no" class="h100b dialog_bg" style="overflow: hidden;">
<div id="bannerContainer" class="scrollList form_area" style="height: 418px;overflow: auto;">
</div>
<div id="cloneDiv" class="hidden">
    <div id="bannerSetting" class="bannerSetting">
        <div class="clearfix margin_t_5 margin_l_5">
            <div class="left clearfix" style="width: 20px;min-height: 100px;line-height: 100px;margin-left:15px;">
                <div style="height: 50px;line-height: 25px;">
                    <span id="addRowButton" class="addRowButton ico16 repeater_plus_16"></span>
                    <br/>
                    <br/>
                    <span id="delRowButton" class="delRowButton ico16 repeater_reduce_16"></span>
                </div>
            </div>
            <div>
                <fieldset style="width: 505px;padding:0px;border:1px solid #ccc;">
                    <legend>${ctp:i18n('section.name.banner.image')}</legend>
                    <div style="width: 465px; margin: 10px;">
                        <input type="hidden" id="count" name="count" value="" />
                    	<div id="bannerImageUploadDiv" class="hidden"></div>
                        <div id="bannerImageDiv" class="clearfix margin_t_5" style="line-height: 20px;">
                            <div class="left like_a hand" style="width: 100px;text-align: right;padding-top:4px;" onclick="addParamImage(this)">${ctp:i18n('section.name.banner.image.image')}：</div>
                            <div class="left common_txtbox_wrap" style="width: 310px;padding: 0px;">
                            	<div style="height: 60px;overflow: auto;" onclick="addParamImage(this)">
                            		<input id="bannerImageId" name="bannerImageId" value="${ctp:i18n('space.banner.upload.img')}" style="padding-left:5px;color:#999999;width:auto;" />
									<img id="bannerImage" src="" class="hidden" />
								</div>
                            </div>
                        </div>
                        <div id="bannerImageTitleDiv" class="clearfix margin_t_5" style="line-height: 20px;">
                            <div class="left" style="width: 100px;text-align: right;">${ctp:i18n('section.name.banner.image.title')}：</div>
                            <div class="left common_txtbox_wrap" style="width: 300px;">
                            	<input type="text" id="bannerImageTitle" name="bannerImageTitle" value="" maxLength="30" class="validate" validate="type:'string',maxLength:30,name:'${ctp:i18n('section.name.banner.image.title')}',avoidChar:'!@#$%^&\|\\\/<>\'*'" />
                            </div>
                        </div>
                        <div id="bannerImageUrlDiv" class="clearfix margin_t_5" style="line-height: 20px;">
                            <div class="left" style="width: 100px;text-align: right;">${ctp:i18n('section.name.banner.image.url')}：</div>
                            <div class="left common_txtbox_wrap" style="width: 300px;">
                            	<input type="text" id="bannerImageUrl" name="bannerImageUrl" value="" maxLength="200" class="validate" validate="type:'string',maxLength:200,name:'${ctp:i18n('section.name.banner.image.url')}',avoidChar:'<>\''" />
                            </div>
                        </div>
                    </div>
                </fieldset>
            </div>
        </div>
    </div>
</div>
</body>
<script type="text/javascript">
	var transParams = window.dialogArguments;
	var currentBannerSet = null;
	var count = 0;
	var txt="${ctp:i18n('space.banner.upload.img')}";
	$().ready(function() {
	    $(".addRowButton").click(function() {
	    	addBannerSet(currentBannerSet);
	    });

	    $(".delRowButton").click(function() {
	    	setCurrentBannerSet(this);
	    	delBannerSet();
	        currentBannerSet = null;
	    });

	    $(".bannerSetting").mousedown(function() {
	    	currentBannerSet = $(this);
	    });

	    $("body").data("bannerSetClone", $("#bannerSetting", "#cloneDiv").clone(true));

	    var banners = null;
	    if (transParams) {
	    	banners = $.parseJSON(transParams);
	    }

	    if (banners != null && banners.length > 0) {
	    	for (var i = 0; i < banners.length; i++) {
		    	var banner = banners[i];
		    	addBannerSet();
		    	currentBannerSet.find("#bannerImage").attr("src", _ctxPath + "/fileUpload.do?method=showRTE&fileId=" + banner.bannerImageId + "&type=image");
			    currentBannerSet.find("#bannerImage").show();
			    currentBannerSet.find("#bannerImageId").val(banner.bannerImageId);
		    	currentBannerSet.find("#bannerImageTitle").val(banner.bannerImageTitle);
		    	currentBannerSet.find("#bannerImageUrl").val(banner.bannerImageUrl);
		    	currentBannerSet.find("#bannerImageId").hide();
		    }
	    } else {
	    	addBannerSet();
	    }
	});

	function setCurrentBannerSet(obj) {
	    currentBannerSet = $(obj).parents(".bannerSetting");
	}

	function addBannerSet(obj) {
		var length = $(".bannerSetting", "#bannerContainer").length;
	    if (length == 5) {
	    	$.alert("${ctp:i18n('section.name.banner.image.max')}");
	    	return;
	    }
		count = count + 1;
		var bannerImageUploadDivId = "bannerImageUploadDiv" + count;
		var poiAddParamImageId = "poiAddParamImage" + count;
	    var temObj = $("body").data("bannerSetClone").clone(true);
	    temObj.find("#count").val(count);
	    temObj.find("#bannerImageUploadDiv").attr("id", bannerImageUploadDivId);
	    if (obj) {
	        temObj.insertAfter($(obj));
	    } else {
	        $("#bannerContainer").append(temObj);
	    }
	    dymcCreateFileUpload(bannerImageUploadDivId, 0, 'jpg,jpeg,gif,bmp,png', 1, false, 'addParamImageCallBack', poiAddParamImageId, true, true, null, false, true);
	    currentBannerSet = temObj;
	}

	function delBannerSet() {
	    if ($(".bannerSetting", "#bannerContainer").length > 1) {
	    	currentBannerSet.remove();
	    } else {
	    	currentBannerSet.remove();
	    	addBannerSet();
	    }
	}

	function addParamImageCallBack(attachments) {
	    fileUploadAttachments.clear();
	    var attachment = attachments.instance[0];
	    currentBannerSet.find("#bannerImage").attr("src", _ctxPath + "/fileUpload.do?method=showRTE&fileId=" + attachment.fileUrl+ "&type=image");
	    currentBannerSet.find("#bannerImage").show();
	    currentBannerSet.find("#bannerImageId").val(attachment.fileUrl);
	    currentBannerSet.find("#bannerImageId").hide();
	}

	function addParamImage(obj) {
		var poiAddParamImageId = "poiAddParamImage" + currentBannerSet.find("#count").val();
	    insertAttachmentPoi(poiAddParamImageId);
	    $(obj).children().eq(0).css("display","none");
	}

	<c:if test="${param.from == 'Vjoin'}">
	function getCtpTop(){
		return window;
	}
	</c:if>

	function OK() {
		var check =true;
		var s = [];
		s[0] = [];
		var length = $(".bannerSetting", "#bannerContainer").length;
    	var isValidate = $("#bannerContainer").validate();
    	if (isValidate) {
    		var count=0;
    		var dataStr= "";
   	    	$(".bannerSetting", "#bannerContainer").each(function(i){
   	    		var bannerImageId = $(this).find("#bannerImageId").val();
   	    		if(txt==bannerImageId)bannerImageId="";
   	    		if (bannerImageId == "") {
   	    			//$.alert("${ctp:i18n('section.name.banner.image.image.notnull')}");
   	    			//check = false;
   	    			//return false;
   	    		}else{
   	    			var bannerImageTitle = $(this).find("#bannerImageTitle").val();
   	   	    		var bannerImageUrl = $(this).find("#bannerImageUrl").val();
   	   	    		if(bannerImageUrl != "" && bannerImageUrl.indexOf("http://")!=0 && bannerImageUrl.indexOf("https://")!=0){
   	   	    			bannerImageUrl = "http://"+bannerImageUrl;
   	   	    		}
	   	   	    	if (count > 0) {
						dataStr += ","+ $.toJSON({"bannerImageId":bannerImageId, "bannerImageTitle":bannerImageTitle, "bannerImageUrl":bannerImageUrl});
		   	    	}else{
						dataStr += $.toJSON({"bannerImageId":bannerImageId, "bannerImageTitle":bannerImageTitle, "bannerImageUrl":bannerImageUrl});
					}
   	   	    		count ++;
   	    		}
   	    	});
   	    	if(count>0){
   	    		s[0][0] = "[";
   	    		s[0][0] += dataStr;
   	    		s[0][0] += "]";
   	    	}else{
   	    		return "closeDefault";
   	    	}
    	} else {
    		check = false;
    	}
	    if (check) {
	    	return s;
	    } else {
	    	return null;
	    }
	}
</script>
</html>