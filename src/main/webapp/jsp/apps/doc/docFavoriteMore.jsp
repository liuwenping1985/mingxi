<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="docHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>	
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<fmt:setBundle basename="com.seeyon.apps.doc.resources.i18n.DocResource" var="v3xDocI18N"/>
<title>${v3x:_(pageContext, title)}</title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/knowledgeBrowseUtils.js" />"></script>
<style type="text/css">
.with-header .right_div_row2 >.center_div_row2{
    top:64px;
}
</style>
<script language="javascript">
	function cancelFavorite(){
		var listForm = self.document.getElementById("listForm");
		listForm.target = "empty";
		var aurl = "${detailURL}?method=docFavoriteCancel&ids=";
	
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
			alert(v3x.getMessage("DocLang.doc_more_select_alert"))
			return;
		}
        aurl += ids.substring(1, ids.length);
			listForm.action = aurl;	
		listForm.submit();
	}
	
	function reSort(flag, id){
		var listForm = self.document.getElementById("listForm");
		listForm.target = "empty";
		var aurl = "${detailURL}?method=docFavoriteResort&id=" + id + "&flag=" + flag + "&destId=";

		var rows = document.getElementById("bTablefavoriteTable").rows;
		var len = document.getElementsByName("id").length;
		for(var i = 0; i < rows.length; i++) {
			if(rows[i].id == ("tr" + id)){
				if(flag == 'up') {
					if(i == 0){
						return;
					}
					var dest = rows[i - 1].id;
					aurl += dest.substring(2, dest.length);		
					if(navigator.userAgent.indexOf('MSIE')>0){
					    rows[i].swapNode(rows[i - 1]);
                    }else{
                        swapNode(rows[i],rows[i - 1]);
                    }
				}else if(flag == 'down') {
					if(i == len - 1){
						return;
					}
					var dest = rows[i + 1].id;
					aurl += dest.substring(2, dest.length);		
					if(navigator.userAgent.indexOf('MSIE')>0){
					    rows[i].swapNode(rows[i + 1]);
					}else{
					    swapNode(rows[i],rows[i + 1]);
					}
				}
				
				listForm.action = aurl;
				listForm.submit();
				break;
			}			
		}
	}
	
    //交换2个DOM节点
    function swapNode(node1,node2)
    {
      var parent = node1.parentNode;//父节点
      var t1 = node1.nextSibling;//两节点的相对位置
      var t2 = node2.nextSibling;
      
      //如果是插入到最后就用appendChild
      if(t1) parent.insertBefore(node2,t1);
      else parent.appendChild(node2);
      if(t2) parent.insertBefore(node1,t2);
      else parent.appendChild(node1);
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
<body scroll="no" class="with-header">
<div class="main_div_row2">
  <div class="right_div_row2">
  <div class="top_div_row2">
<input type="hidden" name="siteType" value="${siteType}" /> 
<input type="hidden" name="siteId" value="${siteId}" />
<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
	<tr class="page2-header-line">
		<td width="100%" height="38" valign="top" class="page-list-border-LRD gov_noborder gov_top_border" colspan="2">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     <tr class="page2-header-line">
		        <td width="45" class="page2-header-img"><div class="docFavoriteMore"></div></td>
		        <td class="page2-header-bg">${v3x:_(pageContext, title)}(${total}${v3x:_(pageContext, 'doc.jsp.home.more.item')})</td>       
			</tr>
			</table>
		</td>
	</tr>
<tr>
	   <td height="22" class="webfx-menu-bar page2-list-header"  id="docFavoriteMoreTable">
	    <c:if test="${canAdmin == true}">
		<script type="text/javascript">
			var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
		    myBar.add(new WebFXMenuButton("cancelIssue", "<fmt:message key='common.toolbar.cancelIssue.label' bundle='${v3xCommonI18N}' />", "cancelFavorite()", [5,9], "", null));		     
			document.write(myBar);
			document.close();		
		</script>
		</c:if>
       </td>
			  <td height="26" width="40%" class="webfx-menu-bar page2-list-header"> 
					<div class="div-float-right condition-search-div">
						<form action="${detailURL}" name="searchForm" id="searchForm" method="get" style="margin: 0px">
							<input type="hidden" value="docFavoriteMore" name="method">
							<input type="hidden" name="userType" value="${userType}" /> 
							<input type="hidden" value="${param.from}" name="from">
							<input type="hidden" value="${param.deptId}" name="deptId">
							<div class="div-float">
								<select name="condition" id="condition" onChange="showNextCondition(this)" class="condition" style="height:22px">
						    		<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
							  	  	<option value="name"><fmt:message key="common.name.label" bundle="${v3xCommonI18N}" /></option>
							  	  	<option value="category"><fmt:message key="doc.search.category.label" bundle='${v3xDocI18N}' /></option>
							  	  	<option value="keywords"><fmt:message key="doc.metadata.def.keywords" bundle="${v3xDocI18N}" /></option>
							   	 	<option value="creator"><fmt:message key="doc.search.creator.label" bundle="${v3xDocI18N}" /></option>
						  			<option value="createDate"><fmt:message key="doc.jsp.favorite.createTime" bundle="${v3xDocI18N}" /></option>
						  		</select>
					  		</div>
					  		<div id="nameDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield" onkeydown="doSearchEnter()"></div>
					  		<div id="keywordsDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield" onkeydown="doSearchEnter()"></div>
					  		<div id="creatorDiv" class="div-float hidden">
								<input type="text" name="textfield" id="creatorName" class="textfield" onKeyDown="doSearchEnter()">
							</div> 
					  		<div id="categoryDiv" class="div-float hidden">
					  			<select name="textfield" class="category" style="height:22px">
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
		<v3x:table htmlId="favoriteTable" data="${dfvos}" var="vo" isChangeTRColor="false" className="sort ellipsis">
			<v3x:column width="5%" align="center"
				label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' value="${vo.docFavorite.id}" 
				${v3x:outConditionExpression(canAdmin!='true', 'disabled', '')}
				/>
			</v3x:column>

			<v3x:column width="30%" type="String" className="sort"
				align="left" label="${v3x:_(pageContext, 'doc.metadata.def.name')}" onClick="">
			<c:if test="${vo.docResource.isFolder == false && vo.isFolderLink == false}">
	        	<a href="javascript:fnOpenKnowledge('${vo.docResource.id}','6')" class='defaulttitlecss' >
	        </c:if>

	        <c:if test="${vo.docResource.isFolder == true}">
	        	<a  class='defaulttitlecss' href="javascript:folderOpenFunHomepage('${vo.docResource.id}', '${vo.docResource.frType}','${vo.allAcl}', '${vo.editAcl}', '${vo.addAcl}', '${vo.readOnlyAcl}', '${vo.browseAcl}', '${vo.listAcl}', 'false', '${vo.docLibId}', '${vo.docLibType}')">
	        </c:if>
	        <c:if test="${vo.docResource.isFolder == false && vo.isFolderLink == true}">
	        	<a  class='defaulttitlecss'  href="javascript:folderOpenFunHomepage('${vo.docResource.sourceId}', '${vo.docResource.frType}','${vo.allAcl}', '${vo.editAcl}', '${vo.addAcl}', '${vo.readOnlyAcl}', '${vo.browseAcl}', '${vo.listAcl}', 'true', '${vo.docLibId}', '${vo.docLibType}')">
	        </c:if>
			<img src="${pageContext.request.contextPath}/apps_res/doc/images/docIcon/${vo.icon}" width="16" height="16"/>&nbsp;${v3x:toHTML(v3x:_(pageContext, vo.docResource.frName))}
            <c:if test="${vo.hasAttachments}">
                <span class="attachment_table_true inline-block"></span>
            </c:if>
            </a>
			</v3x:column>

			<v3x:column width="15%" type="String" align="left" label="${v3x:_(pageContext, 'doc.metadata.def.type')}"
				value="${v3x:_(pageContext, vo.type)}"></v3x:column>

			<v3x:column width="10%" type="Size" align="right" label="${v3x:_(pageContext, 'doc.metadata.def.size')}"
				value="${vo.size}"></v3x:column>

			<v3x:column width="10%" type="String" align="left" label="${v3x:_(pageContext, 'doc.metadata.def.creater')}"
				value="${vo.createUserName}"></v3x:column>

			<v3x:column width="20%" type="Date" align="left" label="${v3x:_(pageContext, 'doc.jsp.favorite.createTime')}">
				<fmt:formatDate value="${vo.docFavorite.createTime}"
					pattern="${datetimePattern}" />
			</v3x:column>
			
			<v3x:column width="10%" align="center" label="${v3x:_(pageContext, 'doc.jsp.home.more.favorite.sort')}">
			<c:if test="${canAdmin == true}">
				<img src="${pageContext.request.contextPath}/apps_res/doc/images/moveUp.gif" onclick="reSort('up', '${vo.docFavorite.id}')" />&nbsp;&nbsp;&nbsp;
				<img src="${pageContext.request.contextPath}/apps_res/doc/images/moveDown.gif" onclick="reSort('down', '${vo.docFavorite.id}')" />
			</c:if>
			<c:if test="${canAdmin == false}">
				<img src="${pageContext.request.contextPath}/apps_res/doc/images/moveUp.gif" onclick="" />&nbsp;&nbsp;&nbsp;
				<img src="${pageContext.request.contextPath}/apps_res/doc/images/moveDown.gif" onclick="" />
			</c:if>
			</v3x:column>
		</v3x:table>
		</form>
		</div> 
	</div></div>
<IFRAME height="0%" name="empty" id="empty" width="0%" frameborder="0"></IFRAME>
<script type="text/javascript">
	var modyTableTr=document.getElementById("bTablefavoriteTable");

	var temp_meta_id=document.getElementsByName("id");
	for(var m=0; m<temp_meta_id.length;m++){
		modyTableTr.rows[m].id="tr"+temp_meta_id[m].value;		//为当前存在得行设置ID
	}
</script>
</body>
</html>