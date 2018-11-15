<%--
/**
 * $Author: wangchw $
 * $Rev: 40258 $
 * $Date:: 2014-09-05 16:35:12#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
 --%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>${ctp:i18n('selectPolicy.please.select')}</title>
</head>
<body onload="compare()">
<div class="form_area align_center">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td colspan="2" height="8" class="PopupTitle"></td>
    </tr>
    <tr>
    <td id="policyDiv" colspan="2" valign="top" style="padding:0 10px;">
        <div id="policyHTML">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <!-- 节点权限部分:开始 -->
            <tr>
                <td>
                <fieldset width="80%" align="center">
                    <legend>${ctp:i18n('workflow.designer.node.property.setting')}</legend>
                    <table align="center" width="100%" border="0">
                        <tr>
                            <td width="28%" height="28" align="right">${ctp:i18n('workflow.designer.node.name.label')}:</td>
                            <td width="50%" align="left"><input style="width:197px" id="nodeNamee" name="nodeNamee" class="input-100per margin_l_5"  value="${ctp:toHTML(nodeName)}" title="${ctp:toHTML(nodeName)}"></td>
                            <td align="left" width="22%" nowrap="nowrap"></td>
                        </tr>   
                    </table>
                </fieldset>
              </td>
          </tr>
          <!-- 节点权限部分:结束 -->
        </table>
      </div>
     </td>
    </tr>
</table>
</form>
</div>
<script type="text/javascript">
//确定按钮响应方法
function OK(jsonArgs) {
  var returnValue= new Array();
  returnValue[0]= $("#nodeNamee").attr("value");
  return returnValue;
}
</script>
</body>
</html>