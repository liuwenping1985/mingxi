<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/ctp/form/formreport/form/common.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/form/dee/design/deeDesign.js.jsp" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <title>form</title>
        <script type="text/javascript" src="${url_ajax_reportDesignManager}"></script>
    </head>
    <body class="page_color" onload="changeVal();"><input type="hidden" name="content" id="content">
    <input type="hidden" name="secondCategory" id="secondCategory" value="${secondCategory}">
    	<div id='layout'>
	        <div class="layout_center bg_color_white" id="center">
				 <div class="form_area padding_t_5 padding_l_10" id="form">
	                <table border="0" cellspacing="0" cellpadding="0">
	                  <tr>
	                    <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('report.reportDesign.reportName')}:</label></th>
	                    <td width="200">
	                    	<DIV class=common_txtbox_wrap><input readonly="readonly" type="text" id="formTitle" value="${formBean.formName }"/></DIV>
	                    </td>
	                  </tr>
	                </table>
	             </div>
	             
	             <!--左右布局-->
				 <div class="layout clearfix code_list padding_t_5 padding_l_10">
                 
                 <!-- 暂勿删除，以后或许有用 -->
<%-- 	            	<div <c:if test="${formBean.formType!=baseInfo }">class="col2"</c:if> id="querySet" style="float: left"> --%>
	                	<div class="common_txtbox clearfix margin_b_5 <c:if test="${formBean.formType==baseInfo }"> hidden </c:if>">
<!-- 							<label class="margin_r_10 left" for="text">条件设置:</label> -->
							<label class="margin_r_10 left margin_t_5" for="text">${ctp:i18n('report.reportDesign.conditionSet')}:</label>
							<a class="common_button common_button_gray" href="javascript:void(0)" id="newquery">${ctp:i18n('report.reportDesign.button.newReport')}</a>
						</div>
                        
                        <div id="querySet" class="col2" style="float: left">
                        <div class="common_txtbox clearfix margin_b_5 hidden">
							<label class="margin_r_10 left margin_t_5" for="text">${ctp:i18n('report.reportDesign.conditionSet')}:</label>
							<select onchange="changeVal();" id="statisticsC" class="common_selectbox_wrap hidden">
							    <option value="0">${ctp:i18n('report.reportDesign.data')}</option>
							    <option value="1">${ctp:i18n('report.reportDesign.info')}</option>
							</select>
						</div>
<%-- 						<a class="common_button common_button_gray" href="javascript:void(0)" id="newquery">${ctp:i18n('report.reportDesign.button.newReport')}</a> --%>
						<form action="${path }/report/reportDesign.do?method=reportSave" id="saveForm">
							<input type="hidden" id="statisticsCInput" name ="statisticsCInput" />
                    						<fieldset class="form_area padding_10" id="queryFieldSet">
                    							<legend><font color="black">${ctp:i18n('report.reportDesign.reportDefine')}</font></legend>
                    								<table width="100%" border="0" cellpadding="2" cellspacing="0" id="firstTable">
                                                    <tr height="30px">
                                                        <td width="30%" align="right" nowrap="nowrap">
                                                            <label class="margin_r_10" for="text"><span class="required">*</span>${ctp:i18n('report.reportDesign.templetName')}：</label>
                                                        </td>
                                                        <td nowrap="nowrap">
                                                            <div class=common_txtbox_wrap>
                                                                <input id="reportId" name="reportId" class="w100b" type="hidden"> 
                                                                <input id="modifyIndex" name="modifyIndex" class="w100b" type="hidden" value="-1"><!-- 如果是修改统计，记录统计记录的顺序 -->
                                                                <input id="mainTableCode" name="mainTableCode" searchFieldIsMainTableOnly="1" type="hidden" reportHead="" crossColumn="" showDataList="" userCondition="" systemCondition="" searchFieldList="">
                                                                <input id="reportName" name="${ctp:i18n('report.reportDesign.templetName')}" disabled="disabled" readonly="readonly" class="w100b validate" type="text" validate="type:'string',notNull:true,notNullWithoutTrim:true,avoidChar:'\&#39;&quot;&lt;&gt;!,@#$%&*()',maxLength:85">
                                                            </div>
                                                        </td>
                                                        <td width="20%"></td>
                                                    </tr>
                                                    <tr>
                                                        <td><label class="margin_r_10 right title" for="text">${ctp:i18n('report.reportDesign.templetType.title')}：</label></td>
                                                        <td colspan=2>
                                                            <div class="common_txtbox clearfix margin_5">
                                                                <input type="radio" name="acrossreport" disabled="disabled" value="false" checked="checked" id="common" class="common" /><span>${ctp:i18n('report.reportDesign.templetType.Simple')}</span>
                                                                <input type="radio" name="acrossreport" disabled="disabled" value="true" id="common" class="cross" /><span>${ctp:i18n('report.reportDesign.templetType.Cross')}</span>
                                                            </div>
                                                        </td>
                                                        <td></td>
                                                    </tr>
                                                    <tr height="30px">
                                                        <td width="30%" align="right" nowrap="nowrap"><label class="margin_r_10"
                                                            for="text"><font color="red">*</font>${ctp:i18n('report.reportDesign.dialog.groupingitem.title')}：</label></td>
                                                        <td nowrap="nowrap">
                                                            <div class=common_txtbox_wrap>
                                                                <input readonly="readonly" disabled="disabled" id="reportHead" name="${ctp:i18n('report.reportDesign.dialog.groupingitem.title')}" class="w100b validate" type="text" mytype="4" hideText="showFieldNameList" validate="type:'string',notNull:true">
                                                            </div>
                                                        </td>
                                                       <td align="left"><!-- 统计分组项设置 -->
                                                       		<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="setReportHead" dialogId="dialog_reportHead" dialogTitle="${ctp:i18n('report.reportDesign.dialog.groupingitem.set')}">
                                                       		${ctp:i18n('report.reportDesign.form.button.set')}</a>
                                                            <input type="hidden" id="reportHeadHidden" value="">
                                                            <input type="hidden" id="reportHeadNewTitleHidden" value="">
                                                            <input type="hidden" id="reportHeadDateTypeHidden" value="">
                                                        </td>
                                                    </tr>
                                                    <tr height="30px">
                                                        <td width="30%" align="right" nowrap="nowrap"><label class="margin_r_10"
                                                            for="text"><span class="required" id="iscross" style="display:none;">*</span>${ctp:i18n('report.reportDesign.dialog.acrossreportColumn.title')}：</label></td>
                                                        <td nowrap="nowrap">
                                                            <div class=common_txtbox_wrap>
                                                                <input disabled="disabled" readonly="readonly" validate="" name="${ctp:i18n('report.reportDesign.dialog.acrossreportColumn.title')}" id="crossColumn" class="w100b " type="text" mytype="4" hideText="showFieldNameList">
                                                                <input type="hidden" id="crossColumnHidden" value="">
                                                                <input type="hidden" id="crossColumndDateTypeHidden" value="">
                                                                
                                                            </div>
                                                        </td>
                                                        <td align="left"><a class="common_button common_button_disable common_button_gray margin_l_5"
                                                            href="javascript:void(0)" id="setCrossColumn" dialogTitle="${ctp:i18n('report.reportDesign.sort.crossDialog')}" dialogId="dialog_crossColumn">${ctp:i18n('report.reportDesign.form.button.set')}</a>
                                                        </td>
                                                    </tr>
                                                     
                                                    <tr height="30px">
                                                        <td width="30%" align="right" nowrap="nowrap"><label class="margin_r_10"
                                                            for="text"><font color="red">*</font>${ctp:i18n('report.reportDesign.dialog.staticsitem.title')}：</label></td>
                                                        <td nowrap="nowrap">
                                                            <div class=common_txtbox_wrap>
                                                                <input disabled="disabled" readonly="readonly" id="showDataList" name="${ctp:i18n('report.reportDesign.dialog.staticsitem.title')}"
                                                                    class="w100b validate" type="text" mytype="4"
                                                                    hideText="showFieldNameList" validate="type:'string',notNull:true">
                                                            </div>
                                                        </td>
                                                        <td align="left"><!-- 统计项设置 -->
                                                        	<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="setShowDataList" dialogTitle="${ctp:i18n('report.reportDesign.dialog.staticsitem.set')}" dialogId="dialog_showDataList">
                                                        	${ctp:i18n('report.reportDesign.form.button.set')}</a>
                                                            <input type="hidden" id="showDataListHidden" value="">
                                                            <input type="hidden" id="showDataListNewTitleHidden" value="">
                                                            <input type="hidden" id="showDataListStaticsTypeHidden" value="">
                                                            <input type="hidden" id="formattype" value="">
                                                            <input type="hidden" id="formulastr" value="">
                                                            <input type="hidden" id="columntype" value="">
                                                            <input type="hidden" id="enumchange" value="">
                                                            <input type="hidden" id="crossTypes" value=""><!-- 计算列交叉设置 -->
                                                        </td>
                                                    </tr>
                                                    <tr height="30px">
                                                        <td width="30%" align="right" nowrap="nowrap"><label class="margin_r_10"
                                                            for="text">${ctp:i18n('report.reportDesign.sort.sortDialog')}：</label></td>
                                                        <td nowrap="nowrap">
                                                            <div class=common_txtbox_wrap>
                                                                <input disabled="disabled" readonly="readonly" id="sortColumn" name="${ctp:i18n('report.reportDesign.sort.sortDialog')}"
                                                                    class="w100b validate" type="text" mytype="4"
                                                                    hideText="showFieldNameList" validate="type:'string'">
                                                            </div>
                                                        </td>
                                                        <td align="left"><!-- 排序设置 -->
                                                        	<a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="setSortColumn" dialogTitle="${ctp:i18n('report.reportDesign.sort.sortDialog')}" dialogId="dialog_sortColumn">
                                                        	${ctp:i18n('report.reportDesign.form.button.set')}</a>
                                                            <input type="hidden" id="sortColumnVal" value="">
                                                            <input type="hidden" id="sortColumnTitle" value="">
                                                        </td>
                                                    </tr>
                                                    <tr height="30px" >
                    										<td width="30%" align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
                    											color="red"></font>${ctp:i18n('report.reportDesign.lastRowCount.title')}：</label></td>
                    										<td nowrap="nowrap">
                    										     <div class=common_txtbox_wrap>
                    										    <input disabled="disabled" readonly="readonly" id="sumDataField" name="sumDataField"
                                                                       class="w100b" type="text"  datafiledId="showFieldList"   hideText="orderByNameList">
                    										    </div>
                    										</td>
                    										<td align="left"><!-- 行分类汇总 -->
                    										 <a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="sumDataFieldSet"  dialogTitle="${ctp:i18n('report.reportDesign.lastRowCount.set')}" dialogId="dialog_showFieldList">${ctp:i18n('report.reportDesign.form.button.set')}</a>
                                                                 <input type="hidden" id="classifyValue" value="">
                                                                 <input type="hidden" id="summaryWay" value="">
                                                                 <input type="hidden" id="summaryWayTitle" value="">
                                                                 <input type="hidden" id="sumDataFieldSetHidden" value="">
                                                                 <input type="hidden" id="sumDataFieldSetNewTitleHidden" value="">
                    										</td>
                    								</tr>
                    									<tr height="30px" >
                    										<td width="30%" align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><font
                    											color="red"></font>${ctp:i18n('report.reportDesign.systemStatCondition.title')}：</label></td>
                    										<td height="32">
                    										     <div class="common_txtbox  clearfix">
                    										     <input type="hidden" id="systemConditionId">
                    										    <textarea disabled="disabled" readonly="readonly" id="systemCondition" name="systemCondition" class="w100b"></textarea>
                    										    </div>
                    										</td>
                    										<td align="left">
                    										 <a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="systemConditionSet">${ctp:i18n('report.reportDesign.form.button.set')}</a>
                    										</td>
                    									</tr>
                    									
                    								</table>
                    						</fieldset>
                                            
                                            
                                            <fieldset class="form_area padding_10" id="chartFieldSet">
                                                <legend><font color="blue">${ctp:i18n('report.reportDesign.chartSet.title')}</font></legend>
                                                <table class="align_center w100b" id="fieldAreaContent" isGrid="true">
                                                    <tr align="center" class="margin_b_5">
                                                        <td>${ctp:i18n('report.reportDesign.dialog.chartItem.title')}</td>
                                                        <td>${ctp:i18n('report.reportDesign.dialog.chartItem.row')}</td>
                                                        <td>${ctp:i18n('report.reportDesign.dialog.chartItem.column')}</td>
                                                        <td></td>
                                                    </tr>
                                                    <tr class="margin_b_5">
                                                        <td width="25%"><input type="text" id="chartName" name="chartName" value="" disabled="disabled" readonly="readonly" class="margin_b_5 w90b"/><input type="hidden" id="chartId" name="chartId"/></td>
                                                        <td width="25%"><input type="text" id="chartHead" name="chartHead1" value="" class="margin_b_5 w90b" disabled="disabled" readonly="readonly"/><input type="hidden" id="chartHeadHidden" name="chartHeadHidden"/></td>
                                                        <td width="25%"><input type="text" id="chartData" name="chartData1" value="" class="margin_b_5 w90b" disabled="disabled" readonly="readonly"/><input type="hidden" id="chartDataHidden" name="chartDataHidden"/></td>
                                                        <td width="30%">
                     										<span class='ico16 repeater_reduce_16' id='delField' name="delField"></span>
                                                            <span class='ico16 repeater_plus_16' id='addField' name="addField"></span>
                                                        	<a id="setReportChart" name="setReportChart" class="common_button common_button_disable common_button_gray margin_b_5 margin_l_5" href="javascript:void(0)">${ctp:i18n('report.reportDesign.form.button.set')}</a>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </fieldset>
                                            <div align="center" id="buttonDiv" class="margin_t_5">
                                                <a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="saveQuery">${ctp:i18n('report.reportDesign.button.confirm1')}</a>
                                                <a class="common_button common_button_disable common_button_gray margin_l_5" href="javascript:void(0)" id="reset">${ctp:i18n('report.reportDesign.button.reset')}</a>
                                            </div>
				</form>
	                </div>
	                <div class="col2 margin_l_5" style="float: left">
	                	<div class="common_txtbox clearfix margin_b_5">
							<label class="margin_r_10 left margin_t_5" for="text">${ctp:i18n('report.reportDesign.dialog.staticsitem.list')}:</label>
							<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="update">${ctp:i18n('report.reportDesign.button.edit')}</a>
							<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="del">${ctp:i18n('report.reportDesign.button.delete')}</a>
							<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="authSet">${ctp:i18n('report.reportDesign.button.authSet')}</a>
							<form action="${path }/report/reportDesign.do?method=reportSave" id="saveAuthForm">
								<input id="authTo" type="hidden">
								<input id="selectedReportId" type="hidden">
								<input id="selectedAuthId" type="hidden">
							</form>
						</div>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table edit_table" style="table-layout:fixed;">
		                    <thead>
		                        <tr>
		                            <th width="30"><input type="checkbox" onclick="selectAll(this);"/></th>
		                            <th align="center">${ctp:i18n('report.reportDesign.templetName')}</th>
		                            <th align="center">${ctp:i18n('report.reportDesign.statAuthSet.title')}</th>
		                            <th align="center">${ctp:i18n('report.reportDesign.field.modifyDate')}</th>
		                        </tr>
		                    </thead>
		                    <tbody id="queryBody">
		                    	<c:forEach var="report" items="${formBean.formReportList }" varStatus="status">
                                <c:if test="${report.reportDefinition.deleteFlag != 1}">
			                    		<tr>
			                    			<td id="reportId">
			                    				<c:choose>
			                    					<c:when test="${reportsAuth[status.index]==null}">
			                    						<input type="checkbox" name="cbReportId" value="${status.index}*0*0*${report.reportDefinition.id }"  onclick="setInitState();initShowTitle();initShowTable();"/>
			                    					</c:when>
			                    					<c:otherwise>
			                    						<input type="checkbox" name="cbReportId" value="${status.index}*${report.reportAuthList[0].id}*${reportsAuth[status.index].personsNameId}*${report.reportDefinition.id }"  onclick="setInitState();initShowTitle();initShowTable();"/>
			                    					</c:otherwise>
			                    				</c:choose>
			                    				
			                    			</td>
		                            		<td onclick="showReport(this);" nowrap="nowrap" class="callreportname" title="${report.reportDefinition.name}" value="${report.reportDefinition.name}" >
                                            	<c:choose>
													<c:when test="${report.reportDefinition.secondCategory==1}">
														<span style="width:95%;float:left;">${report.reportDefinition.cutName}<span class="ico16 flash_16"></span></span>
                                            			<span style="width:5%;float:rigth;">
                                            			<c:if test="${report.reportCfg.chartCfgList!= null && fn:length(report.reportCfg.chartCfgList)>0}">
                                            			<span class="ico16 statistics_16"></span> 
                                            			</c:if></<span>
													</c:when>
													<c:otherwise>
														<div class='cut_string' style="width:95%;float:left;">${report.reportDefinition.name}</div>
                                            			<div style="width:5%;float:rigth;"><c:if test="${report.reportCfg.chartCfgList!= null && fn:length(report.reportCfg.chartCfgList)>0}">
                                            			<span class="ico16 statistics_16"></span> 
                                            			</c:if></div>
													</c:otherwise>
												</c:choose>
                                            </td>
		                            		<td id="auth" title="${reportsAuth[status.index].personsName}" nowrap="nowrap">
		                            			<div class='cut_string' style="width:100%;">${reportsAuth[status.index].personsName}</div>
		                            		</td>
		                            		<td id="updateDate" title="<c:if test="${ctp:isNotBlank(report.reportDefinition.updateDate)}">${ctp:formatDateTime(report.reportDefinition.updateDate)}</c:if>" nowrap="nowrap">
		                            			<div class='cut_string' style="width:100%;"><c:if test="${ctp:isNotBlank(report.reportDefinition.updateDate)}">${ctp:formatDateTime(report.reportDefinition.updateDate)}</c:if></div>
		                            		</td>
		                        		</tr>
                                 </c:if>
		                        </c:forEach>
		                    </tbody>
		                 </table>
	                </div>
				</div>
				 <div class="clearfix code_list padding_5">
				<table id="newTable" width="100%" border="0" cellpadding="0"
					cellspacing="0">
					<tr>
						<td width="100%" style="padding-top: 6px;"><span
							style="text-align: left; width: 100%; font-size: 9pt;"> <font
							color="blue">${ctp:i18n('report.reportDesign.preview')}:</font> </span>
						<hr>
						</td>
					</tr>
					<tr>
					<td align="center">
					<span id="outName"
							style="text-align: center; width: 100%; font-size: 12pt;"></span> <span
							id="con" style="text-align: center; width: 100%; font-size: 12pt;"></span>
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
		</div>
	</body>
	<%@ include file="/WEB-INF/jsp/ctp/form/common/common.js.jsp" %>
	<script type="text/javascript">
	
	$(document).ready(function(){
        new MxtLayout({
            'id': 'layout',
            'centerArea': {
                'id': 'center',
                'border': false
            }
        });
        //初始化按钮的单击事件
        initBtnClick();
        $("#content").val($("#firstTable").html());
        $("body").data("queryDefine",$("#queryFieldSet").children().clone(true));
        $("body").data("showTableObject",$("table.flexme1").clone(true));
        //重复项设置        
        $("body").data("reportChartArea",$("#chartFieldSet").children().clone(true));
        
        if(!${formBean.newForm }){
          parent.ShowBottom({'show':['doSaveAll','doReturn']});
          }else{
            parent.ShowBottom({'show':['upStep','nextStep','finish'],'source':{'upStep':'../form/queryDesign.do?method=queryIndex','nextStep':'../form/bindDesign.do?method=index'}});
          }
        $("#viewShow input[type='checkbox']").attr("checked", "checked");
	});
	
	function changeVal(index){
		var formType = "${formBean.formType}";
		if(formType == 1){
			$("#statisticsC").removeClass("hidden");
		}
		if(typeof(index) != 'undefined'){
			var secondC = $("#secondCategory").val();
			var statisticsCInput = secondC.split(",")[index];
			$("#statisticsC").val(statisticsCInput);
	        $("#statisticsCInput").val(statisticsCInput);
		}
		var value = $("#statisticsC")[0].value;
		$("#firstTable").html($("#content").val());
		var appendHTML = "";
		var gdContent = "<tr height='30px' ><td width='30%' align='right' nowrap='nowrap' style='padding-bottom:40px;padding-top:30px'><label class='margin_r_10' for='text'><font"+
						 "color='red'></font>${ctp:i18n('report.reportDesign.drillSet.title')}：</label></td><td> <div  class='margin_tb_5 padding_5 border_all'>"+
						 "<div class='common_radio_box clearfix'><label for='gent1' class='margin_r_10 hand'><input class='radio_com' disabled='disabled' type='radio' id='gent' name='gent'  value='1' checked='checked'/>${ctp:i18n('report.reportDesign.drillSet.yes')}</label>"+
						 "<label for='gent2' class='margin_r_10 hand'><input class='radio_com' disabled='disabled' type='radio' id='gent' name='gent'  value='0'/>${ctp:i18n('report.reportDesign.drillSet.no')}</label>"+
						 "</div><table style='width:100%' id='viewShow' height='60'>${content}"+
						 "<input type='hidden' value='${varName}' id='ccount'/></table> </div></td></tr>";
		// 页面加载时，curchoice为undefined    
		if(value == 0){ // 表单数据统计
			appendHTML = "<tr height='30px' ><td width='30%' align='right' nowrap='nowrap'><label class='margin_r_10' for='text'><font"+
						 "color='red'></font>${ctp:i18n('report.reportDesign.sysUserInputCond.title')}：</label></td><td height='32'><div class='common_txtbox  clearfix'>"+
						 "<input type='hidden' id='userConditionId'> <textarea disabled='disabled' readonly='readonly' id='userCondition' name='userCondition' class='w100b'></textarea>"+
						 "</div></td><td align='left' nowrap='nowrap'>"+
						 " <a class='common_button common_button_disable common_button_gray margin_l_5' href='javascript:void(0)' id='userConditionSet'>${ctp:i18n('report.reportDesign.form.button.set')}</a>"+
						 " <a class='common_button common_button_disable common_button_gray margin_l_5' href='javascript:void(0)' id='userFieldSet'>${ctp:i18n('report.reportDesign.conditionControl.title')}<input type='hidden' id='userFields'></a>"+
						 "</td></tr><tr height='30px' ><td width='30%' align='right' nowrap='nowrap'><label class='margin_r_10' for='text'><font"+
						 "color='red'></font>${ctp:i18n('report.reportDesign.userDefinedState.title')}：</label></td><td nowrap='nowrap'>"+
						 "<div class=common_txtbox_wrap><input disabled='disabled' readonly='readonly' id='searchFieldList' name='searchFieldList' class='w100b' type='text' mytype='11' hideText='searchFieldNameList'>"+
						 " <input id='searchFieldNameList' name='searchFieldNameList' class='w100b' type='hidden'> </div></td><td align='left'>"+
						 " <a class='common_button common_button_disable common_button_gray margin_l_5' href='javascript:void(0)' id='searchFieldSet'>${ctp:i18n('report.reportDesign.form.button.set')}</a>"+
						 "</td></tr>";
			var dee = "<tr height='30px'><td width='30%' align='right' nowrap='nowrap'><label class='margin_r_10' for='text'>${ctp:i18n('report.reportDesign.form.button.deeLable')}</label></td><td nowrap='nowrap'><div class=common_txtbox_wrap><input type='hidden' id='deeId'/><input disabled='disabled' readonly='readonly' id='deeName' name='deeName' class='w100b' type='text' mytype='11'>"+
						 "  </div></td><td align='left'> <a class='common_button common_button_disable common_button_gray margin_l_5' href='javascript:void(0)' id='toDEE'>${ctp:i18n('report.reportDesign.form.button.set')}</a><a class='common_button common_button_disable common_button_gray margin_l_5' href='javascript:void(0)' id='deeClear'>${ctp:i18n('report.reportDesign.form.button.deeClear')}</a></td></tr>";
			var isDee = "${dee}";
			if(isDee){
				gdContent = gdContent + dee;
			}
		}
		var description = "<tr height='30px' ><td width='30%' align='right' nowrap='nowrap'><label class='margin_r_10' for='text'><fontcolor='red'></font>${ctp:i18n('report.reportDesign.statdescription.title')}：</label></td>"+
		 "<td> <div class='common_txtbox  clearfix'> <textarea disabled='disabled' readonly='readonly' id='description' name='description' class='w100b'></textarea></div></td></tr>";
		gdContent = gdContent + description;
		$("#firstTable").append(appendHTML+gdContent);
	}
	
	function checkTitle(title){
		var chars = "!,@#$%^&*()";
        for(var i=0,len=chars.length; i<len; i++){
            if (title.indexOf(chars.charAt(i)) > -1) {
              	return true;
            }
        }
		return false;
	}
    //初始化按钮的单击事件
    function initBtnClick(){
      //新增
		$("#newquery").unbind('click').click(function(){
			newQuery();
			$("#reportName").val("${formBean.formName}");
		});
		//确认
	 $("#saveQuery").click(function(){
	       if($(this).hasClass("common_button_disable"))return;
            //验证图表名称是否已报在
            var title= $("#reportName").val();
            if(title!=""){
            	var modifyIndex = $("#modifyIndex").val();
            	var cbReport = $("input[name='cbReportId']");
            	var res= $(".callreportname");
            	var reportId = $("#reportId").val();
            	for(var i=0;i<cbReport.length;i++){
            		var cbReportId = $(cbReport[i]).attr("value");
            		var rname=$(res[i]).attr("value");
            		var isModifyThis = false;//修改当前统计
            		if(modifyIndex != -1 && (cbReportId.indexOf(reportId) > 0)){
            			isModifyThis = true;
            		}
            		if((title.trim()==rname.trim()) && !isModifyThis){
            			$.error("${ctp:i18n('report.reportDesign.set.errorSameName')}");//该名称已存在
                        return false;
            		}
            	}
            }
            // 穿透显示设置中，过勾选了允许穿透，检查是否有视图选中，如果没有，提示“允许穿透必须选择显示的视图及权限”
            if($("input[name='gent']").eq(0).attr("checked")=="checked"){
            	var show = $("input:checked","#viewShow");
            	if(show.length == 0){
            		$.alert("${ctp:i18n('report.reportDesign.dialog.chooseView')}");
            		return false;
            	}
            }
            //验证自定义统计项选择是否符合规则（如果统计项、统计分组项、交叉项只有主表字段，则自定义统计项也只能选择主表字段）
            /*if($("#mainTableCode").attr("searchFieldList") != "" && 
               $("#mainTableCode").attr("reportHead") == "" &&
               $("#mainTableCode").attr("crossColumn") == "" &&
               $("#mainTableCode").attr("showDataList") == ""){
                $.error("${ctp:i18n('report.reportDesign.set.errorNotInOneTable')}");//自定义统计项设置错误，与统计分组项、交叉项、统计项选择的字段不在同一个重复表中，请修改。
                return;
            }*/
            if($(this).hasClass("common_button_disable"))return;
            changePageNoAlert = true;
            $("#statisticsCInput").val($("#statisticsC")[0].value);
            //先验证数据有效性
            var validateResult = $("#saveForm").validate();
            if(validateResult){
            	var proce = $.progressBar(); //提交时加个遮罩，防重复提交，因为URL是重定向的，所以不自动close了
            	$("#saveForm").jsonSubmit();
            }
        });
		//删除
		$("#del").unbind('click').click(function(){
			var selectQuery = $(":checked","#queryBody");
			if(selectQuery.length<=0){
				$.alert("${ctp:i18n('report.reportDesign.dialog.prompt.selecteDelete')}");
			}else{
			    $.confirm({
			        'msg': "${ctp:i18n('report.reportDesign.dialog.prompt.delete')}",//确定要删除选中的记录吗?删除后数据将不可恢复!
			        ok_fn: function () {
	                     var queryIds = new Array();
	                        selectQuery.each(function(){
	                            var selectedValues = $(this).val().split("*");
	                            queryIds[queryIds.length] = selectedValues[3];
	                        });
	                    
	                        var o = new formReportDesignManager();
	                        o.deleteReportSet(queryIds,{
	                          success: function(obj){
	                              //协同V5.0 OA-32256 刷新页面请调用这个方法winReflesh(u,win) U是url连接 win是window对象 这两个参数可以没有默认是当前的window reload
// 	                              window.location.href=url_reportDesign_index;
                                  parent.winReflesh(null,window);
	                          }
	                        });
			        }
			    });
			}
		});
		//修改
		$("#update").unbind('click').click(function(){
			$("#statisticsC").attr("disabled","disabled");
			var selectQuery = $(":checked","#queryBody");
			if(selectQuery.length!=1){
				$.alert("${ctp:i18n('report.reportDesign.dialog.prompt.selecteEdit')}");//请选择一项记录进行修改!
				return;
			}else{	
				var index = selectQuery.val().split("*")[0];

				newQueryForModify(index);
				//modifyIndex 用来判断是否是修改，-1是新建
				$("#modifyIndex").val(index);		
			    editReport(index,false);
			}
			setTimeout("initShowTable()",500);
		});

		//授权
		$("#authSet").unbind('click').click(function(){
			var selectQuery = $(":checked","#queryBody");
			if(selectQuery.length<=0){
				$.alert("${ctp:i18n('report.reportDesign.dialog.prompt.selecteAuth')}");//请选择需要授权的记录!
				return;
			}else{
				var index = selectQuery.val().split("*")[0];
				var secondC = $("#secondCategory").val();
				for(var i=0;i<selectQuery.size();i++){
					var curIndex = selectQuery[i].defaultValue.split("*")[0];
					var statisticsCInput = secondC.split(",")[curIndex];
					if(statisticsCInput == 1){
						$.alert("${ctp:i18n('report.reportDesign.shouquan')}");//请选择需要授权的记录!
						return;
					}
				}
				var par = new Object();
				par.value = "";
				if(selectQuery.length>1){
					par.text='';
					par.value='';
				}else{
					selectQuery.each(function(index){
		        		var tval = $(this).val();
		        		var val = par.value + tval.split("*")[2];
			        	if(val==0){
			        		val="";
			        	}
			            par.value += val + (index==selectQuery.size()-1?"":",");
		          	});
				}
				
				var panels = 'Account,Department,Team,Post,Level,Outworker,JoinOrganization,JoinAccountTag,JoinPost';
				var selectType = 'Account,Department,Team,Post,Level,Member,JoinAccountTag';
		        if ("${formBean.formType}" == "4") {//计划格式屏蔽V-Join
		            panels = 'Account,Department,Team,Post,Level,Outworker';
	                selectType = 'Account,Department,Team,Post,Level,Member';
		        }
				
				$.selectPeople({
			        panels: panels,
			        selectType: selectType,
			        minSize : 0, 
			        isNeedCheckLevelScope:false,
			        hiddenPostOfDepartment:true,
			        hiddenRoleOfDepartment:true,
			        showAllOuterDepartment:true,
			        params : par,
			        callback : function(ret) {
			          var queryIds = "";
			          var authIds = "";
			          selectQuery.each(function(index){
			        	  var tval = $(this).val();
				          queryIds = queryIds + (index==0?"":",")+ tval.split("*")[0];
				          authIds = authIds + (index==0?"":",") + tval.split("*")[1];
			          });
			          $("#selectedReportId").val(queryIds);
			          $("#selectedAuthId").val(authIds);
			          $("#authTo").val(ret.value);
			          changePageNoAlert = true;
                        parent.hiddenAllBtn();
			          $("#saveAuthForm").jsonSubmit();
			        }
			    });
			}
		});
		//重置
		$("#reset").unbind('click').click(function(){
			var reportId = $("#reportId").val();
			var modifyIndex = $("#modifyIndex").val();
			var ccount = $("#ccount").val();
			if($(this).hasClass("common_button_disable"))return;
			if($("#queryId").val()!=""){
				var tempQueryId = $("#queryId").val();
				newQuery();
				editQuery(tempQueryId);
			}else{
				newQuery();
			}
			$("#reportId").val(reportId);
			$("#modifyIndex").val(modifyIndex);
			$("#ccount").val(ccount);
		});
		 
		$("#firstTable").on('click', 'a', function(){
		    if($(this)[0].id == 'userConditionSet'){ // 用户自定义条件设置
		    	if($(this).hasClass("common_button_disable"))return;
		    	 var value = $("#statisticsC")[0].value;
		      	  var ob = new Object();
		      	  ob.qsType = value;
		      	setUserStatistics(ob);
		    }else if($(this)[0].id == 'userFieldSet'){
		    	if($(this).hasClass("common_button_disable"))return;
		  		editUserConditionField("userCondition","report");
		    }else if($(this)[0].id == 'searchFieldSet'){//自定义统计设置
		    	if($(this).hasClass("common_button_disable"))return;
		    	selectChoose("searchFieldList",null,$.parseJSON("{'byTable':'wee','byInputType':'handwrite,attachment,document,image'}"),{IsWriteBlak:false},searchFieldCheck);
		    } else if($(this)[0].id == 'toDEE'){ //转DEE
		    	if($(this).hasClass("common_button_disable"))return;
		    	deeSource();
		    }else if($(this)[0].id == 'deeClear'){ //清空DEE任务
		    	if($(this).hasClass("common_button_disable"))return;
		    	$("#deeName").val("");
             	$("#deeId").val("");
		    }
		});
    }
    
    
    function deeSource(){
	var returnval;
		var dialog = $.dialog({
	          targetWindow:window.top,
	          isDrag:true,
	          width:700,
	          height:500,
	          scrolling:false,
	          url:"${path}/dee/deeTrigger.do?method=triggerDEETask&&taskType=data",
	          title : "${ctp:i18n('report.index.invoke.dee')}",
	          buttons : [ {
	            text : "${ctp:i18n('report.reportDesign.button.confirm')}",
	            id:"sure",
	            isEmphasize: true,
	            handler : function() {
	                var returnval = dialog.getReturnValue();
	                if(returnval){
	                	 $("#deeName").val(returnval.taskName);
	                	 $("#deeId").val(returnval.taskId);
	                	 dialog.close();
	            	}
	            }
	          }, {
	            text: "${ctp:i18n('report.reporting.button.cancel')}",
	            id:"exit",
	            handler : function() {
	              dialog.close();
	            }
	          } ]
	        });	
}
    
    function checkFunction(formulastr,setButton,condition){
        var returnValue = false;
        var formReportDesignManager_ = new formReportDesignManager();
        var checkValue =  formReportDesignManager_.findCondtionsOwnerTableName(formulastr,setButton);
        if(checkValue.status == "1" && isInSameMainTable(checkValue.value,setButton,checkValue.name)){
            $("#"+condition+"").val(formulastr);
           	returnValue = true;
        }else if(checkValue.status == "0"){
            $.error("${ctp:i18n('report.reportDesign.set.errorNotInOneTable')}");
        }
        return returnValue;
    }
    function initSetBtnClick(){
      //初始化图表设置的3个按钮
      initChartSetBtnClick();
      //按钮 统计分组项 设置、统计项设置,最后一行合计设置
      $("#setReportHead,#setShowDataList").unbind('click').click( function() {
          openFormField($(this).attr("dialogId"), $(this).attr("dialogTitle"), $(this).attr("id"));
      });
      $("#setSortColumn").unbind('click').click( function() {
          openFormSortField($(this).attr("dialogId"), $(this).attr("dialogTitle"), $(this).attr("id"));
      });
      $("#sumDataFieldSet").unbind('click').click( function() {
          openFormSummary($(this).attr("dialogId"), $(this).attr("dialogTitle"), $(this).attr("id"));
      });

      //系统条件设置
      $("#systemConditionSet").unbind('click').click(function(){
      	  var value = $("#statisticsC")[0].value;
      	  var ob = new Object();
      	  ob.qsType = value;
          setSystemStatistics(ob);
      });
      
	    $(":radio",$("#queryFieldSet")).unbind('click').click(function(){
	        initGentRadio();
	    });
	    $(":checkbox",$("#queryFieldSet")).unbind('click').click(function(){
	        initViewShow();
	    });
	    $("#reportName").unbind('keyup').keyup(function(){
	        initShowTitle();
	    });
	    
	    //交叉报表
	    $(".cross").unbind('click').click(function(){
	      $("#crossColumn").removeAttr("disabled");
	           //图表设置中列（图列项）有多个统计项，请修改成一项或删除相应设置后再转换成交叉报表
	        var chartDatas = $("input[name='chartDataHidden']");
	        for(var i = 0 ; i < chartDatas.length ; i ++){
	            if(chartDatas.eq(i).val().indexOf(",") != -1){
	                $.error("${ctp:i18n('report.reportDesign.dialog.prompt.acrossReport')}!");//图表设置中列（图列项）有多个统计项，请修改成一项或删除相应设置后再转换成交叉报表
	                $("#common").trigger("click");
	                return false;
	            }
	        }
	        chooseCrossButton();
	        
	    });
	    //普通报表
	    $(".common").unbind('click').click(function(){
	    	$("#crossColumn").attr("disabled","");
	        $("#iscross").hide();
	       $("#saveForm").myclearform();
	       $("#crossColumn").attr("validate","" ).removeClass(" validate ");//交叉项允许为空
	       $("#setCrossColumn").removeClass("common_button").addClass("common_button_disable").addClass("common_button");
	       $("#setCrossColumn").unbind('click');
	       
	       var crossVal=$("#crossColumnHidden").val();
	       var sortColumnName=$("#sortColumn").val().split(",");
	       var sortColumnVal=$("#sortColumnVal").val().split(",");
	       var newSortColumnVal="";
	       var newSortColumnName="";
	       for(var i=0;i<sortColumnVal.length;i++){
	       		if(sortColumnVal[i].indexOf(crossVal)==-1){
	       			newSortColumnVal+=sortColumnVal[i]+",";
	       			newSortColumnName+=sortColumnName[i]+",";
	       		}
	       }
	       $("#sortColumn").val(newSortColumnName.substring(0,newSortColumnName.length-1));
	       $("#sortColumnVal").val(newSortColumnVal.substring(0,newSortColumnVal.length-1));
	       //清空交叉项中的值
	       $("#crossColumn").val("");
	       $("#crossColumnHidden").val("");
	       $("#crossColumndDateTypeHidden").val("");
	       $("#crossTypes").val("");
	       initShowTable();
	    });
	    
	    //允许穿透　不允许穿透设置　
        $(".radio_com").click(function(){
            var res=$(this).attr("value");
            if(res==1)
                $("#viewShow").show();
             else
                $("#viewShow").hide();
        });
    }
  //初始化图表设置的3个按钮
    function initChartSetBtnClick(){
      //图表设置界面
      $("a[name='setReportChart']").unbind('click').click(function(){
          openReportChartDialog($(this));
      });
      //图标设置重复项删除图标
      $("span[name='delField']").unbind('click').click(function(){
          delField($(this));
      });
      //图标设置重复项添加图标
      $("span[name='addField']").unbind('click').click(function(){
          addField($(this));
      });
    }
    /**
    *取消按钮事件绑定
    */
    function cancelBtnClick(){
      $("#setReportHead,#setShowDataList,#setCrossColumn,#sumDataFieldSet,#setReportChart,#delField,#addField,#searchFieldSet,#systemConditionSet,#userConditionSet,#userFieldSet").unbind('click');
      $(":radio",$("#queryFieldSet")).unbind('click');
      $(":checkbox",$("#queryFieldSet")).unbind('click');
      $("#reportName").unbind('keyup');
    }
    /**
    *选择交叉报表后，修改交叉报表选项
    */
    function chooseCrossButton(){
      $("#iscross").show(); //*符号
      $("#crossColumn").attr("validate","type:'string',notNull:true" ).addClass(" validate ");//交叉项不允许为空
      $("#setCrossColumn").removeClass("common_button_disable").removeClass("common_button").addClass("common_button");
      $("#crossColumn").removeAttr("disabled");
      $("#setCrossColumn").unbind('click').click(function(){
          openFormField($(this).attr("dialogId"), $(this).attr("dialogTitle"), $(this).attr("id"));
      });
    }

    /**
     *打开dialog:行分类汇总
     */
    function openFormSummary(id, title, from) {
    	 var sortColumnVal=$("#sortColumnVal").val();
         var selectedValues = $("#showDataListHidden").val();
         var selectedShowTitles = $("#showDataList").val();
         var crossTypes = $("#crossTypes").val();
         var selectedNewShowTitles = $("#showDataListNewTitleHidden").val();
         var staticsTypes = $("#showDataListStaticsTypeHidden").val(); //统计项类型
         
         if(!$.isNull(crossTypes)){//汇总项里面排除 计算列交叉
         	var crossTypeArr = crossTypes.split(",");
         	var showDataValueArr = $("#showDataListHidden").val().split(",");
         	var showDataTitleArr = $("#showDataList").val().split(",");
         	var selectedNewShowTitleArr = selectedNewShowTitles.split(",");
         	var staticsTypeArr = staticsTypes.split(",");
         	
         	selectedValues = "";
         	selectedShowTitles = "";
         	selectedNewShowTitles = "";
         	staticsTypes = "";
         	
         	for(var i=0;i<crossTypeArr.length;i++){
         		if("cross" != crossTypeArr[i]){
         			selectedValues = union(selectedValues, showDataValueArr[i]);
         			selectedShowTitles = union(selectedShowTitles, showDataTitleArr[i]);
         			selectedNewShowTitles = union(selectedNewShowTitles, selectedNewShowTitleArr[i]);
         			staticsTypes = union(staticsTypes, staticsTypeArr[i]);
         		}
         	}
         }
         
         
         var url = url_reporDesign_selectFormField + "&from=" + from;
         var width = 310;
         var height = 300;
         //记录已选择的项的关键字
         var selectedValue =  $("#reportHeadHidden").val();
         //记录已选择的项的Name
         var selectedShowTitle = $("#reportHead").val();
         //选项重复时的提示语
         var errorMsg = "${ctp:i18n('report.reportDesign.set.errorSumDataFieldSet')}";//行分类汇总
         //统计项设置中记录统计类型
         var staticsType = "";
         //汇总字段
         var classifyValue = $("#classifyValue").val();
         //汇总方式
         var summaryWay = $("#summaryWay").val();;
         //汇总项
         var summaryItem = $("#sumDataFieldSetNewTitleHidden").val();
         var dialog = $.dialog({
             id: id,
             url: url,
             width: width,
             height: height,
             targetWindow:getCtpTop(),
             title: title,
             transParams: {
                 selectedValue: selectedValue,
                 selectedShowTitle: selectedShowTitle,
                 staticsType: staticsType,
                 selectedValues: selectedValues,
                 selectedShowTitles: selectedShowTitles,
                 selectedNewShowTitles: selectedNewShowTitles,
                 staticsTypes: staticsTypes,
                 classifyValue:classifyValue,
                 summaryWay:summaryWay,
                 summaryItem:summaryItem,
                 sortColumnVal:sortColumnVal
             },
             buttons: [{
                 text: "${ctp:i18n('report.reportDesign.button.confirm')}",
                 isEmphasize: true,
                 handler: function () {
                 	 var returnObj = dialog.getReturnValue();
                     if(returnObj.classifyValue!=undefined&&returnObj.classifyValue!=""&&sortColumnVal.indexOf("dataList")!=-1){
    	 					$.alert("${ctp:i18n('report.reportDesign.sort.selectSumData')}");
    	 					return false;
    	 			}
                 	 if(returnObj.summaryValues != "" && returnObj.summaryValues != undefined){
					 	$("#sumDataField").val(returnObj.texts);
					 	$("#summaryWay").val(returnObj.summaryWay);
					 	$("#summaryWayTitle").val(returnObj.summaryWayTitle);
					 	$("#classifyValue").val(returnObj.classifyValue);
					 	$("#sumDataFieldSetHidden").val(returnObj.summaryValues);
					 	$("#sumDataFieldSetNewTitleHidden").val(returnObj.summaryTitles);
					 	dialog.close();  
					 	initShowTable();
                 	 }else{
                 	 	//$.alert("${ctp:i18n('report.reportDesign.dialog.chooseSummaryItem')}");
                 	 	$("#sumDataField").val("");
					 	$("#summaryWay").val("");
					 	$("#summaryWayTitle").val("");
					 	$("#classifyValue").val("");
					 	$("#sumDataFieldSetHidden").val("");
					 	$("#sumDataFieldSetNewTitleHidden").val("");
					 	dialog.close();
					 	initShowTable();
                 	 }
                 }
             }, {
                 text: "${ctp:i18n('report.reportDesign.button.cancel')}",
                 handler: function () {
                     dialog.close();
                 }
             }]
         });
    	
    }
    
    /**
     *打开dialog:排序设置
     */
     function openFormSortField(id, title, from) {
     	 var sortColumnVal=$("#reportHeadHidden").val();
     	 var sortColumnTitle=$("#reportHead").val();
     	 var staticType=$("#showDataListStaticsTypeHidden").val();
     	 var dataListTitle= $("#showDataList").val();
         var dataListVal= $("#showDataListHidden").val();
     	 var selectSortVal=$("#sortColumnVal").val();
     	 var selectSortTitle=$("#sortColumn").val();
     	 var sortCrossColumnTitle=$("#crossColumn").val();
         var sortCrossColumnVal=$("#crossColumnHidden").val();
         var sortCrossColumnDataType=$("#crossColumndDateTypeHidden").val();
     	 var columntype=$("#columntype").val();
     	 var sumDataField=$("#sumDataField").val();
     	 var classifyValue=$("#classifyValue").val();
     	 var url = url_reporDesign_selectFormField + "&from=" + from;
     	 var width = from == $("#setCrossColumn").attr("id") ? 450 : 590;
         var height = 400;
         var dialog = $.dialog({
             id: id,
             url: url,
             width: width,
             height: height,
             targetWindow:getCtpTop(),
             title: title,
             transParams: {
                 sortColumnVal:sortColumnVal,
                 sortColumnTitle:sortColumnTitle,
                 selectSortVal:selectSortVal,
                 selectSortTitle:selectSortTitle,
                 staticType:staticType,
                 dataListTitle:dataListTitle,
                 dataListVal:dataListVal,
                 sortCrossColumnTitle:sortCrossColumnTitle,
                 sortCrossColumnVal:sortCrossColumnVal,
                 sortCrossColumnDataType:sortCrossColumnDataType,
                 columntype:columntype,
                 sumDataField:sumDataField,
                 classifyValue:classifyValue
             },
             buttons: [{
                 text: "${ctp:i18n('report.reportDesign.button.confirm')}",
                 isEmphasize: true,
                 handler: function () {
                    var returnObj = dialog.getReturnValue();
                    sortColumnVal="";
                    sortColumnTitle="";
                    for(var i=0;i<returnObj.length;i++){
                    	if(returnObj[i].dataType!=undefined){
                    		if(returnObj[i].staticType!='undefined'){
                    			sortColumnVal+=returnObj[i].sortId+"|"+returnObj[i].sortType+"|"+returnObj[i].dataType+"|"+returnObj[i].staticType+",";
                    		}else{
                    			sortColumnVal+=returnObj[i].sortId+"|"+returnObj[i].sortType+"|"+returnObj[i].dataType+",";
                    		}
                    	}else{
                    		sortColumnVal+=returnObj[i].sortId+"|"+returnObj[i].sortType+",";
                    	}
                    	sortColumnTitle+=returnObj[i].sortTitle+",";
                    }
                    $("#sortColumnVal").val(sortColumnVal.substring(0,sortColumnVal.length-1));
                    $("#sortColumn").val(sortColumnTitle.substring(0,sortColumnTitle.length-1));
                    dialog.close();
                 }
             }, {
                 text: "${ctp:i18n('report.reportDesign.button.cancel')}",
                 handler: function () {
                     dialog.close();
                 }
             }]
         });
     }
     
    /**
     *打开dialog:统计分组项、统计项、交叉项
     */
     function openFormField(id, title, from) {
         //最后一行合计　获取统计项数据
         var selectedValues = $("#showDataListHidden").val();
         var selectedShowTitles = $("#showDataList").val();
         var selectedNewShowTitles = $("#showDataListNewTitleHidden").val();
         var staticsTypes = $("#showDataListStaticsTypeHidden").val(); //统计项类型
         var url = url_reporDesign_selectFormField + "&from=" + from;
         var width = from == $("#setCrossColumn").attr("id") ? 450 : 590;
         var height = 400;
         //记录已选择的项的关键字
         var selectedValue = "";
         //记录已选择的项的Name
         var selectedShowTitle = "";
         //记录修改后的标题(其中一个是统计分组项的标题另一个就是是统计项的标题)
         var selectedNewShowTitle = "";
         var selectedNewShowTitleOther = "";
         //交叉列的标题
         var selectedNewShowTitleCross = $("#crossColumn").val();
         //选项重复时的提示语
         var errorMsg = "";
         //判断重复时的基准数组
         var baseArray = new Array();
         //统计项设置中记录统计类型
         var staticsType = "";
         //分组统计项设置中日期控件统计类型
         var dateType = "";
         //列汇总和公式
         var formattype = "";
         var formulastr = "";
         var columntype = "";
         var j=0;
         var chartData =new Array(); 
         $("input[name^='chartData1']").each(function(){
         	chartData[j] = $(this).val();
         	j++;
         });
         j=0;
         var chartHead = new Array(); 
         $("input[name^='chartHead1']").each(function(){
         	chartHead[j] = $(this).val();
         	j++;
         });
         var formType = "${formBean.formType}";
         var enumchange = $("#enumchange").val();
         var isCross = $("input[name='acrossreport']:checked").val();// 是否是交叉统计
         var crossTypes = "";
     	 var chartChoiceData = "";
         if (from === $("#setReportHead").attr("id")) {
             selectedValue = $("#reportHeadHidden").val();
             selectedShowTitle = $("#reportHead").val();
             selectedNewShowTitle = $("#reportHeadNewTitleHidden").val();
             selectedNewShowTitleOther = $("#showDataListNewTitleHidden").val();
             dateType = $("#reportHeadDateTypeHidden").val();
             baseArray = baseArray.concat($("#showDataListHidden").val().split(","));
             baseArray = baseArray.concat($("#crossColumnHidden").val().split(","));
             errorMsg = "${ctp:i18n('report.reportDesign.set.errorSetReportHead')}";//统计项或交叉项
             var reportHeadFZ = $("#reportHead").val().split(",");
             var reportHeadHFZ = $("#reportHeadHidden").val().split(",");
             var chartChoiceDataFZ = "";
           	 $("input[name^='chartHeadHidden']").each(function(){
       			 	var temp = $(this).val().split(",");
       			 	if($(this).val()!=""){
	       				for(var i=0;i<temp.length;i++){
	        					for(var j=0;j<reportHeadFZ.length;j++){
	         					if(reportHeadFZ[j].indexOf(temp[i])>=0){
	                  				chartChoiceDataFZ = chartChoiceDataFZ + temp[i] +",";
	                  				break;
	                  			}
	      					}
	              		}
              		}
         	 });
             chartChoiceData =  chartChoiceDataFZ;
         } else if (from === $("#setShowDataList").attr("id")) {
             selectedValue = $("#showDataListHidden").val();
             selectedShowTitle = $("#showDataList").val();
             selectedNewShowTitle = $("#showDataListNewTitleHidden").val();
             selectedNewShowTitleOther = $("#reportHeadNewTitleHidden").val();
             baseArray = baseArray.concat($("#reportHeadHidden").val().split(","));
             baseArray = baseArray.concat($("#crossColumnHidden").val().split(","));
             staticsType = $("#showDataListStaticsTypeHidden").val();
             formattype = $("#formattype").val();
             formulastr = $("#formulastr").val();
             columntype = $("#columntype").val();
             crossTypes = $("#crossTypes").val();
             errorMsg = "${ctp:i18n('report.reportDesign.set.errorSetShowDataList')}";//统计分组项或交叉项
             var reportDataTJ = $("#showDataList").val().split(",");
             var reportDataHTJ = $("#showDataListHidden").val().split(",");
     		 var chartChoiceDataTJ = "";
           	 $("input[name^='chartDataHidden']").each(function(){
           	 		var temp = $(this).val().split(",");
           	 		if($(this).val()!=""){
           	 			for(var i=0;i<temp.length;i++){
	           	 			for(var j=0;j<reportDataTJ.length;j++){
		                  		if(reportDataTJ[j].indexOf(temp[i])>=0){
		                  			chartChoiceDataTJ = chartChoiceDataTJ + temp[i] +",";
		                  			break;
		                  		}
	               			}
           	 			}
           	 		}
         	 });
             chartChoiceData = chartChoiceDataTJ;
         } else if (from === $("#setCrossColumn").attr("id")) {
             selectedValue = $("#crossColumnHidden").val();
             selectedShowTitle = $("#crossColumn").val();
             dateType = $("#crossColumndDateTypeHidden").val();
             baseArray = baseArray.concat($("#showDataListHidden").val().split(","));
             baseArray = baseArray.concat($("#reportHeadHidden").val().split(","));
             errorMsg = "${ctp:i18n('report.reportDesign.set.errorSetCrossColumn')}";//统计分组项或统计项
         }
         if(!$.isNull(chartChoiceData)){
         	chartChoiceData = chartChoiceData.substring(0,chartChoiceData.length-1);
         	chartChoiceData =  encodeURI(encodeURI(chartChoiceData));
         }
         url = url+"&chartChoiceData="+chartChoiceData;
         var dialog = $.dialog({
             id: id,
             url: url,
             width: width,
             height: height,
             targetWindow:getCtpTop(),
             title: title,
             transParams: {
                 selectedValue: selectedValue,
                 selectedShowTitle: selectedShowTitle,
                 selectedNewShowTitle: selectedNewShowTitle,
                 selectedNewShowTitleOther: selectedNewShowTitleOther,
                 selectedNewShowTitleCross:selectedNewShowTitleCross,
                 dateType: dateType,
                 staticsType: staticsType,
                 selectedValues: selectedValues,
                 selectedShowTitles: selectedShowTitles,
                 selectedNewShowTitles: selectedNewShowTitles,
                 staticsTypes: staticsTypes,
         		 formattype:formattype,
         		 formulastr:formulastr,
         		 columntype:columntype,
         		 chartHead:chartHead,
         		 chartData:chartData,
         		 formType:formType,
         		 enumchange:enumchange,
         		 isCross:isCross,
         		 crossTypes:crossTypes
             },
             buttons: [{
                 text: "${ctp:i18n('report.reportDesign.button.confirm')}",
                 isEmphasize: true,
                 handler: function () {
                     var returnObj = dialog.getReturnValue();
                     if (returnObj != undefined && returnObj) {
                         var checkArray = returnObj.values.split(",");
                         var textArray = returnObj.texts.split(",");
	                         //判断统计分组项、统计项、交叉项不能重复选择
	                         var checkValue = "";
	                         var checkTitle = false;
	                         //有列汇总后就不能以checkArray为验证了
	                         if(from != "setShowDataList"){
	                         	checkValue = checkSelectedDouble(baseArray, checkArray, textArray);
	                         }else{
	                         	checkValue = checkSelectedDouble(baseArray, checkArray, returnObj.staticsType.split(","),textArray);
	                         }
	                         if(from == "setCrossColumn"){
	                         	if(!$.isNull(checkValue[0])){
	                             //合并统计分组项和统计项的标题
	                             var fields = $("#reportHeadHidden").val().concat(",",$("#showDataListHidden").val()).split(",");
	                         	 for(var i = 0;i < fields.length;i++){
	                         	 	if(checkArray[0] == fields[i]){//有标题相同
	                					checkTitle = true;
	                				}
	                         	 }
	                         	}
	                         }
	                         if (checkValue !== "" || checkTitle ) {
	                         	if(checkValue !== ""){
	                         	    //$.error("'" + checkValue + "' 在" + errorMsg + "中已经选择，不能再选!");
	                             	$.error(($.i18n('report.reportDesign.set.errorCheckValue',checkValue,errorMsg)));
	                         	}else{
	                         		$.error("${ctp:i18n('report.reportDesign.set.errorRepetition')}");
	                         	}
	                         } else {
	                             if(isInSameMainTable(returnObj.ownerTableName,from,returnObj.displayName )){
	                             	
	                                 if (from === "setReportHead") {
	                                     $("#reportHead").val(returnObj.texts);
	                                     $("#reportHeadHidden").val(returnObj.values);
	                                     $("#reportHeadNewTitleHidden").val(returnObj.newTitle);
	                                     $("#reportHeadDateTypeHidden").val(returnObj.dateType);
	                                     //如果选择的汇总项在分组项中移除，则清除汇总项
	                                     if(returnObj.values.indexOf($("#classifyValue").val()) == -1){
	                                     	$("#classifyValue").val("");
	                                     }
	                                     //修改名字后图里面的名字也要修改
	                                     var k=0;
	                                     $("input[name^='chartHead1']").each(function(){
	         								 $(this).val(returnObj.chartHead[k]);
	         								 k++;
	         							 });
	         							 k=0;
	         							 $("input[name^='chartHeadHidden']").each(function(){
	         								 $(this).val(returnObj.chartHead[k]);
	         								 k++;
	         							 });
	                                 } else if (from === "setShowDataList") {
	                                     $("#showDataList").val(returnObj.texts);
	                                     $("#showDataListHidden").val(returnObj.values);
	                                     $("#showDataListNewTitleHidden").val(returnObj.newTitle);
	                                     $("#showDataListStaticsTypeHidden").val(returnObj.staticsType);
	                                     
	                                     $("#formattype").val(returnObj.formattype);
	                                     $("#formulastr").val(returnObj.formulastr);
	                                     $("#columntype").val(returnObj.columntype);
	                                     $("#enumchange").val(returnObj.enumchange);
	                                     $("#crossTypes").val(returnObj.crossTypes);
	                                     if(returnObj.crossTypes.indexOf("cross") != -1){
	                                     	var sumDataFieldArr = $("#sumDataFieldSetHidden").val().split(",");
	                                     	var sumDataTitleArr = $("#sumDataFieldSetNewTitleHidden").val().split(",");
	                                     	var sumDataFieldStr = "";var sumDataTitleStr = "";
	                                     	for(var i=0;i<sumDataFieldArr.length;i++){
	                                     		if(sumDataFieldArr[i].indexOf("field") != -1){
	                                     			sumDataFieldStr = union(sumDataFieldStr,sumDataFieldArr[i]);
	                                     			sumDataTitleStr = union(sumDataTitleStr,sumDataTitleArr[i]);
	                                     		}
	                                     	}
	                                     	$("#sumDataFieldSetHidden").val(sumDataFieldStr);
	                                     	$("#sumDataFieldSetNewTitleHidden").val(sumDataTitleStr);
	                                     }
	                                     //修改名字后图里面的名字也要修改
	                                     var k=0;
	                                     $("input[name^='chartData1']").each(function(){
	         								 $(this).val(returnObj.chartData[k]);
	         								 k++;
	         							 });
	         							 k=0;
	         							 $("input[name^='chartDataHidden']").each(function(){
	         								 $(this).val(returnObj.chartData[k]);
	         								 k++;
	         							 });
	                                     screen();
	                                 } else if (from === "setCrossColumn") {
	                                	 var text = returnObj.texts;
	                                     text = text.substring(text.indexOf("]")+1);
	                                     $("#crossColumn").val(text);
	                                     $("#crossColumnHidden").val(returnObj.values);
	                                     $("#crossColumndDateTypeHidden").val(returnObj.dateType);
	                                 }
	                                 //updateSortColumn(returnObj,from);
	                                 deleteSortColum();
	                                 dialog.close();  
	                                 initShowTable();
                                 }
                             }
                         }
                 }
             }, {
                 text: "${ctp:i18n('report.reportDesign.button.cancel')}",
                 handler: function () {
                     dialog.close();
                 }
             }]
         });
     }
     //修改统计分组项，统计项，交叉项后 删除统计排序设置
     function deleteSortColum(){
     	//统计分组项或者统计项
    	$("#sortColumn").val("");
    	$("#sortColumnVal").val("")
     }
    //更新排序设置
    function updateSortColumn(returnObj,from){
    	var orderObjVal=returnObj.values;
    	var orderObjName=returnObj.texts;
    	var sortColumnVal=$("#sortColumnVal").val().split(",");
    	var sortColumnName=$("#sortColumn").val().split(",");
    	var newSortColumnVal="";
    	var newSortColumnName="";
    	if (from === "setReportHead"||from === "setShowDataList" || from === "setCrossColumn") {
    		//统计分组项或者统计项
    		$("#sortColumn").val("");
    		$("#sortColumnVal").val("");
    	}else{
    		//交叉项
    		for(var i=0;i<sortColumnVal.length;i++){
    			var order=sortColumnVal[i].split("|");
    			if(sortColumnVal[i].indexOf("crossData")!=-1){
    				if(orderObjVal.indexOf(order[0])!=-1){
    					//拥有
    					newSortColumnVal+=sortColumnVal[i]+",";
    					newSortColumnName+=sortColumnName[i]+",";
    				}
    			}else{
    				newSortColumnVal+=sortColumnVal[i]+",";
    				newSortColumnName+=sortColumnName[i]+",";
    			}
    		}
    	}
    	$("#sortColumnVal").val(newSortColumnVal.substring(0,newSortColumnVal.length-1));
    	$("#sortColumn").val(newSortColumnName.substring(0,newSortColumnName.length-1));
    }
    /**
     *图标设置删除图标事项，删除一个重复项
     */
    function delField(obj){
    	 var trs = $("tr",$("#fieldAreaContent"));
    	 if(trs.length>2){
    		  obj.parents("tr:eq(0)").remove();
    	 }else{
    	   $(obj).parents("tr:eq(0)").replaceWith($("body").data("reportChart").clone(true));
    	 }
    }
    
    /**
     *图标设置添加图标事项，添加一个重复项
     */
    function addField(obj){
    	var tr = $("body").data("reportChart").clone(true);
    	$(obj).parents("tr:eq(0)").after(tr);
    	initChartSetBtnClick();
    }

	function setEditState(){
		var queryFeidlSet = $("#saveForm");
		$("a[id!='setCrossColumn']",queryFeidlSet).removeClass("common_button_disable").removeClass("common_button").addClass("common_button");
		$(":disabled[id!='crossColumn']",queryFeidlSet).removeAttr("disabled");
		$("#reportName",queryFeidlSet).removeAttr("readonly");
		$("#description",queryFeidlSet).removeAttr("readonly");
	}
	function setInitState(index){
		$("#queryFieldSet").empty();
		$("#queryFieldSet").append($("body").data("queryDefine").clone(true));
		$("#chartFieldSet").empty();
		$("#chartFieldSet").append($("body").data("reportChartArea").clone(true));
		$("#saveQuery,#reset").addClass("common_button_disable");
		changeVal(index);
	}
	function newQuery(){
		setInitState();
		setEditState();
		initSetBtnClick();
		$("#statisticsC").removeAttr("disabled");
		//图表重复项
		$("body").data("reportChart",$("tr:eq(1)",$("#fieldAreaContent")).clone(true));
        //穿透设置选中
        $("#viewShow input[type='checkbox']").attr("checked", "checked");
	}
	//用于修改统计时初始化统计设置界面，这个不选中穿透设置，因为设置后会导致回填问题
	function newQueryForModify(index){
		setInitState(index);
		setEditState();
		initSetBtnClick();
		//图表重复项
		$("body").data("reportChart",$("tr:eq(1)",$("#fieldAreaContent")).clone(true));
	}
	function initGentRadio(){
		var gentRadio = $(":radio:checked","#queryFieldSet");
		if(gentRadio.length==1){
			if(gentRadio.val()=="1"){
				$("#viewShow").removeClass("hidden");
			}else{
				$("#viewShow").removeClass("hidden").addClass("hidden");
			}
		}
	}
	function initViewShow(){
		$(":checkbox","#queryFieldSet").each(function(){
			if($(this).is(':checked')){
				$("select",$(this).parents("tr:eq(0)")).removeAttr("disabled");
			}else{
				$("select",$(this).parents("tr:eq(0)")).removeAttr("disabled").attr("disabled",true);
			}
		});
	}

	
    $.fn.myclearform = function() {
	    var errorClassName = 'error-form';
	      this.find('.'+errorClassName).removeClass(errorClassName).each(function(i,e) {
	            var prt = $(e);
	            var es = prt.attrObj("errorIcon");
	            if(es){
	                prt.removeClass('error-form').next().remove();
	                prt.removeAttr("title");
	                prt.removeAttrObj("errorIcon");

	                  prt.css({
	                    'width' : ($(this).width() + 20) + 'px'
	                  });

	            }       
	   });
  }
	

	function initShowTitle(){
		$("#outName").text($("#reportName").val());
	}
	//预览
	function  initShowTable(){
	    initShowTitle();
		var jcTitle = $("#crossColumn").val();// 交差项信息
	    var headval = $("#reportHeadHidden").val().split(",");//统计分组项的字段
        var headtitle = $("#reportHeadNewTitleHidden").val().split(",");//统计分组项的名称,字段和名称数量是对应的
        
		var classifyValue = $("#classifyValue").val();//汇总字段
		var num = $.inArray(classifyValue,headval);//找到汇总字段在统计分组项字段的位置
        
        var showDataList = $("#showDataListNewTitleHidden").val();//统计项
        var showDatas = new Array(); // 统计项数组
        var countDatas = new Array();//计算列交叉 数组
        var crossTypes = $("#crossTypes").val();
		
        if(!$.isNull(crossTypes)){
        	var crossTypeArr = crossTypes.split(",");
        	var showDataArr = showDataList.split(",");
        	var j = 0;//  对应showDatas 下标
        	var k = 0;//  对应coumnDatas 下标
        	for(var i=0;i<crossTypeArr.length;i++){
        		if("cross" == crossTypeArr[i]){
        			countDatas[k++] = showDataArr[i];
        		}else{
        			showDatas[j++] = showDataArr[i];
        		}
        	}
        }else{
        	showDatas = showDataList.split(",");
        }
        var sumDatas=$("#sumDataFieldSetNewTitleHidden").val().split(",");//行汇总
		
		$("#showTd").empty();
        if(!$.isNull($("#reportHeadNewTitleHidden").val())|| !$.isNull(showDataList)){
			var title1="";var title2="";//标题 两行标题
			var nullhtml="";//空行 
			var subtotalhtml="";//小计汇总
			var sumhtml="";//最后一行合计
			var nullTd = "<td>&nbsp</td>"; var zeroTd = "<td>0</td>";
			if(!$.isNull($("#reportHeadNewTitleHidden").val())){
				for(var i=0;i<headtitle.length;i++){//分组项
					if($.isNull(jcTitle)){//没有有交叉项
						title1 += "<th rowspan='1'>"+headtitle[i]+"</th>";
					}else{
						title1 += "<th rowspan='2'>"+headtitle[i]+"</th>";
					}
					nullhtml += nullTd;
					if(!$.isNull($("#sumDataFieldSetNewTitleHidden").val())){
						var sumWay = "";
						var subtotalWay = "";
						var way = $("#summaryWay").val();
						if(way == "sum"){
							sumWay = "${ctp:i18n('report.reportDesign.total')}";
							subtotalWay = "${ctp:i18n('report.reportDesign.summarizing')}";
						}else if(way == "count"){
							sumWay = "${ctp:i18n('report.reportDesign.totalCount')}";
							subtotalWay = "${ctp:i18n('report.reportDesign.count')}";
						}else if(way == "avg"){
							sumWay = "${ctp:i18n('report.reportDesign.totalAvg')}";
							subtotalWay = "${ctp:i18n('report.reportDesign.avg')}";
						}else if(way == "max"){
							sumWay = "${ctp:i18n('report.reportDesign.totalMax')}";
							subtotalWay = "${ctp:i18n('report.reportDesign.max')}";
						}else if(way == "min"){
							sumWay = "${ctp:i18n('report.reportDesign.totalMin')}";
							subtotalWay = "${ctp:i18n('report.reportDesign.min')}";
						}
						if(i == num){
							subtotalhtml += "<td><label class='color_black font_bold' for='text'>"+headtitle[i]+"</label>&nbsp"+subtotalWay+"</td>";
							sumhtml += "<td>"+sumWay+"</td>";
						}else{
							subtotalhtml += nullTd;
							sumhtml += nullTd;
						}
					}
				}
			}
			if(!$.isNull(showDataList)){
				if($.isNull(jcTitle)){//没有有交叉项
					for(var j=0;j<showDatas.length;j++){ //统计项
						title1+="<th rowspan='1'>"+showDatas[j]+"</th>";
						nullhtml += nullTd;
						if($.inArray(showDatas[j],sumDatas) != -1){
							subtotalhtml += zeroTd;
							sumhtml += zeroTd;
						}else{
							subtotalhtml += nullTd;
							sumhtml += nullTd;
						}
					}
				}else{
					for(var m=0;m<2;m++){
						title1+="<th colspan='"+showDatas.length+"'>"+jcTitle+(m+1)+"</th>";
						for(var j=0;j<showDatas.length;j++){ //统计项
							title2+="<th>"+showDatas[j]+"</th>";
							nullhtml += nullTd;
							if($.inArray(showDatas[j],sumDatas) != -1){
								subtotalhtml += zeroTd;
								sumhtml += zeroTd;
							}else{
								subtotalhtml += nullTd;
								sumhtml += nullTd;
							}
						}
					}
					for(var n=0;n<countDatas.length;n++){
						title1+="<th colspan='"+showDatas.length+"'>"+countDatas[n]+"</th>";
						for(var j=0;j<showDatas.length;j++){ //统计项
							title2+="<th>"+showDatas[j]+"</th>";
							nullhtml += nullTd;
							if($.inArray(showDatas[j],sumDatas) != -1){
								subtotalhtml += zeroTd;
								sumhtml += zeroTd;
							}else{
								subtotalhtml += nullTd;
								sumhtml += nullTd;
							}
						}
					}
				}
			}
        
            var html="<table class='only_table edit_table' border='0' cellSpacing='0' cellPadding='0' width='100%'><thead><tr>"+title1+"</tr>";
			if(!$.isNull(crossTypes)){
				html += "<tr>"+title2+"</tr>";
			}
			html += "</thead><tbody><tr>"+nullhtml+"</tr>";
            if(!$.isNull($("#sumDataFieldSetNewTitleHidden").val())){//设置了 最后一行合计或者 行汇总
            	if(num >= 0){//没有设置汇总字段，就不显示汇总行
             		html += "<tr>"+subtotalhtml+"</tr>";
            	}
             	html += "<tr>"+sumhtml+"</tr>";
            }else{
            	html += "<tr>"+nullhtml+"</tr>";
            }
            html += "</tbody></table>";
            
            $("#showTd").html(html);
        }
	}
	//返回值拼接，以“,”隔开的字符串
    function union(_self, _new) {
        (_self == "") ? (_self = _new) : (_self = _self + "," + _new);
        return _self;
    }
	function selectAll(obj){
		if($(obj).attr("checked")){
			$(":checkbox","#queryBody").attr("checked",true);
		}else{
			$(":checkbox","#queryBody").attr("checked",false);
		}
	}
	function editQuery(queryId,isShowOnly){
// 		var o = new formQueryDesignManager();
//     	o.editQuery(queryId, {
//             success: function(obj){
//             	$("#queryFieldSet").fillform(obj);
//             	initViewShow();
//             	initGentRadio();
// 				initShowTitle();
// 				initShowTable();
// 				if(isShowOnly){
// 					viewShowDisabled();
// 				}
//             }
//         });
	}
  //统计列表查看
  function showReport(obj){
      $(obj).parent().parent().find("input").attr("checked",false);
      var obj = $(obj).parent().find("#reportId input");
      obj.attr("checked",true);
      var index = obj.val().split("*")[0];
      setInitState(index);
      cancelBtnClick();
      editReport(index,true);
      setTimeout("initShowTable()",500);
  }
  //ajax提取表单统计设置数据
  function editReport(index,isShowOnly){
      var formReportDesignManager_ = new formReportDesignManager();
      formReportDesignManager_.editReport(index, {
          success: function(obj){
              //回填图表数据
              var reportChart = obj.reportChart;
              $("body").data("reportChart",$("tr:eq(1)",$("#fieldAreaContent")).clone(true));
              for(var i = 0 ; i < reportChart.length - 1 ; i ++){
                  $("#addField").trigger("click");
              }
              for(var i = 0 ; i < reportChart.length ; i ++){
            	  //OA-37877. 
            	  if($("tr:eq("+ (i + 1) +")",$("#fieldAreaContent")).html() == undefined){
            		  $("tr:eq("+ i +")",$("#fieldAreaContent")).clone().appendTo($("tr:eq("+ i +")",$("#fieldAreaContent")).parent());
            	  }
                 $("tr:eq("+ (i + 1) +")",$("#fieldAreaContent")).fillform(reportChart[i]);
              }
              //OA-77373 默认都是勾选的，回填的时候，没有勾选的没有去掉，所有回填前，去掉全部勾选
              $("input","#viewShow").removeAttr("checked");
              $("#queryFieldSet").fillform(obj);
              //回填选择的字段所在子表的code，如果只有主表字段，值为空
              $("#mainTableCode").attr("summaryWay", obj.summaryWay);
              $("#mainTableCode").attr("summaryWayTitle", obj.summaryWayTitle);
              $("#mainTableCode").attr("classifyValue", obj.classifyValue);
              $("#mainTableCode").attr("reportHead", obj.reportHeadOwnerTable);
              $("#mainTableCode").attr("crossColumn", obj.crossColumnOwnerTable);
              $("#mainTableCode").attr("showDataList", obj.showDataListOwnerTable);
              $("#mainTableCode").attr("userCondition", obj.userConditionOwnerTable);
              $("#mainTableCode").attr("systemCondition", obj.systemConditionOwnerTable);
              $("#mainTableCode").attr("searchFieldList", obj.searchFieldListOwnerTable);
              $("#mainTableCode").attr("deeId", obj.deeId);
              $("#mainTableCode").attr("deeName", obj.deeName);
              if(!isShowOnly){
                if($("input[name='acrossreport']").eq(1).attr("checked")){
                  chooseCrossButton();
                }
              }else{
                if($("input[name='acrossreport']").eq(1).attr("checked")){
                  //协同V5.0 OA-19632
                  $("#iscross").show();
                }
              }
              var show = $("input","#viewShow");
              //是否允许穿透回填调整
              if($("input[name='gent']").eq(0).attr("checked")=="checked"){
                  $("#viewShow").show();
                  for(var i = 0; i < show.length; i ++){
                	  if(show.eq(i).attr("checked")!="checked"){
                		  $("#showAuth"+i).attr("disabled","disabled");
                	  }
                  }
              }else{
                  $("#viewShow").hide();
                   for(var i = 0; i < show.length; i ++){
                	 $("#view"+i).attr("checked","checked");
                   }
              }
          }
      });
  }
	function viewShowDisabled(){
		$("select","#queryFieldSet").removeAttr("disabled").attr("disabled",true);
	} 
	//自定义统计项设置回调
	function searchFieldCheck(result){
	    var tableName = "";
	    var text = "";
	    var value = "";
	    if (null != result && result.length > 0) {
	        for(var i = 0; i < result.length; i ++){
	            var key = result[i].key;
	            text += result[i].value + ",";
	            value += key + ",";
	            if(key.indexOf("formmain_") != -1){
	                continue;
	            } else {
	                var temp = key.substring(0, key.indexOf("."));
	                if(tableName == ""){
	                    tableName = temp;
	                } else if(tableName != temp&&!$.isNull(temp)) {//temp为空，选择的是系统数据域
	                    $.error("${ctp:i18n('report.reportDesign.set.errorNotInOneTable')}");
	                    return false;
	                }
	                if(tableName != "" && !isInSameMainTable(tableName, "searchFieldSet",result[i].value)){
                        return false;
                    }
	            }
	               
	            //自定义统计项设置时，如果选择了从表字段，且统计项，统计分组项，交叉项只选择了主表字段，返回false
	           /* if(tableName != "" && $("#mainTableCode").attr("reportHead") == "" && $("#mainTableCode").attr("crossColumn") == "" && $("#mainTableCode").attr("showDataList") == ""){
	                $("#mainTableCode").attr("searchFieldList","");
	                $.error("${ctp:i18n('report.reportDesign.set.errorNotInOneTable')}");//自定义统计项设置错误，与统计分组项、交叉项、统计项选择的字段不在同一个重复表中，请修改。
	                return false;
	            }*/

	        }
	    }
	    if(text.length>0){
	        text = text.substring(0,text.length-1);
	        value = value.substring(0,value.length-1);
	    }
	    $("#searchFieldList").val(text);
	    $("#searchFieldNameList").val(value);
	    return true;
	}
	
//打开图表设置界面
  function openReportChartDialog(_self){
    //当前行
    var curruntTr = $(_self).parents("tr:eq(0)");
	/*统计分组项*/
	var reportHeadSelected = new Object();
	//分组项 title
	reportHeadSelected.value = $("#reportHeadNewTitleHidden").val();
	reportHeadSelected.text = $("#reportHead").val();
	/*已选择的统计项*/
	var valueList = $("#showDataListNewTitleHidden").val().split(",");
	var textList = $("#showDataList").val().split(",");
	var corssTypeList = $("#crossTypes").val().split(",");
	var curSize = corssTypeList.length;
	if(corssTypeList.length <= textList.length){
		curSize = textList.length;
	}
	var valueStr = "";textStr = "";
	// 是否是交叉统计
	if("true" == $("input[name='acrossreport']:checked").val()){
		for(var i=0;i<curSize;i++){
			if("cross" != corssTypeList[i]){// 计算列交叉 不能设置成图表
				valueStr = union(valueStr, valueList[i]);
				textStr = union(textStr, textList[i]);
			}
		}
	}else{
		valueStr = $("#showDataListNewTitleHidden").val();
		textStr = $("#showDataList").val();
	}
	var showDataListSelected = new Object();
	//统计项 title
	showDataListSelected.value = valueStr;
	showDataListSelected.text = textStr;
	//if( !$.isNull($("#columnTitle").val()) ){//$("#columnTitle") 不知道是什么 能否注释
	//	showDataListSelected.value = showDataListSelected.value + "," + $("#columnTitle").val();
	//}
	
	//图表设置中，已选择的行和列
	var chartSelected = new Object();
	chartSelected.title = $("#chartName", curruntTr).val();
	chartSelected.headValue = $("#chartHeadHidden", curruntTr).val();
	chartSelected.headText = $("#chartHead", curruntTr).val();
	chartSelected.dataValue = $("#chartDataHidden", curruntTr).val();
	chartSelected.dataText = $("#chartData", curruntTr).val();
	var isAcross = $("input[name='acrossreport']").eq(1).attr("checked") == "checked";
    var dialog = $.dialog({
      id : 'reportChartDialog',
      url : url_reporDesign_setReportChartDialog,
      title : "${ctp:i18n('report.reportDesign.dialog.chartItem.set')}",
      width : 560,
      height : 450,
      targetWindow:getCtpTop(),
      transParams : {
    	  reportHeadSelected : reportHeadSelected,
    	  showDataListSelected : showDataListSelected,
    	  chartSelected : chartSelected,
    	  isAcross : isAcross
        },
      buttons : [ {
        text : "${ctp:i18n('report.reportDesign.button.confirm')}",
        isEmphasize: true,
        handler : function() {
          var returnObj = dialog.getReturnValue();
          if(returnObj.checkValue){
              //重名检查
              if(checkChartTitleDouble(returnObj.chartName, $("#chartName", curruntTr))){
                  $.error("${ctp:i18n('report.reportDesign.set.errorRepetitionChart')}");//图标名称重复，请重新输入！
              }else{
                  $("#chartName", curruntTr).val(returnObj.chartName);
                  $("#chartHead", curruntTr).val(returnObj.chartHeadValue);
                  $("#chartHeadHidden", curruntTr).val(returnObj.chartHeadValue);
                  $("#chartData", curruntTr).val(returnObj.chartDataValue);
                  $("#chartDataHidden", curruntTr).val(returnObj.chartDataValue);
                  dialog.close();
              }
          }
          
        }
      }, {
        text : "${ctp:i18n('report.reportDesign.button.cancel')}",
        handler : function() {
          dialog.close();
        }
      } ]
    });
  }
  //检查图表名称重复，如果有重复，返回true
  function checkChartTitleDouble(chartName, _self){
      var obj = $("input[name='chartName']");
      var returnValue = false;
      var modifyFlag = false;
      var count = 0;
      //修改图表设置，且没有改变标题
      if(_self.val() == chartName){
          modifyFlag = true;
      }
      for(var i = 0 ; i < obj.length ; i ++){
          if(obj.eq(i).val() == chartName){
              if(!modifyFlag){
                  returnValue = true;
                  break; 
              }else{
                  count = count + 1;
                  if(count > 1){
                      returnValue = true;
                      break; 
                  }
              }
          }
      }
      return returnValue;
  }
  /**
   *检查是否重复选择（统计分组项、交叉项、统计项）
   */
 function checkSelectedDouble(baseArray, checkArray, textArray,text){
	    var hash = {};
	    var returnValue = "";
	    if(checkArray.length === textArray.length){
	    	for(var j = 0; j < baseArray.length; j++){
	    		hash[baseArray[j]] = true;
	    	}
		    for(var i = 0; i < checkArray.length; i++){
		    	if(hash[checkArray[i]]){
		    		if(text == undefined){
		    			returnValue = textArray[i];
		    		}else{
		    			returnValue = text[i];
		    		}
		    		break;
		    	}
		    }
	    }else{
	    	 $.error("${ctp:i18n('report.reportDesign.set.errorData')}");//数据错误，请重新选择!
	    }
	    return returnValue;
 }
 //筛选最后一行统计信息
 function screen()
 {
     var sumdataFileds=$("#sumDataField").val();//获得最后一行合计值
     var showDataLists=$("#showDataList").val(); //获得选择项目的值
     
     var item1="",item2="",item3="",item4="";//最终结果
    if(sumdataFileds!=""&&showDataLists!=""){
        var lists=showDataLists.split(","); //选择项目的集合
        var listHiddens=$("#showDataListHidden").val().split(",");
        var listNewTitleHiddens=$("#showDataListNewTitleHidden").val().split(",");
        var listStaticsTypeHiddens=$("#showDataListStaticsTypeHidden").val().split(",");
        var fileds=sumdataFileds.split(",");//获得最后一行统计的集合
        var fsumDataFieldSetHiddens=$("#sumDataFieldSetHidden").val().split(",");
        var fsumDataFieldSetNewTitleHiddens=$("#sumDataFieldSetNewTitleHidden").val().split(",");
        
        for (var i=0;i<listHiddens.length;i++) { //循环选择项目的集合
            for(var j=0;j<fsumDataFieldSetHiddens.length;j++)
            {
                if(listHiddens[i]==fsumDataFieldSetHiddens[j])
                {
                   item1+=lists[i]+",";
                   item2+=listHiddens[i]+",";
                   item3+=listNewTitleHiddens[i]+",";
                   item4+=listStaticsTypeHiddens[i]+",";
                   break;
                }
            } 
       }
       if(!$.isNull($("#columnValues").val())){
       	var columnTitles = $("#columnTitle").val().split(",");
       	var columnValues = $("#columnValues").val().split(",");
       	for (var i=0;i<columnValues.length;i++) { 
            for(var j=0;j<fsumDataFieldSetHiddens.length;j++)
            {
                if(columnValues[i]==fsumDataFieldSetHiddens[j])
                {
                   item1+=columnTitles[i]+",";
                   item2+=columnValues[i]+",";
                   item3+=columnTitles[i]+",";
                   break;
                }
            } 
       	}
       }
        
    }
    if(item1!=""){
        $("#sumDataField").val(item1.substring(0,item1.length-1));
        $("#sumDataFieldSetHidden").val(item2.substring(0,item2.length-1));
        $("#sumDataFieldSetNewTitleHidden").val(item3.substring(0,item3.length-1));
    }else{
    	$("#classifyValue").val("");
    	$("#summaryWay").val("");
    	$("#summaryWayTitle").val("");
        $("#sumDataField").val("");
        $("#sumDataFieldSetHidden").val("");
        $("#sumDataFieldSetNewTitleHidden").val("");
    }
 }
//判断是否是同一个从表字段
 function isInSameMainTable(mainTable,from,name){
     var returnValue = false;
     if(from == "sumDataFieldSet"){
         returnValue = true;
     }else{
         var specific;
         if(from === "setReportHead"){
             specific = "reportHead";
         }else if(from === "setShowDataList"){
             specific = "showDataList";
         }else if(from === "setCrossColumn"){
             specific = "crossColumn";
         }else if(from === "userConditionSet"){
             specific = "userCondition";
         }else if(from === "systemConditionSet"){
             specific = "systemCondition";
         }else if(from === "searchFieldSet"){
             specific = "searchFieldList";
         }
         returnValue = isAllInOne(specific,name,mainTable);
     }
     return returnValue;
 }
 //检查数组元素值是否有为空，如果有不为空的，返回false，如果都为空，返回true
 function isAllInOne(specific,name,mainTable){
     var objArray = ["reportHead","crossColumn","showDataList","systemCondition","userCondition","searchFieldList"];
     var displayName = ["${ctp:i18n('report.reportDesign.dialog.groupingitem.title')}","${ctp:i18n('report.reportDesign.dialog.acrossreport.title')}",
                        "${ctp:i18n('report.reportDesign.dialog.staticsitem.title')}","${ctp:i18n('report.reportDesign.systemStatCondition.title')}",
                        "${ctp:i18n('report.reportDesign.sysUserInputCond.title')}","${ctp:i18n('report.reportDesign.userDefinedState.title')}"];
     var returnValue = true;
     var error = "";
     for(var i = 0; i < objArray.length; i ++){
         if(objArray[i] != specific && mainTable != "" &&
            $("#mainTableCode").attr(""+objArray[i]+"") != "" && 
            $("#mainTableCode").attr(""+objArray[i]+"") != mainTable){
             error = displayName[i];
             returnValue = false;
             break;
         }
     }
     if(!returnValue){
     	$.error($.i18n('report.reportDesign.set.errorFieldNotInOneTable', name, error));
     // $.error(name+"与"+error+"的字段不在同一个重复表中！");
     }else{
         $("#mainTableCode").attr(""+specific+"",mainTable);
     }
     return returnValue;
 }
 
 //协同V5.0 OA-12901
 function validateFormData(){
     //OA-18531
     //OA-30334 注释
     //OA-41475 2013-7-1修改 取消注释 by陈祥
     if(!$("#saveQuery").hasClass("common_button_disable") && ($("#reportHead").val() != "" || $("#crossColumn").val() != "" || $("#showDataList").val() != ""
   			|| $("#systemCondition").val() != "" || (typeof($("#userCondition").val())!='undefined'&& $("#userCondition").val() != "") || (typeof($("#userCondition").val())!='undefined'&& $("#searchFieldList").val() != "") || $("#description").val() != "")){
        $.alert("${ctp:i18n('report.reportDesign.dialog.prompt.saveQuery')}");//请先保存统计定义信息!
        return false;
     }
     return true;
 }

        function saveFormData(){

        }
 
	</script>
</html>
