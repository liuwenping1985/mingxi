<%--
 $Author: lilong $
 $Rev: 32817 $
 $Date:: 2014-01-20 16:45:37#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title></title>
<script>
  $(function() {
    var cmd = "${cmd}";
    if(cmd === "importresult"){
      var results = "${results}";
      $("#selectDiv").hide();
      $("#selectButton").hide();
      $("#resultLable").append(results);
    }
  });
  // 上传文件
  function resCallBack(fileid){
    // 处理文件逻辑的action
    location.href="privilege/resource.do?method=importResSubmit&fileid="+fileid;
  }
</script>
</head>
<body class="bg_color_gray font_size12">
<span id="selectDiv">
<br>
<br>
<input id="myfile" type="text" class="comp" comp="type:'fileupload', applicationCategory:'1', extensions:'xlsx'">
&nbsp;&nbsp;&nbsp;&nbsp;${ctp:i18n('resource.selected.file.click')}&nbsp;&nbsp;<input id="selectButton" class="common_button common_button_emphasize" type="button" value="${ctp:i18n('label.choose')}" onclick="insertAttachment('resCallBack');"/></span>

<label id="resultLable"></label>
</body>
</html>
