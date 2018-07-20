<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="../include/taglib.jsp"%>
<html>
<head>
<title>
	<fmt:message key="oper.statistics" />
</title>
<%@ include file="../include/header.jsp"%>
<script type="text/javascript"
	src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"> 
${v3x:skin()}
<script type="text/javascript">
	function changeType(type){
		$('type').value=type;
		$('typeForm').submit();	
	}
	
	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");

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
	
	detailBaseUrl='${newsDataURL}?method=detail';
	
	window.onload = function(){
		var conditionObj = document.getElementById("condition");
		var oc = '${param.type}';
		
		if('byWrite' != oc && 'byPublishDate' != oc && 'byState' != oc && 'byRead' != oc){
			changeType('byRead');
		}else{
			selectUtil(conditionObj, oc);
		}
			
	}
	
</script>
<style type="text/css">
.border_lr{
  border-left: 1px solid #b6b6b6;
  border-right: 1px solid #b6b6b6;
}
</style>

<base target="_self">
</head>
<body scroll="no" class="listPadding border_lr">
	<div class="main_div_row2">
  		<div class="right_div_row2">
		    <div class="top_div_row2" style="_top:-10px;">
				<table width="100%"border="0" cellpadding="0" cellspacing="0" class="popupTitleRight">
				<tr><td height="42" class="PopupTitle" valign="middle" align="left">
				<div style="display:none">
					<form action="${newsDataURL}" id="typeForm" method="post">
						<input type="hidden" id="method" name="method" value="statistics" />
						<input type="hidden" id="type" name="type" value="byType" />
						<input type="hidden" id="newsTypeId" name="newsTypeId" value="${newsTypeId}" />
						<input type="hidden" id="spaceId" name="spaceId" value="${param.spaceId}" />
					</form>
				</div>
				&nbsp;&nbsp;&nbsp;<fmt:message key="news.data_shortname"/><fmt:message key="bul.statistics.label" bundle="${bulI18N}"/>:
				<select name="condition" id="condition"
							onChange="changeType(this.value)" class="condition">
							<option value="byRead"><fmt:message key="label.stat.byRead"  bundle="${bulI18N}"/></option>
							<option value="byWrite"><fmt:message key="label.stat.byWrite"  bundle="${bulI18N}"/></option>
							<option value="byPublishDate"><fmt:message key="label.stat.byPublishDate"  bundle="${bulI18N}"/></option>
							<option value="byState"><fmt:message key="label.stat.byState"  bundle="${bulI18N}"/></option>
						</select>
				</td></tr>
				</table>
			</div>
			<div class="center_div_row2" id="scrollListDiv" style="top:42px;">
			<c:if test="${type==null || type=='byType'}">
			
			<v3x:table htmlId="listTable" data="list" var="bean" showPager="false" pageSize="10" varIndex="a" className="sort ellipsis">
				<v3x:column width="50%" type="String" alt="dd"
					label="label.num" className="sort">
					${a}		
				</v3x:column>
				<v3x:column width="25%" type="String"
					label="news.type" className="sort">
					${bean[1]}
				</v3x:column>
				<v3x:column width="25%" type="String"
					label="label.count" className="sort">
					${bean[2]}
				</v3x:column>
			</v3x:table>
			</c:if>
			
			<c:if test="${type=='byRead'}">
			<form id="readForm" name="readForm" >
			<v3x:table htmlId="listTable" data="list" var="bean"  varIndex="b" className="sort ellipsis"> 
			
				<v3x:column type="String" width="50%"
					label="news.biaoti.label" className="sort" value="${bean[3]}" alt="${bean[3]}">
					${bean[3]}
				</v3x:column>
				<v3x:column type="String" width="25%"
					label="news.data.createUser" className="sort">
					${bean[5]}
				</v3x:column>
				<v3x:column type="Number" width="25%"
					label="label.readCount" className="sort">
					${bean[6]}
				</v3x:column>
			</v3x:table></form>
			</c:if>
			
			
			<c:if test="${type=='byWrite'}">
			<form id="writeForm" name="writeForm" >
			<v3x:table htmlId="listTable" data="list" var="bean"  varIndex="c" className="sort ellipsis">
			
				<v3x:column type="String" width="50%"
					label="news.data.createUser" className="sort" value="${bean[1]}" alt="${bean[1]}">
					${bean[1]}
				</v3x:column>
				<v3x:column type="String" width="50%"
					label="label.count" className="sort">
					${bean[2]}
				</v3x:column>
			</v3x:table></form>
			</c:if>
			
			<c:if test="${type=='byPublishDate'}">
			
			<v3x:table htmlId="listTable" data="list" var="bean" showPager="false" pageSize="12" varIndex="d" className="sort ellipsis">
			
				<v3x:column type="String" width="50%"
					label="news.data.publishDate" className="sort">
					<fmt:formatDate value="${bean[0]}" pattern="yyyy-MM" />
				</v3x:column>
				<v3x:column type="String" width="50%"
					label="label.count" className="sort">
					${bean[1]}
				</v3x:column>
			</v3x:table>
			</c:if>
			
			
			<c:if test="${type=='byState'}">
			
			<v3x:table htmlId="listTable" data="list" var="bean" showPager="false" pageSize="10" varIndex="e" className="sort ellipsis">
			
				<v3x:column type="String" width="50%"
					label="news.data.state" className="sort">
					<fmt:message key="news.data.state.${bean[0]}" />
				</v3x:column>
				<v3x:column type="String" width="50%"
					label="label.count" className="sort">
					${bean[1]}
				</v3x:column>
			</v3x:table>
			</c:if>
			</div>
		</div>
	</div>
</body>
</html>
