<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<table>
  <tr>
    <td height="40"></td>
  </tr>
</table>
<input type="hidden" name="isGroupFlag" id="isGroupFlag" value="${isGroupFlag}" />
<input type="hidden" name=isAdmin id="isAdmin" value="${isAdmin}" />
<c:set value="${v3x:parseElementsOfIds(agent.agentId, 'Member')}" var="org"/>
<v3x:selectPeople id="surrogate" panels="Department" selectType="Member" departmentId="${v3x:currentUser().departmentId}" 
	jsFunction="dataToSurrogate(elements)" maxSize="1" showMe="false" originalElements="${org}" />
<table width="50%" border="0" cellspacing="0" cellpadding="0" align="center">
<c:if test="${v3x:currentUser().admin}">
<v3x:selectPeople id="surrogateTo" panels="Department" selectType="Member" departmentId="${v3x:currentUser().departmentId}" 
	jsFunction="dataToSurrogateTo(elements)" maxSize="1" showMe="false" />
<!-- 被代理人信息 -->
<tr>
	<td class="bg-gray" width="20%" nowrap="nowrap">
		<label for="name"><font color="red">*</font><fmt:message key="${'agent.is.surrogate.name'}" bundle="${agentI18N}" />:</label>
	</td>
	<td class="new-column" width="80%" align="left">
		<c:set value="<fmt:message key='click.choice' bundle='${v3xCommonI18N}'/>" var="defaultValue" />
		<input type="text" name="surrogateTo" id="surrogateTo" class="input-100per" deaultValue="${defaultValue }" style="width:300px"
		 value="<fmt:message key='click.choice' bundle='${v3xCommonI18N}' />"
		 	title=""  <c:if test="${from eq 'new'}"> onclick="selectPeopleFun_surrogateTo()" </c:if> <c:if test="${from eq 'modify'}"> disabled </c:if>readonly/>
		<input type="hidden" name="surrogateValueTo" id="surrogateValueTo" />
	</td>
</tr>
<!-- 代理人信息 -->
<tr>
	<td class="bg-gray" width="20%" nowrap="nowrap">
		<label for="name"><font color="red">*</font><fmt:message key="${'agent.surrogate.name'}" bundle="${agentI18N}" />:</label>
	</td>
	<td class="new-column" width="80%" align="left">
		<c:set value="<fmt:message key='click.choice' bundle='${v3xCommonI18N}'/>" var="defaultValue" />
		<input type="text" name="surrogate" id="surrogate" class="input-100per" deaultValue="${defaultValue }" style="width:300px"
		 value="<fmt:message key='click.choice' bundle='${v3xCommonI18N}'/>"
		 	title="" onclick="selectPeopleFun_surrogate()"  />
		<input type="hidden" name="surrogateValue" id="surrogateValue" value="" />
	</td>
</tr>
</c:if>
<c:if test="${!v3x:currentUser().admin}">
<tr>
	<td class="bg-gray" width="20%" nowrap="nowrap">
		<label for="name"><font color="red">*</font><fmt:message key="${agentToFlag?'agent.surrogate.name':'agent.is.surrogate.name'}" bundle="${agentI18N}" />:</label>
	</td>
	<td class="new-column" width="80%" align="left">
		<c:set value="<fmt:message key='click.choice' bundle='${v3xCommonI18N}'/>" var="defaultValue" />
		<input type="text" name="surrogate" id="surrogate" class="input-100per" deaultValue="${defaultValue }" style="width:300px"
		 value="<fmt:message key='click.choice' bundle='${v3xCommonI18N}'/>"
		 	title="" onclick="selectPeopleFun_surrogate()" readonly/>
		<input type="hidden" name="surrogateValue" id="surrogateValue" value="" />
	</td>
</tr>
</c:if>
<tr><td height="10"></td></tr>
<tr>
	<td class="bg-gray" width="20%" nowrap="nowrap">
		<font color="red">*</font><label for="agent_deadline"><fmt:message key="agent.deadLine" bundle="${agentI18N}" />:</label>
	</td>
	<td id="dateTd" class="new-column" width="80%" align="left">
		<input type="text" name="beginDate" id="beginDate" class="input-date" style="width:140px"
		 value="<fmt:formatDate value='${firstDay}' pattern='yyyy-MM-dd HH:mm'/>" onclick="whenstart('${pageContext.request.contextPath}',this,575,140,'datetime');" readonly >
		-
		<input type="text" name="endDate" id="endDate" class="input-date" style="width:140px" 
		value="<fmt:formatDate value='${lastDay}' pattern='yyyy-MM-dd HH:mm'/>" onclick="whenstart('${pageContext.request.contextPath}',this,675,140,'datetime');" readonly >
	</td>
</tr>
<tr><td height="10"></td></tr>
<tr>
	<td class="bg-gray" width="20%" nowrap="nowrap" valign="top">
		<label for="appType"><font color="red">*</font><fmt:message key="agent.option.name" bundle="${agentI18N}" />:</label>
	</td>
	<td class="new-column" width="80%" id="agentOptionTD" align="left">
        <div>
		<label for="edoc" class="margin_r_10" style="display : ${v3x:hasPlugin('edoc')  ? '' : 'none'}" >
        	<input type="checkbox" name="edoc" id="edoc" value="true" extvalue="EDOC"><fmt:message key="metadataDef.category.edoc" bundle="${agentI18N}" />
        </label>
		<label for="meeting" class="margin_r_10" style="display : ${v3x:hasPlugin('meeting') ? '' : 'none'}" >
        	<input type="checkbox" name="meeting" id="meeting" value="true" extvalue="MEETING"><fmt:message key="metting.label" bundle="${agentI18N}" />
        </label>
        <c:if test ="${(v3x:getSysFlagByName('sys_isGovVer')=='true') && (v3x:hasPlugin('govInfoPlugin')=='true')}">
        <label for="govinfo" class="margin_r_10"  >
        	<input type="checkbox" name="govinfo" id="govinfo" value="true" extvalue="INFO"><fmt:message key="govinfo.label" bundle="${agentI18N}" />
        </label>
        </c:if>
        <label for="audit" class="margin_r_10" style="display : ${v3x:hasPlugin('bbs')||v3x:hasPlugin('news')||v3x:hasPlugin('bulletin')||v3x:hasPlugin('inquiry') ? '' : 'none'}">
        	<input type="checkbox" name="audit" id="audit" value="true" extvalue="PUBAUDIT"><fmt:message key="audit.label" bundle="${agentI18N}"/>
        </label>
        <label for="freecoll" class="margin_r_10" style="display : ${v3x:hasPlugin('collaboration') ? '' : 'none'}" >
        	<input type="checkbox" name="freecoll" id="freecoll" value="true" extvalue="COL" ${operationType == "new" || freeColl?"checked":""}><fmt:message key="freecoll.label" bundle="${agentI18N}"/>
        </label>
        </div>
        <div class="margin_t_5">
        <label class="margin_t_5 margin_r_10" for="template" style="display : ${v3x:hasPlugin('template')||v3x:hasPlugin('form') ? '' : 'none'}" >
        	<input type="checkbox" name="template" id="template" value="true" extvalue="TEMPLATE" onclick="showTemplate(this)" ><fmt:message key="templatecoll.label${v3x:hasPlugin('form')?'':'.noForm'}" bundle="${agentI18N}"/>
        </label>
        <span id="templateSpan" class="margin_r_10">
        	<select class="margin_t_5" id="templateSelect" onchange="selectTemplate(1)" style="width:200px;">
        		<option value=''><fmt:message key="templatecoll.all" bundle="${agentI18N}"/></option>
        		<option><fmt:message key="templatecoll.select" bundle="${agentI18N}"/></option>
        	</select>
        </span>
        <input type="hidden" id="templateIds" name="templateIds" value="${ids }">
        </div>
        <div class="margin_t_10">
        <label for="office" class="margin_r_10" style="display : ${v3x:hasPlugin('office') ? '' : 'none'}">
            <input type="checkbox" name="office" id="office" value="true" extvalue="OFFICE"><fmt:message key="office.label" bundle="${agentI18N}" />
        </label>
        </div>
	</td>
</tr>

</table>
<script type="text/javascript">
<!--	
	document.getElementById("surrogate").focus();
//-->
</script>