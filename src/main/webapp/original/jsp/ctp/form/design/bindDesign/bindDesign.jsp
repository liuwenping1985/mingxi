<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>form</title>
        <script type="text/javascript" src="${path}/common/form/design/bindDesign/bindDesign.js${ctp:resSuffix()}"></script>
    </head>
    <body class="page_color">
    	<div id='layout'>
	        <div class="layout_center bg_color_white" id="center">
	        <form action="${path }/form/bindDesign.do?method=bindLogsAndCodeSave" id="saveCode" style="height: 80%">
				 <div class="form_area padding_t_5 padding_l_10" id="form">
	                <table border="0" cellspacing="0" cellpadding="0">
	                  <tr>
	                  <%-- 表单名称 --%>
	                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('form.base.formname.label')}:</label></th>
	                    <td width="200"><input readonly="readonly" type="text" id="formTitle" class="w100b" value="${formBean.formName }"/></td>
	                    <%-- 表单编号 --%>
	                    <th nowrap="nowrap"><label class="margin_lr_10" for="text">${ctp:i18n('form.base.formcode.label')}:</label></th>
	                    <td width="200"><input type="text" id="formCode" class="w100b" value="${fn:escapeXml(formBean.bind.formCode) }"/></td>
	                    <td class="padding_l_10"><input type="hidden" id="logsId" name="logsId" value="${logsId }"/><input value="${logs }" type="hidden" id="logs" name="logs" mytype="6" hideText="logsId"/><a class="common_button common_button_gray" href="javascript:void(0)" id="logSet">${ctp:i18n('form.oper.logsettings.label')}</a></td>
	                  	<c:if test="${formBean.formType eq baseInfo}">
							<td nowrap="nowrap">
								<a id="designPhoneView" class="common_button common_button_gray margin_l_10" href="javascript:void(0)"><em class='ico16 ${issetPhone eq true ? "formPhone_16" : "toGray"}'></em>${ctp:i18n('form.query.phoneview.label')}</a>
							</td>
						</c:if>
					  </tr>
	                </table>
	             </div>
	             
	             <!--左右布局-->
				 <div class="layout clearfix code_list padding_t_5 padding_l_10" style="height: 100%">
	            	<div <c:if test="${formBean.formType!=baseInfo }">class="col2 left"</c:if> id="bindSet" class="col2 " style="width:70%;">
	                	<div class="common_txtbox clearfix margin_b_5<c:if test="${formBean.formType==baseInfo }"> hidden </c:if>">
	                	<%-- 绑定设置 --%>
							<label class="margin_r_10 left margin_t_5" for="text">${ctp:i18n('form.bind.set.label')}:</label>
							<%-- 增加 --%>
							<a class="common_button common_button_gray" href="javascript:void(0)" id="newBind">${ctp:i18n('form.trigger.triggerSet.add.label')}</a>
						</div>
						<fieldset class="form_area padding_10" id="editArea">
						<fieldset class="form_area padding_10" id="fieldSetClone">
							<legend>${ctp:i18n('form.pagesign.appbind.label')}</legend>
								<table width="100%" border="0" cellpadding="2" cellspacing="0" id="triggerNameSet">
								    <%-- 基础数据不包含此项 --%>
									<tr height="30px" <c:if test="${formBean.formType==baseInfo }"> class="hidden" </c:if>>
										<td width="30%" align="right" nowrap="nowrap">
										<%-- 应用绑定 --%>
										<label for="text"><font color="red">*</font>${ctp:i18n('form.pagesign.appbindname.label')}：</label></td>
										<td nowrap="nowrap">
										    <div class=" w200" >
										    <input id="bindId" name="bindId" class="w100b" type="hidden">
										    <%--  应用绑定名称 --%>
										    <input readonly="readonly" id="bindName" name="${ctp:i18n('form.pagesign.appbindname.label')}" class="w100b validate" type="text" validate="notNullWithoutTrim:true,type:'string',notNull:true,maxLength:60,avoidChar:'&&quot;&lt;&gt;'">
										    </div>
										</td>
									</tr>
									<tr height="30px" >
										<td width="30%" align="right" nowrap="nowrap">
										<%-- 列表显示项 --%>
										<label for="text"><font color="red"><c:if test="${formBean.formType!=baseInfo }">*</c:if></font>${ctp:i18n('form.query.querylistdatafield.label')}：</label></td>
										<td nowrap="nowrap">
										    <div class=" w200" >
										    <%--  列表显示项 --%>
										    <input readonly="readonly" id="showFieldList" name="${ctp:i18n('form.query.querylistdatafield.label')}" class="w100b validate" type="text" mytype="4" hideText="showFieldNameList" <c:if test="${formBean.formType==baseInfo }">validate="errorMsg:'${ctp:i18n('form.query.querylistdatafield.label')}${ctp:i18n('form.base.notnull.label')}',func:checkShowFieldList"</c:if><c:if test="${formBean.formType!=baseInfo }">validate="errorMsg:'${ctp:i18n('form.query.querylistdatafield.label')}${ctp:i18n('form.base.notnull.label')}',type:'string',notNull:true"</c:if> >
										    <input id="showFieldNameList"  name="showFieldNameList" class="w100b" type="hidden">
										    <%-- 设置 --%>
										    <a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="showFieldListSet">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
										    </div>
										</td>
									</tr>
									<tr height="30px" >
										<td width="30%" align="right" nowrap="nowrap">
										<%-- 排序设置 --%>
										<label for="text"><font color="red"></font>${ctp:i18n('form.query.querysortset.label')}：</label></td>
										<td nowrap="nowrap">
										    <div class=" w200" >
										    <input readonly="readonly" id="orderByList" name="orderByList" class="w100b" type="text" datafiledId="showFieldList" mytype="5" hideText="orderByNameList">
										    <input id="orderByNameList" name="orderByNameList" class="w100b" type="hidden">
										    <%-- 设置 --%>
										    <a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="orderByListSet">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
										    </div>
										</td>
									</tr>
									<%-- 基础数据不包含此项 --%>
									<tr height="30px" <c:if test="${formBean.formType==baseInfo }"> class="hidden" </c:if>>
										<td width="30%" align="right" nowrap="nowrap">
										<%-- 自定义查询项 --%>
										<label for="text"><font color="red"></font>${ctp:i18n('form.query.customfield.label')}：</label></td>
										<td nowrap="nowrap">
										    <div class=" w200" >
										    <input readonly="readonly" id="searchFieldList" name="searchFieldList" class="w100b" type="text" mytype="1" pageFrom="bindDesign" hideText="searchFieldNameList">
										    <input id="searchFieldNameList" name="searchFieldNameList" class="w100b" type="hidden">
										    <%-- 设置 --%>
										    <a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="searchFieldSet">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
										    </div>
										</td>
									</tr>
									<%-- 基础数据不包含此项 --%>
									<tr height="30px" <c:if test="${formBean.formType==baseInfo }"> class="hidden" </c:if>>
										<td width="30%" align="right" nowrap="nowrap">
										<%-- 操作授权 --%>
										<label for="text"><font color="red"></font>${ctp:i18n('form.bind.operauth.label')}：</label></td>
										<td nowrap="nowrap">
										    <div class=" w200" >
										    <input readonly="readonly" id="tempBindAuthName" name="tempBindAuthName" class="comp w200" type="text">
										    <input type="hidden">
										    <%-- 设置 --%>
										    <a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="authSet">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
										    </div>
										</td>
									</tr>
									<%-- 基础数据 包含使用者授权 --%>
									<c:if test="${formBean.formType==baseInfo }">
									<tr height="35px">
									   <%-- 使用者授权 --%>
										<td align="right" width="30%">${ctp:i18n('form.query.useroperauth.label')}：</td>
										<td nowrap="nowrap">
										<div class=" w200" >
										<input type="text" id="authTo_txt" name="authTo_txt" readonly="readonly" class="w100b">
									    <input type="hidden" id="authTo" name="authTo" readonly="readonly" class="comp w200">
									    <%-- 设置 --%>
									    <a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="authSet2">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
									    </div>
										</td>
										</tr>
									</c:if>
									<!-- 允许扫码录入设置 -->
									<tr height="35px">
										<td align="right" width="30%"></td>
										<td nowrap="nowrap">
											<label class="margin_r_10 hand" for="scanCodeInput">
												<input name="scanCodeInput" class="radio_com scanCodeInput" id="scanCodeInput" disabled="disabled" type="checkbox"  value="1">${ctp:i18n("form.barcode.allow.scaninput.label")}</label>
										</td>
									</tr>
									<tr>
									<td colspan="2" class="hidden">
										<table id="authSetTable" width="98%" border="0" cellpadding="0"
											cellspacing="0" height="100%" class="ellipsis">
											<tr height="35px">
											<%-- 操作授权名称 --%>
												<td align="right"><label><font color="red">*</font></label>${ctp:i18n('form.bind.operauthname.label')}：</td>
												<td colspan="2"><input name="authName" type="text"
													id="authName"> <input name="authId" type="hidden"
													id="authId"></td>
												<td width="100">&nbsp;</td>
		  										<td width="70">&nbsp;</td>
											</tr>
								
											<tr height="35px">
											<%-- 新建 --%>
												<td align="right">${ctp:i18n('common.toolbar.new.label')}：</td>
												<td colspan="2"><select id="add" name="add"
													class="input-100">
													<%-- 无 --%>
													<option value="">${ctp:i18n('form.timeData.none.lable')}</option>
													<c:forEach var="formView" items="${formBean.formViewList }">
														<c:forEach var="auth" items="${formView.operations }">
															<c:if test="${auth.type == add }">
																<option value='${formView.id }.${auth.id }'>${formView.formViewName }.${auth.name }</option>
															</c:if>
														</c:forEach>
													</c:forEach>
												</select></td>
												<%-- 显示名称 --%>
												<td align="right">${ctp:i18n("form.bind.showname.label") }：</td>
												<td>
													<input id="addAlias" name="addAlias" type="text" class="validate" validate="type:'string',maxLength:10,minLength:0,isWord:true,avoidChar:'!<>@#$%^&*()'" value=""/>
												</td>
											</tr>
								
											<tr height="35px">
												<td> <input type="text"  id="update" name="update" value=""/></td>
											</tr>
								
											<tr height="35px">
											<%-- 显示 --%>
												<td align="right"><label><font color="red">*</font></label>${ctp:i18n('common.display.show.label')}：</td>
												<td colspan="2">
												<fieldset>
												<table width="100%" border="0" cellpadding="0" cellspacing="0"
													height="100%" class="ellipsis">
													<c:forEach var="formView" items="${formBean.formViewList }"
														varStatus="status">
														<tr>
															<td align="left" width="35%"><input class="browse"
																id="browseCheck${status.index}" type="checkbox"
																name="browseCheck${status.index}" value="${formView.id }" /> <span
																title="${formView.formViewName }">${formView.formViewName }</span></td>
															<td><select id="browseSelect${status.index}"
																name="browseSelect${status.index}" class="input-100">
																<c:forEach var="auth" items="${formView.operations }">
																	<c:if test="${auth.type == browse }">
																		<option value='${formView.id }.${auth.id }'>${auth.name }</option>
																	</c:if>
																</c:forEach>
															</select></td>
														</tr>
													</c:forEach>
												</table>
												</fieldset>
												</td>
												<td></td>
												<td></td>
											</tr>
											<tr height="35px">
											<%-- 其他 --%>
												<td align="right">${ctp:i18n('common.other.label')}：</td>
												<td colspan="2">
												<fieldset>
												<table width="100%" border="0" cellpadding="0" cellspacing="0">
													<tr>
													   <td nowrap="nowrap">
									                    <label for="bathFresh">
									                    <%-- 批量刷新 --%>
									                    <input id="bathupdate" type="hidden" name="bathupdate"  value="">
									                    <input id="bathupdate_txt" type="hidden" name="bathupdate_txt"  value="">
									                    <input id="bathFresh" type="checkbox" name="bathFresh"  value="true">
									                    ${ctp:i18n('form.bind.bath.refresh.label')}
									                    </label>       
									                    </td>
														<td width="20%">
														<%-- 加锁/解锁 --%>
															<label for="allowlock"> 
																<input  id="allowlock" type="checkbox" name="allowlock" value="true">${ctp:i18n('form.bind.lockedAndUnLock.label')}
															</label>
														</td>
														<td width="15%">
														<%-- 删除 --%>
															<label for="allowdelete"> 
																<input id="allowdelete" type="checkbox" name="allowdelete" value="true"> ${ctp:i18n('common.toolbar.delete.label')}
															</label>
														</td>
														<td>
														<%-- 导出 --%>
															<label for="allowexport"> 
																<input id="allowexport" type="checkbox" name="allowexport" value="true"> ${ctp:i18n('form.condition.guideout.label')} 
															</label>
														</td>
                                                        <td>
														<%-- 导入 --%>
															<label for="allowimport">
																<input id="allowimport" type="checkbox" name="allowimport" value="true"> ${ctp:i18n('org.button.imp.label')}
															</label>
														</td>
														<td>
														<%-- 查询 --%>
															<label for="allowquery"> 
																<input id="allowquery" type="checkbox" name="allowquery" value="true"> ${ctp:i18n('form.query.querybutton')} 
															</label>
														</td>
														<td>
														<%-- 统计 --%>
															<label for="allowreport"> 
																<input id="allowreport" type="checkbox" name="allowreport" value="true"> ${ctp:i18n('form.report.statbutton')} 
															</label>
														</td>
														<td>
														<%-- 打印 --%>
															<label for="allowprint"> 
																<input id="allowprint" type="checkbox" name="allowprint" value="true"> ${ctp:i18n('form.print.printbutton')} 
															</label>
														</td>
														<td>
														<%-- 日志 --%>
															<label for="allowlog"> 
																<input id="allowlog" type="checkbox" name="allowlog" value="true"> ${ctp:i18n('form.log.label')} 
															</label>
														</td>
													</tr>
												</table>
												</fieldset>
												</td>
												<td></td>
												<td></td>
											</tr>
                                            <tr height="35px">
                                                <td> <input type="text"  id="customSet" name="customSet" value=""/></td>
                                            </tr>
											<tr height="35px">
											<%-- 操作范围 --%>
												<td align="right">${ctp:i18n('form.query.operrange.label')}：</td>
												<td colspan="2"><span id="spanqueryarea" class="span-style"
													style="width: 262px"> <textarea name="formula"
													id="formula" readonly="readonly"></textarea></span> 
													<%-- 设置 --%>
													<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="buttonarea">${ctp:i18n('form.input.inputtype.oper.label')}</a>
												</td>
												<td></td>
												<td></td>
											</tr>
								            <c:if test="${formBean.formType==2  or formBean.formType==5}">
											<tr height="35px">
											<%-- 使用者授权 --%>
												<td align="right">${ctp:i18n('form.query.useroperauth.label')}：</td>
												<td colspan="2">
												<input type="text" id="authTo" name="authTo" readonly="readonly" >
												<input type="text" id="authTo_txt" name="authTo_txt" readonly="readonly" class="comp w200">
											</tr>
								            </c:if>
										</table>
									</td>
									</tr>
								</table>
							</fieldset>
						<div align="center" id="buttonDiv" <c:if test="${formBean.formType==baseInfo }"> class="hidden" </c:if>>
						    <%--  保存 --%>
							<a class="common_button common_button_disable common_button_gray margin_t_5" href="javascript:void(0)" id="saveBind">${ctp:i18n('form.query.save.label')}</a>
							<%-- 取消 --%>
							<a class="common_button common_button_disable common_button_gray margin_t_5" href="javascript:void(0)" id="cancelSet">${ctp:i18n('common.button.cancel.label')}</a>
						</div>
						<div <c:if test="${formBean.formType==baseInfo }"> class="hidden" </c:if>>
										<label for="text"><font color="green">${ctp:i18n('form.bind.description' )}</font></label>
									</div>
						</fieldset>
	                </div>
	                <div class="col2 margin_l_5 left <c:if test="${formBean.formType==baseInfo }">hidden </c:if>" style="width:29%;height: 100%">
	                	<div class="common_txtbox clearfix margin_b_5">
	                	    <%-- 绑定列表 --%>
							<label class="margin_r_10 left margin_t_5" for="text">${ctp:i18n('form.bind.bindList')}:</label>
							<%-- 修改 --%>
							<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="updateBind">${ctp:i18n('form.oper.update.label')}</a>
							<%-- 删除 --%>
							<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="delBind">${ctp:i18n('form.datamatch.del.label')}</a>
						</div>
						<div  style="height: 100%;">
							<table width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table">
			                    <thead>
			                        <tr>
			                            <th width="1%"><input type="checkbox" onclick="selectAll(this,'bindBody')"/></th>
			                            <%-- 应用绑定 --%>
			                            <th align="center">${ctp:i18n('form.pagesign.appbind.label')}</th>
										<c:if test="${formBean.formType eq 2}">
											<th>${ctp:i18n('form.query.phoneview.label')}</th>
										</c:if>
			                        </tr>
			                    </thead>
			                    <tbody id="bindBody">
			                    	<c:if test="${formBean.bind!=null }">
			                    		<c:forEach var="bindAuth" items="${formBean.bind.unFlowTemplateMap }" varStatus="status">
				                    		<tr class="bindnamelist" class="hand <c:if test="${(status.index % 2) == 1 }">erow</c:if>">
			                            		<td id="selectBox"><input class="bindid" type="checkbox" value="${bindAuth.value.id }"/></td>
			                            		<td class="bindname" onclick="showTemplate(this,'${bindAuth.value.id }')">${bindAuth.value.name }</td>
												<c:if test="${formBean.formType eq 2}">
													<td id="${bindAuth.value.id }"><span view="${bindAuth.value.id }" class='phone ico16 ${empty bindAuth.value.formBindAuthBean4Phone ? "toGray" : "formPhone_16"}'></span></td><!--"formPhone_16" : "toGray"-->
												</c:if>
			                        		</tr>
			                         </c:forEach>
			                    	</c:if>
			                    </tbody>
			                 </table>
						</div>
	                </div>
				</div>
				</form>
	        </div>
		</div>
	</body>
	<%@ include file="../../common/common.js.jsp" %>
	<script type="text/javascript">
		var formType=${formBean.formType};
	$(document).ready(function(){
        new MxtLayout({
            'id': 'layout',
            'centerArea': {
                'id': 'center',
                'border': false
            }
        });
        if(!${formBean.newForm }){
        	parent.ShowBottom({'show':['doSaveAll','doReturn']},$("#saveCode"));
        }else{
            parent.ShowBottom({'show':['upStep','nextStep','finish'],'source':{'upStep':'../report/reportDesign.do?method=index','nextStep':'../form/triggerDesign.do?method=index'}},$("#saveCode"));
        }

        $("#authSet").click(function(){
        	authSetFun($(this));
        });
        
        $("#formCode").change(function(){
          setLogs();
        });
        $("#authSet2").click(function(){
        	authSet2Fun($(this));
        });
        $("#saveBind").click(function(){
        	saveBindFun($(this));
        });
        $("#newBind").click(function(){
        	newBindFun($(this),"${formBean.formName}");
        });
        
        $("#cancelSet").click(function(){
        	cancelSetFun($(this));
        });
        
        $("#showFieldListSet").click(function(){
        	showFieldListSetFun($(this));
        });
        $("#orderByListSet").click(function(){
        	orderByListSetFun($(this));
        });
        $("#searchFieldSet").click(function(){
			searchFieldSetFun($(this));
        });
		$(".phone,#designPhoneView").click(function(){
			layoutConfig4Phone($(this));
		});
        $("#logSet").click(function(){
        	if($(this).hasClass("common_button_disable")){
        		return;
        	}
			var obj = {};
			obj.title = $.i18n("form.forminputchoose.logconfig");
			obj.valueTitle = "${ctp:i18n('form.forminputchoose.logdata')}";
			obj.showSysArea = false;
			obj.height = 520;
			obj.canSort = false;
			var relationValue = {};
			relationValue.value = "logsId";
			obj.relationValue = relationValue;
			obj.callBack = setLogs;
			obj.desc="${ctp:i18n('form.forminputchoose.reasemedetail')}";
			obj.result = {
				value:"logsId",
				display:'logs'
			};
			selectFormField("formLogs",obj);
        });
        $("#updateBind").click(function(){
        	updateBindFun($(this));
        });
        
        $("#delBind").click(function(){
        	delBindFun($(this));
        });
        $(":checkbox","#bindBody").click(function(){
        	bindBodyFun();
        });

		if(formType == ${baseInfo }){//
			var checkedObj = $("input:checkbox","#bindBody");
			initEmptyData();
        	if(checkedObj.length != 0){
            	initAuthData(checkedObj.eq(0).val());
        	}
        	editState();
			$("#showFieldList").focus();
		}
		$("body").data("fieldSetClone",$("#fieldSetClone").clone(true));
	});

	
	function setLogs(result){
	  var formBind = new formBindDesignManager();
	  var obj = {};
	  obj.logsId = $("#logsId").val();
	  obj.formCode = $("#formCode").val();
	  <c:if test="${formBean.formType ne baseInfo }">
	  formBind.saveOrUpdateCodeAndLogs(obj);
	  </c:if>
		return true;
	}
	
function validateFormData(){
	if(!$("#bindName").prop("readonly")&&!$("#bindName").is(":hidden") && ($("#showFieldList").val() != "" || $("#orderByList").val() != ""
			|| $("#searchFieldList").val() != "" || $("#tempBindAuthName").val() != "")){
		$.alert("${ctp:i18n('form.bind.saveBindInfo')}");
    	return false;
	}
	var m = new formBindDesignManager();
	if($.trim($("#formCode").val())!=""){
		var rem = m.checkSameCode("",$("#formCode").val());
		if(rem != "success"){
			$.alert("${ctp:i18n('form.bind.template.number.alert.duple')}");
			return false;
		}
	}
	<c:if test="${formBean.formType  ==  baseInfo }">
	return $("#saveCode").validate({errorAlert:true,errorIcon:false});
	</c:if>
	<c:if test="${formBean.formType != baseInfo }">
	return true;
	</c:if>
}
        function saveFormData(){
            <c:if test="${formBean.formType  ==  baseInfo }">
            var m = new formBindDesignManager();
            m.saveOrUpdateCodeAndLogs($("#saveCode").formobj());
            </c:if>
        }
	</script>
</html>
