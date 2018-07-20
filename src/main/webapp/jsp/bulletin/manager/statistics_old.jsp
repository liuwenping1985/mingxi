<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>

<html>
<head>
<title>
	<fmt:message key='common.toolbar.statistics.label' bundle='${v3xCommonI18N}' />
</title>
<%@ include file="../include/header.jsp"%>
<script type="text/javascript"
	src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
	
<script type="text/javascript">
	function listenerKeyPress(){
		if(event.keyCode == 27){
			window.close();
		}
	}
	function changeType(type){
		$('type').value=type;
		$('typeForm').submit();	
	}
	
	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
		
	//myBar.add(
	//	new WebFXMenuButton(
	//		"byTypeBtn", 
	//		"<fmt:message key="label.stat.byType" />", 
	//		"changeType('byType');", 
	//		"", 
	//		"", 
	//		null
	//		)
	//);
	myBar.add(
		new WebFXMenuButton(
			"byReadBtn", 
			"<fmt:message key="label.stat.byRead" />", 
			"changeType('byRead');", 
			"", 
			"", 
			null
			)
	);
	myBar.add(
		new WebFXMenuButton(
			"byWriteBtn", 
			"<fmt:message key="label.stat.byWrite" />", 
			"changeType('byWrite');", 
			"", 
			"", 
			null
			)
	);
	myBar.add(
		new WebFXMenuButton(
			"byPublishDateBtn", 
			"<fmt:message key="label.stat.byPublishDate" />", 
			"changeType('byPublishDate');", 
			"", 
			"", 
			null
			)
	);
	myBar.add(
		new WebFXMenuButton(
			"byStateBtn", 
			"<fmt:message key="label.stat.byState" />", 
			"changeType('byState');", 
			"", 
			"", 
			null
			)
	);
	
	detailBaseUrl='${bulDataURL}?method=detail';
	
</script>

<base target="_self">
</head>
<body onkeydown="listenerKeyPress()">
<table width="100%" height="100%">
<tr><td height="25">
<div style="display:none">
	<form action="${bulDataURL}" id="typeForm" method="get">
		<input type="hidden" id="method" name="method" value="statistics" />
		<input type="hidden" id="type" name="type" value="byType" />
		<input type="hidden" id="bulTypeId" name="bulTypeId" value="${bulTypeId}" />
	</form>
</div>
<script type="text/javascript">
	document.write(myBar);	
</script>
</td></tr>
<tr><td>
<div class="scrollList">
<c:if test="${type==null || type=='byType'}">

<v3x:table htmlId="listTable" data="list" var="bean" showPager="false" pageSize="10" varIndex="a">
	<v3x:column width="70" type="String"
		label="label.num" className="cursor-hand sort">
		${a}		
	</v3x:column>
	<v3x:column type="String"
		label="bul.type" className="cursor-hand sort">
		${bean[1]}
	</v3x:column>
	<v3x:column type="String"
		label="label.count" className="cursor-hand sort">
		${bean[2]}
	</v3x:column>
</v3x:table>
</c:if>

<c:if test="${type=='byRead'}">
<form id="readForm" name="readForm" >
<v3x:table htmlId="listTable" data="list" var="bean"  varIndex="b">


	<v3x:column type="String"
		label="bul.biaoti.label" className="cursor-hand sort">
		${bean[3]}
	</v3x:column>
	<v3x:column type="String"
		label="bul.data.createUser" className="cursor-hand sort">
		${bean[5]}
	</v3x:column>
	<v3x:column type="String"
		label="label.readCount" className="cursor-hand sort">
		${bean[6]}
	</v3x:column>
</v3x:table></form>
</c:if>


<c:if test="${type=='byWrite'}">
<form id="writeForm" name="writeForm" >
<v3x:table htmlId="listTable" data="list" var="bean"  varIndex="c">

	<v3x:column type="String"
		label="bul.data.createUser" className="cursor-hand sort">
		${bean[1]}
	</v3x:column>
	<v3x:column type="String"
		label="label.count" className="cursor-hand sort">
		${bean[2]}
	</v3x:column>
</v3x:table></form>
</c:if>

<c:if test="${type=='byPublishDate'}">

<v3x:table htmlId="listTable" data="list" var="bean" showPager="false"  varIndex="d" pageSize="12">

	<v3x:column type="String"
		label="bul.data.publishDate" className="cursor-hand sort">
		<fmt:formatDate value="${bean[0]}" pattern="yyyy-MM" />
	</v3x:column>
	<v3x:column type="String"
		label="label.count" className="cursor-hand sort">
		${bean[1]}
	</v3x:column>
</v3x:table>
</c:if>


<c:if test="${type=='byState'}">

<v3x:table htmlId="listTable" data="list" var="bean" showPager="false" varIndex="e" pageSize="10">

	<v3x:column type="String"
		label="bul.data.state" className="cursor-hand sort">
		<fmt:message key="bul.data.state.${bean[0]}" />
	</v3x:column>
	<v3x:column type="String"
		label="label.count" className="cursor-hand sort">
		${bean[1]}
	</v3x:column>
</v3x:table>
</c:if>
</div>
</td></tr>
</table>
</body>
</html>
