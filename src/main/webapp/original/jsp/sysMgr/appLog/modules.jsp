<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>

<select id="category" name="moduleId" class="condition" onchange="" style="width:250px;">
	<option value=""><fmt:message key="common.option.selectCondition.text" bundle='${v3xCommonI18N}'/></option>
	<c:if test ="${v3x:hasPlugin('collaboration')}">
	<option value="100"><fmt:message key="appLog.moduleName.100" bundle='${sysMgrResources}'/> </option>
	</c:if>
	<%--表单插件 --%>
	<c:choose>
		<c:when test="${v3x:getSysFlagByName('sys_isGovVer')=='true'}">
			<c:if test ="${v3x:hasPlugin('form')}">
				<option value="200"> <fmt:message key="appLog.moduleName.200" bundle='${sysMgrResources}'/></option>
			</c:if>
		</c:when>
		<c:otherwise>
		<option value="200"> <fmt:message key="appLog.moduleName.200" bundle='${sysMgrResources}'/></option>
		</c:otherwise>
	</c:choose>
	<c:if test="${v3x:hasPlugin('edoc')=='true'}">
		<option value="300"> <fmt:message key="appLog.moduleName.300" bundle='${sysMgrResources}'/></option>
	</c:if>
	<c:if test="${v3x:hasPlugin('doc')}">
	<c:choose>
		<c:when test="${v3x:getSystemProperty('system.onlyA6')}">
			<option value="400"> <fmt:message key="appLog.moduleName.400.A6" bundle='${sysMgrResources}'/></option>
		</c:when>
		<c:otherwise>
			<option value="400"> <fmt:message key="appLog.moduleName.400${v3x:suffix()}" bundle='${sysMgrResources}'/></option>
		</c:otherwise>
	</c:choose>
	</c:if>
	<c:if test="${v3x:hasPlugin('news') || v3x:hasPlugin('bulletin') || v3x:hasPlugin('bbs') || v3x:hasPlugin('inquiry')}">
	<option value="500"> <fmt:message key="appLog.moduleName.500" bundle='${sysMgrResources}'/></option>
	</c:if>
	<c:if test="${v3x:hasPlugin('meeting')}">
   		 <option value="2200"><fmt:message key="appLog.moduleName.2200" bundle='${sysMgrResources}'/></option>
    </c:if>
    <%--政务版信息报送 --%>
     <c:if test="${v3x:hasPlugin('infosend')}">
        <option value="2400"><fmt:message key="appLog.moduleName.2400" bundle='${sysMgrResources}'/></option>
     </c:if>
     <c:if test="${v3x:hasPlugin('project') || v3x:hasPlugin('taskmanage') || v3x:hasPlugin('plan') || v3x:hasPlugin('calendar')}">
		<option value="600"> <fmt:message key="appLog.moduleName.new.600" bundle='${sysMgrResources}'/></option>
	</c:if>
	<c:if test="${v3x:hasPlugin('hr')}">
		<option value="700"> <fmt:message key="appLog.moduleName.700${v3x:suffix()}" bundle='${sysMgrResources}'/></option>
	</c:if>
	<option value="800"><fmt:message key="appLog.moduleName.800" bundle='${sysMgrResources}'/></option>
	<option value="900"><fmt:message key="appLog.moduleName.900" bundle='${sysMgrResources}'/></option>
	<option value="1000"><fmt:message key="appLog.moduleName.1000" bundle='${sysMgrResources}'/></option>
	<option value="1100"><fmt:message key="appLog.moduleName.1100" bundle='${sysMgrResources}'/></option>
    <c:if test="${v3x:hasPlugin('behavioranalysis') || v3x:hasPlugin('wfanalysis') || v3x:hasPlugin('performanceReport') || v3x:hasPlugin('colCube') || v3x:hasPlugin('seeyonreport')}">
		<c:choose>
			<c:when test="${ctp:getSystemProperty('system.ProductId') == 0}">
				<option value="6000"><fmt:message key="appLog.moduleName.6000.a6" bundle='${sysMgrResources}'/></option>
			</c:when>
			<c:otherwise>
				<option value="6000"><fmt:message key="appLog.moduleName.6000" bundle='${sysMgrResources}'/></option>
			</c:otherwise>
		</c:choose>
	</c:if>
	<c:if test="${v3x:hasPlugin('nc')}">
		<option value="9900"><fmt:message key="appLog.moduleName.9900" bundle='${sysMgrResources}'/></option>
	</c:if>
	<c:if test="${v3x:hasPlugin('ldap')}">
		<option value="4000"><fmt:message key="appLog.moduleName.4000" bundle='${sysMgrResources}'/></option>
	</c:if>
    <c:if test="${v3x:hasPlugin('office')}">
        <option value="2600"><fmt:message key="appLog.moduleName.2600" bundle='${sysMgrResources}'/></option>
    </c:if>
    <c:if test="${v3x:hasPlugin('yunxuetang')}">
        <option value="8000"><fmt:message key="appLog.moduleName.8000" bundle='${sysMgrResources}'/></option>
    </c:if>
    <c:if test="${v3x:hasPlugin('weixin')}">
        <option value="8300"><fmt:message key="appLog.moduleName.8300" bundle='${sysMgrResources}'/></option>
    </c:if>
</select>