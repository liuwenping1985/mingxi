<%--
 $Author: lilong $
 $Rev: 13618 $
 $Date:: 2013-01-30 14:37:22#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/privilege/resource/resourceTree_js.jsp"%>
<html>
<head>
</head>
<body  class="w100b h100b" style="background-color: #ffffff;">
<div style="margin-left: 20px;margin-right: 20px;width: 410px;min-height:400px;background:#fff;">
  <table>
    <tr>
       <td><input type="button" value="${ctp:i18n('privilege.resource.expandAll.button')}" id="expandAllBtu" style="display:none;"></td>
       <td><input type="button" value="${ctp:i18n('privilege.resource.foldAll.button')}" id="foldAllBtu" style="display:none;"></td> 
       <%-- <td><input type="button" value="${ctp:i18n('privilege.resource.selectAll.button')}" id="selectAllBtu" style="display:none;"></td> 
       <td><input type="button" value="${ctp:i18n('privilege.resource.selectNot.button')}" id="selectNotBtu" style="display:none;"></td> --%>
       <td><input type="button" value="${ctp:i18n('privilege.resource.confirm.button')}" id="confirmBtu" style="display:none;"></td>
       <td><input type="button" value="${ctp:i18n('resource.all.show')}" id="showAllBtu"></td>
       <td><input type="button" value="${ctp:i18n('resource.selected.show')}" id="showSelectBtu"></td>        
    </tr>
  </table>
  
  <div id="treeback"></div>
 
  <div id="treefront"></div>
</div>
</body>
</html>
