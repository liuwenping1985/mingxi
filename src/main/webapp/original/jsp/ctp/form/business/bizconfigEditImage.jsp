<%--
  Created by IntelliJ IDEA.
  User: wangh
  Date: 2016/3/9
  Time: 20:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" isELIgnored="false" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
    <title>编辑图片</title>
</head>
<body class="page_color font_size12">
<form method="post" action="" >
    <div style="width:400px;height: 280px;overflow-y: auto;">
        <c:forEach items="${imageList}" var="image" varStatus="status">
            <div class="left margin_l_10 margin_t_10" onclick="selectImg(this)" value="${image}" style="width: ${width}px;height: ${height}px;cursor: pointer;position: relative;" id="system${status.index}">
                <img src="/seeyon/common/form/bizconfig/images/${image}" width="${width}" height="${height}">
                <div name="selectedIcon" style="z-index: 9999;position: absolute;right: 2px;bottom: 2px;" class="hidden"><span class="ico16 gone_through_16"></span></div>
            </div>
        </c:forEach>
        <div id="uploadDiv" class="left margin_l_10 margin_t_10" id="container" class="border_all" style="width: ${width}px;height: ${height}px;">
            <span id="uploadImg" class="ico16 g6_add_16"></span>
        </div>
    </div>
    <div id="uploadList" class="hidden"></div>
    <div id="dyncid"></div>
</form>
</body>
</html>
<script>
    var dialogArgs = window.dialogArguments;
    var pWin = dialogArgs.win;//父窗口
    var PId = dialogArgs.id;//编辑图片的窗口id
    var fileIds = dialogArgs.fielId;
    var selectedImg = dialogArgs.selectedImg;
    var currentImage = "";
    $(document).ready(function() {
        $("#uploadImg").click(function(){
            uploadImgFun();
        });
        if(fileIds){
            for(var i = 0,len = fileIds.length;i<len;i++){
                showImage(fileIds[i]);
            }
        }
        //进来的时候，默认勾选穿过来的图片
        if(selectedImg){
            var selectDiv = $("div[value='"+selectedImg+"']");
            if(selectDiv && selectDiv.length>0){
                $("div[name='selectedIcon']",selectDiv).removeClass("hidden");
                currentImage = $(selectDiv).attr("id");
            }
        }
    });
    //选择图片
    function selectImg(obj){
        $("div[name='selectedIcon']").hide();
        $("div[name='selectedIcon']",obj).show();
        currentImage = $(obj).attr("id");
    }
    function OK(){
        if(!currentImage){
            $.alert("请选择图片");
            return false;
        }
        var obj = {};
        var imageId = $("#"+currentImage).attr("value");
        var custom = currentImage.indexOf("system")>-1?1:2;
        obj.imageId= imageId;
        obj.custom = custom;
        obj.uploadImgs = getUploadList();
        return obj;
    }
    //上传图片
    function uploadImgFun(){
        dymcCreateFileUpload("dyncid", "1", "gif,jpg,jpeg,png,bmp", "1", false, 'imageCallback', null, true, true, null, true, false, '${fileSize}');
        insertAttachment();
    }
    //回调函数
    function imageCallback(attr){
        showImage(attr.get(0).fileUrl);
        uploadList(attr.get(0).fileUrl);
        $("#attachmentArea").hide();//隐藏图片下面的垃圾回收站的图标
        //上传后选中当前图标
        var div = $("div[value='"+attr.get(0).fileUrl+"']");
        selectImg(div);
    }
    //添加到uploadList中
    function uploadList(fileId){
        var container = $("#uploadList");
        container.append($('<input type="hidden" name="uploadImg" value="'+fileId+'" />'));
    }
    //获取uploadList中已上传的图片
    function getUploadList(){
        var obj = [];
        $("input[name='uploadImg']","#uploadList").each(function(){
            obj.push($(this).val());
        });
        return obj;
    }
    function showImage(fileId){
        var url1 = '/fileUpload.do?method=showRTE&fileId=' + fileId + '&type=image';
        var path = _ctxServer;
        var url = " ";
        var uploadDiv = $("#uploadDiv");
        url = url + path + url1;
        var newImg = $('<div id="upload'+fileId+'" value="'+fileId+'" onclick="selectImg(this)" class="left margin_l_10 margin_t_10" style="width: ${width}px;height:${height}px;cursor: pointer;position:relative"></div>');
        newImg.append($('<img src="'+url+'" width="${width}" height="${height}"/>'));
        newImg.append($('<div name="selectedIcon" style="z-index: 9999;position: absolute;right: 2px;bottom: 2px;" class="hidden"><span class="ico16 gone_through_16"></span></div>'));
        uploadDiv.before(newImg);
    }
</script>
