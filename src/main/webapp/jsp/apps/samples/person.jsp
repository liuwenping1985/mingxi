<%--
 $Author: wuym $
 $Rev: 250 $
 $Date:: 2012-07-18 15:09:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common-debug.jsp"%>
<html>
<head>
<title>AjaxPagingGrid测试</title>
<script language="javascript">
  $().ready(function() {
    var time1 = new Date().getTime();
    $('#mygrid').ajaxgrid({
      bsName : 'a6UserManager',
      bsMethod : 'selectPerson'
    });
    var o = new Object();o.name="%";
    $('#mygrid').ajaxgridload(o);
    var time2 = new Date().getTime();
    //alert(time2-time1);
  });
</script>
</head>
<body leftmargin="0" topmargin="" marginwidth="0" marginheight="0">
    <table id="mygrid" cellpadding="2" cellspacing="1" width="100%">
        <thead>
            <tr>
                <th>&nbsp;</th>
                <th>序号</th>
                <th>登录名</th>
                <th>姓名</th>
            </tr>
        </thead>
        <tbody bgcolor="#FFFFFF">
            <tr style="display: none">
                <td><input type="checkbox" name="chkvalue" value="" align="center"></td>
                <td dataIndex="id" align="center"></td>
                <td dataIndex="username" align="center"></td>
                <td dataIndex="truename" align="center"></td>
            </tr>
        </tbody>
    </table>
    <%@ include file="/WEB-INF/jsp/common/ajaxFlipPageBar.jsp"%>
</body>
</html>
