<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<%-- 用于选择上级任务的列表，只显示：任务名称、任务状态、开始日期、负责人  --%>
<c:set value="${param.method eq 'showParentTasks'}" var="parentTasks" />
   	<form name="listForm" id="listForm" method="get" onsubmit="return false" style="margin:0px">
		<v3x:table htmlId="listTable" data="tasks" var="task" className="sort ellipsis">
		   	<c:set var="onClick" value="viewTaskInfo('${task.id}', '${empty param.listTypeName ? listTypeName : param.listTypeName}', '${fromWorkManage}')" />
		   	<c:set value="${task.createUser == (empty param.userId ? currentUser.id : param.userId) ? '' : 'disabled'}" var="disabled" />
		    <c:choose>
		    	<c:when test="${!parentTasks}">
					<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
						<input type='checkbox' name='id' value='${task.id}' ${disabled} />
					</v3x:column>
		    	</c:when>
		    	<c:otherwise>
					<v3x:column width="5%" align="center" label="">
						<input type='radio' name='id' id='parent${task.id}' ondblclick="parent.selectParentTask('${task.id}');" value='${task.id}' ${task.id == param.parentTaskId ? 'checked' : ''} />
						<input type='hidden' name='logicalPath${task.id}' id='logicalPath${task.id}' value='${task.logicalPath}' />
						<input type='hidden' name='title${task.id}' id='title${task.id}' value="${v3x:toHTMLWithoutSpace(task.subject)}" />
					</v3x:column>
		    	</c:otherwise>
		    </c:choose>
			
			<v3x:column  type="String" width="${parentTasks ? 65 : 35}%" onClick="${onClick}" hasAttachments="${task.hasAttachments}" label="common.subject.label"  className="cursor-hand sort" alt="${task.subject}">
			    <c:if test="${task.importantLevel > 1}">
                    <img src="<c:url value="/common/images/importance_${task.importantLevel}.gif" />" />
                </c:if>
                <c:if test="${task.milestone == 1 }">
                    <span class="milestone"></span>
                </c:if>
                <c:if test="${task.riskLevel > 0}">
                    <img src="<c:url value="/apps_res/taskmanage/images/risk${task.riskLevel}.gif" />" />
                </c:if>
				${v3x:toHTML(task.subject)}
			</v3x:column>
			
		<c:if test="${!parentTasks}">
			<v3x:column type="String" width="8%" onClick="${onClick}" label="common.importance.label" className="cursor-hand sort" >
<%-- 				<v3x:metadataItemLabel metadata="${comImportanceMetadata}" value="${task.importantLevel}"/> --%>
                <c:forEach items="${comImportanceMetadata}" var="important">
                     <c:if test="${important.key==task.importantLevel}">
                        <c:out value="${important.text }"></c:out>
                     </c:if>
                </c:forEach>
			</v3x:column>
		</c:if>
			<v3x:column type="String" width="5%" onClick="${onClick}" align="center" label="task.weight" className="cursor-hand sort" 
                value="${v3x:showRate(task.weight)}%"/>
            
			<v3x:column type="String" width="8%" onClick="${onClick}" label="common.state.label" className="cursor-hand sort" >
<%-- 				<v3x:metadataItemLabel metadata="${taskStatusMetadata}" value="${task.status}"/> --%>
                <c:forEach items="${taskStatusMetadata}" var="tsm">
                     <c:if test="${tsm.key==task.status}">
                        <c:out value="${tsm.text }"></c:out>
                     </c:if>
                </c:forEach>
			</v3x:column>
		
		<c:if test="${!parentTasks}">	
			<v3x:column type="String" width="9%" onClick="${onClick}" align="center" label="task.finishrate" className="cursor-hand sort" 
				value="${v3x:showRate(task.finishRate)}%"/>
		</c:if>
			
			<v3x:column type="String" width="10%" onClick="${onClick}" label="common.date.begindate.label" className="cursor-hand sort" >
				<fmt:formatDate value="${task.plannedStartTime}" pattern="${task.fullTime ? datePattern : datetimePattern}" />
			</v3x:column>
		
		<c:if test="${!parentTasks}">	
			<v3x:column type="String" width="10%" onClick="${onClick}" label="common.date.enddate.label" className="cursor-hand sort" >
				<fmt:formatDate value="${task.plannedEndTime}" pattern="${task.fullTime ? datePattern : datetimePattern}" />
			</v3x:column>
		</c:if>
			
			<c:set value="${v3x:showOrgEntitiesOfIds(task.managers, 'Member', pageContext)}" var="managersName" />
			<v3x:column type="String" width="10%" onClick="${onClick}" label="task.manager" 
				className="cursor-hand sort" alt="${v3x:toHTMLWithoutSpace(managersName)}">
				${v3x:toHTML(v3x:getLimitLengthString(managersName, 20,'...'))}
			</v3x:column>
		</v3x:table>
	</form>