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
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ctp:i18n('calendar.event.list.cancel.event.client')}</title>
<script type="text/javascript" src="${path}/apps_res/calendar/js/entrust_CalEvent.js${ctp:resSuffix()}"></script>
</head>
<body>
  <div class="form_area margin_10">
    <form id="entrustSaveCalEvent" action="calEvent.do?method=entrustSaveCalEvent" method="post">
      <table>
        <tr>
          <td><h3 class="font-bold">${ctp:i18n('calendar.event.list.cancel.event.client')}</h3></td>
        <tr>
          <td>
            <fieldset style="height: 150px; width: 300px;">
              <legend>${ctp:i18n('calendar.event.list.cancel.event.client')}</legend>
              <div style="height: 140px;overflow: auto;">
                <table style="width:95%">
                  <c:forEach items="${calEvents}" var="calEvent" varStatus="status">
                    <tr>
                      <td>${status.count }</td>
                      <td style="width:90%">${ctp:toHTML(calEvent.subject) }
                          <input name="createUserId" type="hidden" value="${calEvent.createUserId}" /> 
                          <input name="states" type="hidden" value="${calEvent.states}" />
                          <input name="id" type="hidden" value="${calEvent.id}" />
                      </td>
                    </tr>
                  </c:forEach>
                </table>
              </div>
            </fieldset>
          </td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>
              <label class=margin_r_5>${ctp:i18n('calendar.event.list.cancel.event.authorized.person')}</label>
              <DIV class=common_txtbox_wrap>
                  <input type="text" id="receiveMemberName" style="font-size: 12px;" name="receiveMemberName" class="validate hand" validate='type:"string",notNull:true' value="${ctp:i18n('calendar.event.create.person')}" onclick="selectPerson();" /> 
                  <input id="receiveMemberId" name="receiveMemberId" type="hidden" />
              </DIV>
          </td>
        </tr>
      </table>
    </form>
  </div>
  <input type="hidden" id="curUserID" name="curUserID" value="${CurrentUser.id}"/>
</body>
</html>