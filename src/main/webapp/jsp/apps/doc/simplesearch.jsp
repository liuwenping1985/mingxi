<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<c:set value="${param.isQuote eq 'true' ? 'parent.parent.rightFrame' : 'docFrame'}" var="target" />
<c:set var="selectedEl" value="selected='selected'" />
<form action="" name="searchForm" id="searchForm" method="post" onsubmit="return false" style="margin: 0px" target="${target}">
	<c:set value="${v3x:currentUser()}" var="currentUser" />
	<input type="hidden"  name="flag">
	<div class="div-float-right condition-search-div">
		<div class="div-float">
			<select name="condition" id="condition" onChange="setFlag(this.value);showNextCondition(this)" class="condition" style="height:22px;">
				<option value=""><fmt:message key="doc.search.label" /></option>
				<c:forEach items="${searchConditions}" var="sc">
					<option value="${sc.physicalName}|${sc.type}|${sc.isDefault}">${sc.showName}</option>
				</c:forEach>
				<% 		
			  		if(addinMenus !=null && addinMenus.size() != 0) {
			  	%>
					  	<c:if test="${isLibOwner == true && isPrivateLib == false}">
                            <option value="third_hasPingHole|7|true"><fmt:message key="doc.tree.move.pigeonhole"/></option>
                        </c:if>
				<%  }%>	
			</select>
		</div>
		
		<c:forEach items="${searchConditions}" var="sc">
			<div id="${sc.physicalName}|${sc.type}|${sc.isDefault}Div" class="div-float hidden">
			<c:choose>
			<%-- 日期(时间) --%>
			<c:when test="${sc.type == 4 || sc.type == 5}">
                <c:set var="beginTimeEl" value="${sc.physicalName}beginTime"/>
                <c:set var="endTimeEl" value="${sc.physicalName}endTime"/>
				<input type="text" value="${param[beginTimeEl]}" name="${sc.physicalName}beginTime" id="${sc.physicalName}beginTime" class="input-date" onpropertychange="setDate('startdate', '${sc.physicalName}beginTime', '${sc.physicalName}endTime')" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly >
				- <input type="text" value="${param[endTimeEl]}" name="${sc.physicalName}endTime" id="${sc.physicalName}endTime" class="input-date" onpropertychange="setDate('enddate', '${sc.physicalName}beginTime', '${sc.physicalName}endTime')" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly >
			</c:when>
			<%-- 文件类型 --%>
			<c:when test="${sc.type == 10}">
                <c:set var="valueEl" value="${sc.physicalName}Value" />
				<select name="${sc.physicalName}" id="${sc.physicalName}Value" style="width:120px;height:22px;" >
					<option value=""><fmt:message key="doc.please.select"/></option>
					<c:forEach items="${types}" var="t">
                        <c:if test="${t.id ne '52'}">
    						<option value="${t.id}" ${t.id eq param[valueEl]?selectedEl:''} title="${v3x:toHTML(v3x:_(pageContext, t.name))}">
    							<c:set var="tempV" value="${v3x:getLimitLengthString(v3x:_(pageContext, t.name), 15,'...')}" />
    							${v3x:toHTML(tempV)}
    						</option>
                        </c:if>
					</c:forEach>
				</select>
			</c:when>
			<%-- 选人界面:部门 --%>
			<c:when test="${sc.type == 9}">
				<c:set var="selectType" value="${sc.type == 8 ? 'Member' : 'Department'}" />
				<v3x:selectPeople id="${sc.physicalName}" panels="Department,Team" selectType="${selectType}" departmentId="${currentUser.departmentId}" 
						jsFunction="setSimpleDocSearchPeopleFields('${sc.physicalName}', elements)" minSize="0" maxSize="1" showAllAccount="${param.docLibType == 5}"  />
				<script type="text/javascript">
					onlyLoginAccount_${sc.physicalName} = "${param.docLibType != 5}";
				</script>
                <c:set var="valueEl" value="${sc.physicalName}Name" />
				<input type="text" value="${param[valueEl]}" name="${sc.physicalName}Name" id="${sc.physicalName}Name" onclick="selectPeopleFun_${sc.physicalName}('${sc.physicalName}', '${sc.physicalName}Name')" 
					class="textfield" maxlength="100" readonly>
				<input type="hidden" name="${sc.physicalName}" id="${sc.physicalName}">
			</c:when>
            
			<%-- 枚举类型 --%>
			<c:when test="${sc.type == 13}">
                <c:set var="valueEl" value="${sc.physicalName}" />
				<select name="${sc.physicalName}" id="${sc.physicalName}" style="width:120px;height:22px;" >
					<c:forEach items="${sc.metadataOption}" var="op">
						<option value="${op.id}" ${op.id eq param[valueEl]?selectedEl:''} title="${v3x:toHTML(op.optionItem)}">${v3x:toHTML(op.optionItem)}</option>
					</c:forEach>
				</select>
			</c:when>
            <%-- 公文枚举 --%>
            <c:when test="${sc.type == 14}">
                <c:set var="valueEl" value="${sc.physicalName}" />
                <select name="${sc.physicalName}" id="${sc.physicalName}" style="width:120px;height:22px;" >
                  <c:forEach items="${sc.metadataOption}" var="op">
                    <option value="${op.id}" ${op.id eq param[valueEl]?selectedEl:''} title="${v3x:toHTML(op.optionItem)}">${v3x:toHTML(op.optionItem)}</option>
                  </c:forEach>
                </select>
            </c:when>      
			<%-- 布尔类型 --%>
			<c:when test="${sc.type == 7}">
                <c:set var="valueEl" value="${sc.physicalName}" />
				<select name="${sc.physicalName}" id="${sc.physicalName}" style="width:80px;height:22px;" >
					<option value="true" ${'true' eq param[valueEl]?selectedEl:''}><fmt:message key='common.yes' bundle="${v3xCommonI18N}"/></option>
					<option value="false" ${'false' eq param[valueEl]?selectedEl:''} ><fmt:message key='common.no' bundle="${v3xCommonI18N}"/></option>
				</select>
			</c:when>
			<%-- 文本类型或其他类型 --%>
			<c:otherwise>
				<c:choose>
					<%-- 公文种类129、行文类型130、文件密级133、紧急程度134 --%>
					<c:when test="${sc.id == 129 || sc.id == 130 || sc.id == 133 || sc.id == 134}">
                        <c:set var="valueEl" value="${sc.physicalName}" />
						<select name="${sc.physicalName}" id="${sc.physicalName}" style="width:120px;height:22px;" >
							<v3x:metadataItem metadata="${sc.metadata}" showType="option" name="${sc.physicalName}Meta" />
						</select>
					</c:when>
					<c:otherwise>
                        <c:set var="valueEl" value="${sc.physicalName}" />
						<input type="text" name="${sc.physicalName}" value="${v3x:toHTML(param[valueEl])}" id="${sc.physicalName}" onkeydown="docSimpleSearchEnter(${param.isQuote eq 'true'})" class="textfield" maxLength='20'/>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
			</c:choose>
			</div>
		</c:forEach>
		<% 		
	  		if(addinMenus !=null && addinMenus.size() != 0){
	  	%>
	  	<c:if test="${isLibOwner == true && isPrivateLib == false}">
			<div id="third_hasPingHole|7|trueDiv" class="div-float hidden">
                <select name="third_hasPingHole" id="third_hasPingHole" style="width:120px;height:22px;" >
                    <option value="true" ${'true' eq param['third_hasPingHole']?selectedEl:''} ><fmt:message key="doc.thirdM.pingHole.lable.true" /></option>
                    <option value="false" ${'false' eq param['third_hasPingHole']?selectedEl:''} ><fmt:message key="doc.thirdM.pingHole.lable.false" /></option>
                </select>
            </div>
		</c:if>
		<%  } %>
		<c:set value="${param.isQuote eq 'true' ? 'seachDocRel()' : 'docSimpleSearch()'}" var="action" />
		<div onclick="${action}" class="condition-search-button div-float"></div>
		<%-- 个人文档库无高级属性查询(关联文档界面也暂时屏蔽掉高级组合查询(界面问题...2011-04-11)) --%>
		<c:if test="${param.docLibType ne '1' && docLibType ne '1' && param.isQuote ne 'true'}">
			<span class="advanceSearchDown" title="<fmt:message key='doc.advancedquery.label'/>" onclick="showOrHideAdvancedSearch()" id="advancedSearchImg">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
		</c:if>
	</div>
</form>