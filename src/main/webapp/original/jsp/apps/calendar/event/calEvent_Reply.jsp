<%--
 $Author: xiongfeifei $
 $Rev: 1783 $
 $Date:: 2012-10-30 15:17:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title></title>
</head>
<body style="overflow-x: hidden;">
  <div id="eventReply" class="form_area margin_10">
    <p class="margin_b_5">
      ${ctp:i18n("calendar.event.create.reply.event")}${ctp:i18n("calendar.event.create.reply")}
    </p>
    <ul border="1" id="replyInfo" name="replyInfo" class="w100b border_all"
      style="height: 250px; overflow: auto;">
      <c:forEach var="calReply" items="${replyList}">
        <li>
          <p class="margin_5">
            <a href="javascript:void(0)" style="cursor:default"> ${calReply.replyUserName}
              (${ctp:formatDateByPattern(calReply.replyDate,'MM-dd HH:mm')}) </a>
          </p>
          <div class="margin_l_10">${ctp:toHTML(calReply.replyInfo)}</div>
        </li>
      </c:forEach>
    </ul>
  </div>
</body>
</html>