<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<html>
<%@include file="head.jsp" %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
<script type="text/javascript">
var menuKey="1606";
showCtpLocation('F13_unitLog');

function dataToColony(elements){
    if (!elements) {
        return false;
    }
    var objectIds = getIdsString(elements);
    var objectNames = getNamesString(elements);
    //for(var i=0; i<elements.length; i++){
    //	objectIds += elements[i].type + "|" + elements[i].id + "|1,"; //TODO
    //}
    
    document.getElementById("selectPersonIds").value = objectIds;
    document.getElementById("personIds").value = objectNames;
    document.getElementById("personIds").title = objectNames;
}

function removeall(){
   window.location.reload() ;
}

function submitForm(){
  var theForm = document.getElementById("appLogForm");
  if(theForm) {
    var beginDate = document.getElementById("beginDate").value;
	var endDate = document.getElementById("endDate").value;
	if(compareDate(endDate, beginDate) < 0){
		alert(v3x.getMessage("LogLang.log_search_overtime")) ;
		//alert("时间问题") ;
		return false;
	}
    theForm.target = "dataIFrame" ;
    theForm.action = "${appLog}?method=accountQueryAppLog" ;
    theForm.submit() ;
  var oSearchTitle = document.getElementById('searchTitle');
  if (oSearchTitle)
  	oSearchTitle.innerHTML = "<fmt:message key='common.query.result' bundle='${v3xCommonI18N}' />";
  }
}
onlyLoginAccount_user=true;
</script>
</head>
<body scroll="no" class="padding5">
<v3x:selectPeople id="user" panels="Department,Outworker,Admin" selectType="Account,Department,Member,Admin" departmentId="${v3x:currentUser().departmentId}" 
	jsFunction="dataToColony(elements)" viewPage="${viewPage}" minSize="0" />
<script type="text/javascript">
	<!--
	var isConfirmExcludeSubDepartment_user = true;
	var showAdminTypes_user="${admin}";
	//-->
</script>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0"  class="main-bg">
	<tr>
		<td height="20" class="webfx-menu-bar" colspan="2">	
			<script type="text/javascript">
				var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
		    	myBar.add(new WebFXMenuButton("exportExcel", "<fmt:message key='common.toolbar.exportExcel.label' bundle='${v3xCommonI18N}' />", "javascript:exportExcel('AppLog')", [2,6], "", null));
		    	myBar.add(new WebFXMenuButton("print", "<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />", "javascript:doPrint('AppLog')", [1,8], "", null));    	
		    	document.write(myBar);
		    	document.close();
		    </script>			
		</td>
	</tr>
	<tr>
		<td align="left" valign="top"  colspan="2" class="border-top">
		  <form action="" method="post" name="appLogForm"  id = "appLogForm" onsubmit="" >
		   <table width="" border="0" cellspacing="8" cellpadding="0">
		     <tr>
		       <td align="right" width="15%"><fmt:message key="log.toolbar.title.category"/>: </td>
		       <td width="10%" align="">
					<%@ include file="modules.jsp"%>        
		        </td>
		        <td align="right"  nowrap="nowrap"> <fmt:message key="log.toolbar.title.stuff"/>:</td>
		       <td width="10%"> 	
		        <input type="text" readonly="readonly" class="cursor-hand"  onclick="selectPeopleFun_user()" id="personIds"  name="personIds" title="" value="">
		        <input type="hidden" name="selectPersonIds" id="selectPersonIds" value="">
		       </td>
		       
		       <td align="left"><input class="deal_btn" onmouseover="javascript:this.className='deal_btn_over'" onmouseout="javascript:this.className='deal_btn'" type="button" value='<fmt:message key="common.button.condition.search.label" bundle="${v3xCommonI18N}" />' class="button-default-2" onclick="submitForm()"/></td>
		     </tr>
		     
		     
		     <tr>
		       <td align="right"><fmt:message key="log.toolbar.title.operationTime"/>:</td>
		       <td width="25%" align="" colspan="3">
			           <input type="text" style="width:150px;" class="input-date cursor-hand" id="beginDate" name="beginDate"  value='<fmt:formatDate value="${firstDay}" type="Date" dateStyle="full" pattern="yyyy-MM-dd"/>' readonly="readonly" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);">—
		               <input type="text" style="width:150px;" class="input-date cursor-hand" id="endDate"  name="endDate"  value='<fmt:formatDate value="${today}" type="Date" dateStyle="full" pattern="yyyy-MM-dd"/>' readonly="readonly" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);">
		        </td>
		        <td>
		        <%--<input type="button" value='<fmt:message key="common.button.reset.label" bundle="${v3xCommonI18N}" />' class="button-default-2" onclick="removeall()"/>--%>
		        </td>
		     </tr>
	    	 </table>
		  </form>
	  </td>
	</tr>
	<tr>
		<td height="100%" valign="top" colspan="2" bgcolor="">
		    <iframe src="${appLog}?method=listAllAccountAppLogData" name="dataIFrame" id="dataIFrame"
		            frameborder="0" marginheight="0" marginwidth="0" height="100%" width="100%" scrolling="auto">
		    </iframe>
		</td>
	</tr>
</table>
<iframe name="appLogDataExportExcel" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>