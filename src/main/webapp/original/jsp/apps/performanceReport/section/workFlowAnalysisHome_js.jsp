<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/isearch/css/isearch.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/templete.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
function resetData() {
	document.getElementById("beginDate").value="";
	document.getElementById("endDate").value="";
	document.getElementById("templeteName").value="";
	document.getElementById("templeteId").value="";
	document.getElementById("allTemplete").checked=true;
	document.getElementById("specTempleteDiv").style.display="none";
}

function submitData() {
	var beginDate = getDocValue("beginDate");
	var endDate = getDocValue("endDate");
	if (beginDate == "") {
		alert(v3x.getMessage("V3XLang.common_start_date_not_null_label"));
		return ;
	}
	if (endDate == "") {
		alert(v3x.getMessage("V3XLang.common_end_date_not_null_label"));
		return ;
	}
	
	// 日期跨年判断
	if (judgeOneYearDate(beginDate+"-1",endDate+"-1"))
		return ;
	
	document.getElementById("workflowForm").submit();
}

function hiddenTemplete() {
	document.getElementById("templeteName").style.display = "none";
}
function templateChooseCallback(id,name){
	$("#templeteName").css("display","block").val(name);
	$("#templeteId").val(id);
}
function selectTemplate(){
	var appType=$("#appType").val();
	if(appType==2){
 		templateChoose(templateChooseCallback,2,'','','maxScope');
	}else if(appType==1){
		templateChoose(templateChooseCallback,1,'','','maxScope');
	}else if(appType==4){
		templateChoose(templateChooseCallback,4,'','','maxScope'); 
	}
}
//-->
</script>
</head>
<body scroll="no" class="padding5">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="page-list-border">
	<tr >
		<td height="70">	
				<div class="portal-layout-cell ">		  	
					<div class="portal-layout-cell_head">
						<div class="portal-layout-cell_head_l"></div>
						<div class="portal-layout-cell_head_r"></div>
					</div>
				
					<table border="0" cellSpacing="0" cellPadding="0" width="100%" class="portal-layout-cell-right">
						<tr>
							<td class="sectionBodyBorder" align="center">
								<form method="post" id="workflowForm" name="workflowForm" target="dataIFrame" action="${path}/performanceReport/WorkFlowAnalysisController.do?method=comprehensiveAnalysiszListPage">
									<table width="100%" height="100%" border="0px" class="noWrap">
										<tr>
											<td width="10%" height="25px" class="sectionTitleLine sectionTitleLineBackground " align="left">
												<div>
													<div class="sectionTitleLeft"></div>
													<div class="sectionTitleMiddel">
														<div class="sectionTitleDiv">
															<span class="searchSectionTitle"><fmt:message key="common.statistic.conditions.label"/></span>
														</div>
													</div>
												</div>
											</td>
											<td width="12%" align="right"><fmt:message key="common.application.type.label" /> : </td>
											<td width="15%">
												<select name="appType" id="appType" style="width: 100%;">
												<c:if test="${(v3x:hasPlugin('form') && v3x:getSysFlagByName('sys_isGovVer')=='true') || v3x:getSysFlagByName('sys_isGovVer')!='true'}">
													<option value="2"><fmt:message key="application.2.label" bundle="${v3xCommonI18N}" /></option>
												</c:if>
													<option value="1"><fmt:message key="node.policy.collaboration" bundle="${v3xCommonI18N}" /></option>
													<option value="4"><fmt:message key="application.4.label" bundle="${v3xCommonI18N}" /></option>
												</select>
											</td>
											<td width="10%" align="right"><fmt:message key="common.template.process.label" /> : </td>
											<td width="30%" valign="middle">
												<div style="float: left;height: 25px;">
													<label for="allTemplete">
														<input type="radio" id="allTemplete" name="templete" onclick="hiddenTemplete();" checked="checked" value="1">
														<fmt:message key='common.all.templete.label' bundle='${v3xCommonI18N}'/>&nbsp;&nbsp;&nbsp;&nbsp;
													</label>
													<label for="chooseTemplete">
														<input type="radio" id="chooseTemplete" name="templete" onclick="selectTemplate()" value="2">
														<fmt:message key='common.the.specified.template.label' />
													</label>
												</div>
												<div id="specTempleteDiv" style="float: left;height: 25px;">
													<input type="text" id="templeteName" name="templeteName" title="" value="" onclick="selectTemplate()" readonly="readonly" style="width:98%;display: none;">
													<input type="hidden" id="templeteId" name="templeteId" value="">
												</div>
											</td>
											<td width="25%">&nbsp; </td>
										</tr>
										<tr>
											<td height="25px" ></td>
											<td align="right"><fmt:message key="common.endtime.label" /> : </td>
											<td >
												<c:set var="productUpgrageDate" value="${v3x:getProductInstallDate4WF() }" />
												 <input class="cursor-hand" type="text" name="beginDate" id="beginDate" validate="notNull" readonly="true" value='<fmt:formatDate value="${beginDate }" type="Date" dateStyle="full" pattern="yyyy-MM"/>'
												onclick="getChooseDate('${pageContext.request.contextPath}',this,'${productUpgrageDate }',true);" style="width: 46%"/>	
												<input class="cursor-hand" type="text" name="endDate" id="endDate" validate="notNull" readonly="true" value="${endDate }" value='<fmt:formatDate value="${endDate }" type="Date" dateStyle="full" pattern="yyyy-MM"/>'
												onclick="getChooseDate('${pageContext.request.contextPath}',this,'${productUpgrageDate }',true);" style="width: 46%"/>
											</td>
											<td ></td>
											<td align="left" nowrap="nowrap"></td>
											<td  nowrap="nowrap" colspan="0" align="left">
												<input type="button" onclick="submitData()" value='<fmt:message key='common.toolbar.statistics.label' bundle='${v3xCommonI18N}'/>' class="button-default-2">
												&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
												<input type="button" onclick="resetData()" value='<fmt:message key="common.button.reset.label" bundle="${v3xCommonI18N}" />' class="button-default-2">
											</td>
										</tr>
									</table>
								</form>
							</td>
						</tr>
					</table>
					<div class="portal-layout-cell_footer">
						<div class="portal-layout-cell_footer_l"></div>
						<div class="portal-layout-cell_footer_r"></div>
					</div>
				</div>  
			
		</td>
	</tr>
	<tr id="workflowDetail" >
	    <td colspan="5">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td>
	        <iframe src="${path}/performanceReport/WorkFlowAnalysisController.do?method=comprehensiveAnalysiszListPage" name="dataIFrame" id="dataIFrame"
	                frameborder="0" marginheight="0" marginwidth="0" height="100%" width="100%" scrolling="auto">
	        </iframe>
	    </td>
	    </tr>
	    </table>    
	    </td>
	</tr>
</table>
</body>
</html>