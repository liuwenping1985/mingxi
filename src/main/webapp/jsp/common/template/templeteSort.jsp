<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script>
  var dialog = parent.sortdialog;
  dialog.disabledBtn('sortSubmit');
  function OK(){
    var oSelect = document.getElementById("templeteSelect");
    if(!oSelect) return false;
    var ids = new Array();
    for(var selIndex=0; selIndex<oSelect.options.length; selIndex++) {
       ids.push(oSelect.options[selIndex].value);
    }
    return ids;
  }
  
  function moveUp() {
    var oSelect = document.getElementById("templeteSelect");
    if (!oSelect || oSelect.options.length <= 1)
      return;
    dialog.enabledBtn('sortSubmit');
    //如果是多选------------------------------------------------------------------
    if (oSelect.multiple) {
      for ( var selIndex = 0; selIndex < oSelect.options.length; selIndex++) {
        if (oSelect.options[selIndex].selected) {
          if (selIndex > 0) {
            if (!oSelect.options[selIndex - 1].selected) {
              var textTemp = oSelect.options[selIndex - 1].text;
              var valueTemp = oSelect.options[selIndex - 1].value;
              oSelect.options[selIndex - 1].text = oSelect.options[selIndex].text;
              oSelect.options[selIndex - 1].value = oSelect.options[selIndex].value;
              oSelect.options[selIndex].text = textTemp;
              oSelect.options[selIndex].value = valueTemp;
              oSelect.options[selIndex - 1].selected = true;
              oSelect.options[selIndex].selected = false;
            }
          }
        }
      }
    }
    //如果是单选--------------------------------------------------------------------
    else {
      var selIndex = oSelect.selectedIndex;
      if (selIndex <= 0)
        return;
      oSelect.options[selIndex].swapNode(oSelect.options[selIndex - 1]);
    }
  }

  /**
   * select使选中的项目下移
   */
  function moveDown() {
    var oSelect = document.getElementById("templeteSelect");
    if (!oSelect || oSelect.options.length <= 1)
      return;
    dialog.enabledBtn('sortSubmit');
    var selLength = oSelect.options.length - 1;
    //如果是多选------------------------------------------------------------------
    if (oSelect.multiple) {
      for ( var selIndex = oSelect.options.length - 1; selIndex >= 0; selIndex--) {
        if (oSelect.options[selIndex].selected) {
          if (selIndex < selLength) {
            if (!oSelect.options[selIndex + 1].selected) {
              var textTemp = oSelect.options[selIndex + 1].text;
              var valueTemp = oSelect.options[selIndex + 1].value;
              oSelect.options[selIndex + 1].text = oSelect.options[selIndex].text;
              oSelect.options[selIndex + 1].value = oSelect.options[selIndex].value;
              oSelect.options[selIndex].text = textTemp;
              oSelect.options[selIndex].value = valueTemp;
              oSelect.options[selIndex + 1].selected = true;
              oSelect.options[selIndex].selected = false;
            }
          }
        }
      }
    }
    //如果是单选--------------------------------------------------------------------
    else {
      var selIndex = oSelect.selectedIndex;
      if (selIndex >= selLength - 1)
        return;
      oSelect.options[selIndex].swapNode(oSelect.options[selIndex + 1]);
    }
  }
</script>
</head>
<body scroll="no" style="overflow: hidden">
  <table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td class="bg-advance-middel">
        <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="90%">
                <select id="templeteSelect" multiple="multiple" size="16" style="width: 254px;">
                <c:forEach items="${templeteList}" var="myTemplete">
                  <option value="${myTemplete.id}">${v3x:toHTML(myTemplete.subject)}</option>
                </c:forEach>
                </select>
            </td>
            <td width="10%" align="center">
              <p>
                <span class="ico16 sort_up" onClick="moveUp()"></span>
              </p>
              <p>
                <span class="ico16 sort_down" onClick="moveDown()"></span>
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>