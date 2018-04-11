<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
	<meta name="renderer" content="webkit">
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<title>${ctp:i18n('menu.taskmanage.new')}</title>
</head>
<body style="background: #fafafa;">
	<div class="form_area" id="taskinfo">
		<form id="taskinfoform" name="taskinfoform" method="post" action="${path }/taskmanage/taskinfo.do?method=saveTask">
			<div id="domain_task_info" class="margin_b_10">
				<%-- 隐藏属性 --%>
				<input type="hidden" name="optype" id="optype" value="${optype}" />
				<input type="hidden" id="task_id" name="task_id" />
				<input type="hidden" id="fulltime" name="fulltime" value="1" /> 
				<input type="hidden" id="remindstarttime" name="remindstarttime" value="-1" /> 
				<input type="hidden" id="remindendtime" name="remindendtime" value="-1" />
				<table width="496" border="0" cellspacing="0" cellpadding="0" align="center" class="fixed_table_nowrap color_414141 font_size14">
					<%--标题 --%>
					<tr>
						<td colspan="2" class="padding_t_15 padding_b_3"><span class="color_red">*</span>${ctp:i18n("common.subject.label")}</td>
					</tr>
					<tr>
						<td colspan="2">
							<div class="common_txtbox_wrap">
								<input id="subject" name="subject" type="text" class="validate" validate='type:"string",name:"${ctp:i18n("common.subject.label")}",notNull:true,maxLength:85'>
							</div>
						</td>
					</tr>
					<%--描述 & 附件--%>
					<tr>
						<td colspan="2" class="padding_t_15 padding_b_3">${ctp:i18n("taskmanage.description.js")}</td>
					</tr>
					<tr>
						<td colspan="2">
							<div class="projectTask_reply">
								<%--描述 --%>
								<div class="common_txtbox left clearfix">
									<textarea class="w100b" style="resize: none; width: 485px;" rows="8" id="content" name="content" placeholder="${ctp:i18n("taskmanage.content.alert.js") }"></textarea>
								</div>
								<%--附件&关联附件 --%>
								<div id="attmentDiv" class="left clearfix w100b font_size12">
									<div id="attachmentTR" style="display: none;"></div>
									<div class="comp clearfix" comp="type:'fileupload',applicationCategory:'30',canDeleteOriginalAtts:true,originalAttsNeedClone:false,canFavourite:false" attsdata='${ attachmentsJSON}'></div>
									<div class="comp clearfix" comp="type:'assdoc',applicationCategory:'30',canDeleteOriginalAtts:true,attachmentTrId:'position1', modids:'1,3,6'" attsdata='${ attachmentsJSON}'></div>
								</div>
								<div class="left clearfix w100b padding_t_3 padding_b_3">
									<div class="padding_lr_10 padding_tb_5 border_r left" onclick="insertAttachment();">
										<em class="ico16 affix_16"></em>
									</div>
									<div class="padding_lr_10 padding_tb_5 left" onclick="quoteDocument('position1');">
										<em class="ico16 associated_document_16"></em>
									</div>
								</div>
							</div>
						</td>
					</tr>
					<%--计划时间 --%>
					<tr>
						<td colspan="2" class="padding_t_15 padding_b_3"><span class="color_red">*</span>${ctp:i18n("taskmanage.planTime.label")}</td>
					</tr>
					<tr>
						<td colspan="2">
							<table width="495px" border="0" cellspacing="0" cellpadding="0" class="fixed_table_nowrap">
								<tr>
									<td width="232" class="remindImgTime1">
										<div class="common_txtbox_wrap">
											<input id="starttime" name="starttime" class="comp validate" value="" type="text" readonly="readonly" comp="type:'calendar',isJustShowIcon:true" validate='type:"string",name:"${ctp:i18n("taskmanage.starttime")}",notNull:true' />
										</div>
									</td>
									<td width="0" class="padding_l_3 remindImg1"><span id="remind_start_time_img" class="ico16 time_remind_16" title="" style="display: none"></span></td>
									<td align="center" width="28">${ctp:i18n("taskmanage.to.label")}</td>
									<td width="232" class="remindImgTime2">
										<div class="common_txtbox_wrap" style="width: 205px">
											<input id="endtime" name="endtime" class="comp validate" value="" type="text" readonly="readonly" comp="type:'calendar',isJustShowIcon:true" validate='type:"string",name:"${ctp:i18n("common.date.endtime.label")}",notNull:true,needfloat:true' />
										</div>
									</td>
									<td width="0" class="padding_l_3 remindImg2"><span id="remind_end_time_img" class="ico16 time_remind_16" style="display: none"></span></td>
								</tr>
							</table> 
						</td>
					</tr>
					<%--实际时间：只在编辑时显示 --%>
					<c:if test="${optype == 'Edit'}">
					<tr class="actual_time">
						<td colspan="2" class="padding_t_15 padding_b_3">${ctp:i18n("taskmanage.actualtime.label")}</td>
					</tr>
					<tr class="actual_time">
						<td colspan="2">
							<table width="100%" border="0" cellspacing="0" cellpadding="0" class="fixed_table_nowrap">
								<tr>
									<td width="234">
										<div class="common_txtbox_wrap">
											<input id="actual_start_time" name="actual_start_time" class="comp" value="" type="text" readonly="readonly" comp="type:'calendar',isJustShowIcon:true" />
										</div>
									</td>
									<td width="28" align="center">${ctp:i18n("taskmanage.to.label")}</td>
									<td width="234">
										<div class="common_txtbox_wrap">
											<input id="actual_end_time" name="actual_end_time" class="comp" value="" type="text" readonly="readonly" comp="type:'calendar',isJustShowIcon:true" />
										</div>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					</c:if>
					<%--负责人&参与人 --%>
					<tr>
						<td class="padding_r_15 padding_t_15 padding_b_3" width="50%"><span class="color_red">*</span>${ctp:i18n("taskmanage.manager")}</td>
						<td class="padding_l_15 padding_t_15 padding_b_3">${ctp:i18n("taskmanage.participator")}</td>
					</tr>
					<tr>
						<td class="padding_r_15">
							<div class="common_txtbox_wrap">
								<input id="managers_text" type="text" name="managers_text" readonly="readonly" style="cursor: pointer;" class="validate" validate='type:"string",name:"${ctp:i18n("taskmanage.manager")}",notNull:true' />
								<input id="managers" type="hidden" name="managers" />
							</div>
						</td>
						<td class="padding_l_15">
							<div class="common_txtbox_wrap">
								<input id="participators_text" type="text" name="participators_text" readonly="readonly" style="cursor: pointer;" /> 
								<input id="participators" type="hidden" name="participators" /> 
							</div>
						</td>
					</tr>
					<%--更多 --%>
					<tr>
						<td colspan="2" class="padding_tb_5">
							<div id="more" class="w20b">${ctp:i18n("message.header.more.alt")}<em id="topEm" class="ico16 rolling_btn_b padding_b_5 margin_l_5"></em></div>
						</td>
					</tr>
					<%--告知&重要程度&标为里程碑 --%>
					<tr class="extendClass hidden">
						<td class="padding_r_15 padding_t_5 padding_b_3">${ctp:i18n("taskmanage.notice.js")}</td>
						<td class="padding_l_15 padding_t_5 padding_b_3">${ctp:i18n("taskmanage.detail.importantLevel.label")}</td>
					</tr>
					<tr class="extendClass hidden">
						<td class="padding_r_15">
							<div class="common_txtbox_wrap">
								<input id="inspectors_text" type="text" class="hand" name="inspectors_text" readonly="readonly" /> 
								<input id="inspectors" type="hidden" name="inspectors" />
							</div>
						</td>
						<td class="padding_l_15">
							<table border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<div class="common_selectbox_wrap">
											<select id="importantlevel" name="importantlevel" class="codecfg" style="width: 134px; vertical-align: top;" codecfg="codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.ImportantLevelEnums'"></select>
										</div>
									</td>
									<td class="padding_l_10">
										<label for="milestone_check" class="margin_r_10 hand"><input id="milestone_check" name="milestone_check" type="checkbox" <c:if test="${ffdomain_task_info.milestone == '1'}">checked</c:if> class="radio_com">${ctp:i18n("taskmanage.mark.milestone.label")}</label> 
										<input type="hidden" id="milestone" name="milestone" value="0" /> 
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<%--所属项目&上级任务 --%>
					<tr class="extendClass hidden">
						<td class="padding_r_15 padding_t_15 padding_b_3"><c:if test="${ctp:hasPlugin('project')}">${ctp:i18n("taskmanage.project.belong.js")}</c:if></td>
						<td class="padding_l_15 padding_t_15 padding_b_3">${ctp:i18n("taskmanage.parentTask")}</td>
					</tr>
					<tr class="extendClass hidden">
						<td class="padding_r_15">
							<c:if test="${ctp:hasPlugin('project')}">
							<div id="projectDiv" class="common_selectbox_wrap"></div>
							</c:if>
							<input type="hidden" name="projectId" id="projectId" value="-1" />
							<input type="hidden" name="projectPhaseId" id="projectPhaseId" value="1"/>
						</td>
						<td class="padding_l_15">
							<table width="100%" cellpadding="0" cellspacing="0" border="0" class="">
								<tr>
									<td>
										<div class="common_txtbox_wrap">
											<input id="parent_task_text" name="parent_task_text" type="text" readonly="readonly" class="hand" />
											<input type="hidden" id="parent_task_id" name="parent_task_id" value="-1" /> 
										</div>
									</td>
									<td width="38" class="padding_l_2 padding_r_2 weight_area" align="center">${ctp:i18n("taskmanage.weight")}</td>
									<td width="35" class="weight_area">
										<div class="common_txtbox_wrap" style="width: 25px;">
											<input id="weight" maxlength="5" type="text" name="weight" class="align_center" value="0" validate='name:"${ctp:i18n("taskmanage.weight")}",isNumber:true,decimalDigits:0, maxValue:100,minValue:0,errorMsg:"${ctp:i18n("taskmanage.alert.weight.zero_hundred")}"' />
										</div>
									</td>
									<td width="20" class="weight_area">&nbsp;％</td>
								</tr>
							</table>
						</td>
					</tr>
					<%--任务来源： 当任务是由其他模块转换过来时显示--%>
					<tr id="source_info" class="extendClass hidden">
						${sourceHtml }
					</tr>
					<input type="hidden" name="source_id" id="source_id" value="-1" /> 
					<input type="hidden" name="source_type" id="source_type" value="0" />
					<input type="hidden" name="source_record_id" id="source_record_id" value="-1" />
				</table>
			</div>
		</form>
	</div>
	<%-- 任务日历控件--%>
	<div id="set_plan_time" class="font_size12 form_area hidden">
		<table class="margin_lr_5 padding_t_5" cellpadding="0" width="400" cellspacing="0">
			<%--开始日期&结束日期--%>
			<tr style="background: #5fabf1;">
				<td colspan="2" class="font_bold" style="color: #fff; padding: 6px 0 6px 10px;">${ctp:i18n('taskmanage.starttime')}</td>
				<td colspan="2" class="font_bold" style="color: #fff; padding: 6px 0 6px 10px;">${ctp:i18n('common.date.endtime.label')}</td>
			</tr>
			<tr style="height: 215px">
				<td class="padding_tb_5 padding_r_5" id="startdate" colspan="2" valign="top">
					<input type="hidden" id="start_date" />
				</td>
				<td class="padding_tb_5" id="enddate" colspan="2" valign="top">
					<input type="hidden" id="end_date" />
				</td>
			</tr>
			<%--全天&开始日期时分&结束日期时分 --%>
			<tr>
				<td colspan="2">
					<table class="" cellpadding="0" width="100%" cellspacing="0">
						<tr>
							<td>
								<div class="common_checkbox_box clearfix ">
									<label class="margin_r_10 hand" for="fulltimechk">
										<input id="fulltimechk" class="radio_com" name="fulltimechk" type="checkbox" />${ctp:i18n("taskmanage.fulltime")}
									</label>
									<input type="hidden" id="fulltimetext" name="fulltimetext" />
								</div>
							</td>
							<th nowrap="nowrap">${ctp:i18n("taskmanage.time")}:</th>
							<td width="60%">
								<table class="" cellpadding="0" width="100%" cellspacing="0">
									<tr>
										<td width="49%">
											<div class="common_selectbox_wrap">
												<select id="start_time_hour" name="start_time_hour">
													<c:forEach var="i" begin="0" end="23">
														<c:choose>
															<c:when test="${i < 10 }">
																<option value="0${i}">0${i}</option>
															</c:when>
															<c:otherwise>
																<option value="${i}">${i}</option>
															</c:otherwise>
														</c:choose>
													</c:forEach>
												</select>
											</div>
										</td>
										<td width="">&nbsp;<strong>:</<strong>&nbsp;</td>
										<td width="49%">
											<div class="common_selectbox_wrap">
												<select id="start_time_minutes" name="start_time_minutes">
													<c:forEach var="i" begin="0" end="59">
														<c:choose>
															<c:when test="${i < 10 }">
																<option value="0${i}">0${i}</option>
															</c:when>
															<c:otherwise>
																<option value="${i}">${i}</option>
															</c:otherwise>
														</c:choose>
													</c:forEach>
												</select>
											</div>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
				<td colspan="2">
					<table class="" cellpadding="0" width="100%" cellspacing="0">
						<tr>
							<th nowrap="nowrap">${ctp:i18n("taskmanage.time")}:</th>
							<td width="60%">
								<table class="" cellpadding="0" width="100%" cellspacing="0">
									<tr>
										<td width="49%">
											<div class="common_selectbox_wrap">
												<select id="end_time_hour" name="end_time_hour">
													<c:forEach var="i" begin="0" end="23">
														<c:choose>
															<c:when test="${i < 10 }">
																<option value="0${i}">0${i}</option>
															</c:when>
															<c:otherwise>
																<option value="${i}">${i}</option>
															</c:otherwise>
														</c:choose>
													</c:forEach>
												</select>
											</div>
										</td>
										<td width="">&nbsp;<strong>:</<strong>&nbsp;</td>
										<td width="49%">
											<div class="common_selectbox_wrap">
												<select id="end_time_minutes" name="end_time_minutes">
													<c:forEach var="i" begin="0" end="59">
														<c:choose>
															<c:when test="${i < 10 }">
																<option value="0${i}">0${i}</option>
															</c:when>
															<c:otherwise>
																<option value="${i}">${i}</option>
															</c:otherwise>
														</c:choose>
													</c:forEach>
												</select>
											</div>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<%--开始前提醒&结束前提醒 --%>
			<tr id="remind_time">
				<th nowrap="nowrap">${ctp:i18n("taskmanage.remind.before.start")}:</th>
				<td width="50%">
					<div class="common_selectbox_wrap">
						<select id="remind_start_time_select" name="remind_start_time_select" class="codecfg" codecfg="codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.RemindTimeEnums'"></select>
					</div>
				</td>
				<th nowrap="nowrap">${ctp:i18n("taskmanage.remind.before.end")}:</th>
				<td width="50%">
					<div class="common_selectbox_wrap">
						<select id="remind_end_time_select" name="remind_end_time_select" class="codecfg" codecfg="codeType:'java',codeId:'com.seeyon.apps.taskmanage.enums.RemindTimeEnums'"></select>
					</div>
				</td>
			</tr>
			<tr>
				<td width="50%" colspan="2"></td>
				<td width="50%" colspan="2" align="right"><a id="btnok" class="common_button common_button_emphasize" href="javascript:void(0)">${ctp:i18n('common.button.ok.label')}</a> <a id="btncancel" class="common_button common_button_gray margin_lr_5" href="javascript:void(0)">${ctp:i18n('common.button.cancel.label')}</a></td>
			</tr>
		</table>
	</div>
	<%--日历组件 [END] --%>
	<%@include file="/WEB-INF/jsp/common/common_footer.jsp"%>
	<c:if test="${ctp:hasPlugin('project') }">
	<script type="text/javascript" src="${path}/apps_res/projectandtask/js/project-select-debug.js${ctp:resSuffix()}"></script>
	</c:if>
	<c:if test="${ctp:hasPlugin('plan')}">
		<%@ include file="/WEB-INF/jsp/apps/plan/planInterface.js.jsp"%>
	</c:if>
	<script type="text/javascript" src="${path}/apps_res/taskmanage/js/jquery.ui.placeholder-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript" src="${path}/apps_res/taskmanage/js/taskInfo-editor-debug.js${ctp:resSuffix()}"></script>
	<script type="text/javascript">
		var hasProject = ${ctp:hasPlugin("project")};
		var hasPlan = ${ctp:hasPlugin("plan")};
		var projectRole = '${projectRole}';
		$(document).ready(function(){
			$('input, textarea').placeholder();
			initTaskEditor();
		});
	</script>
</body>	
</html>