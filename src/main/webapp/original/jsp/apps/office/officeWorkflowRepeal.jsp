<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ctp:i18n('office.cancel.word.js')}</title>
<script type="text/javascript">
    $(function() {
       new inputChange($("#comment"), "${ctp:i18n('office.repeal.input.msg.js')}");
    });
	
    function OK() {
        var comment = $.trim($('#comment').val());
        if (comment == "" || comment.indexOf($.trim("${ctp:i18n('office.repeal.input.msg.js')}"))!=-1) {
            $.alert("${ctp:i18n('collaboration.cancel.workflow.tip')}");
            return false;
        }
        var length = comment.length;
        if (length > 100) {
            $.alert("${ctp:i18n('collaboration.cancel.workflow.tip.length')}" + length);
            return false;
        }
        return comment;
    }
</script>
</head>
<body scroll="no" class="page_color h100b over_hidden padding_l_5 padding_r_5" style="padding:0 26px;">
  <form name="commentForm" id="commentForm">
    <table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="30px" class="PopupTitle"><fmt:message key='col.repeal.comment' /></td>
      </tr>
      <tr>
        <td class="bg-advance-middel">
          <table width="100%" border="0" cellpadding="0" cellspacing="0" class="font_size12">
            <tr>
              <td height="100%">
                <textarea name="comment" id="comment" style="width: 100%; height: 140px;" inputName="${ctp:i18n('collaboration.common.workflow.revokePostscript')}"
                  class="validate font_size12" validate="type:'string',name:'${ctp:i18n('collaboration.common.workflow.revokePostscript')}',notNull:true,minLength:0,maxLength:100"></textarea>
                <span class="description-lable">${ctp:i18n('collaboration.common.workflow.100WordsOrLess')} </span>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </form>
</body>
</html>