<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ include file="formHeader.jsp"%>
<%@ include file="/WEB-INF/jsp/common/INC/noCache.jsp"%>
<html>
<head>
<title>Insert title here</title>
<script>
function doSearch(){
	var theForm = document.getElementById("searchForm");
	theForm.target = theForm.target || "_self";
	theForm.action = "${pageContext.request.contextPath}/form/formData.do?method=selectDeeTaskResultList";
	theForm.submit();
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"> 
</head>
<body>
<div class="main_div_row2">
	<div class="right_div_row2">
    	<div class="top_div_row2">
			<table height="100%" width="100%"  border="0" cellspacing="0" cellpadding="0" class="add-coll-border">
			<tr>
				<td class="webfx-menu-bar">
				<form action="" name="searchForm" id="searchForm" method="post" style="margin: 0px">
					<input type="hidden" value="<c:out value='${param.fieldName}' />" name="fieldName">
					<input type="hidden" value="<c:out value='${param.isSearch}' />" name="isSearch">
					<input type="hidden" value="<c:out value='${refField}' />" name="refField" id="refField">
					<input type="hidden" value="<c:out value='${param.formId}' />" name="formId">
					<%-- <input type="hidden" value="<c:out value='${param.paramStr}' />" name="paramStr"> --%>
					<div class="div-float-right condition-search-div">
						<div class="div-float">
							<select name="condition" class="condition">
						    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
							    <c:forEach var="field" items="${fieldlist}" varStatus="status">
							    	<option value="${field.name }"><v3x:out value="${field.display }"></v3x:out></option>
						  		</c:forEach>
						  	</select>
					  	</div>
					  	<div class="div-float">
					  		<input type="text" name="textfield" class="textfield">
					  	</div>
					  	<div onclick="javascript:doSearch()" class="div-float condition-search-button"></div>
				  	</div>
				</form>
				</td>
			</tr>
			</table>
		</div>
    	<div class="center_div_row2" id="scrollListDiv">
    		<form id="listForm" method="post" name="listForm" onsubmit="return false">
			 <v3x:table data="${datalist}" var="columnMap" varIndex="index" htmlId="pending" className="sort ellipsis" isChangeTRColor="true">
			 	<c:if test="${param.isSearch!='search'}">
					<v3x:column width="5%" align="center" onClick=""
						label="">
						<input type="radio" name="id" value = "datalist${index }"/>
					</v3x:column>
				</c:if>
				<c:forEach items="${fieldlist}" var="field" varStatus="status">
					<v3x:column  width="${columnwidth }%" label="${field.display}" className="cursor-hand sort" alt="${columnMap[field.name].value}" value="${columnMap[field.name].value}"/>
				</c:forEach>
			</v3x:table>
			<c:forEach items="${datalist}" var="map" varStatus="status">
				<c:forEach items="${map}" var="entry">
					<input type="hidden" name="datalist${status.index }" toRelFormField="${entry.value.toRelFormField}" field = "${entry.key}" value = "${v3x:toHTMLWithoutSpaceEscapeQuote(entry.value.value)}" display="${v3x:toHTMLWithoutSpaceEscapeQuote(entry.value.display)}"/>
				    <input type="hidden" name="datalist${status.index }a" value="${v3x:toHTMLWithoutSpaceEscapeQuote(entry.value.display)}"/>
				</c:forEach>
			</c:forEach>
			</form>
		</div>
	</div>
</div>
<script type="text/javascript">
<!--
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />");
//-->
</script>
</body>		
</html>