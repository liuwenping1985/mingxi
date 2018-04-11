<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>${ctp:i18n("subflow.setting.title")}</title>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_meta.jsp"%>
</head>
<body id="NewflowContainer">
    <fieldset id="newflow1" class="margin_5 margin_l_20">
        <legend>${ctp:i18n('subflow.label')}</legend>
        <div class="form_area  relative">
            <table border="0" cellspacing="0" cellpadding="0" width="100%" align="left">
                <tr>
                    <th nowrap="nowrap"><label class="margin_r_5" for="text"><span class="required">*</span>${ctp:i18n("subflow.setting.selectFlow")}:</label></th>
                    <td width="100%" colspan="3"><div class="common_txtbox_wrap">
                        <input validate="type:'string',name:'${ctp:i18n("subflow.setting.selectFlow")}',notNull:true,isDeaultValue:true,deaultValue:'<${ctp:i18n('subflow.setting.selectFlow')}>',errorMsg:'${ctp:i18n('subflow.setting.noSelectFlow')}'" class="validate input-100per cursor-hand" id="subFlowName" name="subFlowName" readonly="readonly" value="<${ctp:i18n('subflow.setting.selectFlow')}>" />
                        <input id="newflowTempleteId" name="newflowTempleteId" type="hidden" value=""/></div>
                    </td>
                </tr>
                <tr>
                    <th nowrap="nowrap"><label class="margin_r_5" for="text"><span class="required">*</span>${ctp:i18n("subflow.setting.sender")}:</label></th>
                    <td nowrap="nowrap">
                          <label class="margin_r_10 hand forinput">
                              <input id="sender3Value" name="sender1" type="radio" checked="checked" class="selectPeople radio_com" value="" />
                          </label>
                          <input id="sender3Name" type="text" name="sender3Name" value="${ctp:i18n('common.default.selectPeople.value')}" readonly deaultValue="${ctp:i18n('common.default.selectPeople.value')}"/>
                    </td>
                    <td nowrap="nowrap">
                        <div class="common_radio_box clearfix">
                            <label class="margin_r_10 hand forinput clearRed">
                                <input id="sender1" name="sender1" type="radio" class="selectPeople radio_com" value="CurrentNode"/> ${ctp:i18n("subflow.setting.sender.currentNode")} &nbsp;&nbsp;
                            </label>
                        </div>
                    </td>
                    <td nowrap="nowrap">
                          <label class="margin_r_10 hand forinput clearRed">
                              <input id="sender2" name="sender1" type="radio" class="selectPeople radio_com" value="CurrentSender"/> ${ctp:i18n("subflow.setting.sender.CurrentSender")}
                          </label>
                    </td>
                </tr>
                <tr>
                    <th nowrap="nowrap"><label class="margin_r_5" for="text">${ctp:i18n("subflow.setting.condition")}:</label></th>
                    <td nowrap="nowrap">
                        <div class="common_radio_box clearfix">
                            <label class="margin_r_10 hand forinput clearRed">
                                <input id="formFlowCondition1NameRadio1" name="formFlowCondition1NameRadio1" type="radio" class="forsingle radio_com" value="0" checked/> ${ctp:i18n("common.none")}
                            </label>
                        </div>
                    </td>
                    <td colspan="2">
                      <input id="formFlowCondition1Title" name="formFlowCondition1Title" type="hidden" value=""/>
                      <input id="formFlowCondition1Value" name="formFlowCondition1Value" type="hidden" value=""/>
                      <input id="formFlowCondition1IsForce" name="formFlowCondition1IsForce" type="hidden" value="0"/>
                      <input id="formFlowCondition1Base" name="formFlowCondition1Base" type="hidden" value="currentNode"/>
                      <!-- 这两个属性在3.5中就无意义，5.0时先注释 <input id="formFlowCondition1Id" name="formFlowCondition1Id" type="hidden" value=""/>
                      <input id="formFlowCondition1IdAdd" name="formFlowCondition1IdAdd" type="hidden" value=""/> -->
                        <label class="margin_r_10 hand forinput condition">
                                <input id="formFlowCondition1NameRadio2" name="formFlowCondition1NameRadio1" type="radio" class="forsingle radio_com condition" value="1"/>
                        </label>
                        <input type="text" id="formFlowCondition1Name" name="formFlowCondition1Name" readonly="readonly" class="condition" value="${ctp:i18n('subflow.condition.tip')}" deaultValue="${ctp:i18n('subflow.condition.tip')}"/>
                    </td>
                </tr>
                <tr>
                    <th nowrap="nowrap"><label class="margin_r_5" for="text"><span class="required">*</span>${ctp:i18n("subflow.setting.relate")}:</label></th>
                    <td nowrap="nowrap">
                        <div class="common_radio_box clearfix">
                            <label class="margin_r_10 hand forinput">
                                <input id="flowRelateType11" name="flowRelateType1" type="radio" class="forsingle radio_com" checked="checked" value="0"/> ${ctp:i18n("subflow.setting.relate.0")}
                            </label>
                        </div>
                    </td>
                    <td nowrap="nowrap" colspan="2">
                        <label class="margin_r_10 hand forinput">
                            <input id="flowRelateType12" name="flowRelateType1" type="radio" class="forsingle radio_com" value="1"/> ${ctp:i18n("subflow.setting.relate.1")}
                        </label>
                    </td>
                </tr>
                <tr>
                    <th nowrap="nowrap"><label class="margin_r_5" for="text"><span class="required">*</span>${ctp:i18n("subflow.setting.isCanViewByMain")}:</label></th>
                    <td>
                        <div class="common_radio_box clearfix">
                            <label class="margin_r_10 hand forinput">
                                <input id="isCanViewByMainFlow11" name="isCanViewByMainFlow1" type="radio" class="forsingle radio_com" checked="checked" value="true"/> ${ctp:i18n("common.true")}
                            </label>
                        </div>
                    </td>
                    <td>
                        <label class="margin_r_10 hand forinput">
                            <input id="isCanViewByMainFlow12" name="isCanViewByMainFlow1" type="radio" class="forsingle radio_com" value="false"/> ${ctp:i18n("common.false")}
                        </label>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <th nowrap="nowrap"><label class="margin_r_5" for="text"><span class="required">*</span>${ctp:i18n("subflow.setting.isCanViewMain")}:</label></th>
                    <td>
                        <div class="common_radio_box clearfix">
                            <label class="margin_r_10 hand forinput">
                                <input id="isCanViewMainFlow11" name="isCanViewMainFlow1" type="radio" class="forsingle radio_com" checked="checked" value="true"/> ${ctp:i18n("common.true")}
                            </label>
                        </div>
                    </td>
                    <td>
                        <label class="margin_r_10 hand forinput">
                            <input id="isCanViewMainFlow12" name="isCanViewMainFlow1" type="radio" class="forsingle radio_com" value="false"/> ${ctp:i18n("common.false")}
                        </label>
                    </td>
                    <td></td>
                </tr>
             </table>
        </div>
    </fieldset>
    <div class="fieldset_edit fixed" style="position:fixed">
        <span class="ico16 repeater_plus_16"  onclick="addANewFlow()" title="${ctp:i18n('workflow.subprocess.addone')}"></span><br>
        <span class="ico16 repeater_reduce_16" onclick="removeANewFlow()" title="${ctp:i18n('workflow.subprocess.deleteone')}"></span>
    </div>
    <div style="display:none">
        <fieldset id="newflow1Copy" class="margin_5 margin_l_20">
            <legend>${ctp:i18n('subflow.label')}</legend>
            <div class="form_area relative">
                <table border="0" cellspacing="0" cellpadding="0" width="100%" align="left">
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_5" for="text"><span class="required">*</span>${ctp:i18n("subflow.setting.selectFlow")}:</label></th>
                        <td width="100%" colspan="3"><div class="common_txtbox_wrap">
                            <input validate="type:'string',name:'${ctp:i18n("subflow.setting.selectFlow")}',notNull:true,isDeaultValue:true,deaultValue:'<${ctp:i18n('subflow.setting.selectFlow')}>'" class="validate input-100per cursor-hand" id="subFlowName" name="subFlowName" readonly="readonly" value="<${ctp:i18n('subflow.setting.selectFlow')}>" />
                            <input id="newflowTempleteId" name="newflowTempleteId" type="hidden" value=""/>
                        </div></td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_5" for="text"><span class="required">*</span>${ctp:i18n("subflow.setting.sender")}:</label></th>
                        <td>
                            <label class="margin_r_10 hand forinput">
                                <input id="sender3Value" name="sender0" type="radio" checked="checked" class="selectPeople radio_com" value="" />
                            </label>
                            <input id="sender3Name" type="text" name="sender3Name" value="${ctp:i18n('common.default.selectPeople.value')}" readonly deaultValue="${ctp:i18n('common.default.selectPeople.value')}"/>
                        </td>
                        <td nowrap="nowrap">
                            <div class="common_radio_box clearfix">
                                <label class="margin_r_10 hand forinput clearRed">
                                    <input id="sender1" name="sender0" type="radio" class="selectPeople radio_com" value="CurrentNode"/> ${ctp:i18n("subflow.setting.sender.currentNode")} &nbsp;&nbsp;
                                </label>
                            </div>
                        </td>
                        <td nowrap="nowrap">
                            <label class="margin_r_10 hand forinput clearRed">
                                <input id="sender2" name="sender0" type="radio" class="selectPeople radio_com" value="CurrentSender"/> ${ctp:i18n("subflow.setting.sender.CurrentSender")}
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_5" for="text">${ctp:i18n("subflow.setting.condition")}:</label></th>
                        <td nowrap="nowrap">
                            <div class="common_radio_box clearfix">
                                <label class="margin_r_10 hand forinput clearRed">
                                    <input id="formFlowCondition1NameRadio1" name="formFlowCondition1NameRadio0" type="radio" class="forsingle radio_com" value="0" checked/> ${ctp:i18n("common.none")}
                                </label>
                            </div>
                        </td>
                        <td colspan="2">
                            <input id="formFlowCondition1Title" name="formFlowCondition1Title" type="hidden" value=""/>
                            <input id="formFlowCondition1Value" name="formFlowCondition1Value" type="hidden" value=""/>
                            <input id="formFlowCondition1IsForce" name="formFlowCondition1IsForce" type="hidden" value="0"/>
                            <input id="formFlowCondition1Base" name="formFlowCondition1Base" type="hidden" value="currentNode"/>
                            <!-- <input id="formFlowCondition1Id" name="formFlowCondition1Id" type="hidden" value=""/>
                            <input id="formFlowCondition1IdAdd" name="formFlowCondition1IdAdd" type="hidden" value=""/> -->
                            <label class="margin_r_10 hand forinput condition">
                                    <input id="formFlowCondition1NameRadio2" name="formFlowCondition1NameRadio0" type="radio" class="forsingle radio_com" value="1"/>
                            </label>
                            <input type="text" id="formFlowCondition1Name" name="formFlowCondition1Name" readonly="readonly" class="condition" value="${ctp:i18n('subflow.condition.tip')}" deaultValue="${ctp:i18n('subflow.condition.tip')}"/>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_5" for="text"><span class="required">*</span>${ctp:i18n("subflow.setting.relate")}:</label></th>
                        <td nowrap="nowrap">
                            <div class="common_radio_box clearfix">
                                <label class="margin_r_10 hand forinput">
                                    <input id="flowRelateType11" name="flowRelateType0" type="radio" class="forsingle radio_com" checked="checked" value="0"/> ${ctp:i18n("subflow.setting.relate.0")}
                                </label>
                            </div>
                        </td>
                        <td nowrap="nowrap" colspan="2">
                            <label class="margin_r_10 hand forinput">
                                <input id="flowRelateType12" name="flowRelateType0" type="radio" class="forsingle radio_com" value="1"/> ${ctp:i18n("subflow.setting.relate.1")}
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_5" for="text"><span class="required">*</span>${ctp:i18n("subflow.setting.isCanViewByMain")}:</label></th>
                        <td>
                            <div class="common_radio_box clearfix">
                                <label class="margin_r_10 hand forinput">
                                    <input id="isCanViewByMainFlow11" name="isCanViewByMainFlow0" type="radio" class="forsingle radio_com" checked="checked" value="true"/> ${ctp:i18n("common.true")}
                                </label>
                            </div>
                        </td>
                        <td>
                            <label class="margin_r_10 hand forinput">
                                <input id="isCanViewByMainFlow12" name="isCanViewByMainFlow0" type="radio" class="forsingle radio_com" value="false"/> ${ctp:i18n("common.false")}
                            </label>
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_5" for="text"><span class="required">*</span>${ctp:i18n("subflow.setting.isCanViewMain")}:</label></th>
                        <td>
                            <div class="common_radio_box clearfix">
                                <label class="margin_r_10 hand forinput">
                                    <input id="isCanViewMainFlow11" name="isCanViewMainFlow0" type="radio" class="forsingle radio_com" checked="checked" value="true"/> ${ctp:i18n("common.true")}
                                </label>
                            </div>
                        </td>
                        <td>
                            <label class="margin_r_10 hand forinput">
                                <input id="isCanViewMainFlow12" name="isCanViewMainFlow0" type="radio" class="forsingle radio_com" value="false"/> ${ctp:i18n("common.false")}
                            </label>
                        </td>
                        <td></td>
                    </tr>
                 </table>
            </div>
        </fieldset>
    </div>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowEditSubProcess_js.jsp"%>
</body>
</html>