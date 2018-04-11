<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">   
<%@ include file="header.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<style type="text/css">
  .scrollList{
    overflow: hidden;
  }
</style>
<c:set var="current_user_id" value="${sessionScope['com.seeyon.current_user'].id}"/>
<script type="text/javascript" src="<c:url value='/apps_res/isearch/js/isearch.js${v3x:resSuffix()}' />">
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/knowledgeBrowseUtils.js" />"></script>
</head>
<body scroll="no" style="width:100%;height:100%;">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="search_bg">
    <tr>
        <td height="9">
            <div class="portal-layout-cell " style="margin-bottom:0;">          
            <div class="portal-layout-cell_head">
                <div class="portal-layout-cell_head_l"></div>
                <div class="portal-layout-cell_head_r"></div>
            </div>
            <div class="portal-layout-cell-right">
            <div class="sectionSingleTitleLine border-tree" style="background:#fafafa;">
                <span class="searchSectionTitle"><fmt:message key="isearch.jsp.list.result" bundle="${isearchI18N}"/>:</span>
            </div> </div> </div> 
        </td>
    </tr>
<tr>
    <td valign="top" style="background-color: #ffffff;" >
                    <table border="0" cellSpacing="0" cellPadding="0" width="100%" height="100%" class="portal-layout-cell-right">
                        <tr>
                            <td valign="top">
                                <div class="scrollList border_lr" style="width: 100%;" >
                                    <form>
                                        <c:set value="${cm.appObj.appShowName}" var="typeName" />
                                        <c:if test="${cm.appObj.appShowName == null}">
                                        <c:set value="${v3x:getApplicationCategoryName(cm.appObj.appEnumKey, pageContext)}" var="typeName" />
                                        </c:if>
                                        <c:if test="${cm.appObj.nameKey != null}">
                                        <c:set value="${v3x:_(pageContext, cm.appObj.nameKey)}" var="typeName" />
                                        </c:if>
                                        <c:set value="" var="locLabel" />
                                        <v3x:table width="100%" htmlId="dataTable"  data="${list}" var="vo" isChangeTRColor="false"  className="sort ellipsis" subHeight="40"
                                         bundle="${isearchI18N}">
                                            <v3x:column type="String" align="left" label="common.subject.label" width="49%" onClick="" alt="${vo.title}"  bodyType="${vo.bodyType}" hasAttachments="${vo.hasAttachments}" >              
                                                <html:link renderURL="${vo.openLink}&from=isearch&dumpData=${param.dumpData}" var="theUrl" />
                                                <a href="javascript:openKnowledgeByURL('${theUrl}')">${v3x:toHTML(vo.title)}</a>
                                            </v3x:column>
                                            <v3x:column width="15%" type="String" align="left" label="common.sender.label"  alt="${vo.fromUserName}">
                                                ${vo.fromUserName}
                                            </v3x:column>
                                            <v3x:column width="15%" type="Date" align="left" label="common.date.senddate.label">
                                                <fmt:formatDate value="${vo.beginDate}" pattern="yyyy-MM-dd" />
                                            </v3x:column>
                                            <v3x:column width="20%" type="String" align="left" label="isearch.jsp.list.loc" alt="${vo.locationPath}">
                                                ${v3x:toHTML(vo.locationPath)}
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