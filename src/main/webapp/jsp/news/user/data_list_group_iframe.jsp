<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<html>
<head>
<%@ include file="../include/header.jsp"%>
<script type="text/javascript">
	<c:if test="${more==null}">
		window.onload = function(){
			showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
		}
	</c:if>	
	
	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	myBar.add(
		new WebFXMenuButton(
			"editBtn", 
			"<fmt:message key="label.news.new" />", 
			null, 
			null, 
			null, 
			null
			)
	);
	
	var myTypeBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	myTypeBar.add(
		new WebFXMenuButton(
			"editBtn", 
			"<fmt:message key="label.news.type" />", 
			null, 
			null, 
			null, 
			null
			)
	);

	function viewTypeList(typeId,baseUrl){
		document.location.href=baseUrl+"type="+typeId;
	}

	//TODO yangwulin 2012-10-29 getA8Top().contentFrame.leftFrame.showSpaceMenuLocation(21); 
</script>
<style type="text/css">
	#MyTypeTable tbody .sort{
		height:40px;
		vertical-align: middle;
	}
</style>
</head>
<body style="padding:5px">
	<table width="100%" height="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td valign="bottom" height="26" class="tab-tag">
			<div class="div-float">
			<div class="tab-tag-left-sel"></div>
			<div class="tab-tag-middel-sel"><fmt:message key="label.type.bulletin" /></div>
			<div class="tab-tag-right-sel"></div>
			</div>
			</td>
		</tr>
		<tr>
			<td class="tab-body-border">
				<div id="MyTypeTable" style="overflow: auto;" height="100%" class="scrollList">
				<v3x:table htmlId="listTable" data="typeList" var="bean" showPager="false" isChangeTRColor="false">
					<v3x:column type="String" className="cursor-hand sort" width="50px">
						<img align="absmiddle" src="<c:url value="/apps_res/news/images/icon.gif"/>" />
					</v3x:column>
					<v3x:column type="String" label="news.type.typeName" className="cursor-hand sort"> 
						<strong><a class='titleDefaultCss' href="javascript:viewTypeList('${bean.id}','${newsDataURL}?method=userList&group=group&');">${bean.typeName}</a></strong>
					</v3x:column>
					<v3x:column type="String" width="120px" label="news.type.description" className="sort" value="${bean.description} " maxLength="20" symbol="..."/>	
					<v3x:column width="100px" type="Number" align="right" label="label.totals" className="sort">
						${bean.totalItems}
					</v3x:column>
					<v3x:column width="240px" type="String" label="news.type.managerUsers" className="sort" property="managerUserNames" alt="${bean.managerUserNames}" maxLength="40" symbol="..."/>
					<v3x:column width="70px" type="String" label="news.type.auditUser" className="sort" property="auditUserName" alt="${bean.auditUserName}"/>
				</v3x:table>
				</div>
			</td>
		</tr>
	</table>
</body>
</html>
