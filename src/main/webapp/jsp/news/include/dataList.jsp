<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<form>
<!-- Edit By Lif Start -->
<v3x:table htmlId="listTable" data="list" var="bean">
<!-- Edit End -->
<%-- 
	<c:choose>
		<c:when test="${bean.readFlag}">
			<c:set value="title-already-visited" var="readStyle" />
		</c:when>
		<c:otherwise>
			<c:set value="title-more-visited" var="readStyle" />
		</c:otherwise>
	</c:choose>
--%>	
	<v3x:column width="5%" align="center"
		label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
		<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>" 
							dataState='${bean.state}'
		/>
	</v3x:column>
	<v3x:column width="45%" type="String" label="news.biaoti.label" className="cursor-hand sort"
		hasAttachments="${bean.attachmentsFlag}" bodyType="${bean.dataFormat}" onClick="javascript:showPageByMethod('${bean.id}','${detailMethod}')"
		 alt="${bean.title}" value="${v3x:getLimitLengthString(bean.title,56, '...')}" />

	<v3x:column width="15%" type="String" onClick="showPageByMethod('${bean.id}','${detailMethod}');"
		label="news.data.type" className="cursor-hand sort"
		property="type.typeName" alt="${bean.type.typeName}" maxLength="20"
		>
	</v3x:column>
	<v3x:column width="10%" type="String" onClick="showPageByMethod('${bean.id}','${detailMethod}');"
		label="news.data.createUser" className="cursor-hand sort"
		>
		${bean.createUserName}
	</v3x:column>
	<v3x:column width="10%" type="String" onClick="showPageByMethod('${bean.id}','${detailMethod}');"
		label="news.data.publishDepartmentId" className="cursor-hand sort"
		maxLength="16" property="publishDepartmentName" alt="${bean.publishDepartmentName}"
		>
	</v3x:column>

	<v3x:column width="10%" type="String" onClick="showPageByMethod('${bean.id}','${detailMethod}');"
		label="news.data.state" className="cursor-hand sort">
		<fmt:message key="news.data.state.${bean.state}" />
		<input type="hidden" id="${bean.id}_state" value="${bean.state}" />
	</v3x:column>

</v3x:table>
</form>