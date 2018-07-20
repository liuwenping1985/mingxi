<%@ page language="java" contentType="text/html;charset=UTF-8"%>

<html>
<head>
<%@include file="../header.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<c:set value="${isNew eq 'New' ? 'new' : 'modify'}" var="titleLable"/>
<title>
<fmt:message key='addressbook.toolbar.${titleLable}.team.label' bundle='${v3xAddressBookI18N}'/>
</title>

<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/jquery.jetspeed.json.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
var tName = "${v3x:escapeJavascript(team.name)}";
function disableSubmitButton() {
  document.getElementById('sub').disabled = true;
  return true;
} 
function checkName() {
			var name = $('input#name').val();
   			if(name != ''&& name.length>20){
   				alert("组名输入不要超过20个字符！");
   				return false;
   			}

         if(document.getElementById("isNew").value!="New" && document.getElementById("name").value == tName){
	           var editForm = document.getElementById('editForm');
	           if(checkForm(editForm)&&disableSubmitButton()){
	             editForm.submit();
	           }
         }else if(document.getElementById("name").value=='未分类联系人'){
        	 alert(v3x.getMessage("ADDRESSBOOKLang.addressbook_operation_is_exist", v3x.getMessage("ADDRESSBOOKLang.addressbook_zu_label")));
		    return false;
         }
         else{
   		  	var options = {
		      	url: '${pageContext.request.contextPath}/addressbook.do?method=isExist',
		      	params: {type: 2, category: $('input#name').val()},
		      	success: function(json) {
					if (json[0].isExist) {
						alert(v3x.getMessage("ADDRESSBOOKLang.addressbook_operation_is_exist", v3x.getMessage("ADDRESSBOOKLang.addressbook_form_category")));
						return false;
					} else
					  var editForm = document.getElementById('editForm');
			          if(checkForm(editForm)&&disableSubmitButton()){
			            editForm.submit();
			          }
			          return false;
		      	}
		 	};
   			getJetspeedJSON(options);
   		}
};
</script>
<script type="text/javascript">

	// 取得列表中所有选中的id
	function getSelectIds(frame){
		var ids=frame.document.getElementsByName('id');
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				id=id+idCheckBox.value+',';
			}
		}
		return id;
	}
	
	function setTeamMems(teamMemIDs, teamMemNames){
    	document.getElementById("teamMemIDs").value = teamMemIDs;
    	document.getElementById("teamMemNames").value = teamMemNames;
	}
	
	function selectPrivatedPeople() {
		var url   = addressbookURL + '?method=selectPrivatedPeople';
		//window.open(url);
		var vReturnValue =  window.showModalDialog(url, "selectPrivatedPeople", "dialogHeight:480px;dialogWidth:560px");
		if(!vReturnValue || vReturnValue == "null") return;
		//alert(vReturnValue);
		var teamMemIDs = '';
		var teamMemNames = '';
		var arr = vReturnValue.split(',');
		if (arr) {
			for(var i=0;i<arr.length;i++) {
				if (!arr[i]) continue;
				var arr2 = arr[i].split('|');
				teamMemNames = teamMemNames + arr2[0];
				teamMemIDs = teamMemIDs + arr2[1];
				if (i < (arr.length-2)) {
					teamMemNames = teamMemNames+ v3x.getMessage("V3XLang.common_separator_label");
					teamMemIDs = teamMemIDs + ',';
				}
			}
		}
		setTeamMems(teamMemIDs,teamMemNames);
	}
	
	function checkDefName(obj){
		var defName = getDefaultValue(obj);
		var textName = document.getElementById("name").value;
		if(defName == textName){
			alert(v3x.getMessage("ADDRESSBOOKLang.addressbook_operation_add_category_message"));
			return false;
		}
	}
	function checkEditForm(form){
		if(checkForm(form)){
			window.returnValue=true;
			return true;
		} else {
			return false;		
		}
	}
	function OK(){
		var editForm = document.getElementById('editForm');
		editForm.submit();
	}
	function reloadWindow(){
		parent.parent.treeFrame.location.reload();
		if(window.parent.category_add_win){
			window.parent.category_add_win.close();
		}
		if(window.parent.category_modify_win){
			window.parent.category_modify_win.close();
		}
	}
</script>
</head>
<body scroll="no" style="overflow: hidden;">
<form id="editForm" method="post" target="viewTeamHiddenFrame" action="${addressbookURL}?method=newOwnTeam&addressbookType=2" onsubmit="return checkEditForm(this);" >
<input type="hidden" name="isNew" id="isNew" value="${isNew}" />
<input type="hidden" name="id" id="id" value="${tId}">		
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="popupTitleRight">
	<%-- <tr align="center">
		<td height="8" class="detail-top">
			<script type="text/javascript">
			getDetailPageBreak(); 
			//document.write("<img src=\"/seeyon/common/images/button.preview.up.gif\" height=\"8\" onclick=\"previewFrame('Up')\" class=\"cursor-hand\">");
			//document.write("<img src=\"/seeyon/common/images/button.preview.down.gif\" height=\"8\" onclick=\"previewFrame('Down')\" class=\"cursor-hand\">");
			//document.close();
		</script>
		</td>
	</tr>
	<tr>
		<td class="categorySet-4" height="8"></td>
	</tr>
	
	<tr>
		<td class="categorySet-head" height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key='addressbook.zu.label'  bundle='${v3xAddressBookI18N}'/></td>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;<font color="red">*</font><fmt:message key='addressbook.form.item.req.label'  bundle='${v3xAddressBookI18N}'/></td>
					 </td>
				</tr>
			</table>
		</td>
	</tr>--%>
	<tr>
		<td class="categorySet-head">
			<div class="categorySet-body2">
				<%@include file="teamInfo.jsp"%>
			</div>		
		</td>
	</tr>
	<c:if test="${!readOnly}">
	<tr>
		<td height="42" align="center" class="bg-advance-bottom">
			<input type="button" id="sub" onclick="checkName()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
			<input type="button" onclick="getA8Top().newCategoryWin.close();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
	</c:if>
</table>
</form>
<iframe name="viewTeamHiddenFrame" width="0" height="0" frameborder="0"></iframe>
</body>
</html>