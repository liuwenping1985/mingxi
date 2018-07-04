<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%@ include file="../header.jsp"%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript">
	/**
	 function openShow(colId,familyId){
	 var _url = genericURL +"?method=showPost&articleId="+id+"&&resourceMethod=listFavoritesArticleGroupByFamily&&familyId="+familyId ;
	 var returnValue =  v3x.openWindow({
	 url : _url ,
	 width : "380",
	 height : "200",
	 resizable : "true",
	 scrollbars : "true"   
	 });
	 window.location.href = window.location.href;
	
	 }
	 **/
</script>
<style type="text/css">
.bg_color {
  background: #EDEDED;
}
</style>
</head>
<body class="" scroll="no">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
		<table border="0" cellpadding="0" cellspacing="0" width="100%"
			height="100%" align="center">
			<tr>
				<td class="page2-header-bg bg_color" align="left">${name}</td>
				<td class="page2-header-line" height="30"><div
						class="blog-div-float-right">
						<!-- 返回 -->
						<a href="${detailURL}?method=listFavoritesArticleGroupByFamily"
							class="hyper_link2"> [<fmt:message
								key="common.toolbar.back.label" bundle="${v3xCommonI18N}" />]
						</a>&nbsp;&nbsp;
					</div></td>
			</tr>
		</table>
	</div>
    <div class="center_div_row2" id="scrollListDiv">
	<form name="postForm" id="postForm" method="post" style="margin: 0px">
		<v3x:table htmlId="pending" data="${articleModelList}" var="col" subHeight="-30"
			showPager="false" isChangeTRColor="true" showHeader="true">
			<v3x:column width="48%" type="String"
				label="common.subject.label">
				<a
					href="${detailURL}?method=showPost&articleId=${col.id}&&resourceMethod=listFavoritesArticleGroupByFamily&&familyId=${col.familyId}&v=${col.vForList}"
					class="hyper_link1" title="${col.subject}"> ${col.subject}
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
				<fmt:formatDate value="${col.issueTime}"
					pattern="${dataPattern}" />
			</v3x:column>
		</v3x:table>
	</form>
    </div>
  </div>
</div>
</body>
</html>