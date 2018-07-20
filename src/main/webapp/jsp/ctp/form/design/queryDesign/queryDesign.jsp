<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>form</title>
        <script type="text/javascript" src="${path}/ajax.do?managerName=formQueryDesignManager"></script>
        <script type="text/javascript" src="${path}/common/form/design/queryDesign/queryDesign.js${ctp:resSuffix()}"></script>
    </head>
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
				 <div class="form_area padding_t_5 padding_l_10" id="form">
	                <table border="0" cellspacing="0" cellpadding="0">
	                  <tr>
	                    <th nowrap="nowrap"><label class="margin_r_10" for="text">
							<c:if test="${formBean.govDocFormType !=5 &&formBean.govDocFormType !=6 && formBean.govDocFormType !=7}">
								${ctp:i18n("form.base.formname.label")}：
							</c:if>
							<c:if test="${formBean.govDocFormType ==5 ||formBean.govDocFormType ==6 || formBean.govDocFormType ==7}">
								${ctp:i18n("form.base.edocformname.label")}：
							</c:if>
							<input type="hidden" id="govDocFormType" value="${formBean.govDocFormType}">
						</label></th><!-- 表单名称的国际化 -->
	                    <td width="200">
	                    <DIV class=common_txtbox_wrap><input readonly="readonly" type="text" id="formTitle" value="${formBean.formName }"/></DIV><!-- 表单名称 -->
	                    </td>
	                  </tr>
	                </table>
	             </div>
	             
	             <!--左右布局-->
				 <div class="layout clearfix code_list padding_t_5 padding_l_10">
	            	<div <c:if test="${formBean.formType!=baseInfo }">class="col2"</c:if> id="querySet" style="float: left">
	                	<div class="common_txtbox clearfix margin_b_5<c:if test="${formBean.formType==baseInfo }"> hidden </c:if>">
							<label class="margin_r_10 left margin_t_5" for="text">${ctp:i18n('form.formquery.query.label')}:</label>
							<c:if test="${formBean.formType==1}">
							<select id="newqueryType">
							    <option value="0">
									<c:if test="${formBean.govDocFormType !=5 &&formBean.govDocFormType !=6 && formBean.govDocFormType !=7}">
										${ctp:i18n('form.query.querySet.dataQuery')}
									</c:if>
									<c:if test="${formBean.govDocFormType ==5 ||formBean.govDocFormType ==6 || formBean.govDocFormType ==7}">
										${ctp:i18n("edocform.query.querySet.dataQuery")}
									</c:if>
								</option>
							    <option value="1">${ctp:i18n('form.query.querySet.flowQuery')}</option>
							</select>
							</c:if>
							<a class="common_button common_button_gray" href="javascript:void(0)" id="newquery">${ctp:i18n('form.trigger.triggerSet.add.label')}</a>
						</div>
						<form action="${path }/form/queryDesign.do?method=querySave" id="saveForm">
						<fieldset class="form_area padding_10" id="queryFieldSet">
							<legend>${ctp:i18n('form.query.querydefine.label')}</legend>
								<table width="100%" border="0" cellpadding="2" cellspacing="0" id="">
									<tr height="30px" <c:if test="${formBean.formType==baseInfo }"> class="hidden" </c:if>>
										<td width="30%" align="right" nowrap="nowrap">
											<!-- 查询模板名称 -->
											<label for="text"><font color="red">*</font>${ctp:i18n('form.query.queryname.label')}：</label>
										</td>
										<td nowrap="nowrap">
										     <div class=common_txtbox_wrap>
										    <input id="queryId" name="queryId" class="w100b" type="hidden">
										    <input id="type" name="type" class="w100b" type="hidden" value=""/>
										    <input readonly="readonly" disabled="disabled" id="queryName" name="queryName" class="w100b validate" type="text" validate="name:'${ctp:i18n('form.query.queryname.label')}',type:'string',notNull:true,notNullWithoutTrim:true,avoidChar:'\&#39;&quot;&lt;&gt;'">
										    </div>
										</td>
										<td width="20%">
										</td>
									</tr>
									<tr height="30px" >
										<td width="30%" align="right" nowrap="nowrap">
											<!-- 输出数据项 -->
											<label for="text"><font color="red">*</font>${ctp:i18n('form.query.querydatafield.label')}：</label>
										</td>
										<td nowrap="nowrap">
										     <div class=common_txtbox_wrap>
										    <input readonly="readonly" disabled="disabled" id="showFieldList" name="showFieldList" class="w100b validate" type="text" mytype="4" hideText="showFieldNameList" validate="name:'${ctp:i18n('form.query.querydatafield.label')}',type:'string',notNull:true">
										    <input id="showFieldNameList" name="showFieldNameList" class="w100b" type="hidden">
										    </div>
										</td>
										<td align="left">
											<!-- 设置 -->
											<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="showFieldListSet">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
										</td>
									</tr>
									<tr height="30px" >
										<td width="30%" align="right" nowrap="nowrap">
											<!-- 排序设置 -->
											<label for="text"><font color="red"></font>${ctp:i18n('form.query.queryresultsort.label')}：</label>
										</td>
										<td nowrap="nowrap">
										     <div class=common_txtbox_wrap>
										    <input readonly="readonly" disabled="disabled" id="orderByList" name="orderByList" class="w100b" type="text" datafiledId="showFieldList" mytype="5" hideText="orderByNameList">
										    <input id="orderByNameList" name="orderByNameList" class="w100b" type="hidden">
										    </div>
										</td>
										<td align="left">
										 <a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="orderByListSet">
										 	${ctp:i18n('form.trigger.triggerSet.set.label')} <!-- 设置 -->
										 </a>
										</td>
									</tr>
									<tr height="30px" >
										<td width="30%" align="right" nowrap="nowrap">
											<!-- 系统查询条件 -->
											<label for="text"><font color="red"></font>${ctp:i18n('form.query.querydatarange.label')}：</label>
										</td>
										<td>
										     <div class="common_txtbox  clearfix">
										     <input type="hidden" id="systemConditionId">
										    <textarea readonly="readonly" disabled="disabled" id="systemCondition" name="systemCondition" class="w100b"></textarea>
										    </div>
										</td>
										<td align="left">
											<!-- 设置 -->
										    <a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="systemConditionSet">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
										</td>
									</tr>
									<tr height="5px" >
										<td colspan="3" height="5px" style="font-size: 3px;">&nbsp;</td>
									</tr>
									<tr height="30px" id="userConditionTr">
										<td width="30%" align="right" nowrap="nowrap">
											<!-- 用户输入条件 -->
											<label for="text"><font color="red"></font>${ctp:i18n('form.query.inputcondition.label')}：</label>
										</td>
										<td>
										    <div class="common_txtbox  clearfix">
										     <input type="hidden" id="userConditionId">
										     <textarea readonly="readonly" disabled="disabled" id="userCondition" name="userCondition" class="w100b"></textarea>
										    </div>
										</td>
										<td align="left" nowrap="nowrap">
											<!-- 设置 -->
										    <a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="userConditionSet">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
										    <!-- 条件控制 -->
										    <a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="userFieldSet">${ctp:i18n('form.query.querySet.conditionField')}
										    <input type="hidden" id="userFields"></a>
										</td>
									</tr>
									
									<tr height="30px" <c:if test="${formBean.formType==baseInfo }"> class="hidden" </c:if> id="customfieldTr">
										<td width="30%" align="right" nowrap="nowrap">
											<!-- 自定义查询项 -->
											<label for="text"><font color="red"></font>${ctp:i18n('form.query.customfield.label')}：</label>
										</td>
										<td nowrap="nowrap">
										    <div class=common_txtbox_wrap>
										    <input readonly="readonly" disabled="disabled" id="searchFieldList" name="searchFieldList" class="w100b" type="text" mytype="1" hideText="searchFieldNameList">
										    <input id="searchFieldNameList" name="searchFieldNameList" class="w100b" type="hidden">
										    </div>
										</td>
										<td align="left">
											<!-- 设置 -->
										    <a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="searchFieldSet">${ctp:i18n('form.trigger.triggerSet.set.label')}</a>
										</td>
									</tr>
									<tr height="30px" >
										<td width="30%" align="right" nowrap="nowrap" valign="top" class="padding_t_5">
											<!-- 穿透显示设置 -->
											<label for="text"><font color="red"></font>${ctp:i18n('form.query.showdetailset.label')}：</label>
										</td>
										<td>
										    	<div class="common_radio_box clearfix">
										    	<!-- 允许穿透 -->
										    	<label for="gent1" class="margin_r_10 hand"><input class=radio_com disabled="disabled" type="radio" id="gent1" name="gent" value="1" checked="checked"/>${ctp:i18n('form.query.allowpenetrate.label')}</label>
										    	<!-- 不允许穿透 -->
										    	<label for="gent2" class="margin_r_10 hand"><input class=radio_com disabled="disabled" readonly="readonly" type="radio" id="gent2" name="gent" value="0"/>${ctp:i18n('form.query.notallowpenetrate.label')}</label>
										    	</div>
										    	<table style="width:100%" id="viewShow">
										    		<c:forEach var="view" items="${formBean.formViewList }" varStatus="status">
										    		<tr><td><label for="view${status.index }"><input disabled="disabled" type="checkbox" id="view${status.index }" value="${view.id }" checked="checked"/>${view.formViewName }</label></td>
										    		<td>
										    		<DIV class=common_selectbox_wrap>
										    			<select disabled="disabled" id="showAuth${status.index }" style="width:100px">
										    				<c:forEach var="auth" items="${view.operations }">
										    					<c:if test="${auth.type eq 'readonly' }">
										    					<option value="${auth.id }">${auth.name }</option>
										    					</c:if>
										    				</c:forEach>
										    			</select>
										    			</DIV>
										    		</td></tr>
										    		</c:forEach>
													<c:if test="${formBean.govDocFormType==5||formBean.govDocFormType==6||formBean.govDocFormType==7}">
													<tr><td><label><input id="zhengwencheck" disabled="disabled" type="checkbox" checked="checked"/>正文</label></td>
														<td>
															<DIV class=common_selectbox_wrap>
																<select disabled="disabled" id="showAuth${status.index }" style="width:100px">
																			<option>显示</option>
																</select>
															</DIV>
														</td></tr>
													</c:if>
										    	</table>
										</td>
									</tr>

									<%--只查询当前流程--%>
									<tr height="30px">
										<td width="30%" align="right" nowrap="nowrap" valign="top" class="padding_t_5">
											<label for=""><font color="red"></font>${ctp:i18n('form.query.datarange.label')}：</label>
										</td>
										<td>
											<div class="common_radio_box clearfix">
												<!-- 是 -->
												<label for="queryRange1" class="margin_r_10 hand"><input class=radio_com disabled="disabled" type="radio" id="queryRange1" name="queryRange" value="1" checked />${ctp:i18n('systemswitch.yes.lable')}</label>
												<!-- 否 -->
												<label for="queryRange2" class="margin_r_10 hand"><input class=radio_com disabled="disabled" readonly="readonly" type="radio" id="queryRange2" name="queryRange" value="0" />${ctp:i18n('systemswitch.no.lable')}</label>
											</div>
										</td>
									</tr>

									<tr height="30px" >
										<td width="30%" align="right" nowrap="nowrap">
											<!-- 描述 -->
											<label for="text"><font color="red"></font>${ctp:i18n('form.trigger.triggerSet.description.label')}：</label>
										</td>
										<td>
										     <div class="common_txtbox  clearfix">
										    <textarea readonly="readonly" disabled="disabled" id="description" name="description" class="w100b margin_tb_5"></textarea>
										    </div>
										</td>
									</tr>
								</table>
						<div align="center" id="buttonDiv" class="margin_t_5">
						<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="saveQuery">${ctp:i18n('form.query.save.label')}</a><!-- 确定 -->
							<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="reset">${ctp:i18n('common.button.reset.label')}</a><!-- 重置 -->
						</div>
						</fieldset>
						</form>
	                </div>
	                <div class="col2 margin_l_5" style="float: left">
	                	<div class="common_txtbox clearfix margin_b_5">
	                		<!-- 查询列表 -->
							<label class="margin_r_10 left margin_t_5" for="text">${ctp:i18n('form.query.querylist.label')}:</label>
							<!-- 修改 -->
							<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="update">${ctp:i18n('form.query.update.label')}</a>
							<!-- 删除 -->
							<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="del">${ctp:i18n('form.datamatch.del.label')}</a>
							<!-- 授权设置 -->
							<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="authSet">${ctp:i18n('form.query.queryauthor.label.set')}</a>
							<form action="${path }/form/queryDesign.do?method=queryAuthSave" id="saveAuthForm">
							<input id="selectedQueryId" type="hidden">
							<input id="authTo" type="hidden">
							</form>
						</div>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table edit_table">
		                    <thead>
		                        <tr>
		                            <th width="30"><input type="checkbox" onclick="selectAll(this,'queryBody');"/></th>
		                            <!-- 查询模板名称 -->
		                            <th align="center" width="50%">${ctp:i18n('form.query.queryname.label')}</th>
		                            <!-- 查询授权 -->
		                            <th align="center" width="30%">${ctp:i18n('form.query.queryauthor.label')}</th>
		                            <th align="center" width="20%">修改时间</th>
		                        </tr>
		                    </thead>
		                    <tbody id="queryBody">
		                    	<c:forEach var="query" items="${formBean.formQueryList }" varStatus="status">
			                    		<tr class=" hand <c:if test="${(status.index % 2) == 1 }">erow</c:if> ">
		                            		<td id="selectBox"><input type="checkbox" value="${query.id }"  queryType="${query.type}" onclick="setInitState();initShowTitle();initShowTable();"/></td>
		                            		<td queryId="${query.id }" onclick="showQuery(this);" title="${query.name }">${v3x:getLimitLengthString(query.name, 32, '...')}
		                            		<c:if test="${query.type eq 1 }"><span class="ico16 flash_16"></span></c:if></td>
		                            		<c:set var="auth" value="${query.moduleAuthStr }"></c:set>
		                            		<td queryId="${query.id }" onclick="showQuery(this);" title="${auth[1] }"><input type="hidden" value="${auth[0] }" id="authCode${query.id }"/>
		                            		<input type="hidden" value="${auth[1] }" id="authName${query.id }"/>
		                            		${v3x:getLimitLengthString(auth[1], 20, '...')}</td>
                                            <td queryId="${query.id }" onclick="showQuery(this);" title="${ctp:getLimitLengthString(query.modifyTime, 16, '')}">${ctp:getLimitLengthString(query.modifyTime, 16, '')}</td>
		                        		</tr>
		                        </c:forEach>
		                    </tbody>
		                 </table>
	                </div>
				</div>
				 <div class="clearfix code_list padding_5">
				<table id="newTable" width="100%" border="0" cellpadding="0"
					cellspacing="0">
					<tr>
						<td width="100%" style="padding-top: 6px;">
							<span style="text-align: left; width: 100%; font-size: 12px;"> 
								<font>${ctp:i18n('form.query.preview.label')}:</font> <!-- 预览 -->
							</span>
						<hr>
						</td>
					</tr>
					<tr>
						<td align="center">
							<span id="outName" style="text-align: center; width: 100%; font-size: 14px;"></span> 
							<span id="con" style="text-align: center; width: 100%; font-size: 12px;"></span>
						</td>
					</tr>
					<tr>
					<td align="center" style="padding-left: 10px;font-size: 12px;">
						<table id="userTable"  align="left" width="100%"></table>
					</td>
					</tr>
					<tr>
					<td id="showTd">
						<table class="flexme1"></table>
					</td>
					</tr>
				</table>
				</div>
            </div>
	       	<div class="layout_south over_hidden" id="south">
					<%@ include file="../bottom.jsp" %>
			</div>
		</div>
	</body>
	<%@ include file="../../common/common.js.jsp" %>
	<script type="text/javascript">
	$(document).ready(function(){
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
                'height': 40,
                'sprit': true,
				'border': false,
				'maxHeight': 40,
                'minHeight': 40
            },
            'centerArea': {
                'id': 'center',
                'border': false
            }
        });
        if(!${formBean.newForm }){
        	new ShowTop({'current':'query','canClick':'true','module':'query'});
        	new ShowBottom({'show':['doSaveAll','doReturn']});
        }else{
        	new ShowTop({'current':'query','canClick':'false','module':'query'});
        	new ShowBottom({'show':['upStep','nextStep','finish'],'source':{'upStep':'../form/authDesign.do?method=formDesignAuth','nextStep':'../report/reportDesign.do?method=index'}});
        }
        
        $("#showFieldListSet").click(function(){
        	showFieldListSetFun($(this));
        });
        
        $("#orderByListSet").click(function(){
        	orderByListSetFun($(this));
        });
        
        $("#searchFieldSet").click(function(){
        	searchFieldSetFun($(this));
        });
        
		$("#newquery").click(function(){
			newQuery("${formBean.formName}");
		});
		$(":radio",$("#queryFieldSet")).click(function(){
			initGentRadio();
		});
		$(":checkbox",$("#queryFieldSet")).click(function(){
			initViewShow();
		});
		$("#queryName").keyup(function(){
			initShowTitle();
		});
		$("#saveQuery").click(function(){
			saveQueryFun($(this));
		});
		
		$("#del").click(function(){
			deleteQueryFun();
		});
		
		$("#update").click(function(){
			updateFun("${formBean.formName}");
		});
		
		$("#systemConditionSet").click(function(){
			if($(this).hasClass("common_button_disable")){
				return;
			}
			var o=new Object();
			o.qsType=$("#newqueryType").val();
			setSysQuery(o);
		});
		
		$("#userConditionSet").click(function(){
            if($(this).hasClass("common_button_disable")){
            	return;
            }
            setUserQuery();
        });
		
		$("#authSet").click(function(){
			authSetFun();
		});
		
		$("#reset").click(function(){
			resetFun($(this),"${formBean.formName}");
		});
		
		$("#userFieldSet").click(function(){
			if($(this).hasClass("common_button_disable")){
				return;
			}
			editUserConditionField("userCondition","query");
		});

		$("#newqueryType").change(function(){
			clickChooseQueryType();
        });
		
		$("#userFields").bind("input propertychange", function() {
			if($("#showFieldList").val() != ""){
				showUserFieldTable();
			}
		});
		//位置放到最后
		$("body").data("queryDefine",$("#queryFieldSet").children().clone(true));
        $("body").data("showTableObject",$("table.flexme1").clone(true));
	});
	
	</script>
</html>
