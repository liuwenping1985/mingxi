<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>

<select id="category" name="moduleId" class="condition" onchange="" style="width:250px;">
	<option value=""><fmt:message key="common.option.selectCondition.text" bundle='${v3xCommonI18N}'/></option>
	<option value="100"><fmt:message key="appLog.moduleName.100" bundle='${sysMgrResources}'/> </option>
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
	<c:if test ="${(v3x:getSysFlagByName('edoc_notShow')!='true')}">
		<c:if test="${v3x:hasPlugin('edoc')=='true'}">
			<option value="300"> <fmt:message key="appLog.moduleName.300" bundle='${sysMgrResources}'/></option>
		</c:if>
	</c:if>
	<c:choose>
		<c:when test="${v3x:getSystemProperty('system.onlyA6')}">
			<option value="400"> <fmt:message key="appLog.moduleName.400.A6" bundle='${sysMgrResources}'/></option>
		</c:when>
		<c:otherwise>
			<option value="400"> <fmt:message key="appLog.moduleName.400${v3x:suffix()}" bundle='${sysMgrResources}'/></option>
		</c:otherwise>
	</c:choose>
	<option value="500"> <fmt:message key="appLog.moduleName.500" bundle='${sysMgrResources}'/></option>
	<c:if test="${v3x:hasPlugin('meeting')}">
   		 <option value="2200"><fmt:message key="appLog.moduleName.2200" bundle='${sysMgrResources}'/></option>
    </c:if>
    <%--政务版信息报送 --%>
     <c:if test="${v3x:hasPlugin('infosend')}">
        <option value="2400"><fmt:message key="appLog.moduleName.2400" bundle='${sysMgrResources}'/></option>
     </c:if>
     <c:if test ="${(v3x:getSysFlagByName('target_showOnlyTimeManager')!='true')}">
		<option value="600"> <fmt:message key="appLog.moduleName.new.600" bundle='${sysMgrResources}'/></option>
	</c:if>
	<c:if test="${v3x:hasPlugin('hr')}">
		<option value="700"> <fmt:message key="appLog.moduleName.700${v3x:suffix()}" bundle='${sysMgrResources}'/></option>
	</c:if>
	<option value="800"><fmt:message key="appLog.moduleName.800" bundle='${sysMgrResources}'/></option>
	<option value="900"><fmt:message key="appLog.moduleName.900" bundle='${sysMgrResources}'/></option>
	<option value="1000"><fmt:message key="appLog.moduleName.1000" bundle='${sysMgrResources}'/></option>
	<option value="1100"><fmt:message key="appLog.moduleName.1100" bundle='${sysMgrResources}'/></option>
    <%-- 
	<option value="3000"><fmt:message key="appLog.moduleName.3000" bundle='${sysMgrResources}'/></option>
    --%>
    <c:if test ="${(v3x:getSysFlagByName('cooperative_driving_cabin_notShow')!='true')}">
	    <c:if test="${v3x:hasPlugin('performanceReport') && ctp:getSystemProperty('system.ProductId') != '0'}">
			<option value="6000"><fmt:message key="appLog.moduleName.6000" bundle='${sysMgrResources}'/></option>
		</c:if>
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
    <option value="10000"><fmt:message key="appLog.moduleName.10000" bundle='${sysMgrResources}'/></option>
    <option value="39900"><fmt:message key="appLog.moduleName.39900" bundle='${sysMgrResources}'/></option>
</select>