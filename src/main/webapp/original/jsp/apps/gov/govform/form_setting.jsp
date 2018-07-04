<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<table id="formTable2" class="font_size12 form_area w100b" style="height:300px;overflow:hidden;" align="center">
	<tr>
		<td>
			<fieldset id="fieldset" style="padding: 20px"><legend><b>${ctp:i18n('govform.label.formsetting.sortType.set')}<!-- 处理意见格式设置 --></b></legend>
				<div class="categorySet-body-govform" style="width:97%;" id="settingDiv1" name="settingDiv1">
				<table id="settingTable1">
					<tr>
						<td>${ctp:i18n('govform.label.formsetting.flowperm.setup')}<!-- 意见保留设置 -->:</td>
						<td>
							<div class="common_checkbox_box clearfix">
								<input type="radio" id="optionType2" name="optionType" value="2" <c:if test="${param.editFlag == 'readonly'}"> disabled="disabled"</c:if>/>
								<label for="optionType2">${ctp:i18n('govform.label.formsetting.flowperm.all')}<!-- 全流程保留所有意见 --></label>
							</div>
						</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<div class="common_checkbox_box clearfix">
								<input type="radio" id="optionType1" name="optionType" value="1" checked="checked" <c:if test="${param.editFlag == 'readonly'}"> disabled="disabled"</c:if>/>
								<label for="optionType1">${ctp:i18n('govform.label.formsetting.flowperm.showLastOptionOnly')}<!-- 全流程保留最后一次意见 --></label>
							</div>
						</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<div class="common_checkbox_box clearfix">
								<input type="radio" id="optionType4" name="optionType" value="4" <c:if test="${param.editFlag == 'readonly'}"> disabled="disabled"</c:if>/>
								<label for="optionType4">${ctp:i18n('govform.label.formsetting.flowperm.client1')}<!-- 退回时办理人选择覆盖方式，其他情况保留所有意见 --></label>
							</div>
						</td>
					</tr>
					<script>
					  	if(optionFormatSet!=null && optionFormatSet!=""){
						  	var formatSet = optionFormatSet.split(",");
						  	var optionType=null;
						  	if(formatSet[0] != '0') {
							  	optionType = formatSet[0];
						  	}else{
							  	optionType = '1';
						  	}
						  	if(formatSet[3] != "0") {
							  	optionType = formatSet[3];
						  	}
						  	document.getElementById("optionType"+optionType).checked="checked";
					   	}
					</script>
					
					<tr class="padding_t_10">
						<td class="padding_t_10">${ctp:i18n('govform.label.fromsetting.flowperm.showOpinionSignDploy')}<!-- 意见留痕配置: --></td>
						<td class="padding_t_10">
							<div class="common_checkbox_box clearfix">
								<input type="radio" id="radio3" name="showOrgnDept" value="0" checked="checked" <c:if test="${param.editFlag == 'readonly'}"> disabled="disabled"</c:if>/>
								<label for="radio3">${ctp:i18n('govform.label.formsetting.flowperm.showDept')}<!-- 显示处理人所在部门 （如：办公室 张三） --></label>	
							</div>
						</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<div class="common_checkbox_box clearfix">
								<input type="radio" id="radio4" name="showOrgnDept" value="1" <c:if test="${param.editFlag == 'readonly'}"> disabled="disabled"</c:if>/>
								<label for="radio4">${ctp:i18n('govform.label.formsetting.flowperm.showOrgan')}<!-- 显示处理人所在机关 （如：机关 办公室 张三） --></label>
							</div>
						</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<div class="common_checkbox_box clearfix">
								<input type="radio" id="radio5" name="showOrgnDept" value="2" <c:if test="${param.editFlag == 'readonly'}"> disabled="disabled"</c:if>/>
								<label for="radio5">${ctp:i18n('govform.label.formsetting.flowperm.showPerson')}<!-- 显示处理人名字 （如：张三） --></label>
							</div>
						</td>
					</tr>
					<script>
						if(optionFormatSet!=null && optionFormatSet!=""){
						  	var formatSet = optionFormatSet.split(",");
						  	var optionType=null;
						  	if(formatSet[1] == '0') {
						  		document.getElementById("radio3").checked="checked";
						  	}else if(formatSet[1] == '1') {
						  		document.getElementById("radio4").checked="checked";
						  	}else if(formatSet[1] == '2') {
						  		document.getElementById("radio5").checked="checked";
						  	}
						}
					</script>
					
					<tr>
						<td class="padding_t_10">${ctp:i18n('govform.label.formsetting.flowperm.showDateTimeFormat')}<!-- 处理时间显示格式: --></td>
						<td class="padding_t_10">
							<div class="common_checkbox_box clearfix">
								<input type="radio" id="radio1" name="dealTimeFormt" value="0" checked="checked" <c:if test="${param.editFlag == 'readonly'}"> disabled="disabled"</c:if>/>
								<label for="radio1">${ctp:i18n('govform.label.formsetting.flowperm.dealDateTimeFormt')}<!-- 显示日期时间 --></label>	
							</div>
						</td>
					</tr>
					<tr>
						<td></td>
						<td>
							<div class="common_checkbox_box clearfix">
								<input type="radio" id="radio2" name="dealTimeFormt" value="1" <c:if test="${param.editFlag == 'readonly'}"> disabled="disabled"</c:if>/>
								<label for="radio2">${ctp:i18n('govform.label.formsetting.flowperm.dealDateFormt')}<!-- 显示日期 --></label>
							</div>
						</td>
					</tr>
					<script>
						if(optionFormatSet!=null && optionFormatSet!=""){
						  	var formatSet = optionFormatSet.split(",");
						  	var optionType=null;
						  	if(formatSet[2] == '0') {
						  		document.getElementById("radio1").checked="checked";
						  	}else if(formatSet[2] == '1') {
						  		document.getElementById("radio2").checked="checked";
						  	}
						}
					</script>
				</table>
				</div>
			</fieldset>
		</td>
	</tr>
	
	<tr>
		<td>
			<div style="padding: 20px;margin:2px;height:60px;" class="categorySet-body-govform" id="settingDiv2" name="settingDiv2">
				<table id="settingTable2" width="70%" border="1" cellspacing="0" cellpadding="5" align="center">
					<thead>
					<tr style="background-color:#D3D3D3;"  style="height:25px;">
						<th align="left" style="text-align:left;line-height:20px;">${ctp:i18n('element.column.datatype6')}<!-- 处理意见 --></th>
						<th align="left" style="text-align:left;line-height:20px;">${ctp:i18n('common.workflow.policy')}<!-- 节点权限 --></th>
						<th style="text-align:center;line-height:20px;">${ctp:i18n('govform.label.formsetting.flowperm.operation.label')}<!-- 绑定操作 --></th>
						<th align="left" style="text-align:center;line-height:20px;">${ctp:i18n('govform.label.formsetting.flowperm.process.sortType')}<!-- 处理意见显示顺序 --></th>
					</tr>
					</thead>
					<tbody>
					<c:forEach items="${processList}" var="bean">
						<tr style="height:25px;">
							<td width="15%">${bean.processLabel}</td>
							<td width="45%">
								<div class="common_txtbox_wrap">
									<!-- ${bean.flowpermName==''?bean.processName:bean.flowpermName} -->
									<input readonly="readonly" type="text" name="" id="${bean.processName}" value="${bean.flowpermLabel}" />
								</div>
							</td>
							<td width="10%" align="center" style="text-align:center;">
								<div class="seach_icon_button">
									<input type="button" name="button_${bean.processName }" value="${ctp:i18n('govform.label.formsetting.button.editoperate')}" onclick="choosePermission('${bean.flowpermName}','${bean.processName}');" /><!-- 编辑操作 -->
								</div>
								<div style="display:none">
									<select id="choosedOperation_${bean.processName}" name="choosedOperation_${bean.processName}" multiple="multiple"  size="4"  class="input-100per">
										<option value="${bean.flowpermName}" itemList="${bean.flowpermNameList}">${bean.flowpermLabel}</option>
									</select>
									<input type="hidden" id="returnOperation_${bean.processName }" name="returnOperation_${bean.processName}" value="${bean.flowpermName}" type="hidden" />
								</div>
							</td>
							<td width="25%" style="text-align:center;">
								<div class="common_selectbox_wrap" style="width:95%">
									<select id="sortType_${bean.processName}" name="sortType_${bean.processName}">
										<c:choose>
											<c:when test="${bean.sortType == '0'}">
												<option value="0" selected="selected">${ctp:i18n('govform.label.formsetting.flowperm.process.sortType.dealtime.asc')}<!-- 按处理时间顺序显示 --></option>
											</c:when>
											<c:otherwise>
												<option value="0">${ctp:i18n('govform.label.formsetting.flowperm.process.sortType.dealtime.asc')}<!-- 按处理时间顺序显示 --></option>
											</c:otherwise>
										</c:choose>
										<c:choose>
											<c:when test="${bean.sortType == '1'}">
												<option value="1" selected="selected">${ctp:i18n('govform.label.formsetting.flowperm.process.sortType.dealtime.desc')}<!-- 按处理时间倒序显示 --></option>
											</c:when>
											<c:otherwise>
												<option value="1">${ctp:i18n('govform.label.formsetting.flowperm.process.sortType.dealtime.desc')}<!-- 按处理时间倒序显示 --></option>
											</c:otherwise>
										</c:choose>
										
										<c:choose>
											<c:when test="${bean.sortType == '4'}">
												<option value="4" selected="selected">${ctp:i18n('govform.label.formsetting.flowperm.process.sortTypeAsc.orgLevel')}<!-- 按职务升序显示 --></option>
											</c:when>
											<c:otherwise>
												<option value="4">${ctp:i18n('govform.label.formsetting.flowperm.process.sortTypeAsc.orgLevel')}<!-- 按职务升序显示 --></option>
											</c:otherwise>
										</c:choose>
										
										<c:choose>
											<c:when test="${bean.sortType == '2'}">
												<option value="2" selected="selected">${ctp:i18n('govform.label.formsetting.flowperm.process.sortTypeDesc.orgLevel')}<!-- 按职务降序显示 --></option>
											</c:when>
											<c:otherwise>
												<option value="2">${ctp:i18n('govform.label.formsetting.flowperm.process.sortTypeDesc.orgLevel')}<!-- 按职务降序显示 --></option>
											</c:otherwise>
										</c:choose>
										<c:choose>
											<c:when test="${bean.sortType == '3'}">
												<option value="3" selected="selected">${ctp:i18n('govform.label.formsetting.sortDepartment.asc')}<!-- 按部门顺序显示 --></option>
											</c:when>
											<c:otherwise>
												<option value="3">${ctp:i18n('govform.label.formsetting.sortDepartment.asc')}<!-- 按部门顺序显示 --></option>
											</c:otherwise>
										</c:choose>
									    <%--wangw 增加按人员排序号排序,默认显示最后一位 START --%>
										  <c:choose>
												<c:when test="${bean.sortType == '5'}">
													<option value="5" selected="selected">${ctp:i18n('govform.label.formsetting.memberSortId.asc')}</option>
												</c:when>
												<c:otherwise>
													<option value="5">${ctp:i18n('govform.label.formsetting.memberSortId.asc')}</option>
											    </c:otherwise>
										  </c:choose>
										<%--wangw 增加按人员排序号排序 End --%>
									</select>
								</div>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				<table id="noteTable" style="height:30px;" width="70%" border="0" cellspacing="0" cellpadding="5" align="center">
					<tr><td colspan="3"><font color="green">*${ctp:i18n('govform.label.formsetting.note')}<!-- 意见元素设置说明：如果信息报送流程中对应的节点权限没有与意见元素绑定，则该节点的处理意见显示在处理意见位置；如果报送单中没有处理意见元素，则处理意见显示在报送单下方位置。 --></font></td></tr>
				</table>
			</div>
			
			
			<div style="display:none">
				<select id="operation" name="operation"multiple="multiple"  size="4"  class="input-100per">
			        <%--国际化的问题 --%>
			        <c:forEach var="flowPerm" items="${permissionList}">
			            <option value="${flowPerm.name}">
			                <c:if test="${flowPerm.type == 0}">
			                    ${flowPerm.label}
			                </c:if>
			                <c:if test="${flowPerm.type == 1}">
			                    ${flowPerm.label}
			                </c:if>                             
			            </option>
			        </c:forEach>
				</select>
				
				<select id="hidden_operation" name="hidden_operation" multiple="multiple"  size="4"  class="input-100per">
					<c:forEach var="flowPerm" items="${permissionList}">
						<option value="${flowPerm.label}">
						<c:if test="${flowPerm.type == 0}">
							${flowPerm.name}
						</c:if>
						<c:if test="${flowPerm.type == 1}">
								${flowPerm.name}
							</c:if>								
						</option>
					</c:forEach>
				</select>
			</div>
			<input type="hidden" name="operation_str" id="operation_str" value="${operation_str}"> 
			
		</td>
	</tr>
	
</table>
	