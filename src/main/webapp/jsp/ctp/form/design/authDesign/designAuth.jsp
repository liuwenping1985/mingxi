<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>form</title>
		<script type="text/javascript" src="${path}/ajax.do?managerName=formAuthDesignManager"></script>
    </head>
    <body class="page_color">
    	<div id='layout'>
	        <div class="layout_center bg_color_white" id="center">
	        <form action="${path}/form/authDesign.do?method=formDesignSaveAuth" id="saveForm" style="height: 100%">
				 <div class="form_area padding_t_5 padding_l_10" id="form">
				 <div id="eventBindDiv" style="display: none">
                 </div>
                 <div id="eventBindTableDiv" style="display: none">
                 </div>
	                <table border="0" cellspacing="0" cellpadding="0">
	                  <tr>
	                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('form.base.formname.label')}:</label></th>
	                    <td width="200"><input readonly="readonly" type="text" id="formTitle" class="w100b padding_l_5"/></td>
						<th nowrap="nowrap"><label class="margin_l_10 margin_r_10" for="text">${ctp:i18n('form.base.billname.label')}:</label></th>
	                    <td width="200"><select class="w100b" id="viewId">
	                    <c:forEach var="formView" items="${formBean.formViewList }" varStatus="status">
	                     	<option value="${formView.id }">${formView.formViewName }</option>
	                    </c:forEach>
	                    </select></td>
                          <!-- infopath表单才显示移动设计器-->
                          <c:if test="${formBean.formType ne 4  and formBean.infoPathForm}">
                              <td nowrap="nowrap">
                                  <a id="designPhoneView" class="common_button common_button_gray margin_l_10" href="javascript:void(0)"><em class='ico16  ${viewBean.settedPhoneView ? "formPhone_16" : "toGray"}'></em>${ctp:i18n('form.query.phoneview.label')}</a>
                              </td>
                          </c:if>
	                  </tr>
	                </table>
	             </div>
	             <!--左右布局-->
				 <div class="layout clearfix code_list padding_l_10 margin_t_10" style="height: 80%">
	            	<div class="col2" id="authField" style="float: left;width:54%;height: 100%">
	                	<div class="common_txtbox clearfix margin_b_5">
							<label class="margin_r_10 left margin_t_5" for="text">${ctp:i18n('form.oper.formoperflag.label')}:</label>
							<a class="common_button common_button_gray" href="javascript:void(0)" id="newAuth">${ctp:i18n('form.trigger.triggerSet.add.label')}</a>
						</div>
						<fieldset class="form_area padding_10" id="authFieldMap" style="height: 90%">
							<!-- 权限设置 -->
							<legend>${ctp:i18n('form.oper.operitemflag.label')}</legend>
							<div style="height: 90%;margin-bottom: 5px;">
								<div  id="authFieldTable" style="height: 90%;margin-bottom: 26px">
								<table border="0" cellspacing="0" cellpadding="0" width="100%">
				                  <tr>
				                  	<!-- 操作权限名称 -->
				                    <td nowrap="nowrap" align="right"><label class="margin_r_10" for="text">${ctp:i18n('form.oper.opername.label')}:</label></td>
				                    <td colspan="5" nowrap="nowrap" width="210">
				                    <div class="common_txtbox_wrap w200" id="authTitle_wap" style="float:left">
					                    <input type="hidden" id="authId" name="authId" value="0"/>
					                    <input type="hidden" id="defaultAuth" name="defaultAuth" value="false"/>
                                        <input type="hidden" id="advanceAuthType" name="advanceAuthType" value="-1"/>
					                    <!-- 操作权限名称 -->
					                    <input type="text" id="authTitle" name="${ctp:i18n('form.oper.opername.label')}" disabled="disabled" displayName="操作权限名称" class="validate" validate="notNullWithoutTrim:true,type:'string',notNull:true"/>
				                    </div>
				                    </td>
				                    <!-- 高级设置 -->
				                    <td align="left" clospan="2">
				                    	<div class="common_checkbox_box clearfix ">
				                    	<label for="conditionCkb" class="margin_r_5 hand">
				                    	<input type="checkbox" value="0" id="conditionCkb" name="conditionAuthSet" disabled="disabled" class="radio_com">${ctp:i18n('form.authdesign.highfieldauth.title.label')}</label>
				                    	</div>
				                    </td>
                                  </tr>
				                  <tr>
				                  	<!-- 操作类型 -->
									<th nowrap="nowrap" align="right"><label class="margin_l_10 margin_r_10" for="text">${ctp:i18n('form.log.operationtype')}:</label></th>
				                    <td colspan="5"><div class="common_selectbox_wrap w200" style="float:left;width:210px">
				                    <input type="hidden" id="authTypeValue" name="authTypeValue" value="0"/>
				                    <select class="w200" id="authType" disabled="disabled">
				                    	<option value="0"> </option>
	                                   <c:forEach var="authType" items="${formAuthorizationType }" varStatus="status">
	                     	             <option value="${authType.key}">${authType.i18nStr }</option>
	                                   </c:forEach>
	                                </select>
				                    </div></td>
				                    <td class="padding_l_5" colspan="2">
				                    <input type="hidden" id=highAuths name="highAuths" value=""/>
				                    <div class="common_radio_box clearfix" id="advanceAuthSetDiv" style="display:none;">
				                    <label for="radio5" class="margin_t_5 hand display_block">
				                    <input type="radio" value="0" id="radio5" name="advanceSetAuthOption" class="radio_com">${ctp:i18n('form.authdesign.highfieldauth.uniformset.label')}&nbsp;<span name="highAuthDesign" id="highAuthDesign">[<font color="#296fbe">${ctp:i18n('form.authdesign.highfieldauth.condition.label')}</font>]</span><span id="advanceIcon" style="display: none;" class="ico16 gone_through_16"></span></label>
				                    <label for="radio6" class="margin_t_5 hand display_block">
				                    <input type="radio" value="1" id="radio6" name="advanceSetAuthOption" class="radio_com">${ctp:i18n('form.authdesign.highfieldauth.setapart.label')}</label>
				                    </div>
				                    </td>
				                  </tr>
								  <tr id="selectAllAccess" disabled="disabled" >
								  	<td height="35" nowrap="nowrap" ><LABEL for=name>&nbsp;</LABEL></td>
								  	<!-- 浏览 -->
									<td align="center" nowrap="nowrap" width="10%">[<A href="javascript:void(0)" name="chobrowse" id="${browse }">${ctp:i18n('form.oper.browse.label')}</A>]</TD>
									<!-- 编辑 -->
									<td align="center" nowrap="nowrap" width="10%">[<A href="javascript:void(0)" name="choedit" id="${edit }">${ctp:i18n('form.authDesign.edit')}</A>]</TD>
									<!-- 隐藏 -->
									<td align="center" nowrap="nowrap" width="10%">[<A href="javascript:void(0)" name="chohide" id="${hide }">${ctp:i18n('form.authDesign.hide')}</A>]</TD>
									<!-- 追加 -->
									<td align="center" nowrap="nowrap" width="10%">[<A href="javascript:void(0)" name="choappand" id="${add }">${ctp:i18n('form.oper.superaddition.label')}</A>]</TD>
									<!-- 必填 -->
									<td align="center" nowrap="nowrap" width="10%">[<A href="javascript:void(0)" name="" id="notNull">${ctp:i18n('form.authDesign.mustinput')}</A>]</TD>
									<!-- 初始值设置 -->
									<td align="left" nowrap="nowrap" width="17%">[<A name="initvalue" id="initValue">${ctp:i18n('formoper.init.label')}</A>]</TD>
                                    <td aling="center" nowrap="nowrap" id="conFieldAuthColTitle" width="11%"><LABEL>&nbsp;&nbsp;</LABEL></td>
								</tr>
								</table>
								<div id="radioHeight" style="width:100%; overflow:scroll; overflow-x:hidden; margin-bottom:5px;height: 65%">
								<table border="0" cellspacing="0" cellpadding="0" width="100%" style="height: 100%">
								<c:forEach var="field" items="${formBean.allFieldBeans }" varStatus="status">
								<tr id="${field.name }_tr">
                                    <td height="30" style="word-break:break-all;">[<c:if test="${field.masterField}">${ctp:i18n("form.base.mastertable.label")}</c:if><c:if test="${!field.masterField}">${ctp:i18n("formoper.dupform.label")}${field.ownerTableIndex}</c:if>]&nbsp;${field.display}:</td>
									<%-- 如果是关联表单，记录关联类型：1：手动选择；2：系统关联 --%>
									<td align="center" width="10%"><INPUT tableName="${field.ownerTableName }" fieldName="${field.name }" fieldType="${field.inputType}" <c:if test="${field.inputType eq relationForm}">viewSelectType = ${field.formRelation.viewSelectType }</c:if> disabled type="radio" checked="checked" id="${field.name }_access" name="${field.name }_access" value="${browse }"></td>
									<td align="center" width="10%"><INPUT tableName="${field.ownerTableName }" fieldName="${field.name }" fieldType="${field.inputType}" <c:if test="${field.inputType eq relationForm}">viewSelectType = ${field.formRelation.viewSelectType }</c:if> disabled type="radio" id="${field.name }_access" name="${field.name }_access" value="${edit }"></td>
									<td align="center" width="10%"><INPUT tableName="${field.ownerTableName }" fieldName="${field.name }" fieldType="${field.inputType}" <c:if test="${field.inputType eq relationForm}">viewSelectType = ${field.formRelation.viewSelectType }</c:if> disabled type="radio" id="${field.name }_access" name="${field.name }_access" value="${hide }"></td>
									<td align="center" width="10%">
										<c:if test="${field.inputType eq textarea || field.inputType eq flowDealOption}">
											<INPUT tableName="${field.ownerTableName }" fieldName="${field.name }" disabled type="radio" fieldType="${field.inputType}" <c:if test="${field.inputType eq relationForm}">viewSelectType = ${field.formRelation.viewSelectType }</c:if> id="${field.name }_access" name="${field.name }_access" value="${add }">
										</c:if>
									</td>
									<td align="center" width="10%"><INPUT disabled fieldType="${field.inputType}" <c:if test="${field.inputType eq relationForm}">viewSelectType = ${field.formRelation.viewSelectType }</c:if> type="checkbox" id="${field.name }_notNull"  value="${isNotNull }"/> </td>
									<td align="center" width="17%">
									<INPUT type="hidden" id="${field.name }_allowModify" value="false"/>
									<INPUT type="hidden" id="${field.name }_defaultValueType"/>
									<INPUT type="hidden" id="${field.name }_defaultValue"/>
									<INPUT type="hidden" id="${field.name }_display"/>
									<INPUT type="hidden" id="${field.name }_displayType"/>
									<INPUT type="hidden" id="${field.name }_isInitNull"/>
									<INPUT readOnly disabled id="${field.name }_showName" fieldType="${field.inputType}" <c:if test="${field.inputType eq relationForm}">viewSelectType = ${field.formRelation.viewSelectType }</c:if> attrType="def" fieldName="${field.name }" tablename="${field.ownerTableName}" style="width: 90%"/>
                                    </td>
                                    <td name="conFieldAuthTD" tablename="${field.ownerTableName}" fieldType="${field.inputType}" width="11%">
                                    	<div id="colFieldAuthDiv" style="display:none;width:100%;height:15px;">
                                        [<A name="${field.name}_conditionAuth" id="${field.name}_conditionAuth" fieldName="${field.name}" attrType="conditionFieldSet">${ctp:i18n('form.authdesign.highfieldauth.condition.label')}</A>]
                                        <input type="hidden" id="${field.name}_fieldHighAuths" value="" /><span id="${field.name}_selIcon" style="display: none;" class="ico16 gone_through_16"></span>
                                        </div>
                                    </td>
								</tr>
								</c:forEach>
								<c:if test="${!empty formBean.templateFileId}">
									<tr id="templateFile_tr">
										<td height="30" style="word-break:break-all;">[${ctp:i18n("form.system.field.flowcontent.label")}]&nbsp;${ctp:i18n("form.auth.field.content.lable")}:</td>
										<td align="center" width="10%"><INPUT  disabled type="radio" checked="checked" id="templateFile_access" name="templateFile_access" value="${browse }"></td>
										<td align="center" width="10%"><INPUT  disabled type="radio" id="templateFile_access" name="templateFile_access" value="${edit }"></td>
										<td align="center" width="10%"><INPUT  disabled type="radio" id="templateFile_access" name="templateFile_access" value="${hide }"></td>
									</tr>
								</c:if>
				                </table>
								<table id="groupShow" width="0px" height="0px" border="0" cellpadding="0" style="display:none"
									cellspacing="0">
									<tr>
										<td>
										<fieldset style="width: 90%;" align="center">
										<!-- 重复表操作 -->
										<legend align="center" style="color: blue;">${ctp:i18n('form.operhigh.repeatedform.label')}：</legend>
                                            <div class="scrollList" style="text-align: center" width="90%" >
                                            <table id="groupEdit" style="display: inline" width="90%" border="0"
                                                cellspacing="0" cellpadding="0" align="center">
                                                <c:forEach var="table" items="${formBean.tableList }" begin="1">
                                                    <tr tableName="${table.tableName }" isCollectTable="${table.isCollectTable}">
                                                        <td class="bg-gray" width="37%" nowrap="nowrap" id="${table.display }" title="${ctp:i18n("formoper.dupform.label")}${table.tableIndex}">[${ctp:i18n("formoper.dupform.label")}${table.tableIndex}]</td>
                                                        <td width="124px" nowrap="nowrap"><label for="${table.display }_allowAdd">
                                                            <!-- 允许添加 -->
                                                            <input tableName="${table.tableName }" type="checkbox" name="${table.display }_allowAdd" id="${table.display }_allowAdd" value="true" isCollectTable="${table.isCollectTable}" />${ctp:i18n('form.authDesign.allowadd')}</label>
                                                        </td>
                                                        <td width="31%" nowrap="nowrap">
                                                            <label for="${table.display }_allowDelete">
                                                                <!-- 允许删除 -->
                                                                <input tableName="${table.tableName }" type="checkbox" value="true" name="${table.display }_allowDelete" id="${table.display }_allowDelete" isCollectTable="${table.isCollectTable}" />${ctp:i18n('form.operhigh.allowdel.label')}
                                                            </label>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </table>
                                            </div>
										</fieldset>
										</td>
									</tr>
								</table>
								</div>
								</div>
							<div align="center" style="height: 20px;min-height: 20px;">
							<!-- 重复表操作 -->
							<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="groupAuth">${ctp:i18n('form.operhigh.repeatedform.label')}</a>
							<!-- 开发高级 -->
							<c:if test="${formBean.formType eq 1}">
								<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="developmentadv">${ctp:i18n('formoper.empolderhigh.label')}</a>
							</c:if>
							<!-- 保存 -->
							<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="saveAuth">${ctp:i18n('form.query.save.label')}</a>
							</div>
				           	</div>
							
						</fieldset>
	                </div>
	                <div class="col2 margin_l_5" style="float: left;width:44%">
	                	<div class="common_txtbox clearfix margin_b_5">
	                		<!-- 操作权限 -->
							<label class="margin_r_10 left margin_t_5" for="text">${ctp:i18n('form.oper.formoperflag.label')}:</label>
							<!-- 修改 -->
							<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="updateAuth">${ctp:i18n('form.oper.update.label')}</a>
							<!-- 删除 -->
							<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="delAuth">${ctp:i18n('form.datamatch.del.label')}</a>
						</div>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table edit_table">
		                    <thead>
		                        <tr>
		                            <th width="1%"><input type="checkbox" onclick="selectAll(this)"/></th>
		                            <!-- 操作权限名称 -->
		                            <th>${ctp:i18n('form.oper.opername.label')}</th>
		                            <!-- 操作类型 -->
		                            <th>${ctp:i18n('form.oper.opertype.label')}</th> 
		                            <!-- 类别 -->
									<th>${ctp:i18n('form.baseinfo.sort')}</th>
                                    <c:if test="${formBean.formType ne 4  and formBean.infoPathForm}">
                                        <th>${ctp:i18n('form.query.phoneview.label')}</th>
                                    </c:if>
		                        </tr>
		                    </thead>
		                    <tbody id="authBody" isNewCode='1'>
			                    	<c:forEach var="auth" items="${authList }" varStatus="status" >
			                    			<c:choose>
		                            		<c:when test="${auth.defaultAuth}"><c:set var="authSysType" value="sys"></c:set></c:when>
		                            		<c:otherwise><c:set var="authSysType" value="user"></c:set></c:otherwise>
		                            		</c:choose>
			                    		<tr class="hand <c:if test="${(status.index % 2) == 1 }">erow</c:if>">
		                            		<td id="selectBox"><input id="authBox" type="checkbox" ${formBean.formType eq 3 and status.index ==1 ? "disabled=true" : "" } authSysType="${authSysType }"  value="${auth.id }" authName="${auth.name}"/></td>
		                            		<td id="${auth.id }">${auth.name }</td>
		                            		<td id="${auth.id }">${auth.extraMap.typeName }</td>
		                            		<td id="${auth.id }">${auth.extraMap.sysName }</td>
                                            <c:if test="${formBean.formType ne 4  and formBean.infoPathForm}">
                                                <td id="${auth.id }">
                                                    <c:if test="${!(formBean.formType eq 3 and auth.type eq 'update')}">
                                                        <span view="${auth.id }" class='phone ico16 ${auth.settedPhoneView ? "formPhone_16" : "toGray"}'></span>
                                                    </c:if>
                                                </td>
                                            </c:if>
		                        		</tr>
			                    	</c:forEach>
		                    </tbody>
		                 </table>
	                </div>
				</div>
				</form>
	        </div>
		</div>
		<%@ include file="designAuth.js.jsp" %>
    </body>
</html>
