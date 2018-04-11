<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="edocHeader.jsp" %>
</head>
<body onkeydown="listenerKeyESC()" scroll="no" onload="qq()">
<table width="100%" border="0" cellspacing="0" cellpadding="0"  style="table-layout:fixed;">
<c:set var="item" value="1"/>
	<tr>
		<td>
			<div>
			<form>
			<v3x:table data="${logList}" var="model" htmlId="ww" className="sort ellipsis" isChangeTRColor="true" showHeader="true" showPager="true">
						<v3x:column width="10%" type="String" label="common.member.code" maxLength="15" value="${item}" alt="${item}" />
						<c:set var="item" value="${item+1}"/>
						<v3x:column width="20%" type="String" label="common.workflow.modifyBy" maxLength="15" value="${model.updatePerson}" alt="${model.updatePerson}" />
						<v3x:column width="25%" type="String" label="common.date.lastupdate.label" maxLength="40" >
							<fmt:formatDate value="${model.updateTime}" type="Date" dateStyle="full" pattern="yyyy-MM-dd HH:mm:ss" />
						</v3x:column>
                        <v3x:column width="45%" type="String" label="common.workflow.modifyContent" maxLength="40" 
                         alt="" ><fmt:message key='edoc.doctemplate.modify' /><fmt:message key="edoc.symbol.colon" />
                         <c:if test="${model.modifyForm==1}"><fmt:message key='edoc.doctemplate.wendan' />&nbsp;</c:if>
                         <c:if test="${model.modifyContent==1}"><fmt:message key='edoc.doctemplate.text' />&nbsp;</c:if>
                         <c:if test="${model.modifyAtt==1}"><fmt:message key='edoc.doctemplate.fujian' /></c:if>
                         </v3x:column>
<%--                          <v3x:column width="10%" type="String"  maxLength="40" >
							<a href="javascript:void(0)" onclick="openDetailFromArchiveModify('${model.id}')">查看</a>
						</v3x:column> --%>
			</v3x:table>
			</form>
			</div>
		</td>
	</tr>
</table>
</body>
</html>
<script type="text/javascript">
	function qq(){
		document.getElementById('pagerTd').style.textAlign="right";
	}
</script>