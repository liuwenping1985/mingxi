<%-- 
There are 7 pages using nearly same code in the below, which will make you crazy 
when you have to make some changes cause you have to modify them all.
So I extract the same code out as a single jsp file and add some condition expression 
by checking parameter 'method' of each url so that it can conform to all these 7 pages.
And your life would be some better from now on.

By Poor Rookie Young at 2010-04-16
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<div class="div-float">
	<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
	<div class="tab-separator"></div>
	<%-- Personal Info setting --%>
	<c:set value="${param.method eq 'personalInfo' ? '-sel' : ''}" var="selected"/>	
	<div class="tab-tag-left${selected}"></div>
	<div class="tab-tag-middel${selected} cursor-hand" onclick="<c:if test="${selected ne '-sel'}">javascript:location.href='${pageContext.request.contextPath}/personalAffair.do?method=personalInfo'</c:if><c:if test="${selected eq '-sel'}">location.reload();</c:if>">
	 	<fmt:message key="personalInfo.title" bundle="${v3xMainI18N}"/>
	</div>
	<div class="tab-tag-right${selected}"></div>
	
	<%-- Password setting --%>
	<c:if test="${v3x:getSystemProperty('person.disable.modify.password')==0}">
		<div class="tab-separator"></div>
		<c:set value="${param.method eq 'managerFrame' ? '-sel' : ''}" var="selected"/>	
		<div class="tab-tag-left${selected}"></div>
		<div class="tab-tag-middel${selected} cursor-hand" onclick="<c:if test="${selected ne '-sel'}">javascript:location.href='<html:link renderURL='/individualManager.do?method=managerFrame' />'</c:if><c:if test="${selected eq '-sel'}">location.reload();</c:if>">
			<fmt:message key='menu.individual.manager' bundle="${v3xMainI18N}"/>
		</div>
		<div class="tab-tag-right${selected}"></div>
    </c:if>
    
    <%-- Personal Space Setting --%>            
	<!--<div class="tab-separator"></div>
	<c:set value="${param.method eq 'showPersonalSpace' ? '-sel' : ''}" var="selected"/>		
	<div class="tab-tag-left${selected}"></div>
	<div class="tab-tag-middel${selected} cursor-hand" onclick="<c:if test="${selected ne '-sel'}">javascript:location.href='${spacePortalURL}&method=showPersonalSpace'</c:if><c:if test="${selected eq '-sel'}">location.reload();</c:if>">
	 	<fmt:message key="menu.space.personalConfig" bundle="${v3xMainI18N}"/>
	</div>
	<div class="tab-tag-right${selected}"></div>
	
	-->
	<%-- Personal Space Navigation Setting --%>
	<div class="tab-separator"></div>	
	<c:set value="${param.method eq 'showSpaceNavigation' ? '-sel' : ''}" var="selected"/>
	<div class="tab-tag-left${selected}"></div>
	<div class="tab-tag-middel${selected} cursor-hand" onclick="<c:if test="${selected ne '-sel'}">javascript:location.href='${spacePortalURL}&method=showSpaceNavigation'</c:if><c:if test="${selected eq '-sel'}">location.reload();</c:if>">
	 	<fmt:message key="menu.space.navigationConfig" bundle="${v3xMainI18N}"/>
	</div>
	<div class="tab-tag-right${selected}"></div>
	
	<%-- Menu Setting --%>
	<div class="tab-separator"></div>	
	<c:set value="${param.method eq 'menuSetting' ? '-sel' : ''}" var="selected"/>
	<div class="tab-tag-left${selected}"></div>
	<div class="tab-tag-middel${selected} cursor-hand" onclick="<c:if test="${selected ne '-sel'}">javascript:location.href='/seeyon/main.do?method=menuSetting'</c:if><c:if test="${selected eq '-sel'}">location.reload();</c:if>">
	 	<fmt:message key='personalSetting.menu.label' bundle="${v3xMainI18N}" />
	</div>
	<div class="tab-tag-right${selected}"></div>

	<%-- Shortcut Panel Setting --%>
	<div class="tab-separator"></div>
	<c:set value="${param.method eq 'showShortcutSet' ? '-sel' : ''}" var="selected"/>
	<div class="tab-tag-left${selected}"></div>
	<div class="tab-tag-middel${selected} cursor-hand" onclick="<c:if test="${selected ne '-sel'}">javascript:location.href='/seeyon/main.do?method=showShortcutSet'</c:if><c:if test="${selected eq '-sel'}">location.reload();</c:if>">
	 	<fmt:message key='shortcut.set.title' bundle="${v3xMainI18N}" />
	</div>
	<div class="tab-tag-right${selected}"></div>
	
	<%-- View Storespace --%>
	<div class="tab-separator"></div>	
	<c:set value="${param.method eq 'storeSpaceLook' ? '-sel' : ''}" var="selected"/>
	<div class="tab-tag-left${selected}"></div>
	<div class="tab-tag-middel${selected} cursor-hand" onclick="<c:if test="${selected ne '-sel'}">javascript:location.href='/seeyon/main.do?method=storeSpaceLook'</c:if><c:if test="${selected eq '-sel'}">location.reload();</c:if>">
	 	<fmt:message key="personalInfo.storeSpace.look" bundle="${v3xMainI18N}" />
	</div>
	<div class="tab-tag-right${selected}"></div>
	<div class="tab-separator"></div>
</div>