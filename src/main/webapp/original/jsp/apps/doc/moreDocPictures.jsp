<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:message key="common.datetime.pattern" var="datetimePattern" bundle="${v3xCommonI18N}"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N"/>
<fmt:setBundle basename="com.seeyon.apps.doc.resources.i18n.DocResource"/>
<fmt:setBundle basename="com.seeyon.v3x.edoc.resources.i18n.EdocResource" var="v3xEdocI18N"/>
<html:link renderURL="/doc.do" var="detailURL" />
<html:link renderURL="/doc.do" psml="default-page.psml" forcePortal="true" var="detailPortalURL" />
<html:link renderURL="/collaboration/collaboration.do" var="colDetailURL" />
<html:link renderURL="/mtMeeting.do" var="mtMeetingURL" />
<html:link renderURL="/newsData.do" var="newsURL" />
<html:link renderURL="/bulData.do" var="bulURL" />
<html:link renderURL="/bbs.do" var="bbsURL" />
<html:link renderURL="/plan.do" var="planURL" />
<html:link renderURL="/webmail.do" var="mailURL" />
<html:link renderURL="/edocController.do" var="edocURL" />
<html:link renderURL="/inquirybasic.do" var="inquiryURL" />
<html:link renderURL="/docManager.do" var="managerURL" />
<html:link renderURL="/doc.do?method=xmlJsp" var="srcJURL" />
<html:link renderURL="/doc.do?method=listDocs" var="actionJURL" />
<html:link renderURL="/rssManager.do" var="rssURL" />
<html:link renderURL="/docSpace.do" var="spaceURL" />
<html:link renderURL="/infoDetailController.do" var="infoURL" />
<html:link renderURL="/infoStatController.do" var="infoStatURL" />

<c:url value="/apps_res/doc/images/docIcon/" var="imgURL"/>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/doc/css/doc.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/doc/css/property.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/office/js/office.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
<fmt:message key="common.date.pattern" var="datePattern" bundle="${v3xCommonI18N}"/>
<fmt:message key="common.datetime.pattern" var="dateTimePattern" bundle="${v3xCommonI18N}"/>

<script type="text/javascript">
var docjsshowlabel = "<fmt:message key='doc.menu.show.label'/>";
var docjshiddenlabel = "<fmt:message key='doc.menu.hidden.label'/>";
var dtb = "<%=com.seeyon.ctp.util.Datetimes.formatDatetime(new java.util.Date())%>";
var dte = "<%=com.seeyon.ctp.util.Datetimes.formatDatetime(com.seeyon.ctp.util.Datetimes.addDate(new java.util.Date(),180))%>";
var contpath = "${pageContext.request.contextPath}";

var v3x = new V3X();

v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
var treeImgURL = "${imgURL}";
var jsURL = "${detailURL}";
var docURL = jsURL;
var jsColURL = "${colDetailURL}";
var jsMeetingURL = "${mtMeetingURL}";
var jsPlanURL = "${planURL}";
var jsMailURL = "${mailURL}";
var jsNewsURL = "${newsURL}";
var jsBulURL = "${bulURL}";
var jsBbsURL = "${bbsURL}";
var jsEdocURL = "${edocURL}";
var jsInquiryURL = "${inquiryURL}";
var managerURL="${managerURL}";
var spaceURL="${spaceURL}";
var infoURL="${infoURL}";
var infoStatURL="${infoStatURL}";
var baseurl = v3x.baseURL;
var srcURL = baseurl + "/doc.do?method=xmlJsp";
var actionURL = jsURL + "?method=listDocs";
_ = v3x.getMessage;
v3x.loadLanguage("/apps_res/doc/i18n");
v3x.loadLanguage("/common/pdf/js/i18n");
v3x.loadLanguage("/apps_res/v3xmain/js/i18n");
<%-- ææ¡£åºç¨éç¶æå¸¸éå®ä¹ --%>
var LockStatus_AppLock = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.AppLock.key()%>";
var LockStatus_ActionLock = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.ActionLock.key()%>";
var LockStatus_DocInvalid = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.DocInvalid.key()%>";
var LockStatus_None = "<%=com.seeyon.apps.doc.util.Constants.LockStatus.None.key()%>";
var LOCK_MSG_NONE = "<%=com.seeyon.apps.doc.util.Constants.LOCK_MSG_NONE%>";
</script>

<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/xtree.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/xmlextras.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/xloadtree.js${v3x:resSuffix()}" />"></script>
<link type="text/css" rel="stylesheet" href="<c:url value='/apps_res/doc/css/xtree.css${v3x:resSuffix()}' />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/commonFuncs.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/doc.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/controllerFuncs.js${v3x:resSuffix()}" />"></script>

<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/property.js${v3x:resSuffix()}" />"></script>


<%@ include file="../../common/INC/noCache.jsp"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/knowledgeBrowseUtils.js" />"></script>
<script type="text/javascript">
<!--
// getA8Top().hiddenNavigationFrameset();
function changeImage(obj){

	var image = new Image();
	image.src = obj.src;
	var oldwidth = image.width;
	var oldheight=image.height;
	var maxHeight = 140;
	var maxWidth = 140;
	var resultX = 0;resultY = 0;
	var oWH = oldwidth/oldheight;
	var destWH = maxWidth/maxHeight;
	if(oWH >= destWH){
		if(oldwidth > maxWidth){// 宽幅图片
			resultX = maxWidth;
			resultY = parseInt(maxWidth/oWH);
		} else {
			resultX = oldwidth;
			resultY = oldheight;
		}
	} else {
	  	if(oldheight > maxHeight){
			resultX = parseInt(oWH * maxHeight);
			resultY = maxHeight;
	    } else {
	    	resultX = oldwidth;
		   	resultY = oldheight;
	    }
	}
	obj.width = resultX;
	obj.height = resultY;
}
//-->
</script>
</head>
<body scroll="no" class="w100b h100b absolute">
<table border="0" cellpadding="0" cellspacing="0" width="100%"
	height="100%" align="center">
	<tr>
		<td width="100%" height="41" valign="top" class="page-list-border-LRD">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr class="page2-header-line">
				<td width="45" height="41">
				<div class="template"></div>
				</td>
				<td class="page2-header-bg"><fmt:message key="doc.picture.label"/></td>
				<td class="page2-header-line page2-header-link" align="right">
				<a class='defaulta' href="${detailURL}?method=docHomepageIndex&docResId=${folderId }"><fmt:message key="doc.list.label"/></a>&nbsp;&nbsp;
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td valign="top" class="padding5 page-list-border-LRD">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
   			<tr>
      			<td valign="bottom" height="26" colspan="2" class="tab-tag">
					 <c:forEach var="panel" items="${allPanels}">
						<c:set var="sel" value="${folderId == panel.id?'-sel':''}"></c:set>
						<div class="tab-tag-left${sel} "></div>
						<div class="tab-tag-middel${sel} cursor-hand" title="${panel.name}" onclick="javascript:location.href='${detailURL}?method=moreDocPictures&fragmentId=${param.fragmentId }&ordinal=${param.ordinal }&folderId=${panel.id }'">
							${v3x:getLimitLengthString(panel.name, 30, "...") }
						</div>
						<div class="tab-tag-right${sel}"></div>
					</c:forEach>
				 </td>
			</tr>
		
			<tr>
			<td valign="top" class="padding5">
			<table width="100%" height="86%" border="0" cellspacing="0"
				cellpadding="0" class="page2-list-border">
		          <form action="" id="theForm" name="theForm" method="get" >
				<tr>
					<td style="padding: 8px,8px,8px,8px;">
					<div class="scrollList" id="divScrollListId">
						<table border="0" width="100%" height="100%" cellpadding="0" cellspacing="0">
							<tr>
							<c:forEach items="${docResources}" var="docResource" varStatus="ordinal">
								<c:set value="javascript:fnOpenKnowledge('${docResource.id}')" var="url" />
								<td width="20%" align="center" valign="top" style="padding-top:6px;">
								<div>
								<fmt:formatDate pattern="yyyy-MM-dd" value="${docResource.createTime }" var="createDate"/>
								<c:if test="${docResource.hasAcl==true}">
								<a href="${url}">
									<img style="BORDER:1px SOLID #d6d6d6" src="/seeyon/fileUpload.do?method=showRTE&fileId=${docResource.sourceId}&createDate=${createDate}&type=image&showType=small" width="140px" height="140px" onload="changeImage(this)">
								</a>
								</c:if>
								<c:if test="${docResource.hasAcl!=true}">
									<a href="${url}">
									<img style="BORDER:1px SOLID #d6d6d6" src="/seeyon/apps_res/v3xmain/images/defaultNo.jpg" width="140px" height="140px" onload="changeImage(this)">			
									</a>
								</c:if>
								</div>
								<div>
									<a href="${url}" title="${docResource.frName }">${v3x:getSafeLimitLengthString(docResource.frName, 20, "...")}</a>
								</div>
								</td>
								${(ordinal.index + 1) % 5 == 0 && !ordinal.last ? "</tr><tr>" : ""}
								<c:set value="${(ordinal.index + 1) % 5}" var="i" />
							</c:forEach>
							<c:if test="${i !=0}">
								<c:forTokens items="1,1,1,1,1" delims="," end="${5 - i - 1}">
									<td width="20%">&nbsp;</td>
								</c:forTokens>
							</c:if>
							</tr>
						</table>
					</div>
          </td>
          </tr>
          <tr>
          <td style="padding: 8px,8px,8px,8px;">
					<table  width="100%" height="100%" border="0" cellspacing="0"
				cellpadding="0" class="page2-list-border">
							<c:if test="${not empty docResources}">
							<tr>
							<td colspan="8" id="pagerTd" class="table_footer" noWrap>
							<script type="text/javascript">
							<!--
							var pageFormMethod = "get"
							var pageQueryMap = new Properties();
							pageQueryMap.put('method', "moreDocPictures");
							pageQueryMap.put('folderId', "${param.folderId}");
							pageQueryMap.put('fragmentId', "${param.fragmentId}");
							pageQueryMap.put('ordinal', "${param.ordinal}");
							pageQueryMap.put('type', "personal");
							pageQueryMap.put('_spage', '');
							pageQueryMap.put('page', '${page}');
							pageQueryMap.put('count', "${size}");
							pageQueryMap.put('pageSize', "${pageSize}");
							//-->
							</script>
							<fmt:message key='taglib.list.table.page.html' bundle="${v3xCommonI18N}">
								<fmt:param ><input type="text" maxlength="3" class="pager-input-25" value="${pageSize }" name="pageSize" onChange="pagesizeChange(this)" onkeypress="enterSubmit(this, '${pageSize}')"></fmt:param>
								<fmt:param>${pages}</fmt:param>
								<fmt:param>${size}</fmt:param>
								<fmt:param>
									<c:choose>
									<c:when test="${page == 1 && size > pageSize}">
										<span class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.first.label' bundle="${v3xCommonI18N}" />"><em class="pageFirst"></em></span>
										<span class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.prev.label' bundle="${v3xCommonI18N}"/>"><em class="pagePrev"></em></span>
										<span class="common_over_page_btn" onclick="next(this)" title="<fmt:message key='taglib.list.table.page.next.label' bundle="${v3xCommonI18N}" />"><em class="pageNext"></em></span>
										<span class="common_over_page_btn" onclick="last(this,'${pages}')" title="<fmt:message key='taglib.list.table.page.last.label' bundle="${v3xCommonI18N}" />"><em class="pageLast"></em></span>
									</c:when>
									<c:when test="${page == pages && size > pageSize}">
										<span class="common_over_page_btn" onclick="first(this)" title="<fmt:message key='taglib.list.table.page.first.label' bundle="${v3xCommonI18N}" />"><em class="pageFirst"></em></span>
										<span class="common_over_page_btn" onclick="prev(this)" title="<fmt:message key='taglib.list.table.page.prev.label' bundle="${v3xCommonI18N}"/>"><em class="pagePrev"></em></span>
										<span class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.next.label' bundle="${v3xCommonI18N}" />"><em class="pageNext"></em></span>
										<span class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.last.label' bundle="${v3xCommonI18N}" />"><em class="pageLast"></em></span>
									</c:when>
									<c:when test="${page != pages && page != 1 && size > pageSize}">
										<span class="common_over_page_btn" onclick="first(this)" title="<fmt:message key='taglib.list.table.page.first.label' bundle="${v3xCommonI18N}" />"><em class="pageFirst"></em></span>
										<span class="common_over_page_btn" onclick="prev(this)" title="<fmt:message key='taglib.list.table.page.prev.label' bundle="${v3xCommonI18N}"/>"><em class="pagePrev"></em></span>
										<span class="common_over_page_btn" onclick="next(this)" title="<fmt:message key='taglib.list.table.page.next.label' bundle="${v3xCommonI18N}" />"><em class="pageNext"></em></span>
										<span class="common_over_page_btn" onclick="last(this,'${pages}')" title="<fmt:message key='taglib.list.table.page.last.label' bundle="${v3xCommonI18N}" />"><em class="pageLast"></em></span>
									</c:when>
									<c:otherwise>
										<span class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.first.label' bundle="${v3xCommonI18N}" />"><em class="pageFirst"></em></span>
										<span class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.prev.label' bundle="${v3xCommonI18N}"/>"><em class="pagePrev"></em></span>
										<span class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.next.label' bundle="${v3xCommonI18N}" />"><em class="pageNext"></em></span>
										<span class="common_over_page_btn" title="<fmt:message key='taglib.list.table.page.last.label' bundle="${v3xCommonI18N}" />"><em class="pageLast"></em></span>
									</c:otherwise>
									</c:choose>
								</fmt:param>
								<fmt:param>
									<input type="text" maxlength="10" class="pager-input-25" value="${page}" onChange="pageChange(this)" pageCount="${size}" onkeypress="enterSubmit(this, 'intpage')">
								</fmt:param>
							</fmt:message>
							 <input type="button" value="go" class="go" onclick="pageGo(this)">
							</td>
							</tr>
							</c:if>
					</table>
					</td>
				</tr>
            </form>
			</table>
			</td>
			</tr>
		</table>
	</td>
</tr>
</table>
</body>
</html>
<script type="text/javascript">
    bindOnresize('divScrollListId',0,108);
</script>