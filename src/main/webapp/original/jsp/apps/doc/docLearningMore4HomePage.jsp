<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<html>
<head>
<%@ include file="docHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<c:if test="${CurrentUser.skin != null}">
<link rel="stylesheet" href="<c:url value="/skin/${CurrentUser.skin}/skin.css"/>">
</c:if>
<c:if test="${CurrentUser.skin == null}">
<link rel="stylesheet" href="<c:url value="${path}/skin/default/skin.css"/>">
</c:if>
<fmt:setBundle basename="com.seeyon.v3x.doc.resources.i18n.DocResource" var="v3xDocI18N"/>
<title>${v3x:_(pageContext, title)}</title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/knowledgeBrowseUtils.js" />"></script>
<script language="javascript">
	var _ctxPath = '/seeyon', _ctxServer = 'http://10.5.6.240:88/seeyon';
	var currentUserId = ${CurrentUser.id};
	function cancelLearning(){
		var listForm = self.document.getElementById("listForm");
		listForm.target = "empty";
		var aurl = "${detailURL}?method=docLearningCancel&ids=";
	
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
			alert(v3x.getMessage("DocLang.doc_jsp_larning_alert"));
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
	
	var tohtml='<span class="margin_r_10">'+"${ctp:i18n('seeyon.top.nowLocation.label')}"+'</span>'
			+"${ctp:i18n('doc.knowledge.zone')}" + '<span class="common_crumbs_next margin_lr_5">-</span>';
				<c:choose>
					<c:when test="${param.from == 'square'}">
					tohtml = tohtml + "<a href=\"javascript:showMenu('/seeyon/doc/knowledgeController.do?method=toKnowledgeSquare')\">"
			         + v3x.getMessage("DocLang.doc_jsp_knowledge_square") +'</a>'
		             + '<span class="common_crumbs_next margin_lr_5">-</span>'
		             + "<a href=\"javascript:showMenu('/seeyon/doc.do?method=docLearningMore&accountId=${CurrentUser.loginAccount}&from=square')\">"+"${v3x:_(pageContext, title)}"+"</a>";

		         	showCtpLocation("",{html:tohtml});
				</c:when>
				<c:when test="${param.from == 'homepage'}">
				tohtml = tohtml + "<a href=\"javascript:showMenu('/seeyon/doc/knowledgeController.do?method=personalKnowledgeCenterIndex')\">"
		         + v3x.getMessage("DocLang.doc_jsp_personal_knowledge_center") +'</a>'
	             + '<span class="common_crumbs_next margin_lr_5">-</span>'
	             + "<a href=\"javascript:showMenu('/seeyon/doc.do?method=docLearningMore&from=homepage')\">"+"${v3x:_(pageContext, title)}"+"</a>";
	         	showCtpLocation("",{html:tohtml});
				</c:when>
				<c:otherwise>
					resetCtpLocation();
				</c:otherwise>
			</c:choose>
	window.onload = function() {
		showCondition('${param.condition}',"${v3x:escapeJavascript(param.textfield)}","${v3x:escapeJavascript(param.textfield1)}");
	}
	window.onunload =  function() {
		getA8Top().$('.mxt-window').remove();
		getA8Top().$('.shield').remove();
		getA8Top().$('.dialog_box').remove();
	}
</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/> 
<style type="text/css">
	.page2-header-line,.webfx-menu-bar,.table_footer{ background:#fff;}
	.btn_xiugai td div{ background:#EDEDED;}
</style>

</head>
<body scroll="no" class=" bg_color" style="background:#EDEDED;">
<div class="main_div_row2">
  <div class="right_div_row2">
  	<div class="top_div_row2">
<table border="0" cellpadding="0" cellspacing="0" width="950" align="center">
<tr>
<td valign="top" class="padding5">	
<table align="center" width="100%" height="100%" cellpadding="0" cellspacing="0" class="page2-list-border bg_color"  border="0">	
    <tr>
	   <td height="22" class="webfx-menu-bar page2-list-header">
		<c:if test="${canAdmin == true}">
		<div class="btn_xiugai">
			<script type="text/javascript">
				var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
			    myBar.add(new WebFXMenuButton("cancelIssue", "<fmt:message key='common.toolbar.cancelIssue.label' bundle='${v3xCommonI18N}' />", "cancelLearning()", [5,9], "", null));		     
				document.write(myBar);
				document.close();		
			</script>
			</div>
		</c:if>
       </td>
			  <td height="26" width="40%" class="webfx-menu-bar page2-list-header"> 
					<div class="div-float-right condition-search-div">
						<form action="${detailURL}" name="searchForm" id="searchForm" method="get" style="margin: 0px">
							<input type="hidden" value="docLearningMore" name="method">
							<input type="hidden" value="${param.from}" name="from">
							<input type="hidden" value="${deptId}" name="deptId">
							<input type="hidden" value="${accountId}" name="accountId">
							<input type="hidden" value="${groupId}" name="groupId">
							<div class="div-float">
								<select name="condition" id="condition" onChange="showNextCondition(this)" class="condition">
						    		<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
							  	  <option value="name"><fmt:message key="common.name.label" bundle="${v3xCommonI18N}" /></option>
							   	 <option value="creator"><fmt:message key="doc.jsp.home.learn.push.people" bundle="${v3xDocI18N}" /></option>
						  			<option value="createDate"><fmt:message key="doc.jsp.home.learn.time" bundle="${v3xDocI18N}" /></option>
						  		</select>
					  		</div>
					  		<div id="nameDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield" onKeyDown="doSearchEnter()"></div>
					  		<div id="creatorDiv" class="div-float hidden">
								<input type="text" name="textfield" id="creatorName" class="textfield" onKeyDown="doSearchEnter()">
							</div> 
					  		<div id="createDateDiv" class="div-float hidden">
					  			<input type="text" name="textfield" class="input-date cursor-hand" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly onKeyDown="doSearchEnter()">
						  		<input type="text" name="textfield1" class="input-date cursor-hand" onClick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly onKeyDown="doSearchEnter()">
					  		</div>
							<div onClick="javascript:doSearch()" class="condition-search-button div-float"></div>
						</form>
					</div>		
	    	</td>
	</tr>
</table></td></tr></table>
</div>
	  	<div class="center_div_row2" id="scrollListDiv">
		<form name="listForm" action="" id="listForm" method="post"	style="margin: 0px">
		<input type="hidden" name="siteType" value="${siteType}" />
		<input type="hidden" name="siteId" value="${siteId}" />
		<div style="width:950px; margin:0 auto;">
		<v3x:table width="100%" htmlId="learningTable" data="${dlvos}" var="vo" isChangeTRColor="false" className="sort ellipsis">
			<v3x:column width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' value="${vo.docLearning.id}" ${v3x:outConditionExpression(canAdmin!='true', 'disabled', '')} />
			</v3x:column>

			<v3x:column width="42%" type="String" className="sort div-float" align="left" label="${v3x:_(pageContext, 'doc.metadata.def.name')}" onClick="" alt="${vo.docName}" >
			 	<a href="javascript:fnOpenKnowledge('${vo.docLearning.docResource.id}','7')">  
					<img src="${pageContext.request.contextPath}/apps_res/doc/images/docIcon/${vo.icon}" width="16" height="16"/>&nbsp;${v3x:_(pageContext, vo.docName)}
				</a>
			</v3x:column>

			<v3x:column width="15%" type="String" align="left" label="${v3x:_(pageContext, 'doc.jsp.home.learn.push.people')}"
				value="${vo.recommender}" />

			<v3x:column width="20%" type="Date" align="left" label="${v3x:_(pageContext, 'doc.jsp.home.learn.time')}">
				<fmt:formatDate value="${vo.recommendTime}" pattern="${datetimePattern}" />
			</v3x:column>
		</v3x:table>
		</div>
		</form> 
		</div>
		</div></div>
<IFRAME height="0%" name="empty" id="empty" width="0%" frameborder="0"></IFRAME>
</body>
</html>