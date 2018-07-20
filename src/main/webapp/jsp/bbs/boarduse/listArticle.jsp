<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>	
<title></title>
<script type="text/javascript">
<!--
    function dateChecks () {
        var condition = document.getElementById('condition').value;
        if (condition == 'issueTime') {
            return dateCheck();
        } else {
            doSearch();
        }
    }

	function articleDetail(articleId){
		var acturl = "${detailURL}?method=showPost&spaceId=${param.spaceId}&articleId="+articleId+"&resourceMethod=listAllArticle&group=${group}";
		openWin(acturl);
	}
	
	window.onload = function(){
		showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	}
	
	var firstName = "${firstName}";
	var secondName = "${secondName}";
	if (firstName != '' && secondName != '') {
	     var theHtml=toHtml("${v3x:toHTML(firstName)}",'${v3x:toHTML(secondName)}');
	     showCtpLocation("",{html:theHtml});
	}
//-->
</script>
</head>
<body scroll="no" class="with-header">
	<div class="main_div_row2">
 		<div class="right_div_row2">
  			<div class="top_div_row2">
                <table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0" style='background:#eee;'>
                    <tr class="page2-header-line">
                        <td width="100%" height="38" valign="top" class="page-list-border-LRD" colspan="2">
                             <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
                                <tr class="page2-header-line">
                                <td width="45" class="page2-header-img"><div class="bbsIndex"></div></td>
                                <td class="page2-header-bg"><fmt:message key='application.9.label' bundle="${v3xCommonI18N}" /></td>
                                <td class="page2-header-line page2-header-link" align="right">
                                </td>
                            </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                       <td height="25" class="webfx-menu-bar page2-list-header" style="border-top: 1px solid #b6b6b6;">
                            <c:choose>
                                <c:when test="${moreList}">
                                     <b>${v3x:toHTML(boardName)}</b>
                                </c:when>
                                <c:when test="${param.topFlag == 'true' && group=='group'}">
                                    <b><fmt:message key='bbs.groupTopBbs.label'/></b>
                                </c:when>
                                <c:when test="${param.topFlag == 'true'}">
                                    <b><fmt:message key='bbs.TopbbsSection.label'/></b>
                                </c:when>
                                <c:otherwise>
                                    <b>
                                    <c:choose>
                                        <c:when test="${publicCustom}">
                                            ${v3x:toHTML(spaceName)}
                                        </c:when>
                                        <c:when test="${group=='group' }">
                                            <c:set value="${v3x:getSysFlagByName('sys_isGovVer') ? '.rep' : ''}" var="govLabel" />
                                            <fmt:message key='group.latest.bbs.label${govLabel}' />
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:message key='account.latest.bbs.label' />
                                        </c:otherwise>
                                    </c:choose>
                                    </b>
                                </c:otherwise>
                            </c:choose>
                       </td>
                       <td class="webfx-menu-bar"  style="border-top: 1px solid #b6b6b6;">
                            <form action="${detailURL}" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
                                <input type="hidden" value="oneTypeBbsSearch" name="method"> 
                                <input type="hidden" name="id" value="${board.id}">
                                <input type="hidden" name="group" value="${group}">
                                <input type="hidden" value="${param.homeFlag}" name="homeFlag">
                                <input type="hidden" name="typeId" value="${typeId}">
                                <input type="hidden" name="boardId" value="${typeId}">
                                <input type="hidden" name="spaceType" value="${param.spaceType}">
                                <input type="hidden" name="spaceId" value="${param.spaceId}">
                                <input type="hidden" name="topFlag" value="${param.topFlag}">
                                <div class="div-float-right condition-search-div">
                                    <div class="div-float">
                                        <select name="condition"  id="condition" onChange="showNextCondition(this)" class="condition ">
                                            <option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}"/></option>
                                            <option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}"/></option>
                                            <option value="issueUser"><fmt:message key="bbs.issue.poster.label"/></option>
                                            <option value="issueTime"><fmt:message key="bbs.date.create"/></option>
                                        </select>
                                    </div>
                                    <div id="subjectDiv" class="div-float hidden"><input type="text" name="textfield"  maxlength="50" onkeydown="javascript:searchWithKey()" class="textfield"></div>
                                    <div id="issueUserDiv" class="div-float hidden"><input type="text" name="textfield" maxlength="50" onkeydown="javascript:searchWithKey()" class="textfield"></div>
                                    <div id="issueTimeDiv" class="div-float hidden"><input
                                        type="text" id="startdate" name="textfield" class="input-date"
                                        onclick="whenstart('${pageContext.request.contextPath}',this,640,265);"
                                        readonly> - <input type="text" id="enddate" name="textfield1" class="input-date"
                                        onclick="whenstart('${pageContext.request.contextPath}',this,720,265);" readonly></div>
                                    <div onclick="javascript:dateChecks()" class="div-float condition-search-button  button-font-color"></div>
                                </div>
                            </form> 
                       </td>
                        </tr>
                        </table>
                       </div>
                         <div class="center_div_row2" id="scrollListDiv">
                                            <fmt:message key='bbs.board.label' var="bbsBoard"/>
                                                <form name="fm" method="post" action="" onsubmit="">
                                                <v3x:table htmlId="pending" data="${articleModellist}" var="col" isChangeTRColor="false" className="">
                                                    <c:set value="${(empty param.boardId && empty param.typeId)?'40%':'60%'}" var="width"/>
                                                    <v3x:column width="${width}" type="String" label="common.subject.label" hasAttachments="${col.attachmentFlag}">
                                                        <a href="javascript:articleDetail('${col.id}')"  title="${v3x:toHTML(col.articleName)}" class="defaulttitlecss">
                                                             <c:choose>
                                                                <c:when test="${typeId != null}">
                                                                    <c:set value="50" var="nameLength" />
                                                                    <c:if test="${col.topSequence==1}">
                                                                        <font color="red">[<fmt:message key="bbs.top.label" />]</font>
                                                                        <c:set value="${nameLength - 4}" var="nameLength" />
                                                                    </c:if>
                                                                    ${v3x:toHTML(col.articleName)}
                                                                    <c:if test="${col.eliteFlag}">
                                                                        <font color="red">[<fmt:message key="bbs.elite.label" />]</font>
                                                                    </c:if>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    ${v3x:toHTML(col.articleName)}
                                                                </c:otherwise>
                                                             </c:choose>
                                                        </a>
                                                    </v3x:column>
                                                    <c:if test="${empty param.boardId && empty param.typeId}">
                                                    <v3x:column width="20%" type="String" label="${bbsBoard}" value="${col.board.name}" maxLength="20" symbol="..."
                                                     href="${detailURL}?method=listAllArticle&boardId=${col.board.id}&group=${group}&from=${param.from}" />
                                                     </c:if>								
                                                    <c:set var="currentUserId" value="${v3x:currentUser().id}" />
                                                    <c:choose>
                                                        <c:when test="${col.anonymousFlag && currentUserId!=col.issueUser}">
                                                            <fmt:message key="anonymous.label" var="createrUser"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:set value="${v3x:showOrgEntitiesOfIds(col.issueUser, 'Member', pageContext)}" var="createrUser"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <v3x:column width="10%" type="String" label="bbs.issue.poster.label" value="${createrUser}"  maxLength="18" symbol="..."/>
                                                    <v3x:column width="10%" type="Number" align="center" label="bbs.clicknumber.label" value="${col.clickNumber}" />
                                                    <v3x:column width="10%" type="Number" align="center" label="bbs.replynumber.label" value="${col.replyNumber}" />
                                                    <v3x:column type="Date" label="bbs.date.create" width="10%">
                                                        <fmt:formatDate value="${col.issueTime}" pattern="${dataPattern}" />
                                                    </v3x:column>
                                                </v3x:table>
                                                </form>
                                        </div></div></div>
<script type="text/javascript">
<!--
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
if('${param.openFrom}'=='index'){
	resetCtpLocation();
}
//-->
</script>
</body>
</html>
