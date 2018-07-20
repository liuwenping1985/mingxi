<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<form>
<v3x:table htmlId="listTable" data="list" var="bean" >
	<v3x:column width="3%" align="center"
		label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
		<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>" 
			dataState='${bean.state}' dataTopOrder='${bean.topOrder}'
		/>
	</v3x:column>
	<c:set var="topStr" value="" />
	
	<v3x:column width="33%" type="String" onClick="showPageByMethod('${bean.id}','${detailMethod}');"
		label="bul.biaoti.label" className="cursor-hand sort"
		hasAttachments="${bean.attachmentsFlag}"
		bodyType="${empty bean.ext5 ? bean.dataFormat : 'Pdf'}"
		alt="${bean.title}"
		symbol="..."
		>
		<c:if test="${bean.topOrder>0}">
			<font color='red'>[<fmt:message key="label.top" />]</font>
		</c:if>
		${v3x:getLimitLengthString(bean.title, 42,'...')}
	</v3x:column>
	
	<v3x:column width="15%" type="String" onClick="showPageByMethod('${bean.id}','${detailMethod}');"
		label="bul.data.type" className="cursor-hand sort"
		property="type.typeName" alt="${bean.type.typeName}" maxLength="20" symbol="..."
		>
	</v3x:column>
	<v3x:column width="15%" type="String" onClick="showPageByMethod('${bean.id}','${detailMethod}');"
		label="bul.data.createUser" className="cursor-hand sort" value="${v3x:showMemberName(bean.createUser)}"
		>
		
	</v3x:column>
	<v3x:column width="12%" type="String" onClick="showPageByMethod('${bean.id}','${detailMethod}');"
		label="common.issueScope.label" className="cursor-hand sort"
		maxLength="16" value="${v3x:showOrgEntitiesOfTypeAndId(bean.publishScope, pageContext)}" symbol="..."/>

	<v3x:column width="10%" type="String" onClick="showPageByMethod('${bean.id}','${detailMethod}');"
		label="bul.data.state" className="cursor-hand sort">
		<fmt:message key="bul.data.state.${bean.state}" />
		<input type="hidden" id="${bean.id}_state" value="${bean.state}" />
	</v3x:column>

</v3x:table>
</form>