<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum" %>
<%@page import="com.seeyon.ctp.common.constants.Constants" %>
<html>
  <head>
    <title></title>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
	<script type="text/javascript">
		getA8Top().showLocation(1517, "<fmt:message key='menu.zhbg.popedomMgr' bundle='${v3xMainI18N}' />");
		 
    	var tempUrl = "${officeadminURL}?method=list";
    	function doCreate(){
    		parent.detailFrame.document.location.href = "mtMeeting.do?method=create_admin&showFlag=1";
    	}
    	
    	function doModify(){
    		var count = checkSelectCount();
			if(count == 0){
				alert("<fmt:message key='admin.alert.selectdit'/>");
				return false;
			}else if(count > 1){
				alert("<fmt:message key='admin.alert.selectonerecord'/>");
				return false;
			}else if(count == 1){
				parent.parent.detailFrame.document.location.href = "${officeadminURL}?method=edit&id="+selectValue();
			}
    	}
    	
    	function showDetail(assetId){
    		parent.parent.detailFrame.document.location.href = "${officeadminURL}?method=detail&id="+assetId;
    	}
    	function showDetailFull(assetId){
    		parent.parent.detailFrame.document.location.href = "${officeadminURL}?method=detail&id="+assetId+"&fs=true";
    	}
    	
    	function doDel(){
    		var count = checkSelectCount();
    		if(count == 0){
    			alert("<fmt:message key='admin.alert.selectonerecord'/>");
    			return false;
    		}else{
    			if(confirm("<fmt:message key='admin.alert.confirmdelrecord'/>")){
    				document.listForm.action = "${officeadminURL}?method=del";
    	           //document.listForm.target = "_self";
    				document.listForm.submit();
    			}
    		}
    	}
    	
    	function checkSelectCount(){
    		var id = document.getElementsByName("id");
    		var count = 0;
    		for(var i = 0; i < id.length; i++){
    			if(id[i].checked){
    				count++;
    			}
    		}
    		return count;
    	}
    	
    	function selectValue(){
    		var id = document.getElementsByName("id");
    		for(var i = 0; i < id.length; i++){
    			if(id[i].checked){
    				return id[i].value;
    			}
    		}
    	}
    	
    	function selectPeople(value)
		{
			if(value == 3){
				selectPeopleFun_selectDepartment();
			}else if(value == 2){
				selectPeopleFun_selectMember();
			}
		}
		
		function setBulPeopleFields_Dep(elements){
			if(elements.length > 1){
				alert("<fmt:message key='admin.alert.selectonedep'/>");
				return false;
			}else{
				var element = elements[0];
				document.getElementById("textfield3").value=getIdsString(elements, false);
				document.getElementById("textfieldd").value=element.name;
			}
		}
		
		function setBulPeopleFields_Mem(elements){
			if(elements.length > 1){
				alert("<fmt:message key='admin.alert.selectone'/>");
				return false;
			}else{
				var element = elements[0];
				document.getElementById("textfield2").value=element.id;
				document.getElementById("textfieldm").value=element.name;
			}
		}

	</script>
  </head>
<body>
<script type="text/javascript">

	var onlyLoginAccount_selectDepartment = true;
	var onlyLoginAccount_selectMember = true;
	var showOriginalElement_selectDepartment = true;
</script>
<v3x:selectPeople id="selectDepartment" panels="Department" selectType="Account,Department" jsFunction="setBulPeopleFields_Dep(elements);" />
<v3x:selectPeople id="selectMember" panels="Department" selectType="Member" jsFunction="setBulPeopleFields_Mem(elements);" />
  <table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="22">
    <script type="text/javascript">
    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}","gray");
    	myBar.add(new WebFXMenuButton("create", "<fmt:message key='mt.admin.button.create'/>", "doCreate()", "<c:url value='/common/images/toolbar/new.gif'/>", "", null));
    	myBar.add(new WebFXMenuButton("modify", "<fmt:message key='mt.admin.button.modify'/>", "doModify()", "<c:url value='/common/images/toolbar/update.gif'/>", "", null));
    	myBar.add(new WebFXMenuButton("delete", "<fmt:message key='mt.admin.button.del'/>", "doDel()", "<c:url value='/common/images/toolbar/delete.gif'/>", "", null));
    	document.write(myBar);
    	document.close();
    </script>
		</td>
		<td class="webfx-menu-bar-gray">
		<form name="searchForm" method="post" action="${officeadminURL}">
		<input type="hidden" name="method" value="list"/>
		<div class="div-float-right">
			<div class="div-float">
				<select name="condition" onChange="showNextCondition(this)">
					<option value="0">-<fmt:message key='admin.alert.selectcondition'/>-</option>
					<option value="1"><fmt:message key='mt.admin.button.administrator'/></option>
					<option value="2"><fmt:message key='mt.admin.button.management.range'/></option>
				</select>
			</div>
			<!--<div id="subjectDiv" class="div-float"><input type="text" class="textfield" name="textfield" /></div>  -->
			
			<div id="1Div" class="div-float hidden">
							<select name="textfield" id="textfield" style="width:130px" class="textfield"  class="div-float hidden">
								<option value="1">${auto}</option>
								<option value="2">${asset}</option>
								<option value="3">${book}</option>
								<option value="4">${stock}</option>
								<option value="5">${meetingroom}</option>
							</select>
			</div>
				<div id="2Div" class="div-float hidden">
							<input type="hidden" name="textfield" id="textfield2" class="textfield"/>
							<input type='text' id="textfieldm" class='textfield1' name='textfield1' onclick='selectPeople(2)' value='${checkselectperson}' readonly onkeydown="javascript:if(event.keyCode==13)return false;"/>
				<!--<input type="text" name="textfield" id="textfield2" class="textfield"/>-->
				</div>
				
			<div onclick="javascript:doSearch()" class="condition-search-button">&nbsp;</div>
		</div>
		</form></td>
	</tr>
	<tr>
		<td colspan="2">
    <div class="scrollList">
    <form name="listForm" id="listForm" method="post" style="margin: 0px">
    <v3x:table htmlId="listTable" data="list" var="bean" showHeader="true" showPager="true" isChangeTRColor="true" subHeight="30">
		<v3x:column width="4%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
			<input type='checkbox' name='id' value="<c:out value='${bean.admin},${bean.admin_model }'/>" />
		</v3x:column>
		<v3x:column width="40%" type="String" onDblClick="doModify()" onClick="showDetail('${bean.admin},${bean.admin_model }')"
			label="mt.admin.button.administrator" className="cursor-hand sort" alt="${bean.modelName}">
			<c:out value="${bean.modelName}" />
		</v3x:column>
		<v3x:column width="50%" type="String" onDblClick="doModify()" onClick="showDetail('${bean.admin},${bean.admin_model }')"
			label="mt.admin.button.management.range" className="cursor-hand sort" alt="${v3x:_(pageContext, 'admin.label.manager')}">
			<c:out value="${bean.adminName}" />
		</v3x:column>
	</v3x:table>
	</form>
	</div>
		</td>
	</tr>
</table>
<script type="text/javascript">
   showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
   showDetailPageBaseInfo("parent.detailFrame", "<fmt:message key='menu.zhbg.popedomMgr' bundle='${v3xMainI18N}' />", "/common/images/detailBannner/9001.gif", pageQueryMap.get('count'),v3x.getMessage("officeLang.detail_info_office_right"));	
  
</script>
</body>
</html>
