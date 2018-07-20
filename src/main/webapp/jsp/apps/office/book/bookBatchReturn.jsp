<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
</head>
<body scroll="no">
  <div id="batchApproval" class="form_area">
    <table border="0" cellspacing="0" cellpadding="0" width="100%" height="100%" class="font_size12 margin_t_10">
      <tr>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <th noWrap="nowrap" align="right">&nbsp;</th>
        <th noWrap="nowrap" align="right" width="60">${ctp:i18n('office.book.bookInfoDetail4Remand.pghsj.js') }:</th>
        <td>
          <div id="lendDateDiv" class="common_txtbox_wrap">
            <input id="rebackDate" name="rebackDate" type="text" class="validate" validate="name:'归还时间',notNull:true"
               readonly="readonly" style="width: 98%" value="${nowReturnTime}" />
          </div>
        </td>
        <td><a class = 'calendar_icon' id="calendar" href="javascript:showTime('calendar')"></a></td>
        <script type="text/javascript">
                  function showTime(id) {
                    $.calendar({
                      displayArea : id,
                      position:[200,0],
                      returnValue : true,
                      date : new Date(),
                      onUpdate : changeTime,
                      autoShow : true,
                      minuteStep:5,
                      ifFormat : "%Y-%m-%d %H:%M",
                      daFormat : "%Y-%m-%d %H:%M",
                      showsTime : true,
                      isClear : true
                    });
                  }

                  function changeTime(date) {
                    var input1 = document.getElementById("rebackDate");
                    input1.value = date;
                  }
        </script>
        <td align="left" nowrap="nowrap">&nbsp;</td>
      </tr>
    </table>
  </div>
</body>
<script type="text/javascript">
  function OK() {
    var validate = $("#lendDateDiv").validate();
    if (!validate) {
      return false;
    }
    var obj = {};
    obj.rebackDate = $("#rebackDate").val();
    return obj;
  }
</script>
</html>