<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<script type="text/javascript">
<!--
	function deleteApp(){
		var dynamicForm = document.getElementById("dynamicForm").value;
		var tableName = parent.listFrame.document.getElementById("tableName").value;
		var ids = getSelectIds(parent.listFrame);
		if (ids == '') {
			alert(v3x.getMessage("HRLang.hr_staffInfo_choose_delete"));
			return false;
		}
		if(!confirm(v3x.getMessage("HRLang.hr_staffInfo_is_delete")))
			return false;
		parent.listFrame.location.href = "${hrAppURL}?method=deleteForms&dynamicForm="+dynamicForm+"&ids="+ids+"&tableName="+tableName;
		
	}
	
	function searDynamicForm(){
		var condition = document.getElementById("condition").value;
		var staffName = document.getElementById("staffName").value;
		var fromTime = document.getElementById("fromTime").value;
		var toTime = document.getElementById("toTime").value;
		var tableName = parent.listFrame.document.getElementById("tableName").value;
		var type = document.getElementById("dynamicForm").value;
		if(condition == "con"){
			alert(v3x.getMessage("HRLang.hr_staffTransfer_search_no_condition"));
			return false;
		}
		if(condition == "staffName" && (staffName == "" || staffName == null)){
			alert(v3x.getMessage("HRLang.hr_staffTransfer_search_no_content"));
			return false;
		}
		if(condition == "formDate" && (fromTime == "" || fromTime == null || toTime == "" || toTime == null)){
			alert(v3x.getMessage("HRLang.hr_staffTransfer_search_no_content"));
			return false;
		}
		if(condition == "staffName"){
			parent.listFrame.location.href = "${hrAppURL}?method=searchFormByName&type="+type+"&staffName="+encodeURI(staffName)+"&tableName="+tableName;
		}else if(condition == "formDate"){
			parent.listFrame.location.href = "${hrAppURL}?method=searchFormByDate&type="+type+"&fromTime="+fromTime+"&toTime="+toTime+"&tableName="+tableName;
		}
	}
//-->
</script>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
	<td height="25" width="40%">
    <script>	
	//def toolbar
	var myBar1 = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","gray");
	
	//add buttons
	myBar1.add(new WebFXMenuButton("deleteApp", "<fmt:message key='hr.toolbar.salaryinfo.delete.label' bundle='${v3xHRI18N}' />", "deleteApp()", "<c:url value='/common/images/toolbar/delete.gif'/>"));
	
	//WebFXMenuButton对象参数：（HtmlId, 显示名称, 按钮事件, 图标, alt/title, 子菜单）
	document.write(myBar1);
	document.close();
	</script>
	</td>
	<td class="webfx-menu-bar-gray" width="50%" height="100%"><form action="" name="searchForm" id="searchForm" method="post" onsubmit="return false" style="margin: 0px">
		<div class="div-float-right" >
			<div class="div-float">
					<select name="condition" id="condition" onChange="showNextCondition(this)" class="condition">
				    	<option value="con"><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
					    <option value="staffName"><fmt:message key="hr.salary.search.name.label" bundle="${v3xHRI18N}" /></option>
					    <option value="formDate"><fmt:message key="hr.form.search.applicationDate.label" bundle="${v3xHRI18N}" /></option>
				  	</select>
			  	</div>
			  	<div id="conDiv" class="div-float"><input type="text" name="con" class="textfield" /></div>
			  	<div id="staffNameDiv" class="div-float hidden"><input type="text" name="staffName" id="staffName" class="textfield"></div>
				<div id="formDateDiv" class="div-float hidden">
			
				<input type="text" inputName="<fmt:message key="plan.body.endtime.label"/>"  style="cursor:hand"
           		validate="notNull" name="fromTime" id="fromTime"  onClick="whenstart(v3x.baseURL,this,775,150)" readonly
           		value="<fmt:formatDate value="${fromTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>">-
           		<input type="text" inputName="<fmt:message key="plan.body.endtime.label"/>"  style="cursor:hand"
           		validate="notNull" name="toTime" id="toTime"  onClick="whenstart(v3x.baseURL,this,1075,150)" readonly
           		value="<fmt:formatDate value="${toTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>">
			</div>
			<div onclick="javascript:searDynamicForm()" class="condition-search-button"></div>
		</div></form>
	</td>
  </tr>
  <tr>
  <td>
  	<input type="hidden" id="dynamicForm" value="${dynamicForm}" />
  </td>
  </tr>
</table>
