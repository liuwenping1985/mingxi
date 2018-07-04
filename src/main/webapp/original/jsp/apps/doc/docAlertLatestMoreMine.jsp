<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ include file="docHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<fmt:setBundle basename="com.seeyon.v3x.doc.resources.i18n.DocResource" var="v3xDocI18N"/>
<title>${v3x:_(pageContext, 'doc.jsp.home.more.alert.title')}</title>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/knowledgeBrowseUtils.js" />"></script>
<script language="javascript">
function delLatest(){
	var listForm = self.document.getElementById("listForm");
	listForm.target = "empty";
	var aurl = "${detailURL}?method=docAlertLatestDel&status=${status}&flag=${flag}&ids=";

	var chkid = self.document.getElementsByName("id");
	var count = 0;
	var ids = "";
	for(var i = 0; i < chkid.length; i++){
		if(chkid[i].checked){
			count += 1;
			ids += "," + chkid[i].value;
		}
	}
	if(count == 0) {
		alert(v3x.getMessage("DocLang.doc_more_alert_latest_select_alert"))
		return;
	}

	if(!window.confirm(v3x.getMessage("DocLang.are_you_sure_delete_selected_alerts"))) {
		return;
	}
	aurl += ids.substring(1, ids.length);
	listForm.action = aurl;	
	listForm.submit();
}
/**
 * 按发起人查询，选人界面返回值
 */
function setSearchPeopleFields(elements){
	document.getElementById("creatorId").value = getIdsString(elements, false);
	document.getElementById("creatorName").value = getNamesString(elements);
}

window.onload = function() {
	showCondition('${param.condition}',"${v3x:escapeJavascript(param.textfield)}","${v3x:escapeJavascript(param.textfield1)}");
}
</script>
</head>
<body scroll="no">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
		<table id="docAlertLatestTable" align="center" width="100%" height="100%" cellpadding="0" cellspacing="0" >
			<tr>
				<td height="25" class="page_color">
					<script>
				    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}",'gray');
				    	myBar.add(new WebFXMenuButton("cancel", "<fmt:message key='doc.jsp.alert.admin.delete'/>", "javascript:delLatest()", [1,2], "", null));
				    	document.write(myBar);
				    	document.close();
					</script>
				</td>
				  <td height="26" width="40%" class="webfx-menu-bar page2-list-header"> 
					<div class="div-float-right">
						<form action="${detailURL}" name="searchForm" id="searchForm" method="get" style="margin: 0px">
							<input type="hidden" value="docAlertLatestMore" name="method">
							<input type="hidden" value="${status}" name="status">
							<input type="hidden" value="${flag}" name="flag">
							<div class="div-float">
								<select name="condition" id="condition" onChange="showNextCondition(this)" class="condition">
						    		<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
							  	  	<option value="name"><fmt:message key="common.name.label" bundle="${v3xCommonI18N}" /></option>
							  	  	<option value="category"><fmt:message key="doc.search.category.label" bundle='${v3xDocI18N}' /></option>
							  	  	<option value="keywords"><fmt:message key="doc.metadata.def.keywords" bundle="${v3xDocI18N}" /></option>
							   	 	<option value="creator"><fmt:message key="doc.metadata.def.lastuser" bundle="${v3xDocI18N}" /></option>
						  			<option value="createDate"><fmt:message key="doc.metadata.def.lastupdate" bundle="${v3xDocI18N}" /></option>
						  		</select>
					  		</div>
					  		<div id="nameDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield" onkeydown="doSearchEnter()"></div>
					  		<div id="keywordsDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield" onkeydown="doSearchEnter()"></div>
					  		<div id="creatorDiv" class="div-float hidden">
								<v3x:selectPeople id="creator" panels="Department,Team,Post,Outworker" selectType="Member" departmentId="${currentUser.departmentId}" jsFunction="setSearchPeopleFields(elements)" minSize="0" maxSize="1" />
								<input type="hidden" name="textfield" id="creatorId" />
								<input type="text" name="textfield1" id="creatorName" class="textfield cursor-hand" readonly onclick="selectPeopleFun_creator()" />
							</div> 
					  		<div id="categoryDiv" class="div-float hidden">
					  			<select name="textfield" class="category">
					        	    <option value=""><fmt:message key="doc.please.select" /></option>
					        	    <c:forEach items="${types}" var="t">
						      	     <option value="${t.id}" title="${v3x:toHTML(v3x:_(pageContext, t.name))}">
							 	      <c:set var="tempV" value="${v3x:getLimitLengthString(v3x:_(pageContext, t.name), 15,'...')}" />
		                           	      ${v3x:toHTML(tempV)}
						       		 </option>
					        	</c:forEach>
					  			</select>
					  		</div>
					  		<div id="createDateDiv" class="div-float hidden">
					  			<input type="text" name="textfield" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly onkeydown="doSearchEnter()">
						  		<input type="text" name="textfield1" class="input-date cursor-hand" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly onkeydown="doSearchEnter()">
					  		</div>
							<div onclick="javascript:doSearch()" class="condition-search-button div-float"></div>
						</form>
					</div>		
		    	</td>
			</tr>
		</table>	
    </div>
    <div class="center_div_row2" id="scrollListDiv">
		<form name="listForm" action="" id="listForm" method="post" style="margin: 0px">
			<input type="hidden" name="siteType" value="${siteType}" /> 
			<input type="hidden" name="siteId" value="${siteId}" />
			<v3x:table width="100%" htmlId="docTable" data="${dalvos}" var="vo" >

			<v3x:column width="5%" align="center"
				label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' value="${vo.docAlertLatest.id}" />
			</v3x:column>

			<v3x:column width="40%" type="String" className="sort"
				align="left"
				label="${v3x:_(pageContext, 'doc.metadata.def.name')}" onClick="">
			
	        	<a href="javascript:fnOpenKnowledge('${vo.docResource.id}')" class="title-more">

			<img src="${pageContext.request.contextPath}/apps_res/doc/images/docIcon/${vo.icon}" width="16" height="16"/>&nbsp;${v3x:toHTML(v3x:_(pageContext, vo.docResource.frName))}</a>
		        <c:if test="${vo.hasAttachments}">
		           <span class='attachment_true'></span>
		        </c:if>
			</v3x:column>

			<v3x:column width="15%" type="String" align="left" label="${v3x:_(pageContext, 'doc.metadata.def.type')}"
				value="${v3x:_(pageContext, vo.type)}"></v3x:column>

			<v3x:column width="10%" type="String" align="left" label="${v3x:_(pageContext, 'doc.jsp.home.alert.oprtype')}"
				value="${vo.oprType}"></v3x:column>

			<v3x:column width="10%" type="String" align="left" label="${v3x:_(pageContext, 'doc.metadata.def.lastuser')}"
				value="${vo.lastUserName}"></v3x:column>

			<v3x:column width="20%" type="Date" align="left" label="${v3x:_(pageContext, 'doc.metadata.def.lastupdate')}">
				<fmt:formatDate value="${vo.docAlertLatest.lastUpdate}"
					pattern="${datetimePattern}" />
			</v3x:column>

		</v3x:table>
	</form>
	<IFRAME height="0%" name="empty" id="empty" width="0%" frameborder="0"></IFRAME>
    </div>
  </div>
</div>
</body>
</html>
