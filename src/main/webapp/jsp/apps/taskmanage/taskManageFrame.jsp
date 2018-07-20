<%--
 $Author:  xiangq$
 $Rev:  280$
 $Date:: 2012-12-26 14:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>任务管理</title>
<style>
.stadic_head_height {
    height: 30px;
}

.stadic_body_top_bottom {
    bottom: 0px;
    top: 30px;
}
</style>
<script type="text/javascript">
    var layout;
    function initIframeUrl () {
        $("#navigation_iframe").attr("src", _ctxPath + "/taskmanage/taskinfo.do?method=navigation");
    }
    $(document).ready(function() {
        layout = $('#layout').layout();
        initIframeUrl();
    });
</script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_center over_hidden" layout="border:false">
            <iframe id="list_iframe" name="list_iframe" width="100%" height="100%" src="" frameborder="no" border="0"></iframe>
        </div>
        <div class="layout_west over_hidden" layout="width:180,minWidth:170,maxWidth:300,spiretBar:{show:true,handlerL:function(){layout.setWest(0);},handlerR:function(){layout.setWest(200);}}">
            <iframe src="" id="navigation_iframe" width="100%" height="100%" frameborder="0"></iframe>
        </div>
    </div>

</body>
</html>
