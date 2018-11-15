<%--
 $Author: dengcg $
 $Rev: 509 $
 $Date:: 2013-01-07 00:08:40#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>${ctp:i18n('form.flow.show')}</title>
</head>
<body>
 <table class="margin_t_5 font_size12" width="100%" height="100%">
 <c:if test="${formtype eq enu.Enums$FormType.baseInfo}">
 <tr >
 <td height="40" align="right" width="20%"><label >${ctp:i18n('form.query.querylistdatafield.label')}:</label></td>
 <td height="20%" width="80%"><input type="text" id=showFields name=showFields readonly="readonly" disabled="disabled" value="${showFields}" style="width: 95%" /></td>
 </tr>
 <tr>
 <td height="40" align="right" width="20%"><label>${ctp:i18n('form.query.queryresultsort.label')}:</label></td>
 <td height="20%" width="80%"><input type="text" id=order name=order readonly="readonly"  disabled="disabled" value="${orderFields}" style="width: 95%"/></td>
 </tr>
 <tr>
 <td height="40" align="right" width="20%"><label>${ctp:i18n('form.query.useroperauth.label')}:</label></td>
 <td height="20%" width="80%"><input type="text" id=power name=power readonly="readonly" disabled="disabled" value="${power}" style="width: 95%"/></td>
 </tr>
 </c:if>
 <c:if test="${formtype eq enu.Enums$FormType.manageInfo}">
 <tbody>
 <c:forEach items="${templateList}" var="template">
 <tr>
 <td width="80%" align="center"><input type="text" disabled="disabled" readonly="readonly" value="${template.name }" style="width: 95%"/></td>
 </tr>
 </c:forEach>
 </tbody>
 </c:if>
 </table>
</body>
</html>