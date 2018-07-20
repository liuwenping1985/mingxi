<%--
 $Author: wuym $
 $Rev: 3856 $
 $Date:: 2013-01-18 14:48:46#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>Crypt测试</title>
<script type="text/javascript">
  $(function() {
    var s = "wuyumin wysiwyg好吧!@#$%^&*()[]{}\\/?><;'\"";
    var us = CryptoJS.enc.Utf8.parse(s);
    var encrypted = CryptoJS.DES.encrypt(us, "Secret Passphrase");
    alert(encrypted);
    $("#encstr").val(encrypted);

    encrypted = 'U2FsdGVkX18/8jDBbVGGhLf6BnwmkJSE';
    var st = new Date().getTime();
    for(var i=0;i<1000;i++) {
    var decrypted = CryptoJS.DES.decrypt(encrypted, "Secret Passphrase");
    
    var dus = CryptoJS.enc.Utf8.stringify(decrypted);
    }
    alert(new Date().getTime() - st);
    //alert(dus);
 
  });
</script>
</head>
<body leftmargin="0" topmargin="" marginwidth="0" marginheight="0">
<input id="encstr" type="text">
</body>
</html>
