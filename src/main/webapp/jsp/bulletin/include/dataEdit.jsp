<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<style>
#officeFrameDiv{height:100%;}
.cke_wysiwyg_frame{height:93%!important;}
</style>
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="CollTable">
		<tr>
			<td height="10">
				<script type="text/javascript">document.write(myBar);</script>
				<div class="hr_heng"></div>
			</td>
		</tr>
		<tr>
			<td height="10" class="bg-summary padding_t_10 padding_r_5">
			<table border="0" cellpadding="2" cellspacing="0" width="100%" align="center">
				<tr>
				<fmt:message key="oper.send" var="oper_send"/>
                <fmt:message key="oper.publish" var="oper_publish"/>
                <fmt:message key="bul.save" var="bul_save"/>
				<td rowspan="3" valign="top"><a onclick="javaScript:saveForm('submit');" id='sendId'  class="margin_lr_10 display_inline-block align_center new_btn">${param.isAuditEdit?bul_save:(isAduit?oper_send:oper_publish)}</a></td>
				<td width="1%" class="bg-gray" noWrap="noWrap"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}"/><fmt:message key="label.colon" /></td>
				<td class="value">
					<jsp:include page="../include/inputDefine.jsp">
						<jsp:param name="_property" value="title" />
						<jsp:param name="_key" value="bul.data.title" />
						<jsp:param name="_validate" value="notNull,isDefaultValue,isWord" />
						<jsp:param name="_myLength" value="200" />
					</jsp:include>
				</td>
				<td class="label bg-gray"><fmt:message key="bul.data.type" /><fmt:message key="label.colon" /></td>
				<td class="value" colspan="2">
					<c:if test="${bean.type.spaceType == 1}">
						<c:choose>
							<c:when test="${deptSpaceModels!=null && deptSpaceModelsLength>1}">
                                <input type="hidden" name="typeName" id="typeName" value="${v3x:toHTML(bean.type.typeName)}" />
                                <input type="hidden" name="typeId" id="typeId" value="${bean.type.id}" />
                                <select id="superior" name="superior" onchange="openAjax(this.value)">
                                    <c:forEach items="${deptSpaceModels}" var="dept">
                                       <c:set value="${v3x:showOrgEntitiesOfIds(dept.entityId, 'Department', pageContext)}" var="deptName" />
                                       <option title="${v3x:toHTML(deptName)}" value="${dept.entityId}" ${(bean.type.id == dept.entityId)?'selected':''}>${v3x:toHTML(v3x:getLimitLengthString(deptName,20,'...'))}<fmt:message key="bul.title" /></option>
                                    </c:forEach>
                                </select>
                            </c:when>
							<c:otherwise>
                                <input type="hidden" name="typeId" id="typeId" value="${bean.type.id}" />
                                <input disabled="disabled" type="text" name="typeName" id="typeName" value="${v3x:toHTML(v3x:showOrgEntitiesOfIds(bean.type.id, 'Department', pageContext))}" readonly="true" class="cursor-hand input-100per"/>
                            </c:otherwise>
						</c:choose>
					</c:if>
					<c:if test="${bean.type.spaceType == 4}">
								<input type="hidden" name="typeName" id="typeName" value="${v3x:toHTML(bean.type.typeName)}" />
								<input type="hidden" name="typeId" id="typeId" value="${bean.type.id}" />
								<input disabled="disabled" type="text" name="typeName" id="typeName" value="${v3x:toHTML(bean.type.typeName)}" readonly="true" class="cursor-hand input-100per"/>
					</c:if>
					<c:if test="${bean.type.spaceType != 1 && bean.type.spaceType != 4}">					
					<input type="hidden" name="typeName" id="typeName" value="" />
					<c:set var="disable" value="disabled='disabled'"/>
					<select name="typeId" id="typeId" class="input-100per" onchange="syncBulStyleValue(this.value)"  ${param.isAuditEdit eq 'true'?disable:''}>
			    		<c:forEach items="${bulTypeList}" var="bulType">
							<c:choose>
								<c:when test="${bean.type.id == bulType.id}" >
									<option value="${bulType.id}" selected>${v3x:toHTML(bulType.typeName)}</option>
								</c:when>
								<c:otherwise>
									<option value="${bulType.id}" >${v3x:toHTML(bulType.typeName)}</option>
								</c:otherwise>
							</c:choose>
							<script>
								bulStyleMap.put("${bulType.id}", "${bulType.ext1}");
							</script>
						</c:forEach>
		    		</select>
		    		</c:if>
				</td>
				
			</tr>
			
			<tr>
				
				<td width="1%" class="bg-gray" nowrap><fmt:message key='common.issueScope.label' bundle="${v3xCommonI18N}"/><fmt:message key="label.colon" /></td>
				<td class="value">
					<c:set value="${v3x:showOrgEntitiesOfTypeAndId(bean.publishScope, pageContext)}" var="publishScopeValue" />
					<c:set value="${v3x:parseElementsOfTypeAndId(bean.publishScope)}" var="org"/>
					
					<c:if test="${bean.type.spaceType == 3}">
						<c:set value="Account,Department,Team,Post,Level" var="selPanels" />
					</c:if>
					<c:if test="${bean.type.spaceType != 3}">
						<c:set value="Department,Team,Post,Level,Outworker" var="selPanels" />
					</c:if>
					<c:if test="${spaceType == 18||spaceType == 17||spaceType == 4}">
					   <script type="text/javascript">
                        <!--
                         includeElements_scope = "${v3x:parseElementsOfTypeAndId(entity)}";
                        //-->
                        </script>
                        <c:set value="Account,Department,Team,Post,Level,Outworker" var="selPanels" />
                    </c:if>
                    <c:if test="${spaceType == 1}">
                       <script type="text/javascript">
                        <!--
                         includeElements_scope = "${v3x:parseElementsOfTypeAndId(publisthScopeDep)}";
                        //-->
                        </script>
                    </c:if>
					<c:if test="${bean.type.spaceType == 3 ||spaceType == 18}">
					<v3x:selectPeople id="scope" showAllAccount="true"  originalElements="${org}" panels="${selPanels}" selectType="Member,Department,Account,Post,Level,Team" jsFunction="setBulPeopleFields(elements,'publishScope','publishScopeNames')" 
					/>	
					</c:if>
					<c:if test="${bean.type.spaceType != 3 && spaceType != 18}">
                    <v3x:selectPeople id="scope"  originalElements="${org}" panels="${selPanels}" selectType="Member,Department,Account,Post,Level,Team" jsFunction="setBulPeopleFields(elements,'publishScope','publishScopeNames')" 
                    />  
                    </c:if>
					<script type="text/javascript">
						<%-- 单位公告、部门公告不选择个人组外单位人员 --%>
						if('${bean.type.spaceType}' != '3') {
							if ('${bean.type.spaceType}' == '4' || '${bean.type.spaceType}' == '17' || '${bean.type.spaceType}' == '18') {
								onlyLoginAccount_scope = false;
							
							} else {
								onlyLoginAccount_scope = true;						
								hiddenOtherMemberOfTeam_scope = true;
							}
						} else {
							onlyLoginAccount_scope = false;						
							hiddenOtherMemberOfTeam_scope = false;
						}
						isNeedCheckLevelScope_scope  = false;
						if ('${bean.type.spaceType}' == '4' || '${bean.type.spaceType}' == '17' || '${bean.type.spaceType}' == '18') {
							showAllOuterDepartment_scope = false;
						}else{
							showAllOuterDepartment_scope = true;
						}
					</script>	
						<fmt:message key='common.issueScope.label' bundle="${v3xCommonI18N}" var="_myLabel"/>
						<fmt:message key="label.please.select" var="_myLabelDefault">
							<fmt:param value="${_myLabel}" />
						</fmt:message>
						
						<input type="hidden" id="publishScope" name="publishScope" value="${bean.publishScope}" />
						<c:set value="selectPeople('scope','publishScope','publishScopeNames')" var="scopeEvent" />
						<input type="text" class="cursor-hand input-100per" id="publishScopeNames" name="publishScopeNames" readonly="true"  
							value="<c:out value="${publishScopeValue}" default="${_myLabelDefault}" escapeXml="true" />"
							defaultValue="${_myLabelDefault}"
							onfocus="checkDefSubject(this, true)"
							onblur="checkDefSubject(this, false)"
							inputName="${_myLabel}" 
							validate="notNull,isDefaultValue"
							${v3x:outConditionExpression(readOnly, 'disabled', '')}
							onclick="${scopeEvent}"
							
							/>
				</td>
				<td class="label bg-gray"><fmt:message key="bul.data.publishDepartmentId" /><fmt:message key="label.colon" /></td>
				<td class="value" colspan="2">
					
					<c:set value="${v3x:getOrgEntity('Department', bean.publishDepartmentId).name}" var="publishScopeValue"/>
					<!-- ??????????????????????????????? -->
					<c:set value="${v3x:parseElementsOfIds(bean.publishDepartmentId, 'Department')}" var="defauDepar"/>
				
					<v3x:selectPeople id="dept" originalElements="${defauDepar }" panels="Department" selectType="Department" jsFunction="setBulPeopleFields(elements,'publishDepartmentId','publishDepartmentName')" maxSize="1" minSize="1" />
					<script type="text/javascript">
									if('${bean.type.spaceType}' != '3')
						onlyLoginAccount_dept = true;
					</script>
					<fmt:message key="bul.data.publishDepartmentId" var="_myLabel"/>
					<fmt:message key="label.please.select" var="_myLabelDefault">
						<fmt:param value="${_myLabel}" />
					</fmt:message>
						<input type="hidden" id="publishDepartmentId" name="publishDepartmentId" value="${bean.publishDepartmentId}"/>
							<input type="text" class="cursor-hand input-100per" id="publishDepartmentName" name="publishDepartmentName" readonly="true"  
								value="<c:out value="${publishScopeValue}" default="${_myLabelDefault}" escapeXml="true" />"
								defaultValue="${_myLabelDefault}"
								onfocus="checkDefSubject(this, true)"
								onblur="checkDefSubject(this, false)"
								inputName="${_myLabel}" 
								validate="notNull,isDefaultValue"
								${v3x:outConditionExpression(readOnly, 'disabled', '')}
								onclick="selectPeople('dept','publishDepartmentId','publishDepartmentName');"
								<c:if test="${bean.type.spaceType==1}"> disabled </c:if>
								/>
				</td>
			</tr>			
			<!--??????????? -->
			
				<tr>
						<td width="1%" class="bg-gray" nowrap></td>
						<td>	
							<input id="beanId" type="hidden" value="${bean.id}" />
							<label for="showPublishUserFlag">
								<input type="checkbox" name="showPublishUserFlag" id="showPublishUserFlag" ${v3x:outConditionExpression(bean.showPublishUserFlag, 'checked', '')}><span class="margin_l_5"><fmt:message key="bul.dataEdit.showPublishUser"/></span>
							</label>			
							<label for="a">
								<input type="checkbox" name="noteCallInfo" id="a" ${ bean.ext1 == '1'||bean.id==null ? 'checked' : ''}><span class="margin_l_5"><fmt:message key="bul.dataEdit.noteCallInfo"/></span>
							</label>
							<label for="b">
								<input type="checkbox" name="printAllow" id="b" ${ bean.ext2 == '1'||bean.id==null ? 'checked' : ''}><span class="margin_l_5"><fmt:message key="bul.dataEdit.printAllow"/></span>
							</label>
							<label for="c" style="${bean.dataFormat == 'OfficeWord' || bean.dataFormat == 'WpsWord' ? '' : 'display: none;'}" id="changePdf">
								<input type="checkbox" name="changePdf" id="c" ${empty bean.ext5 ? '' : 'checked'}><fmt:message key="common.transmit.pdf" bundle='${v3xCommonI18N}' />
							</label>
						</td>
						
					<!-- mo ban jia zai -->
					<td class="label  bg-gray"><fmt:message key="bul.template" /><fmt:message key="label.colon" /></td>
					<td width="20%" >
						<select name="templateId" id="templateId" onchange="loadBulTemplate();">
							<option value="">&lt;<fmt:message key="oper.please.select" /><fmt:message key="bul.template" />&gt;</option>
							<c:forEach items="${templateList}" var="template">
								<option value="${template.id}">${v3x:toHTML(template.templateName)}</option>
							</c:forEach>
						</select>
						
						<script type="text/javascript">
							setSelectValue("templateId","${templateId}");
						
						function previewBulTemplate(){
							if($F('templateId')==''){
								alert('<fmt:message key="oper.please.select" /><fmt:message key="bul.template" />!');
							}else{
								var dlgArgs=new Array();		
								dlgArgs['width']=708;
								dlgArgs['height']=510;
								dlgArgs['url']='<c:url value="/bulTemplate.do?method=detail" />&preview=true&id='+$F('templateId');
								v3x.openWindow(dlgArgs);
							}
						}	
						
						var hiddenPostOfDepartment_scope=true;	
						</script>
						<!-- qu diao  
							<input type="button" id="previewTemplate" value="<fmt:message key="oper.preview" />" onclick="previewBulTemplate();" />
						
						<input type="button" id="loadTemplate" value="<fmt:message key="oper.load" />" onclick="loadBulTemplate();" />
						-->
					</td>
			            <td id="space" width="20%"  style="${outerSpace == null ? 'display:none;' : ''}" ><label for="pushToSpace" id="pushToSpace1">
          	                <script type="text/javascript">
          	                	function cancelOption(){
									if("${spaceFlag}"=="true"){
										if(!document.getElementById("pushToSpace").checked){
											if(!confirm("确认删除在门户栏目的数据？")){
												document.getElementById("pushToSpace").checked = true;
											}
										}
									}
              	                }
          	                </script>
          	                <input type="checkbox" name="pushToSpace" id="pushToSpace" value="1" onclick="cancelOption();" ${spaceFlag==true ?'checked':''}/>
                            <span>推送门户</span>
                            </label>   
                            <label for="outerSpace" id="outerSpace1">
                            <input type="text" class=="input-100per" name="outerSpace" id="outerSpace" readonly="true"  value="${outerSpace.sectionLabel}" }"/>
                            <input type="hidden" id="outerSpaceId" name="outerSpaceId" value="${outerSpace.id}"/>
                            </label>   
                        </td>
				</tr>
		
			<!--  			
			<c:if test="${bean.id!=null}">
				<tr>
					<td class="label bg-gray"><fmt:message key="bul.data.createUser" /><fmt:message key="label.colon" /></td>
					<td class="value">${v3x:showMemberName(bean.createUser)}</td>
					<td class="label"><fmt:message key="bul.data.createDate" /><fmt:message key="label.colon" /></td>
					<td class="value"><fmt:formatDate value="${bean.createDate}" pattern="${datePattern}"/></td>
				</tr>
			</c:if>
			--> 
			<tr id="attachment2TR"  style="display:none;">
                <td colspan="2" valign="top"></td>
                <td colspan="3" valign="top">
                <div style="float: left"><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:</div>
                <div>
                <div class="div-float">(<span id="attachment2NumberDiv"></span>)</div>
               <div></div><div id="attachment2Area" style="overflow: auto;"></div></div>
            </tr>
			<tr id="attachmentTR" style="display:none;">
                <td colspan="2" valign="top"></td>
                <td colspan="3" valign="top">
				<div style="float: left"><fmt:message key="label.attachments" /><fmt:message key="label.colon" /></div>
				<div>
					<div class="div-float">(<span id="attachmentNumberDiv"></span>)</div>
					<v3x:fileUpload attachments="${attachments}" canDeleteOriginalAtts="true" />
				</div>
			</tr>
			</table>
		 </td>
		</tr>
		<tr>
		  	<td colspan="9" height="6" class="bg-summary"></td>
		 </tr>
		<tr>
			<td id="editerDiv_td" valign="top" height="100%">
			<div id="editerDiv" >
				<c:if test="${originalNeedClone==null}">
					<c:set var="originalNeedClone" value="false" scope="request" />
				</c:if>
				<v3x:editor htmlId="content" content="${bean.content}" type="${bean.dataFormat}" createDate="${bean.createDate}" category="7" originalNeedClone="${originalNeedClone}" contentName="${bean.contentName}" />
			</div>
			</td>
		</tr>
	</table>
	<script>
		
		var beanId = document.getElementById("beanId");
		var  h = document.getElementById("showPublishUserFlag");
		
		if(!beanId.value){
			h.checked = true;
			
		}
	</script>
