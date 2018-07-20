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


<c:set value="${v3x:parseElementsOfIds(teamLeaderIDs, 'Member')}" var="teamLeaders" />
<c:set value="${v3x:parseElementsOfIds(teamMemIDs, 'Member')}" var="teamMems" />
var tName = "${team.name}";
var excludeElements_leader = parseElements('${teamMems}');
var excludeElements_mem = parseElements('${teamLeaders}');
function checkName() {
            if(document.getElementById("isNew").value!="New"){
            	if(document.getElementById("name").value == tName){
            	    var editForm = document.getElementById('editForm');
	                if(checkForm(editForm)&&disableSubmitButton()){
	                  editForm.submit();
	                }
            	}else{
            		var options = {
			      	url: '${urlAddressBook}?method=isExist',
			      	params: {type: 1, ownTeam: $('input#name').val()},
			      	success: function(json) {
						if (json[0].isExist) {
							alert(v3x.getMessage("ADDRESSBOOKLang.addressbook_operation_is_exist", v3x.getMessage("ADDRESSBOOKLang.addressbook_form_ownteam")));
							return false;
							
						} else{
						  var editForm = document.getElementById('editForm');
						  if(checkForm(editForm)&&disableSubmitButton()){
						    editForm.submit();
					      }
					      return false;
						}
			      	}
			 	};
	   			getJetspeedJSON(options);
            	}
            }
            else{
	   		  var options = {
	   				url: '${pageContext.request.contextPath}/addressbook.do?method=isExist',
			      	params: {type: 1, ownTeam: $('input#name').val()},
			      	success: function(json) {
						if (json[0].isExist) {
							alert(v3x.getMessage("ADDRESSBOOKLang.addressbook_operation_is_exist", v3x.getMessage("ADDRESSBOOKLang.addressbook_form_ownteam")));
							return false;
						} else{
						  var editForm = document.getElementById('editForm');
			              if(checkForm(editForm)&&disableSubmitButton()){
			                editForm.submit();
			              }
			              return false;
						}
			      	}
			 	};
	   			getJetspeedJSON(options);
	   		}
}
function disableSubmitButton() {
	document.getElementById('sub').disabled = true;
	return true;
}  
function OK(){
	var editForm = document.getElementById('editForm');
	editForm.submit();
}
function reloadWindow(){
	parent.parent.treeFrame.location.reload();
	if(window.parent.ownteam_add_win){
		window.parent.ownteam_add_win.close();
	}
	if(window.parent.ownteam_modify_win){
		window.parent.ownteam_modify_win.close();
	}
}
</script>
<script type="text/javascript">
	function setTeamLeaders(elements){
		if (!elements) {
        	return;
    	}
    	document.getElementById("teamLeaderNames").value = getNamesString(elements);
    	document.getElementById("teamLeaderIDs").value = getIdsString(elements,false);
    	excludeElements_mem = elements;
	}
	function setTeamMems(elements){
		if (!elements) {
        	return;
    	}
    	document.getElementById("teamMemNames").value = getNamesString(elements);
    	document.getElementById("teamMemIDs").value = getIdsString(elements,false);
    	excludeElements_leader = elements;
	}
	
	
	var hiddenSaveAsTeam_leader = true;
	var hiddenSaveAsTeam_mem = true;
	
</script>
</head>



<v3x:selectPeople id="leader" panels="Department,Outworker" selectType="Member" jsFunction="setTeamLeaders(elements)" minSize="0"  originalElements="${teamLeaders}" isAutoClose="true"/>
<v3x:selectPeople id="mem" panels="Department,Outworker" selectType="Member" jsFunction="setTeamMems(elements)"  minSize="0"  originalElements="${teamMems}" isAutoClose="true"/>
<body scroll="no" style="overflow: no">
<form id="editForm" name="editForm" method="post" target="viewTeamHiddenFrame" action="${addressbookURL}?method=newOwnTeam&addressbookType=4" >	
<input type="hidden" name="isNew" id="isNew" value="${isNew}" />
<input type="hidden" name="id" id="id" value="${tId}">	
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="popupTitleRight">
	<%-- 
	<tr align="center">
		<td height="8" class="detail-top">
			<script type="text/javascript">
			getDetailPageBreak(); 
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
					<td class="categorySet-title" width="80" nowrap="nowrap">
						<c:choose>
							<c:when test="${param.tId != null}">
								<fmt:message key='addressbook.toolbar.modify.team.label'  bundle='${v3xAddressBookI18N}'/>
							</c:when>
							<c:otherwise>
							<fmt:message key='addressbook.team_form.title.label'  bundle='${v3xAddressBookI18N}'/>
							</c:otherwise>
						</c:choose>
					</td>
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
			<input type="button" id="sub"  name="sub" onclick="checkName()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
			<input type="button" id="but" name="but" onclick="getA8Top().newCategoryWin.close();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
	</c:if>
</table>
</form>
<iframe name="viewTeamHiddenFrame" width="0" height="0" frameborder="0"></iframe>
</body>
</html>