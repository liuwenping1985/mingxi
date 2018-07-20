<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="projectHeader.jsp"%>
<title>Insert title here</title>
<fmt:setBundle basename="com.seeyon.v3x.office.admin.resources.i18n.AdminResources" var="v3xOfficeAdminI18N"/>
<script type="text/javascript">
<!--
function selectPeople()
{
	selectPeopleFun_wf();
}
function setBulPeopleFields(elements){
	if(elements.length > 1){
		alert("<fmt:message key='admin.alert.selectone' bundle='${v3xOfficeAdminI18N}'/>");
		return false;
	}else{
		var element = elements[0];
		document.getElementById("managerID").value=element.id;
		document.getElementById("projectManagerInput").value=element.name;
	}
}
function submitSearch(){
		var theForm = document.getElementsByName("searchForm")[0];
		var condition = document.getElementById("condition").value;
		var begintime = document.getElementById("begintime").value;
		var endtime = document.getElementById("endtime").value;
		if (theForm){ 
		   if ( condition == ''||condition == null){
		   alert('<fmt:message key="project.condition.select" />');
		}
		else if(condition=="projectDate"&&begintime>endtime){
		   alert('<fmt:message key="project.search.alert.time" />');
		}else {
           doSearch();
        }
        }
        else if (!theForm){
        	return;
        }
	}

function showMore(projectTypeId,projectTypeName,state){
	window.location.href = "${basicURL}?method=projectInfoMore&projectTypeName="+encodeURIComponent(projectTypeName)+"&projectTypeId="+projectTypeId+"&state="+state ;
}

function loadProjectInfo(projectId){
	setTimeout(function(){  
		//parent.document.getElementById("main").src = "${basicURL}?method=projectInfo&projectId="+projectId;
		//最新项目头部 入口
		parent.document.getElementById("main").src = "${pageContext.request.contextPath}/project/project.do?method=projectSpace&projectId="+projectId;
	},0); 
	
	
}

window.onload = function(){
		showCtpLocation("F02_projectPersonPage");
		var condition = '${condition}';
		if(condition == '' || condition==null)
			return;
		else {
			var conditionObj = document.getElementById("condition");
			selectUtil(conditionObj, condition);
		    showNextCondition(conditionObj);
			
			if(condition == 'projectName')
				document.getElementById("projectNameInput").value = "${v3x:escapeJavascript(field)}";
			else if(condition == 'projectManager'){
			    document.getElementById("projectManagerInput").value = "${v3x:escapeJavascript(field)}";
				document.getElementById("managerID").value = "${v3x:escapeJavascript(managerID)}";
			}
			else if(condition == 'projectDate'){
				document.getElementById("begintime").value = "${v3x:escapeJavascript(field)}";
				document.getElementById("endtime").value = "${v3x:escapeJavascript(field1)}";
			}
		}
	}
//-->
function projectConfig(){
  window.location.href='${newbasicURL}?method=getAllProjectList';
}
</script>
<c:set value="${managerID}" var="adminIds"/>
<c:set value="${v3x:parseElementsOfIds(adminIds,'Member')}" var="defaultmember"/>
<v3x:selectPeople id="wf" panels="Department" selectType="Member" jsFunction="setBulPeopleFields(elements);" originalElements="${defaultmember}"/>
</head>
<body class="bordr-top"> 
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
		<tr class="page2-header-line">
		<td width="100%" height="38" valign="top" class="page-list-border-LRD">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     <tr class="page2-header-line">
		        <td width="45" class="page2-header-img"><div class="getAllProjectList"></div></td>
		        <td class="page2-header-bg"><fmt:message key='project.relation.project.label' /></td>
		        <td class="page2-header-line page2-header-link" align="right">
				</td>
                <td class="page2-header-line page2-header-link" align="right">
				<form action="${basicURL}" name="searchForm" id="searchForm" method="get" onSubmit="return false" style="margin: 0px">
					<input type="hidden" value="projectSearch" name="method">
					<input type="hidden" value="${state}" name="state">
					<div class="div-float-right">
					<div style="float:left;padding-right:5px;">
					<c:if test="${state==1}">
					<a href="<html:link renderURL='/project.do?method=getAllProjectList&more=true&state=0'/>">[ <fmt:message key="project.body.Switch.Finishedstate"/>]</a>&nbsp;&nbsp;
					</c:if>
					<c:if test="${state==0}">
					<a href="<html:link renderURL='/project.do?method=getAllProjectList&more=true&state=1'/>">[ <fmt:message key="project.body.Switch.Startedstate"/>]</a>&nbsp;&nbsp;
					</c:if>
					<a href="javascript:void(0);" onclick="projectConfig();">[ <fmt:message key="project.toolbar.add.label"/>]</a>&nbsp;&nbsp;
					</div>
				</form>
				</td>
			</tr>
			</table>
		</td>
	</tr>
<tr>
<td valign="top">
<div class="scrollList" style="overflow-x:hidden; background:#fff;" >
<c:forEach items='${ptList}' var="postlist" varStatus="status">
<table align="center" width="100%"  border="0" cellspacing="0" cellpadding="0" class="page-list-border">	
    <tr>
	   <td height="22" 	 class="index-type-name">
			${v3x:toHTML(postlist.name)}
       </td>
	</tr>
	<tr>
	<td>
		<style>
			.mxt-grid-header{padding-bottom:0;}
		</style>
	  	<div style="height:100%; border-top:0px">
		<c:forEach var="alist" items="${tprojectList}" varStatus="status2">
			<c:if test="${status.index == status2.index}">
				<c:set value="${alist}" var="projectComposeList"/>
			</c:if>
		</c:forEach>
		<v3x:table htmlId="projectComposeList${status.index}" dragable="false"  data="${projectComposeList}" var="projectCompose" showHeader="true" showPager="false" size="5" varIndex="dataIndex" className="sort ellipsis">
			<v3x:column width="5%" align="center">
    			<img src="<c:url value="/apps_res/peoplerelate/images/icon3.gif" />" width="10" height="10" />
    		</v3x:column>
    		<v3x:column type="String" align="left" width="30%" label="project.body.projectName.label"className="sort" maxLength="20" alt="${projectCompose.projectSummary.projectName}" symbol="...">    									
    			<a href="javascript:void(0)" onclick="javascript:loadProjectInfo('${projectCompose.projectSummary.id}')" class="title-more">${v3x:toHTML(projectCompose.projectSummary.projectName)}</a>			
    		</v3x:column>
            <v3x:column type="String" label="project.body.projectNum.label" value="${projectCompose.projectSummary.projectNumber}" width="10%" className="sort" maxLength="15" alt="${projectCompose.projectSummary.projectNumber}" symbol="...">
            </v3x:column>
    		<v3x:column type="String" label="project.body.responsible.label" value="${v3x:showOrgEntities(projectCompose.principalLists, 'id', 'entityType', pageContext)}" width="15%" className="sort" maxLength="15" alt="${v3x:showOrgEntities(projectCompose.principalLists, 'id', 'entityType', pageContext)}" symbol="...">
			</v3x:column>
    		<v3x:column type="Date" label="project.body.startdate.label" width="15%"  className="sort">
				<fmt:formatDate value="${projectCompose.projectSummary.begintime}" type="both" dateStyle="full" pattern="yyyy-MM-dd"  />	  
			</v3x:column>
			<v3x:column type="Date" label="project.body.enddate.label" width="15%"  className="sort">
				<fmt:formatDate value="${projectCompose.projectSummary.closetime}" type="both" dateStyle="full" pattern="yyyy-MM-dd"  />	  		
			</v3x:column>
			<v3x:column label="project.body.state.label" width="10%"  className="sort">
				<fmt:message key="project.body.projectstate.${projectCompose.projectSummary.projectState}" />
			</v3x:column>
		</v3x:table>
		</div>
	</td>
    </tr>
</table>
<table align="right">
<tr>
	<td>
	<a style="padding-right: 10px;" href='javascript:showMore("${postlist.id}","${v3x:toHTML(v3x:escapeJavascript(postlist.name))}","${state}")' class="link-blue"><fmt:message key="common.more.label" bundle="${v3xCommonI18N}" /> >></a>&nbsp;&nbsp;
	</td>
	</tr>
</table>
<br><br>
</c:forEach>
</div>
</td>
</tr>
</table>
</body>
</html>