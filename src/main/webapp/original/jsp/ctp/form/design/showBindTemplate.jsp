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
<div id='layout' class="comp" comp="type:'layout'">
 <div class="layout_center" layout="border:false">
 <table width="100%" height="100%">
 <c:if test="${formtype eq enu.Enums$FormType.baseInfo}">
 <tr height="20%">
 <td align="right" width="20%"><label >${ctp:i18n('form.query.querylistdatafield.label')}:</label></td>
 <td width="80%"><input type="text" id=showFields name=showFields readonly="readonly" value="${showFields}" style="width: 95%" /></td>
 </tr>
 <tr height="20%">
 <td align="right" width="20%"><label>${ctp:i18n('form.query.queryresultsort.label')}:</label></td>
 <td width="80%"><input type="text" id=order name=order readonly="readonly" value="${orderFields}" style="width: 95%"/></td>
 </tr>
 <tr height="20%">
 <td align="right" width="20%"><label>${ctp:i18n('bizconfig.use.authorize.label')}:</label></td>
 <td width="80%"><input type="text" id=power name=power readonly="readonly" value="${power}" style="width: 95%"/></td>
 </tr>
 </c:if>
 <c:if test="${formtype eq enu.Enums$FormType.manageInfo}">
 <thead>
 <tr>
 <td width="80%" align="center"><label>${ctp:i18n('form.flow.show')}</label></td>
 </tr>
 </thead>
 <tbody>
 <c:forEach items="${templateList}" var="template">
 <tr>
 <td width="80%" align="center"><input type="text" readonly="readonly" value="${template.name }" style="width: 95%"/></td>
 </tr>
 </c:forEach>
 </tbody>
 </c:if>
 </table>
 </div>
 </div>
</body>
</html>