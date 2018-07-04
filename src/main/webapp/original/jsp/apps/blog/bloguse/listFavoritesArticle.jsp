<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<title></title>
<%@ include file="../header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
</head>
<script type="text/javascript">
</script>
<body scroll="no" class="with-header">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr class="page2-header-line">
				<td width="100%" height="30" valign="top" class="page-list-border-LRD">
					 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
				     	<tr class="page2-header-line">
				        <td width="45" class="page2-header-img"><div class="bulltenIndex"></div></td>
						<td class="page2-header-bg"><fmt:message key="blog.family.favorites"/></td>
						<td class="page2-header-line padding-right" align="right">
							<div>&nbsp;<fmt:message key="blog.choose.group"/>:
		                         <select style="width:40%" id="familyList" onchange = "javascript:modtifyArticleModel('${detailURL}?method=modifyFavoritesArticle')" name="familyList">
		                            <option value="${defaultFmId}">-- <fmt:message key="blog.favorites.choose" />   --</option>        
		                                   <c:forEach items="${FamilyModelList}" var="vo">
		                                      <option value="${vo.id}">${v3x:toHTML(vo.nameFamily)}</option>
		                                   </c:forEach>
		   	                     </select>
								<a href="${detailURL}?method=indexFavoritesSetup" class="hyper_link2">[
								<fmt:message key="blog.family.favorites.setup" />]</a>&nbsp; 
								<c:if test="${onlyDefault == false}">
								<a href="${detailURL}?method=listFavoritesArticleGroupByFamily" class="hyper_link2">[
								<fmt:message key="blog.article.view.byfamily" />]</a>&nbsp; 
								</c:if>
								<a href="${detailURL}?method=blogHome" class="hyper_link2">
										[<fmt:message key="common.toolbar.back.label" bundle="${v3xCommonI18N}" />]
								</a>&nbsp;&nbsp;
							</div>
						</td>
					    </tr>
					 </table>
				</td>
			</tr>
			<tr>
				<td height="40" class="bbs-title-bar" width="50%">
					<script type="text/javascript">
						var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
						myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "javascript:deleteArticle('${detailURL}?method=deleteFavoritesArticle')", "<c:url value='/common/images/toolbar/delete.gif'/>", "", null));    	
						document.write(myBar);
	                    document.close(); 
					</script>
				</td>
			</tr>
		</table>	
    </div>
    <div class="center_div_row2" id="scrollListDiv">
		<form name="listForm" method="post" action="" >
			<input type="hidden" name="familyId" id="familyId" value="${FamilyModel.id}"> 
			<input type="hidden" name="resourceMethod" value="listFamilyArticle"> 
				<v3x:table	htmlId="pending" data="${articleModellist}" var="col">
                
					<v3x:column width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
						<input type='checkbox' id="id" name='id' value="${col.favoritesId}" affairId="${col.favoritesId}" />
					</v3x:column>
		
					<v3x:column width="50%" type="String" label="common.subject.label">
						<a
							href="${detailURL}?method=showPost&articleId=${col.id}&&resourceMethod=listAllFavoritesArticle&&familyId=${col.familyId}&&fromFlag=share&v=${col.vForList}"
							class="hyper_link1" title="${v3x:toHTML(col.subject)}">
							${v3x:toHTML(col.subject)}	
							  </a>
					    <c:if test="${col.attachmentFlag==1}">
							<span style="height:26px;line-height:26px;"><img src="<c:url value='/apps_res/blog/images/acc.gif'/>" align="absmiddle"></span>
						</c:if>
					</v3x:column>
					  
				    <v3x:column width="15%" type="Number" align="center"
						label="blog.familymanager.column.categary.label" value="${col.familyName}" />   

		         	<v3x:column width="7%" type="Number" align="center"
						label="blog.familymanager.column.issueuser.label" value="${col.userName}" />
						
					<v3x:column width="7%" type="Number" align="center"
						label="blog.clicknumber.label" value="${col.clickNumber}" />
		
					<v3x:column width="7%" type="Number" align="center"
						label="blog.replynumber.label" value="${col.replyNumber}" />
		
					<v3x:column width="125" type="Date" align="left"
						label="common.issueDate.label">
						<fmt:formatDate value="${col.issueTime}" pattern="${dataPattern}" />
					</v3x:column>
				</v3x:table>
			</form>
    </div>
  </div>
</div>
</body>
</html>
