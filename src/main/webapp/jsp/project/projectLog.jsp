<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="projectHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
	getDetailPageBreak(true);
	//var myBar = new WebFXMenuBar;
	//myBar.add(new WebFXMenuLabel("<fmt:message key='project.body.log.label' />", null));
	//document.write(myBar);
</script>
</head>
<body>

<div class="scrollList">
<form name="form" id="form" action="" method="get">
<v3x:table data="${logList}" var="log" leastSize="0">
	<v3x:column label="project.body.log.label" value="${log.optionUser.name}" width="10%" maxLength="10" symbol="..." alt="${log.optionUser.name}" nowarp>
	</v3x:column>
	<v3x:column label="project.body.projectName.label"	value="${projectName}" className="cursor-hand sort" width="10%" maxLength="30" alt="${projectName}" symbol="..." nowarp>
	</v3x:column>
	<v3x:column type="Date" label="project.log.oper.time.label" width="20%"
		className="cursor-hand sort" nowarp>
		<fmt:formatDate value='${log.projectLog.optionDate}'
			pattern='${datetimePattern}' />
	</v3x:column>

	<v3x:column label="project.log.oper.type.label" width="10%">
		<c:choose>
			<c:when test="${log.projectLog.projectDesc == 'addEvolution'}">
				<fmt:message key='common.button.${log.projectLog.projectDesc}.label' bundle='${v3xCommonI18N}' /><fmt:message key='project.title.info.label' />
			</c:when>
			<c:when test="${log.projectLog.projectDesc == 'add'}">
				<fmt:message key='common.button.${log.projectLog.projectDesc}.label' bundle='${v3xCommonI18N}' /><fmt:message key='project.project.label' />
			</c:when>
			<c:otherwise>
				<fmt:message key='common.toolbar.${log.projectLog.projectDesc}.label' bundle='${v3xCommonI18N}' /><fmt:message key='project.project.label' />
			</c:otherwise>
		</c:choose>
	</v3x:column>

	<v3x:column label="project.log.person.change.label" width="60%">
	    <!-- div style="width: 400px;overflow:hidden; text-overflow:ellipsis; cursor: hand" title="${add_managers}">
	    <nobr>
	     -->
	    <font color="red">
			<c:if test="${log.addManager.name != null}">
				<fmt:message key='common.button.add.label' bundle='${v3xCommonI18N}' /><fmt:message key='project.body.responsible.label' />:
			</c:if>
	    </font>${log.addManager.name}
	    <font color="red">
	    	<c:if test="${log.deleteManager.name !=null}">
				<fmt:message key='common.button.delete.label' bundle='${v3xCommonI18N}' /><fmt:message key='project.body.responsible.label' />:
			</c:if>
	    </font>${log.deleteManager.name} 
	    <font color="red">
		<c:if test="${log.addCharge != null}">
			<fmt:message key='common.button.add.label' bundle='${v3xCommonI18N}' /><fmt:message key='project.body.manger.label' />:
		</c:if>
	    </font>
	    <c:forEach var='ac' items='${log.addCharge}'> 
	         ${ac.name}
		</c:forEach>
		<font color="red">
		<c:if test="${log.deleteCharge != null}">
			<fmt:message key='common.button.delete.label' bundle='${v3xCommonI18N}' /><fmt:message key='project.body.manger.label' />:
		</c:if>
		</font>
		 <c:forEach var='dc' items='${log.deleteCharge}'> 
	         ${dc.name}
		</c:forEach>
		<font color="red">
		<c:if test="${log.addMember != null}">
			<fmt:message key='common.button.add.label' bundle='${v3xCommonI18N}' /><fmt:message key='project.body.members.label' />:
		</c:if>
		</font>
		 <c:forEach var='am' items='${log.addMember}'> 
	         ${am.name}
		 </c:forEach>
		<font color="red">
		<c:if test="${log.deleteMember != null}">
			<fmt:message key='common.button.delete.label' bundle='${v3xCommonI18N}' /><fmt:message key='project.body.members.label' />:
		</c:if>
		</font>
		 <c:forEach var='dm' items='${log.deleteMember}'> 
	         ${dm.name}
		 </c:forEach>
		<font color="red">
		<c:if test="${log.addInterfix != null}">
			<fmt:message key='common.button.add.label' bundle='${v3xCommonI18N}' /><fmt:message key='project.body.related.label' />:
		</c:if>
		</font>
		 <c:forEach var='ai' items='${log.addInterfix}'> 
	         ${ai.name}
		 </c:forEach>
		<font color="red">
		<c:if test="${log.deleteInterfix != null}">
			<fmt:message key='common.button.delete.label' bundle='${v3xCommonI18N}' /><fmt:message key='project.body.related.label' />:
		</c:if>
		</font>
        <c:forEach var='di' items='${log.deleteInterfix}'> 
	         ${di.name}
		</c:forEach>
		<!--</nobr>
		</div-->
        <c:if test="${log.addManager.name == null && log.deleteManager.name == null && log.addCharge == null && log.deleteCharge == null
          && log.addMember == null && log.deleteMember == null && log.addInterfix == null && log.deleteInterfix == null}">
           <fmt:message key="common.remind.time.no" bundle='${v3xCommonI18N}' /><fmt:message key="project.log.person.change.label" />
        </c:if>

	</v3x:column>
</v3x:table>
</form>
</div>
</body>
</html>
