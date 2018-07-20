<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="Collaborationheader.jsp" %>
<%-- <%@ include file="../../common/INC/noCache.jsp"%> --%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/isearch/css/isearch.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/templete.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript"><!--
var isGroupAdmin = "${isGroupAdmin}";

showCtpLocation("F13_unitWorkflow");
	if(${v3x:currentUser().groupAdmin}){
		showCtpLocation("F13_groupWorkflow");
	}
var bdate = '${defaultBeginDate }';
var edate = '${defaultEndDate}';

//getA8Top().showLocation(${isGroupAdmin} ? 2102 : ${isAdministrator} ? 1802 : 1606);
$(function(){
	var pv = "${params}";
	if(!$.isNull(pv)){
		//解析数据
		var array=pv.split(",");
		var arr=new Array();
		var tableChart="${tableChart}";
		var url="${path}/performanceReport/WorkFlowAnalysisController.do?method=workflowStat";
		var reportCategory=new Array();
		for(var i=0;i<array.length;i++){
			var p_array=array[i].split("=");
			arr[i]=p_array;
			if(p_array[0]=='beginDate'&&$.isNull(p_array[1])){
				url+="&beginDate="+bdate;
			}else if(p_array[0]=='endDate'&&$.isNull(p_array[1])){
			   url+="&endDate="+edate;
			}else{
			url+="&"+array[i];
			}
		}
		url+="&tableChart="+tableChart;
		$("#dataIFrame").attr("src",url);
		reOnload_section(arr);
	}else{
		$("#dataIFrame").attr("src","${path }/performanceReport/WorkFlowAnalysisController.do?ViewPage=apps/performanceReport/workFlowAnalysis/workflowStatResult&isGroupAdmin=${isGroupAdmin}&isAdministrator=${isAdministrator }&tableChart=${tableChart}&params="+encodeURI("${params}"));
	}
	if(parent.location.href.indexOf("queryIndex")==-1&&!$.isNull(pv)){
		  $("#queryMainCrumbs").show();
	  }else{
		  $("#queryMainCrumbs").hide();
	  }
})

function reOnload_section(arr){
    	//回填数据操作,循环select元素
    	var section_select=$("#tab_workflow select");
    	for(var j=0;j<arr.length;j++){
    		$.each(section_select,function(i,n){
    			var item=$(n);
    			if(item.attr("id")==arr[j][0]){
    				item.val(arr[j][1]);
    			}
    		})
    	}
  		var section_input=$("#tab_workflow input");
  		var templeteName='';
  		var department='';
  		var person='';
    	//回填数据操作,循环input元素
    	for(var j=0;j<arr.length;j++){
    		$.each(section_input,function(i,n){
        		var item=$(n);
        		if(item.attr("type")=="radio"){
        			if(item.attr("id")==arr[j][0]){
        				item.attr("checked","checked");
        			}
        		}else{
        			if(item.attr("id")==arr[j][0]){
        				if(arr[j][0]=='templeteName'){
        					templeteName=arr[j][1];
        				}else if(arr[j][0]=='department'){
        					department=arr[j][1];
        				}else if(arr[j][0]=='person'){
        					person=arr[j][1];
        				}else if(arr[j][0]=='beginDate'){
        					if(arr[j][1]!=""){
        						$("#beginDate").val(arr[j][1]);
        					}
            			}else if(arr[j][0]=='endDate'){
            				if(arr[j][1]!=""){
            				    $("#endDate").val(arr[j][1]);
            				}
            			}else{
	        				item.val(arr[j][1]);
        				}
        			}
        		}
        	})
		}
    	if($("#templateFlow").attr("checked")=='checked'){
    		$("#templeteName").removeAttr("disabled").val(templeteName);
    	}
    	if($("#toDep").attr("checked")=='checked'){
    		var toDep=document.getElementById("toDep");
    		switchIt(toDep);
    		$("#department").val(department);
    	}
    	if($("#toPer").attr("checked")=='checked'){
    		var toPer=document.getElementById("toPer");
    		switchIt(toPer);
    		$("#person").val(person);
    	}
  	}
//查询
function ok(isExcel){
	var theForm = document.getElementById("workflowForm");

	if(isGroupAdmin!="true" && theForm.templeteId.value==""){
		alert(v3x.getMessage("collaborationLang.workflowStat_select_operationType"));
		return;
	}

	var beginDate = document.getElementById("beginDate").value;
	var endDate = document.getElementById("endDate").value;
	if(beginDate && endDate && !checkDate(beginDate,endDate)) {
		return;
	}
	
	if(isGroupAdmin=="false"){
		condition = document.getElementById("condition");
		if(condition){
			var AppEnumKeyOption = condition.options[condition.selectedIndex];
			document.getElementById("appType").value = AppEnumKeyOption.value;
		}
	}

	var toDep = document.getElementById("toDep");
	var toPer = document.getElementById("toPer");
	var toAccount = document.getElementById("toAccount");
	var statType = document.getElementById("statType");
	if(toAccount && toAccount.checked==true && toAccount.value){
		statType.value = toAccount.value;
	}else if(toDep && toDep.checked==true && toDep.value){
		statType.value = toDep.value;
	}else if(toPer && toPer.checked==true && toPer.value){
		statType.value = toPer.value;
	}
	
	var baseUrl="${path}";
	if(isExcel){
	  $("#workflowForm").attr("action",baseUrl+"/performanceReport/WorkFlowAnalysisController.do?method=workflowStat&exportToExcel=1");
	}else if($("#workflowForm").attr("action") != baseUrl+"/performanceReport/WorkFlowAnalysisController.do?method=workflowStat"){
		$('#querySave').attr('disabled',true);
		$("#workflowForm").attr("action",baseUrl+"/performanceReport/WorkFlowAnalysisController.do?method=workflowStat");
	}
	
	theForm.submit();
}

function checkDate(d1, d2){
	var year = d1.substring(0,d1.indexOf("-"));
	var month = d1.substring(d1.indexOf("-")+1,d1.lastIndexOf("-"))-1;
	var date = d1.substring(d1.lastIndexOf("-")+1);
	var date1 = new Date(year,month,date);
	
	year = d2.substring(0,d2.indexOf("-"));
	month = d2.substring(d2.indexOf("-")+1,d2.lastIndexOf("-"))-1;
	date = d2.substring(d2.lastIndexOf("-")+1);
	var date2 = new Date(year,month,date);
	
	var minus = date2-date1;
	if(minus<0){
		alert(v3x.getMessage("collaborationLang.workflowStat_endDateTooSmall"));
		return false;
	}
	// 时间范围不能超过一年
	if(minus>31536000000){
		alert(v3x.getMessage("collaborationLang.workflowStat_beyondOneYear"));
		return false;
	}
	// 时间范围最好不要超过三个月(当然也可以超过)
	if(minus>7948800000){
		if(!confirm(v3x.getMessage("collaborationLang.workflowStat_moreThanThreeMonth"))){
			return false;
		}		
	}
	return true;
}
//重置
function repeal(){
	$("#condition option").eq(0).attr("selected",true);
	$("#oneselfCreate").attr('checked', true);
	$("#oneselfCreate").click();
	$("#toDep").click();
	$("#beginDate").val(bdate);
	$("#endDate").val(edate);
	
  //协同V5.0 OA-31987 重置操作，清空模板选择的数据
	clearTempChoose();
  //清空选择的人员信息
    clearOrgChoose();
  //清空查询结果
	var baseUrl="${path}"; 
	$("#dataIFrame").attr("src","${path }/performanceReport/WorkFlowAnalysisController.do?ViewPage=apps/performanceReport/workFlowAnalysis/workflowStatResult&isGroupAdmin=${isGroupAdmin}&isAdministrator=${isAdministrator }&tableChart=${tableChart}&params="+encodeURI("${params}"));
}
//清空选择的人员信息
function clearOrgChoose(){
document.getElementById("person").value=document.getElementById("person").defaultValue;
document.getElementById("personIds").value="";
document.getElementById("department").value=document.getElementById("department").defaultValue;
document.getElementById("departmentIds").value=document.getElementById("departmentIds").defaultValue;
elements=null;
elements_user=null;
elements_colony=null;
elements_colonyAccount=null;
}

function clearTempChoose(){
  var tId = $("#templeteId").val();
  if(tId!=1 && tId!=-1){//1表示当前选的是全部模板或自建流程，不需要做数据清理
	 templateChooseCallback("","");
  }
  //弹出框组件将已选项存放在全局变量rv中，这里选择全部模板后，将rv置空
  templateOrginalData = null;
}

//单位/部门条件
function dataToColony(elements,which){
    if (!elements) {
        return false;
    }
    var memberIds = getIdsString(elements);
    var memberNames = getNamesString(elements);
    var statType = "";
    var typeCount = 0;
    for(var i=0; i<elements.length; i++){
    	var person = elements[i];
        //memberIds += person.type + "|" + person.id + ",";
        if(statType != person.type)
        	typeCount++;
        statType = person.type;	
    }
    if(typeCount>1){
    	alert(v3x.getMessage("collaborationLang.workflowStat_onlySelectOne"));
    	return;
    }
    if(which == "department"){
	    document.getElementById("departmentIds").value = memberIds;
	    document.getElementById("department").value = memberNames;
	    <c:if test="${!isGroupAdmin}">
	    document.getElementById("toDep").value = statType;
	    </c:if>
    }else if(which == "person"){
    	document.getElementById("personIds").value = memberIds;
    	document.getElementById("person").value = memberNames;
    }
}

function switchIt(obj){
	var toDep = document.getElementById("toDep");
	var toPer = document.getElementById("toPer");
	var statType = document.getElementById("statType");
	if(obj.id=="toDep" || obj.id=="toAccount"){
		depLabel.style.display = "";
		depContent.style.display = "";
		perLabel.style.display = "none";
		perContent.style.display = "none";
		if(obj.id=="toAccount"){
			statType.value = document.getElementById("toAccount").value;
		}else{
			statType.value = toDep.value;
		}
	}else if(obj.id=="toPer"){
		depLabel.style.display = "none";
		depContent.style.display = "none";
		perLabel.style.display = "";
		perContent.style.display = "";
		statType.value = toPer.value;
	}
}

function doPrint(){
	var printObj = dataIFrame.document.getElementById("printArea");
	var proName=document.getElementById("proName").value;
	var cssList = new ArrayList();
	cssList.add(v3x.baseURL + "/apps_res/collaboration/css/collaboration.css");
	cssList.add("/"+proName+"/common/skin/default/skin.css");
	var pl = new ArrayList();
	if(printObj){
		var html = printObj.innerHTML;
		html = html.replace(/like-a/gi,"").replace(/openList\S*\)/gi,"");
		var printObjFrag = new PrintFragment("", html);
		pl.add(printObjFrag);
		printList(pl,cssList);
	}
}


function exportExcel(){
  ok(true);
// 	var templeteId = "";
// 	var baseUrl='${path}'
// 	if(document.getElementById("templeteId")){
// 		templeteId = document.getElementById("templeteId").value;
// 	}
// 	exportExcel4Stat.location.href = "<c:url value='"+baseUrl+"/performanceReport/WorkFlowAnalysisController.do?method=workflowStat&exportToExcel=1&templeteId="+templeteId+"' />";
}

function changeOperationType(){
	var theForm = document.getElementById("workflowForm");
	var operationTypeArr = theForm.operationType;
	var templeteId = document.getElementById("templeteId");
    for(var i=0; i<operationTypeArr.length; i++){
		if(operationTypeArr[i].checked){
			var operationType = operationTypeArr[i].value;
			var isTemplate = operationType == "template";
			document.getElementById("templeteName").value = '<fmt:message key="click.choice" bundle="${v3xCommonI18N}"/>';
			document.getElementById("templeteName").disabled = !isTemplate;
			templeteId.value = isTemplate ? "" : "${!isGroupAdmin and !isAdministrator ? '1': '-1'}";	
		}
	}
}

function changeAppType(){
    //协同V5.0 OA-31984 切换
    clearTempChoose();
    
	var theForm = document.getElementById("workflowForm");
	var AppEnumKeyOption = theForm.condition.options[theForm.condition.selectedIndex];
	var selectedAppEnumKey = AppEnumKeyOption.value;
	if (${isGroupAdmin} || ${isAdministrator}) {
		if(selectedAppEnumKey == 2){
			document.getElementById("oneselfCreate").disabled = true;
			var operationTypeArr = theForm.operationType;
			for(var i=0; i<operationTypeArr.length; i++){
				var operationType = operationTypeArr[i].value;
				if(operationType == "template"){
					operationTypeArr[i].checked = true;
					document.getElementById("templeteName").disabled = false;
					document.getElementById("templeteName").value = '<fmt:message key="click.choice" bundle="${v3xCommonI18N}"/>';
					document.getElementById("templeteId").value = "";
				}
			}
		}else{
			document.getElementById("oneselfCreate").disabled = false;
			var operationTypeArr = theForm.operationType;
		    for(var i=0; i<operationTypeArr.length; i++){
				if(operationTypeArr[i].checked){
					var operationType = operationTypeArr[i].value;
					if(operationType == "template"){
						operationTypeArr[0].checked = true;
						document.getElementById("templeteName").disabled = true;
						document.getElementById("templeteName").value = '<fmt:message key="click.choice" bundle="${v3xCommonI18N}"/>';
						document.getElementById("templeteId").value = "${!isGroupAdmin and !isAdministrator ? '1' : '-1'}";
					}
				}
			}
		}
	}
	document.getElementById("templeteName").title = "";
	$("#appType").val($("#condition").val());
}

<c:if test="${!isGroupAdmin}">
//只显示当前登录单位
onlyLoginAccount_colony=true;
onlyLoginAccount_user=true;
</c:if>

function selectPeopleDA(){
	if(document.getElementById("toAccount") && document.getElementById("toAccount").checked){
		selectPeopleFun_colonyAccount();
	}
	else{
		selectPeopleFun_colony();
	}
}
var baseUrl="${path}";

function selectTemplete() {
	var condition = document.getElementById("condition");
	var appType = "";
	if(condition){
		appType = condition.value;
		//<%--为了弹出页面的模板可以根据类型进行过滤，需要将此处的ApplicationCategoryEnum转化为TempleteCategory--%>
		if(appType == "1"){<%--协同--%>
			appType = "1";
		}else if(appType == "2"){<%--表单--%>
			appType = "2";
		}else if(appType == "4"){<%--公文--%>
			appType = "4";
		}
	}
	var url="${path}";
	url += "/performanceReport/WorkFlowAnalysisController.do?method=showTempleteFrame&isMultiSelect=true&isWorkflowAnalysiszPage=false&appType="+appType+"&data=MemberAnalysis";
	v3x.openWindow({
		url		: url,
		width	: 600,
		height	: 417,
		resizable	: "false"
	});
}
function templateChooseCallback(id,name){
	$("#templeteName").val(name);
	$("#templeteId").val(id);
}
function selectTemplate(){
	var appType=$("#appType").val();
	if(appType==4){
	  /**
	   *模板左右选择组件,参数没有就传null
	   *@param callback 回调函数
	   *@param isMul 是否支持多选，默认为true
	   *@param moduleType 模板分类，取ModuleType的枚举值Key
	   *@param accountId 单位ID，默认为当前登录单位ID
	   *@param scope 数据范围：枚举值["MemberUse","MaxScope","MemberAnalysis"]
	   *@param excludeTemplateIds : 不包含的模板ID，以，分隔的字符串，eg:123232,12121,43,21212 不宜太多，10个以下为好
	   *@param reportId:报表ID，F8专用
	   */
 		templateChoose(templateChooseCallback,4,true,'','MemberAnalysis','','${reportId}');
	}else if(appType==2){
		templateChoose(templateChooseCallback,2,true,'','MemberAnalysis','','${reportId}');
	}else if(appType==1){
		templateChoose(templateChooseCallback,1,true,'','MemberAnalysis','','${reportId}');
	}
}
//穿透页面转协同
function closeAndForwardToCol(subject, content){
	$("#queryConditionForm").append("<input type='hidden' id='reportContent' name='reportContent' /><input type='hidden' id='reportTitle' name='reportTitle' />");
    $('#reportContent').val(content);
    $('#reportTitle').val(subject.replace(/(^\s*)|(\s*$)/g, ""));
    $("#queryConditionForm").attr("action", "${path}/performanceReport/performanceQuery.do?method=reportForwardCol");
    $("#queryConditionForm").submit();
}
-->
</script>

</head>
<body scroll="no" class="page_color">
	 <div style="height: 19px; display: block;" id="queryMainCrumbs" class="bg_color border_b hidden">
       <span style="display: inline;" id="nowLocation" class="common_crumbs "><span class="margin_r_10">${ctp:i18n('seeyon.top.nowLocation.label')}</span>
       <a href="${path}/portal/spaceController.do?method=showThemSpace&amp;themType=23">${ctp:i18n('system.menuname.CollaborationMonitor')}</a>
       <span class="common_crumbs_next margin_lr_5">-</span>
       <a href="javascript:location.reload()">${ctp:i18n('system.menuname.PerformanceQuery')}</a>
       </span>
      </div>
      <form action="#" id="queryConditionForm"  method="post" target="main">
	</form>
<input type="hidden" value="${path }" id="proName">
<v3x:selectPeople id="colonyAccount" panels="Account" selectType="Account" 
	jsFunction="dataToColony(elements,'department')" viewPage="${viewPage}" minSize="0" />
<v3x:selectPeople id="colony" panels="${isGroupAdmin ? 'Department,Outworker' : 'Department,Outworker' }" selectType="Department" 
	jsFunction="dataToColony(elements,'department')" viewPage="${viewPage}" minSize="0" />
<v3x:selectPeople id="user" panels="Department,Outworker" selectType="Member" 
	jsFunction="dataToColony(elements,'person')" viewPage="${viewPage}" minSize="0" maxSize="100" />
<script type="text/javascript">
	<!--
	var isConfirmExcludeSubDepartment_colonyAccount = true;
	var isConfirmExcludeSubDepartment_colony = true;
	//-->
</script>
<table id="tab_workflow" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="main-bg border_lr page_color">
	<tr height="80">
		<td align="left" valign="top" class="">
			<form method="post" id="workflowForm" name="workflowForm" target="dataIFrame" action="${detailURL}" >
				<input type="hidden" name="method" value="workflowStat" />
				<input type="hidden" name="isGroupAdmin" value="${isGroupAdmin }" />
				<input type="hidden" name="isAdministrator" value="${isAdministrator }" />
				<input type="hidden" name="tableChart" id="tableChart" />
				<table width="100%" height="100%" border="0" class="noWrap" >
					<tr >
						<td width="40%" align="center">
							<table>
								<tr height="30px">
									<c:choose>
									<c:when test="${isGroupAdmin}"><!-- 集团管理员 -->
										<td width="60px" align="right"><fmt:message key="common.app.type" bundle="${v3xCommonI18N}"/>:</td>
										<td >
											<select id="appType" name="appType" style="width:98%">
													<c:forEach items="${appEnumKeyList}" var="appEnumKey" >
													     <c:set value="${v3x:getApplicationCategoryName(appEnumKey, pageContext)}" var="objName" /> 
														 <option value="${appEnumKey}" title="${objName}" ${appEnumKey==1 ? "selected" : "" }>${v3x:getLimitLengthString(objName, 20,'...')}</option>
													</c:forEach>
			<%--                                         <option value="2"><fmt:message key="application.2.label" bundle="${v3xCommonI18N}" /></option> --%>
			<%--                                         <option value="1"><fmt:message key="node.policy.collaboration" bundle="${v3xCommonI18N}" /></option> --%>
			<%--                                         <option value="4"><fmt:message key="application.4.label" bundle="${v3xCommonI18N}" /></option> --%>
											</select>
											<input type="hidden" name="statScope" value="group">
										</td>
									</c:when>
									<c:otherwise><!-- 单位管理员 或普通用户 -->
										<td align="right" width="60px"><fmt:message key="common.app.type" bundle="${v3xCommonI18N}"/>:</td>
										<td colspan="2" width="100%">
			                               <select id="condition" onchange="changeAppType()" style="width:88%">
			                               <c:forEach items="${appEnumKeyList}" var="appEnumKey" >
			                               <c:set value="${v3x:getApplicationCategoryName(appEnumKey, pageContext)}" var="objName" />
			                               <option value="${appEnumKey}" title="${objName}" ${appEnumKey==1 ? "selected" : "" }>${v3x:getLimitLengthString(objName, 20,'...')}</option>
			                               </c:forEach>
			                               </select>
			<!-- 									<select id="condition" onchange="changeAppType()" style="width:98%"> -->
			<%--                                      <option value="2"><fmt:message key="application.2.label" bundle="${v3xCommonI18N}" /></option> --%>
			<%-- 									 <option value="1"><fmt:message key="node.policy.collaboration" bundle="${v3xCommonI18N}" /></option> --%>
			<%--                                      <option value="4"><fmt:message key="application.4.label" bundle="${v3xCommonI18N}" /></option> --%>
			<!-- 									</select> -->
											<input type="hidden" id="appType" name="appType" value="1"/>
											<input type="hidden" name="statScope" value="account">
											<input type="hidden" name="templeteId" id="templeteId" value="${!isGroupAdmin and !isAdministrator ? '1' : '-1'}" />
										</td>
									</c:otherwise>
									</c:choose>
								</tr>
								<tr height="30px">
									<td align="right" nowrap="nowrap" width="60px">
										<c:if test="${isGroupAdmin or isAdministrator }">
											<fmt:message key="common.date.sendtime.label" bundle="${v3xCommonI18N}" />:
										</c:if>
										<c:if test="${!isGroupAdmin and !isAdministrator }">
											<fmt:message key="common.start.date.label" bundle="${workflowI18N}" />: 
										</c:if>
									</td>
									<td colspan="2" >
										<input type="text" value="${defaultBeginDate }" name="beginDate" id="beginDate" style="width:40%" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly >
										-
										<input type="text" value="${defaultEndDate }" name="endDate" id="endDate" class="input-date" style="width:40%" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly >
									</td>
								</tr>
							</table>
						</td>
						<td colspan="2" width="45%" align="right">
							<table >
								<tr height="30px">
								<c:choose>
									<c:when test="${!isGroupAdmin}"><!-- 集团管理员 -->
									<td width="60px" align="right" nowrap="nowrap">
										<c:choose>
											<c:when test="${isAdministrator }">
												<fmt:message key="common.operation.type" bundle="${v3xCommonI18N}"/>:		
											</c:when>
											<c:otherwise>
												<fmt:message key="common.template.process.label" bundle="${workflowI18N}"/>:
											</c:otherwise>
										</c:choose>
									</td>
								<td colspan="2" >
									<label for="oneselfCreate">
										<input type="radio" name="operationType" id="oneselfCreate" value="self" onclick="changeOperationType()" checked />
										<c:choose>
											<c:when test="${isAdministrator }">
												<fmt:message key="self.create.workflow" />		
											</c:when>
											<c:otherwise>
												<fmt:message key='common.all.templete.label' bundle='${v3xCommonI18N}'/>
											</c:otherwise>
										</c:choose>
									</label>
									<label for="templateFlow">
										<input type="radio" name="operationType" id="templateFlow" value="template" onclick="changeOperationType()" />
										<c:choose>
											<c:when test="${isAdministrator }">
												<fmt:message key="template.flow" />	
											</c:when>
											<c:otherwise>
												<fmt:message key='common.the.specified.template.label' bundle='${workflowI18N}'/>
											</c:otherwise>
										</c:choose>
									</label>
									</td>
									</c:when>
									</c:choose>
								</tr>
								<tr height="30px">
									<td nowrap="nowrap" align="right" width="55px" >
										<fmt:message key="stat.to"/>:
										<c:if test="${isGroupAdmin }">
										<label for="toAccount"><input type="radio" name="statWhat" id="toAccount" value="Account"  checked="true" onclick="switchIt(this)"><fmt:message key="stat.toAccound"/></label>
										</c:if>
									</td>
									<td >
										<label for="toDep"><input type="radio" name="statWhat" id="toDep" value="${accountId==null ? 'Department' : 'Account' }" ${isGroupAdmin ? '' : 'checked' } onclick="switchIt(this)"><fmt:message key="stat.toDepartment"/></label>
										<label for="toPer"><input type="radio" name="statWhat" id="toPer" value="Member" onclick="switchIt(this)"><fmt:message key="stat.toPerson"/></label>
										<input type="hidden" name="statType" id="statType" value="${accountId==null ? '' : 'Account' }">
									</td>
									<td align="right" id="depLabel" nowrap="nowrap" width="60px" >
									<label style=""><fmt:message key="org.account.label" bundle="${v3xMainI18N }"/><c:if test="${!isGroupAdmin }"><fmt:message key="org.department.label" bundle="${v3xMainI18N }"/></c:if>:
									</label>
									</td>
									<td width="55px" align="right" id="perLabel" style="display:none" nowrap="nowrap"><fmt:message key="stat.specifyPerson"/>:</td>
								</tr>
							</table>
						</td>
						<td colspan="3">
								<table>
									<tr height="30">
									<c:choose>
									<c:when test="${!isGroupAdmin}"><!-- 集团管理员 -->
										<td>
											<input type="text" name="templeteName" id="templeteName" style="width:100px" value='<fmt:message key="click.choice" 
											bundle="${v3xCommonI18N}"/>' title="" onclick="selectTemplate()" readonly ${flowType eq 'self' ? 'disabled' : ''} />
										</td>
										</c:when>
										</c:choose>
									</tr>
									<tr height="30">
									<td width="60px" id="depContent" nowrap="nowrap">
									<c:set var="accountName" value="${v3x:getAccount(accountId).name}"/>
									<fmt:message key="click.choice" bundle="${v3xCommonI18N}" var="defalutValue"/>
										<input type="text" name="department" id="department" style="width:80px;" value="${empty accountName ? defalutValue : accountName}" onclick="selectPeopleDA()"   readonly class="cursor-hand"/>
										<input type="hidden" name="departmentIds" id="departmentIds" value="${accountId }" />
									</td>
									
									<td width="60px" id="perContent" style="display:none" nowrap="nowrap">
										<input type="text" name="person" id="person" style="width:80px" value='${defalutValue }' onclick="selectPeopleFun_user()" readonly class="cursor-hand" />
										<input type="hidden" name="personIds" id="personIds" value="" />
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<div class='align_center clear padding_tb_5' nowrap="nowrap" colspan="0" width="100%">
					<input type="button" id="querySave" class="button-default-2"  onclick="ok()" 
						value='<fmt:message key="common.toolbar.statistics.label" bundle="${v3xCommonI18N}" />' class="button-default-2">
					<input type="button" class="button-default-2"  onclick="repeal()" value='<fmt:message key="common.button.reset.label" bundle="${v3xCommonI18N}" />' >
				</div>
			</form>
		</td>
	</tr>
	<tr id="workflowDetail" >
	    <td colspan="6">
	    <div id="content">
	        <iframe src="" name="dataIFrame" id="dataIFrame"
	                frameborder="0" marginheight="0" marginwidth="0" height="94%" width="100%" scrolling="auto">
	        </iframe>
	    </div>
	    </td>
	</tr>
</table>
<iframe name="exportExcel4Stat" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
<script  type="text/javascript">
initIe10AutoScroll("content",70);
</script>
</body>
</html>