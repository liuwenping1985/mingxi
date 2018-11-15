<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>form</title>
        <script type="text/javascript" src="${path}/ajax.do?managerName=formTriggerDesignManager,formManager"></script>
		<script type="text/javascript" src="${path}/common/form/relation/relationDetailView.js${ctp:resSuffix()}"></script>
		<script>
			var tarFormId = "${tarFormId}";
			var relationId = "${relationId}";
            var srcFormId = "${srcFormId}";
            var isChar = ${isChar};
            var trigger = "${triggerId}";
			$(function () {
				$("#btnmodify").click(function () {
					var formId = "${srcFormId}";
					relationEdit(null, formId);
				});
			});

			function showRelationCondition(index){
				var triggerId = $("#triggerId_" + index).val();
				setRelationFormView(srcFormId, tarFormId, relationId, triggerId, "trigger", "", "link", null, null)
			}

            function showRowConditionDetail(index, triggerIndex){
                debugger;
                var rowCondition = $("#rowcondition" + index).val();
                var triggerId = $("#triggerId_" + triggerIndex).val();
                if(triggerIndex == -1){
                    triggerId = trigger;
                }
                showRowCondition(rowCondition,null, "", triggerId, srcFormId);
            }
		</script>
</head>
<body style='overflow:hidden;width: 100%;background: #fff'>

        <c:if test="${isChar}">
        <div id="newEchoSettingContainer" class="scrollList" <c:if test="${isChar}">style="height:440px;overflow-y: auto;"</c:if><c:if test="${not isChar}">style="height:400px"</c:if>>
        <c:if test="${fn:length(fillBackSet)>0 }">
        <c:forEach var="echo" items="${fillBackSet }" varStatus="status">
        <div id="echoSetting" class="echoSetting">
        <div class="clearfix margin_t_5 margin_l_5" style="">
            <div class="left clearfix" style="width: 20px;min-height: 100px;vertical-align: bottom;line-height: 100px;">

            </div>
            <div>
                <fieldset style="width: 480px;padding: 0px;">
                    <legend style="font-size: 14px">${ctp:i18n('form.echoSetting.label')}</legend>
                    <div <c:if test="${isChar}">style="width: 480px;"</c:if><c:if test="${not isChar}">style="width: 480px;height: 370px;overflow-y: auto;"</c:if>>

						<%--触发名称--%>
						<c:if test="${isChar}">
						<div class="clearfix" style="line-height: 20px;" istable="false">
							<div class="left" style="width: 150px;line-height: 25px;text-align: right;"><label class="" for="text"><font color="red">*</font>${ctp:i18n('form.echoSetting.triggername.label')}：</div>
							<div class="left common_txtbox_wrap">
								<input id="triggerId_${status.index}" value="${echo.id}" type="hidden">
								<input type="text" disabled="disabled" id="triggerName" title="${echo.name }" value="${echo.name }" name="triggerName" style="width:176px;" maxlength="80" class="triggerName validate">
							</div>
						</div>
						</c:if>

						<%--选择要回写的表单--%>
						<c:if test="${isChar}">

						<div class="clearfix" style="line-height: 20px;" istable="false">
							<div class="left" style="width: 150px;text-align: right;margin-top:5px;">${ctp:i18n('form.echoSetting.selectForm.label')}：</div>
                            <div class="left">
                                <div class="common_selectbox_wrap  showFormName" style="width: 240px;white-space:nowrap;overflow:hidden;text-overflow: ellipsis;margin-left: 0px;margin-top:5px;" title="${echo.extraMap.systemRelationForm }">
                                    <input type="text" disabled="disabled" title="${tarFormName}" value="${tarFormName}" style="width:176px;" maxlength="80" class="triggerName validate">
                                 </div>
                            </div>
							<%-- 处理回写设置的关联条件 --%>
                            <div class="right" style="width:65px;margin-top:5px;">
								<input type="hidden" id="relationId" value="${echos}">
                                <span id="relateButton" class="relateButton color_blue hand" onclick="showRelationCondition(${status.index})">[${ctp:i18n('form.relation.condition.label')}]</span>
                            </div>
                        </div>
						</c:if>

						<%--回写时间点--%>
						<c:if test="${isChar}">
                        <div id = "echoTiemDiv" class="clearfix margin_t_5" style="line-height: 20px;" istable="false">
                            <div class="left" style="width: 150px;text-align: right;">${ctp:i18n('form.echoSetting.echoTime.label')}：</div>
                            <div class="left">
                                <input type="hidden" id="pointData" value="${echo.flowState }">
                                <label for="flow${status.index }"><input disabled="disabled" type="radio" id="flow${status.index }" class="radio_com flow"  name="echoTime${status.index }" value="1" <c:if test="${echo.flowState eq '1' }">checked="checked"</c:if>>${ctp:i18n('form.trigger.triggerSet.processEnd.label')}</label>
                                <label for="approved${status.index }"><input disabled="disabled" type="radio" id="approved${status.index }"  class="radio_com approved" name="echoTime${status.index }" value="2" <c:if test="${echo.flowState eq '2' }">checked="checked"</c:if>>${ctp:i18n('form.trigger.triggerSet.approvedBy2.label')}</label>
								<label for="perapproved${status.index }"><input disabled="disabled" type="radio" id="perapproved${status.index }" class="radio_com perapproved"  name="echoTime${status.index }" value="6" <c:if test="${echo.flowState eq '6' }">checked="checked"</c:if>>${ctp:i18n('form.trigger.triggerSet.approvedBy3.label')}</label>
                            </div>
                        </div>
						</c:if>
                        <div class="clearfix margin_t_5" style="line-height: 20px;">
                            <div class="left" <c:if test="${isChar}">style="width: 150px;text-align: right;"</c:if> <c:if test="${not isChar}">style="width: 150px;text-align: left;margin-left: 20px"</c:if>>${ctp:i18n('form.echoSetting.data.label')}：</div>
                        </div>


						<%--回写字段.逻辑列表只显示这一块--%>
                        <div class="rowdatas" id="refColumTable">
                                <c:forEach var="refColum" items="${resultSet[status.index] }" varStatus="rowIndex">
                                    <div class="clearfix margin_t_5 rowdata" style="line-height: 20px;">
                                        <div class="left margin_l_5" style="width: 20px;"></div>
                                        <div class="left" style="margin: 0 20px" id="echoselect" title="${refColum.srcField }">
                                            <input type="text" disabled="disabled" readonly="readonly" value="${refColum.srcField }" style="width:130px;" class="calcExpression validate">
                                        </div>

                                        <div class="left" style="width: 50px;text-align: center;">=<input type="hidden" id="fillType"></div>


                                        <div class="left" style="margin: 0 5px 0 20px" id="echoinput" title="${refColum.tarField }">
                                            <input type="text" disabled="disabled" readonly="readonly" value="${refColum.tarField }" style="width:130px;" class="calcExpression validate">
                                        </div>


                                        <div class="left margin_l_5" style="margin: 0 0 0 15px">
                                            <input type="hidden" name="rowcondition" id="rowcondition${status.index}${rowIndex.index}" value="${refColum.rowConditon }">
                                            <c:if test="${refColum.hasCondition}">
                                             <span id="formulaButton" class="formulaButton hand color_blue" onclick="showRowConditionDetail('${status.index}${rowIndex.index}','${status.index}')">
                                                [${ctp:i18n('form.query.label.condition')}<span id="formulaButtonImg" class="ico16 gone_through_16"></span>]
                                             </span>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
						<%--预提控制,增加重复行--%>
						<c:if test="${isChar}">
                        <div class="clearfix margin_t_5 radiocheck" style="line-height: 20px;padding-left: 10px;" istable="false">
                            <input id="withholding" type="hidden" value="${echo.actions[0].param.withholding }">
                            <input id="addSlaveRow" type="hidden" value="${echo.actions[0].param.addSlaveRow }">
                            <div class="common_checkbox_box clearfix ">
                                <label class="margin_r_10 hand" for="withholding${status.index }">
                                    <input disabled="disabled" name="withholding" class="radio_com withholding" id="withholding${status.index }" type="checkbox" <c:if test='${echo.actions[0].param.withholding eq "true" }'>checked='checked'</c:if> value="true">${ctp:i18n('form.create.withholding.label')}</label>
                                <label class="margin_r_10 hand" for="addSlaveRow${status.index }" style="margin-left: 30px;">
                                    <input disabled="disabled" name="addSlaveRow" class="radio_com addSlaveRow" id="addSlaveRow${status.index }" type="checkbox" <c:if test='${echo.actions[0].param.addSlaveRow eq "true" }'>checked='checked'</c:if> <c:if test='${echo.extraMap.conditionOnlyMasterFeild eq "0" }'>disabled</c:if> value="true">${ctp:i18n('form.trigger.triggerSet.fillback.add.repeat') }</label>
                            </div>
                        </div>
						</c:if>
                    </div>
                </fieldset>
            </div>
        </div>
        </div>
        </c:forEach>
        </c:if>
        </div>

        </c:if>

        <%-- 逻辑列表使用下面的页面来展示回写字段 --%>
        <c:if test="${not isChar}">

            <div class="scrollList" style="height:400px">
                <div class="echoSetting">
                    <div class="clearfix margin_t_5 margin_l_5" style="">
                        <div class="left clearfix" style="width: 20px;min-height: 100px;vertical-align: bottom;line-height: 100px;">
                        </div>
                        <div>
                            <fieldset style="width: 480px;padding: 0px;">
                                <legend>${ctp:i18n('form.echoSetting.label')}</legend>
                                <div style="width: 480px;height: 370px;overflow-y: auto;">
                                        <%--回写字段.逻辑列表只显示这一块--%>
                                    <div class="rowdatas">
                                        <c:forEach var="fillBackAction" items="${result}" varStatus="actionIndex">
                                            <div class="clearfix margin_t_5 rowdata" style="line-height: 20px;">
                                                <div class="left margin_l_5" style="width: 20px;"></div>
                                                <div class="left" style="margin: 0 20px" title="${fillBackAction.srcField }">
                                                    <input type="text" disabled="disabled" readonly="readonly" value="${fillBackAction.srcField }" style="width:130px;" class="calcExpression validate">
                                                </div>

                                                <div class="left" style="width: 50px;text-align: center;">=<input type="hidden"></div>


                                                <div class="left" style="margin: 0 5px 0 20px" title="${fillBackAction.tarField }">
                                                    <input type="text" disabled="disabled" readonly="readonly" value="${fillBackAction.tarField }" style="width:130px;" class="calcExpression validate">
                                                </div>

                                                <div class="left margin_l_5" style="margin: 0 0 0 15px">
                                                    <input type="hidden" id="rowcondition${actionIndex.index}" value="${fillBackAction.rowConditon }">
                                                    <c:if test="${fillBackAction.hasCondition}">
                                                            <span id="formulaButton" class="formulaButton hand color_blue" onclick="showRowConditionDetail(${actionIndex.index}, -1)">
                                                            [${ctp:i18n('form.query.label.condition')}<span id="formulaButtonImg" class="ico16 gone_through_16" style="${fn:length(fillBackAction.rowConditon) > 0 ? '' : 'display: none'}"></span>]
                                                            </span>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </fieldset>
                        </div>
                    </div>
                </div>
            </div>

        </c:if>



    <div id="operInstructionDiv"  style="color:  green;font-size: 12px;display: none;">
        ${ctp:i18n("form.trigger.triggerSet.fillback.info") }
    </div>

</body>
<%@ include file="../../../common/common.js.jsp" %>
</html>