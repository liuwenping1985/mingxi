<%--
 $Author: zhout $
 $Rev: 33650 $
 $Date:: 2014-03-07 16:43:47#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html style="overflow: hidden;">
<head>
<title>${ctp:i18n("personal.headImg.cuttingAndUpload")}</title>
<link href="${path}/main/personalHeadImg/jquery.Jcrop.min.css${ctp:resSuffix()}" rel="stylesheet" type="text/css"/>
<link href="${path}/common/skin/default/skin.css${ctp:resSuffix()}" rel="stylesheet" type="text/css"/>
<script src="${path}/main/personalHeadImg/jquery.Jcrop.min.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
var personalHeadImgManager = RemoteJsonService.extend({
  jsonGateway : "${path}/ajax.do?method=ajaxAction&managerName=personalHeadImgManager",
  persnalHeadImgCuttingAndSave: function(){
    return this.ajaxCall(arguments, "persnalHeadImgCuttingAndSave");
  },
  getSrcWidthAndHeight: function(){
	return this.ajaxCall(arguments, "getSrcWidthAndHeight");
  }
});
var cuttingManager = new personalHeadImgManager();

//剪切上传的参数
var cuttingParam = new Object();
//原始上传图片的fileId(fileUrl)
cuttingParam.originalImgFileId = null;
//用于显示头像的原始区域宽
cuttingParam.originalWidth = 0;
//用于显示头像的原始区域高
cuttingParam.originalHeight = 0;
//预览区域宽
cuttingParam.previewWidth = 104;
//预览区域高
cuttingParam.previewHeight = 104;
var source = "${source}";
if(source=="leaderWindow"){
	//预览区域宽
cuttingParam.previewWidth = 130;
//预览区域高
cuttingParam.previewHeight = 180;
}
//x轴坐标
cuttingParam.x = 0;
//y轴坐标
cuttingParam.y = 0;
//切面宽度
cuttingParam.w = 0;
//切面高度
cuttingParam.h = 0;
//图片格式/扩展名
cuttingParam.formatName = "JPG";

//原图上传时间
var originalImgCreateDate = "";

//jcrop对象
var jcropObject = null;

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

function hidePreview() {
  //preview.stop().fadeOut('fast');
}

function uploadCallBack(attachment){
  if(jcropObject != null){
	jcropObject.destroy();
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
		  var regionWH = 350;
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
		    bgColor : "#f5f5f5",
		    aspectRatio : 1
		  });
		  $(".jcrop-holder").css("margin-left", parseInt((regionWH - cuttingParam.originalWidth) / 2) + "px");
		  $(".jcrop-holder").css("margin-top", parseInt((regionWH - cuttingParam.originalHeight) / 2) + "px");
		  $(".jcrop-holder").css("top", "0px");
		  $(".jcrop-holder").css("left", "0px");
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
		  jcropObject.setSelect([x, y, x2, y2]);
		  cuttingParam.originalImgFileId = attachment.instance[0].fileUrl;
		  cuttingParam.formatName = attachment.instance[0].extension.toUpperCase();
		  originalImgCreateDate = (attachment.instance[0].createDate || attachment.instance[0].createdate);
	  }
  });  
}

$(document).ready(function() {
  dymcCreateFileUpload("myfile",13,"jpg,jpeg,png,gif",1,false,"uploadCallBack", "poi",true,true,null,false,true,5242880);
  
  $("#selectImgBtn").click(function() {
    //上传图片
    insertAttachmentPoi("poi");
  });

  $("#submitBtn").click(function() {
    if(cuttingParam.originalImgFileId != null) {
      if(cuttingParam.formatName == "GIF"){
    	transParams.parentWin.headImgCuttingCallBack(cuttingParam.originalImgFileId + "&createDate=" + originalImgCreateDate);
    	return;
      }
      if(cuttingParam.w == 0){
    	cuttingParam.x = 0;
    	cuttingParam.y = 0;
    	cuttingParam.w = cuttingParam.originalWidth;
    	cuttingParam.h = cuttingParam.originalHeight;
      }
      cuttingParam.source = "${source}";
	  cuttingManager.persnalHeadImgCuttingAndSave(cuttingParam, {
        success : function(cuttedHeadImgId){
          if(cuttedHeadImgId != null){
            transParams.parentWin.headImgCuttingCallBack(cuttedHeadImgId + "&createDate=" + originalImgCreateDate);
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
	  getCtpTop().headImgCuttingWin.close();
  });
  $("#headImgCutDialog_main_body", parent.document).css("overflow", "hidden");
  $("#headImgCutDialog_main_content", parent.document).css("overflow", "hidden");
  $("#headImgCutDialog_main_iframe_content", parent.document).css("overflow", "hidden");
});
</script>
</head>
<body style="font-size: 14px; overflow: hidden; height:500px;">
    <input id="myfile" type="hidden" />
    <table border="0" cellSpacing="0" cellPadding="0" style="margin-top: 40px; margin-left: 64px;">
        <tr>
            <td style="position: relative;"><div style="float:left; width: 350px; height:350px; text-align:center; background-color: #f5f5f5; border: 1px #e1e1e1; color: #aaaaaa" ><div id="headImgInstruction" style="margin-top: 155px">${ctp:i18n("personal.headImg.instruction")}</div></div><img id="originalImg" style="position:absolute; display:none; " /></td>
            <td valign="top">
            	 <c:choose>
                                        <c:when test="${source=='leaderWindow' }">
	                                        <div style="margin-left: 68px; margin-top: 0px; width: 130px; height: 180px; overflow: hidden;">
						                    	<img id="preview" src="${path}/apps_res/v3xmain/images/personal/pic.gif" style="width: 130px; height: 180px;">
						                	</div>
						                	<div style="margin-left: 68px; margin-top: 5px; width: 130px;">130*180px</div>
                                        </c:when>
                                        <c:otherwise>
                                           <div style="margin-left: 68px; margin-top: 0px; width: 104px; height: 104px; overflow: hidden;">
						                    	<img id="preview" src="${path}/apps_res/v3xmain/images/personal/pic.gif" style="width: 104px; height: 104px;">
						                	</div>
						                	<div style="margin-left: 68px; margin-top: 5px; width: 104px;">${ctp:i18n("personal.headImgPreview.instruction")}</div>
                                        </c:otherwise>
                                    </c:choose>
            
            	<c:if test="">
            		
            	</c:if>
                
            </td>
        </tr>
    </table>
    <div style="margin-top: 10px; margin-left: 64px;"><input id="selectImgBtn" type="button" class="button-default-2" style="width:100px;height:30px;font-size: 15px;" value="${ctp:i18n("privilege.menu.selectpic.label")}" /></div>
    <div class="align_right bg-advance-bottom" style="position: absolute; top: 460px; left: 0px; width: 100%">
        <input id="submitBtn" type="button" class="button-default_emphasize" style="width:64px;height:30px;margin-top: 6px;font-size: 15px" value="${ctp:i18n("common.button.ok.label")}" />&nbsp;&nbsp;<input id="cancelBtn" type="button" class="button-default-2" style="width:64px;height:30px;margin-top: 6px;margin-right: 20px;font-size: 15px" value="${ctp:i18n("common.button.cancel.label")}" />
    </div>
</body>
</html>