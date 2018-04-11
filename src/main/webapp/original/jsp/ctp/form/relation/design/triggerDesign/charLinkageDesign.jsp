<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <script type="text/javascript" src="${path}/common/form/relation/relationDetailView.js${ctp:resSuffix()}"></script>
    <script></script>
    <script>
        /*数据域值,关联条件,数据联动需要的参数*/
        /*数据域值(分发,汇总,双向):messageDataFilter*/
        /*关联条件:setRelationFormView*/
        /*数据联动:copySetFunView*/
        //全局变量,用来存放数据域,关联条件,数据联动js事件需要的参数

        var srcFormId = "${srcFormId}";
        var triggerId = "${triggerId}";
        var tarFormId = "${tarFormId}";
        var type = "${type}";

        $(function () {
            $("#btnmodify").click(function () {
                relationEdit(null, srcFormId);
            });
        });


        /**
         * 数据过滤
         * @param index
         */
        function showDataFilterDetail(index){
            var triggerId = $("#triggerId" + index).val();
            messageDataFilter(srcFormId, null, null, triggerId, "trigger", null, null, null, null);
        }

        /**
         * 关联条件详情
         * @param index
         */
        function showRelationConditionDetail(index) {
            var triggerId = $("#triggerId" + index).val();
            var relationId = $("#relationId" + index).val();
            setRelationFormView(srcFormId, tarFormId, relationId, triggerId, "trigger", null, "link", null, null)
        }

        /**
         * 联动详情
         * @param index
         */
        function showRelationDetail(index, actionId){
            var triggerId = $("#triggerId" + index).val();
            var relationType = $("#relationType" + index).val();
            copySetFunView(srcFormId, tarFormId, actionId, triggerId, null, relationType, null, null);
        }
    </script>

</head>
<body class="page_color" style="background: #fff">
    <div id="layout">
        <div class="layout clearfix code_list padding_t_5 padding_lr_10"style="height:440px;overflow-y: auto;overflow-x: hidden">
            <c:forEach items="${formTriggerList}" var="formTrigger" varStatus="triggerStatus">
                <fieldset class="form_area" id="fieldsetArea" style="margin-bottom: 10px">
                    <legend style="font-size: 14px">&nbsp;&nbsp; ${formTrigger.triggerName} &nbsp;&nbsp;</legend>
                    <div id="triggerSet" >
                            <div id="fillFormBase">
                                <%--条件--%>
                                <fieldset class="form_area padding_5">
                                    <legend>&nbsp;&nbsp; ${ctp:i18n('form.trigger.triggerSet.conditions.label') }&nbsp;&nbsp; </legend>
                                    <table width="100%" border="0" cellpadding="2" cellspacing="0" height="65px;" id="triggerConditionSet">
                                        <input type="hidden" id="triggerId${triggerStatus.index}" name="triggerId" value="${formTrigger.triggerId}">
                                        <input type="hidden" id="relationId${triggerStatus.index}" name="triggerId" value="${formTrigger.relationId}">
                                        <%--触发点--%>
                                        <tr>
                                            <td width="4%"rowspan="2"></td>
                                            <td width="22%" align="right" nowrap="nowrap"><font color="red">*</font>${ctp:i18n('form.trigger.triggerSet.triggerPoint.label')}：</td>
                                            <td nowrap="nowrap">
                                                ${formTrigger.executePoint}
                                            </td>
                                        </tr>

                                        <%--数据域值 数据域值是点击详情后在新的页面展示--%>
                                        <tr>
                                            <td align="right" nowrap="nowrap" valign="middle">${ctp:i18n('form.trigger.triggerSet.fieldValue.label')}：</td>
                                            <td id="dataFilter" nowrap="nowrap" >
                                                <c:if test="${formTrigger.hasDataFilter == true}">
                                                 [<a href="javascript:void(0)" onclick="showDataFilterDetail(${triggerStatus.index})">${ctp:i18n('form.data.refresh.fail.detail.label')}</a>]
                                              </c:if>
                                                <c:if test="${formTrigger.hasDataFilter == false}">[${ctp:i18n('form.format.flowprocessoption.none')}]</c:if>
                                            </td>
                                        </tr>
                                    </table>
                                </fieldset>
                            </div>


                            <%--动作--%>
                            <fieldset class="form_area padding_5 margin_tb_10" id="actionSet">
                                <legend>&nbsp;&nbsp; ${ctp:i18n('form.trigger.triggerSet.actions.label') }&nbsp;&nbsp; </legend>
                                <c:forEach items="${formTrigger.actionList}" var="action" varStatus="status">
                                <c:if test="${action.actionType ne 'bilateralback'}">
                                <table width="100%" border="0" cellspacing="0" id="actionTable" isGrid="true">
                                    <tr>
                                        <td>
                                            <table width="100%" height="120" border="0" cellpadding="0" cellspacing="0">


                                                <%--信息表--%>

                                                <tr>
                                                    <td width="4%" rowspan="4"></td>
                                                    <td width="22%" align="right" nowrap="nowrap" title="${ctp:i18n('form.trigger.triggerSet.linkage.unflow.label.js')}"><font color="red">*</font>${ctp:getLimitLengthString(ctp:i18n('form.trigger.triggerSet.linkage.unflow.label.js'), 16, '..')}：</td>
                                                    <td>
                                                        <div style=" width:327px;<c:if test="${action.actionType eq 'gather'}">width: 200px; </c:if>white-space:nowrap;overflow:hidden;text-overflow: ellipsis;display: block;">
                                                            <input type="hidden" id="relationType${status.index}" value="${action.actionType}">
                                                            ${action.flowTemplate}
                                                        </div>
                                                    </td>
                                                    <%-- 汇总才有关联条件.通过actionType来判断 --%>
                                                    <c:if test="${action.actionType eq 'gather'}">
                                                    <td nowrap="nowrap">
                                                        [<a href="javascript:void(0)" onclick="showRelationConditionDetail(${triggerStatus.index})">${ctp:i18n('form.relation.condition.label')}</a>]
                                                    </td>
                                                    </c:if>
                                                </tr>

                                                <%--创建人/修改人--%>
                                                <tr>
                                                    <td align="right" nowrap="nowrap" title="${ctp:i18n('form.trigger.triggerSet.linkage.creator.label.js')}"><font color="red">*</font>${ctp:getLimitLengthString(ctp:i18n('form.trigger.triggerSet.linkage.creator.label.js'), 16, '..')}：</td>
                                                    <td nowrap="nowrap">
                                                        <div style="width: 180px; margin-top: 10px; margin-bottom: 10px;">
                                                                ${action.creator}
                                                        </div>
                                                    </td>
                                                </tr>
                                                <c:if test="${action.actionType eq 'bilateralgo' or action.actionType eq 'distribution'}">
                                                <tr>
                                                    <td  align="right" nowrap="nowrap"></td>
                                                    <%-- 删除目标数据后重新生成 分发和双向才有.需要判断actionType --%>
                                                    <td>
                                                        <div class="common_checkbox_box clearfix " style="margin-bottom: 10px;">
                                                            <input type="checkbox" value="1" <c:if test="${action.regenerate}">checked="checked"</c:if>id="regeneration" name="regeneration" disabled="true" class="radio_com">${ctp:i18n('form.trigger.triggerSet.linkage.regeneration.label')}
                                                        </div>
                                                    </td>
                                                </tr>
                                                </c:if>
                                                <%-- 数据联动 --%>
                                                <tr>
                                                    <input type="hidden" id="relationType${status.index}" name="triggerId" value="${action.actionType}">
                                                    <td align="right" nowrap="nowrap">${ctp:i18n('form.trigger.triggerSet.linkage.data.label')}：</td> 
                                                    <td nowrap="nowrap">[<a href="javascript:void(0)" onclick="showRelationDetail(${triggerStatus.index}, '${action.actionId}')">${ctp:i18n('form.data.refresh.fail.detail.label')}</a>]</td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr height="5">
                                        <td >
                                            <hr align="center" width="450"<c:if test="${status.last}"> style="visibility:hidden;"</c:if>/>
                                        </td>
                                    </tr>
                                </table>
                                </c:if>
                                </c:forEach>
                            </fieldset>
                    </div>
                </fieldset>
            </c:forEach>
        </div>
    </div>
</body>
</html>