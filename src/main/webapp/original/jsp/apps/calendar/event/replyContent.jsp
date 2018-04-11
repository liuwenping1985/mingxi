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
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ctp:i18n("calendar.event.create.reply")}${ctp:i18n("calendar.event.create.reply.event")}</title>
<script type="text/javascript">
  var parentWindowData = window.dialogArguments;
  function OK(obj) {
    var fValidate = $("#createCalReply").validate();
    if (fValidate) {
      if(obj.dialogObj) {
        obj.dialogObj.disabledBtn("sure");
      }
      var toReplyDate = $("#replyDate").val();
      $("#replyDate").val($("#replyDateVal").val());
      $("#createCalReply")
          .jsonSubmit(
              {
                callback : function(res) {
                  var replyInfo = $("#replyInfo").val();
                  replyInfo = replyInfo.replace(/</g,"&lt").replace(/>/g,"&gt").replace(/\n/g,"<br/>");
                  fValidate = "<li><p class='margin_5'><a href='javascript:void(0)' style='cursor:default'>"
                      + $("#replyUserName").val()
                      + "("
                      + $("#replyDate").val()
                      + ")"
                      + "</a></p><div class='margin_l_10'>"
                      + replyInfo + "</div></li>";
                  parentWindowData.initReplyFunc(fValidate);
                }
              });
      $("#replyDate").val(toReplyDate);
    }
  }
</script>
</head>
<body>
  <div class="form_area margin_10">
    <form id="createCalReply" action="calReply.do?method=saveCalReply"
      method="post">
      <table width="100%">
        <tr>
          <td colspan="3">
            ${ctp:i18n("calendar.event.create.reply")}${ctp:i18n("calendar.event.create.reply.event")}
          </td>
        </tr>
        <tr>
          <td colspan="3"><textarea rows="12" class="validate w100b font_size12"
              style="resize: none;" name="replyInfo" id="replyInfo"
              validate='type:"string",name:"${ctp:i18n('calendar.event.create.reply')}${ctp:i18n('calendar.event.create.reply.event')}",notNull:true,notNullWithoutTrim:true,
              minLength:1,maxLength:1200'></textarea></td>
        </tr>
        <tr>
          <td colspan="3">${ctp:i18n("calendar.event.create.reply.max")}</td>
        </tr>
        <tr>
          <td colspan="3"><input id="replyOption" name="replyOption"
            checked type="checkbox">${ctp:i18n("calendar.event.create.reply.send.message")}
            <input type="hidden" id="eventId" name="eventId" value="${eventId }" />
            <input type="hidden" id="replyUserName" name="replyUserName"
            value="${CurrentUser.name}" /> <input type="hidden"
            id="replyUserId" name="replyUserId" value="${CurrentUser.id}" /> <input
            type="hidden" id="replyDate" name="replyDate"
            value="${ctp:formatDateByPattern(replyDate,'MM-dd HH:mm')}" /> <input
            type="hidden" id="replyDateVal" name="replyDateVal"
            value="${ctp:formatDateTime(replyDate)}" /></td>
        </tr>
      </table>
    </form>
  </div>
</body>
</html>