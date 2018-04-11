
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../edocHeader.jsp" %>
<fmt:setBundle basename="com.seeyon.v3x.isearch.resources.i18n.ISearchResources" var="isearchI18N"/>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/isearch/css/isearch.css${v3x:resSuffix()}" />">
<script type="text/javascript">
    /* if(getA8Top()!=null && typeof(getA8Top().showLocation)!="undefined") {  
    	getA8Top().showLocation(207);
    	getA8Top().hiddenNavigationFrameset();
    } */
    
    showCtpLocation("F07_edocSearch");
    
    var show="";
    //设置不显示增加外部单位连接
    var hiddenAddExternalAccount_mainSendToUnit = true;
    $(document).ready(function () {
		$("#deduplication").val(${isGourpBy});
		$("#isGourpBy").click(function(){
		    var isDedupCheck =  $("#isGourpBy:checked").size();
		    if (isDedupCheck != 0) {
		      	$("#deduplication").val("true");
		    } else {
		    	$("#deduplication").val("false");
			}
		    edocSearch();
		});
		//设置长度IE8下
		var browser=navigator.appName
		var b_version=navigator.appVersion
		var version=b_version.split(";");
		var trim_Version=version[1].replace(/[ ]/g,"");
		if(browser=="Microsoft Internet Explorer" && trim_Version=="MSIE8.0"){
			$("#edocType").css("width","137px");
			$("#docType").css("width","137px");
			$("#sendType").css("width","155px");
			$("#serialNo").css("width","155px");
			$("#sendUnit").css("width","155px");
			$("#sendDepartment").css("width","155px");
			//$("#createTimeB").css("width","67px");
		}
	});
	//保存查询时候的表单值
	function saveOldFormValue(){
		document.getElementById("_oldEdocType").value   =document.getElementById("edocType").value;
		document.getElementById("_oldSubject").value    =document.getElementById("subject").value;
		document.getElementById("_oldDocMark").value	=document.getElementById("docMark").value;
		document.getElementById("_oldSerialNo").value	=document.getElementById("serialNo").value;
		document.getElementById("_oldDocType").value	=document.getElementById("docType").value;
		document.getElementById("_oldSendType").value	=document.getElementById("sendType").value;
		document.getElementById("_oldCreatePerson").value=document.getElementById("createPerson").value;
		document.getElementById("_oldCreateTimeB").value=document.getElementById("createTimeB").value;
		document.getElementById("_oldCreateTimeE").value=document.getElementById("createTimeE").value;
		document.getElementById("_oldSendTo").value		=document.getElementById("sendTo").value;
		document.getElementById("_oldSendToId").value	=document.getElementById("sendToId").value;
		document.getElementById("_oldSendUnit").value	=document.getElementById("sendUnit").value;
		document.getElementById("_oldSendUnitId").value	=document.getElementById("sendUnitId").value;
		document.getElementById("_oldSendDepartment").value   =document.getElementById("sendDepartment").value;
		document.getElementById("_oldSendDepartmentId").value   =document.getElementById("sendDepartmentId").value;
		document.getElementById("_oldIssuer").value		=document.getElementById("issuer").value;
		document.getElementById("_oldSigningDateA").value=document.getElementById("signingDateA").value;
		//document.getElementById("_oldParty").value	=document.getElementById("party").value;
		//document.getElementById("_oldAdministrative").value	=document.getElementById("administrative").value;
	}
	
	
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
		searchForm.submit();
	}

	// ????????????
	function edocStatPage() {		
		window.location.href = "${edocStat}?method=statCondition";		
	}	
	 function selectdoctype(val){
		 var f = document.getElementById("administrative_f");

	        if(val=='0'){
	        	document.getElementById("administrative").style.display = "block";
	        	document.getElementById("party").style.display = "none";
	        	document.getElementById("party").value = "";
				f.style.display = "none";
	        }else if(val=='1'){
	        	document.getElementById("party").style.display = "block";
	        	document.getElementById("administrative").style.display = "none";
	        	document.getElementById("administrative").value = "";
				f.style.display = "none";
	        }else{
				f.style.display = "block";
				document.getElementById("party").style.display = "none";
				document.getElementById("administrative").style.display = "none";
			}
		 }

		//保存公文备考
	function saveRemark(){
		if(!checkForm(myform))
		return;//验证form
		
		var aId = myform.id.value;
		myform.action = "${edocStat}?method=saveEdocRemark&id=" + aId;
		myform.target = "empty";
		myform.submit();
	}
	function setMainSendUnitFields(elements){
		myform.sendTo.value=getNamesString(elements);
  		myform.sendToId.value=getIdsString(elements);
	}
	
	function setSendUnitFields(elements){
		myform.sendUnit.value=getNamesString(elements);  		
		myform.sendUnitId.value=getIdsString(elements);  		
	}
	
	function setSendDepartmentFields(elements){
		myform.sendDepartment.value=getNamesString(elements);  		
		myform.sendDepartmentId.value=getIdsString(elements);  		
	}
	
	function edocSearch(){
	  if(compareDate(myform.createTimeB.value,myform.createTimeE.value)>0)
	  {
	    alert(_("edocLang.begin_later_than_end_alert"));
	    return;
	  }
	  if(compareDate(myform.signingDateA.value,myform.signingDateB.value)>0){
	    alert(_("edocLang.issue_begin_later_than_end_alert"));
	    return;
	  }
		document.getElementById("outExecl").style.borderBottom="0px";
	
	  /*	
	  var customSearch = document.getElementById("customSearch");
	  var colId = "";
	  if(customSearch.checked){
	  	 colId = document.getElementById("displayCol").value;
	  }
	  
	  myform.action="${edoc}?method=listEdocSearchReult";
	  */

	  myform.action="${edoc}?method=listEdocSearchReult";
	  myform.target="dataIFrame";
	  saveOldFormValue();
	  myform.submit();
	  document.getElementById("show").value="1";
	}
	
	function resetForm(){
	  	myform.sendToId.value="";
	 	elements_mainSendToUnit="";
	  	elements_sendUnit="";
	  	elements_sendDepartment="";
	  	document.getElementById("edocType").value="1";
		document.getElementById("subject").value="";
		document.getElementById("docMark").value="";
		document.getElementById("serialNo").value="";
		document.getElementById("docType").value="";
		document.getElementById("sendType").value="";
		document.getElementById("createPerson").value="";
		document.getElementById("createTimeB").value="";
		document.getElementById("createTimeE").value="";
		document.getElementById("sendTo").value="";
		document.getElementById("sendToId").value="";
		document.getElementById("sendUnit").value="";
		document.getElementById("sendUnitId").value="";
		document.getElementById("sendDepartment").value="";
		document.getElementById("sendDepartmentId").value="";
		document.getElementById("issuer").value="";
		document.getElementById("signingDateA").value="";	  
		document.getElementById("signingDateB").value="";
		//document.getElementById("administrative").value="";
		//document.getElementById("party").value="";

		/*if(document.getElementById("administrative")){
			document.getElementById("administrative").options[0].selected = true;
		}
		if(document.getElementById("party")){
			document.getElementById("party").options[0].selected = true;
		}	*/
		if(document.getElementById("chechdoctype")){
			document.getElementById("chechdoctype").options[0].selected = true;
		}
		
		//修复bug GOV-3160 【公文管理】-【公文查询】，设置自定义查询后，点击'重置'，自定义查询不会被重置，而且点击查询后结果仍能按照自定义查询项显示
		document.getElementById("customSearch").checked=false;
		document.getElementById("displayColName").value="";
		document.getElementById("displayColName").style.display="none";
		document.getElementById("displayCol").value="";
	}

	//显示自定义查询输入框
	function viewDocSetting(obj){
		var t = document.getElementById("customQuery");
		var displayColInput = document.getElementById("displayCol");
		var displayColNameInput = document.getElementById("displayColName");
		if(obj.checked){
			t.style.display = "";//如果设为block,会换行显示
			if(displayColNameInput.style.display="none"){
				displayColNameInput.style.display="";
				displayColNameInput.value="<<fmt:message key='edoc.custom.type.msg' />>";
			}
		}else{
			t.style.display = "none";
			displayColInput.value="";
			displayColNameInput.value="<<fmt:message key='edoc.custom.type.msg' />>";
		}
		
	}

	//清空自定义查询选择框和输入框
	function clearDocSetting(){
		var displayColInput = document.getElementById("displayCol");
		var displayColNameInput = document.getElementById("displayColName");
		var customSearchInput=document.getElementById("customSearch");
		var t = document.getElementById("customQuery");
		customSearchInput.checked=false;
		displayColInput.value="";
		displayColNameInput.value="<<fmt:message key='edoc.custom.type.msg' />>";
		t.style.display = "none";
	}

	//显示自定义查询页面
	function openDocSetting(){
		var winWidth = 600;
		var winHeight = 400;
		var feacture = "dialogWidth:" + winWidth + "px; dialogHeight:" + winHeight + "px;";
		feacture = feacture + "directories:no; localtion:no; menubar:no; status:no;";
		feacture = feacture + "toolbar:no; scroll:no; resizeable:no; help:no";
		var displayCol = document.getElementById("displayCol").value;
		var nowEdocType=document.getElementById("edocType").value;
		var url = "${edoc}?method=openSearchEdocSetting&edocType="+nowEdocType+"&displayCol="+displayCol+"&date="+new Date().getTime();
		getA8Top().win123 = getA8Top().$.dialog({
			title:'<fmt:message key='edoc.custom.classification'/>',
			transParams:{'parentWin':window},
		    url   : url,
		    width : winWidth,
		    height  : winHeight,
		    resizable : "no"
		  });
	}
</script>
<script type="text/javascript">
	function exportQuery(){
		if(!dataIFrame.window.document.getElementById("colId")){
			alert("<fmt:message key='edoc.query.first'/>!");
			return;
		}
		var colId = window.frames["dataIFrame"].document.getElementById("colId").value;
		myform.action = "${edoc}?method=exportQueryToExcel&type=query&exportType=edocQuery&colId="+colId+"&show="+document.getElementById("show").value;;
		myform.target = "temp_iframe";
		myform.submit();
	}
</script>
<link rel="stylesheet" href="${path}/skin/default/skin.css" />
<style>
	input[type='text']{
		width:155px;
		height: 20px;
	}
	select{
		width:155px;
		height: 20px;
	}
	.sectionTitleLine {
		background:#FAFAFA;
	}
	.sectionTitleLine table{
		/*table-layout:fixed;*/
	}
	.sectionBody table{
		background: #FAFAFA;
	}
	.sectionBody {
		background: #FAFAFA;
	}
</style>
</head>
<body scroll="no" onload="onLoadLeft()" onunload="unLoadLeft()">
	<v3x:selectPeople id="mainSendToUnit" panels="Account,Department,ExchangeAccount,OrgTeam" selectType="Account,Department,ExchangeAccount,OrgTeam" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setMainSendUnitFields(elements)" viewPage="" minSize="0" maxSize="1" showAllAccount="true" />
	<v3x:selectPeople id="sendUnit" panels="Account,Department,ExchangeAccount,OrgTeam" selectType="Account,Department,ExchangeAccount,OrgTeam" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setSendUnitFields(elements)" viewPage="" minSize="0"  maxSize="1" showAllAccount="true" />
	<v3x:selectPeople id="sendDepartment" panels="Department" selectType="Department" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setSendDepartmentFields(elements)" viewPage="" minSize="0"  maxSize="1" showAllAccount="true" />
	<script>
		hiddenOnChanageAccountForExchangeAccount_mainSendToUnit=false;
		hiddenOnChanageAccountForOrgTeam_mainSendToUnit=false;
		hiddenOnChanageAccountForExchangeAccount_sendUnit=false;
		hiddenOnChanageAccountForOrgTeam_sendUnit=false;
		
		disabledAccountSelectorForOrgTeam_mainSendToUnit=false;
		disabledAccountSelectorForExchangeAccount_mainSendToUnit=false;
		disabledAccountSelectorForExchangeAccount_sendUnit=false;
		disabledAccountSelectorForOrgTeam_sendUnit=false;
	</script>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<!-- 
	<tr class="page2-header-line">
		<td width="100%" height="41" valign="top" class="">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     	<tr class="page2-header-line">
		        	<td width="45"><div class="bulltenIndex"></div></td>
			        <td class="page2-header-bg"><fmt:message key="edoc.stat.query.label"/></td>
			        <td class="page2-header-line page2-header-link" align="right"></td>
				</tr>
			</table>
		</td>
	</tr>
	 -->
	<tr>
		<td height="150">
			<!-- 查询条件设置 -->
			<form id="myform" name="myform" method="post" action="${edoc}?method=listEdocSearchReult" target="dataIFrame">
				<input type="hidden" id="deduplication" name="deduplication" value="" />
				<input type="hidden" name="_oldEdocType" id="_oldEdocType" value="">
				<input type="hidden" name="_oldSubject"  id="_oldSubject" value="">
				<input type="hidden" name="_oldDocMark" id="_oldDocMark" value="">
				<input type="hidden" name="_oldSerialNo" id="_oldSerialNo" value="">
				<input type="hidden" name="_oldDocType" id="_oldDocType" value="">
				<input type="hidden" name="_oldSendType" id="_oldSendType" value="">
				<input type="hidden" name="_oldCreatePerson" id="_oldCreatePerson"value="">
				<input type="hidden" name="_oldCreateTimeB" id="_oldCreateTimeB" value="">
				<input type="hidden" name="_oldCreateTimeE" id="_oldCreateTimeE" value="">
				<input type="hidden" name="_oldSendTo" id="_oldSendTo" value="">
				<input type="hidden" name="_oldSendToId" id="_oldSendToId" value="">
				<input type="hidden" name="_oldSendUnit" id="_oldSendUnit" value="">
				<input type="hidden" name="_oldSendUnitId" id="_oldSendUnitId" value="">
				<input type="text" style="display:none;" name="_oldSendDepartment" id="_oldSendDepartment" value="">
				<input type="hidden"   name="_oldSendDepartmentId" id="_oldSendDepartmentId" value="">
				<input type="hidden" name="_oldIssuer" id="_oldIssuer" value="">
				<input type="hidden" name="_oldSigningDateA" id="_oldSigningDateA" value="">
			   	<!-- wangwei start -->
				<input type="hidden" name="_oldParty" id="_oldParty" value="">
			    <input type="hidden" name="_oldAdministrative" id="_oldAdministrative" value="">
		   		<!-- wangwei end-->
				<input type="hidden" name="show" id="show" value="">
				<div class="portal-layout-cell " style="margin:0">
					<div class="portal-layout-cell_head">
						<div class="portal-layout-cell_head_l"></div>
						<div class="portal-layout-cell_head_r"></div>
					</div>
					
					<table border="0" cellSpacing="0" cellPadding="0" width="100%" class="portal-layout-cell-right">
						<tr>
							<td class="sectionBody sectionBodyBorder" align="center" style="background:#FAFAFA;">
								<TABLE width="100%" cellspacing="0" cellpadding="0" border="0" style="background:#FAFAFA;">
									<tr>
										<td style="padding-top:2px;padding-left:5px;" valign="top"><fmt:message key='edoc.custom.querycondition'/> ：</td></tr>
									<TR>

										<TD VALIGN="top" align="center">
											<TABLE cellspacing="0" border="0" style="margin: auto;background:#FAFAFA;">
												<TR style="height:22px;">
													<%--类别 --%>
												  <TD align="right"><fmt:message key='edoc.sorttype.label'/>:</TD>
												  <TD colspan="4" align="left">
												  	<select name="edocType" id="edocType" onChange="clearDocSetting();">
												  		<%--全部 --%>
												  		<option value="3"><fmt:message key='exchange.element.total'/></option>
														<option value="0"><fmt:message key='edoc.docmark.inner.send'/></option>
														<option value="1" selected="selected"><fmt:message key='edoc.docmark.inner.receive'/></option>
													  	<option value="2"><fmt:message key='edoc.docmark.inner.signandreport'/></option>
													</select>
												  </TD>
											  	</TR>
												<TR style="height:22px;">
													<%--公文标题--%>	
												  	<TD align="right"><fmt:message key='edoc.element.subject'/>:</TD>
												  	<TD width="180px" align="left"><input type="text" name="subject" id="subject" style="width: 155px;"></TD>
												  	<%-- 内部文号 --%>	
												  	<TD align="right"><fmt:message key='edoc.element.wordinno.label'/>:</TD>
												  	<TD align="left"><input type="text" name="serialNo" id="serialNo"  style="width: 155px;"></TD>
												  	<TD width="30px">&nbsp;</TD>
											  	</TR>
												<TR style="height:22px;">
													<%-- 公文文号 --%>
												  	<TD align="right"><fmt:message key='edoc.element.wordno.label'/>:</TD>
												  	<TD align="left"><input type="text" name="docMark" id="docMark"  style="width: 155px;"></TD>
												  	<%-- 行文类型 --%>
												  	<TD align="right"><fmt:message key='edoc.element.sendtype'/>:</TD>
												  	<TD align="left">
														<select name="sendType" id="sendType">
															<option value="" selected><fmt:message key='common.pleaseSelect.label'/></option>
															<v3x:metadataItem metadata="${sendTypeMetadata}" showType="option" name="sendType" bundle="${colI18N}" switchType="zhangh"/>
														</select>
												  	</TD>
												  <TD >&nbsp;</TD>
											  	</TR>
												<TR style="height:22px;">
												  <!-- wangwei start -->
												  <%-- 公文种类 --%>
												  <TD align="right"><fmt:message key='edoc.element.doctype'/>:</TD>
												  <TD align="left">
												  	<table cellspacing="0" cellpadding="0">
														<tr>
															<td align="left">
																<select id="docType" name="docType" style="width:155px;" >
													   				<option value="" selected><fmt:message key='common.pleaseSelect.label'/></option>
																	<v3x:metadataItem metadata="${edocTypeMetadata}" showType="option" name="docType" bundle="${colI18N}" switchType="zhangh" />
																</select>
															</td>
															<td align="left">
															</td>
														</tr>
													  </table>
												  </TD>
												  <!-- wangwei end -->
												  <%-- 发起日期 --%>
													<TD align="right"><fmt:message key='edoc.supervise.serach.startdate'/>:</TD>					
													<TD align="left">
														<input type="text" name="createTimeB" id="createTimeB"readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" style="width:75px;">-<input  style="width:75px;" type="text" name="createTimeE" id="createTimeE" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);">
													</TD>
													<TD >&nbsp;</TD>
												</TR>
												<TR style="height:22px;">
													<%-- 拟稿人--%>
													<TD align="right"><fmt:message key='edoc.element.author'/>:</TD>
													<TD align="left"><input type="text" name="createPerson" id="createPerson"  style="width: 155px;"></TD>
													<%-- 发文单位--%>
													<TD align="right"><fmt:message key='edoc.element.sendunit'/>:</TD>					
													<TD align="left"><input type="text" name="sendUnit"  id="sendUnit" onClick="selectPeopleFun_sendUnit();"></TD>
													<TD align="left"><input type="hidden" name="sendUnitId"  id="sendUnitId" ></TD>
													<TD >&nbsp;</TD>
												</TR>
												<TR style="height:22px;">
													<%-- 主送单位--%>
													<TD align="right"><fmt:message key='edoc.element.sendtounit'/>:</TD>
													<TD align="left"><input type="text" name="sendTo" id="sendTo" readonly="readonly" onClick="selectPeopleFun_mainSendToUnit();"  style="width: 155px;"><input type="hidden" name="sendToId"  id="sendToId"></TD>
													<%-- 发文部门--%>
													<TD align="right"><fmt:message key='edoc.element.senddepartment'/>:</TD>					
													<TD align="left"><input type="text" name="sendDepartment"  id="sendDepartment" onClick="selectPeopleFun_sendDepartment();"></TD>
													<TD align="left"><input type="hidden" name="sendDepartmentId"  id="sendDepartmentId" ></TD>
													<TD  align="left">&nbsp;</TD>
												</TR>	
												<TR style="height:22px;">
													<%-- 签发人--%>
													<TD align="right"><fmt:message key='edoc.element.issuer'/>:</TD>
													<TD align="left"><input type="text" name="issuer" id="issuer"  style="width: 155px;"></TD>
													<%-- 签发日期--%>
													<TD align="right"><fmt:message key='edoc.element.sendingdate'/>:</TD>					
													<TD align="left"><input type="text" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" name="signingDateA" id="signingDateA" style="width:75px;">-<input type="text" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" name="signingDateB" id="signingDateB" style="width:75px;"></TD>
													<TD >&nbsp;</TD>
												</TR>
												<TR style="height:22px;">
													<TD><label><input type="checkbox" onClick="viewDocSetting(this);" style="vertical-align:middle;width:19px;height:19px;" id="customSearch"/>&nbsp;<fmt:message key="edoc.custom.query" /></label></TD>
													<TD colspan="4">
														<span id="customQuery" style="display:none;">
															<input id="displayColName"  type="text" onClick="openDocSetting();" value="&lt;<fmt:message key="edoc.custom.type.msg" />&gt;" style="width:92.5%; border: 1px solid #CCC;cursor:pointer;"/>
														</span>
														<input type="hidden" name="displayCol" id="displayCol">	
													</TD>
												</TR>
												<TR style="height:28px;valign:top">
													<TD colspan="5" align="center">
														<input type="button" style="width:50px;border-top-width:0px;" class="button-default_emphasize" name="btn" onClick="edocSearch();" value="<fmt:message key='common.search.label'/>">&nbsp;&nbsp;&nbsp;&nbsp;
														<input type="button" style="width:50px;border-top-width:0px;" class="button-default-2" onClick="resetForm()"  name="btn" value="<fmt:message key='common.reset.label'/>">&nbsp;
													</TD>
												</TR>					
											</TABLE>			
										</TD>				
									</TR>			
								</TABLE>
							</td>
						</tr>
					</table>
					<div class="portal-layout-cell_footer">
						<div class="portal-layout-cell_footer_l"></div>
						<div class="portal-layout-cell_footer_r"></div>
					</div>
				</div>  	
			</form>
		<!-- 查询条件设置结束 -->
		</td>
	</tr>
	<tr>
		<td id="outExecl" height="20" valign="top" style="border-top: 1px solid #e3e3e3;border-bottom: 1px solid #e3e3e3;">
			<div class="portal-layout-cell" style="margin:0;">
				<div class="portal-layout-cell_head">
					<div class="portal-layout-cell_head_l"></div>
					<div class="portal-layout-cell_head_r"></div>
				</div>
				<table border="0" cellSpacing="0" align="left" cellPadding="0" width="100%" class="portal-layout-cell-right">
					<tr>
						<td class="sectionTitleLine" width="200">
							<span class="padding_l_10"><fmt:message key="isearch.jsp.list.result" bundle="${isearchI18N}"/>: <span class="ico16 export_excel_16"></span><a href="javascript:exportQuery()"> <fmt:message key='common.toolbar.exportExcel.label' bundle='${v3xCommonI18N}' /></a></span>
						</td>
						<%-- 同一流程只显示最后一条 --%>
						<td class="sectionTitleLine padding_l_5 ">
							<label class="isGourpBy"><input style="width: 20px;" type="checkbox" ${isGourpBy=="true"?'checked="checked"' : '' } name="isGourpBy" id="isGourpBy" value="1" /><fmt:message key="edoc.list.isGroupBy" /></label>
						</td>
					</tr>
				</table>
			</div> 
		</td>
	</tr>
	<tr>
		<td align="center" style="padding:0 4px 0px 2px;background:#FAFAFA;">
			<IFRAME height="100%"  name="dataIFrame" id="dataIFrame" width="100%" frameborder="0"></IFRAME>
		</td>
	</tr>
</table>
	<iframe name="temp_iframe" id="temp_iframe"  style="display:none;">&nbsp;</iframe>
</body>
</html>