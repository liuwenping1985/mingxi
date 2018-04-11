<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../header.jsp"%>
<html:link renderURL='/message.do' var='messageURL' />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body scroll="no" onload="setDefaultTab(0);">
  <table width="100%" height="100%" cellspacing="0" cellpadding="0" border="0">
    <tr>
      <td valign="bottom" height="26" style="height:30px;">
          <div class="tab-separator"></div>
          <div id="menuTabDiv" class="div-float">
          <c:forEach items="${allTypes}" var="t">
            <div class="tab-tag-left"></div>
            <c:choose>
              <c:when test="${v3x:currentUser().admin && t.name !='wechat' && (t.name !='email' || v3x:hasPlugin('webmail'))}">
                <div class="tab-tag-middel" onclick="javascript:changeMenuTab(this);" url="${messageURL}?method=showMessageSettingDetail&messageType=${t.name}&fromModel=${param.fromModel}">${t.showName}</div>
              </c:when>
              <c:when test="${!v3x:currentUser().admin && (t.name !='email' || v3x:hasPlugin('webmail'))}">
                <div class="tab-tag-middel" onclick="javascript:changeMenuTab(this);" url="${messageURL}?method=showMessageSettingDetail&messageType=${t.name}&fromModel=${param.fromModel}">${t.showName}</div>
              </c:when>
            </c:choose>
            <div class="tab-tag-right"></div>
            <div class="tab-separator"></div>
          </c:forEach>
          </div>
      </td>
    </tr>
    <tr>
      <td valign="top" width="100%" height="100%">
        <iframe width="100%" height="100%" id="detailIframe" frameborder="0" src="" />
      </td>
    </tr>
  </table>
</body>
</html>