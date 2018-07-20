<%--
 $Author: wuym $
 $Rev: 1291 $
 $Date:: 2012-10-13 11:15:53#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>I18n测试</title>
<script type="text/javascript">
  $(function() {
    alert($.i18n('common.button.cancel.label'));
    alert($.i18n('common.button.close.label', 'test'));
  });
</script>
</head>
<body leftmargin="0" topmargin="" marginwidth="0" marginheight="0">
<% request.setAttribute("myDate", new java.util.Date());%>
${ctp:formatDate(myDate)},
${ctp:formatDateTime(myDate)},
${ctp:formatDateByPattern(myDate, 'yyyy')}
    <table border="1" width="500">
        <tr>
            <td>描述</td>
            <td>取值</td>
        </tr>
        <tr>
            <td>ctp:i18n函数</td>
            <td>${ctp:i18n('common.button.add.label')}</td>
        </tr>
        <tr>
            <td>ctp:i18n_1函数，一个参数，变量参数</td>
            <td>${ctp:i18n_1('common.charactor.limit.label',path)}</td>
        </tr>
        <tr>
            <td>ctp:i18n_1函数，一个参数，数值参数</td>
            <td>${ctp:i18n_1('common.charactor.limit.label',10)}</td>
        </tr>
        <tr>
            <td>ctp:i18n_1函数，一个参数，字符串参数</td>
            <td>${ctp:i18n_1('common.charactor.limit.label','测试')}</td>
        </tr>
        <tr>
            <td>ctp:i18n_2函数，两个参数</td>
            <td>${ctp:i18n_2('common.charactor.limit.label','测试',3)}</td>
        </tr>
        <tr>
            <td>ctp:i18n_3函数，三个参数</td>
            <td>${ctp:i18n_3('common.charactor.limit.label','测试',3,3)}</td>
        </tr>
        <tr>
            <td>ctp:i18n_4函数，四个参数</td>
            <td>${ctp:i18n_4('common.charactor.limit.label','测试',3,3,3)}</td>
        </tr>
        <tr>
            <td>ctp:i18n_5函数，五个参数</td>
            <td>${ctp:i18n_5('common.charactor.limit.label','测试',3,3,3,3)}</td>
        </tr>
    </table>
</body>
</html>
