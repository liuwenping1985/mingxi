<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
</head>
<body scroll="no">
  <div id="batchApproval" class="form_area">
    <table border="0" cellspacing="0" cellpadding="0" width="100%" height="100%" class="font_size12 margin_t_10">
      <tr>
        <td>
          <table border="0" cellspacing="0" cellpadding="0" width="95%">
            <tr height="40">
              <td width="20" class="padding_t_10">&nbsp;</td>
              <td align="left" width="90" class="padding_t_10">${ctp:i18n('office.book.bookInfoDetail4Audit.pspyj.js') }：</td>
            </tr>
            <tr height="100">
              <td width="20" class="padding_t_10">&nbsp;</td>
              <td width="300" class="padding_t_10">
                <div>
                  <textarea name="auditOpinion" class="validate font_size12" id="auditOpinion" style="width: 400px; height: 100px;"
                    validate="maxLength:800,name:'${ctp:i18n('office.book.bookInfoDetail4Audit.pspyj.js') }'"></textarea>
                </div>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </div>
</body>
<script type="text/javascript">
  function OK() {
    var obj = {};
    var validate = $("#batchApproval").validate();
    if (!validate) {
      obj.vali = "false";
      return obj;
    } else {
      obj.vali = "true";
      obj.approvalText = $("#auditOpinion").val();
      return obj;
    }

  }
</script>
</html>