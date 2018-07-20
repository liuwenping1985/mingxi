<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>form</title>
        <script type="text/javascript" src="${path}/ajax.do?managerName=formBindDesignManager,govdocTemplateDepAuthManager"></script>
    </head>	
	<%@ include file="../../common/common.js.jsp" %>
    <body class="page_color">			
    	<div id='layout'>
	        <div class="layout_north" id="north">
	        	<!--向导菜单-->
				<div class="step_menu clearfix margin_tb_5 margin_l_10">
					<%@ include file="../top.jsp" %>
				</div>
				<!--向导菜单-->
				<div class="hr_heng"></div>
	        </div>
	        <div class="layout_center bg_color_white" id="center">
				 <div class="form_area padding_tb_5 padding_l_10" id="form">
	                <table border="0" cellspacing="0" cellpadding="0">
	                  <tr>
	                    <th nowrap="nowrap"><label class="margin_r_10" for="text">
							<c:if test="${formBean.govDocFormType !=5 &&formBean.govDocFormType !=6 && formBean.govDocFormType !=7 && formBean.govDocFormType !=8}">
								${ctp:i18n("form.base.formname.label")}：
							</c:if>
							<c:if test="${formBean.govDocFormType ==5 ||formBean.govDocFormType ==6 || formBean.govDocFormType ==7 || formBean.govDocFormType ==8}">
								${ctp:i18n("form.base.edocformname.label")}：
							</c:if>
						</label></th>
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
										<td width="20%" align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
											color="red">*</font>
											<c:if test="${formBean.govDocFormType !=5 &&formBean.govDocFormType !=6 && formBean.govDocFormType !=7 && formBean.govDocFormType !=8}">
												${ctp:i18n('form.seeyontemplatename.label')}：
											</c:if>
											<c:if test="${formBean.govDocFormType ==5 ||formBean.govDocFormType ==6 || formBean.govDocFormType ==7 || formBean.govDocFormType ==8}">
												${ctp:i18n("edocform.seeyontemplatename.label")}：
											</c:if>
											</label></td>
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
										<td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
											color="red">*</font>${ctp:i18n('form.bind.flow.label')}：</label></td>
										<td>
											<div class=common_txtbox_wrap>
											<input type="hidden" id="govdocContent" name="govdocContent" value="${content }"/><!-- 公文正文id-->
											<input type="hidden" id="govdocContentType" name="govdocContentType" value="${govdocContentType } }"/><!-- 公文正文类型value，41,42,43-->
											<input type="hidden" id="govdocBodyType" name="govdocBodyType" value="${govdocContentType }"/>
											<input type="hidden" id="contentFileId" name="contentFileId" value="${content }"/>
										    <input id="isFlowCopy" name="isFlowCopy" type="hidden" value='0'/>
										    <input id="process_id" name="process_id" type="hidden"/>
										    <input id="taohongTemplete" name="taohongTemplete" type="hidden"/>
										    <input id="process_xml" name="process_xml" type="hidden"/>
										    <input id="process_desc_by" name="process_desc_by" type="hidden"/>
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
										<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="newFlowSet">${ctp:i18n('form.bind.newFlow')}</a>
										<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="updateFlowSet">${ctp:i18n('form.bind.editFlow')}</a>
										<c:if test="${formBean.govDocFormType ne '6' }">
										<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="flowCopy">${ctp:i18n('form.bind.copyFrom')}...</a>
										</c:if>
										</td>
									</tr>
									<tr height="30px" >
										<td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
											color="red"></font>
											<c:if test="${formBean.govDocFormType !=5 &&formBean.govDocFormType !=6 && formBean.govDocFormType !=7 && formBean.govDocFormType !=8}">
												${ctp:i18n('form.bind.formFlowTitle')}：
											</c:if>
											<c:if test="${formBean.govDocFormType ==5 ||formBean.govDocFormType ==6 || formBean.govDocFormType ==7 || formBean.govDocFormType ==8}">
												${ctp:i18n("edocform.bind.formFlowTitle")}：
											</c:if>
											</label></td>
										<td nowrap="nowrap" >
										    <div class=" common_txtbox_wrap">
										    <input readonly="readonly" id="colSubject" name="colSubject" type="text" class="w100b validate" validate="type:'string',china3char:true,maxLength:255,name:'${ctp:i18n('form.bind.formFlowTitle')}'">
										    </div>
										</td>
										<td>
											<div>
												<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="formTitleSet">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
												&nbsp;
												<label class="margin_r_10 hand" for="updateSubject">
													<input disabled="disabled" id="updateSubject" class="radio_com" value="1" type="checkbox" name="updateSubject">
													${ctp:i18n('form.bind.formFlowTitle.autoUpdate')}
												</label>
											</div>
										</td>
									</tr>
									<tr height="30px" <c:if test="${formBean.govDocFormType eq 0 || formBean.govDocFormType eq 6}">style="display:none" </c:if>>
											<td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
												color="red"></font>${ctp:i18n('form.bind.contentType')}：</label></td>
											<td nowrap="nowrap" >
												<div class=" common_selectbox_wrap">
												<select disabled="disabled" id="contentType" name="contentType" class="w100b codecfg">
												</select>
												</div>
											</td>
											<td>
											<span class="margin_l_5 disabled_color" id="contentBtn" onclick="contentBtnClic();" disabled>[${ctp:i18n('form.bind.content')}]</span>
											</td>
									</tr>
									<tr height="30px" <c:if test="${formBean.govDocFormType eq 0 || formBean.govDocFormType eq 6}">style="display:none" </c:if>>
											<td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
												color="red"></font>${ctp:i18n('form.bind.contentRed')}：</label></td>
											<td nowrap="nowrap" >
												<div class="common_selectbox_wrap">
												<select disabled="disabled" id="contentRed" name="contentRed" class="w100b codecfg">
													  <option value="-1" selected="selected">无</option>
													  <c:forEach items="${docTemplates }" var="items">
													  	 <option value="${items.id }" >${items.name }</option>
													  </c:forEach>
												</select>
												</div>
											</td>
											<td>
												<span class="margin_l_5 disabled_color" id="taohongBtn" onclick="taohongClc()" disabled>[${ctp:i18n('form.bind.contentRed')}]</span>
											</td>
									</tr>
									<tr height="30px" <c:if test="${CurrentUser.administrator}">style="display:none" </c:if>>
										<td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
											color="red"></font>${ctp:i18n('form.input.extend.document.label')}：</label></td>
										<td nowrap="nowrap" >
										 <div class=" common_txtbox_wrap" id="rel_doc_div" style="min-height: 24px;">
										    <div id="rel_doc" class="comp" comp="type:'assdoc',attachmentTrId:'rel_doc',canFavourite:false,modids:'2,3'"></div>
										    </div>
										</td>
										<td>
										<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="relDocSet">${ctp:i18n('form.input.extend.document.label')}</a>
										</td>
									</tr>
									<tr height="30px">
										<td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
											color="red"></font>${ctp:i18n('common.toolbar.insert.localfile.label')}：</label></td>
										<td nowrap="nowrap" >
										     <div class=" common_txtbox_wrap" id="fileArea" isGrid="true" style="min-height: 24px;">
										     <input id="uploadFile" name="uploadFile" type="text" class="comp" comp="type:'fileupload',applicationCategory:'1',canFavourite:false,canDeleteOriginalAtts:true,originalAttsNeedClone:false">
										    </div>
										</td>
										<td>
										<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="uploadSet">${ctp:i18n('form.bind.upload.label')}</a>
										</td>
									</tr>
										<tr height="30px" <c:if test="${formBean.govDocFormType eq 0 || formBean.govDocFormType eq 6}">style="display:none"</c:if>>
											<td align="right" nowrap="nowrap"><label class="margin_r_10" for="text">
												<font color="red"></font>文号绑定：</label>
											</td>
											<td nowrap="nowrap" >
											     <div class=" common_txtbox_wrap" id="markBindDiv" style="min-height: 24px; overflow-y: auto; max-height: 30px ">
											     	<input type="hidden" id="markBind" name="markBind" type="text" >
											     	<input type="hidden" id="markBindStr" name="markBindStr" type="text" >
											    </div>
											</td>
											<td>
												<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="markBindSet" disabled>${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
											</td>											
										</tr>
								
									<tr height="30px" <c:if test="${formBean.govDocFormType ne 0 }">style="display:none" </c:if>>
										<td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
											color="red"></font>${ctp:i18n('common.importance.label')}：</label></td>
										<td nowrap="nowrap" >
										    <div class=" common_selectbox_wrap">
										    <select disabled="disabled" id="importantLevel" name="importantLevel" class="w100b codecfg" codecfg="codeId:'common_importance'">
										    </select>
										    </div>
										</td>
										<td>
										</td>
									</tr>
				
									<c:if test ="${(ctp:getSysFlagByName('target_showOnlyTimeManager')!='true')}">
									<tr height="30px" <c:if test="${formBean.govDocFormType eq '5' || formBean.govDocFormType eq '6' || formBean.govDocFormType eq '7' || formBean.govDocFormType eq '8'}">style="display: none;"</c:if>>
										<td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
											color="red"></font>${ctp:i18n('form.base.relationProject.title')}：</label></td>
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
                                    <tr height="30px"  <c:if test="${formBean.govDocFormType eq 5 || formBean.govDocFormType eq 6 || formBean.govDocFormType eq 7 || formBean.govDocFormType eq 8}">style="display:none" </c:if>>
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
									<tr height="30px"><!-- 流程期限 -->
										<td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
											color="red"></font>${ctp:i18n('form.bind.flowCycle')}：</label></td>
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
									<tr height="30px">
										<td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
											color="red"></font>${ctp:i18n('common.reference.time.label')}：</label></td>
										<td nowrap="nowrap" >
										    <div class=" common_selectbox_wrap">
										    <select disabled="disabled" id="standardDuration" name="standardDuration" class="w100b codecfg" codecfg="codeId:'collaboration_deadline'">
										    </select>
										    </div>
										</td>
										<td>
										</td>
									</tr>
									<tr height="30px"><!-- 提醒 -->
										<td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
											color="red"></font>${ctp:i18n('common.remind.time.label')}：</label></td>
										<td nowrap="nowrap" >
										    <div class=" common_selectbox_wrap">
										    <select disabled="disabled" id="advanceremind" name="advanceremind" class="w100b codecfg" codecfg="codeId:'common_remind_time'">
										    </select>
										    </div>
										</td>
										<td>
										</td>
									</tr>
									<tr height="30px">
										<td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
											color="red"></font>${ctp:i18n('form.bind.pigeonhole.label')}：</label></td>
										<td nowrap="nowrap" >
										    <div class=" common_selectbox_wrap">
										    <select disabled="disabled" id="archiveId" class="w100b">
										    <option selected="selected" value="">${ctp:i18n('form.timeData.none.lable')}</option>
										    <option value="1">${ctp:i18n('form.bind.selectTo')}</option>
										    </select>
                                            <input type="hidden" id="archiveName" name="archiveName" value="" />
                                            <input type="hidden" id="archiveFieldName" name="archiveFieldName" value="" />
                                            <input type="hidden" id="archiveIsCreate" name="archiveIsCreate" value="true" />
										    </div>
										</td>
										<td>
                                            <span class="margin_l_5 disabled_color" id="advancePigeonhole">[${ctp:i18n('form.formlist.advanced')}]</span>
										</td>
									</tr>
									<tr height="30px" class="hidden" id="authDetail">
										<td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
											color="red"></font>${ctp:i18n('form.query.showdetails.label')}：</label></td>
										<td nowrap="nowrap">
										<table width="100%">
										<c:forEach items="${formBean.formViewList}" var="view">
											<tr>
											<td  width="30%">
											<input type="checkbox" id="view_${view.id }" value="${view.id }"/><label for="view_${view.id }">${view.formViewName }</label>
											</td>
											<td width="70%">
											<div class=" common_selectbox_wrap" >
											<select id="auth_${view.id }" style="width: 100">
											<c:forEach items="${view.operations}" var="auth">
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
									<tr height="30px">
										<td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
											color="red"></font>${ctp:i18n("collaboration.newcoll.isNoProcess")}</label></td>
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
									<tr height="30px">
										<td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
											color="red"></font></label></td>
										<td>
											<fieldset>
										    <div class="common_checkbox_wrap" >
									    	<LABEL <c:if test="${formBean.govDocFormType eq '5' || formBean.govDocFormType eq '6' || formBean.govDocFormType eq '7' || formBean.govDocFormType eq '8'}">style="display: none;"</c:if> class="margin_r_10 hand" for=canForward><INPUT disabled="disabled" <c:if test="${formBean.govDocFormType ne '5' && formBean.govDocFormType ne '6' && formBean.govDocFormType ne '7'}">checked="checked"</c:if> id=canForward class=radio_com value=1 type=checkbox name=canForward>${ctp:i18n('collaboration.allow.transmit.label')}</LABEL>
										    <LABEL class="margin_r_10 hand" for=canModify><INPUT disabled="disabled" checked="checked" id=canModify class=radio_com value=1 type=checkbox name=canModify>${ctp:i18n('collaboration.allow.chanage.flow.label')}</LABEL>
										    <LABEL class="margin_r_10 hand" for=canArchive><INPUT disabled="disabled" checked="checked" id=canArchive class=radio_com value=1 type=checkbox name=canArchive>${ctp:i18n('collaboration.allow.pipeonhole.label')}</LABEL>
										    <LABEL class="margin_r_10 hand" for=canEditAttachment><INPUT disabled="disabled" id=canEditAttachment class=radio_com value=1 type=checkbox name=canEditAttachment>${ctp:i18n('collaboration.allow.edit.attachment.label')}</LABEL>
										    </div>
												<div>
													<LABEL <c:if test="${formBean.govDocFormType eq '5' || formBean.govDocFormType eq '6' || formBean.govDocFormType eq '7' || formBean.govDocFormType eq '8'}">style="display: none;"</c:if> class="margin_r_10 hand" for=canMergeDeal><INPUT disabled="disabled" id=canMergeDeal class=radio_com value=1 type=checkbox name=canMergeDeal>${ctp:i18n('collaboration.allow.canmergedeal.label')}</LABEL>
												</div>
										    </fieldset>
										</td>
										<td>&nbsp;</td>
									</tr>
									<tr height="30px">
										<td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
											color="red"></font>${ctp:i18n('form.bind.template.number.label')}：</label></td>
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
									<tr height="30px">
										<td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
											color="red"></font>${ctp:i18n('form.flow.templete.super')}：</label></td>
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
									<tr <c:if test="${formBean.govDocFormType eq 6 }">style="display:none"</c:if>>
									   <td></td>
									   <td colspan="2">
										<div class="common_checkbox_wrap">
										<LABEL class="margin_r_10 hand" for=canSupervise><input disabled="disabled" id="canSupervise" class="radio_com" name="canSupervise" value="1" type="checkbox" checked="checked">${ctp:i18n('form.bind.allowToSupervise')}</LABEL>
										</div>
									   </td>
									</tr>
									<tr height="30px" id="authRelationTR" <c:if test="${formBean.govDocFormType eq 6 }">style="display:none"</c:if>>
										<td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
											color="red"></font>
											<c:if test="${formBean.govDocFormType !=5 &&formBean.govDocFormType !=6 && formBean.govDocFormType !=7 && formBean.govDocFormType !=8}">
												${ctp:i18n('form.bind.relationform.auth.set.label')}：
											</c:if>
											<c:if test="${formBean.govDocFormType ==5 ||formBean.govDocFormType ==6 || formBean.govDocFormType ==7 || formBean.govDocFormType ==8}">
												${ctp:i18n("edocform.bind.relationform.auth.set.label")}：
											</c:if>
										</label></td>
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
									<tr id="authRelationAlertTR" <c:if test="${formBean.govDocFormType eq 6 }">style="display:none"</c:if>>
										<td>
										</td>
										<td colspan="2">
										 <div style="font_size12">
											 <font color="green">
											 	 <c:choose> 
										            <c:when test="${formBean.govDocFormType eq 5 or formBean.govDocFormType eq 7}">${ctp:i18n('form.bind.relation.auth.alert.edoc.label')}</c:when> 
										            <c:otherwise>${ctp:i18n('form.bind.relation.auth.alert.label')}</c:otherwise> 
												</c:choose>
										    </font>
										 </div>
										</td>
									</tr>
									<c:if test="${govExchangeFormType!='1' }">
									<tr height="30px">
										<td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
											color="red"></font>${ctp:i18n('common.toolbar.auth.label')}：</label></td>
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
									</c:if>
									<!-- cx -->
									<c:if test="${govExchangeFormType=='1' }">
									<tr height="30px">
										<td align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
											color="red">*</font>${ctp:i18n('common.toolbar.auth.label')}单位或部门：</label></td>
										<td nowrap="nowrap" >
										    <div class=" common_txtbox_wrap">
											    <input readonly="readonly" class="w100b validate" id="dep_auth_txt" validate="notNullWithoutTrim:true,notNull:true" name="授权部门" type="text">
											    <input readonly="readonly" id="dep_auth" name="dep_auth" type="hidden">
											    <input type="hidden" id="saveOrUpdateValidate" name="saveOrUpdateValidate" type=""/>
										    </div>
										</td>
										<td>
										<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="depAuthSet">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
										</td>
									</tr>
									</c:if>
								</table>
						<div align="center" id="buttonDiv">
							<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="saveSet">${ctp:i18n('common.button.ok.label')}</a>
							<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="cancelSet">${ctp:i18n('common.button.cancel.label')}</a>
						</div>
						</fieldset>
	                </div>
	                </form>
	                <div class="col2 margin_l_5 <c:if test="${formBean.formType==baseInfo }">hidden </c:if>" style="float: left;width:39%;height: 100%">
	                	<div class="common_txtbox clearfix margin_tb_5">
							<label class="margin_r_10 left margin_t_5" for="text">${ctp:i18n('form.bind.bindList')}:</label>
							<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="updateTemplate">${ctp:i18n('common.button.modify.label')}</a>
							<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="delTemplate">${ctp:i18n('common.button.delete.label')}</a>
						</div>
						<div  style="height: 80%;overflow: auto;">
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table">
		                    <thead>
		                        <tr>
		                            <th width="1%"><input type="checkbox" onclick="selectAll(this,'templateBody')"/></th>
		                            <th align="center">
										<c:if test="${formBean.govDocFormType !=5 &&formBean.govDocFormType !=6 && formBean.govDocFormType !=7 && formBean.govDocFormType !=8}">
											${ctp:i18n('form.seeyontemplatename.label')}
										</c:if>
										<c:if test="${formBean.govDocFormType ==5 ||formBean.govDocFormType ==6 || formBean.govDocFormType ==7 || formBean.govDocFormType ==8}">
											${ctp:i18n("edocform.seeyontemplatename.label")}
										</c:if>
									</th>
		                        </tr>
		                    </thead>
		                    <tbody id="templateBody" >
		                    	<c:forEach var="it" items="${formBean.bind.flowTemplateList }" varStatus="status">
			                    		<tr class="hand <c:if test="${(status.index % 2) == 1 }">erow</c:if>"  style="height: 30px;">
		                            		<td id="selectBox"><input type="checkbox" value="${it.id }" workflowId="${it.workflowId}"/></td>
		                            		<td onclick="showTemplate(this,'${it.id }')"><c:if test="${it.extraMap['com.seeyon.ctp.form.po.GovdocTemplateDepAuth'] != null }">${ctp:i18n('govdoc.title.lianhe.label') }</c:if>${it.subject }</td>
		                        		</tr>
		                        		</c:forEach>
		                    </tbody>
		                 </table>
						</div>
	                </div>
				</div>
	        </div>
	       	<div class="layout_south over_hidden" id="south">
		       
					<%@ include file="../bottom.jsp" %>
				
			</div>
		</div>
		
		<c:set var="defaultBodyType" value="${(formBean.govDocFormType eq 0 || formBean.govDocFormType eq 6) ? 'HTML' : 'OfficeWord'}" />	
		<iframe	id="editFrame" name = "editFrame" src="${path }/form/bindDesign.do?method=editFrame&defaultBodyType=${defaultBodyType}" style="height:0;width:0;"></iframe>
	 
	</body>
	<script type="text/javascript">
	 var contentState = false;
	  var fullEditorURL="${path}/edocController.do?method=fullEditor";
	  var _contentType;
	  var iframeSrc="${path }/form/bindDesign.do?method=editFrame&defaultBodyType=${defaultBodyType}";
	 var govDocFormType = '${formBean.govDocFormType}';
	  function markShow(data){
	  		try{
        		data = $.parseJSON(data);
	  		}catch(e){}
			var html = "", 
				str = "";
				str1 = "";
			for(var i = 0; i < data.length; i++){
				if(typeof(data[i].title)=="undefined"){
					continue;
				}
				html += "<span style=\"margin-right:10px; float:left\">"+ data[i].title +"<em class=\"ico16 gray_close_16\"></em></span>"
				str += "title:"+ data[i].title +"&fieldName:"+ data[i].fieldName +"&id:"+ data[i].id +"#";
				str1+= data[i].id+":";
			}
			$("#markBindDiv").find("span").remove();
			$("#markBind").val("");
			$("#markBindDiv").prepend(html);
			$("#markBind").val(str.substring(0, str.length-1));
			$("#markBindStr").val(str1.substring(0, str.length-1));
			delData();
        }
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
		  }

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
              $("<option selected value='"+p[0]+"'>"+p[1].escapeHTML()+"</option>").appendTo($("#archiveId"));
              $("#authDetail").removeClass("hidden");
              $(":checked","#authDetail").prop("checked",false);
              $("#archiveName").val(p[1]);
              $("#archiveFieldName").val("");
              $("#archiveIsCreate").val("true");
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

	 function isGovDov(govDocFormType) {
		 if(govDocFormType!=null&&govDocFormType!=''&&govDocFormType!='0'){
			 return true;
		 }else{
			 return false;
		 }
	 }

	$(document).ready(function(){
		//初始化正文类型下拉框数据
		try{
			var mainBodyTypelist = eval(${contentTypeList });
			var bodyTypeSelect = document.getElementById("contentType");
			if(bodyTypeSelect){
				bodyTypeSelect.add(new Option("无","-1"));
				for ( var i = 0; i < mainBodyTypelist.length; i++) {
					var bodyType = mainBodyTypelist[i];
					var mt = bodyType.mainbodyType;
					if($.ctx.isOfficeEnabled(mt)){
						bodyTypeSelect.add(new Option(bodyType.name,mt));
					}
				}
				var optionsArr = bodyTypeSelect.options;
				var selIndex = getBodyTpe(optionsArr);
				optionsArr[selIndex].selected = true;
				_contentType = selIndex;
				//changeBodyType2(optionsArr[selIndex].value,true);
			}
		}catch(e){alert(e)}
		
		if(!${ctp:hasPlugin("formAdvanced")}){
			$("#authRelationTR").hide();
			$("#authRelationAlertTR").hide();
			$("#advancePigeonhole").hide();
			$("#contentBtn").hide();
		}
        new MxtLayout({
            'id': 'layout',
            'northArea': {
                'id': 'north',
                'height':40,
                'sprit': false,
				'border': false
            },
            'southArea': {
                'id': 'south',
                'height':40,
                'sprit': false,
				'border': false,
				'maxHeight': 40,
                'minHeight':40
            },
            'centerArea': {
                'id': 'center',
                'border': false
            }
        });
        if(!${formBean.newForm }){
        	new ShowTop({'current':'bind','canClick':'true','module':'bind'});
        	new ShowBottom({'show':['doSaveAll','doReturn']});
        }else{
        	new ShowTop({'current':'bind','canClick':'false','module':'bind'});
        	new ShowBottom({'show':['upStep','nextStep','finish'],'source':{'upStep':'../report/reportDesign.do?method=index','nextStep':'../form/triggerDesign.do?method=index'}});
        }
		
		$("#contentType").change(function(){
			var res =false;
			res = document.getElementById("editFrame").contentWindow.changeBodyType($(this).children('option:selected').val());
			if(!res){
				$("#taohongBtn").attr("disabled",false);
				$("#contentType").get(0).selectedIndex=_contentType;
			}else{
				//更新正文类型
				_contentType=$("#contentType").get(0).selectedIndex;
				document.getElementById("govdocBodyType").value = transType($(this).children('option:selected').val());
				//更新套红模板
				var redDocument =  document.getElementById("contentRed").options;
				if(redDocument.length > 0){
					redDocument[0].selected = true;
					var taohongTemplete = document.getElementById("taohongTemplete");
					taohongTemplete.value = redDocument[0].value;
				}
				var str = document.getElementById("govdocBodyType").value;
				if (str != "Pdf") {
					document.getElementById("editFrame").contentWindow.location.href = iframeSrc + "&govdocBodyType="+str;
			    }
			}
		})
        $("#archiveId").change(function(){
        	var options = $("option",$(this));
        	var ids = options.length==3?(options.eq(2).val()+"."+options.eq(2).text()):null;
            if($(this).val()=="1"){
				var appName = isGovDov(govDocFormType)?4:2;//公文场景是4
				var pigeonholeType = isGovDov(govDocFormType)?'EdocTempletePrePigeonhole':'fromTempleteManage';
            	var pige = pigeonhole(appName,null,false,false,pigeonholeType,"pigeonholeCallback");
            }else if("" == $(this).val()){
            	if(ids!=null){
            		$("option:eq(2)",$(this)).remove();
            	}
            	$("#authDetail").removeClass("hidden").addClass("hidden");
            	$("#archiveName").val("");
            	$("#archiveFieldName").val("");
                $("#archiveIsCreate").val("true");
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
            createWFTemplate(getCtpTop(),"${curPerm.appName}", "${formBean.id}", "${formBean.formViewList[0].id}","",window,"${curPerm.defaultPolicyId}","${CurrentUser.id}",'${fn:escapeXml(CurrentUser.name)}',"${CurrentUser.loginAccountName}","${CurrentUser.loginAccount}",nomorlOperationId,startOperationId,"${curPerm.defaultPolicyName}","",$("#process_id").val());
        });
		
        $("#updateFlowSet").click(function(){
            if($(this).hasClass("common_button_disable")){
                return false;
            }
            if($("#process_xml").val()==""){
            	$("#process_xml").val($("#process_xml_clone").val());
            }

            $("#process_xml_clone2flowCopy").val($("#process_xml").val());
        	createWFTemplate(getCtpTop(),"${curPerm.appName}", "${formBean.id}", "${formBean.formViewList[0].id}",$("#process_id").val(),window,"${curPerm.defaultPolicyId}","${CurrentUser.id}",'${fn:escapeXml(CurrentUser.name)}',"${CurrentUser.loginAccountName}","${CurrentUser.loginAccount}",nomorlOperationId,startOperationId,"${curPerm.defaultPolicyName}");
        });
        $("#newBind").click(function(){//TODO 有个BUG 打开模版之后，取消，点击新增，如果模版类型是word类型，则打开的新建正文内容依然为上一个模版内容
        	var _width;
			contentState = true;
        	var $td = $("#templateNameSet tr:eq(0) td:eq(1)");//放到初始化的页面加 不然会变宽
            if(!_width)
                _width = $td.width();
        	setInitState();
        	editState();
        	saveOrUpdateValidate = "";
            $("#templateNameSet tr").each(function(i, t) {
                $td.children("div").css("width",_width);
            });
            $("#subject").val("${formBean.formName}");
			if(${formBean.govDocFormType} == 7 || ${formBean.govDocFormType} == 5 || ${formBean.govDocFormType} ==6 || ${formBean.govDocFormType} ==8){
				var contentType = document.getElementById("contentType").options;
				var selIndex = getBodyTpe(contentType);
				contentType[selIndex].selected = true;
				changeBodyType2(contentType[selIndex].value,true);
			}
			if (document.getElementById("govdocBodyType").value != "Pdf") {
				document.getElementById("editFrame").contentWindow.location.href = iframeSrc;
		    }
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
        	
        	if(!($("#dep_auth_txt").validate({errorAlert:true,errorIcon:false}))){
        		return;
        	}
          //cx 判断是否存在部门
        	if(${formBean.govDocFormType} ==6){
        		var outStr = "";
        		var govdocTemplateDepManager = new govdocTemplateDepAuthManager();
        		outStr = govdocTemplateDepManager.validateTemplateDepAuth($("#id").val(),$("#saveOrUpdateValidate").val(),$("#dep_auth").val());
    			if(outStr!=""){
    				if(!confirm( "以下单位或部门已存在授权： "+outStr+"，是否将其覆盖?")){
    					return;
    				}
    			}
			}
			//保存当前选择的套红模版
			var redDocument =  document.getElementById("contentRed");
			var index2 = redDocument.selectedIndex; // 选中索引
			var taohongTemplete = document.getElementById("taohongTemplete");
		 	taohongTemplete.value = redDocument.options[index2].value; // 选中值
			
			//保存正文文件
			//G6V5.7-保存公文正文--start
 			if(${formBean.govDocFormType} == 7 || ${formBean.govDocFormType} == 5 || ${formBean.govDocFormType} == 8){
 				if(!saveGovdocBody2()){
 					return ;
 				}
 			}
			//G6V5.7-保存公文正文--end
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
			if(${formBean.govDocFormType} == 7 || ${formBean.govDocFormType} == 5 || ${formBean.govDocFormType} == 6 || ${formBean.govDocFormType} == 8){
				document.getElementById("editFrame").contentWindow.location.href = iframeSrc + "&fbid=${fbid}&id="+templateChecked.val();
			}
			saveOrUpdateValidate = "1";
			//document.location.href = iframeSrc + "&fbid=${fbid}&id="+templateChecked.val();
            setInitState();
            initTemplateData(templateChecked.val());
			editState();
			contentState = false;
        });
        $("#lianheAuth").click(function(){
        	if($(this).hasClass("common_button_disable")){
                return false;
            }
            var templateChecked = $(":checked","#templateBody");
            if(templateChecked.length!=1){
            	$.alert("请选择一个流程模板!");
                return false;
            }
            var manager = new formBindDesignManager();
            
    		manager.lianheAuth(templateChecked.eq(0).val(), {
                success: function(obj){
    				winReflesh("${path }/form/bindDesign.do?method=index");
             	}
         	});
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
                $.alert($.i18n('Form.bind.deleteError.subFlow',result[0][0],result[0][1]));
                return;
            }

            var ctm = new collaborationTemplateManager();
            var reV = ctm.getGovdocTemplateDepAuthFlag(tems);
            if(reV==true){
          	  $.alert($.i18n('template.govdoc.msg.delete.lianhe.info'));
          	  return false;
            }
            
            $.confirm({
			    'msg' : "${ctp:i18n('form.query.querySet.deleteConfirm')}",
			    ok_fn : function() {
	                deleteTemplate(tems);
			    }
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
        	setFlowTemplateTitle("${formBean.govDocFormType}");
        });
        
       	Array.prototype.del = function(n) {
			if (n < 0) return this;
			return this.slice(0, n).concat(this.slice(n + 1, this.length));
		}
        
        function delData(){
        	$("#markBindDiv em").click(function(){
        		var index = $(this).parent("span").index();
        		var newArr = $("#markBind").val().split("#");
        		$("#markBind").val(newArr.del(index).join("#"));
        		$(this).parent("span").remove();
        	})
        }
        
        $("#markBindSet").click(function(){
        	   var markDialog = $.dialog({
			        id: 'url',
			        url: "${path }/form/bindDesign.do?method=markBind&markBindStr="+$("#markBindStr").val()+"&templateId="+$(":checked","#templateBody").val(),
			        width: 320,
			        targetWindow : getCtpTop(),
			        height: 160,
			        title: "文号绑定",
				    buttons: [{
						        text: "${ctp:i18n('common.button.ok.label')}",
						        handler: function () {
						             var o = markDialog.getReturnValue();
						             markShow(o);
						        	 markDialog.close();
						        }
						     }, {
						        text: "${ctp:i18n('common.button.cancel.label')}",
						        handler: function () {
						        	markDialog.close();
						        }
				        	}]
			    });
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
            
            dialog = $.dialog({
              url : "${path }/form/bindDesign.do?method=advancePigeonhole",
              title : "${ctp:i18n('form.bind.set.pigeonhole.content.label')}",
              targetWindow : getCtpTop(),
              transParams : {"parentFolderId" : parentFolderId, "parentFolderName" : parentFolderName, "fieldName" : fieldName, "isCreate" : isCreate},
              width : 500,
              height : 300,
              buttons : [{
                text : "${ctp:i18n('common.button.ok.label')}",
                id : "ok",
                handler : function() {
                  var re = dialog.getReturnValue();
                  if(re){
                    var reParentFolderId = re.parentFolderId;
                    var reParentFolderName = re.parentFolderName;
                    var reFieldName = re.fieldName;
                    var reFieldDisplay = re.fieldDisplay;
                    var reIsCreate = re.isCreate;
                    
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
                      var option = document.createElement("option");
                      option.text = optionText;
                      option.value = reParentFolderId;
                      option.selected = true;
                      try
                      {
                    	  $("#archiveId").get(0).add(option);
                      }
                    	catch (e)
                      {
                    	 $("#archiveId").get(0).add(option,null);
                      } 
                      
                      //$("<option selected value='" + reParentFolderId + "'>" + optionText + "</option>").appendTo($("#archiveId"));
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
			var panels = 'Account,Department,Team,Post,Level,Outworker';
			var govdocFormType = '${govdocFormType}';
			if(govdocFormType == 5 || govdocFormType == 6 || govdocFormType == 7 || govdocFormType == 8){
				panels = 'Account,Department,Team,Post,Level';
			}
        	$.selectPeople({
                panels: panels,
                selectType: 'Account,Department,Team,Post,Level,Member',
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
        $("#depAuthSet").click(function(){
        	if($(this).hasClass("common_button_disable")){
                return false;
            }
        		var par = new Object();
        		par.value = $("#dep_auth").val();
        		par.text = $("#dep_auth_txt").val();
        		$.selectPeople({
        	        panels: 'Department',
        	        selectType: 'Account,Department',
        	        showAllOuterDepartment:false,//显示所有外部单位
        	        isCanSelectGroupAccount:false,//是否可选集团单位
        	        onlyLoginAccount:true,//只能选择当前单位
        	        isAllowContainsChildDept:true,
        	        hiddenAccount:true,
        	        params : par,
        	        minSize:0,
        	        callback : function(ret) {
        	        	$("#dep_auth").val(ret.value);
        	            $("#dep_auth_txt").val(ret.text);
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
		        panels: 'Account,Department,Team,Post,Level,Node,FormField,Outworker',
		        selectType: 'Account,Department,Team,Post,Level,Role,Member,FormField,Node',
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
			        	cloneWFTemplate(getCtpTop(),"${curPerm.appName}", "${formBean.id}", "${formBean.formViewList[0].id}",re[0].workflowId,window,"${curPerm.defaultPolicyId}","${CurrentUser.id}",'${fn:escapeXml(CurrentUser.name)}',"${fn:escapeXml(CurrentUser.loginAccountName)}","${CurrentUser.loginAccount}",nomorlOperationId,startOperationId,"${curPerm.defaultPolicyName}");
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
        
        $("body").data("cloneTable",$("#editArea").clone(true));
        
	});
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
		if($("#archiveId").val()!=""){
			if($(":checkbox:checked","#authDetail").length<=0){
				$.alert("${ctp:i18n('form.bind.chooseDetail')}");
				return false;
			}
		}
		return true;
	}
	
	 function delData(){
        	$("#markBindDiv em").click(function(){
        		var index = $(this).parent("span").index();
        		var newArr = $("#markBind").val().split("#");
        		$("#markBind").val(newArr.del(index).join("#"));
        		$(this).parent("span").remove();
        	})
        }
        
	//显示模板 canDeleteFile是否能删除附件 文档
	function initTemplateData(templateId,canDeleteFile){
		canDeleteFile = (canDeleteFile==null?true:canDeleteFile);
		var manager = new formBindDesignManager();
		AjaxDataLoader.load("${path }/form/bindDesign.do?method=editFlowTemplate&fbid=${fbid}&id="+templateId,{},function(obj){
       	obj = $.parseJSON(obj);
       	markShow(obj.markList);
       	//判断是默认状态下还是修改状态
       	if(!canDeleteFile){
       		$("#markBindDiv").prop("disabled",true).find("em").hide();
       	}
		$("#editArea").fillform(obj);
		$("#fileArea").empty();
		if(${formBean.govDocFormType} == 7 || ${formBean.govDocFormType} == 5 || ${formBean.govDocFormType} == 6 || ${formBean.govDocFormType} == 8){
			var bodyTypeSelect = document.getElementById("contentType").options;
			if(${formBean.govDocFormType == 6}){
				$("#saveOrUpdateValidate").val(obj.dep_auth);
			}
			for(var i=0;i<bodyTypeSelect.length;i++){
				// 目前存在 -1的情况为  无 的时候 为-1 类型为1 、 41 office   2、 45 pdf  其他没有情况为-1
				if(("-1" != obj.contentFileId || obj.contentType == 45) && bodyTypeSelect[i].value == obj.contentType){
					bodyTypeSelect[i].selected = true;
					document.getElementById("govdocBodyType").value = convertString(obj.contentType);
					//changeBodyType2(bodyTypeSelect[i].value,true);
					fileId=obj.contentFileId;
					createDate="2015-12-16 10:43:22";
					var content1 = document.getElementById("content");
					if(content1) content1.value = obj.contentFileId;
					showEditor(obj.contentType, true);
					break;
				}
				bodyTypeSelect[0].selected = true;
			}
			var redDocument =  document.getElementById("contentRed").options;
			for(var i=0;i<redDocument.length;i++){
				if(redDocument[i].value == obj.taohongTemplete){
					redDocument[i].selected = true;
					var taohongTemplete = document.getElementById("taohongTemplete");
					taohongTemplete.value = obj.taohongTemplete;
					break;
				}	
			}
		}
		if(obj.archive_Id!=null&&obj.archive_Id!=""){
			var option = document.createElement('option');
			if (obj.archiveFieldName != null && obj.archiveFieldName != "") {
			  $("#archiveFieldName").val(obj.archiveFieldName);
			  option.text = obj.archive_name + "\\" + "{" + obj.archiveFieldDisplay + "}";
			} else {
			  option.text = obj.archive_name;
			}
			$("#archiveName").val(obj.archive_name);
			if (obj.archiveIsCreate != null && obj.archiveIsCreate != "") {
			  $("#archiveIsCreate").val(obj.archiveIsCreate);
			} else {
			  $("#archiveIsCreate").val("true");
			}
			option.value = obj.archive_Id;
			option.selected = true;
			$("#archiveId")[0].add(option);
			$("#authDetail").removeClass("hidden");
		}
		if (obj.cycleState == "0") {
          $("#cycleStateBtn").hide();
        } else {
          $("#cycleStateBtn").show();
        }
		deleteAllAttachment(0);
		deleteAllAttachment(2);
		var uploadStr = "<input id=\"uploadFile\" name=\"uploadFile\" attsdata='@attsJson@' type=\"text\" class=\"comp\" comp=\"type:'fileupload',isBR:true,applicationCategory:'1',canFavourite:false,canDeleteOriginalAtts:"+canDeleteFile+",originalAttsNeedClone:false\">";
		//alert(obj.fileJson);
	          $("#fileArea").html(uploadStr.replace("@attsJson@",obj.fileJson));
	          var docStr = "<div id=\"rel_doc\" class=\"comp\" attsdata='@attsJson@' comp=\"type:'assdoc',attachmentTrId:'rel_doc',isBR:true,canFavourite:false,modids:'2,3',canDeleteOriginalAtts:"+canDeleteFile+"\"></div>";
	          $("#rel_doc_div").html(docStr.replace("@attsJson@",obj.fileJson));
	          $("body").comp();
			});
	}
	function deleteTemplate(ids){
		var manager = new formBindDesignManager();
		manager.delFlowTemplate(ids, {
            success: function(obj){
				winReflesh("${path }/form/bindDesign.do?method=index");
         	}
     	});
	}
	function editState(){
		$("a","#editArea").removeClass("common_button_disable").removeClass("common_button").addClass("common_button");
		$("#advancePigeonhole").removeClass("disabled_color").removeClass("like_a").addClass("like_a").removeClass("hand").addClass("hand");
		$("#contentBtn").removeClass("disabled_color").removeClass("like_a").addClass("like_a").removeClass("hand").addClass("hand");
		$("#taohongBtn").removeClass("disabled_color").removeClass("like_a").addClass("like_a").removeClass("hand").addClass("hand");
		$("#contentBtn").attr("disabled",false);
		$("#taohongBtn").attr("disabled",false);
		$("#markBindSet").attr("disabled",false);
		$("#subject").prop("readonly",false);
		$("#templateNumber").prop("readonly",false);
		$(":disabled","#editArea").prop("disabled",false);
		$("#contentRed").attr("disabled","disabled");
	}
	function setInitState(){
		var bindTable = $("#editArea");
		bindTable.empty();
		bindTable.append($("body").data("cloneTable").clone(true).children());
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
	function changeBodyType2(bodyType,callbackFunc) {
		bodyType = transType(bodyType);
		var bodyTypeObj = document.getElementById("govdocBodyType");
		if (bodyTypeObj && bodyTypeObj.value == bodyType) {
			return true;
		}else{
			bodyTypeObj.value = bodyType;
		}
		
		if(bodyType=='HTML'){
			var contentObj=document.getElementById("content");
			if(contentObj)
			{
				contentObj.value="";
			}
		}
		document.getElementById("editFrame").contentWindow.showEditor(bodyType, true);
	}
	function getBodyTpe(optionsVar){
		var bodytype = 0;
		if(optionsVar && optionsVar.length>0){
			for(var i=0; i<optionsVar.length; i++){
				if(optionsVar[i].value == 41 || optionsVar[i].value == 43){
					bodytype = i;
					break;
				}
			}
		}
		return bodytype;
	}
	//G6V5.7- 保存公文正文
	function saveGovdocBody2(){
		var res =document.getElementById("editFrame").contentWindow;
		var bodyType = document.getElementById("govdocBodyType").value;
		res.document.getElementById("govdocBodyType").value = bodyType;
		if("-1" == bodyType){ //如果不需要正文的，则不需要保存
			return true;
		}
		//保存公文正文
		if(bodyType == "HTML"){
			var rsStr = res.getHtmlContent();
			$("#contentFileId").val(rsStr);
			$("#content").val(rsStr);
		}else{
		   if(!res.saveOcx(true))
		   {//失败
			 return false;
		   }else{
			//成功，则传递参数
			  $("#contentFileId").val(res.fileId);
			  $("#content").val(res.fileId);
		   }
		}
		
	   //G6V5.7- 保存公文正文 --end	   
	   return true;
   
	}
	function transType(bodyType){

		if(bodyType==10){
			bodyType="HTML";
		}else if(bodyType==41){
			bodyType="OfficeWord";
		}else if(bodyType==42){
			bodyType="OfficeExcel";
		}else if(bodyType==43){
			bodyType="WpsWord";
		}else if(bodyType==44){
			bodyType="WpsExcel";
		}else if(bodyType==45){
			bodyType="Pdf";
		}else if(bodyType==46){
			bodyType="Ofd";
		}
		return bodyType;
	}
	function contentBtnClic(){
		//防止a标签disabled后还可以点击
		if($("#contentBtn").attr("disabled") && $("#contentBtn").attr("disabled") != "undefined"){
			return;
		}
		var contentType = document.getElementById("contentType");
		var bodyType = document.getElementById("govdocBodyType").value;
		if(contentType){
		  var index = contentType.selectedIndex; // 选中索引
		  var bodyTypeid = contentType.options[index].value; // 选中值
		  bodyType = transType(bodyTypeid);
		}
		if("-1" == bodyType){
			return;
		}
		document.getElementById("govdocBodyType").value = bodyType;
		var editframe = document.getElementById("editFrame").contentWindow;
		editframe.document.getElementById("govdocBodyType").value = bodyType;
		editframe.dealPopupContentWin(true,false);
	}
	function convertString(bodyType){
		if(bodyType==10){
				bodyType="HTML";
			}else if(bodyType==41){
				bodyType="OfficeWord";
			}else if(bodyType==42){
				bodyType="OfficeExcel";
			}else if(bodyType==43){
				bodyType="WpsWord";
			}else if(bodyType==44){
				bodyType="WpsExcel";
			}else if(bodyType==45){
				bodyType="Pdf";
			}else if(bodyType==46){
				bodyType="Ofd";
			}
			return bodyType;
	}
	function taohongClc(){
		var bodyType = document.getElementById("govdocBodyType").value;
		if (bodyType == "Pdf") {
	        alert($.i18n("govdoc.pdfnofuntion.text"));
	        return;
	    }
		//防止a标签disabled后还可以点击
		if($("#taohongBtn").attr("disabled") && $("#taohongBtn").attr("disabled") != "undefined"){
			return;
		}
		if (bodyType == "HTML") {
        alert($.i18n("govdoc.htmlnofuntion.text"));
	        return;
	    }
	    if (bodyType == "OfficeExcel")// excel不能进行正文套红。
	    {
	        alert($.i18n("govdoc.excelnofuntion.text"));
	        return;
	    }
	    if (bodyType == "WpsExcel")// excel不能进行正文套红。
	    {
	        alert($.i18n("govdoc.wpsetnofuntion.text"));
	        return;
	    }
	    if (bodyType == "gd") {
	        alert($.i18n("govdoc.gdnofuntion.text"));
	        return;
	    }
   
	
		//如果是新建的时候套红，则手动保存该正文，不然无法将正文套入模版中  而更新则不用保存，否则报错
		if(contentState){
			saveGovdocBody2();
		}
		var editframe = document.getElementById("editFrame").contentWindow;
		editframe.mygovdocContentTaohong(bodyType,'edoc','${CurrentUser.loginAccount }');
	}

	</script>
</html>