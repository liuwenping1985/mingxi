<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../workFlowAnalysis/Collaborationheader.jsp" %>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/isearch/css/isearch.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/templete.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript"><!--
var isGroupAdmin = "${isGroupAdmin}";
var bdate = '${defaultBeginDate }';
var edate = '${defaultEndDate}';
//getA8Top().showLocation(${isGroupAdmin} ? 2102 : ${isAdministrator} ? 1802 : 1606);
$(function(){
	var pv = getA8Top().paramValue;
	//解析数据
	var array=pv.split(",");
	var arr=new Array();
	var reportCategory=new Array();
	for(var i=0;i<array.length;i++){
		var p_array=array[i].split("=");
		arr[i]=p_array;
	}
	reOnload_section(arr);
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
        				}else{
	        				item.val(arr[j][1]);
        				}
        			}
        		}
        	})
		}
		if($("#beginDate").val()==""||$("#beginDate").val()==null){
			$("#beginDate").val(bdate);
		}
		if($("#endDate").val()==""||$("#endDate").val()==null){
			$("#endDate").val(edate);
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
  	
function OK(){
	submitDate();
	var content=$("#tab_workflow input");
	var select=$("#tab_workflow select");
	var array=new Array();
	var arr=new Array();
	var j=0;
	$.each(content,function(i,n){
		var item=$(n);
		if(item.attr("type")=='hidden'){
			if(item.attr("id")!=undefined){
				array[j]=""+item.attr("id")+"="+item.val();
				j++;
			}else{
				array[j]=""+item.attr("name")+"="+item.val();
				j++;
			}
		}
		if(item.attr("type")=='radio'){
			if(item.attr("id")!=undefined){
				if(item.attr("checked")=='checked'){
					array[j]=""+item.attr("id")+"="+item.val();
					j++;
				}else{
					array[j]=""+item.attr("name")+"="+item.val();
					j++;
				}
			}
		}
		if(item.attr("type")=='text'){
			if(item.attr("id")!=undefined){
				array[j]=""+item.attr("id")+"="+item.val();
				j++;
			}else{
				array[j]=""+item.attr("name")+"="+item.val();
				j++;
			}
		}
	});
	$.each(select,function(i,n){
		var item=$(n);
		array[j]=""+item.attr("id")+"="+item.val();
		j++;
	})
	arr[0]=array;
	return arr;
}
// function OK(){
// 	submitDate();
// 	var array=new Array();
// 	var arr=new Array();
// 	array[0]="templeteId="+$("#templeteId").val();
// 	array[1]="beginDate="+$("#beginDate").val();
// 	array[2]="endDate="+$("#endDate").val();
// 	array[3]="appType="+$("input[name='appType']").val();
// 	array[4]="statType="+$("#statType").val();
// 	array[5]="departmentIds="+$("#departmentIds").val();
// 	array[6]="personIds="+$("#personIds").val();
// 	array[7]="statScope="+$("input[name='statScope']").val();
// 	array[8]="templeteName="+$("#templeteName").val();
// 	array[9]="templateFlow="+$("#templateFlow").val();
// 	array[10]="department="+$("#department").val();
// 	array[11]="person="+$("#person").val();
// 	arr[0]=array;
// 	return arr;
// }
//查询
function submitDate(){
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
			//document.getElementById("appType").value = AppEnumKeyOption.value;
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
	//$("#workflowForm").attr("action",""+baseUrl+"/performanceReport/WorkFlowAnalysisController.do?method=workflowStat")
	//theForm.submit();
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
	location.reload(true);
}

//单位/部门条件
function dataToColony(elements,which){
    if (!elements) {
        return false;
    }
    var memberIds = getIdsString(elements);;
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
	var templeteId = "";
	var baseUrl='${path}'
	if(document.getElementById("templeteId")){
		templeteId = document.getElementById("templeteId").value;
	}
	exportExcel4Stat.location.href = "<c:url value='"+baseUrl+"/performanceReport/WorkFlowAnalysisController.do?method=workflowStat&exportToExcel=1&templeteId="+templeteId+"' />";
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
// var elements_colonyAccount = parseElements("");
// function selectPeopleFun_PcolonyAccount() {
//     var elements=v3x.openWindow(
//     		{
//     			url:""+baseUrl+"/performanceReport/WorkFlowAnalysisController.do?method=select&ViewPage=&ShowMe=true&Panels=Account&SelectType=Account&memberId=&departmentId=&postId=&levelId=&maxSize=-1&minSize=0&id=colonyAccount",
//     			height:488,
//     			width:608
//     		},
//     		resizable="no");
//     if(elements != null){
//         elements_colonyAccount = elements;
//         dataToColony(elements,'department');
//         return true;
//     }
//     return false;
// }

// var elements_colony = parseElements("");
// function selectPeopleFun_Pcolony() {
//     var elements=v3x.openWindow({url:""+baseUrl+"/performanceReport/WorkFlowAnalysisController.do?method=select&ViewPage=&ShowMe=true&Panels=Department,Outworker&SelectType=Department&memberId=&departmentId=&postId=&levelId=&maxSize=-1&minSize=0&id=colony",height:488,width:608},resizable="no");
//     if(elements != null){
//         elements_colony = elements;
//         dataToColony(elements,'department');
//         return true;
//     }
//     return false;
// }

// var elements_user = parseElements("");
// function selectPeopleFun_Puser() {
//     var elements=v3x.openWindow({url:""+baseUrl+"/performanceReport/WorkFlowAnalysisController.do?method=select&&ShowMe=true&Panels=Department,Outworker&SelectType=Member&memberId=&departmentId=&postId=&levelId=&maxSize=100&minSize=0&id=user",height:488,width:608},resizable="no");
//     if(elements != null){
//         elements_user = elements;
//         dataToColony(elements,'person');
//         return true;
//     }
//     return false;
// }
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
	$("#templeteName").css("display","block").val(name);
	$("#templeteId").val(id);
}
function selectTemplate(){
	var appType = $("#appType").val();
// 	if(appType==4){
//  		templateChoose(templateChooseCallback,2,'','','MaxScope');
// 	}else if(appType==0){
// 		templateChoose(templateChooseCallback,1,'','','MaxScope');
// 	}else if(appType==1){
// 		templateChoose(templateChooseCallback,4,'','','MaxScope');
// 	}
	//templateChoose(templateChooseCallback,'',false,'','MemberAnalysis','','${reportId}');
	templateChoose(templateChooseCallback,appType,true,'','MemberAnalysis','','${reportId}');
}
-->
</script>
<style type="text/css">
	#tab_workflow tr td{
		padding:5px;
	}
</style>
</head>
<body scroll="no" class="page_color">
<input type="hidden" value="${path }" id="proName">
<v3x:selectPeople id="colonyAccount" panels="Account" selectType="Account" 
	jsFunction="dataToColony(elements,'department')" viewPage="${viewPage}" minSize="0" />
<v3x:selectPeople id="colony" panels="${isGroupAdmin?'Department,Outworker':'Department,Outworker' }" selectType="Department" 
	jsFunction="dataToColony(elements,'department')" viewPage="${viewPage}" minSize="0" />
<v3x:selectPeople id="user" panels="Department,Outworker" selectType="Member" 
	jsFunction="dataToColony(elements,'person')" viewPage="${viewPage}" minSize="0" maxSize="100" />
<script type="text/javascript">
	<!--
	var isConfirmExcludeSubDepartment_colonyAccount = true;
	var isConfirmExcludeSubDepartment_colony = true;
	//-->
</script>
<table id="tab_workflow" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="main-bg">
	<tr height="70">
		<td align="left" valign="top" class="">
			<form method="post" id="workflowForm" name="workflowForm" target="dataIFrame" action="${detailURL}" >
				<input type="hidden" name="method" value="workflowStat" />
				<input type="hidden" name="isGroupAdmin" value="${isGroupAdmin }" />
				<input type="hidden" name="isAdministrator" value="${isAdministrator }" />
				<table width="100%" height="100%" border="0" class="noWrap" >
					<tr >
							<c:choose>
							<c:when test="${isGroupAdmin}"><!-- 集团管理员 -->
								<td align="left" width="17%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="common.app.type" bundle="${v3xCommonI18N}"/>:</td>
								<td>
									<select id="appType" name="appType" style="width:40%">
									<%-- 	<c:forEach items="${appEnumKeyList}" var="appEnumKey" >
										     <c:set value="${v3x:getApplicationCategoryName(appEnumKey, pageContext)}" var="objName" />
											 <option value="${appEnumKey}" title="${objName}" ${appEnumKey==1?"selected":"" }>${v3x:getLimitLengthString(objName, 20,'...')}</option>
										</c:forEach> --%>
                                        <option value="2"><fmt:message key="application.2.label" bundle="${v3xCommonI18N}" /></option>
                                        <option value="1"><fmt:message key="node.policy.collaboration" bundle="${v3xCommonI18N}" /></option>
                                        <option value="4"><fmt:message key="application.4.label" bundle="${v3xCommonI18N}" /></option>
									</select>
									<input type="hidden" name="statScope" value="group">
								</td>
							</c:when>
							<c:otherwise><!-- 单位管理员 或普通用户 -->
								<td align="left" width="17%">&nbsp;<fmt:message key="common.app.type" bundle="${v3xCommonI18N}"/>:</td>
								<td colspan="2">
									<select id="condition" onchange="changeAppType()" style="width:40%">
                                     <option value="2"><fmt:message key="application.2.label" bundle="${v3xCommonI18N}" /></option>
									 <option value="1"><fmt:message key="node.policy.collaboration" bundle="${v3xCommonI18N}" /></option>
                                     <option value="4"><fmt:message key="application.4.label" bundle="${v3xCommonI18N}" /></option>
									</select>
									<input type="hidden" id="appType" name="appType" value="2"/>
									<input type="hidden" name="statScope" value="account">
									<input type="hidden" name="templeteId" id="templeteId" value="${!isGroupAdmin and !isAdministrator ? '1' : '-1'}" />
								</td>
							</c:otherwise>
							</c:choose>
						</tr>
						<tr>
						<td align="left">
									<c:choose>
										<c:when test="${isAdministrator }">
											<fmt:message key="common.operation.type" bundle="${v3xCommonI18N}"/> :		
										</c:when>
										<c:otherwise>
											<fmt:message key="common.template.process.label" bundle="${workflowI18N}"/> :
										</c:otherwise>
									</c:choose>
								</td>
							<td colspan="4">
								<label for="oneselfCreate">
									<input type="radio" name="operationType" id="oneselfCreate" value="self" onclick="changeOperationType()" checked />&nbsp;&nbsp;
									<c:choose>
										<c:when test="${isAdministrator }">
											<fmt:message key="self.create.workflow" />		
										</c:when>
										<c:otherwise>
											<fmt:message key='common.all.templete.label' bundle='${v3xCommonI18N}'/>
										</c:otherwise>
									</c:choose>
								</label>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
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
								<input type="text" name="templeteName" id="templeteName" style="width:150px" value='<fmt:message key="click.choice" 
								bundle="${v3xCommonI18N}"/>' title="" onclick="selectTemplate()" readonly ${flowType eq 'self'? 'disabled' : ''} />
							</td>
						</tr>
						<tr >
							<td align="left">
								<c:if test="${isGroupAdmin or isAdministrator }">
									&nbsp;<fmt:message key="common.date.sendtime.label" bundle="${v3xCommonI18N}" />:
								</c:if>
								<c:if test="${!isGroupAdmin and !isAdministrator }">
									&nbsp;<fmt:message key="common.start.date.label" bundle="${workflowI18N}" />: 
								</c:if>
							</td>
							<td colspan="4">
								<input type="text" value="" name="beginDate" id="beginDate" style="width:45%" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly >
								-
								<input type="text" value="" name="endDate" id="endDate" class="input-date" style="width:45%" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly >
							</td>
						</tr>
						<tr>
							<td align="left">
									&nbsp;&nbsp;&nbsp;&nbsp;<fmt:message key="stat.to"/> :
									<c:if test="${isGroupAdmin }">
									<label for="toAccount"><input type="radio" name="statWhat" id="toAccount" value="Account"  checked="true" onclick="switchIt(this)"><fmt:message key="stat.toAccound"/></label>&nbsp;&nbsp;
									</c:if>
							</td>
							<td>
								<label for="toDep"><input type="radio" name="statWhat" id="toDep" value="${accountId==null?'Department':'Account' }" ${isGroupAdmin?'':'checked' } onclick="switchIt(this)"><fmt:message key="stat.toDepartment"/></label>&nbsp;&nbsp;
									<label for="toPer"><input type="radio" name="statWhat" id="toPer" value="Member" onclick="switchIt(this)"><fmt:message key="stat.toPerson"/></label>
									<input type="hidden" name="statType" id="statType" value="${accountId==null?'':'Account' }">
							</td>
							<td align="left" id="depLabel" nowrap="nowrap" >
							 <label style=""><fmt:message key="org.account.label" bundle="${v3xMainI18N }"/><c:if test="${!isGroupAdmin }"><fmt:message key="org.department.label" bundle="${v3xMainI18N }"/></c:if>:
							</label></td>
							<td id="depContent" nowrap="nowrap">
							<c:set var="accountName" value="${v3x:getAccount(accountId).name}"/>
							<fmt:message key="click.choice" bundle="${v3xCommonI18N}" var="defalutValue"/>
								<input type="text" name="department" id="department" style="width:150px;" value="${empty accountName?defalutValue:accountName}" onclick="selectPeopleDA()"   readonly class="cursor-hand"/>
								<input type="hidden" name="departmentIds" id="departmentIds" value="${accountId }" />
							</td>
							<td align="left" id="perLabel" style="display:none" nowrap="nowrap"><fmt:message key="stat.specifyPerson"/>:</td>
							<td  id="perContent" style="display:none" nowrap="nowrap">
								<input type="text" name="person" id="person" style="width:150px" value='${defalutValue }' onclick="selectPeopleFun_user()" readonly class="cursor-hand" />
								<input type="hidden" name="personIds" id="personIds" value="" />
							</td>
						</tr>
				</table>
			</form>
		</td>
	</tr>
</table>
<iframe name="exportExcel4Stat" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>