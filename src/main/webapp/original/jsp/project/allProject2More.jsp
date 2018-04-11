<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="projectHeader.jsp"%>
<title>Insert title here</title>
<fmt:setBundle basename="com.seeyon.v3x.office.admin.resources.i18n.AdminResources" var="v3xOfficeAdminI18N"/>
<script type="text/javascript">
	onlyLoginAccount_projectManager = true;

	window.onload = function() {
		var isCondition = "${param.isCondition}";
		if($("#state").val().length > 0 && isCondition.length == 0) {
			var st = "0";
			if($("#state").val() == "0") {
				st = "2";
			}
			showCondition("projectState", st, "");
		} else {
			showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "${param.textfield1}");
		}
	}

	function mySearch(){
		var theForm = document.getElementsByName("searchForm")[0];
		var condition = $("#condition").val();
		if(condition == "projectDate"){
			var textfield = $("#begintime").val();
			var textfield1 = $("#closetime").val();
			var beginTimeStrs = textfield.split("-");
			var beginTimeDate = new Date();
			beginTimeDate.setFullYear(beginTimeStrs[0],beginTimeStrs[1]-1,beginTimeStrs[2]);
			var endTimeStrs = textfield1.split("-");
			var endTimeDate = new Date();
			endTimeDate.setFullYear(endTimeStrs[0],endTimeStrs[1]-1,endTimeStrs[2]);
			if(endTimeDate<beginTimeDate){
				window.alert(v3x.getMessage("ProjectLang.startdate_cannot_late_than_enddate"));
				$("#closetime").val(textfield);
				return;
			}
		}
		doSearch();
	}
	
	function forwardProjectSpace(projectId){
		var url="${pageContext.request.contextPath}/project/project.do?method=projectSpace&projectId="+projectId;
		window.top.$("#main").attr("src",url);
	}
	
	function reloadPage() {
		window.location.reload();
	}
</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"> 
</head>
<body srcoll="no" class="border-top" height="100%" width="100%"> 
<div class="main_div_row2">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
	<tr class="page2-header-line">
		<td width="100%" height="38" valign="top">
			 <table width="100%"  border="0" cellpadding="0" cellspacing="0">
			     <tr class="page2-header-line">
			        <td width="45" class="page2-header-img"><div></div></td>
			        <td class="page2-header-bg"><fmt:message key='project.project.label' /></td>
			        <td class="page2-header-line page2-header-link" align="right"></td>
	                <td valign="bottom">
						<div class="div-float-right">
<%-- 				        	<a href="${basicURL}?method=getAllProjectList&more=true&state=${state}">[ <span class='backpage'></span> ]</a>&nbsp;&nbsp; --%>
						</div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td valign="top" class="padding5">
			<div>
				<table align="center" width="100%" cellpadding="0" cellspacing="0" class="page2-list-border">	
				    <tr>
					   <td height="25" class="webfx-menu-bar page2-list-header">
				      		<b>${v3x:toHTML(projectTypeName)}</b>
				       </td>
				       <td height="25" class="webfx-menu-bar page2-list-header">
				      		<form action="" name="searchForm" id="searchForm" method="get" style="margin: 0px" onsubmit="return false" onkeydown="doSearchEnter()">
				      			<input type="hidden" value="${param.method}" name="method"/>
								<input type="hidden" value="${v3x:toHTML(param.projectTypeName)}" name="projectTypeName"/>
								<input type="hidden" value="${param.projectTypeId}" name="projectTypeId"/>
								<input type="hidden" value="${param.state}" name="state" id="state"/>
								<input type="hidden" value="1" name="isCondition">
								<div class="div-float-right">
									<div class="div-float">
										<select id="condition" name="condition" onChange="showNextCondition(this)" class="condition">
									    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
										    <option value="projectName"><fmt:message key="project.body.projectName.label" /></option>
											<option value="projectNumber"><fmt:message key="project.body.projectNum.label" /></option>
                                            <option value="projectManager"><fmt:message key="project.body.responsible.label" /></option>
											<option value="projectDate"><fmt:message key="project.body.search.projecttime" /></option>
											<option value="projectState"><fmt:message key="project.body.state.label" /></option>
											<option value="projectRole"><fmt:message key="project.body.search.myrole" /></option>
									  	</select>
								  	</div>
								  	
								  	<div id="projectNameDiv" class="div-float hidden"><input type="text" id="projectName" name="textfield" class="textfield" maxlength="100"></div>
								  	
                                    <div id="projectNumberDiv" class="div-float hidden">
                                        <input type="text" id="projectNumber" name="textfield" class="textfield" maxlength="50"/>
                                    </div>
                                    
								  	<div id="projectManagerDiv" class="div-float hidden">
										 <input type="text" name="textfield" id="projectManagerName" class="textfield" />
									</div>
									
								  	<div id="projectDateDiv" class="div-float hidden">
								  		<input type="text" name="textfield" id="begintime" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
								  		-
								  		<input type="text" name="textfield1" id="closetime" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
								  	</div>
								  	
								  	<div id="projectStateDiv" class="div-float hidden">
								  		<select id="projectState" name="textfield" class="textfield">
								  			<option value="0"><fmt:message key="project.body.projectstate.0" /></option>
								  			<option value="2"><fmt:message key="project.body.projectstate.2" /></option>
								  		</select>	
								  	</div>
				  					<!-- 本人角色 -->
									<div id="projectRoleDiv" class="div-float hidden">
										<select id="projectRole" name="textfield"  class="textfield">
											<option value="0"><fmt:message key="project.body.responsible.label" /></option>
											<option value="5"><fmt:message key="project.body.assistant.label" /></option>
											<option value="2"><fmt:message key="project.body.members.label" /></option>
											<option value="1"><fmt:message key="project.body.manger.label" /></option>
											<option value="3"><fmt:message key="project.body.related.label" /></option>
										</select>
									</div>
									<div onclick="javascript:mySearch()" class="div-float condition-search-button"></div>
								</div>
							</form>
				       </td>
					</tr>
					<tr>
					  	<td colspan="2">
						    <div class="scrollList">
						  		<form>
									<v3x:table htmlId="projectComposeList"  data="${projectComposeList}" var="projectCompose" pageSize="20" showHeader="true" showPager="true" size="1" subHeight="70">
											<v3x:column width="5%" align="center">
								    				<img src="<c:url value="/apps_res/peoplerelate/images/icon3.gif" />" width="10" height="10" />
								    		</v3x:column>
								    		<v3x:column align="left" width="30%" label="project.body.projectName.label" className="sort" alt="${projectCompose.projectName}" symbol="...">    									
								    			<a onClick="forwardProjectSpace('${projectCompose.id}')" class="title-more">${v3x:toHTML(projectCompose.projectName)}</a>			
								    		</v3x:column>
                                            <v3x:column type="String" label="project.body.projectNum.label" value="${projectCompose.projectNumber}" width="10%" className="sort" alt="${projectCompose.projectNumber}" symbol="...">
                                            </v3x:column>
								    		<v3x:column label="project.body.responsible.label" value="${projectCompose.managerNames }" width="15%" className="sort" maxLength="15" alt="${projectCompose.managerNames }" symbol="...">
											</v3x:column>
								    		<v3x:column type="Date" label="project.body.startdate.label" width="15%"  className="sort">
											<fmt:formatDate value="${projectCompose.beginTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd"  />	  
											</v3x:column>
											<v3x:column type="Date" label="project.body.enddate.label" width="15%"  className="sort">
											<fmt:formatDate value="${projectCompose.closeTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd"  />	  		
											</v3x:column>
											<v3x:column label="project.body.state.label" width="10%"  className="sort">
											<fmt:message key="project.body.projectstate.${projectCompose.projectState}" />
											</v3x:column>
									</v3x:table>
								</form>
							</div>
					    </td>
				    </tr>
				</table>
			</div>
		</td>
	</tr>
</table>
</div>
</body>
</html>