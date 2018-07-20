<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<table id="leftTable" class="font_size12 form_area" style="width:100%" border="0" align="center">
			<tr>
            	<td class="padding_5 padding_t_0 padding_b_0">${ctp:i18n('col.name')}<!-- 名称 -->：</td><%-- 名称 --%>
            </tr>
            <tr>	
	            <td class="padding_5 padding_t_0">
	                <div class="common_txtbox_wrap">
	                       	<input type="text" id="name" name="name" maxLength="85" class="validate" value="${ctp:toHTML(formVO.name)}" deaultValue="${ctp:toHTML(formVO.name)}" default="${ctp:toHTML(formVO.name)}"
								validate="type:'string',name:'${ctp:i18n('col.name')}',notNull:true,maxLength:85,avoidChar:'\\/|$%&amp;&gt;&lt;&quot;*:?'" /><!-- 名称 -->
	                   	</div>
	            	</td>
	     	</tr>
	     	
        	<tr>
            	<td class="padding_5 padding_t_0 padding_b_0">${ctp:i18n('application.type.label')}<!-- 类型 -->：</td><%-- 类型 --%>
            </tr>
            <tr>	
            	<td class="padding_5 padding_t_0">
                    <div class="common_txtbox_wrap">
                        <input type="hidden" id="type" name="type" value="${formVO.type}">
						<input type="hidden" id="sort" value="${msgType }" >
						<input type="text" id="sort" name="sort" value="${formVO.typeName}" readonly disabled="disabled">
					</div>
            	</td>
       		</tr>
       		
        	<tr>
            	<td class="padding_5 padding_t_0 padding_b_0">${ctp:i18n('govform.column.typename.default_32')}<!-- 默认报送单 -->:</td><%-- 默认报送单 --%>
            </tr>
            <tr>
            	<td class="padding_5 padding_t_0">
                	<div class="common_checkbox_box clearfix">
                		<input type="hidden" name="isDefault" id="isDefault" value="0" />
                        <c:choose>
	 						<c:when test="${formVO.isDefault}">
		 						<label class="margin_r_10 hand display_block left" for="isDefault1">
			 						<input type="radio" name="isDefault0" id="isDefault1" value="1"  checked/> ${ctp:i18n('common.yes')}<!-- 是 -->
								</label>
								<label class="margin_l_10 hand display_block left" for="isDefault2">
		 							<input type="radio" name="isDefault0" id="isDefault2" value="0" /> ${ctp:i18n('common.no')}<!-- 否 -->
								</label>				
	 						</c:when>
	 						<c:when test="${!formVO.isDefault}">
	 							<label class="margin_r_10 hand display_block left" for="isDefault1">
	 								<input type="radio" name="isDefault0" id="isDefault1" value="1" /> ${ctp:i18n('common.yes')}<!-- 是 -->
								</label>
								<label class="margin_l_10 hand display_block left" for="isDefault2">
	 								<input type="radio" name="isDefault0" id="isDefault2" value="0"  checked/> ${ctp:i18n('common.no')}<!-- 否 -->
								</label>
	 						</c:when>
	 						<c:otherwise>
	 							<label class="margin_r_10 hand display_block left" for="isDefault1">
	 								<input type="radio" name="isDefault0" id="isDefault1" value="1" /> ${ctp:i18n('common.yes')}<!-- 是 -->
	 							</label>
	 							<label class="margin_l_10 hand display_block left" for="isDefault2">
	 								<input type="radio" name="isDefault0" id="isDefault2" value="0" checked/>${ctp:i18n('common.no')}<!-- 否 -->
	 						</c:otherwise>
	 					</c:choose>
                </div>
            </td>
        	</tr>
        	
        	<tr>
            	<td class="padding_5 padding_t_0 padding_b_0">${ctp:i18n('govform.label.form.currentstatus')}<!-- 使用状态 -->:</td><%-- 使用状态 --%>
            </tr>
            <tr>	
            	<td class="padding_5 padding_t_0">
                	<div class="common_checkbox_box clearfix">
                		<input type="hidden" name="status" id="status" value="1" />
                        <c:choose>
 							<c:when test="${formVO.status == 1}">
 								<label for="status1">
 									<input type="radio" id="status1" name="status0" value="1" checked/> ${ctp:i18n('common.state.normal.label')}
								</label>
								<label for="status2">
 									<input type="radio" id="status2" name="status0" value="0" /> ${ctp:i18n('common.state.invalidation.label')}
								</label>
							</c:when>
							<c:when test="${formVO.status == 0}">
								<label for="status1">
 									<input type="radio" id="status1" name="status0" value="1"/> ${ctp:i18n('common.state.normal.label')}
 								</label>	
 								<label for="status2">
	 								<input type="radio" id="status2" name="status0" value="0" checked /> ${ctp:i18n('common.state.invalidation.label')}
								</label>
							</c:when>
							<c:otherwise>
								<label for="status1">
									<input type="radio" id="status1" name="status0" value="1"  /> ${ctp:i18n('common.state.normal.label')}	
								</label>
								<label for="status2">
 									<input type="radio" id="status2" name="status0" value="0"/> ${ctp:i18n('common.state.invalidation.label')}
 								</label>
							</c:otherwise>
						</c:choose>
                	</div>
            	</td>
        	</tr>
        	
        	<tr>
            	<td class="padding_5 padding_t_0 padding_b_0">${ctp:i18n('govform.label.fromsetting.forceItems')}<!-- 报送必填项 -->:</td><%-- 文单必填项 --%>
            </tr>
            <tr>	
            	<td class="padding_5 padding_t_0">
            		<div class="common_checkbox_box border_all" style="height:100px; OVERFLOW-Y:scroll; OVERFLOW-X:hidden;" >
	                	<table id="elementRequired">
	                		<c:set value="${param.editFlag=='true' && !isMyDomain }" var="disableFlag" />
	                    	<c:forEach items="${formElements}" var="formElement">
	                      	<tr>    
	                          	<td style='height:15px;'>
	                              	<c:choose> 
	                                  	<c:when test="${param.editFlag!='true' || disableFlag}">
	                                      	<input type='checkbox' elementId="${formElement.id}" fieldName="${formElement.fieldName }" disabled="disabled" <c:if test="${formElement.required}">checked="checked"</c:if> />
	                                   	</c:when>
	                                    <c:when test="${formElement.fieldName=='subject' || formElement.fieldName=='category'}">
	                                    	<input type='checkbox' elementId="${formElement.id}" fieldName="${formElement.fieldName }" checked="checked" disabled="disabled" />
	                                        <input type='checkbox' elementId="${formElement.id}" id="elementId_${formElement.id}" name="elementId_${formElement.id}" value="1" fieldName="${formElement.fieldName }" checked="checked"  style='display: none' />
	                                    </c:when>
	                                    <c:otherwise>
	                                      	<input type='checkbox' elementId="${formElement.id}" id="elementId_${formElement.id}" name="elementId_${formElement.id}" fieldName="${formElement.fieldName }" <c:if test="${formElement.required}">checked="checked" value="1"</c:if> />
	                                    </c:otherwise>
	                               	</c:choose>
	                               	<label>${ctp:i18n(formElement.label)}</label>
	                        	</td>                                                            
	                        </tr>
	                       	</c:forEach>
	                   	</table>
                   	</div>
            	</td>
        	</tr>
        	
        	<tr id="authLabelTr">
	            <td class="padding_5 padding_t_0 padding_b_0">${ctp:i18n('common.toolbar.auth.label')}<!-- 授权 -->:</td><%-- 授权 --%>
	        </tr>
	        
	       	<tr id="authDataTr">    
	           	<td class="padding_5 padding_t_0">
	                <div class="common_txtbox clearfix">
						<textarea id="authUnitNames" name="authUnitNames" value="" rows="4" inputName="${ctp:i18n('common.toolbar.auth.label')}" validate="" readonly = "true" style="width:100%">${ctp:toHTML(formVO.authUnitNames)}</textarea><!-- 授权 -->
						<input type="hidden" id="authUnitIds" name="authUnitIds" value="${ctp:toHTML(formVO.authUnitIds)}" />
	                </div>
	            </td>
        	</tr>
        	
        	<tr>
	            <td class="padding_5 padding_t_0 padding_b_0">${ctp:i18n('common.description.label')}<!-- 描述 -->:</td><%-- 描述 --%>
	        </tr>
	        <tr>    
	            <td class="padding_5 padding_t_0">
	                <div class="common_txtbox clearfix">
	                     <textarea class="input-100per w100b" id="description" name="description" rows="5"
								inputName="${ctp:i18n('common.description.label')}" onkeypress="return (this.value.length<80)"
								maxSize="80" maxLength="80"
								validate="type:'string',name:'${ctp:i18n('common.description.label')}',notNull:true,maxLength:80,maxSize:80,avoidChar:'\\/|$%&amp;&gt;&lt;&quot;*:?'">${ctp:toHTML(formVO.description)}</textarea>
	                </div>
	            </td>
        	</tr>
		</table>
		