<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="projectHeader.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>Insert title here</title>
<script type="text/javascript" src="<c:url value='/apps_res/project/js/projectList.js${v3x:resSuffix()}'/>"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<script type="text/javascript">
<!--
	var sessionScopeParam = "${currentUserId}";
	var basicURLParam = "${basicURL}";

	onlyLoginAccount_projectManager = true;
	
	window.onload = function() {
		showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "${param.textfield1}");
	}

	function OK(){
		var radio = document.getElementsByName("proid");
		var rv={value:"",name:""};
		for (i=0;i<radio.length;i++){  
			if(radio[i].checked){
				rv.value = radio[i].value;
				rv.name = radio[i].title;
			}  
		}
			return rv;
		}
//-->
</script>
</head>
<body>
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2 webfx-menu-bar-gray">
		 <div class="div-float-right">
      		<form action="" name="searchForm" id="searchForm" method="get" style="margin: 0px" onsubmit="return false" onkeydown="doSearchEnter()">
      			<input type="hidden" value="${param.method}" name="method">
				<input type="hidden" value="${param.projectTypeName}" name="projectTypeName">
				<input type="hidden" value="${param.state}" name="state">
				<input type="hidden" value="${param.isFormRel}" name="isFormRel">
				<div class="div-float-right">
					<div class="div-float">
						<select id="condition" name="condition" onChange="showNextCondition(this)" class="condition">
					    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
						    <option value="projectName"><fmt:message key="project.body.projectName.label" /></option>
                            <option value="projectNumber"><fmt:message key="project.body.projectNum.label" /></option>
							<option value="projectType"><fmt:message key="project.body.projectType.label" /></option>
							<option value="projectManager"><fmt:message key="project.body.responsible.label" /></option>
					  		<option value="projectState"><fmt:message key="project.body.state.label" /></option>
					  	</select>
				  	</div>
				  	
				  	<div id="projectNameDiv" class="div-float hidden">
				  		<input type="text" id="projectName" name="textfield" class="textfield" maxlength="100"/>
				  	</div>
				  	
                    <div id="projectNumberDiv" class="div-float hidden">
                        <input type="text" id="projectNumber" name="textfield" class="textfield" maxlength="50"/>
                    </div>
                    
				  	<div id="projectManagerDiv" class="div-float hidden">
						<input type="text" name="textfield" id="projectManagerName" class="textfield" />
					</div>
				  	
				  	<div id="projectTypeDiv" class="div-float hidden">
				  		<select id="projectType" name="textfield" class="textfield">
					  		<c:forEach items="${ptList}" var="ptype">   
					  			   <option value="${ptype.id}">${v3x:toHTML(ptype.name)}</option>
							</c:forEach>  
				  		</select>	
				  	</div>
				  	
				  	<div id="projectStateDiv" class="div-float hidden">
				  		<select id="projectState" name="textfield" class="textfield">
				  			<option value="0"><fmt:message key="project.body.projectstate.0" /></option>
				  			<option value="2"><fmt:message key="project.body.projectstate.2" /></option>
				  		</select>	
				  	</div>
				  	
					<div onclick="javascript:doSearch()" class="div-float condition-search-button"></div>
				</div>
			</form>
		</div>
    </div>
    <div class="center_div_row2" id="scrollListDiv">
		<form name="form" id="form" action="">
			<v3x:table htmlId="projectComposeList" data="${projectComposeList}" var="projectCompose" className="sort ellipsis">
				<v3x:column width="5%" align="center" label="">
					<input type='radio' name='proid' value="<c:out value="${projectCompose.projectSummary.id}"/>" title="${v3x:toHTML(projectCompose.projectSummary.projectName)}" <c:if test="${param.selectId eq projectCompose.projectSummary.id }"> checked</c:if>/>
					<c:set var="projectNameN" value="${v3x:toHTML(projectCompose.projectSummary.projectName)}" />
				</v3x:column>
				<v3x:column width="35%" label="project.body.projectName.label" value="${projectCompose.projectSummary.projectName}" onClick="${detail}" onDblClick="${onDoubleClick}" className="cursor-hand sort mxtgrid_black" maxLength="60" alt="${projectCompose.projectSummary.projectName}" symbol="..."></v3x:column>
				<v3x:column width="15%" label="project.body.projectNum.label" value="${projectCompose.projectSummary.projectNumber}" onClick="${detail}" onDblClick="${onDoubleClick}" className="cursor-hand sort" maxLength="60" alt="${projectCompose.projectSummary.projectNumber}" symbol="..."></v3x:column>
                <v3x:column width="15%" label="project.group.label" value="${projectCompose.projectSummary.projectTypeName}" onClick="${detail}" onDblClick="${onDoubleClick}" className="cursor-hand sort" maxLength="15" alt="${projectCompose.projectSummary.projectTypeName}" symbol="..."></v3x:column>
				<v3x:column label="project.body.responsible.label" value="${v3x:showOrgEntities(projectCompose.principalLists, 'id', 'entityType', pageContext)}" width="15%" onClick="${detail}" onDblClick="${onDoubleClick}" className="cursor-hand sort" maxLength="15" alt="${v3x:showOrgEntities(projectCompose.principalLists, 'id', 'entityType', pageContext)}" symbol="..."></v3x:column>
				<v3x:column label="project.body.state.label" width="15%" onClick="${detail}" onDblClick="${onDoubleClick}" className="cursor-hand sort">
					<fmt:message key="project.body.projectstate.${projectCompose.projectSummary.projectState}" />
				</v3x:column>
			</v3x:table>
		</form>
    </div>
  </div>
</div>
</body>
</html>