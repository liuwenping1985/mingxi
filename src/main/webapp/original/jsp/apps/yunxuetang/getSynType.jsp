<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
</head>
<body scroll="no">
  <table id="synType" border="0" cellspacing="0" cellpadding="0" width="100%" height="100%" class="font_size12 margin_t_10">
    <tr>
      <td>
        <table border="0" cellspacing="0" cellpadding="0" width="95%">
          <tr height="40">
            <td width="10" class="padding_t_10">&nbsp;</td>
            <td align="right" width="90" class="padding_t_10">${ctp:i18n('yunxuetang.getSynType.choose.js')}</td>
            <td width="300" class="padding_t_10"><form>
                <input id="clean" type="radio" value="cleanBeforeSyn" name="synType" checked="checked">${ctp:i18n('yunxuetang.getSynType.method.0.js')} <input id="noClean" type="radio" value="noCleanSyn" name="synType">${ctp:i18n('yunxuetang.getSynType.method.1.js')}
              </form></td>
            <td width="10" class="padding_t_10">&nbsp;</td>
          </tr>
          <tr height="40">
            <td width="10" class="padding_t_10">&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
<script type="text/javascript">
  function OK() {
    var validate = $("#synType").validate();
    if (!validate) {
      return false;
    }
    var obj = {};
    if ($("#clean").attr("checked")) {
      obj.type = $("#clean").val();
    }else{
      obj.type = $("#noClean").val();
    }
    return obj;
  }
</script>
</html>