<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<link href="${path}/main/personalHeadImg/jquery.Jcrop.min.css${ctp:resSuffix()}" rel="stylesheet" type="text/css"/>
<link href="${path}/common/skin/default/skin.css${ctp:resSuffix()}" rel="stylesheet" type="text/css"/>
<script src="${path}/main/personalHeadImg/jquery.Jcrop.min.js${ctp:resSuffix()}"></script>
<script type="text/javascript"> 
var imgManager = RemoteJsonService.extend({
	jsonGateway : "${path}/ajax.do?method=ajaxAction&managerName=imgManager",
	imgCuttingAndSave: function(){
	return this.ajaxCall(arguments, "imgCuttingAndSave");
	},
	getSrcWidthAndHeight: function(){
		return this.ajaxCall(arguments, "getSrcWidthAndHeight");
	}
}); 

var originalImgCreateDate = ""; 				//原图上传时间
var jcropObject = null;							//jcrop对象
var cuttingManager = new imgManager();

var cuttingParam = {
	originalWidth: 0,							//用于显示头像的原始区域宽
	originalHeight: 0,							//用于显示头像的原始区域高
	previewWidth: transParams.previewWidth,		//预览区域宽
	previewHeight: transParams.previewHeight,	//预览区域高
	x: 0,										//x轴坐标
	y: 0,										//y轴坐标
	w: 0,										//切面宽度
	h: 0,										//切面高度
	formatName: transParams.formatName
};

function showPreview(coords) {
  var preview = $("#preview");
  if(parseInt(coords.w) > 0) {
    cuttingParam.x = parseInt(coords.x);
    cuttingParam.y = parseInt(coords.y);
    cuttingParam.w = parseInt(coords.w);
    cuttingParam.h = parseInt(coords.h);
    
    width = coords.w;
    height = coords.h;
    
    var rx = cuttingParam.previewWidth / coords.w;
    var ry = cuttingParam.previewHeight / coords.h;

    preview.css({
      width : Math.round(rx * cuttingParam.originalWidth) + 'px',
      height : Math.round(ry * cuttingParam.originalHeight) + 'px',
      marginLeft : '-' + Math.round(rx * coords.x) + 'px',
      marginTop : '-' + Math.round(ry * coords.y) + 'px'
    }).show();
  }
}
function hidePreview() {}
  
function uploadCallBack(attachment){
  if(jcropObject != null){
	jcropObject.destroy();
  } 
  
  if(typeof(transParams.uploadCallback) == 'function'){
	  var f = transParams.uploadCallback(attachment.instance);
	  if(!f){
		  return;
	  }
  }
  
  if(attachment.instance[0].extension.toUpperCase() == "GIF"){ 
	$("#headImgInstruction").show();
	$("#preview").attr("src", "${path}/fileUpload.do?method=showRTE&fileId=" + attachment.instance[0].fileUrl + "&type=image");
	$("#preview").attr("style", "");
	$("#preview").width(cuttingParam.previewWidth);
	$("#preview").height(cuttingParam.previewHeight);
	$("#preview").show();
	$("#originalImg").hide();
	cuttingParam.originalImgFileId = attachment.instance[0].fileUrl;
	cuttingParam.formatName = attachment.instance[0].extension.toUpperCase();
	originalImgCreateDate = (attachment.instance[0].createDate || attachment.instance[0].createdate);
	return;
  }
  cuttingManager.getSrcWidthAndHeight(attachment.instance[0].fileUrl, {
	  success : function(srcWidthAndHeight){
		  var srcWidth = parseInt(srcWidthAndHeight[0]);
		  var srcHeight = parseInt(srcWidthAndHeight[1]);
		  //var regionWH = 350;
		  if(srcWidth > srcHeight){
			  if(srcWidth > regionWH){
				  cuttingParam.originalWidth = regionWH;
				  cuttingParam.originalHeight = parseInt(regionWH * srcHeight / srcWidth);
			  } else {
				  cuttingParam.originalWidth = srcWidth;
				  cuttingParam.originalHeight = srcHeight;
			  }
		  } else {
			  if(srcHeight > regionWH){
				  cuttingParam.originalWidth = parseInt(regionWH * srcWidth / srcHeight);
				  cuttingParam.originalHeight = regionWH;
			  } else {
				  cuttingParam.originalWidth = srcWidth;
				  cuttingParam.originalHeight = srcHeight;
			  }
		  }
		  $("#headImgInstruction").hide();
		  $("#originalImg").css("width", cuttingParam.originalWidth + "px");
		  $("#originalImg").css("height", cuttingParam.originalHeight + "px");
		  $("#originalImg").attr("src", "${path}/fileUpload.do?method=showRTE&fileId=" + attachment.instance[0].fileUrl + "&type=image");
		  $("#originalImg").show();
		  $("#preview").attr("style", "width: " + cuttingParam.previewWidth + "px; height: " + cuttingParam.previewWidth + "px;");
		  $("#preview").attr("src", "${path}/fileUpload.do?method=showRTE&fileId=" + attachment.instance[0].fileUrl + "&type=image");
		  jcropObject = $.Jcrop("#originalImg", {
		    onChange : showPreview,
		    onSelect : showPreview,
		    onRelease : hidePreview,
		    bgColor : "#f5f5f5" 
		  });
		  $(".jcrop-holder").css("margin-left", parseInt((regionWH - cuttingParam.originalWidth) / 2) + "px");
		  $(".jcrop-holder").css("margin-top", parseInt((regionWH - cuttingParam.originalHeight) / 2) + "px");
		  $(".jcrop-holder").css("top", "0px");
		  $(".jcrop-holder").css("left", plusWidth/2);
		  $(".jcrop-holder").css("position", "absolute");
		  var x, y, x2, y2;
		  if(cuttingParam.originalWidth > cuttingParam.originalHeight){
			  y = parseInt(cuttingParam.originalHeight / 3);
			  x = parseInt((cuttingParam.originalWidth - y) / 2);
			  y2 = y + y;
			  x2 = x + y;
		  } else {
			  x = parseInt(cuttingParam.originalWidth / 3);
			  y = parseInt((cuttingParam.originalHeight - x) / 2);
			  x2 = x + x;
			  y2 = y + x;
		  }
		  
		  if(parseInt(cuttingParam.originalWidth) <= 80 || parseInt(cuttingParam.originalHeight) <= 80){
		  	jcropObject.setSelect([0, 0, parseInt(cuttingParam.originalWidth), parseInt(cuttingParam.originalHeight)]);
		  }if(transParams.selectWidth && transParams.selectHeight){
			  
			  x = (cuttingParam.originalWidth - parseInt(transParams.selectWidth))/2;
			  y = (cuttingParam.originalHeight - parseInt(transParams.selectHeight))/2;
			  x2 = x + transParams.selectWidth;
			  y2 = y + transParams.selectHeight;
			  
		  	  jcropObject.setSelect([x, y, x2, y2]);
		  }
		  else{
		  	jcropObject.setSelect([x, y, x2, y2]);
		  	}
		  
		  
		  
		  cuttingParam.originalImgFileId = attachment.instance[0].fileUrl;
		  cuttingParam.formatName = attachment.instance[0].extension.toUpperCase();
		  originalImgCreateDate = (attachment.instance[0].createDate || attachment.instance[0].createdate);
	  }
  });  
}

if($.browser.msie&&($.browser.version == "7.0")){
	var plusWidth = 145;
}else{
	var plusWidth = 120;
}
var regionWH = 350;

$(document).ready(function() {
  $("#headImgInstruction").text(transParams.showInstruction);
	
  /* $("#preview-container, #preview").css({
	width: transParams.previewWidth, height: transParams.previewHeight
  });  */ 
  regionWH = parseInt(transParams.height) - plusWidth; 
  $('#div_imgShow').css({
	  height: regionWH,
	  width: regionWH + plusWidth
  });
  
  $("#preview-size").css({width: transParams.previewWidth}).text(transParams.previewWidth + " * " + transParams.previewHeight);
  dymcCreateFileUpload("myfile",13,"jpg,jpeg,png,gif,bmp",1,false,"uploadCallBack", "poi",true,true,null,false,true,5242880);
  
  $("#selectImgBtn").click(function() {
    //上传图片
    insertAttachmentPoi("poi");
  });

  $("#submitBtn").click(function() {
    if(cuttingParam.originalImgFileId != null) {
      if(cuttingParam.formatName == "GIF"){
    	  transParams.parentWin.getA8Top()._ctpImgCuttingWin.close();  
    	  transParams.callbackFunction(cuttingParam.originalImgFileId);
    	return;
      }
      if(cuttingParam.w == 0){
    	cuttingParam.x = 0;
    	cuttingParam.y = 0;
    	cuttingParam.w = cuttingParam.originalWidth;
    	cuttingParam.h = cuttingParam.originalHeight;
      }
	  cuttingManager.imgCuttingAndSave(cuttingParam, {
        success : function(cuttedHeadImgId){
          if(cuttedHeadImgId != null){
        	  transParams.callbackFunction(cuttedHeadImgId);
        	  transParams.parentWin.getA8Top()._ctpImgCuttingWin.close();  
          } else {
            $.alert("图片处理出错，请联系管理员检查log");
          }
        }
      });
    } else {
      $.alert("${ctp:i18n("personal.headImg.cuttingPrompt")}");
    }
  });

  $("#cancelBtn").click(function() {
	  if(typeof(transParams.cancelFunction) == 'function'){
		  transParams.cancelFunction();
	  }
	  
	  getCtpTop()._ctpImgCuttingWin.close();
  });

});
</script>
</head>
<body style="font-size: 14px; overflow: hidden; position: relative; ">
    <input id="myfile" type="hidden" />
    <table border="0" cellSpacing="0" cellPadding="0" style="margin-top: 40px; margin-left: 64px;">
        <tr>
            <td style="position: relative;">
	            <div id="div_imgShow" style="float:left; text-align:center; background-color: #f5f5f5; border: 1px #e1e1e1; color: #aaaaaa" >
	            	<div id="headImgInstruction" style="margin-top: 50px">${ctp:i18n("personal.headImg.instruction")}</div>
	            </div>
	            <img id="originalImg" style="position:absolute; display:none; " />
           </td>
            <%-- <td valign="top">
                <div id="preview-container" style="margin-left: 68px; margin-top: 0px; width: 110px; height: 110px; overflow: hidden;">
                    <img id="preview" src="${path}/apps_res/v3xmain/images/personal/pic.gif" style="width: 110px; height: 110px;">
                </div>
                <div id="preview-size" style="margin-left: 68px; margin-top: 5px; width: 110px;"></div>
            </td> --%>
        </tr>
    </table>
    <div style="margin-bottom: 10px; margin-left: 64px;">
    	<input id="selectImgBtn" type="button" class="button-default-2" style="width:100px;height:30px;font-size: 15px;" value="${ctp:i18n("privilege.menu.selectpic.label")}" />
    </div>
    <div class="align_right bg-advance-bottom" style="width: 100%">
        <input id="submitBtn" type="button" class="button-default_emphasize" style="width:64px;height:30px;margin-top: 6px;font-size: 15px" value="${ctp:i18n("common.button.ok.label")}" />
        &nbsp;&nbsp;<input id="cancelBtn" type="button" class="button-default-2" style="width:64px;height:30px;margin-top: 6px;margin-right: 20px;font-size: 15px" value="${ctp:i18n("common.button.cancel.label")}" />
    </div>
</body>
</html>