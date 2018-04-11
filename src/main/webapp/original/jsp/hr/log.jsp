<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="hr.log.view.label" bundle="${v3xHRI18N}" /></title>

<script type="text/javascript">
var  onlyLoginAccount_second  = true;

window.onload = function(){
	showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
}

function searchLog(){
	var model = document.getElementById("model").value;
	var condition = document.getElementById("condition").value;
	var fromTime = document.getElementById("fromTime").value;
	var toTime = document.getElementById("toTime").value;
	var type = document.getElementById("type").value;
	
	var textfield = "";
	if(fromTime>toTime){
		alert(v3x.getMessage("HRLang.hr_message_checkdate_startdoesnotlateend"));
		return false;
	}
	if(condition == 'con'){
           alert(v3x.getMessage("HRLang.hr_staffTransfer_search_no_condition"));
           return false;
    }
    if(condition == 'actionTime' && (fromTime == '' || toTime == '')){
           alert(v3x.getMessage("HRLang.hr_staffTransfer_search_no_content"));
           return false;
    }
	if(condition == 'actionTime'){
		textfield = fromTime+","+toTime;
	}
	if(condition == 'actionType'){
		textfield = type;
	}
	if(condition == 'actionAll'){
		textfield = type;
	}
	if(condition == 'actionName'){
	var member = searchForm.content1.value;
	  if(member==""){
               alert(v3x.getMessage("HRLang.hr_staffTransfer_search_no_content"));
               return false;
       }
	
		textfield = member;
	}
	 self.location.replace("${hrLogURL}?method=searchLog&textfield="+textfield+"&condition="+condition+"&model="+model);
}

function searchLogs(){
	 var theForm = document.getElementsByName("searchForm")[0];
     var condition = theForm.condition;
     if(condition.value == 'actionTime') {         
         var input = document.getElementById("actionTimeDiv").getElementsByTagName('input');
         var startDate= input[0].value;
         var endDate = input[1].value;
         if(startDate != "" && endDate != ""){
             if(compareDate(startDate, endDate) > 0){
                 alert(v3x.getMessage("V3XLang.calendar_endTime_startTime"));
                 return false;
             }
         }
     }
     doSearch();
}

function exportExcel(){
    
	var model = document.getElementById("model").value;
	var condition = document.getElementById("exCondition").value;
	var textfield = document.getElementById("textfield").value;
	var textfield1 = document.getElementById("textfield1").value;
	var isLoad = document.getElementById("isLoad").value;
	var size=document.getElementById("size").value;
	var ids = document.getElementById("ids").value;
	
	
    if(size==0){
       alert(v3x.getMessage("HRLang.hr_export_noData"));
       return false;
    }
    
	window.location ="<c:url value='/hrLog.do'/>?method=exportExcel&model="+model+"&condition="+condition+"&textfield="+textfield+"&isLoad="+isLoad+"&ids="+ids+"&textfield1="+textfield1;
   // exportIt(exportedURL);
    //window.location = "${hrLogURL}?method=exportExcel&model="+model+"&condition="+condition+"&textfield="+textfield+"&isLoad="+isLoad;
 }
 
 function setPeopleFieldsSecond(elements)
{
	if(!elements){
		return;
	}
	document.getElementById("peopleValueSecond").value=getNamesString(elements);
	document.getElementById("peopleIdSecond").value=getIdsString(elements,false);

}
 
 function printTransferList(){
	//printIt($('#form1').html());
	   var aa= "";
	   var mm = $('#form1').html();
	   var list1 = new PrintFragment(aa,mm);
	   var tlist = new ArrayList();
	   tlist.add(list1);
	   var cssList=new ArrayList();
	   cssList.add("/seeyon/common/skin/default/skin.css");
	   printList(tlist,cssList);
}

window.onbeforeunload = function(){
	try{
		var parentWin = v3x.getParentWindow();
		if(parentWin && parentWin.logWin){
			parentWin.logWin = null;
		}
	}catch(e){}
}
</script>

<c:set value="${v3x:parseElements(auList, 'id', 'entityType')}" var="auList"/>
<v3x:selectPeople id="per" panels="Department,Team"
	selectType="Member,Team,Department" minSize="0"
	departmentId="${sessionScope['com.seeyon.current_user'].departmentId}"
	originalElements="${auList}" jsFunction="setPeopleFields(elements)" />
<script type="text/javascript">
    var authlist="${authlist.authlist}";
    //alert(authlist);
    //elements_per = parseElements(authlist);
    
</script>
<v3x:selectPeople id="second" panels="Department"
	selectType="Member"
	departmentId="${sessionScope['com.seeyon.current_user'].departmentId}"
	jsFunction="setPeopleFieldsSecond(elements)" maxSize="1" />
</head>
	
</head>

<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr>
  <td>
	<script>	
	//def toolbar
	var myBar1 = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	
	//add buttons
	myBar1.add(new WebFXMenuButton("export", "<fmt:message key='hr.toolbar.salaryinfo.export.label' bundle='${v3xHRI18N}' />", "exportExcel()", "<c:url value='/common/images/toolbar/bodyType_excel.gif'/>"));
	myBar1.add(new WebFXMenuButton("print", "<fmt:message key='hr.record.application.print.label' bundle='${v3xHRI18N}'/>",  "printTransferList()", "<c:url value='/common/images/toolbar/print.gif'/>"));	
	document.write(myBar1);
	document.close();
	</script>
</td>		
	<td class="webfx-menu-bar" width="80%" height="100%"><form action="" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
	    <input type="hidden" name="model" id="model" value="${model}" />
	    <input type="hidden" name="method" value="${param.method}" />
		<input type="hidden" name="size"  id="size" value="${size}" />
		<input type="hidden" id="exCondition" value="${param.condition}" />
		<input type="hidden" id="textfield" value="${param.textfield}" />
		<input type="hidden" id="textfield1" value="${param.textfield1}" />
		<input type="hidden" id="isLoad" value="${isLoad}" />
		<input type="hidden" id="ids" value="${ids}" />
		<div class="div-float-right" >
			<div class="div-float">
					<select name="condition" id="condition" onChange="showNextCondition(this)" class="condition">
				    	<option value="con"><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
					    <option value="actionType"><fmt:message key="hr.log.operation.type.label" bundle="${v3xHRI18N}"/></option>
					    <option value="actionTime"><fmt:message key="hr.log.operationTime.label" bundle="${v3xHRI18N}" /></option>
					<!--     <option value="actionAll"><fmt:message key="hr.salary.search.all.label" bundle="${v3xHRI18N}" /></option>后台方法写好！--> 
					    <option value="actionName"><fmt:message key="hr.log.userName.label" bundle="${v3xHRI18N}" /></option>
				  	</select>
			  	</div>
			 <!--   	<div id="conDiv" class="div-float"><input type="text" name="con" class="textfield" /></div>-->
			  	<div id="actionTypeDiv" class="div-float hidden">
			  	<c:choose>
			  		<c:when test="${model == 'transfer'}">
				  		<select name="textfield" id="textfield" class="textfield">
				  			<option value="hr.transferType.tobeFullMember.label" ><fmt:message key="hr.transferType.tobeFullMember.label" bundle="${v3xHRI18N}"/></option>
				  			<option value="hr.transferType.transferPost.label" ><fmt:message key="hr.transferType.transferPost.label" bundle="${v3xHRI18N}"/></option>
				  			<option value="hr.transferType.upgrade.label" ><fmt:message key="hr.transferType.upgrade.label" bundle="${v3xHRI18N}"/></option>
				  			<option value="hr.transferType.demotion.label" ><fmt:message key="hr.transferType.demotion.label" bundle="${v3xHRI18N}"/></option>
				  			<option value="hr.transferType.dimission.label" ><fmt:message key="hr.transferType.dimission.label" bundle="${v3xHRI18N}"/></option>
				  			<option value="hr.transferType.other.label" ><fmt:message key="hr.transferType.other.label" bundle="${v3xHRI18N}"/></option>
				  		</select>
			  		</c:when>
			  		<c:when test="${model == 'staff'}">
			  			<select name="textfield" id="textfield" class="textfield">
			  				<option value="hr.staffInfo.operation.add.label"><fmt:message key="hr.staffInfo.operation.add.label" bundle="${v3xHRI18N}" /></option>
			  				<option value="hr.staffInfo.operation.delete.label"><fmt:message key="hr.staffInfo.operation.delete.label" bundle="${v3xHRI18N}" /></option>
			  				<option value="hr.staffInfo.operation.update.label"><fmt:message key="hr.staffInfo.operation.update.label" bundle="${v3xHRI18N}" /></option>
			  			</select>
			  		</c:when>
			  	</c:choose>
			  	</div>
				<div id="actionTimeDiv" class="div-float hidden">
			
					<input type="text" class="textfield" id="textfield"  style="cursor:hand"
	           		 name="textfield"  onClick="whenstart('/seeyon',this,520,205)" readonly
	           		value="">-
	           		<input type="text" class="textfield1" id="textfield1" style="cursor:hand"
	           		 name="textfield1"  onClick="whenstart('/seeyon',this,520,205)" readonly
	           		value="">
				</div>
				<!--  
					<c:if test="${model == 'staff'}">
						<div id="actionAllDiv" class="div-float hidden">
							<select name="textfield" id="textfield" class="textfield">
								<option value="hr.salary.search.all.label"><fmt:message key="hr.salary.search.all.label" bundle="${v3xHRI18N}" /></option>
							</select>
						</div>
					</c:if>	
			
				-->
				<div id="actionNameDiv" class="div-float hidden"><input type="text" readonly
					id="peopleValueSecond" deaultvalue="<fmt:message key="hr.default.people.value" bundle="${v3xHRI18N}" />" value="<fmt:message key="hr.default.people.value" bundle="${v3xHRI18N}" />"
					name="textfield1" size="20" onclick="selectPeopleFun_second()">
					<input type="hidden" id="peopleIdSecond" name="textfield">
				</div>
						
			
			<div onclick="javascript:searchLogs()" class="condition-search-button"></div>
		</div></form>
	</td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0"
	cellpadding="0" height="95%">
	<tr>

		<td colspan="2">
			<div class="scrollList">
				<form id="form1" method="post">
					<v3x:table data="${webOperationLogs}" var="webOperationLog" htmlId="operationLoglist" leastSize="${leastSize}" dragable="false">
					<v3x:column width="8%" label="hr.log.userName.label"
							value="${v3x:showMemberName(webOperationLog.operationLog.memberId)}" className="sort"
					 		symbol="..." alt="${v3x:showMemberName(webOperationLog.operationLog.memberId)}"
					></v3x:column>
					<v3x:column width="10%" label="hr.log.operation.type.label"	className="sort">
						<fmt:message key="${webOperationLog.operationLog.actionType}" bundle="${v3xHRI18N}" />
					</v3x:column>			        
			        
					<v3x:column width="10%" type="String" label="hr.log.operationTime.label" className="sort">
		               <fmt:formatDate value="${webOperationLog.operationLog.actionTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd"  />
                 	</v3x:column>
                 	 
                 	<v3x:column width="10%" label="hr.log.ip.label"
							value="${webOperationLog.operationLog.remoteIp}" className="sort"
					 		symbol="..." alt="${webOperationLog.operationLog.remoteIp}"
					></v3x:column>
                 	
                 	<v3x:column width="16%" type="String" label="hr.log.operation.note.label" className="sort">
                 	<c:choose>
                 		<c:when test="${model == 'transfer'}">
	                 		<fmt:message key="${webOperationLog.operationLog.contentLabel}">
			               		<fmt:param value="${webOperationLog.staffTransferLog.staffName}" />
			               	</fmt:message>
			               	<fmt:message key="${webOperationLog.operationLog.actionType}" bundle="${v3xHRI18N}" />
		               	</c:when>
		               	<c:when test="${model == 'staff'}">
		               		<fmt:message key="${webOperationLog.operationLog.contentLabel}">
			               		<fmt:param value="${webOperationLog.operation}" />
			               	</fmt:message>
		               	</c:when>
		            </c:choose>
                 	</v3x:column>
                 					
					</v3x:table>
				
				</form>
			</div>
		</td>
	</tr>
</table>

</body>
</html>