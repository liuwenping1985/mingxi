<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" errorPage=""%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N" />
<fmt:setBundle basename="com.seeyon.apps.index.resource.i18n.IndexResources" />
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources" var="v3xMainI18N" />
<fmt:setBundle basename="com.seeyon.v3x.doc.resources.i18n.DocResource" var="docResources" />
<fmt:message key="common.datetime.pattern" var="datePattern" bundle="${v3xCommonI18N}" />
<fmt:setBundle basename="com.seeyon.v3x.isearch.resources.i18n.ISearchResources" var="isearchI18N" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html style="overflow:hidden" class="h100b">
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
<!--
var v3x = new V3X();
v3x.init("<c:out value='${pageContext.request.contextPath}' />", "<%=com.seeyon.v3x.common.i18n.LocaleContext.getLanguage(request)%>");
_ = v3x.getMessage;

 var resultJson = '${resultJson}';
 var keyword="${v3x:escapeJavascript(keyword)}";
 var accessoryName="${v3x:escapeJavascript(accessoryName)}";
 var currentPage="${currentPage}";
 var prePage="${prePage}";
 var nextPage="${nextPage}";
 var totalPage="${totalPage}";
 var totalCount="${totalCount}";
 parent.document.getElementById("searchBtn").disabled=false;
 var resultData = '{"rows": '+resultJson+'}';
 var sss = $.parseJSON(resultData);

    function clickRow(data, rowIndex, colIndex){
        if(data.appType == '1' || data.appType == '2'|| data.appType == '400'){
            getA8Top().openDocument('message.link.col.done.detail|'+data.linkId,0);
        }else if(data.appType == '4' || data.appType == '19' || data.appType == '20' || data.appType == '21'){
            getA8Top().openDocument('message.link.edoc.done|'+data.linkId,0);
        }else if(data.appType == '3'){
            getA8Top().openDocument('message.link.doc.open.index|'+data.linkId,0);
        }else if(data.appType == '8'){
            getA8Top().openDocument('message.link.news.open|'+data.linkId,0);
        }else if(data.appType == '7'){
            getA8Top().openDocument('message.link.bulletin.open|'+data.linkId,0);
        }else if(data.appType == '9'){
            getA8Top().openDocument('message.link.bbs.open|'+data.linkId+'|listLatestFiveArticleAndAllBoard',0);
        }else if(data.appType == '10'){
            getA8Top().openDocument('message.link.inquiry.send|'+data.linkId,0);
        }else if(data.appType == '6'){
            getA8Top().openDocument('message.link.mt.send|'+data.linkId,0);
        }else if(data.appType == '11'){
            getA8Top().openDocument('message.link.cal.view|'+data.linkId,0);
        }else if(data.appType == '5'){
            getA8Top().openDocument('message.link.plan.summary|'+data.linkId,0);
        }else if(data.appType == '30'){
            getA8Top().openDocument('message.link.taskmanage.view|'+data.linkId,0);
        }else{
            showV3XMemberCard(data.startMemberId);
        }
    }

    function rend(text, row, rowIndex, colIndex,col){
        if (colIndex == 0 && row.isHasAttachment == "true") {
            return  text + "<span class='ico16 affix_16'></span>";
        }else{
            return text;
        }
    }

 $(function() {
  // 表格加载
     grid = $('#indexResultTable').ajaxgrid({
         click : clickRow,
         datas: sss,
         colModel : [{
             display : "${ctp:i18n('index.view.list.title')}",
             name : 'title',
             sortable : true,
             width : '28%'
         }, {
             display : "${ctp:i18n('index.view.list.content')}",
             name : 'content',
             sortable : true,
             width : '40%'
         }, {
             display : "${ctp:i18n('index.com.seeyon.v3x.index.startUser')}",
             name : 'startMember',
             sortable : true,
             width : '10%'
         }, {
             display : "${ctp:i18n('index.com.seeyon.v3x.index.startDate')}",
             name : 'createDate',
             sortable : true,
             width : '10%'
         }, {
             display : "${ctp:i18n('index.com.seeyon.v3x.index.docpath')}",
             name : 'docPath',
             sortable : true,
             width : '10%'
         }],
         render : rend,
         resizable : false,
         height : $(window).height() - 100,
         width : $(window).width() - 3,
         isEscapeHTML : false,
         usepager: false,
         showTableToggleBtn : false,
         //parentId : $('.layout_center').eq(0).attr('id'),
         vChange : true,
         vChangeParam : {
             overflow : "hidden",
             autoResize : true
         },
         isHaveIframe : true,
         slideToggleBtn : false
        });
});
</script>
${v3x:skin()}
<style type="text/css">
.sectionBody {
    background-color: rgb(255, 255, 255);
}
</style>
</head>
<body scroll="no" class="padding0 h100b" onkeydown="doKeyPressedEvent()" onload="resizePage();">
    <form class="h100b" action="<html:link renderURL='/index/indexController.do?method=searchAll'/>" method="post" id="form1" target="_self">
        <input name="iframeSearch" value="iframeSearch" type="hidden" />
        <input type="hidden" " id="author" name="author" value="${v3x:toHTML(author)}" />
        <input type="hidden" " id="title" name="title" value="${v3x:toHTML(title)}" />
        <input type="hidden" " id="SEARCHDATE_BEGIN" name="SEARCHDATE_BEGIN" value="${SEARCHDATE_BEGIN}" />
        <input type="hidden" " id="SEARCHDATE_END" name="SEARCHDATE_END" value="${SEARCHDATE_END}" />
        <input type="hidden" " id="viewType" name="viewType" value="${viewType}" />
        <input type="hidden" name="keyword" id="keyword" value="${v3x:toHTML(keyword)}" />
        <input type="hidden" name="accessoryName" id="accessoryName" value="${v3x:toHTML(accessoryName)}"/>
        <input type="hidden" name="preornext" id="preornext" />
        <input type="hidden" id="sortid" name="sortName" value="${sortName}" />
        <div class="h100b">
        <table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0" class="main-bg" id="mainDivId">
            <c:if test="${isAfterSearch}">
                <tr>
                    <td height="20" style="padding: 0 5px" valign="top">
                        <div class="gov_border gov_nobackground" style="padding: 5px 5px 0px 5px" id="resultBarId">
                            <table border="0" cellSpacing="0" cellPadding="0" width="100%">
                                <tr>
                                    <td class="">&nbsp;&nbsp;&nbsp;<fmt:message
                                            key='index.com.seeyon.v3x.index.searchKey' />: <fmt:message
                                            key='index.com.seeyon.v3x.index.endLabel1'>
                                            <fmt:param value="${totalCount}" />
                                        </fmt:message> <c:if test="${hasResult}">
                                            <fmt:message key='index.com.seeyon.v3x.index.endLabel2'>
                                                <fmt:param value="${firstResult}" />
                                                <fmt:param value="${lastResult}" />
                                            </fmt:message>
                                        </c:if> (<fmt:message key='index.com.seeyon.v3x.index.endLabel3'>
                                            <fmt:param value="${time}" />
                                        </fmt:message>)
                                    </td>
                                    <td width="20"></td>
                                    <td>
									<a href="javascript:searchAction(1)" title="${ctp:i18n('index.view.text')}"><span class="ico16 view_text_16"></span></a>
									<a href="javascript:searchAction(3)" title="${ctp:i18n('index.view.list')}"><span class="ico16 view_list_16"></span></a>
									</td>

                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
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
                                                <div class="content_area_body" style="padding-left:0px;">
                                                    <table  class="flexme3" id="indexResultTable"></table>
                                                    <div class="content_area_footer clearfix" align="right">
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" style="padding: 5px 25px; width:540px;" valign="bottom"
                                                        class="portal-layout-cell gov_border gov_nobackground">
                                                        <tr>
                                                            <td height="27" colspan="5" valign="top" align="left">
                                                            <fmt:message key='index.com.seeyon.v3x.index.everypage' />
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
                                                                value="go" /></td>
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
    }
}
</script>
