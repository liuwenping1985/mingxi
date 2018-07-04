<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<html>
<head>
<%@ include file="docHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<fmt:setBundle basename="com.seeyon.apps.doc.resources.i18n.DocResource"/>
<title>${v3x:_(pageContext, title)}</title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/knowledgeBrowseUtils.js" />"></script>
<script language="javascript">
	getA8Top().showLeftNavigation();
	resetCtpLocation();
	var currentUserId = ${CurrentUser.id};
	function cancelLearning(){
		var listForm = self.document.getElementById("listForm");
		listForm.target = "empty";
		var aurl = "${detailURL}?method=docLearningCancel&fromPage=${titlePostfix}&ids=";
	
		var chkid = self.document.getElementsByName("id");
		var checkRemind = self.document.getElementsByName("checkRemind");
		var remindInfo = self.document.getElementsByName("remindInfo");
		var isCheckRed = false;
		var count = 0;
		var ids = "";
		var remindInfos = "";
		var remindLength = 20;
		for(var i = 0; i < chkid.length; i++){
			if(chkid[i].checked){
				count += 1;
				ids += "," + chkid[i].value;
				if(checkRemind[i].value =="true"){
					isCheckRed = true;
					remindInfos += remindInfo[i].value+"、";
				}
				
			}
			
		}
		if(remindInfos.substring(remindInfos.length-1) == "、"){
			remindInfos = remindInfos.substring(0,remindInfos.length-1);
		}
		var remindInfosLimt = fnSubString(remindInfos,remindLength);
		
		if(count == 0) {
			alert(v3x.getMessage("DocLang.doc_only_more_select_alert"))
			return;
		}
		if("${titlePostfix}" == "personal" && isCheckRed){
<%--			var reminds = "<div style='line-height:180%;' >"+v3x.getMessage("DocLang.doc_learning_cancel_remindinfo1")+"<span title='"+remindInfos+"'>"+remindInfosLimt+"</span>"+v3x.getMessage("DocLang.doc_learning_cancel_remindinfo2")+"</div>";--%>
			var reminds = "<div style='line-height:180%;' >"+v3x.getMessage("DocLang.doc_learning_cancel_remindall")+"</div>";
			var confirm = getA8Top().$.confirm({
			    'msg': reminds,
			    ok_fn: function () {
			    	aurl += ids.substring(1, ids.length);
					listForm.action = aurl;	
					listForm.submit();
				},
				cancel_fn:function(){
					return;
				}
			});
		}else{
			aurl += ids.substring(1, ids.length);
			listForm.action = aurl;	
			listForm.submit();
		}
		
	}
	

	/**
	 * 按发起人查询，选人界面返回值
	 */
	function setSearchPeopleFields(elements){
		document.getElementById("creatorId").value = getIdsString(elements, false);
		document.getElementById("creatorName").value = getNamesString(elements);
	}
	
	function fnRefreshDocLearningMore(){
		doSearch();
	}

	window.onload = function() {
		showCondition('${param.condition}',"${v3x:escapeJavascript(param.textfield)}","${v3x:escapeJavascript(param.textfield1)}");
	}
	function fnCloseAllDialog() {
		getA8Top().$('.mxt-window').remove();
		getA8Top().$('.shield').remove();
		getA8Top().$('.dialog_box').remove();
	}
	function fnSubString(srcStr,len){
	    if(len == null|| typeof(len) != 'number'){
	        return srcStr;
	    }
	    
	    if(srcStr != null && srcStr.length > len){
	        srcStr = srcStr.substr(0,len-1)+ "...";
	    }
	    
	    return srcStr;
	}
</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/> 
<style type="text/css">
.border_t {
    border-top: 1px #CDCDCD solid;
}
.with-header .top_div_row2 {
 height:65px;
}
.with-header .right_div_row2>.center_div_row2 {
 top:77px;
}
</style>
</head>
<body scroll="no" class="with-header" onunload="fnCloseAllDialog();">
<div class="main_div_row2">
  <div class="right_div_row2 border_all">
  	<div class="top_div_row2">
<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
	<tr class="page2-header-line">
		<td width="100%" height="38" valign="top">
			 <table width="100%"  border="0" cellpadding="0" cellspacing="0">
		     	<tr class="page2-header-line" >
		        <td width="45"><div class="docLearningMore"></div></td>
		        <td class="page2-header-bg">${v3x:_(pageContext, title)}(${total}${v3x:_(pageContext, 'doc.jsp.home.more.item')})</td>
			</tr>
			</table>
		</td>
	</tr>
<tr>
<td valign="top" class="padding5">	
<table align="center" width="100%" height="100%" cellpadding="0" cellspacing="0" class="page2-list-border border_t">	
    <tr>
	   <td height="22" class="webfx-menu-bar page2-list-header">
		<c:if test="${canAdmin == true}">
			<script type="text/javascript">
				var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
			    myBar.add(new WebFXMenuButton("cancelIssue", "<fmt:message key='common.toolbar.cancelIssue.label' bundle='${v3xCommonI18N}' />", "cancelLearning()", [5,9], "", null));		     
				document.write(myBar);
				document.close();		
			</script>
		</c:if>
       </td>
			  <td height="26" width="40%" valign="middle" class="webfx-menu-bar page2-list-header"> 
					<div class="div-float-right condition-search-div">
						<form action="${detailURL}" name="searchForm" id="searchForm" method="get" style="margin: 0px">
							<input type="hidden" value="docLearningMore" name="method">
							<input type="hidden" value="${param.from}" name="from">
							<input type="hidden" value="${deptId}" name="deptId">
							<input type="hidden" value="${accountId}" name="accountId">
							<input type="hidden" value="${groupId}" name="groupId">
							<div class="div-float">
								<select name="condition" id="condition" onChange="showNextCondition(this)" style="width:105px;margin-right: 2px;height:26px;line-height: 26px;border:1px solid #e4e4e4;">
						    		<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
							  	  <option value="name"><fmt:message key="common.name.label" bundle="${v3xCommonI18N}" /></option>
							   	 <option value="creator"><fmt:message key="doc.jsp.home.learn.push.people" /></option>
						  			<option value="createDate"><fmt:message key="doc.jsp.home.learn.time" /></option>
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
							<div onClick="javascript:doSearch()" id = "doSearchId" class="condition-search-button div-float"></div>
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
		<v3x:table width="100%" htmlId="learningTable" data="${dlvos}" var="vo" isChangeTRColor="false" className="sort ellipsis">
			<v3x:column width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' value="${vo.docLearning.id}" ${v3x:outConditionExpression(canAdmin!='true', 'disabled', '')} />
				<input type="hidden" name='checkRemind' value = "${vo.checkRemined}" />
				<input type="hidden" name='remindInfo' value = "${vo.remindInfo}" />
			</v3x:column>
            
            <v3x:column width="25" align="center">
                <img style="margin-top:5px;" src="${pageContext.request.contextPath}/apps_res/doc/images/docIcon/${vo.icon}" width="16" height="16"/>&nbsp;
            </v3x:column>
			<v3x:column width="55%" type="String" className="sort div-float" align="left" label="${v3x:_(pageContext, 'doc.metadata.def.name')}" onClick="" alt="${vo.docName}" >
			 	<a href="javascript:fnOpenKnowledge('${vo.docLearning.docResource.id}','6')">  
					${v3x:toHTML(v3x:_(pageContext, vo.docName))}
                    <c:if test="${vo.hasAttachments }">
                        <span class="attachment_table_true inline-block"></span>
                    </c:if>
				</a>
			</v3x:column>

            <c:choose>
				<c:when test="${personalLearning == 'true'}">
				<v3x:column width="10%" type="String" align="left" label="${v3x:_(pageContext, 'doc.jsp.home.learn.push.people')}"
				value="${vo.recommender}" />
		           <v3x:column width="15%" type="String" alt="${vo.sendOthersStrAll}" align="left" label="${v3x:_(pageContext, 'doc.jsp.home.learn.recommend.area')}" value="${vo.sendOthersStrAll}">
		           </v3x:column>
				   <v3x:column width="10%" type="Date" align="left" label="${v3x:_(pageContext, 'doc.jsp.home.learn.time')}">
						<fmt:formatDate value="${vo.recommendTime}" pattern="${datetimePattern}" />
					</v3x:column>
           		</c:when>
           		<c:otherwise>
           		<v3x:column width="15%" type="String" align="left" label="${v3x:_(pageContext, 'doc.jsp.home.learn.push.people')}"
				value="${vo.recommender}" />
				   <v3x:column width="20%" type="Date" align="left" label="${v3x:_(pageContext, 'doc.jsp.home.learn.time')}">
						<fmt:formatDate value="${vo.recommendTime}" pattern="${datetimePattern}" />
					</v3x:column>
           		</c:otherwise>
           </c:choose>
		</v3x:table>
						</form> 
		</div>
		</div></div>
<IFRAME height="0%" name="empty" id="empty" width="0%" frameborder="0"></IFRAME>
</body>
</html>