<%--
 $Author: zhaifeng $
 $Rev: 509 $
 $Date:: 2015-01-09 #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%-- 业务导图制作 --%>
<title>${ctp:i18n('form.bizmap.create.label')}</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=bizMapManager"></script>
<script type="text/javascript" src="${path}/common/form/bizmap/createBizMap.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/js/ui/seeyon.ui.jcrop-debug.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/form/bizmap/croop.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/common/form/bizmap/drag.js${ctp:resSuffix()}"></script>
<style>
.form_croop_border {
	position: absolute;
	border: 1px #cdcdcd solid;
	background: #000;
	filter: alpha(opacity = 50);
	-moz-opacity: 0.5;
	opacity: 0.5;
	z-index: 300;
}

.mapArea {
	background: #D6E0ED;
}

#container {
	position: absolute;
	top: 10px; 
    left : 10px;
    overflow: hidden; 
    margin: auto;
	-webkit-box-shadow: 10px 10px 25px #ccc;
	-moz-box-shadow: 10px 10px 25px #ccc;
	box-shadow: 10px 10px 25px #ccc;
}

#coor {
	width: 10px;
	height: 10px;
	overflow: hidden;
	cursor: move;
	position: absolute;
	right: 0;
	bottom: 0;
    z-index:20001;
	background-color: #09C;
}
</style>
</head>
<script type="text/javascript">
    //新建、编辑标志位
    var isEditData = "${isEditData}";
    //业务导图数据
    var _bizMapAndItem;
    if ("true" == isEditData) {
        _bizMapAndItem = $.parseJSON('${ctp:escapeJavascript(bizMapAndItem)}');
    }
    //工作区宽度
    var _wWidth = "${width}";
    var _wHeight = "${height}";
    $(document).ready(
            function() {
                //初始化工具栏
                initToolbar();
                //编辑时回填数据
                if ("true" == isEditData) {
                    //将onload事件提前，告诉浏览器在图片加载完成之后要执行的操作，防止浏览器加载图片太快，不执行onload
                    //判断图片是否加载完成，只有图片加载完成才回填数据
                    crop_target.onload = function() {
                        if(_bizMapAndItem.layoutType == "2"){
                            $("#coor").show();
                            //初始化 设置画布拖拽功能
                            dragBizMapArea(false,true);
                        }else{
                            $("#coor").hide();
                        }
                        //布局设置的值
                        var layoutMap = _bizMapAndItem.layoutMap;
                        //设置画布大小
                        setCanvasForEdit(layoutMap.width,layoutMap.height);
                        CROOPOBJ.IMAGEOBJ.width = layoutMap.imageW;
                        CROOPOBJ.IMAGEOBJ.height = layoutMap.imageH;
                        //设置图片大小
                        setImageAreaSize();
                        //栏目布局时，重置画布高度，处理对布局进行拖拽调整高度的情况
                        if(_bizMapAndItem.layoutType == "2"){
                            $('#container').height(layoutMap.height);
                        }
                        //设置热点
                        initDataForEdit(_bizMapAndItem,true);
                        //设置是否存在热点属性
                        CROOPOBJ.isExistsHot = checkSetHot();
                    }
                    // 加载业务导图图片
                    $("#crop_target").show().attr("src",
                            _ctxPath + "/fileUpload.do?method=showRTE&fileId=" + _bizMapAndItem.attId + "&type=image");
                }else{
                    //弹出布局设置
                    settingLayout();
                }
            });
</script>
<body>
  <div id='layout' class="comp page_color margin_10" comp="type:'layout'">
    <div class="layout_north" id="north" layout="height:40,sprit:false,border:false">
      <div id="toolbar"></div>
    </div>
    <div class="layout_center mapArea" id="center" style="overflow:auto;">
      <%-- 上传附件  控件隐藏 --%>
      <input id="myfile" type="hidden" class="comp hidden"
        comp="type:'fileupload',applicationCategory:'1',extensions:'jpg,jpeg,png,bmp,gif',maxSize:2097152,quantity:1,isEncrypt:false,firstSave:true,attachmentTrId:'bizMapImage',callMethod:'callBk'">
      <%-- 画布区域 --%>
      <div id="container" class="hidden">
        <%-- 图片 --%>
        <img src="" id="crop_target" alt="" class="hidden" />
        <div id="coor" class="hidden"></div>
      </div>
    </div>
  </div>
</body>
</html>