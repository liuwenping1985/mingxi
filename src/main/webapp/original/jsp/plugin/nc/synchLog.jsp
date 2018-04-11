<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>hand</title>
<%@include file="header_synchLog.jsp"%>
<c:set var="mapTypeDept" value="<%=com.seeyon.apps.ntp.util.NcUtil.getNCCorpMapA8DepartmentType()%>"></c:set>
<c:set var="mapTypeAccount" value="<%=com.seeyon.apps.ntp.util.NcUtil.getNCCorpMapA8AccountType()%>"></c:set>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript">
	//导航菜单
	showCtpLocation("F21_tolog");
	//如果有查询条件进行初始化
	function init(){
		if("${condition}" != ""){
			//document.getElementById("condition").fireEvent("onChange");
			showNextSpecialCondition(document.getElementById("condition"));
		}
	}
	
	function doSearch() {
		var mname="";
		var accountId="";
		var cntaccountid="";
		var searchObjValue = document.getElementById('condition').value;
		if(searchObjValue=='createDate'){
			 var timeFrom = document.getElementById('dataTextFieldFrom').value;
			 var timeTo = document.getElementById('dataTextFieldTo').value;
			 if(timeFrom != "" && timeTo !=""){
				 if(!timeCompare(timeFrom, timeTo)){
					 return false;
				 }
			 }
		}
		document.forms[0].submit();
	}
	 function timeCompare(a, b) {
		    var arr = a.split("-");
		    var starttime = new Date(arr[0], arr[1], arr[2]);
		    var starttimes = starttime.getTime();

		    var arrs = b.split("-");
		    var lktime = new Date(arrs[0], arrs[1], arrs[2]);
		    var lktimes = lktime.getTime();

		    if (starttimes > lktimes) {
		        alert("<fmt:message key='ntp.org.synchLog.time'/>");
		        return false;
		    }
		    else
		        return true;

		}
	function filterLogsList(flag){
		var flagNum = parseInt(flag);
		switch(flagNum){
			<%--筛选部门--%>
			case 0:
					location.href="${urlNCSynchLog}?method=synchLog&type=department";
					break;
			<%--筛选岗位--%>
			case 1:
					location.href="${urlNCSynchLog}?method=synchLog&type=post";
					break;
			<%--筛选人员--%>
			case 2:
					location.href="${urlNCSynchLog}?method=synchLog&type=people";
					break;
			<%--全部--%>
			case 3:
					location.href="${urlNCSynchLog}?method=synchLog";
					break;	
		}
	}
	
	function openDetailWin(recordId){
		v3x.openWindow({
	        url: "${urlNCSynchLog}?method=synchLogDetail&recordId=" + recordId,
	        width: 800,
	        height: 450,
	        dialogType:"open",
		    resizable: "yes"
	    });
	}
	
   function openDetailFail(recordId){
     v3x.openWindow({
        url: "${urlNCSynchLog}?method=synchLogDetail&recordId=" + recordId+"&expressionType=option"+"&expressionValue="+encodeURIComponent("失败"),
        width: 800,
        height: 450,
        dialogType:"open",
        resizable: "yes"
    });
    }
	function showNextSpecialCondition(conditionObject) {
		var options = conditionObject.options;
		for (var i = 0; i < options.length; i++) {
		    var d = document.getElementById(options[i].value + "Div");
		    if (d) {
		        d.style.display = "none";
		 	}
		}
		if(document.getElementById(conditionObject.value + "Div") == null) {
			return;
		}
		document.getElementById(conditionObject.value + "Div").style.display = "block";
	
	}
	
	function deleteSynchLog(){
		
		var ids = document.getElementsByName('id');
		var hasMoreElement = false; 
		for(var i = 0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				hasMoreElement = true;
				break;
			}
		}
		if(!hasMoreElement){
			alert("<fmt:message key='member.delete' bundle="${v3xOrganizationIl8n}"/>");
		}else{
			if(confirm("<fmt:message key='ntp.user.filder.person.question'/>") == true){
			    disableButton("delete");
				var listForm = document.getElementById("listForm");
				listForm.action="${urlNCSynchLog}?method=delSynchLog";
				listForm.submit();
			}
		}
}
	  
/**
 * 搜索按钮事件
 */
//待修改getA8Top().showLocation(null, "<fmt:message key='ntp.org.synchron' />", "<fmt:message key='ntp.org.synchron.log' />");
</script>
</head>
<body  scroll="no" onload="init()">

<fmt:message key="ntp.org.hand.account" var="accountName"/>
<fmt:message key="ntp.org.hand.dept" var="deptName"/>
	
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
    	<table class="border-left border-right" height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
    	<tr>
		<td height="22" class="webfx-menu-bar border-top">
		<script type="text/javascript">
			var myBar = new WebFXMenuBar("${pageContext.request.contextPath}","");
			myBar.add(new WebFXMenuButton("all","<fmt:message key='common.toolbar.all.label' bundle = '${v3xCommonI18N}'/>","filterLogsList(3)",[7,9],"", null));
			myBar.add(new WebFXMenuButton("add","<fmt:message key='common.toolbar.department.label' bundle = '${v3xCommonI18N}'/>","filterLogsList(0)",[9,2], "",null));
			myBar.add(new WebFXMenuButton("mod","<fmt:message key='common.toolbar.post.label' bundle = '${v3xCommonI18N}'/>","filterLogsList(1)",[9,3],"", null));
			myBar.add(new WebFXMenuButton("del","<fmt:message key='common.toolbar.people.label' bundle = '${v3xCommonI18N}'/>","filterLogsList(2)",[9,4],"", null));
			myBar.add(new WebFXMenuButton("delete", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "deleteSynchLog();", [1,3], "", null));
			document.write(myBar);
	    	document.close();
	    	</script>
	    </td>
		<td class="webfx-menu-bar border-top">
			<form action="${urlNCSynchLog}" name="searchForm" id="searchForm" method="get" onkeypress="doSearchEnter()" onsubmit="return false">
				<input type="hidden" name="type" value="" id="type"/>
				<input type="hidden" value="synchLog" name="method"/>
				<div class="div-float-right">
					<div class="div-float">
						<select name="condition" id="condition" onChange="showNextSpecialCondition(this)" class="condition">
					    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
					    	<option value="3" ${condition == '3'?'selected':''}><fmt:message key="ntp.org.synchron.history.all"/></option>
						    <option value="subject" ${condition == 'subject'?'selected':''}><fmt:message key="ntp.org.synchron.synType"/></option>
						    <option value="importantLevel" ${condition == 'importantLevel'?'selected':''}><fmt:message key="ntp.org.synchron.type"/></option>
						    <option value="createDate" ${condition == 'createDate'?'selected':''}><fmt:message key="ntp.org.auto.time"/></option>
					  	</select>
				  	</div>
				  	<div id="subjectDiv" class="div-float hidden">
				  		<select name="textfieldSubject" class="textfield" id="textfieldSubject">
				  			<option value="department" ${textfieldSubject == 'department'?'selected':''}><fmt:message key="ntp.org.synchron.synType.2"/></option>
				  			<option value="post" ${textfieldSubject == 'post'?'selected':''}><fmt:message key="ntp.org.synchron.synType.3"/></option>
				  			<option value="people" ${textfieldSubject == 'people'?'selected':''}><fmt:message key="ntp.org.synchron.synType.4"/></option>
				  		</select>
				  	</div>
				  	<div id="importantLevelDiv" class="div-float hidden">
				  		<select name="importantLevel" class="textfield" id="importantLevel">
				  			<option value="auto" ${importantLevel == 'auto'?'selected':''}><fmt:message key="ntp.org.synchron.type.auto"/></option>
				  			<option value="hand" ${importantLevel == 'hand'?'selected':''}><fmt:message key="ntp.org.synchron.type.hand"/></option>
				  			<option value="require" ${importantLevel == 'require'?'selected':''}><fmt:message key="ntp.org.synchron.type.require"/></option>
				  		</select>	
				  	</div>
				  	<div id="createDateDiv" class="div-float hidden">
				  		<input type="text" id="dataTextFieldFrom" name="textfield" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" value="${textfield}" readonly>
			  			-
			  			<input type="text" id="dataTextFieldTo" name="textfield1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" value="${textfield1}" readonly>
				  	</div>
				  	<div onclick="doSearch()" class="condition-search-button"></div>
			  	</div>
			</form>
		</td>
	</tr>
    	</table>
    </div>
    <div class="center_div_row2" id="scrollListDiv">
    	<form name="listForm" id="listForm" method="post" onsubmit="return false">
				<v3x:table data="synRecordList" var="synchLog">
				<v3x:column width="4%" align="center"
				label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
				<input type="checkbox" name="id"
					value="${synchLog.id}">
				</v3x:column>
				<v3x:column width="20%" type="String" label="ntp.org.list.name${v3x:getSysFlagByName('NCSuffix')}" className="sort">
				<c:choose>
					<c:when test="${synchLog.mapType == mapTypeDept}">
						${v3x:getOrgEntity('Department',synchLog.mapLocalId).name}
						<c:if test="${v3x:getSysFlagByName('sys_isEnterpriseVer')!=true}">
						      --(${deptName})
						</c:if> 
					</c:when>
					<c:when test="${synchLog.mapType == mapTypeAccount}">
						${v3x:getAccount(synchLog.mapLocalId).name}
						<c:if test="${v3x:getSysFlagByName('sys_isEnterpriseVer')!=true}">
						--(${accountName})
						</c:if> 
					</c:when>
				</c:choose>
				</v3x:column>
				<v3x:column width="20%" type="String" label="ntp.org.list.nc.org" className="sort">
					${ncAccountsMap[synchLog.mapGuid].unitname}
				</v3x:column>
				<v3x:column width="8%" type="String" label="ntp.org.synchron.synType" className="sort">
					<fmt:message key="ntp.org.synchron.synType.${synchLog.synType}"/>
				</v3x:column>
				<v3x:column width="8%" type="String" label="ntp.org.synchron.type" className="sort">
					<fmt:message key="ntp.org.synchron.type.${synchLog.opType == 0?'auto':(synchLog.opType == 1 ? 'hand':'require')}"/>
				</v3x:column>
				<v3x:column width="15%" type="String" label="ntp.org.auto.time" className="sort">
					<fmt:formatDate value="${synchLog.dt}" pattern="yyyy-MM-dd HH:mm:ss" />
				</v3x:column>
				<v3x:column width="5%" type="Integer" label="ntp.org.synchron.sucess" className="sort">
                    ${synchLog.oknum}
                </v3x:column>
                <v3x:column width="5%" type="Integer" label="ntp.org.synchron.fail" className="sort">
                    <c:choose>
                    <c:when test="${synchLog.failnum == 0}">
                       ${synchLog.failnum}
                    </c:when>
                    <c:otherwise>
                       <a href="javascript:openDetailFail('${synchLog.id}')"> ${synchLog.failnum}</a>
                    </c:otherwise>
                </c:choose>
                </v3x:column>
				<v3x:column width="10%" label="ntp.org.synchron.log.detail" className="cursor-hand like-a sort">
					<a href="javascript:openDetailWin('${synchLog.id}')"><fmt:message key="ntp.org.synchron.log.detail.${synchLog.synType}" /></a>
				</v3x:column>
				</v3x:table>
				</form>
    </div>
  </div>
</div>
</body>
</html>