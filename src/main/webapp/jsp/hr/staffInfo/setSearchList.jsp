<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>    
<html>
<head>
<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
var  onlyLoginAccount_dep  = true;
var  onlyLoginAccount_level  = true;
var  onlyLoginAccount_post  = true;


	function query(){ 
	  
	    var department = document.getElementById("departmentId").value;	    //部门
	     var level = document.getElementById("levelId").value; 				//职务级别
	      var post = document.getElementById("postId").value;				//岗位
	      
	      var sex  = document.getElementById("sex").value;					//性别
	   	  var study = document.getElementById("study").value;				//学历
	      var polity = document.getElementById("polity").value;				//政治面貌
	      var marriage = document.getElementById("marriage").value;			//婚姻

		  var fromTime1  = document.getElementById("fromTime1").value;		//出生日期 -从
	   	  var toTime1 = document.getElementById("toTime1").value;			//出生日期 -到
	      var fromTime2 = document.getElementById("fromTime2").value;		//入职时间 -从
	      var toTime2 = document.getElementById("toTime2").value;			//入职时候 -到
	      
	      if(fromTime1 != "" && toTime1 != ""){
	             if(compareDate(fromTime1, toTime1) > 0){
	                 alert(v3x.getMessage("V3XLang.calendar_endTime_startTime"));
	                 return false;
	             }
	         }
	      if(fromTime2 != "" && toTime2 != ""){
	             if(compareDate(fromTime2, toTime2) > 0){
	                 alert(v3x.getMessage("V3XLang.calendar_endTime_startTime"));
	                 return false;
	             }
	         }
	      	     
	//window.opener.location.href= "${hrStaffURL}?method=highLevelQueryList&department="+department+"&level="+level+"&post="+post+"&sex="+sex+"&study="+study+"&polity="+polity+"&marriage="+marriage+"&fromTime1="+fromTime1+"&toTime1="+toTime1+"&fromTime2="+fromTime2+"&toTime2="+toTime2;
	    var returnValue = "method=highLevelQueryList&department="+department+"&level="+level+"&post="+post+"&sex="+sex+"&study="+study+"&polity="+polity+"&marriage="+marriage+"&fromTime1="+fromTime1+"&toTime1="+toTime1+"&fromTime2="+fromTime2+"&toTime2="+toTime2;
		transParams.parentWin.queryCallBack(returnValue);
	}
	
	function setDepartment(elements){
		if(!elements){
			return;
		}
		document.getElementById("department").value = getNamesString(elements);
    	document.getElementById("departmentId").value = getIdsString(elements,false);
	}
	function setLevel(elements){
		if(!elements){
			return;
		}
		document.getElementById("level").value = getNamesString(elements);
    	document.getElementById("levelId").value = getIdsString(elements,false);
	}
	function setPost(elements){
		if(!elements){
			return;
		}
		document.getElementById("post").value = getNamesString(elements);
    	document.getElementById("postId").value = getIdsString(elements,false);
	}
	function close1(){
		getA8Top().queryWin.close();
	}
	
</script>
<title><fmt:message key='hr.toolbar.salaryinfo.advanceQuery.label' bundle='${v3xHRI18N}' /></title>
</head>
<body scroll="no">
<v3x:selectPeople id="dep" panels="Department" maxSize="1" selectType="Department" jsFunction="setDepartment(elements)" />
<v3x:selectPeople id="level" panels="Level" maxSize="1" selectType="Level" jsFunction="setLevel(elements)" />
<v3x:selectPeople id="post" panels="Post" maxSize="1" selectType="Post" jsFunction="setPost(elements)" />
<table class="popupTitleRight" width="100%" align="center" border="0" height="100%"  cellspacing="0" cellpadding="0">
 <tr>
	<td height="20" class="PopupTitle"><fmt:message key='hr.toolbar.salaryinfo.advanceQuery.label' bundle='${v3xHRI18N}' /></td>
 </tr>
 <tr>
	<td>
<form name="advancedForm" action="" method="post">
	<input type="hidden" name="departmentId" id="departmentId" value="">
	<input type="hidden" name="levelId" id="levelId" value="">
	<input type="hidden" name="postId" id="postId" value="">
	
	<tr><td  class="padding15">
	<fieldset class="fieldset-align">
	<legend><fmt:message key='hr.staffInfo.staff.label' bundle='${v3xHRI18N}'/></legend>
	<table>
	<tr>
	<td><label><fmt:message key='hr.staffInfo.department.label' bundle='${v3xHRI18N}' /></label>:</td>
	<td><input type="text" size="10" name="department" id="department" value="" onClick="selectPeopleFun_dep()" readonly="readonly" class="cursor-hand"/></td>
	<td><label><fmt:message key="hr.organization.level.label"/></label>:</td>
	<td><input type="text" size="10" name="level" id="level" value="" onClick="selectPeopleFun_level()" readonly="readonly" class="cursor-hand"/></td>
	</tr>
	<tr>
	<td><label><fmt:message key="hr.statistic.station.label" bundle='${v3xHRI18N}'/></label>:</td>
	<td><input type="text" size="10" name="post" id="post" value="" onClick="selectPeopleFun_post()" readonly="readonly" class="cursor-hand"/></td>
	<td></td>
	<td></td>
	</tr>
	</table>
	</fieldset>
	</tr></td>
	<tr>
	<td  class="padding15">
	<fieldset class="fieldset-align">
	<legend><fmt:message key='hr.staffInfo.person.label' bundle='${v3xHRI18N}'/></legend>
	<table>
	<tr>
	<td><label><fmt:message key='hr.staffInfo.sex.label' bundle='${v3xHRI18N}'/></label>:</td>
	<td>
	<select style="width:80" name="sex" id="sex">
		<option value="-1"></option>
		<option value="1"><fmt:message key='hr.staffInfo.male.label' bundle='${v3xHRI18N}'/></option>
		<option value="2"><fmt:message key='hr.staffInfo.female.label' bundle='${v3xHRI18N}'/></option>
	</select>
	</td>
	<td><label><fmt:message key='hr.staffInfo.edulevel.label' bundle='${v3xHRI18N}'/></label>:</td>
	<td>
	<select style="width:80" name="study" id="study">
		<option value="-1"></option>
			     <option value="1"><fmt:message key="hr.staffInfo.edulevel.1" bundle="${v3xHRI18N}"/>
			     <option value="2"><fmt:message key="hr.staffInfo.edulevel.2" bundle="${v3xHRI18N}"/>
				 <option value="8"><fmt:message key="hr.staffInfo.edulevel.8" bundle="${v3xHRI18N}"/>
				 <option value="9"><fmt:message key="hr.staffInfo.edulevel.9" bundle="${v3xHRI18N}"/>
				 <option value="10"><fmt:message key="hr.staffInfo.edulevel.10" bundle="${v3xHRI18N}"/>
				 <option value="3"><fmt:message key="hr.staffInfo.edulevel.3" bundle="${v3xHRI18N}"/>
				 <option value="4"><fmt:message key="hr.staffInfo.edulevel.4" bundle="${v3xHRI18N}"/>
				 <option value="5"><fmt:message key="hr.staffInfo.edulevel.5" bundle="${v3xHRI18N}"/>
				 <option value="6"><fmt:message key="hr.staffInfo.edulevel.6" bundle="${v3xHRI18N}"/>
				 <option value="7"><fmt:message key="hr.staffInfo.edulevel.7" bundle="${v3xHRI18N}"/>
	</select>
	</td>
	</tr>
	<tr>
	<td><label><fmt:message key='hr.staffInfo.position.label' bundle='${v3xHRI18N}'/></label>:</td>
	<td>
	<select style="width:80" name="polity" id="polity">
				 <option value="-1"></option>
			     <option value="1"><fmt:message key="hr.staffInfo.position.1" bundle="${v3xHRI18N}"/>
				 <option value="3"><fmt:message key="hr.staffInfo.position.3" bundle="${v3xHRI18N}"/>
				 <option value="4"><fmt:message key="hr.staffInfo.position.4" bundle="${v3xHRI18N}"/>
			     <option value="2"><fmt:message key="hr.staffInfo.position.2" bundle="${v3xHRI18N}"/>
	</select>
	</td>
	<td><label style="width:50"><fmt:message key='hr.staffInfo.marriage.label' bundle='${v3xHRI18N}'/></label>:</td>
	<td>
	<select style="width:80" name="marriage" id="marriage">
		<option value="-1"></option>
			     <option value="1"><fmt:message key="hr.staffInfo.marriage.1" bundle="${v3xHRI18N}"/>
			     <option value="2"><fmt:message key="hr.staffInfo.marriage.2" bundle="${v3xHRI18N}"/>
				 <option value="3"><fmt:message key="hr.staffInfo.marriage.3" bundle="${v3xHRI18N}"/>
				 <option value="4"><fmt:message key="hr.staffInfo.marriage.4" bundle="${v3xHRI18N}"/>
	</select>
	</td>
	</tr>
	</table>
	</fieldset>	
	</td>
	</tr>
	<tr>
	<td  class="padding15">	
	<fieldset class="fieldset-align">
	<legend><fmt:message key='hr.staffInfo.date.label' bundle='${v3xHRI18N}'/></legend>
	<table>
	   <tr>
	      <td><fmt:message key='hr.staffInfo.birthday.label' bundle='${v3xHRI18N}'/>:</td>
	      <td><fmt:message key='hr.record.queryfromtime.label' bundle='${v3xHRI18N}'/>&nbsp;&nbsp;<input name="fromTime1" type="text" class="cursor-hand" id="fromTime1" onClick="whenstart('${pageContext.request.contextPath}',this,400,400)" value="" maxlength="10" readonly="readonly" size="10"></td>
	      <td><fmt:message key='hr.record.querytotime.label' bundle='${v3xHRI18N}'/>&nbsp;&nbsp;<input name="toTime1" type="text" class="cursor-hand" id="toTime1" onClick="whenstart('${pageContext.request.contextPath}',this,400,400)" value="" maxlength="10" readonly="readonly" size="10"></td>
	   </tr>
	    <tr>
          <td><fmt:message key='hr.staffInfo.workStartingDate.label' bundle='${v3xHRI18N}'/>:</td>
          <td><fmt:message key='hr.record.queryfromtime.label' bundle='${v3xHRI18N}'/>&nbsp;&nbsp;<input name="fromTime2" type="text" class="cursor-hand" id="fromTime2" onClick="whenstart('${pageContext.request.contextPath}',this,400,400)" value="" maxlength="10" readonly="readonly" size="10"></td>
          <td><fmt:message key='hr.record.querytotime.label' bundle='${v3xHRI18N}'/>&nbsp;&nbsp;<input name="toTime2" type="text" class="cursor-hand" id="toTime2" onClick="whenstart('${pageContext.request.contextPath}',this,400,400)" value="" maxlength="10" readonly="readonly" size="10"></td>
       </tr>
	</table>
	</fieldset>
		</td></tr>
	
	</form>
</td>
</tr>
<tr>
<td height="42" align="right" class="bg-advance-bottom">
	<input type="button" onClick="query()" value="<fmt:message key='hr.record.query.label' bundle='${v3xHRI18N}' />" class="button-default-2">
	<input type="button" onClick="close1()" value="<fmt:message key='hr.record.cancel.label' bundle='${v3xHRI18N}' />" class="button-default-2">
</td>	
</tr>
</center>
</table>
</fieldset>
</body>
</html>