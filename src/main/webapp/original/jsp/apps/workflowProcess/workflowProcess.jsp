<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">            
	<head>
	    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	      <style>
			.stadic_head_height{
			    height:30px;
			}
			.stadic_body_top_bottom{
			 bottom: 0px;
			    top: 30px;
			}
		</style>
	</head>
	<body class="page_color" onload="initLoad()">
     <div style="height: 19px; display: none;" id="queryGroupCrumbs" class="bg_color border_b">
     	<div class="comp" comp="type:'breadcrumb',code:'F13_groupWorkflow'"></div>
     </div>
     <div style="height: 19px; display: none;" id="queryUnitCrumbs" class="bg_color border_b">
     	<div class="comp" comp="type:'breadcrumb',code:'F13_unitWorkflow'"></div>
     </div>
	<div id='layout' class="comp bg_color" comp="type:'layout'">
			<div id='layoutNorth' class="layout_north" style="margin-top:2px;overflow: hidden;" layout="height:140,minHeight:100,maxHeight:200,spiretBar:{show:true,type:2,handlerT:function(){layout.setNorth(0);},handlerB:function(){layout.setNorth(140);}},border:false">
			<div id="tabs" class="">
				<div class="border_t" id="qt">
				<form action="#" id="queryConditionForm"  style="margin:0;padding:0; height:105px" method="post" target="main">
					<div class="form_area padding_t_10 padding_b_10"  id="queryCondition">
						<div class='form_area set_search'>
							<table width='92%' border=0 cellpadding=0 cellspacing=0 style='margin-left:60px;' class='common_center'>
								<tbody>
									<tr>
										<td width='50%' vAlign='top' id='type_td' class='padding_lr_10'>
											<table border=0  cellpadding=0 cellspacing=0>
												<tbody>
													<tr>
														 <th nowrap='nowrap'><label class='margin_r_10 th_name'  for='text'>${ctp:i18n("workflowProcess.queryMainHtml.flowType.name")}:</label></th>
														 <td width='200'>
													       <div class='common_selectbox_wrap' >
														       <select id='appType' <c:if test = "${isAdministrator}"> onchange="ProcessAnalysis.changeAppType()"</c:if>>
															       <c:if test="${ctp:hasPlugin('collaboration')}">
															       	<option value='1'>${ctp:i18n('workflowProcess.queryMainHtml.flowType.col')}</option>
															       </c:if>
															       <c:if test="${ctp:hasPlugin('form')}">
															       	<option value='2'>${ctp:i18n('workflowProcess.queryMainHtml.flowType.report')}</option>
															       </c:if>
															       <c:if test="${ctp:hasPlugin('edoc')}">
															       	<option value='4'>${ctp:i18n('workflowProcess.queryMainHtml.flowType.edoc')}</option>
															       </c:if>
														       </select>
													       </div>
													     </td>
													     <tr id='timeAll'>
													     	<th nowrap="nowrap"><label class="margin_r_10 th_name" for="text">${ctp:i18n("workflowProcess.queryMain.textbox.sendTime.name")}:</label></th>
													     	<td width='200' nowrap='nowrap' id='start_time_td'>
													     	<div class='common_txtbox_wrap'>
													     		<input id='start_time' name='${ctp:i18n('workflowProcess.queryMain.textbox.startTime.name')}' value="${defaultBeginDate}" type='text' class='comp mycal validate' validate='notNull:true' readOnly='true' comp='cache:false,type:"calendar",ifFormat:"%Y-%m-%d"'/>
													     	</div></td>
									  	  					<td id='mid'>-</td>
									  	  					<td width='200' nowrap='nowrap'  id='end_time_td'>
									  	  					<div class='common_txtbox_wrap'>
									  	  						<input  id='end_time' name='${ctp:i18n('workflowProcess.queryMain.textbox.endTime.name')}' value="${defaultEndDate }" type='text'readOnly='true' class='comp mycal validate' validate='notNull:true'  comp='cache:false,type:"calendar",ifFormat:"%Y-%m-%d"'/>
									  	  					</div>
									  	  					</td>
													     </tr>
													 </tr>
												</tbody>
											</table>
										</td>
										<c:if test = "${isAdministrator eq true }">
											<td width="50%" class="padding_lr_10" valign="top">
												<table border="0" cellspacing="0" cellpadding="0">
													<tbody>
														<tr>
															<th nowrap="nowrap">
																<label class="margin_r_10 th_name" for="text">${ctp:i18n("workflowProcess.workFlowAnalysis.workFlowStat.businessType")}:</label>
															</th>
														<td nowrap="nowrap" colspan="2">
															<input name="operationType" id="allTemplete" onclick="ProcessAnalysis.changeOperationType()" type="radio" checked="" value="self">${ctp:i18n("workflowProcess.queryMain.reports.self.build") }&nbsp;&nbsp;
															<input name="operationType" id="chooseTemplete" onclick="ProcessAnalysis.changeOperationType()" type="radio" value="template">${ctp:i18n("workflowProcess.queryMain.getTemplate") }
														</td>
														<td>
															<input name="templeteName" onclick="ProcessAnalysis.selectTemplate()" title="" disabled="" id="templeteName" style="width: 100px;" type="text" readonly="" value="${ctp:i18n('workflowProcess.queryMain.reports.click')}">
														</td>
														</tr>
														<tr id="statisticsRange">
															<th nowrap="nowrap">
																<label class="margin_r_10 th_name" for="text">&nbsp;&nbsp;&nbsp;&nbsp;${ctp:i18n("workflowProcess.queryMainHtml.statistics.to")}:</label>
															</th>
															<td nowrap="nowrap"><label for="toDep">
																<input name="statWhat" id="toDep" onclick="ProcessAnalysis.switchIt(this)" type="radio" checked="" value="Account">${ctp:i18n("workflowProcess.workFlowAnalysis.workFlowStat.department")}</label>
																<label for="toPer"><input name="statWhat" id="toPer" onclick="ProcessAnalysis.switchIt(this)" type="radio" value="Member">${ctp:i18n("workflowProcess.authorize.list.personsName") }</label>
																<input name="statWhat" id="statWhat" type="hidden" value="Department">
																<input name="statType" id="statType" type="hidden" value="Department">
															</td>
															<td id="acldem" nowrap="nowrap">&nbsp;&nbsp;${ctp:i18n("workflowProcess.queryMain.AccountDpt") }</td>
															<td width="" align="right" id="perLabel" nowrap="nowrap" style="display: none;">&nbsp;&nbsp;${ctp:i18n("workflowProcess.queryMain.reports.designated.personnel") }</td>
															<td width="60" id="depContent" nowrap="nowrap"><div class="common_txtbox_wrap">
																<input name="department" class="cursor-hand" id="department" style="width: 80px;" onclick="ProcessAnalysis.selectPeopleDA()" type="text" readonly="" value="${ctp:i18n('workflowProcess.queryMain.reports.click') }">
															</div>
															</td>
															<td width="60" id="perContent" nowrap="nowrap" style="display: none;">
																<div class="common_txtbox_wrap">
																	<input name="person" class="cursor-hand" id="person" onclick="ProcessAnalysis.selectPeople()" style="width: 80px;" type="text" readonly="" value="${ctp:i18n('workflowProcess.queryMain.reports.click') }">
																</div>
															</td>
														</tr>
													</tbody>
												</table>
												</td>
										</c:if>
										<c:if test = "${isGroupAdmin eq true }">
											<td width="50%" class="padding_lr_10" valign="top">
												<table border="0" cellspacing="0" cellpadding="0">
													<tbody>
														<tr id="statisticsRange">
															<th nowrap="nowrap">
																<label class="margin_r_10 th_name" for="text">&nbsp;&nbsp;&nbsp;&nbsp;${ctp:i18n("workflowProcess.queryMainHtml.statistics.to") }:</label>
															</th>
															<td nowrap="nowrap"><label for="toAccount">
																<input name="statWhat" id="toAccount" onclick="ProcessAnalysis.switchIt(this)" type="radio" checked="true" value="Account">${ctp:i18n("workflowProcess.queryMain.reports.account") }</label>
															</td>
															<td nowrap="nowrap">
																<label for="toDep">
																	<input name="statWhat" id="toDep" onclick="ProcessAnalysis.switchIt(this)" type="radio" value="Department">${ctp:i18n("workflowProcess.workFlowAnalysis.workFlowStat.department") }</label>
																<label for="toPer">
																<input name="statWhat" id="toPer" onclick="ProcessAnalysis.switchIt(this)" type="radio" value="Member">${ctp:i18n("workflowProcess.authorize.list.personsName") }</label>
																<input name="statWhat" id="statWhat" type="hidden" value="Account">
																<input name="statType" id="statType" type="hidden" value="Account">
															</td>
															<td width="" align="right" id="perLabel" nowrap="nowrap" style="display: none;">&nbsp;&nbsp;${ctp:i18n("workflowProcess.queryMain.reports.designated.personnel") }</td>
															<td width="60" id="depContent" nowrap="nowrap">
																<div class="common_txtbox_wrap">
																	<input name="department" class="cursor-hand" id="department" style="width: 80px;" onclick="ProcessAnalysis.selectPeopleDA()" type="text" readonly="" value="${ctp:i18n('workflowProcess.queryMain.reports.click')}">
																</div>
															</td>
															<td width="60" id="perContent" nowrap="nowrap" style="display: none;">
																<div class="common_txtbox_wrap">
																	<input name="person" class="cursor-hand" id="person" onclick="ProcessAnalysis.selectPeople()" style="width: 80px;" type="text" readonly="" value="${ctp:i18n('workflowProcess.queryMain.reports.click')}">
																</div>
															</td>
														</tr>
													</tbody>
												</table>
											</td>
										</c:if>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="align_center clear padding_lr_5 padding_b_5" id="button_div">
							<a class="common_button common_button_emphasize margin_r_10" id="querySave" onclick="ProcessAnalysis.executeStatistics()" href="javascript:void(0)">${ctp:i18n("workflowProcess.queryMain.button.start") }</a>
							<a class="common_button common_button_gray margin_r_10" id="queryReset" onclick="ProcessAnalysis.rest()" href="javascript:void(0)">${ctp:i18n("workflowProcess.queryMain.button.reset")}</a>
						</div>
						<input type="hidden" id="isAdministrator" value="${isAdministrator }">
			         	<input type="hidden" id="isGroupAdmin" value="${isGroupAdmin }">
			         	<c:if test="${isGroupAdmin}">
	 		         		<input type='hidden' name='statScope' id='statScope' value='group'/>
	 		         	</c:if>
	 		         	<c:if test="${isAdministrator }">
	 		         		<input type='hidden' name='statScope' id='statScope' value='account'/>
	 		         	</c:if> 
						<input type='hidden' name='templeteId' id='templeteId' value='-1'/>
						<input name="departmentIds" id="departmentIds" type="hidden" value="-1"/>
						<input name="personIds" id="personIds" type="hidden" value=""/>
					</div>
	         	</form>
	         	<form action="#" id="resolveExecel">
	         		<div id="execelCondition"></div>
	         	</form>
	         	</div>
         	</div>
         	
        </div>
       		<div class="layout_center stadic_layout margin_l_5" layout="border:true" style='overflow-y:hidden'>
		
		    <div class=" padding_lr_10  set_search align_left" id="oper">
		        <table>
		            <tr>
		                <td>
		                	<span class="left">${ctp:i18n('workflowProcess.queryMain.result')}：
							<a class="img-button margin_r_5" href="javascript:void(0)" id="reportToExcel" onclick="ProcessAnalysis.reportToExcel()"><em class="ico16 export_excel_16"></em>${ctp:i18n('workflowProcess.queryMain.tools.reportToExcel')}</a> 
							<a class="img-button margin_r_5" href="javascript:void(0)" id="printReport" onclick="ProcessAnalysis.printReport()"><em class="ico16 print_16"></em>${ctp:i18n('workflowProcess.queryMain.tools.printReport')}</a> 
							</span>
						</td>
					</tr>
				</table>
			</div>
			<div class="stadic_layout_body stadic_body_top_bottom" id="reportResult">
				<div id="tabs" name="tabs" class="stadic_layout" style="*position:absolute;height:90%;width:100%">
					<ul id="queryResult" class="align_center border_tb common_tabs_body stadic_body_top_bottom stadic_layout_body" style="position:absolute;width:100%;top:25px;bottom:65px;background:#fff;">
					</ul>
					<div id='resultComp' style="bottom:35px;" class=" align_right stadic_layout_footer stadic_footer_height">
    			  		<table border='0' width="100%">
    			  			<tr style='height: 20px;' id='result'>
    			  			</tr>
    			  		</table>
    			  		<hr style='margin-bottom:15px;' id="proHr">
    			  	</div>
		            <!-- 奇怪啊，分页组件居然会造成内存泄漏 -->
					<div class="common_over_page align_right stadic_layout_footer stadic_footer_height" id="pageContent">
						${ctp:i18n('workflowProcess.queryMain.page.eachPage')}<input class="common_over_page_txtbox" type="text" value="20" id="pageSize">
						<span id="totleItem">${ctp:i18n_1('workflowProcess.queryMain_js.unitTotal',0) }</span>
						<a title="${ctp:i18n('workflowProcess.queryMain.page.firstPage')}" onclick="ProcessAnalysis.firstPage()" class="common_over_page_btn" href="#" id="firstPage"><em class="pageFirst"></em></a>
						<a title="${ctp:i18n('workflowProcess.queryMain.page.up')}" onclick="ProcessAnalysis.prevPage()" class="common_over_page_btn" href="#" id="prevPage"><em class="pagePrev"></em></a>
						<span>${ctp:i18n('workflowProcess.queryMain.page.the')}</span>
						<input class="common_over_page_txtbox" type="text" value="1" id="pageNo"><span id="totlePage">${ctp:i18n_1('workflowProcess.queryMain_js.pageTotal',1)}</span>
						<a title="${ctp:i18n('workflowProcess.queryMain.page.down')}" onclick="ProcessAnalysis.nextPage()" class="common_over_page_btn" href="#" id="nextPage"><em class="pageNext"></em></a>
						<a title="${ctp:i18n('workflowProcess.queryMain.page.lastPage')}" onclick="ProcessAnalysis.lastPage()" class="common_over_page_btn" href="#" id="lastPage"><em class="pageLast"></em></a>
						<a id="grid_go" class="common_button common_button_gray margin_r_10" onclick="ProcessAnalysis.grid_go()" href="javascript:void(0)">go</a>
					</div>
				</div>
			</div>
		</div>
	</body> 
	<%@ include file="/WEB-INF/jsp/common/template/template.js.jsp" %>
	<script type="text/javascript" src="${path}/apps_res/workflowProcess/js/workflowProcess.js${ctp:resSuffix()}"></script>
</html>