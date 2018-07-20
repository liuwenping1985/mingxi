<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp"%>
<html>
<head>
<script type="text/javascript">
<!--
resetCtpLocation();

//保存图片ID和日期的对应关系
var properties = new Properties();
<c:forEach items="${filesMap}" var="item">
   properties.put("${item.key}","${item.value}");
</c:forEach>

function onLoadImage(img, maxWidth, maxHeight){
	var image = new Image();
	image.src = img.src;
	var height = 0;
	var width = 0;
		
	var oHeight = image.height;
	var oWidth = image.width;
	var destWH = maxWidth/maxHeight;
	var oWH = oWidth/oHeight;
		
	if(oWH == destWH){
		width = maxWidth;
		height = maxHeight;
	} else if(oWH > destWH){ // 宽幅图片
		width = maxWidth;
		height = maxWidth/oWH;
	} else if(oWH < destWH){
		width = oWH * maxHeight;
		height = maxHeight;
	}
		
	img.width = width;
	img.height = height;
}
//-->

//根据回复总数和新的每页条数计算获取新的总页数
function getTotalPages(totalCount, newPageSize) {
	var totalRecords = parseInt(totalCount);
	var newTotalPages = 1; 
	if((totalRecords%newPageSize)==0 && totalRecords>0) {
		newTotalPages = totalRecords/newPageSize;
	} else {
		newTotalPages = parseInt(totalRecords/newPageSize + 1);
	}
	return newTotalPages;
}

function next(obj){
	var page = parseInt(pageQueryMap.get("page"));
	var pageSize = parseInt(pageQueryMap.get("pageSize"));
	var count = parseInt(pageQueryMap.get("count"));
	var totalPages = getTotalPages(count, pageSize);
	if(totalPages < page + 1){
	    pageQueryMap.put("page", page);
	}else{
	    pageQueryMap.put("page", page+1);
	}
	
	getPageAction(obj);
};
</script>
</head>
<body scroll="auto">
<table border="0" cellpadding="0" cellspacing="0" width="100%"
	height="100%" align="center">
	<tr class="page2-header-line">
		<td width="100%" height="41" valign="top" class="page-list-border-LRD">
		<table width="100%" height="100%" border="0" cellpadding="0"
			cellspacing="0">
			<tr class="page2-header-line">
				<td width="45" class="page2-header-img">
				<div class="newsIndex"></div>
				</td>
				<td class="page2-header-bg"><fmt:message key="news.title" /></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td valign="top" class="padding5">
		<table id="newsMoreTable" align="center" width="100%" height="100%"
			cellpadding="0" cellspacing="0" class="page2-list-border">
			<tr>
				<td height="22" class="webfx-menu-bar page2-list-header " style="border-top: 1px solid #b6b6b6;border-bottom: 1px solid #b6b6b6;"><b>
				<c:choose>
					<c:when test="${imageOrFocus == 0}">
						<c:choose>
							<c:when test="${param.spaceType != 0 && param.spaceType != 1}">
								<fmt:message key="news.image_news" />
							</c:when>
							<c:otherwise>
								<c:set value="${param.spaceType == 0 && v3x:getSysFlagByName('sys_isGovVer') ? '.GOV' : ''}" var="govLabel" />
								<fmt:message key="space.${param.spaceType}.name${govLabel}" bundle="${v3xCommonI18N}" /><fmt:message key="news.image_news" />
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:otherwise>
						<c:choose>
							<c:when test="${param.spaceType != 0 && param.spaceType != 1}">
								<fmt:message key="news.focus_news" />
							</c:when>
							<c:otherwise>
								<c:set value="${param.spaceType == 0 && v3x:getSysFlagByName('sys_isGovVer') ? '.GOV' : ''}" var="govLabel" />
								<fmt:message key="space.${param.spaceType}.name${govLabel}" bundle="${v3xCommonI18N}" /><fmt:message key="news.focus_news" />
							</c:otherwise>
						</c:choose>
					</c:otherwise>
				</c:choose>
				</b></td>
				<td class="webfx-menu-bar"></td>
			</tr>
			<tr>
				<td colspan="2">
				<div class="scrollList">
				<form name="newsMoreForm" id="newsMoreForm" method="post" action="">

				<table border="0" width="100%" height="100%" cellpadding="0"
					cellspacing="0">
					<c:forEach items="${newsDataList}" var="news">
						<c:set value="openWin('${newsDataURL}?method=userView&spaceId=${param.spaceId}&id=${news.id}&auditFlag=0')" var="clickEvent"/>
						<tr>
							<td valign="top" height="100px"style="padding:10px;border-bottom: 1px #ccc dotted;">
								<table border="0" width="100%" height="100%" cellpadding="0" cellspacing="0">
								<c:if test="${news.imageId != null && news.imageId != ''}">
									<tr>
									<td width="140px" style="BORDER:1px SOLID #d6d6d6;" align="center">
										<c:forEach items="${filesMap}" var="item">
											<c:if test="${item.key eq news.imageId}">
												<c:set value="${item.value}" var="createDate" />
											</c:if>
										</c:forEach>
										<a href="javascript:${clickEvent }">
										<img style="padding:0px; border:0px solid #cccccc;" src="${pageContext.request.contextPath}/fileUpload.do?method=showRTE&fileId=${news.imageId }&createDate=${createDate}&type=image&showType=small" width="140px" height="100px" onload="onLoadImage(this,140,100);">
										</a>
									</td>
									<td style="padding-left:12px;">
									<table border="0" width="100%" height="100%" cellpadding="0" cellspacing="0">
								</c:if>
								<tr>
								<td valign="top" style="font-size: 16px;" height="25px" align="left" width="100%">
								<a href="javascript:${clickEvent}" style="TEXT-DECORATION:underline">${v3x:toHTML(news.title)}</a>
								</td>
								<td style="padding:0 6px;" nowrap="nowrap">
									<fmt:formatDate pattern="yyyy-MM-dd" value="${news.publishDate }" />
								</td>
								<td align="right" style="padding:0 6px;" nowrap="nowrap">
								<c:choose>
									<c:when test="${news.type.spaceType == 0}">
										<c:set value="${newsDataURL }?method=newsMore&orgType=group&spaceType=0&typeId=${news.type.id}" var="typeLink"/>
									</c:when>
									<c:when test="${news.type.spaceType == 1}">
										<c:set value="${newsDataURL }?method=newsMore&orgType=account&spaceType=1&typeId=${news.type.id}" var="typeLink"/>
									</c:when>
									<c:otherwise>
										<c:set value="${newsDataURL }?method=newsMore&spaceType=${param.spaceType}&typeId=${news.type.id}" var="typeLink"/>
									</c:otherwise>
								</c:choose>
								<a href="${typeLink}">
									${v3x:toHTML(news.type.typeName)}
								</a>
								</td>
								</tr>
								<tr>
									<td valign="top" colspan="3">
										<c:choose>
											<c:when test="${not empty news.brief}">${v3x:toHTML(news.brief)}</c:when>
											<c:otherwise>
												<c:choose>
													<c:when test='${news.dataFormat == "OfficeWord" || news.dataFormat == "OfficeExcel" || news.dataFormat == "WpsWord" || news.dataFormat == "WpsExcel"}'> </c:when>
													<c:otherwise>${v3x:getLimitLengthString(v3x:toHTML(news.content), 200, "...")}</c:otherwise>
												</c:choose>
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
								<c:if test="${news.imageId != null && news.imageId != ''}">
									</td>
									</tr>
									</table>
								</c:if>
								</table>
							</td>
						</tr>
					</c:forEach>
					<tr>
						<td align="right" valign="top">
						<script type="text/javascript">
						<!--
						var pageFormMethod = "get";
						var pageQueryMap = new Properties();
						pageQueryMap.put('method', "imageNewsMore");
						pageQueryMap.put('imageOrFocus', "${param.imageOrFocus}");
						pageQueryMap.put('spaceType', "${param.spaceType}");
						pageQueryMap.put('spaceId', "${param.spaceId}");
						pageQueryMap.put('fragmentId', "${param.fragmentId}");
						pageQueryMap.put('ordinal', "${param.ordinal}");
						pageQueryMap.put('panelValue', "${param.panelValue}");
						pageQueryMap.put('type', "personal");
						pageQueryMap.put('_spage', '');
						pageQueryMap.put('page', '${page}');
						pageQueryMap.put('count', "${size}");
						pageQueryMap.put('pageSize', "${pageSize}");
						//-->
						</script>
						 <DIV class="common_over_page align_right">
						<fmt:message key='taglib.list.table.page.html' bundle="${v3xCommonI18N}">
							<fmt:param ><input type="text" maxlength="3" class="pager-input-25-undrag" value="${pageSize }" name="pageSize" onChange="pagesizeChange(this)" onkeypress="enterSubmit(this, '${pageSize}')"></fmt:param>
							<fmt:param>${pages}</fmt:param>
							<fmt:param>${size}</fmt:param>
							<fmt:param>
							 <a href="javascript:first(this)" class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.first.label' bundle="${v3xCommonI18N}" />"><EM class=pageFirst></EM></a>
                             <a href="javascript:prev(this)" class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.prev.label' bundle="${v3xCommonI18N}" />"><EM class=pagePrev></EM></a>
                             <a href="javascript:next(this)" class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.next.label' bundle="${v3xCommonI18N}" />"><EM class=pageNext></EM></a>
                             <a href="javascript:last(this, '${pages }')" class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.last.label' bundle="${v3xCommonI18N}" />"><EM class=pageLast></EM></a>
                             </fmt:param>
							<fmt:param>
								<input type="text" maxlength="10" class="pager-input-25-undrag" value="${page}" onChange="pageChange(this)" pageCount="${size}" onkeypress="enterSubmit(this, 'intpage')">
							</fmt:param>
						</fmt:message>
						<A id=grid_go class=common_over_page_btn href="javascript:pageGo(this);">go</A>&nbsp;&nbsp;&nbsp;&nbsp;
						
						 </DIV>
						</td>
					</tr>
				</table>

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