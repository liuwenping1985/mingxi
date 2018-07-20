<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<form action="" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
    <%-- 是否为用于选择上级任务的列表进行查询  --%>
    <c:set value="${param.method eq 'showParentTasks'}" var="parentTasks" />
    <input type="hidden" value="${param.method}" name="method">
    <%--项目任务选择上级任务时查询条件中没有项目信息导致结果不一致--%>
    <c:if test="${!parentTasks}">
        <input type="hidden" value="${param.from}" name="from" id="from" >
        <input type="hidden" value="${param.projectId}" name="projectId" id="projectId" >
        <input type="hidden" value="${param.projectPhaseId}" name="projectPhaseId" id="projectPhaseId" >
        <input type="hidden" value="${param.listTypeName}" name="listTypeName" id="listTypeName" >
        <input type="hidden" value="${param.showEmpty}" name="showEmpty" id="showEmpty" >
        <input type="hidden" value="${param.userId}" name="userId" id="showEmpty" >
    </c:if>
    <div class="div-float-right condition-search-div">
        <div class="div-float">
            <select name="condition" id="condition" onChange="showNextCondition(this)" class="condition">
                <option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
                <option value="subject"><fmt:message key="common.name.label" bundle="${v3xCommonI18N}" /></option>
                <option value="plannedStartTime"><fmt:message key='common.date.begindate.label' bundle='${v3xCommonI18N}' /></option>
                <option value="plannedEndTime"><fmt:message key='common.date.enddate.label' bundle='${v3xCommonI18N}' /></option>
            <%-- 用于选择上级任务的列表，查询条件只有：标题、时间、状态和负责人 --%>
            <c:if test="${!parentTasks}">   
                <option value="importantLevel"><fmt:message key="common.importance.label" bundle='${v3xCommonI18N}' /></option>
            </c:if>
                <option value="status"><fmt:message key="task.status" /></option>
            <c:if test="${!parentTasks}">
                <option value="riskLevel"><fmt:message key="task.risk" /></option>
            </c:if>
            <c:if test="${param.from ne 'Sent' && !parentTasks}">
                <option value="createUser"><fmt:message key='common.creater.label' bundle='${v3xCommonI18N}' /></option>
            </c:if>
                <option value="managers"><fmt:message key='task.manager' /></option>
            <c:if test="${!parentTasks}">
                <option value="participators"><fmt:message key='task.participator' /></option>
            </c:if>
            </select>
        </div>
        
        <div id="subjectDiv" class="div-float hidden"><input type="text" name="textfield" id="textfield" inputName="<fmt:message key='common.subject.label' bundle='${v3xCommonI18N}' />" class="textfield" onkeydown="javascript:doSearchEnter()" maxlength="100"></div>
        
        <div id="plannedStartTimeDiv" class="div-float hidden">
            <input type="text" name="textfield" id="startdate" class="input-date cursor-hand" 
                onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
            -
            <input type="text" name="textfield1" id="enddate" class="input-date cursor-hand"
                onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
        </div>
        
        <div id="plannedEndTimeDiv" class="div-float hidden">
            <input type="text" name="textfield" id="startdate2" class="input-date cursor-hand"
                onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
            -
            <input type="text" name="textfield1" id="enddate2" class="input-date cursor-hand"
                onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
        </div>
        
    <c:if test="${!parentTasks}">   
        <div id="importantLevelDiv" class="div-float hidden">
            <select name="textfield" class="textfield">
<%--                 <v3x:metadataItem metadata="${comImportanceMetadata}" showType="option" name="importantLevel" /> --%>
                     <c:forEach var="cim" items="${comImportanceMetadata}">
                        <option value="${cim.key }">${cim.text }</option>       
                     </c:forEach>
            </select>   
        </div>
    </c:if>
        
        <div id="statusDiv" class="div-float hidden">
            <select name="textfield" class="textfield">
<%--                 <v3x:metadataItem metadata="${taskStatusMetadata}" showType="option" name="status" /> --%>
                <option value="1,2,3"><fmt:message key="task.status.unfinished" /></option>
                <option value="1,2,3,4,5"><fmt:message key='task.projectall' /></option>
                <c:forEach var="sts" items="${taskStatusMetadata}">
                        <option value="${sts.key }">${sts.text }</option>       
                </c:forEach>
            </select>   
        </div>

    <c:if test="${!parentTasks}">       
        <div id="riskLevelDiv" class="div-float hidden">
            <select name="textfield" class="textfield">
<%--                 <v3x:metadataItem metadata="${riskMetadata}" showType="option" name="riskLevel" /> --%>
                     <c:forEach items="${riskMetadata}" var="rmd">
                        <option value="${rmd.key }">${rmd.text }</option>
                     </c:forEach>
            </select>   
        </div>
    </c:if>
        
    <c:if test="${param.from ne 'Sent' && !parentTasks}">
        <div id="createUserDiv" class="div-float hidden">
            <v3x:selectPeople id="createUser" panels="Department,Team" selectType="Member" departmentId="${currentUser.departmentId}" 
                jsFunction="setSearchPeopleFields(elements, 'createUserName', 'createUserId')" minSize="0" maxSize="1"  />
            <input type="text" name="textfield" id="createUserName" class="textfield" readonly="true" onclick="selectPeopleFun_createUser('textfield', 'textfield1')" />
            <input type="hidden" name="textfield1" id="createUserId" />
        </div>
    </c:if>
        
        <div id="managersDiv" class="div-float hidden">
            <v3x:selectPeople id="managers" panels="Department,Team" selectType="Member" departmentId="${currentUser.departmentId}" 
                jsFunction="setSearchPeopleFields(elements, 'managersName', 'managersId')" minSize="0" maxSize="1"  />
            <input type="text" name="textfield" id="managersName" class="textfield" readonly="true" onclick="selectPeopleFun_managers('textfield', 'textfield1')" />
            <input type="hidden" name="textfield1" id="managersId" />
        </div>
    
    <c:if test="${!parentTasks}">   
        <div id="participatorsDiv" class="div-float hidden">
            <v3x:selectPeople id="participators" panels="Department,Team" selectType="Member" departmentId="${currentUser.departmentId}" 
                jsFunction="setSearchPeopleFields(elements, 'participatorsName', 'participatorsId')" minSize="0" maxSize="1"  />
            <input type="text" name="textfield" id="participatorsName" class="textfield" readonly="true" onclick="selectPeopleFun_participators('textfield', 'textfield1')" />
            <input type="hidden" name="textfield1" id="participatorsId" />
        </div>
    </c:if>
        
        <div onclick="javascript:myDoSearch()" class="div-float condition-search-button"></div>
    </div>
</form>