<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html style="width: 100%;height: 100%">
<head>
<script type="text/javascript">
    $(function () {
        $("input").attr("disabled", "disabled");
        $("input").attr("readonly", "readonly");
    });

</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body class="over_hidden font_size12">
    <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" disabled="disabled" readonly="readonly">
        <tr height="5">
            <td></td>
        </tr>
        <tr>
            <td>
                <fieldset class="form_area padding_5 margin_t_5 margin_lr_10">
                    <legend>&nbsp;
                        <c:if test="${actionType eq 'billInner' || actionType eq 'billOuter'}" >${ctp:i18n("form.trigger.automatic.updatedatalist.label")}</c:if>
                        <c:if test="${actionType eq 'autoInsert'}" >${ctp:i18n("form.trigger.automatic.billnew.label")}${ctp:i18n("form.data.items.label")}</c:if>
                    &nbsp;
                    </legend>
                    <div style="height: 380px;overflow: auto;" disabled="disabled">
                        <table id="dataTable" border="0" cellspacing="0" cellpadding="0" width="430" align="center" style="overflow: auto;" disabled="disabled">
                            <c:forEach items="${fieldMap}" var="map">
                            <tr height="22" style="margin-top: 5px;">
                                <td width="35%" height="20" class="source">
                                    <div  id="sourceTD" style="margin-top: 5px;"title="${map.key}" >
                                        <select style="width: 150px;margin-top: 5px;" onchange="" class="validate comp enumselect common_drop_down" comp="type:'autocomplete',autoSize:true" comptype="autocomplete"title="${map.key}">
                                            <option value="${map.key}">${map.key}</option>
                                        </select>
                                    </div>
                                </td>
                                <td align="center">
                                    <input type="hidden" id="tfillBackType" value="copy">=
                                    <input type="hidden" id="isIncludeSub" />
                                </td>
                                <td width="35%" class="target" style="margin-top: 5px;">
                                    <div id="targetTD" title="${map.value}">
                                        <select style="width: 150px;margin-top: 5px;" id="fromField" name="fromField" onchange="" class="validate comp enumselect common_drop_down" comp="type:'autocomplete',autoSize:true" comptype="autocomplete" title="${map.value}">
                                            <option value="${map.value}">${map.value}</option>
                                        </select>
                                    </div>
                                </td>

                            </tr>
                            </c:forEach>
                        </table>
                    </div>
                </fieldset>
            </td>
        </tr>
    </table>

</body>
</html>