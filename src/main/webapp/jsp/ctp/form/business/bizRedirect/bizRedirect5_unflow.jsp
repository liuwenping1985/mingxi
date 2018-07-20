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
<style type="text/css">
.setLabel{
    width: 200px;
    text-align: right;
}

.setValue{
    width: 260px;
}

.operation{
}
</style>
<script type="text/javascript" src="${path}/ajax.do?managerName=businessManager"></script>
<script>
var resultObj = {};
var currentSet;

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

var redirectJSON;
var redirectGrid;
$(document).ready(function(){
  redirectJSON = parent.getData();
  resultObj.complateRedirect = false;
  resultObj.bizObj = redirectJSON;
  var redirectJSON = $.parseJSON(redirectJSON);
    redirectGrid = new RedirectGrid({data:redirectJSON,headType:2});
    parent.window.endLoadingData();
});



</script>
</head>
<body style="overflow: auto;">
</body>
</html>