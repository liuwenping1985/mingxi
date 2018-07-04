<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>
	<fmt:message key='common.toolbar.statistics.label' bundle='${v3xCommonI18N}' />
</title>
<%@ include file="../include/header.jsp"%>
<script type="text/javascript" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
</head>
<body>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<tr><td>
<div class="scrollList">
<%-- 按照板块进行统计已经取消......  --%>
<c:set var="type" value="${param.type}" />
<c:if test="${type==null || type=='byType'}">
<v3x:table htmlId="listTable" data="list" var="bean" showPager="false" pageSize="10" varIndex="a">
	<v3x:column width="70" type="String" label="label.num" className="sort">
		${a}		
	</v3x:column>
	<v3x:column type="String"
		label="bul.type" className="sort">
		${bean[1]}
	</v3x:column>
	<v3x:column type="String"
		label="label.count" className="sort">
		${bean[2]}
	</v3x:column>
</v3x:table>
</c:if>

<c:if test="${type=='byRead'}">
<form id="readForm" name="readForm" >
<v3x:table htmlId="listTable" data="list" var="bean"  varIndex="b">
	<v3x:column type="String" width="50%" label="bul.biaoti.label" className="sort">
		${v3x:toHTML(bean[0])}
	</v3x:column>
	<v3x:column type="String" width="25%" label="bul.data.createUser" className="sort">
		${v3x:showMemberName(bean[1])}
	</v3x:column>
	<v3x:column type="String" width="20%" label="label.readCount" className="sort">
		${bean[2]}
	</v3x:column>
</v3x:table></form>
</c:if>

<c:if test="${type=='byWrite'}">
<form id="writeForm" name="writeForm" >
<v3x:table htmlId="listTable" data="list" var="bean"  varIndex="c">
	<v3x:column type="String" width="50%" label="bul.data.createUser" className="sort">
		${v3x:showMemberName(bean[0])}
	</v3x:column>
	<v3x:column type="String" width="45%" label="label.count" className="sort">
		${bean[1]}
	</v3x:column>
</v3x:table>
</form>
</c:if>

<c:if test="${type=='byPublishDate'}">
<v3x:table htmlId="listTable" data="list" var="bean" showPager="false"  varIndex="d" pageSize="12">
	<v3x:column type="String" width="50%" label="bul.data.publishDate" className="sort">
		<fmt:formatDate value="${bean[0]}" pattern="yyyy-MM" />
	</v3x:column>
	<v3x:column type="String" width="45%" label="label.count" className="sort">
		${bean[1]}
	</v3x:column>
</v3x:table>
</c:if>

<c:if test="${type=='byState'}">
<v3x:table htmlId="listTable" data="list" var="bean" showPager="false" varIndex="e" pageSize="10">
	<v3x:column type="String" width="50%" label="bul.data.state" className="sort">
		<fmt:message key="bul.data.state.${bean[0]}" />
	</v3x:column>
	<v3x:column type="String" width="45%" label="label.count" className="sort">
		${bean[1]}
	</v3x:column>
</v3x:table>
</c:if>
</div>
</td></tr>
</table>
</body>
</html>