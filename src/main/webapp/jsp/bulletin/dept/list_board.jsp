<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="mainResource"/>
<html>
<head>
<%@ include file="../include/header.jsp"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
	
<script type="text/javascript">
	 <c:if test="${unit != null}">
 		getA8Top().showLocation(null, getA8Top().findMenuName(7), getA8Top().findMenuItemName(705),"<fmt:message key='publicManager.select.menu.bulletin'  bundle='${mainResource}'/>" )
 	</c:if>	 
	<c:if test="${from != null}">
    	getA8Top().contentFrame.leftFrame.showSpaceMenuLocation(26);
    </c:if>	 
    <c:if test="${dept != null}">
    	getA8Top().contentFrame.leftFrame.showSpaceMenuLocation(15);
    </c:if>	
</script>
<script type="text/javascript">
<c:if test="${more==null}">
	window.onload = function(){
		showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	}
</c:if>	
</script>
<script type="text/javascript">
	function viewTypeList(typeId,baseUrl){
		document.location.href=baseUrl+"type="+typeId;
	}
</script>
</head>
</script>
<body class="tab-body" scroll = 'auto' style="padding:5px;">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="bottom" height="26" class="tab-tag">
			<div class="div-float">
				<div class="tab-tag-left-sel"></div>
				<div class="tab-tag-middel-sel"><a href="#" class="non-a"><fmt:message key="bul.board" /><fmt:message key="oper.manage" /></a></div>
				<div class="tab-tag-right-sel"></div>
				
			</div>
		</td>
	</tr>
<tr>
<td>
<style type="text/css">
	#MyTypeTable tbody .sort{
		height:40px;
	}
</style>
<div id="MyTypeTable" style="overflow: auto;height:100%;" class="tab-body-border">
<v3x:table htmlId="listTable" data="typeList" var="bean" showPager="false">
	<v3x:column type="String" className="cursor-hand sort" width="30px">
		<img align="absmiddle" src="<c:url value="/apps_res/bulletin/images/icon.gif"/>" />
	</v3x:column>
	
	<c:set var="onClick" value="javascript:viewTypeList('${bean.id}','${bulDataURL}?method=listMain&spaceType=${bean.spaceType}&');" />
	<v3x:column type="String" label="bul.type.typeName" className="cursor-hand sort">
		<a style="text-decoration:none;color:black;" href="${onClick}"><strong>${bean.typeName}</strong></a>
	</v3x:column>
	
	<v3x:column width="200px" type="String" label="bul.type.description" className="cursor-hand sort" 
		alt="${bean.description}" value="${bean.description}" maxLength="30" symbol="..." onClick="${onClick}">
	</v3x:column>
	
	<v3x:column width="100px" type="Number" align="right"
		label="label.totals" className="cursor-hand sort" onClick="${onClick}">
		${bean.totalItems}
	</v3x:column>
	
	<v3x:column width="240px" type="String"
		label="bul.type.managerUsers" className="cursor-hand sort" value="${v3x:showOrgEntitiesOfIds(bean.managerUserIds, 'Member', pageContext)}"
		alt="${v3x:showOrgEntitiesOfIds(bean.managerUserIds, 'Member', pageContext)}" onClick="${onClick}" />

</v3x:table>
</div>
</td>
</tr>
</table>


</body>
</html>
