<%--
 $Author: wuym $
 $Rev: 1907 $
 $Date:: 2012-11-04 21:55:26#$:
  
 Copyright (C) 2010 UFIDA, Inc. All rights reserved.
 This software is the proprietary information of CSI, Inc.
 Use is subject to license terms
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>AjaxPagingGrid测试</title>
<script language="javascript">
  $().ready( function() {
    $('#myajaxgridbar').ajaxgridbar( {
      managerName :'testPagingManager',
      managerMethod :'testPaging',
      callback : function(fpi) {
        alert($.toJSON(fpi));
      }
    });

    $('#myajaxgridbar').ajaxgridbarLoad(new Object());

  });
</script>
</head>
<body leftmargin="0" topmargin="" marginwidth="0" marginheight="0">
<div id="myajaxgridbar" align="right" class="number">
<a href="javascript:void(0);" id="_afpFirst">首&nbsp;页</a>
<a href="javascript:void(0);" id="_afpPrevious">上一页</a>
<a href="javascript:void(0);" id="_afpNext">下一页</a>
<a href="javascript:void(0);" id="_afpLast">末&nbsp;页</a>
&nbsp;&nbsp;第<span id="_afpPage">0</span>页/共<span id="_afpPages">0</span>页
&nbsp;&nbsp; 每页<span id="_afpSize">0</span>条/共<span id="_afpTotal">0</span>条
&nbsp;&nbsp;转到 <input id="_page_id" type=text class="anyPageNum" name="page" size="1" value="0" onmouseover="this.select();">
页<img id="_page_btn" align="absmiddle" src="${path}/resources/images/go.png" border="0" style="cursor: hand">
</div>
</body>
</html>
