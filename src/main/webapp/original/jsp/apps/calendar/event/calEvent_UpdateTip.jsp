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
<title>${ctp:i18n('calendar.sure')}</title>
<script type="text/javascript">
  function OK() {
    a = $(".updateTip");
    for ( var i = 0; i < a.length; i++) {
      if (a[i].checked) {
        return a[i].value;
      }
    }
  }
</script>
</head>
<body>
  <DIV class="common_radio_box clearfix">
    <table>
      <tr>
        <td>&nbsp;</td>
        <td class="padding-left: 5px"><LABEL
          class="margin_t_5 hand display_block" for=radio1> <INPUT
            id=radio25 checked class="updateTip" name=option value="1"
            type=radio>${ctp:i18n('calendar.event.create.updateTip.cur')}
        </LABEL> <LABEL class="margin_t_5 hand display_block" for=radio2> <INPUT
            id=radio26 class="updateTip" name=option value="2" type=radio>${ctp:i18n('calendar.event.create.updateTip.all')}
        </LABEL></td>
      </tr>
    </table>
  </DIV>
</body>
</html>