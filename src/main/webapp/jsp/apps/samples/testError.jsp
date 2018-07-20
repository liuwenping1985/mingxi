<%--
 $Author: wuym $
 $Rev: 272 $
 $Date:: 2012-07-25 00:21:34#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>异常处理测试</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=testBS"></script>
<script type="text/javascript">
  $().ready(function() {
    $("#alertbtn").click(function() {
      window.location = 'test.do?method=talert';
    });
    $("#errorbtn").click(function() {
      window.location = 'test.do?method=terror';
    });
    $("#ajax_alertbtn").click(function() {
      var tesBS = new testBS();
      tesBS.testAlert({
        success : function(s) {
          alert(s);
        }
      });
    });
    $("#ajax_errorbtn").click(function() {
      var tesBS = new testBS();
      tesBS.testError({
        success : function(s) {
          alert(s);
        }
      });
    });
  });
</script>
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
    <input id="alertbtn" type="button" value="提示型异常" autoDisable="false">
    <input id="errorbtn" type="button" value="错误型异常" autoDisable="false">
    <input id="ajax_alertbtn" type="button" value="Ajax提示型异常" autoDisable="false">
    <input id="ajax_errorbtn" type="button" value="Ajax错误型异常">
</body>
</html>
