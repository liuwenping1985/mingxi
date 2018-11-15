<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html style="width: 100%;height: 100%">
<head>
<script type="text/javascript">

</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body class="over_hidden font_size12">
    <c:if test="${error}">
        <div style="height: 30px;overflow: hidden;">
            <table width="535" border="0" cellspacing="0" cellpadding="0" align="center" style=" table-layout:fixed;">
                <tr>

                    <td align="left" width="65%" style="overflow:hidden;">目标表单已重置,请重新刷新表间关系!</td>
                </tr>
            </table>
        </div>
    </c:if>
    <c:if test="${not error}">
    <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
        <tr height="5">
            <td></td>
        </tr>
        <tr>
            <td>
                <fieldset class="form_area padding_5 margin_t_5 margin_lr_10">
                    <c:if test="${not empty actionType}">
                        <c:set var="legendLabel" value="form.trigger.triggerSet.linkage.${actionType}.label" />
                    </c:if>
                    <c:if test="${empty actionType}">
                        <c:set var="legendLabel" value="form.trigger.triggerSet.copy.label" />
                    </c:if>
                    <c:if test="${actionType eq 'flow' or actionType eq 'unflow'}">
                        <c:set var="legendLabel" value="form.trigger.triggerSet.copy.label" />
                    </c:if>
                    <legend>&nbsp;${ctp:i18n(legendLabel)}&nbsp;</legend>

                    <%-- 表名,从哪个表到哪个表 --%>
                    <div style="height: 30px;overflow: hidden;">
                        <table width="535" border="0" cellspacing="0" cellpadding="0" align="center" style=" table-layout:fixed;">
                            <tr>
                                <td align="left" width="65%" style="overflow:hidden;" title="${fromFormBean.formName}">${ctp:i18n('form.source.label')}：${ctp:getLimitLengthString(fromFormBean.formName, 24, '...')}</td>
                                <td align="left" width="35%" title="${toFormBean.formName}">${ctp:i18n('form.target.label')}：${ctp:getLimitLengthString(toFormBean.formName, 21, '...')}</td>
                            </tr>
                        </table>
                    </div>

                    <div style="<c:if test="${hasBack}">height: 230px;</c:if><c:if test="${not hasBack}">height: 350px;</c:if>overflow: auto;margin-left:28px;">
                        <table id="dataTable" border="0" cellspacing="0" cellpadding="0" width="530" align="center" style="float:left;overflow: auto;"  disabled="disabled">
                            <c:set var="tarField" value="${tarList}"></c:set>
                            <c:forEach items="${srcList}" var="field" varStatus="index">
                            <tr height="22" style="margin-top: 5px;">

                                <%--源--%>
                                <td width="35%" height="20" class="source">
                                    <div  id="sourceTD" style="margin-top: 5px;"title="${field}">
                                        <input type="text" disabled="disabled" readonly="readonly" value="${field}" style="width:130px;" class="calcExpression validate">
                                    </div>
                                </td>

                                <td align="center">
                                    <input type="hidden" id="tfillBackType" value="copy">-----&gt;
                                </td>

                                <%-- 目标 --%>
                                <td width="35%" class="target" title="${tarField[index.index]}">
                                    <div id="targetTD"  style="margin-top: 5px;">
                                        <input type="text" disabled="disabled" readonly="readonly" value="${tarField[index.index]}" style="width:130px;" class="calcExpression validate">
                                    </div>
                                </td>
                            </tr>
                            </c:forEach>
                        </table>
                    </div>
                </fieldset>

                <c:if test="${hasBack}">
                    <fieldset class="form_area padding_5 margin_t_5 margin_lr_10" >
                        <legend>${ctp:i18n('form.trigger.triggerSet.linkage.bilateralback.label')}</legend>
                        <div style="height: 30px;overflow: hidden;">
                            <table border="0" cellspacing="0" cellpadding="0" width="530" align="center" style="table-layout:fixed;"  disabled="disabled">
                                <tr>
                                    <td align="left" width="65%" title="${fromFormBean.formName}">${ctp:i18n('form.source.label')}：${ctp:getLimitLengthString(fromFormBean.formName, 24, '...')}</td>
                                    <td align="left" width="35%" title="${toFormBean.formName}">${ctp:i18n('form.target.label')}：${ctp:getLimitLengthString(toFormBean.formName, 22, '...')}</td>
                                </tr>
                            </table>
                        </div>


                        <div style="height: 125px;overflow: auto;margin-left:28px;">
                            <table id="dataTable1" border="0" cellspacing="0" cellpadding="0" width="530" align="center" style="float:left;overflow: auto;">
                                <c:set var="tarBack" value="${tarListBack}"></c:set>
                                <c:forEach items="${srcListBack}" var="backField" varStatus="status">
                                    <tr height="22" style="margin-top: 5px;">

                                            <%--源--%>
                                        <td width="35%" height="20" class="source">
                                            <div style="margin-top: 5px;"title="${backField}">
                                                <input type="text" disabled="disabled" readonly="readonly" value="${backField}" style="width:130px;" class="calcExpression validate">
                                            </div>
                                        </td>

                                        <td align="center">
                                            <input type="hidden" value="copy">&nbsp;&lt;-----
                                        </td>

                                            <%-- 目标 --%>
                                        <td width="35%" class="target">
                                            <div style="margin-top: 5px;" title="${tarBack[status.index]}">
                                                <input type="text" disabled="disabled" readonly="readonly" value="${tarBack[status.index]}" style="width:130px;" class="calcExpression validate">
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </table>
                        </div>
                    </fieldset>
                </c:if>
            </td>
        </tr>
    </table>
    </c:if>
</body>
</html>