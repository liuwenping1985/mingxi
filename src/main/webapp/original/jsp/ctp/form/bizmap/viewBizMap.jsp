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
<title>业务导图显示</title>
<style>
.mapArea {
	background: #D6E0ED;
}

#container {
    position: absolute;
    overflow: hidden; 
    margin: auto;
    -webkit-box-shadow: 10px 10px 25px #ccc;
    -moz-box-shadow: 10px 10px 25px #ccc;
    box-shadow: 10px 10px 25px #ccc;
}
</style>
<script type="text/javascript"
  src="${path}/common/form/bizmap/viewBizMap.js${ctp:resSuffix()}"></script>
  <script type="text/javascript">
    //业务导图数据
    var bizMapAndItem = $.parseJSON('${ctp:escapeJavascript(bizMapAndItem)}');
    $(document).ready(function() {
        //判断图片是否加载完成，只有图片加载完成才回填数据
        //这里把图片加载完成后执行的代码放到加载图片之前是为了提前告诉浏览器 加载完图片后要干嘛，防止浏览器加载图片太快时
        //没有执行onload事件，特别是IE浏览器 
        crop_target.onload = function() {
            //布局设置的值
            var layoutMap = bizMapAndItem.layoutMap;
            //设置画布
            setCanvas(layoutMap.width,layoutMap.height);
            setImageSize();
            //设置热点区域并且绑定URL
            setHotspotArea(bizMapAndItem.bizMapItem,bizMapAndItem.layoutType);
        }
        
        //加载业务导图图片
        var _url = "";
        if(bizMapAndItem.attId){
            _url = _ctxPath + "/fileUpload.do?method=showRTE&fileId=" + bizMapAndItem.attId + "&type=image";
            $("#crop_target").show().attr("src",_url);
        }else{
            $("#crop_target").hide();
        }
    });
</script>
</head>
<body>
<c:if test="${param.srcFrom eq 'bizconfig'}">
    <div class="comp" comp="type:'breadcrumb',comptype:'location'"></div>
</c:if>
  <div id='layout' class="comp page_color margin_10 mapArea" comp="type:'layout'">
    <div class="layout_center mapArea" id="center" style="overflow: auto;">
      <%-- 画布区域 --%>
      <div id="container">
        <%-- 图片 --%>
        <img src="" id="crop_target" usemap="#Map" class="hidden" style="cursor:auto;"/>
        <map name="Map" id="Map"></map>
      </div>
    </div>
  </div>
</body>
</html>