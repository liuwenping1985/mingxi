<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>form</title>
    </head>
    <body class="page_color">
    	<div id='layout'>
	        <div class="layout_center bg_color_white" id="center">
				 <div class="form_area padding_tb_5 padding_l_10" id="form">
	                <table border="0" cellspacing="0" cellpadding="0">
	                  <tr>
	                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('form.base.formname.label')}:</label></th>
	                    <td width="400"><DIV class=common_txtbox_wrap><input readonly="readonly" type="text" id="formTitle" class="w100b" value="${formBean.formName }"/></DIV></td>
	                  </tr>
	                </table>
	             </div>
	             
	             <!--左右布局-->
				 <div class="layout clearfix code_list padding_tb_5 padding_l_10" style="height: 100%;">
				  <form action="${path }/form/bindDesign.do?method=saveFlowTemplate" id="saveForm">
	            	<div class="col2" id="bindSet" style="float: left;width:59%">
	                	<div class="common_txtbox clearfix margin_b_5">
							<label class="margin_r_10 left margin_t_5" for="text">${ctp:i18n('form.bind.set.label')}:</label>
							<a class="common_button common_button_gray" href="javascript:void(0)" id="newBind">${ctp:i18n('form.trigger.triggerSet.add.label')}</a>
						</div>
						<fieldset class="form_area padding_10" id="editArea">
							<legend>${ctp:i18n('form.pagesign.appbind.label')}</legend>
								<table width="100%" border="0" cellpadding="2" cellspacing="0" id="templateNameSet">
									<tr height="30px">
										<td width="10%" align="right" nowrap="nowrap">
                                            <label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('form.bind.templatename.label')} ：</label>
                                        </td>
										<td nowrap="nowrap" width="100%">
										    <DIV class=common_txtbox_wrap>
										    <input id="id" name="id" class="w100b" type="hidden">
										    <input readonly="readonly" id="subject" name="${ctp:i18n('form.seeyontemplatename.label')}" class="w100b validate" type="text" maxlength="60" validate="notNullWithoutTrim:true,type:'string',notNull:true,maxLength:60,avoidChar:'&&quot;&lt;&gt;'">
										    </DIV>
										</td>
										<td>
										</td>
									</tr>
									<tr height="30px" >
										<td align="right" nowrap="nowrap">
                                            <label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('form.bind.flow.label')}：</label>
                                        </td>
										<td>
										    <div class=common_txtbox_wrap>
										    <input id="isFlowCopy" name="isFlowCopy" type="hidden" value='0'>
										    <input id="process_id" name="process_id" type="hidden">
										    <input id="process_xml" name="process_xml" type="hidden">
										    <input id="process_desc_by" name="process_desc_by" type="hidden">
										    <input id="process_subsetting" name="process_subsetting" type="hidden">
										    <input id="process_rulecontent" name="process_rulecontent" type="hidden">
										    <input id="workflow_newflow_input" name="workflow_newflow_input" type="hidden">
										    <input id="workflow_node_peoples_input" name="workflow_node_peoples_input" type="hidden">
										    <input id="workflow_node_condition_input" name="workflow_node_condition_input" type="hidden">
										    <input id="process_xml_clone" name="process_xml_clone" type="hidden">
										    <input id="process_xml_clone2flowCopy" name="process_xml_clone2flowCopy" type="hidden">
										    <input id="process_event" name="process_event" type="hidden">
										    <input readonly="readonly" id="process_info" name="${ctp:i18n('form.bind.flow.label')}" class="w100b validate" validate="errorMsg:'${ctp:i18n('form.bind.flow.label')}${ctp:i18n('form.base.notnull.label')}',type:'string',notNull:true">
										    </div>
										</td>
										<td nowrap="nowrap">
										<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="newFlowSet" title="${ctp:i18n('form.bind.newFlow')}">${ctp:getLimitLengthString(ctp:i18n('form.bind.newFlow'), 8, '...')}</a>
										<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="updateFlowSet" title="${ctp:i18n('form.bind.editFlow')}">${ctp:getLimitLengthString(ctp:i18n('form.bind.editFlow'), 8, '...')}</a>
										<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="flowCopy" title="${ctp:i18n('form.bind.copyFrom')}...">${ctp:getLimitLengthString(ctp:i18n('form.bind.copyFrom'), 8, '...')}</a>
										</td>
									</tr>
									<tr height="30px" >
										<td align="right" nowrap="nowrap">
                                            <label class="margin_r_10" for="text"><font color="red"></font>${ctp:i18n('form.bind.formFlowTitle')}：</label>
                                        </td>
										<td nowrap="nowrap" >
										    <div class=" common_txtbox_wrap">
										    <input readonly="readonly" id="colSubject" name="colSubject" type="text" class="w100b validate" validate="type:'string',china3char:true,maxLength:255,name:'${ctp:i18n('form.bind.formFlowTitle')}'">
										    </div>
										</td>
										<td>
										<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="formTitleSet">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
										&nbsp;
										<label id="updateSubjectLabel" class="margin_r_10 hand" for="updateSubject">
											<input disabled="disabled" id="updateSubject" class="radio_com" value="1" type="checkbox" name="updateSubject">
											${ctp:i18n('form.bind.formFlowTitle.autoRefresh')}
										</label>
										</td>
									</tr>
                                    <!-- 关联文档 -->
									<tr height="30px">
										<td align="right" nowrap="nowrap">
                                            <label class="margin_r_10" for="text"><font color="red"></font>${ctp:i18n('form.input.extend.document.label')}：</label>
                                        </td>
										<td nowrap="nowrap" >
										 <div class=" common_txtbox_wrap" id="rel_doc_div" style="min-height: 24px;">
										    <div id="rel_doc" class="comp" comp="type:'assdoc',attachmentTrId:'rel_doc',canFavourite:false,modids:'2,3'"></div>
                                         </div>
										</td>
										<td>
										<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="relDocSet" title="${ctp:i18n('form.input.extend.document.label')}">${ctp:i18n('form.input.extend.document.label')}</a>
										</td>
									</tr>
                                    <!-- 本地文件 -->
									<tr height="30px">
										<td align="right" nowrap="nowrap">
                                            <label class="margin_r_10" for="text"><font color="red"></font>${ctp:i18n('common.toolbar.insert.localfile.label')}：</label>
                                        </td>
										<td nowrap="nowrap" >
										     <div class=" common_txtbox_wrap" id="fileArea" isGrid="true" style="min-height: 24px;">
										     <input id="uploadFile" name="uploadFile" type="text" class="comp" comp="type:'fileupload',applicationCategory:'1',canFavourite:false,canDeleteOriginalAtts:true,originalAttsNeedClone:false">
										    </div>
										</td>
										<td>
										<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="uploadSet" title="${ctp:i18n('form.bind.upload.label')}">${ctp:i18n('form.bind.upload.label')}</a>
										</td>
									</tr>
                                    <!-- 重要程度 -->
									<tr height="30px">
										<td align="right" nowrap="nowrap">
                                            <label class="margin_r_10" for="text"><font color="red"></font>${ctp:i18n('common.importance.label')}：</label>
                                        </td>
										<td nowrap="nowrap" >
										    <div class=" common_selectbox_wrap">
										    <select disabled="disabled" id="importantLevel" name="importantLevel" class="w100b codecfg" codecfg="codeId:'common_importance'">
										    </select>
										    </div>
										</td>
										<td>
										</td>
									</tr>
									<c:if test ="${ctp:hasPlugin('project')}">
                                    <!-- 关联项目，需要有插件才显示 -->
									<tr height="30px">
										<td align="right" nowrap="nowrap">
                                            <label class="margin_r_10" for="text"><font color="red"></font>${ctp:i18n('form.bind.relationProject.label')}：</label>
                                        </td>
										<td nowrap="nowrap" >
										    <div class=" common_selectbox_wrap">
										    <select disabled="disabled" id="projectId" name="projectId" class="w100b">
										    <option selected="selected" value="">${ctp:i18n('form.timeData.none.lable')}</option>
										    <c:forEach var="p" items="${project }">
										    	<option value="${p.id }">${fn:escapeXml(p.projectName)}</option>
										    </c:forEach>
										    </select>
										    </div>
										</td>
										<td>
										</td>
									</tr>
									</c:if>
                                    <!-- 自动发起 -->
                                    <tr height="30px">
                                        <td align="right" nowrap="nowrap">
                                            <label class="margin_r_10" for="text">${ctp:i18n('form.bind.set.autosend.label')}：</label>
                                        </td>
                                        <td nowrap="nowrap">
                                            <div class="common_selectbox_wrap">
                                                <select disabled="disabled" id="cycleState" name="cycleState" class="w100b">
                                                    <option value="0" selected="selected">${ctp:i18n('form.timeData.none.lable')}</option>
                                                    <option value="1">${ctp:i18n('form.timeData.exist.lable')}</option>
                                                </select>
                                                <input type="hidden" id="cycleSender" name="cycleSender" value="" />
                                                <input type="hidden" id="cycleSender_txt" name="cycleSender_txt" value="" />
                                                <input type="hidden" id="cycleStartDate" name="cycleStartDate" value="" />
                                                <input type="hidden" id="cycleEndDate" name="cycleEndDate" value="" />
                                                <input type="hidden" id="cycleType" name="cycleType" value="" />
                                                <input type="hidden" id="cycleMonth" name="cycleMonth" value="" />
                                                <input type="hidden" id="cycleOrder" name="cycleOrder" value="" />
                                                <input type="hidden" id="cycleDay" name="cycleDay" value="" />
                                                <input type="hidden" id="cycleWeek" name="cycleWeek" value="" />
                                                <input type="hidden" id="cycleHour" name="cycleHour" value="" />
                                            </div>
                                        </td>
                                        <td>
                                            <a class="common_button common_button_disable common_button_gray margin_l_5" style="display: none;" href="javascript:void(0)" id="cycleStateBtn">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
                                        </td>
                                    </tr>
                                    <!-- 流程期限 -->
									<tr height="30px">
										<td align="right" nowrap="nowrap">
                                            <label class="margin_r_10" for="text"><font color="red"></font>${ctp:i18n('form.bind.flowCycle')}：</label>
                                        </td>
										<td nowrap="nowrap" >
										    <div class=" common_selectbox_wrap">
										    <input type="hidden" id="oldDeadlineValue">
										    <select disabled="disabled" id="deadline" name="deadline" class="w100b codecfg" codecfg="codeId:'collaboration_deadline'">
										    </select>
										    </div>
										</td>
										<td>
										</td>
									</tr>
                                    <!-- 基准时长 -->
									<tr height="30px">
										<td align="right" nowrap="nowrap">
                                            <label class="margin_r_10" for="text"><font color="red"></font>${ctp:i18n('common.reference.time.label')}：</label>
                                        </td>
										<td nowrap="nowrap" >
										    <div class=" common_selectbox_wrap">
										    <select disabled="disabled" id="standardDuration" name="standardDuration" class="w100b codecfg" codecfg="codeId:'collaboration_deadline'">
										    </select>
										    </div>
										</td>
										<td>
										</td>
									</tr>
                                    <!-- 提醒 -->
									<tr height="30px">
										<td align="right" nowrap="nowrap">
                                            <label class="margin_r_10" for="text"><font color="red"></font>${ctp:i18n('common.remind.time.label')}：</label>
                                        </td>
										<td nowrap="nowrap" >
										    <div class=" common_selectbox_wrap">
										    <select disabled="disabled" id="advanceremind" name="advanceremind" class="w100b codecfg" codecfg="codeId:'common_remind_time'">
										    </select>
										    </div>
										</td>
										<td>
										</td>
									</tr>
									<c:if test="${ctp:hasPlugin('doc')}">
                                    <!-- 预归档，需要有文档插件才显示 -->
									<tr height="30px">
										<td align="right" nowrap="nowrap">
                                            <label class="margin_r_10" for="text"><font color="red"></font>${ctp:i18n('form.bind.pigeonhole.label')}：</label>
                                        </td>
										<td nowrap="nowrap" >
										    <div class=" common_selectbox_wrap">
										    <select disabled="disabled" id="archiveId" class="w100b">
                                                <option selected="selected" value="">${ctp:i18n('form.timeData.none.lable')}</option>
                                                <option value="1">${ctp:i18n('form.bind.selectTo')}</option>
										    </select>
                                            <input type="hidden" id="archiveName" name="archiveName" value="" />
                                            <input type="hidden" id="archiveFieldName" name="archiveFieldName" value="" />
                                            <input type="hidden" id="archiveIsCreate" name="archiveIsCreate" value="true" />
											<input type="hidden" id="archiveText" name="archiveText" value="" />
											<input type="hidden" id="archiveTextName" name="archiveTextName" value="" />
											<input type="hidden" id="archiveKeyword" name="archiveKeyword" value="" />
											<input type="hidden" id="archiveAttachment" name="archiveAttachment" value="" />
											<input type="hidden" id="attachmentArchiveName" name="attachmentArchiveName" value="" />
											<input type="hidden" id="attachmentArchiveId" name="attachmentArchiveId" value="" />
										    </div>
										</td>
										<td>
                                            <span class="margin_l_5 disabled_color" id="advancePigeonhole">[${ctp:i18n('form.formlist.advanced')}]</span>
										</td>
									</tr>
									</c:if>
                                    <!-- 显示明细，预归档用 -->
									<tr height="30px" class="hidden" id="authDetail">
										<td align="right" nowrap="nowrap">
                                            <label class="margin_r_10" for="text"><font color="red"></font>${ctp:i18n('form.query.showdetails.label')}：</label>
                                        </td>
										<td nowrap="nowrap">
										<table width="100%">
										<c:forEach items="${formBean.formViewList}" var="formView">
											<tr>
											<td  width="50%">
											<input type="checkbox" id="view_${formView.id }" value="${formView.id }"/><label for="view_${formView.id }" title="${formView.formViewName}">${ctp:getLimitLengthString(formView.formViewName , 20, '...')}</label>
											</td>
											<td width="50%">
											<div class="common_selectbox_wrap">
											<select id="auth_${formView.id }" style="width: 100%">
											<c:forEach items="${formView.operations}" var="auth">
												<option value="${auth.id }">${auth.name }</option>
										    </c:forEach>
										    </select>
										    </div>
										    </td>
										    </tr>
										</c:forEach>
										</table>
										</td>
										<td>
										</td>
									</tr>
                                    <!-- 是否追溯流程 -->
									<tr height="30px">
										<td align="right" nowrap="nowrap">
                                            <label class="margin_r_10" for="text"><font color="red"></font>${ctp:i18n("form.bind.isNoProcess.label")}</label>
                                        </td>
										<td nowrap="nowrap" >
										    <div class=" common_selectbox_wrap">
										    <select disabled="disabled" id="canTrackWorkFlow" name="canTrackWorkFlow" class="w100b">
										    <option selected="selected" value="0">${ctp:i18n("collaboration.newcoll.undoRollback")}</option>
										    <option value="1">${ctp:i18n("collaboration.newcoll.trace")}</option>
										    <option value="2">${ctp:i18n("collaboration.newcoll.noTrace")}</option>
										    </select>
										    </div>
										</td>
										<td>
										</td>
									</tr>
                                    <!-- 流程操作的一些开关 -->
									<tr height="30px">
										<td align="right" nowrap="nowrap">
                                            <label class="margin_r_10" for="text"><font color="red"></font></label>
                                        </td>
										<td>
											<fieldset>
										    <div class="common_checkbox_wrap" >
										    	<LABEL class="margin_r_10 hand" for=canForward><INPUT disabled="disabled" checked="checked" id=canForward class=radio_com value=1 type=checkbox name=canForward>${ctp:i18n('collaboration.allow.transmit.label')}</LABEL>
										    	<LABEL class="margin_r_10 hand" for=canModify><INPUT disabled="disabled" checked="checked" id=canModify class=radio_com value=1 type=checkbox name=canModify>${ctp:i18n('collaboration.allow.chanage.flow.label')}</LABEL>
												<c:if test="${ctp:hasPlugin('doc')}">
												<LABEL class="margin_r_10 hand" for=canArchive><INPUT disabled="disabled" checked="checked" id=canArchive class=radio_com value=1 type=checkbox name=canArchive>${ctp:i18n('collaboration.allow.pipeonhole.label')}</LABEL>
												</c:if>
												<LABEL class="hand" for=canEditAttachment><INPUT disabled="disabled" id=canEditAttachment class=radio_com value=1 type=checkbox name=canEditAttachment>${ctp:i18n('collaboration.allow.edit.attachment.label')}</LABEL>
										    </div>
												<div>
												<LABEL class="margin_r_10 hand" for=canMergeDeal><INPUT disabled="disabled" id=canMergeDeal class=radio_com value=1 type=checkbox name=canMergeDeal>${ctp:i18n('collaboration.allow.canmergedeal.label')}</LABEL>
												</div>
												<div>
												<LABEL class="margin_r_10 hand" for=canAnyMerge><INPUT disabled="disabled" id=canAnyMerge onclick=canAnyMergeClk(this) class=radio_com value=1 type=checkbox name=canAnyMerge>${ctp:i18n('collaboration.allow.before.same.merge.label')}</LABEL>
												</div>
										    </fieldset>
										</td>
										<td>&nbsp;</td>
									</tr>
                                    <!-- 模板编号 -->
									<tr height="30px">
										<td align="right" nowrap="nowrap">
                                            <label class="margin_r_10" for="text"><font color="red"></font>${ctp:i18n('form.bind.template.number.label')}：</label>
                                        </td>
										<td >
											<div class=" common_txtbox_wrap">
										    <input readonly="readonly" id="templateNumber" name="templateNumber" type="text" class="w100b validate" validate="errorMsg:'${ctp:i18n('form.bind.template.number.alert.label')}',type:'string',maxLength:20,regExp:/^[A-Za-z0-9_]*$/">
										    </div>
										</td>
										<td>
										</td>
									</tr>
									<tr>
										<td>
										</td>
										<td colspan="2">
										 <div style="font_size12">
										    <font color="green">${ctp:i18n('form.bind.template.number.description.label')}</font>
										    </div>
										</td>
									</tr>
                                    <!-- 督办人员 -->
									<tr height="30px">
										<td align="right" nowrap="nowrap">
                                            <label class="margin_r_10" for="text"><font color="red"></font>${ctp:i18n('form.flow.templete.super')}：</label>
                                        </td>
										<td nowrap="nowrap" >
										    <div class=" common_txtbox_wrap">
										    <input readonly="readonly" id="showSupervisors" name="showSupervisors" type="text" class="w100b">
										    <!--  <input readonly="readonly" id="supervisor" name="supervisor" type="hidden"> -->
										    <%@ include file="/WEB-INF/jsp/common/supervise/supervise.js.jsp" %> 
										    </div>
										</td>
										<td>
										<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="supervisorSet">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
										</td>
									</tr>
									<tr>
									   <td></td>
									   <td colspan="2">
										<div class="common_checkbox_wrap">
										<LABEL class="margin_r_10 hand" for=canSupervise><input disabled="disabled" id="canSupervise" class="radio_com" name="canSupervise" value="1" type="checkbox" checked="checked">${ctp:i18n('form.bind.allowToSupervise')}</LABEL>
										</div>
									   </td>
									</tr>
                                    <!-- 关联表单授权 -->
									<tr height="30px" id="authRelationTR">
										<td align="right" nowrap="nowrap">
                                            <label class="margin_r_10" for="text"><font color="red"></font>${ctp:i18n('form.bind.relationform.auth.set.label')}：</label>
                                        </td>
										<td nowrap="nowrap" >
										    <div class=" common_txtbox_wrap">
										    <input readonly="readonly" id="authRelation_txt" name="authRelation_txt" type="text" class="w100b">
										    <input readonly="readonly" id="authRelation" name="authRelation" type="hidden">
										    </div>
										</td>
										<td>
										<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="relationAuthSet">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
										</td>
									</tr>
									<tr id="authRelationAlertTR">
										<td>
										</td>
										<td colspan="2">
										 <div class="font_size12">
										    <font color="green">${ctp:i18n('form.bind.relation.auth.alert.label')}</font>
										    </div>
										</td>
									</tr>
                                    <!-- 调用授权 -->
									<tr height="30px">
										<td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
											color="red"></font>${ctp:i18n('form.bizmap.invokeAuthorize.label')}：</label></td>
										<td nowrap="nowrap" >
										    <div class=" common_txtbox_wrap">
										    <input readonly="readonly" id="auth_txt" name="auth_txt" type="text" class="w100b">
										    <input readonly="readonly" id="auth" name="auth" type="hidden">
										    </div>
										</td>
										<td>
										<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="authSet">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
										</td>
									</tr>
									<tr height="35px">
										<td align="right" width="30%"></td>
										<td >
                                            <!-- 允许扫码录入设置 -->
											<label class="margin_r_10 hand" for="scanCodeInput">
												<input name="scanCodeInput" class="radio_com scanCodeInput" disabled="disabled" id="scanCodeInput" type="checkbox"  value="1">${ctp:i18n("form.barcode.allow.scaninput.label")}</label>
											<!--wxj 设置是否点赞开关  -->
											<label class="margin_r_10 hand" for="canPraiseinput">
												<input name="canPraiseinput" class="radio_com canPraiseInput" disabled="disabled" id="canPraiseinput" type="checkbox"  value="1" checked="checked">${ctp:i18n("form.barcode.allow.likes.label")}
											</label>
										</td>
									</tr>
									<!--wxj 相关数据一键复制  -->
									<tr height="35px">
                                        <td align="right" width="30%"></td>
                                        <td nowrap="nowrap">
                                            <label class="margin_r_10 hand" for="canCopyInput">
                                                <input name="canCopyInput" class="radio_com canCopyInputs" disabled="disabled" id="canCopyInput" type="checkbox"  value="1" checked="checked">${ctp:i18n("form.barcode.allow.copy.label")}
                                            </label>
                                        </td>
                                    </tr>
									<!-- 默认保护签章全字段 -->
									<tr height="35px">
										<td align="right" width="30%"></td>
										<td nowrap="nowrap">
											<label class="margin_r_10 hand" for="signetProtectInput">
												<input name="signetProtectInput" class="radio_com scanCodeInput" disabled="disabled" id="signetProtectInput" type="checkbox"  value="1" checked="checked">${ctp:i18n("form.signet.auto.protect.all")}
											</label>
										</td>
									</tr>
								</table>
						<div align="center" id="buttonDiv">
							<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="saveSet">${ctp:i18n('common.button.ok.label')}</a>
							<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="cancelSet">${ctp:i18n('common.button.cancel.label')}</a>
						</div>
						</fieldset>
	                </div>
	                </form>
	                <div class="col2 margin_l_5 <c:if test="${formBean.formType==baseInfo }">hidden </c:if>" style="float: left;width:40%;height: 100%">
	                	<div class="common_txtbox clearfix margin_tb_5">
							<label class="margin_r_10 left margin_t_5" for="text">${ctp:i18n('form.bind.bindList')}:</label>
							<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="updateTemplate">${ctp:i18n('common.button.modify.label')}</a>
							<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="delTemplate">${ctp:i18n('common.button.delete.label')}</a>
							<c:if test="${v3x:getSysFlag('col_showwfsimulation') && ctp:hasPlugin('workflowAdvanced')}">
								<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="simulation" title="${ctp:i18n('system.menuname.WorkflowSimulation')}">${ctp:i18n('system.menuname.WorkflowSimulation')}</a>
							</c:if>
							<c:if test="${ctp:hasResourceCode('T05_wfdynamic') == true}">
								<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="dynamicFlowForm">${ctp:i18n('common.detail.label.dynamic.wf.form')}</a>
							</c:if>
						</div>
						<div  style="height: 80%;">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table">
		                    <thead>
		                        <tr>
		                            <th width="1%"><input type="checkbox" onclick="selectAll(this,'templateBody')"/></th>
		                            <th align="center">${ctp:i18n('form.seeyontemplatename.label')}</th>
		                        </tr>
		                    </thead>
		                    <tbody id="templateBody" >
		                    	<c:forEach var="it" items="${formBean.bind.flowTemplateList }" varStatus="status">
			                    		<tr class="hand <c:if test="${(status.index % 2) == 1 }">erow</c:if>"  style="height: 30px;">
		                            		<td id="selectBox"><input type="checkbox" value="${it.id }" workflowId="${it.workflowId}"/></td>
		                            		<td onclick="showTemplate(this,'${it.id }')">${it.subject }</td>
		                        		</tr>
		                        		</c:forEach>
		                    </tbody>
		                 </table>
						</div>
	                </div>
				</div>
	        </div>
		</div>
	</body>
	<%@ include file="../../common/common.js.jsp" %>
	<script type="text/javascript">
	  $.fn.fillform = function(fillData) {
		    if (this[0] == null)
		      return;
		    this.each(function(i) {
		      var frm = $(this);
		      frm.resetValidate();
		      for ( var fi in fillData) {
		        $("#" + fi, frm).each(function(i) {
		          $(this).fill(fillData[fi], fi, frm);
		        });
		      }
		      frm = null;
		    });
		  };

		  $.fn.fill = function(v, fi, frm) {
		    var el = this[0], eq = $(el), tag = el.tagName.toLowerCase();
		    if (v && typeof v == "string")
		      v = v.replace(/<\/\/script>/gi, "<\/script>");
		    var t = el.type, val = el.value;
		    switch (tag) {
		      case "input":
		        switch (t) {
		          case "text":
		            eq.val(v);
		            break;
		          case "hidden":
		            var cp = eq.attrObj("_comp"), ctp;
		            if (cp) {
		              ctp = cp.attr("compType");
		              if (ctp === "selectPeople") {
		                var pv = "", pt = "";
		                if (v && v.startsWith("{")) {
		                  v = $.parseJSON(v);
		                  cp.comp(v);
		                  pv = v.value;
		                  pt = v.text;
		                }
		                cp.val(pt);
		                eq.val(pv);
		                break;
		              }
		            }
		            eq.val(v);
		            break;
		          case "checkbox":
		            if (v == val)
		              el.checked = true;
		            else
		              el.checked = false;
		            break;
		          case "radio":
		            if (frm) {
		              $("input[type=radio]", frm).each(
		                  function() {
		                    if ((this.id == fi || this.name == fi) && v == this.value
		                        && !this.checked)
		                      this.checked = true;
		                  });
		            } else if (v == el.value && !el.checked) {
		              el.checked = true;
		            }
		        }
		        break;
		      case "textarea":
		        eq.val(v);
		        break;
		      case "select":
		        switch (t) {
		          case "select-one":
		            eq.val(v);
		            break;
		          case "select-multiple":
		            var ops = el.options;
		            var sv = v.split(",");
		            for ( var i = 0; i < ops.length; i++) {
		              var op = ops[i];
		              // extra pain for IE...
		              var opv = $.browser.msie && !(op.attributes['value'].specified) ? op.text
		                  : op.value;
		              for ( var j = 0; j < sv.length; j++) {
		                if (opv == sv[j]) {
		                  op.selected = true;
		                }
		              }
		            }
		        }
		        break;
		      default:
		        if (!((!v || v == '') && $(this)[0].innerHTML.indexOf('&nbsp;') != -1)) {
		          if(v && eq.parent('.text_overflow').length == 1) {
		            eq.attr('title', v);
		          }
		          if (v && typeof v == "string")
		            v = v.replace(/\n/g, '<br/>');
		          el.innerHTML = v;
		        }
		    }
		  };
      function pigeonholeCallback(pige){
          var options = $("option",$("#archiveId"));
          var ids = options.length==3?(options.eq(2).val()+"."+options.eq(2).text()):null;
          if("cancel"!=pige&&""!=pige){
              var p = pige.split(",");
              if(ids!=null){
                  options.eq(2).remove();
              }
			  var bManager = new formBindDesignManager();
			  var fullPath = bManager.getDocResFullPath(p[0]);
              $("<option selected value='"+p[0]+"'>"+fullPath.escapeHTML()+"</option>").appendTo($("#archiveId"));
              $("#authDetail").removeClass("hidden");
              $(":checked","#authDetail").prop("checked",false);
              $("#archiveName").val(fullPath);
              $("#archiveFieldName").val("");
              $("#archiveIsCreate").val("true");
			  $("#archiveText").val("false");
			  $("#archiveTextName").val("");
			  $("#archiveKeyword").val("");
			  $("#archiveAttachment").val("false");
			  //$("#attachmentArchiveName").val("");
			  $("#archiveId").attr("title",fullPath.escapeHTML());
          }else{
              if(ids!=null){
                  options.eq(2).prop("selected",true);
              }else{
                  options.eq(0).prop("selected",true);
              }
          }
          if ($.browser.msie) { //clone出来的选择框在IE9的情况下重新赋值后会有问题
              for (var i = 0; i < options.length; i++) {
                  options[i].innerText = options[i].text + (i == 0 ? " " : "");
                  options[i].text = options[i].text + (i == 0 ? " " : "");
              }
          }
      }
      var defaultPolicyId = '${defaultPolicyId}';
      var defaultPolicyName = '${defaultPolicyName}';
      var dialog ;
	$(document).ready(function(){

		if (!${redTemplete}) {
			$("#archiveText").val("false");
			$("#archiveTextName").val("");
			$("#archiveAttachment").val("false");
			$("#attachmentArchiveName").val("");

		}

		if(!${ctp:hasPlugin("formAdvanced")}){
			$("#authRelationTR").hide();
			$("#authRelationAlertTR").hide();
			$("#advancePigeonhole").hide();
		}
        new MxtLayout({
            'id': 'layout',
            'centerArea': {
                'id': 'center',
                'border': false
            }
        });
        if(!${formBean.newForm }){
            parent.ShowBottom({'show':['doSaveAll','doReturn']});
        }else{
            parent.ShowBottom({'show':['upStep','nextStep','finish'],'source':{'upStep':'../report/reportDesign.do?method=index','nextStep':'../form/triggerDesign.do?method=index'}});
        }
        parent.closeProcessBar();
        $("#archiveId").change(function(){
        	var options = $("option",$(this));
        	var ids = options.length==3?(options.eq(2).val()+"."+options.eq(2).text()):null;
			if($(this).val()=="1"){
            	var pige = pigeonhole(2,null,false,false,"fromTempleteManage","pigeonholeCallback");
            }else if("" == $(this).val()){
            	if(ids!=null){
            		$("option:eq(2)",$(this)).remove();
            	}
            	$("#authDetail").removeClass("hidden").addClass("hidden");
            	$("#archiveName").val("");
            	$("#archiveFieldName").val("");
                $("#archiveIsCreate").val("true");
				$("#archiveText").val("");
				$("#archiveTextName").val("");
				$("#archiveKeyword").val("");
				$("#archiveId").attr("title","");
            }else{
            	$("#authDetail").removeClass("hidden");
            }
            if($.browser.msie){//clone出来的选择框 在IE9的情况下 重新赋值后会有问题
        		for(var i=0; i<this.options.length; i++){
        			this.options[i].innerText = this.options[i].text+(i==0?" ":"");
        			this.options[i].text = this.options[i].text+(i==0?" ":"");
        		}
        	}
        });
		$("#relDocSet").click(function(){
			if($(this).hasClass("common_button_disable")){
                return false;
            }
			quoteDocument('rel_doc');
		});
		 /**
		   * 为表单/协同/公文创建或修改流程模版
		   * @tWindow 目标窗口window对象
		   * @appName 应用类型
		   * @formApp 表单应用ID
		   * @formName 表单ID
		   * @ptemplateId 流程模版ID
		   * @vWindow 值回写window对象
		   * @defaultPolicyId 默认节点权限ID
		   * @currentUserId 当前用户ID
		   * @currentUserName 当前用户名称
		   * @currentUserAccountName 当前用户单位名称
		   * @flowPermAccountId 当前单位ID
		   * @operationName 表单默认视图权限（不是表单模版的话可传为null或不给出）非首节点默认
		   * @startOperationName 表单默认视图权限 首节点默认
		   * @defaultPolicyName 默认节点权限名称
		   */
		   var startOperationId = "${startOperation}";//默认开始节点表单权限
		   var nomorlOperationId = "${nomorlOperation}";//默认处理节点表单权限
        $("#newFlowSet").click(function(){
            if($(this).hasClass("common_button_disable")){
                return false;
            }
            $("#process_xml_clone").val($("#process_xml").val());
            $("#process_xml").val("");
            
            $("#process_xml_clone2flowCopy").val($("#process_xml").val());
            createWFTemplate(getCtpTop(),"collaboration", "${formBean.id}", "${formBean.formViewList[0].id}","",window,defaultPolicyId,"${CurrentUser.id}",'${fn:escapeXml(CurrentUser.name)}',"${CurrentUser.loginAccountName}","${CurrentUser.loginAccount}",nomorlOperationId,startOperationId,defaultPolicyName,"",$("#process_id").val());
        });
        $("#updateFlowSet").click(function(){
            if($(this).hasClass("common_button_disable")){
                return false;
            }
            if($("#process_xml").val()==""){
            	$("#process_xml").val($("#process_xml_clone").val());
            }
            $("#process_xml_clone2flowCopy").val($("#process_xml").val());
        	createWFTemplate(getCtpTop(),"collaboration", "${formBean.id}", "${formBean.formViewList[0].id}",$("#process_id").val(),window,defaultPolicyId,"${CurrentUser.id}",'${fn:escapeXml(CurrentUser.name)}',"${CurrentUser.loginAccountName}","${CurrentUser.loginAccount}",nomorlOperationId,startOperationId,defaultPolicyName);
        });
        $("#newBind").click(function(){
        	var _width;
        	var $td = $("#templateNameSet tr:eq(0) td:eq(1)");//放到初始化的页面加 不然会变宽
            if(!_width)
                _width = $td.width();
        	setInitState();
        	editState();
            $("#templateNameSet tr").each(function(i, t) {
                $td.children("div").css("width",_width);
            });
            $("#subject").val("${formBean.formName}");
          	//动态刷新按钮默认置灰
            $("#updateSubject").attr("checked",false);
			$("#updateSubject").attr("disabled","disabled");
			$("#updateSubjectLabel").addClass("color_gray");
        });
        $("#cancelSet").click(function(){
        	if($(this).hasClass("common_button_disable")){
                return false;
            }
        	setInitState();
        });
        $("#saveSet").click(function(){
        	if($(this).hasClass("common_button_disable")){
                return false;
            }
        	if($("#process_xml").val()==""){
            	$("#process_xml").val($("#process_xml_clone").val());
            }
        	if ($("#cycleSender").val() == "") {
                $("#cycleState").val("0");
            }
            /*if($("#process_info").val()==""||$("#process_info").val()=="undefined"||$("#process_info").val()=="null"){
                alert("流程不能为空!");
                return false;
            }
            if($("#subject").val()==""){
                alert("表单模板名称不能为空!");
                return false;
            }*/
            if($("#templateNameSet").validate({errorAlert:true,errorIcon:false})&&checkDetail()){
                $("#saveSet").prop("disabled",true);
            	var bManager = new formBindDesignManager();
                if($("#isFlowCopy").val()==2){
                    var ss = bManager.validateWorkFlowCopy($("#process_xml").val());
                    if("success" != ss){
                        $.alert(ss);
		                $("#saveSet").prop("disabled",false);
                        return;
                    }
                }
                var bindId= $("#id").val()==""?-1:$("#id").val();
                var ss = bManager.checkSameBindName(bindId,$("#subject").val());
                if("success" != ss){
                    $.alert($.i18n('form.bind.bindNameExist.label',$("#subject").val()));
		                $("#saveSet").prop("disabled",false);
                    return;
                }
                if($.trim($("#templateNumber").val())!=""){
                	var rem = bManager.checkSameCode(bindId,$("#templateNumber").val());
                	if(rem != "success"){
            			$.alert("${ctp:i18n('form.bind.template.number.alert.duple')}");
		                $("#saveSet").prop("disabled",false);
            			return false;
            		}
                }
                changePageNoAlert = true;
                getCtpTop().processBar =  getCtpTop().$.progressBar({text: "${ctp:i18n('form.bind.template.progressbar.info')}"});
                parent.hiddenAllBtn();
            	$("#editArea").jsonSubmit({domains:['templateNameSet','superviseDiv'],validate:false,action:$("#saveForm").prop('action')});
            }
        });
        $("#updateTemplate").click(function(){
        	if($(this).hasClass("common_button_disable")){
                return false;
            }
            var templateChecked = $(":checked","#templateBody");
            if(templateChecked.length!=1){
            	$.alert("${ctp:i18n('form.bind.chooseOneToUpdate')}");
                return false;
            }
            if (!validateFormData()){
            	return false;
            }
            setInitState();
            editState();
            initTemplateData(templateChecked.val(),null,true);
        });
        $("#delTemplate").click(function(){
        	if($(this).hasClass("common_button_disable")){
                return false;
            }
            var templateChecked = $(":checked","#templateBody");
            if(templateChecked.length<1){
            	$.alert("${ctp:i18n('form.query.querySet.chooseToDelete')}");
                return false;
            }
            if (!validateFormData()){
            	return false;
            }
            var tems = new Array(), workflowIds = [];
            templateChecked.each(function(){
                tems[tems.length] = $(this).val();
                workflowIds.push($(this).attr("workflowId"));
            });
            var result = wfAjax.getMainProcessTitleList(workflowIds);
            if(result && result.length>0){
                var alertMsg = $.i18n('Form.bind.deleteError.subFlow',result[0][0],result[0][1]);
                alertMsg = alertMsg.replace(/</g, "&lt;").replace(/>/g, "&gt;");
                $.alert(alertMsg);
                return;
            }
            $.confirm({
			    'msg' : "${ctp:i18n('form.query.querySet.deleteConfirm')}",
			    ok_fn : function() {
	                deleteTemplate(tems);
			    }
			 });
        });
		$("#simulation").click(function(){
			if($(this).hasClass("common_button_disable")){
                return false;
            }
            var templateChecked = $(":checked","#templateBody");
            if(templateChecked.length!=1){
            	$.alert("${ctp:i18n('form.bind.chooseOneToSimulation')}");
                return false;
            }
			var templateManagerService = new templateManager();
			var canUse = templateManagerService.templateCanUse(templateChecked.val());
			if(!canUse){
				$.alert("${ctp:i18n('form.bind.chooseTemplateNotSave')}");
				return false;
			}
            var url =_ctxPath+"/workflow/simulation.do?method=simulationMain&templateId="+templateChecked.val();
			var id = getMultyWindowId("id",templateChecked.val());
			openCtpWindow({
				"url"     : url,
				"id"		: "updateSimulation"+id
			});
		});
		//addby libing
		$("#dynamicFlowForm").click(function(){
			var dynamicDataFillBackValue ="";
			var defId = "${formBean.id}";
			dialog = $.dialog({
				width:620,
				height:450,
				targetWindow:getCtpTop(),
				transParams:window,
				url:_ctxPath + "/form/wfdynamic.do?method=flowDynamicFormSet&formDefId="+defId+"&dynamicDataFillBackValue="+dynamicDataFillBackValue,
			    title : "${ctp:i18n('common.detail.label.dynamic.wf.formset.js')}",//
			    buttons : [{
			      text : $.i18n('common.button.ok.label'),
			      id:"doOk",
				  isEmphasize: true,
			      handler : function() {
			    	  var retValue = dialog.getReturnValue({"operationId":"doOk"});
			    	 //dialog.close();
			      }
			    }, {
				      text : $.i18n('common.button.empty.label'),
				      id:"deleteAndExit",
					  isEmphasize: true,
				      handler : function() {
				    	  var retValue = dialog.getReturnValue({"operationId":"deleteAndExit"});
				    	 //dialog.close();
				      }
				    },{
			      text : $.i18n('common.button.cancel.label'),
			      id:"exit",
			      handler : function() {
			        dialog.close();
			      }
			    } ]
			});
		});
        $("#formTitleSet").click(function(){
        	if($(this).hasClass("common_button_disable")){
                return false;
            }
        	if($("#process_info").val()==""||$("#process_info").val()=="undefined"||$("#process_info").val()=="null"){
        		$.alert("${ctp:i18n('form.bind.setFlow.err')}");
                return false;
            }
        	setFlowTemplateTitle();
        });
        $("#uploadSet").click(function(){
        	if($(this).hasClass("common_button_disable")){
                return false;
            }
        	insertAttachment();
        });
        
        $("#cycleState").change(function(){
          if ($("#cycleState").val() == "0") {
            $("#cycleStateBtn").hide();
		    $("input",$("#cycleState").parent()).each(function(){
				$(this).val("");
			});
          } else {
            $("#cycleStateBtn").show();
          }
        });
        $("#cycleStateBtn").click(function(){
          if ($(this).hasClass("common_button_disable")) {
              return false;
          }
          
          var transParams={};
          transParams.cycleSender = $("#cycleSender").val();
          transParams.cycleSender_txt = $("#cycleSender_txt").val();
          transParams.cycleStartDate = $("#cycleStartDate").val();
          transParams.cycleEndDate = $("#cycleEndDate").val();
          transParams.cycleType = $("#cycleType").val();
          transParams.cycleMonth = $("#cycleMonth").val();
          transParams.cycleOrder = $("#cycleOrder").val();
          transParams.cycleDay = $("#cycleDay").val();
          transParams.cycleWeek = $("#cycleWeek").val();
          transParams.cycleHour = $("#cycleHour").val();
          
          dialog = $.dialog({
            url : "${path }/form/bindDesign.do?method=cycleSetting",
            title : "${ctp:i18n('form.bind.set.autosend.title.label')}",
            targetWindow : getCtpTop(),
            transParams : transParams,
            closeParam : {"show" : true, handler : function(){
              if ($("#cycleSender").val() == "") {
                $("#cycleState").val("0");
                $("#cycleStateBtn").hide();
              }
            }},
            width : 600,
            height : 300,
            buttons : [{
              text : "${ctp:i18n('common.button.ok.label')}",
              id : "ok",
			  isEmphasize: true,
              handler : function(){
                var re = dialog.getReturnValue();
                if(re){
                  $("#cycleSender").val(re.cycleSender);
                  $("#cycleSender_txt").val(re.cycleSender_txt);
                  $("#cycleStartDate").val(re.cycleStartDate);
                  $("#cycleEndDate").val(re.cycleEndDate);
                  $("#cycleType").val(re.cycleType);
                  $("#cycleMonth").val(re.cycleMonth);
                  $("#cycleOrder").val(re.cycleOrder);
                  $("#cycleDay").val(re.cycleDay);
                  $("#cycleWeek").val(re.cycleWeek);
                  $("#cycleHour").val(re.cycleHour);
                  
                  dialog.close();
                }
              }
            },{
              text : "${ctp:i18n('common.button.cancel.label')}",
              id : "cancel",
              handler : function(){
                if ($("#cycleSender").val() == "") {
                  $("#cycleState").val("0");
                  $("#cycleStateBtn").hide();
                }
                dialog.close(); 
              }
            }]
          });
        });
        $("#supervisorSet").click(function(){
        	if($(this).hasClass("common_button_disable")){
                return false;
            }
        	/**
        	 组件：督办设置窗口
        	 参数1：superviseType   superviseEnum枚举 0是模板 1是协同 2是公文
        	 参数2：isSubmit 是否直接提交 true or false 
        	 参数3：moduleId 主运用ID
        	参数4：templateId 模板Id
        	 */
        	openSuperviseWindow(0,false,null,"22",editSuperVise);
        });
        $("#advancePigeonhole").click(function(){
            if ($(this).hasClass("disabled_color")) {
                return false;
            }
            
            var parentFolder = $("#archiveId").find("option:selected");
            var parentFolderId = parentFolder.val();
            var parentFolderName = $("#archiveName").val();
            var fieldName = $("#archiveFieldName").val();
            var isCreate = $("#archiveIsCreate").val();
			var archiveText = $("#archiveText").val();
			var archiveTextName = $("#archiveTextName").val();
			var archiveKeyword = $("#archiveKeyword").val();
			var archiveAttachment = $("#archiveAttachment").val();
			var attachmentArchiveName = $("#attachmentArchiveName").val();
			var attachmentArchiveId = $("#attachmentArchiveId").val();

			dialog = $.dialog({
              url : "${path }/form/bindDesign.do?method=advancePigeonhole",
              title : "${ctp:i18n('form.bind.set.pigeonhole.content.label')}",
              targetWindow : getCtpTop(),
              transParams : {"parentFolderId" : parentFolderId, "parentFolderName" : parentFolderName,
				  "fieldName" : fieldName, "isCreate" : isCreate,
				  "archiveText" : archiveText, "archiveTextName" : archiveTextName, "archiveKeyword" : archiveKeyword,
				  "archiveAttachment" : archiveAttachment, "attachmentArchiveName" : attachmentArchiveName,"attachmentArchiveId":attachmentArchiveId},
              width : 500,
              height : 300,
              buttons : [{
                text : "${ctp:i18n('common.button.ok.label')}",
                id : "ok",
			    isEmphasize: true,
                handler : function() {
                  var re = dialog.getReturnValue();
                  if(re){
                    var reParentFolderId = re.parentFolderId;
                    var reParentFolderName = re.parentFolderName;
                    var reFieldName = re.fieldName;
                    var reFieldDisplay = re.fieldDisplay;
                    var reIsCreate = re.isCreate;
					var reArchiveText = re.archiveText;
					var reArchiveTextName = re.archiveTextName;
					var reArchiveKeyword = re.archiveKeyword;
					var reArchiveAttachment = re.archiveAttachment;
					var reArchiveFilePathName = re.attachmentArchiveName;
					var reArchivePathId = re.attachmentArchiveId;
					
					$("#archiveAttachment").val(reArchiveAttachment);//附件归档复选框
                    $("#attachmentArchiveName").val(reArchiveFilePathName);//附件归档目录
                    $("#attachmentArchiveId").val(reArchivePathId);//附件归档目录的ID
                    if (reParentFolderId != "") {
                      $("#archiveName").val(reParentFolderName);
                      var options = $("option", $("#archiveId"));
                      if (options.length == 3) {
                        options.eq(2).remove();
                      } else {
                        $("#authDetail").removeClass("hidden");
                        $(":checked", "#authDetail").prop("checked", false);
                      }
                      var optionText = reParentFolderName.escapeHTML();
                      if (reFieldName != "") {
                        $("#archiveFieldName").val(reFieldName);
                        $("#archiveIsCreate").val(reIsCreate);
                        optionText += "\\" + reFieldDisplay;
                      } else {
                        $("#archiveFieldName").val("");
                        $("#archiveIsCreate").val("true");
                      }
						$("<option selected value='" + reParentFolderId + "'>" + optionText + "</option>").appendTo($("#archiveId"));
						$("#archiveText").val(reArchiveText);
						$("#archiveTextName").val(reArchiveTextName);
						$("#archiveKeyword").val(reArchiveKeyword);
						$("#archiveId").attr("title",optionText);
					}else{
						checkArchiveInfo(reArchiveKeyword, reArchiveTextName);
					}
                    
                    dialog.close();
                  }
                }
              },{
                text : "${ctp:i18n('common.button.cancel.label')}",
                id : "cancel",
                handler : function() {
                  dialog.close(); 
                }
              }]
            });
        });
        $("#authSet").click(function(){
        	if($(this).hasClass("common_button_disable")){
                return false;
            }
        	var par = new Object();
			par.value = $("#auth").val();
			par.text = $("#auth_txt").val();
        	$.selectPeople({
                panels: 'Account,Department,Team,Post,Level,Outworker,JoinOrganization,JoinAccountTag,JoinPost',
                selectType: 'Account,Department,Team,Post,Level,Member,JoinAccountTag',
                hiddenPostOfDepartment:true,
                isNeedCheckLevelScope:false,
                showAllOuterDepartment:true,
                params : par,
                minSize:0,
                callback : function(ret) {
                  $("#auth").val(ret.value);
                  $("#auth_txt").val(ret.text);
                }
              });
        });
        $("#relationAuthSet").click(function(){
        	if($(this).hasClass("common_button_disable")){
                return false;
            }
        	var par = new Object();
			par.value = $("#authRelation").val();
			par.text = $("#authRelation_txt").val();
			$.selectPeople({
		        panels: 'Account,Department,Team,Post,Level,Node,FormField,Outworker,JoinOrganization,JoinAccountTag,JoinPost',
		        selectType: 'Account,Department,Team,Post,Level,Role,Member,FormField,Node,JoinAccountTag',
		        extParameters:'${CurrentUser.id},333',
		        isNeedCheckLevelScope:false,
		        hiddenFormFieldRole:true,
		        hiddenPostOfDepartment:true,
		        hiddenRoleOfDepartment:true,
		        excludeElements: "Node|NodeUser,Node|BlankNode,Node|NodeUserSuperDept,Node|NodeUserLeaderDep,Node|NodeUserManageDep,Node|SenderLeaderDep,Node|SenderManageDep",
		        minSize:0,
		        params : par,
		        callback : function(ret) {
		        	$("#authRelation").val(ret.value);
	                $("#authRelation_txt").val(ret.text);
		        }
		      });
        });
        $("#flowCopy").click(function(){
        	if($(this).hasClass("common_button_disable")){
                return false;
            }
        	dialog = $.dialog({
				url:"${path }/form/formList.do?method=showFlowTemplate&ownerId=${CurrentUser.id}&canSelect=true"+($("#id").val()!=""?("&notTemplateId="+$("#id").val()):""),
			    title : "${ctp:i18n('form.bind.flowCopySet')}",
			    targetWindow:getCtpTop(),  
			    width:800,
                height:500,
			    buttons : [{
			      text : "${ctp:i18n('common.button.ok.label')}",
			      id:"sure",
				  isEmphasize: true,
			      handler : function() {
			        var re = dialog.getReturnValue();
			        if(re!=null&&re.length==1){
			        	$("#isFlowCopy").val(2);//表明是流程复制过来的
				       /* var mam = new formBindDesignManager();
			        	var d = mam.getWorkFlow(re[0].workflowId);
			        	//$("#process_info").val(d.process_info);
			        	$("#process_xml_clone2flowCopy").val($("#process_xml").val());
			        	$("#process_xml").val(d.wfXML);
			        	if($("#process_xml").val()==""){
			            	$("#process_xml").val($("#process_xml_clone").val());
			            }
			        	createWFTemplate(window.top,"collaboration", "${formBean.id}", "${formBean.formViewList[0].id}",$("#process_id").val(),window,"collaboration","${CurrentUser.id}",'${fn:escapeXml(CurrentUser.name)}',"${fn:escapeXml(CurrentUser.loginAccountName)}","${CurrentUser.loginAccount}",nomorlOperationId,startOperationId,"协同");*/
			        	if(!$.browser.msie){ 
			        	  dialog.close(); 
			        	}else{ 
			              dialog.hideDialog(); 
                        }
			        	cloneWFTemplate(getCtpTop(),"collaboration", "${formBean.id}", "${formBean.formViewList[0].id}",re[0].workflowId,window,"collaboration","${CurrentUser.id}",'${fn:escapeXml(CurrentUser.name)}',"${fn:escapeXml(CurrentUser.loginAccountName)}","${CurrentUser.loginAccount}",nomorlOperationId,startOperationId,"${ctp:i18n("collaboration.newColl.collaboration")}");
			        } 
			      }
			    },{
				      text : "${ctp:i18n('common.button.cancel.label')}",
				      id:"exit",
				      handler : function() {
				        if(!$.browser.msie){ 
				          dialog.close(); 
      				    }else{ 
      				      dialog.hideDialog(); 
      				    } 
				      }
				    } ]
			  });
        });
        $("#deadline").focus(function(){
            $("#oldDeadlineValue").val($(this).val());
        });
        $("#deadline").change(function(){
            if(!checkAdvanceremind()){
              $("#advanceremind").val(0);
            }
        });
        $("#advanceremind").change(function(){
        	if(!checkAdvanceremind()){
                $(this).val(0);
            }
        });
        $("input:checkbox","#templateBody").click(function(){
        	if (!validateFormData()){
        		return;
        	}
        	setInitState();
        });
        
        $("body").data("cloneBindTable",$("#editArea").clone(true));
        
		$("#updateSubjectLabel").addClass("color_gray");
	});

	//检查模板标题是否设置
	function checkTemplateSubject(){
		var formTempSubject = $("#colSubject").val();
		if(formTempSubject){
			$("#updateSubject").removeAttr("disabled");
			$("#updateSubjectLabel").removeClass("color_gray");
		}else{
			$("#updateSubject").attr("checked",false);
			$("#updateSubject").attr("disabled","disabled");
			$("#updateSubjectLabel").addClass("color_gray");
		}
	}
	function checkAdvanceremind(){
		if($("#deadline").val()!='0'||$("#advanceremind").val()!='0'){
            if(new Number($("#deadline").val())<=new Number($("#advanceremind").val())){
                $.alert("${ctp:i18n('form.bind.advanceremind.err')}");
                return false;
            }
        }
        return true;
	}
	function editSuperVise(map){
		/*$("#supervisorsId").val(map.supervisorsId);
		$("#supervisors").val(map.supervisorNames);
		$("#awakeDate").val(map.superviseDate);
		$("#superviseTitle").val(map.title);
		$("#role").val(map.role);
		$("#roleNames").val(map.roleNames);*/
		var supervisorStr = "";
		if(map.roleNames != ""){
			supervisorStr = map.roleNames;
		}
		if(map.supervisorNames != "" ){
			supervisorStr = (supervisorStr==""?"":(supervisorStr+"、")) + unescape(map.supervisorNames);
			$("#supervisorNames").val(unescape(map.supervisorNames));
		}
		/*if(map.roleNames!=null && map.roleNames!=""){
			supervisorStr = (supervisorStr==""?"":(supervisorStr+"、"))+map.roleNames;
		}*/
		$("#showSupervisors").val(supervisorStr);
	}
	function checkDetail(){
		var archiveId = $("#archiveId").val();
		if(archiveId != undefined && archiveId != ""){
			if($(":checkbox:checked","#authDetail").length<=0 && $("#archiveTextName").val() == ""){
				$.alert("${ctp:i18n('form.bind.chooseDetail')}");
				return false;
			}
		}
		return true;
	}
	//显示模板 canDeleteFile是否能删除附件 文档
	function initTemplateData(templateId,canDeleteFile,modifyTemplate){
		canDeleteFile = (canDeleteFile==null?true:canDeleteFile);
		var manager = new formBindDesignManager();
		AjaxDataLoader.load("${path }/form/bindDesign.do?method=editFlowTemplate&id="+templateId,{},function(obj){
       	obj = $.parseJSON(obj);
		$("#editArea").fillform(obj);
		$("#fileArea").empty();
		<c:if test="${ctp:hasPlugin('doc')}">
		if(obj.archive_Id!=null&&obj.archive_Id!=""){
				var option = document.createElement('option');
				var bManager = new formBindDesignManager();
				var fullPath = bManager.getDocResFullPath(obj.archive_Id);
				if (obj.archiveFieldName != null && obj.archiveFieldName != "") {
				  $("#archiveFieldName").val(obj.archiveFieldName);
				  option.text = fullPath + "\\" + "{" + obj.archiveFieldDisplay + "}";
				} else {
				  option.text = fullPath;
				}
				$("#archiveName").val(fullPath);
				if (obj.archiveIsCreate != null && obj.archiveIsCreate != "") {
				  $("#archiveIsCreate").val(obj.archiveIsCreate);
				} else {
				  $("#archiveIsCreate").val("true");
				}
				option.value = obj.archive_Id;
				option.selected = true;
				$("#archiveId")[0].add(option);
				$("#authDetail").removeClass("hidden");
				if($("#archiveId").val() != ""){
					$("#archiveId").attr("title",option.text.escapeHTML());
				}
			
		}

			if($("#archiveText").val() == ""){
				//$("#archiveAttachment").val("false");
				$("#archiveText").val("false");
			}

			$("#attachmentArchiveName").val(obj.attachmentArchiveName);
			$("#archiveAttachment").val(obj.archiveAttachment);
			$("#attachmentArchiveId").val(obj.attachmentArchiveId);
		</c:if>
		if (obj.cycleState == "0") {
          $("#cycleStateBtn").hide();
        } else {
          $("#cycleStateBtn").show();
        }
		
		if (obj.canAnyMerge == true) {
          $("#canMergeDeal").attr("disabled",true);
        }
		deleteAllAttachment(0);
		deleteAllAttachment(2);
		var uploadStr = "<input id=\"uploadFile\" name=\"uploadFile\" attsdata='@attsJson@' type=\"text\" class=\"comp\" comp=\"type:'fileupload',isBR:true,applicationCategory:'1',canFavourite:false,canDeleteOriginalAtts:"+canDeleteFile+",originalAttsNeedClone:false\">";
		//alert(obj.fileJson);
	          $("#fileArea").html(uploadStr.replace("@attsJson@",obj.fileJson));
	          var docStr = "<div id=\"rel_doc\" class=\"comp\" attsdata='@attsJson@' comp=\"type:'assdoc',attachmentTrId:'rel_doc',isBR:true,canFavourite:false,modids:'2,3',canDeleteOriginalAtts:"+canDeleteFile+"\"></div>";
	          $("#rel_doc_div").html(docStr.replace("@attsJson@",obj.fileJson));
	          $("body").comp();
	          
	          $("#updateSubjectLabel").addClass("color_gray");
	          if(modifyTemplate){
	          	checkTemplateSubject();
	          }
			});
	}
	function deleteTemplate(ids){
		var manager = new formBindDesignManager();
		manager.delFlowTemplate(ids, {
            success: function(obj){
				parent.winReflesh("${path }/form/bindDesign.do?method=index",window);
         	}
     	});
	}
	function editState(){
		$("a","#editArea").removeClass("common_button_disable").removeClass("common_button").addClass("common_button");
		$("#advancePigeonhole").removeClass("disabled_color").removeClass("like_a").addClass("like_a").removeClass("hand").addClass("hand");
		$("#subject").prop("readonly",false);
		$("#templateNumber").prop("readonly",false);
		$(":disabled","#editArea").prop("disabled",false);
	}
	function setInitState(){
		var bindTable = $("#editArea");
		bindTable.empty();
		bindTable.append($("body").data("cloneBindTable").clone(true).children());
		deleteAllAttachment(0);
		deleteAllAttachment(2);
	}
	function validateFormData(){
		if(!$("#subject").prop("readonly") && $("#process_info").val() != ""){
			$.alert("${ctp:i18n('form.bind.saveBindInfo')}");
	    	return false;
		}
		return true;
	}
      function saveFormData(){

      }
	function recoverWorkFlowHistoryData(){
		//$("#process_xml").val($("#process_xml_clone2flowCopy").val());
	}
	function showTemplate(obj,tId){
		if (!validateFormData()){
			return;
		}
		$("input:checked",".only_table").attr("checked",false);
		$(obj).parents("tr:eq(0)").find("input:checkbox").attr("checked",true);
		setInitState();
		initTemplateData(tId,false);
		$("input:checkbox","#editArea").prop("disabled",true);
		$("select","#editArea").prop("disabled",true);
	}
	
	function canAnyMergeClk(ths){
		var canAnyMerge = $(ths);
		var canMergeDeal = $("#canMergeDeal");
		if(canAnyMerge.is(":checked")){
			canMergeDeal.attr({"disabled":true,"checked":true});
		}else{
			canMergeDeal.attr("disabled",false); 		
		}
	}
	  function checkArchiveInfo(keyWord, textName){
		  var flag = false;
		  <c:if test="${redTemplete == 'true' }">
		  if(keyWord != "" || textName != "") {
			  flag = true;
		  }
		  </c:if>
		  <c:if test="${redTemplete != 'true' }">
		  if(keyWord != "") {
			  flag = true;
		  }
		  </c:if>
		  if(flag){
			  var msg = "${ctp:i18n('form.bind.set.pigeonhole.save.log.label1')}";//未设置归档文件夹，关键字内容将不会保存，是否继续？
			  <c:if test="${redTemplete == 'true' }">
			  msg = "${ctp:i18n('form.bind.set.pigeonhole.save.log.label2')}";//未設置歸檔文件夾，關鍵字內容或正文歸檔名稱都將不會保存，是否继续？
			  </c:if>
			  $.alert(msg);
		  }
	  }
	</script>
</html>