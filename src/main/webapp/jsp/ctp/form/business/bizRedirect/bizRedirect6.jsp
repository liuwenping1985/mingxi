<%--
 $Author: wusb $
 $Rev: 603 $
 $Date:: 2012-09-18

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="bizRedirectUtil.jsp"%>
<html style="width: 100%;height: 100%;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>业务重定向</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=businessManager,formTriggerDesignManager"></script>
<!-- 工具方法 -->
<script>
var resultObj = {};
var currentTriggerSet;
var currentRow;
var redirectJSON;
var o = new formTriggerDesignManager();
/**
 * 切换页签回掉函数,返回obj 对象
 * obj.complateRedirect 是否完成当前页面所有重定向
 * obj.bizObj 当前页面返回的 json 对象
 */
function getResultJSON(){
  resultObj.complateRedirect = redirectGrid.checkRedirectRight();
  resultObj.bizObj = redirectGrid.getResultJSON();
  return resultObj;
}
var redirectGrid;
$(document).ready(function(){
  redirectJSON = parent.getData();
  resultObj.complateRedirect = false;
  resultObj.bizObj = redirectJSON;
  var redirectJSON = $.parseJSON(redirectJSON);
  redirectGrid = new RedirectGrid({data:redirectJSON,headType:1});
    parent.window.endLoadingData();
});

    function redirectDee(obj){

    }

</script>
</head>
<body style="width: 100%;height: 100%">
</body>
</html>