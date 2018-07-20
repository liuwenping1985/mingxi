<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%@ include file="../docHeader.jsp" %>
<%@include file="../../../common/INC/noCache.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/docVersion.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/knowledgeBrowseUtils.js" />"></script>
<script type="text/javascript">
	var currentUserId = "${v3x:currentUser().id}";
	<c:if test="${fn:length(allVersions) == 0 && empty param.condition}">
		alert(parent.v3x.getMessage('DocLang.doc_has_no_history_alert'));
		getA8Top().docHisWin.close();
	</c:if>
	
	window.onload = function() {
		showProcDiv();
		initVersionListMenuACL('${param.all}', '${param.edit}', '${param.add}', '${param.readonly}', '${param.browse}', '${param.list}', '${param.isBorrowOrShare}', '${isUploadFile}');
		showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "${param.textfield1}");
	}

	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
	myBar.add(new WebFXMenuButton("renew", "<fmt:message key='doc.menu.history.renew.label'/>", "replace2Latest('${param.docResId}');", [21,4]));
	myBar.add(new WebFXMenuButton("delete", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />",  "deleteDocResHistory();", [1,3]));
	myBar.add(new WebFXMenuButton("editComment", "<fmt:message key='doc.menu.history.editcomment.label' />",  "toEditComment();", [1,2]));
	myBar.add(new WebFXMenuButton("back", "<fmt:message key='common.toolbar.back.label' bundle='${v3xCommonI18N}'/>",  "getA8Top().docHisWin.close();", [7,4]));
</script>
</head>
<body scroll='no'>
<c:set value="${v3x:currentUser()}" var="currentUser" />
<%-- docLibType == 5 表明来自集团文档库 --%>
<v3x:selectPeople id="docversion" panels="Department,Team" selectType="Member" departmentId="${currentUser.departmentId}" 
		jsFunction="setDocVersionPeopleFields(elements)" minSize="0" maxSize="1" showAllAccount="${param.docLibType == 5}"  />
<script type="text/javascript">
	onlyLoginAccount_docversion = "${param.docLibType != 5}";
</script>
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="22" valign="top" class="webfx-menu-bar">
					<script type="text/javascript">
						document.write(myBar);	
					</script>
				</td>
				
				<td height="22" align="right" class="webfx-menu-bar page2-list-header">
				<form action="" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
					<input type="hidden" name="method" value="listAllDocVersions">
					<input type="hidden" name="docResId" value="${param.docResId}" >
					<input type="hidden" name="all" value="${param.all}" >
					<input type="hidden" name="edit" value="${param.edit}" >
					<input type="hidden" name="add" value="${param.add}" >
					<input type="hidden" name="readonly" value="${param.readonly}" >
					<input type="hidden" name="browse" value="${param.browse}" >
					<input type="hidden" name="list" value="${param.list}" >
					<input type="hidden" name="isBorrowOrShare" value="${param.isBorrowOrShare}" >
					<input type="hidden" name="docLibId" value="${param.docLibId}" >
					<input type="hidden" name="docLibType" value="${param.docLibType}" >
					<input type="hidden" name="entranceType" value="${param.entranceType}" >
					<div class="div-float-right">
						<div class="div-float">
							<select name="condition" id="condition" onChange="showNextCondition(this)" class="condition">
								<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
								<option value="name"><fmt:message key="doc.column.name" /></option>
								<option value="createUser"><fmt:message key="doc.metadata.def.lastuser" /></option>
								<option value="createDate"><fmt:message key="doc.metadata.def.lastupdate" /></option>
								<option value="versionNumber"><fmt:message key="doc.menu.version.label" /></option>
							</select>
						</div>
						
						<div id="nameDiv" class="div-float hidden">
							<input type="text" name="textfield" id="nameInput" class="textfield" onkeydown="javascript:doSearchEnter()" maxlength="100">
						</div>
						
						<div id="createUserDiv" class="div-float hidden">
							<input type="text" name="textfield" id="userName" 
								class="textfield" onkeydown="javascript:doSearchEnter()" maxlength="100">
							<input type="hidden" name="textfield1" id="userId">
						</div>
						
						<div id="createDateDiv" class="div-float hidden">	
							<input type="text" name="textfield" id="startdate" class="input-date" onpropertychange="setDate('startdate')"
								onclick="whenstart('${pageContext.request.contextPath}', this, 640, 265);" readonly > - 
				 			<input type="text" name="textfield1" id="enddate" class="input-date" onpropertychange="setDate('enddate')"
				 				onclick="whenstart('${pageContext.request.contextPath}', this, 720, 265);" readonly >
				 		</div>
				 		
				 		<div id="versionNumberDiv" class="div-float hidden">	
							<input type="text" name="textfield" id="versionNumberInput" class="textfield" onkeydown="javascript:doSearchEnter()" maxlength="8">
				 		</div>
				 		
						<div onclick="javascript:doSearch()" class="condition-search-button"></div>
					</div>
				</form>
				</td>
				<td width="10"  class="webfx-menu-bar page2-list-header"></td>
			</tr>
		</table>	
    </div>
    <div class="center_div_row2" id="scrollListDiv">
    	<form name="listForm" id="listForm" method="get" onsubmit="return false" style="margin:0px">
		<v3x:table htmlId="listTable" data="allVersions" var="dvi" className="sort ellipsis">
		   	<c:set var="paramUrl" value="versionFlag=HistoryVersion&docVersionId=${dvi.id}&all=${param.all}&edit=${param.edit}&add=${param.add}&readonly=${param.readonly}&browse=${param.browse}&isBorrowOrShare=${param.isBorrowOrShare}&list=${param.list}&docLibId=${param.docLibId}&docLibType=${param.docLibType}" />
		   	<c:set scope="request" var="onClick" value="javascript:viewHistoryVersion('${dvi.id}','${param.entranceType}','${dvi.vForDocVersion}');" />
			
			<v3x:column width="5%" widthFixed="true" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' id='dvi_${dvi.id}' value="<c:out value="${dvi.id}"/>" />
			</v3x:column>
			
			<v3x:column width="10%" widthFixed="true" onClick="${onClick}" label="doc.metadata.def.icon" 
				className="cursor-hand sort" align="center">
				<img src="<c:url value="/apps_res/doc/images/docIcon/${v3x:getIcon(dvi.mimeTypeId)}"/>" width="16" height="16">
			</v3x:column>
			
			<v3x:column width="15%" type="String" onClick="${onClick}" label="doc.column.name" 
				className="cursor-hand sort" alt="${dvi.frName}" symbol="..." 
				hasAttachments="${dvi.hasAttachments}" value="${dvi.frName}" />
		
			<v3x:column width="15%" widthFixed="true" type="String" onClick="${onClick}" label="doc.menu.version.label" 
				className="cursor-hand sort" value="V${dvi.version}.0" />
				
			<v3x:column width="10%" widthFixed="true" type="String" onClick="${onClick}" label="doc.metadata.def.size" 
				className="cursor-hand sort" align="right" value="${v3x:formatFileSize(dvi.frSize, true)}" />
			
			<v3x:column width="15%" type="String" onClick="${onClick}" label="doc.metadata.def.lastuser"
				className="cursor-hand sort" value="${v3x:showMemberName(dvi.lastUserId)}" />				
			
			<v3x:column width="15%" type="String" onClick="${onClick}" label="doc.metadata.def.lastupdate" 
				className="cursor-hand sort">
				<fmt:formatDate value="${dvi.lastUpdate}" pattern="${dateTimePattern}" />
			</v3x:column>
		
			<v3x:column type="String" width="15%" label="doc.menu.history.note.label" className="cursor-hand sort">
				<div style="text-align :center;float:left" id="versionCommentDiv_${dvi.id}" title="<c:out value='${dvi.versionComment}' escapeXml='true'/>">
					<label id="versionCommentLabel_${dvi.id}" onClick="toEditComment('${dvi.id}')">
						${v3x:toHTML(dvi.versionComment)}
					</label>
				</div>
			</v3x:column>
		</v3x:table>
		</form>
		<div id="procDiv1" style="display:none;"></div>
		<iframe name="deleteIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
    </div>
  </div>
</div>
</body>
</html>