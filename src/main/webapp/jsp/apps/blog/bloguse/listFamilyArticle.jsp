<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>
<title></title>

</head>

<body class="tab-body">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td  height="86" background ="<c:url value='/apps_res/blog/images/back.gif'/>" class="tex_2">
		</td>
	</tr>
	<tr>
	<form action="" name="familyForm" id="familyForm" method="post"
			style="margin: 0px">		
			<input type="hidden" name="familyId" value="${FamilyModel.id}"> 
			<input type="hidden" name="familyName" id="familyName" value="${FamilyModel.nameFamily}"> 						 
			<td valign="bottom" height="26" class="tab-tag">
		<div class="blog-div-float-left">${FamilyModel.nameFamily}</div>		
				<div class="blog-div-float-right">
					<a href="" onclick="javascript:refreshIt()"
						class="hyper_link2"> [<fmt:message key="common.toolbar.refresh.label" bundle="${v3xCommonI18N}" />]</a>&nbsp; 
<!--  					<a href="${detailURL}?method=listLatestFiveArticleAndAllFamily"
						class="hyper_link2"> [<fmt:message key="common.toolbar.back.label" bundle="${v3xCommonI18N}" />]</a>
 -->			 	</div>
			</td>
	</form>
			<td valign="bottom" width="3" rowspan="2"><div class="tab-tag-1"></div></td>
	</tr>
	
	<tr>
		<td height="26" class="bbs-title-bar" width="100%">
			<div class="div-float-right">
				<script type="text/javascript">
					var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
					myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "javascript:deleteArticle(deleteActionURL)", "<c:url value='/common/images/toolbar/delete.gif'/>", "", null));    	
					document.write(myBar);
					document.close();
				</script>
			</div>
		</td>
	</tr>
	
	<tr>
		<td class="tab-body" colspan="2">
			<table width="100%" height="100%" border="0" cellspacing="0"
								cellpadding="0">				
					<tr>
						<td>
							<div class="scrollList">
							<form name="listForm" method="get" action="" onsubmit="">
							<input type="hidden" name="familyId" value="${FamilyModel.id}"> 
							<input type="hidden" name="resourceMethod" value="listFamilyArticle"> 
								<v3x:table
									htmlId="pending" data="${familyArticle}" var="col">
									<v3x:column width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
										<input type='checkbox' name='id' value="${col.id}" affairId="${col.id}" />
									</v3x:column>
						
									<v3x:column width="48%" type="String" label="common.subject.label"
										>
										<c:if test="${col.attachmentFlag==1}">
											<span style="height:26px;line-height:26px;"><img src="<c:url value='/apps_res/blog/images/acc.gif'/>" align="absmiddle"></span>
										</c:if>
										<a
											href="${detailURL}?method=showPost&articleId=${col.id}&&resourceMethod=listFamilyArticle&&familyId=${col.familyId}&v=${col.vForList}"
											class="hyper_link1" title="${col.subject}">
											${v3x:getLimitLengthString(col.subject,45,"...")}	
											  </a>
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
								</form>
							</div>
						</td>
					</tr>
			</table>
		</td>
	</tr>
</table>
</body>
</html>
