<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../edocHeader.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
    var myBar;
	//================表单值处理，主要用于导出EXCEL的时候，导出的结果是上次查询的结果================
	
	//保存查询时候的表单值
	function saveOldFormValue(){
		document.getElementById("_oldEdocType").value	=document.getElementById("edocType").value;
		document.getElementById("_oldFlowState").value	=document.getElementById("flowState").value;
		document.getElementById("_oldBeginDate").value	=document.getElementById("beginDate").value;
		document.getElementById("_oldEndDate").value	=document.getElementById("endDate").value;
	}
	//========================================================表单值结束======
	
	function changeEdocType() {
		var edocType = searchForm.edocType.options[searchForm.edocType.selectedIndex].value;
		if (edocType == "0") {
			document.getElementById("div_flowstate").style.display = "";
		}
		else {
			document.getElementById("div_flowstate").style.display = "none";
		}
	}

	function doSearch() {
		searchForm.target = "top";
		searchForm.action = "${edocStat}?method=listQueryResult";
		saveOldFormValue();
		searchForm.submit();
	}

	// ????????????
	function edocStatPage() {		
		window.location.href = "${edocStat}?method=statCondition";		
	}	
	
	function exportQuery(){
		searchForm.action = "<c:url value='/edocStat.do'/>?method=exportQueryToExcel";
		searchForm.target = "temp_iframe";
		searchForm.submit();
	}
	function searchByself(){
		var b_date_obj = document.getElementById("beginDate");
		var e_date_obj = document.getElementById("endDate");
		var b_date = null;
		var e_date = null;
		if(b_date_obj && e_date_obj){
			b_date = b_date_obj.value;
			e_date = e_date_obj.value;
			if(b_date!=null && b_date!="" && e_date!=null && e_date!=""){
				var b = parseDate(b_date);
				var e = parseDate(e_date);
					if(e<b){
						alert(v3x.getMessage("edocLang.log_search_overtime"));
						return;
					}
			}
		}
		doSearch();
		myBar.enabled("edit");
	}
//-->
</script>
<style>
.toolbar-button-icon{
	margin-top:0;
}
.border_b {
	border-bottom: 1px solid #b6b6b6;
}
</style>
</head>
<body onload="changeEdocType();onLoadLeft()" style="overflow: hidden;" onunload="unLoadLeft()">

<table width="100%" border="0" height="100%" cellspacing="0" cellpadding="0">
	<tr>
		<td height="22">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td height="22">
						<script type="text/javascript">
							<!--
								myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />", "gray");
								<%--
								myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.refresh.label' bundle='${v3xCommonI18N}' />",  "location.reload();", [1,0], "", null));
								--%>
								myBar.add(new WebFXMenuButton("edit", "<fmt:message key='common.toolbar.exportExcel.label' bundle='${v3xCommonI18N}' />", "exportQuery();", [2,6], "", null));	
								document.write(myBar.toString());
								myBar.disabled("edit");
							//-->
						</script>
					</td>
					<td align="right" class="webfx-menu-bar-gray">
						<form id="searchForm" name="searchForm" method="post">
						
						<input type="hidden" id="_oldEdocType"  name="_oldEdocType" value="">
						<input type="hidden" id="_oldFlowState" name="_oldFlowState" value="">
						<input type="hidden" id="_oldBeginDate" name="_oldBeginDate" value="">
						<input type="hidden" id="_oldEndDate"   name="_oldEndDate" value="">
						
						<input type="hidden" id="flag" name="flag" value="1">
						<div class="div-float-right">
							<div class="div-float">								
								<select id="edocType" name="edocType" onchange="changeEdocType();" class="condition" style="margin-top:2px;">
								<c:if test="${v3x:hasPlugin('edoc')}"><!-- //安装edoc控件后才会有收发文管理功能-->
									<option value="0"><fmt:message key="edoc.stat.tables.send.label"/></option>
									<option value="1"><fmt:message key="edoc.stat.tables.recieve.label"/></option>
								</c:if>
									<option value="2"><fmt:message key="edoc.stat.tables.sign.label"/></option>
								<c:if test="${v3x:hasPlugin('doc')}">
									<option value="999"><fmt:message key="edoc.stat.tables.archive.label"/></option>
								</c:if>
								</select>
							</div>				
							<div id="div_flowstate" class="div-float">
								<select id="flowState" name="flowState" class="condition" style="margin-top:2px;">
									<option value="-1"><fmt:message key="edoc.stat.flowstat.label"/></option>
									<option value="0"><fmt:message key="edoc.stat.flowstat.running.label"/></option>
									<option value="3"><fmt:message key="edoc.stat.flowstat.sent.label"/></option>
								</select>
							</div>
							<div class="div-float">
								<input type="text" name="beginDate" id="beginDate" class="textfield" size="10" maxlength="10" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly> - <input type="text" name="endDate" id="endDate" class="textfield" size="10" maxlength="10" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
							</div>
							<div onclick="javascript:searchByself();" class="condition-search-button">
							</div>				
						</div>
						</form>
					</td>
				</tr>
			</table>
		</td>	
	</tr>
	<tr>
		<td>
			<div class="scrollList"  style="border-top:0px;overflow: hidden;">
				<iframe noresize frameborder="no" src="${edocStat}?method=statEntry" id="detailIframe" name="detailIframe" style="width:100%;height: 100%;" border="0px"></iframe>			
			</div>
			<div style="display:none">
				<iframe name="temp_iframe" id="temp_iframe">&nbsp;</iframe>
			</div>
		</td>
	</tr>
</table>
</html>