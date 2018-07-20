<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<style type="text/css">
.page2-header-bg {
    font-size: 24px;
    font-weight: bold;
    color: #219FDA;
    width:380px;
    text-shadow:1px 2px 2px #cccccc;
}
.div-float a{
    color: #1039B2;
    text-decoration:none;
    cursor: pointer;
}
.sorts {
    border-bottom:dotted 1px #ccc;
    font-size: 22px;
    PADDING-LEFT: 8px;
    PADDING-TOP: 8px;
    PADDING-BOTTOM: 8px;
}
a {
    font-size: 12px;
    cursor: pointer;
    color: #007CD2;
    text-decoration: none;
}
body{
    margin-left: 32px;
    margin-top: 12px;
}
</style>
</head>
<body style="overflow: auto;">
<c:set value="${CurrentUser.loginAccount}" var="loginAccountId" />
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
    <tr class="page2-header-line">
       <td width="100%" height="38" valign="top">
           <form id="searchForm" method="post" action="${path}/collTemplate/collTemplate.do?method=moreDepartmentTemplate">
               <table width="100%"  border="0" cellpadding="0" cellspacing="0">
                   <tr class="page2-header-line">
                       <!-- 部门模板 -->
                       <td class="page2-header-bg">${ctp:i18n("template.templatePub.departmentsTemplate")}</td>
                       <td class="page2-header-line page2-header-link" align="right">
                            <!-- 
                            <input id="searchValue" name="searchValue" value="${searchValue}"/>
                            <span class="ico16 search_16" onclick="search()"></span>&#13
                             -->
                       </td>
                      
                       <td width="1%">
                       </td>
                   </tr>
              </table>
          </form>
       </td>
    </tr>
    <c:if test="${v3x:hasPlugin('edoc') && v3x:isEnableEdoc()}">
        <c:if test="${fn:length(templeteListSend) != 0}">
            <table border="0" width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td colspan="4" class="sortsHead">
                      <div class="div-float no-wrap">
                          <span class="ico16 folder_16"></span>
                          <a class="display-inline">
                              <b>${ctp:i18n("template.templatePub.postingTemplate")}</b><!-- 发文模板 -->
                          </a>
                      </div>
                    </td>
                </tr>
                <tr>
                    <c:forEach items="${templeteListSend }" var="templete" varStatus="ordinal">
                        <td class="text-indent-1em sorts" width="25%"> 
                          <c:choose>
                              <c:when test="${templete.orgAccountId != loginAccountId }">
                                  <c:set var="theAccount" value="${v3x:getAccount(templete.orgAccountId)}"/>
                                  <c:set var="esName" value="${templete.subject}"/>
                                  <c:set var="templeteName" value="${esName}(${theAccount.shortName})"/>
                                  <c:set var="templeteShowName" value="${v3x:toHTML(v3x:getLimitLengthString(templeteName,22,'...'))}"/>
                              </c:when> 
                              <c:otherwise>
                                  <c:set var="templeteName" value="${templete.subject}"/>
                                  <c:set var="templeteShowName" value="${v3x:toHTML(v3x:getLimitLengthString(templeteName,22,'...'))}"/>
                              </c:otherwise>
                          </c:choose>
                          <a title="${templeteName}&#13${templeteCreatorAlt[templete.memberId] }" class='defaultlinkcss' 
                          href="${path}/edocController.do?method=entryManager&entry=sendManager&toFrom=newEdoc&templeteId=${templete.id}">
                               <span class="ico16 ${templeteIcon[templete.id]} }"></span>&nbsp;${templeteShowName}</a>
                        </td>
                        ${(ordinal.index + 1) % 4 == 0 && !ordinal.last ? "</tr><tr>" : ""}
                        <c:set value="${(ordinal.index + 1) % 4}" var="i" />
                    </c:forEach>
                    <c:if test="${i !=0}">                  
                      <c:forTokens items="1,1,1,1" delims="," end="${4 - i - 1}">
                          <td  width="25%" class="sorts">&nbsp;</td>
                      </c:forTokens>
                    </c:if>
                </tr>
            </table>
        </c:if>
        <c:if test="${fn:length(templeteListRec) != 0}">
            <table border="0" width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td colspan="4" class="sortsHead">
                        <div class="div-float no-wrap">
                            <span class="ico16 folder_16"></span>
                            <a class="display-inline">
                                <!-- 收文模板 -->
                                <b>${ctp:i18n("template.templatePub.receiptTemplate")}</b>
                            </a>
                        </div>
                    </td>
                </tr>
                <tr>
                    <c:forEach items="${templeteListRec }" var="templete" varStatus="ordinal">
                        <td class="text-indent-1em sorts"  width="25%"> 
                            <c:choose>
                              <c:when test="${templete.orgAccountId != loginAccountId }">
                                  <c:set var="theAccount" value="${v3x:getAccount(templete.orgAccountId)}"/>
                                  <c:set var="esName" value="${templete.subject}"/>
                                  <c:set var="templeteName" value="${esName}(${theAccount.shortName})"/>
                                  <c:set var="templeteShowName" value="${v3x:toHTML(v3x:getLimitLengthString(templeteName,22,'...'))}"/>
                              </c:when> 
                              <c:otherwise>
                                  <c:set var="templeteName" value="${templete.subject}"/>
                                  <c:set var="templeteShowName" value="${v3x:toHTML(v3x:getLimitLengthString(templeteName,22,'...'))}"/>
                              </c:otherwise>
                            </c:choose>
                            <a title="${templeteName}&#13${templeteCreatorAlt[templete.memberId] }" class='defaultlinkcss' 
                            href="${path}/edocController.do?method=entryManager&entry=recManager&toFrom=newEdoc&templeteId=${templete.id}">
                             <span class="ico16 ${templeteIcon[templete.id]} }"></span>&nbsp;${templeteShowName}</a>
                        </td>
                        ${(ordinal.index + 1) % 4 == 0 && !ordinal.last ? "</tr><tr>" : ""}
                        <c:set value="${(ordinal.index + 1) % 4}" var="i" />
                    </c:forEach>
                    <c:if test="${i !=0}">                  
                        <c:forTokens items="1,1,1,1" delims="," end="${4 - i - 1}">
                            <td  width="25%" class="sorts">&nbsp;</td>
                        </c:forTokens>
                    </c:if>
                </tr>
            </table>
        </c:if>
        <c:if test="${fn:length(templeteListSginReport) != 0}">
            <table border="0" width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td colspan="4" class="sortsHead">
                        <div class="div-float no-wrap">
                            <span class="ico16 folder_16"></span>
                            <a class="display-inline">
                                <!-- 签报模板 -->
                                <b>${ctp:i18n("template.templatePub.theyReportTemplate")}</b>
                            </a>
                        </div>
                    </td>
                </tr>
                <tr>
                    <c:forEach items="${templeteListSginReport }" var="templete" varStatus="ordinal">
                        <td class="text-indent-1em sorts"  width="25%"> 
                            <c:choose>
                              <c:when test="${templete.orgAccountId != loginAccountId }">
                                  <c:set var="theAccount" value="${v3x:getAccount(templete.orgAccountId)}"/>
                                  <c:set var="esName" value="${templete.subject}"/>
                                  <c:set var="templeteName" value="${esName}(${theAccount.shortName})"/>
                                  <c:set var="templeteShowName" value="${v3x:toHTML(v3x:getLimitLengthString(templeteName,22,'...'))}"/>
                              </c:when> 
                              <c:otherwise>
                                  <c:set var="templeteName" value="${templete.subject}"/>
                                  <c:set var="templeteShowName" value="${v3x:toHTML(v3x:getLimitLengthString(templeteName,22,'...'))}"/>
                              </c:otherwise>
                            </c:choose>
                            <a title="${templeteName}&#13${templeteCreatorAlt[templete.memberId] }" class='defaultlinkcss' 
                            href="${path}/edocController.do?method=entryManager&entry=signReport&toFrom=newEdoc&templeteId=${templete.id}">
                             <span class="ico16 ${templeteIcon[templete.id]} }"></span>&nbsp;${templeteShowName}</a>
                        </td>
                        ${(ordinal.index + 1) % 4 == 0 && !ordinal.last ? "</tr><tr>" : ""}
                        <c:set value="${(ordinal.index + 1) % 4}" var="i" />
                    </c:forEach>
                    <c:if test="${i !=0}">
                        <c:forTokens items="1,1,1,1" delims="," end="${4 - i - 1}">
                            <td  width="25%" class="sorts">&nbsp;</td>
                        </c:forTokens>
                    </c:if>
                </tr>
            </table>
        </c:if>
    </c:if>
    <%--信息报送开始--%>
    <c:if test="${fn:length(templeteListInfo) != 0}">
            <table border="0" width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td colspan="4" class="sortsHead">
                        <div class="div-float no-wrap">
                            <span class="ico16 folder_16"></span>
                            <a class="display-inline">
                                <!-- 信息模板 -->
                                <b>${ctp:i18n("collaboration.info.template.label")}</b>
                            </a>
                        </div>
                    </td>
                </tr>
                <tr>
                    <c:forEach items="${templeteListInfo }" var="templete" varStatus="ordinal">
                        <td class="text-indent-1em sorts"  width="25%"> 
                            <c:choose>
                              <c:when test="${templete.orgAccountId != loginAccountId }">
                                  <c:set var="theAccount" value="${v3x:getAccount(templete.orgAccountId)}"/>
                                  <c:set var="esName" value="${templete.subject}"/>
                                  <c:set var="templeteName" value="${esName}(${theAccount.shortName})"/>
                                  <c:set var="templeteShowName" value="${v3x:toHTML(v3x:getLimitLengthString(templeteName,22,'...'))}"/>
                              </c:when> 
                              <c:otherwise>
                                  <c:set var="templeteName" value="${templete.subject}"/>
                                  <c:set var="templeteShowName" value="${v3x:toHTML(v3x:getLimitLengthString(templeteName,22,'...'))}"/>
                              </c:otherwise>
                            </c:choose>
                            <a title="${templeteName}&#13${templeteCreatorAlt[templete.memberId] }" class='defaultlinkcss' 
                            href="${path}/info/infomain.do?method=infoReport&listType=listCreateInfo&templateId=${templete.id}">
                             <span class="ico16 ${templeteIcon[templete.id]} }"></span>&nbsp;${templeteShowName}</a>
                        </td>
                        ${(ordinal.index + 1) % 4 == 0 && !ordinal.last ? "</tr><tr>" : ""}
                        <c:set value="${(ordinal.index + 1) % 4}" var="i" />
                    </c:forEach>
                    <c:if test="${i !=0}">
                        <c:forTokens items="1,1,1,1" delims="," end="${4 - i - 1}">
                            <td  width="25%" class="sorts">&nbsp;</td>
                        </c:forTokens>
                    </c:if>
                </tr>
            </table>
        </c:if>
    <%--信息报送结束 --%>
    <c:if test="${fn:length(categoryNames) != 0}">
        <c:forEach items="${categoryNames }" var="categoryName">
            <c:set var="templetes" value="${collTempleteCategory[categoryName] }"/>
            <c:if test="${fn:length(templetes) != 0}">
              <table border="0" width="100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td colspan="4" class="sortsHead">
                      <div class="div-float no-wrap">
                          <span class="ico16 folder_16"></span>
                          <a class="display-inline">
                            <b>${v3x:escapeJavascript(categoryName)}</b>
                          </a> 
                      </div>
                    </td>
                </tr>
                <tr> 
                    <c:forEach items="${templetes }" var="templete" varStatus="ordinal">
                        <td class="text-indent-1em sorts"  width="25%">
                            <c:choose>
                              <c:when test="${templete.orgAccountId != loginAccountId }">
                                  <c:set var="theAccount" value="${v3x:getAccount(templete.orgAccountId)}"/>
                                  <c:set var="esName" value="${templete.subject}"/>
                                  <c:set var="templeteName" value="${esName}(${theAccount.shortName})"/>
                                  <c:set var="templeteShowName" value="${v3x:toHTML(v3x:getLimitLengthString(templeteName,22,'...'))}"/>
                              </c:when> 
                              <c:otherwise>
                                  <c:set var="templeteName" value="${templete.subject}"/>
                                  <c:set var="templeteShowName" value="${v3x:toHTML(v3x:getLimitLengthString(templeteName,22,'...'))}"/>
                              </c:otherwise>
                            </c:choose>
                            <c:set var="createTitle" value="${templeteName }&#13${templeteCreatorAlt[templete.memberId] }"/>
                            <a title="${createTitle}" class='defaultlinkcss' href="${path }/collaboration/collaboration.do?method=newColl&templateId=${templete.id}"><span class="ico16 ${templeteIcon[templete.id]} }"></span>
                            &nbsp;${templeteShowName }</a> 
                        </td>
                        ${(ordinal.index + 1) % 4 == 0 && !ordinal.last ? "</tr><tr>" : ""}
                        <c:set value="${(ordinal.index + 1) % 4}" var="i" />
                    </c:forEach>
                    <c:if test="${i !=0}">                  
                        <c:forTokens items="1,1,1,1" delims="," end="${4 - i - 1}">
                            <td  width="25%" class="sorts">&nbsp;</td>
                        </c:forTokens>
                    </c:if>
                </tr>
              </table>
            </c:if>
        </c:forEach>
    </c:if>
</table>
</body>
</html>
