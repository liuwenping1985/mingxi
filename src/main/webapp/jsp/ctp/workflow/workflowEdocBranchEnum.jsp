<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title>公文枚举设置</title>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_meta.jsp"%>
<body class="h100b over_hidden">
<div class="form_area padding_5">
        <table border="0" cellSpacing="0" cellPadding="0" width="100%">
          <tbody>
          <tr height="32">
            <td nowrap="nowrap" width="20%" align="right">
         		<label class="margin_r_10" for="text">${ctp:i18n('workflow.edocBranch.enum') }:</label>
            </td>
            <td width="80%">
                <div class="common_radio_box clearfix">
                    <label class="margin_r_10 hand" for="type1">
                        ${enumLabel }
                    </label>
                </div>
            </td>
          </tr>
          <tr height="32">
            <td nowrap="nowrap" width="20%" align="right">
         		<label class="margin_r_10" for="text">${ctp:i18n('workflow.edocBranch.search.label') }:</label>
            </td>
            <td width="80%">
                <div id="type2Content" class="common_selectbox_wrap">
                <select id="operatorValue" name="operatorValue">
                    <option value="==">=</option>
                    <option value="!=">&lt;&gt;</option>
                </select>
            </div>
            </td>
          </tr><tr height="40">
            <td nowrap="nowrap" width="20%" align="right">
         		<label class="margin_r_10" for="text">${ctp:i18n('workflow.edocBranch.enumValue') }:</label>
            </td>
            <td width="80%"><div id="type2Content" class="common_selectbox_wrap">
                <select id="edocEnumValue" name="edocEnumValue">
                    <c:forEach items="${enumItemList}" var="field">
                        <option value="${field.enumvalue}">${field.showvalue }</option>
                    </c:forEach>
                </select>
            </div>
            </td>
          </tr>
          </tbody>
         </table>
    </div>
<script type="text/javascript">
function OK(){
    var result = " "+$("#operatorValue").val()+" "+$("#edocEnumValue").val();
    return result;
}
</script>
</body>
</html>