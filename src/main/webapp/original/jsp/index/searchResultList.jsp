﻿﻿﻿﻿﻿<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" errorPage=""%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N" />
<fmt:setBundle basename="com.seeyon.apps.index.resource.i18n.IndexResources" />
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N" />
<fmt:message key="common.datetime.pattern" var="datePattern" bundle="${v3xCommonI18N}" />
<fmt:setBundle basename="com.seeyon.v3x.isearch.resources.i18n.ISearchResources" var="isearchI18N" />
<html style="overflow:hidden;height:100%;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Search Result Page</title>
<link href="<c:url value="/apps_res/index/css/searchresult.css${v3x:resSuffix()}" />" rel="stylesheet" type="text/css">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/isearch/css/isearch.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/index/js/searchresult.js${v3x:resSuffix()}" />"></script>
<c:if test="${CurrentUser.skin != null}">
<link rel="stylesheet" href="<c:url value="/skin/${CurrentUser.skin}/skin.css" />">
</c:if>
<c:if test="${CurrentUser.skin == null}">
<link rel="stylesheet" href="<c:url value="/skin/default/skin.css" />">
</c:if>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css" />">
<script Language="JavaScript">
<c:if test="${not empty hasError}">
/* alert('<fmt:message key="${hasError}"/>'); */
</c:if>

var v3x = new V3X();
v3x.init("<c:out value='${pageContext.request.contextPath}' />", "<%=com.seeyon.ctp.common.i18n.LocaleContext
					.getLanguage(request)%>");
_ = v3x.getMessage;

 var keyword="${v3x:escapeJavascript(keyword)}";
 var accessoryName="${v3x:escapeJavascript(accessoryName)}";
 var currentPage="${currentPage}";
 var prePage="${prePage}";
 var nextPage="${nextPage}";
 var totalPage="${totalPage}";
 var totalCount="${totalCount}";
 parent.document.getElementById("searchBtn").disabled=false;
</script>
${v3x:skin()}
<style type="text/css">
.sectionBody {
    background-color: rgb(255, 255, 255);
    padding:0px;
}
.a_sort_sty{
	color:#318ed9;
}
.a_sort_sty:hover{
	color:#318ed9;
}
.importance_1{
	overflow: hidden;
    text-overflow: ellipsis;
    word-break: keep-all;
    white-space: nowrap;
	width:180px;
}
.source_color{
	margin-left:0px;
	color:#a3a3a3;
}
a{
	color:#318ed9;
}
.title_color {
    position: relative;
}
.content_area_body td.text-overflow {
    white-space: normal;
}
</style>
</head>
<body scroll="no" class="padding0 h100b" onkeydown="doKeyPressedEvent()" onload="resizePage();">

    <form action="<html:link renderURL='/index/indexController.do?method=searchAll'/>" method="post" id="form1" target="_self" class="h100b" style="top:-18px;">
        <input name="iframeSearch" value="iframeSearch" type="hidden" /> 
        <input type="hidden"  id="author" name="author" value="${v3x:toHTML(author)}" /> 
        <input type="hidden"  id="title" name="title" value="${v3x:toHTML(title)}" /> 
        <input type="hidden"  id="SEARCHDATE_BEGIN" name="SEARCHDATE_BEGIN" value="${SEARCHDATE_BEGIN}" /> 
        <input type="hidden"  id="SEARCHDATE_END" name="SEARCHDATE_END" value="${SEARCHDATE_END}" />
        <input type="hidden"  id="viewType" name="viewType" value="${viewType}" />
		<div id="scrollBody" class="content_area_body" style="height: 100%;overflow: auto; position:relative;">
        <table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0" class="" id="mainDivId" >
            <c:if test="${isAfterSearch}">
                <tr>
                    <td height="20" style="padding: 0 5px" valign="top">
                        <div class="gov_border gov_nobackground" style="padding: 5px 5px 10px 5px" id="resultBarId">
                            <table border="0" cellSpacing="0" cellPadding="0" width="100%">
                                <tr style='height:30px;line-height:30px;'>

                                	<!--头部-->
                                    <td class="" style='color:#999'>
                                    	<span style='padding-right:16px;color:#999'>
                                    		<span><fmt:message key='index.com.seeyon.v3x.index.searchKey' />: </span><span><fmt:message key='index.com.seeyon.v3x.index.all' /></span><span style='color:#ef6b43'>${totalCount}</span><span><fmt:message key='index.com.seeyon.v3x.index.items' /></span>
                                    	</span>
                                    	<c:if test="${hasResult}">
	                                    	<span>
	                                    		<span><fmt:message key='index.com.seeyon.v3x.index.endLabel2'>
                                                <fmt:param value="${firstResult}" />
                                                <fmt:param value="${lastResult}" />
                                               </fmt:message></span>
                                               <span>(<fmt:message key='index.com.seeyon.v3x.index.endLabel3'><fmt:param value="${time}" /></fmt:message>)</span>
	                                    	</span>
										</c:if>

                                    </td>

                                    <td width="20"></td>

                                 <c:if test="${hasResult}">

                                 	<!--排序-->
                                    <td class="sectionBody sectionBodyBorder" align="right" style='color:#999;'><input
                                            type="hidden" id="sortid" name="sortName" value="${sortName}" /> &nbsp;<<c:if
                                                test="${empty sortName||sortName=='1'}">!</c:if>a
                                            href="javascript:searchAction(1)"><fmt:message
                                                key='index.com.seeyon.v3x.index.sort.time' /></<c:if
                                                test="${empty sortName||sortName=='1'}">!</c:if>a><span style='padding:0 5px;'>|</span><<c:if
                                                test="${sortName=='2'}">!</c:if>a href="javascript:searchAction(2)" class = "a_sort_sty"><fmt:message
                                                key='index.com.seeyon.v3x.index.sort.score' />&nbsp;</<c:if
                                                test="${sortName=='2'}">!</c:if>a>
                                    </td>
                                    <!--排序结束-->

                                </c:if>
                                        <td width='40' style='padding-left:12px'>
                                        	<a href="javascript:searchAction(1)" title="文本视图"><span class="ico16 view_text_16"></span></a>
                                        	<a href="javascript:searchAction(3)" title="列表视图"><span class="ico16 view_list_16"></span></a>
                                        </td>
                                       <!--  <td><a href="javascript:searchAction(3)" title="列表视图"><span class="ico16 view_list_16"></span></a></td>  -->

                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>

<!--头部结束-->


            </c:if>
            <c:if test="${hasResult}">
	    		<c:if test="${not empty isShowIndexSummary&&isShowIndexSummary=='false'}">
                    <c:set value="true" var="isIndexSummary" />
                </c:if>
                <tr>
                    <td>
                        <table border="0" cellSpacing="0" cellPadding="0" width="100%" height="100%"
                            class="portal-layout-cell gov_border gov_nobackground">
                            <tr>
                                <td>
                                    <table border="0" cellSpacing="0" cellPadding="0" width="100%" height="100%"
                                        class="">
                                        <tr>
                                            <td valign="top">
                                                <div class="content_area_body" id="scrollListDiv"  style="padding:0px;overflow:visible;word-break:break-all;">
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" style="padding-left:10px; color:#666;"
                                                        class="">
                                                        <c:forEach var="result" items="${searchResults}">
                                                        	<c:set value="${v3x:getLimitLengthString(result.title, 80, '..')}" var="itemTitle" />
                                                            <c:if test="${result.appType == '3'}">
                                                                <c:if test="${not empty result.folderId}">
                                                                    <c:set value="javascript:getA8Top().openDocument('message.link.doc.folder.open|${result.folderId}',1)" var="openFolder" />
                                                                </c:if>
                                                            </c:if>
                                                            <c:if test="${result.appType!= '13'}">
                                                                <tr  style="height:28px;line-height:28px;font-size:16px;">
                                                                	<td width='24'>
                                                                      <img  style="vertical-align: middle;"
                                                                        src="<c:url value="/apps_res/doc/images/docIcon/${result.docType}"/>"  width="18" height="16" />
                                                                	</td>
                                                                    <td class="title_color text-overflow" colspan="4">
                                                                        <a title="${v3x:toHTML(result.title)}"
                                                                        href="javascript:openIndexResult('${result.appType}', '${result.linkId}', '${result.startMemberId}')" class="searchTitle" style="color: #207bc9;"><span
                                                                            class='importance_${result.importantLevel}'></span>${v3x:toHTML(itemTitle)}<span
                                                                            class='attachment_table_${result.isHasAttachment}'></span></a>
                                                                        &nbsp;&nbsp;&nbsp;&nbsp; 
                                                                         <span style="position:absolute;right:0;top:0;">
                                                                        <c:if
                                                                            test="${result.fileId!=null&&result.fileId!=''&&result.fileId!='null'}">
                                                                            <a href="javascript:fileDownload('${result.fileId}','${result.createDate}','${result.title }')">
                                                                                <fmt:message key='index.com.seeyon.v3x.index.download.label' />
                                                                            </a>
                                                                        </c:if> 
                                                                       
                                                                        <c:if test="${not empty result.folderId}">
                                                                            <c:if
                                                                                test="${result.fileId!=null&&result.fileId!=''}"> |</c:if>
                                                                            <a href="${openFolder }"> 
                                                                                <fmt:message key='index.com.seeyon.v3x.index.openfolder' />
                                                                            </a>
                                                                        </c:if> 
                                                                        
                                                                        <c:if
                                                                            test="${result.typeId!=null&&result.typeId!=0 }">
                                                                            <c:set
                                                                                value="javascript:openInfoMore('${result.appType }','${result.typeId }')"
                                                                                var="infoURL" />
                                                                            <a href="${infoURL}"> <fmt:message
                                                                                    key='index.com.seeyon.v3x.index.list${result.appType}' /></a>
                                                                        </c:if>
                                                                        </span>
                                                                    </td>
                                                                    <td align="right" width="90px" style="display:none">
                                                                    	 <c:if test="${not empty result.score}">
                                                                            <fmt:message key='index.com.seeyon.v3x.index.score' />:${result.score}
												   						 </c:if>
												   					</td>
                                                                </tr>
                                                            </c:if>
                                                            <c:if test="${!isIndexSummary && result.showIndexSummary}">
                                                                <tr height="25" style="height:25px;line-height:25px;">
                                                                	<td width='24'></td>
                                                                    <td colspan="2"><c:if
                                                                            test="${not empty result.picturePath}">
                                                                            <img alt="${v3x:toHTML(result.title)}"
                                                                                src="${result.picturePath}" width="50px"
                                                                                height="50px" style="float: left">
                                                                        </c:if> <c:choose>
                                                                            <c:when test="${result.appType== '13'}">
                                                                                <table border="0" cellSpacing="0"
                                                                                    cellPadding="3" width="60%"
                                                                                    class="ellipsis">
                                                                                    <tr>
                                                                                        <td width="10%"
                                                                                            title="${v3x:toHTML(result.officePhoto)}">&nbsp;&nbsp;<fmt:message
                                                                                                key='index.com.seeyon.v3x.index.member.office' />:&nbsp;${v3x:toHTML(result.officePhoto)}
                                                                                        </td>
                                                                                        <td width="10%"><fmt:message
                                                                                                key='index.com.seeyon.v3x.index.member.dept' />:&nbsp;${result.deptName}</td>
                                                                                        <td width="20%"
                                                                                            title="${v3x:toHTML(result.memo)}"><fmt:message
                                                                                                key='index.com.seeyon.v3x.index.member.memo' />:&nbsp;${v3x:toHTML(result.memo)}</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td width="10%"
                                                                                            title="${v3x:toHTML(result.telePhoto)}">&nbsp;&nbsp;<fmt:message
                                                                                                key='index.com.seeyon.v3x.index.member.tele' />:&nbsp;${v3x:toHTML(result.telePhoto)}
                                                                                        </td>
                                                                                        <td colspan="2" width="10%"
                                                                                            title="${v3x:toHTML(result.postName)}"><fmt:message
                                                                                                key='index.com.seeyon.v3x.index.member.post' />:&nbsp;${v3x:toHTML(result.postName)}</td>
                                                                                    </tr>
                                                                                    <tr>
                                                                                        <td width="10%"
                                                                                            title="${v3x:toHTML(result.email)}">&nbsp;&nbsp;<fmt:message
                                                                                                key='index.com.seeyon.v3x.index.member.email' />:&nbsp;${v3x:toHTML(result.email)}
                                                                                        </td>
                                                                                        <td colspan="2" width="10%"
                                                                                            title="${v3x:toHTML(result.level)}"><fmt:message
                                                                                                key='index.com.seeyon.v3x.index.member.level' />:&nbsp;${v3x:toHTML(result.level)}</td>
                                                                                    </tr>
                                                                                </table>
                                                                            </c:when>
                                                                            <c:otherwise>
													  	<span style="vertical-align: bottom; color: #414141;" name="search_text_len">${result.summary}</span>
                                                                            </c:otherwise>
                                                                        </c:choose></td>
                                                                </tr>
                                                                <c:if test="${not empty result.opinionSummary}">
                                                                    <tr>
                                                                    	<td width='24'></td>
                                                                        <td colspan="5">${result.opinionSummary}</td>
                                                                    </tr>
                                                                </c:if>

                                                                <c:if test="${not empty result.commentSummary}">
                                                                    <tr>
                                                                    	<td width='24'></td>
                                                                        <td colspan="5">${result.commentSummary}</td>
                                                                    </tr>
                                                                </c:if>

                                                                <c:if test="${not empty result.accessorySummary}">
                                                                    <tr>
                                                                    	<td width='24'></td>
                                                                        <td colspan="5">${result.accessorySummary}</td>
                                                                    </tr>
                                                                </c:if>
                                                                <c:if test="${not empty result.accessoryNames}">
                                                                    <tr>
                                                                    	<td width='24'></td>
                                                                        <td colspan="5">${result.accessoryNames}</td>
                                                                    </tr>
                                                                </c:if>
                                                            </c:if>
                                                            <tr style="height:30px;">
                                                            	<td width='24'></td>
                                                                <td colspan="5" class="title_color text-overflow">
                                                                    <c:choose>
                                                                        <c:when test="${result.appType == '3'}">
                                                                            <c:set
                                                                                value="index.com.seeyon.v3x.index.createUser"
                                                                                var="startMember" />
                                                                            <c:set
                                                                                value="index.com.seeyon.v3x.index.createDate"
                                                                                var="startDate" />
                                                                            <c:set value="true" var="dochas" />
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <c:set
                                                                                value="index.com.seeyon.v3x.index.startUser"
                                                                                var="startMember" />
                                                                            <c:set
                                                                                value="index.com.seeyon.v3x.index.startDate"
                                                                                var="startDate" />

                                                                        </c:otherwise>
                                                                    </c:choose> <c:if test="${result.appType!= '13'}">
                                                                        <span class="source_color"><fmt:message
                                                                                key="${startMember}" /></span>：
											   <c:choose>
                                                                            <c:when
                                                                                test="${!empty result.startMemberId&&result.startMemberId!=-1}">
											   									<c:choose>
                                                                                <c:when test="${result.showMember=='true'}">
                                                                                	<a
                                                                                    href="javascript:showV3XMemberCard('${result.startMemberId}')"
                                                                                    style="text-decoration: underline">${v3x:toHTML(result.startMember)}</a>&nbsp;
                                                                               </c:when>
                                                                                <c:otherwise>
	                                                                                ${v3x:toHTML(result.startMember)}&nbsp;
                                                                               </c:otherwise>
                                                                               </c:choose>
											   </c:when>
                                                                            <c:otherwise>
										              ${v3x:toHTML(result.startMember)}&nbsp;
											   </c:otherwise>
                                                                        </c:choose>
                                                                        <span class="source_color"><fmt:message
                                                                                key='${startDate }' />:${result.createDate}</span>
                                                                                
                                                                    </c:if> <c:if test="${result.appType== '13'}">
											 &nbsp;&nbsp;<a href="javascript:openIndexResult('${result.appType}', '${result.linkId}', '${result.startMemberId}')">${itemTitle}</a>
                                                                    </c:if>
                                                                </td>
                                                            </tr>
                                                            <tr >
                                                            	<td width='24'></td>
                                                                <td colspan="5" class="title_color text-overflow" style="padding-top: 5px;">
                                                                    <span class="source_color" >
                                                                        <c:if test="${not empty result.fileSize}"><fmt:message
                                                                            key='index.com.seeyon.v3x.index.fileSize' />:${result.fileSize}</c:if>
                                                                            </span>
                                                                            <span  class="source_color" >
                                                                    <c:if test="${not empty dochas }">
                                                                        <c:if test="${not empty result.docPath}">&nbsp;&nbsp;&nbsp;<fmt:message
                                                                                key='index.com.seeyon.v3x.index.docpath' />:${v3x:toHTML(result.docPath)}</c:if>
                                                                    </c:if>
                                                                    </span>
                                                                </td>
                                                            </tr>
                                                           <!--  <tr>
                                                            	<td width='24'></td>
                                                                <td colspan="5">&nbsp;
                                                                </td>
                                                            </tr> -->
                                                        </c:forEach>
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </c:if>
        </table>
		<div class="content_area_footer clearfix">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="padding: 5px 25px; width:100%;" valign="bottom"
            class="portal-layout-cell gov_border gov_nobackground">
            <tr>
                <td height="27" colspan="5" valign="top" align="right">
                <input type="hidden" name="keyword" id="keyword" value="${v3x:toHTMLWithoutSpace(keyword)}" /> 
                <input type="hidden" name="accessoryName" id="accessoryName" value="${v3x:toHTML(accessoryName)}"/>
                <input type="hidden" name="preornext" id="preornext" /> 
<%--                 <fmt:message key='index.com.seeyon.v3x.index.everypage' />
                <input type="text" id="pageSize" name="pageSize" value="${pageSize }" maxlength="2" class="pager-input-25" onChange="pagesizeChange()" onKeyPress="enterSubmit(this, 'pageSize')" /> 
                    <fmt:message key='index.com.seeyon.v3x.index.item' />/<fmt:message key='index.com.seeyon.v3x.index.totalItem'>
                        <fmt:param value="${totalCount}" />
                    </fmt:message>&nbsp;|<<c:if test="${!firstPage}">!</c:if>a href="javascript:first()"><fmt:message
                        key='index.com.seeyon.v3x.index.firstPage' /></<c:if test="${!firstPage}">!</c:if>a> <<c:if
                        test="${!showPrePage}">!</c:if>a href="javascript:prevPage()"><fmt:message
                        key='index.com.seeyon.v3x.index.prevPage' /></<c:if test="${!showPrePage}">!</c:if>a> <<c:if
                        test="${!showNextPage}">!</c:if>a href="javascript:goNextPage()"><fmt:message
                        key='index.com.seeyon.v3x.index.nextPage' /></<c:if test="${!showNextPage}">!</c:if>a> <<c:if
                        test="${!lastPage}">!</c:if>a href="javascript:last()"><fmt:message
                        key='index.com.seeyon.v3x.index.lastPage' /></<c:if test="${!lastPage}">!</c:if>a> <fmt:message
                        key='index.com.seeyon.v3x.index.totalPage'>
                        <fmt:param value="${totalPage}" />
                    </fmt:message> <fmt:message key='index.com.seeyon.v3x.index.go' /><input type="text" id="pageNum" name="page"
                    value="${currentPage}" maxlength="3" class="pager-input-25" onChange="pageChange(this)"
                    onKeyPress="enterSubmit(this, 'intpage')" />
                <fmt:message key='index.com.seeyon.v3x.index.page' /> <input type="button" onClick="go()" name="gog"
                    value="go" /> --%>
                    
            <div style="width:100%;padding-top:10px;padding-bottom:10px;color:#9d9c9c;font-size:12px;background:#fff;text-align:center;">
            <fmt:message key='index.com.seeyon.v3x.index.everypage' />
            <input type="text" id="pageSize" name="pageSize" maxlength="2" value="${pageSize}" onChange="pagesizeChange()" onKeyPress="enterSubmit(this, 'pageSize')" class="common_over_page_txtbox" style="width:32px;">
            <span class="margin_r_10 total">                   
             <fmt:message key='index.com.seeyon.v3x.index.item' />/<fmt:message key='index.com.seeyon.v3x.index.totalItem'><fmt:param value="${totalCount}" />
             </fmt:message></span>
            <span class="total_page"><fmt:message key='index.com.seeyon.v3x.index.totalPage'> <fmt:param value="${totalPage}" /></fmt:message></span>
            
            <!-- 第一页 -->
		     <a class="pFirst pButton common_over_page_btn" <c:if test="${firstPage}">href="javascript:first()" </c:if>><span class="pageFirst"></span></a>
            <!-- 上一页 -->
		     <a class="pPrev pButton common_over_page_btn"  <c:if test="${showPrePage}"> href="javascript:prevPage()"</c:if>><span class="pagePrev"></span></a>
            
            <span class="pcontrol margin_l_10">
            <fmt:message key='index.com.seeyon.v3x.index.go' />
            <input type="text" id="pageNum" name="page" class="common_over_page_txtbox" name="page" value="${currentPage}" maxlength="3" onChange="pageChange(this)"  onKeyPress="enterSubmit(this, 'intpage')" /> <fmt:message key='index.com.seeyon.v3x.index.page' /></span>
            <!-- 下一页 -->
		    <a class="pNext pButton common_over_page_btn" <c:if test="${showNextPage}"> href="javascript:goNextPage()"</c:if>><span class="pageNext"></span></a>
            <!-- 最后一页 -->
		     <a class="pLast pButton common_over_page_btn" <c:if test="${lastPage}"> href="javascript:last()" </c:if>><span class="pageLast"></span></a>
            
            <a class="common_over_page_btn" style="display:none"><span class="pReload pButton"><span class="ico16 refresh_16 margin_lr_5">&nbsp;</span></span></a>
            <a href="javascript:go()" id="grid_go" class="common_button margin_lr_10 common_over_page_go" name="gog">GO</a>
            <div class="pGroup" style="display:none;">
                <span class="pPageStat">Displaying 1 to 5 of 5 items</span>
            </div>
        </div>
        </td>
            </tr>
            <tr style="display: none;">
                <td><c:if test="${not empty libStr}">
                        <c:forEach var="lib" items="${libStr}">
                            <input type="checkbox" name="library" value="${lib}" checked="checked" />
                        </c:forEach>
                    </c:if></td>
            </tr>
        </table>
        </div>
        </div>
    </form>
</body>
</html>
<script type="text/javascript">
var tout = null;
function resizePage(){   
    <c:if test="${hasResult}">
    tout=setTimeout("fnReSizeOfficeWindow()",200);
    </c:if>
}

function fnReSizeOfficeWindow()
{
   //判断页面是否加载完成
   if (document.readyState=='complete')
   {
        //停止定时器
       clearTimeout(tout);
       var docContent = document.getElementById("mainDivId");
       
       if(typeof(document.getElementById("scrollListDiv"))==='undefined'){
           return ;
       }
       var oContentArea=parent.document.getElementById("contentAreaId");
       var oScrollList=document.getElementById("scrollListDiv");
       //oScrollList.style.height =oContentArea.clientHeight-60;
      // oScrollList.style.width =oContentArea.clientWidth - 30;
      oScrollList.style.width = 900;
    }
}
/* var _spanVal = document.getElementsByName("search_text_len");
//console.log(_spanVal[0].textContent);
if(_spanVal.length){
  for(var i = 0 ;i<_spanVal.length;i++){

       spanValue = _spanVal[i].innerHTML; 
		if(spanValue && spanValue.length>100){
		  spanValue=spanValue.substring(0,100)+"...";
		 
		}
		console.log(spanValue);
		console.log(_spanVal[i]);
	 _spanVal[i].innerHTML=spanValue; 
      
  }
}
else{
   spanValue = _spanVal.innerHTML; 
		if(spanValue && spanValue.length>100){
		  spanValue=spanValue.substring(0,100)+"...";

		}
	 _spanVal.innerHTML=spanValue;
} */

// 设置滚动条的高度
document.getElementById("scrollBody").style.height = window.document.body.clientHeight + "px";

if(navigator.userAgent.indexOf("MSIE 9") > 0 && navigator.userAgent.indexOf("Trident/5.0") > 0){
    document.getElementById("scrollBody").style.height = window.document.body.clientHeight - 50 + "px";
    if(!window.parent.document.getElementById("moreSearchArea").getAttribute("style")){
        document.getElementById("scrollBody").style.height = window.document.body.clientHeight - 150 + "px";
    }
}

</script>