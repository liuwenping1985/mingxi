<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<c:set value="${v3x:currentUser()}" var="currentUser" />
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
</head>
<body>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
	<td width="50%">
		<script type="text/javascript">
			onlyLoginAccount_salaryDept = true;
			
			function setSearchPeopleFields(elements) {
				document.getElementById("salaryDeptId").value = getIdsString(elements, false);
				document.getElementById("salaryDeptName").value = getNamesString(elements);
			}
			
			var myBar1 = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
		
			myBar1.add(new WebFXMenuButton("newSalaryInfo", "<fmt:message key='hr.toolbar.salaryinfo.new.label' bundle='${v3xHRI18N}' />", "newSalaryInfo()", [1,1]));
			myBar1.add(new WebFXMenuButton("modify", "<fmt:message key='hr.staffInfo.modify.label' bundle='${v3xHRI18N}' />", "modify()", [1,2], "", null));
			myBar1.add(new WebFXMenuButton("deleteSalary", "<fmt:message key='hr.toolbar.salaryinfo.delete.label' bundle='${v3xHRI18N}' />", "deleteSalary()", [1,3]));
			myBar1.add(new WebFXMenuButton("import", "<fmt:message key='hr.toolbar.salaryinfo.import.label' bundle='${v3xHRI18N}' />", "importExcel()", [2,6]));
			myBar1.add(new WebFXMenuButton("export", "<fmt:message key='common.toolbar.download.label' bundle='${v3xCommonI18N}' />", "exportTemplate()", [3,4]));
			myBar1.add(new WebFXMenuButton("setNewPassWrod", "<fmt:message key='system.password.protecd.person'/>", "setMembersNewPassWrod()", [9,9]));
			//这里是数据交接的按钮
			var forwardSubItems = new WebFXMenu;
			var listMembers = '${listMembers}';
			var members=eval(listMembers);
			for(var i=0;i<members.length;i++){
				var userName = members[i].userName;
				var userId = members[i].userId;
				forwardSubItems.add(new WebFXMenuItem("transferSalary"+i, userName, "transferSalary('"+userId+"','"+userName+"')", ""));
			}
			myBar1.add(new WebFXMenuButton("forward", "<fmt:message key='hr.transfer.selectpeople' bundle='${v3xHRI18N}' />", "",[17,1],"<fmt:message key='common.advance.label' bundle='${v3xCommonI18N}'/>", forwardSubItems));
			document.write(myBar1);
			document.close();
		</script>
	</td>
	<td><input type="hidden" id="exCondition" value="" /><input type="hidden" id="exStaffName" value="" /></td>
	<td><input type="hidden" id="exFromTime" value="" /><input type="hidden" id="exToTime" value="" /></td>
	<td class="webfx-menu-bar" width="50%" height="100%">
		<form action="" name="searchForm" id="searchForm" method="post" onSubmit="return false" style="margin: 0px">
			<div class="div-float-right" >
				<div class="div-float">
					<select name="condition" id="condition"  onChange="showNextCondition(this)" class="condition">
				    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
					    <option value="staffName"><fmt:message key="hr.salary.search.name.label" bundle="${v3xHRI18N}" /></option>
					    <option value="salaryDate"><fmt:message key="hr.salary.search.mounth.label" bundle="${v3xHRI18N}" /></option>
					    <option value="salaryDept"><fmt:message key="hr.salary.dept.label" bundle='${v3xHRI18N}'/></option>
				  	</select>
			  	</div>
			  	<div id="staffNameDiv" class="div-float hidden"><input type="text" name="staffName" class="textfield" onKeyDown="onEnterPress()"></div>
				<div id="salaryDateDiv" class="div-float hidden">
					<input type="text" class="textfield" id="fromTime" style="cursor:hand;width: 80px;" name="fromTime" onClick="selectDates('fromTime'); return false;" readonly value="">-
	           		<input type="text" class="textfield" id="toTime" style="cursor:hand;width: 80px;" name="toTime" onClick="selectDates('toTime'); return false;" readonly value="">
				</div>
				<div id="salaryDeptDiv" class="div-float hidden">
					<v3x:selectPeople id="salaryDept" panels="Department" selectType="Department" departmentId="${currentUser.departmentId}" jsFunction="setSearchPeopleFields(elements)" maxSize="1" />
					<input type="text" name="salaryDeptName" id="salaryDeptName" class="textfield" readonly="true" onClick="selectPeopleFun_salaryDept()" />
					<input type="hidden" name="salaryDeptId" id="salaryDeptId" />
				</div>
				<div onClick="javascript:searchSalarys()" class="condition-search-button"></div>
			</div>
		</form>
		<div class="hidden">
			<form name="formExcel" method="post" target="formExcelIframe">
				<table>
				  	<tr id="attachmentTR" class="bg-summary" style="display:none;">
			      		<td nowrap="nowrap" height="18" class="bg-gray" valign="bottom"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /></td>
			      		<td colspan="8" valign="top"><div class="div-float">(<span id="attachmentNumberDiv"></span>)</div>
							<v3x:fileUpload attachments="${attachments}" canDeleteOriginalAtts="true" originalAttsNeedClone="false" encrypt="false"/>
			      		</td>
			  		</tr>
			  	</table>
			 </form>
		</div>
	</td>
  </tr>
</table>
<iframe id="formExcelIframe" name="formExcelIframe" width="0" height="0" style="display:none;"></iframe>
</body>
</html>