<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%@ include file="/WEB-INF/jsp/common/myHeader.jsp" %>
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

    showCtpLocation("F20_search");
    var show="";
    var layout;
    //设置不显示增加外部单位连接
    var hiddenAddExternalAccount_mainSendToUnit = true;
    $(document).ready(function () {
    	layout = $("#layout").layout();
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
			$("#serialNo").css("width","235px");
			$("#sendUnit").css("width","235px");
			$("#sendDepartment").css("width","235px");
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
	  if(myform.recieveDateB && myform.recieveDateE){
		  if(compareDate(myform.recieveDateB.value,myform.recieveDateE.value)>0)
		  {
		    alert(_("edocLang.receivedate_begin_later_than_end_alert"));
		    return;
		  }
	  }
	  if(myform.registerDateB && myform.registerDateE){
		  if(compareDate(myform.registerDateB.value,myform.registerDateE.value)>0)
		  {
		    alert(_("edocLang.registetime_begin_later_than_end_alert"));
		    return;
		  }
	  }
	  if(myform.packdateB && myform.packdateE){
		  if(compareDate(myform.packdateB.value,myform.packdateE.value)>0)
		  {
		    alert(_("edocLang.packdate_begin_later_than_end_alert"));
		    return;
		  }
	  }
	  if(myform.copies){
		  if(isNaN(myform.copies.value))
		  {
		    alert(_("edocLang.edoc_print_validate"));
		    return;
		  }
	  }
	  if(compareDate(myform.signingDateA.value,myform.signingDateB.value)>0){
	    alert(_("edocLang.issue_begin_later_than_end_alert"));
	    return;
	  }
		document.getElementById("outExecl").style.borderBottom="0px";
		//BDGW-1814公文管理 > 公文查询 界面，查询字段填写内容应该限制长度
		var inputs = $(myform).find("input");
		for(var i=0;i<inputs.length;i++){
			if($(inputs[i]).val().length>1000){
				alert("查询条件输入内容超过限制，请检查输入内容长度！")
				return ;
			}
		}
	  /*
	  var customSearch = document.getElementById("customSearch");
	  var colId = "";
	  if(customSearch.checked){
	  	 colId = document.getElementById("displayCol").value;
	  }
	  
	  myform.action="${edoc}?method=listEdocSearchReult";
	  */

	  var displayCol = $("#displayCol").val();
	  myform.action="${edoc}?method=listEdocSearchReult&app=4&displayCol=" + displayCol;
	  myform.target="dataIFrame";
	  saveOldFormValue();
	  myform.submit();
	  document.getElementById("subject").focus();
	  document.getElementById("show").value="1";
	}
	
function resetForm(){
	  	myform.sendToId.value="";
	 	elements_mainSendToUnit="";
	  	elements_sendUnit="";
	  	elements_sendDepartment="";
	  	document.getElementById("edocType").value="402";
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
		document.getElementById("addCondition").value="";
		document.getElementById("addConditionTd").innerHTML="";
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
		var url = "${edoc}?method=openSearchEdocSetting&edocType="+nowEdocType+"&displayCol="+displayCol+"&date="+new Date();
		getA8Top().win123 = getA8Top().$.dialog({
			title:'<fmt:message key='edoc.custom.classification'/>',
			transParams:{'parentWin':window},
		    url   : url,
		    width : winWidth,
		    height  : winHeight,
		    resizable : "no"
		  });
	}
	function selectPeopleFun_undertakenoffice(){
		var par = new Object();
		par.value = $("#undertakenofficeId").val();
		par.text = $("#undertakenoffice").val();
    	$.selectPeople({
            panels: 'Account,Department',
            selectType: 'Account,Department',
            hiddenPostOfDepartment:true,
            isNeedCheckLevelScope:false,
            showAllOuterDepartment:true,
            params : par,
            minSize:0,
            callback : function(ret) {
              $("#undertakenofficeId").val(ret.value);
              $("#undertakenoffice").val(ret.text);
            }
          });
	}
	function selectPeopleFun_printUnit(){
		var par = new Object();
		par.value = $("#printUnitId").val();
		par.text = $("#printUnit").val();
    	$.selectPeople({
            panels: 'Account,Department',
            selectType: 'Account,Department',
            hiddenPostOfDepartment:true,
            isNeedCheckLevelScope:false,
            showAllOuterDepartment:true,
            params : par,
            minSize:0,
            callback : function(ret) {
              $("#printUnitId").val(ret.value);
              $("#printUnit").val(ret.text);
            }
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
	function openConditionSetting(){
		var winWidth = 600;
		var winHeight = 400;
		var feacture = "dialogWidth:" + winWidth + "px; dialogHeight:" + winHeight + "px;";
		feacture = feacture + "directories:no; localtion:no; menubar:no; status:no;";
		feacture = feacture + "toolbar:no; scroll:no; resizeable:no; help:no";
		var addCondition = document.getElementById("addCondition").value;
		var nowEdocType=document.getElementById("edocType").value;
		var url = "${edoc}?method=openConditionSetting&edocType="+nowEdocType+"&addCondition="+addCondition+"&date="+new Date()+"&app=4&operate=openConditionSetting";
		getA8Top().win123 = getA8Top().$.dialog({
			title:'<fmt:message key='edoc.custom.conditionSetting'/>',
			transParams:{'parentWin':window},
		    url   : url,
		    width : winWidth,
		    height  : winHeight,
		    resizable : "no"
		  });
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
	#searchCondition td{
	    padding: 3px 3px 3px 10px;
	}
	#searchCondition tr{
	    height:24px;
	}
	#searchCondition select{
	    height:27px!important;
	    width:236px!important;
	    background-color: #FFFFFF;
	    border: 1px solid #CCCCCC;
	    box-shadow: 0 1px 1px rgba(0, 0, 0, 0.075) inset;
	    transition: border 0.2s linear 0s, box-shadow 0.2s linear 0s;
	}
	#searchCondition select:hover,#searchCondition input:hover{
		 border: 1px solid #57B4E7;
	}
	#searchCondition input{
	    height:24px;
	    width:235px;
	    border: 1px solid #CCCCCC;
	    box-shadow: 0 1px 1px rgba(0, 0, 0, 0.075) inset;
	    transition: border 0.2s linear 0s, box-shadow 0.2s linear 0s;
	}
	#searchCondition{
		margin: auto;background:#FAFAFA;
	}
	.layout_north{ overflow-y:auto}
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
<div id="layout" class="comp bg_color" comp="type:'layout'">
	<div class="layout_north" layout="height:300,minHeight:100,spiretBar:{show:true,handlerT:function(){layout.setNorth(0);},handlerB:function(){layout.setNorth(300);}}">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
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
												<td style="padding-top:2px;padding-left:5px;" valign="top" align="left"><fmt:message key='edoc.custom.querycondition'/> ：<input type="button" onclick="openConditionSetting()"  value="<fmt:message key='govdoc.add.searchCondition.label'/>" class="button-default_emphasize"/>
												<input type="hidden" id="addCondition"/>
												<input type="hidden" id="addConditionName"/>
												</td>
											</tr>
											<TR>
												<TD VALIGN="top" align="center">
													<TABLE cellspacing="0" border="0" id="searchCondition">
														<TR>
															<%--类别 --%>
														  <TD align="right"><fmt:message key='edoc.sorttype.label'/>:</TD>
														  <TD colspan="4" align="left">
														  	<select name="edocType" id="edocType" onChange="clearDocSetting();">
														  		<%--全部 --%>
														  		<c:if test="${app == '4' }">
															  		<option value="4"><fmt:message key='exchange.element.total'/></option>
																	<option value="401"><fmt:message key='edoc.docmark.inner.send'/></option>
																	<option value="402" selected="selected"><fmt:message key='edoc.docmark.inner.receive'/></option>
																	<option value="404"><fmt:message key='edoc.docmark.inner.signandreport'/></option>
														  		</c:if>
														  		<c:if test="${app != '4' }">
															  		<option value="3"><fmt:message key='exchange.element.total'/></option>
																	<option value="0"><fmt:message key='edoc.docmark.inner.send'/></option>
																	<option value="1" selected="selected"><fmt:message key='edoc.docmark.inner.receive'/></option>
			 													  	<option value="2"><fmt:message key='edoc.docmark.inner.signandreport'/></option>
														  		</c:if>
															</select>
														  </TD>
													  	</TR>
														<TR>
															<%--公文标题--%>	
														  	<TD align="right" width="55"><fmt:message key='edoc.element.subject'/>:</TD>
														  	<TD align="left" width="260"><input type="text" name="subject" id="subject"></TD>
														  	<%-- 内部文号 --%>	
														  	<TD align="right" width="55"><fmt:message key='edoc.element.wordinno.label'/>:</TD>
														  	<TD align="left" width="260"><input type="text" name="serialNo" id="serialNo"></TD>
													  	</TR>
														<TR>
															<%-- 公文文号 --%>
														  	<TD align="right"><fmt:message key='edoc.element.wordno.label'/>:</TD>
														  	<TD align="left"><input type="text" name="docMark" id="docMark"></TD>
														  	<%-- 行文类型 --%>
														  	<TD align="right"><fmt:message key='edoc.element.sendtype'/>:</TD>
														  	<TD align="left">
																<select name="sendType" id="sendType">
																	<option value="" selected><fmt:message key='common.pleaseSelect.label'/></option>
																	<v3x:metadataItem metadata="${sendTypeMetadata}" showType="option" name="sendType" bundle="${colI18N}" switchType="zhangh"/>
																</select>
														  	</TD>
													  	</TR>
														<TR>
														  <!-- wangwei start -->
														  <%-- 公文种类 --%>
														  <TD align="right"><fmt:message key='edoc.element.doctype'/>:</TD>
														  <TD align="left">
																		<select id="docType" name="docType">
															   				<option value="" selected><fmt:message key='common.pleaseSelect.label'/></option>
																			<v3x:metadataItem metadata="${edocTypeMetadata}" showType="option" name="docType" bundle="${colI18N}" switchType="zhangh" />
																		</select>	
														  </TD>
														  <!-- wangwei end -->
														  <%-- 发起日期 --%>
															<TD align="right"><fmt:message key='edoc.supervise.serach.startdate'/>:</TD>					
															<TD align="left">
																<input type="text" name="createTimeB" id="createTimeB"readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" style="width:115px;">-<input  style="width:115px;" type="text" name="createTimeE" id="createTimeE" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);">
															</TD>
														</TR>
														<TR>
															<%-- 拟稿人--%>
															<TD align="right"><fmt:message key='edoc.element.author'/>:</TD>
															<TD align="left"><input type="text" name="createPerson" id="createPerson"></TD>
															<%-- 发文单位--%>
															<TD align="right"><fmt:message key='edoc.element.sendunit'/>:</TD>					
															<TD align="left"><input type="text" name="sendUnit" id="sendUnit"></TD>
															<TD align="left"><input type="hidden" name="sendUnitId"  id="sendUnitId" ></TD>
														</TR>
														<TR>
															<%-- 主送单位--%>
															<TD align="right"><fmt:message key='edoc.element.sendtounit'/>:</TD>
															<TD align="left"><input type="text" name="sendTo" id="sendTo"><input type="hidden" name="sendToId"  id="sendToId"></TD>
															<%-- 发文部门--%>
															<TD align="right"><fmt:message key='edoc.element.senddepartment'/>:</TD>					
															<TD align="left"><input type="text" name="sendDepartment"  id="sendDepartment"></TD>
															<TD align="left"><input type="hidden" name="sendDepartmentId"  id="sendDepartmentId" ></TD>
														</TR>	
														<TR>
															<%-- 签发人--%>
															<TD align="right"><fmt:message key='edoc.element.issuer'/>:</TD>
															<TD align="left"><input type="text" name="issuer" id="issuer"></TD>
															<%-- 签发日期--%>
															<TD align="right"><fmt:message key='edoc.element.sendingdate'/>:</TD>					
															<TD align="left"><input type="text" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" name="signingDateA" id="signingDateA" style="width:115px;">-<input type="text" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" name="signingDateB" id="signingDateB" style="width:115px;"></TD>
														</TR>
														<TR>
															<TD id="addConditionTd" colspan="5" style="padding:0"></TD>
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
		</table>
	</div>
	<div class="layout_center" layout="border:true">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td id="outExecl" height="20" valign="top" style="border-top: 1px solid #e3e3e3;border-bottom: 1px solid #e3e3e3;">
					<div class="portal-layout-cell" style="margin:0;">
						<div class="portal-layout-cell_head">
							<div class="portal-layout-cell_head_l"></div>
							<div class="portal-layout-cell_head_r"></div>
						</div>
						<table border="0" cellSpacing="0" align="left" cellPadding="0" width="100%" class="portal-layout-cell-right">
							<tr>
								<td class="sectionTitleLine" width="160">
									<span class="padding_l_10"><fmt:message key="isearch.jsp.list.result" bundle="${isearchI18N}"/>: <span class="ico16 export_excel_16"></span><a href="javascript:exportQuery()"> <fmt:message key='common.toolbar.exportExcel.label' bundle='${v3xCommonI18N}' /></a></span>
								</td>
								<%-- 同一流程只显示最后一条 --%>
								<td class="sectionTitleLine padding_l_5 " style="width:200px;">
									<label class="isGourpBy"><input style="width: 20px;" type="checkbox" ${isGourpBy=="true"?'checked="checked"' : '' } name="isGourpBy" id="isGourpBy" value="1" /><fmt:message key="edoc.list.isGroupBy" /></label>
								</td>
								<td class="sectionTitleLine padding_l_5 ">
									<label><input type="checkbox" onClick="viewDocSetting(this);" style="vertical-align:middle;" id="customSearch"/>&nbsp;<fmt:message key="edoc.custom.query" /></label>
									<span id="customQuery" style="display:none;">
										<input id="displayColName"  type="text" onClick="openDocSetting();" value="&lt;<fmt:message key="edoc.custom.type.msg" />&gt;" style="width:72.5%; border: 1px solid #CCC;cursor:pointer;"/>
									</span>
									<input type="hidden" name="displayCol" id="displayCol">	
								</td>
							</tr>
						</table>
					</div> 
				</td>
			</tr>
			<tr>
				<td vAlign="top" style="padding:0 4px 0px 2px;background:#FAFAFA;" height="90%">
					<IFRAME height="100%"  name="dataIFrame" id="dataIFrame" width="100%" frameborder="0"></IFRAME>
				</td>
			</tr>
		</table>
		<iframe name="temp_iframe" id="temp_iframe"  style="display:none;">&nbsp;</iframe>
	</div>
</div>
</body>
</html>