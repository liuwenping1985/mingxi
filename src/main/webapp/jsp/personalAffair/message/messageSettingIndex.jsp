<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<html:link renderURL='/message.do' var='messageURL' />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
</head>
<body scroll="no">
  <table width="100%" height="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
      <td valign="bottom" height="26">
        <div class="div-float">
          <c:forEach items="${allTypes}" var="t">
            <div class="tab-separator"></div>
            <div class="tab-tag-left${messageType eq t.name? '-sel':''}"></div>
            <c:if test="${t.name !='email' || (v3x:getSysFlagByName('email_notShow')!='true')}">
            	<div class="tab-tag-middel${messageType eq t.name? '-sel':''} cursor-hand" style="border-bottom: none;" onclick="javascript:location.href='${messageURL}?method=showMessageSetting&messageType=${t.name}&fromModel=${param.fromModel}'">${t.showName}</div>
            </c:if>
            <div class="tab-tag-right${messageType eq t.name? '-sel':''}"></div>
          </c:forEach>
          <div class="tab-separator"></div>
        </div>
      </td>
    </tr>
    <tr>
      <td valign="top" width="100%" height="100%" class="border-top border-bottom border-left border-right">
        <iframe width="100%" height="100%" id="bulletinFrame" frameborder="0" src="${messageURL}?method=showMessageSettingDetail&messageType=${messageType}&fromModel=${param.fromModel}" />
      </td>
    </tr>
  </table>
</body>
</html>