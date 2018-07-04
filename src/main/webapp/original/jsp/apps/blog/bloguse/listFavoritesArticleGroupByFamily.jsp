<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<title></title>
<%@ include file="../header.jsp"%>
<script type="text/javascript">
</script>

<script>
	showAttachment('<c:out value="${article.id}" />', 0, '', '');
	
	function moreOneFavoritesArt(id){
	  if(id){
	    var form = document.getElementById("postForm") ;
	    if(form) {
	      form.action = genericURL + "?method=queryOneListFvoritesAct&id="+id ;
	      form.submit() ;
	    }
	  }
	}
	
</script>
<style type="text/css">
.mxt-grid-header{
    padding-bottom: 0px;
}
.border_t{
    border-top: 1px solid #b6b6b6;
}
.border_b{
    border-bottom: 1px solid #b6b6b6;
}
.border_l{
    border-left: 1px solid #b6b6b6;
}
.border_r{
    border-right: 1px solid #b6b6b6;
}
.bg_color {
  background: #EDEDED;
}
</style>

</head>

<body scroll="yes" class="bg_color">

<form name="postForm"  id="postForm" method="post"  style="margin: 0px">

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" >
<tr>
	<td height="45">
		<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
			<tr>
				<td>
					<table width="100%" border="0" cellpadding="0" cellspacing="0" class="page2-header-line">
						  <tr>
							<td class="page2-header-bg" valign="middle" height="30">&nbsp;<fmt:message key="blog.article.view.byfamily" /><fmt:message key="blog.family.favorites"/></td>
							<td valign="middle">
								<div class="blog-div-float-right">
								<!-- 返回 -->
								<a href="${detailURL}?method=listAllFavoritesArticle" class="hyper_link2">
										[<fmt:message key="common.toolbar.back.label" bundle="${v3xCommonI18N}" />]
								</a>&nbsp;&nbsp;
								</div>
							</td>
						  </tr>
					</table>
				</td>
			</tr>
		</table>
	</td>
</tr>
								
<tr >
<td valign="top">
	<table  border="0" cellspacing="0" cellpadding="0" align="center" valign="top" width="100%" height="100%" valign="top">
	<tr>
	<td width="100%" id="signOpinion" valign="top">
<!-- 按收藏分类循环 -->
	<c:set value='1' var='i' />
	<c:forEach items="${favoritesFamily}" var="family">
		<%-- 文章 --%>
           <table align="center" width="97%" cellpadding="0" cellspacing="0" class="page-list-border">	                
				<tr>
				   <td height="22" class="webfx-menu-bar page2-list-header">
						<b>${family.nameFamily}</b> 
			       </td>
				</tr>
				
				   <td valign="top" class="border_t border_l border_r">	
				
			    
					<c:set var="tem" value="familyArticle${i}"/>
			
					<v3x:table htmlId="pending"
					data="${tem}" var="col" showPager="false"
					isChangeTRColor="true" showHeader="true" dragable="false">	
						<v3x:column width="48%" type="String" label="common.subject.label"
							>
							<a
								href="${detailURL}?method=showPost&articleId=${col.id}&&resourceMethod=listFavoritesArticleGroupByFamily&&familyId=${col.familyId}&v=${col.vForList}"
								class="hyper_link1" title="${col.subject}">
								${col.subject}	
							</a>
							<c:if test="${col.attachmentFlag==1}">
								<span style="height:26px;line-height:26px;"><img src="<c:url value='/apps_res/blog/images/acc.gif'/>" align="absmiddle"></span>
							</c:if>
						</v3x:column>
			
						<v3x:column width="7%" type="Number" align="center"
							label="blog.clicknumber.label" value="${col.clickNumber}" />
			
						<v3x:column width="7%" type="Number" align="center"
							label="blog.replynumber.label" value="${col.replyNumber}" />
			
						<v3x:column width="18%" type="Date" align="left"
							label="common.issueDate.label">
							<fmt:formatDate value="${col.issueTime}" pattern="${dataPattern}" />
						</v3x:column>
					</v3x:table>
					</td>
			</table>
		<table width="98%"><tr><td align="right" width="100%">
		<a href="javascript:moreOneFavoritesArt('${family.id }')" class="link-blue"><fmt:message key="common.more.label" bundle="${v3xCommonI18N}" /> >>&nbsp;&nbsp; </a></td></tr></table>
		<table><tr><td>&nbsp;</td></tr></table>

		<c:set value='${i+1}' var='i' />
	</c:forEach>
	</td>
	</tr>
	</table>
</td></tr>
</table>
</form>
</body>
</html>
