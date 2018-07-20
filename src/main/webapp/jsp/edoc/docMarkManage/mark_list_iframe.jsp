<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../edocHeader.jsp" %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
<!--

	var dialogTitleUp = "${dialogTitleUp}";
	var dialogTitleDown = "${dialogTitleDown}";
	
	window.onload = function() {
		showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "");
	}

	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","gray");
	myBar.add(new WebFXMenuButton("newBtn", "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />", "addMarkDefPage();", [1,1], "", null));	
	myBar.add(new WebFXMenuButton("editBtn", "<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />", "editMarkDefPage('undefined','edit');", [1,2], "", null));	
	myBar.add(new WebFXMenuButton("delBtn", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "deleteMarkDef();", [1,3], "", null));
	var reserveMenu = new WebFXMenu;
	reserveMenu.add(new WebFXMenuItem("", "${dialogTitleUp }", "reserveMark(1)"));
	reserveMenu.add(new WebFXMenuItem("", "${dialogTitleDown }", "reserveMark(2)"));
	myBar.add(new WebFXMenuButton("reserve", "${dialogTitleUp }" + "<fmt:message key='edoc.mark.reserve.set' />", null, [1,9], "", reserveMenu));
	
	//-->	
</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
</head>
<body scroll="no">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2 webfx-menu-bar-gray" style="border-top:0;">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="25" class="" style="border:0;">
			<script type="text/javascript">
				document.write(myBar);	
				document.close();
			</script>
		</td>
		<td height="25">
      		<form action="" name="searchForm" id="searchForm" method="get" style="margin: 0px" onsubmit="return false" onkeydown="doSearchEnter()">
      			<input type="hidden" value="${param.method}" name="method">
				<div class="div-float-right">
					<div class="div-float">
						<select id="condition" name="condition" onChange="showNextCondition(this)" class="condition">
					    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
						    <option value="mark"><fmt:message key="edoc.docmark.current" /></option>
							<option value="markType"><fmt:message key="edoc.element.wordno.type" /></option>
							<option value="markReserveUp">${dialogTitleUp }</option>
							<option value="markReserveDown">${dialogTitleDown }</option>
					  	</select>
				  	</div>
				  	
				  	<div id="markDiv" class="div-float hidden"><input type="text" id="mark" name="textfield" class="textfield" style="height:14px;"  maxlength="100"></div>
				  	
				  	<div id="markTypeDiv" class="div-float hidden">
				  		<select id="markType" name="textfield" class="textfield">
				  			<option value="0"><fmt:message key="edoc.element.wordno.label" /></option>
				  			<option value="1"><fmt:message key="edoc.element.wordinno.label" /></option>
				  			<option value="2"><fmt:message key="exchange.edoc.signingNo" bundle="${exchangeI18N}"/></option>
				  		</select>	
				  	</div>
				  	
				  	<div id="markReserveUpDiv" class="div-float hidden"><input type="text" id="textfield" name="textfield" class="textfield" style="height:14px;"  maxlength="100"></div>
				  	
				  	<div id="markReserveDownDiv" class="div-float hidden"><input type="text" id="textfield" name="textfield" class="textfield" style="height:14px;"  maxlength="100"></div>
				  				  	
					<div onclick="javascript:doSearch()" class="div-float condition-search-button"></div>
				</div>
			</form>
       </td>
	</tr>
	</table>
    </div>
    <div class="center_div_row2" id="scrollListDiv">
				<form id="mainForm" name="mainForm" method="post">
				<input type="hidden" id ="orgAccountId" name="orgAccountId" value="${v3x:currentUser().loginAccount}">
				<v3x:table data="markNoList" var="bean" htmlId="listTable" showHeader="true" showPager="true">
					<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
						<input type='checkbox' name='id' markType="${bean.markType }" codeMode="${bean.codeMode }" value="<c:out value="${bean.markDefinitionId}"/>" accountId="${accountId}" domainId="${bean.domainId }" />
					</v3x:column>
					<v3x:column width="20%" type="String" onClick="editMarkDefPage('${bean.markDefinitionId}','view');" onDblClick="editMarkDefPage('${bean.markDefinitionId}','edit','${accountId}');" label="edoc.docmark.current" className="cursor-hand sort mxtgrid_black" value="${bean.mark}">
					</v3x:column>
					<%-- 公文文号类型--%>
					<v3x:column width="10%" type="String" onClick="editMarkDefPage('${bean.markDefinitionId}','view');" onDblClick="editMarkDefPage('${bean.markDefinitionId}','edit','${accountId}');" label="edoc.element.wordno.type" className="cursor-hand sort">
						<c:choose>
							<c:when test="${bean.markType==0}">
								<fmt:message key="edoc.element.wordno.label" />
							</c:when>
							<c:when test="${bean.markType==1}">
								<fmt:message key="edoc.element.wordinno.label" />
							</c:when>
							<c:when test="${bean.markType==2}">
								<fmt:message key="exchange.edoc.signingNo" bundle='${exchangeI18N}' />
							</c:when>
						</c:choose>
					</v3x:column>
					<%-- 预留文号 --%>
					<v3x:column width="20%" type="String" onClick="editMarkDefPage('${bean.markDefinitionId}','view');" onDblClick="editMarkDefPage('${bean.markDefinitionId}','edit','${accountId}');" label="edoc.mark.reserve.up" className="cursor-hand sort" maxLength="50"  symbol="..." value="${bean.markReserveUp}" >
					</v3x:column>
					<%-- 线下占用 --%>
					<v3x:column width="15%" type="String" onClick="editMarkDefPage('${bean.markDefinitionId}','view');" onDblClick="editMarkDefPage('${bean.markDefinitionId}','edit','${accountId}');" label="edoc.mark.reserve.down.label" className="cursor-hand sort" maxLength="40"  symbol="..." value="${bean.markReserveDown}" >
					</v3x:column>
					<%-- 授权信息查了2次组织模型： 1：controller 2：标签 --%>
					<v3x:column width="15%" type="String" onClick="editMarkDefPage('${bean.markDefinitionId}','view');" onDblClick="editMarkDefPage('${bean.markDefinitionId}','edit','${accountId}');" label="edoc.docmark.grantdepart" className="cursor-hand sort" maxLength="40"  symbol="..." value="${v3x:showOrgEntities(bean.aclEntity, 'id', 'entityType', pageContext)}" >
					</v3x:column>
					<v3x:column width="15%" type="String" onClick="editMarkDefPage('${bean.markDefinitionId}','view');" onDblClick="editMarkDefPage('${bean.markDefinitionId}','edit','${accountId}');" label="排序号" className="cursor-hand sort" maxLength="50"  symbol="..." value="${bean.markDef.sortNo}" >
					</v3x:column>
				</v3x:table>
				<div id="deleteInfo"></div>
				</form>
			</div>
  </div>
</div>
<iframe name="empty" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0">
</iframe>
<script type="text/javascript">
showDetailPageBaseInfo("detailFrame", "<fmt:message key='menu.edoc.wordNoManager' bundle="${v3xMainI18N}"/>", [1,2], pageQueryMap.get('count'), _("edocLang.detail_info_4002"));	
</script>
</body>
</html>