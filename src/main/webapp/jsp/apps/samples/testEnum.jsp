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
<title>Enum测试</title>
<script type="text/javascript">
  $(function() {
    alert('javascript枚举值显示：' + enu.MainbodyType.html);
  });
</script>
</head>
<body leftmargin="0" topmargin="" marginwidth="0" marginheight="0">
EL枚举值显示（enu.MainbodyType.html）：${enu.MainbodyType.html}
</body>
</html>
