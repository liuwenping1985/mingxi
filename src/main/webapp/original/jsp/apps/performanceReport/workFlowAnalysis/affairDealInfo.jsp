<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="header.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../../common/INC/noCache.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<title>节点分析</title>
<script type="text/javascript">
<!--
var baseUrl='${path}';
function openNodeAccessDetailWindow(id, policyName, memberName, overRadio, avgRunWorkTime) {
	var templeteId = parent.document.getElementById("templeteId").value;
	var beginDate = parent.document.getElementById("beginDate").value;
	var endDate = parent.document.getElementById("endDate").value;
	
	getA8Top().v3x.openWindow({
        url: encodeURI("workFlowAnalysis.do?method=nodeAnalysiszNodeAccessFrame&templeteId="+templeteId+"&nodeId="+id
        		+"&policyName="+policyName+"&memberName="+memberName+"&beginDate="+beginDate+"&endDate="+endDate
        		+"&overRadio="+overRadio+"&avgRunWorkTime="+avgRunWorkTime),
        dialogType : v3x.getBrowserFlag('openWindow') == true ? "modal" : "1",
        width: "750",
        height: "500"
    });
}

function openNodeNameDetailWindow(id,memberName) {
	var templeteId = parent.document.getElementById("templeteId").value;
	var beginDate = parent.document.getElementById("beginDate").value;
	var endDate = parent.document.getElementById("endDate").value;
	
	getA8Top().v3x.openWindow({
        url: encodeURI("workFlowAnalysis.do?method=nodeAnalysiszNodeNameFrame&templeteId="+templeteId+"&nodeId="+id+"&beginDate="
        		+beginDate+"&endDate="+endDate+"&memberName="+memberName),
        dialogType : v3x.getBrowserFlag('openWindow') == true ? "modal" : "1",
        width: "750",
        height: "500"
    });
}

function exportNodeExcel() {
	var templeteId="${templeteId}";
	var createDate="${createDate}";
	var objectId="${objectId}";
	var subject="${subject}";
	var searchForm = document.getElementById("searchForm");
	searchForm.action = ""+baseUrl+"/performanceReport/WorkFlowAnalysisController.do?method=exportAffairDealInfo&templeteId="+templeteId+"&createDate="+createDate+"&objectId="+objectId+"&subject="+subject;
	searchForm.target = "temp_iframe";
	searchForm.submit();
}

function showDigarm() {
	var templeteId="${templeteId}";
	if (templeteId == "") {
		$.error(v3x.getMessage("V3XLang.common_select_templete_process_label"));
		return ;
	}
	$.post(""+baseUrl+"/performanceReport/WorkFlowAnalysisController.do?method=viewWorkflow",{templeteId:templeteId},function(data){
		var ptemplateId=data;
		showWFTDiagram(parent.window,ptemplateId,window);
	});
}
//-->
</script>
</head>
<body>
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
    	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="9">
						<div class="portal-layout-cell ">		  	
							<form id="searchForm" action="" method="post">
								<input type="hidden" id="templeteId" name="templeteId" value=""/>
								<input type="hidden" id="beginDate" name="beginDate" value=""/>
								<input type="hidden" id="endDate" name="endDate" value=""/>
							</form>
							<table border="0" cellSpacing="0" cellPadding="0" width="100%" class="portal-layout-cell-right">
								<tr>
									<td class="sectionTitleLine sectionTitleLineBackground">
										<span class="searchSectionTitle text-bold"><c:out value="${subject }"></c:out></span>
									</td>
									<td align="right">
										<table>
											<tr>
												<td nowrap>
													&nbsp;&nbsp;&nbsp;
												</td>
												<td nowrap>
													<span class="icon_com display_block flow_com margin_r_5" onclick="showDigarm()"></span>
												</td>
												<td nowrap>
													<a onclick="showDigarm()"><fmt:message key='common.view.the.processflow.label' /></a>&nbsp;&nbsp;&nbsp;&nbsp;
												</td>
												<td nowrap>
													<span id="ExcportExcel1Div" title="<fmt:message key='common.export.excel' bundle='${v3xCommonI18N}' />" style="width: 16px; height: 16px; display: block;" class="download_com cursor-hand margin_r_5" onclick='javascript:exportNodeExcel()'></span>			
												</td>
												<td nowrap>
													<a onclick="exportNodeExcel()"><fmt:message key='common.export.excel' bundle='${v3xCommonI18N}' /></a>&nbsp;&nbsp;&nbsp;&nbsp;
												</td>
												<td nowrap>
													<span id="printButton1Div" title="<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />" class="ico16 print_16 margin_r_5" style="display: block;" onclick='popprint()'></span>
												</td>
												<td nowrap>
													<a onclick="popprint()"><fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' /></a>
												</td>
												<td width="10">
													&nbsp;
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</div>  
				</td>
			</tr>
		</table>
    </div>
    <div class="center_div_row2" id="scrollListDiv"  >
    	<form method="get" >
			<div id="dataListDiv">
				<v3x:table width="100%" htmlId="dataListTable"	data="${affairs}" var="affair" isChangeTRColor="false" className="sort ellipsis" >
					<v3x:column width="25%" type="String" label="common.deal.people.label" alt="${affair.memberId}" >
							${ctp:showMemberNameOnly(affair.memberId)}</v3x:column>
					<v3x:column width="25%" type="String" label="common.node.access.label">
						${affair.nodePolicy}</v3x:column>
					<v3x:column width="25%" type="String" label="common.processing.status.label" >
						${affair.state}</v3x:column>
					<v3x:column width="25%" type="String" label="common.initate.or.receive.time.label">
						${affair.receiveTime }</v3x:column>	
					<v3x:column width="24%" type="String" label="common.processing.time.label" >
						${affair.overTime}</v3x:column>
					<v3x:column width="24%" type="String" label="common.handling.time.label" >
						${v3x:showDateByNature(affair.runWorktime)}</v3x:column>
					<v3x:column width="24%" type="String" label="common.processing.period.label" >
						${v3x:showDateByNature(affair.deadlineDate)}</v3x:column>
					<v3x:column width="24%" type="String" label="common.timeouts.label" >
						${v3x:showDateByNature(affair.overTime)}</v3x:column>
				</v3x:table>
			</div>
		</form>
    </div>
  </div>
</div>
<iframe name="temp_iframe" id="temp_iframe" style="display:none;">&nbsp;</iframe>
</body>
</html>