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
<%@ include file="/WEB-INF/jsp/ctp/form/business/bizRedirect/bizRedirectUtil.jsp"%>
<html style="width: 100%;height: 100%;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>业务重定向</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=businessManager"></script>
</head>
<body style="width: 100%;height: 98%">

<!-- 工具方法 -->
<script>
var grid;
$(function(){
  var currentJSON = parent.getData();
  var beanList = $.parseJSON(currentJSON);
  grid = new RedirectGrid({
    data:beanList
  });
    parent.window.endLoadingData();
})

/**
 * 切换页签回掉函数,返回obj 对象
 * obj.complateRedirect 是否完成当前页面所有重定向
 * obj.bizObj 当前页面返回的 json 对象
 */
function getResultJSON(){
  var obj = {};
  obj.complateRedirect = grid.checkRedirectRight();
  obj.bizObj = getGridResult();
  return obj;
}

function getGridResult(){
  return $.toJSON($("body").formobj());
}
</script>
</body>
</html>