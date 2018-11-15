<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body class="page_color">
    <div id="layout">
        <div class="layout_center bg_color_white" id="center">
            <input id="tempMsg" type="hidden">
            <form action="${path }/form/triggerDesign.do?method=saveTrigger" id="saveForm">
                <div class="form_area padding_tb_5 padding_l_10" id="form">
                    <table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <th nowrap="nowrap">
                                <label class="margin_r_10" for="text">${ctp:i18n('form.base.formname.label') }:</label>
                            </th>
                            <td width="400">
                                <div class="common_txtbox_wrap">
                                    <input type="text" id="formTitle" readonly="readonly" class="w100b" value="${formBean.formName }" />
                                </div>
                            </td>
                        </tr>
                        <!-- 将非标准触发的url存起来 -->
                        <tr class="hidden">
                            <td>
                                <c:forEach var="actionDesign" items="${actionList}" varStatus="ssss">
                                    <c:if test="${!(empty actionDesign.configPageURL) && actionDesign.standardFlag eq false}">
                                        <input id="actionDesignUrl_${actionDesign.id}" name="actionDesignUrl_${actionDesign.id}" type="hidden" value="${actionDesign.configPageURL}&formId=${formBean.id}">
                                    </c:if>
                                </c:forEach>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="layout clearfix code_list padding_t_5 padding_l_10">
                    <div class="col2" id="triggerSet" style="float: left">
                        <div class="common_txtbox clearfix margin_b_5">
                            <label class="margin_r_10 left margin_t_5" for="text">${ctp:i18n('form.trigger.triggerSet.linkage.set.label') }:</label>
                            <a class="common_button common_button_gray" href="javascript:void(0)" id="newTrigger">${ctp:i18n('form.trigger.triggerSet.add.label')}</a>
                        </div>
                        <fieldset class="form_area" id="fieldsetArea">
                            <div id="fillFormBase">
                                <fieldset class="form_area">
                                    <legend>${ctp:i18n('form.trigger.triggerSet.linkage.definition.label') }</legend>
                                    <table width="100%" height="67" border="0" cellpadding="0" cellspacing="0" id="triggerNameSet">
                                        <tr>
                                            <td width="4%" rowspan="2"></td>
                                            <td width="22%" align="right" nowrap="nowrap"><font color="red">*</font>${ctp:i18n('form.trigger.triggerSet.name.label') }：</td>
                                            <td nowrap="nowrap">
                                                <div id="triggerNameDiv" style="width: 180px;">
                                                    <input type="hidden" id="triggerId" name="triggerId" value="">
                                                    <input type="hidden" id="triggerType" name="triggerType" value="3">
                                                    <div class="common_txtbox_wrap">
                                                    <input type="text" id="triggerName" name="triggerName" readonly="readonly" maxlength="80" class="validate" validate="notNullWithoutTrim:true,name:'${ctp:i18n('form.trigger.triggerSet.name.label') }',type:'string',notNull:true,character:'\&#39;&quot;&lt;&gt;'">
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" nowrap="nowrap">${ctp:i18n('form.trigger.triggerSet.state.label') }：</td>
                                            <td nowrap="nowrap">
                                                <input type="hidden" id="state" value="1" forChecked="true">
                                                <div class="common_radio_box clearfix">
                                                    <label class="margin_r_10 hand" for="status1">
                                                        <input type="radio" class="radio_com" name="state" checkId="state" id="status1" value="1" checked="checked" />${ctp:i18n('form.enable.label' )}
                                                    </label>
                                                    <label class="margin_r_10 hand" for="status2">
                                                        <input type="radio" class="radio_com" name="state" checkId="state" id="status2" value="0" />${ctp:i18n('form.stop.label' )}
                                                    </label>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </fieldset>
                                <fieldset class="form_area padding_5 margin_t_10">
                                    <legend>${ctp:i18n('form.trigger.triggerSet.conditions.label') }</legend>
                                    <table width="100%" border="0" cellpadding="2" cellspacing="0" height="65px;" id="triggerConditionSet">
                                        <tr>
                                            <td width="4%"rowspan="2"></td>
                                            <td width="22%" align="right" nowrap="nowrap"><font color="red">*</font>${ctp:i18n('form.trigger.triggerSet.triggerPoint.label')}：</td>
                                            <td nowrap="nowrap">
                                                <input type="hidden" id="dotConditionId">
                                                <input type="hidden" id="dotConditionValue" value="22" forChecked="true">
                                                <div class="common_radio_box clearfix" style="margin-bottom: 5px; line-height: 20px;">
                                                    <label class="margin_l_5 hand" for="triggerDot2">
                                                        <input type="radio" class="radio_com" name="dotConditionValue" checkId="dotConditionValue" id="triggerDot2" value="22" checked="checked" />${ctp:i18n('form.trigger.triggerSet.metAgain.label')}
                                                    </label>
                                                    <label class="margin_l_5 hand" for="triggerDot3">
                                                        <input type="radio" class="radio_com" name="dotConditionValue" checkId="dotConditionValue" id="triggerDot3" value="23" />${ctp:i18n('form.trigger.triggerSet.specOperation.label')}
                                                    </label>
                                                    <select id="add" name="add" class="input-100 font_size12" style="width: 90px;">
                                                        <option value="">${ctp:i18n('form.timeData.none.lable')}</option>
                                                        <c:forEach var="formView" items="${formBean.formViewList }">
                                                            <c:forEach var="auth" items="${formView.operations }">
                                                                <c:if test="${auth.type == 'add' }">
                                                                    <option value="${formView.id }.${auth.id }">${formView.formViewName }.${auth.name }</option>
                                                                </c:if>
                                                            </c:forEach>
                                                        </c:forEach>
                                                    </select>
                                                    <label>or</label>
                                                    <select id="update" name="update" class="input-100 font_size12" style="width: 90px;">
                                                        <option value="">${ctp:i18n('form.timeData.none.lable')}</option>
                                                        <c:set value="true" var="updateDefault" />
                                                        <c:forEach var="formView" items="${formBean.formViewList }">
                                                            <c:forEach var="auth" items="${formView.operations }">
                                                                <c:if test="${auth.type == 'update' }">
                                                                    <option value="${formView.id }.${auth.id }" defaultAuth="${auth.defaultAuth }" ${auth.defaultAuth && updateDefault ? "selected" : ""}>${formView.formViewName }.${auth.name }</option>
                                                                    <c:if test="${auth.defaultAuth}"><c:set value="false" var="updateDefault" /></c:if>
                                                                </c:if>
                                                            </c:forEach>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" nowrap="nowrap" valign="middle">${ctp:i18n('form.trigger.triggerSet.fieldValue.label')}：</td>
                                            <td valign="middle">
                                                <input type="hidden" id="fieldConditionId">
                                                <input type="hidden" id="fieldConditionFormulaId">
                                                <div class="clearfix">
                                                    <div class="common_txtbox_wrap left" style="width: 160px; text-align: left; padding: 0px;">
                                                        <textarea id="fieldConditionValue" style="width: 100%; height: 35px; border: 0px;" class="valign_m" name="fieldConditionValue" validateat="name:'${ctp:i18n('form.trigger.triggerSet.fieldValue.label')}',notNull:true,type:'string'" readonly="true" inputName="${ctp:i18n('form.trigger.triggerSet.fieldValue.label' )}"></textarea>
                                                    </div>
                                                    <a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" onclick="setTriggerCondition(this)">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </fieldset>
                            </div>
                            <fieldset class="form_area padding_5 margin_t_10" id="actionSet">
                                <legend>${ctp:i18n('form.trigger.triggerSet.actions.label') }</legend>
                                <table width="100%" border="0" cellspacing="0" id="actionTable" isGrid="true">
                                    <tr>
                                        <td>
                                            <table width="100%" height="120" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td width="4%" rowspan="5"></td>
                                                    <td width="22%" align="right" nowrap="nowrap">${ctp:i18n('form.trigger.triggerSet.linkage.type.label')}：</td>
                                                    <td nowrap="nowrap">
                                                        <c:forEach items="${actionList }" var="action" varStatus="status">
                                                            <label class="margin_l_10">
                                                                <input type="radio" ${status.index eq 0 ? 'checked="checked"' : '' } /><span class="margin_l_5">${action.name }</span>
                                                            </label>
                                                        </c:forEach>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right" nowrap="nowrap"><font color="red">*</font>${ctp:i18n('form.trigger.triggerSet.linkage.unflow.label.js')}：</td>
                                                    <td nowrap="nowrap">
                                                        <div style="width: 180px; margin-top: 10px;">
                                                            <textarea readonly="readonly" style="width: 160px;">${ctp:i18n('form.trigger.triggerSet.linkage.clickToTemplate.label.js')}</textarea>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right" nowrap="nowrap"><font color="red">*</font>${ctp:i18n('form.trigger.triggerSet.linkage.creator.label.js')}：</td>
                                                    <td nowrap="nowrap">
                                                        <div style="width: 180px; margin-top: 10px; margin-bottom: 10px;">
                                                            <input type="text" readonly="readonly" style="width: 160px;" value="${ctp:i18n('form.trigger.triggerSet.linkage.clickToPerson.label.js')}" />
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td  align="right" nowrap="nowrap"></td>
                                                    <td>
                                                        <div class="common_checkbox_box clearfix " style="margin-bottom: 10px;">
                                                            <input type="checkbox" value="1" id="regeneration" name="regeneration" class="radio_com">${ctp:i18n('form.trigger.triggerSet.linkage.regeneration.label')}
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="right" nowrap="nowrap"><font color="red">*</font>${ctp:i18n('form.trigger.triggerSet.linkage.data.label')}：</td>
                                                    <td nowrap="nowrap"><a class="common_button common_button_gray" href="javascript:void(0)">${ctp:i18n('form.trigger.triggerSet.set.label')}</a></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </fieldset>
                            <div align="center" id="buttonDiv" class="margin_t_5">
                                <a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="saveTrigger">${ctp:i18n('common.toolbar.save.label') }</a>
                                <a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="reset">${ctp:i18n('common.button.reset.label')}</a>
                            </div>
                        </fieldset>
                    </div>
                    <div class="col2 margin_l_5" style="float: left">
                        <div class="common_txtbox clearfix margin_b_5">
                            <label class="margin_r_10 left margin_t_5" for="text">${ctp:i18n('form.trigger.triggerSet.linkage.list.label')}:</label>
                            <a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="updateTrigger">${ctp:i18n('common.button.modify.label') }</a>
                            <a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="delTrigger">${ctp:i18n('common.button.delete.label') }</a>
                        </div>
                        <table id="triggerListTable" width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table">
                            <thead>
                                <tr>
                                    <th width="15">
                                        <input type="checkbox" onclick="selectAll(this,'triggerListTable')" />
                                    </th>
                                    <th width="70%">${ctp:i18n('form.trigger.triggerSet.linkage.name.label')}</th>
                                    <th width="30%">${ctp:i18n('form.trigger.triggerSet.state.label')}</th>
                                </tr>
                            </thead>
                            <tbody id="triggerBody">
                                <c:set var="counts" value="0"></c:set>
                                <c:forEach var="trigger" items="${formBean.triggerList }" varStatus="status">
                                    <c:if test="${trigger.type==type && empty trigger.formTriggerId}">
                                        <tr class="hand <c:if test=" ${(counts % 2)==1 } ">erow</c:if>">
                                            <td id="selectBox">
                                                <input type="checkbox" value="${trigger.id }" />
                                            </td>
                                            <td onclick="showTrigger(this,'${trigger.id }')">${fn:escapeXml(trigger.name) }</td>
                                            <td onclick="showTrigger(this,'${trigger.id }')">${trigger.stateName }</td>
                                        </tr>
                                        <c:set var="counts" value="${counts + 1 }"></c:set>
                                    </c:if>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </form>
        </div>
        <form action="${path }/form/triggerDesign.do?method=saveTrigger" id="save"></form>
    </div>
    <table width="100%" border="0" cellspacing="0" style="display: none">
        <tr id="cloneRow" onmousedown="currentTr=$(this)" onmouseover="currentTr=$(this)">
            <td>
                <table width="100%" height="120" border="0" cellpadding="0" cellspacing="0">
                    <tr id="label">
                        <td width="4%" rowspan="5">
                            <br /><br />
                            <div id="addRow" onclick="addRow(this)"><span class="ico16 repeater_plus_16"></span></div>
                            <br /><br />
                            <div id="delRow" onclick="delRow(this)"><span class="ico16 revoked_process_16 repeater_reduce_16"></span></div>
                            <br /><br />
                        </td>
                        <td width="22%" align="right" nowrap="nowrap">
                            <span id="actionTypeLabel">${ctp:i18n('form.trigger.triggerSet.linkage.type.label')}：</span>
                        </td>
                        <input type="hidden" id="actionId" />
                        <input type="hidden" id="actionType" value="distribution" />
                        <td nowrap="nowrap">
                            <div id="actionTypeTd">
                                <c:forEach items="${actionList }" var="action" varStatus="status">
                                    <label for="${action.id }" class="margin_l_10">
                                        <input type="radio" id="${action.id }" name="actionType" value="${action.id }" ${status.index eq 0 ? 'checked="checked"' : '' } /><span class="margin_l_5">${action.name }</span>
                                    </label>
                                </c:forEach>
                            </div>
                        </td>
                    </tr>
                    <tr class="distribution gather bilateralgo hidden">
                        <td align="right" nowrap="nowrap">
                            <font color="red">*</font><span id="flowLabel">${ctp:i18n('form.trigger.triggerSet.linkage.unflow.label.js')}</span>：
                        </td>
                        <td nowrap="nowrap">
                            <input type="hidden" id="formId" />
                            <input type="hidden" id="templateId" />
                            <input type="hidden" id="formulaId" />
                            <input type="hidden" id="formulaDisplay" />
                            <div style="width: 180px; margin-top: 10px;">
                                <textarea id="content" name="content" readonly="readonly" style="width: 160px;" class="validate" validate="errorMsg:'${ctp:i18n("form.trigger.triggerSet.linkage.template.notnull.js") }',type:'string',notNull:true,isDeaultValue:true,deaultValue:'${ctp:i18n("form.trigger.triggerSet.linkage.clickToTemplate.label.js")}'">${ctp:i18n('form.trigger.triggerSet.linkage.clickToTemplate.label.js')}</textarea>
                            </div>
                        </td>
                    </tr>
                    <tr class="distribution gather bilateralgo hidden">
                        <td align="right" nowrap="nowrap">
                            <font color="red">*</font><span id="creator">${ctp:i18n('form.trigger.triggerSet.linkage.creator.label.js')}</span>：
                        </td>
                        <td nowrap="nowrap">
                            <div style="width: 162px; margin-top: 10px; margin-bottom: 10px;">
                                <input type="hidden" id="flowMem" name="flowMem" />
                                <div class="common_txtbox_wrap">
                                <input type="text" id="flowMem_txt" name="flowMem_txt" readonly="readonly" value="${ctp:i18n('form.trigger.triggerSet.linkage.clickToPerson.label.js')}" class="validate" validate="errorMsg:'${ctp:i18n("form.trigger.triggerSet.linkage.template.sender.js") }',type:'string',notNull:true,isDeaultValue:true,deaultValue:'${ctp:i18n("form.trigger.triggerSet.linkage.clickToPerson.label.js")}'" />
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr class="distribution bilateralgo hidden">
                        <td  align="right" nowrap="nowrap"></td>
                        <td>
                            <div class="common_checkbox_box clearfix " style="margin-bottom: 10px;">
                                <input type="checkbox" value="1" id="regeneration" name="regeneration" class="radio_com">${ctp:i18n('form.trigger.triggerSet.linkage.regeneration.label')}
                            </div>
                        </td>
                    </tr>
                    <tr class="distribution gather bilateralgo hidden">
                        <td align="right" nowrap="nowrap">
                            <font color="red">*</font>${ctp:i18n('form.trigger.triggerSet.linkage.data.label')}：
                        </td>
                        <td nowrap="nowrap">
                            <input id="fillBackType" type="hidden" />
                            <input id="fillBackKey" type="hidden" />
                            <input id="fillBackValue" type="hidden" />
                            <input id="fillBackType1" type="hidden" />
                            <input id="fillBackKey1" type="hidden" />
                            <input id="fillBackValue1" type="hidden" />
                            <input name="ConfigValue" id="ConfigValue" type="hidden" value="">
                            <a class="common_button common_button_gray" href="javascript:void(0)" id="copySet">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
                        </td>
                    </tr>
                    <!-- 触发预留接口 创建任务 走的就是此处去处理 需要排除标准的触发(分发、汇总、双向) -->
					<c:forEach var="actionDesign" items="${actionList}" varStatus="s">
						<c:if test="${!(empty actionDesign.configPageURL) && actionDesign.standardFlag eq false}">
							<tr class="hidden ${actionDesign.id}">
								<td colspan="2">
									<iframe id="DesignIframe_${actionDesign.id}" name="DesignIframe_${actionDesign.id}" src="" width="100%" height="100" frameborder="0" marginheight="0" marginwidth="0"></iframe>
								</td>
							</tr>
						</c:if>
					</c:forEach>
                </table>
                <p />
                <hr />
            </td>
        </tr>
    </table>
</body>
<%@ include file="linkageDesign.js.jsp" %>
<%@ include file="../../common/common.js.jsp" %>
</html>