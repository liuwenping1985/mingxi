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
	function viewTypeList(typeId,baseUrl){
		document.location.href=baseUrl+"type="+typeId;
	}
	getA8Top().contentFrame.leftFrame.showSpaceMenuLocation(22); 
	//文章页面弹出窗口
	function openWin(url){
		getA8Top().openNewsWin = v3x.openDialog({
            title:" ",
            transParams:{'parentWin':window},
            url: url,
            isDrag:false
        });
	}		
</script>
<style type="text/css">
	#MyTypeTable tbody .sort{
		height:40px;
	}
</style>
</head>
<body style="padding:5px;">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
<tr> 
<td valign="bottom" height="28" class="tab-tag">
	<div class="div-float">
		<div class="tab-tag-left-sel"></div>
		<div class="tab-tag-middel-sel"><fmt:message key="label.type.bulletin" /></div>
		<div class="tab-tag-right-sel"></div>
	</div>					
</td>
</tr>
<tr>
<td class="tab-body-border">
<div id="MyTypeTable" style="overflow: auto;" height="100%" class="scrollList" >
<v3x:table htmlId="listTable" data="typeList" var="bean" showPager="false" isChangeTRColor="false">
	<v3x:column  className="cursor-hand sort" width="40px">
		<img align="absmiddle" src="<c:url value="/apps_res/bulletin/images/icon.gif"/>" />
	</v3x:column>
	<v3x:column type="String" label="bul.type.typeName" className="cursor-hand sort">
		<a class='titleDefaultCss' href="javascript:viewTypeList('${bean.id}','${bulDataURL}?method=userList&isGroup=true&');"><strong>${bean.typeName}</strong></a>
	</v3x:column>
	<v3x:column type="String" width="120px" label="common.description.label" className="sort" value="${bean.description}" maxLength="20" symbol="..."/>
	<v3x:column width="100px" type="Number" align="right" label="label.totals" className="sort">
		${bean.totalItems}
	</v3x:column>
	<v3x:column width="240px" type="String" label="bul.type.managerUsers" className="sort" value="${v3x:showOrgEntitiesOfIds(bean.managerUserIds, 'Member', pageContext)}" maxLength="40" symbol="..."/>
	<v3x:column width="70px" type="String" label="bul.type.auditUser" className="sort" property="auditUserName" alt="${bean.auditUserName}"/>
</v3x:table>
</div>
</td>
</tr>
</table>
</body>
</html>
