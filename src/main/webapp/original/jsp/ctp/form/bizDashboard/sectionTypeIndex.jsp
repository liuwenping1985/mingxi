<%--
  Created by IntelliJ IDEA.
  User: wangh
  Date: 2017/1/5
  Time: 17:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>栏目分类主页</title>
</head>
<script type="text/javascript" src="${path}/common/form/bizDashboard/sectionTypeIndex.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
    var searchObj;
    $().ready(function() {
        var categoryArray = new Array();
        <c:forEach items="${categoryList}" var="item">
        categoryArray.push({
            text : "${ctp:toHTML(item.name)}".replace(/&nbsp;/g,""),
            value : "${item.id}"
        });
        </c:forEach>

        if (categoryArray.length == 0) {
            categoryArray.push({
                text : "",
                value : ""
            });
        }

        searchObj = $.searchCondition({
            top : 5,
            left : 10,
            searchHandler : function() {
                var rv = searchObj.g.getReturnValue();
                if (rv) {
                    sectionSearch($("#searchType").val(), rv.condition, rv.value,false);
                }
            },
            conditions : [ {
                id : "subject",
                name : "subject",
                type : "input",
                text : "${ctp:i18n('formsection.config.template.name')}",
                value : "subject"
            }, {
                id : "category",
                name : "category",
                type : "select",
                text : "${ctp:i18n('formsection.config.template.category')}",
                value : "categoryId",
                items : categoryArray
            } ]
        });

        if (${!CurrentUser.admin}) {
            if ("${sectionType.supportedSearchType}" == "1") {
                setTimeout('$("#admin").click()',100);
            }

            if ("${sectionType.supportedSearchType}" == "2") {
                setTimeout('$("#user").click()',100);
            }
        } else {
            sectionSearch('admin', '', '',true)
        }
    });
</script>
<body>
<div class="stadic_layout">
    <div class="stadic_left">
        <form id="searchForm" name="searchForm" method="post" action="${path}/form/bizDashboard.do?method=sectionDataTree&type=${ctp:toHTML(param.type)}" target="tree_iframe">
            <input type="hidden" id="searchType" name="searchType" value="" />
            <input type="hidden" id="condition" name="condition" value="" />
            <input type="hidden" id="textfield" name="textfield" value="" />
        </form>
        <table width="100%" <c:if test="${param.from eq 'setLink'}">height="360"</c:if> <c:if test="${param.from ne 'setLink'}">height="410"</c:if>  cellpadding="0" cellspacing="0" border="0">
            <tr>
                <td height="100%">
                    <table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
                        <!-- 如果是设置连接过来的时候，因为页面比较窄，所以查询条件和查询范围不放在一行，以免被遮住 -->
                        <c:if test="${param.from eq 'setLink'}">
                        <tr height="30">

                        </tr>
                        </c:if>
                        <tr>
                            <td height="36" align="right">
                            <c:if test="${!CurrentUser.admin}">
                                <c:if test="${sectionType.supportedSearchType eq '2'}">
                                    <label for="user" class="hand margin_l_10 font_size12">
                                        <input type="radio" id="user" name="templateOption" value="user" onclick="sectionSearch('user', '', '',true)" />
                                        <span class="margin_l_5">${ctp:i18n("bizconfig.create.my")}</span>
                                    </label>
                                </c:if>
                                <label for="admin" class="hand margin_l_10 font_size12" style="margin-right: 8px;">
                                    <input type="radio" id="admin" name="templateOption" value="admin" onclick="sectionSearch('admin', '', '',true)" />
                                    <span class="margin_l_5">${ctp:i18n("bizconfig.create.all")}</span>
                                </label>
                            </c:if>
                            </td>
                        </tr>
                        <tr>
                             <c:set value="${param.from eq 'setLink'?'320':'345'}" var="_height" />
                            <td id="tree_td" style="height: ${_height}px;" valign="top">
                                <div id="tree_div" style="width: 100%; height: ${_height}px; padding-top: 0px;">
                                    <iframe id="tree_iframe" width="100%" height="100%" frameborder="0" class="border_all" style="border-bottom: none;border-bottom-left:none;"></iframe>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
</div>
</body>
</html>
